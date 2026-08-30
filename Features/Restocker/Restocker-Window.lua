local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Window Geometry
--------------------------------------------------------------------------------

--[[
    Size and position both live in ns.db.global.restocker.framePos. That is the
    account-wide half of the AceDB database, so one window layout follows the
    player across every character and no profile switch can move it.

    Both width numbers are set by the LIST, not the footer, and they are the sum
    of two things that each have their own floor:

      the category pane   its widest ALLOWED width (180) plus the gap (8)
      the table           580, below which the item name stops being readable
      window chrome       the inset (2 + 4), its padding (8), the scroll bar (26)

    which is where MIN_WIDTH comes from. The pane sizes itself to the longest type
    name it actually has to draw (see ns.ResolveRestockGroupPaneWidth) and is capped so this
    number stays honest: MIN_WIDTH is set against the CAP rather than the usual
    width, so the item name keeps its floor even on a client whose type names run
    long. Raising that cap means raising this. The footer's own floor (the profile
    row up to the Rename label) is 580, comfortably under both.

    DEFAULT_WIDTH is a step above the floor so a fresh window opens with room for
    a long consumable name rather than at the edge of truncation. MAX_* is a
    sanity ceiling for a corrupt saved value, not a real limit.
]]
local DEFAULT_WIDTH = 870
local DEFAULT_HEIGHT = 400
local MIN_WIDTH = 810
local MIN_HEIGHT = 260
local MAX_WIDTH = 1600
local MAX_HEIGHT = 1200

local function Clamp(value, minimum, maximum, fallback)
	value = tonumber(value)
	if not value then
		return fallback
	end
	return math.max(minimum, math.min(maximum, value))
end

--[[
    Persist where the window is and how big it is. Called when a drag or a
    resize finishes, and again at logout, so a crash loses at most the last
    adjustment rather than the whole layout.
]]
function ns.SaveRestockWindowGeometry()
	local frame = ns.restockWindow
	if not frame then
		return
	end
	local settings = ns.restockSettings
	settings.framePos = settings.framePos or {}

	local point, _, relativePoint, xOfs, yOfs = frame:GetPoint(frame:GetNumPoints())
	settings.framePos.point = point
	settings.framePos.relativePoint = relativePoint
	settings.framePos.xOfs = xOfs
	settings.framePos.yOfs = yOfs
	settings.framePos.width = math.floor(frame:GetWidth() + 0.5)
	settings.framePos.height = math.floor(frame:GetHeight() + 0.5)
end

--[[
    Forward-declared: CreateAddonFrame's OnSizeChanged closure names it, and a
    local that is not yet in scope on that line compiles as a nil global instead.
]]
local RelayoutFrame

local function CreateAddonFrame()
	local settings = ns.restockSettings
	local addonFrame = CreateFrame("Frame", "ConnoisseurRestockerFrame", UIParent, "BasicFrameTemplate")
	addonFrame.width = Clamp(settings.framePos.width, MIN_WIDTH, MAX_WIDTH, DEFAULT_WIDTH)
	addonFrame.height = Clamp(settings.framePos.height, MIN_HEIGHT, MAX_HEIGHT, DEFAULT_HEIGHT)
	addonFrame:SetSize(addonFrame.width, addonFrame.height)
	addonFrame:SetPoint(
		settings.framePos.point or "RIGHT",
		UIParent,
		settings.framePos.relativePoint or "RIGHT",
		settings.framePos.xOfs or -5,
		settings.framePos.yOfs or 0
	)
	addonFrame:SetFrameStrata("FULLSCREEN")
	addonFrame:SetMovable(true)
	addonFrame:SetResizable(true)
	addonFrame:EnableMouse(true)
	addonFrame:RegisterForDrag("LeftButton")
	addonFrame:SetScript("OnDragStart", addonFrame.StartMoving)
	addonFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		ns.SaveRestockWindowGeometry()
	end)

	-- SetResizeBounds is probed in Diagnostics' API checks.
	if addonFrame.SetResizeBounds then
		addonFrame:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT, MAX_WIDTH, MAX_HEIGHT)
	end

	--[[
	    Children are anchored to two corners rather than given a size, so the whole
	    layout follows the window on its own. Only the scroll child and the pooled
	    rows need telling -- a scroll child is sized, not anchored -- which is what
	    RelayoutFrame does.
	]]
	addonFrame:SetScript("OnSizeChanged", function(self)
		RelayoutFrame(self)
	end)

	--[[
	    The "New" group lasts exactly as long as the window is open, and an open
	    reputation menu is parented to UIParent rather than to the window, so it
	    would outlive it. Hooked on OnHide rather than in ns.HideRestockWindow because the
	    frame also closes by routes that never reach it -- the title bar's X, and
	    Escape via UISpecialFrames.
	]]
	addonFrame:SetScript("OnHide", function()
		ns.CloseReputationMenu()
		ns.CloseRestockListPullout()
		ns.ClearRestockNewItems()
		ns.ClearRestockGroupSelection()
	end)
	return addonFrame
