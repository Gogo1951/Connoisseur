local _, ns = ...

--[[
    Scanner-Character -- reads live player/pet state and decides which buffs the
    character still needs: profession skills, aura probes (Well Fed, scroll, and
    pet-food buffs), and the scroll override resolver.
]]

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

ns.ScrollOverrideIDs = nil
ns.CurrentFirstAidSkill = 0
ns.CurrentAlchemySkill = 0
ns.CurrentEngineeringSkill = 0

--------------------------------------------------------------------------------
-- Derived Scroll Lookups
--------------------------------------------------------------------------------

--[[
    Built once at load from ns.ScrollData (defined in Data/Scrolls.lua, which
    loads before this file). ns.ScrollItemLookup maps each scroll itemID to its
    scroll type so the bag scanners route scroll items away from normal
    consumable processing; data.buffIDs is the per-type set of scroll buff spell
    IDs, precomputed so HasScrollBuff doesn't rebuild it on every aura tick.
    Every consumer reads these from inside a function (runtime), so the build
    only needs to finish before the first scan.
]]
ns.ScrollItemLookup = {}

--[[
    Reverse maps from a spell ID back to the scroll type(s) it covers, so the
    aura walk below resolves each aura in one lookup instead of testing every
    type. Both hold lists: no spell covers two stats in the current data, but a
    group buff that did (a Gift of the Wild style spell) has to register
    against every type it covers rather than silently claiming one.
]]
local scrollBuffOwners = {}
local scrollConflictOwners = {}

