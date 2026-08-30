local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local frame = CreateFrame("Frame")

--[[
    Two-flag throttle. isUpdatePending means "a rescan/rebuild is wanted but
    hasn't been applied yet"; isTickScheduled means "the OnUpdate throttle is
    currently armed." Keeping them separate is what makes the throttle
    self-healing: RequestUpdate re-arms whenever the tick is disarmed, so a
    pending update can never get stranded with no OnUpdate attached — even if a
    combat-exit (PLAYER_REGEN_ENABLED) clear is ever missed, the next
    out-of-combat request re-arms the tick instead of being swallowed.
]]
local isUpdatePending = false
local isTickScheduled = false
local updateTimer = 0
local UPDATE_THROTTLE = 0.5

--[[
    Budget for the cold-item retry below, sized to cover a slow login. Matches
    the cap ns.WarmItemCache spends on the same problem in
    Options/Options-Utilities.lua.
]]
local DATA_RETRY_MAX_ATTEMPTS = 10
local dataRetryAttempts = 0

--------------------------------------------------------------------------------
-- Diagnostics State
--------------------------------------------------------------------------------

--[[
    Runtime-only diagnostics state — never persisted to SavedVariables, so it
    starts false every login and needs no teardown. The dispatcher reads
    ns.diagnostics.logging first (see OnEvent) so logging-off costs one boolean
    check. Features/Diagnostics.lua owns ns.LogEvent / ns.StopEventLog.
]]
ns.diagnostics = { enabled = false, logging = false, log = nil }

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

local function GetVersion()
	local version = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")
	if not version or version:find("@") then
		return "Dev"
	end
	return version
end

ns.Version = GetVersion()

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
    ns.db exists, so LDBIcon gets its saved minimap position.
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
	ns.IsRogue = (classToken == "ROGUE")

	-- Resolve the Stealth spell name once for macro building (Stealth Eating)
	if ns.IsRogue then
		ns.StealthSpellName = GetSpellInfo(ns.STEALTH_SPELL_ID)
	end

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
	if ns.UpdateEngineeringSkill then
		ns.UpdateEngineeringSkill()
	end

	local LDBIcon = LibStub("LibDBIcon-1.0")
	if LDBIcon and ns.LDBObject and not ns.IconRegistered then
		LDBIcon:Register(ns.LOCALE_NAME, ns.LDBObject, ns.db.global.minimap)
		ns.IconRegistered = true
	end
end

