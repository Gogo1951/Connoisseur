local _, ns = ...

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

ns.BestFoodID = nil
ns.BestFoodLink = nil
ns.ScrollOverrideID = nil

ns.BestPetFoodID   = nil
ns.BestPetFoodLink = nil

local currentFirstAidSkill = 0
local currentAlchemySkill = 0

ns.RawData = ns.RawData or {}
ns.RawData.Bandage = ns.RawData.Bandage or {}
ns.RawData.FoodAndWater = ns.RawData.FoodAndWater or {}
ns.RawData.Healthstone = ns.RawData.Healthstone or {}
ns.RawData.Soulstone = ns.RawData.Soulstone or {}
ns.RawData.ManaGem = ns.RawData.ManaGem or {}
ns.RawData.Potions = ns.RawData.Potions or {}

--------------------------------------------------------------------------------
-- Item Cache Helpers
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
-- Best Item Tracking
--------------------------------------------------------------------------------

local best = {
    ["Bandage"]       = { id = nil, value = 0, price = 0, count = 0, link = nil, isBuffFood = false, isPercent = false, isHybrid = false },
    ["Food"]          = { id = nil, value = 0, price = 0, count = 0, link = nil, isBuffFood = false, isPercent = false, isHybrid = false },
    ["Health Potion"] = { id = nil, value = 0, price = 0, count = 0, link = nil, isBuffFood = false, isPercent = false, isHybrid = false },
    ["Healthstone"]   = { id = nil, value = 0, price = 0, count = 0, link = nil, isBuffFood = false, isPercent = false, isHybrid = false },
    ["Mana Gem"]      = { id = nil, value = 0, price = 0, count = 0, link = nil, isBuffFood = false, isPercent = false, isHybrid = false },
    ["Mana Potion"]   = { id = nil, value = 0, price = 0, count = 0, link = nil, isBuffFood = false, isPercent = false, isHybrid = false },
    ["Soulstone"]     = { id = nil, value = 0, price = 0, count = 0, link = nil, isBuffFood = false, isPercent = false, isHybrid = false },
    ["Water"]         = { id = nil, value = 0, price = 0, count = 0, link = nil, isBuffFood = false, isPercent = false, isHybrid = false },
}

local function ResetBest(entry)
    entry.id = nil
    entry.value = 0
    entry.price = 0
    entry.count = 0
    entry.link = nil
    entry.isBuffFood = false
    entry.isPercent = false
    entry.isHybrid = false
end

--------------------------------------------------------------------------------
-- Buff Detection
--------------------------------------------------------------------------------

function ns.HasWellFedBuff()
    local TARGET_ICON_ID = 136000
    local TARGET_ICON_ID_2 = 133943
    for i = 1, 40 do
        local name, icon, _, _, _, _, _, _, _, spellID = UnitAura("player", i, "HELPFUL")
        if not name then break end
        if icon == TARGET_ICON_ID or icon == TARGET_ICON_ID_2 then
            return true
        end
        if ns.WellFedBuffIDs and ns.WellFedBuffIDs[spellID] then
            return true
        end
    end
    return false
end

-- Returns true if the player already has adequate coverage for this scroll type.
-- A scroll buff of any rank counts as covered. A conflict spell (e.g. Fort)
-- only counts as covered if its base amount >= the scroll we would use.
function ns.HasScrollBuff(scrollType, scrollAmount)
    if not ns.ScrollData or not ns.ScrollData[scrollType] then
        return true
    end

    local data = ns.ScrollData[scrollType]

    -- Build a set of all scroll buff IDs for this type
    local scrollBuffIDs = {}
    for _, entry in ipairs(data.items) do
        scrollBuffIDs[entry[2]] = true
    end

    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellID = UnitAura("player", i, "HELPFUL")
        if not name then break end

        -- Already have a scroll buff active for this stat
        if scrollBuffIDs[spellID] then
            return true
        end

        -- Check conflict spells — only block the scroll if the class buff
        -- provides at least as much stat as our best scroll would
        local conflictAmount = data.conflictSpells[spellID]
        if conflictAmount and conflictAmount >= (scrollAmount or 0) then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- Profession Skills
