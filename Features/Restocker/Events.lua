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

  The client fires MERCHANT_CLOSED and BANKFRAME_CLOSED on loading-screen
  teardown (boat crossings included) with no matching open -- and can double-fire
  them -- so each close handler keys the reminder off its tracked open flag: a
  _CLOSED event alone does not mean a window was ever open.
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
  local merchantWasOpen = merchantModule.merchantIsOpen
  merchantModule.merchantIsOpen = false
  RS:Hide()

  local settings = restockerModule.settings
  if settings and merchantWasOpen then
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
  local bankWasOpen = bankModule.bankIsOpen
  bankModule.bankIsOpen = false
  bankModule.currentlyRestocking = false
  RS:Hide()

  local settings = restockerModule.settings
  if settings and bankWasOpen then
    rsRemindOnClose(settings.bankReminder, settings.bankReminderMode)
  end
end

--[[
  ENTERING TOWN

  Resting status is the game's own "you are somewhere with vendors" signal --
  it turns on in inns and cities and nowhere else -- so it is what the reminder
  keys off rather than a zone list we would have to maintain.

  Only a not-resting to resting transition counts, so this reminds you on
  ARRIVING in town rather than every time the flag twitches while you are in
  one -- and logging in counts as arriving, see the arming block below.

  Three things reach the check, because one signal does not cover every way of
  arriving:

    PLAYER_UPDATE_RESTING  -- walking in. Fires on both edges and can repeat,
                              which the transition rule already absorbs.
    PLAYER_ENTERING_WORLD  -- logging in, hearthing, portalling, or stepping
                              out of an instance. The resting flag is part of
                              the state the client syncs across a loading
                              screen, so no update event follows and
                              walking-in was the only arrival that ever fired.
    PLAYER_CONTROL_GAINED  -- landing off a flight path; see the taxi rule.

  Both halves are gated on actually being short of something: a reminder to
  restock when there is nothing to buy is noise too. All three settings ship on.
]]
local wasResting = nil

--[[
  A flight path crosses inns and towns the whole way, and the resting flag
  flickers on and off with them. None of those is an arrival -- you cannot
  shop from the back of a gryphon -- so a taxi counts as NOT IN TOWN for as
  long as it lasts, and the recorded state is forced to match. That is what
  leaves a genuine not-resting to resting edge for the landing to trip:
  PLAYER_CONTROL_GAINED re-checks once control is back and UnitOnTaxi has
  cleared, so touching down at a town flight master still reminds you.
]]
---@return boolean
local function rsOnTaxi()
  return UnitOnTaxi("player") and true or false
end

--[[
  The quiet window after a reminder. Arrivals cluster -- a hearth lands you in
  an inn inside a city, and a quick errand in and out of an instance re-crosses
  the same boundary -- and each of those is one trip to town, not three
  reminders. Measured from the reminder, not from the arrival, so a suppressed
  check (nothing short, everything off) never starts the clock.
]]
local REMINDER_COOLDOWN = 60
local lastReminderAt = nil

--[[
  How long to let an arrival settle before reading it. Resting status and the
  bag counts the shortfall is built from both land after the loading screen,
  and after a flight the taxi flag clears a moment behind control returning --
  reading either too early reports the trip you just left.

  A login settles slower than a zone change and waits longer still -- past the
  loading-screen flurry, past the add-on's own post-login work, and well past
  the item queries behind a name-keyed list entry. The shortfall is read at the
  END of that pause, not the start, so a bag that finishes filling in the
  meantime is counted and a list that is no longer short says nothing.
]]
local ARRIVAL_SETTLE_DELAY = 2
local LOGIN_SETTLE_DELAY = 5

--[[
  ARMING

  Nothing reminds until PLAYER_ENTERING_WORLD has said what kind of entry this
  was, because the two kinds want opposite things and the resting events during
  a load arrive too early to tell them apart:

    Logging in IS an arrival -- you have just walked up to the game -- so a
    character who logs in resting gets the reminder. That was inconsistent
    before this gate existed: an inn happened to fire a late
    PLAYER_UPDATE_RESTING and a city did not, so the same standing-in-town
    login reminded you or did not depending on which side of the door you
    logged out on.

    A /reload is NOT an arrival. It records where the character already is --
    so the next real arrival still has an edge to trip -- and says nothing,
    which is the whole reason the flag is seeded rather than simply cleared.

  Left false until then, the check does nothing at all rather than recording
  state: a resting event landing mid-load would otherwise consume the very
  transition the login is about to report.
]]
local remindersArmed = false

