local _TOCNAME, ns = ... ---@type string, table
local L = ns.L
local RS = CRS_ADDON ---@type RestockerAddon

---@class RsMainFrameModule
local mainFrameModule = CrsModule.mainFrameModule ---@type RsMainFrameModule
local restockerModule = CrsModule.restockerModule ---@type RsRestockerModule

---@class RsControl: WowControl
---@field width number
---@field height number

---@class RsRestockerFrame: RsControl
---@field profileDropDownMenu WowControl
---@field editBox RsControl
---@field addBtn RsControl
---@field addGrp RsControl
---@field listInset RsControl
---@field scrollFrame RsControl
---@field scrollChild RsControl
---@field title RsControl
---@field resizeGrip RsControl Corner drag handle that resizes the window

--[[
  WINDOW GEOMETRY

  Size and position both live in settings.framePos, which is part of
  ConnoisseurRestockerDB -- a plain ## SavedVariables table, so it is
  account-wide and one window layout follows the player across characters.

  DEFAULT_WIDTH grew twice to keep a row's button strip off the item name, and
  came back down once the strip moved to its own line: a row now shows only its
  name, amount and remove control until it is expanded, so the widest thing the
  list draws is that detail line rather than every row at once.

  MIN_WIDTH is set by the footer rather than the list: the profile row up to the
  Rename label is fixed, and below this the rename field itself has nothing left
  to occupy. MAX_* is a sanity ceiling for a corrupt saved value, not a real
  limit.
]]
local DEFAULT_WIDTH = 620
local DEFAULT_HEIGHT = 400
local MIN_WIDTH = 580
local MIN_HEIGHT = 260
local MAX_WIDTH = 1600
local MAX_HEIGHT = 1200

local function rsClamp(value, lo, hi, fallback)
  value = tonumber(value)
  if not value then
    return fallback
  end
  return math.max(lo, math.min(hi, value))
end

---Persist where the window is and how big it is. Called when a drag or a
---resize finishes, and again at logout, so a crash loses at most the last
---adjustment rather than the whole layout.
function RS.SaveFrameGeometry()
  local frame = RS.MainFrame
  if not frame then
    return
  end
  local settings = restockerModule.settings
  settings.framePos = settings.framePos or {}

  local point, _, relativePoint, xOfs, yOfs = frame:GetPoint(frame:GetNumPoints())
  settings.framePos.point = point
  settings.framePos.relativePoint = relativePoint
  settings.framePos.xOfs = xOfs
  settings.framePos.yOfs = yOfs
  settings.framePos.width = math.floor(frame:GetWidth() + 0.5)
  settings.framePos.height = math.floor(frame:GetHeight() + 0.5)
end

function mainFrameModule:CreateAddonFrame()
  local settings = restockerModule.settings
  local addonFrame = --[[---@type RsRestockerFrame]] CreateFrame("Frame", "ConnoisseurRestockerFrame", UIParent,
    "BasicFrameTemplate");
  addonFrame.width = rsClamp(settings.framePos.width, MIN_WIDTH, MAX_WIDTH, DEFAULT_WIDTH)
  addonFrame.height = rsClamp(settings.framePos.height, MIN_HEIGHT, MAX_HEIGHT, DEFAULT_HEIGHT)
  addonFrame:SetSize(addonFrame.width, addonFrame.height);
  addonFrame:SetPoint(settings.framePos.point or "RIGHT",
    UIParent, settings.framePos.relativePoint or "RIGHT",
    settings.framePos.xOfs or -5,
    settings.framePos.yOfs or 0);
  addonFrame:SetFrameStrata("FULLSCREEN");
  addonFrame:SetMovable(true)
  addonFrame:SetResizable(true)
  addonFrame:EnableMouse(true)
  addonFrame:RegisterForDrag("LeftButton")
  addonFrame:SetScript("OnDragStart", addonFrame.StartMoving)
  addonFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    RS.SaveFrameGeometry()
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
    mainFrameModule:RelayoutFrame(self)
  end)

  --[[
    The "New" group and the open row both last exactly as long as the window is
    open. Hooked on OnHide rather than in RS:Hide because the frame also closes
    by routes that never reach it -- the title bar's X, and Escape via
    UISpecialFrames.
  ]]
  addonFrame:SetScript("OnHide", function()
    RS.ClearNewItems()
    RS.CollapseAllRows()
  end)
  return addonFrame
