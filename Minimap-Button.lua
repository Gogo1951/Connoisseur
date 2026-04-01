local addonName, ns = ...
local GetColor = ns.GetColor
local L = ns.L

local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)

--------------------------------------------------------------------------------
-- LDB Icon Update
--------------------------------------------------------------------------------

local UpdateTooltip

function ns.UpdateLDB()
    if not ns.LDBObj then return end

    local iconID = ns.BestFoodID or ns.Config["Food"].defaultID
    local newIcon = C_Item.GetItemIconByID(iconID) or "Interface\\Icons\\INV_Misc_Food_02"
    ns.LDBObj.icon = newIcon

    if LDBIcon then
        local button = LDBIcon:GetMinimapButton("Connoisseur")
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
-- Tooltip
--------------------------------------------------------------------------------

local KnowsAny = ns.KnowsAny

UpdateTooltip = function(anchor)
    if not ConnoisseurCharDB then return end
    local settings = ConnoisseurCharDB.settings or {}
    local tooltip = GameTooltip

    tooltip:SetOwner(anchor, "ANCHOR_BOTTOMLEFT")
    tooltip:ClearLines()

    tooltip:AddDoubleLine(GetColor("TITLE") .. L["BRAND"] .. "|r", GetColor("MUTED") .. ns.Version .. "|r")
    tooltip:AddLine(" ")

    -- Class-specific conjure tips
    local _, playerClass = UnitClass("player")
    local descriptionColor = GetColor("DESC")

    if playerClass == "MAGE" and ns.ConjureSpells then
        local mageColor = "|cff3FC7EB"
        local knowsTable   = KnowsAny(ns.ConjureSpells.MageCreateTable)
        local knowsFood    = KnowsAny(ns.ConjureSpells.MageCreateFood)
        local knowsWater   = KnowsAny(ns.ConjureSpells.MageCreateWater)
        local knowsManaGem = KnowsAny(ns.ConjureSpells.MageCreateManaGem)

        if knowsFood or knowsWater or knowsTable or knowsManaGem then
            tooltip:AddLine(" ")
            tooltip:AddLine(mageColor .. L["PREFIX_MAGE"] .. "|r")
            if knowsFood or knowsWater then
                tooltip:AddLine(descriptionColor .. L["TIP_MAGE_CONJURE"] .. "|r", 1, 1, 1, true)
            end
            if knowsManaGem then
                tooltip:AddLine(" ")
                tooltip:AddLine(descriptionColor .. L["TIP_MAGE_GEM"] .. "|r", 1, 1, 1, true)
            end
            if knowsTable then
                tooltip:AddLine(" ")
                tooltip:AddLine(descriptionColor .. L["TIP_MAGE_TABLE"] .. "|r", 1, 1, 1, true)
            end
            tooltip:AddLine(" ")
            tooltip:AddLine(descriptionColor .. L["TIP_DOWNRANK"] .. "|r", 1, 1, 1, true)
        end
    elseif playerClass == "WARLOCK" and ns.ConjureSpells then
        local warlockColor = "|cff8788EE"
        local knowsSoulwell    = KnowsAny(ns.ConjureSpells.WarlockCreateSoulwell)
        local knowsHealthstone = KnowsAny(ns.ConjureSpells.WarlockCreateHealthstone)
        local knowsSoulstone   = KnowsAny(ns.ConjureSpells.WarlockCreateSoulstone)

        if knowsHealthstone or knowsSoulstone or knowsSoulwell then
            tooltip:AddLine(" ")
            tooltip:AddLine(warlockColor .. L["PREFIX_WARLOCK"] .. "|r")
            if knowsHealthstone or knowsSoulstone then
                tooltip:AddLine(descriptionColor .. L["TIP_WARLOCK_CONJURE"] .. "|r", 1, 1, 1, true)
            end
            if knowsSoulwell then
                tooltip:AddLine(" ")
                tooltip:AddLine(descriptionColor .. L["TIP_WARLOCK_SOUL"] .. "|r", 1, 1, 1, true)
            end
            tooltip:AddLine(" ")
            tooltip:AddLine(descriptionColor .. L["TIP_DOWNRANK"] .. "|r", 1, 1, 1, true)
        end
    end

    -- Prioritize Buff Food
    tooltip:AddLine(" ")
    local buffState = settings.useBuffFood
        and (GetColor("SUCCESS") .. L["UI_ENABLED"] .. "|r")
        or  (GetColor("DISABLED") .. L["UI_DISABLED"] .. "|r")
    tooltip:AddDoubleLine(GetColor("TITLE") .. L["MENU_BUFF_FOOD"] .. "|r", buffState)
    tooltip:AddLine(GetColor("DESC") .. L["MENU_BUFF_FOOD_DESC"] .. "|r", 1, 1, 1, true)
    tooltip:AddDoubleLine(GetColor("INFO") .. L["UI_LEFT_CLICK"] .. "|r", GetColor("INFO") .. L["UI_TOGGLE"] .. "|r")
    tooltip:AddLine(" ")

    -- Include Scroll Buffs
    local scrollState = settings.useScrolls
        and (GetColor("SUCCESS") .. L["UI_ENABLED"] .. "|r")
        or  (GetColor("DISABLED") .. L["UI_DISABLED"] .. "|r")
    tooltip:AddDoubleLine(GetColor("TITLE") .. L["MENU_SCROLL_BUFFS"] .. "|r", scrollState)
    tooltip:AddLine(GetColor("DESC") .. L["MENU_SCROLL_BUFFS_DESC"] .. "|r", 1, 1, 1, true)
    tooltip:AddDoubleLine(GetColor("INFO") .. L["UI_SHIFT_LEFT"] .. "|r", GetColor("INFO") .. L["UI_TOGGLE"] .. "|r")

    -- Current Best Food
    if ns.BestFoodID and ns.BestFoodLink then
        tooltip:AddLine(" ")
        tooltip:AddLine(GetColor("TITLE") .. L["UI_BEST_FOOD"] .. "|r")
        local foodIcon = C_Item.GetItemIconByID(ns.BestFoodID)
        tooltip:AddLine(format("|T%s:14:14|t %s", foodIcon, ns.BestFoodLink))
        tooltip:AddDoubleLine(GetColor("INFO") .. L["UI_RIGHT_CLICK"] .. "|r", GetColor("INFO") .. L["MENU_IGNORE"] .. "|r")
    end

    -- Ignore List
    local ignoreList = ConnoisseurCharDB.ignoreList or {}
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

        tooltip:AddDoubleLine(GetColor("INFO") .. L["UI_MIDDLE_CLICK"] .. "|r", GetColor("INFO") .. L["MENU_CLEAR_IGNORE"] .. "|r")
    end

    -- Options hint
    tooltip:AddLine(" ")
    tooltip:AddLine(GetColor("DESC") .. L["MENU_OPTIONS_HINT"] .. "|r", 1, 1, 1, true)

    tooltip:Show()
end

--------------------------------------------------------------------------------
-- LDB Data Object
--------------------------------------------------------------------------------

if LDB then
    ns.LDBObj = LDB:NewDataObject("Connoisseur", {
        type = "data source",
        text = L["BRAND"],
        icon = "Interface\\Icons\\INV_Misc_Food_02",
        OnClick = function(self, button)
            if button == "RightButton" and ns.BestFoodID then
                local ignoreList = ConnoisseurCharDB and ConnoisseurCharDB.ignoreList or {}
                ignoreList[ns.BestFoodID] = true
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
                local ignoreList = ConnoisseurCharDB and ConnoisseurCharDB.ignoreList or {}
                wipe(ignoreList)
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