local function rsCheckResting()
  if not RS.loaded or not remindersArmed then
    return
  end

  if rsOnTaxi() then
    wasResting = false
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

  if lastReminderAt and (GetTime() - lastReminderAt) < REMINDER_COOLDOWN then
    return
  end

  local groceries = RS.BuildGroceryList()
  if #groceries == 0 then
    return
  end

  lastReminderAt = GetTime()

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

function eventsModule.OnUpdateResting()
  rsCheckResting()
end

---Arriving under your own steam: off a flight path (the common case for this
---event) or out of anything else that took control away. Delayed like the
---loading-screen arrivals, because UnitOnTaxi clears a moment after control
---returns and an immediate read would still call it a flight.
function eventsModule.OnControlGained()
  C_Timer.After(ARRIVAL_SETTLE_DELAY, rsCheckResting)
end

--[[
  The one PLAYER_ENTERING_WORLD handler (the dispatcher in Restocker.lua keeps
  one per event), shared by the arrival check and the Starter List pop-up.

  isReloadingUi is the only entry that is not an arrival: a login is one, and
  so is any other loading screen -- a hearth, a portal, an instance door. Both
  branches wait out the same settle before touching the resting flag, so a
  /reload cannot be reminded on by a resting event that beat the seeding.
]]
---@param isInitialLogin boolean
---@param isReloadingUi boolean
function eventsModule.OnEnteringWorld(isInitialLogin, isReloadingUi)
  local delay = isInitialLogin and LOGIN_SETTLE_DELAY or ARRIVAL_SETTLE_DELAY

  C_Timer.After(delay, function()
    if isReloadingUi then
      wasResting = IsResting() and true or false
      remindersArmed = true
      return
    end

    remindersArmed = true
    rsCheckResting()
  end)

  RS.OnStarterListEnteringWorld(isInitialLogin, isReloadingUi)

  --[[
    Catch-up for a list that is behind the player's level. A ding is not the
    only way that happens -- levels gained with the add-on disabled, a profile
    copied off a higher character, a ding that arrived while the list was
    mid-load -- and before this ran, a single missed level-up stranded the
    entry for good, since nothing else re-checked.

    Safe here: rsInflate has already turned the saved one-line entries back
    into tables (it runs at PLAYER_LOGIN, ahead of this event), and the check
    is silent and free once nothing is behind, so the zone-in case costs a walk
    of the list. A cold item cache at login needs no special handling: the move
    defers and rides GET_ITEM_INFO_RECEIVED like any other.
  ]]
  if RS.UpgradeRestockList then
    RS.UpgradeRestockList()
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
  A ding is the usual thing that moves a staple onto its next tier. The new
  level is handed on rather than read back off the player: UnitLevel("player")
  still returns the OLD level during this event (see RS.UpgradeRestockList),
  which is what used to make the ding itself a no-op.

  Classic Era's ladders top out at level 45, so a Classic character sees this a
  handful of times and then never again -- which is exactly what the expansion
  flag on each tier is for.
]]
---@param newLevel number
function eventsModule.OnLevelUp(newLevel)
  if RS.UpgradeRestockList then
    RS.UpgradeRestockList(newLevel)
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
  RS:RegisterEvent("PLAYER_CONTROL_GAINED", self.OnControlGained);
  RS:RegisterEvent("PLAYER_LEVEL_UP", self.OnLevelUp);
  -- The dispatcher in Restocker.lua keeps ONE handler per event, so the two
  -- things that want PLAYER_ENTERING_WORLD share OnEnteringWorld above: the
  -- arrival check here, and the Starter List pop-up whose half lives in
  -- StarterList.lua (loads after this file, defined well before PLAYER_LOGIN
  -- runs InitEvents).
  RS:RegisterEvent("PLAYER_ENTERING_WORLD", self.OnEnteringWorld);
end
