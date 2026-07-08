local _, ns = ...

--[[
    Item-Cache -- derives and caches per-item consumable data in
    ns.db.profile.itemCache (the stateful item-metadata layer) and answers
    whether an item is a known consumable.

    Exposes: ns.RawData, ns.ClearItemCache, ns.IsKnownConsumable,
    ns.CacheItemData, ns.PruneIgnoreList.
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

function ns.ClearItemCache()
    if ns.db and ns.db.profile.itemCache then
        wipe(ns.db.profile.itemCache)
    end
end

function ns.IsKnownConsumable(itemID)
    local cache = ns.db and ns.db.profile.itemCache
    if cache and cache[itemID] and cache[itemID] ~= "IGNORE" then
        return true
    end
    if ns.ScrollItemLookup and ns.ScrollItemLookup[itemID] then
        return true
    end
    return ns.RawData.FoodAndWater[itemID] ~= nil or ns.RawData.Potions[itemID] ~= nil or
        ns.RawData.Healthstone[itemID] ~= nil or
        ns.RawData.Soulstone[itemID] ~= nil or
        ns.RawData.Bandage[itemID] ~= nil or
        ns.RawData.ManaGem[itemID] ~= nil or
        ns.RawData.Explosives[itemID] ~= nil
end

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

--[[
    On logout, drop ignore-list entries no longer recognized as consumables
    (e.g. the data changed between versions) so the list can't accumulate stale
    item IDs. Routed from Core's PLAYER_LOGOUT handler.
]]
function ns.PruneIgnoreList()
    local ignoreList = (ns.db and ns.db.profile.ignoreList) or {}
    for itemID in pairs(ignoreList) do
        if not ns.IsKnownConsumable(itemID) then
            ignoreList[itemID] = nil
        end
    end
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

    local name, _, _, _, minLevel, _, _, maxStack, _, _, vendorPrice = GetItemInfo(itemID)
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

    if not (rawFoodAndWater or rawPotion or rawHealthstone or rawSoulstone or rawBandage or rawManaGem or rawExplosive) then
        itemCache[itemID] = "IGNORE"
        return "IGNORE"
    end

    local data = {
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
        isBuffFood = false,
        isPercent = false,
        zones = nil,
        arenaOnly = false,
        arenaUsable = false,
        isConjured = false
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