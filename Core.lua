local addonName, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
local isUpdatePending = false
local updateTimer = 0
local UPDATE_THROTTLE = 0.5

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

local function GetVersion()
    local version = C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Version")
        or GetAddOnMetadata(addonName, "Version")
    if not version or version:find("@") then
        return "Dev"
    end
    return version
end

ns.Version = GetVersion()

--------------------------------------------------------------------------------
-- Saved Variable Migration
--------------------------------------------------------------------------------

local function MigrateFromLegacy()
    -- Account-wide: CC_MinimapSettings → ConnoisseurDB.minimap
    if CC_MinimapSettings and next(CC_MinimapSettings) then
        ConnoisseurDB.minimap = CC_MinimapSettings
    end
    CC_MinimapSettings = nil

    -- Account-wide: CC_ItemCache → ConnoisseurDB.itemCache
    if CC_ItemCache then
        ConnoisseurDB.itemCache = CC_ItemCache
    end
    CC_ItemCache = nil

    if CC_ItemCacheVersion then
        ConnoisseurDB.itemCacheVersion = CC_ItemCacheVersion
    end
    CC_ItemCacheVersion = nil

    -- Per-character: CC_IgnoreList → ConnoisseurCharDB.ignoreList
    if CC_IgnoreList and next(CC_IgnoreList) then
        ConnoisseurCharDB.ignoreList = CC_IgnoreList
    end
    CC_IgnoreList = nil

    -- Per-character: CC_Settings → ConnoisseurCharDB.settings
    if CC_Settings then
        if CC_Settings.UseBuffFood then
            ConnoisseurCharDB.settings.useBuffFood = true
        end
        CC_Settings.Minimap = nil
    end
    CC_Settings = nil
end

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

local function ApplyDefaults(target, defaults)
    if not defaults then return end
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            ApplyDefaults(target[key], value)
        elseif target[key] == nil then
            target[key] = value
        end
    end
end

local function InitVars()
    ConnoisseurDB = ConnoisseurDB or {}
    ConnoisseurCharDB = ConnoisseurCharDB or {}
    ConnoisseurCharDB.ignoreList = ConnoisseurCharDB.ignoreList or {}
    ConnoisseurCharDB.settings = ConnoisseurCharDB.settings or {}

    if CC_MinimapSettings or CC_ItemCache or CC_IgnoreList or CC_Settings then
        MigrateFromLegacy()
    end

    ConnoisseurDB.minimap = ConnoisseurDB.minimap or {}

    ApplyDefaults(ConnoisseurCharDB.settings, ns.SETTINGS_DEFAULTS)

    -- Invalidate item cache on version change
    if ConnoisseurDB.itemCacheVersion ~= ns.Version then
        ConnoisseurDB.itemCache = {}
        ConnoisseurDB.itemCacheVersion = ns.Version
    else
        ConnoisseurDB.itemCache = ConnoisseurDB.itemCache or {}
    end

    ns.CachedPlayerLevel = UnitLevel("player") or 1
    ns.CachedMapID = C_Map.GetBestMapForUnit("player")

    local _, raceToken = UnitRace("player")
    ns.IsNightElf = (raceToken == "NightElf")

    -- Resolve the Shadowmeld spell name once for macro building
    if ns.IsNightElf then
        ns.ShadowmeldSpellName = GetSpellInfo(ns.SHADOWMELD_SPELL_ID)
    end

    -- Hunter detection and pet spell resolution
    local _, classToken = UnitClass("player")
    ns.IsHunter = (classToken == "HUNTER")

    if ns.IsHunter then
        ns.FeedPetSpellName    = GetSpellInfo(ns.FEED_PET_SPELL_ID)
        ns.RevivePetSpellName  = GetSpellInfo(ns.REVIVE_PET_SPELL_ID)
        ns.MendPetSpellName    = GetSpellInfo(ns.MEND_PET_SPELL_ID)
        ns.CallPetSpellName    = GetSpellInfo(ns.CALL_PET_SPELL_ID)
        ns.DismissPetSpellName = GetSpellInfo(ns.DISMISS_PET_SPELL_ID)
        ns.PetDeadDismissed    = false
    end

    ns.SpellCache = {}
    if ns.ConjureSpells then
        for _, spellList in pairs(ns.ConjureSpells) do
            for _, data in ipairs(spellList) do
                local spellID = data[1]
                if GetSpellInfo(spellID) then
                    ns.SpellCache[spellID] = true
                end
            end
        end
    end

    if ns.UpdateFirstAidSkill then
        ns.UpdateFirstAidSkill()
    end
    if ns.UpdateAlchemySkill then
        ns.UpdateAlchemySkill()
    end

    local LDBIcon = LibStub("LibDBIcon-1.0")
    if LDBIcon and ns.LDBObj and not ns.IconRegistered then
        LDBIcon:Register("Connoisseur", ns.LDBObj, ConnoisseurDB.minimap)
        ns.IconRegistered = true
    end
