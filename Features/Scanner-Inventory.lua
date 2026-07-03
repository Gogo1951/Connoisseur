local _, ns = ...

--[[
    Scanner-Inventory -- scans the player's bags and selects the single best item
    per macro category (food, water, potions, healthstones, ...) plus the best
    Hunter pet food, applying scoring, ranking, and usability gates.

    Exposes: ns.ScanBags, ns.ScanPetFood, ns.BestFoodID, ns.BestFoodLink,
    ns.BestPetFoodID, ns.BestPetFoodLink.
]]

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

ns.BestFoodID = nil
ns.BestFoodLink = nil

ns.BestPetFoodID = nil
ns.BestPetFoodLink = nil

--------------------------------------------------------------------------------
-- Best Item Tracking
--------------------------------------------------------------------------------

local best = {
    ["Bandage"] = {
        id = nil,
        value = 0,
        price = 0,
        count = 0,
        link = nil,
        isBuffFood = false,
        isPercent = false,
        isHybrid = false
    },
    ["Food"] = {
        id = nil,
        value = 0,
        price = 0,
        count = 0,
        link = nil,
        isBuffFood = false,
        isPercent = false,
        isHybrid = false
    },
    ["Health Potion"] = {
        id = nil,
        value = 0,
        price = 0,
        count = 0,
        link = nil,
        isBuffFood = false,
        isPercent = false,
        isHybrid = false,
        topIDs = {}
    },
    ["Healthstone"] = {
        id = nil,
        value = 0,
        price = 0,
        count = 0,
        link = nil,
        isBuffFood = false,
        isPercent = false,
        isHybrid = false,
        topIDs = {}
    },
    ["Mana Gem"] = {
        id = nil,
        value = 0,
        price = 0,
        count = 0,
        link = nil,
        isBuffFood = false,
        isPercent = false,
        isHybrid = false
    },
    ["Mana Potion"] = {
        id = nil,
        value = 0,
        price = 0,
        count = 0,
        link = nil,
        isBuffFood = false,
        isPercent = false,
        isHybrid = false,
        topIDs = {}
    },
    ["Soulstone"] = {
        id = nil,
        value = 0,
        price = 0,
        count = 0,
        link = nil,
        isBuffFood = false,
        isPercent = false,
        isHybrid = false
    },
    ["Water"] = {
        id = nil,
        value = 0,
        price = 0,
        count = 0,
        link = nil,
        isBuffFood = false,
        isPercent = false,
        isHybrid = false
    }
}

--[[
    Expose the scanner's live best table for diagnostics. ScanBags resets and
    repopulates these entries in place every pass, so the reference always
    reflects the last scan. Read-only for consumers (Diagnostics' context
    report); the scanner itself owns all writes. This is what lets the context
    report show the per-category winner for every type, not just BestFoodID.
]]
ns.BestSelection = best

local function ResetBest(entry)
    entry.id = nil
    entry.value = 0
    entry.price = 0
    entry.count = 0
    entry.link = nil
    entry.isBuffFood = false
    entry.isPercent = false
    entry.isHybrid = false
    if entry.topIDs then
        wipe(entry.topIDs)
    end
end

--------------------------------------------------------------------------------
-- Adjusted Score (Potions & Bandages)
--------------------------------------------------------------------------------

--[[
    Layers two small priority bonuses onto the raw heal/mana value so the
    scoring still falls back to vendor price → count when items truly tie:

      +2 if the item is zone-restricted (data.zones present). The scanner has
         already gated on currentMap before this is called, so "has zones" at
         this point implies "usable here." Zone-locked consumables (Nethergon
         potions in Tempest Keep, BG-specific bandages, etc.) are worthless
         outside their zone, so we burn them first when we're inside.

      +1 if the item stacks above 10. Favors Healing/Mana Potion Injectors
         (stack 20) over the plain potions they are crafted from (stack 5):
         it preserves the reagent supply and frees bag space.

    The bonuses are intentionally tiny relative to typical heal values, so a
    stronger raw value still wins; the +1/+2 only matter when raw values tie.
]]

