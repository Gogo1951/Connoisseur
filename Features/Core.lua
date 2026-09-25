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

local sessionConstantsInitialized = false

local function InitializeSavedVariables()
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
		    Switching, copying, or resetting a profile swaps the settings
		    themselves as well as the Ignore List, so the macro bodies and aura
		    tracking must rebuild. Which macros exist does NOT change --
		    enabledMacros is account-wide, like the macros themselves. The
		    account-wide keys survive untouched, but the two applied
		    imperatively (minimap visibility, macro-name text) have to be pushed
		    again from global because nothing else re-reads them, and an open
		    options panel has to be told to redraw.
		]]
		local function OnProfileChange()
			ns.EnsureItemCache()
			ns.ResetMacroState()
			ns.UpdateAuraTracking()
			ns.ApplyMacroNameVisibility()
			if ns.db.global.minimap then
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
		ns.RegisterOptionsPanels()
	end

	-- MIGRATION (remove after 2026-09-29)
	--[[
	    The Restock List used to live in a saved variable of its own,
	    ConnoisseurRestockerDB, rather than under ns.db.global. Move it in before
	    anything reads the new home -- an upgrading player's lists are still over
	    there, and WoW drops that table from the saved file at the first logout of
	    a build that no longer declares it. Deliberately not guarded on the
	    function existing: this failing quietly is how the lists get lost.
	    Features/Restocker/Restocker-Saved-Migration.lua lists the pieces that
	    come out together.
	]]
	ns.AdoptStandaloneRestockerDB()

	-- MIGRATION (remove after 2026-10-18)
	--[[
	    The Restocker's saved keys were renamed (profiles to lists, framePos to
	    framePosition, and so on). Immediately after the adoption, so a legacy
	    table adopted under the old names is renamed in the same login, and
	    before anything reads the new names. Its section of
	    Features/Restocker/Restocker-Saved-Migration.lua lists the pieces that
	    come out together.
	]]
	ns.RenameRestockerSavedKeys()

	-- MIGRATION (remove after 2026-10-18)
	--[[
	    A wrong itemID on the Blinding Powder ladder saved the Starter List's
	    Blinding Powder as Infantry Gauntlets; this moves those rows onto the real
	    item. After the rename, so a list still saved under an old name is repaired
	    in the same login, and before ns.InitializeRestocker unpacks the lists,
	    where the moved row gets its name or starts waiting for it. Its section of
	    Features/Restocker/Restocker-Saved-Migration.lua has the rest.
	]]
	ns.RepairBlindingPowderRows()

	-- MIGRATION (remove after 2026-09-29)
	--[[
	    Retired keys, cleared explicitly so they do not sit in saved files.
	    debugMessages was the Restocker's own persisted debug switch; that trace
	    is now gated on the runtime-only diagnostics flag instead, so nothing can
	    leave it on across sessions -- the adoption above leaves it behind rather
	    than carrying it, so this only has to catch files that already took a
	    copy. adoptedLegacyData was the stamp an earlier, since-retired copy step
	    wrote.

	    The report keys are the Ready Check report's own switches, retired when
	    it became the Readiness Report (its sections were re-cut rather than
	    renamed, so nothing maps onto a new key), and readinessReport, the
	    Readiness Report's first master switch, retired when the report became
	    opt-in. That one is cleared rather than reused: AceDB strips a value equal
	    to its default at logout, but a value the player set stays in the saved
	    file after its key leaves the defaults, so a reused name would read back
	    a choice made under its old meaning.
	]]
	ns.db.global.restocker.debugMessages = nil
	ns.db.global.restocker.adoptedLegacyData = nil
	local RETIRED_READY_CHECK_KEYS = {
		"readyCheckReport",
		"readyCheckHealthstone",
		"readyCheckHealthPotion",
		"readyCheckManaPotion",
		"readyCheckScrolls",
		"readyCheckWellFed",
		"readyCheckPetFood",
		"readyCheckBuffTimes",
		"readyCheckSoulstone",
		"readyCheckManaGem",
		"readyCheckBandage",
		"readinessReport",
	}
	for _, key in ipairs(RETIRED_READY_CHECK_KEYS) do
		ns.db.global[key] = nil
	end

	ns.EnsureItemCache()

	--[[
	    Session-constant work runs once; the SavedVariables work above it is
	    idempotent, so the whole function is safe to call twice on the login
	    path even though nothing does.
	]]
	if not sessionConstantsInitialized then
		sessionConstantsInitialized = true
		ns.InitCharacterConstants()
		ns.RegisterMinimapIcon()
	end