end

--------------------------------------------------------------------------------
-- Feature Toggles
--------------------------------------------------------------------------------

function ns.UpdateAuraTracking()
    local settings = ConnoisseurCharDB.settings

    local buffFoodActive = settings.useBuffFood and ns.IsModeActive(settings.buffFoodMode)
    local scrollsActive  = settings.useScrolls and ns.IsModeActive(settings.scrollsMode)
    local petBuffActive  = settings.usePetBuffFood and ns.IsModeActive(settings.petBuffFoodMode)

    if buffFoodActive or scrollsActive then
        ns.WellFedState = ns.HasWellFedBuff and ns.HasWellFedBuff() or false
    else
        ns.WellFedState = false
    end

    if buffFoodActive or scrollsActive or petBuffActive then
        frame:RegisterUnitEvent("UNIT_AURA", "player", "pet")
    else
        frame:UnregisterEvent("UNIT_AURA")
    end
end

function ns.ToggleBuffFood()
    local settings = ConnoisseurCharDB.settings
    settings.useBuffFood = not settings.useBuffFood
    ns.UpdateAuraTracking()
    if ns.ResetMacroState then
        ns.ResetMacroState()
    end
    ns.RequestUpdate()
end

function ns.ToggleScrollBuffs()
    local settings = ConnoisseurCharDB.settings
    settings.useScrolls = not settings.useScrolls
    ns.UpdateAuraTracking()
    if ns.ResetMacroState then
        ns.ResetMacroState()
    end
    ns.RequestUpdate()
end

function ns.ToggleShadowmeldDrinking()
    local settings = ConnoisseurCharDB.settings
    settings.enableShadowmeldDrinking = not settings.enableShadowmeldDrinking
    if ns.ResetMacroState then
        ns.ResetMacroState()
    end
    ns.RequestUpdate()
end

--------------------------------------------------------------------------------
-- Update Throttling
--------------------------------------------------------------------------------

function ns.RegisterDataRetry()
    frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    C_Timer.After(2, function()
        ns.RequestUpdate()
    end)
end

function ns.UnregisterDataRetry()
    frame:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
end

local function OnUpdateHandler(self, elapsed)
    if InCombatLockdown() then
        frame:SetScript("OnUpdate", nil)
        isUpdatePending = true
        return
    end

    updateTimer = updateTimer + elapsed
    if updateTimer > UPDATE_THROTTLE then
        frame:SetScript("OnUpdate", nil)
        isUpdatePending = false
        if ns.UpdateMacros then
            ns.UpdateMacros()
        end
    end
end

function ns.RequestUpdate()
    if not isUpdatePending then
        isUpdatePending = true
        updateTimer = 0
        frame:SetScript("OnUpdate", OnUpdateHandler)
    end
end

--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

