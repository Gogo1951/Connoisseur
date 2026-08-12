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
    check. Features/Diagnostics.lua owns ns:LogEvent / ns:StopEventLog.
]]
ns.diagnostics = { enabled = false, logging = false, log = nil }

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

local function GetVersion()
	local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
	local version = GetAddOnMetadata(ADDON_NAME, "Version")
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
	if LDBIcon and ns.LDBObj and not ns.IconRegistered then
		LDBIcon:Register(ns.LOCALE_NAME, ns.LDBObj, ns.db.global.minimap)
		ns.IconRegistered = true
	end
end

--[[
    MIGRATION (remove after 2026-08-15): every one-time conversion of saved data
    lives in this one function so the whole thing can be deleted as a block --
    remove the function and its single call in InitVars, plus the
    ns.PROFILE_NON_SETTINGS table in Data/Default-Settings.lua and the
    ConnoisseurCharDB line in the .toc. Runs immediately after AceDB:New, before
    anything reads a setting. Kept on ns so it can be exercised offline.
]]
function ns.RunDatabaseMigrations()
	--[[
        Keys this character supplied itself, which the account-wide seeding
        below must not overwrite. The two sources genuinely can coexist:
        ConnoisseurCharDB is per-character, so a character that skipped the
        AceDB build still has its own table while a sibling that did log in has
        already promoted ITS settings to global. The character's own value has
        to win over a sibling's.
    ]]
	local ownedByCharacter = {}

	--[[
        Move pre-AceDB saved data into the AceDB profile/global. Two sources:
          (a) the old per-character ConnoisseurCharDB (settings + ignoreList),
          (b) legacy root keys left on the ConnoisseurDB SavedVariable from
              before AceDB managed it (showWelcome, enabledMacros, minimap,
              itemCache, itemCacheVersion).
        Only non-nil saved values are copied, so AceDB's defaults fill the rest;
        each source is cleared after copying so this runs once. A user who
        hasn't logged in within the window simply starts from defaults.
    ]]
	if ConnoisseurCharDB then
		if type(ConnoisseurCharDB.settings) == "table" then
			for key, value in pairs(ConnoisseurCharDB.settings) do
				ns.db.profile[key] = value
				ownedByCharacter[key] = true
			end
		end
		if type(ConnoisseurCharDB.ignoreList) == "table" then
			ns.db.profile.ignoreList = ConnoisseurCharDB.ignoreList
		end
		ConnoisseurCharDB = nil
	end
	if ConnoisseurDB.showWelcome ~= nil then
		ns.db.profile.showWelcome = ConnoisseurDB.showWelcome
		ConnoisseurDB.showWelcome = nil
	end
	--[[
        Merge rather than assign for the two account-wide subtables: a save from
        an older version predates macros added since (and LibDBIcon fields it
        never wrote), and assigning the saved table wholesale would leave those
        keys nil instead of at their defaults.
    ]]
	local function MergeIntoGlobal(key, source)
		if type(source) ~= "table" then
			return
		end
		for subKey, subValue in pairs(source) do
			ns.db.global[key][subKey] = subValue
		end
	end

	if ConnoisseurDB.enabledMacros ~= nil then
		MergeIntoGlobal("enabledMacros", ConnoisseurDB.enabledMacros)
		ConnoisseurDB.enabledMacros = nil
	end
	if ConnoisseurDB.itemCache ~= nil then
		ns.db.profile.itemCache = ConnoisseurDB.itemCache
		ConnoisseurDB.itemCache = nil
	end
	if ConnoisseurDB.itemCacheVersion ~= nil then
		ns.db.profile.itemCacheVersion = ConnoisseurDB.itemCacheVersion
		ConnoisseurDB.itemCacheVersion = nil
	end
	if ConnoisseurDB.minimap ~= nil then
		MergeIntoGlobal("minimap", ConnoisseurDB.minimap)
		ConnoisseurDB.minimap = nil
	end

	--[[
        Move a legacy character off the shared "Default" profile onto its own
        "Name - Realm" profile. The old Simple model pinned every character to
        "Default" via AceDB:New(..., true), and AceDB persists that choice in
        ConnoisseurDB.profileKeys -- so dropping the flag only changes the
        default for brand-new characters; an existing one stays on "Default"
        until it is moved here. Capture the shared Ignore List first, so the
        fresh per-character profile can be seeded from it below. A character
        that already picked its own profile is left untouched.
    ]]
	local sharedIgnoreList
	if ns.db:GetCurrentProfile() == "Default" then
		local defaultProfile = ns.db.profiles and ns.db.profiles["Default"]
		sharedIgnoreList = defaultProfile and defaultProfile.ignoreList
		ns.db:SetProfile(ns.db.keys.char)
	end

	--[[
        Lift the five genuinely account-wide settings off a profile. Both the
        Simple model (every character shared the "Default" profile) and the
        pre-AceDB block above deposit their keys on a profile; showWelcome,
        showMacroNames, readyCheckReport, enabledMacros, and minimap belong on
        global. Two sources, in order: the shared "Default" profile the
        character was just moved off, then this character's own profile. Later
        source wins. Only keys declared in the
        global defaults move -- everything else is per-character and is handled
        by the demotion below.
    ]]
	local function PromoteProfileSettings(source)
		if type(source) ~= "table" then
			return
		end
		for key in pairs(ns.DATABASE_DEFAULTS.global) do
			if source[key] ~= nil then
				ns.db.global[key] = source[key]
				source[key] = nil
			end
		end
	end
	PromoteProfileSettings(ns.db.profiles and ns.db.profiles["Default"])
	PromoteProfileSettings(ns.db.profile)

	--[[
        Seed this character's settings from the account-wide values every
        character used to share. All of them except the five promoted above are
        per-character now, so each character inherits the old account value
        once, on its first login after the update, and diverges from there.

        Two sources, in order (later wins):
          (a) the shared "Default" profile, for a character coming straight from
              the Simple model that never reached the global-settings build,
          (b) leftovers on ns.db.global, written by that build. These keys are
              no longer declared in the global defaults, so AceDB neither fills
              them in (copyDefaults only walks the defaults table) nor strips
              them at logout (removeDefaults likewise) -- ns.db.global[key] is
              therefore exactly what the user saved, with no default to mistake
              it for.

        Both sources are deliberately left intact: characters that have not
        logged in yet still have to inherit from them. They go when this block
        does. The seeded flag stops a character that deliberately changed a
        setting back from being re-seeded on the next login.
    ]]
	local function SeedFromAccount(source)
		if type(source) ~= "table" then
			return
		end
		for key, default in pairs(ns.DATABASE_DEFAULTS.profile) do
			if not ns.PROFILE_NON_SETTINGS[key] and not ownedByCharacter[key] then
				local saved = source[key]
				if type(default) == "table" then
					--[[
                        Merge rather than replace: AceDB saves only the entries
                        that diverge from the defaults, so a wholesale copy of
                        scrollTypes / petBuffTypes would drop every defaulted
                        entry.
                    ]]
					if type(saved) == "table" then
						for subKey, subValue in pairs(saved) do
							ns.db.profile[key][subKey] = subValue
						end
					end
				elseif saved ~= nil then
					ns.db.profile[key] = saved
				end
			end
		end
	end
	--[[
        The "already seeded" record lives on global, keyed by character, NOT on
        the profile: Reset Profile wipes the whole profile table, so a flag kept
        there would be cleared along with the settings and the next login would
        silently re-seed everything the user had just reset. Undeclared in the
        defaults, like the leftovers it guards, so AceDB leaves it alone and it
        goes with this block.
    ]]
	local charKey = ns.db.keys.char
	local seeded = ns.db.global.migrationSeeded
	if type(seeded) ~= "table" then
		seeded = {}
		ns.db.global.migrationSeeded = seeded
	end
	local alreadySeeded = seeded[charKey]

	if not alreadySeeded then
		SeedFromAccount(ns.db.profiles and ns.db.profiles["Default"])
		SeedFromAccount(ns.db.global)
	end

	--[[
        Seed this character's Ignore List from the shared "Default" profile it
        was just moved off. The list was effectively account-wide under the
        Simple model; it is genuinely per-character now, so each character
        inherits a copy on its first login after the update and diverges from
        there. The Default profile is left intact so a character that hasn't
        logged in yet still gets its copy.

        Earlier builds recorded this on the profile, so that flag is still
        honoured -- a character that already inherited its copy and then cleared
        the list must not have it handed back.
    ]]
	if not (alreadySeeded or ns.db.profile.ignoreListSeeded) then
		if type(sharedIgnoreList) == "table" and sharedIgnoreList ~= ns.db.profile.ignoreList then
			for itemID in pairs(sharedIgnoreList) do
				ns.db.profile.ignoreList[itemID] = true
			end
		end
	end

	seeded[charKey] = true