end

--[[
    Per-arrival state: refreshed at login AND on every later loading screen,
    because the cached level and zone move as the player levels and travels.

    Split out of InitializeSavedVariables, which is confined to PLAYER_LOGIN — SavedVariables
    initialization must not hang off PLAYER_ENTERING_WORLD, which refires on
    every loading screen. Nothing here touches the database.

    Order matters on the login path: this runs AFTER InitializeSavedVariables, because
    ns.InitCharacterConstants is what resolves ns.isHunter for the registration
    below.
]]
local function RefreshArrivalState()
	ns.cachedPlayerLevel = UnitLevel("player") or 1
	ns.cachedMapID = C_Map.GetBestMapForUnit("player")

	--[[
	    QUEST_LOG_UPDATE fires very frequently, and the only consumer of quest
	    data is Hunter pet-food quest-objective skipping (ScanPetFood via
	    BuildActiveQuestSet). Register it only for hunters so everyone else
	    doesn't pay for a full bag rescan + macro rebuild on every quest-log
	    churn. Idempotent, so registration follows ns.isHunter on every arrival.
	]]
	ns.SetEventRegistered("QUEST_LOG_UPDATE", ns.isHunter)
end

--------------------------------------------------------------------------------
-- Update Throttling
--------------------------------------------------------------------------------

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
		ns.UpdateMacros()
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

