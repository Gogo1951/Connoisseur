local _, ns = ...

--------------------------------------------------------------------------------
-- Diagnostic Tools
--------------------------------------------------------------------------------

--[[
    Environment probing and state capture for bug reports, not unit tests. WoW's
    sandboxed Lua has no assertion runner, so everything here is read-only and
    side-effect free. The one exception is the explicit Taint Log button, which
    sets the taintLog CVar. Reports build only on a button press, never on load
    or panel open.
]]

local L = ns.L

--------------------------------------------------------------------------------
-- Runtime State
--------------------------------------------------------------------------------

--[[
    Runtime-only state. NOT a SavedVariable. File-scope init is correct here —
    the "initialize on PLAYER_LOGIN" rule applies only to SavedVariables, which
    don't exist until the client loads them. Core also initialises this table;
    the `or` keeps whichever ran first.
]]
ns.diagnostics = ns.diagnostics or { enabled = false, logging = false, log = nil }

--------------------------------------------------------------------------------
-- Strings
--------------------------------------------------------------------------------

--[[
    Diagnostics strings are intentionally NOT localized. They are
    developer-facing troubleshooting text; translating them is wasted effort for
    zero player value. Every diagnostics string lives here as plain English, in
    the diagnostics files only — never in Locales/. The one exception is the
    add-on's own display name, read from ns.L["ADDON_TITLE"], which is the add-on's
    identity, not a diagnostics string.
]]
ns.DiagnosticsStrings = {
	TAB = "Diagnostic Tools",
	WARNING = "These tools help diagnose problems and are meant for developers. They won't change how the add-on works, but their output includes technical details about your client and installed add-ons. Leave this off unless you're troubleshooting with someone.",
	ENABLE = "Enable Diagnostic Tools",
	EVENT_LOG_TITLE = "Event Log",
	EVENT_LOG_START = "Start Event Log",
	EVENT_LOG_STOP = "Stop Event Log",
	EVENT_LOG_SHOW = "Show Captured Events",
	EVENT_LOG_HINT = "Captures the events the add-on registered for, with arguments, in the order they fired. The best tool for 'my macro didn't update' reports.",
	EVENTS_TITLE = "Event Registration",
	EVENTS_BUTTON = "Test Event Registration",
	API_TITLE = "API Endpoints",
	API_BUTTON = "Test WoW API Endpoints",
	CONTEXT_TITLE = "Connoisseur Context",
	CONTEXT_BUTTON = "Show Connoisseur Context",
	SELECTION_TITLE = "Item Selection",
	SELECTION_BUTTON = "Show Selection Report",
	SELECTION_HINT = "Shows what each macro picked and which runners-up it beat, naming the ranking step that decided each one. The tool for 'why did it choose that item?' reports. Candidates are only kept while these tools are enabled, so trigger a rescan (loot something, or change zone) after turning them on.",
	ADDONS_TITLE = "Other Add-ons",
	ADDONS_BUTTON = "List Installed Add-ons",
	SAVED_TITLE = "Saved Variables",
	SAVED_BUTTON = "Dump Saved Variables",
	LIBS_TITLE = "Library Versions",
	LIBS_BUTTON = "List Library Versions",
	TAINT_TITLE = "Taint Log",
	TAINT_STATE = "Taint logging is currently set to level %d (0 = off, 2 = verbose).",
	TAINT_ON = "Turn On Taint Log",
	TAINT_OFF = "Turn Off Taint Log",
	TAINT_HINT = "Writes to Logs\\taint.log. The setting persists until turned off; reload your UI to capture taint from login onward.",
	TOOLS_TITLE = "External Tools",
	TOOLS_ERRORS = "Lua errors: install BugSack and !BugGrabber, or enable %s to surface them.",
	TOOLS_ETRACE = "Live event tracing: use %s.",
}

--------------------------------------------------------------------------------
-- Enable Gate
--------------------------------------------------------------------------------

function ns:SetDiagnosticsEnabled(value)
	ns.diagnostics.enabled = value and true or false
	if not ns.diagnostics.enabled then
		ns:StopEventLog()
	end
end

--------------------------------------------------------------------------------
-- Report Header
--------------------------------------------------------------------------------