--------------------------------------------------------------------------------

function ns.UpdateFirstAidSkill()
    local firstAidSpellName = GetSpellInfo(3273)
    if not firstAidSpellName then
        currentFirstAidSkill = 0
        return
    end

    for i = 1, GetNumSkillLines() do
        local skillName, isHeader, _, skillRank = GetSkillLineInfo(i)
        if not isHeader and skillName == firstAidSpellName then
            currentFirstAidSkill = skillRank
            return
        end
    end

    currentFirstAidSkill = 0
end

function ns.UpdateAlchemySkill()
    local alchemySpellName = GetSpellInfo(2259)
    if not alchemySpellName then
        currentAlchemySkill = 0
        return
    end

    for i = 1, GetNumSkillLines() do
        local skillName, isHeader, _, skillRank = GetSkillLineInfo(i)
        if not isHeader and skillName == alchemySpellName then
            currentAlchemySkill = skillRank
            return
        end
    end

    currentAlchemySkill = 0
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
--------------------------------------------------------------------------------

local function CacheItemData(itemID)
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
        id             = itemID,
        itemType       = "",
        healthValue    = 0,
        manaValue      = 0,
        requiredLevel  = minLevel or 0,
        requiredFirstAid = 0,
        requiredAlchemy  = 0,
        price          = vendorPrice or 0,
        isBuffFood     = false,
        isPercent      = false,
        zones          = nil,
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

--------------------------------------------------------------------------------
-- Comparison Logic
--------------------------------------------------------------------------------

local function IsBetter(candidate, candidateCount, candidatePrice, currentBest, score, allowBuffFood, preferHybrid)
    if not currentBest.id then
        return true
    end

    if allowBuffFood and candidate.isBuffFood ~= currentBest.isBuffFood then
        return candidate.isBuffFood
    end

    if candidate.isPercent ~= currentBest.isPercent then
        return candidate.isPercent
    end

    if score ~= currentBest.value then
        return score > currentBest.value
    end

    if candidatePrice ~= currentBest.price then
        return candidatePrice < currentBest.price
    end

    local candidateIsHybrid = (candidate.healthValue > 0 and candidate.manaValue > 0)
    if candidateIsHybrid ~= currentBest.isHybrid then
        if preferHybrid then
            return candidateIsHybrid
        else
            return not candidateIsHybrid
        end
    end

    return candidateCount < currentBest.count
end

--------------------------------------------------------------------------------
-- Scroll Scanning
--------------------------------------------------------------------------------

-- Finds the best available scroll for a type from bag contents.
-- Scroll entries: {[1] itemID, [2] buffID, [3] requiredLevel, [4] amount}
-- Returns itemID, amount (or nil, nil if nothing usable is found).
local function FindBestScroll(scrollType, bagItemCounts)
    if not ns.ScrollData or not ns.ScrollData[scrollType] then
        return nil, nil
    end

    local playerLevel = ns.CachedPlayerLevel or 1
    local items = ns.ScrollData[scrollType].items
    for _, entry in ipairs(items) do
        if entry[3] <= playerLevel then
            if bagItemCounts[entry[1]] and bagItemCounts[entry[1]] > 0 then
                return entry[1], entry[4]
            end
        end
    end

    return nil, nil
end

-- Returns the item ID of the first scroll that should be used, or nil
function ns.FindScrollOverride(bagItemCounts)
    local charDB = ConnoisseurCharDB
    if not charDB or not charDB.settings or not charDB.settings.useScrolls then
        return nil
    end
    if not ns.IsModeActive(charDB.settings.scrollsMode) then
        return nil
    end

    local scrollTypes = charDB.settings.scrollTypes
    if not scrollTypes then return nil end

    for _, scrollType in ipairs(ns.SCROLL_CHECK_ORDER) do
        if scrollTypes[scrollType] then
            local scrollItemID, scrollAmount = FindBestScroll(scrollType, bagItemCounts)
            if scrollItemID and not ns.HasScrollBuff(scrollType, scrollAmount) then
                return scrollItemID
            end
        end
    end

    return nil