end

--[[
    Push the current window size down into the parts that cannot follow it by
    anchoring alone. Cheap enough to run on every frame of a resize drag: it
    sets widths and never rebuilds the list.
]]
function RelayoutFrame(addonFrame)
	local scrollChild = addonFrame.scrollChild
	if not scrollChild then
		return -- still being built; ns.CreateRestockWindow lays out once at the end
	end

	addonFrame.width = addonFrame:GetWidth()
	addonFrame.height = addonFrame:GetHeight()
	addonFrame.listInset.width = addonFrame.listInset:GetWidth()
	addonFrame.listInset.height = addonFrame.listInset:GetHeight()

	--[[
	    Only the table's rows follow the window: the category pane is a fixed width
	    (see WINDOW GEOMETRY), so nothing in it needs resizing on a drag.
	]]
	local rowWidth = addonFrame.scrollFrame:GetWidth()
	scrollChild:SetWidth(rowWidth)
	for _, row in ipairs(ns.restockRowPool) do
		row:SetWidth(rowWidth)
	end
end

--[[
    The corner grip that resizes the window. A child button, so it takes the
    mouse before the frame-wide drag-to-move handler sees it.
]]
local function CreateResizeGrip(addonFrame)
	local grip = CreateFrame("Button", nil, addonFrame)
	grip:SetSize(16, 16)
	grip:SetPoint("BOTTOMRIGHT", addonFrame, "BOTTOMRIGHT", -4, 4)
	grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	grip:SetScript("OnMouseDown", function()
		addonFrame:StartSizing("BOTTOMRIGHT")
	end)
	grip:SetScript("OnMouseUp", function()
		addonFrame:StopMovingOrSizing()
		RelayoutFrame(addonFrame)
		ns.SaveRestockWindowGeometry()
	end)
	addonFrame.resizeGrip = grip
	return grip
end

local function CreateListInset(addonFrame)
	local listInset = CreateFrame("Frame", nil, addonFrame, "InsetFrameTemplate3")
	-- Two corners instead of a size: the inset then tracks the window by itself.
	listInset:SetPoint("TOPLEFT", addonFrame, "TOPLEFT", 2, -22)
	listInset:SetPoint("BOTTOMRIGHT", addonFrame, "BOTTOMRIGHT", -4, 38)
	listInset.width = listInset:GetWidth()
	listInset.height = listInset:GetHeight()
	addonFrame.listInset = listInset
	return listInset
end

