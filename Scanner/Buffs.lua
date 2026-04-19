local _, ns = ...

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

ns.ScrollOverrideID = nil
ns.PetBuffOverrideID = nil

--------------------------------------------------------------------------------
-- Well Fed
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

--------------------------------------------------------------------------------
-- Scroll Buffs
--
-- A scroll buff of any rank counts as covered. A conflict spell (e.g. Fort)
-- only counts as covered if its base amount is at least as large as the
-- scroll we would use — otherwise the scroll would still improve the stat.
--------------------------------------------------------------------------------

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

-- Returns the item ID of the first scroll that should be used, or nil.
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
-- Pet Food Buffs
--------------------------------------------------------------------------------

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

-- Returns the item ID of the pet food buff that should be used, or nil.
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

    if petTypes.KiblersBits
        and bagItemCounts[ns.KIBLERS_BITS_ITEM_ID]
        and bagItemCounts[ns.KIBLERS_BITS_ITEM_ID] > 0
    then
        return ns.KIBLERS_BITS_ITEM_ID
    end

    if petTypes.SporelingSnacks
        and bagItemCounts[ns.SPORELING_SNACKS_ITEM_ID]
        and bagItemCounts[ns.SPORELING_SNACKS_ITEM_ID] > 0
    then
        return ns.SPORELING_SNACKS_ITEM_ID
    end

    return nil
end
