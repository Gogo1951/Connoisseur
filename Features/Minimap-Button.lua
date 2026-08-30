local _, ns = ...
local GetColor = ns.GetColor
local L = ns.L

local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

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
-- LDB Icon Update
--------------------------------------------------------------------------------

local UpdateTooltip

function ns.UpdateLDB()
	if not ns.LDBObject then
		return
	end

	local iconID = ns.BestFoodID or ns.MacroConfig["Food"].defaultID
	local newIcon = ns.GetItemIcon(iconID) or "Interface\\Icons\\INV_Misc_Food_02"
	ns.LDBObject.icon = newIcon

	if LDBIcon then
		local button = LDBIcon:GetMinimapButton(ns.LOCALE_NAME)
		if button then
			if button.icon then
				button.icon:SetTexture(newIcon)
			end
			if GameTooltip:GetOwner() == button then
				UpdateTooltip(button)
			end
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
	ns.db.global.minimap = ns.db.global.minimap or {}
	local show
	if value == nil then
		show = ns.db.global.minimap.hide
	else
		show = value
	end
	ns.db.global.minimap.hide = not show

	if not LDBIcon then
		return
	end
	if show then
		LDBIcon:Show(ns.LOCALE_NAME)
	else
		LDBIcon:Hide(ns.LOCALE_NAME)
	end
end

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

local KnowsAny = ns.KnowsAny

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
    UI_NONE instead, leaving the full explanation to the line below it.
]]
local function ItemValue(itemID, itemLink)
	if itemID and itemLink then
		return format("|T%s:14:14|t %s", ns.GetItemIcon(itemID), itemLink)
	end
	return GetColor("BODY") .. L["UI_NONE"] .. "|r"
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
		tooltip:AddLine(GetColor("BODY") .. format(L["MSG_NO_ITEM"], missingLabel) .. "|r", 1, 1, 1, true)
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
	local buffState = settings.useBuffFood and (GetColor("ON") .. L["UI_ENABLED"] .. "|r")
		or (GetColor("OFF") .. L["UI_DISABLED"] .. "|r")
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["FEATURE_BUFF_FOOD"] .. "|r", buffState)
	tooltip:AddLine(GetColor("BODY") .. L["MENU_BUFF_FOOD_DESCRIPTION"] .. "|r", 1, 1, 1, true)
	tooltip:AddDoubleLine(GetColor("INFO") .. L["UI_LEFT_CLICK"] .. "|r", GetColor("INFO") .. L["UI_TOGGLE"] .. "|r")
	tooltip:AddLine(" ")

	-- Include Scroll Buffs
	local scrollState = settings.useScrolls and (GetColor("ON") .. L["UI_ENABLED"] .. "|r")
		or (GetColor("OFF") .. L["UI_DISABLED"] .. "|r")
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["FEATURE_SCROLL_BUFFS"] .. "|r", scrollState)
	tooltip:AddLine(GetColor("BODY") .. L["MENU_SCROLL_BUFFS_DESCRIPTION"] .. "|r", 1, 1, 1, true)
	tooltip:AddDoubleLine(GetColor("INFO") .. L["UI_SHIFT_LEFT"] .. "|r", GetColor("INFO") .. L["UI_TOGGLE"] .. "|r")

	--[[
	    Current Best Food. Shares AddItemSection's row shape, but keeps its own
	    block: the Ignore hint only belongs here when there is an item to ignore.
	]]
	tooltip:AddLine(" ")
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["UI_BEST_FOOD"] .. "|r", ItemValue(ns.BestFoodID, ns.BestFoodLink))
	if ns.BestFoodID and ns.BestFoodLink then
		tooltip:AddDoubleLine(
			GetColor("INFO") .. L["UI_RIGHT_CLICK"] .. "|r",
			GetColor("INFO") .. L["MENU_IGNORE"] .. "|r"
		)
	else
		tooltip:AddLine(GetColor("BODY") .. format(L["MSG_NO_ITEM"], L["LABEL_FOOD"]) .. "|r", 1, 1, 1, true)
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
		tooltip:AddLine(GetColor("TITLE") .. L["UI_IGNORE_LIST"] .. "|r")

		local sortedIgnoreList = {}
		for itemID in pairs(ignoreList) do
			local name, _, quality, _, _, _, _, _, _, texture = GetItemInfo(itemID)
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
				local _, _, _, colorHex = GetItemQualityColor(item.quality)
				tooltip:AddLine(format("|T%s:14:14|t |c%s[%s]|r", item.texture, colorHex, item.name))
			else
				tooltip:AddLine(GetColor("MUTED") .. format(L["LOADING_ITEM"], item.id) .. "|r")
			end
		end

		tooltip:AddDoubleLine(
			GetColor("INFO") .. L["UI_MIDDLE_CLICK"] .. "|r",
			GetColor("INFO") .. L["MENU_CLEAR_IGNORE"] .. "|r"
		)
	end

	-- Class-specific conjure tips
	local _, playerClass = UnitClass("player")
	local descriptionColor = GetColor("BODY")

	if playerClass == "MAGE" and ns.ConjureSpells then
		local classColor = GetClassColorEscape("MAGE")
		local knowsTable = KnowsAny(ns.ConjureSpells.MageCreateTable)
		local knowsFood = KnowsAny(ns.ConjureSpells.MageCreateFood)
		local knowsWater = KnowsAny(ns.ConjureSpells.MageCreateWater)
		local knowsManaGem = KnowsAny(ns.ConjureSpells.MageCreateManaGem)

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
	elseif playerClass == "WARLOCK" and ns.ConjureSpells then
		local classColor = GetClassColorEscape("WARLOCK")
		local knowsSoulwell = KnowsAny(ns.ConjureSpells.WarlockCreateSoulwell)
		local knowsHealthstone = KnowsAny(ns.ConjureSpells.WarlockCreateHealthstone)
		local knowsSoulstone = KnowsAny(ns.ConjureSpells.WarlockCreateSoulstone)

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
			AddItemSection(tooltip, L["UI_MAIN_HAND"], mainID, mainLink, L["LABEL_POISONS"])
			AddItemSection(tooltip, L["UI_OFF_HAND"], offID, offLink, L["LABEL_POISONS"])
		end
	elseif playerClass == "HUNTER" and ns.FeedPetSpellName then
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

		AddItemSection(tooltip, L["UI_BEST_PET_FOOD"], ns.BestPetFoodID, ns.BestPetFoodLink, L["LABEL_PET_FOOD"])
	end

	--[[
	    Restocker Report -- a count, not a list. Spelling out every shortfall
	    made the tooltip taller than the screen on a real restock list, and the
	    only question this section answers is "do I need to shop?". The
	    Restocker window itself (/crs) is where the items live.

	    Read straight off ns.BuildGroceryList so the tooltip and the
	    entering-town reminder can never disagree, and rendered even when
	    empty: "fully stocked" is an answer, a missing section is not.
	]]
	if ns.BuildGroceryList then
		local shortCount = #ns.BuildGroceryList()
		tooltip:AddLine(" ")
		if shortCount == 0 then
			tooltip:AddDoubleLine(
				GetColor("TITLE") .. L["UI_RESTOCKER_REPORT"] .. "|r",
				GetColor("ON") .. L["UI_RESTOCKER_STOCKED_SHORT"] .. "|r"
			)
			tooltip:AddLine(GetColor("ON") .. L["UI_RESTOCKER_STOCKED"] .. "|r", 1, 1, 1, true)
		else
			local countText = (shortCount == 1) and L["UI_RESTOCKER_NEEDED_ONE"]
				or format(L["UI_RESTOCKER_NEEDED"], shortCount)
			tooltip:AddDoubleLine(
				GetColor("TITLE") .. L["UI_RESTOCKER_REPORT"] .. "|r",
				GetColor("BODY") .. countText .. "|r"
			)
		end
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

