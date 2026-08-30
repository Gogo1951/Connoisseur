local _, ns = ...
local L = ns.L
local AceGUI = LibStub("AceGUI-3.0")

--[[
    The controls that fill the Restock List grid: the toggle cells, the reputation
    menu, the amount box, the remove button, and the pooled rows holding them, plus
    the render loop that lays those rows out.

    The grid itself -- column definitions, widths, shared colors and the header --
    is Restocker-Window-Columns.lua, which loads first.
]]
local COLUMNS = ns.RESTOCK_COLUMNS
local REP_STANDINGS = ns.REPUTATION_STANDINGS
local BUTTON_FONT = ns.RESTOCK_BUTTON_FONT
local REMOVE_ICON_SIZE = ns.RESTOCK_REMOVE_ICON_SIZE
local COLUMN_MIN_WIDTH = ns.RESTOCK_COLUMN_MIN_WIDTH
local ROW_INSET = ns.RESTOCK_ROW_INSET
local ICON_SIZE = ns.RESTOCK_ICON_SIZE
local ICON_TEXT_GAP = ns.RESTOCK_ICON_TEXT_GAP
local NAME_COLUMN_GAP = ns.RESTOCK_NAME_COLUMN_GAP
local AMOUNT_GAP = ns.RESTOCK_AMOUNT_GAP
local GOLD = ns.RESTOCK_CELL_GOLD
local WHITE = ns.RESTOCK_CELL_WHITE
local DASH_OFF = ns.RESTOCK_CELL_DASH_OFF
local DASH_NOT_APPLICABLE = ns.RESTOCK_CELL_DASH_NOT_APPLICABLE
local REPUTATION_SET = ns.RESTOCK_CELL_REPUTATION_SET
local LayoutColumns = ns.LayoutRestockColumns
local ApplyColumnWidths = ns.ApplyRestockColumnWidths
local TooltipBody = ns.RestockColumnTooltipBody
local ReputationStandingByValue = ns.RestockReputationStandingByValue
local ReputationMenuText = ns.RestockReputationMenuText

--[[
    Zebra stripe alpha. Deliberately faint: the row already carries quality-coloured
    item names and gold check glyphs, and a stripe strong enough to notice on its own
    competes with both. It only has to make the eye's path across seven cells hold
    its line.
]]
local ROW_STRIPE_ALPHA = 0.045

-- Scratch list rebuilt on every render; never escapes this file.
local restockItemList = {}

--[[
    The standings menu, built on AceGUI's own pullout rather than Blizzard's
    UIDropDownMenu. Blizzard's version drives shared global frames that its own
    secure code also uses, so an add-on running through them leaves taint behind;
    AceGUI's pullout owns its frames outright. It also raises itself to TOOLTIP
    strata, which is what keeps it in front of a FULLSCREEN-strata window.

    A hand-created pullout closes only when we close it. The widget installs no
    OnHide script, and SetHideOnLeave writes a flag AceGUI-3.0 never reads, so
    every close path is one of ours: opening another menu, picking a standing,
    the window hiding, and ns.UpdateRestockList.

    Update is the load-bearing one. Rows come from a pool, so any redraw can put a
    different item under an open menu -- and the menu has to be gone before that
    row is rebound, or a pick lands on an item the player never opened.

    The callback is pinned to the item the menu was opened for as a second guard,
    so a close that is ever missed writes nothing rather than writing to whatever
    row drifted underneath.
]]
local openRepPullout = nil

local function CloseReputationMenu()
	if not openRepPullout then
		return
	end
	local pullout = openRepPullout
	openRepPullout = nil
	pullout:Close()
	AceGUI:Release(pullout)
end

ns.CloseReputationMenu = CloseReputationMenu

local function OpenReputationMenu(cell, row)
	CloseReputationMenu()

	local openedForItem = cell.item
	if not openedForItem then
		return
	end

	local pullout = AceGUI:Create("Dropdown-Pullout")
	openRepPullout = pullout

	local title = AceGUI:Create("Dropdown-Item-Header")
	title:SetText(L["RESTOCKER_REPUTATION_MENU_TITLE"])
	pullout:AddItem(title)

	for _, standing in ipairs(REP_STANDINGS) do
		local entry = AceGUI:Create("Dropdown-Item-Toggle")
		entry:SetText(ReputationMenuText(standing))
		entry:SetValue((openedForItem.reaction or 0) == standing.value)
		entry:SetCallback("OnValueChanged", function()
			if cell.item == openedForItem then
				-- Store nil for "Any" so nothing is persisted; otherwise the standing code.
				openedForItem.reaction = (standing.value > 0) and standing.value or nil
				ns.UpdateRestockListRow(row, openedForItem)
			end
			-- A toggle item does not close its own pullout, unlike an execute item.
			CloseReputationMenu()
		end)
		pullout:AddItem(entry)
	end

	pullout:SetCallback("OnClose", function()
		openRepPullout = nil
	end)
	pullout:Open("TOPLEFT", cell, "BOTTOMLEFT", 0, 0)
