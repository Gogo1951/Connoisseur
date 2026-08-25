local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local Header = ns.OptionsHeader
local Desc = ns.OptionsDesc
local Spacer = ns.OptionsSpacer
local RowLabel = ns.OptionsRowLabel

--[[
    Feedback & Support rows use a narrower label than the default split so the
    URL box is wide enough to show a full address without truncating it.
]]
local LINK_LABEL_WIDTH = 0.6
local LINK_URL_WIDTH = ns.OPTIONS_ROW_WIDTH - LINK_LABEL_WIDTH

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

--[[
    The root page holds add-on-level behavior only -- nothing here changes what
    a macro does. In order: intro, Welcome Message, Mini-map Button, /Commands,
    Ready Check, Feedback & Support, and version.

    Everything that shapes a macro lives on the Macros panel
    (Options-Macros.lua), and Restocker on its own (Options-Restocker.lua),
    beside Profiles and Diagnostic Tools.

    Ready Check stays here rather than moving with the buff sections it reports
    on: it decides whether Connoisseur speaks up in chat, not what any macro
    contains. Every toggle on this page is account-wide (ns.db.global) -- see
    Data/Default-Settings.lua for why each one stays there.

    Order values are grouped in spaced blocks so sections can be reordered or
    extended without renumbering their neighbors.
]]

function ns.BuildGeneralOptions()
	return {
		name = L["ADDON_TITLE"],
		type = "group",
		args = {
			descIntro = Desc(L["OPTIONS_DESCRIPTION"], 1),

			-- Welcome Message
			spaceWelcome0 = Spacer(10),
			toggleWelcomeMessage = {
				type = "toggle",
				name = L["OPTIONS_WELCOME_MESSAGE"],
				desc = L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"],
				order = 11,
				width = "full",
				get = function()
					return ns.db and ns.db.global.showWelcome
				end,
				set = function(_, value)
					if ns.db then
						ns.db.global.showWelcome = value
					end
				end,
			},

			-- Minimap Button
			toggleMinimapButton = {
				type = "toggle",
				name = L["OPTIONS_MINIMAP_BUTTON"],
				desc = L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"],
				order = 13,
				width = "full",
				get = function()
					return not (ns.db and ns.db.global.minimap and ns.db.global.minimap.hide)
				end,
				set = function(_, value)
					if ns.ToggleMinimapButton then
						ns.ToggleMinimapButton(value)
					end
				end,
			},

			-- /Commands
			spaceCommands0 = Spacer(20),
			headerCommands = Header(L["OPTIONS_COMMANDS_HEADER"], 21),
			spaceCommands1 = Spacer(22),
			descCommands = Desc(
				GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
				23
			),
			spaceCommands2 = Spacer(24),
			descCommandsCrs = Desc(
				GetColor("INFO") .. L["RESTOCKER_COMMAND"] .. "|r" .. "  " .. L["RESTOCKER_COMMAND_DESCRIPTION"],
				25
			),

			-- Ready Check
			spaceReady0 = Spacer(150),
			headerReady = Header(L["OPTIONS_READY_CHECK_HEADER"], 151),
			spaceReady1 = Spacer(152),
			descReady = Desc(GetColor("BODY") .. L["OPTIONS_READY_CHECK_DESCRIPTION"] .. "|r", 153),
			spaceReady2 = Spacer(154),
			toggleReadyCheck = {
				type = "toggle",
				name = L["OPTIONS_READY_CHECK"],
				desc = L["OPTIONS_READY_CHECK_DESCRIPTION"],
				order = 155,
				width = "full",
				get = function()
					return ns.db and ns.db.global.readyCheckReport
				end,
				set = function(_, value)
					ns.db.global.readyCheckReport = value
				end,
			},

			-- Feedback & Support
			spaceCommunity0 = Spacer(900),
			headerCommunity = Header(L["OPTIONS_COMMUNITY_HEADER"], 901),
			spaceCommunity1 = Spacer(902),
			discordLabel = RowLabel(GetColor("TITLE") .. L["DISCORD"] .. "|r", 903, LINK_LABEL_WIDTH),
			discordURL = {
				type = "input",
				name = "",
				order = 904,
				width = LINK_URL_WIDTH,
				get = function()
					return ns.DISCORD_URL
				end,
				set = function() end,
			},
			spaceCommunity2 = Spacer(905),
			githubLabel = RowLabel(GetColor("TITLE") .. L["GITHUB"] .. "|r", 906, LINK_LABEL_WIDTH),
			githubURL = {
				type = "input",
				name = "",
				order = 907,
				width = LINK_URL_WIDTH,
				get = function()
					return ns.GITHUB_URL
				end,
				set = function() end,
			},
			spaceCommunity3 = Spacer(908),
			curseforgeLabel = RowLabel(GetColor("TITLE") .. L["CURSEFORGE"] .. "|r", 909, LINK_LABEL_WIDTH),
			curseforgeURL = {
				type = "input",
				name = "",
				order = 910,
				width = LINK_URL_WIDTH,
				get = function()
					return ns.CURSEFORGE_URL
				end,
				set = function() end,
			},
			spaceCommunity4 = Spacer(911),
			wagoLabel = RowLabel(GetColor("TITLE") .. L["WAGO"] .. "|r", 912, LINK_LABEL_WIDTH),
			wagoURL = {
				type = "input",
				name = "",
				order = 913,
				width = LINK_URL_WIDTH,
				get = function()
					return ns.WAGO_URL
				end,
				set = function() end,
			},

			-- Version
			spaceVersion0 = {
				type = "description",
				name = " ",
				width = "full",
				order = 998,
			},
			versionLine = {
				type = "description",
				name = GetColor("MUTED") .. L["VERSION_LABEL"] .. " " .. ns.Version .. "|r",
				fontSize = "medium",
				order = 999,
			},
		},
	}
end