--[[
    The filter box and the add row each sit in clear space rather than tight
    against the inset edge and the list -- a control the player types into reads
    as its own thing, not as the first or last row of the table.
]]
local CONTROL_ROW_HEIGHT = 25 -- sized to the Add button, the tallest thing on it
local CONTROL_ROW_GAP = 10 -- clear space above and below the row
local EDIT_BOX_HEIGHT = 18 -- both boxes, shorter than the row so they centre in it
--[[
    One width for both boxes. They do opposite things but they are the same kind
    of control, so sizing them alike is what stops the wider one reading as the
    more important one. Neither absorbs a wider window: the slack collects in the
    middle of the row instead, between the filter and the add box.

    Set by the longer of the two placeholders, the add row's, with headroom over
    it. That headroom is the whole reason one shared width is affordable at all:
    the row cannot pay for two boxes wide enough for a hint that runs the width
    of a sentence, so the add hint is kept to a phrase (see its locale key).

    A placeholder is a FontString rather than editbox content, so nothing clips
    it for you -- that is what put the add hint out over the Add button when it
    had only a left anchor. Both are anchored on both sides now, so a hint that
    outgrows its field truncates inside it instead of over its neighbour.
]]
local TEXT_BOX_WIDTH = 260
local CONTROL_GROUP_GAP = 16 -- between the add pair and the List Builder button
local ADD_BUTTON_WIDTH = 60
--[[
    The English measurement for the List Builder button, set before it is fitted
    to its caption. GameMenuButtonTemplate carries no size of its own, and
    ns.FitRestockButton declines to size a button whose font has not resolved
    yet -- which would leave this one zero-wide and invisible rather than merely
    the wrong width. Fitting only ever widens it from here.
]]
local LIST_BUILDER_BUTTON_WIDTH = 130
local LIST_BOTTOM_MARGIN = 8 -- the list no longer shares its inset with a control row

--[[
    The magnifying glass beside the filter, saying what that box is for without
    spending row width on a caption. Decoration only -- it takes no mouse, so
    there is no dead click target sitting beside a box you type into.

    The add box carries no matching glyph on purpose: the Add button bolted to
    its right already names what it does, so an icon there would be a second
    label on a control that has one.

    The gap clears InputBoxTemplate's border art, which hangs off the box's left
    edge, so an icon set flush against it would touch the frame rather than the
    field. The path is the client's own art; if it renders blank, that is the
    thing to check first.
]]
local ROW_ICON_SIZE = 16
local ROW_ICON_GAP = 8
local FILTER_ICON = "Interface\\Common\\UI-Searchbox-Icon"

--[[
    The filter's clear button, inside the field's right edge where a search box's
    is conventionally looked for. Shown only while there is text to clear, since
    a clear control on an empty field is a button that does nothing.

    The mark is the group-loot pass the item rows and the options item lists
    already use for "get rid of this", so removal looks the same everywhere in
    the add-on -- and, unlike a new path, it is art this window is already known
    to load.
]]
local CLEAR_BUTTON_SIZE = 14
local CLEAR_BUTTON_INSET = 4
local CLEAR_ICON = "Interface\\Buttons\\UI-GroupLoot-Pass-Up"
local CLEAR_ICON_DOWN = "Interface\\Buttons\\UI-GroupLoot-Pass-Down"

--[[
    The side insets both control rows sit in, so the filter box at the top and the
    add box at the bottom start and stop on the same two lines. Asymmetric because
    InputBoxTemplate hangs its border art off the left edge -- the numbers are what
    make the two boxes look evenly inset, not what makes them measure evenly.
]]
local CONTROL_ROW_INSET_LEFT = 16
local CONTROL_ROW_INSET_RIGHT = 12

--[[
    How far below the inset's top edge both panes start: the control row in its
    clear space, then the column header's own height. Shared so the category rows
    and the item rows sit on the same baseline.
]]
local function ListTopInset()
	return CONTROL_ROW_GAP + CONTROL_ROW_HEIGHT + CONTROL_ROW_GAP + ns.RESTOCK_COLUMN_HEADER_HEIGHT + 4
end

--[[
    How far above the inset's bottom edge both panes stop. Everything the player
    types into now shares one row at the top, so this is a plain margin rather
    than a reserved band. Read by the category pane too
    (Restocker-Window-Categories.lua), so the two halves end on the same line.
]]
ns.RESTOCK_LIST_BOTTOM_INSET = LIST_BOTTOM_MARGIN

