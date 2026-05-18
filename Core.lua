local addonName, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--[[
    Cross-client item API shims. Retail exposes these on C_Item; Classic /
    TBC only expose the globals. Resolving once at load keeps call sites
    branch-free and avoids "attempt to index nil" errors on Classic.
]]
ns.GetItemCount = (C_Item and C_Item.GetItemCount) or GetItemCount
ns.GetItemIcon  = (C_Item and C_Item.GetItemIconByID) or GetItemIcon

--[[
    Transport between the /run snippet in consumable macros and the
    UI_ERROR_MESSAGE handler. The macro writes lastID and lastTime so
    we can correlate a zone-restriction error back to its triggering item.
]]
ConnoisseurState = ConnoisseurState or {}

--[[
    Tiny helper exposed as a global so macro bodies can record the firing
    item with `/run ConnFire(itemID)` instead of inlining a longer
    snippet. That savings matters when stacking scroll uses against the
    255-character macro body limit.

    Name choice: 8 characters, distinctive "Conn" prefix to avoid collisions
    with two-letter or generic globals other addons might define.
]]
function ConnFire(itemID)
    ConnoisseurState.lastID = itemID
    ConnoisseurState.lastTime = GetTime()
end

--[[
    Resolves a ConnTip key to its display text. Static messages come from
    ns.MessageStrings; "you don't know <spell>" keys come from
    ns.MissingSpellMessageIDs and are rendered with the localized spell
    name via GetSpellInfo at print time. A spell that doesn't exist on the
    current client returns nil here so ConnTip silently skips rather than
    naming a spell the player will never see.
]]
local function ResolveConnTip(key)
    if ns.MessageStrings and ns.MessageStrings[key] then
        return ns.MessageStrings[key]
    end
    if ns.MissingSpellMessageIDs and ns.MissingSpellMessageIDs[key] then
        local name = GetSpellInfo(ns.MissingSpellMessageIDs[key])
        if not name then return nil end
        return "You don't currently know " .. name .. "."
    end
    return nil
end

function ConnTip(key)
    local text = ResolveConnTip(key)
    if text then
        ns.PrintMessage(text)
    end
end

--[[
    Conditional sibling of ConnTip — fires the tip only when the macro
    conditional `cond` matches. Used by the Feed Pet macro for level-10/11
    hunters who don't know Mend Pet yet, so right-click or in-combat clicks
    print an explanation instead of silently doing nothing useful. We append
    a sentinel " 1" so SecureCmdOptionParse returns "1" on match and nil on
    miss — clean truthy/falsy semantics regardless of how the API treats an
    empty action body.
]]
function ConnIf(cond, key)
    if SecureCmdOptionParse(cond .. " 1") then
        ConnTip(key)
    end
end

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
local isUpdatePending = false
local updateTimer = 0
local UPDATE_THROTTLE = 0.5

--------------------------------------------------------------------------------
-- Chat Output
--------------------------------------------------------------------------------

function ns.PrintMessage(text)
    print(
        GetColor("INFO") .. L["BRAND"] .. "|r " ..
        GetColor("SEPARATOR") .. "//" .. "|r " ..
        GetColor("TEXT") .. text .. "|r"
    )
end

--[[
    PLAYER_ENTERING_WORLD fires on instance transitions and reloads, not
    just initial login. Guard with a flag so the welcome lands once per
    session.
]]
local welcomePrinted = false

local function PrintWelcome()
    if welcomePrinted then return end
    if not (ConnoisseurDB and ConnoisseurDB.showWelcome) then return end
    welcomePrinted = true
    ns.PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
end

--------------------------------------------------------------------------------
-- Utility
--------------------------------------------------------------------------------

function ns.IsModeActive(mode)
    if mode == "always" then
        return true
    end
    if mode == "party" then
        return IsInGroup()
    end
    if mode == "raid" then
        return IsInRaid()
    end
    return true
end

function ns.KnowsAny(spellList)
    if not spellList then
        return false
    end
    for _, data in ipairs(spellList) do
        if IsSpellKnown(data[1]) then
            return true
        end
    end
    return false
end

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
-- Defaults
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

--------------------------------------------------------------------------------
-- Hunter Pet Spell Resolution
--------------------------------------------------------------------------------

