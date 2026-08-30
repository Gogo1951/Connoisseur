local _, ns = ...
local L = ns.L

--[[
    Read across files as the "a bank window is open" gate; everything else about a
    restock run is private to this file.
]]
ns.bankIsOpen = false

local currentlyRestocking = false
local restockState = nil
local updateTimer = 0
--[[
    Starts at the floor so the OnUpdate handler never compares against nil; the real
    connection-paced value is seeded in RestartBankRestocking.
]]
local updateInterval = 0.140

--[[
    After this many consecutive steps that fail to reduce the outstanding work (a move that
    keeps being rejected, or an item stuck locked), stop and report what's still short --
    instead of retrying forever. Retrying a handful of times first rides out transient
    "Couldn't split those items" races without ever bothering the user.
]]
local MAX_STUCK_STEPS = 5

--[[
    A maintained item's bag+bank TOTAL can only drop while a move is in transit: the source
    slot is already empty but the destination hasn't been credited yet, and NOTHING is locked
    in that window, so the lock gate in OnBankRestockUpdate can't see it. A scan taken there
    under-counts and must not be acted on. Wait at most this many steps for the total to
    recover before accepting it as the new reality (item genuinely consumed or destroyed).
]]
local MAX_INFLIGHT_STEPS = 3

--[[
    The bank restock's step-by-step trace. Gated on the Diagnostic Tools panel's
    runtime flag, which lives in memory and starts false at every login, so a
    player can never leave this on -- and the boolean is read before any string
    work, so a run with diagnostics off pays one comparison per call.

    Developer-facing, so the text stays plain English and out of Locales/, like
    every other diagnostics string.

    Restocker-Bags.lua calls this too and loads first, which is fine: every call is
    made at runtime, long after all the Restocker files have loaded.

    Takes an optional printf-style format plus arguments rather than a
    pre-concatenated string, so the (potentially expensive) build only happens
    when the gate is open: prefer ns.RestockerDebug("x=%s", v) over
    ns.RestockerDebug("x=" .. v).
]]
function ns.RestockerDebug(format, ...)
	if not (ns.diagnostics and ns.diagnostics.enabled) then
		return
	end
	local message = format
	if select("#", ...) > 0 then
		message = string.format(format, ...)
	end
	ns.PrintMessage(tostring(message))
end

--------------------------------------------------------------------------------
-- Inventory Model
--------------------------------------------------------------------------------

-- Collection of items in the inventory or bank with their precise slot locations and counts, and summaries
local Inventory = {}
Inventory.__index = Inventory

function ns.NewRestockInventorySlot(bag, slot, itemCount)
	return {
		bag = bag,
		slot = slot,
		count = itemCount,
	}
end

local function NewSlotNumber(bag, slot)
	return {
		bag = bag,
		slot = slot,
	}
end

function ns.NewRestockInventory()
	return setmetatable({
		summary = {},
		slots = {},
	}, Inventory)
end

-- Sorts bag slots for each item, with smallest stacks first
function Inventory:SortSlots()
	for _, eachItemSlots in pairs(self.slots) do
		table.sort(eachItemSlots, ns.CompareByStackSizeAscending)
	end
end

function Inventory:FindBestFit(cachedItem, amount)
	local containingSlots = self.slots[cachedItem.itemID]
	if not containingSlots then
		ns.RestockerDebug("BestFit: no existing stacks for merging %s x%s", cachedItem.itemName, amount)
		return nil
	end

	local mergeDestinations = {}

	for _, inventorySlot in ipairs(containingSlots) do
		local remainingAfterMerge = cachedItem.itemStackCount - (inventorySlot.count + amount)

		-- If can merge into this slot
		if remainingAfterMerge >= 0 then
			local candidate = ns.NewRestockInventorySlot(inventorySlot.bag, inventorySlot.slot, remainingAfterMerge)
			table.insert(mergeDestinations, candidate)
		end
	end

	if #mergeDestinations == 0 then
		ns.RestockerDebug("BestFit: found stacks but no candidates for merging %s x%s", cachedItem.itemName, amount)
		return nil
	end

	-- Pick smallest remaining
	table.sort(mergeDestinations, ns.CompareByStackSizeAscending)

	-- First element should be lowest, i.e. closest to the perfection of a full stack
	local bestDestination = mergeDestinations[1]
	ns.RestockerDebug(
		"BestFit: candidate for merging %s x%s is %s:%s",
		cachedItem.itemName,
		amount,
		bestDestination.bag,
		bestDestination.slot
	)
	return NewSlotNumber(bestDestination.bag, bestDestination.slot)
