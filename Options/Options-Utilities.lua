local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Shared Option Widgets
--------------------------------------------------------------------------------

--[[
    Dot-defined widget constructors shared by every options panel. Callers use
    dot invocation (ns.OptionsHeader(...)), matching the panel builders.
]]

function ns.OptionsHeader(text, order)
    return {
        type = "header",
        name = GetColor("TITLE") .. text .. "|r",
        order = order,
    }
end

function ns.OptionsSubHeader(text, order)
    return {
        type = "description",
        name = "\n" .. GetColor("TITLE") .. text .. "|r",
        fontSize = "medium",
        order = order,
    }
end

function ns.OptionsDesc(text, order)
    return {
        type = "description",
        name = text,
        fontSize = "medium",
        order = order,
    }
end

function ns.OptionsSpacer(order)
    return {
        type = "description",
        name = " ",
        order = order,
    }
end

--------------------------------------------------------------------------------
-- Shared Values
--------------------------------------------------------------------------------

-- Group-restriction mode labels shared by the Buff Food, Scroll, and Pet panels.
ns.MODE_VALUES = {
    always = L["MODE_ALWAYS"],
    party = L["MODE_PARTY"],
    raid = L["MODE_RAID"]
}