if LDB then
	ns.LDBObject = LDB:NewDataObject(ns.LOCALE_NAME, {
		type = "data source",
		text = L["ADDON_TITLE"],
		icon = "Interface\\Icons\\INV_Misc_Food_02",
		OnClick = function(_, button)
			-- Shift + Middle-Click always opens the options panel; checked first (matches every Gogo1951 add-on).
			if button == "MiddleButton" and IsShiftKeyDown() then
				if ns.OpenOptionsPanel then
					ns.OpenOptionsPanel()
				end
				return
			end
			if button == "RightButton" and ns.BestFoodID then
				--[[
				    BestFoodID is never already ignored (the scanner filters both
				    lists), so the toggle only ever adds here.
				]]
				if ns.ToggleIgnore then
					ns.ToggleIgnore(ns.BestFoodID)
				end
			elseif button == "LeftButton" and IsShiftKeyDown() then
				if ns.ToggleScrollBuffs then
					ns.ToggleScrollBuffs()
				end
			elseif button == "LeftButton" then
				if ns.ToggleBuffFood then
					ns.ToggleBuffFood()
				end
			elseif button == "MiddleButton" then
				if ns.ClearIgnoreList then
					ns.ClearIgnoreList()
				end
			end

			ns.UpdateLDB()
		end,
		OnEnter = function(self)
			UpdateTooltip(self)
		end,
		OnLeave = function()
			GameTooltip:Hide()
		end,
	})
end
