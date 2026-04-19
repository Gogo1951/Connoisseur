local _, ns = ...

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

ns.BestFoodID = nil
ns.BestFoodLink = nil

ns.BestPetFoodID = nil
ns.BestPetFoodLink = nil

local currentFirstAidSkill = 0
local currentAlchemySkill = 0

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
-- Comparison Logic
--
-- Candidate wins if, in order: it's a buff food when we want one, it's a
-- percent-heal, it has a higher score, a lower price, the correct hybrid
-- preference, or fewer copies in bags.
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
                    data = ns.CacheItemData(id)
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
    ns.BestPetFoodID = nil
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

    ns.BestPetFoodID = bestID
    ns.BestPetFoodLink = bestLink
end