local function CreateScrollFrame(addonFrame, listInset)
	local scrollFrame = CreateFrame("ScrollFrame", nil, addonFrame, "UIPanelScrollFrameTemplate")
	--[[
	    The category pane owns the left of the inset, so the table starts past it.
	    26 on the right for the scroll bar, and the add row's own space at the
	    bottom. The column header is anchored to this frame's top corners rather
	    than measured against the inset, so it inherits the same right edge the
	    rows lay out from.
	]]
	local left = 8 + ns.RESTOCK_GROUP_PANE_WIDTH + ns.RESTOCK_GROUP_PANE_GAP
	scrollFrame:SetPoint("TOPLEFT", listInset, "TOPLEFT", left, -ListTopInset())
	scrollFrame:SetPoint("BOTTOMRIGHT", listInset, "BOTTOMRIGHT", -26, ns.RESTOCK_LIST_BOTTOM_INSET)
	scrollFrame.width = scrollFrame:GetWidth()
	scrollFrame.height = scrollFrame:GetHeight()
	addonFrame.scrollFrame = scrollFrame
	return scrollFrame
end

--[[
    One row across the top holding everything the player types into: the add box
    and its Add button as a pair on the left, then the filter anchored right,
    where a search field is conventionally looked for.

    The two boxes look alike but do opposite things -- one changes the list, the
    other only narrows the view -- so they are kept apart by a wider gap than
    anything else on the row, and Add is bolted to the add box so that pair reads
    as one control rather than two more fields.
]]
local function CreateControlRow(addonFrame, listInset)
	local row = CreateFrame("Frame", nil, addonFrame)
	row:SetPoint("TOPLEFT", listInset, "TOPLEFT", CONTROL_ROW_INSET_LEFT, -CONTROL_ROW_GAP)
	row:SetPoint("TOPRIGHT", listInset, "TOPRIGHT", -CONTROL_ROW_INSET_RIGHT, -CONTROL_ROW_GAP)
	row:SetHeight(CONTROL_ROW_HEIGHT)
	addonFrame.controlRow = row
	return row
end

--[[
    A text filter at the right end of the row. Once 2+ characters are typed, the list
    shows only items whose name or type contains the text; clearing it shows everything.
]]
local function CreateFilterBox(addonFrame, controlRow)
	local box = CreateFrame("EditBox", nil, controlRow, "InputBoxTemplate")
	--[[
	    The row's left end, past its own icon. A LEFT-to-LEFT anchor centres the
	    box vertically against the taller buttons at the other end of the row.

	    The filter leads the row because it narrows the whole view under it: the
	    category pane's counts answer to it as well as the item rows, so at this
	    end it sits over everything it changes rather than over half of it.
	]]
	box:SetPoint("LEFT", controlRow, "LEFT", ROW_ICON_SIZE + ROW_ICON_GAP, 0)
	box:SetWidth(TEXT_BOX_WIDTH)
	box:SetHeight(EDIT_BOX_HEIGHT)
	box:SetAutoFocus(false)
	-- Keep typed text off the clear button below; the placeholder never meets it.
	box:SetTextInsets(0, CLEAR_BUTTON_SIZE + CLEAR_BUTTON_INSET, 0, 0)

	local icon = controlRow:CreateTexture(nil, "ARTWORK")
	icon:SetSize(ROW_ICON_SIZE, ROW_ICON_SIZE)
	icon:SetPoint("LEFT", controlRow, "LEFT", 0, 0)
	icon:SetTexture(FILTER_ICON)
	addonFrame.filterIcon = icon

	local clearButton = CreateFrame("Button", nil, box)
	clearButton:SetSize(CLEAR_BUTTON_SIZE, CLEAR_BUTTON_SIZE)
	clearButton:SetPoint("RIGHT", box, "RIGHT", -CLEAR_BUTTON_INSET, 0)
	clearButton:SetNormalTexture(CLEAR_ICON)
	clearButton:SetPushedTexture(CLEAR_ICON_DOWN)
	clearButton:SetHighlightTexture(CLEAR_ICON, "ADD")
	clearButton:Hide()
	--[[
	    Clearing the box fires OnTextChanged below, which is what empties the
	    filter and repaints the list -- so this handler only has to blank the
	    text, and the two paths out of a filter cannot drift apart.
	]]
	clearButton:SetScript("OnClick", function()
		box:SetText("")
		box:ClearFocus()
	end)
	ns.SetupRestockerTooltip(clearButton, L["RESTOCKER_FILTER_CLEAR_TOOLTIP"])
	addonFrame.filterClearButton = clearButton

	--[[
	    Greyed-out placeholder, shown only while the box is empty. Anchored on
	    both sides with no word wrap, the same way a row's item name is, so a
	    string longer than the field truncates inside it instead of running out
	    over whatever sits to the right. A placeholder is a FontString rather
	    than editbox content, so nothing clips it otherwise.
	]]
	local placeholder = box:CreateFontString(nil, "OVERLAY")
	placeholder:SetFontObject("GameFontDisableSmall")
	placeholder:SetPoint("LEFT", box, "LEFT", 4, 0)
	placeholder:SetPoint("RIGHT", box, "RIGHT", -4, 0)
	placeholder:SetJustifyH("LEFT")
	placeholder:SetWordWrap(false)
	placeholder:SetText(L["RESTOCKER_FILTER_PLACEHOLDER"])

	box:SetScript("OnTextChanged", function(self)
		local text = self:GetText() or ""
		placeholder:SetShown(text == "")
		clearButton:SetShown(text ~= "")
		ns.restockListFilter = text
		ns.UpdateRestockList()
	end)
	box:SetScript("OnEscapePressed", function(self)
		self:SetText("")
		self:ClearFocus()
	end)

	addonFrame.filterBox = box
	return box
