--------------------------------------------------------------------------------
-- Connoisseur Options — Starter List Pop-up
--------------------------------------------------------------------------------

--[[
    The window that opens after login when a level-6+ character has nothing on
    their Restock List, offering the staples -- foods, water, class reagents,
    ammo -- as one-tick suggestions, a few of them pre-ticked for the class.
    The trigger, the categories, the defaults, and what every tick does live
    in Features/Restocker/Restocker-Starter-List.lua; this file only draws them.

    This is an AceConfigDialog standalone window rather than a hand-built
    frame, the same arrangement as GogoLoot's master-looter pop-up: registered
    with AceConfigRegistry like any other panel (Options.lua) but never passed
    to AddToBlizOptions, so it takes the add-on's existing widget styling,
    gets the stock Close button, and stays out of the Blizzard settings tree.
    Nothing here is protected.
]]
local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local Header = ns.OptionsHeader
local Desc = ns.OptionsDesc
local Spacer = ns.OptionsSpacer

--[[
    Sized to what THIS character will see -- the sections are decided by
    class and level the moment the window opens, so the height is computed
    per open (PopupHeight below): a base for the frame chrome plus the three
    intro paragraphs, then each section adds its header block and its rows,
    and the water row rides the food section without a header of its own.
    Coarse constants on purpose; they only need to land close enough that
    nothing scrolls and nothing gapes.

    The cap is for the fullest builds (a level-60 rogue's reagents run to
    four rows), which scroll a little rather than swallow the screen -- and
    the row widths below stay inside the scrollbar-narrowed content width,
    so the capped case reflows nothing. The don't-show-again checkbox adds
    no height: it rides the frame's own footer line, beside Close.
]]
local POPUP_WIDTH = 580
local POPUP_BASE_HEIGHT = 250
local POPUP_MAX_HEIGHT = 640
local SECTION_CHROME_HEIGHT = 54 -- header + its line break + the trailing spacer
local STAPLE_ROW_HEIGHT = 30 -- a row group: its controls plus the group's own sliver of padding
local WATER_ROW_HEIGHT = 45 -- the water row group plus its own trailing spacer
local POISONS_NOTE_HEIGHT = 45 -- the two-line ingredients note plus its spacer

--[[
    Each staple is a checkbox-plus-stacks-dropdown pair, two pairs to a row
    with a gutter widget between them, so the left column gets air after its
    dropdown the way the right column gets it from the window edge. The unit
    is AceConfig's 170px width step.

    The staple pair is sized snug to one-word labels with a dropdown that
    must hold "18 Stacks"; the reagent pair spends more on the label --
    "Demonic Figurine" is the yardstick -- and less on a dropdown that never
    shows past "4 Stacks" (the counting ones, Soul Shards, stop at a bare
    "40", narrower still). Both dropdowns fit because the AceGUI dropdown
    renders its text in the small highlight font. A reagent with a fixed
    amount draws no dropdown; its checkbox spans the whole pair, so the
    columns keep their rhythm. A locale that overruns a label wraps that row
    onto another line -- revisit these widths before shipping long-label
    locales.
]]
local STAPLE_TOGGLE_WIDTH = 0.5
local STAPLE_STACKS_WIDTH = 0.65
local REAGENT_TOGGLE_WIDTH = 0.75
local REAGENT_STACKS_WIDTH = 0.6
local COLUMN_GUTTER_WIDTH = 0.2

--------------------------------------------------------------------------------
-- Options Table Builder
--------------------------------------------------------------------------------

-- Every category argument below is one entry from ns.GetStarterCategories().

--[[
    "1 Stack" .. "N Stacks" choice lists, one per distinct cap -- the food
    dropdowns stop at 4 stacks where the ammo ones run to 18, so the lists
    are built per category.maxStacks and cached by that cap. The label is
    unit-agnostic on purpose, because a stack is 20 for most staples and 200
    for the ammo and the dropdown's tooltip is what says which.

    A category whose stack size is 1 counts items instead (Soul Shards), and
    gets a bare-number list: "1 Stack" of a thing that cannot stack reads as a
    bug, and the row's own label already says what is being counted.

    A category carrying a choices list offers exactly those counts rather than
    every number to a cap -- Restocker-Starter-List.lua owns which, and why. Same
    machinery either way, so the cache keys on the style and on the run of
    counts, and two categories offering the same run share one list.
]]
local stackOptionsByCap = {}

