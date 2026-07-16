local _, ns = ...

--[[
    Scanner-Character -- reads live player/pet state and decides which buffs the
    character still needs: profession skills, aura probes (Well Fed, scroll, and
    pet-food buffs), and the scroll override resolver.

    Exposes: ns.UpdateFirstAidSkill, ns.UpdateAlchemySkill,
    ns.UpdateEngineeringSkill, ns.CurrentFirstAidSkill,
    ns.CurrentAlchemySkill, ns.CurrentEngineeringSkill, ns.HasWellFedBuff,
    ns.HasScrollBuff, ns.HasPetFoodBuff, ns.FindScrollOverrides,
    ns.HandleUnitAura, ns.ScrollItemLookup, ns.ScrollOverrideIDs.
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
for scrollType, data in pairs(ns.ScrollData) do
	local buffIDs = {}
	for _, entry in ipairs(data.items) do
		ns.ScrollItemLookup[entry[1]] = scrollType
		buffIDs[entry[2]] = true
	end
	data.buffIDs = buffIDs
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
-- Well Fed
--------------------------------------------------------------------------------

function ns.HasWellFedBuff()
	local TARGET_ICON_ID = 136000
	local TARGET_ICON_ID_2 = 133943
	for i = 1, 40 do
		local name, icon, _, _, _, expirationTime, _, _, _, spellID = UnitAura("player", i, "HELPFUL")
		if not name then
			break
		end
		if icon == TARGET_ICON_ID or icon == TARGET_ICON_ID_2 then
			if BuffCountsAsActive(expirationTime) then
				return true
			end
		elseif ns.WellFedBuffIDs and ns.WellFedBuffIDs[spellID] then
			if BuffCountsAsActive(expirationTime) then
				return true
			end
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Scroll Buffs
--------------------------------------------------------------------------------

--[[
    A scroll buff of any rank counts as covered. A conflict spell (e.g. Fort)
    only counts as covered if its base amount is at least as large as the
    scroll we would use — otherwise the scroll would still improve the stat.
]]

function ns.HasScrollBuff(scrollType, scrollAmount)
	if not ns.ScrollData or not ns.ScrollData[scrollType] then
		return true
	end

	local data = ns.ScrollData[scrollType]

	-- Per-type buff-ID set, precomputed once in this file's Derived Scroll Lookups block
	local scrollBuffIDs = data.buffIDs

	for i = 1, 40 do
		local name, _, _, _, _, expirationTime, _, _, _, spellID = UnitAura("player", i, "HELPFUL")
		if not name then
			break
		end

		-- Already have a scroll buff active for this stat
		if scrollBuffIDs[spellID] and BuffCountsAsActive(expirationTime) then
			return true
		end

		--[[
            Check conflict spells — only block the scroll if the class buff
            provides at least as much stat as our best scroll would. Exempt
            from the early re-application threshold: a still-active stronger
            class buff cannot be overwritten, so treating it as expired would
            build a scroll line that errors on use.
        ]]
		local conflictAmount = data.conflictSpells[spellID]
		if conflictAmount and conflictAmount >= (scrollAmount or 0) then
			return true
		end
	end

	return false
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
		if entry[3] <= playerLevel then
			if bagItemCounts[entry[1]] and bagItemCounts[entry[1]] > 0 then
				return entry[1], entry[4]
			end
		end
	end

	return nil, nil
end

--[[
    Returns an ordered list of scroll item IDs the player should use, or nil
    if none apply. Order follows ns.SCROLL_CHECK_ORDER so the macro builder
    can use that priority when truncating to fit the 255-char macro limit.
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

	for _, scrollType in ipairs(ns.SCROLL_CHECK_ORDER) do
		if scrollTypes[scrollType] then
			local scrollItemID, scrollAmount = FindBestScroll(scrollType, bagItemCounts)
			if scrollItemID and not ns.HasScrollBuff(scrollType, scrollAmount) then
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

-- Consumed by ns.FindPetBuffOverride (Macros/Tools-Hunters.lua); the probe
-- lives here because BuffCountsAsActive is private to this file.
function ns.HasPetFoodBuff()
	if not UnitExists("pet") then
		return false
	end
	for i = 1, 40 do
		local name, _, _, _, _, expirationTime, _, _, _, spellID = UnitAura("pet", i, "HELPFUL")
		if not name then
			break
		end
		if spellID == ns.KIBLERS_BUFF_ID or spellID == ns.SPORELING_BUFF_ID then
			if BuffCountsAsActive(expirationTime) then
				return true
			end
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Aura Event Handler
--------------------------------------------------------------------------------

--[[
    UNIT_AURA handler routed from Core's dispatcher. Diffs the Well Fed state so
    a buff gain or loss triggers exactly one rebuild, and flags an update while
    scroll (player) or pet-buff (pet) tracking is active.
]]
function ns.HandleUnitAura(unit)
	local needsUpdate = false

	if unit == "player" then
		if ns.HasWellFedBuff then
			local currentState = ns.HasWellFedBuff()
			if currentState ~= ns.WellFedState then
				ns.WellFedState = currentState
				needsUpdate = true
			end
		end

		if ns.db and ns.db.profile and ns.db.profile.useScrolls then
			needsUpdate = true
		end
	elseif unit == "pet" then
		if ns.db and ns.db.profile and ns.db.profile.usePetBuffFood then
			needsUpdate = true
		end
	end

	if needsUpdate then
		ns.RequestUpdate()
	end
end
