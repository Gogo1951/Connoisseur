local _, ns = ...
local L = ns.L

--[[
    Read by the bank restock as a hard gate: C_Container.UseContainerItem SELLS
    while a merchant window is open, so anything that moves an item has to know.
]]
ns.merchantIsOpen = false

-- Restock throttle: the client can fire MERCHANT_SHOW more than once per visit.
local lastTimeRestocked = GetTime()

local function CountTableItems(theTable)
	if not theTable then
		return 0
	end

	local count = 0
	for _, _ in pairs(theTable) do
		count = count + 1
	end
	return count
end

--[[
    NOTE: this addon must NEVER sell at a merchant. Having too many of an item is fine and is
    left untouched. There is no sell path at all: only BuildPurchaseOrder (buy when too few).
]]

--------------------------------------------------------------------------------
-- Buy Extra
--------------------------------------------------------------------------------

--[[
    A normal order asks for the shortfall and stops there. An Extra row asks for
    whatever a LIMITED vendor slot is holding, however much of it the player
    already has: the scarce Classic consumables (Major Mana Potions and the like)
    sit behind a few-at-a-time slot that trickles back, so the useful behaviour is
    to clear the slot every time you walk past rather than to top up to a number.

    That means an Extra row needs an order even when the shortfall is zero, which
    is why the amount gate below is skipped for it. The order still carries the
    ordinary shortfall as its amount -- never a guess at what the vendor holds,
    which is unknown until PurchaseMerchantItem reads the slot -- so partial-fill
    reporting keeps working off the real target. An amount of 0 is a legitimate
    Extra order: nothing is owed, so anything bought fills it.

    Extra rides on top of Buy rather than beside it. Restock() already skips
    records with buyFromMerchant off before calling this, so an Extra row with Buy
    switched off never reaches here.
]]
local function BuildPurchaseOrder(purchaseOrders, eachRestockRecord, vendorReaction)
	--[[
	    Counted by itemID, the same key BuildGroceryList and the crafting order use,
	    so all three agree on what the bags hold. A name-keyed count reads 0 for a
	    saved line whose name never resolved, and the order then buys a full stack
	    of something the bags are already carrying.
	]]
	local haveInBag = GetItemCount(eachRestockRecord.itemID or eachRestockRecord.itemName, false, false) or 0
	local amount = eachRestockRecord.amount or 0
	local requiredReaction = eachRestockRecord.reaction or 0
	local buyExtra = eachRestockRecord.buyExtra == true

	--[[
	    A vendor below the item's required standing is skipped in silence:
	    announcing every gated item at every vendor would flood chat.
	]]
	if requiredReaction <= vendorReaction and (amount > 0 or buyExtra) then
		--[[
		    Clamped at zero: an already over-stocked Extra row owes nothing, and a
		    negative amount would run the chunked buy loop backwards below.
		]]
		local toBuy = math.max(0, amount - haveInBag)

		if toBuy > 0 or buyExtra then
			local purchaseOrder = purchaseOrders[eachRestockRecord.itemName]
			if not purchaseOrder then
				-- add new
				purchaseOrders[eachRestockRecord.itemName] = ns.NewPurchaseOrder(
					toBuy,
					eachRestockRecord.itemName,
					eachRestockRecord.itemID,
					eachRestockRecord.itemLink
				)
			else
				-- update amount, add more
				purchaseOrder.amount = purchaseOrder.amount + toBuy
			end

			--[[
			    Flagged on the ORDER, not re-read from the record later: orders are keyed
			    by item name and a crafting reagent can merge into this same entry, so
			    the buy loop needs the flag on the thing it actually holds.
			]]
			if buyExtra then
				purchaseOrders[eachRestockRecord.itemName].buyExtra = true
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Grocery List
--------------------------------------------------------------------------------