end

--------------------------------------------------------------------------------
-- Restock State
--------------------------------------------------------------------------------

local RestockState = {}
RestockState.__index = RestockState

local function NewRestockState()
	local state = {}
	state.lastRemainingWork = math.huge
	state.stuckSteps = 0
	state.consolidating = false
	state.lastStackCount = math.huge
	state.tidySteps = 0
	state.lastTotals = nil
	state.suspectSteps = 0
	state.cursorSteps = 0
	state.overshotItems = {}

	setmetatable(state, RestockState)

	state:Rescan()

	return state
end

--[[
    Whether the cursor is clear enough to snapshot over, clearing it where that is ours to do.

    An item on the cursor is uncounted, so a scan taken across one reads short and moves
    things that are already fine. Only OUR strays are cleared outright: every move this file
    issues is of a maintained item, so a cursor holding anything else belongs to the player --
    picked up to move it by hand -- and clearing that snapped their drag back within a tick.
    A foreign item is waited out for the same MAX_STUCK_STEPS budget the watchdog spends, then
    cleared anyway, so a parked cursor can never hold a run open forever.
]]
function RestockState:ClearCursorForScan()
	if not CursorHasItem() then
		self.cursorSteps = 0
		return true
	end

	local infoType, cursorItemID = GetCursorInfo()
	local isOurs = infoType == "item"
		and cursorItemID ~= nil
		and self.currentProfile ~= nil
		and self.currentProfile[cursorItemID] ~= nil

	if not isOurs and self.cursorSteps < MAX_STUCK_STEPS then
		self.cursorSteps = self.cursorSteps + 1
		ns.RestockerDebug("Cursor holds an item we do not maintain, waiting (%d/%d)", self.cursorSteps, MAX_STUCK_STEPS)
		return false
	end

	self.cursorSteps = 0
	ClearCursor()
	return true
end

--[[
    Refresh the profile and re-scan bags + bank. Called at the START OF EVERY restock step,
    so the plan is always derived from what is actually in the containers right now. This is
    the core of the fix: a move the server rejected or only partially placed shows up as
    "still short" on the next step and gets retried, instead of being assumed done. Never
    deduct from a plan optimistically: a move that does not fully land leaves the item short
    in silence. Recomputing every step is safe only because the watchdog in RunRestockLogic
    stops the run once it stops making progress; without that guard it spins on "Couldn't
    split those items" forever.

    Returns false when the cursor made this step unsafe to read, which is the caller's cue to
    do nothing this tick. The profile is resolved before that test, because deciding whose
    item is on the cursor needs it -- and it leaves the inventories from the previous scan
    untouched rather than half-updated.
]]
function RestockState:Rescan()
	local settings = ns.restockSettings
	self.currentProfile = settings.profiles[settings.currentProfile]

	if not self:ClearCursorForScan() then
		return false
	end

	self:UpdateInventory()
	return true
end

--[[
    How much moving is still owed: shortfalls the bank can supply, plus excesses to stash.
    Zero means done -- either everything is at target, or the only gaps left are items the
    bank has none of (nothing more we can do).
]]
function RestockState:RemainingWork()
	local work = 0
	for itemID, eachItem in pairs(self.currentProfile) do
		local haveInBag = self.playerInventory.summary[itemID] or 0
		local haveInBank = self.bankInventory.summary[itemID] or 0
		--[[
		    A hand-edited save can leave amount nil; comparing that against a count throws
		    inside the coroutine and kills the whole run, so read it as 0.
		]]
		local wanted = eachItem.amount or 0

		if eachItem.restockFromBank and wanted > haveInBag and haveInBank > 0 then
			work = work + math.min(wanted - haveInBag, haveInBank)
		end
		--[[
		    Overshoot excess counts as stash work even without stashTobank: the addon created it
		    (whole-stack fallback pull), so the addon returns it.
		]]
		if (eachItem.stashTobank or self.overshotItems[itemID]) and haveInBag > wanted then
			work = work + (haveInBag - wanted)
		end
	end
	return work
end

