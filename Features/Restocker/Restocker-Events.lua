local _, ns = ...

ns.restockerLoaded = false

--[[
    Handlers keyed by event name, read by Core's dispatcher (Features/Core.lua).
    Each takes the event's own arguments with no leading event-name, which is what
    Core's own branches use. Filled by ns.InitRestockerEvents.
]]
ns.RESTOCKER_EVENT_HANDLERS = {}

--[[
    A table from the first frame, so the options panel's guarded accessors index
    something rather than nil before login. ns.InitializeRestocker below replaces
    it with the real ns.db.global.restocker.
]]
ns.restockSettings = {}

--[[
    Called by Core's PLAYER_LOGIN branch, which is the earliest point at which the
    saved variables are loaded and ns.db exists.
]]
function ns.InitializeRestocker()
	ns.restockerLoaded = false

	--[[
	    Everything the subsystem saves lives on ns.db.global.restocker: named
	    shopping lists keyed by itemID, and which list each character uses, so all
	    characters share one file while a Warrior and a Priest see separate lists.
	    AceDB has already applied the defaults from Data/Default-Settings.lua by
	    this point, so nothing is filled in by hand here.
	]]
	ns.restockSettings = ns.db.global.restocker

	ns.restockRowPool = {}
	ns.restockCategoryRowPool = {} -- category pane rows
	ns.restockHiddenFrame = CreateFrame("Frame", nil, UIParent)
	ns.restockHiddenFrame:Hide()

	--[[
	    Unpack the one-line string entries into in-memory tables (and tolerate any tables
	    left by a crash or pasted in by hand). Item links are rebuilt from the itemID.
	]]
	ns.InflateSavedRestockItems(ns.restockSettings)

	-- Select this character's own list (creating it if this is a fresh character)
	ns.InitCharacterRestockList()

	-- Drop leftover empty orphan profiles (e.g. an old shared "default")
	ns.PruneEmptyOrphanRestockLists(ns.restockSettings)
	--[[
	    (Re-packing into the one-line form happens in ns.OnRestockerLogout, which calls
	    ns.DeflateRestockItemsForSave just before WoW writes the SavedVariables file.)
	]]

	ns.InitRestockerEvents()
	ns.InstallRestockLinkCapture()

	--[[
	    The two modules with real one-time setup, called by name. A registry that
	    walked every module looking for an init hook hid which two those were.
	]]
	ns.InitRestockBagDefinitions()
	ns.SetupCraftingRecipes()

	if not ns.restockWindow then
		ns.CreateRestockWindow()
	end

	ns.restockerLoaded = true
end

--------------------------------------------------------------------------------
-- Merchant And Bank Windows
--------------------------------------------------------------------------------

function ns.OnRestockerMerchantShow()
	--[[
	    Idempotent: ns.SetupCraftingRecipes returns immediately once any recipe has
	    resolved. Called again here because a login can finish before the client has
	    named a single item, and a merchant is the next moment the table is needed.
	]]
	ns.SetupCraftingRecipes()

	ns.restockBuying = true

	if IsShiftKeyDown() then
		return
	end

	ns.merchantIsOpen = true
	ns.RestockFromMerchant() -- each item can be individually enabled to restock from merchant
end