local function GetClientHeader()
	local version, build, _, tocVersion = GetBuildInfo()
	return string.format(
		"%s %s // Client %s // Build %s // TOC %s // Locale %s // Project %s",
		L["ADDON_TITLE"],
		ns.Version,
		version,
		build,
		tocVersion,
		GetLocale(),
		tostring(WOW_PROJECT_ID)
	)
end

--------------------------------------------------------------------------------
-- Event Log
--------------------------------------------------------------------------------

local EVENT_LOG_SIZE = 500
local EVENT_LOG_MAX_ARGS = 8

--[[
    Per-argument byte cap. 64 was too small: a single item link
    (|cff...|Hitem:...|h[Name]|h|r) already runs past 80 bytes, so the link was
    getting cut mid-name and the entry collapsed to a sliver like "[Sc". 255
    holds a full item link while still bounding a runaway argument.
]]
local EVENT_LOG_MAX_ARG_LENGTH = 255

--[[
    Firehose events flood the log in milliseconds and bury the signal, so the
    logger skips them. UNIT_AURA is the one firehose this add-on registers (Well
    Fed / scroll / pet-buff tracking). The log only sees events routed through
    Core's central dispatcher, so an event the add-on never registers can't
    appear here regardless.
]]
ns.DIAGNOSTIC_EVENT_EXCLUDE = {
	UNIT_AURA = true,
}

--------------------------------------------------------------------------------
-- Event Log Noise
--------------------------------------------------------------------------------

--[[
    UI_ERROR_MESSAGE is a firehose the add-on genuinely acts on some of the time,
    so it is never excluded wholesale: the client raises it for every red combat
    error, and against a 500-entry buffer that traffic silently evicts the
    entries the log exists to carry -- the report comes back looking complete
    while the signal has already been trimmed away.

    The value is the argument position carrying the field the filter classifies
    by. UI_ERROR_MESSAGE fires as (messageID, message); this add-on's handlers
    all correlate on the message TEXT rather than the numeric id, so position 2
    is the field the filter has to read to classify the same way they do.
]]
ns.MESSAGE_ID_FILTERED_EVENTS = {
	UI_ERROR_MESSAGE = 2,
}

--[[
    The log's allowlist: the messages this add-on actually acts on. Every entry
    is the exact global its live handler compares against -- ERR_ITEM_WRONG_ZONE
    (ns.ReportZoneRestriction, Macros/Runtime.lua), SPELL_FAILED_TARGETS_DEAD
    (ns.HandleHunterPetError, Macros/Tools-Hunters.lua), and ERR_INV_FULL /
    ERR_BANK_FULL (eventsModule.OnUiErrorMessage, Restocker/Events.lua) -- read
    live on every call and never persisted, so the filter cannot drift from the
    handlers and start making the log lie about what fired.

    Never invert this into a denylist of noise: noise is unbounded, varies by
    class and activity, and renumbers across client patches. The allowlist is
    finite and already in the code.
]]
local function IsCorrelatedMessage(text)
	return text == ERR_ITEM_WRONG_ZONE
		or text == SPELL_FAILED_TARGETS_DEAD
		or text == ERR_INV_FULL
		or text == ERR_BANK_FULL
end

--[[
    Decides, per firing, whether the entry is logged in full or folded into a
    counter. Suppressed traffic aggregates per message text (first-seen text plus
    a count) and renders as one compact block at the end of the report, so the
    report still proves what fired and how often -- and a tester can spot a
    message the add-on should be correlating and isn't.
]]
function ns:SuppressUncorrelatedMessage(event, ...)
	local position = ns.MESSAGE_ID_FILTERED_EVENTS[event]
	if not position then
		return false
	end

	--[[
        Unclassifiable is signal: a firing that doesn't carry the field we
        classify by is exactly the unexpected shape a bug report needs to show,
        so it is logged verbatim rather than suppressed.
    ]]
	local text = select(position, ...)
	if type(text) ~= "string" then
		return false
	end

	if IsCorrelatedMessage(text) then
		return false
	end

	local suppressed = ns.diagnostics.suppressed
	if not suppressed then
		suppressed = {}
		ns.diagnostics.suppressed = suppressed
	end

	local key = event .. "\0" .. text
	local entry = suppressed[key]
	if entry then
		entry.count = entry.count + 1
	else
		suppressed[key] = { event = event, text = text, count = 1 }
	end

	return true
