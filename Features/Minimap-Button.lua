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
local function GetClassColorStr(classToken)
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
	if not ns.LDBObj then
		return
	end

	local iconID = ns.BestFoodID or ns.Config["Food"].defaultID
	local newIcon = ns.GetItemIcon(iconID) or "Interface\\Icons\\INV_Misc_Food_02"
	ns.LDBObj.icon = newIcon

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
    One "section title + resolved item" block, matching the Current Pet Food
    and Main Hand / Off Hand sections. Falls back to the standard "no suitable
    item" line when nothing resolved, or while the item cache is still cold.
]]
local function AddItemSection(tooltip, title, itemID, itemLink, missingLabel)
	tooltip:AddLine(" ")
	tooltip:AddLine(GetColor("TITLE") .. title .. "|r")
	if itemID and itemLink then
		tooltip:AddLine(format("|T%s:14:14|t %s", ns.GetItemIcon(itemID), itemLink))
	else
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

	-- Current Best Food
	tooltip:AddLine(" ")
	tooltip:AddLine(GetColor("TITLE") .. L["UI_BEST_FOOD"] .. "|r")
	if ns.BestFoodID and ns.BestFoodLink then
		local foodIcon = ns.GetItemIcon(ns.BestFoodID)
		tooltip:AddLine(format("|T%s:14:14|t %s", foodIcon, ns.BestFoodLink))
		tooltip:AddDoubleLine(
			GetColor("INFO") .. L["UI_RIGHT_CLICK"] .. "|r",
			GetColor("INFO") .. L["MENU_IGNORE"] .. "|r"
		)
	else
		tooltip:AddLine(GetColor("BODY") .. format(L["MSG_NO_ITEM"], L["LABEL_FOOD"]) .. "|r", 1, 1, 1, true)
	end

	-- Ignore List
	local ignoreList = ns.db.profile.ignoreList or {}
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
				tooltip:AddLine(GetColor("MUTED") .. "ID: " .. item.id .. "|r")
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
		local classColor = GetClassColorStr("MAGE")
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
		local classColor = GetClassColorStr("WARLOCK")
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
			local classColor = GetClassColorStr("ROGUE")
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
		local classColor = GetClassColorStr("HUNTER")

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

        Read straight off RS.BuildGroceryList so the tooltip and the
        entering-town reminder can never disagree, and rendered even when
        empty: "fully stocked" is an answer, a missing section is not.
    ]]
	local restocker = CRS_ADDON
	if restocker and restocker.BuildGroceryList then
		local shortCount = #restocker.BuildGroceryList()
		tooltip:AddLine(" ")
		tooltip:AddLine(GetColor("TITLE") .. L["UI_RESTOCKER_REPORT"] .. "|r")
		if shortCount == 0 then
			tooltip:AddLine(GetColor("ON") .. L["UI_RESTOCKER_STOCKED"] .. "|r", 1, 1, 1, true)
		elseif shortCount == 1 then
			tooltip:AddLine(GetColor("BODY") .. L["UI_RESTOCKER_NEEDED_ONE"] .. "|r", 1, 1, 1, true)
		else
			tooltip:AddLine(GetColor("BODY") .. format(L["UI_RESTOCKER_NEEDED"], shortCount) .. "|r", 1, 1, 1, true)
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
	ns.LDBObj = LDB:NewDataObject(ns.LOCALE_NAME, {
		type = "data source",
		text = L["ADDON_TITLE"],
		icon = "Interface\\Icons\\INV_Misc_Food_02",
		OnClick = function(self, button)
			-- Shift + Middle-Click always opens the options panel; checked first (matches every Gogo1951 add-on).
			if button == "MiddleButton" and IsShiftKeyDown() then
				if ns.OpenOptionsPanel then
					ns:OpenOptionsPanel()
				end
				return
			end
			if button == "RightButton" and ns.BestFoodID then
				if ns.db and ns.db.profile then
					ns.db.profile.ignoreList = ns.db.profile.ignoreList or {}
					ns.db.profile.ignoreList[ns.BestFoodID] = true
				end
				if ns.UpdateMacros then
					ns.UpdateMacros(true)
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
				if ns.db and ns.db.profile then
					ns.db.profile.ignoreList = ns.db.profile.ignoreList or {}
					wipe(ns.db.profile.ignoreList)
				end
				if ns.UpdateMacros then
					ns.UpdateMacros(true)
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