--[[
    Resolves each pet spell's name only if the player actually knows the spell.
    GetSpellInfo returns a name even for unlearned spells, so a level-8 hunter
    without Mend Pet would otherwise get a macro referencing a spell they can't
    cast. Re-run on PLAYER_LEVEL_UP and SPELLS_CHANGED so newly-learned spells
    (Mend Pet at 12) start participating in the macro without a /reload.
]]
local function ResolveIfKnown(spellID)
    local known = IsSpellKnown(spellID)
    if not known and IsPlayerSpell then
        known = IsPlayerSpell(spellID)
    end
    if known then
        return GetSpellInfo(spellID)
    end
    return nil
end

function ns.ResolveHunterSpells()
    if not ns.IsHunter then return end
    ns.FeedPetSpellName    = ResolveIfKnown(ns.FEED_PET_SPELL_ID)
    ns.RevivePetSpellName  = ResolveIfKnown(ns.REVIVE_PET_SPELL_ID)
    ns.MendPetSpellName    = ResolveIfKnown(ns.MEND_PET_SPELL_ID)
    ns.CallPetSpellName    = ResolveIfKnown(ns.CALL_PET_SPELL_ID)
    ns.DismissPetSpellName = ResolveIfKnown(ns.DISMISS_PET_SPELL_ID)
end

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