frame:SetScript("OnEvent", function(self, event, ...)
    if InCombatLockdown() then
        isUpdatePending = true
        return
    end

    if event == "PLAYER_REGEN_ENABLED" then
        if isUpdatePending then
            isUpdatePending = false
            ns.RequestUpdate()
        end
        return
    end

    if event == "BAG_UPDATE_DELAYED"
        or event == "ITEM_PUSH"
        or event == "PLAYER_TARGET_CHANGED"
        or event == "GET_ITEM_INFO_RECEIVED"
        or event == "PLAYER_ALIVE"
        or event == "PLAYER_UNGHOST"
        or event == "GROUP_ROSTER_UPDATE"
    then
        ns.RequestUpdate()
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        ns.CachedMapID = C_Map.GetBestMapForUnit("player")
        ns.RequestUpdate()
    elseif event == "PLAYER_LEVEL_UP" then
        ns.CachedPlayerLevel = UnitLevel("player") or 1
        ns.RequestUpdate()
    elseif event == "PLAYER_ENTERING_WORLD" then
        InitVars()
        ns.UpdateAuraTracking()
        ns.RequestUpdate()
        C_Timer.After(3, function()
            ns.RequestUpdate()
        end)
    elseif event == "SKILL_LINES_CHANGED" then
        if ns.UpdateFirstAidSkill then
            ns.UpdateFirstAidSkill()
        end
        if ns.UpdateAlchemySkill then
            ns.UpdateAlchemySkill()
        end
        ns.RequestUpdate()
    elseif event == "UNIT_AURA" then
        local needsUpdate = false
        local unit = ...

        if unit == "player" then
            if ns.HasWellFedBuff then
                local currentState = ns.HasWellFedBuff()
                if currentState ~= ns.WellFedState then
                    ns.WellFedState = currentState
                    needsUpdate = true
                end
            end

            if ConnoisseurCharDB and ConnoisseurCharDB.settings and ConnoisseurCharDB.settings.useScrolls then
                needsUpdate = true
            end
        elseif unit == "pet" then
            if ConnoisseurCharDB and ConnoisseurCharDB.settings and ConnoisseurCharDB.settings.usePetBuffFood then
                needsUpdate = true
            end
        end

        if needsUpdate then
            ns.RequestUpdate()
        end
        
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local _, _, spellID = ...
        if ns.SpellCache and ns.SpellCache[spellID] then
            ns.RequestUpdate()
        end
    elseif event == "UNIT_PET" then
        local unit = ...
        if unit == "player" then
            -- Pet appeared or changed: clear the dead-dismissed flag
            if ns.IsHunter and UnitExists("pet") and not UnitIsDead("pet") then
                ns.PetDeadDismissed = false
            end
            ns.RequestUpdate()
        end
    elseif event == "UI_ERROR_MESSAGE" then
        local _, msg = ...

        -- Hunter: detect dead-but-dismissed pet
        -- When Call Pet fails because the pet is dead, the client fires
        -- SPELL_FAILED_TARGETS_DEAD. We catch it here and flip the flag
        -- so the macro rebuilds with Revive Pet on the next cycle.
        -- If the error ID changes in a future build, update this check.
        if ns.IsHunter and not UnitExists("pet") and msg then
            local deadMsg = SPELL_FAILED_TARGETS_DEAD
            if deadMsg and msg == deadMsg then
                ns.PetDeadDismissed = true
                ns.RequestUpdate()
            end
        end

        -- Existing zone-error reporting for consumables
        if CC_LastTime and (GetTime() - CC_LastTime) < 1.0 then
            if msg == ERR_ITEM_WRONG_ZONE then
                local mapID = C_Map.GetBestMapForUnit("player") or "0"
                local zone = GetZoneText() or "?"
                local subzone = GetSubZoneText() or ""
                if subzone == "" then
                    subzone = zone
                end

                local itemID = CC_LastID or 0
                local link = "Item #" .. itemID
                if itemID ~= 0 then
                    local _, itemLink = GetItemInfo(itemID)
                    if itemLink then
                        link = itemLink
                    end
                end

                print(
                    GetColor("INFO") .. L["BRAND"] .. GetColor("MUTED") .. " // " ..
                    GetColor("TEXT") .. string.format(L["MSG_BUG_REPORT"], link, itemID, zone, subzone, mapID)
                )
                CC_LastTime = 0
            end
        end
    elseif event == "PLAYER_LOGOUT" then
        if ns.IsKnownConsumable then
            local ignoreList = ConnoisseurCharDB and ConnoisseurCharDB.ignoreList or {}
            for itemID in pairs(ignoreList) do
                if not ns.IsKnownConsumable(itemID) then
                    ignoreList[itemID] = nil
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- Event Registration
--------------------------------------------------------------------------------

frame:RegisterEvent("BAG_UPDATE_DELAYED")
frame:RegisterEvent("ITEM_PUSH")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:RegisterEvent("UI_ERROR_MESSAGE")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("SKILL_LINES_CHANGED")
frame:RegisterEvent("UNIT_PET")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")