end

--[[
    How many of this item the list is asking for. The caller places it and sets
    its width, since the row lays its controls out from the right edge inward.
]]
local function CreateAmountEditBox(frame)
	local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")

	editBox:SetHeight(ns.RESTOCK_BUTTON_HEIGHT - 2)
	editBox:SetAutoFocus(false)
	--[[
	    Digits only, and every read still falls back to 0: item.amount is compared
	    against bag counts by the bank restock loop, where a nil target throws and
	    aborts the whole run.
	]]
	editBox:SetNumeric(true)
	--[[
	    Both handlers read self.item, rebound by ns.UpdateRestockListRow like every
	    other row control -- never GetParent().item, which is the trap that once
	    broke removal silently.
	]]
	editBox:SetScript("OnEnterPressed", function(self)
		local amount = tonumber(self:GetText()) or 0

		if self.item then
			self.item.amount = amount
		end
		editBox:ClearFocus()
		self:SetText(tostring(amount))
		ns.UpdateRestockList()
		if ns.bankIsOpen then
			ns.OnRestockerBankOpen()
		end
	end)
	editBox:SetScript("OnKeyUp", function(self)
		if self.item then
			self.item.amount = tonumber(self:GetText()) or 0
		end
	end)

	ns.SetupRestockerTooltip(editBox, L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"], L["RESTOCKER_AMOUNT_TOOLTIP_BODY"])

	return editBox
end

--[[
    Reads self.item, which UpdateRestockListRow rebinds like every other row
    control -- NOT GetParent().item: the two-line row layout parents this
    button to line1, which carries no item, and resolving through the parent
    is exactly how removal silently broke when that layout landed.
]]
local function OnDeleteButtonClick(self)
	local settings = ns.restockSettings
	local profile = settings.profiles[settings.currentProfile]
	local item = self.item

	if item and item.itemID then
		-- Profiles are keyed by itemID, so removal is a direct delete
		profile[item.itemID] = nil
		ns.UpdateRestockList()
	end
end

--[[
    The group-loot pass mark is the game's own "get rid of this" icon, and the
    same texture Connoisseur's and MagicEraser's option-panel item lists use for
    their remove column -- so removal looks the same everywhere. It replaces a
    UIPanelCloseButton, whose red X reads as "close the window" on a row and
    whose 30px frame was mostly transparent padding.

    The highlight is the normal texture blended additively rather than a separate
    file, which glows on hover without depending on a second art path.
]]
local REMOVE_ICON = "Interface\\Buttons\\UI-GroupLoot-Pass-Up"
local REMOVE_ICON_DOWN = "Interface\\Buttons\\UI-GroupLoot-Pass-Down"

local function CreateDeleteButton(frame)
	local button = CreateFrame("Button", nil, frame)

	button:SetPoint("RIGHT", frame, "RIGHT", -ROW_INSET, 0)
	button:SetSize(REMOVE_ICON_SIZE, REMOVE_ICON_SIZE)
	button:SetNormalTexture(REMOVE_ICON)
	button:SetPushedTexture(REMOVE_ICON_DOWN)
	button:SetHighlightTexture(REMOVE_ICON, "ADD")
	button:SetScript("OnClick", OnDeleteButtonClick)
	ns.SetupRestockerTooltip(button, L["RESTOCKER_REMOVE_TOOLTIP"])
	return button
end

--------------------------------------------------------------------------------
-- Cell States
--------------------------------------------------------------------------------

local CELL_ON, CELL_OFF, CELL_NOT_APPLICABLE = "on", "off", "na"

local CHECK_TEXTURE = "Interface\\Buttons\\UI-CheckBox-Check"
local CHECK_SIZE = 16
local DASH_WIDTH = 7
local DASH_HEIGHT = 2

--[[
    Reading and writing one item flag per column, so a cell needs no knowledge of
    which one it is beyond its key. These replaced five near-identical button
    constructors that differed only in the field they touched.

    The nil defaults are load-bearing and differ per flag: buyFromMerchant and
    upgrade default ON when unset, buyExtra defaults OFF. A plain `not` on the
    first two would read nil as false and switch them on, which is backwards.
]]
local COLUMN_STATE = {
	withdraw = function(item)
		return item.restockFromBank and CELL_ON or CELL_OFF
	end,
	deposit = function(item)
		return item.stashTobank and CELL_ON or CELL_OFF
	end,
	buy = function(item)
		return (item.buyFromMerchant == nil or item.buyFromMerchant) and CELL_ON or CELL_OFF
	end,
	extra = function(item)
		--[[
		    Extra rides on top of Buy: ns.RestockFromMerchant never reaches an item
		    with Buy off, so the cell says "not applicable" rather than "off".
		]]
		if not (item.buyFromMerchant == nil or item.buyFromMerchant) then
			return CELL_NOT_APPLICABLE
		end
		return item.buyExtra and CELL_ON or CELL_OFF
	end,
	upgrade = function(item)
		--[[
		    Only vendor-sold staples sit on a ladder; most of a real list cannot
		    upgrade at all, which is not the same as choosing not to.
		]]
		if not ns.CanUpgradeRestockItem(item.itemID) then
			return CELL_NOT_APPLICABLE
		end
		return (item.upgrade ~= false) and CELL_ON or CELL_OFF
	end,
}

local COLUMN_TOGGLE = {
	withdraw = function(item)
		item.restockFromBank = not item.restockFromBank
	end,
	deposit = function(item)
		item.stashTobank = not item.stashTobank
	end,
	buy = function(item)
		if item.buyFromMerchant == nil then
			item.buyFromMerchant = false -- nil defaults to true, so toggle to false
		else
			item.buyFromMerchant = not item.buyFromMerchant
		end
	end,
	extra = function(item)
		item.buyExtra = not item.buyExtra -- nil defaults to false
	end,
	upgrade = function(item)
		if item.upgrade == nil then
			item.upgrade = false -- nil defaults to true, so toggle to false
		else
			item.upgrade = not item.upgrade
		end
	end,
}

-- Attach the shared hover highlight used by every clickable cell.
local function AddCellHighlight(cell)
	cell:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
	local highlight = cell:GetHighlightTexture()
	if highlight then
		highlight:SetVertexColor(GOLD.r, GOLD.g, GOLD.b, 0.30)
	end
end

-- Paint a glyph cell for one of the three states.
local function SetCell(cell, state)
	cell.isActive = (state ~= CELL_NOT_APPLICABLE)
	cell.check:SetShown(state == CELL_ON)
	cell.dash:SetShown(state ~= CELL_ON)
	if state == CELL_NOT_APPLICABLE then
		cell.dash:SetColorTexture(DASH_NOT_APPLICABLE.r, DASH_NOT_APPLICABLE.g, DASH_NOT_APPLICABLE.b, 1)
	else
		cell.dash:SetColorTexture(DASH_OFF.r, DASH_OFF.g, DASH_OFF.b, 1)
	end
	--[[
	    Alpha rather than Disable(): a dead cell still has to answer "why can this
	    not be set?", and Disable() would take the tooltip away with the clicks.
	]]
	local highlight = cell:GetHighlightTexture()
	if highlight then
		highlight:SetAlpha(cell.isActive and 1 or 0)
	end
end

local function CreateGlyphCell(row, column)
	local cell = CreateFrame("Button", nil, row)
	cell:SetSize(ns.RESTOCK_COLUMN_WIDTH[column.key] or COLUMN_MIN_WIDTH, ns.RESTOCK_BUTTON_HEIGHT)

	local check = cell:CreateTexture(nil, "ARTWORK")
	check:SetTexture(CHECK_TEXTURE)
	check:SetSize(CHECK_SIZE, CHECK_SIZE)
	check:SetPoint("CENTER")
	check:SetVertexColor(GOLD.r, GOLD.g, GOLD.b)
	cell.check = check

	local dash = cell:CreateTexture(nil, "ARTWORK")
	dash:SetSize(DASH_WIDTH, DASH_HEIGHT)
	dash:SetPoint("CENTER")
	cell.dash = dash

	AddCellHighlight(cell)

	local toggle = COLUMN_TOGGLE[column.key]
	cell:SetScript("OnClick", function(self)
		-- Reads self.item, rebound by UpdateRestockListRow like every other control
		if not (self.isActive and self.item) then
			return
		end
		toggle(self.item)
		ns.UpdateRestockListRow(row, self.item)
	end)

	ns.SetupRestockerTooltip(cell, L[column.title], unpack(TooltipBody(column)))
	return cell
end

--[[
    The reputation cell. A menu, not a toggle, so it draws the standing it is in
    and opens the standings list on click.
]]
local function CreateReputationCell(row, column)
	local cell = CreateFrame("Button", nil, row)
	cell:SetSize(ns.RESTOCK_COLUMN_WIDTH[column.key] or COLUMN_MIN_WIDTH, ns.RESTOCK_BUTTON_HEIGHT)
	cell.isActive = true

	local fontString = cell:CreateFontString(nil, "ARTWORK", BUTTON_FONT)
	fontString:SetPoint("CENTER")
	cell.text = fontString

	AddCellHighlight(cell)

	cell:SetScript("OnClick", function(self)
		if not self.item then
			return
		end
		OpenReputationMenu(self, row)
	end)

	ns.SetupRestockerTooltip(cell, L[column.title], unpack(TooltipBody(column)))
	return cell
end

function ns.CreateRestockListRow(item)
	--[[
	    Born parented to the hidden frame and positioned by ns.UpdateRestockList, which
	    places every row by absolute index rather than chaining them to each other.
	]]
	local frame = CreateFrame("Frame", nil, ns.restockHiddenFrame)
	frame:SetSize(ns.restockWindow.scrollChild:GetWidth(), ns.RESTOCK_ROW_HEIGHT)
	frame.item = item

	--[[
	    The stripe belongs to the POSITION, not the item: rows come from a pool and
	    are reused at whatever index the next render puts them at, so every row owns
	    a stripe and ns.UpdateRestockList decides which ones show.
	]]
	local stripe = frame:CreateTexture(nil, "BACKGROUND")
	stripe:SetAllPoints(frame)
	stripe:SetColorTexture(WHITE.r, WHITE.g, WHITE.b, ROW_STRIPE_ALPHA)
	frame.stripe = stripe

	-- ICON, with an invisible button over it that shows the item tooltip on hover
	local icon = frame:CreateTexture(nil, "ARTWORK")
	icon:SetSize(ICON_SIZE, ICON_SIZE)
	icon:SetPoint("LEFT", frame, "LEFT", ROW_INSET, 0)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- trim the default icon border
	frame.icon = icon

	-- RIGHT EDGE: remove control, then the amount box.
	frame.removeButton = CreateDeleteButton(frame)
	frame.amountBox = CreateAmountEditBox(frame)
	frame.amountBox:SetPoint("RIGHT", frame.removeButton, "LEFT", -AMOUNT_GAP, 0)
	frame.amountBox:SetWidth(ns.RESTOCK_AMOUNT_WIDTH)

	frame.cells, frame.firstCell = LayoutColumns(frame.amountBox, function(column)
		if column.isText then
			return CreateReputationCell(frame, column)
		end
		return CreateGlyphCell(frame, column)
	end)

	--[[
	    ITEM NAME fills whatever the columns leave. Anchored on both sides with no
	    word wrap, so a long name truncates instead of running under the first cell.
	]]
	local text = frame:CreateFontString(nil, "OVERLAY", nil)
	text:SetFontObject("GameFontHighlight")
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)
	text:SetPoint("LEFT", icon, "RIGHT", ICON_TEXT_GAP, 0)
	text:SetPoint("RIGHT", frame.firstCell, "LEFT", -NAME_COLUMN_GAP, 0)
	frame.text = text

	--[[
	    The icon and the name together are the row's tooltip target: a FontString
	    takes no mouse, so an invisible button covers both. It only shows the item
	    tooltip -- there is nothing left for a row click to open.
	]]
	local nameButton = CreateFrame("Button", nil, frame)
	nameButton:SetPoint("TOPLEFT", icon, "TOPLEFT", 0, 0)
	nameButton:SetPoint("BOTTOMRIGHT", text, "BOTTOMRIGHT", 0, 0)
	nameButton:SetScript("OnEnter", function(button)
		local rowItem = frame.item
		if not (rowItem and rowItem.itemID) then
			return
		end
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
		-- Prefer the cached colored link; fall back to a bare item: link (always valid)
		local info = ns.GetItemData(rowItem.itemID)
		GameTooltip:SetHyperlink((info and info.itemLink) or ("item:" .. rowItem.itemID))
		GameTooltip:Show()
	end)
	nameButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	frame.iconBtn = nameButton

	table.insert(ns.restockRowPool, frame)
	return frame
