local _, ns = ...
local L = ns.L

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

local REGISTRY = ns.OPTIONS_REGISTRY

AceConfig:RegisterOptionsTable(REGISTRY.General, ns.BuildGeneralOptions)
local mainPanel = AceConfigDialog:AddToBlizOptions(REGISTRY.General, L["ADDON_TITLE"])

--[[
    All feature settings live on the General panel (see Options-General.lua), so
    the only child panel is Diagnostic Tools. The third AddToBlizOptions argument
    is the parent's display name (L["ADDON_TITLE"]); Diagnostics sits at the bottom of
    the tree as the sole child. Its display name is a plain English string
    (ns.DiagnosticsStrings.TAB), not a locale key — diagnostics text is never
    localized.
]]
local function RegisterChild(appName, builder, displayName)
    AceConfig:RegisterOptionsTable(appName, builder)
    AceConfigDialog:AddToBlizOptions(appName, displayName, L["ADDON_TITLE"])
end

RegisterChild(REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions, ns.DiagnosticsStrings.TAB)

--------------------------------------------------------------------------------
-- Panel Navigation
--------------------------------------------------------------------------------

function ns.OpenOptions()
    if Settings and Settings.GetCategory then
        local category = Settings.GetCategory(L["ADDON_TITLE"])
        if category then
            Settings.OpenToCategory(category.ID)
            return
        end
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
    if ns.OpenOptions then
        ns.OpenOptions()
    end
end