end

local function CreateScrollChild(scrollFrame, addonFrame)
	local scrollChild = CreateFrame("Frame", nil, scrollFrame)
	scrollChild.width = scrollFrame:GetWidth()
	scrollChild.height = scrollFrame:GetHeight()
	scrollChild:SetWidth(scrollChild.width)
	scrollChild:SetHeight(scrollChild.height - 10)
	addonFrame.scrollChild = scrollChild

	scrollFrame:SetScrollChild(scrollChild)
	return scrollChild
end

local function CreateTitle(addonFrame)
	local title = addonFrame:CreateFontString(nil, "OVERLAY")
	title:SetFontObject("GameFontHighlightLarge")
	title:SetPoint("CENTER", addonFrame.TitleBg, "CENTER", 0, 0)
	title:SetText(L["RESTOCKER_WINDOW_TITLE"])
	addonFrame.title = title
	return title
end

local function CreateAddButton(addonFrame, controlRow)
	local addButton = CreateFrame("Button", nil, controlRow, "GameMenuButtonTemplate")
	--[[
	    Sits against the List Builder button's left edge, closing the add pair off
	    from it. The add box then hangs off THIS button's left edge, so the pair
	    still reads as one control rather than a field and a button that happen
	    to be adjacent.
	]]
	addButton:SetPoint("RIGHT", addonFrame.listBuilderBtn, "LEFT", -CONTROL_GROUP_GAP, 0)
	addButton:SetSize(ADD_BUTTON_WIDTH, CONTROL_ROW_HEIGHT)
	addButton:SetText(L["RESTOCKER_ADD_BUTTON"])
	addButton:SetNormalFontObject("GameFontNormal")
	addButton:SetHighlightFontObject("GameFontHighlight")
	--[[
	    The add box is captured, never resolved through GetParent: this button is
	    parented to the add group and the box is not its child, so walking the chain
	    is both fragile and exactly the trap the row controls warn about.
	]]
	addButton:SetScript("OnClick", function()
		local editBox = addonFrame.editBox
		local text = editBox:GetText()

		ns.AddRestockItem(text)

		editBox:SetText("")
		editBox:ClearFocus()
	end)
	--[[
	    The same tooltip the edit box shows: the button and the box are two
	    halves of one control, and either is a fair place to hover.
	]]
	ns.SetupRestockerTooltip(addButton, L["RESTOCKER_ADD_TOOLTIP_TITLE"], L["RESTOCKER_ADD_TOOLTIP_BODY"])

	addonFrame.addBtn = addButton
	return addButton
end