local function InitVars()
    ConnoisseurDB = ConnoisseurDB or {}
    --[[
        Booleans need an explicit nil check; `or true` would clobber a
        user's saved `false`. Initialize before migrations so legacy paths
        can rely on the field existing.
    ]]
    if ConnoisseurDB.showWelcome == nil then ConnoisseurDB.showWelcome = true end

    ConnoisseurCharDB = ConnoisseurCharDB or {}
    ConnoisseurCharDB.ignoreList = ConnoisseurCharDB.ignoreList or {}
    ConnoisseurCharDB.settings = ConnoisseurCharDB.settings or {}

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

    --[[
        Class detection. Used by macro builders to decide which conjure
        branches the player could *eventually* know — so a low-level mage
        gets "You don't currently know Conjure Food." while a hunter sees no
        message at all (they'll never learn that spell).
    ]]
    local _, classToken = UnitClass("player")
    ns.IsHunter  = (classToken == "HUNTER")
    ns.IsDruid   = (classToken == "DRUID")
    ns.IsMage    = (classToken == "MAGE")
    ns.IsWarlock = (classToken == "WARLOCK")

    if ns.IsDruid then
        -- Dire Bear was merged into Bear Form in Cataclysm; resolve whichever exists.
        ns.DruidBearFormName = GetSpellInfo(ns.DRUID_DIRE_BEAR_FORM_SPELL_ID)
            or GetSpellInfo(ns.DRUID_BEAR_FORM_SPELL_ID)
        ns.DruidCatFormName = GetSpellInfo(ns.DRUID_CAT_FORM_SPELL_ID)
    end

    if ns.IsHunter then
        ns.ResolveHunterSpells()
        ns.PetDeadDismissed = false
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
-- Reset
--------------------------------------------------------------------------------

function ns.ResetSettings()
    if not ConnoisseurCharDB then return end

    --[[
        Wipe per-character user state in place, preserving the table
        references held by other modules.
    ]]
    if ConnoisseurCharDB.ignoreList then
        wipe(ConnoisseurCharDB.ignoreList)
    end
    if ConnoisseurCharDB.settings then
        wipe(ConnoisseurCharDB.settings)
    else
        ConnoisseurCharDB.settings = {}
    end

    -- Rebuild the item cache from scratch on next scan
    if ConnoisseurDB and ConnoisseurDB.itemCache then
        wipe(ConnoisseurDB.itemCache)
    end

    ApplyDefaults(ConnoisseurCharDB.settings, ns.SETTINGS_DEFAULTS)

    ns.UpdateAuraTracking()
    if ns.ResetMacroState then
        ns.ResetMacroState()
    end
    if ns.UpdateMacros then
        ns.UpdateMacros(true)
    end
end

--------------------------------------------------------------------------------
-- Feature Toggles
--------------------------------------------------------------------------------

--[[
    Each toggle accepts an optional value. No argument flips the current state
    (minimap click path). A boolean argument sets state directly (options-panel
    path) and matches what AceConfig hands back to the set callback.
]]

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

function ns.ToggleBuffFood(value)
    local settings = ConnoisseurCharDB.settings
    if value == nil then
        settings.useBuffFood = not settings.useBuffFood
    else
        settings.useBuffFood = value
    end
    ns.UpdateAuraTracking()
    if ns.ResetMacroState then
        ns.ResetMacroState()
    end
    ns.RequestUpdate()
end

function ns.ToggleScrollBuffs(value)
    local settings = ConnoisseurCharDB.settings
    if value == nil then
        settings.useScrolls = not settings.useScrolls
    else
        settings.useScrolls = value
    end
    ns.UpdateAuraTracking()
    if ns.ResetMacroState then
        ns.ResetMacroState()
    end
    ns.RequestUpdate()
end

function ns.ToggleShadowmeldDrinking(value)
    local settings = ConnoisseurCharDB.settings
    if value == nil then
        settings.enableShadowmeldDrinking = not settings.enableShadowmeldDrinking
    else
        settings.enableShadowmeldDrinking = value
    end
    if ns.ResetMacroState then
        ns.ResetMacroState()
    end
    ns.RequestUpdate()
end

function ns.ToggleDruidMacroHelper(value)
    local settings = ConnoisseurCharDB.settings
    if value == nil then
        settings.enableDruidMacroHelper = not settings.enableDruidMacroHelper
    else
        settings.enableDruidMacroHelper = value
    end
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
        or event == "QUEST_LOG_UPDATE"
    then
        ns.RequestUpdate()
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        ns.CachedMapID = C_Map.GetBestMapForUnit("player")
        ns.RequestUpdate()
    elseif event == "PLAYER_LEVEL_UP" then
        ns.CachedPlayerLevel = UnitLevel("player") or 1
        if ns.IsHunter then
            ns.ResolveHunterSpells()
        end
        ns.RequestUpdate()
    elseif event == "SPELLS_CHANGED" then
        --[[
            Hunter spell-name cache refreshes here so a level-up training
            visit (e.g. Mend Pet at 12) starts participating in the macro
            immediately. Mages/warlocks don't have a name cache, but their
            macro bodies still depend on KnowsAny / GetSmartSpell results,
            so we trigger a generic rebuild for everyone.
        ]]
        if ns.IsHunter then
            ns.ResolveHunterSpells()
        end
        ns.RequestUpdate()
    elseif event == "PLAYER_ENTERING_WORLD" then
        InitVars()
        PrintWelcome()
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

        --[[
            Hunter: detect dead-but-dismissed pet.
            When Call Pet fails because the pet is dead, the client fires
            SPELL_FAILED_TARGETS_DEAD. We catch it here and flip the flag
            so the macro rebuilds with Revive Pet on the next cycle.
            If the error ID changes in a future build, update this check.
        ]]
        if ns.IsHunter and not UnitExists("pet") and msg then
            local deadMsg = SPELL_FAILED_TARGETS_DEAD
            if deadMsg and msg == deadMsg then
                ns.PetDeadDismissed = true
                ns.RequestUpdate()
            end
        end

        --[[
            Zone-restriction reporting. The macro's /run snippet writes
            lastID and lastTime via ConnFire(). If we see
            ERR_ITEM_WRONG_ZONE within one second of a macro firing, we
            know which item to blame.
        ]]
        if ConnoisseurState.lastTime and (GetTime() - ConnoisseurState.lastTime) < 1.0 then
            if msg == ERR_ITEM_WRONG_ZONE then
                local mapID = C_Map.GetBestMapForUnit("player") or "0"
                local zone = GetZoneText() or "?"
                local subzone = GetSubZoneText() or ""
                if subzone == "" then
                    subzone = zone
                end

                local itemID = ConnoisseurState.lastID or 0
                local link = "Item #" .. itemID
                if itemID ~= 0 then
                    local _, itemLink = GetItemInfo(itemID)
                    if itemLink then
                        link = itemLink
                    end
                end

                ns.PrintMessage(string.format(L["MSG_BUG_REPORT"], link, itemID, zone, subzone, mapID))
                ConnoisseurState.lastTime = 0
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
frame:RegisterEvent("SPELLS_CHANGED")
frame:RegisterEvent("UNIT_PET")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("QUEST_LOG_UPDATE")
