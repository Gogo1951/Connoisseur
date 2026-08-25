local _, ns = ... ---@type string, table
local L = ns.L
local RS = CRS_ADDON ---@type RestockerAddon

local bankModule = CrsModule.bankModule ---@type RsBankModule
local restockerModule = CrsModule.restockerModule ---@type RsRestockerModule
local eventsModule = CrsModule.eventsModule ---@type RsEventsModule

-- Required-reputation choices for the per-row dropdown. `value` is the item.reaction
-- code the merchant logic compares against UnitReaction(vendor) -- 0 means "no
-- requirement". `discount` is the standard Classic faction-vendor price saving for
-- that standing, shown for reference (it is informational, not enforced here).
-- "Neutral" is omitted: requiring Neutral is the same as no requirement ("Any"), since
-- you can already buy from any vendor you're at least Neutral with.
local REP_STANDINGS = {
  { value = 0, label = L["RESTOCKER_REPUTATION_ANY"], discount = 0 },
  { value = 5, label = L["RESTOCKER_REPUTATION_FRIENDLY"], discount = 5 },
  { value = 6, label = L["RESTOCKER_REPUTATION_HONORED"], discount = 10 },
  { value = 7, label = L["RESTOCKER_REPUTATION_REVERED"], discount = 15 },
  { value = 8, label = L["RESTOCKER_REPUTATION_EXALTED"], discount = 20 },
}

---@param value number|nil
local function repStandingByValue(value)
  value = value or 0
  for _, s in ipairs(REP_STANDINGS) do
    if s.value == value then
      return s
    end
  end
  return REP_STANDINGS[1] -- default to "Any"
end