local function CreateEditBox(addonFrame, controlRow)
	local editBox = CreateFrame("EditBox", nil, controlRow, "InputBoxTemplate")
	--[[
	    One end anchored and a fixed width, matching the filter box on the far
	    side of the row. It hangs off the Add button rather than off the row, so
	    the whole right-hand group keeps its shared right edge and a wider window
	    opens the gap between this box and the filter instead.

	    The 3px overlap tucks the box's right border art under the button, which
	    is what makes the two read as one control.
	]]
	editBox:SetPoint("RIGHT", addonFrame.addBtn, "LEFT", 3, 0)
	editBox:SetWidth(TEXT_BOX_WIDTH)
	editBox:SetAutoFocus(false)
	editBox:SetHeight(EDIT_BOX_HEIGHT)
	editBox:SetScript("OnEnterPressed", function(self)
		local text = self:GetText()
		ns.AddRestockItem(text)
		self:SetText("")
		self:ClearFocus()
	end)
	editBox:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			local infoType, _, info2 = GetCursorInfo()
			if infoType == "item" then
				ns.AddRestockItem(info2)
				ClearCursor()
			end
		end
	end)
	editBox:SetScript("OnReceiveDrag", function(self)
		local infoType, _, info2 = GetCursorInfo()
		if infoType == "item" then
			ns.AddRestockItem(info2)
			ClearCursor()
		end
	end)

	--[[
	    Greyed-out placeholder, shown only while the box is empty -- the same
	    arrangement as the filter box, both ends anchored and no wrap included.
	    This is the longer of the two hints and the one that sets TEXT_BOX_WIDTH,
	    so it is also the one that overran the field and drew under the Add
	    button when it had only a left anchor to hold it.
	]]
	local placeholder = editBox:CreateFontString(nil, "OVERLAY")
	placeholder:SetFontObject("GameFontDisableSmall")
	placeholder:SetPoint("LEFT", editBox, "LEFT", 4, 0)
	placeholder:SetPoint("RIGHT", editBox, "RIGHT", -4, 0)
	placeholder:SetJustifyH("LEFT")
	placeholder:SetWordWrap(false)
	placeholder:SetText(L["RESTOCKER_ADD_PLACEHOLDER"])
	editBox:SetScript("OnTextChanged", function(self)
		placeholder:SetShown((self:GetText() or "") == "")
	end)

	ns.SetupRestockerTooltip(editBox, L["RESTOCKER_ADD_TOOLTIP_TITLE"], L["RESTOCKER_ADD_TOOLTIP_BODY"])

	addonFrame.editBox = editBox
	return editBox
end

--[[
    The List Builder, the same staples window a fresh character is offered at
    login (Options/Options-Starter-List-Popup.lua). Reachable from here as well
    so it is a tool the player can come back to rather than a one-off greeting
    they either caught or missed.

    Sized to its caption like the footer buttons rather than to a number, so a
    longer word in another locale widens the button instead of clipping it; the
    height is then set back to the row's, since FitRestockButton sizes for a
    list row and this one shares a line with Add.
]]
local function CreateListBuilderButton(addonFrame, controlRow)
	local button = CreateFrame("Button", nil, controlRow, "GameMenuButtonTemplate")
	-- The row's right end; the add pair chains leftward off it.
	button:SetPoint("RIGHT", controlRow, "RIGHT", 0, 0)
	button:SetSize(LIST_BUILDER_BUTTON_WIDTH, CONTROL_ROW_HEIGHT)
	button:SetText(L["RESTOCKER_LIST_BUILDER_BUTTON"])
	button:SetNormalFontObject("GameFontNormal")
	button:SetHighlightFontObject("GameFontHighlight")
	ns.FitRestockButton(button)
	button:SetHeight(CONTROL_ROW_HEIGHT)

	button:SetScript("OnClick", function()
		--[[
		    Close this window first. Both windows clear the "New" group as they
		    hide, so hiding ahead of the open leaves the builder's own OnHide as
		    the last one to run -- and it is the one that repaints the list with
		    whatever was just ticked.
		]]
		ns.HideRestockWindow()
		if ns.ShowStarterListPopup then
			ns.ShowStarterListPopup()
		end
	end)

	ns.SetupRestockerTooltip(button, L["RESTOCKER_LIST_BUILDER_BUTTON"], L["RESTOCKER_LIST_BUILDER_TOOLTIP"])

	addonFrame.listBuilderBtn = button
	return button
end