local function AdjustedScore(data, baseValue)
    local score = baseValue
    if data.zones then
        score = score + 2
    end
    if (data.maxStack or 1) > 10 then
        score = score + 1
    end
    return score
end

--------------------------------------------------------------------------------
-- Comparison Logic
--------------------------------------------------------------------------------

--[[
    Candidate wins if, in order: it's a buff food when we want one, it's a
    percent-heal, it has a higher score, a lower price, the correct hybrid
    preference, fewer copies in bags, or — as a final, never-equal tiebreak —
    a lower itemID.

    The itemID tiebreak mirrors CompareRankedCandidates: without it, two items
    that match on every other field compare equal, so the winner is whichever
    the pairs() scan over slotItems happened to reach first. That order is not
    stable between an in-session rescan (a wiped-and-rebuilt table) and a fresh
    table after /reload, so the selection could flip for identical bags — the
    item would only "update" after a reload. Comparing itemID last makes the
    pick deterministic, so a buy-triggered rescan and a reload always agree.
]]

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

    if candidateCount ~= currentBest.count then
        return candidateCount < currentBest.count
    end

    return candidate.id < currentBest.id
end

--------------------------------------------------------------------------------
-- Ranked Candidates (Multi-Use Macros)
--------------------------------------------------------------------------------

--[[
    The ns.MultiUseMacroTypes categories stack up to ns.MULTI_USE_MAX_ITEMS
    /use lines per macro, so instead of tracking a single running winner
    they collect every usable candidate during the scan and are ranked once
    it completes. The other categories keep the single-winner IsBetter path.
]]

local rankedCandidates = {
    ["Health Potion"] = {},
    ["Healthstone"] = {},
    ["Mana Potion"] = {}
}

local function AddRankedCandidate(typeName, id, data, score, count)
    local list = rankedCandidates[typeName]
    list[#list + 1] = {
        id = id,
        value = score,
        price = data.price,
        count = count,
        isPercent = data.isPercent or false,
        isHybrid = (data.healthValue > 0 and data.manaValue > 0)
    }
end

--[[
    Pairwise form of IsBetter's ordering for the ranked categories, where
    allowBuffFood and preferHybrid are always false: percent heals first,
    then higher score, lower price, non-hybrid, fewer copies in bags.
    itemID is the final tiebreak so candidates never compare equal — keeps
    table.sort's instability from reordering equal ranks between scans and
    churning macro rewrites.
]]
local function CompareRankedCandidates(a, b)
    if a.isPercent ~= b.isPercent then
        return a.isPercent
    end
    if a.value ~= b.value then
        return a.value > b.value
    end
    if a.price ~= b.price then
        return a.price < b.price
    end
    if a.isHybrid ~= b.isHybrid then
        return not a.isHybrid
    end
    if a.count ~= b.count then
        return a.count < b.count
    end
    return a.id < b.id
end