for scrollType, data in pairs(ns.ScrollData) do
	local buffIDs = {}
	for _, entry in ipairs(data.items) do
		ns.ScrollItemLookup[entry[1]] = scrollType
		buffIDs[entry[2]] = true
	end
	data.buffIDs = buffIDs

	for spellID in pairs(buffIDs) do
		local owners = scrollBuffOwners[spellID] or {}
		owners[#owners + 1] = scrollType
		scrollBuffOwners[spellID] = owners
	end
	for spellID, amount in pairs(data.conflictSpells) do
		local owners = scrollConflictOwners[spellID] or {}
		owners[#owners + 1] = { scrollType = scrollType, amount = amount }
		scrollConflictOwners[spellID] = owners
	end
end

--------------------------------------------------------------------------------
-- Profession Skills
--------------------------------------------------------------------------------

function ns.UpdateFirstAidSkill()
	local firstAidSpellName = GetSpellInfo(3273)
	if not firstAidSpellName then
		ns.CurrentFirstAidSkill = 0
		return
	end

	for i = 1, GetNumSkillLines() do
		local skillName, isHeader, _, skillRank = GetSkillLineInfo(i)
		if not isHeader and skillName == firstAidSpellName then
			ns.CurrentFirstAidSkill = skillRank
			return
		end
	end

	ns.CurrentFirstAidSkill = 0
end

function ns.UpdateAlchemySkill()
	local alchemySpellName = GetSpellInfo(2259)
	if not alchemySpellName then
		ns.CurrentAlchemySkill = 0
		return
	end

	for i = 1, GetNumSkillLines() do
		local skillName, isHeader, _, skillRank = GetSkillLineInfo(i)
		if not isHeader and skillName == alchemySpellName then
			ns.CurrentAlchemySkill = skillRank
			return
		end
	end

	ns.CurrentAlchemySkill = 0
end

function ns.UpdateEngineeringSkill()
	local engineeringSpellName = GetSpellInfo(4036)
	if not engineeringSpellName then
		ns.CurrentEngineeringSkill = 0
		return
	end

	for i = 1, GetNumSkillLines() do
		local skillName, isHeader, _, skillRank = GetSkillLineInfo(i)
		if not isHeader and skillName == engineeringSpellName then
			ns.CurrentEngineeringSkill = skillRank
			return
		end
	end

	ns.CurrentEngineeringSkill = 0
end

--------------------------------------------------------------------------------
-- Early Re-Application
--------------------------------------------------------------------------------

--[[
    With Re-Apply Expiring Buffs on, a tracked buff whose remaining time is
    under the profile threshold counts as already expired, so the macros offer
    a fresh application before the pull. Auras without a duration
    (expirationTime 0) never count as expiring.

    Crossing the threshold fires no UNIT_AURA event, so when a scan finds a
    buff still above it, a one-shot timer requests a rebuild for the moment
    the buff crosses. C_Timer.After cannot be cancelled, so nextRecheckAt
    tracks the earliest pending fire time and later-firing stale timers
    no-op; a duplicate rebuild within the epsilon is harmless (RequestUpdate
    is throttled).
]]
local nextRecheckAt

local function ScheduleExpiryRecheck(delay)
	local fireAt = GetTime() + delay
	if nextRecheckAt and nextRecheckAt <= fireAt then
		return
	end
	nextRecheckAt = fireAt
	C_Timer.After(delay, function()
		if not nextRecheckAt or GetTime() + 0.5 < nextRecheckAt then
			return
		end
		nextRecheckAt = nil
		ns.RequestUpdate()
	end)
end

local function BuffCountsAsActive(expirationTime)
	local settings = ns.db and ns.db.profile
	if not (settings and settings.earlyReapply) then
		return true
	end
	if not expirationTime or expirationTime == 0 then
		return true
	end
	local remaining = expirationTime - GetTime()
	local threshold = settings.earlyReapplyThreshold or 120
	if remaining < threshold then
		return false
	end
	ScheduleExpiryRecheck(remaining - threshold + 1)
	return true
end

--------------------------------------------------------------------------------
-- Player Aura Snapshot
--------------------------------------------------------------------------------

--[[
    One walk of the player's helpful auras, shared by the Well Fed and scroll
    probes below and by the readiness report (Features/Readiness.lua). The
    snapshot holds raw expiration times, never a verdict: the probes apply
    BuffCountsAsActive, which owns the early re-application threshold and its
    rebuild timer, while the report reads the same numbers with no side
    effects of its own.

    Expiration convention, shared with the pet probe below: nil means the buff
    is absent, 0 means the aura carries no duration.

    Per buff we keep the longest-lasting match, and a 0 outranks any timed one.
    BuffCountsAsActive is monotonic in remaining time, so testing the longest
    match answers "does any match count as active" exactly as the old per-aura
    loops did. Neither Well Fed nor a scroll buff stacks with itself, so in
    practice there is only ever one match to choose from.

    Scroll entries also keep the largest conflicting class-buff amount seen, so
    the scroll probe can settle "is a class buff already at least as good as
    the scroll I would use" without a second pass; that comparison needs the
    scroll's own amount, which is per-call.

    The table is reused in place rather than rebuilt, because UNIT_AURA is a
    firehose and the Well Fed probe runs on every tick. That makes the return
    value a single shared buffer, not a private copy: a caller must not hold it
    across another call to this function, and one that needs several answers
    takes one snapshot and passes it down (see ns.FindScrollOverrides).
]]
local WELL_FED_ICON_ID = 136000
local WELL_FED_ICON_ID_2 = 133943

local snapshot = { scrolls = {} }
for scrollType in pairs(ns.ScrollData) do
	snapshot.scrolls[scrollType] = {}
end

local function IsLongerExpiration(candidate, current)
	if current == nil then
		return true
	end
	if current == 0 then
		return false
	end
	return candidate == 0 or candidate > current
end

function ns.GetPlayerBuffSnapshot()
	snapshot.wellFedExpiration = nil
	for _, entry in pairs(snapshot.scrolls) do
		entry.expiration = nil
		entry.conflictAmount = nil
	end

	for i = 1, 40 do
		local aura = C_UnitAuras.GetBuffDataByIndex("player", i, "HELPFUL")
		if not aura then
			break
		end
		local icon, spellID = aura.icon, aura.spellId
		local expirationTime = aura.expirationTime or 0

		if
			icon == WELL_FED_ICON_ID
			or icon == WELL_FED_ICON_ID_2
			or (ns.WellFedBuffIDs and ns.WellFedBuffIDs[spellID])
		then
			if IsLongerExpiration(expirationTime, snapshot.wellFedExpiration) then
				snapshot.wellFedExpiration = expirationTime
			end
		end

		local buffOwners = scrollBuffOwners[spellID]
		if buffOwners then
			for _, scrollType in ipairs(buffOwners) do
				local entry = snapshot.scrolls[scrollType]
				if IsLongerExpiration(expirationTime, entry.expiration) then
					entry.expiration = expirationTime
				end
			end
		end

		local conflictOwners = scrollConflictOwners[spellID]
		if conflictOwners then
			for _, owner in ipairs(conflictOwners) do
				local entry = snapshot.scrolls[owner.scrollType]
				if not entry.conflictAmount or owner.amount > entry.conflictAmount then
					entry.conflictAmount = owner.amount
				end
			end
		end
	end

	return snapshot
end

--------------------------------------------------------------------------------
-- Well Fed
--------------------------------------------------------------------------------

--[[
    Split out so the aura handler can settle Well Fed and the scroll diff from
    ONE snapshot pass instead of walking the player's auras twice per event.
]]
local function WellFedFromSnapshot(currentSnapshot)
	local expiration = currentSnapshot.wellFedExpiration
	return expiration ~= nil and BuffCountsAsActive(expiration)
end

function ns.HasWellFedBuff()
	return WellFedFromSnapshot(ns.GetPlayerBuffSnapshot())
end

--------------------------------------------------------------------------------
-- Scroll Buffs
--------------------------------------------------------------------------------

--[[
    A scroll buff of any rank counts as covered. A conflict spell (e.g. Fort)
    only counts as covered if its base amount is at least as large as the
    scroll we would use — otherwise the scroll would still improve the stat.
]]

--[[
    callerSnapshot is an optional snapshot from ns.GetPlayerBuffSnapshot.
    Callers asking about more than one scroll type pass one in, so a single
    walk of the player's auras serves the whole set; omitting it takes a
    fresh one.
]]
function ns.HasScrollBuff(scrollType, scrollAmount, callerSnapshot)
	if not ns.ScrollData or not ns.ScrollData[scrollType] then
		return true
	end

	local entry = (callerSnapshot or ns.GetPlayerBuffSnapshot()).scrolls[scrollType]

	-- Already have a scroll buff active for this stat
	if entry.expiration ~= nil and BuffCountsAsActive(entry.expiration) then
		return true
	end

	--[[
	    Check conflict spells — only block the scroll if the class buff
	    provides at least as much stat as our best scroll would. Exempt
	    from the early re-application threshold: a still-active stronger
	    class buff cannot be overwritten, so treating it as expired would
	    build a scroll line that errors on use.
	]]
	return entry.conflictAmount ~= nil and entry.conflictAmount >= (scrollAmount or 0)
end

--[[
    Finds the best available scroll for a type from bag contents.
    Scroll entries: {[1] itemID, [2] buffID, [3] requiredLevel, [4] amount}
    Returns itemID, amount (or nil, nil if nothing usable is found).
]]
local function FindBestScroll(scrollType, bagItemCounts)
	if not ns.ScrollData or not ns.ScrollData[scrollType] then
		return nil, nil
	end

	local playerLevel = ns.CachedPlayerLevel or 1
	local items = ns.ScrollData[scrollType].items
	for _, entry in ipairs(items) do
		--[[
		    The scroll override path never passes the scanner's ignore filter
		    (it reads the raw bag counts), so it honors the Ignore List itself.
		]]
		if entry[3] <= playerLevel and not ns.IsIgnored(entry[1]) then
			if bagItemCounts[entry[1]] and bagItemCounts[entry[1]] > 0 then
				return entry[1], entry[4]
			end
		end
	end

	return nil, nil
end

--[[
    Returns an ordered list of scroll item IDs the player should use, or nil
    if none apply. Order follows ns.SCROLL_CHECK_ORDER, which is the order the
    scroll-only body fires them in.
]]
function ns.FindScrollOverrides(bagItemCounts)
	local settings = ns.db and ns.db.profile
	if not settings or not settings.useScrolls then
		return nil
	end
	if not ns.IsModeActive(settings.scrollsMode) then
		return nil
	end

	local scrollTypes = settings.scrollTypes
	if not scrollTypes then
		return nil
	end

	local results

	--[[
	    One aura walk for the whole set. Letting each ns.HasScrollBuff call take
	    its own snapshot re-read the player's 40 aura slots once per enabled
	    scroll type, on a path that re-runs with every bag scan.
	]]
	local currentSnapshot = ns.GetPlayerBuffSnapshot()

	for _, scrollType in ipairs(ns.SCROLL_CHECK_ORDER) do
		if scrollTypes[scrollType] then
			local scrollItemID, scrollAmount = FindBestScroll(scrollType, bagItemCounts)
			if scrollItemID and not ns.HasScrollBuff(scrollType, scrollAmount, currentSnapshot) then
				results = results or {}
				results[#results + 1] = scrollItemID
			end
		end
	end

	return results
end

--------------------------------------------------------------------------------
-- Pet Food Buffs
--------------------------------------------------------------------------------

-- Kibler's Bits and Sporeling Snacks both require level 55.
local PET_BUFF_FOOD_MIN_LEVEL = 55

--[[
    Whether pet buff food applies to this character right now: the feature is
    on, its group restriction is satisfied, the player is high enough level for
    the food to exist, and there is a live pet to feed.

    Single source of truth on purpose. Both ns.FindPetBuffOverride
    (Macros/Tools-Hunters.lua), which decides whether to splice the feed line
    into the Food macro, and the readiness report (Features/Readiness.lua) have
    to agree -- when they drifted, the report asked a level-30 Hunter for a
    buff its own macro would never apply, with no way to satisfy it.
]]
function ns.ShouldTrackPetFood()
	local settings = ns.db and ns.db.profile
	if not settings or not settings.usePetBuffFood then
		return false
	end
	if not ns.IsModeActive(settings.petBuffFoodMode) then
		return false
	end
	if (ns.CachedPlayerLevel or 1) < PET_BUFF_FOOD_MIN_LEVEL then
		return false
	end
	if not UnitExists("pet") or UnitIsDead("pet") or UnitIsGhost("pet") then
		return false
	end
	return true
end

--[[
    The pet is a separate unit and so a separate walk from the player snapshot
    above, but it follows the same expiration convention: nil when the buff is
    absent, 0 when the aura carries no duration. Consumed by
    ns.FindPetBuffOverride (Macros/Tools-Hunters.lua) and by the readiness
    report; the probe lives here because BuffCountsAsActive is private to this
    file.
]]
function ns.GetPetFoodBuffExpiration()
	if not UnitExists("pet") then
		return nil
	end
	local best
	for i = 1, 40 do
		local aura = C_UnitAuras.GetBuffDataByIndex("pet", i, "HELPFUL")
		if not aura then
			break
		end
		if aura.spellId == ns.KIBLERS_BUFF_ID or aura.spellId == ns.SPORELING_BUFF_ID then
			local expirationTime = aura.expirationTime or 0
			if IsLongerExpiration(expirationTime, best) then
				best = expirationTime
			end
		end
	end
	return best
end

function ns.HasPetFoodBuff()
	local expiration = ns.GetPetFoodBuffExpiration()
	return expiration ~= nil and BuffCountsAsActive(expiration)
end

--------------------------------------------------------------------------------
-- Aura Event Handler
--------------------------------------------------------------------------------

--[[
    Last-seen aura inputs to the scroll decision, one entry per scroll type.
    ns.HasScrollBuff answers from exactly two snapshot fields -- the scroll's own
    expiration and the largest conflicting class-buff amount -- so tracking those
    two is what separates an aura change that could flip a scroll line from the
    firehose of unrelated ones. The verdict itself is deliberately not recomputed
    here: it needs the scroll amount from the bag scan, which this path has no
    access to, and the early-reapply threshold it applies moves with time rather
    than with any event (ScheduleExpiryRecheck owns that case).
]]
local lastScrollExpiration = {}
local lastScrollConflict = {}
local scrollStateKnown = false

--[[
    Called from ns.ResetMacroState: a forced rebuild drops the baseline so the
    next aura event is treated as a change rather than compared against readings
    taken under the old settings.
]]
function ns.ResetScrollBuffTracking()
	wipe(lastScrollExpiration)
	wipe(lastScrollConflict)
	scrollStateKnown = false
end

--[[
    Records this pass's values and reports whether any moved. The loop always
    runs to completion -- returning early on the first difference would leave the
    remaining types holding stale values and report a phantom change next call.
]]
local function ScrollAurasChanged(currentSnapshot, scrollTypes)
	local changed = not scrollStateKnown
	scrollStateKnown = true

	for _, scrollType in ipairs(ns.SCROLL_CHECK_ORDER) do
		local entry = scrollTypes[scrollType] and currentSnapshot.scrolls[scrollType]
		local expiration = entry and entry.expiration or nil
		local conflictAmount = entry and entry.conflictAmount or nil
		if expiration ~= lastScrollExpiration[scrollType] or conflictAmount ~= lastScrollConflict[scrollType] then
			changed = true
		end
		lastScrollExpiration[scrollType] = expiration
		lastScrollConflict[scrollType] = conflictAmount
	end

	return changed
end

--[[
    UNIT_AURA handler routed from Core's dispatcher. One snapshot pass settles
    both player-side features, and each requests a rebuild only on a real change:
    Well Fed diffs its own state, scrolls diff the two inputs above. UNIT_AURA is
    a firehose and a rebuild is a full bag rescan, so an unconditional request
    here costs one of those per unrelated buff. The pet branch keeps its
    unconditional request: pet auras change rarely and carry no such traffic.
]]
function ns.HandleUnitAura(unit)
	local needsUpdate = false
	--[[
	    What made this firing worth acting on. UNIT_AURA is a firehose, so the
	    diagnostics capture tap can only count it -- it runs before this handler
	    and cannot yet know. This is the end that does know, so the signal
	    firings are logged from here (see ns.LogEventNow in
	    Features/Diagnostics.lua), which keeps the event log from disagreeing
	    with what the add-on actually reacted to.
	]]
	local reason

	if unit == "player" then
		local currentSnapshot = ns.GetPlayerBuffSnapshot()

		local wellFedState = WellFedFromSnapshot(currentSnapshot)
		if wellFedState ~= ns.WellFedState then
			ns.WellFedState = wellFedState
			needsUpdate = true
			reason = "wellfed"
		end

		local settings = ns.db and ns.db.profile
		if settings and settings.useScrolls and settings.scrollTypes then
			if ScrollAurasChanged(currentSnapshot, settings.scrollTypes) then
				needsUpdate = true
				reason = reason and (reason .. "+scrolls") or "scrolls"
			end
		end
	elseif unit == "pet" then
		if ns.db and ns.db.profile and ns.db.profile.usePetBuffFood then
			needsUpdate = true
			reason = "petbuff"
		end
	end

	if needsUpdate then
		if ns.LogEventNow then
			ns.LogEventNow("UNIT_AURA", unit, reason)
		end
		ns.RequestUpdate()
	end
end