end

local function InitVars()
	if not ns.db then
		--[[
            One account-wide SavedVariable managed by AceDB-3.0. AceDB:New's
            third argument (defaultProfile) is deliberately omitted, so every
            character lands on its own "Name - Realm" profile -- and that is
            where the settings live, so each character configures its own
            consumables. The five account-wide keys live on ns.db.global
            instead, each with its reason (see Data/Default-Settings.lua).
            AceDB applies ns.DATABASE_DEFAULTS itself -- no hand-merge. It
            copies scalar and table defaults into the saved table (rawset)
            when a scope is first accessed; only */** wildcard defaults
            resolve through a metatable.
        ]]

		ns.db = LibStub("AceDB-3.0"):New("ConnoisseurDB", ns.DATABASE_DEFAULTS)

		ns.RunDatabaseMigrations()

		--[[
            Switching, copying, or resetting a profile now swaps the settings
            themselves as well as the Ignore List, so the macro bodies and aura
            tracking must rebuild. Which macros exist does NOT change --
            enabledMacros is account-wide, like the macros themselves. The five
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
	frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")

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
	frame:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
end

local function OnUpdateHandler(self, elapsed)
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
-- Event Handling
--------------------------------------------------------------------------------

frame:SetScript("OnEvent", function(self, event, ...)
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
        leaving ns.db nil until the next out-of-combat
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

	if
		event == "BAG_UPDATE_DELAYED"
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
	"ITEM_PUSH",
	"PLAYER_ALIVE",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_LEVEL_UP",
	"PLAYER_LOGIN",
	"PLAYER_LOGOUT",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_TARGET_CHANGED",
	"PLAYER_UNGHOST",
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
    (UNIT_AURA via UpdateAuraTracking, QUEST_LOG_UPDATE for hunters in InitVars,
    GET_ITEM_INFO_RECEIVED via RegisterDataRetry).
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
    QUEST_LOG_UPDATE is registered dynamically in InitVars — Hunters only.
    It is the only event whose sole consumer is Hunter pet-food quest-skipping,
    and it fires too often to justify a full rescan on non-Hunter characters.
]]