--[[
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

local function RemindOnClose(enabled, mode)
	if not enabled then
		return
	end
	C_Timer.After(SETTLE_DELAY, function()
		local groceries = ns.BuildGroceryList()
		if #groceries == 0 then
			return
		end
		ns.PrintRestockShortfall(ns.RestockShortfallHeadline(#groceries), mode, groceries)
	end)
end

function ns.OnRestockerMerchantClose()
	local merchantWasOpen = ns.merchantIsOpen
	ns.merchantIsOpen = false
	ns.HideRestockWindow()

	local settings = ns.restockSettings
	if settings and merchantWasOpen then
		RemindOnClose(settings.merchantReminder, settings.merchantReminderMode)
	end
end

function ns.OnRestockerBankOpen()
	local settings = ns.restockSettings

	if IsShiftKeyDown() or settings.profiles[settings.currentProfile] == nil then
		return
	end

	if settings.autoOpenAtBank then
		ns.ShowRestockWindow()
	end

	ns.bankIsOpen = true
	ns.RestartBankRestock()
end

function ns.OnRestockerBankClose()
	local bankWasOpen = ns.bankIsOpen
	ns.bankIsOpen = false
	ns.StopBankRestock()
	ns.HideRestockWindow()

	local settings = ns.restockSettings
	if settings and bankWasOpen then
		RemindOnClose(settings.bankReminder, settings.bankReminderMode)
	end
end

--------------------------------------------------------------------------------
-- Level, Logout And Errors
--------------------------------------------------------------------------------

--[[
    A ding is the usual thing that moves a staple onto its next tier. The new
    level is handed on rather than read back off the player: UnitLevel("player")
    still returns the PREVIOUS level during this event (see
    ns.UpgradeRestockList), so reading it here makes the ding a no-op.

    Classic Era's ladders top out at level 45, so a Classic character sees this a
    handful of times and then never again -- which is exactly what the expansion
    flag on each tier is for.
]]
function ns.OnRestockerLevelUp(newLevel)
	if ns.UpgradeRestockList then
		ns.UpgradeRestockList(newLevel)
	end
end

function ns.OnRestockerLogout()
	-- Position and size together, the same call the drag and resize handlers use.
	ns.SaveRestockWindowGeometry()

	--[[
	    Pack items into the compact one-line-per-item form for the SavedVariables
	    file. Must be last: every list entry is a string from here to the end of the
	    session, so nothing may read one as a table after this runs.
	]]
	ns.DeflateRestockItemsForSave()
end

function ns.OnRestockerUiErrorMessage(_, message)
	if message == ERR_INV_FULL or message == ERR_BANK_FULL then
		--[[
		    Matched against the client's own ERR_INV_FULL / ERR_BANK_FULL globals rather than
		    the numeric message ids, which can renumber between client builds and would fail
		    silently -- the same text comparison Core's dispatcher uses for ERR_ITEM_WRONG_ZONE.
		    Do NOT hard-stop restocking here: this error
		    can fire on a transient race, and silently killing the whole run is what left later
		    items untouched. The restock loop re-scans every step and stops itself with a clear
		    message when it's genuinely out of room (see RunRestockLogic / StuckMessage). Buying,
		    which has no such self-check, still stops.
		]]
		ns.restockBuying = false
	end
end

--[[
    Core's dispatcher keeps ONE handler per event name, so anything else wanting an
    event already in this table shares the existing entry rather than adding a
    second one. That is why the arrival check and the Starter List pop-up both
    hang off OnEnteringWorld: the pop-up's half is called from inside that
    handler rather than registering a second one of its own.
]]
function ns.InitRestockerEvents()
	ns.RESTOCKER_EVENT_HANDLERS = {
		MERCHANT_SHOW = ns.OnRestockerMerchantShow,
		MERCHANT_CLOSED = ns.OnRestockerMerchantClose,
		BANKFRAME_OPENED = ns.OnRestockerBankOpen,
		BANKFRAME_CLOSED = ns.OnRestockerBankClose,
		GET_ITEM_INFO_RECEIVED = ns.OnRestockerItemInfoReceived,
		PLAYER_LOGOUT = ns.OnRestockerLogout,
		UI_ERROR_MESSAGE = ns.OnRestockerUiErrorMessage,
		PLAYER_UPDATE_RESTING = ns.OnRestockerUpdateResting,
		PLAYER_CONTROL_GAINED = ns.OnRestockerControlGained,
		PLAYER_LEVEL_UP = ns.OnRestockerLevelUp,
		PLAYER_ENTERING_WORLD = ns.OnRestockerEnteringWorld,
	}
	ns.SyncRestockItemInfoSubscription()
end
