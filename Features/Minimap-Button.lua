local _, ns = ...
local GetColor = ns.GetColor
local L = ns.L

local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

--------------------------------------------------------------------------------
-- Class Color
--------------------------------------------------------------------------------

--[[
    The class's display color as a ready-to-use "|cffRRGGBB" prefix. Prefers
    ns.CLASS_COLORS (Data/Data.lua) so the tooltip matches the add-on's own
    palette, falls back to Blizzard's RAID_CLASS_COLORS (whose colorStr is an
    8-char "ffRRGGBB" string), then to white if neither is available.
]]
local function GetClassColorEscape(classToken)
	local localHex = ns.CLASS_COLORS and ns.CLASS_COLORS[classToken]
	if localHex then
		return "|cff" .. localHex
	end
	local color = RAID_CLASS_COLORS and RAID_CLASS_COLORS[classToken]
	if color and color.colorStr then
		return "|c" .. color.colorStr
	end
	return "|cffFFFFFF"
end

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

-- Called once at login, after ns.db exists, so LibDBIcon gets the saved button position.
function ns.RegisterMinimapIcon()
	if ns.dataBrokerObject and not ns.minimapIconRegistered then
		LibDBIcon:Register(ns.LOCALE_NAME, ns.dataBrokerObject, ns.db.global.minimap)
		ns.minimapIconRegistered = true
	end
end

--------------------------------------------------------------------------------
-- Minimap Icon Update
--------------------------------------------------------------------------------

local UpdateTooltip

function ns.UpdateMinimapIcon()
	if not ns.dataBrokerObject then
		return
	end

	local iconID = ns.bestFoodID or ns.MACRO_CONFIG["Food"].defaultID
	local newIcon = ns.GetItemIcon(iconID) or "Interface\\Icons\\INV_Misc_Food_02"
	ns.dataBrokerObject.icon = newIcon

	local button = LibDBIcon:GetMinimapButton(ns.LOCALE_NAME)
	if button then
		if button.icon then
			button.icon:SetTexture(newIcon)
		end
		if GameTooltip:GetOwner() == button then
			UpdateTooltip(button)
		end
	end
end

--------------------------------------------------------------------------------
-- Visibility Toggle
--------------------------------------------------------------------------------

--[[
    Show or hide the minimap button. Like the other feature toggles, no argument
    flips the current state and a boolean sets it directly (options-panel path).
    State lives in ns.db.global.minimap.hide — the same field LibDBIcon reads at
    registration — so the choice persists across reloads with no extra wiring.
]]
function ns.ToggleMinimapButton(value)
	local show
	if value == nil then
		show = ns.db.global.minimap.hide
	else
		show = value
	end
	ns.db.global.minimap.hide = not show
	LibDBIcon:Refresh(ns.LOCALE_NAME, ns.db.global.minimap)
end

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

local KnowsAny = ns.KnowsAny

-- The most restocking orders the Restocker Report lists one per row; a longer list shows only its count.
local RESTOCKER_REPORT_MAX_ROWS = 8

--[[
    The class tip blocks render one instruction per line, separated by blank
    lines. Collecting the lines first and spacing them here keeps the rhythm
    correct when a tip is gated out — an unknown spell leaves no doubled gap
    and no trailing blank.
]]
local function AddSpacedLines(tooltip, color, lines)
	for index, text in ipairs(lines) do
		if index > 1 then
			tooltip:AddLine(" ")
		end
		tooltip:AddLine(color .. text .. "|r", 1, 1, 1, true)
	end
end

--[[
    The right-hand value of an item row: icon and name as one string, so the
    pair can never split across the tooltip's two columns. An item link carries
    its own quality color, so the resolved case needs no color of its own.

    Nothing resolved -- or an item cache still cold -- renders the one-word
    MINIMAP_NONE instead, leaving the full explanation to the line below it.
]]
local function ItemValue(itemID, itemLink)
	if itemID and itemLink then
		return format("|T%s:14:14|t %s", ns.GetItemIcon(itemID), itemLink)
	end
	return GetColor("BODY") .. L["MINIMAP_NONE"] .. "|r"
end

--[[
    One "section title + resolved item" row, matching the Current Pet Food and
    Main Hand / Off Hand sections. Title on the left, item on the right -- the
    house pattern of a name and its current value sharing a row.

    The "no suitable item" sentence stays on its own wrapping line rather than
    moving into the right column, because that column never wraps: a sentence
    there would stretch the tooltip to the width of the whole sentence.
]]
local function AddItemSection(tooltip, title, itemID, itemLink, missingLabel)
	tooltip:AddLine(" ")
	tooltip:AddDoubleLine(GetColor("TITLE") .. title .. "|r", ItemValue(itemID, itemLink))
	if not (itemID and itemLink) then
		tooltip:AddLine(GetColor("BODY") .. format(L["MESSAGE_NO_ITEM"], missingLabel) .. "|r", 1, 1, 1, true)
	end