--[[
    Bag+bank total for each maintained item, from this step's scan. Used by the in-flight
    gate in RunRestockLogic: a DROP versus the last accepted scan means an item is mid-move.
]]
function RestockState:ComputeTotals()
	local totals = {}
	for itemID in pairs(self.currentProfile) do
		totals[itemID] = (self.playerInventory.summary[itemID] or 0) + (self.bankInventory.summary[itemID] or 0)
	end
	return totals
end

--[[
    How many stacks of maintained items the bags hold, used as the tidy-phase progress
    signal: each successful merge collapses two stacks into one, so
    this strictly decreases while consolidation is making headway and plateaus when done (or if
    a merge bounces), which the tidy watchdog uses to stop.
]]
function RestockState:CountMaintainedStacks()
	local stacks = 0
	for _, slots in pairs(self.playerInventory.slots) do
		stacks = stacks + #slots
	end
	return stacks
end

--[[
    A user-facing message for why we stopped when work still remains. Prefers the specific
    "bag/bank is full" cause; otherwise lists exactly what we couldn't move.
]]
function RestockState:StuckMessage()
	local bagHasSpace, bankHasSpace = ns.GetRestockSpace()
	if not bagHasSpace and not bankHasSpace then
		return L["RESTOCKER_STOPPED_BOTH_FULL"]
	elseif not bankHasSpace then
		return L["RESTOCKER_STOPPED_BANK_FULL"]
	elseif not bagHasSpace then
		return L["RESTOCKER_STOPPED_BAG_FULL"]
	end

	local parts = {}
	for itemID, eachItem in pairs(self.currentProfile) do
		local haveInBag = self.playerInventory.summary[itemID] or 0
		local haveInBank = self.bankInventory.summary[itemID] or 0
		local wanted = eachItem.amount or 0

		if eachItem.restockFromBank and wanted > haveInBag and haveInBank > 0 then
			parts[#parts + 1] = string.format(
				L["RESTOCKER_STUCK_ITEM_FORMAT"],
				math.min(wanted - haveInBag, haveInBank),
				eachItem.itemName
			)
		elseif (eachItem.stashTobank or self.overshotItems[itemID]) and haveInBag > wanted then
			parts[#parts + 1] =
				string.format(L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"], haveInBag - wanted, eachItem.itemName)
		end
	end

	if #parts == 0 then
		return L["RESTOCKER_STOPPED_NO_PROGRESS"]
	end
	return string.format(L["RESTOCKER_STOPPED_COULD_NOT_MOVE"], table.concat(parts, ", "))
end

--[[
    Issue one stash move: find the first over-stocked item and send some to the bank. The
    excess is computed fresh from this step's scan, not from a running tally.
]]
local function StashToBank()
	local state = restockState

	for itemID, eachItem in pairs(state.currentProfile) do
		if eachItem.stashTobank or state.overshotItems[itemID] then
			local haveInBag = state.playerInventory.summary[itemID] or 0
			local excess = haveInBag - eachItem.amount
			if excess > 0 then
				ns.RestockerDebug("Too many %s in bag (%d need %d)", eachItem.itemName, haveInBag, eachItem.amount)
				if ns.MoveRestockItemToBank(state.bankInventory, itemID, excess) then
					return true -- issued one move; caller yields and re-scans next step
				end
			end
		end
	end

	return false
end

--[[
    Issue one restock move: find the first under-stocked item the bank can supply and pull
    some in. The shortfall is computed fresh from this step's scan.
]]
local function RestockFromBank()
	local state = restockState

	for itemID, eachItem in pairs(state.currentProfile) do
		if eachItem.restockFromBank then
			local haveInBag = state.playerInventory.summary[itemID] or 0
			local haveInBank = state.bankInventory.summary[itemID] or 0
			local short = eachItem.amount - haveInBag
			if short > 0 and haveInBank > 0 then
				ns.RestockerDebug("Too few %s in bag (%d need %d)", eachItem.itemName, haveInBag, eachItem.amount)
				--[[
				    stuckSteps > 0 means the previous step's move never landed -- in practice the
				    flaky exact split. Switch to whole-stack overshoot, which always lands; the
				    watchdog would otherwise burn its retries on the same bounced split and give up
				    short (the "couldn't move: 2x ..." stop).
				]]
				local overshoot = state.stuckSteps > 0
				if
					ns.MoveRestockItemFromBank(state.playerInventory, itemID, math.min(short, haveInBank), overshoot)
				then
					if overshoot then
						--[[
						    The whole-stack pull may go past the target. That excess is the addon's
						    doing, not the player's stock -- trim it back even without stashTobank.
						]]
						state.overshotItems[itemID] = true
					end
					return true -- issued one move; caller yields and re-scans next step
				end
			end
		end
	end

	return false
end

--[[
    Merge one pair of partial stacks of a maintained item in the PLAYER bags, to undo the
    fragmentation that free-slot-first placement leaves behind (e.g. 10 + 9 + 1 -> 20). Only
    does "full-absorb" merges: it picks up a whole stack and drops it onto another that has
    room for ALL of it, so no split is involved -- splitting-then-merging is the operation
    that gets bounced by the server, and a whole-stack pickup-then-drop is the reliable manual
    consolidation move. Pairs that can't fully absorb (e.g. 11 + 11) are left alone; they're
    already at the fewest stacks a non-splitting merge can reach.
]]
local function ConsolidateOne()
	local state = restockState

	for itemID, slots in pairs(state.playerInventory.slots) do
		if #slots >= 2 then
			local info = ns.GetItemData(itemID)
			local maxStack = info and info.itemStackCount
			if maxStack and maxStack > 1 then
				--[[
				    slots are sorted smallest-first (SortSlots). Emptying the smallest into another
				    stack removes a slot with the least risk of overflow.
				]]
				local source = slots[1]
				for i = 2, #slots do
					local dest = slots[i]
					if source.count + dest.count <= maxStack then
						ns.RestockerDebug(
							"Consolidate %s: %d from %s:%s -> %s:%s",
							(info and info.itemName) or itemID,
							source.count,
							source.bag,
							source.slot,
							dest.bag,
							dest.slot
						)
						C_Container.PickupContainerItem(source.bag, source.slot) -- pick up whole stack
						C_Container.PickupContainerItem(dest.bag, dest.slot) -- drop onto it -> merges
						return true
					end
				end
			end
		end
	end

	return false
end

--[[
    Is this bag/bank item one we maintain? Profiles are keyed by itemID, so this is
    an O(1) lookup instead of scanning the whole profile by name for every bag
    slot. Hoisted out of UpdateInventory, which runs on every restock step: it
    reads the list off this upvalue rather than closing over a fresh one each time.
]]
local maintainedProfile

local function IsMaintainedItem(itemID)
	return maintainedProfile[itemID] ~= nil
end

function RestockState:UpdateInventory()
	local settings = ns.restockSettings
	maintainedProfile = settings.profiles[settings.currentProfile]

	self.playerInventory = ns.GetRestockItemsInBags(IsMaintainedItem)
	self.bankInventory = ns.GetRestockItemsInBank(IsMaintainedItem)
end

--------------------------------------------------------------------------------
-- Restock Steps
--------------------------------------------------------------------------------

local function FinishRestocking(message)
	currentlyRestocking = false
	ns.restockUpdateFrame:Hide() -- stop the periodic OnUpdate timer
	if message then
		ns.PrintMessage(message)
	end
end

--[[
    The bank window closing, from outside this file. The run is abandoned rather
    than finished, so it says nothing: the closing handler reports the shortfall.
]]
function ns.StopBankRestock()
	FinishRestocking(nil)
end

--[[
    Run a single restock step: re-scan reality, then issue at most one move. The coroutine
    calls this once per eligible tick (only after the previous move has settled -- see the
    lock gate in OnBankRestockUpdate) and yields between calls.
]]
local function RunRestockLogic()
	local state = restockState

	if not ns.bankIsOpen then
		FinishRestocking(L["RESTOCKER_BANK_NOT_OPEN"])
		return true
	end

	--[[
	    HARD SAFETY INVARIANT: never sell at a merchant. The moves below use
	    C_Container.UseContainerItem to shift whole stacks, and that call SELLS the item when a
	    merchant window is open (it only moves to the bank when a BANK is open). A bank and a
	    merchant can't normally both be open, but if the merchant flag is set -- a stale flag, or
	    an odd BANKFRAME/MERCHANT event order -- issuing a stash here would vendor the player's
	    "too many" excess. Refuse to act: bail cleanly, and the next real bank visit restarts.
	]]
	if ns.merchantIsOpen then
		ns.RestockerDebug("Merchant open -- aborting bank restock so UseContainerItem can never sell")
		FinishRestocking(nil)
		return true
	end

	--[[
	    Reconcile against reality every step: re-derive the outstanding work from what's
	    actually in the bags/bank right now. A move that was rejected or only partially placed
	    simply reappears as remaining work and gets retried; a move that worked shrinks the
	    work for real.

	    A declined rescan (the player is holding something of their own) is a skipped tick,
	    not a stalled run: nothing below has read this step's inventories yet, and the step
	    is deliberately not counted against the watchdog, since no move was attempted.
	]]
	if not state:Rescan() then
		return false
	end

	--[[
	    In-flight gate: a maintained item's bag+bank total can only DROP while a move is in
	    transit (source slot already empty, destination not yet credited -- and nothing is
	    locked in that window, so the lock gate in OnBankRestockUpdate can't hold us back). A scan
	    taken there under-counts: acting on it is what pulled a duplicate stack ("8 -> 28"),
	    and when the in-transit stack was the bank's LAST one, printed "Finished restocking"
	    with the pull still in the air -- skipping the stash-back. Don't move and don't finish
	    off a scan like that; wait for the total to recover. If it stays down past
	    MAX_INFLIGHT_STEPS, the item really left (consumed/destroyed) -- accept the new
	    baseline and continue.
	]]
	local totals = state:ComputeTotals()
	if state.lastTotals ~= nil and state.suspectSteps < MAX_INFLIGHT_STEPS then
		for itemID, previousTotal in pairs(state.lastTotals) do
			if (totals[itemID] or 0) < previousTotal then
				state.suspectSteps = state.suspectSteps + 1
				local profileItem = state.currentProfile[itemID]
				ns.RestockerDebug(
					"%s in transit (bag+bank %d, was %d), waiting",
					profileItem and profileItem.itemName or tostring(itemID),
					totals[itemID] or 0,
					previousTotal
				)
				return false
			end
		end
	end
	state.suspectSteps = 0
	state.lastTotals = totals

	local remaining = state:RemainingWork()

	if remaining > 0 then
		state.consolidating = false -- still moving; tidy phase (below) hasn't started

		--[[
		    Watchdog. We only get here with locks already settled (OnBankRestockUpdate gates on that), so
		    if the outstanding work did NOT shrink since last step, the last move genuinely didn't
		    land -- a rejected split, or something we can't place. Retry a few times to absorb
		    transient races, then give up with a clear message. This is the piece both previous
		    designs lacked: it neither spams forever (recompute-every-step) nor reports success
		    while short (optimistic-deduct).
		]]
		if remaining < state.lastRemainingWork then
			state.stuckSteps = 0
		else
			state.stuckSteps = state.stuckSteps + 1
			if state.stuckSteps >= MAX_STUCK_STEPS then
				FinishRestocking(state:StuckMessage())
				return true
			end
		end
		state.lastRemainingWork = remaining

		--[[
		    ONE move per tick: stash an over-stocked item, otherwise pull an under-stocked one.
		    Doing only one keeps a stash and a restock from firing in the same tick and fighting
		    over the cursor. ALWAYS keep going (return false) even if nothing was issued -- a slot
		    may still be locked from the previous move; the watchdog above is what stops us if
		    we're genuinely stuck. Stashing runs first so it can free a bag slot for restocking.
		]]
		if StashToBank() then
			return false
		end
		if RestockFromBank() then
			return false
		end
		return false
	end

	--[[
	    All items are at target. TIDY PHASE (best-effort): merge the partial stacks that
	    free-slot-first placement leaves behind. This can never leave an item short (totals are
	    already correct) -- the worst case is that a merge doesn't take and we simply stop.
	]]
	if not state.consolidating then
		state.consolidating = true -- entering tidy phase; start its watchdog fresh
		state.lastStackCount = math.huge
		state.tidySteps = 0
	end

	--[[
	    Tidy watchdog: each successful merge collapses two stacks into one, so the maintained
	    stack count strictly drops while we're making progress. If it stops dropping (fully
	    consolidated, or a merge got bounced), finish cleanly -- restocking already succeeded,
	    so this is a normal "Finished", not a problem to report.
	]]
	local stacks = state:CountMaintainedStacks()
	if stacks < state.lastStackCount then
		state.tidySteps = 0
	else
		state.tidySteps = state.tidySteps + 1
		if state.tidySteps >= MAX_STUCK_STEPS then
			FinishRestocking(
				string.format(L["RESTOCKER_COMPLETE"], ns.GetColor("INFO") .. "/crs|r" .. ns.GetColor("TEXT"))
			)
			return true
		end
	end
	state.lastStackCount = stacks

	if ConsolidateOne() then
		return false -- merged a pair; re-scan next tick and keep tidying
	end

	-- Nothing left to merge: genuinely done.
	FinishRestocking(string.format(L["RESTOCKER_COMPLETE"], ns.GetColor("INFO") .. "/crs|r" .. ns.GetColor("TEXT")))
	return true
end

local function RunRestockCoroutine()
	while RunRestockLogic() == false and ns.bankIsOpen do
		coroutine.yield()
	end
end

local restockCoroutine = coroutine.create(RunRestockCoroutine)

local function MaintainAndResumeCoro()
	if restockCoroutine == nil or coroutine.status(restockCoroutine) == "dead" then
		ns.RestockerDebug("Maintain: create coro")
		restockCoroutine = coroutine.create(RunRestockCoroutine)
	end

	if coroutine.status(restockCoroutine) == "running" then
		ns.RestockerDebug("Maintain: coro running")
		return
	end

	local ok, err = coroutine.resume(restockCoroutine)

	if not ok then
		--[[
		    Surface the error to the user instead of letting it vanish, then stop so we don't
		    respawn the coroutine and re-trigger the same error every tick. Reopening the bank
		    (ns.RestartBankRestock) creates a fresh coroutine and retries.
		]]
		ns.PrintMessage(string.format(L["RESTOCKER_STOPPED_ERROR"], tostring(err)))
		FinishRestocking(nil)
		restockCoroutine = nil
	end
end

--------------------------------------------------------------------------------
-- Move Timer
--------------------------------------------------------------------------------

--[[
    One move is issued per tick. Pace ticks to the connection so a move has time to be
    confirmed by the server before the next one: wait ~3x the round-trip, but never faster
    than 0.140s. GetNetStats only refreshes its figures every ~30s, so this is called once
    per tick (and once at restock start) rather than on every OnUpdate frame.
]]
local function ComputeUpdateInterval()
	local _, _, pingHome, pingWorld = GetNetStats()
	local maxPing = math.max(pingHome, pingWorld)
	return math.max(0.140, (maxPing * 3) / 1000)
end

local function OnBankRestockUpdate(_frame, elapsed)
	if ns.bankIsOpen == false then
		ns.restockUpdateFrame:Hide() -- stop the periodic timer in the update frame
		return -- nope
	end

	updateTimer = updateTimer + elapsed

	if updateTimer >= updateInterval then
		updateTimer = 0
		updateInterval = ComputeUpdateInterval() -- pace the NEXT tick

		if currentlyRestocking then
			--[[
			    Wait until the previous move has FULLY settled (no slot still locked) before
			    issuing the next one. Firing a split while the server is still consolidating the
			    item from a move ~140ms ago is what gets rejected with "Couldn't split those
			    items". The fixed tick interval alone isn't enough on a laggy connection. Only wait
			    on OUR items -- an unrelated locked slot must not stall the restock forever.
			]]
			if restockState and ns.IsRestockItemLocked(restockState.currentProfile) then
				return
			end
			MaintainAndResumeCoro()
		end
	end
end

function ns.RestartBankRestock()
	restockState = NewRestockState()
	currentlyRestocking = true
	updateInterval = ComputeUpdateInterval() -- pace the first tick off a fresh reading
	restockCoroutine = coroutine.create(RunRestockCoroutine) -- fresh run for this bank visit
	ns.restockUpdateFrame:Show() -- start the periodic timer in the update frame
end

ns.restockUpdateFrame = CreateFrame("Frame")
ns.restockUpdateFrame:SetScript("OnUpdate", OnBankRestockUpdate)

--[[
    There is no manual re-trigger for a restock, and there must not be one on the
    Diagnostic Tools panel: that panel is read-only by rule, and a restock moves
    the player's items. Closing and reopening the bank restarts a run, and the
    step-by-step trace behind ns.RestockerDebug is what actually explains a stuck
    one. For the logic with no game running, see Tests/RestockPlannerTest.lua.
]]
