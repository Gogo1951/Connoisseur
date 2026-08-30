local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local Header = ns.OptionsHeader
local Desc = ns.OptionsDesc
local Spacer = ns.OptionsSpacer

--------------------------------------------------------------------------------
-- Readiness Report Panel
--------------------------------------------------------------------------------

--[[
    What Connoisseur says when a ready check starts. One master switch, then
    three sections matching the three lines the report prints, so the panel and
    the chat output read as the same feature: Missing Buffs, Missing Items,
    Character.

    Every switch here can only ever ADD a line about something that is wrong.
    The report says nothing when a character is ready, and that silence is what
    lets it cover this much without becoming noise -- see Features/Readiness.lua.

    The report itself is built in Features/Readiness.lua; this only owns the
    switches. All of them are account-wide (ns.db.global) -- see
    Data/Default-Settings.lua for why, and for the defaults.

    LAYOUT. Seventeen switches is more than a page can present as a plain column
    of checkboxes, so the rows are BUILT rather than declared: SECTIONS below
    says what exists, and AddReportRow gives every one of them the same three
    parts -- the switch, the silver line saying what it reports, then a blank
    line. Building them is what holds that rhythm identical across all
    seventeen. Written out as literals it had already drifted: no break between
    any two switches, and the description visible under three rows and hidden on
    hover for the other fourteen.
]]

--[[
    Everything below the master toggle hides with it, so the page collapses to
    one switch when the report is off. Baked into the local builders rather than
    repeated per widget, the same arrangement the Diagnostics panel uses.
]]
local function ReportsHidden()
	return not (ns.db and ns.db.global.readinessReportEnabled)
end

--[[
    Hidden on Classic Era on top of the standard gate, matching the check
    itself: Era has flasks and elixirs but does not run on them, so the switch
    would only offer a line that is wrong for most of the characters it fired
    at. See ns.HasFlaskOrElixirs' caller in Features/Readiness.lua.
]]
local function FlaskHidden()
	return ReportsHidden() or ns.IsEra
end

-- Repaint the page so a reset shows in the controls without a reopen.
local function Refresh()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.Readiness)
end

--------------------------------------------------------------------------------
-- Reset
--------------------------------------------------------------------------------

--[[
    Every Readiness Report setting back to what a fresh install ships with.

    A control of its own, which the Style Guide's Reset rule otherwise forbids
    (see the Connoisseur entry in References/Exceptions.md). The reason it has
    to exist: these settings are account-wide, and under the Per-Character model
    nothing can reach that scope -- ns.db:ResetProfile() clears the profile and
    the profile alone -- so without this button the page has no path back to its
    defaults at all.

    The keys are derived from ns.DATABASE_DEFAULTS rather than listed again
    here, so the button can never drift from the declared defaults and a
    readiness key added later joins the reset for free. Every one of them is a
    scalar (booleans, plus the two thresholds), which is what makes writing the
    default straight across safe -- a table default would have to be copied, or
    the saved table would end up aliasing the defaults table itself.

    Scoped and well-behaved on every other count: it touches this page's own
    keys and nothing else, no profile among them, and it writes through ns.db
    like every other control here rather than nil-ing the saved variable, so
    AceDB stays the only owner of that table.
]]
local READINESS_KEY_PATTERN = "^readiness"

local function ResetReadinessSettings()
	local defaults = ns.DATABASE_DEFAULTS and ns.DATABASE_DEFAULTS.global
	if not (ns.db and defaults) then
		return
	end

	for key, value in pairs(defaults) do
		if key:find(READINESS_KEY_PATTERN) then
			ns.db.global[key] = value
		end
	end

	Refresh()
end

--------------------------------------------------------------------------------
-- Thresholds
--------------------------------------------------------------------------------

--[[
    Expiry choices in seconds, which is what the report compares against. The
    labels are minutes because that is how a player thinks about a pull timer,
    and 2.5 is offered because the useful answer sits between the two round
    numbers either side of it.
]]
local EXPIRING_SECONDS = { 60, 120, 150, 180, 300, 480 }

local function ExpiringValues()
	local values = {}
	for _, seconds in ipairs(EXPIRING_SECONDS) do
		local minutes = seconds / 60
		if minutes == 1 then
			-- Its own key: no plural template renders the one-minute entry grammatically.
			values[seconds] = L["OPTIONS_READINESS_EXPIRING_MINUTES_ONE"]
		else
			-- Trim a whole number's ".0" without rounding the half-minute entry away.
			local label = (minutes % 1 == 0) and tostring(math.floor(minutes)) or tostring(minutes)
			values[seconds] = string.format(L["OPTIONS_READINESS_EXPIRING_MINUTES"], label)
		end
	end
	return values
end

local DURABILITY_PERCENTS = { 10, 20, 30, 40, 50 }

local function DurabilityValues()
	local values = {}
	for _, percent in ipairs(DURABILITY_PERCENTS) do
		values[percent] = string.format(L["OPTIONS_READINESS_DURABILITY_PERCENT"], percent)
	end
	return values