end

function ns:StartEventLog()
	ns.diagnostics.log = {}
	ns.diagnostics.suppressed = {}
	ns.diagnostics.logging = true
end

function ns:StopEventLog()
	ns.diagnostics.logging = false
	ns.diagnostics.log = nil
	ns.diagnostics.suppressed = nil
end

--[[
    Called by Core's dispatcher for every event while logging is active.
    Snapshots arguments to strings immediately — never retain references, since
    some events carry frames or tables that would leak memory or go stale. Caps
    the arg count and string length so a single entry can't run away.

    Pipes are escaped (| -> ||) AFTER the length cut so each argument shows
    verbatim in the report editbox rather than rendering as a clickable item
    swatch. Escaping last also means the cut can never leave a dangling pipe that
    would eat the following ", " separator.
]]
function ns:LogEvent(event, ...)
	if ns.DIAGNOSTIC_EVENT_EXCLUDE[event] then
		return
	end
	--[[
        Filtered at capture, never at render: folding the spam only at display
        time would still let it push the add-on's own events out of the bounded
        buffer, and the report would come back clean and empty.
    ]]
	if ns:SuppressUncorrelatedMessage(event, ...) then
		return
	end
	local parts = {}
	for index = 1, select("#", ...) do
		if index > EVENT_LOG_MAX_ARGS then
			break
		end
		local raw = string.sub(tostring((select(index, ...))), 1, EVENT_LOG_MAX_ARG_LENGTH)
		parts[index] = (raw:gsub("|", "||"))
	end
	local log = ns.diagnostics.log
	log[#log + 1] = string.format("%.3f %s(%s)", GetTime(), event, table.concat(parts, ", "))
	if #log > EVENT_LOG_SIZE then
		table.remove(log, 1)
	end
end

--[[
    The suppressed-traffic block, appended after the log itself: one line per
    folded message, biggest offender first. Pipes are escaped here for the same
    reason the log entries escape them -- so the text shows verbatim in the
    report editbox instead of rendering as an escape.
]]
local function AppendSuppressedSummary(lines)
	local suppressed = ns.diagnostics.suppressed
	if not suppressed then
		return
	end

	local rows = {}
	for _, entry in pairs(suppressed) do
		rows[#rows + 1] = entry
	end
	if #rows == 0 then
		return
	end

	table.sort(rows, function(a, b)
		if a.count ~= b.count then
			return a.count > b.count
		end
		return a.text < b.text
	end)

	lines[#lines + 1] = ""
	lines[#lines + 1] = "-- Suppressed (uncorrelated) traffic --"
	for _, entry in ipairs(rows) do
		lines[#lines + 1] = string.format("%s(%s) x%d", entry.event, (entry.text:gsub("|", "||")), entry.count)
	end
end

function ns:BuildEventLogReport()
	local lines = { GetClientHeader(), "" }
	local log = ns.diagnostics.log
	if not log or #log == 0 then
		lines[#lines + 1] = "(no events captured)"
	else
		for _, entry in ipairs(log) do
			lines[#lines + 1] = entry
		end
	end
	AppendSuppressedSummary(lines)
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Event Registration
--------------------------------------------------------------------------------

--[[
    For every event the add-on registers (ns.EVENT_NAMES, exported by Core.lua),
    report whether it is valid on this client (C_EventUtils.IsEventValid) and
    whether RegisterEvent succeeds. The probe frame registers then immediately
    unregisters each event with no handler attached, so nothing is ever
    processed. The list is sourced from Core so it can never drift from the
    events the add-on actually uses.
]]

local probeFrame

local function GetProbeFrame()
	if not probeFrame then
		probeFrame = CreateFrame("Frame")
	end
	return probeFrame
end

function ns:RunEventChecks()
	local lines = { GetClientHeader(), "" }
	local hasIsEventValid = type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function"
	local probe = GetProbeFrame()
	local failures = 0
	for _, event in ipairs(ns.EVENT_NAMES or {}) do
		local valid = "n/a"
		if hasIsEventValid then
			valid = C_EventUtils.IsEventValid(event) and "valid" or "INVALID"
		end
		local ok = pcall(probe.RegisterEvent, probe, event)
		if ok then
			probe:UnregisterEvent(event)
		else
			failures = failures + 1
		end
		lines[#lines + 1] = string.format("[%s] %s (IsEventValid: %s)", ok and "PASS" or "FAIL", event, valid)
	end
	lines[#lines + 1] = ""
	if failures == 0 then
		lines[#lines + 1] = "All events register on this client."
	else
		lines[#lines + 1] = string.format("%d event(s) failed to register.", failures)
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- API Endpoints
--------------------------------------------------------------------------------

--[[
    Existence and shape checks only: read-only, no side effects, no protected
    calls. One row per WoW API the add-on depends on, scanned from across
    Features/ and Options/. Every API the code guards for existence (e.g.
    IsPlayerSpell) or reaches through a modern->legacy fallback gets a
    row of its own — modern and legacy listed separately — so the manifest stays
    one-to-one with the code's guards and the report shows exactly what each
    client provides.
]]
ns.DIAGNOSTIC_API_CHECKS = {
	-- { label, testFunction }
	{
		"C_AddOns.GetAddOnMetadata",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnMetadata) == "function"
		end,
	},
	{
		"GetAddOnMetadata (legacy)",
		function()
			return type(GetAddOnMetadata) == "function"
		end,
	},
	{
		"C_AddOns.GetAddOnInfo",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnInfo) == "function"
		end,
	},
	{
		"GetAddOnInfo (legacy)",
		function()
			return type(GetAddOnInfo) == "function"
		end,
	},
	{
		"C_AddOns.GetNumAddOns",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetNumAddOns) == "function"
		end,
	},
	{
		"GetNumAddOns (legacy)",
		function()
			return type(GetNumAddOns) == "function"
		end,
	},
	--[[
        C_Container has no legacy-global rows by design: GetContainerNumSlots /
        GetContainerItemInfo are absent on the target clients (see the TOC
        ## Interface line), where C_Container is the only container API. See
        the container shims in Utilities.
    ]]
	{
		"C_Container.GetContainerNumSlots",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerNumSlots) == "function"
		end,
	},
	{
		"C_Container.GetContainerItemInfo",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerItemInfo) == "function"
		end,
	},
	{
		"C_Map.GetBestMapForUnit",
		function()
			return type(C_Map) == "table" and type(C_Map.GetBestMapForUnit) == "function"
		end,
	},
	{
		"IsInInstance",
		function()
			return type(IsInInstance) == "function"
		end,
	},
	{
		"C_Item.GetItemCount",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemCount) == "function"
		end,
	},
	{
		"GetItemCount (legacy)",
		function()
			return type(GetItemCount) == "function"
		end,
	},
	{
		"C_Item.GetItemIconByID",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemIconByID) == "function"
		end,
	},
	{
		"GetItemIcon (legacy)",
		function()
			return type(GetItemIcon) == "function"
		end,
	},
	{
		"GetItemInfo",
		function()
			return type(GetItemInfo) == "function"
		end,
	},
	{
		"GetMacroIndexByName",
		function()
			return type(GetMacroIndexByName) == "function"
		end,
	},
	{
		"CreateMacro",
		function()
			return type(CreateMacro) == "function"
		end,
	},
	{
		"EditMacro",
		function()
			return type(EditMacro) == "function"
		end,
	},
	{
		"DeleteMacro",
		function()
			return type(DeleteMacro) == "function"
		end,
	},
	{
		"GetMacroBody",
		function()
			return type(GetMacroBody) == "function"
		end,
	},
	{
		"GetNumMacros",
		function()
			return type(GetNumMacros) == "function"
		end,
	},
	{
		"GetPetFoodTypes",
		function()
			return type(GetPetFoodTypes) == "function"
		end,
	},
	{
		"GetNumSkillLines",
		function()
			return type(GetNumSkillLines) == "function"
		end,
	},
	{
		"GetSkillLineInfo",
		function()
			return type(GetSkillLineInfo) == "function"
		end,
	},
	{
		"GetNumQuestLogEntries",
		function()
			return type(GetNumQuestLogEntries) == "function"
		end,
	},
	{
		"GetQuestLogTitle",
		function()
			return type(GetQuestLogTitle) == "function"
		end,
	},
	{
		"UnitAura",
		function()
			return type(UnitAura) == "function"
		end,
	},
	{
		"GetSpellInfo",
		function()
			return type(GetSpellInfo) == "function"
		end,
	},
	{
		"IsSpellKnown",
		function()
			return type(IsSpellKnown) == "function"
		end,
	},
	{
		"IsPlayerSpell",
		function()
			return type(IsPlayerSpell) == "function"
		end,
	},
	{
		"SecureCmdOptionParse",
		function()
			return type(SecureCmdOptionParse) == "function"
		end,
	},
	{
		"C_Timer.After",
		function()
			return type(C_Timer) == "table" and type(C_Timer.After) == "function"
		end,
	},
	{
		"C_EventUtils.IsEventValid",
		function()
			return type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function"
		end,
	},
	-- Restocker's load-bearing surface (merchant buying and bank restocking).
	{
		"GetMerchantNumItems",
		function()
			return type(GetMerchantNumItems) == "function"
		end,
	},
	{
		"GetMerchantItemInfo",
		function()
			return type(GetMerchantItemInfo) == "function"
		end,
	},
	{
		"GetMerchantItemLink",
		function()
			return type(GetMerchantItemLink) == "function"
		end,
	},
	{
		"BuyMerchantItem",
		function()
			return type(BuyMerchantItem) == "function"
		end,
	},
	{
		"UnitReaction",
		function()
			return type(UnitReaction) == "function"
		end,
	},
	{
		"GetNetStats",
		function()
			return type(GetNetStats) == "function"
		end,
	},
	{
		"GetItemFamily",
		function()
			return type(GetItemFamily) == "function"
		end,
	},
	{
		"GetInventorySlotInfo",
		function()
			return type(GetInventorySlotInfo) == "function"
		end,
	},
	{
		"C_Container.GetContainerNumFreeSlots",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerNumFreeSlots) == "function"
		end,
	},
	{
		"C_Container.PickupContainerItem",
		function()
			return type(C_Container) == "table" and type(C_Container.PickupContainerItem) == "function"
		end,
	},
	{
		"C_Container.SplitContainerItem",
		function()
			return type(C_Container) == "table" and type(C_Container.SplitContainerItem) == "function"
		end,
	},
	{
		"C_Container.UseContainerItem",
		function()
			return type(C_Container) == "table" and type(C_Container.UseContainerItem) == "function"
		end,
	},
	{
		"C_Container.ContainerIDToInventoryID",
		function()
			return type(C_Container) == "table" and type(C_Container.ContainerIDToInventoryID) == "function"
		end,
	},
	{
		"GetCVar",
		function()
			return type(GetCVar) == "function"
		end,
	},
	{
		"SetCVar",
		function()
			return type(SetCVar) == "function"
		end,
	},
}

function ns:RunApiChecks()
	local lines = { GetClientHeader(), "" }
	for _, check in ipairs(ns.DIAGNOSTIC_API_CHECKS) do
		local ok, result = pcall(check[2])
		lines[#lines + 1] = ((ok and result) and "[PASS] " or "[FAIL] ") .. check[1]
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Connoisseur Context
--------------------------------------------------------------------------------

--[[
    Existence/value reads only (same read-only contract as the API checks). The
    add-on-specific probe for "nothing shows up" reports: the spells the add-on
    gates on, the current best-item selections, and — because the add-on draws a
    minimap button — the display context behind off-screen / wrong-scale reports.
]]
ns.DIAGNOSTIC_SPELLS = {
	-- { spellID, label }
	{ 587, "Conjure Food (Rank 1)" },
	{ 5504, "Conjure Water (Rank 1)" },
	{ 759, "Conjure Mana Agate" },
	{ 43987, "Ritual of Refreshment" },
	{ 6201, "Create Healthstone (Minor)" },
	{ 693, "Create Soulstone (Minor)" },
	{ 29893, "Ritual of Souls" },
	{ 883, "Call Pet" },
	{ 6991, "Feed Pet" },
	{ 136, "Mend Pet" },
	{ 982, "Revive Pet" },
	{ 2641, "Dismiss Pet" },
	{ 20580, "Shadowmeld" },
	{ 20222, "Goblin Engineer" },
}

function ns:BuildContextReport()
	local lines = { GetClientHeader(), "" }

	local _, classToken = UnitClass("player")
	lines[#lines + 1] = string.format(
		"Class: %s // Level: %s // Cached level: %s // Cached map: %s",
		tostring(classToken),
		tostring(UnitLevel("player")),
		tostring(ns.CachedPlayerLevel),
		tostring(ns.CachedMapID)
	)

	-- The profession ranks the scanner's usability gates read (0 = unlearned).
	lines[#lines + 1] = string.format(
		"Skills: First Aid %s // Alchemy %s // Engineering %s",
		tostring(ns.CurrentFirstAidSkill),
		tostring(ns.CurrentAlchemySkill),
		tostring(ns.CurrentEngineeringSkill)
	)

	lines[#lines + 1] = ""
	lines[#lines + 1] = "-- Best-item selection --"
	lines[#lines + 1] = string.format("BestFoodID: %s", tostring(ns.BestFoodID))
	lines[#lines + 1] = string.format("BestPetFoodID: %s", tostring(ns.BestPetFoodID))
	if ns.ScrollOverrideIDs and #ns.ScrollOverrideIDs > 0 then
		lines[#lines + 1] = "ScrollOverrideIDs: " .. table.concat(ns.ScrollOverrideIDs, ", ")
	else
		lines[#lines + 1] = "ScrollOverrideIDs: (none)"
	end
	lines[#lines + 1] = string.format("PetBuffOverrideID: %s", tostring(ns.PetBuffOverrideID))

	--[[
        Per-category winners from the last ScanBags pass (ns.BestSelection is
        the scanner's live best table). The read-out for "category X didn't
        update" reports: it shows exactly what the scanner picked plus the
        tiebreak inputs (value/price/count) the comparison ladder ordered on,
        and the ranked topIDs for multi-use types — none of which BestFoodID
        alone can reveal.
    ]]
	local selection = ns.BestSelection
	if selection then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "-- Best by category (last scan) --"
		local categories = {}
		for typeName in pairs(selection) do
			categories[#categories + 1] = typeName
		end
		table.sort(categories)
		for _, typeName in ipairs(categories) do
			local entry = selection[typeName]
			local detail = string.format(
				"id=%s value=%s price=%s count=%s",
				tostring(entry.id),
				tostring(entry.value),
				tostring(entry.price),
				tostring(entry.count)
			)
			if entry.topIDs and #entry.topIDs > 0 then
				detail = detail .. " topIDs=" .. table.concat(entry.topIDs, ",")
			end
			lines[#lines + 1] = string.format("%s: %s", typeName, detail)
		end
	end

	lines[#lines + 1] = ""
	lines[#lines + 1] = "-- Spell knowledge --"
	for _, entry in ipairs(ns.DIAGNOSTIC_SPELLS) do
		local spellID, label = entry[1], entry[2]
		local known = IsSpellKnown(spellID)
		if not known and IsPlayerSpell then
			known = IsPlayerSpell(spellID)
		end
		local name = GetSpellInfo(spellID)
		lines[#lines + 1] = string.format(
			"[%s] %s (%d)%s",
			known and "KNOWN" or "  -  ",
			label,
			spellID,
			name and (" = " .. name) or " (no name on this client)"
		)
	end

	lines[#lines + 1] = ""
	lines[#lines + 1] = "-- Display context --"
	local pw, ph = GetPhysicalScreenSize()
	lines[#lines + 1] = string.format("PhysicalScreenSize: %s x %s", tostring(pw), tostring(ph))
	lines[#lines + 1] = string.format("UIParent scale: %s", tostring(UIParent and UIParent:GetScale()))
	lines[#lines + 1] = string.format("uiScale CVar: %s", tostring(GetCVar("uiScale")))

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Item Selection
--------------------------------------------------------------------------------

--[[
    The "why did it pick that?" read-out. For every category that goes through
    the scanner's ranking ladder, prints the winner and the runners-up it beat,
    each tagged with the RANKING_PRIORITY field that decided the pair (see
    Features/Scanner-Inventory.lua). Reads only what the last scan left behind;
    it never rescans, so the report can never disagree with the macros the
    player is actually looking at.
]]

local function DescribeItem(itemID)
	if not itemID then
		return "(none)"
	end
	local name = GetItemInfo(itemID)
	if name then
		return string.format("%d (%s)", itemID, name)
	end
	return string.format("%d (name not cached)", itemID)
end

local function AppendCategoryLines(lines, typeName, entry, candidates)
	lines[#lines + 1] = string.format("%s: %s", typeName, DescribeItem(entry and entry.id))

	if entry and entry.id then
		lines[#lines + 1] = string.format(
			"    won with value=%s price=%s count=%s",
			tostring(entry.value),
			tostring(entry.price),
			tostring(entry.count)
		)
	end

	if entry and entry.topIDs and #entry.topIDs > 0 then
		lines[#lines + 1] = "    stacked /use order: " .. table.concat(entry.topIDs, ", ")
	end

	if not candidates or #candidates < 2 then
		return
	end

	for i = 2, #candidates do
		local candidate = candidates[i]
		lines[#lines + 1] = string.format(
			"    beat %s on %s (value=%s price=%s count=%s)",
			DescribeItem(candidate.id),
			candidate.decidedBy or "nothing (identical record)",
			tostring(candidate.value),
			tostring(candidate.price),
			tostring(candidate.count)
		)
	end
end

function ns:BuildSelectionReport()
	local lines = { GetClientHeader(), "" }

	local selection = ns.BestSelection
	local candidates = ns.DiagnosticCandidates

	if not selection then
		lines[#lines + 1] = "No scan has completed yet. Trigger one by looting an item or changing zone."
		return table.concat(lines, "\n")
	end

	--[[
        Candidate retention starts when the tools are enabled, so a report run
        before the next scan has winners but no runners-up. Say so rather than
        letting an empty list read as "nothing else was in the running."
    ]]
	local retained = false
	for _, list in pairs(candidates) do
		if #list > 0 then
			retained = true
			break
		end
	end

	lines[#lines + 1] = string.format("AllowBuffFood (live scan preference): %s", tostring(ns.AllowBuffFood))
	if not retained then
		lines[#lines + 1] = ""
		lines[#lines + 1] =
			"No candidates were retained: the last scan ran before these tools were enabled. Trigger a rescan (loot something, or change zone) and run this again to see the runners-up."
	end

	lines[#lines + 1] = ""
	lines[#lines + 1] = "-- Ranked by the selection ladder --"

	local typeNames = {}
	for _, def in ipairs(ns.RegisteredMacroDefs or {}) do
		if def.itemTypes then
			typeNames[#typeNames + 1] = def.typeName
		end
	end
	table.sort(typeNames)

	for _, typeName in ipairs(typeNames) do
		AppendCategoryLines(lines, typeName, selection[typeName], candidates[typeName])
	end

	--[[
        The custom definitions own their whole update and resolve their item
        outside the ladder (the Hunter pet-food scan, the Rogue poison walk),
        so they have no candidate list to show. Naming them keeps the report
        honest about what it does and does not cover.
    ]]
	local customNames = {}
	for _, def in ipairs(ns.RegisteredCustomMacroDefs or {}) do
		customNames[#customNames + 1] = def.typeName
	end
	table.sort(customNames)

	if #customNames > 0 then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "-- Resolved outside the ladder (no candidate ranking) --"
		for _, typeName in ipairs(customNames) do
			lines[#lines + 1] = string.format("%s: resolved by its own builder at macro-update time", typeName)
		end
		lines[#lines + 1] = string.format("Feed Pet current pick: %s", DescribeItem(ns.BestPetFoodID))
	end

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Other Add-ons
--------------------------------------------------------------------------------

function ns:BuildAddOnReport()
	local lines = { GetClientHeader(), "" }
	local getInfo = (C_AddOns and C_AddOns.GetAddOnInfo) or GetAddOnInfo
	local getMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
	local count = (C_AddOns and C_AddOns.GetNumAddOns and C_AddOns.GetNumAddOns()) or GetNumAddOns()
	for index = 1, count do
		local name, _, _, loadable = getInfo(index)
		local version = getMeta(index, "Version") or "?"
		lines[#lines + 1] = string.format("%s v%s [%s]", name, version, loadable and "loadable" or "disabled")
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

local function DumpTable(value, indent, depth, lines)
	if depth > 8 then
		lines[#lines + 1] = indent .. "<max depth>"
		return
	end
	local keys = {}
	for key in pairs(value) do
		keys[#keys + 1] = key
	end
	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	for _, key in ipairs(keys) do
		local entry = value[key]
		if type(entry) == "table" then
			--[[
                itemCache can hold hundreds of rows; summarize its size rather
                than dumping every entry (see DATA -- large arrays are described,
                not reproduced). Matched by key at any depth, since under AceDB
                it lives inside the active profile rather than at the root.
            ]]
			if key == "itemCache" then
				local count = 0
				for _ in pairs(entry) do
					count = count + 1
				end
				lines[#lines + 1] = indent .. tostring(key) .. string.format(" = <%d cached items>", count)
			else
				lines[#lines + 1] = indent .. tostring(key) .. " = {"
				DumpTable(entry, indent .. "    ", depth + 1, lines)
				lines[#lines + 1] = indent .. "}"
			end
		else
			lines[#lines + 1] = indent .. tostring(key) .. " = " .. tostring(entry)
		end
	end
end

function ns:BuildSavedVariablesReport()
	local lines = { GetClientHeader(), "" }

	--[[
        Dump the single AceDB-managed SavedVariable in its real on-disk shape
        (profiles / global / profileKeys). DumpTable summarizes any itemCache
        table it meets -- now nested under the active profile -- as
        "<N cached items>", so the report stays readable and read-only.
    ]]
	lines[#lines + 1] = "ConnoisseurDB = {"
	DumpTable(ConnoisseurDB or {}, "    ", 1, lines)
	lines[#lines + 1] = "}"

	--[[
        Restocker's own account-wide SavedVariable (see Features/Restocker/
        Restocker.lua). Its profiles hold one row per tracked item and can run
        long, so each profile is summarized as "<N items>" -- the same rule
        DumpTable applies to itemCache. The view table keeps this read-only.
    ]]
	local restockerDB = ConnoisseurRestockerDB or {}
	local restockerView = {}
	for key, entry in pairs(restockerDB) do
		restockerView[key] = entry
	end
	if type(restockerDB.profiles) == "table" then
		local profileSummaries = {}
		for name, profile in pairs(restockerDB.profiles) do
			if type(profile) == "table" then
				local count = 0
				for _ in pairs(profile) do
					count = count + 1
				end
				profileSummaries[name] = string.format("<%d items>", count)
			else
				profileSummaries[name] = tostring(profile)
			end
		end
		restockerView.profiles = profileSummaries
	end
	lines[#lines + 1] = ""
	lines[#lines + 1] = "ConnoisseurRestockerDB = {"
	DumpTable(restockerView, "    ", 1, lines)
	lines[#lines + 1] = "}"

	--[[
        MIGRATION (remove after 2026-08-15): also dump the legacy per-character
        table while the migration window is open, so a bug report from a user
        whose ConnoisseurCharDB hasn't been folded into a profile yet still
        carries their old configuration.
    ]]
	if ConnoisseurCharDB then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "ConnoisseurCharDB = {"
		DumpTable(ConnoisseurCharDB, "    ", 1, lines)
		lines[#lines + 1] = "}"
	end

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Library Versions
--------------------------------------------------------------------------------

function ns:BuildLibraryReport()
	local lines = { GetClientHeader(), "" }
	local names = {}
	for name in LibStub:IterateLibraries() do
		names[#names + 1] = name
	end
	table.sort(names)
	for _, name in ipairs(names) do
		lines[#lines + 1] = string.format("%s (minor %s)", name, tostring(LibStub.minors[name]))
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Taint Log
--------------------------------------------------------------------------------

--[[
    The taintLog CVar controls UI taint logging to Logs\taint.log. Level 2 logs
    both blocked actions and accesses to tainted globals; 0 is off. This is the
    only state the diagnostics panel ever writes.
]]

function ns:GetTaintLogState()
	return tonumber(GetCVar("taintLog")) or 0
end

function ns:SetTaintLog(enabled)
	SetCVar("taintLog", enabled and 2 or 0)
end
