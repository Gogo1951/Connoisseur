local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Consumable Upgrades
--------------------------------------------------------------------------------

--[[
    Keeps staple consumables on the Restock List current with the player's
    level, walking the ladders in Data/Consumable-Upgrade-Paths.lua.

    Only ever forward. An item ABOVE the player's level is left alone -- someone
    who stocked Morning Glory Dew at 30 meant to, and gets moved on only once
    they outgrow it -- so the rule is "a strictly later tier", never "the tier
    matching my level".
]]

-- The client's expansion, as the ladder's flag (Features/Utilities.lua).
local CURRENT_EXPANSION = ns.CURRENT_EXPANSION

-- [itemID] = { chain = <chain>, tier = <index into chain.tiers> }
local upgradeIndex = {}
for _, chain in ipairs(ns.FoodUpgradeChains or {}) do
	for tierIndex, tier in ipairs(chain.tiers) do
		upgradeIndex[tier[2]] = { chain = chain, tier = tierIndex }
	end
end

--[[
    Is this item on a ladder at all? Everything else shows a disabled Upgrade
    button -- most of a real Restock List is potions, bandages and reagents.
]]
function ns.CanUpgradeRestockItem(itemID)
	return itemID ~= nil and upgradeIndex[itemID] ~= nil
end

--[[
    The furthest tier this character can reach right now.

    Walks the whole chain and keeps the LAST acceptable tier rather than
    returning the first miss: tiers are ordered by level then expansion, so where
    two share a level (65 in every food chain) this lands on the one matching the
    client -- TBC stops at the Outland item, Wrath carries on to the Northrend one.

    A tier's optional fourth field is the LAST expansion it exists in --
    Blinding Powder left the game after Classic, so its tier reads
    { 34, 6510, CLASSIC, CLASSIC } and a TBC client refuses it here the same
    way an Era client refuses a TBC tier.
]]
local function BestTier(chain, level)
	local best
	for tierIndex, tier in ipairs(chain.tiers) do
		if tier[1] <= level and tier[3] <= CURRENT_EXPANSION and (tier[4] == nil or CURRENT_EXPANSION <= tier[4]) then
			best = tierIndex
		end
	end
	return best
end

--[[
    The item a ladder yields for this character right now: the furthest tier at
    or below the level, on this client. The Starter List popup (Restocker-Starter-List.lua)
    adds through this, so a ticked staple starts on the same tier the upgrader
    would otherwise move it to.
]]
function ns.BestChainItemID(chain, level)
	local tierIndex = BestTier(chain, level)
	if tierIndex == nil then
		return nil
	end
	return chain.tiers[tierIndex][2]
end

--[[
    Move one list entry onto a later tier, keeping everything the player set on
    it -- amount, the three toggles, required reputation, and the Upgrade flag
    itself. Profiles are keyed by itemID, so this is a delete plus an insert.

    When the target tier is ALREADY on the list the two entries merge: the
    amounts add up and the old row goes. Anything else would either drop what
    the player asked for or leave two rows for the same shopping trip.
]]
local function MoveToTier(profile, fromID, toID)
	local item = profile[fromID]
	local existing = profile[toID]

	if existing then
		existing.amount = (existing.amount or 0) + (item.amount or 0)
	else
		local info = ns.GetItemData(toID)
		item.itemID = toID
		item.itemName = info and info.itemName or ""
		item.itemType = (info and info.itemType) or item.itemType
		item.itemLink = nil
		profile[toID] = item
	end

	profile[fromID] = nil
end

--[[
    True when an upgrade was deferred because the client had not resolved the
    target item yet. GetItemInfo asks the server on a miss, so the retry rides
    on GET_ITEM_INFO_RECEIVED (Restocker-List.lua) rather than a timer.
]]
local pendingUpgrade = false

--[[
    Bring every eligible entry on the current Restock List up to date.
    Safe to call repeatedly: it is a no-op once nothing is behind.

    PLAYER_LEVEL_UP passes its new level straight through, because
    UnitLevel("player") still reads the OLD level while that event is being
    handled -- the unit field updates a moment later. Reading it there cost a
    whole level: the ding to 45 planned against 44, found no strictly later
    tier, and left the list on its level-35 water permanently, since nothing
    re-checked afterwards. Callers that run clear of the ding -- the deferred
    retry, the login catch-up -- pass nothing and read the level themselves.
]]
function ns.UpgradeRestockList(newLevel)
	local settings = ns.restockSettings
	local profile = settings and settings.profiles and settings.profiles[settings.currentProfile]
	if not profile then
		return
	end

	local level = newLevel or UnitLevel("player") or 1
	pendingUpgrade = false

	--[[
	    Collected before anything moves: MoveToTier both inserts and deletes
	    keys, and mutating a table while pairs() walks it is undefined.
	]]
	local planned = {}
	for itemID, item in pairs(profile) do
		-- nil means on, matching how buyFromMerchant reads its default
		if item.upgrade ~= false then
			local entry = upgradeIndex[itemID]
			if entry then
				local best = BestTier(entry.chain, level)
				if best and best > entry.tier then
					local targetID = entry.chain.tiers[best][2]
					if ns.GetItemData(targetID) then
						planned[#planned + 1] = { from = itemID, to = targetID }
					else
						--[[
						    Target not cached. Skipping now and retrying on
						    GET_ITEM_INFO_RECEIVED keeps a half-named row out of
						    the list entirely -- the alternative is writing the
						    old item's name against the new item's ID.
						]]
						pendingUpgrade = true
						ns.SyncRestockItemInfoSubscription()
					end
				end
			end
		end
	end

	if #planned == 0 then
		return
	end

	--[[
	    Headline first, then one line per swap naming both tiers and their
	    amounts. Naming what changed beats counting it: the add-on just rewrote
	    a shopping list, and "2 items upgraded" does not say which two. The
	    headline makes the Restock List the subject, so there is no item plural
	    to agree with and one string covers any number of swaps.

	    The outgoing amount is read BEFORE MoveToTier and the incoming one
	    after, because the two differ whenever the target tier was already on
	    the list: that path merges the rows and sums the amounts rather than
	    carrying the old one across.
	]]
	ns.PrintMessage(L["RESTOCKER_UPGRADED"])
	for _, move in ipairs(planned) do
		local from = profile[move.from]
		local fromLink = ns.GetItemHyperlink(move.from, from and from.itemName)
		local fromAmount = (from and from.amount) or 0
		MoveToTier(profile, move.from, move.to)
		local moved = profile[move.to]
		ns.PrintMessage(
			string.format(
				L["RESTOCKER_UPGRADED_ITEM"],
				fromLink,
				fromAmount,
				ns.GetItemHyperlink(move.to, moved and moved.itemName),
				(moved and moved.amount) or fromAmount
			)
		)
	end

	ns.UpdateRestockList()
end

function ns.HasPendingUpgrade()
	return pendingUpgrade
end