function ns.CreateRestockWindow()
	-- Row and button heights come from the font, so measure before anything is built.
	ns.RefreshRestockRowMetrics()
	-- The table's left edge is anchored past the category pane, so size it first.
	ns.ResolveRestockGroupPaneWidth()

	local addonFrame = CreateAddonFrame()
	local listInset = CreateListInset(addonFrame)
	local scrollFrame = CreateScrollFrame(addonFrame, listInset)
	CreateScrollChild(scrollFrame, addonFrame)
	ns.CreateRestockColumnHeader(addonFrame, scrollFrame)
	ns.CreateRestockGroupPane(addonFrame, listInset, ListTopInset())
	CreateTitle(addonFrame)

	--[[
	    Order matters, and the row chains right to left: the List Builder button
	    anchors to the row's right edge, Add to that button, and the add box to
	    Add. The filter is independent -- it hangs off the row's LEFT edge -- so
	    where it is built in the sequence does not matter.
	]]
	local controlRow = CreateControlRow(addonFrame, listInset)
	CreateFilterBox(addonFrame, controlRow)
	CreateListBuilderButton(addonFrame, controlRow)
	CreateAddButton(addonFrame, controlRow)
	CreateEditBox(addonFrame, controlRow)
	--[[
	    Settings live in Connoisseur's options panel (minimap tooltip / /foodie);
	    the frame deliberately has no Settings button.
	]]
	ns.CreateRestockWindowFooter(addonFrame)
	CreateResizeGrip(addonFrame)

	table.insert(UISpecialFrames, "ConnoisseurRestockerFrame")
	addonFrame:Hide()

	ns.restockWindow = addonFrame
	-- Now that scrollChild exists, settle the sizes the anchors could not carry.
	RelayoutFrame(addonFrame)
	return ns.restockWindow
end

function ns.ShowRestockWindow()
	if ns.restockerLoaded then
		local menu = ns.restockWindow or ns.CreateRestockWindow()
		menu:Show()
		return ns.UpdateRestockList()
	end
end

function ns.HideRestockWindow()
	if ns.restockerLoaded then
		local menu = ns.restockWindow or ns.CreateRestockWindow()
		return menu:Hide()
	end
end

function ns.ToggleRestockWindow()
	if ns.restockerLoaded then
		local menu = ns.restockWindow or ns.CreateRestockWindow()
		return menu:SetShown(not menu:IsShown()) or false
	end
end

--------------------------------------------------------------------------------
-- Tooltips
--------------------------------------------------------------------------------

--[[
    Every explanatory tooltip in the Restocker window routes through here, so the
    colors, the spacing, and the wrap all live in one place.

    Shape: a gold title, then white body lines with a blank line before each, so
    a multi-line tooltip reads as paragraphs instead of one wall. Same spacing
    idiom as AddSpacedLines in Minimap-Button.lua. Single-body tooltips are
    unaffected -- they get the one spacer under the title either way.

    Colors are passed explicitly rather than left to default: the two defaults
    disagree, SetText falling back to gold and AddLine to white, so a tooltip that
    leaves them out gets its title and body the wrong way round. Both come from the
    shared numeric palette. Callers pass plain strings; no |cff escapes.

    The trailing `true` on each line is the textWrap argument. Without it a
    tooltip is exactly as wide as its longest line, and the longer strings here
    (the reputation control's discount line especially) rendered a tooltip wider
    than the game window. With it the client breaks each line at its standard
    tooltip width -- which is also why we do not hand-measure a pixel budget: the
    client's own break points are correct in locales that don't put spaces
    between words.

    A one-argument call is a whole tooltip in one line, and renders as the title.
]]
local TOOLTIP_TITLE = ns.COLORS_RGB.TITLE
local TOOLTIP_BODY = ns.COLORS_RGB.TEXT

function ns.SetupRestockerTooltip(control, title, ...)
	local body = { ... }
	control:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText(title, TOOLTIP_TITLE.r, TOOLTIP_TITLE.g, TOOLTIP_TITLE.b, 1, true)
		for i = 1, #body do
			GameTooltip:AddLine(" ") -- blank line under the title, then between each pair
			GameTooltip:AddLine(body[i], TOOLTIP_BODY.r, TOOLTIP_BODY.g, TOOLTIP_BODY.b, true)
		end
		GameTooltip:Show()
	end)
	control:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end