end

function ns.UpdateRestockListRow(row, item)
	row.item = item
	-- Every control carries its own item rather than resolving through a parent.
	row.removeButton.item = item
	row.amountBox.item = item
	for _, cell in pairs(row.cells) do
		cell.item = item
	end

	--[[
	    Column widths can resolve after a row was built, so re-read them here rather
	    than only at creation. Guarded on a serial, which makes this six SetWidth
	    calls once and a single comparison thereafter.
	]]
	if row.columnSerial ~= ns.RESTOCK_COLUMN_WIDTH_SERIAL then
		row.columnSerial = ns.RESTOCK_COLUMN_WIDTH_SERIAL
		ApplyColumnWidths(row.cells)
	end

	for _, column in ipairs(COLUMNS) do
		if not column.isText then
			SetCell(row.cells[column.key], COLUMN_STATE[column.key](item))
		end
	end

	--[[
	    Reputation names its own standing. Dimmed at "Any", which is the absence of
	    a requirement, and tinted when one is set so a gated row stands out in a
	    column of otherwise identical text.
	]]
	local standing = ReputationStandingByValue(item.reaction)
	local repCell = row.cells.rep
	repCell.text:SetText(standing.label)
	if (item.reaction or 0) > 0 then
		repCell.text:SetTextColor(REPUTATION_SET.r, REPUTATION_SET.g, REPUTATION_SET.b)
	else
		repCell.text:SetTextColor(DASH_OFF.r, DASH_OFF.g, DASH_OFF.b)
	end

	-- Icon + quality-colored name (from the item cache; falls back until it is known)
	local info = ns.GetItemData(item.itemID)
	if info then
		row.icon:SetTexture(info.itemTexture)
		local quality = ITEM_QUALITY_COLORS[info.itemRarity or 1]
		if quality then
			row.text:SetTextColor(quality.r, quality.g, quality.b)
		else
			row.text:SetTextColor(WHITE.r, WHITE.g, WHITE.b)
		end
	else
		row.icon:SetTexture("Interface\\ICONS\\INV_Misc_QuestionMark")
		row.text:SetTextColor(WHITE.r, WHITE.g, WHITE.b)
	end

	row.text:SetText(item.itemName)
	row.amountBox:SetText(tostring(item.amount or 0))
