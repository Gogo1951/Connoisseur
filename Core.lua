local addonName, ns = ...
local L = ns.L
local C = ns.Colors

local frame = CreateFrame("Frame")
local isUpdatePending = false
local updateTimer = 0
local UPDATE_THROTTLE = 0.5

local ITEM_CACHE_VERSION = C_AddOns.GetAddOnMetadata(addonName, "Version") or "unknown"

local function InitVars()
    if not CC_IgnoreList then
        CC_IgnoreList = {}
    end
    if not CC_Settings then
        CC_Settings = {UseBuffFood = false}
    end
    if not CC_MinimapSettings then
        CC_MinimapSettings = {}
    end
    CC_Settings.Minimap = nil

    if CC_ItemCacheVersion ~= ITEM_CACHE_VERSION then
        CC_ItemCache = {}
        CC_ItemCacheVersion = ITEM_CACHE_VERSION
    else
        CC_ItemCache = CC_ItemCache or {}
    end

    ns.CachedPlayerLevel = UnitLevel("player") or 1
    ns.CachedMapID = C_Map.GetBestMapForUnit("player")

    ns.SpellCache = {}
    if ns.ConjureSpells then
        for _, spellList in pairs(ns.ConjureSpells) do
            for _, data in ipairs(spellList) do
                local spellID = data[1]
                if GetSpellInfo(spellID) then
                    ns.SpellCache[spellID] = true
                end
            end
        end
    end

    if ns.UpdateFirstAidSkill then
        ns.UpdateFirstAidSkill()
    end
    if ns.UpdateAlchemySkill then
        ns.UpdateAlchemySkill()
    end

    local LDBIcon = LibStub("LibDBIcon-1.0", true)
    if LDBIcon and ns.LDBObj and not ns.IconRegistered then
        LDBIcon:Register("Connoisseur", ns.LDBObj, CC_MinimapSettings)
        ns.IconRegistered = true
    end

    if CC_Settings.UseBuffFood then
        frame:RegisterUnitEvent("UNIT_AURA", "player")
        ns.WellFedState = ns.HasWellFedBuff and ns.HasWellFedBuff() or false
    else
        frame:UnregisterEvent("UNIT_AURA")
        ns.WellFedState = false
    end
end

function ns.ToggleBuffFood()
    CC_Settings.UseBuffFood = not CC_Settings.UseBuffFood
    if CC_Settings.UseBuffFood then
        frame:RegisterUnitEvent("UNIT_AURA", "player")
        ns.WellFedState = ns.HasWellFedBuff and ns.HasWellFedBuff() or false
    else
        frame:UnregisterEvent("UNIT_AURA")
        ns.WellFedState = false
    end
    if ns.ResetMacroState then
        ns.ResetMacroState()
    end
    ns.RequestUpdate()
end

function ns.RegisterDataRetry()
    frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    C_Timer.After(
        2,
        function()
            ns.RequestUpdate()
        end
    )
end

function ns.UnregisterDataRetry()
    frame:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
end

local function OnUpdateHandler(self, elapsed)
    if InCombatLockdown() then
        frame:SetScript("OnUpdate", nil)
        isUpdatePending = true
        return
    end

    updateTimer = updateTimer + elapsed
    if updateTimer > UPDATE_THROTTLE then
        frame:SetScript("OnUpdate", nil)
        isUpdatePending = false
        if ns.UpdateMacros then
            ns.UpdateMacros()
        end
    end
end

function ns.RequestUpdate()
    if not isUpdatePending then
        isUpdatePending = true
        updateTimer = 0
        frame:SetScript("OnUpdate", OnUpdateHandler)
    end
end

frame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if InCombatLockdown() then
            isUpdatePending = true
            return
        end

        if event == "PLAYER_REGEN_ENABLED" then
            if isUpdatePending then
                isUpdatePending = false
                ns.RequestUpdate()
            end
            return
        end

        if
            event == "BAG_UPDATE_DELAYED" or 
                event == "ITEM_PUSH" or
                event == "PLAYER_TARGET_CHANGED" or
                event == "GET_ITEM_INFO_RECEIVED" or
                event == "PLAYER_ALIVE" or
                event == "PLAYER_UNGHOST"
         then
            ns.RequestUpdate()
        elseif event == "ZONE_CHANGED_NEW_AREA" then
            ns.CachedMapID = C_Map.GetBestMapForUnit("player")
            ns.RequestUpdate()
        elseif event == "PLAYER_LEVEL_UP" then
            ns.CachedPlayerLevel = UnitLevel("player") or 1
            ns.RequestUpdate()
        elseif event == "PLAYER_ENTERING_WORLD" then
            InitVars()
            ns.RequestUpdate()
            C_Timer.After(
                3,
                function()
                    ns.RequestUpdate()
                end
            )
        elseif event == "SKILL_LINES_CHANGED" then
            if ns.UpdateFirstAidSkill then
                ns.UpdateFirstAidSkill()
            end
            if ns.UpdateAlchemySkill then
                ns.UpdateAlchemySkill()
            end
            ns.RequestUpdate()
        elseif event == "UNIT_AURA" then
            if ns.HasWellFedBuff then
                local currentState = ns.HasWellFedBuff()
                if currentState ~= ns.WellFedState then
                    ns.WellFedState = currentState
                    ns.RequestUpdate()
                end
            end
        elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            local _, _, spellID = ...
            if ns.SpellCache and ns.SpellCache[spellID] then
                ns.RequestUpdate()
            end
        elseif event == "UI_ERROR_MESSAGE" then
            if CC_LastTime and (GetTime() - CC_LastTime) < 1.0 then
                local _, msg = ...
                if msg == ERR_ITEM_WRONG_ZONE then
                    local mapID = C_Map.GetBestMapForUnit("player") or "0"
                    local zone = GetZoneText() or "?"
                    local subzone = GetSubZoneText() or ""
                    if subzone == "" then
                        subzone = zone
                    end

                    local itemID = CC_LastID or 0
                    local link = "Item #" .. itemID
                    if itemID ~= 0 then
                        local _, itemLink = GetItemInfo(itemID)
                        if itemLink then
                            link = itemLink
                        end
                    end

                    print(
                        C.INFO ..
                            L["BRAND"] ..
                                C.MUTED ..
                                    " // " ..
                                        C.TEXT .. string.format(L["MSG_BUG_REPORT"], link, itemID, zone, subzone, mapID)
                    )
                    CC_LastTime = 0
                end
            end
        elseif event == "PLAYER_LOGOUT" then
            if ns.IsKnownConsumable then
                for itemID in pairs(CC_IgnoreList) do
                    if not ns.IsKnownConsumable(itemID) then
                        CC_IgnoreList[itemID] = nil
                    end
                end
            end
        end
    end
)

frame:RegisterEvent("BAG_UPDATE_DELAYED")
frame:RegisterEvent("ITEM_PUSH")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:RegisterEvent("UI_ERROR_MESSAGE")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("SKILL_LINES_CHANGED")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