local function InitVars()
	if not ns.db then
		--[[
		    One account-wide SavedVariable managed by AceDB-3.0. AceDB:New's
		    third argument (defaultProfile) is deliberately omitted, so every
		    character lands on its own "Name - Realm" profile -- and that is
		    where the settings live, so each character configures its own
		    consumables. The account-wide keys live on ns.db.global instead,
		    each with its reason (see Data/Default-Settings.lua).
		    AceDB applies ns.DATABASE_DEFAULTS itself -- no hand-merge. It
		    copies scalar and table defaults into the saved table (rawset)
		    when a scope is first accessed; only */** wildcard defaults
		    resolve through a metatable.
		]]

		ns.db = LibStub("AceDB-3.0"):New("ConnoisseurDB", ns.DATABASE_DEFAULTS)

		--[[
		    Switching, copying, or resetting a profile now swaps the settings
		    themselves as well as the Ignore List, so the macro bodies and aura
		    tracking must rebuild. Which macros exist does NOT change --
		    enabledMacros is account-wide, like the macros themselves. The
		    account-wide keys survive untouched, but the two applied
		    imperatively (minimap visibility, macro-name text) have to be pushed
		    again from global because nothing else re-reads them, and an open
		    options panel has to be told to redraw.
		]]
		local function OnProfileChange()
			ns.ResetMacroState()
			ns.UpdateAuraTracking()
			if ns.ApplyMacroNameVisibility then
				ns.ApplyMacroNameVisibility()
			end
			if ns.ToggleMinimapButton and ns.db.global.minimap then
				ns.ToggleMinimapButton(not ns.db.global.minimap.hide)
			end
			local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
			for _, appName in pairs(ns.OPTIONS_REGISTRY) do
				AceConfigRegistry:NotifyChange(appName)
			end
			ns.RequestUpdate()
		end
		ns.db.RegisterCallback(ns, "OnProfileChanged", OnProfileChange)
		ns.db.RegisterCallback(ns, "OnProfileCopied", OnProfileChange)
		ns.db.RegisterCallback(ns, "OnProfileReset", OnProfileChange)

		--[[
		    Options registration is deferred to here (rather than at Options.lua
		    load) because the Profiles panel reads its display name from the
		    stock AceDBOptions table, which needs ns.db. Runs once, inside this
		    same not-yet-initialized guard.
		]]
		if ns.InitializeOptions then
			ns.InitializeOptions()
		end
	end

	--[[
	    The Restock List used to live in a saved variable of its own,
	    ConnoisseurRestockerDB, rather than under ns.db.global. Move it in before
	    anything reads the new home -- an upgrading player's lists are still over
	    there, and WoW drops that table from the saved file at the first logout of
	    a build that no longer declares it. Deliberately not guarded on the
	    function existing: this failing quietly is how the lists get lost.

	    RETIRE AFTER 2026-09-29, with the rest of the shim --
	    Features/Restocker/Restocker-Saved-Migration.lua has the whole story and
	    the list of pieces that come out together.
	]]
	ns.AdoptStandaloneRestockerDB()

	--[[
	    Retired keys, cleared explicitly so they do not sit in saved files
	    forever. debugMessages was the Restocker's own persisted debug switch;
	    that trace is now gated on the runtime-only diagnostics flag instead, so
	    nothing can leave it on across sessions -- the adoption above leaves it
	    behind rather than carrying it, so this only has to catch files that
	    already took a copy. adoptedLegacyData was the stamp an earlier,
	    since-retired copy step wrote.
	]]
	ns.db.global.restocker.debugMessages = nil
	ns.db.global.restocker.adoptedLegacyData = nil

	--[[
	    Retired report keys, cleared so no saved file can keep answering with
	    them: the old Ready Check switches, whose sections were re-cut rather
	    than renamed, and readinessReport, the Readiness Report's first master
	    switch, retired when the report became opt-in. The list and the reason
	    each one is on it live in Data/Default-Settings.lua.
	]]
	for _, key in ipairs(ns.RETIRED_READY_CHECK_KEYS) do
		ns.db.global[key] = nil
	end

	--[[
	    Derived item cache is lazy-inited on the profile (never declared in
	    defaults). Invalidate on a version change; the scanner's stale-schema
	    nil-test catches same-version (dev) field additions.
	]]
	if ns.db.profile.itemCacheVersion ~= ns.Version then
		ns.db.profile.itemCache = {}
		ns.db.profile.itemCacheVersion = ns.Version
	else
		ns.db.profile.itemCache = ns.db.profile.itemCache or {}
	end

	--[[
	    Session-constant work runs once; the SavedVariables work above it is
	    idempotent, so the whole function is safe to call twice on the login
	    path even though nothing does.
	]]
	if not varsInitialized then
		varsInitialized = true
		InitSessionConstants()
	end
end

--[[
    Per-arrival state: refreshed at login AND on every later loading screen,
    because the cached level and zone move as the player levels and travels.

    Split out of InitVars, which is confined to PLAYER_LOGIN — SavedVariables
    initialization must not hang off PLAYER_ENTERING_WORLD, which refires on
    every loading screen. Nothing here touches the database.

    Order matters on the login path: this runs AFTER InitVars, because
    InitSessionConstants is what resolves ns.IsHunter for the registration
    below.
]]
local function RefreshArrivalState()
	ns.CachedPlayerLevel = UnitLevel("player") or 1
	ns.CachedMapID = C_Map.GetBestMapForUnit("player")

	--[[
	    QUEST_LOG_UPDATE fires very frequently, and the only consumer of quest
	    data is Hunter pet-food quest-objective skipping (ScanPetFood via
	    BuildActiveQuestSet). Register it only for hunters so everyone else
	    doesn't pay for a full bag rescan + macro rebuild on every quest-log
	    churn. Idempotent, so registration follows ns.IsHunter on every arrival.
	]]
	if ns.IsHunter then
		frame:RegisterEvent("QUEST_LOG_UPDATE")
	else
		frame:UnregisterEvent("QUEST_LOG_UPDATE")
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
	local settings = ns.db.profile

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
	local settings = ns.db.profile
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
	local settings = ns.db.profile
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
	local settings = ns.db.profile
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

function ns.ToggleStealthEating(value)
	local settings = ns.db.profile
	if value == nil then
		settings.enableStealthEating = not settings.enableStealthEating
	else
		settings.enableStealthEating = value
	end
	if ns.ResetMacroState then
		ns.ResetMacroState()
	end
	ns.RequestUpdate()
end

function ns.ToggleDruidMacroHelper(value)
	local settings = ns.db.profile
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

--[[
    An id the server never answers for would spin the rescan forever: every
    scan that ends with an unresolved bag item calls this, and the timer walks
    straight back into another scan, so the pair is self-sustaining with no
    outside signal to stop it. The timer therefore gets a budget of
    DATA_RETRY_MAX_ATTEMPTS and then stops arming.

    GET_ITEM_INFO_RECEIVED stays registered past the budget: the event is the
    real signal, it costs nothing while idle, and an answer arriving late still
    rebuilds. UnregisterDataRetry refunds the budget, so the next cold item
    starts from a full one rather than inheriting an exhausted one.
]]
function ns.RegisterDataRetry()
	ns.RequestItemInfoEvents("scan")

	if dataRetryAttempts >= DATA_RETRY_MAX_ATTEMPTS then
		return
	end
	dataRetryAttempts = dataRetryAttempts + 1

	C_Timer.After(2, function()
		ns.RequestUpdate()
	end)
end

function ns.UnregisterDataRetry()
	dataRetryAttempts = 0
	ns.ReleaseItemInfoEvents("scan")
end

--[[
    GET_ITEM_INFO_RECEIVED has more than one waiter -- the bag scan above, and
    the Restock List, which defers an add, an upgrade or a Starter List tick on
    the same cold-cache miss. The client answers this event once per item it
    resolves, which during a login is a flood, so it is registered only while
    somebody is actually waiting.

    Keyed rather than counted: a waiter that asks twice must not need to release
    twice, and the last one out is what unregisters.
]]
local itemInfoWaiters = {}

function ns.RequestItemInfoEvents(key)
	itemInfoWaiters[key] = true
	frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
end

function ns.ReleaseItemInfoEvents(key)
	itemInfoWaiters[key] = nil
	if next(itemInfoWaiters) == nil then
		frame:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	end
end

local function OnUpdateHandler(_, elapsed)
	if InCombatLockdown() then
		--[[
		    Macros can't be written in combat. Disarm the tick but leave the
		    work pending (isUpdatePending stays true); PLAYER_REGEN_ENABLED, or
		    any later out-of-combat request, re-arms it.
		]]
		frame:SetScript("OnUpdate", nil)
		isTickScheduled = false
		return
	end

	updateTimer = updateTimer + elapsed
	if updateTimer > UPDATE_THROTTLE then
		frame:SetScript("OnUpdate", nil)
		isTickScheduled = false
		isUpdatePending = false
		if ns.UpdateMacros then
			ns.UpdateMacros()
		end
	end
end

function ns.RequestUpdate()
	isUpdatePending = true

	--[[
	    In combat, leave the work pending without arming the tick — macro
	    writes are blocked until combat drops, and PLAYER_REGEN_ENABLED
	    re-requests then.
	]]
	if InCombatLockdown() then
		return
	end

	--[[
	    Out of combat, ensure the throttled tick is armed. Gating on
	    isTickScheduled (not isUpdatePending) means a request always re-arms a
	    disarmed tick, so a stranded isUpdatePending can never swallow updates
	    until a /reload. updateTimer is reset only when arming a fresh tick, so
	    the throttle still fires ~UPDATE_THROTTLE after the first request in a
	    burst rather than debouncing to the last.
	]]
	if not isTickScheduled then
		isTickScheduled = true
		updateTimer = 0
		frame:SetScript("OnUpdate", OnUpdateHandler)
	end
end

--------------------------------------------------------------------------------
-- Target Tracking
--------------------------------------------------------------------------------

--[[
    PLAYER_TARGET_CHANGED fires on every tab, and a rebuild is a full bag
    rescan, so an unconditional request there costs one of those per mob
    targeted. Only three things about a target reach a macro body:

      is it a friendly player  -- scroll suppression (ns.HasFriendlyPlayerTarget)
      is it the player         -- plain-food mode (targetingSelf in ns.ScanBags)
      its level                -- the conjure downrank cap (ns.GetSmartSpell)

    Those three ARE the whole of what a target contributes to a written body,
    so anything new that reads the target MUST join this signature or its macro
    goes stale. Same diff-before-requesting shape ns.HandleUnitAura uses on the
    other firehose.

    Left nil until the first firing, so the first reading always counts as a
    change rather than being compared against a state nobody has read yet.
]]
local lastTargetFriendly, lastTargetIsSelf, lastTargetLevel

function ns.ResetTargetTracking()
	lastTargetFriendly, lastTargetIsSelf, lastTargetLevel = nil, nil, nil
end

--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

frame:SetScript("OnEvent", function(_, event, ...)
	-- Diagnostics event-log tap; the boolean is read first so logging-off is free.
	if ns.diagnostics.logging then
		ns.LogEvent(event, ...)
	end

	--[[
	    PLAYER_LOGIN is the ONLY place the database initializes: it is the
	    earliest safe point (SavedVariables are loaded) and it fires before the
	    first PLAYER_ENTERING_WORLD, which refires on every loading screen and
	    so can never own SavedVariables setup.

	    Handled ahead of the lockdown guard below, and neither call touches a
	    protected function. That is what guarantees ns.db exists even when the
	    player enters the world already in combat (e.g. zoning into an
	    in-progress battleground) — a case the guard would otherwise swallow,
	    leaving the add-on uninitialized until combat dropped.
	]]
	if event == "PLAYER_LOGIN" then
		InitVars()
		--[[
		    Restocker starts here rather than on its own frame, so it is
		    guaranteed ns.db already exists. Everything it does at this point is
		    saved-variable and frame setup, none of it protected.
		]]
		if ns.InitializeRestocker then
			ns.InitializeRestocker()
		end
		RefreshArrivalState()
		return
	end

	--[[
	    Restocker's handlers, ahead of the lockdown guard below. None of them
	    touches a protected function: a merchant or bank window cannot open in
	    combat, and a logout mid-combat must still pack the Restock List for the
	    saved-variables file. Routing them here rather than through a private
	    frame is also what puts them in the Diagnostics event log.
	]]
	local restockerHandler = ns.RESTOCKER_EVENT_HANDLERS[event]
	if restockerHandler then
		restockerHandler(...)
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
		local _, message = ...

		if ns.HandleHunterPetError then
			ns.HandleHunterPetError(message)
		end

		if ns.ReportZoneRestriction then
			ns.ReportZoneRestriction(message)
		end
		return
	end

	--[[
	    Leveling changes which items, scrolls, and spells qualify, so a
	    level-up forces a full rebuild of every macro. Refresh the cached level
	    and hunter spell names here, above the combat lockdown guard, because a
	    ding from a killing blow fires PLAYER_LEVEL_UP in combat, and the
	    event's own level / GetSpellInfo are safe combat reads. Wiping the
	    macro state forces every macro to rewrite; the write itself still
	    defers to the post-combat tick via the throttled update.

	    The level comes off the event rather than from UnitLevel("player"),
	    which still reads the OLD level while this event is being handled --
	    caching that would rebuild every macro one level behind and leave it
	    there until some later event happened to rebuild them again.
	]]
	if event == "PLAYER_LEVEL_UP" then
		local newLevel = ...
		ns.CachedPlayerLevel = newLevel or UnitLevel("player") or ns.CachedPlayerLevel or 1
		if ns.IsHunter then
			ns.ResolveHunterSpells()
		end
		if ns.ResetMacroState then
			ns.ResetMacroState()
		end
		ns.RequestUpdate()
		return
	end

	--[[
	    PLAYER_LOGOUT runs ahead of the lockdown guard too: a /reload issued
	    mid-combat still fires it, and the guard below would swallow the prune
	    and leave stale entries on the Ignore List. Pruning only reads and
	    rewrites SavedVariables, so it touches nothing protected.
	]]
	if event == "PLAYER_LOGOUT" then
		if ns.PruneIgnoreList then
			ns.PruneIgnoreList()
		end
		return
	end

	--[[
	    READY_CHECK is handled ahead of the lockdown guard for the same reason
	    as the events above: a ready check routinely fires with the raid
	    already pulling, and the report only reads auras and the last scan's
	    results before printing, so it touches nothing protected.
	]]
	if event == "READY_CHECK" then
		if ns.ReportReadiness then
			ns.ReportReadiness()
		end
		return
	end

	if InCombatLockdown() then
		isUpdatePending = true
		return
	end

	if event == "PLAYER_REGEN_ENABLED" then
		if isUpdatePending then
			ns.RequestUpdate()
		end
		return
	end

	if event == "PLAYER_TARGET_CHANGED" then
		-- Record every firing, request only on a real change. See Target Tracking.
		local isFriendly = ns.HasFriendlyPlayerTarget() and true or false
		local isSelf = (UnitExists("target") and UnitIsUnit("target", "player")) and true or false
		local level = UnitLevel("target")

		local changed = isFriendly ~= lastTargetFriendly or isSelf ~= lastTargetIsSelf or level ~= lastTargetLevel
		lastTargetFriendly, lastTargetIsSelf, lastTargetLevel = isFriendly, isSelf, level

		if changed then
			ns.RequestUpdate()
		end
		return
	end

	if
		event == "BAG_UPDATE_DELAYED"
		or event == "ITEM_PUSH"
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
		RefreshArrivalState()
		ns.PrintWelcome()
		ns.UpdateAuraTracking()
		if ns.ApplyMacroNameVisibility then
			ns.ApplyMacroNameVisibility()
		end
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
		if ns.UpdateEngineeringSkill then
			ns.UpdateEngineeringSkill()
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
	end
end)

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
ns.EVENT_NAMES = {
	"BAG_UPDATE_DELAYED",
	"BANKFRAME_CLOSED",
	"BANKFRAME_OPENED",
	"ITEM_PUSH",
	"MERCHANT_CLOSED",
	"MERCHANT_SHOW",
	"PLAYER_ALIVE",
	"PLAYER_CONTROL_GAINED",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_LEVEL_UP",
	"PLAYER_LOGIN",
	"PLAYER_LOGOUT",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_TARGET_CHANGED",
	"PLAYER_UNGHOST",
	"PLAYER_UPDATE_RESTING",
	"READY_CHECK",
	"UI_ERROR_MESSAGE",
	"ZONE_CHANGED_NEW_AREA",
	"SKILL_LINES_CHANGED",
	"SPELLS_CHANGED",
	"GROUP_ROSTER_UPDATE",
	"UNIT_PET",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_AURA",
	"QUEST_LOG_UPDATE",
	"GET_ITEM_INFO_RECEIVED",
}

--[[
    Names NOT registered by the plain loop: unit-filtered events use
    RegisterUnitEvent, and the on-demand events are registered only while needed
    (UNIT_AURA via UpdateAuraTracking, QUEST_LOG_UPDATE for hunters in
    RefreshArrivalState, GET_ITEM_INFO_RECEIVED via RequestItemInfoEvents).
]]
local DEFERRED_EVENTS = {
	UNIT_PET = true,
	UNIT_SPELLCAST_SUCCEEDED = true,
	UNIT_AURA = true,
	QUEST_LOG_UPDATE = true,
	GET_ITEM_INFO_RECEIVED = true,
}

for _, event in ipairs(ns.EVENT_NAMES) do
	if not DEFERRED_EVENTS[event] then
		frame:RegisterEvent(event)
	end
end

frame:RegisterUnitEvent("UNIT_PET", "player")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")

--[[
    QUEST_LOG_UPDATE is registered dynamically in RefreshArrivalState — Hunters only.
    It is the only event whose sole consumer is Hunter pet-food quest-skipping,
    and it fires too often to justify a full rescan on non-Hunter characters.
]]
