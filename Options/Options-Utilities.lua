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

function ns.OptionsHeader(text, order, hidden)
	return {
		type = "header",
		name = GetColor("TITLE") .. text .. "|r",
		order = order,
		hidden = hidden,
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

--[[
    The left half of a label-beside-control row: this cell, then the control
    with name = "" ordered immediately after it. A caption left on the control
    would put the label back above the widget and break the row.
]]
function ns.OptionsRowLabel(text, order, width)
	return {
		type = "description",
		name = text,
		fontSize = "medium",
		width = width or ns.OPTIONS_LABEL_WIDTH,
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
	raid = L["MODE_RAID"],
}
