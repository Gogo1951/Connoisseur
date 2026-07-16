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

function mainFrameModule:CreateAddonFrame()
  local settings = restockerModule.settings
  local addonFrame = --[[---@type RsRestockerFrame]] CreateFrame("Frame", "ConnoisseurRestockerFrame", UIParent,
    "BasicFrameTemplate");
  addonFrame.width = 580
  addonFrame.height = 400
  addonFrame:SetSize(addonFrame.width, addonFrame.height);
  addonFrame:SetPoint(settings.framePos.point or "RIGHT",
    UIParent, settings.framePos.relativePoint or "RIGHT",
    settings.framePos.xOfs or -5,
    settings.framePos.yOfs or 0);
  addonFrame:SetFrameStrata("FULLSCREEN");
  addonFrame:SetMovable(true)
  addonFrame:EnableMouse(true)
  addonFrame:RegisterForDrag("LeftButton")
  addonFrame:SetScript("OnDragStart", addonFrame.StartMoving)
  addonFrame:SetScript("OnDragStop", addonFrame.StopMovingOrSizing)
  return addonFrame
end

function mainFrameModule:CreateListInset(addonFrame)
  local listInset = --[[---@type RsControl]] CreateFrame("Frame", nil, addonFrame, "InsetFrameTemplate3");
  listInset.width = addonFrame.width - 6
  listInset.height = addonFrame.height - 60
  listInset:SetSize(listInset.width, listInset.height);
  listInset:SetPoint("TOPLEFT", addonFrame, "TOPLEFT", 2, -22);
  addonFrame.listInset = listInset
  return listInset
end

function mainFrameModule:CreateScrollFrame(addonFrame, listInset)
  local scrollFrame = --[[---@type RsControl]] CreateFrame("ScrollFrame", nil, addonFrame, "UIPanelScrollFrameTemplate")
  scrollFrame.width = addonFrame.listInset.width - 4
  -- Leave 22px at the top for the sortable column-header bar
  scrollFrame.height = addonFrame.listInset.height - 32 - 22
  scrollFrame:SetSize(scrollFrame.width - 30, scrollFrame.height);
  scrollFrame:SetPoint("TOPLEFT", listInset, "TOPLEFT", 8, -28);
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
  addGrp:SetPoint("BOTTOM", addonFrame.listInset, "BOTTOM", 0, 2);
  addGrp:SetSize(listInset.width - 5, 25);
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
  return addBtn
end

function mainFrameModule:CreateEditbox(addonFrame, addBtn)
  local editBox = CreateFrame("EditBox", nil, addonFrame.addGrp, "InputBoxTemplate");
  editBox:SetPoint("RIGHT", addBtn, "LEFT", 3);
  editBox:SetAutoFocus(false);
  editBox:SetSize(addonFrame.addGrp:GetWidth() - addBtn:GetWidth() - 5, 25);
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
  editBox:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:SetText(RS.FormatTexture(RS.BAG_ICON) .. " " .. L["RESTOCKER_ADD_TOOLTIP_TITLE"])
    GameTooltip:AddLine(L["RESTOCKER_ADD_TOOLTIP_BODY"])
    GameTooltip:Show()
  end)
  editBox:SetScript("OnLeave", function(self, motion)
    GameTooltip:Hide()
  end)

  addonFrame.editBox = editBox
  addonFrame.addBtn = addBtn
  return editBox
end

