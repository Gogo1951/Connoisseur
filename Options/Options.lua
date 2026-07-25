local _, ns = ...
local L = ns.L

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

local REGISTRY = ns.OPTIONS_REGISTRY
local mainPanel
local mainCategoryID

--[[
    Registration is deferred to ns.InitializeOptions, called once from
    Features/Core.lua after AceDB creates ns.db. It has to wait for ns.db
    because the Profiles panel's tree label is read from the stock
    AceDBOptions-3.0 table (ns.BuildProfilesOptions().name), which needs the
    database to exist. Child-panel order in Blizzard's settings tree is the
    order of the AddToBlizOptions calls: General (root) -> Profiles -> Diagnostic
    Tools, so Profiles sits second-to-last and Diagnostics last. The third
    AddToBlizOptions argument is the parent's display name (L["ADDON_TITLE"]) so
    each child nests under the root.
]]
local function RegisterChild(appName, builder, displayName)
	AceConfig:RegisterOptionsTable(appName, builder)
	AceConfigDialog:AddToBlizOptions(appName, displayName, L["ADDON_TITLE"])
end

function ns.InitializeOptions()
	AceConfig:RegisterOptionsTable(REGISTRY.General, ns.BuildGeneralOptions)
	mainPanel, mainCategoryID = AceConfigDialog:AddToBlizOptions(REGISTRY.General, L["ADDON_TITLE"])

	--[[
        Profiles panel: the stock AceDBOptions-3.0 table, unmodified
        (Options-Profiles.lua). Its display name comes already-localized from
        AceDBOptions, read off the built table so we neither hardcode it nor add
        a locale key for a stock widget.
    ]]
	RegisterChild(REGISTRY.Profiles, ns.BuildProfilesOptions, ns.BuildProfilesOptions().name)

	--[[
        Diagnostic Tools last so it sits at the bottom of the tree. Its display
        name is a plain English string (ns.DiagnosticsStrings.TAB), not a locale
        key -- diagnostics text is never localized.
    ]]
	RegisterChild(REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions, ns.DiagnosticsStrings.TAB)
end

--------------------------------------------------------------------------------
-- Panel Navigation
--------------------------------------------------------------------------------

function ns:OpenOptionsPanel()
	if Settings and Settings.OpenToCategory and mainCategoryID then
		Settings.OpenToCategory(mainCategoryID)
		return
	end
	if InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory(mainPanel)
		InterfaceOptionsFrame_OpenToCategory(mainPanel)
		return
	end
	AceConfigDialog:Open(REGISTRY.General)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

SLASH_CONNOISSEUR1 = "/foodie"
SlashCmdList["CONNOISSEUR"] = function()
	if ns.OpenOptionsPanel then
		ns:OpenOptionsPanel()
	end
end
