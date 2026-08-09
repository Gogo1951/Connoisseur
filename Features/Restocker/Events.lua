local _, ns = ... ---@type string, table
local L = ns.L
local RS = CRS_ADDON ---@type RestockerAddon

---@class RsEventsModule
local eventsModule = CrsModule.eventsModule

local bagModule = CrsModule.bagModule ---@type RsBagModule
local bankModule = CrsModule.bankModule ---@type RsBankModule
local buyiModule = CrsModule.buyIngredientsModule ---@type RsBuyIngredientsModule
local merchantModule = CrsModule.merchantModule ---@type RsMerchantModule
local restockerModule = CrsModule.restockerModule ---@type RsRestockerModule

RS.loaded = false
RS.addItemWait = {}

function eventsModule.OnMerchantShow()
  -- prevents double init but sometimes does not init when entering world too soon?
  buyiModule:SetupAutobuyIngredients()

  RS.buying = true

  if IsShiftKeyDown() then
    return
  end -- If shiftkey is down return

  merchantModule.merchantIsOpen = true
  merchantModule:Restock() -- each item can be individually enabled to restock from merchant
end

--[[
  CLOSING-WINDOW REMINDERS

  Leaving a merchant or a bank is the last moment you can still do something
  about a short list, so both report what is left on the way out. Silent when
  nothing is short -- a report with nothing in it is just noise.

  The short delay is for bag counts. Purchases and bank moves settle on
  BAG_UPDATE, which can land after the window closes; reading the shortfall on
  the same frame would count items you are already holding as missing.
]]
local SETTLE_DELAY = 0.3

