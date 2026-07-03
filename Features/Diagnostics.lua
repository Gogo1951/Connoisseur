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
    TOOLS_ETRACE = "Live event tracing: use %s."
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
        L["ADDON_TITLE"], ns.Version, version, build, tocVersion,
        GetLocale(), tostring(WOW_PROJECT_ID)
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
    UNIT_AURA = true
}

function ns:StartEventLog()
    ns.diagnostics.log = {}
    ns.diagnostics.logging = true
end

function ns:StopEventLog()
    ns.diagnostics.logging = false
    ns.diagnostics.log = nil
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
    if ns.DIAGNOSTIC_EVENT_EXCLUDE[event] then return end
    local parts = {}
    for index = 1, select("#", ...) do
        if index > EVENT_LOG_MAX_ARGS then break end
        local raw = string.sub(tostring((select(index, ...))), 1, EVENT_LOG_MAX_ARG_LENGTH)
        parts[index] = (raw:gsub("|", "||"))
    end
    local log = ns.diagnostics.log
    log[#log + 1] = string.format("%.3f %s(%s)", GetTime(), event, table.concat(parts, ", "))
    if #log > EVENT_LOG_SIZE then
        table.remove(log, 1)
    end
end

function ns:BuildEventLogReport()
    local lines = {GetClientHeader(), ""}
    local log = ns.diagnostics.log
    if not log or #log == 0 then
        lines[#lines + 1] = "(no events captured)"
    else
        for _, entry in ipairs(log) do
            lines[#lines + 1] = entry
        end
    end
    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Event Registration
--------------------------------------------------------------------------------

--[[
    For every event the add-on registers (ns.CORE_EVENTS, exported by Core.lua),
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
    local lines = {GetClientHeader(), ""}
    local hasIsEventValid = type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function"
    local probe = GetProbeFrame()
    local failures = 0
    for _, event in ipairs(ns.CORE_EVENTS or {}) do
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
    {"C_AddOns.GetAddOnMetadata", function() return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnMetadata) == "function" end},
    {"GetAddOnMetadata (legacy)", function() return type(GetAddOnMetadata) == "function" end},
    {"C_AddOns.GetAddOnInfo", function() return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnInfo) == "function" end},
    {"GetAddOnInfo (legacy)", function() return type(GetAddOnInfo) == "function" end},
    {"C_AddOns.GetNumAddOns", function() return type(C_AddOns) == "table" and type(C_AddOns.GetNumAddOns) == "function" end},
    {"GetNumAddOns (legacy)", function() return type(GetNumAddOns) == "function" end},
    --[[
        C_Container has no legacy-global rows by design: GetContainerNumSlots /
        GetContainerItemInfo are absent on the target clients (Era 1.15.8 +
        TBC 2.5.5), where C_Container is the only container API. See the container shims in Utilities.
    ]]
    {"C_Container.GetContainerNumSlots", function() return type(C_Container) == "table" and type(C_Container.GetContainerNumSlots) == "function" end},
    {"C_Container.GetContainerItemInfo", function() return type(C_Container) == "table" and type(C_Container.GetContainerItemInfo) == "function" end},
    {"C_Map.GetBestMapForUnit", function() return type(C_Map) == "table" and type(C_Map.GetBestMapForUnit) == "function" end},
    {"IsInInstance", function() return type(IsInInstance) == "function" end},
    {"C_Item.GetItemCount", function() return type(C_Item) == "table" and type(C_Item.GetItemCount) == "function" end},
    {"GetItemCount (legacy)", function() return type(GetItemCount) == "function" end},
    {"C_Item.GetItemIconByID", function() return type(C_Item) == "table" and type(C_Item.GetItemIconByID) == "function" end},
    {"GetItemIcon (legacy)", function() return type(GetItemIcon) == "function" end},
    {"GetItemInfo", function() return type(GetItemInfo) == "function" end},
    {"GetMacroIndexByName", function() return type(GetMacroIndexByName) == "function" end},
    {"CreateMacro", function() return type(CreateMacro) == "function" end},
    {"EditMacro", function() return type(EditMacro) == "function" end},
    {"DeleteMacro", function() return type(DeleteMacro) == "function" end},
    {"GetMacroBody", function() return type(GetMacroBody) == "function" end},
    {"GetNumMacros", function() return type(GetNumMacros) == "function" end},
    {"GetPetFoodTypes", function() return type(GetPetFoodTypes) == "function" end},
    {"GetNumSkillLines", function() return type(GetNumSkillLines) == "function" end},
    {"GetSkillLineInfo", function() return type(GetSkillLineInfo) == "function" end},
    {"GetNumQuestLogEntries", function() return type(GetNumQuestLogEntries) == "function" end},
    {"GetQuestLogTitle", function() return type(GetQuestLogTitle) == "function" end},
    {"UnitAura", function() return type(UnitAura) == "function" end},
    {"GetSpellInfo", function() return type(GetSpellInfo) == "function" end},
    {"IsSpellKnown", function() return type(IsSpellKnown) == "function" end},
    {"IsPlayerSpell", function() return type(IsPlayerSpell) == "function" end},
    {"SecureCmdOptionParse", function() return type(SecureCmdOptionParse) == "function" end},
    {"C_Timer.After", function() return type(C_Timer) == "table" and type(C_Timer.After) == "function" end},
    {"C_EventUtils.IsEventValid", function() return type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function" end},
    {"GetCVar", function() return type(GetCVar) == "function" end},
    {"SetCVar", function() return type(SetCVar) == "function" end}
}

function ns:RunApiChecks()
    local lines = {GetClientHeader(), ""}
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
    {587, "Conjure Food (Rank 1)"},
    {5504, "Conjure Water (Rank 1)"},
    {759, "Conjure Mana Agate"},
    {43987, "Ritual of Refreshment"},
    {6201, "Create Healthstone (Minor)"},
    {693, "Create Soulstone (Minor)"},
    {29893, "Ritual of Souls"},
    {883, "Call Pet"},
    {6991, "Feed Pet"},
    {136, "Mend Pet"},
    {982, "Revive Pet"},
    {2641, "Dismiss Pet"},
    {20580, "Shadowmeld"}
}

function ns:BuildContextReport()
    local lines = {GetClientHeader(), ""}

    local _, classToken = UnitClass("player")
    lines[#lines + 1] = string.format(
        "Class: %s // Level: %s // Cached level: %s // Cached map: %s",
        tostring(classToken), tostring(UnitLevel("player")),
        tostring(ns.CachedPlayerLevel), tostring(ns.CachedMapID)
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
                tostring(entry.id), tostring(entry.value),
                tostring(entry.price), tostring(entry.count)
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
            known and "KNOWN" or "  -  ", label, spellID,
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
-- Other Add-ons
--------------------------------------------------------------------------------

function ns:BuildAddOnReport()
    local lines = {GetClientHeader(), ""}
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
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    for _, key in ipairs(keys) do
        local entry = value[key]
        if type(entry) == "table" then
            lines[#lines + 1] = indent .. tostring(key) .. " = {"
            DumpTable(entry, indent .. "    ", depth + 1, lines)
            lines[#lines + 1] = indent .. "}"
        else
            lines[#lines + 1] = indent .. tostring(key) .. " = " .. tostring(entry)
        end
    end
end

function ns:BuildSavedVariablesReport()
    local lines = {GetClientHeader(), ""}

    --[[
        itemCache can hold hundreds of rows; summarize its size rather than
        dumping every entry (see DATA — large arrays are described, not
        printed). Work on a shallow copy so the real saved table is never
        mutated, keeping the report read-only.
    ]]
    local accountView = {}
    for key, value in pairs(ConnoisseurDB or {}) do
        accountView[key] = value
    end
    if type(accountView.itemCache) == "table" then
        local count = 0
        for _ in pairs(accountView.itemCache) do
            count = count + 1
        end
        accountView.itemCache = string.format("<%d cached items>", count)
    end

    lines[#lines + 1] = "ConnoisseurDB = {"
    DumpTable(accountView, "    ", 1, lines)
    lines[#lines + 1] = "}"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "ConnoisseurCharDB = {"
    DumpTable(ConnoisseurCharDB or {}, "    ", 1, lines)
    lines[#lines + 1] = "}"
    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Library Versions
--------------------------------------------------------------------------------

function ns:BuildLibraryReport()
    local lines = {GetClientHeader(), ""}
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