end

--------------------------------------------------------------------------------
-- Pet Buff Scanning
--------------------------------------------------------------------------------

ns.PetBuffOverrideID = nil

-- Returns true if the pet already has the Kibler's or Sporeling well-fed buff
function ns.HasPetFoodBuff()
    if not UnitExists("pet") then return false end
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellID = UnitAura("pet", i, "HELPFUL")
        if not name then break end
        if spellID == ns.KIBLERS_BUFF_ID or spellID == ns.SPORELING_BUFF_ID then
            return true
        end
    end
    return false
end

-- Returns the item ID of the pet food buff that should be used, or nil
function ns.FindPetBuffOverride(bagItemCounts)
    local charDB = ConnoisseurCharDB
    if not charDB or not charDB.settings or not charDB.settings.usePetBuffFood then
        return nil
    end
    if not ns.IsModeActive(charDB.settings.petBuffFoodMode) then
        return nil
    end

    local playerLevel = ns.CachedPlayerLevel or 1
    if playerLevel < 55 then return nil end

    if not UnitExists("pet") or UnitIsDead("pet") or UnitIsGhost("pet") then
        return nil
    end

    if ns.HasPetFoodBuff() then
        return nil
    end

    local petTypes = charDB.settings.petBuffTypes
    if not petTypes then
        petTypes = { KiblersBits = true, SporelingSnacks = true }
    end

    if petTypes.KiblersBits ~= false and bagItemCounts[ns.KIBLERS_BITS_ITEM_ID] and bagItemCounts[ns.KIBLERS_BITS_ITEM_ID] > 0 then
        return ns.KIBLERS_BITS_ITEM_ID
    end

    if petTypes.SporelingSnacks ~= false and bagItemCounts[ns.SPORELING_SNACKS_ITEM_ID] and bagItemCounts[ns.SPORELING_SNACKS_ITEM_ID] > 0 then
        return ns.SPORELING_SNACKS_ITEM_ID
    end

    return nil
end

--------------------------------------------------------------------------------
-- Bag Scanning
--------------------------------------------------------------------------------

local itemCounts = {}
local slotItems = {}

