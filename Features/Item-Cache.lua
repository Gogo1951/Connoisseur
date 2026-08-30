local _, ns = ...

--[[
    Item-Cache -- derives and caches per-item consumable data in
    ns.db.profile.itemCache (the stateful item-metadata layer) and answers
    whether an item is a known consumable.
]]

--------------------------------------------------------------------------------
-- Raw Data Safety Init
--------------------------------------------------------------------------------

--[[
    Defensive in case a Data/*.lua file fails to load. Scanner modules read
    ns.RawData tables and must never index nil.
]]
ns.RawData = ns.RawData or {}
ns.RawData.Bandage = ns.RawData.Bandage or {}
ns.RawData.FoodAndWater = ns.RawData.FoodAndWater or {}
ns.RawData.Healthstone = ns.RawData.Healthstone or {}
ns.RawData.Soulstone = ns.RawData.Soulstone or {}
ns.RawData.ManaGem = ns.RawData.ManaGem or {}
ns.RawData.Potions = ns.RawData.Potions or {}
ns.RawData.Explosives = ns.RawData.Explosives or {}

--------------------------------------------------------------------------------
-- Item Cache
--------------------------------------------------------------------------------

function ns.IsKnownConsumable(itemID)
	local cache = ns.db and ns.db.profile.itemCache
	if cache and cache[itemID] and cache[itemID] ~= "IGNORE" then
		return true
	end
	if ns.ScrollItemLookup and ns.ScrollItemLookup[itemID] then
		return true
	end
	--[[
	    Pet-only foods (Kibler's Bits and kin) are consumables the Feed Pet
	    macro selects from, even though no RawData table carries them.
	]]
	if ns.PetFoodData and ns.PetFoodData[itemID] then
		return true
	end
	return ns.RawData.FoodAndWater[itemID] ~= nil
		or ns.RawData.Potions[itemID] ~= nil
		or ns.RawData.Healthstone[itemID] ~= nil
		or ns.RawData.Soulstone[itemID] ~= nil
		or ns.RawData.Bandage[itemID] ~= nil
		or ns.RawData.ManaGem[itemID] ~= nil
		or ns.RawData.Explosives[itemID] ~= nil
end

--------------------------------------------------------------------------------
-- Zone Helpers
--------------------------------------------------------------------------------

local function BuildZoneSet(rawZoneArray)
	if not rawZoneArray then
		return nil
	end
	local set = {}
	for _, mapID in ipairs(rawZoneArray) do
		set[mapID] = true
	end
	return set
end

--------------------------------------------------------------------------------
-- Item Data Caching
--------------------------------------------------------------------------------

--[[
    Looks up an item in the RawData tables, derives a canonical shape
    (type, health/mana values, requirements, zones), and caches it under
    ns.db.profile.itemCache. Non-consumable items are cached as "IGNORE"
    so we never look them up a second time.
]]
function ns.CacheItemData(itemID)
	local itemCache = ns.db and ns.db.profile.itemCache
	if not itemCache then
		return nil
	end

	local name, _, _, _, minLevel, _, _, maxStack, _, _, vendorPrice, _, _, bindType = GetItemInfo(itemID)
	if not name then
		return nil
	end

	local rawFoodAndWater = ns.RawData.FoodAndWater[itemID]
	local rawPotion = ns.RawData.Potions[itemID]
	local rawHealthstone = ns.RawData.Healthstone[itemID]
	local rawSoulstone = ns.RawData.Soulstone[itemID]
	local rawBandage = ns.RawData.Bandage[itemID]
	local rawManaGem = ns.RawData.ManaGem[itemID]
	local rawExplosive = ns.RawData.Explosives[itemID]

	if
		not (rawFoodAndWater or rawPotion or rawHealthstone or rawSoulstone or rawBandage or rawManaGem or rawExplosive)
	then
		itemCache[itemID] = "IGNORE"
		return "IGNORE"
	end

	local data = {
		--[[
		    Spelled `id` rather than `itemID` because this table is persisted:
		    every saved itemCache entry on every character already carries this
		    key, and renaming it would read as nil against all of them. The
		    session-only cache below, which persists nothing, uses itemID.
		]]
		id = itemID,
		itemType = "",
		healthValue = 0,
		manaValue = 0,
		damageValue = 0,
		requiredLevel = minLevel or 0,
		requiredFirstAid = 0,
		requiredAlchemy = 0,
		requiredEngineering = 0,
		requiredSpellID = nil,
		price = vendorPrice or 0,
		maxStack = maxStack or 1,
		--[[
		    bindType 1 is Enum.ItemBind.OnAcquire. For a consumable that is
		    the exact test for "the stack in the bag is soulbound": you can
		    only be holding one by having acquired it, so the item's binding
		    rule and the state of this copy always agree, and no per-slot
		    lookup is needed. Bind-on-use (3) is deliberately NOT soulbound
		    -- it stays tradeable right up until it is consumed.
		]]
		isSoulbound = (bindType == 1),
		isBuffFood = false,
		isPercent = false,
		zones = nil,
		arenaOnly = false,
		arenaUsable = false,
		isConjured = false,
	}

	if rawFoodAndWater then
		local isBuffFoodType = (rawFoodAndWater[1] == 1)
		data.isBuffFood = isBuffFoodType
		data.zones = BuildZoneSet(rawFoodAndWater[6])

		--[[
		    Arena usability (column 7), a static per-item property so it caches
		    like the other fields. 1 = usable ONLY inside a PvP Arena (Star's
		    Tears/Lament); 2 = conjured, so ALSO usable inside an arena. The
		    scanner gates on the live instance type (IsInInstance) rather than a
		    zone-ID list, so every arena is covered with no map IDs to maintain.
		]]
		local arenaFlag = rawFoodAndWater[7]
		data.arenaOnly = (arenaFlag == 1)
		data.arenaUsable = (arenaFlag ~= nil)
		--[[
		    Conjured (flag 2) is a distinct selection axis from arena usability:
		    arenaUsable is true for BOTH the arena-only drinks (flag 1) and
		    conjured items (flag 2), so it can't tell them apart. isConjured
		    records the conjured status on its own so the scanner can prefer a
		    free, infinite conjured ration over an equal-value purchased,
		    quested, or arena-only item (see IsBetter in Scanner-Inventory).
		]]
		data.isConjured = (arenaFlag == 2)

		local hasFood = false
		local hasWater = false

		if rawFoodAndWater[2] > 0 then
			hasFood = true
			data.healthValue = 99999
			data.isPercent = true
		elseif rawFoodAndWater[3] > 0 then
			hasFood = true
			data.healthValue = rawFoodAndWater[3]
		end

		if rawFoodAndWater[4] > 0 then
			hasWater = true
			data.manaValue = 99999
			data.isPercent = true
		elseif rawFoodAndWater[5] > 0 then
			hasWater = true
			data.manaValue = rawFoodAndWater[5]
		end

		if isBuffFoodType and not hasFood and not hasWater then
			hasFood = true
		end

		if hasFood and hasWater then
			data.itemType = "foodwater"
		elseif hasFood then
			data.itemType = "food"
		else
			data.itemType = "water"
		end
	elseif rawPotion then
		data.itemType = "potion"
		data.healthValue = rawPotion[1]
		data.manaValue = rawPotion[2]
		data.zones = BuildZoneSet(rawPotion[3])
		data.requiredAlchemy = rawPotion[4] or 0
	elseif rawHealthstone then
		data.itemType = "healthstone"
		data.healthValue = rawHealthstone[1]
		--[[
		    Required level for the bag-scan usable gate comes from the curated
		    Data/Healthstones.lua column (static over API), falling back to
		    GetItemInfo's minLevel. (Conjure downranking uses a separate table.)
		]]
		data.requiredLevel = rawHealthstone[2] or data.requiredLevel
	elseif rawSoulstone then
		data.itemType = "soulstone"
		data.healthValue = rawSoulstone[1]
	elseif rawBandage then
		-- Bandage row shape: {healAmount, requiredSkill, sellPrice, {zones}}
		data.itemType = "bandage"
		data.healthValue = rawBandage[1]
		data.requiredFirstAid = rawBandage[2] or 0
		data.zones = BuildZoneSet(rawBandage[4])
	elseif rawManaGem then
		data.itemType = "managem"
		data.manaValue = rawManaGem[1]
	elseif rawExplosive then
		-- Explosive row shape: {minDamage, maxDamage, requiredSkill, requiredSpellID}
		data.itemType = "explosive"
		data.damageValue = rawExplosive[1]
		data.requiredEngineering = rawExplosive[3] or 0
		--[[
		    Engineering specialization gate (e.g. 20222 = Goblin Engineer for
		    the Global Thermal Sapper Charge). The scanner treats the item as
		    unusable until the player knows this spell.
		]]
		data.requiredSpellID = rawExplosive[4]
	end

	itemCache[itemID] = data
	return data
end

--------------------------------------------------------------------------------
-- Session Item Data
--------------------------------------------------------------------------------

--[[
    A plain memo over GetItemInfo, and the link builder that rides on it. Distinct
    from the consumable cache above and deliberately kept beside it: that one is
    persisted, enriched from ns.RawData, and only ever holds consumables, while
    this one is thrown away at logout and answers for any item at all. Reach for
    the consumable cache when a consumable's own facts are wanted, and for this
    when a name, an icon or a link is.
]]

-- Every GetItemInfo answer this session, keyed by whatever was asked for.
local getItemInfoCache = {}

--[[
    A miss is cached too, under this sentinel. GetItemInfo answers nil for
    anything the client has not resolved yet, and the Restock List asks for the
    same cold item many times inside a single redraw -- once per filter test,
    once per category count, and again while sorting. Without the sentinel every
    one of those was a fresh call.

    Only ID-keyed misses are remembered. This cache is keyed by whatever the
    caller asked with -- an id on the hot paths, an item link at a merchant --
    and GET_ITEM_INFO_RECEIVED reports an id, so an id is the only key
    ns.ForgetItemDataMiss can clear again. A link miss is left uncached rather
    than remembered for a session with no way to retract it.
]]
local MISSING = {}

function ns.ForgetItemDataMiss(itemID)
	if getItemInfoCache[itemID] == MISSING then
		getItemInfoCache[itemID] = nil
	end
end

-- Calls GetItemInfo and saves the results, or records the miss for this redraw.
function ns.GetItemData(request)
	local cached = getItemInfoCache[request]
	if cached ~= nil then
		return cached ~= MISSING and cached or nil
	end

	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
		GetItemInfo(request)
	if itemName == nil then
		if type(request) == "number" then
			getItemInfoCache[request] = MISSING
		end
		return nil
	end

	local cacheItem = {
		itemID = tonumber(string.match(itemLink, "item:(%d+)")),
		itemName = itemName,
		itemLink = itemLink,
		itemRarity = itemRarity,
		itemLevel = itemLevel,
		itemMinLevel = itemMinLevel,
		itemType = itemType,
		itemSubType = itemSubType,
		itemStackCount = itemStackCount,
		itemEquipLoc = itemEquipLoc,
		itemTexture = itemTexture,
		itemSellPrice = itemSellPrice,
	}
	getItemInfoCache[request] = cacheItem
	return cacheItem
end

--[[
    A printable, hoverable, shift-clickable link for an item, always.

    GetItemInfo returns nothing until the client has resolved an item, and on a
    fresh login that is exactly when the Restocker wants to name things -- so
    falling back to a bare name meant the reminder printed plain text most of the
    time. A link built by hand from the id works the moment it is printed: the
    client resolves |Hitem:| on hover, so the tooltip is correct even while the
    cache behind it is still cold.

    The colour on the hand-built form is white rather than the item's quality
    colour, which is the one thing that cannot be known without the cache. The
    cached link is preferred whenever it exists, and it carries the real colour.
]]
function ns.GetItemHyperlink(itemID, fallbackName)
	local info = itemID and ns.GetItemData(itemID) or nil
	if info and info.itemLink then
		return info.itemLink
	end

	if itemID then
		local label = (fallbackName and fallbackName ~= "") and fallbackName or ("item:" .. itemID)
		return "|cffffffff|Hitem:" .. itemID .. "|h[" .. label .. "]|h|r"
	end

	return fallbackName or "?"
end