local function StackOptions(category)
	local counting = category.stackSize == 1
	local choices = category.choices
	local cacheKey = (counting and "count:" or "stacks:")
		.. (choices and table.concat(choices, ",") or category.maxStacks)

	local cached = stackOptionsByCap[cacheKey]
	if not cached then
		cached = { values = {}, sorting = {} }
		--[[
		    Keys are the counts themselves. The explicit sorting array is what
		    keeps AceConfig from ordering them "1, 10, 11, .." by label, so it
		    is filled in offered order rather than keyed like the values.
		]]
		local offered = choices
		if not offered then
			offered = {}
			for stacks = 1, category.maxStacks do
				offered[stacks] = stacks
			end
		end

		for index, stacks in ipairs(offered) do
			if counting then
				cached.values[stacks] = tostring(stacks)
			elseif stacks == 1 then
				cached.values[stacks] = L["STARTER_POPUP_STACK_ONE"]
			else
				cached.values[stacks] = string.format(L["STARTER_POPUP_STACK_MANY"], stacks)
			end
			cached.sorting[index] = stacks
		end
		stackOptionsByCap[cacheKey] = cached
	end
	return cached.values, cached.sorting
end

--[[
    One staple checkbox. Ticking adds the item -- Restocker-Starter-List.lua picks the
    tier for the character's level -- and unticking removes it, whichever tier
    the list is holding by then. The tooltip names the exact item and count a
    tick adds right now.
]]
local function StapleToggle(category, order, width)
	return {
		type = "toggle",
		name = category.label,
		desc = function()
			return ns.DescribeStarterCategory(category)
		end,
		order = order,
		width = width,
		get = function()
			return ns.IsStarterCategoryChecked(category)
		end,
		set = function(_, value)
			ns.SetStarterCategory(category, value)
		end,
	}
end

--[[
    The stacks dropdown beside a staple's checkbox. Live either way round:
    picked first, it decides what a later tick adds; changed after, it rewrites
    the listed entry's amount on the spot. Captionless like every
    beside-a-control dropdown in the options panels.
]]
local function StapleStacks(category, order, width)
	local values, sorting = StackOptions(category)
	return {
		type = "select",
		name = "",
		desc = function()
			if category.stackSize == 1 then
				return L["STARTER_POPUP_COUNT_DESCRIPTION"]
			end
			return string.format(L["STARTER_POPUP_STACKS_DESCRIPTION"], category.stackSize)
		end,
		order = order,
		width = width,
		values = values,
		sorting = sorting,
		get = function()
			return ns.GetStarterCategoryStacks(category)
		end,
		set = function(_, value)
			ns.SetStarterCategoryStacks(category, value)
		end,
	}
end

--[[
    Adds one staple's checkbox-and-dropdown pair to args; returns the next
    order. A fixedAmount category has no stack choice to offer, so its
    checkbox takes the dropdown's width too and the pair stays one cell wide
    to its neighbors.
]]
local function AddStaplePair(args, category, order, toggleWidth, stacksWidth)
	if category.fixedAmount then
		args["toggle" .. category.key] = StapleToggle(category, order, toggleWidth + stacksWidth)
		return order + 1
	end
	args["toggle" .. category.key] = StapleToggle(category, order, toggleWidth)
	args["stacks" .. category.key] = StapleStacks(category, order + 1, stacksWidth)
	return order + 2
end

--[[
    Lays a section's staples out two pairs to a row -- each row WRAPPED IN AN
    INLINE GROUP of its own. The wrapper is load-bearing, exactly as
    the sub-option rows document: laid out flat, a row holds together only
    because its widths happen to fill the line, and any skin that changes
    the arithmetic -- ElvUI's Ace3 skin did -- lets the next checkbox float
    up into the leftover slack and shear every column after it. A fill-width
    group always gets a line to itself, so one group per row pins one row
    per row no matter whose skin is running; a row that still overflows
    wraps INSIDE its own group instead of corrupting its neighbors.

    The gutter is a blank cell between the columns, not after them -- the
    right column's air comes from the window edge -- so a row with a single
    pair (Water) takes no gutter at all. Cell widths default to the standard
    pair; the reagent section passes its own. The categories arrive already in
    the display order SectionCategories computed.
]]
local function AddStapleRows(args, categories, order, toggleWidth, stacksWidth)
	toggleWidth = toggleWidth or STAPLE_TOGGLE_WIDTH
	stacksWidth = stacksWidth or STAPLE_STACKS_WIDTH
	for index = 1, #categories, 2 do
		local first = categories[index]
		local second = categories[index + 1]

		local rowArgs = {}
		local rowOrder = AddStaplePair(rowArgs, first, 1, toggleWidth, stacksWidth)
		if second then
			rowArgs["gutter" .. second.key] = {
				type = "description",
				name = " ",
				width = COLUMN_GUTTER_WIDTH,
				order = rowOrder,
			}
			rowOrder = rowOrder + 1
			AddStaplePair(rowArgs, second, rowOrder, toggleWidth, stacksWidth)
		end

		args["row" .. first.key] = {
			type = "group",
			name = "",
			inline = true,
			order = order,
			args = rowArgs,
		}
		order = order + 1
	end
	return order
