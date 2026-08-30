local _, ns = ...
local L = ns.L
local AceGUI = LibStub("AceGUI-3.0")

--------------------------------------------------------------------------------
-- Footer Row
--------------------------------------------------------------------------------

--[[
    Profile: [dropdown] [Copy] [Delete]        Rename: [box.....................]

    No width here is a literal: a list named after a character
    ("Gogopaladin-Mankrik") overruns any fixed one. The dropdown is sized to hold
    a full Name-Realm, Copy and Delete size themselves to their captions through
    the same ns.FitRestockButton the list rows use, and the Rename box takes whatever
    width is left -- so it, not the truncation, absorbs a wider window.

    The list selector is an InputBoxTemplate field like Rename beside it, not an
    AceGUI Dropdown. Every other control in this window is a Blizzard template, so
    the one AceGUI widget read as foreign -- and skins that restyle AceGUI globally
    (ElvUI ships one) restyle it and nothing around it, which made the mismatch
    worse and moved the geometry the neighbouring buttons were positioned against.

    It opens an AceGUI Dropdown-Pullout on click, the same way the reputation
    column in Restocker-Window-Rows.lua does: Blizzard's UIDropDownMenu drives
    shared global frames its own secure code uses and leaves taint behind, so the
    pullout stays. Only the closed control changed, and because it is a real frame
    with a real width, Copy anchors to its edge instead of to a sum of offsets
    guessing where AceGUI drew its box.
]]
local PROFILE_LABEL_X = 10
local FOOTER_ROW_HEIGHT = 22
local FOOTER_RIGHT_INSET = 26
local PROFILE_SELECTOR_WIDTH = 190
local SELECTOR_ARROW_SIZE = 18
local FOOTER_GAP = 4
local FOOTER_Y = 12

--[[
    One pullout, built on first use and reused, which is how AceGUI's own Dropdown
    treats its pullout. Creating and releasing one per open would leak here: an
    Execute item closes its own pullout from inside its OnClick, so a release
    driven off OnClose would free the very item whose handler is still running.
    Reuse sidesteps that entirely -- items are cleared at open, not at close.

    The pullout lives as long as the window, which is built once per session and
    only ever hidden.
]]
local listPullout
local listPulloutOpen = false

local function CloseListPullout()
	if listPullout and listPulloutOpen then
		listPulloutOpen = false
		listPullout:Close()
	end
end

ns.CloseRestockListPullout = CloseListPullout

