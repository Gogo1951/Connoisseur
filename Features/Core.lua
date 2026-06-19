local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
local isUpdatePending = false
local updateTimer = 0
local UPDATE_THROTTLE = 0.5

--------------------------------------------------------------------------------
-- Diagnostics State
--------------------------------------------------------------------------------

--[[
    Runtime-only diagnostics state — never persisted to SavedVariables, so it
    starts false every login and needs no teardown. The dispatcher reads
    ns.diagnostics.logging first (see OnEvent) so logging-off costs one boolean
    check. Features/Diagnostics.lua owns ns:LogEvent / ns:StopEventLog.
]]
ns.diagnostics = {enabled = false, logging = false, log = nil}

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

local function GetVersion()
    local version =
        C_AddOns and C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version") or GetAddOnMetadata(ADDON_NAME, "Version")
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
    if not defaults then
        return
    end
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
-- Initialization
--------------------------------------------------------------------------------

local varsInitialized = false

--[[
    One-time, session-constant setup: race/class detection, spell-name caches,
    the conjure-spell existence cache, profession skills, and the minimap
    button. None of these change during a session, so they resolve once and the
    event handlers (PLAYER_LEVEL_UP, SPELLS_CHANGED, SKILL_LINES_CHANGED) keep
    the level-dependent pieces fresh afterward. Called by InitVars after
    ConnoisseurDB exists, so LDBIcon gets its saved minimap position.
]]
local function InitSessionConstants()
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
    ns.IsHunter = (classToken == "HUNTER")
    ns.IsDruid = (classToken == "DRUID")
    ns.IsMage = (classToken == "MAGE")
    ns.IsWarlock = (classToken == "WARLOCK")

    if ns.IsDruid then
        -- Dire Bear was merged into Bear Form in Cataclysm; resolve whichever exists.
        ns.DruidBearFormName =
            GetSpellInfo(ns.DRUID_DIRE_BEAR_FORM_SPELL_ID) or GetSpellInfo(ns.DRUID_BEAR_FORM_SPELL_ID)
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
        LDBIcon:Register(ns.LOCALE_NAME, ns.LDBObj, ConnoisseurDB.minimap)
        ns.IconRegistered = true
    end
end

local function InitVars()
    ConnoisseurDB = ConnoisseurDB or {}
    --[[
        Account-wide defaults (welcome message, minimap button, macro enablement) fill through the
        same additive ApplyDefaults merge as the per-character settings below --
        only nil fields are filled, so saved values are preserved. They live in
        ConnoisseurDB, not the per-character ConnoisseurCharDB.settings. The
        minimap subtable is created explicitly first so LibDBIcon always has a
        table to register against regardless of the defaults; the merge then
        seeds its hide flag.
    ]]
    ConnoisseurDB.minimap = ConnoisseurDB.minimap or {}
    ApplyDefaults(ConnoisseurDB, ns.DEFAULT_ACCOUNT_CONFIGURATION)

    ConnoisseurCharDB = ConnoisseurCharDB or {}
    ConnoisseurCharDB.ignoreList = ConnoisseurCharDB.ignoreList or {}
    ConnoisseurCharDB.settings = ConnoisseurCharDB.settings or {}

    ApplyDefaults(ConnoisseurCharDB.settings, ns.DEFAULT_CONFIGURATION)

    -- Invalidate item cache on version change
    if ConnoisseurDB.itemCacheVersion ~= ns.Version then
        ConnoisseurDB.itemCache = {}
        ConnoisseurDB.itemCacheVersion = ns.Version
    else
        ConnoisseurDB.itemCache = ConnoisseurDB.itemCache or {}
    end

    ns.CachedPlayerLevel = UnitLevel("player") or 1
    ns.CachedMapID = C_Map.GetBestMapForUnit("player")

    --[[
        Session-constant work runs once. Everything above this gate refreshes
        every call — SavedVariables existence and the cached level/zone, which
        change between logins and as the player levels and zones.
    ]]
    if not varsInitialized then
        varsInitialized = true
        InitSessionConstants()
    end

    --[[
        QUEST_LOG_UPDATE fires very frequently, and the only consumer of quest
        data is Hunter pet-food quest-objective skipping (ScanPetFood via
        BuildActiveQuestSet). Register it only for hunters so everyone else
        doesn't pay for a full bag rescan + macro rebuild on every quest-log
        churn. Kept per-call (idempotent) so registration follows ns.IsHunter.
    ]]
    if ns.IsHunter then
        frame:RegisterEvent("QUEST_LOG_UPDATE")
    else
        frame:UnregisterEvent("QUEST_LOG_UPDATE")
    end