end

--[[
    One section's categories in display order, holding only the ones this
    class is offered right now -- Restocker-Starter-List.lua's class and availability
    rules keep another class's reagents, a not-yet-trained spell's reagent,
    and another expansion's items out of the window.
]]
local function SectionCategories(section)
	local categories = {}
	for _, category in ipairs(ns.GetStarterCategories()) do
		if
			category.section == section
			and ns.IsStarterCategoryForClass(category)
			and ns.IsStarterCategoryAvailable(category)
		then
			categories[#categories + 1] = category
		end
	end

	--[[
	    Display order is computed, never authored: the staples with a stacks
	    dropdown lead, the fixed-amount singles follow, and each run sorts
	    alphabetically by its localized label -- so the dropdown column stays
	    a solid block instead of gap-toothing around the single items, and
	    every locale reads A to Z without re-authoring the spec.
	]]
	table.sort(categories, function(a, b)
		local aFixed = a.fixedAmount ~= nil
		local bFixed = b.fixedAmount ~= nil
		if aFixed ~= bFixed then
			return bFixed
		end
		return (a.label or "") < (b.label or "")
	end)
	return categories
end

--[[
    The height this character's build needs, mirroring the builder's section
    logic exactly: a section contributes only when it holds at least one
    offerable staple, and pairs pack two to a row.
]]
local function PopupHeight()
	local height = POPUP_BASE_HEIGHT

	local function SectionHeight(section)
		local count = #SectionCategories(section)
		if count == 0 then
			return 0
		end
		return SECTION_CHROME_HEIGHT + math.ceil(count / 2) * STAPLE_ROW_HEIGHT
	end

	height = height + SectionHeight("food")
	if #SectionCategories("water") > 0 then
		height = height + WATER_ROW_HEIGHT
	end
	-- The poisons section carries its ingredients note above the rows.
	local poisonsHeight = SectionHeight("poisons")
	if poisonsHeight > 0 then
		height = height + poisonsHeight + POISONS_NOTE_HEIGHT
	end
	height = height + SectionHeight("reagents")
	height = height + SectionHeight("ammo")
	return math.min(height, POPUP_MAX_HEIGHT)
end

function ns.BuildStarterListPopupOptions()
	local args = {}
	local order = 1

	--[[
	    The intro's three paragraphs -- why the window opened, what a tick
	    does, the way back in -- separated by blank lines, one widget. The
	    /crs literal is colored as an interaction, the same way the Restocker
	    panel's own description colors it.

	    The opening line answers to how the window was reached, because both
	    routes are real: the login trigger only fires over an empty list, while
	    the Restocker's List Builder button opens it over whatever the player
	    already has. Resolved per build rather than once, since AceConfig
	    re-invokes this builder on every open.
	]]
	local introKey = ns.IsRestockListEmpty() and "STARTER_POPUP_INTRO_EMPTY" or "STARTER_POPUP_INTRO_STOCKED"
	args.descIntro = Desc(
		GetColor("BODY")
			.. L[introKey]
			.. "\n\n"
			.. L["STARTER_POPUP_INTRO_HOW"]
			.. "\n\n"
			.. string.format(
				L["STARTER_POPUP_COMMAND_HINT"],
				GetColor("INFO") .. L["RESTOCKER_COMMAND"] .. "|r" .. GetColor("BODY")
			)
			.. "|r",
		order
	)
	order = order + 1
	args.spacerIntro = Spacer(order)
	order = order + 1

	--[[
	    Every section is drawn only when it has something to offer this
	    character right now -- another class's section, or one whose every
	    item is still level-locked, is omitted outright rather than shown
	    empty. Class and level are fixed for the sitting, so there is no
	    state change for a hidden-function to answer.
	]]
	local foodCategories = SectionCategories("food")
	if #foodCategories > 0 then
		--[[
		    The heading covers the Water row below as well, when the class
		    gets one; should water ever be hidden for a class again, the
		    heading falls back to naming only what is there.
		]]
		local foodHeaderText = (#SectionCategories("water") > 0) and L["STARTER_POPUP_FOOD_AND_WATER_HEADER"]
			or L["STARTER_POPUP_FOOD_HEADER"]
		args.headerFood = Header(foodHeaderText, order)
		order = order + 1
		-- A section header is always followed by a line break (house rhythm).
		args.spacerFoodHeader = Spacer(order)
		order = order + 1
		order = AddStapleRows(args, foodCategories, order)
		args.spacerFood = Spacer(order)
		order = order + 1
	end

	--[[
	    Water rides under the Food & Water heading but keeps a spacer and a
	    row of its own -- its pair fills half the line and leaves the rest
	    empty -- so the drink reads apart from the six foods above it rather
	    than as a seventh dish.
	]]
	local waterCategories = SectionCategories("water")
	if #waterCategories > 0 then
		order = AddStapleRows(args, waterCategories, order)
		args.spacerWater = Spacer(order)
		order = order + 1
	end

	--[[
	    Poisons, the rogue's own section, led by a note that the ingredients
	    take care of themselves -- the crafting-reagent half of the Restocker
	    already shops for a listed poison's makings, and a fresh rogue has no
	    way to know that. The note follows the canonical section rhythm
	    (header, line break, description, line break, controls), opening with
	    the class-colored "Attention Rogues" the minimap tooltip uses.
	]]
	local poisonCategories = SectionCategories("poisons")
	if #poisonCategories > 0 then
		args.headerPoisons = Header(L["STARTER_POPUP_POISONS_HEADER"], order)
		order = order + 1
		-- A section header is always followed by a line break (house rhythm).
		args.spacerPoisonsHeader = Spacer(order)
		order = order + 1
		args.descPoisonsNote = Desc(
			GetColor("BODY")
				.. string.format(
					L["STARTER_POPUP_POISONS_NOTE"],
					"|cff" .. ns.CLASS_COLORS.ROGUE .. L["PREFIX_ROGUE"] .. "|r" .. GetColor("BODY")
				)
				.. "|r",
			order
		)
		order = order + 1
		args.spacerPoisonsNote = Spacer(order)
		order = order + 1
		order = AddStapleRows(args, poisonCategories, order, REAGENT_TOGGLE_WIDTH, REAGENT_STACKS_WIDTH)
		args.spacerPoisons = Spacer(order)
		order = order + 1
	end

	--[[
	    Class reagents and tools -- a rogue's powders and picks, a druid's
	    seeds, a priest's candles. The wider label cell is what fits "Demonic
	    Figurine" and "Mind-numbing"; see the width block up top.
	]]
	local reagentCategories = SectionCategories("reagents")
	if #reagentCategories > 0 then
		args.headerReagents = Header(L["STARTER_POPUP_REAGENTS_HEADER"], order)
		order = order + 1
		-- A section header is always followed by a line break (house rhythm).
		args.spacerReagentsHeader = Spacer(order)
		order = order + 1
		order = AddStapleRows(args, reagentCategories, order, REAGENT_TOGGLE_WIDTH, REAGENT_STACKS_WIDTH)
		args.spacerReagents = Spacer(order)
		order = order + 1
	end

	local ammoCategories = SectionCategories("ammo")
	if #ammoCategories > 0 then
		args.headerAmmo = Header(L["STARTER_POPUP_AMMO_HEADER"], order)
		order = order + 1
		-- A section header is always followed by a line break (house rhythm).
		args.spacerAmmoHeader = Spacer(order)
		order = order + 1
		order = AddStapleRows(args, ammoCategories, order)
		args.spacerAmmo = Spacer(order)
	end

	return {
		type = "group",
		name = L["RESTOCKER_WINDOW_TITLE"],
		args = args,
	}
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------

--[[
    The don't-show-again checkbox sits on the frame's own footer line, beside
    the stock Close button, rather than in the scrolling content above -- the
    two ways of ending this conversation belong on one row. The AceGUI Frame
    widget draws a status bar there that AceConfigDialog leaves empty, so the
    checkbox borrows that dead space.

    The offsets are pinned to the bundled AceGUI Frame widget's own footer
    geometry (AceGUIContainer-Frame.lua: Close at BOTTOMRIGHT -27,17 and 20
    tall, the status bar at BOTTOMLEFT 15,15 and 24 tall -- both centered on
    y 27), so the row can only drift if the bundled library does.
]]
local DISMISS_CHECKBOX_SIZE = 24
local DISMISS_CHECKBOX_X = 18
local DISMISS_CHECKBOX_Y = 15
local DISMISS_LABEL_GAP = 2

local dismissCheckbox

--[[
    True from Open until the host frame's next OnHide -- which is how the
    hook below tells THIS window's close apart from a later hide of the same
    pooled frame serving some other AceGUI window.
]]
local starterPopupOpen = false

--[[
    AceConfigDialog.OpenFrames hands back a POOLED widget: after this window
    closes, the same underlying frame can be recycled for any other AceGUI
    window. So the checkbox is re-adopted on every open, orphaned again the
    moment its host hides, and the hide-hook is installed once per recycled
    frame -- a HookScript can never be removed, so it is flagged rather than
    stacked. The host passed in is that widget's underlying WoW frame, not the
    widget itself.
]]
local function AttachDismissCheckbox(host)
	if not dismissCheckbox then
		dismissCheckbox = CreateFrame("CheckButton", nil, UIParent, "UICheckButtonTemplate")
		dismissCheckbox:SetSize(DISMISS_CHECKBOX_SIZE, DISMISS_CHECKBOX_SIZE)

		local label = dismissCheckbox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		label:SetPoint("LEFT", dismissCheckbox, "RIGHT", DISMISS_LABEL_GAP, 0)
		label:SetText(L["STARTER_POPUP_DISMISS"])

		dismissCheckbox:SetScript("OnClick", function(self)
			local checked = self:GetChecked() and true or false
			PlaySound(checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			ns.SetStarterPopupDismissed(checked)
		end)

		-- The same tooltip helper every Restocker-window control routes through.
		ns.SetupRestockerTooltip(dismissCheckbox, L["STARTER_POPUP_DISMISS"], L["STARTER_POPUP_DISMISS_DESCRIPTION"])
	end

	dismissCheckbox:SetParent(host)
	dismissCheckbox:ClearAllPoints()
	dismissCheckbox:SetPoint("BOTTOMLEFT", host, "BOTTOMLEFT", DISMISS_CHECKBOX_X, DISMISS_CHECKBOX_Y)
	-- Above the status bar it overlays, which is itself a Button.
	dismissCheckbox:SetFrameLevel(host:GetFrameLevel() + 10)
	dismissCheckbox:SetChecked(ns.IsStarterPopupDismissed())
	dismissCheckbox:Show()

	if not host.crsStarterDismissHooked then
		host.crsStarterDismissHooked = true
		host:HookScript("OnHide", function()
			if dismissCheckbox and dismissCheckbox:GetParent() == host then
				dismissCheckbox:Hide()
				dismissCheckbox:SetParent(UIParent)
			end
			--[[
			    Closing this window retires its "New" flags: the group is a
			    note about items just added HERE, and once the window is gone
			    the note is stale -- the same rule as the Restocker window's
			    own OnHide. The flag guard keeps a recycled frame's later
			    hides (serving some other AceGUI window) from clearing flags
			    that belong to a sitting still in progress.
			]]
			if starterPopupOpen then
				starterPopupOpen = false
				ns.ClearRestockNewItems()
				ns.UpdateRestockList()
			end
		end)
	end
end

function ns.ShowStarterListPopup()
	AceConfigDialog:SetDefaultSize(ns.OPTIONS_REGISTRY.StarterListPopup, POPUP_WIDTH, PopupHeight())
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY.StarterListPopup)
	starterPopupOpen = true

	--[[
	    Fixed size, same reasoning and same post-Open timing as GogoLoot's
	    master-looter pop-up: nothing here benefits from being dragged bigger,
	    and the AceGUI Frame widget only exists once Open has built it.
	]]
	local openFrame = AceConfigDialog.OpenFrames[ns.OPTIONS_REGISTRY.StarterListPopup]
	if openFrame and openFrame.EnableResize then
		openFrame:EnableResize(false)
	end
	if openFrame and openFrame.frame then
		AttachDismissCheckbox(openFrame.frame)
	end
end