local function RankCandidates()
    for typeName, list in pairs(rankedCandidates) do
        table.sort(list, CompareRankedCandidates)

        local entry = best[typeName]
        local winner = list[1]
        if winner then
            entry.id = winner.id
            entry.value = winner.value
            entry.price = winner.price
            entry.count = winner.count
        end
        for rank = 1, math.min(#list, ns.MULTI_USE_MAX_ITEMS) do
            entry.topIDs[rank] = list[rank].id
        end
    end
end

--------------------------------------------------------------------------------
-- Bag Scanning
--------------------------------------------------------------------------------

local itemCounts = {}
local slotItems = {}

function ns.ScanBags()
    --[[
        Refresh the zone at scan time. A zone change during combat is gated out
        by the lockdown guard in Core's dispatcher, so ZONE_CHANGED_NEW_AREA
        never updates the cache mid-fight; reading it here keeps zone-restricted
        item filtering from running against a stale map after combat drops.
    ]]
    ns.CachedMapID = C_Map.GetBestMapForUnit("player")

    --[[
        Party/raid-restricted Buff Food, Scrolls, and Pet Food go stale when
        group composition or the mode dropdown changes — those flip whether a
        feature is active but have no dedicated UpdateAuraTracking call, so
        ns.WellFedState and UNIT_AURA registration would otherwise drift.
        ScanBags is the single point every rescan passes through, so reconcile
        aura tracking here, before AllowBuffFood reads ns.WellFedState below.
    ]]
    if ns.UpdateAuraTracking then
        ns.UpdateAuraTracking()
    end

    local playerLevel = ns.CachedPlayerLevel
    local currentMap = ns.CachedMapID
    --[[
        Arena-only consumables (e.g. Star's Tears) are gated on the live
        instance type instead of a zone-ID list, so every arena is covered with
        no map IDs to maintain. IsInInstance is safe on Era (returns "none").
        ScanBags re-runs on PLAYER_ENTERING_WORLD and ZONE_CHANGED_NEW_AREA, so
        this refreshes on every arena entry and exit.
    ]]
    local inArena = select(2, IsInInstance()) == "arena"
    local firstAidSkill = ns.CurrentFirstAidSkill or 0
    local alchemySkill = ns.CurrentAlchemySkill or 0
    local charDB = ConnoisseurCharDB or {}
    local settings = charDB.settings or {}
    local itemCache = ConnoisseurDB and ConnoisseurDB.itemCache or {}

    --[[
        Testing aid: targeting yourself forces the Food macro into plain-food
        mode — no scrolls, no buff food, just the best non-buff food. Useful
        for verifying what the macro picks without re-toggling settings.
        Scrolls are already suppressed on any friendly-player target (including
        self) in UpdateMacros, so we only need to disable buff-food here.
    ]]
    local targetingSelf = UnitExists("target") and UnitIsUnit("target", "player")

    --[[
        Arena rule: scrolls, pet buff food, and buff food cannot be consumed in
        a PvP Arena, so the Food macro must stay in plain (non-buff) food mode
        there. Buff-food preference is gated here; the scroll and pet-buff
        override resolvers are gated below.
    ]]
    ns.AllowBuffFood = settings.useBuffFood
        and ns.IsModeActive(settings.buffFoodMode)
        and not ns.WellFedState
        and not targetingSelf
        and not inArena

    for _, entry in pairs(best) do
        ResetBest(entry)
    end

    for _, list in pairs(rankedCandidates) do
        wipe(list)
    end

    local dataRetry = false
    wipe(itemCounts)
    wipe(slotItems)

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, ns.GetContainerNumSlots(bag) do
            local info = ns.GetContainerItemInfo(bag, slot)
            if info and info.itemID then
                local id = info.itemID
                itemCounts[id] = (itemCounts[id] or 0) + info.stackCount
                if not slotItems[id] then
                    slotItems[id] = info.hyperlink
                end
            end
        end
    end

    --[[
        Overrides check happens before standard consumable scan. Skipped
        entirely in a PvP Arena (see the arena rule above): scroll mode and pet
        buff food can't be used there, so both stay nil and the Food macro keeps
        its plain food/conjure form.
    ]]
    if inArena then
        ns.ScrollOverrideIDs = nil
        ns.PetBuffOverrideID = nil
    else
        ns.ScrollOverrideIDs = ns.FindScrollOverrides(itemCounts)
        ns.PetBuffOverrideID = ns.FindPetBuffOverride(itemCounts)
    end

    local ignoreList = charDB.ignoreList or {}

    for id, hyperlink in pairs(slotItems) do
        if not ignoreList[id] then
            -- Skip scroll items from normal consumable processing
            if ns.ScrollItemLookup and ns.ScrollItemLookup[id] then
                -- Scrolls are handled by the scroll override system
            else
                local data = itemCache[id]
                --[[
                    Drop cache entries from an older schema so CacheItemData
                    re-derives them below. Test the NEWEST cached field, not an
                    old one: version-stamp invalidation only fires on a release
                    bump, so a same-version update (dev edit) that adds a field
                    would otherwise keep stale entries missing it. The newest
                    field is arenaUsable (CacheItemData always writes it
                    true/false); maxStack is kept in the test to also catch the
                    oldest pre-maxStack entries.
                ]]
                if data and data ~= "IGNORE" and (data.maxStack == nil or data.arenaUsable == nil) then
                    data = nil
                    itemCache[id] = nil
                end
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

                    if usable and data.requiredFirstAid > 0 and data.requiredFirstAid > firstAidSkill then
                        usable = false
                    end

                    if usable and (data.requiredAlchemy or 0) > 0 and (data.requiredAlchemy or 0) > alchemySkill then
                        usable = false
                    end

                    if usable and data.zones then
                        usable = (currentMap ~= nil) and (data.zones[currentMap] == true)
                    end

                    if usable and data.arenaOnly and not inArena then
                        usable = false
                    end

                    --[[
                        In a PvP Arena only conjured food/water and the arena-only
                        drinks (Star's Tears/Lament) can be consumed -- regular
                        food and drink are blocked. Gate the rest out so the macro
                        never selects a drink that fails on press in the arena.
                        Ranking within what survives is unchanged (highest value,
                        then price, then count).
                    ]]
                    if usable and inArena then
                        local t = data.itemType
                        local isFoodOrWater = (t == "food" or t == "water" or t == "foodwater")
                        if isFoodOrWater and not data.arenaUsable then
                            usable = false
                        end
                    end

                    if usable then
                        local totalCount = itemCounts[id]
                        local itemType = data.itemType

                        if itemType == "bandage" then
                            local adjusted = AdjustedScore(data, data.healthValue)
                            if IsBetter(data, totalCount, data.price, best["Bandage"], adjusted, false) then
                                local winner = best["Bandage"]
                                winner.id = id
                                winner.value = adjusted
                                winner.price = data.price
                                winner.count = totalCount
                            end
                        elseif itemType == "healthstone" then
                            AddRankedCandidate("Healthstone", id, data, data.healthValue, totalCount)
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
                            if data.healthValue > 0 then
                                local adjusted = AdjustedScore(data, data.healthValue)
                                AddRankedCandidate("Health Potion", id, data, adjusted, totalCount)
                            end
                            if data.manaValue > 0 then
                                local adjusted = AdjustedScore(data, data.manaValue)
                                AddRankedCandidate("Mana Potion", id, data, adjusted, totalCount)
                            end
                        elseif itemType == "food" or itemType == "water" or itemType == "foodwater" then
                            if not (data.isBuffFood and not ns.AllowBuffFood) then
                                if itemType == "food" or itemType == "foodwater" then
                                    if
                                        IsBetter(
                                            data,
                                            totalCount,
                                            data.price,
                                            best["Food"],
                                            data.healthValue,
                                            ns.AllowBuffFood,
                                            true
                                        )
                                     then
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
                                    if
                                        IsBetter(
                                            data,
                                            totalCount,
                                            data.price,
                                            best["Water"],
                                            data.manaValue,
                                            ns.AllowBuffFood,
                                            false
                                        )
                                     then
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

    RankCandidates()

    ns.BestFoodID = best["Food"].id
    ns.BestFoodLink = best["Food"].link

    return best, dataRetry
end

--------------------------------------------------------------------------------
-- Active Quest Set (Hunter)
--------------------------------------------------------------------------------

--[[
    Builds a set of quest IDs the player currently has in their quest log.
    Used by ScanPetFood to skip foods that are objectives for active quests.
]]

local activeQuestIDs = {}

local function BuildActiveQuestSet()
    wipe(activeQuestIDs)
    for questIndex = 1, GetNumQuestLogEntries() do
        local _, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(questIndex)
        -- Include completed-but-not-turned-in quests too: turn-in still consumes the items.
        if not isHeader and questID then
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
--------------------------------------------------------------------------------

--[[
    Selects the lowest-itemLevel food that still gives maximum happiness
    (petLevel - foodItemLevel between 0 and 10). Ties broken by sell price
    (lower wins), then total count in bags (fewer wins).

    If no food sits in the max-happiness bracket, falls back to the food
    closest to (but above) the pet's level. Pets eat above-level food, just
    wastefully — better than letting the pet go hungry.

    Note: there is no upper cap on how far above pet level the fallback can
    reach. Confirmed empirically on Anniversary (1.15.x): a level-8 cat will
    happily eat level-70 meat. The fallback ranks by lowest food level first,
    so the *least* wasteful option still wins when multiple are available.

    All data (itemLevel, dietID, sellPrice, questIDs) comes from the stored
    ns.PetFoodData table. No server queries are needed during scanning.

    Quest objective foods are skipped whenever the player has that quest in
    their log (including completed-but-not-turned-in), since turn-in consumes
    the items.
]]

function ns.ScanPetFood()
    ns.BestPetFoodID = nil
    ns.BestPetFoodLink = nil

    if not ns.PetFoodData or not ns.PetDietMap then
        return
    end

    -- Must have a living pet out
    if not UnitExists("pet") or UnitIsDead("pet") or UnitIsGhost("pet") then
        return
    end

    local petLevel = UnitLevel("pet")
    if not petLevel or petLevel < 1 then
        return
    end

    -- Build a set of diet IDs the current pet accepts
    local petDiets = {GetPetFoodTypes()}
    if not petDiets or #petDiets == 0 then
        return
    end

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

    --[[
        Wasteful fallback: pets will eat food above their level when no in-bracket
        option is available. Prefer the food closest to pet level (lowest waste).
    ]]
    local fallbackID, fallbackLink
    local fallbackLevel = 999
    local fallbackPrice = 999999
    local fallbackCount = 999999

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, ns.GetContainerNumSlots(bag) do
            local info = ns.GetContainerItemInfo(bag, slot)
            if info and info.itemID then
                local id = info.itemID
                local foodData = ns.PetFoodData[id]

                if foodData and not ignoreList[id] then
                    local foodLevel = foodData[1]
                    local foodDiet = foodData[2]
                    local sellPrice = foodData[3]
                    local questIDs = foodData[4]

                    if dietSet[foodDiet] then
                        local levelDelta = petLevel - foodLevel
                        local inHappyBracket = (levelDelta >= 0 and levelDelta <= 10)
                        local isAbovePet = (levelDelta < 0)

                        if inHappyBracket or isAbovePet then
                            -- Skip foods needed for active quests
                            local skipQuest = false
                            if questIDs then
                                skipQuest = IsNeededForQuest(questIDs)
                            end

                            if not skipQuest then
                                local totalCount = ns.GetItemCount(id)

                                if inHappyBracket then
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
                                        bestID = id
                                        bestLink = info.hyperlink
                                        bestLevel = foodLevel
                                        bestPrice = sellPrice
                                        bestCount = totalCount
                                    end
                                else
                                    --[[
                                        Fallback (food above pet level). No upper cap:
                                        pets will eat food at any level higher than their
                                        own (confirmed: lvl-8 cat eats lvl-70 meat). Prefer
                                        closest to pet level (lowest), then cheapest, then
                                        fewest in bags.
                                    ]]
                                    local isBetter = false
                                    if not fallbackID then
                                        isBetter = true
                                    elseif foodLevel ~= fallbackLevel then
                                        isBetter = foodLevel < fallbackLevel
                                    elseif sellPrice ~= fallbackPrice then
                                        isBetter = sellPrice < fallbackPrice
                                    else
                                        isBetter = totalCount < fallbackCount
                                    end

                                    if isBetter then
                                        fallbackID = id
                                        fallbackLink = info.hyperlink
                                        fallbackLevel = foodLevel
                                        fallbackPrice = sellPrice
                                        fallbackCount = totalCount
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if bestID then
        ns.BestPetFoodID = bestID
        ns.BestPetFoodLink = bestLink
    else
        ns.BestPetFoodID = fallbackID
        ns.BestPetFoodLink = fallbackLink
    end
end