end

--------------------------------------------------------------------------------
-- Reset
--------------------------------------------------------------------------------

function ns.ResetSettings()
    if not ConnoisseurCharDB then
        return
    end

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

    ApplyDefaults(ConnoisseurCharDB.settings, ns.DEFAULT_CONFIGURATION)

    --[[
        enabledMacros is account-wide (see Default-Settings.lua), so reset it
        here too -- "Reset All" should still restore macro enablement. showWelcome
        and the minimap subtable are left untouched, like every account-wide pref.
    ]]
    if ConnoisseurDB then
        ConnoisseurDB.enabledMacros = ConnoisseurDB.enabledMacros or {}
        wipe(ConnoisseurDB.enabledMacros)
        ApplyDefaults(ConnoisseurDB.enabledMacros, ns.DEFAULT_ACCOUNT_CONFIGURATION.enabledMacros)
    end

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
    local scrollsActive = settings.useScrolls and ns.IsModeActive(settings.scrollsMode)
    local petBuffActive = settings.usePetBuffFood and ns.IsModeActive(settings.petBuffFoodMode)

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
    C_Timer.After(
        2,
        function()
            ns.RequestUpdate()
        end
    )
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

frame:SetScript(
    "OnEvent",
    function(self, event, ...)
        -- Diagnostics event-log tap; the boolean is read first so logging-off is free.
        if ns.diagnostics.logging then
            ns:LogEvent(event, ...)
        end

        --[[
        Initialization must run regardless of combat state, so it is handled
        ahead of the lockdown guard below. PLAYER_LOGIN is the earliest safe
        point (SavedVariables are loaded) and fires before the first
        PLAYER_ENTERING_WORLD. InitVars touches no protected functions and is
        idempotent, so running it here guarantees the DB exists even when the
        player enters the world already in combat (e.g. zoning into an
        in-progress battleground) — a case the guard would otherwise swallow,
        leaving ConnoisseurDB/ConnoisseurCharDB nil until the next out-of-combat
        PLAYER_ENTERING_WORLD.
    ]]
        if event == "PLAYER_LOGIN" then
            InitVars()
            return
        end

        --[[
        UI_ERROR_MESSAGE is also handled ahead of the lockdown guard: both
        of its consumers must work mid-combat and neither touches protected
        functions. The wrong-zone report mostly fires when a zone-locked
        potion is pressed mid-fight — exactly when the guard below would
        swallow it — and the dead-pet branch only flips a flag plus
        RequestUpdate, whose OnUpdate handler already defers macro writes
        until combat drops.
    ]]
        if event == "UI_ERROR_MESSAGE" then
            local _, msg = ...

            if ns.HandleHunterPetError then
                ns.HandleHunterPetError(msg)
            end

            if ns.ReportZoneRestriction then
                ns.ReportZoneRestriction(msg)
            end
            return
        end

        --[[
        Leveling changes which items, scrolls, and spells qualify, so a
        level-up forces a full rebuild of every macro. Refresh the cached level
        and hunter spell names here, above the combat lockdown guard, because a
        ding from a killing blow fires PLAYER_LEVEL_UP in combat, and UnitLevel
        / GetSpellInfo are safe combat reads. Wiping the macro state forces
        every macro to rewrite; the write itself still defers to the
        post-combat tick via the throttled update.
    ]]
        if event == "PLAYER_LEVEL_UP" then
            ns.CachedPlayerLevel = UnitLevel("player") or ns.CachedPlayerLevel or 1
            if ns.IsHunter then
                ns.ResolveHunterSpells()
            end
            if ns.ResetMacroState then
                ns.ResetMacroState()
            end
            ns.RequestUpdate()
            return
        end

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

        if
            event == "BAG_UPDATE_DELAYED" or event == "ITEM_PUSH" or event == "PLAYER_TARGET_CHANGED" or
                event == "GET_ITEM_INFO_RECEIVED" or
                event == "PLAYER_ALIVE" or
                event == "PLAYER_UNGHOST" or
                event == "GROUP_ROSTER_UPDATE" or
                event == "QUEST_LOG_UPDATE"
         then
            ns.RequestUpdate()
        elseif event == "ZONE_CHANGED_NEW_AREA" then
            ns.CachedMapID = C_Map.GetBestMapForUnit("player")
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
            ns.PrintWelcome()
            ns.UpdateAuraTracking()
            ns.RequestUpdate()
            C_Timer.After(
                3,
                function()
                    ns.RequestUpdate()
                end
            )
        elseif event == "SKILL_LINES_CHANGED" then
            if ns.UpdateFirstAidSkill then
                ns.UpdateFirstAidSkill()
            end
            if ns.UpdateAlchemySkill then
                ns.UpdateAlchemySkill()
            end
            ns.RequestUpdate()
        elseif event == "UNIT_AURA" then
            if ns.HandleUnitAura then
                ns.HandleUnitAura(...)
            end
        elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            local _, _, spellID = ...
            if ns.SpellCache and ns.SpellCache[spellID] then
                ns.RequestUpdate()
            end
        elseif event == "UNIT_PET" then
            if ns.HandlePetChanged then
                ns.HandlePetChanged(...)
            end
        elseif event == "PLAYER_LOGOUT" then
            if ns.PruneIgnoreList then
                ns.PruneIgnoreList()
            end
        end
    end
)

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