end

--[[
    A row's optional dropdown: which key it writes, the choices, their order,
    and what to read when the key is unset. `fallback` matches the default in
    Data/Default-Settings.lua -- the two have to agree, or the dropdown opens on
    a value the report is not using.
]]
local EXPIRING_THRESHOLD = {
	key = "readinessExpiringThreshold",
	values = ExpiringValues,
	sorting = EXPIRING_SECONDS,
	fallback = 150,
}

local DURABILITY_THRESHOLD = {
	key = "readinessDurabilityThreshold",
	values = DurabilityValues,
	sorting = DURABILITY_PERCENTS,
	fallback = 20,
}

--------------------------------------------------------------------------------
-- Panel Contents
--------------------------------------------------------------------------------

--[[
    Every section and every switch, in the order the panel draws them and the
    order the report prints them.

    Locale KEYS rather than resolved strings, the same way the Restocker
    window's column table carries its captions: this is a file-scope constant,
    and resolving at build time is what lets the panel pick up a locale the
    client had not finished loading when this file did.

    A row is its account-wide settings key, its label, and the sentence saying
    what it reports. `hidden` overrides the standard gate; `threshold` adds the
    dropdown that sets the row's value.
]]
local SECTIONS = {
	{
		key = "Buffs",
		title = "OPTIONS_READINESS_BUFFS_HEADER",
		rows = {
			{
				key = "readinessFlask",
				name = "OPTIONS_READINESS_FLASK",
				description = "OPTIONS_READINESS_FLASK_DESCRIPTION",
				hidden = FlaskHidden,
			},
			{
				key = "readinessWellFed",
				name = "OPTIONS_READINESS_WELL_FED",
				description = "OPTIONS_READINESS_WELL_FED_DESCRIPTION",
			},
			{
				key = "readinessPetWellFed",
				name = "OPTIONS_READINESS_PET_WELL_FED",
				description = "OPTIONS_READINESS_PET_WELL_FED_DESCRIPTION",
			},
			{
				key = "readinessScrolls",
				name = "OPTIONS_READINESS_SCROLLS",
				description = "OPTIONS_READINESS_SCROLLS_DESCRIPTION",
			},
			{
				key = "readinessSoulstone",
				name = "OPTIONS_READINESS_SOULSTONE",
				description = "OPTIONS_READINESS_SOULSTONE_DESCRIPTION",
			},
			{
				key = "readinessMainHandBuff",
				name = "OPTIONS_READINESS_MAIN_HAND",
				description = "OPTIONS_READINESS_MAIN_HAND_DESCRIPTION",
			},
			{
				key = "readinessOffHandBuff",
				name = "OPTIONS_READINESS_OFF_HAND",
				description = "OPTIONS_READINESS_WEAPON_DESCRIPTION",
			},
			{
				key = "readinessExpiring",
				name = "OPTIONS_READINESS_EXPIRING",
				description = "OPTIONS_READINESS_EXPIRING_DESCRIPTION",
				threshold = EXPIRING_THRESHOLD,
			},
		},
	},
	{
		key = "Items",
		title = "OPTIONS_READINESS_ITEMS_HEADER",
		rows = {
			{
				key = "readinessHealthstone",
				name = "OPTIONS_READINESS_HEALTHSTONE",
				description = "OPTIONS_READINESS_HEALTHSTONE_DESCRIPTION",
			},
			{
				key = "readinessManaGem",
				name = "OPTIONS_READINESS_MANA_GEM",
				description = "OPTIONS_READINESS_MANA_GEM_DESCRIPTION",
			},
			{
				key = "readinessHealingPotion",
				name = "OPTIONS_READINESS_HEALING_POTION",
				description = "OPTIONS_READINESS_HEALING_POTION_DESCRIPTION",
			},
			{
				key = "readinessManaPotion",
				name = "OPTIONS_READINESS_MANA_POTION",
				description = "OPTIONS_READINESS_MANA_POTION_DESCRIPTION",
			},
			{
				key = "readinessBandages",
				name = "OPTIONS_READINESS_BANDAGES",
				description = "OPTIONS_READINESS_BANDAGES_DESCRIPTION",
			},
			{
				key = "readinessDurability",
				name = "OPTIONS_READINESS_DURABILITY",
				description = "OPTIONS_READINESS_DURABILITY_DESCRIPTION",
				threshold = DURABILITY_THRESHOLD,
			},
		},
	},
	{
		key = "Character",
		title = "OPTIONS_READINESS_CHARACTER_HEADER",
		rows = {
			{
				key = "readinessSpec",
				name = "OPTIONS_READINESS_SPEC",
				description = "OPTIONS_READINESS_SPEC_DESCRIPTION",
			},
			{
				key = "readinessPvP",
				name = "OPTIONS_READINESS_PVP",
				description = "OPTIONS_READINESS_PVP_DESCRIPTION",
			},
			{
				key = "readinessQuestionableGear",
				name = "OPTIONS_READINESS_QUESTIONABLE_GEAR",
				description = "OPTIONS_READINESS_QUESTIONABLE_GEAR_DESCRIPTION",
			},
		},
	},
}