function ns.ScanBags()
    local playerLevel = ns.CachedPlayerLevel
    local currentMap = ns.CachedMapID
    local charDB = ConnoisseurCharDB or {}
    local settings = charDB.settings or {}
    local itemCache = ConnoisseurDB and ConnoisseurDB.itemCache or {}

    ns.AllowBuffFood = settings.useBuffFood
    and ns.IsModeActive(settings.buffFoodMode)
    and not ns.WellFedState

    for _, entry in pairs(best) do
        ResetBest(entry)
    end

    local dataRetry = false
    wipe(itemCounts)
    wipe(slotItems)

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.itemID then
                local id = info.itemID
                itemCounts[id] = (itemCounts[id] or 0) + info.stackCount
                if not slotItems[id] then
                    slotItems[id] = info.hyperlink
                end
            end
        end
    end

    -- Overrides check happens before standard consumable scan
    ns.ScrollOverrideID = ns.FindScrollOverride(itemCounts)
    ns.PetBuffOverrideID = ns.FindPetBuffOverride(itemCounts)

    for id, hyperlink in pairs(slotItems) do
        local ignoreList = charDB.ignoreList or {}
        if not ignoreList[id] then
            -- Skip scroll items from normal consumable processing
            if ns.ScrollItemLookup and ns.ScrollItemLookup[id] then
                -- Scrolls are handled by the scroll override system
            else
                local data = itemCache[id]
                if not data then
                    data = CacheItemData(id)
                end

                if not data then
                    dataRetry = true
                elseif data ~= "IGNORE" then
                    local usable = true

                    if data.requiredLevel > playerLevel then
                        usable = false
                    end

                    if usable and data.requiredFirstAid > 0 and data.requiredFirstAid > currentFirstAidSkill then
                        usable = false
                    end

                    if usable and (data.requiredAlchemy or 0) > 0 and (data.requiredAlchemy or 0) > currentAlchemySkill then
                        usable = false
                    end

                    if usable and data.zones then
                        usable = (currentMap ~= nil) and (data.zones[currentMap] == true)
                    end

                    if usable then
                        local totalCount = itemCounts[id]
                        local itemType = data.itemType

                        if itemType == "bandage" then
                            if IsBetter(data, totalCount, data.price, best["Bandage"], data.healthValue, false) then
                                local winner = best["Bandage"]
                                winner.id = id
                                winner.value = data.healthValue
                                winner.price = data.price
                                winner.count = totalCount
                            end
                        elseif itemType == "healthstone" then
                            if IsBetter(data, totalCount, data.price, best["Healthstone"], data.healthValue, false) then
                                local winner = best["Healthstone"]
                                winner.id = id
                                winner.value = data.healthValue
                                winner.price = data.price
                                winner.count = totalCount
                            end
                        elseif itemType == "soulstone" then
                            if IsBetter(data, totalCount, data.price, best["Soulstone"], data.healthValue, false) then
                                local winner = best["Soulstone"]
                                winner.id = id
                                winner.value = data.healthValue
                                winner.price = data.price
                                winner.count = totalCount
                            end
                        elseif itemType == "managem" then
                            if IsBetter(data, totalCount, data.price, best["Mana Gem"], data.manaValue, false) then
                                local winner = best["Mana Gem"]
                                winner.id = id
                                winner.value = data.manaValue
                                winner.price = data.price
                                winner.count = totalCount
                            end
                        elseif itemType == "potion" then
                            if data.healthValue > 0 and IsBetter(data, totalCount, data.price, best["Health Potion"], data.healthValue, false) then
                                local winner = best["Health Potion"]
                                winner.id = id
                                winner.value = data.healthValue
                                winner.price = data.price
                                winner.count = totalCount
                            end
                            if data.manaValue > 0 and IsBetter(data, totalCount, data.price, best["Mana Potion"], data.manaValue, false) then
                                local winner = best["Mana Potion"]
                                winner.id = id
                                winner.value = data.manaValue
                                winner.price = data.price
                                winner.count = totalCount
                            end
                        elseif itemType == "food" or itemType == "water" or itemType == "foodwater" then
                            if not (data.isBuffFood and not ns.AllowBuffFood) then
                                if itemType == "food" or itemType == "foodwater" then
                                    if IsBetter(data, totalCount, data.price, best["Food"], data.healthValue, ns.AllowBuffFood, true) then
                                        local winner = best["Food"]
                                        winner.id = id
                                        winner.value = data.healthValue
                                        winner.price = data.price
                                        winner.count = totalCount
                                        winner.isBuffFood = data.isBuffFood
                                        winner.isPercent = data.isPercent
                                        winner.link = hyperlink
                                        winner.isHybrid = (itemType == "foodwater")
                                    end
                                end
                                if itemType == "water" or itemType == "foodwater" then
                                    if IsBetter(data, totalCount, data.price, best["Water"], data.manaValue, ns.AllowBuffFood, false) then
                                        local winner = best["Water"]
                                        winner.id = id
                                        winner.value = data.manaValue
                                        winner.price = data.price
                                        winner.count = totalCount
                                        winner.isBuffFood = data.isBuffFood
                                        winner.isPercent = data.isPercent
                                        winner.isHybrid = (itemType == "foodwater")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    ns.BestFoodID = best["Food"].id
    ns.BestFoodLink = best["Food"].link

    return best, dataRetry
