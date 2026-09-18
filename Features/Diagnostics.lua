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
	ENABLE_DESCRIPTION = "Shows the diagnostic reports and the event log below until you log out or turn it off.",
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
	READINESS_TITLE = "Readiness Report",
	READINESS_BUTTON = "Show Readiness Report",
	READINESS_HINT = "Renders the Readiness Report as it would print right now, without waiting for a ready check. The tool for 'I turned a switch on and nothing happened': it tells a report that is quiet because you are ready apart from one that never ran, and lists which switches are on.",
	SELECTION_HINT = "Shows what each macro picked and which runners-up it beat, naming the ranking step that decided each one. The tool for 'why did it choose that item?' reports. Candidates are only kept while these tools are enabled, so trigger a rescan (loot something, or change zone) after turning them on.",
	ADDONS_TITLE = "Other Add-ons",
	ADDONS_BUTTON = "List Installed Add-ons",
	SAVED_TITLE = "Saved Variables",
	SAVED_BUTTON = "Dump Saved Variables",
	LIBS_TITLE = "Library Versions",
	LIBS_BUTTON = "List Library Versions",
	VALIDATE_TITLE = "Validate Data: %s",
	VALIDATE_BUTTON = "Validate Data",
	VALIDATE_PROGRESS = "Validated %s / %s items...",
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

function ns.SetDiagnosticsEnabled(value)
	ns.diagnostics.enabled = value and true or false
	if not ns.diagnostics.enabled then
		ns.DiscardEventLog()
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
    Per-argument byte cap. A single item link (|cff...|Hitem:...|h[Name]|h|r)
    runs past 80 bytes and a shorter cap cuts it mid-name; 255 holds a full item
    link while still bounding a runaway argument.
]]
local EVENT_LOG_MAX_ARG_LENGTH = 255

--[[
    Events the capture tap can only COUNT, never classify. They are kept out of
    the buffer and folded into the suppressed-traffic summary instead, so the
    report still proves the event fired and how often.

    UNIT_AURA is the one entry, and it is here for a narrow reason: it is a
    firehose whose signal firings cannot be told apart AT CAPTURE. ns.LogEvent
    runs from Core's dispatcher BEFORE the real handler, so at that moment
    nothing yet knows whether this particular aura change moved anything the
    add-on tracks. Its signal firings are therefore logged from the other end --
    ns.HandleUnitAura (Features/Scanner-Character.lua) calls ns.LogEventNow once
    it has decided something changed, so a stale-macro report shows the aura
    change that preceded the rebuild in full, with the rest of the traffic
    counted beneath it.

    Nothing else belongs here. An event whose firings can be classified at
    capture uses ns.MESSAGE_ID_FILTERED_EVENTS below, and an event with no
    firehose problem is simply logged. The log only sees events routed through
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
    ERR_BANK_FULL (ns.OnRestockerUiErrorMessage, Restocker/Restocker-Events.lua) -- read
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
    Fold one firing into the suppressed-traffic tally, keyed by event plus the
    text that distinguishes firings worth telling apart. Shared by both routes
    into the summary: the excluded firehoses above, and the uncorrelated messages
    below.
]]
local function CountSuppressed(event, text)
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
end

--[[
    Decides, per firing, whether the entry is logged in full or folded into a
    counter. Suppressed traffic aggregates per message text (first-seen text plus
    a count) and renders as one compact block at the end of the report, so the
    report still proves what fired and how often -- and a tester can spot a
    message the add-on should be correlating and isn't.
]]
function ns.SuppressUncorrelatedMessage(event, ...)
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

	CountSuppressed(event, text)

	return true
end

function ns.StartEventLog()
	ns.diagnostics.log = {}
	ns.diagnostics.suppressed = {}
	ns.diagnostics.logging = true
end

--[[
    Stops capturing but KEEPS what was captured. The panel's buttons read Start,
    Stop, Show, so the obvious way to use them is start, reproduce the problem,
    stop, then read the report -- which only works if stopping keeps the buffer.

    Nothing leaks by holding it: Start replaces the buffer, and switching
    diagnostics off entirely releases it through ns.DiscardEventLog.
]]
function ns.StopEventLog()
	ns.diagnostics.logging = false
end