end

---Push the current window size down into the parts that cannot follow it by
---anchoring alone. Cheap enough to run on every frame of a resize drag: it
---sets widths and never rebuilds the list.
function mainFrameModule:RelayoutFrame(addonFrame)
  local scrollChild = addonFrame.scrollChild
  if not scrollChild then
    return -- still being built; CreateMenu lays out once at the end
  end

  addonFrame.width = addonFrame:GetWidth()
  addonFrame.height = addonFrame:GetHeight()
  addonFrame.listInset.width = addonFrame.listInset:GetWidth()
  addonFrame.listInset.height = addonFrame.listInset:GetHeight()

  local rowWidth = addonFrame.scrollFrame:GetWidth()
  scrollChild:SetWidth(rowWidth)
  for _, f in ipairs(RS.framepool) do
    f:SetWidth(rowWidth)
  end
  for _, h in ipairs(RS.headerpool) do
    h:SetWidth(rowWidth)
  end
end

---The corner grip that resizes the window. A child button, so it takes the
---mouse before the frame-wide drag-to-move handler sees it.
function mainFrameModule:CreateResizeGrip(addonFrame)
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
    mainFrameModule:RelayoutFrame(addonFrame)
    RS.SaveFrameGeometry()
  end)
  addonFrame.resizeGrip = grip
  return grip
end

function mainFrameModule:CreateListInset(addonFrame)
  local listInset = --[[---@type RsControl]] CreateFrame("Frame", nil, addonFrame, "InsetFrameTemplate3");
  -- Two corners instead of a size: the inset then tracks the window by itself.
  listInset:SetPoint("TOPLEFT", addonFrame, "TOPLEFT", 2, -22);
  listInset:SetPoint("BOTTOMRIGHT", addonFrame, "BOTTOMRIGHT", -4, 38);
  listInset.width = listInset:GetWidth()
  listInset.height = listInset:GetHeight()
  addonFrame.listInset = listInset
  return listInset
end

function mainFrameModule:CreateScrollFrame(addonFrame, listInset)
  local scrollFrame = --[[---@type RsControl]] CreateFrame("ScrollFrame", nil, addonFrame, "UIPanelScrollFrameTemplate")
  -- Leave 28px at the top for the filter box (CreateFilterBox), 26 on the
  -- right for the scroll bar, and 26 at the bottom for the add row.
  scrollFrame:SetPoint("TOPLEFT", listInset, "TOPLEFT", 8, -28);
  scrollFrame:SetPoint("BOTTOMRIGHT", listInset, "BOTTOMRIGHT", -26, 26);
  scrollFrame.width = scrollFrame:GetWidth()
  scrollFrame.height = scrollFrame:GetHeight()
  addonFrame.scrollFrame = scrollFrame
  return scrollFrame
end

---A text filter at the top of the list. Once 2+ characters are typed, the list shows
---only items whose name or type contains the text; clearing it shows everything.
function mainFrameModule:CreateFilterBox(addonFrame, listInset)
  local box = --[[---@type WowInputBox]] CreateFrame("EditBox", nil, addonFrame, "InputBoxTemplate")
  box:SetPoint("TOPLEFT", listInset, "TOPLEFT", 16, -6)
  box:SetPoint("TOPRIGHT", listInset, "TOPRIGHT", -12, -6)
  box:SetHeight(18)
  box:SetAutoFocus(false)

  -- Greyed-out placeholder, shown only while the box is empty
  local placeholder = box:CreateFontString(nil, "OVERLAY")
  placeholder:SetFontObject("GameFontDisableSmall")
  placeholder:SetPoint("LEFT", box, "LEFT", 4, 0)
  placeholder:SetText(L["RESTOCKER_FILTER_PLACEHOLDER"])

  box:SetScript("OnTextChanged", function(self)
    local text = self:GetText() or ""
    placeholder:SetShown(text == "")
    RS.listFilter = text
    RS:Update()
  end)
  box:SetScript("OnEscapePressed", function(self)
    self:SetText("")
    self:ClearFocus()
  end)

  addonFrame.filterBox = box
  return box
end