--[[
    Every event name the add-on uses, in one list. The dispatcher registers the
    plain events from it, and Diagnostics' Event Registration check reads the
    same list, so the two can never drift. Unit-filtered and on-demand events
    are registered separately below but still appear here so the validity check
    covers them too.
]]
ns.CORE_EVENTS = {
    "BAG_UPDATE_DELAYED",
    "ITEM_PUSH",
    "PLAYER_ALIVE",
    "PLAYER_ENTERING_WORLD",
    "PLAYER_LEVEL_UP",
    "PLAYER_LOGIN",
    "PLAYER_LOGOUT",
    "PLAYER_REGEN_ENABLED",
    "PLAYER_TARGET_CHANGED",
    "PLAYER_UNGHOST",
    "UI_ERROR_MESSAGE",
    "ZONE_CHANGED_NEW_AREA",
    "SKILL_LINES_CHANGED",
    "SPELLS_CHANGED",
    "GROUP_ROSTER_UPDATE",
    "UNIT_PET",
    "UNIT_SPELLCAST_SUCCEEDED",
    "UNIT_AURA",
    "QUEST_LOG_UPDATE",
    "GET_ITEM_INFO_RECEIVED"
}

--[[
    Names NOT registered by the plain loop: unit-filtered events use
    RegisterUnitEvent, and the on-demand events are registered only while needed
    (UNIT_AURA via UpdateAuraTracking, QUEST_LOG_UPDATE for hunters in InitVars,
    GET_ITEM_INFO_RECEIVED via RegisterDataRetry).
]]
local DEFERRED_EVENTS = {
    UNIT_PET = true,
    UNIT_SPELLCAST_SUCCEEDED = true,
    UNIT_AURA = true,
    QUEST_LOG_UPDATE = true,
    GET_ITEM_INFO_RECEIVED = true
}

for _, event in ipairs(ns.CORE_EVENTS) do
    if not DEFERRED_EVENTS[event] then
        frame:RegisterEvent(event)
    end
end

frame:RegisterUnitEvent("UNIT_PET", "player")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")

--[[
    QUEST_LOG_UPDATE is registered dynamically in InitVars — Hunters only.
    It is the only event whose sole consumer is Hunter pet-food quest-skipping,
    and it fires too often to justify a full rescan on non-Hunter characters.
]]