---Menu label, e.g. "Honored  (10% off)"
local function repMenuText(s)
  if s.discount and s.discount > 0 then
    return string.format(L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"], s.label, s.discount)
  end
  return s.label
end

--[[
  ROW METRICS

  Nothing in a row carries a hardcoded size any more: a caption that outgrew its
  button was how "Withdraw" ended up clipped. Every control measures the font it
  actually draws with, so a larger UI font (or a longer word in another locale)
  widens the button instead of overflowing it.

  RS.ROW_HEIGHT and RS.BUTTON_HEIGHT start at the values the fixed layout used
  and are recomputed by RS.RefreshRowMetrics once the frame exists. With the
  stock font the measurement lands back on exactly these numbers.
]]
RS.ROW_HEIGHT = 26
RS.BUTTON_HEIGHT = 22

--[[
  A row carries two lines: the summary line, always shown, and the detail line
  holding the Bank/Merchant controls, shown only while the row is expanded.
  RS.ROW_HEIGHT is the collapsed height; RS.ROW_HEIGHT_EXPANDED adds the second
  line. Both are derived from the measured font like everything else here, so a
  font add-on grows the open row too.
]]
RS.ROW_HEIGHT_EXPANDED = 50

local BUTTON_FONT = "GameFontNormalSmall"
local BUTTON_PAD_X = 16 -- caption to button edge, both sides together
local BUTTON_PAD_Y = 8
local BUTTON_MIN_WIDTH = 28
local ROW_PAD_Y = 4 -- breathing room above and below the tallest control
local LINE_GAP = 2 -- between the summary line and the detail line

-- Scratch FontString used only to measure BUTTON_FONT; never shown.
local rsMeasureFS

local function rsFontLineHeight()
  if not rsMeasureFS then
    rsMeasureFS = (RS.hiddenFrame or UIParent):CreateFontString(nil, "ARTWORK", BUTTON_FONT)
    rsMeasureFS:Hide()
  end
  rsMeasureFS:SetText("Wg")
  local h = rsMeasureFS:GetStringHeight()
  -- GetStringHeight reads 0 before the font is resolved; fall back to the
  -- height that produces today's 22px button.
  if not h or h <= 0 then
    return 14
  end
  return h
end

---Recompute the row and button heights from the font currently in use. Called
---when the window is built; safe to call again if a font add-on swaps fonts.
function RS.RefreshRowMetrics()
  local line = rsFontLineHeight()
  RS.BUTTON_HEIGHT = math.max(22, math.ceil(line + BUTTON_PAD_Y))
  RS.ROW_HEIGHT = RS.BUTTON_HEIGHT + ROW_PAD_Y
  RS.ROW_HEIGHT_EXPANDED = RS.ROW_HEIGHT + LINE_GAP + RS.BUTTON_HEIGHT
end

--------------------------------------------------------------------------------
-- Row Expansion
--------------------------------------------------------------------------------

--[[
  One row open at a time, keyed by itemID rather than by frame: rows come from a
  pool and are handed to whichever entry needs them each RS:Update, so a frame
  reference would drift onto a different item the moment a filter keystroke
  reshuffles the list.

  View state for one sitting, like RS.newItems -- never persisted, cleared when
  the window closes.
]]
RS.expandedItem = nil

---@param item RsTradeCommand|nil
---@return boolean
function RS.IsRowExpanded(item)
  return item ~= nil and item.itemID ~= nil and RS.expandedItem == item.itemID
end

---@param itemID number|nil
function RS.ToggleRowExpanded(itemID)
  if not itemID then
    return
  end
  -- A rep menu belongs to the row that opened it; collapsing would strand it.
  CloseDropDownMenus()
  RS.expandedItem = (RS.expandedItem ~= itemID) and itemID or nil
  RS:Update()
end

function RS.CollapseAllRows()
  RS.expandedItem = nil
end

--[[
  Whether this row still matches what RS:addItem creates: all three toggles on,
  no reputation requirement, Auto-Upgrade left at its nil default. Collapsing
  hides the gold/grey toggles that answer "why was this not bought?", so a row
  that has been changed away from the defaults shows a marker in its summary
  line to say there is something worth opening.
]]
---@param item RsTradeCommand
---@return boolean
local function rsIsDefaultRow(item)
  return (item.buyFromMerchant == nil or item.buyFromMerchant)
      and item.stashTobank
      and item.restockFromBank
      and (item.reaction or 0) == 0
      and item.upgrade ~= false
end

---Size a button to the caption it is currently showing. The button keeps its
---anchor, so a row's controls chain from the right edge and simply push the
---item name's cutoff further left as they grow.
---@param btn WowControl
local function rsFitButton(btn)
  local fs = btn:GetFontString()
  if not fs then
    return
  end
  local w = fs:GetStringWidth()
  if not w or w <= 0 then
    return -- font not resolved yet; the next UpdateRestockListRow re-fits it
  end
  btn:SetWidth(math.max(BUTTON_MIN_WIDTH, math.ceil(w) + BUTTON_PAD_X))
  btn:SetHeight(RS.BUTTON_HEIGHT)
end

RS.FitButton = rsFitButton

---Render a toggle button: always show its label, gold when on, dimmed grey when off.
---@param btn RsItemButton
---@param label string
---@param on boolean|nil
local function rsSetToggleButton(btn, label, on)
  btn:SetText(label)
  local fs = btn:GetFontString()
  if fs then
    if on then
      fs:SetTextColor(1, 0.82, 0) -- gold = enabled
    else
      fs:SetTextColor(0.5, 0.5, 0.5) -- grey = disabled
    end
  end
  rsFitButton(btn)
end

-- The reputation menu uses Blizzard's UIDropDownMenu API -- the SAME one the working
-- profile selector uses -- not EasyMenu (which is unreliable in current Classic Era).
-- One shared menu frame is reused by every row; the row/item it was opened for is
-- stashed here so the initializer knows what to draw and where to write the choice.
local repMenuItem = nil ---@type RsTradeCommand|nil
local repMenuRow = nil  ---@type RsRestockingListRow|nil

RS.repMenuFrame = RS.repMenuFrame
    or CreateFrame("Frame", "ConnoisseurRestockerRepMenu", UIParent, "UIDropDownMenuTemplate")

---UIDropDownMenu initializer: a title plus one entry per standing, current one checked.
---Selecting an entry writes item.reaction and refreshes the row.
local function repMenuInitialize(_self, level)
  if not repMenuItem then
    return
  end

  local title = UIDropDownMenu_CreateInfo()
  title.text = L["RESTOCKER_REPUTATION_MENU_TITLE"]
  title.isTitle = true
  title.notCheckable = true
  UIDropDownMenu_AddButton(title, level)

  for _, s in ipairs(REP_STANDINGS) do
    local info = UIDropDownMenu_CreateInfo()
    info.text = repMenuText(s)
    info.checked = ((repMenuItem.reaction or 0) == s.value)
    info.func = function()
      -- store nil for "Any" so nothing is persisted; otherwise the standing code
      repMenuItem.reaction = (s.value > 0) and s.value or nil
      RS:UpdateRestockListRow( --[[---@not nil]] repMenuRow, --[[---@not nil]] repMenuItem)
      CloseDropDownMenus()
    end
    UIDropDownMenu_AddButton(info, level)
  end
end

local rsTooltip = RS.SetupTooltip

---Create an amount edit box, aligning to the left of alignFrame
---@param frame RsRestockerFrame
---@param chainTo RsRestockerFrame
local function rsAmountEditBox(frame, chainTo)
  local settings = restockerModule.settings
  local editBox = --[[---@type WowInputBox]] CreateFrame("EditBox", nil, frame, "InputBoxTemplate");

  editBox:SetSize(40, RS.BUTTON_HEIGHT - 2)
  editBox:SetPoint("RIGHT", chainTo, "LEFT", 3, 0);
  editBox:SetAutoFocus(false);
  -- Digits only, and every read still falls back to 0: item.amount is compared
  -- against bag counts by the bank restock loop, where a nil target throws and
  -- aborts the whole run.
  editBox:SetNumeric(true)
  -- Both handlers read self.item (rebound by UpdateRestockListRow), not
  -- GetParent().item -- the box lives on line1 in the two-line row layout,
  -- the same reparenting trap that broke the remove button.
  editBox:SetScript("OnEnterPressed", function(self)
    local amount = tonumber(self:GetText()) or 0

    if self.item then
      self.item.amount = amount
    end
    editBox:ClearFocus()
    self:SetText(tostring(amount));
    RS:Update()
    if bankModule.bankIsOpen then
      eventsModule.OnBankOpen(true)
    end
  end);
  editBox:SetScript("OnKeyUp",
    function(self)
      if self.item then
        self.item.amount = tonumber(self:GetText()) or 0
      end
    end)

  rsTooltip(editBox, L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"], L["RESTOCKER_AMOUNT_TOOLTIP_BODY"])

  frame.editBox = editBox
  frame.isInUse = true
  frame:Show()

  return editBox;
end

---Create the required-reputation dropdown button, aligning to the left of chainTo.
---Clicking it opens a menu of standings (Any/Neutral/.../Exalted) with the standard
---vendor discount shown. The chosen standing is stored as item.reaction.
---@param frame RsRestockerFrame
---@param chainTo RsRestockerFrame
---@param item RsTradeCommand
---@return RsItemButton
local function rsReputationButton(frame, chainTo, item)
  local btn = --[[---@type RsItemButton]] CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")

  btn:SetPoint("RIGHT", chainTo, "LEFT", -4, 0)
  btn:SetHeight(RS.BUTTON_HEIGHT)
  btn.item = item

  local fs = btn:GetFontString()
  if fs then
    fs:SetFontObject(BUTTON_FONT)
    fs:SetTextColor(0.85, 0.6, 0.35) -- keep the reputation control's amber tint
  end

  btn:SetScript("OnClick", function(self)
    repMenuItem = self.item
    repMenuRow = frame
    UIDropDownMenu_Initialize(RS.repMenuFrame, repMenuInitialize, "MENU")
    ToggleDropDownMenu(1, nil, RS.repMenuFrame, "cursor", 0, 0)
    -- The main window is FULLSCREEN strata, so the menu would open BEHIND it at the
    -- default DIALOG strata. Lift the open list above the window.
    if DropDownList1 then
      DropDownList1:SetFrameStrata("FULLSCREEN_DIALOG")
    end
  end)

  rsTooltip(btn,
    L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"],
    L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"],
    L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"],
    L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"])

  return btn
end

--[[
  Reads self.item, which UpdateRestockListRow rebinds like every other row
  control -- NOT GetParent().item: the two-line row layout parents this
  button to line1, which carries no item, and resolving through the parent
  is exactly how removal silently broke when that layout landed.
]]
local function rsOnDeleteButtonClick(self)
  local settings = restockerModule.settings
  local profile = --[[---@not nil]] settings.profiles[settings.currentProfile]
  local item = self.item

  if item and item.itemID then
    -- Profiles are keyed by itemID, so removal is a direct delete
    profile[item.itemID] = nil
    RS:Update();
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
local REMOVE_ICON_SIZE = 16

---Create the remove button which on click will remove the restocking item row
local function rsDeleteButton(frame)
  local btn = CreateFrame("Button", nil, frame)

  btn:SetPoint("RIGHT", frame, "RIGHT", -6, 0)
  btn:SetSize(REMOVE_ICON_SIZE, REMOVE_ICON_SIZE)
  btn:SetNormalTexture(REMOVE_ICON)
  btn:SetPushedTexture(REMOVE_ICON_DOWN)
  btn:SetHighlightTexture(REMOVE_ICON, "ADD")
  btn:SetScript("OnClick", rsOnDeleteButtonClick)
  rsTooltip(btn, L["RESTOCKER_REMOVE_TOOLTIP"])
  return btn
end

---Create a button to toggle buying from merchants
---@param item RsTradeCommand
---@return RsItemButton
local function rsBuyFromMerchantButton(frame, chainTo, item)
  local btn = --[[---@type RsItemButton]] CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")

  btn:SetPoint("RIGHT", chainTo, "LEFT", 3, 0);
  btn:SetHeight(RS.BUTTON_HEIGHT)
  if btn:GetFontString() then btn:GetFontString():SetFontObject(BUTTON_FONT) end
  btn.item = item

  btn:SetScript("OnClick", function(self)
    if self.item.buyFromMerchant == nil then
      self.item.buyFromMerchant = false -- nil default to true, so toggle to false
    else
      self.item.buyFromMerchant = not self.item.buyFromMerchant
    end
    RS:UpdateRestockListRow(frame, self.item)
  end)
  rsTooltip(btn, L["RESTOCKER_BUY_TOOLTIP_TITLE"], L["RESTOCKER_BUY_TOOLTIP_BODY"])
  return btn
end

--[[
  Create a button to toggle following the food/water upgrade ladder.

  Unlike its neighbours this one has a third state. Only vendor-sold staples
  sit on a ladder, so on a real Restock List most rows -- potions, bandages,
  reagents -- can never upgrade. Those show the button disabled rather than
  hidden, so every row keeps the same shape and the control reads as "not
  applicable here" instead of vanishing.
]]
---@param item RsTradeCommand
---@return RsItemButton
local function rsUpgradeButton(frame, chainTo, item)
  local btn = --[[---@type RsItemButton]] CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")

  btn:SetPoint("RIGHT", chainTo, "LEFT", 3, 0);
  btn:SetHeight(RS.BUTTON_HEIGHT)
  if btn:GetFontString() then btn:GetFontString():SetFontObject(BUTTON_FONT) end
  btn.item = item

  btn:SetScript("OnClick", function(self)
    if self.item.upgrade == nil then
      self.item.upgrade = false -- nil defaults to true, so toggle to false
    else
      self.item.upgrade = not self.item.upgrade
    end
    RS:UpdateRestockListRow(frame, self.item)
  end)
  rsTooltip(btn, L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"], L["RESTOCKER_UPGRADE_TOOLTIP_BODY"])
  return btn
end

---Create a button to toggle storing to bank
---@param item RsTradeCommand
---@return RsItemButton
local function rsStashToBankButton(frame, chainTo, item)
  local btn = --[[---@type RsItemButton]] CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")

  btn:SetPoint("RIGHT", chainTo, "LEFT", 3, 0);
  btn:SetHeight(RS.BUTTON_HEIGHT)
  if btn:GetFontString() then btn:GetFontString():SetFontObject(BUTTON_FONT) end
  btn.item = item

  btn:SetScript("OnClick", function(self)
    self.item.stashTobank = not self.item.stashTobank
    RS:UpdateRestockListRow(frame, self.item)
  end)
  rsTooltip(btn, L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"], L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"])
  return btn
end

---Create a button to toggle restocking from bank
---@param item RsTradeCommand
---@return RsItemButton
local function rsRestockFromBankButton(frame, chainTo, item)
  local btn = --[[---@type RsItemButton]] CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")

  btn:SetPoint("RIGHT", chainTo, "LEFT", 3, 0);
  btn:SetHeight(RS.BUTTON_HEIGHT)
  if btn:GetFontString() then btn:GetFontString():SetFontObject(BUTTON_FONT) end
  btn.item = item

  btn:SetScript("OnClick", function(self)
    self.item.restockFromBank = not self.item.restockFromBank
    RS:UpdateRestockListRow(frame, self.item)
  end)
  rsTooltip(btn, L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"], L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"])
  return btn
end

function RS:CreateFrame()
  -- Rows are positioned by RS:Update (absolute row index), not chained here, so headers
  -- and item rows can interleave freely.
  local frame = --[[---@type RsReusableFrame]] CreateFrame("Frame", nil, RS.hiddenFrame, nil)
  frame.index = #RS.framepool + 1
  frame:SetSize(RS.MainFrame.scrollChild:GetWidth(), RS.ROW_HEIGHT);
  return frame
end

---Was this item added during the current viewing of the window? See RS.newItems.
---@param item RsTradeCommand
---@return boolean
local function rsIsNew(item)
  return (item.itemID ~= nil) and (RS.newItems[item.itemID] == true)
end

---The item-type group used for sorting and section headers -- the exact WoW item class
---from GetItemInfo (e.g. "Consumable", "Weapon", "Armor", "Quest", "Trade Goods",
---"Miscellaneous"). Falls back to a stored type, then "Other" until the item is cached.
---Just-added items report the "New" group instead, until the window closes.
---@param item RsTradeCommand
---@return string
local function rsItemGroupOf(item)
  if rsIsNew(item) then
    return L["RESTOCKER_GROUP_NEW"]
  end
  local info = RS.GetItemInfo(item.itemID)
  if info and info.itemType and info.itemType ~= "" then
    return info.itemType
  end
  if item.itemType and item.itemType ~= "" then
    return item.itemType
  end
  return L["RESTOCKER_GROUP_OTHER"]
end

local function rsCompareName(a, b)
  return (a.itemName or "") < (b.itemName or "")
end

---Apply the text filter, then group the items by type into a render list: a sequence of
---{ item = <item> } entries with { header = <type> } entries at each group boundary.
---Items are sorted by type, then by name within each group.
---@param items RsTradeCommand[]
---@return table[]
function RS:BuildRenderList(items)
  -- Text filter: once 2+ characters are typed, keep only items whose name, type,
  -- or item ID contains the text (case-insensitive, plain substring). Fewer
  -- chars = show all.
  local filter = RS.listFilter
  if filter and #filter >= 2 then
    local lf = filter:lower()
    local kept = {}
    for _, item in ipairs(items) do
      if ((item.itemName or ""):lower():find(lf, 1, true))
          or (rsItemGroupOf(item):lower():find(lf, 1, true))
          or (tostring(item.itemID or ""):find(lf, 1, true)) then
        kept[#kept + 1] = item
      end
    end
    items = kept
  end

  --[[
    Grouped by item type, name-sorted within each group -- except New, which is
    ranked ahead of every other group rather than sorted with them. Sorting on
    the group name alone would file "New" alphabetically, landing it somewhere
    in the middle of the list, which is the one place it must not be.
  ]]
  table.sort(items, function(a, b)
    local na, nb = rsIsNew(a), rsIsNew(b)
    if na ~= nb then
      return na
    end
    local ga, gb = rsItemGroupOf(a), rsItemGroupOf(b)
    if ga ~= gb then
      return ga < gb
    end
    return rsCompareName(a, b)
  end)

  local renderList = {}
  local lastGroup = nil
  for _, item in ipairs(items) do
    local g = rsItemGroupOf(item)
    if g ~= lastGroup then
      renderList[#renderList + 1] = { header = g }
      lastGroup = g
    end
    renderList[#renderList + 1] = { item = item }
  end
  return renderList
end

---Create a section-header row (a tinted bar with the item-type name).
local function rsCreateHeaderRow()
  local frame = CreateFrame("Frame", nil, RS.hiddenFrame)
  frame:SetSize(RS.MainFrame.scrollChild:GetWidth(), RS.ROW_HEIGHT)

  local bg = frame:CreateTexture(nil, "BACKGROUND")
  bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -1)
  bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 1)
  bg:SetColorTexture(1, 0.82, 0, 0.10) -- subtle gold band

  local text = frame:CreateFontString(nil, "OVERLAY")
  text:SetFontObject("GameFontNormal")
  text:SetTextColor(1, 0.82, 0)
  text:SetPoint("LEFT", frame, "LEFT", 8, 0)
  frame.text = text

  table.insert(RS.headerpool, frame)
  return frame
end

---@return RsControl A free (or new) section-header row
function RS:GetHeaderRow()
  for _, h in ipairs(RS.headerpool) do
    if not h.isInUse then
      return h
    end
  end
  return rsCreateHeaderRow()
end

---@class RsItemButton: WowControl
---@field item RsTradeCommand

---@class RsRestockingListRow: RsControl
---@field text WowFontString
---@field icon WowTexture
---@field iconBtn WowControl
---@field editBox WowInputBox
---@field delBtn RsItemButton
---@field upgradeBtn RsItemButton
---@field buyBtn RsItemButton
---@field toBankBtn RsItemButton
---@field fromBankBtn RsItemButton
---@field amountBox WowControl
---@field repBtn RsItemButton
---@field item RsTradeCommand

--[[
  ROW SHAPE

  Summary line (always):  [+] [icon] Item Name .......... [40] [x]
  Detail line (expanded): Bank [Withdraw] [Deposit]   Merchant [Buy] [Rep: Any]   Upgrade [Automatic]

  The detail line is grouped by what each control acts on, and spaced to say so:
  three spaces in from the edge and between groups, one space inside a group.
  Reputation sits with Merchant because it only ever gates buying.

  The detail controls are parented to frame.line2, so showing and hiding the
  whole set is one SetShown on the line rather than six on the buttons. They are
  still CREATED against the row frame, because rsReputationButton captures it to
  hand back to RS:UpdateRestockListRow when a standing is picked -- reparenting
  afterwards moves the frame without disturbing that closure.

  The two line frames exist only as anchors: everything inside them anchors
  LEFT or RIGHT, so each control centres itself vertically on its own line and
  the row grows downward without any of them being repositioned.
]]
local EXPANDER_SIZE = 16
local EXPANDER_CLOSED = "Interface\\Buttons\\UI-PlusButton-Up"
local EXPANDER_OPEN = "Interface\\Buttons\\UI-MinusButton-Up"
local EXPANDER_HILIGHT = "Interface\\Buttons\\UI-PlusButton-Hilight"

local MODIFIED_PIP_SIZE = 5
--[[
  Detail-line spacing, in multiples of one space at the button font, so the
  rhythm in the sketch above is the rhythm on screen: three in from the edge and
  between groups, one between a label and its button and between buttons.
]]
local SPACE = 4
local ROW_INDENT = SPACE * 3 -- the detail line's left inset
local GROUP_GAP = SPACE * 3 -- between the Bank, Merchant and Upgrade groups
local CONTROL_GAP = SPACE -- between buttons inside a group
local LABEL_GAP = SPACE -- between a group's label and its first button

---A group caption on the detail line ("Bank", "Merchant").
---@param parent WowControl
---@param text string
local function rsGroupLabel(parent, text)
  local fs = parent:CreateFontString(nil, "OVERLAY")
  fs:SetFontObject(BUTTON_FONT)
  fs:SetTextColor(0.65, 0.65, 0.65)
  fs:SetText(text)
  return fs
end

---Create UI row for items
---@return RsRestockingListRow
---@param item RsTradeCommand
function RS:CreateRestockListRow(item)
  local frame = --[[---@type RsRestockingListRow]] self:CreateFrame()
  frame.item = item

  local line1 = CreateFrame("Frame", nil, frame)
  line1:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -ROW_PAD_Y / 2)
  line1:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -ROW_PAD_Y / 2)
  line1:SetHeight(RS.BUTTON_HEIGHT)
  frame.line1 = line1

  local line2 = CreateFrame("Frame", nil, frame)
  line2:SetPoint("TOPLEFT", line1, "BOTTOMLEFT", 0, -LINE_GAP)
  line2:SetPoint("TOPRIGHT", line1, "BOTTOMRIGHT", 0, -LINE_GAP)
  line2:SetHeight(RS.BUTTON_HEIGHT)
  line2:Hide()
  frame.line2 = line2

  local function toggle()
    RS.ToggleRowExpanded(frame.item and frame.item.itemID)
  end

  -- EXPANDER
  local expander = CreateFrame("Button", nil, line1)
  expander:SetSize(EXPANDER_SIZE, EXPANDER_SIZE)
  expander:SetPoint("LEFT", line1, "LEFT", 4, 0)
  expander:SetNormalTexture(EXPANDER_CLOSED)
  expander:SetHighlightTexture(EXPANDER_HILIGHT)
  expander:SetScript("OnClick", toggle)
  frame.expander = expander

  -- ICON, with an invisible button over it that shows the item tooltip on hover
  local icon = frame:CreateTexture(nil, "ARTWORK")
  icon:SetSize(18, 18)
  icon:SetPoint("LEFT", expander, "RIGHT", 4, 0)
  icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- trim the default icon border
  frame.icon = icon

  local iconBtn = CreateFrame("Button", nil, line1)
  iconBtn:SetAllPoints(icon)
  iconBtn:SetScript("OnEnter", function(self)
    local it = frame.item
    if not (it and it.itemID) then
      return
    end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    -- Prefer the cached colored link; fall back to a bare item: link (always valid)
    local info = RS.GetItemInfo(it.itemID)
    GameTooltip:SetHyperlink((info and info.itemLink) or ("item:" .. it.itemID))
    GameTooltip:Show()
  end)
  iconBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
  iconBtn:SetScript("OnClick", toggle)
  frame.iconBtn = iconBtn

  -- SUMMARY LINE, right to left: [remove] then the amount box.
  frame.delBtn = rsDeleteButton(frame)
  frame.delBtn:SetParent(line1)
  frame.delBtn:ClearAllPoints()
  frame.delBtn:SetPoint("RIGHT", line1, "RIGHT", -6, 0)

  frame.amountBox = rsAmountEditBox(frame, frame.delBtn)
  frame.amountBox:SetParent(line1)
  frame.amountBox:ClearAllPoints()
  frame.amountBox:SetPoint("RIGHT", frame.delBtn, "LEFT", -6, 0)

  --[[
    Sits in the gap the item name always leaves before the amount box, so the
    name's cutoff does not move when the marker appears or goes.
  ]]
  local pip = line1:CreateTexture(nil, "OVERLAY")
  pip:SetSize(MODIFIED_PIP_SIZE, MODIFIED_PIP_SIZE)
  pip:SetPoint("RIGHT", frame.amountBox, "LEFT", -5, 0)
  pip:SetColorTexture(1, 0.82, 0, 0.9) -- the same gold the section headers band with
  pip:Hide()
  frame.modifiedPip = pip

  -- DETAIL LINE, left to right, grouped by what each control acts on.
  frame.bankLabel = rsGroupLabel(line2, L["RESTOCKER_ROW_BANK"])
  frame.bankLabel:SetPoint("LEFT", line2, "LEFT", ROW_INDENT, 0)

  frame.fromBankBtn = rsRestockFromBankButton(frame, frame.delBtn, item)
  frame.fromBankBtn:SetParent(line2)
  frame.fromBankBtn:ClearAllPoints()
  frame.fromBankBtn:SetPoint("LEFT", frame.bankLabel, "RIGHT", LABEL_GAP, 0)

  frame.toBankBtn = rsStashToBankButton(frame, frame.delBtn, item)
  frame.toBankBtn:SetParent(line2)
  frame.toBankBtn:ClearAllPoints()
  frame.toBankBtn:SetPoint("LEFT", frame.fromBankBtn, "RIGHT", CONTROL_GAP, 0)

  frame.merchantLabel = rsGroupLabel(line2, L["RESTOCKER_ROW_MERCHANT"])
  frame.merchantLabel:SetPoint("LEFT", frame.toBankBtn, "RIGHT", GROUP_GAP, 0)

  frame.buyBtn = rsBuyFromMerchantButton(frame, frame.delBtn, item)
  frame.buyBtn:SetParent(line2)
  frame.buyBtn:ClearAllPoints()
  frame.buyBtn:SetPoint("LEFT", frame.merchantLabel, "RIGHT", LABEL_GAP, 0)

  -- Reputation belongs to Merchant: it only ever gates buying.
  frame.repBtn = rsReputationButton(frame, frame.delBtn, item)
  frame.repBtn:SetParent(line2)
  frame.repBtn:ClearAllPoints()
  frame.repBtn:SetPoint("LEFT", frame.buyBtn, "RIGHT", CONTROL_GAP, 0)

  frame.upgradeLabel = rsGroupLabel(line2, L["RESTOCKER_ROW_UPGRADE"])
  frame.upgradeLabel:SetPoint("LEFT", frame.repBtn, "RIGHT", GROUP_GAP, 0)

  frame.upgradeBtn = rsUpgradeButton(frame, frame.delBtn, item)
  frame.upgradeBtn:SetParent(line2)
  frame.upgradeBtn:ClearAllPoints()
  frame.upgradeBtn:SetPoint("LEFT", frame.upgradeLabel, "RIGHT", LABEL_GAP, 0)

  -- ITEM NAME fills the gap between the icon and the leftmost summary control.
  -- Anchoring both sides (plus no word-wrap) keeps long names from overlapping.
  local text = line1:CreateFontString(nil, "OVERLAY", nil)
  text:SetFontObject("GameFontHighlight")
  text:SetJustifyH("LEFT")
  text:SetWordWrap(false)
  text:SetPoint("LEFT", icon, "RIGHT", 4, 0)
  text:SetPoint("RIGHT", frame.amountBox, "LEFT", -12, 0)
  frame.text = text

  --[[
    The name is the row's main hit area: a bare FontString takes no clicks, so
    an invisible button covers it. Kept clear of the amount box and the remove
    icon, which own their own clicks.
  ]]
  local nameBtn = CreateFrame("Button", nil, line1)
  nameBtn:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 0)
  nameBtn:SetPoint("BOTTOMRIGHT", frame.amountBox, "BOTTOMLEFT", -12, 0)
  nameBtn:SetScript("OnClick", toggle)
  frame.nameBtn = nameBtn

  table.insert(RS.framepool, frame)
  return frame