--------------------------------------------------------------------------------
-- Row Builders
--------------------------------------------------------------------------------

--[[
    A switch paired with the dropdown that sets its threshold. The toggle takes
    the larger share because it carries a phrase and the dropdown carries two
    words; together they fill one row, the same split the Restocker's reminder
    rows use.
]]
local TOGGLE_WITH_VALUE_WIDTH = 1.8
local VALUE_DROPDOWN_WIDTH = 0.8

--[[
    Opens a section: a break, its header, then a break under it -- the house
    rhythm every other panel's sections open with. Returns the next order.
]]
local function AddSection(args, section, order)
	args["space" .. section.key .. "Top"] = Spacer(order, ReportsHidden)
	args["header" .. section.key] = Header(L[section.title], order + 1, ReportsHidden)
	args["space" .. section.key .. "Under"] = Spacer(order + 2, ReportsHidden)
	return order + 3
end

--[[
    One category row: the switch, its threshold dropdown where it has one, the
    silver line naming what it reports, and the break under it.

    The description is both that visible line and the toggle's hover text, the
    same doubling the Macros panel's sections use -- the line answers a player
    reading down the page, the hover answers a mouse already on the control.

    Every part carries the row's own `hidden`, so a row that is not offered
    (Flask on Era) takes its description and its break with it rather than
    leaving a gap where a switch used to be.
]]
local function AddReportRow(args, row, order)
	local hidden = row.hidden or ReportsHidden
	local key = row.key
	local description = L[row.description]
	local threshold = row.threshold

	args["toggle" .. key] = {
		type = "toggle",
		name = L[row.name],
		desc = description,
		order = order,
		width = threshold and TOGGLE_WITH_VALUE_WIDTH or "full",
		hidden = hidden,
		get = function()
			return ns.db and ns.db.global[key]
		end,
		set = function(_, value)
			ns.db.global[key] = value
		end,
	}
	order = order + 1

	if threshold then
		args["value" .. key] = {
			type = "select",
			name = "",
			order = order,
			width = VALUE_DROPDOWN_WIDTH,
			values = threshold.values,
			sorting = threshold.sorting,
			hidden = hidden,
			get = function()
				return (ns.db and ns.db.global[threshold.key]) or threshold.fallback
			end,
			set = function(_, value)
				ns.db.global[threshold.key] = value
			end,
		}
		order = order + 1
	end

	args["desc" .. key] = Desc(GetColor("HELP") .. description .. "|r", order, hidden)
	args["space" .. key] = Spacer(order + 1, hidden)
	return order + 2
end

--------------------------------------------------------------------------------
-- Panel
--------------------------------------------------------------------------------

function ns.BuildReadinessOptions()
	local args = {}
	local order = 1

	--[[
	    No leading header repeating the panel's own name: AceConfigDialog already
	    draws that at the top, and every sibling panel opens straight into its
	    intro line instead.
	]]
	args.descIntro = Desc(L["OPTIONS_READINESS_DESCRIPTION"], order)
	order = order + 1
	args.spaceIntro = Spacer(order)
	order = order + 1
	args.toggleReadiness = {
		type = "toggle",
		name = L["OPTIONS_READINESS_ENABLE"],
		desc = L["OPTIONS_READINESS_DESCRIPTION"],
		order = order,
		width = "full",
		get = function()
			return ns.db and ns.db.global.readinessReportEnabled
		end,
		set = function(_, value)
			ns.db.global.readinessReportEnabled = value
		end,
	}
	order = order + 1

	--[[
	    Deliberately NOT gated on the report being on: it is what returns the
	    categories to their defaults, and those keep their values while the
	    report is off, so a player who has switched the report off still has to
	    be able to reach it.
	]]
	args.spaceReset = Spacer(order)
	order = order + 1
	args.resetReadiness = {
		type = "execute",
		name = L["OPTIONS_READINESS_RESET"],
		desc = L["OPTIONS_READINESS_RESET_DESCRIPTION"],
		order = order,
		width = "double",
		confirm = true,
		confirmText = L["OPTIONS_READINESS_RESET_CONFIRM"],
		func = ResetReadinessSettings,
	}
	order = order + 1

	for _, section in ipairs(SECTIONS) do
		order = AddSection(args, section, order)
		for _, row in ipairs(section.rows) do
			order = AddReportRow(args, row, order)
		end
	end

	return {
		type = "group",
		--[[
		    Named from the section header rather than a tab key of its own: the
		    two are the same two words, and a second key holding the same string
		    is one more thing for ten locales to keep in sync for no gain.
		]]
		name = L["OPTIONS_READINESS_HEADER"],
		args = args,
	}
end