end

UpdateTooltip = function(anchor)
	if not (ns.db and ns.db.profile) then
		return
	end
	local settings = ns.db.profile
	local tooltip = GameTooltip

	tooltip:SetOwner(anchor, "ANCHOR_BOTTOMLEFT")
	tooltip:ClearLines()

	tooltip:AddDoubleLine(GetColor("TITLE") .. L["ADDON_TITLE"] .. "|r", GetColor("MUTED") .. ns.Version .. "|r")
	tooltip:AddLine(" ")
	tooltip:AddLine(" ")

	-- Prioritize Buff Food
	local buffState = settings.useBuffFood and (GetColor("ON") .. L["MINIMAP_ENABLED"] .. "|r")
		or (GetColor("OFF") .. L["MINIMAP_DISABLED"] .. "|r")
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["FEATURE_BUFF_FOOD"] .. "|r", buffState)
	tooltip:AddLine(GetColor("BODY") .. L["MENU_BUFF_FOOD_DESCRIPTION"] .. "|r", 1, 1, 1, true)
	tooltip:AddDoubleLine(
		GetColor("INFO") .. L["MINIMAP_LEFT_CLICK"] .. "|r",
		GetColor("INFO") .. L["MINIMAP_TOGGLE"] .. "|r"
	)
	tooltip:AddLine(" ")

	-- Include Scroll Buffs
	local scrollState = settings.useScrolls and (GetColor("ON") .. L["MINIMAP_ENABLED"] .. "|r")
		or (GetColor("OFF") .. L["MINIMAP_DISABLED"] .. "|r")
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["FEATURE_SCROLL_BUFFS"] .. "|r", scrollState)
	tooltip:AddLine(GetColor("BODY") .. L["MENU_SCROLL_BUFFS_DESCRIPTION"] .. "|r", 1, 1, 1, true)
	tooltip:AddDoubleLine(
		GetColor("INFO") .. L["MINIMAP_SHIFT_LEFT"] .. "|r",
		GetColor("INFO") .. L["MINIMAP_TOGGLE"] .. "|r"
	)

	--[[
	    Current Food. Unlike AddItemSection's shared title-and-item row, the
	    title stands alone and the item sits in the right column of the row
	    beneath it, so a long food name never adds its width to the title's.
	    With nothing resolved the sentence below answers on its own (a "None"
	    row above it would only say it twice), and the Ignore hint only
	    belongs here when there is an item to ignore.
	]]
	tooltip:AddLine(" ")
	tooltip:AddLine(GetColor("TITLE") .. L["MINIMAP_BEST_FOOD"] .. "|r")
	if ns.bestFoodID and ns.bestFoodLink then
		tooltip:AddDoubleLine(" ", ItemValue(ns.bestFoodID, ns.bestFoodLink))
		tooltip:AddDoubleLine(
			GetColor("INFO") .. L["MINIMAP_RIGHT_CLICK"] .. "|r",
			GetColor("INFO") .. L["MENU_IGNORE"] .. "|r"
		)
	else
		tooltip:AddLine(GetColor("BODY") .. format(L["MESSAGE_NO_ITEM"], L["LABEL_FOOD"]) .. "|r", 1, 1, 1, true)
	end

	--[[
	    Ignore List (the tooltip shows the character's own list, the one the
	    Right-Click and Middle-Click below act on; the Global list lives in the
	    Ignore List panel).
	]]
	local ignoreList = ns.GetIgnoreList() or {}
	local hasIgnoredItems = next(ignoreList) ~= nil
	if hasIgnoredItems then
		tooltip:AddLine(" ")
		tooltip:AddLine(GetColor("TITLE") .. L["MINIMAP_IGNORE_LIST"] .. "|r")

		local sortedIgnoreList = {}
		for itemID in pairs(ignoreList) do
			local name, _, quality, _, _, _, _, _, _, texture = C_Item.GetItemInfo(itemID)
			if name then
				tinsert(sortedIgnoreList, { id = itemID, name = name, quality = quality, texture = texture })
			else
				tinsert(sortedIgnoreList, { id = itemID, name = "ZZZ_Unknown", quality = 0, texture = nil })
			end
		end

		table.sort(sortedIgnoreList, function(a, b)
			return a.name < b.name
		end)

		for _, item in ipairs(sortedIgnoreList) do
			if item.texture then
				local _, _, _, colorHex = C_Item.GetItemQualityColor(item.quality)
				tooltip:AddLine(format("|T%s:14:14|t |c%s[%s]|r", item.texture, colorHex, item.name))
			else
				tooltip:AddLine(GetColor("MUTED") .. format(L["LOADING_ITEM"], item.id) .. "|r")
			end
		end

		tooltip:AddDoubleLine(
			GetColor("INFO") .. L["MINIMAP_MIDDLE_CLICK"] .. "|r",
			GetColor("INFO") .. L["MENU_CLEAR_IGNORE"] .. "|r"
		)
	end

	-- Class-specific conjure tips
	local _, playerClass = UnitClass("player")
	local descriptionColor = GetColor("BODY")

	if playerClass == "MAGE" and ns.CONJURE_SPELLS then
		local classColor = GetClassColorEscape("MAGE")
		local knowsTable = KnowsAny(ns.CONJURE_SPELLS.MageCreateTable)
		local knowsFood = KnowsAny(ns.CONJURE_SPELLS.MageCreateFood)
		local knowsWater = KnowsAny(ns.CONJURE_SPELLS.MageCreateWater)
		local knowsManaGem = KnowsAny(ns.CONJURE_SPELLS.MageCreateManaGem)

		if knowsFood or knowsWater or knowsTable or knowsManaGem then
			tooltip:AddLine(" ")
			tooltip:AddLine(classColor .. L["PREFIX_MAGE"] .. "|r")
			tooltip:AddLine(" ")

			local tips = { L["TIP_MAGE_MACROS"] }
			if knowsFood or knowsWater then
				tinsert(tips, L["TIP_MAGE_CONJURE"])
				tinsert(tips, L["TIP_MAGE_DOWNRANK"])
			end
			if knowsTable then
				tinsert(tips, L["TIP_MAGE_TABLE"])
			end
			if knowsManaGem then
				tinsert(tips, L["TIP_MAGE_GEM"])
			end
			AddSpacedLines(tooltip, descriptionColor, tips)
		end
	elseif playerClass == "WARLOCK" and ns.CONJURE_SPELLS then
		local classColor = GetClassColorEscape("WARLOCK")
		local knowsSoulwell = KnowsAny(ns.CONJURE_SPELLS.WarlockCreateSoulwell)
		local knowsHealthstone = KnowsAny(ns.CONJURE_SPELLS.WarlockCreateHealthstone)
		local knowsSoulstone = KnowsAny(ns.CONJURE_SPELLS.WarlockCreateSoulstone)

		if knowsHealthstone or knowsSoulstone or knowsSoulwell then
			tooltip:AddLine(" ")
			tooltip:AddLine(classColor .. L["PREFIX_WARLOCK"] .. "|r")
			tooltip:AddLine(" ")

			local tips = { L["TIP_WARLOCK_MACROS"] }
			if knowsHealthstone then
				tinsert(tips, L["TIP_WARLOCK_HEALTHSTONE"])
				tinsert(tips, L["TIP_WARLOCK_DOWNRANK"])
			end
			if knowsSoulstone then
				tinsert(tips, L["TIP_WARLOCK_SOULSTONE"])
			end
			if knowsSoulwell then
				tinsert(tips, L["TIP_WARLOCK_SOUL"])
			end
			AddSpacedLines(tooltip, descriptionColor, tips)
		end
	elseif playerClass == "ROGUE" and ns.POISONS_SPELL_ID then
		local knowsPoisons = IsSpellKnown(ns.POISONS_SPELL_ID)
		if not knowsPoisons and IsPlayerSpell then
			knowsPoisons = IsPlayerSpell(ns.POISONS_SPELL_ID)
		end
		if knowsPoisons then
			local classColor = GetClassColorEscape("ROGUE")
			tooltip:AddLine(" ")
			tooltip:AddLine(classColor .. L["PREFIX_ROGUE"] .. "|r")
			tooltip:AddLine(" ")
			AddSpacedLines(tooltip, descriptionColor, {
				L["TIP_ROGUE_MACROS"],
				L["TIP_ROGUE_OFF_HAND"],
				L["TIP_ROGUE_MAIN_HAND"],
				L["TIP_ROGUE_REPLACE"],
				L["TIP_ROGUE_WINDOW"],
			})

			local mainID, mainLink = ns.GetBestPoisonForHand("main")
			local offID, offLink = ns.GetBestPoisonForHand("off")
			AddItemSection(tooltip, L["MINIMAP_MAIN_HAND"], mainID, mainLink, L["LABEL_POISONS"])
			AddItemSection(tooltip, L["MINIMAP_OFF_HAND"], offID, offLink, L["LABEL_POISONS"])
		end
	elseif playerClass == "HUNTER" and ns.feedPetSpellName then
		local classColor = GetClassColorEscape("HUNTER")

		tooltip:AddLine(" ")
		tooltip:AddLine(classColor .. L["PREFIX_HUNTER"] .. "|r")
		tooltip:AddLine(" ")
		AddSpacedLines(tooltip, descriptionColor, {
			L["TIP_HUNTER_MACROS"],
			L["TIP_HUNTER_ALL_IN_ONE"],
			L["TIP_HUNTER_CALL"],
			L["TIP_HUNTER_MEND"],
			L["TIP_HUNTER_MODIFIERS"],
		})

		AddItemSection(tooltip, L["MINIMAP_BEST_PET_FOOD"], ns.bestPetFoodID, ns.bestPetFoodLink, L["LABEL_PET_FOOD"])
	end

	--[[
	    Restocker Report -- the orders themselves while they fit, only their
	    count past RESTOCKER_REPORT_MAX_ROWS. Spelling out every shortfall made
	    the tooltip taller than the screen on a real restock list, and at that
	    length the only question this section answers is "do I need to shop?".
	    The Restocker window itself (/crs) is where the items live.

	    A row is the item and have/wanted, the ratio the verbose reminder
	    prints. ns.GetItemHyperlink names the item even while the cache is
	    cold; a name-only row has no ID to look an icon up by, so it shows the
	    question mark the Restocker window uses.

	    Read straight off ns.BuildGroceryList so the tooltip and the
	    entering-town reminder can never disagree, and rendered even when
	    empty: "fully stocked" is an answer, a missing section is not. That
	    answer is the green congratulation on its own, in place of the header
	    row -- a "Fully Stocked" value above it would only say it twice.
	]]
	local groceries = ns.BuildGroceryList()
	tooltip:AddLine(" ")
	if #groceries == 0 then
		tooltip:AddLine(GetColor("ON") .. L["MINIMAP_RESTOCKER_STOCKED"] .. "|r", 1, 1, 1, true)
	elseif #groceries <= RESTOCKER_REPORT_MAX_ROWS then
		tooltip:AddLine(GetColor("TITLE") .. L["MINIMAP_RESTOCKER_REPORT"] .. "|r")
		for _, entry in ipairs(groceries) do
			local icon = entry.itemID and ns.GetItemIcon(entry.itemID) or "Interface\\ICONS\\INV_Misc_QuestionMark"
			tooltip:AddDoubleLine(
				format("|T%s:14:14|t %s", icon, ns.GetItemHyperlink(entry.itemID, entry.itemName)),
				GetColor("BODY") .. format(L["MINIMAP_RESTOCKER_ITEM_COUNT"], entry.have, entry.wanted) .. "|r"
			)
		end
	else
		tooltip:AddDoubleLine(
			GetColor("TITLE") .. L["MINIMAP_RESTOCKER_REPORT"] .. "|r",
			GetColor("BODY") .. format(L["MINIMAP_RESTOCKER_NEEDED"], #groceries) .. "|r"
		)
	end

	-- Options block (always the last thing in the tooltip; no hint line below it)
	tooltip:AddLine(" ")
	tooltip:AddLine(GetColor("TITLE") .. L["MENU_OPTIONS"] .. "|r")
	tooltip:AddLine(GetColor("INFO") .. L["MENU_OPTIONS_KEYBIND"] .. "|r")

	tooltip:Show()
end

--------------------------------------------------------------------------------
-- LDB Data Object
--------------------------------------------------------------------------------

ns.dataBrokerObject = LibDataBroker:NewDataObject(ns.LOCALE_NAME, {
	type = "data source",
	text = L["ADDON_TITLE"],
	icon = "Interface\\Icons\\INV_Misc_Food_02",
	OnClick = function(_, button)
		-- Shift + Middle-Click always opens the options panel; checked first (matches every Gogo1951 add-on).
		if button == "MiddleButton" and IsShiftKeyDown() then
			ns.OpenOptionsPanel()
			return
		end
		if button == "RightButton" and ns.bestFoodID then
			--[[
				    bestFoodID is never already ignored (the scanner filters both
				    lists), so the toggle only ever adds here.
				]]
			ns.ToggleIgnore(ns.bestFoodID)
		elseif button == "LeftButton" and IsShiftKeyDown() then
			ns.ToggleScrollBuffs()
		elseif button == "LeftButton" then
			ns.ToggleBuffFood()
		elseif button == "MiddleButton" then
			ns.ClearIgnoreList()
		end

		ns.UpdateMinimapIcon()
	end,
	OnEnter = function(self)
		UpdateTooltip(self)
	end,
	OnLeave = function()
		GameTooltip:Hide()
	end,
})