function mainFrameModule:CreateScrollChild(scrollFrame, addonFrame)
  local scrollChild = --[[---@type RsControl]] CreateFrame("Frame", nil, scrollFrame)
  scrollChild.width = scrollFrame:GetWidth()
  scrollChild.height = scrollFrame:GetHeight()
  scrollChild:SetWidth(scrollChild.width)
  scrollChild:SetHeight(scrollChild.height - 10)
  addonFrame.scrollChild = scrollChild

  scrollFrame:SetScrollChild(scrollChild)
  return scrollChild
end

function mainFrameModule:CreateTitle(addonFrame)
  local title = --[[---@type WowFontString]] addonFrame:CreateFontString(nil, "OVERLAY");
  title:SetFontObject("GameFontHighlightLarge");
  title:SetPoint("CENTER", addonFrame.TitleBg, "CENTER", 0, 0);
  title:SetText(L["RESTOCKER_WINDOW_TITLE"]);
  addonFrame.title = title
  return title
end

function mainFrameModule:CreateAddGroup(addonFrame, listInset)
  local addGrp = --[[---@type RsControl]] CreateFrame("Frame", nil, addonFrame);
  addGrp:SetPoint("BOTTOMLEFT", listInset, "BOTTOMLEFT", 3, 2);
  addGrp:SetPoint("BOTTOMRIGHT", listInset, "BOTTOMRIGHT", -2, 2);
  addGrp:SetHeight(25);
  addonFrame.addGrp = addGrp
  return addGrp
end

function mainFrameModule:CreateAddButton(addGrp)
  local addBtn = --[[---@type RsControl]] CreateFrame("Button", nil, addGrp, "GameMenuButtonTemplate");
  addBtn:SetPoint("BOTTOMRIGHT", addGrp, "BOTTOMRIGHT");
  addBtn:SetSize(60, 25);
  addBtn:SetText(L["RESTOCKER_ADD_BUTTON"]);
  addBtn:SetNormalFontObject("GameFontNormal");
  addBtn:SetHighlightFontObject("GameFontHighlight");
  addBtn:SetScript("OnClick", function(self, button, down)
    local editBox = self:GetParent():GetParent().editBox
    local text = editBox:GetText()

    RS:addItem(text);

    editBox:SetText("")
    editBox:ClearFocus()
  end);
  -- The same tooltip the edit box shows: the button and the box are two
  -- halves of one control, and either is a fair place to hover.
  RS.SetupTooltip(addBtn, L["RESTOCKER_ADD_TOOLTIP_TITLE"], L["RESTOCKER_ADD_TOOLTIP_BODY"])
  return addBtn
end

function mainFrameModule:CreateEditbox(addonFrame, addBtn)
  local editBox = CreateFrame("EditBox", nil, addonFrame.addGrp, "InputBoxTemplate");
  -- Both ends anchored so the box absorbs every pixel the window gains.
  editBox:SetPoint("LEFT", addonFrame.addGrp, "LEFT", 6, 0);
  editBox:SetPoint("RIGHT", addBtn, "LEFT", 3);
  editBox:SetAutoFocus(false);
  editBox:SetHeight(25);
  editBox:SetScript("OnEnterPressed", function(self)
    local text = self:GetText()
    RS:addItem(text)
    self:SetText("")
    self:ClearFocus()
  end)
  editBox:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
      local infoType, _, info2 = GetCursorInfo()
      if infoType == "item" then
        RS:addItem(info2)
        ClearCursor()
      end
    end
  end)
  editBox:SetScript("OnReceiveDrag", function(self)
    local infoType, _, info2 = GetCursorInfo()
    if infoType == "item" then
      RS:addItem(info2)
      ClearCursor()
    end
  end)

  -- Greyed-out placeholder, shown only while the box is empty -- the same
  -- arrangement as the filter box at the top of the window.
  local placeholder = editBox:CreateFontString(nil, "OVERLAY")
  placeholder:SetFontObject("GameFontDisableSmall")
  placeholder:SetPoint("LEFT", editBox, "LEFT", 4, 0)
  placeholder:SetText(L["RESTOCKER_ADD_PLACEHOLDER"])
  editBox:SetScript("OnTextChanged", function(self)
    placeholder:SetShown((self:GetText() or "") == "")
  end)

  RS.SetupTooltip(editBox, L["RESTOCKER_ADD_TOOLTIP_TITLE"], L["RESTOCKER_ADD_TOOLTIP_BODY"])

  addonFrame.editBox = editBox
  addonFrame.addBtn = addBtn
  return editBox
