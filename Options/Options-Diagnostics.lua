local _, ns = ...

local DiagnosticsStrings = ns.DiagnosticsStrings
local GetColor = ns.GetColor
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Diagnostic Tools Panel
--------------------------------------------------------------------------------

--[[
    A single runtime toggle gates the whole panel. When off, only the warning
    text and the enable toggle are visible; everything below is hidden. Every
    gated section hides on that one condition, so the local SectionHeader
    builder bakes it in rather than repeating it per widget.
]]

local function DiagnosticsOn()
	return ns.diagnostics and ns.diagnostics.enabled == true
end

local function Hidden()
	return not DiagnosticsOn()
end

local function Refresh()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.Diagnostics)
end

local function SectionHeader(text, order)
	return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order, hidden = Hidden }
end

local function ReportOutput(field, order)
	return {
		type = "input",
		name = "",
		multiline = 12,
		width = "full",
		order = order,
		hidden = Hidden,
		get = function()
			return ns.diagnostics[field] or ""
		end,
		set = function() end,
	}
end

function ns.BuildDiagnosticsOptions()
	local args = {
		descWarning = ns.OptionsDesc(DiagnosticsStrings.WARNING, 1),
		spaceEnable = ns.OptionsSpacer(2),
		toggleEnable = {
			type = "toggle",
			name = DiagnosticsStrings.ENABLE,
			desc = DiagnosticsStrings.ENABLE_DESCRIPTION,
			width = "full",
			order = 3,
			get = function()
				return DiagnosticsOn()
			end,
			set = function(_, value)
				ns.SetDiagnosticsEnabled(value)
				Refresh()
			end,
		},

		-- Event Log
		headerEventLog = SectionHeader(DiagnosticsStrings.EVENT_LOG_TITLE, 5),
		buttonStartLog = {
			type = "execute",
			name = DiagnosticsStrings.EVENT_LOG_START,
			order = 6,
			hidden = Hidden,
			func = function()
				ns.StartEventLog()
				Refresh()
			end,
		},
		buttonStopLog = {
			type = "execute",
			name = DiagnosticsStrings.EVENT_LOG_STOP,
			order = 7,
			hidden = Hidden,
			func = function()
				ns.StopEventLog()
				Refresh()
			end,
		},
		buttonShowLog = {
			type = "execute",
			name = DiagnosticsStrings.EVENT_LOG_SHOW,
			order = 8,
			hidden = Hidden,
			func = function()
				ns.diagnostics.eventLogReport = ns.BuildEventLogReport()
				Refresh()
			end,
		},
		outputEventLog = ReportOutput("eventLogReport", 9),
		descEventLogHint = {
			type = "description",
			name = GetColor("BODY") .. DiagnosticsStrings.EVENT_LOG_HINT .. "|r",
			fontSize = "medium",
			order = 10,
			hidden = Hidden,
		},

		-- Event Registration
		headerEvents = SectionHeader(DiagnosticsStrings.EVENTS_TITLE, 13),
		buttonEvents = {
			type = "execute",
			name = DiagnosticsStrings.EVENTS_BUTTON,
			order = 14,
			hidden = Hidden,
			func = function()
				ns.diagnostics.eventsReport = ns.RunEventChecks()
				Refresh()
			end,
		},
		outputEvents = ReportOutput("eventsReport", 15),

		-- API Endpoints
		headerApi = SectionHeader(DiagnosticsStrings.API_TITLE, 20),
		buttonApi = {
			type = "execute",
			name = DiagnosticsStrings.API_BUTTON,
			order = 21,
			hidden = Hidden,
			func = function()
				ns.diagnostics.apiReport = ns.RunApiChecks()
				Refresh()
			end,
		},
		outputApi = ReportOutput("apiReport", 22),

		-- Connoisseur Context
		headerContext = SectionHeader(DiagnosticsStrings.CONTEXT_TITLE, 25),
		buttonContext = {
			type = "execute",
			name = DiagnosticsStrings.CONTEXT_BUTTON,
			order = 26,
			hidden = Hidden,
			func = function()
				ns.diagnostics.contextReport = ns.BuildContextReport()
				Refresh()
			end,
		},
		outputContext = ReportOutput("contextReport", 27),

		-- Item Selection
		headerSelection = SectionHeader(DiagnosticsStrings.SELECTION_TITLE, 28),
		buttonSelection = {
			type = "execute",
			name = DiagnosticsStrings.SELECTION_BUTTON,
			order = 29,
			hidden = Hidden,
			func = function()
				ns.diagnostics.selectionReport = ns.BuildSelectionReport()
				Refresh()
			end,
		},
		outputSelection = ReportOutput("selectionReport", 30),
		descSelectionHint = {
			type = "description",
			name = GetColor("BODY") .. DiagnosticsStrings.SELECTION_HINT .. "|r",
			fontSize = "medium",
			order = 31,
			hidden = Hidden,
		},

		-- Readiness Report
		headerReadiness = SectionHeader(DiagnosticsStrings.READINESS_TITLE, 32),
		buttonReadiness = {
			type = "execute",
			name = DiagnosticsStrings.READINESS_BUTTON,
			order = 33,
			hidden = Hidden,
			func = function()
				ns.diagnostics.readinessReport = ns.BuildReadinessDiagnosticReport()
				Refresh()
			end,
		},
		outputReadiness = ReportOutput("readinessReport", 34),
		descReadinessHint = {
			type = "description",
			name = GetColor("BODY") .. DiagnosticsStrings.READINESS_HINT .. "|r",
			fontSize = "medium",
			order = 35,
			hidden = Hidden,
		},

		-- Other Add-ons
		headerAddons = SectionHeader(DiagnosticsStrings.ADDONS_TITLE, 36),
		buttonAddons = {
			type = "execute",
			name = DiagnosticsStrings.ADDONS_BUTTON,
			order = 37,
			hidden = Hidden,
			func = function()
				ns.diagnostics.addOnReport = ns.BuildAddOnReport()
				Refresh()
			end,
		},
		outputAddons = ReportOutput("addOnReport", 38),

		-- Saved Variables
		headerSaved = SectionHeader(DiagnosticsStrings.SAVED_TITLE, 40),
		buttonSaved = {
			type = "execute",
			name = DiagnosticsStrings.SAVED_BUTTON,
			order = 41,
			hidden = Hidden,
			func = function()
				ns.diagnostics.savedReport = ns.BuildSavedVariablesReport()
				Refresh()
			end,
		},
		outputSaved = ReportOutput("savedReport", 42),

		-- Library Versions
		headerLibs = SectionHeader(DiagnosticsStrings.LIBS_TITLE, 50),
		buttonLibs = {
			type = "execute",
			name = DiagnosticsStrings.LIBS_BUTTON,
			order = 51,
			hidden = Hidden,
			func = function()
				ns.diagnostics.libraryReport = ns.BuildLibraryReport()
				Refresh()
			end,
		},
		outputLibs = ReportOutput("libraryReport", 52),

		-- Taint Log
		headerTaint = SectionHeader(DiagnosticsStrings.TAINT_TITLE, 160),
		descTaintState = {
			type = "description",
			name = function()
				return GetColor("BODY") .. string.format(DiagnosticsStrings.TAINT_STATE, ns.GetTaintLogState()) .. "|r"
			end,
			fontSize = "medium",
			order = 161,
			hidden = Hidden,
		},
		buttonTaintOn = {
			type = "execute",
			name = DiagnosticsStrings.TAINT_ON,
			order = 162,
			hidden = Hidden,
			func = function()
				ns.SetTaintLog(true)
				Refresh()
			end,
		},
		buttonTaintOff = {
			type = "execute",
			name = DiagnosticsStrings.TAINT_OFF,
			order = 163,
			hidden = Hidden,
			func = function()
				ns.SetTaintLog(false)
				Refresh()
			end,
		},
		descTaintHint = {
			type = "description",
			name = GetColor("BODY") .. DiagnosticsStrings.TAINT_HINT .. "|r",
			fontSize = "medium",
			order = 164,
			hidden = Hidden,
		},

		-- External Tools (point at mature tools rather than reimplement them)
		headerTools = SectionHeader(DiagnosticsStrings.TOOLS_TITLE, 170),
		descToolsErrors = {
			type = "description",
			name = GetColor("BODY") .. string.format(
				DiagnosticsStrings.TOOLS_ERRORS,
				GetColor("INFO") .. "/console scriptErrors 1|r" .. GetColor("BODY")
			) .. "|r",
			fontSize = "medium",
			order = 171,
			hidden = Hidden,
		},
		descToolsEtrace = {
			type = "description",
			name = GetColor("BODY")
				.. string.format(DiagnosticsStrings.TOOLS_ETRACE, GetColor("INFO") .. "/etrace|r" .. GetColor("BODY"))
				.. "|r",
			fontSize = "medium",
			order = 172,
			hidden = Hidden,
		},
	}

	-- Validate Data: one section per data file, between Library Versions and Taint Log.
	for index, source in ipairs(ns.DIAGNOSTIC_DATA_SOURCES) do
		local order = 100 + index * 3
		local field = "validateDataReport" .. index
		args["headerValidateData" .. index] =
			SectionHeader(string.format(DiagnosticsStrings.VALIDATE_TITLE, source.label), order)
		args["buttonValidateData" .. index] = {
			type = "execute",
			name = DiagnosticsStrings.VALIDATE_BUTTON,
			order = order + 1,
			hidden = Hidden,
			func = function()
				ns.RunDataValidation(index, field, Refresh)
			end,
		}
		args["outputValidateData" .. index] = ReportOutput(field, order + 2)
	end

	return {
		type = "group",
		name = DiagnosticsStrings.TAB,
		args = args,
	}
end