-- Stop and release the buffer, for when diagnostics is switched off altogether.
function ns.DiscardEventLog()
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
local function AppendLogEntry(event, ...)
	local log = ns.diagnostics.log
	if not log then
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
	log[#log + 1] = string.format("%.3f %s(%s)", GetTime(), event, table.concat(parts, ", "))
	if #log > EVENT_LOG_SIZE then
		table.remove(log, 1)
	end
end

function ns.LogEvent(event, ...)
	if ns.DIAGNOSTIC_EVENT_EXCLUDE[event] then
		--[[
		    Counted, not dropped: the first argument is what distinguishes these
		    firings from each other (UNIT_AURA's unit), so it is what the tally is
		    keyed by -- "UNIT_AURA(player) x319". The handler writes the full line
		    for the firings that mattered; see ns.LogEventNow.
		]]
		local first = select("#", ...) > 0 and tostring((select(1, ...))) or ""
		CountSuppressed(event, first)
		return
	end
	--[[
	    Filtered at capture, never at render: folding the spam only at display
	    time would still let it push the add-on's own events out of the bounded
	    buffer, and the report would come back clean and empty.
	]]
	if ns.SuppressUncorrelatedMessage(event, ...) then
		return
	end
	AppendLogEntry(event, ...)
end

--[[
    Write a full log line from inside a handler, for an event ns.LogEvent can
    only count because the capture tap runs before the handler and so cannot yet
    tell signal from noise (ns.DIAGNOSTIC_EVENT_EXCLUDE).

    The classification therefore comes from the handler that already made the
    decision, never from a second copy of its logic -- which is what stops the
    log from disagreeing with the code about what the add-on acted on. Call it
    only on firings the handler actually acted on; everything else is already in
    the suppressed tally.
]]
function ns.LogEventNow(event, ...)
	if not ns.diagnostics.logging then
		return
	end
	AppendLogEntry(event, ...)
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

function ns.BuildEventLogReport()
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

function ns.RunEventChecks()
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
    C_Bank.FetchPurchasedBankTabIDs) or reaches through a modern->legacy fallback gets a
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
		"C_AddOns.GetAddOnInfo",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnInfo) == "function"
		end,
	},
	{
		"C_AddOns.GetNumAddOns",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetNumAddOns) == "function"
		end,
	},
	--[[
	    C_Container is the container surface on all three target clients, so both
	    readers are probed there and nowhere else. Neither carries a legacy
	    fallback nor may be given one, so there is no legacy row to pair with
	    either (see the container shims in Utilities).
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
	--[[
	    The route ns.OpenOptionsPanel docks the panel with
	    (Options/Options.lua). A client that does not provide it falls through
	    to AceConfigDialog, which opens a standalone floating window instead of
	    docking -- so a report where this row FAILs is the one that explains a
	    panel the player says opened in the wrong place.
	]]
	{
		"Settings.OpenToCategory",
		function()
			return type(Settings) == "table" and type(Settings.OpenToCategory) == "function"
		end,
	},
	--[[
	    A frame method, read off UIParent because every frame shares one
	    metatable. The Restocker window's resize grip uses SetResizeBounds; if
	    this row FAILs the window still opens, it just cannot be resized.
	]]
	{
		"Frame:SetResizeBounds",
		function()
			return type(UIParent.SetResizeBounds) == "function"
		end,
	},
	{
		"IsInInstance",
		function()
			return type(IsInInstance) == "function"
		end,
	},
	--[[
	    All three load-bearing for the Restocker's entering-town reminder:
	    IsResting is the signal it keys off, UnitOnTaxi is what keeps a flight
	    path over a town from counting as arriving in one, and PlaySoundFile
	    plays the optional alert.
	]]
	{
		"IsResting",
		function()
			return type(IsResting) == "function"
		end,
	},
	{
		"UnitOnTaxi",
		function()
			return type(UnitOnTaxi) == "function"
		end,
	},
	{
		"PlaySoundFile",
		function()
			return type(PlaySoundFile) == "function"
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
		"C_Item.GetItemInfo",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemInfo) == "function"
		end,
	},
	{
		"C_Item.GetItemQualityColor",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemQualityColor) == "function"
		end,
	},
	-- Validate Data: item existence, and the instant fields every item row carries.
	{
		"C_Item.DoesItemExistByID",
		function()
			return type(C_Item) == "table" and type(C_Item.DoesItemExistByID) == "function"
		end,
	},
	{
		"C_Item.GetItemInfoInstant",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemInfoInstant) == "function"
		end,
	},
	--[[
	    Guarded in ns.WarmItemCache (Options/Options-Utilities.lua): without it
	    an options item list can only show ids the client already cached, so the
	    rows sit on their loading text until something else pulls the data.
	]]
	{
		"C_Item.RequestLoadItemDataByID",
		function()
			return type(C_Item) == "table" and type(C_Item.RequestLoadItemDataByID) == "function"
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
	--[[
	    The shims in Utilities that Forever needs: each client should PASS
	    exactly one side of every pair -- the namespaced reader on Forever, the
	    legacy global on Era and TBC.
	]]
	{
		"C_PetInfo.GetPetFoodTypes",
		function()
			return type(C_PetInfo) == "table" and type(C_PetInfo.GetPetFoodTypes) == "function"
		end,
	},
	{
		"GetPetFoodTypes (legacy)",
		function()
			return type(GetPetFoodTypes) == "function"
		end,
	},
	{
		"C_SkillInfo.GetNumSkillLines",
		function()
			return type(C_SkillInfo) == "table" and type(C_SkillInfo.GetNumSkillLines) == "function"
		end,
	},
	{
		"C_SkillInfo.GetSkillLineInfo",
		function()
			return type(C_SkillInfo) == "table" and type(C_SkillInfo.GetSkillLineInfo) == "function"
		end,
	},
	{
		"GetNumSkillLines (legacy)",
		function()
			return type(GetNumSkillLines) == "function"
		end,
	},
	{
		"GetSkillLineInfo (legacy)",
		function()
			return type(GetSkillLineInfo) == "function"
		end,
	},
	{
		"C_QuestLog.GetNumQuestLogEntries",
		function()
			return type(C_QuestLog) == "table" and type(C_QuestLog.GetNumQuestLogEntries) == "function"
		end,
	},
	{
		"C_QuestLog.GetInfo",
		function()
			return type(C_QuestLog) == "table" and type(C_QuestLog.GetInfo) == "function"
		end,
	},
	{
		"GetNumQuestLogEntries (legacy)",
		function()
			return type(GetNumQuestLogEntries) == "function"
		end,
	},
	{
		"GetQuestLogTitle (legacy)",
		function()
			return type(GetQuestLogTitle) == "function"
		end,
	},
	{
		"C_MerchantFrame.GetItemInfo",
		function()
			return type(C_MerchantFrame) == "table" and type(C_MerchantFrame.GetItemInfo) == "function"
		end,
	},
	{
		"GetMerchantItemInfo (legacy)",
		function()
			return type(GetMerchantItemInfo) == "function"
		end,
	},
	-- Forever's bank is its purchased tabs; Era and TBC read BANK_CONTAINER and the bank bags instead.
	{
		"C_Bank.FetchPurchasedBankTabIDs",
		function()
			return type(C_Bank) == "table" and type(C_Bank.FetchPurchasedBankTabIDs) == "function"
		end,
	},
	{
		"C_UnitAuras.GetBuffDataByIndex",
		function()
			return type(C_UnitAuras) == "table" and type(C_UnitAuras.GetBuffDataByIndex) == "function"
		end,
	},
	{
		"C_Secrets.ShouldAurasBeSecret",
		function()
			return type(C_Secrets) == "table" and type(C_Secrets.ShouldAurasBeSecret) == "function"
		end,
	},
	{
		"C_Secrets.CanCompareUnitTokens",
		function()
			return type(C_Secrets) == "table" and type(C_Secrets.CanCompareUnitTokens) == "function"
		end,
	},
	--[[
	    The Readiness Report's surface. Every one of these is reached only when
	    its own switch is on, so a missing one takes a whole line of the report
	    down and nothing else -- and does it silently, since a client with
	    scriptErrors off swallows the error. A FAIL here is the fastest
	    explanation for "I turned that on and the report went quiet". The
	    exceptions are GetNumTalentTabs and UnitCharacterPoints, which the
	    probes check before calling: they FAIL on Forever as expected, and their
	    lines simply never show there.
	]]
	{
		"GetWeaponEnchantInfo",
		function()
			return type(GetWeaponEnchantInfo) == "function"
		end,
	},
	{
		"GetInventoryItemDurability",
		function()
			return type(GetInventoryItemDurability) == "function"
		end,
	},
	{
		"GetInventoryItemLink",
		function()
			return type(GetInventoryItemLink) == "function"
		end,
	},
	{
		"GetNumTalentTabs",
		function()
			return type(GetNumTalentTabs) == "function"
		end,
	},
	{
		"C_SpecializationInfo.GetSpecializationInfo",
		function()
			return type(C_SpecializationInfo) == "table"
				and type(C_SpecializationInfo.GetSpecializationInfo) == "function"
		end,
	},
	{
		"UnitCharacterPoints",
		function()
			return type(UnitCharacterPoints) == "function"
		end,
	},
	{
		"UnitIsPVP",
		function()
			return type(UnitIsPVP) == "function"
		end,
	},
	{
		"C_Spell.GetSpellName",
		function()
			return type(C_Spell) == "table" and type(C_Spell.GetSpellName) == "function"
		end,
	},
	-- Validate Data reads each of these through C_Spell when the client has it, the legacy global otherwise.
	{
		"C_Spell.GetSpellInfo",
		function()
			return type(C_Spell) == "table" and type(C_Spell.GetSpellInfo) == "function"
		end,
	},
	{
		"GetSpellInfo (legacy)",
		function()
			return type(GetSpellInfo) == "function"
		end,
	},
	{
		"C_Spell.GetSpellSubtext",
		function()
			return type(C_Spell) == "table" and type(C_Spell.GetSpellSubtext) == "function"
		end,
	},
	{
		"GetSpellSubtext (legacy)",
		function()
			return type(GetSpellSubtext) == "function"
		end,
	},
	{
		"C_SpellBook.IsSpellInSpellBook",
		function()
			return type(C_SpellBook) == "table" and type(C_SpellBook.IsSpellInSpellBook) == "function"
		end,
	},
	{
		"C_SpellBook.IsSpellKnown",
		function()
			return type(C_SpellBook) == "table" and type(C_SpellBook.IsSpellKnown) == "function"
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
		"C_Item.GetItemFamily",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemFamily) == "function"
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

function ns.RunApiChecks()
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
	{ 2842, "Poisons" },
	{ 1784, "Stealth" },
	{ 20222, "Goblin Engineer" },
}

