local _, ns = ...

--[[
    The player's own bags, read by the merchant restock to refuse a purchase with
    nowhere to put it. The bank orderings below are only ever walked in here.
]]
ns.RESTOCK_PLAYER_BAGS = {}

local BagDefinition = {}
BagDefinition.__index = BagDefinition

local BANK_BAGS = {} -- filled by ns.InitRestockBagDefinitions
local BANK_BAGS_REVERSED = {} -- filled by ns.InitRestockBagDefinitions

--------------------------------------------------------------------------------
-- Bag Definitions
--------------------------------------------------------------------------------

--[[
    A container the restocker moves items through. `location` is a label for the debug
    log only -- every container is filled the same way, by naming an empty slot (see
    BagDefinition:PutCursorItem). No inventory-slot id is kept: the only thing one was
    ever used for was PutItemInBag, which is the API this file must not go back to.
]]
local function NewBagDefinition(location, bagID)
	local result = {}
	result.location = location
	result.bagID = bagID
	setmetatable(result, BagDefinition)
	return result
end

local function CreateBackpack()
	return NewBagDefinition("backpack", BACKPACK_CONTAINER)
end

local function CreateBag(bag)
	return NewBagDefinition("bag", bag)
end

local function CreateBankMainBag()
	return NewBagDefinition("bank", BANK_CONTAINER)
end

local function CreateBankBag(bag)
	-- Bank bags are 5..11, offset past the player's own bag ids by NUM_BAG_SLOTS.
	return NewBagDefinition("bank", bag + NUM_BAG_SLOTS)
end

function ns.InitRestockBagDefinitions()
	BANK_BAGS = {
		CreateBankMainBag(),
		CreateBankBag(1),
		CreateBankBag(2),
		CreateBankBag(3),
		CreateBankBag(4),
		CreateBankBag(5),
		CreateBankBag(6),
		CreateBankBag(7),
	}
	BANK_BAGS_REVERSED = {
		CreateBankBag(7),
		CreateBankBag(6),
		CreateBankBag(5),
		CreateBankBag(4),
		CreateBankBag(3),
		CreateBankBag(2),
		CreateBankBag(1),
		CreateBankMainBag(),
	}

	ns.RESTOCK_PLAYER_BAGS = { CreateBackpack(), CreateBag(1), CreateBag(2), CreateBag(3), CreateBag(4) }
end

function BagDefinition:NumSlots()
	return C_Container.GetContainerNumSlots(self.bagID)
end

function BagDefinition:HasSpace()
	local numberOfFreeSlots = C_Container.GetContainerNumFreeSlots(self.bagID)
	return numberOfFreeSlots > 0
end

--[[
    True if this container has a free slot AND is allowed to hold the given item. A free-slot
    count alone is not enough: a specialty bag (quiver, soul/herb/enchanting bag) reports free
    slots that a regular item can never occupy.

    This is now a shortcut rather than the safety net it once was. Placement names the slot
    itself, so a container that refuses the item leaves it on the cursor and the caller simply
    tries the next one; skipping the bags that were never going to take it just saves the trip.
]]
function BagDefinition:CanAcceptItem(itemInfo)
	local numberOfFreeSlots, bagType = C_Container.GetContainerNumFreeSlots(self.bagID)
	if numberOfFreeSlots <= 0 then
		return false
	end
	if not bagType or bagType == 0 then
		return true -- regular container takes anything
	end
	if not itemInfo then
		return false -- unknown item: only trust regular containers
	end
	if itemInfo.itemEquipLoc == "INVTYPE_BAG" then
		return false -- equippable bags can only be stored in regular containers
	end
	local itemFamily = GetItemFamily(itemInfo.itemID)
	return itemFamily ~= nil and itemFamily ~= 0 and bit.band(itemFamily, bagType) ~= 0
end

