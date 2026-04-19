local _, ns = ...

--------------------------------------------------------------------------------
-- Raw Data Safety Init
--
-- Defensive in case a Data/*.lua file fails to load. Scanner modules read
-- ns.RawData tables and must never index nil.
--------------------------------------------------------------------------------

ns.RawData = ns.RawData or {}
ns.RawData.Bandage = ns.RawData.Bandage or {}
ns.RawData.FoodAndWater = ns.RawData.FoodAndWater or {}
ns.RawData.Healthstone = ns.RawData.Healthstone or {}
ns.RawData.Soulstone = ns.RawData.Soulstone or {}
ns.RawData.ManaGem = ns.RawData.ManaGem or {}
ns.RawData.Potions = ns.RawData.Potions or {}

--------------------------------------------------------------------------------
-- Item Cache
--------------------------------------------------------------------------------

function ns.ClearItemCache()
    if ConnoisseurDB and ConnoisseurDB.itemCache then
        wipe(ConnoisseurDB.itemCache)
    end
end

function ns.IsKnownConsumable(itemID)
    local cache = ConnoisseurDB and ConnoisseurDB.itemCache
    if cache and cache[itemID] and cache[itemID] ~= "IGNORE" then
        return true
    end
    if ns.ScrollItemLookup and ns.ScrollItemLookup[itemID] then
        return true
    end
    return ns.RawData.FoodAndWater[itemID] ~= nil
        or ns.RawData.Potions[itemID] ~= nil
        or ns.RawData.Healthstone[itemID] ~= nil
        or ns.RawData.Soulstone[itemID] ~= nil
        or ns.RawData.Bandage[itemID] ~= nil
        or ns.RawData.ManaGem[itemID] ~= nil
end

--------------------------------------------------------------------------------
-- Zone Helpers
--------------------------------------------------------------------------------

local function BuildZoneSet(rawZoneArray)
    if not rawZoneArray then return nil end
    local set = {}
    for _, mapID in ipairs(rawZoneArray) do
        set[mapID] = true
    end
    return set
end

--------------------------------------------------------------------------------
-- Item Data Caching
--
-- Looks up an item in the RawData tables, derives a canonical shape
-- (type, health/mana values, requirements, zones), and caches it under
-- ConnoisseurDB.itemCache. Non-consumable items are cached as "IGNORE"
-- so we never look them up a second time.
--------------------------------------------------------------------------------

function ns.CacheItemData(itemID)
    local itemCache = ConnoisseurDB and ConnoisseurDB.itemCache
    if not itemCache then return nil end

    local name, _, _, _, minLevel, _, _, _, _, _, vendorPrice = GetItemInfo(itemID)
    if not name then return nil end

    local rawFoodAndWater = ns.RawData.FoodAndWater[itemID]
    local rawPotion       = ns.RawData.Potions[itemID]
    local rawHealthstone  = ns.RawData.Healthstone[itemID]
    local rawSoulstone    = ns.RawData.Soulstone[itemID]
    local rawBandage      = ns.RawData.Bandage[itemID]
    local rawManaGem      = ns.RawData.ManaGem[itemID]

    if not (rawFoodAndWater or rawPotion or rawHealthstone or rawSoulstone or rawBandage or rawManaGem) then
        itemCache[itemID] = "IGNORE"
        return "IGNORE"
    end

    local data = {
        id               = itemID,
        itemType         = "",
        healthValue      = 0,
        manaValue        = 0,
        requiredLevel    = minLevel or 0,
        requiredFirstAid = 0,
        requiredAlchemy  = 0,
        price            = vendorPrice or 0,
        isBuffFood       = false,
        isPercent        = false,
        zones            = nil,
    }

    if rawFoodAndWater then
        local isBuffFoodType = (rawFoodAndWater[1] == 1)
        data.isBuffFood = isBuffFoodType
        data.zones = BuildZoneSet(rawFoodAndWater[6])

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
    elseif rawSoulstone then
        data.itemType = "soulstone"
        data.healthValue = rawSoulstone[1]
    elseif rawBandage then
        data.itemType = "bandage"
        data.healthValue = rawBandage[1]
        data.requiredFirstAid = rawBandage[2] or 0
        data.zones = BuildZoneSet(rawBandage[3])
    elseif rawManaGem then
        data.itemType = "managem"
        data.manaValue = rawManaGem[1]
    end

    itemCache[itemID] = data
    return data
end