end

---@param row RsRestockingListRow
---@param item RsTradeCommand
function RS:UpdateRestockListRow(row, item)
  row.item = item
  row.buyBtn.item = item
  row.fromBankBtn.item = item
  row.toBankBtn.item = item
  row.repBtn.item = item
  row.upgradeBtn.item = item
  -- These two live on line1 rather than the row frame, so they carry their
  -- item themselves (see rsOnDeleteButtonClick / rsAmountEditBox).
  row.delBtn.item = item
  row.editBox.item = item

  --[[
    Open or closed. The detail controls are all children of line2, so one
    SetShown covers the set; the marker only appears while they are hidden,
    since an open row already shows the state it would be standing in for.
  ]]
  local expanded = RS.IsRowExpanded(item)
  row.line2:SetShown(expanded)
  row.expander:SetNormalTexture(expanded and EXPANDER_OPEN or EXPANDER_CLOSED)
  row.modifiedPip:SetShown(not expanded and not rsIsDefaultRow(item))

  -- Toggle buttons always show their label; gold when on, dimmed grey when off.
  -- buyFromMerchant defaults to true (nil).
  rsSetToggleButton(row.buyBtn, L["RESTOCKER_BUY_LABEL"], item.buyFromMerchant == nil or item.buyFromMerchant)
  rsSetToggleButton(row.fromBankBtn, L["RESTOCKER_WITHDRAW_LABEL"], item.restockFromBank)
  rsSetToggleButton(row.toBankBtn, L["RESTOCKER_DEPOSIT_LABEL"], item.stashTobank)

  --[[
    Upgrade has a third state: items with no ladder can never upgrade, so the
    button is disabled rather than merely off. Disable() must come AFTER
    rsSetToggleButton, which sets the caption colour -- the disabled tint has
    to be the last word or the gold/grey would paint over it.
  ]]
  local canUpgrade = RS.CanUpgrade(item.itemID)
  rsSetToggleButton(row.upgradeBtn, L["RESTOCKER_UPGRADE_LABEL"], canUpgrade and (item.upgrade ~= false))
  if canUpgrade then
    row.upgradeBtn:Enable()
  else
    row.upgradeBtn:Disable()
    local fs = row.upgradeBtn:GetFontString()
    if fs then
      fs:SetTextColor(0.35, 0.35, 0.35) -- dimmer than "off", so the two never read alike
    end
  end

  -- Icon + quality-colored name (from the item cache; falls back until it is known)
  local info = RS.GetItemInfo(item.itemID)
  if info then
    row.icon:SetTexture(info.itemTexture)
    local q = ITEM_QUALITY_COLORS[info.itemRarity or 1]
    if q then
      row.text:SetTextColor(q.r, q.g, q.b)
    else
      row.text:SetTextColor(1, 1, 1)
    end
  else
    row.icon:SetTexture("Interface\\ICONS\\INV_Misc_QuestionMark")
    row.text:SetTextColor(1, 1, 1)
  end

  row.text:SetText(item.itemName)
  row.editBox:SetText(tostring(item.amount or 0))

  -- Reputation requirement button label. The standings differ in length
  -- ("Any" vs "Exalted"), so the button re-fits every time the label changes.
  row.repBtn:SetText(string.format(L["RESTOCKER_REPUTATION_BUTTON_FORMAT"], repStandingByValue(item.reaction).label))
  RS.FitButton(row.repBtn)
end