--[[
    Attempt to drop the cursor item into this container. May leave the item on the cursor if
    the container has no usable slot (the caller checks CursorHasItem() and moves on) -- it
    must NOT clear the cursor itself, or the item would be lost before another bag is tried.
]]
--[[
    Drop into the first genuinely-empty slot of this container, naming the slot
    ourselves. Detect empty with GetContainerItemInfo -- it returns nil ONLY when the
    slot is truly empty, whereas GetContainerItemLink is also nil for a not-yet-cached
    item, which made us "place" onto an occupied slot and strand the item.

    EVERY container goes through this, player bags included. The two APIs that let the
    SERVER pick the slot -- PutItemInBackpack and PutItemInBag(invslot) -- clear the
    cursor the moment they are called, whether or not the drop is accepted. That makes
    the caller's "did it land?" test (CursorHasItem) answer "yes" even when the server
    refused and bounced the item back to its source, so the caller stops early, never
    tries the remaining bags, and the re-scan finds the item still missing. Naming the
    slot keeps the item on the cursor on a refusal, which is what makes that test true.
    See the sibling note on ns.MoveRestockItemFromBank's `overshoot` escape hatch, which
    exists to paper over exactly this.
]]
function BagDefinition:PutCursorItem()
	for slot = 1, C_Container.GetContainerNumSlots(self.bagID) do
		if not C_Container.GetContainerItemInfo(self.bagID, slot) then
			ns.RestockerDebug("PutCursorItem(%s) bag=%s slot=%s", self.location, self.bagID, slot)
			C_Container.PickupContainerItem(self.bagID, slot)
			return
		end
	end

	--[[
	    No empty slot, so nothing was attempted and the cursor still holds the item --
	    deliberately, so the caller can try the next bag. Never ClearCursor here.
	]]
	ns.RestockerDebug("PutCursorItem(%s) bag=%s -- no empty slot", self.location, self.bagID)
end

--------------------------------------------------------------------------------
-- Scanning
--------------------------------------------------------------------------------

--[[
    True if any slot we care about is still mid-move (locked). A locked slot means the last
    move hasn't settled on the server yet -- issuing the next one now is exactly what gets a
    split rejected with "Couldn't split those items".

    `profile` narrows "we care about" to the items on the current list. Only OUR items may
    stall a restock: an unrelated locked item, something
    the player is equipping or a pending trade, would otherwise hold it up forever.
]]
function ns.IsRestockItemLocked(profile)
	local function anyLocked(bags)
		for _, bag in ipairs(bags) do
			for slot = 1, C_Container.GetContainerNumSlots(bag.bagID) do
				local itemInfo = C_Container.GetContainerItemInfo(bag.bagID, slot)
				if
					itemInfo
					and itemInfo.isLocked
					and (profile == nil or (itemInfo.itemID and profile[itemInfo.itemID] ~= nil))
				then
					return true
				end
			end
		end
		return false
	end

	return anyLocked(ns.RESTOCK_PLAYER_BAGS) or anyLocked(BANK_BAGS_REVERSED)
end

function ns.GetRestockItemsInBags(predicate)
	local result = ns.NewRestockInventory()

	for _, bag in ipairs(ns.RESTOCK_PLAYER_BAGS) do
		for slot = 1, C_Container.GetContainerNumSlots(bag.bagID) do
			local itemInfo = C_Container.GetContainerItemInfo(bag.bagID, slot)

			-- Keyed by itemID: unambiguous, locale-proof, and matches the profile's keys
			if itemInfo and itemInfo.itemID then
				local id = itemInfo.itemID

				-- Allow filtering by predicate
				if predicate == nil or predicate(id) == true then
					result.summary[id] = (result.summary[id] or 0) + itemInfo.stackCount

					result.slots[id] = result.slots[id] or {}
					table.insert(result.slots[id], ns.NewRestockInventorySlot(bag.bagID, slot, itemInfo.stackCount))
				end
			end
		end
	end

	result:SortSlots()
	return result
end