--[[
    The menu: every saved list, then a rule, then New Profile.

    Rebuilt on every open rather than cached, so a rename or a delete needs
    nothing kept in sync -- the next open reads the lists as they now are.
]]
local function OpenListPullout(anchor)
	local settings = ns.restockSettings

	if not listPullout then
		listPullout = AceGUI:Create("Dropdown-Pullout")
		listPullout:SetCallback("OnClose", function()
			listPulloutOpen = false
		end)
	end
	listPullout:Clear()

	-- Sorted for a stable menu; pairs() order is arbitrary.
	local names = {}
	for name in pairs(settings.profiles) do
		names[#names + 1] = name
	end
	table.sort(names)

	for _, name in ipairs(names) do
		local entry = AceGUI:Create("Dropdown-Item-Toggle")
		entry:SetText(name)
		entry:SetValue(name == settings.currentProfile)
		entry:SetCallback("OnValueChanged", function()
			-- A toggle item does not close its own pullout, unlike an execute item.
			CloseListPullout()
			ns.SwitchRestockList(name)
		end)
		listPullout:AddItem(entry)
	end

	--[[
	    A rule between the lists and the action under them. Inert by construction:
	    AceGUI's ItemBase gives every item only OnEnter and OnLeave, and Separator
	    is the one item type that never adds an OnClick, so the line cannot be
	    picked and needs no handler of its own.
	]]
	listPullout:AddItem(AceGUI:Create("Dropdown-Item-Separator"))

	--[[
	    New Profile is an Execute, not a Toggle: it performs an action rather than
	    selecting a value, so it draws no tick beside it and closes the menu itself.
	]]
	local newList = AceGUI:Create("Dropdown-Item-Execute")
	newList:SetText(L["RESTOCKER_NEW_PROFILE"])
	newList:SetCallback("OnClick", function()
		ns.CreateRestockList()
	end)
	listPullout:AddItem(newList)

	listPulloutOpen = true
	listPullout:SetWidth(anchor:GetWidth())
	listPullout:Open("TOPLEFT", anchor, "BOTTOMLEFT", 0, 0)
end

--[[
    The closed control: an InputBoxTemplate field so it matches Rename beside it,
    showing the active list. Read-only -- keyboard is off and focus bounces
    straight back out, so it renders as a field but behaves as a button.
]]
--[[
    One row for the whole footer, so every control in it centres on the same line
    by construction. Before this each one inherited its vertical position from the
    neighbour to its left, all the way back to the Profile label -- so anything
    anchored to the WINDOW instead landed at the window's middle and disappeared
    behind the list.
]]
local function CreateFooterRow(addonFrame)
	local row = CreateFrame("Frame", nil, addonFrame)
	row:SetPoint("BOTTOMLEFT", addonFrame, "BOTTOMLEFT", PROFILE_LABEL_X, FOOTER_Y)
	row:SetPoint("BOTTOMRIGHT", addonFrame, "BOTTOMRIGHT", -FOOTER_RIGHT_INSET, FOOTER_Y)
	row:SetHeight(FOOTER_ROW_HEIGHT)
	addonFrame.footerRow = row
	return row
end

local function CreateProfilesDropdown(addonFrame)
	local footerRow = addonFrame.footerRow
	local profileText = addonFrame:CreateFontString(nil, "OVERLAY")
	profileText:SetPoint("LEFT", footerRow, "LEFT", 0, 0)
	profileText:SetFontObject("GameFontNormal")
	profileText:SetText(L["RESTOCKER_PROFILE_LABEL"])
	addonFrame.profileLabel = profileText

	local selector = CreateFrame("EditBox", nil, addonFrame, "InputBoxTemplate")
	selector:SetPoint("LEFT", profileText, "RIGHT", 12, 0)
	selector:SetWidth(PROFILE_SELECTOR_WIDTH)
	selector:SetHeight(20)
	selector:SetAutoFocus(false)
	selector:EnableKeyboard(false)
	selector:SetScript("OnEditFocusGained", function(self)
		self:ClearFocus()
	end)
	selector:SetScript("OnMouseDown", function(self)
		OpenListPullout(self)
	end)

	--[[
	    The same three textures Blizzard's own UIDropDownMenuTemplate puts on its
	    button, so the control opens with the chevron players already read as "this
	    is a menu" rather than a generic arrow painted into a text field. A real
	    Button rather than a texture, so it presses and highlights like one.
	]]
	local arrow = CreateFrame("Button", nil, selector)
	arrow:SetSize(SELECTOR_ARROW_SIZE, SELECTOR_ARROW_SIZE)
	arrow:SetPoint("RIGHT", selector, "RIGHT", -4, 0)
	arrow:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	arrow:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
	arrow:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	arrow:SetScript("OnClick", function()
		OpenListPullout(selector)
	end)

	addonFrame.profileSelector = selector
	ns.SetupRestockerTooltip(selector, L["RESTOCKER_PROFILE_LABEL"], L["RESTOCKER_PROFILE_TOOLTIP"])
	selector:SetText(ns.restockSettings.currentProfile or "")
	selector:SetCursorPosition(0)
end

-- Show the active list in the selector. Called whenever a list is added,
-- renamed, copied, deleted or switched.
function ns.RefreshRestockListDropdown()
	local selector = ns.restockWindow and ns.restockWindow.profileSelector
	if selector then
		selector:SetText(ns.restockSettings.currentProfile or "")
		selector:SetCursorPosition(0)
	end
end

--[[
    Rename is a field plus its own button, the same shape the add row uses at the
    top of the window: the field carries the value and the button carries the verb.

    The button is not redundant with Enter, the way Add's is: Enter was the ONLY
    way to commit a rename, with nothing on screen saying so. It is the visible
    commit.

    Clicking away discards the edit. This field is not like the add box at the
    top, which is input-only and whose resting state is empty: this one also
    DISPLAYS the active list's name, so text left sitting in it is indistinguishable
    from the name the list actually has. Escape discards too, and any list change
    repaints it through ns.UpdateRestockListWidgets.

    A Button click does not pull keyboard focus off an EditBox, so pressing Rename
    does not trip the discard -- OnClick reads what was typed.

    The word "Rename" moved from a label into the button, so the row reads as one
    control instead of a caption, a field, and a verb. The locale key is unchanged
    on purpose: it is the same word, and renaming the key would orphan it in ten
    locale files this pass is not allowed to touch.
]]
local function CreateProfileRenameBox(addonFrame)
	local renameButton = CreateFrame("Button", nil, addonFrame, "UIPanelButtonTemplate")
	renameButton:SetHeight(22)
	renameButton:SetPoint("RIGHT", addonFrame.footerRow, "RIGHT", 0, 0)
	renameButton:SetText(L["RESTOCKER_RENAME_LABEL"])
	ns.FitRestockButton(renameButton)

	local box = CreateFrame("EditBox", nil, addonFrame, "InputBoxTemplate")
	box:SetHeight(20)
	box:SetPoint("LEFT", addonFrame.deleteProfileButton, "RIGHT", 16, 0)
	box:SetPoint("RIGHT", renameButton, "LEFT", -FOOTER_GAP - 4, 0)
	box:SetAutoFocus(false)
	box:SetText(ns.restockSettings.currentProfile or "")

	local function CommitRename()
		ns.RenameCurrentRestockList(box:GetText())
		box:ClearFocus()
	end

	local function RevertRename()
		box:SetText(ns.restockSettings.currentProfile or "")
		box:SetCursorPosition(0)
	end

	renameButton:SetScript("OnClick", CommitRename)
	box:SetScript("OnEnterPressed", CommitRename)
	box:SetScript("OnEditFocusLost", RevertRename)
	box:SetScript("OnEscapePressed", function(self)
		RevertRename()
		self:ClearFocus()
	end)

	ns.SetupRestockerTooltip(renameButton, L["RESTOCKER_RENAME_LABEL"], L["RESTOCKER_RENAME_TOOLTIP"])

	addonFrame.profileRenameBox = box
	addonFrame.renameProfileButton = renameButton
	return box
end

-- PROFILE FOOTER BUTTONS (Copy / Delete)

--[[
    Confirmation for the footer Delete button. text_arg1 is the profile name,
    gold-wrapped at show time; StaticPopup_Show's fourth argument carries that same
    name through as the dialog's data, and OnAccept deletes THAT name rather than
    re-reading currentProfile.

    Load-bearing: the dialog does not lock the window behind it, so a profile
    switched in the dropdown while the confirm is open would otherwise redirect the
    delete onto a list the player was never asked about -- and a Restock List has no
    undo. Deleting falls back to another profile (or the character's own empty list)
    via ns.DeleteRestockList, which also ignores a nil or already-deleted name.
]]
-- luacheck: globals StaticPopupDialogs
StaticPopupDialogs["CONNOISSEUR_RESTOCKER_DELETE_PROFILE"] = {
	text = L["RESTOCKER_DELETE_PROFILE_CONFIRM"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(_self, data)
		ns.DeleteRestockList(data)
		ns.UpdateRestockList()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

local function CreateProfileButtons(addonFrame)
	local copyButton = CreateFrame("Button", nil, addonFrame, "UIPanelButtonTemplate")
	copyButton:SetHeight(22)
	-- Anchored to the selector, which is a real frame with a real width.
	copyButton:SetPoint("LEFT", addonFrame.profileSelector, "RIGHT", FOOTER_GAP + 4, 0)
	copyButton:SetText(L["RESTOCKER_COPY_PROFILE"])
	ns.FitRestockButton(copyButton)
	copyButton:SetScript("OnClick", function()
		ns.CloneCurrentRestockList()
	end)
	ns.SetupRestockerTooltip(copyButton, L["RESTOCKER_COPY_PROFILE_TOOLTIP"])

	local deleteButton = CreateFrame("Button", nil, addonFrame, "UIPanelButtonTemplate")
	deleteButton:SetHeight(22)
	deleteButton:SetPoint("LEFT", copyButton, "RIGHT", FOOTER_GAP, 0)
	deleteButton:SetText(L["RESTOCKER_DELETE_PROFILE"])
	ns.FitRestockButton(deleteButton)
	deleteButton:SetScript("OnClick", function()
		local settings = ns.restockSettings
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
	ns.SetupRestockerTooltip(deleteButton, L["RESTOCKER_DELETE_PROFILE_TOOLTIP"])

	addonFrame.copyProfileButton = copyButton
	addonFrame.deleteProfileButton = deleteButton
end

--------------------------------------------------------------------------------
-- Assembly
--------------------------------------------------------------------------------

--[[
    The whole footer in one call, so Restocker-Window.lua assembles the window
    from parts rather than from this row's three separate pieces. Order matters:
    the buttons anchor off the dropdown's measured label, and the rename box
    anchors off the Delete button.
]]
function ns.CreateRestockWindowFooter(addonFrame)
	CreateFooterRow(addonFrame)
	CreateProfilesDropdown(addonFrame)
	CreateProfileButtons(addonFrame)
	CreateProfileRenameBox(addonFrame)
end