-- Leaves the work pending without arming the tick, for a deferral something else is sure to replay.
function ns.MarkUpdatePending()
	isUpdatePending = true
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
		InitializeSavedVariables()
		--[[
		    Restocker starts here rather than on its own frame, so it is
		    guaranteed ns.db already exists. Everything it does at this point is
		    saved-variable and frame setup, none of it protected.
		]]
		ns.InitializeRestocker()
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
	local restockerHandler = ns.restockerEventHandlers[event]
	if restockerHandler then
		restockerHandler(...)
	end

	--[[
	    Options item lists waiting on this answer repaint now: after the
	    Restocker handler above, which forgets the item's remembered miss before
	    anything asks about it again.
	]]
	if event == "GET_ITEM_INFO_RECEIVED" then
		ns.OnOptionsItemInfoReceived(...)
		--[[
		    Only a consumable's answer can change a macro: ns.CacheItemData, which
		    covers the consumable tables alone, is the one macro input that reads
		    item info. Any other answer rebuilds nothing.
		]]
		local itemID = ...
		if not ns.HasRawData(itemID) then
			return
		end
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

		ns.OnHunterUiErrorMessage(message)

		ns.OnMacroUiErrorMessage(message)
		return
	end

	--[[
	    UNIT_PET is handled ahead of the guard as well: a pet revived or called
	    mid-fight must clear the dead-pet flag then, not when combat ends, and the
	    handler only flips that flag and calls RequestUpdate, which defers the
	    rebuild itself.
	]]
	if event == "UNIT_PET" then
		ns.OnUnitPet(...)
		return
	end

	--[[
	    Leveling changes which items, scrolls, and spells qualify, so a
	    level-up forces a full rebuild of every macro. Refresh the cached level
	    and hunter spell names here, above the combat lockdown guard, because a
	    ding from a killing blow fires PLAYER_LEVEL_UP in combat, and the
	    event's own level / C_Spell.GetSpellName are safe combat reads. Wiping the
	    macro state forces every macro to rewrite; the write itself still
	    defers to the post-combat tick via the throttled update.

	    The level comes off the event rather than from UnitLevel("player"),
	    which still reads the OLD level while this event is being handled --
	    caching that would rebuild every macro one level behind and leave it
	    there until some later event happened to rebuild them again.
	]]
	if event == "PLAYER_LEVEL_UP" then
		local newLevel = ...
		ns.cachedPlayerLevel = newLevel or UnitLevel("player") or ns.cachedPlayerLevel or 1
		if ns.isHunter then
			ns.ResolveHunterSpells()
		end
		ns.ResetMacroState()
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
		ns.OnIgnoreListPlayerLogout()
		return
	end

	--[[
	    READY_CHECK is handled ahead of the lockdown guard for the same reason
	    as the events above: a ready check routinely fires with the raid
	    already pulling, and the report only reads auras and the last scan's
	    results before printing, so it touches nothing protected. Where the
	    client restricts aura data mid-fight (Forever), ns.OnReadyCheck
	    stays silent rather than read a secret value.
	]]
	if event == "READY_CHECK" then
		ns.OnReadyCheck()
		return
	end

	--[[
	    Target and group changes are recorded ahead of the lockdown guard too.
	    Behind it, a change made mid-fight would leave the remembered signature at
	    its pre-fight reading, so changing back after combat would read as no
	    change and leave the macros built for the fight. Both only read unit
	    state, the target comparison only while C_Secrets allows it (Forever
	    can restrict it mid-fight), and ns.RequestUpdate leaves the rebuild
	    pending until combat drops.
	    Request only on a real change; see Target and Group Tracking in
	    Features/Macros/Signatures.lua.
	]]
	if event == "PLAYER_TARGET_CHANGED" then
		if ns.TargetSignatureChanged() then
			ns.RequestUpdate()
		end
		return
	end

	if event == "GROUP_ROSTER_UPDATE" then
		if ns.GroupSignatureChanged() then
			ns.RequestUpdate()
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

	if event == "QUEST_LOG_UPDATE" then
		if ns.PetFoodQuestsChanged() then
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
	then
		ns.RequestUpdate()
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		ns.cachedMapID = C_Map.GetBestMapForUnit("player")
		ns.RequestUpdate()
	elseif event == "SPELLS_CHANGED" then
		--[[
		    Hunter spell-name cache refreshes here so a level-up training
		    visit (e.g. Mend Pet at 12) starts participating in the macro
		    immediately. Mages/warlocks don't have a name cache, but their
		    macro bodies still depend on KnowsAny / GetSmartSpell results,
		    so we trigger a generic rebuild for everyone.
		]]
		if ns.isHunter then
			ns.ResolveHunterSpells()
		end
		ns.RequestUpdate()
	elseif event == "PLAYER_ENTERING_WORLD" then
		RefreshArrivalState()
		ns.PrintWelcome()
		ns.UpdateAuraTracking()
		ns.ApplyMacroNameVisibility()
		ns.RequestUpdate()
		C_Timer.After(3, function()
			ns.RequestUpdate()
		end)
	elseif event == "SKILL_LINES_CHANGED" then
		ns.UpdateFirstAidSkill()
		ns.UpdateAlchemySkill()
		ns.UpdateEngineeringSkill()
		ns.RequestUpdate()
	elseif event == "UNIT_AURA" then
		ns.OnUnitAura(...)
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		local _, _, spellID = ...
		-- A secret spellID (Forever, while casts are restricted) errors as a table key.
		if ns.IsSecretValue(spellID) then
			return
		end
		if ns.spellCache and ns.spellCache[spellID] then
			ns.RequestUpdate()
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
    (UNIT_AURA via ns.UpdateAuraTracking, QUEST_LOG_UPDATE for hunters in
    RefreshArrivalState, GET_ITEM_INFO_RECEIVED via ns.RequestItemInfoEvents),
    each through ns.SetEventRegistered.
]]
local DEFERRED_EVENTS = {
	UNIT_PET = true,
	UNIT_SPELLCAST_SUCCEEDED = true,
	UNIT_AURA = true,
	QUEST_LOG_UPDATE = true,
	GET_ITEM_INFO_RECEIVED = true,
}

--[[
    How a feature file registers or releases one of its on-demand events: on
    this frame, so the event still routes through the dispatcher above. Unit
    arguments after `enabled` make the registration unit-filtered.
]]
function ns.SetEventRegistered(event, enabled, ...)
	if not enabled then
		frame:UnregisterEvent(event)
	elseif select("#", ...) > 0 then
		frame:RegisterUnitEvent(event, ...)
	else
		frame:RegisterEvent(event)
	end
end

for _, event in ipairs(ns.EVENT_NAMES) do
	if not DEFERRED_EVENTS[event] then
		frame:RegisterEvent(event)
	end
end

frame:RegisterUnitEvent("UNIT_PET", "player")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