function ns.BuildContextReport()
	local lines = { GetClientHeader(), "" }

	local _, classToken = UnitClass("player")
	lines[#lines + 1] = string.format(
		"Class: %s // Level: %s // Cached level: %s // Cached map: %s",
		tostring(classToken),
		tostring(UnitLevel("player")),
		tostring(ns.cachedPlayerLevel),
		tostring(ns.cachedMapID)
	)

	-- The profession ranks the scanner's usability gates read (0 = unlearned).
	lines[#lines + 1] = string.format(
		"Skills: First Aid %s // Alchemy %s // Engineering %s",
		tostring(ns.currentFirstAidSkill),
		tostring(ns.currentAlchemySkill),
		tostring(ns.currentEngineeringSkill)
	)

	lines[#lines + 1] = ""
	lines[#lines + 1] = "-- Best-item selection --"
	lines[#lines + 1] = string.format("bestFoodID: %s", tostring(ns.bestFoodID))
	lines[#lines + 1] = string.format("bestPetFoodID: %s", tostring(ns.bestPetFoodID))
	if ns.scrollOverrideIDs and #ns.scrollOverrideIDs > 0 then
		lines[#lines + 1] = "scrollOverrideIDs: " .. table.concat(ns.scrollOverrideIDs, ", ")
	else
		lines[#lines + 1] = "scrollOverrideIDs: (none)"
	end
	lines[#lines + 1] = string.format("petBuffOverrideID: %s", tostring(ns.petBuffOverrideID))

	--[[
	    Per-category winners from the last ScanBags pass (ns.bestSelection is
	    the scanner's live best table). The read-out for "category X didn't
	    update" reports: it shows exactly what the scanner picked plus the
	    tiebreak inputs (value/price/count) the comparison ladder ordered on,
	    and the ranked topIDs for multi-use types — none of which bestFoodID
	    alone can reveal.
	]]
	local selection = ns.bestSelection
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
		local known = ns.IsSpellKnown(spellID) or ns.IsPlayerSpell(spellID)
		local name = C_Spell.GetSpellName(spellID)
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
	local physicalWidth, physicalHeight = GetPhysicalScreenSize()
	lines[#lines + 1] = string.format("PhysicalScreenSize: %s x %s", tostring(physicalWidth), tostring(physicalHeight))
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
	local name = C_Item.GetItemInfo(itemID)
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

function ns.BuildSelectionReport()
	local lines = { GetClientHeader(), "" }

	local selection = ns.bestSelection
	local candidates = ns.diagnosticCandidates

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

	lines[#lines + 1] = string.format("allowBuffFood (live scan preference): %s", tostring(ns.allowBuffFood))
	if not retained then
		lines[#lines + 1] = ""
		lines[#lines + 1] =
			"No candidates were retained: the last scan ran before these tools were enabled. Trigger a rescan (loot something, or change zone) and run this again to see the runners-up."
	end

	lines[#lines + 1] = ""
	lines[#lines + 1] = "-- Ranked by the selection ladder --"

	local typeNames = {}
	for _, definition in ipairs(ns.REGISTERED_MACRO_DEFINITIONS or {}) do
		if definition.itemTypes then
			typeNames[#typeNames + 1] = definition.typeName
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
	for _, definition in ipairs(ns.REGISTERED_CUSTOM_MACRO_DEFINITIONS or {}) do
		customNames[#customNames + 1] = definition.typeName
	end
	table.sort(customNames)

	if #customNames > 0 then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "-- Resolved outside the ladder (no candidate ranking) --"
		for _, typeName in ipairs(customNames) do
			lines[#lines + 1] = string.format("%s: resolved by its own builder at macro-update time", typeName)
		end
		lines[#lines + 1] = string.format("Feed Pet current pick: %s", DescribeItem(ns.bestPetFoodID))
	end

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Readiness Report
--------------------------------------------------------------------------------

--[[
    The Readiness Report as it would print RIGHT NOW, without waiting for a ready
    check. Read-only: it asks the same probes the report asks and prints nothing
    to chat.

    This exists because the report has two silences that look identical from a
    chat window -- "you are ready" and "it never ran" -- and only one of them is
    a bug. Rendering it on demand separates them in one button press, and the
    switch states below say which lines were even eligible to speak.

    Colour escapes are stripped: reports are plain text, and a |cff pasted into
    a bug report is noise.
]]
local READINESS_SWITCHES = {
	"readinessFlask",
	"readinessWellFed",
	"readinessPetWellFed",
	"readinessScrolls",
	"readinessSoulstone",
	"readinessMainHandBuff",
	"readinessOffHandBuff",
	"readinessExpiring",
	"readinessHealthstone",
	"readinessManaGem",
	"readinessHealingPotion",
	"readinessManaPotion",
	"readinessBandages",
	"readinessDurability",
	"readinessSpec",
	"readinessPvP",
	"readinessQuestionableGear",
}

function ns.BuildReadinessDiagnosticReport()
	local lines = { GetClientHeader(), "" }

	local reports = ns.db and ns.db.global
	if not reports then
		lines[#lines + 1] = "Saved variables are not loaded yet."
		return table.concat(lines, "\n")
	end

	lines[#lines + 1] = string.format("Report enabled: %s", tostring(reports.readinessReportEnabled))
	lines[#lines + 1] = string.format("Instance type: %s", tostring(select(2, IsInInstance())))
	lines[#lines + 1] = string.format("In group: %s", tostring(IsInGroup()))

	lines[#lines + 1] = ""
	lines[#lines + 1] = "-- What it would print now --"

	local body = ns.BuildReadinessLines(select(2, IsInInstance()) == "arena")
	if not body then
		lines[#lines + 1] = "(nothing -- this character has nothing the report would name)"
	else
		lines[#lines + 1] = ns.L["READINESS_TITLE"]
		for _, line in ipairs(body) do
			lines[#lines + 1] = line
		end
	end

	lines[#lines + 1] = ""
	lines[#lines + 1] = "-- Category switches --"
	for _, key in ipairs(READINESS_SWITCHES) do
		lines[#lines + 1] = string.format("[%s] %s", reports[key] and "ON " or "   ", key)
	end

	local text = table.concat(lines, "\n")
	-- Item links (Damaged / Non-Combat Gear) survive the color strip; escaping them makes the paste plain text.
	return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|", "||"))
end

--------------------------------------------------------------------------------
-- Other Add-ons
--------------------------------------------------------------------------------

function ns.BuildAddOnReport()
	local lines = { GetClientHeader(), "" }
	local getInfo = C_AddOns.GetAddOnInfo
	local getMetadata = C_AddOns.GetAddOnMetadata
	local count = C_AddOns.GetNumAddOns()
	for index = 1, count do
		local name, _, _, loadable = getInfo(index)
		local version = getMetadata(index, "Version") or "?"
		lines[#lines + 1] = string.format("%s v%s [%s]", name, version, loadable and "loadable" or "disabled")
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

--[[
    Tables counted rather than printed, because they run to hundreds of rows and
    a report has to stay readable (see DATA -- large arrays are described, not
    reproduced).

    itemCache is matched by key at any depth, since under AceDB it moves around
    with the active profile. The restock lists are matched by the exact path
    their container sits at, so no other table that happens to share the key
    is ever summarized -- AceDB's own profiles table, one level up, must print
    in full, since it holds the settings a bug report is about.
]]
local SUMMARIZED_BY_KEY = {
	itemCache = "cached items",
}

local SUMMARIZED_CHILDREN_BY_PATH = {
	["global.restocker.lists"] = "items",
}

local function CountEntries(value)
	local count = 0
	for _ in pairs(value) do
		count = count + 1
	end
	return count
end

local function DumpTable(value, indent, depth, lines, path)
	if depth > 8 then
		lines[#lines + 1] = indent .. "<max depth>"
		return
	end
	local childNoun = SUMMARIZED_CHILDREN_BY_PATH[path]
	local keys = {}
	for key in pairs(value) do
		keys[#keys + 1] = key
	end
	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	for _, key in ipairs(keys) do
		local entry = value[key]
		local noun = type(entry) == "table" and (childNoun or SUMMARIZED_BY_KEY[key])
		if type(entry) ~= "table" then
			lines[#lines + 1] = indent .. tostring(key) .. " = " .. tostring(entry)
		elseif noun then
			lines[#lines + 1] = indent .. tostring(key) .. string.format(" = <%d %s>", CountEntries(entry), noun)
		else
			lines[#lines + 1] = indent .. tostring(key) .. " = {"
			local childPath = (path == "") and tostring(key) or (path .. "." .. tostring(key))
			DumpTable(entry, indent .. "    ", depth + 1, lines, childPath)
			lines[#lines + 1] = indent .. "}"
		end
	end
end

function ns.BuildSavedVariablesReport()
	local lines = { GetClientHeader(), "" }

	--[[
	    Dump the single AceDB-managed SavedVariable in its real on-disk shape
	    (profiles / global / profileKeys). Everything the add-on saves is in
	    here, the Restock Lists included. DumpTable counts rather than prints the
	    two tables that run long -- any itemCache it meets, and each restock list
	    under global.restocker.lists -- so the report stays readable, and it
	    never writes.
	]]
	lines[#lines + 1] = "ConnoisseurDB = {"
	DumpTable(ConnoisseurDB or {}, "    ", 1, lines, "")
	lines[#lines + 1] = "}"

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Library Versions
--------------------------------------------------------------------------------

function ns.BuildLibraryReport()
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
-- Validate Data
--------------------------------------------------------------------------------

local function Keys(source)
	local ids = {}
	for id in pairs(source) do
		ids[#ids + 1] = id
	end
	return ids
end

local function Values(source)
	local ids = {}
	for _, id in pairs(source) do
		ids[#ids + 1] = id
	end
	return ids
end

-- One field of every row, by index for row arrays and by name for keyed rows.
local function Column(field)
	return function(source)
		local ids = {}
		for _, row in pairs(source) do
			ids[#ids + 1] = row[field]
		end
		return ids
	end
end

-- Named fields of one table, for the single-ID constants.
local function Named(fields)
	return function(source)
		local ids = {}
		for _, field in ipairs(fields) do
			ids[#ids + 1] = source[field]
		end
		return ids
	end
end

local function UpgradeTierItems(chains)
	local ids = {}
	for _, chain in ipairs(chains) do
		for _, tier in ipairs(chain.tiers) do
			ids[#ids + 1] = tier[2]
		end
	end
	return ids
end

local function RecipeReagents(recipes)
	local ids = {}
	for _, recipe in ipairs(recipes) do
		for _, reagent in ipairs(recipe[2]) do
			ids[#ids + 1] = reagent[1]
		end
	end
	return ids
end

local function ScrollColumn(index)
	return function(scrollData)
		local ids = {}
		for _, scrollType in pairs(scrollData) do
			for _, row in ipairs(scrollType.items) do
				ids[#ids + 1] = row[index]
			end
		end
		return ids
	end
end

local function ScrollConflictSpells(scrollData)
	local ids = {}
	for _, scrollType in pairs(scrollData) do
		for spellID in pairs(scrollType.conflictSpells) do
			ids[#ids + 1] = spellID
		end
	end
	return ids
end

local function ConjureSpellIDs(conjureSpells)
	local ids = {}
	for _, spellList in pairs(conjureSpells) do
		for _, entry in ipairs(spellList) do
			ids[#ids + 1] = entry[1]
		end
	end
	return ids
end

--[[
    ns.CONJURED_ITEM_IDS_BY_SPELL is filled by both Healthstones.lua and
    Mana-Gems.lua. A row belongs to Healthstones when it conjures a Healthstone
    and to Mana Gems otherwise, so every row is validated exactly once.
]]
local function ConjuresHealthstone(itemIDs)
	for _, itemID in ipairs(itemIDs) do
		if ns.RAW_DATA.Healthstone[itemID] then
			return true
		end
	end
	return false
end

local function ConjureRows(healthstones, readRow)
	return function(conjured)
		local ids = {}
		for spellID, itemIDs in pairs(conjured) do
			if ConjuresHealthstone(itemIDs) == healthstones then
				readRow(ids, spellID, itemIDs)
			end
		end
		return ids
	end
end

local function AddConjureSpell(ids, spellID)
	ids[#ids + 1] = spellID
end

local function AddConjuredItems(ids, _, itemIDs)
	for _, itemID in ipairs(itemIDs) do
		ids[#ids + 1] = itemID
	end
end

--[[
    Every spell and item ID the Data/ files ship, one entry per file. Each table
    names its source, whether its IDs are items or spells, and idsOf, which
    returns the IDs to validate. A data file missing from here is one the
    validator never checks.
]]
ns.DIAGNOSTIC_DATA_SOURCES = {
	{
		label = "Bandages.lua",
		tables = {
			{ name = "ns.RAW_DATA.Bandage", source = ns.RAW_DATA.Bandage, kind = "item", idsOf = Keys },
		},
	},
	{
		label = "Consumable-Upgrade-Paths.lua",
		tables = {
			{
				name = "ns.CONSUMABLE_UPGRADE_CHAINS",
				source = ns.CONSUMABLE_UPGRADE_CHAINS,
				kind = "item",
				idsOf = UpgradeTierItems,
			},
		},
	},
	{
		label = "Elixirs.lua",
		tables = {
			{ name = "ns.FLASK_BUFF_IDS", source = ns.FLASK_BUFF_IDS, kind = "spell", idsOf = Keys },
			{ name = "ns.ELIXIR_BUFF_IDS", source = ns.ELIXIR_BUFF_IDS, kind = "spell", idsOf = Keys },
		},
	},
	{
		label = "Explosives.lua",
		tables = {
			{ name = "ns.RAW_DATA.Explosives", source = ns.RAW_DATA.Explosives, kind = "item", idsOf = Keys },
			{
				name = "ns.RAW_DATA.Explosives (required spell)",
				source = ns.RAW_DATA.Explosives,
				kind = "spell",
				idsOf = Column(4),
			},
		},
	},
	{
		label = "Food-and-Water.lua",
		tables = {
			{ name = "ns.RAW_DATA.FoodAndWater", source = ns.RAW_DATA.FoodAndWater, kind = "item", idsOf = Keys },
		},
	},
	{
		label = "Healthstones.lua",
		tables = {
			{ name = "ns.RAW_DATA.Healthstone", source = ns.RAW_DATA.Healthstone, kind = "item", idsOf = Keys },
			{
				name = "ns.CONJURED_ITEM_IDS_BY_SPELL",
				source = ns.CONJURED_ITEM_IDS_BY_SPELL,
				kind = "spell",
				idsOf = ConjureRows(true, AddConjureSpell),
			},
			{
				name = "ns.CONJURED_ITEM_IDS_BY_SPELL",
				source = ns.CONJURED_ITEM_IDS_BY_SPELL,
				kind = "item",
				idsOf = ConjureRows(true, AddConjuredItems),
			},
		},
	},
	{
		label = "Mana-Gems.lua",
		tables = {
			{ name = "ns.RAW_DATA.ManaGem", source = ns.RAW_DATA.ManaGem, kind = "item", idsOf = Keys },
			{ name = "ns.RAW_DATA.ManaRune", source = ns.RAW_DATA.ManaRune, kind = "item", idsOf = Keys },
			{
				name = "ns.CONJURED_ITEM_IDS_BY_SPELL",
				source = ns.CONJURED_ITEM_IDS_BY_SPELL,
				kind = "spell",
				idsOf = ConjureRows(false, AddConjureSpell),
			},
			{
				name = "ns.CONJURED_ITEM_IDS_BY_SPELL",
				source = ns.CONJURED_ITEM_IDS_BY_SPELL,
				kind = "item",
				idsOf = ConjureRows(false, AddConjuredItems),
			},
		},
	},
	{
		label = "Pet-Foods.lua",
		tables = {
			{ name = "ns.PET_FOOD_DATA", source = ns.PET_FOOD_DATA, kind = "item", idsOf = Keys },
		},
	},
	{
		label = "Poison-Recipes.lua",
		tables = {
			{ name = "ns.POISON_RECIPES (crafted)", source = ns.POISON_RECIPES, kind = "item", idsOf = Column(1) },
			{
				name = "ns.POISON_RECIPES (reagents)",
				source = ns.POISON_RECIPES,
				kind = "item",
				idsOf = RecipeReagents,
			},
		},
	},
	{
		label = "Poisons.lua",
		tables = {
			{ name = "ns.POISON_DATA", source = ns.POISON_DATA, kind = "item", idsOf = Keys },
			{ name = "ns.POISON_GROUP_BASE_ITEMS", source = ns.POISON_GROUP_BASE_ITEMS, kind = "item", idsOf = Values },
		},
	},
	{
		label = "Potions.lua",
		tables = {
			{ name = "ns.RAW_DATA.Potions", source = ns.RAW_DATA.Potions, kind = "item", idsOf = Keys },
		},
	},
	{
		label = "Questionable-Equipment.lua",
		tables = {
			{ name = "ns.QUESTIONABLE_EQUIPMENT", source = ns.QUESTIONABLE_EQUIPMENT, kind = "item", idsOf = Keys },
		},
	},
	{
		label = "Scrolls.lua",
		tables = {
			{ name = "ns.SCROLL_DATA items", source = ns.SCROLL_DATA, kind = "item", idsOf = ScrollColumn(1) },
			{ name = "ns.SCROLL_DATA buffs", source = ns.SCROLL_DATA, kind = "spell", idsOf = ScrollColumn(2) },
			{
				name = "ns.SCROLL_DATA conflictSpells",
				source = ns.SCROLL_DATA,
				kind = "spell",
				idsOf = ScrollConflictSpells,
			},
		},
	},
	{
		label = "Soulstones.lua",
		tables = {
			{ name = "ns.RAW_DATA.Soulstone", source = ns.RAW_DATA.Soulstone, kind = "item", idsOf = Keys },
			{
				name = "ns.SOULSTONE_BUFF_SPELL_IDS",
				source = ns.SOULSTONE_BUFF_SPELL_IDS,
				kind = "spell",
				idsOf = Values,
			},
		},
	},
	{
		label = "Data.lua",
		tables = {
			{ name = "ns.CONJURE_SPELLS", source = ns.CONJURE_SPELLS, kind = "spell", idsOf = ConjureSpellIDs },
			{ name = "ns.WELL_FED_BUFF_IDS", source = ns.WELL_FED_BUFF_IDS, kind = "spell", idsOf = Keys },
			{
				name = "ns.MISSING_SPELL_MESSAGE_IDS",
				source = ns.MISSING_SPELL_MESSAGE_IDS,
				kind = "spell",
				idsOf = Values,
			},
			{
				name = "ns.*_SPELL_ID and ns.*_BUFF_ID",
				source = ns,
				kind = "spell",
				idsOf = Named({
					"CALL_PET_SPELL_ID",
					"DISMISS_PET_SPELL_ID",
					"DRUID_BEAR_FORM_SPELL_ID",
					"DRUID_CAT_FORM_SPELL_ID",
					"DRUID_DIRE_BEAR_FORM_SPELL_ID",
					"FEED_PET_SPELL_ID",
					"KIBLERS_BUFF_ID",
					"MEND_PET_SPELL_ID",
					"POISONS_SPELL_ID",
					"REVIVE_PET_SPELL_ID",
					"SHADOWMELD_SPELL_ID",
					"SPORELING_BUFF_ID",
					"STEALTH_SPELL_ID",
				}),
			},
			{
				name = "ns.MACRO_CONFIG defaultID",
				source = ns.MACRO_CONFIG,
				kind = "item",
				idsOf = Column("defaultID"),
			},
			{
				name = "ns.*_ITEM_ID",
				source = ns,
				kind = "item",
				idsOf = Named({ "KIBLERS_BITS_ITEM_ID", "SPORELING_SNACKS_ITEM_ID" }),
			},
		},
	},
}

local SPELL_COLUMNS = {
	"STATUS",
	"Spell ID",
	"Source",
	"Name",
	"Subtext",
	"Icon",
	"Cast Time",
	"Min Range",
	"Max Range",
	"IsPlayerSpell",
	"IsSpellKnown",
}

-- C_Item.GetItemInfo's seventeen returns, in order, then C_Item.GetItemInfoInstant's fields after the ID it repeats.
local ITEM_COLUMNS = {
	"STATUS",
	"Item ID",
	"Source",
	"Name",
	"Link",
	"Quality",
	"Item Level",
	"Min Level",
	"Type",
	"Subtype",
	"Stack Count",
	"Equip Location",
	"Texture",
	"Sell Price",
	"Class ID",
	"Subclass ID",
	"Bind Type",
	"Expansion ID",
	"Set ID",
	"Crafting Reagent",
	"Instant Type",
	"Instant Subtype",
	"Instant Equip Location",
	"Instant Icon",
	"Instant Class ID",
	"Instant Subclass ID",
}
local ITEM_INFO_RETURNS = 17

local VALIDATE_BATCH_SIZE = 100
local VALIDATE_POLL_SECONDS = 0.2

--[[
    Polls that resolved nothing new before the stragglers are flagged NOT ON
    CLIENT. Counting idle polls rather than all of them means a slow load that
    is still moving is never cut off.
]]
local VALIDATE_MAX_IDLE_POLLS = 25

-- Tabs and newlines would split the TSV, and a raw pipe would render as an escape.
local function Cell(value)
	if value == nil then
		return ""
	end
	return (tostring(value):gsub("[\t\r\n]", " "):gsub("|", "||"))
end

local function WithCommas(number)
	local text = tostring(number)
	local replaced
	repeat
		text, replaced = text:gsub("^(%d+)(%d%d%d)", "%1,%2")
	until replaced == 0
	return text
end

local function CollectValidationRows(entry)
	local spellRows, itemRows = {}, {}
	for _, dataTable in ipairs(entry.tables) do
		local seen, ids = {}, {}
		for _, id in ipairs(dataTable.idsOf(dataTable.source)) do
			if not seen[id] then
				seen[id] = true
				ids[#ids + 1] = id
			end
		end
		table.sort(ids)

		local rows = (dataTable.kind == "spell") and spellRows or itemRows
		for _, id in ipairs(ids) do
			rows[#rows + 1] = { id = id, source = dataTable.name }
		end
	end
	return spellRows, itemRows
end

local function ReadSpell(spellID)
	local name, icon, castTime, minRange, maxRange
	if type(C_Spell) == "table" and C_Spell.GetSpellInfo then
		local info = C_Spell.GetSpellInfo(spellID)
		if info then
			name, icon, castTime, minRange, maxRange =
				info.name, info.iconID, info.castTime, info.minRange, info.maxRange
		end
	else
		local _
		name, _, icon, castTime, minRange, maxRange = GetSpellInfo(spellID)
	end

	local subtext
	if type(C_Spell) == "table" and C_Spell.GetSpellSubtext then
		subtext = C_Spell.GetSpellSubtext(spellID)
	elseif GetSpellSubtext then
		subtext = GetSpellSubtext(spellID)
	end

	return name, subtext, icon, castTime, minRange, maxRange
end

local function ReadItem(row)
	local info = { C_Item.GetItemInfo(row.id) }
	if info[1] == nil then
		return false
	end
	row.info = info
	row.status = "OK"
	return true
end

local function BuildValidationReport(spellRows, itemRows)
	local lines = { GetClientHeader(), "" }

	if #spellRows > 0 then
		lines[#lines + 1] = table.concat(SPELL_COLUMNS, "\t")
		for _, row in ipairs(spellRows) do
			local name, subtext, icon, castTime, minRange, maxRange = ReadSpell(row.id)
			lines[#lines + 1] = table.concat({
				name and "OK" or "NOT ON CLIENT",
				Cell(row.id),
				Cell(row.source),
				Cell(name),
				Cell(subtext),
				Cell(icon),
				Cell(castTime),
				Cell(minRange),
				Cell(maxRange),
				Cell(ns.IsPlayerSpell(row.id)),
				Cell(ns.IsSpellKnown(row.id)),
			}, "\t")
		end
	end

	if #itemRows > 0 then
		if #spellRows > 0 then
			lines[#lines + 1] = ""
		end
		lines[#lines + 1] = table.concat(ITEM_COLUMNS, "\t")
		for _, row in ipairs(itemRows) do
			local cells = { row.status, Cell(row.id), Cell(row.source) }
			for index = 1, ITEM_INFO_RETURNS do
				cells[#cells + 1] = Cell(row.info and row.info[index])
			end
			local instant = { C_Item.GetItemInfoInstant(row.id) }
			for index = 2, 7 do
				cells[#cells + 1] = Cell(instant[index])
			end
			lines[#lines + 1] = table.concat(cells, "\t")
		end
	end

	return table.concat(lines, "\n")
end

--[[
    Validates one ns.DIAGNOSTIC_DATA_SOURCES entry into ns.diagnostics[field],
    calling onUpdate after every rewrite so the panel redraws. Spells answer at
    once; item data loads asynchronously, so items are requested about a hundred
    per frame and then polled, with a progress line standing in until the
    finished TSV replaces it. A second press restarts the section, and turning
    the tools off stops it where it is.
]]
function ns.RunDataValidation(index, field, onUpdate)
	local spellRows, itemRows = CollectValidationRows(ns.DIAGNOSTIC_DATA_SOURCES[index])

	ns.diagnostics.validationRuns = ns.diagnostics.validationRuns or {}
	local runs = ns.diagnostics.validationRuns
	local run = {}
	runs[index] = run

	local canCheckExists = type(C_Item) == "table" and C_Item.DoesItemExistByID ~= nil
	local canRequestLoad = type(C_Item) == "table" and C_Item.RequestLoadItemDataByID ~= nil
	local requested, validated, idlePolls = 0, 0, 0

	local function Step()
		if runs[index] ~= run or not ns.diagnostics.enabled then
			return
		end

		if requested < #itemRows then
			for position = requested + 1, math.min(requested + VALIDATE_BATCH_SIZE, #itemRows) do
				local row = itemRows[position]
				if canCheckExists and not C_Item.DoesItemExistByID(row.id) then
					row.status = "NOT ON CLIENT"
					validated = validated + 1
				elseif ReadItem(row) then
					validated = validated + 1
				elseif canRequestLoad then
					C_Item.RequestLoadItemDataByID(row.id)
				end
				requested = position
			end
		else
			local resolvedAny = false
			for _, row in ipairs(itemRows) do
				if not row.status and ReadItem(row) then
					validated = validated + 1
					resolvedAny = true
				end
			end
			idlePolls = resolvedAny and 0 or (idlePolls + 1)
		end

		if validated == #itemRows or idlePolls >= VALIDATE_MAX_IDLE_POLLS then
			for _, row in ipairs(itemRows) do
				row.status = row.status or "NOT ON CLIENT"
			end
			runs[index] = nil
			ns.diagnostics[field] = BuildValidationReport(spellRows, itemRows)
			onUpdate()
			return
		end

		ns.diagnostics[field] = GetClientHeader()
			.. "\n\n"
			.. string.format(ns.DiagnosticsStrings.VALIDATE_PROGRESS, WithCommas(validated), WithCommas(#itemRows))
		onUpdate()
		C_Timer.After((requested < #itemRows) and 0 or VALIDATE_POLL_SECONDS, Step)
	end

	Step()
end

--------------------------------------------------------------------------------
-- Taint Log
--------------------------------------------------------------------------------

--[[
    The taintLog CVar controls UI taint logging to Logs\taint.log. Level 2 logs
    both blocked actions and accesses to tainted globals; 0 is off. This is the
    only state the diagnostics panel ever writes.
]]

function ns.GetTaintLogState()
	return tonumber(GetCVar("taintLog")) or 0
end

function ns.SetTaintLog(enabled)
	SetCVar("taintLog", enabled and 2 or 0)
end