local function rsRemindOnClose(enabled, mode)
  if not enabled then
    return
  end
  C_Timer.After(SETTLE_DELAY, function()
    local groceries = RS.BuildGroceryList()
    if #groceries == 0 then
      return
    end
    RS.PrintShortfall(RS.ShortfallHeadline(#groceries), mode, groceries)
  end)
end

function eventsModule.OnMerchantClose()
  merchantModule.merchantIsOpen = false
  RS:Hide()

  local settings = restockerModule.settings
  if settings then
    rsRemindOnClose(settings.merchantReminder, settings.merchantReminderMode)
  end
end

function eventsModule.OnBankOpen()
  local settings = restockerModule.settings

  if IsShiftKeyDown()
      or settings.profiles[settings.currentProfile] == nil then
    return
  end

  if settings.autoOpenAtBank then
    RS:Show()
  end

  bankModule.bankIsOpen = true
  bankModule:RestartRestocking()
end

function eventsModule.OnBankClose()
  bankModule.bankIsOpen = false
  bankModule.currentlyRestocking = false
  RS:Hide()

  local settings = restockerModule.settings
  if settings then
    rsRemindOnClose(settings.bankReminder, settings.bankReminderMode)
  end
end

--[[
  ENTERING TOWN

  Resting status is the game's own "you are somewhere with vendors" signal --
  it turns on in inns and cities and nowhere else -- so it is what the reminder
  keys off rather than a zone list we would have to maintain.

  PLAYER_UPDATE_RESTING fires on both edges and can repeat, so only a
  not-resting to resting transition counts. The RS.loaded check comes before
  the state is recorded, deliberately: a firing during load would otherwise
  consume the transition and swallow the reminder for that whole visit.

  This reminds you on arriving in town, not on being in one. Logging in or
  reloading inside an inn generally will not fire it, which is the point --
  a reminder on every /reload would be noise.

  Both halves are gated on actually being short of something: a reminder to
  restock when there is nothing to buy is noise too. All three settings ship on.
]]
local wasResting = nil

function eventsModule.OnUpdateResting()
  if not RS.loaded then
    return
  end

  local resting = IsResting() and true or false
  if resting == wasResting then
    return
  end
  wasResting = resting

  if not resting then
    return
  end

  local settings = restockerModule.settings
  if not settings then
    return
  end
  if not (settings.restockReminderChat or settings.restockReminderSound) then
    return
  end

  local groceries = RS.BuildGroceryList()
  if #groceries == 0 then
    return
  end

  --[[
    Unlike the closing-window reminders, this one keeps its own headline: it
    is a nudge on arrival rather than a report on the way out. The sound is
    independent of the chat line, so it still fires when the print is off.
  ]]
  if settings.restockReminderChat then
    RS.PrintShortfall(L["RESTOCKER_TOWN_REMINDER"], settings.restockReminderMode, groceries)
  end

  if settings.restockReminderSound then
    PlaySoundFile(RS.RESTOCK_ALERT_SOUND, "Master")
  end
end

---@param itemID number
---@param success boolean
function eventsModule.OnItemInfoReceived(itemID, success)
  if success == nil then
    return
  end

  -- If this was an autobuy item setup item request. Tested with next(), not #:
  -- buyIngredientsWait is keyed by itemID (BuyIngredients.lua), so it is a sparse
  -- table and the length operator reads 0 no matter how many recipes are waiting.
  if next(buyiModule.buyIngredientsWait) ~= nil then
    buyiModule:RetryWaitRecipes()
  end

  -- If this was an item add request for an unknown item
  if RS.addItemWait[itemID] then
    RS.addItemWait[itemID] = nil
    RS:addItem(itemID)
  end

  --[[
    An upgrade deferred because its target had not resolved yet. GetItemInfo
    asked the server on that miss, so this event is the answer arriving; the
    retry is free once nothing is pending.
  ]]
  if RS.HasPendingUpgrade and RS.HasPendingUpgrade() then
    RS.UpgradeRestockList()
  end

  -- A Starter List tick deferred the same way (StarterList.lua): its item had
  -- not resolved when the box was ticked, and this event is the answer arriving.
  if RS.HasPendingStarterAdds and RS.HasPendingStarterAdds() then
    RS.RetryPendingStarterAdds()
  end
end

--[[
  Levelling is the only thing that moves a staple onto its next tier, so the
  Restock List is checked here and nowhere else. Classic Era's ladders top out
  at level 45, so a Classic character sees this a handful of times and then
  never again -- which is exactly what the expansion flag on each tier is for.
]]
function eventsModule.OnLevelUp()
  if RS.UpgradeRestockList then
    RS.UpgradeRestockList()
  end
end

function eventsModule.OnLogout()
  RS:Show()
  RS:Hide()

  -- Position and size together, the same call the drag and resize handlers use.
  RS.SaveFrameGeometry()

  -- Pack items into the compact one-line-per-item form for the SavedVariables file.
  -- Must be last here, since RS:Show()/Update() above iterate items as tables.
  RS:DeflateForSave()
end

function eventsModule.OnUiErrorMessage(id, message)
  if message == ERR_INV_FULL or message == ERR_BANK_FULL then
    -- Matched against the client's own ERR_INV_FULL / ERR_BANK_FULL globals rather than
    -- the numeric message ids, which can renumber between client builds and would fail
    -- silently -- the same text comparison Core's dispatcher uses for ERR_ITEM_WRONG_ZONE.
    -- Do NOT hard-stop restocking here: this error
    -- can fire on a transient race, and silently killing the whole run is what left later
    -- items untouched. The restock loop re-scans every step and stops itself with a clear
    -- message when it's genuinely out of room (see RunRestockLogic / StuckMessage). Buying,
    -- which has no such self-check, still stops.
    RS.buying = false
  end
end

function eventsModule:InitEvents()
  RS:RegisterEvent("MERCHANT_SHOW", self.OnMerchantShow);
  RS:RegisterEvent("MERCHANT_CLOSED", self.OnMerchantClose);
  RS:RegisterEvent("BANKFRAME_OPENED", self.OnBankOpen);
  RS:RegisterEvent("BANKFRAME_CLOSED", self.OnBankClose);
  RS:RegisterEvent("GET_ITEM_INFO_RECEIVED", self.OnItemInfoReceived);
  RS:RegisterEvent("PLAYER_LOGOUT", self.OnLogout);
  RS:RegisterEvent("UI_ERROR_MESSAGE", self.OnUiErrorMessage);
  RS:RegisterEvent("PLAYER_UPDATE_RESTING", self.OnUpdateResting);
  RS:RegisterEvent("PLAYER_LEVEL_UP", self.OnLevelUp);
  -- Handler lives in StarterList.lua (loads after this file, defined well
  -- before PLAYER_LOGIN runs InitEvents). Note the dispatcher in Restocker.lua
  -- keeps ONE handler per event -- anything else that wants
  -- PLAYER_ENTERING_WORLD must share this registration.
  RS:RegisterEvent("PLAYER_ENTERING_WORLD", RS.OnStarterListEnteringWorld);
end