end

--------------------------------------------------------------------------------
-- Active Quest Set (Hunter)
--
-- Builds a set of quest IDs the player currently has in their quest log.
-- Used by ScanPetFood to skip foods that are objectives for active quests.
--------------------------------------------------------------------------------

local activeQuestIDs = {}

local function BuildActiveQuestSet()
    wipe(activeQuestIDs)
    for questIndex = 1, GetNumQuestLogEntries() do
        local _, _, _, _, isHeader, _, isComplete, questID = GetQuestLogTitle(questIndex)
        if not isHeader and questID and not isComplete then
            activeQuestIDs[questID] = true
        end
    end
end

-- Returns true if this food item is associated with an active quest.
local function IsNeededForQuest(questIDs)
    for _, questID in ipairs(questIDs) do
        if activeQuestIDs[questID] then
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- Pet Food Scanning (Hunter)
--
-- Selects the lowest-itemLevel food that still gives maximum happiness
-- (petLevel - foodItemLevel between 0 and 10). Ties broken by sell price
-- (lower wins), then total count in bags (fewer wins).
--
-- All data (itemLevel, dietID, sellPrice, questIDs) comes from the stored
-- ns.PetFoodData table. No server queries are needed during scanning.
--
-- Quest objective foods are skipped only when the player has that quest
-- active.
--------------------------------------------------------------------------------

function ns.ScanPetFood()
    ns.BestPetFoodID   = nil
    ns.BestPetFoodLink = nil

    if not ns.PetFoodData or not ns.PetDietMap then return end

    -- Must have a living pet out
    if not UnitExists("pet") or UnitIsDead("pet") or UnitIsGhost("pet") then return end

    local petLevel = UnitLevel("pet")
    if not petLevel or petLevel < 1 then return end

    -- Build a set of diet IDs the current pet accepts
    local petDiets = { GetPetFoodTypes() }
    if not petDiets or #petDiets == 0 then return end

    local dietSet = {}
    for _, dietName in ipairs(petDiets) do
        local dietID = ns.PetDietMap[dietName]
        if dietID then
            dietSet[dietID] = true
        end
    end

    -- Snapshot the player's active quests once per scan
    BuildActiveQuestSet()

    local ignoreList = ConnoisseurCharDB and ConnoisseurCharDB.ignoreList or {}

    local bestID, bestLink
    local bestLevel = 999
    local bestPrice = 999999
    local bestCount = 999999

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.itemID then
                local id = info.itemID
                local foodData = ns.PetFoodData[id]

                if foodData and not ignoreList[id] then
                    local foodLevel = foodData[1]
                    local foodDiet  = foodData[2]
                    local sellPrice = foodData[3]
                    local questIDs  = foodData[4]

                    if dietSet[foodDiet] then
                        local levelDelta = petLevel - foodLevel

                        -- Only consider foods in the max-happiness bracket (delta 0 to 10)
                        if levelDelta >= 0 and levelDelta <= 10 then

                            -- Skip foods needed for active quests
                            local skipQuest = false
                            if questIDs then
                                skipQuest = IsNeededForQuest(questIDs)
                            end

                            if not skipQuest then
                                local totalCount = C_Item.GetItemCount(id)

                                -- Prefer: lowest itemLevel, then lowest sell price, then fewest in bags
                                local isBetter = false
                                if not bestID then
                                    isBetter = true
                                elseif foodLevel ~= bestLevel then
                                    isBetter = foodLevel < bestLevel
                                elseif sellPrice ~= bestPrice then
                                    isBetter = sellPrice < bestPrice
                                else
                                    isBetter = totalCount < bestCount
                                end

                                if isBetter then
                                    bestID    = id
                                    bestLink  = info.hyperlink
                                    bestLevel = foodLevel
                                    bestPrice = sellPrice
                                    bestCount = totalCount
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    ns.BestPetFoodID   = bestID
    ns.BestPetFoodLink = bestLink
end