end

--[[
  FOOTER ROW

  Profile: [dropdown] [Copy] [Delete]        Rename: [box.....................]

  Every width here used to be a literal, and a profile named after a character
  ("Gogopaladin-Mankrik") overran all of them. Now the dropdown is sized to hold
  a full Name-Realm, Copy and Delete size themselves to their captions through
  the same RS.FitButton the list rows use, and the Rename box takes whatever
  width is left -- so it, not the truncation, absorbs a wider window.

  PROFILE_DROPDOWN_WIDTH is the dropdown's *text* width. Its visible box is
  wider than that by the arrow and border, and the template frame is wider
  again by invisible padding on the left, which is what the two offsets below
  account for: DROPDOWN_LEFT_PAD from frame edge to visible box, and
  DROPDOWN_TRIM for the arrow and right border.
]]
local PROFILE_LABEL_X = 10
local PROFILE_DROPDOWN_WIDTH = 190
local DROPDOWN_LEFT_PAD = 16
local DROPDOWN_TRIM = 25
local FOOTER_GAP = 4
local FOOTER_Y = 12

function mainFrameModule:CreateProfilesDropdown(addonFrame)
  local settings = restockerModule.settings
  local profileText = addonFrame:CreateFontString(nil, "OVERLAY")
  profileText:SetPoint("BOTTOMLEFT", addonFrame, "BOTTOMLEFT", PROFILE_LABEL_X, FOOTER_Y)
  profileText:SetFontObject("GameFontNormal")
  profileText:SetText(L["RESTOCKER_PROFILE_LABEL"])
  addonFrame.profileLabel = profileText

  local ConnoisseurRestockerProfileMenu = CreateFrame("Frame", "ConnoisseurRestockerProfileMenu", addonFrame,
    "UIDropDownMenuTemplate")
  -- Anchored to the label's RIGHT with a negative offset: the dropdown
  -- template carries ~20px of invisible left padding, so -14 lands the
  -- visible box a few pixels after the text (same tightness as Rename).
  ConnoisseurRestockerProfileMenu:SetPoint("LEFT", profileText, "RIGHT", -14, 0)
  UIDropDownMenu_SetWidth(ConnoisseurRestockerProfileMenu, PROFILE_DROPDOWN_WIDTH, 500)
  UIDropDownMenu_SetButtonWidth(ConnoisseurRestockerProfileMenu, PROFILE_DROPDOWN_WIDTH)
  UIDropDownMenu_SetText(ConnoisseurRestockerProfileMenu, settings.currentProfile)

  ConnoisseurRestockerProfileMenu.initialize = function(self, level)
    if not level then
      return
    end

    -- Sorted for a stable menu; pairs() order is arbitrary.
    local names = {}
    for profileName in pairs(settings.profiles) do
      names[#names + 1] = profileName
    end
    table.sort(names)

    for _, profileName in ipairs(names) do
      local info = UIDropDownMenu_CreateInfo()

      info.text = profileName
      info.arg1 = profileName
      info.func = RS.DropDownMenuSelectProfile
      info.checked = profileName == settings.currentProfile

      UIDropDownMenu_AddButton(info, 1)
    end

    UIDropDownMenu_AddSeparator(1)

    local newInfo = UIDropDownMenu_CreateInfo()
    newInfo.text = L["RESTOCKER_NEW_PROFILE"]
    newInfo.notCheckable = true
    newInfo.func = function()
      RS:CreateNewProfile()
    end
    UIDropDownMenu_AddButton(newInfo, 1)
  end

  addonFrame.profileDropDownMenu = ConnoisseurRestockerProfileMenu
end

---Rename field for the active profile: always shows the current profile's name;
---type a new one and press Enter to rename it (Escape restores). Renames follow
---through to every character pointing at the profile (see RenameCurrentProfile).
--[[
  The rename box is the footer's flexible cell: its label follows Delete and
  the box runs from there to the window edge (clear of the resize grip), so
  every pixel a wider window gains goes to the field showing the longest text.
]]
function mainFrameModule:CreateProfileRenameBox(addonFrame)
  local label = addonFrame:CreateFontString(nil, "OVERLAY")
  label:SetFontObject("GameFontNormal")
  label:SetText(L["RESTOCKER_RENAME_LABEL"])
  label:SetPoint("LEFT", addonFrame.deleteProfileButton, "RIGHT", 16, 0)

  local box = CreateFrame("EditBox", nil, addonFrame, "InputBoxTemplate")
  box:SetHeight(20)
  box:SetPoint("LEFT", label, "RIGHT", 12, 0)
  box:SetPoint("RIGHT", addonFrame, "RIGHT", -26, 0)
  box:SetAutoFocus(false)
  box:SetText(restockerModule.settings.currentProfile or "")

  box:SetScript("OnEnterPressed", function(self)
    RS:RenameCurrentProfile(self:GetText())
  end)
  box:SetScript("OnEscapePressed", function(self)
    self:SetText(restockerModule.settings.currentProfile or "")
    self:ClearFocus()
  end)

  addonFrame.profileRenameBox = box
  return box
end

--[[
  PROFILE FOOTER BUTTONS (Copy / Delete)
]]

--[[
  Confirmation for the footer Delete button. text_arg1 is the profile name,
  gold-wrapped at show time; StaticPopup_Show's fourth argument carries that same
  name through as the dialog's data, and OnAccept deletes THAT name rather than
  re-reading currentProfile.

  Load-bearing: the dialog does not lock the window behind it, so a profile
  switched in the dropdown while the confirm is open would otherwise redirect the
  delete onto a list the player was never asked about -- and a Restock List has no
  undo. Deleting falls back to another profile (or the character's own empty list)
  via RS:DeleteProfile, which also ignores a nil or already-deleted name.
]]
StaticPopupDialogs["CONNOISSEUR_RESTOCKER_DELETE_PROFILE"] = {
  text = L["RESTOCKER_DELETE_PROFILE_CONFIRM"],
  button1 = YES,
  button2 = NO,
  OnAccept = function(_self, data)
    RS:DeleteProfile(data)
    RS:Update()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

local rsFooterButtonTooltip = RS.SetupTooltip

function mainFrameModule:CreateProfileButtons(addonFrame)
  local copyBtn = CreateFrame("Button", nil, addonFrame, "UIPanelButtonTemplate")
  copyBtn:SetHeight(22)
  --[[
    Anchored to the window, not the dropdown: UIDropDownMenu_SetWidth gives the
    dropdown's invisible frame width + padding, so anchoring to its RIGHT edge
    lands well outside the window. The x offset walks the visible row instead:
    the label, then the dropdown's visible box.
  ]]
  local dropdownLeft = PROFILE_LABEL_X + addonFrame.profileLabel:GetStringWidth() - 14
  copyBtn:SetPoint("BOTTOMLEFT", addonFrame, "BOTTOMLEFT",
    dropdownLeft + DROPDOWN_LEFT_PAD + PROFILE_DROPDOWN_WIDTH + DROPDOWN_TRIM + FOOTER_GAP, FOOTER_Y)
  copyBtn:SetText(L["RESTOCKER_COPY_PROFILE"])
  RS.FitButton(copyBtn)
  copyBtn:SetScript("OnClick", function()
    RS:CloneCurrentProfile()
  end)
  rsFooterButtonTooltip(copyBtn, L["RESTOCKER_COPY_PROFILE_TOOLTIP"])

  local deleteBtn = CreateFrame("Button", nil, addonFrame, "UIPanelButtonTemplate")
  deleteBtn:SetHeight(22)
  deleteBtn:SetPoint("LEFT", copyBtn, "RIGHT", FOOTER_GAP, 0)
  deleteBtn:SetText(L["RESTOCKER_DELETE_PROFILE"])
  RS.FitButton(deleteBtn)
  deleteBtn:SetScript("OnClick", function()
    local settings = restockerModule.settings
    if not settings.currentProfile then
      return
    end
    StaticPopup_Show(
      "CONNOISSEUR_RESTOCKER_DELETE_PROFILE",
      ns.GetColor("TITLE") .. settings.currentProfile .. "|r",
      nil,
      settings.currentProfile
    )
  end)
  rsFooterButtonTooltip(deleteBtn, L["RESTOCKER_DELETE_PROFILE_TOOLTIP"])

  addonFrame.copyProfileButton = copyBtn
  addonFrame.deleteProfileButton = deleteBtn
end

function mainFrameModule:CreateMenu()
  -- Row and button heights come from the font, so measure before anything is built.
  RS.RefreshRowMetrics()

  local addonFrame = self:CreateAddonFrame()
  local listInset = self:CreateListInset(addonFrame)
  local scrollFrame = self:CreateScrollFrame(addonFrame, listInset)
  local _ = self:CreateScrollChild(scrollFrame, addonFrame)
  local _ = self:CreateTitle(addonFrame)
  local addGrp = self:CreateAddGroup(addonFrame, listInset)
  local addBtn = self:CreateAddButton(addGrp)
  local _ = self:CreateEditbox(addonFrame, addBtn)

  self:CreateFilterBox(addonFrame, listInset)
  -- Settings live in Connoisseur's options panel (minimap tooltip / /foodie);
  -- the frame deliberately has no Settings button.
  self:CreateProfilesDropdown(addonFrame)
  self:CreateProfileButtons(addonFrame)
  self:CreateProfileRenameBox(addonFrame)
  self:CreateResizeGrip(addonFrame)

  table.insert(UISpecialFrames, "ConnoisseurRestockerFrame")
  addonFrame:Hide()

  RS.MainFrame = addonFrame
  -- Now that scrollChild exists, settle the sizes the anchors could not carry.
  self:RelayoutFrame(addonFrame)
  return RS.MainFrame
end

-- Handle shiftclicks of items. Guarded: the frame is only built at PLAYER_LOGIN,
-- so an early (or failed-build) shift-click must fall through to the original.
local origChatEdit_InsertLink = ChatEdit_InsertLink;
ChatEdit_InsertLink = function(link)
  local editBox = RS.MainFrame and RS.MainFrame.editBox
  if editBox and editBox:IsVisible() and editBox:HasFocus() then
    RS:addItem(link)
    return true
  end
  return origChatEdit_InsertLink(link);
end

function RS.DropDownMenuSelectProfile(self, arg1, arg2, checked)
  RS:ChangeProfile(arg1)
end

---@param text string|number
function RS:addItem(text)
  local settings = restockerModule.settings
  local currentProfile = settings.profiles[settings.currentProfile]

  if tonumber(text) then
    text = --[[---@not nil]] tonumber(text)
  end

  local itemInfo = RS.GetItemInfo(text)
  if itemInfo == nil then
    --[[
      Park the pending add under its itemID whenever the input carries one: the
      retry in eventsModule.OnItemInfoReceived looks up by the numeric itemID the
      event hands it, so an add keyed by a raw item link (what a shift-click from
      chat drops in) would never be found again and the item would silently never
      arrive. Unparseable input keeps its own key, which simply never retries.
    ]]
    local waitKey = text
    if type(text) == "string" then
      waitKey = tonumber(text:match("item:(%d+)")) or text
    end
    RS.addItemWait[waitKey] = true
    return
  end

  local itemID = ( --[[---@not nil]] itemInfo).itemId

  -- Profiles are keyed by itemID, so a duplicate is a simple lookup
  if currentProfile[itemID] ~= nil then
    return
  end

  local buyItem = --[[---@type RsTradeCommand]] {}

  buyItem.itemName = ( --[[---@not nil]] itemInfo).itemName
  buyItem.itemType = ( --[[---@not nil]] itemInfo).itemType
  buyItem.itemID = itemID
  --[[
    One stack of the item, not one unit: a fresh row asking for a single
    juice reads as a typo, and a stack is the amount everything actually
    trades in. Items that do not stack report a max of 1, so gear and tools
    land at exactly one with no special case.
  ]]
  buyItem.amount = math.max(1, ( --[[---@not nil]] itemInfo).itemStackCount or 1)
  -- New items default to everything ON: buy from merchant, stash to bank, restock from bank
  buyItem.buyFromMerchant = true
  buyItem.stashTobank = true
  buyItem.restockFromBank = true

  currentProfile[itemID] = buyItem

  --[[
    Flag it for the "New" group and jump the list back to the top, so the row
    you just created is on screen with its controls ready rather than filed
    away in its type group somewhere down a long list. Opening it too is the
    point of adding one: the amount and the three toggles are what you came to
    set, and they live on the detail line.
  ]]
  RS.newItems[itemID] = true
  RS.expandedItem = itemID

  RS:Update()

  local scrollFrame = RS.MainFrame and RS.MainFrame.scrollFrame
  if scrollFrame then
    scrollFrame:SetVerticalScroll(0)
  end
end