function ns.GetRestockItemsInBank(predicate)
	local result = ns.NewRestockInventory()

	for _, bag in ipairs(BANK_BAGS_REVERSED) do
		for slot = 1, C_Container.GetContainerNumSlots(bag.bagID) do
			local itemInfo = C_Container.GetContainerItemInfo(bag.bagID, slot)
			-- Keyed by itemID (no hyperlink/name parsing needed)
			if itemInfo and itemInfo.itemID then
				local id = itemInfo.itemID

				-- Allow filtering by predicate
				if predicate == nil or predicate(id) == true then
					result.summary[id] = (result.summary[id] or 0) + itemInfo.stackCount

					result.slots[id] = result.slots[id] or {}
					table.insert(result.slots[id], ns.NewRestockInventorySlot(bag.bagID, slot, itemInfo.stackCount))
				end
			end
		end
	end

	result:SortSlots()
	return result
end

-- Takes cursor item. Drops it into the bank, preferring a free slot.
local function PutItemInBank(bankInventory, itemInfo, amount)
	if not CursorHasItem() then
		return false
	end

	--[[
	    Drop into a FREE slot first -- that is the reliable move. Only stop once it has ACTUALLY
	    landed: a container's free-slot COUNT can disagree with its per-slot contents
	    -- notably the main bank container reports free slots the slot scan can't find -- so a
	    bag may claim room yet fail to take the item. Keep trying the rest, don't give up after
	    the first (which stranded the item on the cursor).
	]]
	for _, bag in ipairs(BANK_BAGS) do
		if bag:CanAcceptItem(itemInfo) then
			bag:PutCursorItem()
			if not CursorHasItem() then
				break -- landed
			end
		end
	end

	--[[
	    No free slot took it (bank effectively full). LAST resort: merge into the best partial
	    stack. We AVOID doing this first because merging a just-split cursor item onto an
	    occupied same-item slot can be rejected and BOUNCE the item back to its source, emptying
	    the cursor without it ever landing (that's what left "9 need 10" stuck). When the bank
	    is full it's the only chance to land the item; if it still bounces, the next re-scan and
	    the watchdog report it honestly.
	]]
	if CursorHasItem() and itemInfo then
		local bestFit = bankInventory:FindBestFit(itemInfo, amount)
		if bestFit then
			C_Container.PickupContainerItem(bestFit.bag, bestFit.slot)
		end
	end

	--[[
	    CRITICAL: never leave an item stranded on the cursor. A stranded item is what makes
	    the NEXT SplitContainerItem throw "Couldn't split those items".
	]]
	if CursorHasItem() then
		ns.RestockerDebug("PutItemInBank: no room to drop, clearing cursor")
		ClearCursor()
		return false
	end

	return true
end

-- Takes cursor item. Drops it into the player bags, preferring a free slot.
local function PutItemInPlayerBag(playerInventory, itemInfo, amount)
	if not CursorHasItem() then
		return false
	end

	--[[
	    Drop into a FREE slot first -- reliable. Keep trying bags until it actually lands
	    (a bag can claim room it won't grant this item), don't give up after the first.
	]]
	for _, bag in ipairs(ns.RESTOCK_PLAYER_BAGS) do
		if bag:CanAcceptItem(itemInfo) then
			bag:PutCursorItem()
			if not CursorHasItem() then
				break -- landed
			end
		end
	end

	--[[
	    No free slot took it (bags effectively full). LAST resort: merge into the best partial
	    stack. We AVOID doing this first because merging a just-split cursor item onto an
	    occupied same-item slot can be rejected and BOUNCE the item back to the bank, emptying
	    the cursor without it ever landing -- exactly what left the final unit stuck at "9 need
	    10". When bags are full it's the only way to top off a stack; a bounce is caught by the
	    next re-scan and the watchdog.
	]]
	if CursorHasItem() and itemInfo then
		local bestFit = playerInventory:FindBestFit(itemInfo, amount)
		if bestFit then
			C_Container.PickupContainerItem(bestFit.bag, bestFit.slot)
		end
	end

	--[[
	    CRITICAL: never leave an item stranded on the cursor. A stranded item is what makes
	    the NEXT SplitContainerItem throw "Couldn't split those items".
	]]
	if CursorHasItem() then
		ns.RestockerDebug("PutItemInPlayerBag: no room to drop, clearing cursor")
		ClearCursor()
		return false
	end

	return true
end

function ns.HasFreeBagSlot(bags)
	for _, bag in ipairs(bags) do
		local numberOfFreeSlots = C_Container.GetContainerNumFreeSlots(bag.bagID)
		if numberOfFreeSlots > 0 then
			return true
		end
	end
	return false
end

-- From bags list, retrieve items which are not locked and match predicate
local function ScanBagsFor(bags, predicate)
	local itemCandidates = {}

	for _, bag in ipairs(bags) do
		for slot = 1, C_Container.GetContainerNumSlots(bag.bagID), 1 do
			local containerItemInfo = ns.GetRestockContainerItemInfo(bag.bagID, slot)
			if containerItemInfo then
				if (containerItemInfo).locked then
					return {} -- can't do nothing now, something is locked, try in 0.1 sec
				end

				if predicate(containerItemInfo) then
					table.insert(itemCandidates, containerItemInfo)
				end
			end
		end
	end

	return itemCandidates
end

--------------------------------------------------------------------------------
-- Moving Items
--------------------------------------------------------------------------------

--[[
    Filter function for ScanBagsFor, matching a specific itemID (locale-proof, and never
    confuses two different items that share a localized name).
]]
local function ContainerItemInfoMatchID(id)
	return function(itemInfo)
		return itemInfo.itemID == id
	end
end

--[[
    Issue at most one bank->bag move from the given candidates. No plan bookkeeping is
    deducted here on purpose: the caller re-scans real inventory next step, so a move that
    the server rejected or only partially placed simply shows up as "still short" and is
    retried -- rather than being counted as done (which silently left items short).

    `overshoot` is the escape hatch for a split that keeps being rejected
    ("Couldn't split those items") -- pull a WHOLE stack instead and go over
    target. UseContainerItem is the one move the server never bounces; overshooting past the
    target is what guarantees it gets reached, and the stash-back pass returns the excess for
    items that stash to bank. Going a little over beats stopping short.
]]
local function MoveOneStackBankToPlayer(playerInventory, candidates, moveAmount, overshoot)
	for _, moveCandidate in ipairs(candidates) do
		-- A whole stack that fits within what we still need
		if moveCandidate.count <= moveAmount then
			ns.RestockerDebug(
				"Use %s from bank, bag=%s, slot=%s",
				moveCandidate.name,
				moveCandidate.bag,
				moveCandidate.slot
			)
			C_Container.UseContainerItem(moveCandidate.bag, moveCandidate.slot, nil, nil)
			return true -- issued one move; next step re-scans and continues
		end

		-- Stack is bigger than the remainder: split off exactly what's left to do
		if moveCandidate.count > moveAmount then
			if overshoot then
				ns.RestockerDebug(
					"Overshoot %s from bank (split not landing), bag=%s, slot=%s",
					moveCandidate.name,
					moveCandidate.bag,
					moveCandidate.slot
				)
				C_Container.UseContainerItem(moveCandidate.bag, moveCandidate.slot, nil, nil)
				return true -- issued one move; next step re-scans and continues
			end

			local itemInfo = ns.GetItemData(moveCandidate.itemID)
			ns.RestockerDebug(
				"Split %s from bank, bag=%s, slot=%s",
				moveCandidate.name,
				moveCandidate.bag,
				moveCandidate.slot
			)
			C_Container.SplitContainerItem(moveCandidate.bag, moveCandidate.slot, moveAmount)
			PutItemInPlayerBag(playerInventory, itemInfo, moveAmount)
			return true -- issued one move; next step re-scans and continues
		end
	end

	return false
end

function ns.MoveRestockItemFromBank(playerInventory, moveItemID, moveAmount, overshoot)
	--[[
	    Bank bags in reverse: the deepest bag is emptied first, so the main bank
	    container keeps the free slots a later stash-back needs.
	]]
	for _, bag in ipairs(BANK_BAGS_REVERSED) do
		-- Build list of move candidates (matched by itemID), smallest stacks first
		local moveCandidates = ScanBagsFor({ bag }, ContainerItemInfoMatchID(moveItemID))
		table.sort(moveCandidates, ns.CompareByStackSizeAscending)

		if MoveOneStackBankToPlayer(playerInventory, moveCandidates, moveAmount, overshoot) then
			return true
		end
	end

	return false -- did not move
end

--[[
    Issue at most one bag->bank move. As with ns.MoveRestockItemFromBank, nothing is deducted --
    the next step's re-scan reflects what actually moved.
]]
local function MoveOneStackPlayerToBank(bankInventory, candidates, moveAmount)
	for _, containerItemInfo in ipairs(candidates) do
		-- Found something to move and its smaller than what we need to move
		if containerItemInfo.count <= moveAmount then
			C_Container.UseContainerItem(containerItemInfo.bag, containerItemInfo.slot, nil, nil)
			return true -- issued one move; next step re-scans and continues
		end

		-- Found something to move, but its bigger than how many we need to move
		if containerItemInfo.count > moveAmount then
			-- May be nil if the item isn't cached; PutItemInBank then drops it in a free slot
			local itemInfo = ns.GetItemData(containerItemInfo.itemID)

			C_Container.SplitContainerItem(containerItemInfo.bag, containerItemInfo.slot, moveAmount)
			PutItemInBank(bankInventory, itemInfo, moveAmount)
			return true -- issued one move; next step re-scans and continues
		end
	end

	return false
end

function ns.MoveRestockItemToBank(bankInventory, moveItemID, moveAmount)
	--[[
	    Candidates come from ALL player bags at once, sorted smallest stack first GLOBALLY.
	    Scanning bag-by-bag made an early bag's big stack get SPLIT (the flaky cursor move)
	    even when a later bag held a loose stack of exactly the excess that a whole-stack
	    UseContainerItem -- the reliable, server-side deposit -- could have moved instead.
	]]
	local moveCandidates = ScanBagsFor(ns.RESTOCK_PLAYER_BAGS, ContainerItemInfoMatchID(moveItemID))

	table.sort(moveCandidates, ns.CompareByStackSizeAscending)

	return MoveOneStackPlayerToBank(bankInventory, moveCandidates, moveAmount)
end

--[[
    Where a restock still has room, as (bags, bank). The caller decides what an
    answer means; this only reports it.
]]
function ns.GetRestockSpace()
	return ns.HasFreeBagSlot(ns.RESTOCK_PLAYER_BAGS), ns.HasFreeBagSlot(BANK_BAGS)
end

function ns.GetRestockContainerItemInfo(bagID, slot)
	local itemInfo = C_Container.GetContainerItemInfo(bagID, slot)
	--[[
	    hyperlink can be nil for a not-yet-cached item; skip the slot rather than erroring
	    on string.match(nil, ...). Matching is done by itemID, so a skipped slot is harmless.
	]]
	if not itemInfo or not itemInfo.hyperlink then
		return nil
	end
	local itemName = string.match(itemInfo.hyperlink, "%[(.*)%]")

	return {
		bag = bagID,
		slot = slot,
		icon = itemInfo.iconFileID,
		count = itemInfo.stackCount,
		locked = itemInfo.isLocked,
		link = itemInfo.hyperlink,
		itemID = itemInfo.itemID,
		name = itemName,
	}
end

function ns.CompareByStackSizeAscending(a, b)
	return a.count < b.count
end