--[[
    What the current profile is short of right now: the same shortfall
    BuildPurchaseOrder computes, minus the vendor. Used by the mini-map tooltip
    and the entering-town reminder, both of which run while the player is
    standing in the open with no merchant window in sight.

    Two differences from a real purchase order, both because there is no vendor:
    the required-reputation gate is skipped (it depends on which vendor you walk
    up to), and crafting reagents are left out (ns.BuildCraftingPurchaseOrder
    resolves those against the merchant's stock). So this answers "what am I low on", which is
    what a shopping list is, rather than "what will this vendor sell me".

    Counts are bags only -- GetItemCount(id, false, false) -- matching what the
    merchant restock compares against, so the list agrees with what would
    actually be bought.
]]
function ns.BuildGroceryList()
	local settings = ns.restockSettings
	local profile = settings and settings.profiles and settings.profiles[settings.currentProfile]
	local list = {}
	if not profile then
		return list
	end

	for _, record in pairs(profile) do
		local wanted = record.amount or 0
		local key = record.itemID or record.itemName
		-- nil buyFromMerchant defaults to true, the same rule Restock() uses
		if key and wanted > 0 and (record.buyFromMerchant == nil or record.buyFromMerchant) then
			local have = GetItemCount(key, false, false) or 0
			local short = wanted - have
			if short > 0 then
				--[[
				    have/wanted ride along for the verbose town reminder, which reports
				    the ratio rather than the shortfall.
				]]
				list[#list + 1] = {
					itemID = record.itemID,
					itemName = record.itemName,
					have = have,
					wanted = wanted,
					needed = short,
				}
			end
		end
	end

	table.sort(list, function(a, b)
		return (a.itemName or "") < (b.itemName or "")
	end)
	return list
end

local function UpdatePurchaseOrdersWithCraftingReagents(purchaseOrders, ingredientName, toBuy)
	if not purchaseOrders[ingredientName] then
		purchaseOrders[ingredientName] = ns.NewPurchaseOrder(toBuy, ingredientName, nil, nil)
	else
		local purchase = purchaseOrders[ingredientName]
		purchase.amount = purchase.amount + toBuy
	end
end

--------------------------------------------------------------------------------
-- All or Nothing Reagents
--------------------------------------------------------------------------------

--[[
    Crafting reagents (rogue poison ingredients) are bought only at a vendor
    that stocks EVERY reagent the crafting order still needs. Half a recipe is
    worse than none: a trade-goods vendor carrying Crystal Vials but no Dust of
    Deterioration would fill the bags with vials that cannot become poisons until
    some other vendor supplies the rest. A poison supplier carries the full set,
    so this gate simply keeps the reagent buying at poison suppliers.

    "Needs" means an amount still to buy after bags were counted -- a reagent
    the bags already cover is not required of the vendor, so dust-only is fine
    when the vials are in the bags. "Stocks" means the slot is purchasable
    right now: unlimited (-1) or a limited count above zero. A sold-out
    limited slot counts as NOT stocked -- buying the others would strand the
    player exactly the way this rule forbids.

    Quantity coverage is deliberately not required: a limited slot holding 4
    of the 6 dust wanted still crafts 4 poisons, and the chunked buy loop
    already caps to vendor stock. The rule is about missing reagent TYPES.

    This gate covers the crafting order only. An item the player put on the
    Restock List directly (vials included) is their explicit ask and buys
    exactly as before.
]]
local function VendorStocksAllReagents(craftingPurchaseOrder)
	local needed = {}
	local neededCount = 0
	for reagentName, amount in pairs(craftingPurchaseOrder) do
		if amount > 0 then
			needed[reagentName] = true
			neededCount = neededCount + 1
		end
	end

	-- Nothing left to buy: the gate passes and no reagent line is at stake.
	if neededCount == 0 then
		return true, false
	end

	local stockedCount = 0
	for i = 1, GetMerchantNumItems() do
		local itemName, _, _, _, numAvailable = GetMerchantItemInfo(i)
		if itemName and needed[itemName] and (numAvailable == -1 or numAvailable > 0) then
			needed[itemName] = nil -- count each reagent once, however many slots carry it
			stockedCount = stockedCount + 1
			if stockedCount == neededCount then
				return true, true
			end
		end
	end

	return false, stockedCount > 0
end

--[[
    Buys one merchant slot if it is on the purchase order, and returns how many
    UNITS were ordered plus whether that covered the whole order.

    Count UNITS, never BuyMerchantItem calls: forty juice bought in stacks of
    twenty is two calls, and "2" is not a number any player can interpret.

    The second return is what the caller turns into "3 restocking orders filled".
    A vendor holding six of a requested twenty leaves that order short, and the
    chat line may not say otherwise, so the claim is decided here rather than
    inferred from a unit count: this is the only place that still knows what the
    order asked for and what the vendor actually had. Bag counts cannot settle it
    either way -- they do not update until BAG_UPDATE, well after this returns.

    Fulfilled orders are flagged rather than removed, so the caller can tell what
    this vendor did not stock without re-reading those bag counts.
]]
local function PurchaseMerchantItem(i, purchaseOrders)
	local itemName, _, _, _, merchantAvailable, _, _ = GetMerchantItemInfo(i)
	local itemLink = GetMerchantItemLink(i)

	local buyItem = purchaseOrders[itemName]
	local unitsOrdered = 0
	local orderFilled = false

	if buyItem then
		--[[
		    Link and cached record are both missing until the client resolves the item, so fall
		    back to single-unit buys, which BuyMerchantItem accepts for anything.
		]]
		local itemInfo = itemLink and ns.GetItemData(itemLink)
		local stackCount = itemInfo and itemInfo.itemStackCount or 1
		if stackCount < 1 then
			stackCount = 1
		end

		--[[
		    HOW MUCH TO ASK FOR

		    BuyMerchantItem will not sell more than one stack per call, which is what
		    the stackCount loop below is for. Capping against the vendor's stock used
		    to bypass that loop and pass merchantAvailable through in a single call,
		    so a limited slot holding more than one stack -- a poison supplier's
		    reagents, exactly the case this path exists for -- had its call rejected
		    and still credited the full amount, reporting an order filled that never
		    arrived. Settling the target first lets one chunked loop serve every case.

		    A positive numAvailable is a LIMITED slot: a fixed few units that trickle
		    back over time. Unlimited stock reports -1 and sold out reports 0, so that
		    is the only reading either rule below can act on.

		    Ordinary orders cap DOWN to what the slot holds. An Extra order takes the
		    slot's whole count instead, up or down: that is the feature, buying past
		    the target amount when the vendor holds more than is owed, and buying at
		    all when nothing is owed. Unlimited slots fall through untouched by
		    design -- "buy every one they have" has no end on a slot that never runs
		    out, so Extra deliberately does nothing there.
		]]
		local wanted = buyItem.amount
		if merchantAvailable > 0 then
			if buyItem.buyExtra then
				wanted = merchantAvailable
			elseif wanted > merchantAvailable then
				wanted = merchantAvailable
			end
		end

		--[[
		    A sold-out slot reports numAvailable 0; unlimited stock reports -1, which
		    is why the cap above tests for a POSITIVE count. Nothing can be bought
		    from an empty slot, so the loop is skipped rather than run into a server
		    that rejects every call -- and skipping it leaves unitsOrdered at 0, which
		    is what stops a slot that gave us nothing from announcing a partial fill.
		]]
		if merchantAvailable ~= 0 then
			for n = wanted, 1, -stackCount do
				local chunk = (n > stackCount) and stackCount or n
				BuyMerchantItem(i, chunk)
				unitsOrdered = unitsOrdered + chunk
			end
		end

		--[[
		    The > 0 half matters for a zero-amount order, which both the
		    crafting-reagent path and a fully stocked Extra row can create: nothing
		    bought must never read as an order filled. An Extra row that did clear a
		    slot passes on the same test, since anything at all covers a zero target.
		]]
		orderFilled = unitsOrdered > 0 and unitsOrdered >= buyItem.amount

		buyItem.purchased = true
	end

	return unitsOrdered, orderFilled
end

--[[
    One vendor's worth of an item to buy. Transient: a purchase order lives for
    the length of one merchant visit and is never saved, which is why itemLink can
    be carried here when the profile row that produced it does not store one.
]]
function ns.NewPurchaseOrder(amount, itemName, itemID, itemLink)
	return {
		amount = amount,
		itemName = itemName,
		itemID = itemID or 0,
		itemLink = itemLink or "",
	}
end

function ns.RestockFromMerchant()
	local settings = ns.restockSettings
	if CountTableItems(settings.profiles[settings.currentProfile]) == 0 then
		return
	end

	if GetTime() - lastTimeRestocked < 1 then
		return
	end

	lastTimeRestocked = GetTime()

	--[[
	    Don't try to buy anything when the bags have no free slot -- the purchase would just
	    fail with "Inventory is full". (The bank restock already bails on full bags via
	    ns.GetRestockSpace.)
	]]
	if not ns.HasFreeBagSlot(ns.RESTOCK_PLAYER_BAGS) then
		ns.PrintMessage(L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"])
		return
	end

	if settings.autoOpenAtMerchant then
		ns.ShowRestockWindow()
	end

	local craftingPurchaseOrder = ns.BuildCraftingPurchaseOrder() or {}

	--[[
	    All-or-nothing (see VendorStocksAllReagents above): a vendor missing any
	    needed reagent buys NO reagents. The print fires only when this vendor
	    stocked some of them, which is the case worth reporting, and stays silent
	    at vendors that stock none, where a skipped reagent order is not news.
	]]
	local allReagentsStocked, anyReagentStocked = VendorStocksAllReagents(craftingPurchaseOrder)
	if not allReagentsStocked then
		if anyReagentStocked then
			ns.PrintMessage(L["RESTOCKER_REAGENTS_SKIPPED"])
		end
		craftingPurchaseOrder = {}
	end

	local purchaseOrders = {}
	local restockList = settings.profiles[settings.currentProfile]
	-- "npc" is the unit we are actually interacting with; the vendor is usually not targeted.
	local vendorReaction = UnitReaction("npc", "player") or UnitReaction("target", "player") or 0

	-- Build the Purchase Orders table used for buying items
	for _, eachRestockRecord in pairs(restockList) do
		if eachRestockRecord.buyFromMerchant or eachRestockRecord.buyFromMerchant == nil then -- nil defaults to true
			BuildPurchaseOrder(purchaseOrders, eachRestockRecord, vendorReaction)
		end
	end

	-- Insert craft reagents for missing items into purchase orders, or add
	for ingredientName, toBuy in pairs(craftingPurchaseOrder) do
		UpdatePurchaseOrdersWithCraftingReagents(purchaseOrders, ingredientName, toBuy)
	end

	-- Loop through vendor items
	local ordersFilled = 0
	local ordersPartlyFilled = 0
	for i = 1, GetMerchantNumItems() do
		if not ns.restockBuying then
			return
		end

		local unitsOrdered, orderFilled = PurchaseMerchantItem(i, purchaseOrders)
		if orderFilled then
			ordersFilled = ordersFilled + 1
		elseif unitsOrdered > 0 then
			ordersPartlyFilled = ordersPartlyFilled + 1
		end
	end

	--[[
	    Report what happened, and nothing more. Anything this vendor did not stock
	    is still outstanding, but the mini-map's Restocker Report already says so --
	    the chat line covers the event, the tooltip covers the outstanding state,
	    and neither repeats the other.

	    Filled and partly filled are counted apart and printed apart, so a mixed run
	    needs no combined string and a clean one never mentions partials. Both are
	    silent at zero, which keeps a vendor that stocked nothing on our list quiet.
	]]
	if ordersFilled == 1 then
		ns.PrintMessage(L["RESTOCKER_RESTOCKED_ONE"])
	elseif ordersFilled > 1 then
		ns.PrintMessage(string.format(L["RESTOCKER_RESTOCKED_MANY"], ordersFilled))
	end

	if ordersPartlyFilled == 1 then
		ns.PrintMessage(L["RESTOCKER_RESTOCKED_PARTIAL_ONE"])
	elseif ordersPartlyFilled > 1 then
		ns.PrintMessage(string.format(L["RESTOCKER_RESTOCKED_PARTIAL_MANY"], ordersPartlyFilled))
	end
end