end

--------------------------------------------------------------------------------
-- Update
--------------------------------------------------------------------------------

function ns.UpdateRestockList()
	--[[
	    Rows are about to be released to the pool and rebound to different items, so
	    an open reputation menu has to go first -- it is anchored to a cell, and its
	    pick would land on whatever item that cell ends up holding.
	]]
	ns.CloseReputationMenu()

	local settings = ns.restockSettings
	local currentProfile = settings.profiles[settings.currentProfile]

	-- Gather items (profile is keyed by itemID, so walk it with pairs)
	wipe(restockItemList)
	for _, v in pairs(currentProfile) do
		table.insert(restockItemList, v)
	end

	--[[
	    The category pane is filled from the UNFILTERED list, so it can report every
	    type the profile holds and how many of each. The render list below is the
	    filtered one: whatever survives the filter box and the selected category.
	]]
	--[[
	    One view per redraw: each item's group resolved once and the filter lowered
	    once, shared by the category pane and the render list. Both used to resolve
	    them per item, and the sort comparator per comparison.
	]]
	local view = ns.BuildRestockView(restockItemList)
	ns.UpdateRestockGroupPane(restockItemList, view)
	local renderList = ns.BuildRestockRenderList(restockItemList, view)

	-- Release every pooled item row back to the hidden frame
	for _, row in ipairs(ns.restockRowPool) do
		row.isInUse = false
		row:SetParent(ns.restockHiddenFrame)
		row:Hide()
	end

	--[[
	    Every entry is one row tall, so the running offset is just an accumulator.
	    It also gives the scroll child its height, which is what keeps the scroll
	    bar's range honest.
	]]
	local scrollChild = ns.restockWindow.scrollChild
	local offset = 0
	-- A late column measurement lands here first; the rows pick it up below.
	ns.RefreshRestockColumnHeader()
	for index, entry in ipairs(renderList) do
		local row = ns.AcquireRestockListRow(entry.item)

		row.isInUse = true
		row:SetParent(scrollChild)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -offset)
		row:SetSize(scrollChild:GetWidth(), ns.RESTOCK_ROW_HEIGHT)
		-- Every second row, counting the first as bare so the list starts flush.
		row.stripe:SetShown(index % 2 == 0)
		ns.UpdateRestockListRow(row, entry.item)
		row:Show()
		offset = offset + ns.RESTOCK_ROW_HEIGHT
	end

	scrollChild:SetHeight(math.max(1, offset))
end

--------------------------------------------------------------------------------
-- Row Pool
--------------------------------------------------------------------------------

function ns.AcquireRestockListRow(item)
	for _, frame in ipairs(ns.restockRowPool) do
		if not frame.isInUse then
			return frame
		end
	end
	return ns.CreateRestockListRow(item)
end