function mainFrameModule:CreateProfilesDropdown(addonFrame)
  local settings = restockerModule.settings
  local profileText = addonFrame:CreateFontString(nil, "OVERLAY")
  profileText:SetPoint("BOTTOMLEFT", addonFrame, "BOTTOMLEFT", 10, 12)
  profileText:SetFontObject("GameFontNormal")
  profileText:SetText(L["RESTOCKER_PROFILE_LABEL"])

  local ConnoisseurRestockerProfileMenu = CreateFrame("Frame", "ConnoisseurRestockerProfileMenu", addonFrame,
    "UIDropDownMenuTemplate")
  -- Anchored to the label's RIGHT with a negative offset: the dropdown
  -- template carries ~20px of invisible left padding, so -14 lands the
  -- visible box a few pixels after the text (same tightness as Rename).
  ConnoisseurRestockerProfileMenu:SetPoint("LEFT", profileText, "RIGHT", -14, 0)
  UIDropDownMenu_SetWidth(ConnoisseurRestockerProfileMenu, 120, 500)
  UIDropDownMenu_SetButtonWidth(ConnoisseurRestockerProfileMenu, 140)
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
function mainFrameModule:CreateProfileRenameBox(addonFrame)
  local label = addonFrame:CreateFontString(nil, "OVERLAY")
  label:SetFontObject("GameFontNormal")
  label:SetText(L["RESTOCKER_RENAME_LABEL"])

  local box = CreateFrame("EditBox", nil, addonFrame, "InputBoxTemplate")
  box:SetSize(140, 20)
  box:SetPoint("BOTTOMRIGHT", addonFrame, "BOTTOMRIGHT", -12, 12)
  label:SetPoint("RIGHT", box, "LEFT", -12, 0)
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

-- Confirmation for the footer Delete button. text_arg1 is the profile name,
-- gold-wrapped at show time. Deleting falls back to another profile (or the
-- character's own empty list) via RS:DeleteProfile.
StaticPopupDialogs["CONNOISSEUR_RESTOCKER_DELETE_PROFILE"] = {
  text = L["RESTOCKER_DELETE_PROFILE_CONFIRM"],
  button1 = YES,
  button2 = NO,
  OnAccept = function()
    RS:DeleteProfile(restockerModule.settings.currentProfile)
    RS:Update()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

local function rsFooterButtonTooltip(btn, text)
  btn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:SetText(text)
    GameTooltip:Show()
  end)
  btn:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
end

function mainFrameModule:CreateProfileButtons(addonFrame)
  local copyBtn = CreateFrame("Button", nil, addonFrame, "UIPanelButtonTemplate")
  copyBtn:SetSize(52, 22)
  --[[
    Anchored to the window, not the dropdown: UIDropDownMenu_SetWidth gives the
    dropdown's invisible frame width + padding (620px here), so anchoring to
    its RIGHT edge lands outside the 580px window.
  ]]
  copyBtn:SetPoint("BOTTOMLEFT", addonFrame, "BOTTOMLEFT", 204, 12)
  copyBtn:SetText(L["RESTOCKER_COPY_PROFILE"])
  copyBtn:SetScript("OnClick", function()
    RS:CloneCurrentProfile()
  end)
  rsFooterButtonTooltip(copyBtn, L["RESTOCKER_COPY_PROFILE_TOOLTIP"])

  local deleteBtn = CreateFrame("Button", nil, addonFrame, "UIPanelButtonTemplate")
  deleteBtn:SetSize(52, 22)
  deleteBtn:SetPoint("LEFT", copyBtn, "RIGHT", 4, 0)
  deleteBtn:SetText(L["RESTOCKER_DELETE_PROFILE"])
  deleteBtn:SetScript("OnClick", function()
    local settings = restockerModule.settings
    if not settings.currentProfile then
      return
    end
    StaticPopup_Show(
      "CONNOISSEUR_RESTOCKER_DELETE_PROFILE",
      ns.GetColor("TITLE") .. settings.currentProfile .. "|r"
    )
  end)
  rsFooterButtonTooltip(deleteBtn, L["RESTOCKER_DELETE_PROFILE_TOOLTIP"])

  addonFrame.copyProfileButton = copyBtn
  addonFrame.deleteProfileButton = deleteBtn
end

function mainFrameModule:CreateMenu()
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

  table.insert(UISpecialFrames, "ConnoisseurRestockerFrame")
  addonFrame:Hide()

  RS.MainFrame = addonFrame
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
    RS.addItemWait[text] = true
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
  buyItem.amount = 1
  -- New items default to everything ON: buy from merchant, stash to bank, restock from bank
  buyItem.buyFromMerchant = true
  buyItem.stashTobank = true
  buyItem.restockFromBank = true

  currentProfile[itemID] = buyItem

  RS:Update()
end