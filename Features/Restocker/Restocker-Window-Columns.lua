local _, ns = ...
local L = ns.L

--[[
    The grid the Restock List is drawn on: which columns exist, how wide each one
    has to be, where every cell sits, and the header above them.

    Restocker-Window-Rows.lua builds the controls that fill this grid. The split is
    deliberate: the header and the rows have to line up exactly, so the widths, the
    gaps and the colors they share are defined once here, and the layout walk that
    places them is called by both.
]]

--------------------------------------------------------------------------------
-- Reputation Standings
--------------------------------------------------------------------------------

-- The standings themselves are Data/Data.lua's; these two format them.
local REP_STANDINGS = ns.REPUTATION_STANDINGS

local function ReputationStandingByValue(value)
	value = value or 0
	for _, standing in ipairs(REP_STANDINGS) do
		if standing.value == value then
			return standing
		end
	end
	return REP_STANDINGS[1] -- default to "Any"
end

-- Menu label, e.g. "Honored  (10% off)"
local function ReputationMenuText(standing)
	if standing.discount and standing.discount > 0 then
		return string.format(L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"], standing.label, standing.discount)
	end
	return standing.label
end

--------------------------------------------------------------------------------
-- Row Metrics
--------------------------------------------------------------------------------

--[[
    Nothing in a row carries a hardcoded size: a caption that outgrows its button
    is clipped, not wrapped. Every control measures the font it actually draws
    with, so a larger UI font, or a longer word in another locale, widens the
    control instead of overflowing it.

    ns.RESTOCK_ROW_HEIGHT and ns.RESTOCK_BUTTON_HEIGHT start at the values the fixed layout used
    and are recomputed by ns.RefreshRestockRowMetrics once the frame exists. With the
    stock font the measurement lands back on exactly these numbers.
]]
ns.RESTOCK_ROW_HEIGHT = 26
ns.RESTOCK_BUTTON_HEIGHT = 22

--[[
    A row is one line and shows everything about its item: the six toggles are lit
    or dim glyphs in fixed columns under a header that names them, so the list
    answers "which of these buy from vendors?" by being looked at. Never hide a
    row's state behind an expander -- with only the open row showing anything, the
    list needs a marker to say which rows are worth opening and a panel to say
    where an open one stops, and it still cannot be read at a glance.
]]
--[[
    The font every control in the window measures itself against, shared with the
    category pane so the two halves cannot drift apart. On Restocker rather than a
    file-local for that reason alone.
]]
ns.RESTOCK_BUTTON_FONT = "GameFontNormalSmall"
local BUTTON_FONT = ns.RESTOCK_BUTTON_FONT
local BUTTON_PAD_X = 16 -- caption to button edge, both sides together
local BUTTON_PAD_Y = 8
local BUTTON_MIN_WIDTH = 28
local ROW_PAD_Y = 4 -- breathing room above and below the tallest control

-- Scratch FontString used only to measure BUTTON_FONT; never shown.
local measureFontString

local function MeasureFontString()
	if not measureFontString then
		measureFontString = (ns.restockHiddenFrame or UIParent):CreateFontString(nil, "ARTWORK", BUTTON_FONT)
		measureFontString:Hide()
	end
	return measureFontString
end

local function FontLineHeight()
	local fontString = MeasureFontString()
	fontString:SetText("Wg")
	local lineHeight = fontString:GetStringHeight()
	--[[
	    GetStringHeight reads 0 before the font is resolved; fall back to the
	    height that produces today's 22px button.
	]]
	if not lineHeight or lineHeight <= 0 then
		return 14
	end
	return lineHeight
end

--------------------------------------------------------------------------------
-- Columns
--------------------------------------------------------------------------------

--[[
    One definition drives the header and every row, so the two cannot drift apart:
    each walks this list from the right edge inward, and a column is as wide as
    its own header caption. A longer word in another locale widens that column and
    takes the room out of the item name, which is the only thing on the row that
    can absorb it.

    `gapBefore` opens a wider space where the meaning changes, and `group` names
    the band of columns it opens, drawn once above them. That band is what buys
    the short captions: "Take" and "Store" would be vague on their own and are
    exact under "Bank", and the width they save is width the item name gets. Six
    full-length captions do not fit beside a readable name at the minimum window
    width -- the name was down to 58 pixels -- so this is load-bearing, not taste.

    Every column carries its tooltip keys, so the header cell and the row cell
    explain themselves from one place.
]]
local COLUMNS = {
	{
		key = "withdraw",
		caption = "RESTOCKER_COLUMN_WITHDRAW",
		group = "RESTOCKER_ROW_BANK",
		title = "RESTOCKER_WITHDRAW_TOOLTIP_TITLE",
		body = { "RESTOCKER_WITHDRAW_TOOLTIP_BODY" },
	},
	{
		key = "deposit",
		caption = "RESTOCKER_COLUMN_DEPOSIT",
		title = "RESTOCKER_DEPOSIT_TOOLTIP_TITLE",
		body = { "RESTOCKER_DEPOSIT_TOOLTIP_BODY" },
	},
	{
		key = "buy",
		caption = "RESTOCKER_BUY_LABEL",
		group = "RESTOCKER_ROW_MERCHANT",
		title = "RESTOCKER_BUY_TOOLTIP_TITLE",
		body = { "RESTOCKER_BUY_TOOLTIP_BODY" },
		gapBefore = true,
	},
	{
		key = "extra",
		caption = "RESTOCKER_EXTRA_LABEL",
		title = "RESTOCKER_EXTRA_TOOLTIP_TITLE",
		body = { "RESTOCKER_EXTRA_TOOLTIP_STOCK", "RESTOCKER_EXTRA_TOOLTIP_LIMITED" },
	},
	{
		--[[
		    The only column that draws text rather than a glyph: reputation has five
		    states, not two, so the cell has to name the one it is in.
		]]
		key = "rep",
		caption = "RESTOCKER_COLUMN_REPUTATION",
		title = "RESTOCKER_REPUTATION_TOOLTIP_TITLE",
		body = {
			"RESTOCKER_REPUTATION_TOOLTIP_STANDING",
			"RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS",
			"RESTOCKER_REPUTATION_TOOLTIP_CLICK",
		},
		isText = true,
	},
	{
		key = "upgrade",
		caption = "RESTOCKER_ROW_UPGRADE",
		title = "RESTOCKER_UPGRADE_TOOLTIP_TITLE",
		body = { "RESTOCKER_UPGRADE_TOOLTIP_BODY" },
		gapBefore = true,
	},
}

local COLUMN_GAP = 5 -- between columns inside a group
local COLUMN_GROUP_GAP = 12 -- where the grouping changes
local COLUMN_PAD_X = 8 -- caption to column edge, both sides together
local COLUMN_MIN_WIDTH = 24

--[[
    A starting width, replaced the first time the font resolves. Amount is
    measured like every other column -- against its own caption AND against a
    four-digit count, since the edit box under it has to hold what the caption
    names. It was the one hardcoded width left in a file that measures
    everything else, and at 40px the heading read "Am...".
]]
ns.RESTOCK_AMOUNT_WIDTH = 58
local AMOUNT_DIGITS_SAMPLE = "8888"

--[[
    Starting widths are the English measurement, replaced the first time the font
    resolves. Cells re-read them on every update (see UpdateRestockListRow), and
    because each cell is anchored to its neighbour's edge rather than to a fixed
    x, setting a new width is all it takes to reflow the whole chain.
]]
ns.RESTOCK_COLUMN_WIDTH = {
	withdraw = 38,
	deposit = 42,
	buy = 32,
	extra = 40,
	rep = 54,
	upgrade = 60,
}
ns.RESTOCK_COLUMN_WIDTH_SERIAL = 0 -- bumped when the widths change, so rows notice

local columnsResolved = false

-- Measure every column from its caption, or nil while the font is unresolved.
local function MeasureColumns()
	local fontString = MeasureFontString()
	local widths = {}
	for _, column in ipairs(COLUMNS) do
		fontString:SetText(L[column.caption])
		local width = fontString:GetStringWidth() or 0
		if column.isText then
			--[[
			    A text column has to hold its widest VALUE, not just its caption:
			    "Rep" is three letters and "Exalted" is seven.
			]]
			for _, standing in ipairs(REP_STANDINGS) do
				fontString:SetText(standing.label)
				local standingWidth = fontString:GetStringWidth() or 0
				if standingWidth > width then
					width = standingWidth
				end
			end
		end
		if width <= 0 then
			return nil -- font not resolved yet; the next call re-measures
		end
		widths[column.key] = math.max(COLUMN_MIN_WIDTH, math.ceil(width) + COLUMN_PAD_X)
	end

	fontString:SetText(L["RESTOCKER_COLUMN_AMOUNT"])
	local amountWidth = fontString:GetStringWidth() or 0
	fontString:SetText(AMOUNT_DIGITS_SAMPLE)
	amountWidth = math.max(amountWidth, fontString:GetStringWidth() or 0)
	if amountWidth <= 0 then
		return nil
	end

	return widths, math.max(COLUMN_MIN_WIDTH, math.ceil(amountWidth) + COLUMN_PAD_X)
end

--[[
    A column's tooltip body, resolved from its locale keys. Cached on the column:
    the strings never change after load, and both the header cell and every pooled
    row cell ask for the same list.
]]
local function TooltipBody(column)
	if not column.bodyText then
		local lines = {}
		for _, key in ipairs(column.body) do
			lines[#lines + 1] = L[key]
		end
		column.bodyText = lines
	end
	return column.bodyText
end

-- Resolve the column widths once. A cheap no-op after that.
local function ResolveColumns()
	if columnsResolved then
		return
	end
	local widths, amountWidth = MeasureColumns()
	if widths then
		ns.RESTOCK_COLUMN_WIDTH = widths
		ns.RESTOCK_AMOUNT_WIDTH = amountWidth
		ns.RESTOCK_COLUMN_WIDTH_SERIAL = ns.RESTOCK_COLUMN_WIDTH_SERIAL + 1
		columnsResolved = true
	end
end

--[[
    Recompute the row and button heights from the font currently in use. Called
    when the window is built; safe to call again if a font add-on swaps fonts.
]]
function ns.RefreshRestockRowMetrics()
	local line = FontLineHeight()
	ns.RESTOCK_BUTTON_HEIGHT = math.max(22, math.ceil(line + BUTTON_PAD_Y))
	ns.RESTOCK_ROW_HEIGHT = ns.RESTOCK_BUTTON_HEIGHT + ROW_PAD_Y
	ns.RESTOCK_COLUMN_HEADER_HEIGHT = ns.RESTOCK_BUTTON_HEIGHT + math.ceil(line) + 2
	ResolveColumns()
end

ns.RESTOCK_COLUMN_HEADER_HEIGHT = 38

--[[
    Size a button to the caption it is currently showing. The button keeps its
    anchor, so a row's controls chain from the right edge and simply push the
    item name's cutoff further left as they grow.
]]
local function FitButton(button)
	local fontString = button:GetFontString()
	if not fontString then
		return
	end
	local width = fontString:GetStringWidth()
	if not width or width <= 0 then
		return -- font not resolved yet; the next UpdateRestockListRow re-fits it
	end
	button:SetWidth(math.max(BUTTON_MIN_WIDTH, math.ceil(width) + BUTTON_PAD_X))
	button:SetHeight(ns.RESTOCK_BUTTON_HEIGHT)
end

ns.FitRestockButton = FitButton

--------------------------------------------------------------------------------
-- Row Shape
--------------------------------------------------------------------------------

--[[
    [icon] Item Name ....  [Wdrw][Dpst]  [Buy][Extra][Rep]  [Upgrade]  [40]  [x]

    Everything right of the name is laid out by walking COLUMNS from the right
    edge inward, which is exactly what the header does, so the two line up by
    construction rather than by matching offsets in two places.

    Each cell anchors to its neighbour's edge, never to a fixed x. That is what
    lets a late column measurement reflow the row with nothing but SetWidth calls,
    and what lets the item name -- anchored on both sides -- absorb whatever the
    columns leave.
]]
local REMOVE_ICON_SIZE = 16
-- The row's inset from both its edges: the icon on the left, this on the right.
local ROW_INSET = 6

local ICON_SIZE = 18
local ICON_TEXT_GAP = 4
local NAME_INSET = ROW_INSET + ICON_SIZE + ICON_TEXT_GAP
local NAME_COLUMN_GAP = 10 -- name to the first cell

local AMOUNT_GAP = 6 -- amount box to the remove control

--------------------------------------------------------------------------------
-- Cell States
--------------------------------------------------------------------------------

--[[
    On is the game's own check glyph in the gold every other lit control uses. Off
    is a short dash rather than an empty cell, so a row reads as a row of answers
    instead of a row of holes, and so the click target is visible before it is
    hovered.

    Not-applicable is a third state, and it is the reason off cannot simply be
    blank: an item with no upgrade ladder and an item with upgrading switched off
    are different facts. It draws the same dash, dimmer, and takes no clicks.
]]
--[[
    Every lit control in the window is the palette's TITLE gold and every plain
    body string its TEXT white, so both are read from the shared numeric palette
    rather than written out again here.

    The greys below are not palette roles: they are this window's own UI states,
    and each says something a palette colour does not. They live here as named
    constants so no call site carries a bare triple.
]]
local GOLD = ns.COLORS_RGB.TITLE
local WHITE = ns.COLORS_RGB.TEXT

local DASH_OFF = { r = 0.48, g = 0.48, b = 0.48 } -- a setting that is off
local DASH_NOT_APPLICABLE = { r = 0.28, g = 0.28, b = 0.28 } -- a setting that cannot apply
--[[
    Column headings are coloured by the band they belong to, so the eye can see
    where Bank stops and Merchant starts without a rule between them. The three
    columns in no band -- Item, Upgrade, Amount -- take the brand gold every
    other heading in the add-on already uses. Gold on the outside is what lets
    the two coloured bands read as a pair set into ordinary chrome rather than as
    three groups competing with one another.

    Each band carries TWO tones: the brighter `label` for the band's own name,
    the softer `caption` for the column headings under it. That step down is what
    makes the label read as the parent of the columns it spans instead of as one
    more heading sitting in the same row as them.

    Neither band uses a brand colour. ns.COLORS_RGB.INFO and .ON already mean
    something everywhere else -- interactive, and on -- and a static heading must
    not borrow it; the brand green directly above a column of on/off ticks read
    as a state rather than as a label. They stay clear of the item-quality
    colours the list draws names in (uncommon 1eff00, rare 0070dd) for the same
    reason. These are chrome, and have to look like it.
]]
local HEADER_CAPTION_UNGROUPED = ns.COLORS_RGB.TITLE -- Item, Upgrade, Amount

local GROUP_TONE = {
	RESTOCKER_ROW_BANK = {
		label = ns.HexToRGB("39D5FF"),
		caption = ns.HexToRGB("8BC7D8"),
	},
	RESTOCKER_ROW_MERCHANT = {
		label = ns.HexToRGB("FF4FA3"),
		caption = ns.HexToRGB("D38EAF"),
	},
}
local REPUTATION_SET = { r = 0.85, g = 0.6, b = 0.35 } -- a standing is required, amber to stand out

--[[
    Lay the cells out right to left, and hand back the leftmost one. Used by both
    the rows and the header, which is the whole point: one walk, one set of gaps,
    so a column can never sit in two different places.
]]
local function LayoutColumns(anchorTo, build)
	local cells = {}
	local anchor = anchorTo
	local gap = COLUMN_GROUP_GAP -- last column to the amount box
	for i = #COLUMNS, 1, -1 do
		local column = COLUMNS[i]
		local cell = build(column)
		cell:SetPoint("RIGHT", anchor, "LEFT", -gap, 0)
		cells[column.key] = cell
		anchor = cell
		gap = column.gapBefore and COLUMN_GROUP_GAP or COLUMN_GAP
	end
	return cells, anchor
end

-- Push the current column widths into a set of cells. Cheap and idempotent.
local function ApplyColumnWidths(cells)
	for _, column in ipairs(COLUMNS) do
		local cell = cells[column.key]
		if cell then
			cell:SetWidth(ns.RESTOCK_COLUMN_WIDTH[column.key] or COLUMN_MIN_WIDTH)
		end
	end
end

--[[
    Which tone each column's caption takes, and which its band label takes. A
    column carrying `group` opens a band and every column after it inherits that
    band's caption tone until the next boundary; `gapBefore` without a `group`
    closes the band and falls back to the ungrouped gold, which is how Upgrade,
    sitting alone between Merchant and Amount, gets its colour.

    BAND_LABEL_TONE is keyed by the column that OPENS each band, because that is
    the key the band-drawing loop below already has in hand.

    Both are derived from GROUP_TONE rather than declared per column, so the Bank
    columns and the "Bank" label over them read from one entry and cannot drift
    apart. A band added to COLUMNS with no tone comes out gold rather than
    silently inheriting its neighbour's colour.
]]
local COLUMN_TONE = {}
local BAND_LABEL_TONE = {}
do
	local tone = HEADER_CAPTION_UNGROUPED
	for _, column in ipairs(COLUMNS) do
		if column.group then
			local band = GROUP_TONE[column.group]
			tone = (band and band.caption) or HEADER_CAPTION_UNGROUPED
			BAND_LABEL_TONE[column.key] = (band and band.label) or HEADER_CAPTION_UNGROUPED
		elseif column.gapBefore then
			tone = HEADER_CAPTION_UNGROUPED
		end
		COLUMN_TONE[column.key] = tone
	end
end

--------------------------------------------------------------------------------
-- Column Header
--------------------------------------------------------------------------------

--[[
    Anchored to the scroll frame's top corners so it inherits the same width and,
    crucially, the same RIGHT edge as the rows inside it -- rows are sized to the
    scroll frame, and both lay out from that edge. Nothing here knows an x
    coordinate.

    It sits outside the scroll frame rather than at the top of the list, so it
    stays put while the list scrolls under it.
]]
function ns.CreateRestockColumnHeader(parent, scrollFrame)
	local header = CreateFrame("Frame", nil, parent)
	header:SetPoint("BOTTOMLEFT", scrollFrame, "TOPLEFT", 0, 2)
	header:SetPoint("BOTTOMRIGHT", scrollFrame, "TOPRIGHT", 0, 2)
	header:SetHeight(ns.RESTOCK_COLUMN_HEADER_HEIGHT)

	local rule = header:CreateTexture(nil, "ARTWORK")
	rule:SetPoint("BOTTOMLEFT", header, "BOTTOMLEFT", 0, 0)
	rule:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", 0, 0)
	rule:SetHeight(1)
	rule:SetColorTexture(GOLD.r, GOLD.g, GOLD.b, 0.20)

	--[[
	    The lower tier is its own frame so everything in it centres vertically by
	    itself, exactly the way a row does. The group bands then have the whole
	    remaining height above it and never have to be positioned against a
	    caption's baseline.
	]]
	local captionRow = CreateFrame("Frame", nil, header)
	captionRow:SetPoint("BOTTOMLEFT", header, "BOTTOMLEFT", 0, 2)
	captionRow:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", 0, 2)
	captionRow:SetHeight(ns.RESTOCK_BUTTON_HEIGHT)

	local function caption(parentFrame, text, tone, width)
		local fontString = parentFrame:CreateFontString(nil, "OVERLAY")
		fontString:SetFontObject(BUTTON_FONT)
		fontString:SetTextColor(tone.r, tone.g, tone.b)
		fontString:SetText(text)
		if width then
			fontString:SetWidth(width)
			fontString:SetJustifyH("CENTER")
		end
		return fontString
	end

	--[[
	    A stand-in for the remove control, which has no caption but does take up the
	    width the rows give it. Without it every heading would sit one icon too far
	    right.
	]]
	local removeSpacer = CreateFrame("Frame", nil, captionRow)
	removeSpacer:SetSize(REMOVE_ICON_SIZE, 1)
	removeSpacer:SetPoint("RIGHT", captionRow, "RIGHT", -ROW_INSET, 0)

	local amount = caption(captionRow, L["RESTOCKER_COLUMN_AMOUNT"], HEADER_CAPTION_UNGROUPED, ns.RESTOCK_AMOUNT_WIDTH)
	amount:SetPoint("RIGHT", removeSpacer, "LEFT", -AMOUNT_GAP, 0)
	header.amountCaption = amount

	--[[
	    Captions ride on buttons of their column's width: a FontString takes no
	    mouse, and hovering a heading has to give the same explanation as hovering a
	    cell under it. That is what lets the cells be glyphs instead of repeating
	    the words on every row.
	]]
	header.cells = LayoutColumns(amount, function(column)
		local button = CreateFrame("Button", nil, captionRow)
		button:SetSize(ns.RESTOCK_COLUMN_WIDTH[column.key] or COLUMN_MIN_WIDTH, ns.RESTOCK_BUTTON_HEIGHT)
		local fontString = button:CreateFontString(nil, "OVERLAY")
		fontString:SetFontObject(BUTTON_FONT)
		local tone = COLUMN_TONE[column.key]
		fontString:SetTextColor(tone.r, tone.g, tone.b)
		fontString:SetText(L[column.caption])
		fontString:SetPoint("CENTER")
		ns.SetupRestockerTooltip(button, L[column.title], unpack(TooltipBody(column)))
		return button
	end)

	--[[
	    GROUP BANDS

	    Each band anchors to the LEFT of its group's first column and the RIGHT of
	    its last, so it centres itself over exactly the columns it covers and
	    re-spans on its own whenever those columns are re-measured. No band is ever
	    told a width.

	    A column with no `group` (Upgrade) gets no band -- its own caption is
	    already the whole word.
	]]
	for i, column in ipairs(COLUMNS) do
		if column.group then
			--[[
			    A band runs until the next column STARTS one. `gapBefore` is that signal
			    as much as `group` is -- Upgrade opens its own band and carries no label,
			    and stopping only at the next labelled column swallowed it into
			    Merchant, which drew "Merchant" over the Upgrade column.
			]]
			local last = column
			for j = i + 1, #COLUMNS do
				if COLUMNS[j].group or COLUMNS[j].gapBefore then
					break
				end
				last = COLUMNS[j]
			end
			local band = caption(header, L[column.group], BAND_LABEL_TONE[column.key])
			band:SetJustifyH("CENTER")
			band:SetPoint("LEFT", header.cells[column.key], "LEFT", 0, 0)
			band:SetPoint("RIGHT", header.cells[last.key], "RIGHT", 0, 0)
			band:SetPoint("TOP", header, "TOP", 0, -1)
		end
	end

	local item = caption(captionRow, L["RESTOCKER_COLUMN_ITEM"], HEADER_CAPTION_UNGROUPED)
	item:SetPoint("LEFT", captionRow, "LEFT", NAME_INSET, 0)

	ns.restockColumnHeader = header
	return header
end

--[[
    Re-sync the header to the current column widths. Called from ns.UpdateRestockList, which
    is where a late measurement first shows up.
]]
function ns.RefreshRestockColumnHeader()
	local header = ns.restockColumnHeader
	if header and header.cells then
		ApplyColumnWidths(header.cells)
		-- The amount heading is not one of the laid-out cells, so it re-widths here.
		header.amountCaption:SetWidth(ns.RESTOCK_AMOUNT_WIDTH)
	end
end

--------------------------------------------------------------------------------
-- Shared With The Rows
--------------------------------------------------------------------------------

--[[
    The grid's surface for Restocker-Window-Rows.lua. Everything else above is
    private to this file: the measurement, the resolved widths, and the header.
]]
ns.RESTOCK_COLUMNS = COLUMNS
ns.RESTOCK_REMOVE_ICON_SIZE = REMOVE_ICON_SIZE
ns.RESTOCK_COLUMN_MIN_WIDTH = COLUMN_MIN_WIDTH
ns.RESTOCK_ROW_INSET = ROW_INSET
ns.RESTOCK_ICON_SIZE = ICON_SIZE
ns.RESTOCK_ICON_TEXT_GAP = ICON_TEXT_GAP
ns.RESTOCK_NAME_COLUMN_GAP = NAME_COLUMN_GAP
ns.RESTOCK_AMOUNT_GAP = AMOUNT_GAP
ns.RESTOCK_CELL_GOLD = GOLD
ns.RESTOCK_CELL_WHITE = WHITE
ns.RESTOCK_CELL_DASH_OFF = DASH_OFF
ns.RESTOCK_CELL_DASH_NOT_APPLICABLE = DASH_NOT_APPLICABLE
ns.RESTOCK_CELL_REPUTATION_SET = REPUTATION_SET
ns.LayoutRestockColumns = LayoutColumns
ns.ApplyRestockColumnWidths = ApplyColumnWidths
ns.RestockColumnTooltipBody = TooltipBody
ns.RestockReputationStandingByValue = ReputationStandingByValue
ns.RestockReputationMenuText = ReputationMenuText
