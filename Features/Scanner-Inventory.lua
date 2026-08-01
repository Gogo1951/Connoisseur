local _, ns = ...

--[[
    Scanner-Inventory -- scans the player's bags and selects the best item per
    macro category, applying scoring, ranking, and usability gates. WHAT each
    category consumes and HOW it scores is declared by the macro definitions
    themselves (itemTypes / accepts / score / ranked / ... — see the
    definition protocol in Features/Macros/Engine.lua); this file owns the
    shared machinery: the usability gates, the RANKING_PRIORITY tiebreak
    ladder, and the scan loop that dispatches each bag item to every matching
    definition.

    Exposes: ns.ScanBags, ns.AdjustedScore, ns.BestSelection, ns.BestFoodID,
    ns.BestFoodLink.
]]

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

ns.BestFoodID = nil
ns.BestFoodLink = nil

--------------------------------------------------------------------------------
-- Best Item Tracking
--------------------------------------------------------------------------------

--[[
    Per-category winner records and ranked-candidate lists, built from the
    definition registry (ns.RegisteredMacroDefs) instead of hardcoded here:
    every registered definition with an itemTypes set gets a winner record,
    and ranked definitions also get a topIDs list plus a candidate
    collector. Definitions register from Features/Macros/*.lua, which load
    after this file, so the tables are built lazily on the first scan
    (BuildSelectionTables below) — every scan happens long after load.
]]
local best = {}

--[[
    Expose the scanner's live best table for diagnostics. ScanBags resets and
    repopulates these entries in place every pass, so the reference always
    reflects the last scan. Read-only for consumers (Diagnostics' context
    report); the scanner itself owns all writes. This is what lets the context
    report show the per-category winner for every type, not just BestFoodID.
]]
ns.BestSelection = best

local rankedCandidates = {}

local function ResetBest(entry)
	entry.id = nil
	entry.value = 0
	entry.price = 0
	entry.count = 0
	entry.link = nil
	entry.isBuffFood = false
	entry.isPercent = false
	entry.isHybrid = false
	entry.isConjured = false
	if entry.topIDs then
		wipe(entry.topIDs)
	end
end

local selectionTablesBuilt = false

local function BuildSelectionTables()
	if selectionTablesBuilt then
		return
	end
	selectionTablesBuilt = true
	for _, def in ipairs(ns.RegisteredMacroDefs) do
		if def.itemTypes then
			local entry = {}
			if def.ranked then
				entry.topIDs = {}
				rankedCandidates[def.typeName] = {}
			end
			ResetBest(entry)
			best[def.typeName] = entry
		end
	end
end

--------------------------------------------------------------------------------
-- Adjusted Score (Potions & Bandages)
--------------------------------------------------------------------------------

--[[
    Layers two small priority bonuses onto the raw heal/mana value so the
    scoring still falls back to vendor price → count when items truly tie:

      +2 if the item is zone-restricted (data.zones present). The scanner has
         already gated on currentMap before this is called, so "has zones" at
         this point implies "usable here." Zone-locked consumables (Nethergon
         potions in Tempest Keep, BG-specific bandages, etc.) are worthless
         outside their zone, so we burn them first when we're inside.

      +1 if the item stacks above 10. Favors Healing/Mana Potion Injectors
         (stack 20) over the plain potions they are crafted from (stack 5):
         it preserves the reagent supply and frees bag space.

    The bonuses are intentionally tiny relative to typical heal values, so a
    stronger raw value still wins; the +1/+2 only matter when raw values tie.
]]

local function AdjustedScore(data, baseValue)
	local score = baseValue
	if data.zones then
		score = score + 2
	end
	if (data.maxStack or 1) > 10 then
		score = score + 1
	end
	return score
end
-- Exposed for the definitions' score() hooks (Bandage, Health/Mana Potion).
ns.AdjustedScore = AdjustedScore

--------------------------------------------------------------------------------
-- Comparison Logic
--------------------------------------------------------------------------------

--[[
    RANKING_PRIORITY is the single source of truth for how consumables are
    ranked. Both comparator forms — IsBetter's single-winner test and the
    ranked lists' pairwise sort (CompareRankedCandidates) — are generated from
    this one ordered list by CompareRecords, so reordering a step here is the
    only edit needed to change the ranking everywhere.

    Step shape:
      field — record field to compare
      kind  — "bool" (truthy side wins), "higher", or "lower"
      gatedOnAllowBuffFood       — step runs only when the caller allows buff
                                   food (the Food macro path)
      truthyWinsWhenPreferHybrid — direction flag for the hybrid step: truthy
                                   wins when the caller prefers hybrids (Food);
                                   falsy wins otherwise (Water, ranked potions)

    Boolean fields are compared RAW (~=), never coerced: winner entries store
    e.g. `data.isBuffFood` unnormalized, so nil-vs-false pairs occur in
    practice, count as a difference, and decide the step — that outcome is
    part of the long-standing observed ordering and must not change.
]]

local RANKING_PRIORITY = {
	-- Buff food first when the Food macro wants one.
	{ field = "isBuffFood", kind = "bool", gatedOnAllowBuffFood = true },

	-- Percent-based restores beat flat values.
	{ field = "isPercent", kind = "bool" },

	-- Higher restore/damage score (AdjustedScore bonuses included).
	{ field = "value", kind = "higher" },

	--[[
        Conjured food/water beats a non-conjured item of equal restore value.
        A mage's conjured ration is free and infinite, so at equal food/mana
        it should always be the pick rather than burning a purchased, quested,
        or arena-only drink. Below value (a higher-value item still wins) and
        above price so the preference is deterministic instead of falling
        through to the incidental price/count/itemID tiebreaks. isConjured is
        false for every non-food/water type, so this is a no-op for potions,
        stones, gems, and bandages.
    ]]
	{ field = "isConjured", kind = "bool" },

	-- Cheaper wins.
	{ field = "price", kind = "lower" },

	-- Hybrid food/water: the Food macro prefers hybrids; Water and the
	-- ranked potion lists prefer dedicated items.
	{ field = "isHybrid", kind = "bool", truthyWinsWhenPreferHybrid = true },

	-- Fewer copies in bags: burn the smaller pile first.
	{ field = "count", kind = "lower" },

	--[[
        Final, never-equal tiebreak. Without it, two items that match on every
        other field compare equal, so the winner is whichever the pairs() scan
        over slotItems happened to reach first. That order is not stable
        between an in-session rescan (a wiped-and-rebuilt table) and a fresh
        table after /reload, so the selection could flip for identical bags —
        the item would only "update" after a reload. Comparing itemID last
        makes the pick deterministic, so a buy-triggered rescan and a reload
        always agree; it also keeps table.sort's instability from reordering
        equal ranks between scans and churning macro rewrites.
    ]]
	{ field = "id", kind = "lower" },
}

--[[
    Returns true when record `a` outranks record `b` under RANKING_PRIORITY,
    plus the field name of the step that decided it (nil when every step
    compared equal). Only the diagnostics Selection Report reads the second
    value -- it is what turns "this item lost" into "it lost on price" -- and
    returning it costs nothing on the hot path, but every other caller must
    take the first value alone so the extra return can never leak into a
    boolean or a table constructor.
]]
local function CompareRecords(a, b, allowBuffFood, preferHybrid)
	for i = 1, #RANKING_PRIORITY do
		local step = RANKING_PRIORITY[i]
		if not (step.gatedOnAllowBuffFood and not allowBuffFood) then
			local av, bv = a[step.field], b[step.field]
			if av ~= bv then
				if step.kind == "higher" then
					return av > bv, step.field
				elseif step.kind == "lower" then
					return av < bv, step.field
				elseif step.truthyWinsWhenPreferHybrid and not preferHybrid then
					return not av, step.field
				else
					return (av and true or false), step.field
				end
			end
		end
	end
	return false, nil
end

--[[
    Single-winner form: does this bag item beat the current best entry?
    The candidate's fields are normalized into a reusable scratch record —
    score arrives as a parameter because the call sites pass AdjustedScore or
    a raw restore value, and hybrid is derived from the restore values exactly
    as before — so CompareRecords reads both sides through the same field
    names. Best entries already use these names (see ResetBest).
]]
local candidateRecord = {}

--[[
    Normalizes a bag item into the field names CompareRecords reads. Split out
    so the diagnostics retention below compares exactly the record the
    selection itself compared, rather than a second reading of the same item.
]]
local function FillCandidateRecord(record, candidate, candidateCount, candidatePrice, score)
	record.isBuffFood = candidate.isBuffFood
	record.isPercent = candidate.isPercent
	record.value = score
	record.isConjured = candidate.isConjured
	record.price = candidatePrice
	record.isHybrid = (candidate.healthValue > 0 and candidate.manaValue > 0)
	record.count = candidateCount
	record.id = candidate.id
	return record
end

local function IsBetter(candidate, candidateCount, candidatePrice, currentBest, score, allowBuffFood, preferHybrid)
	if not currentBest.id then
		return true
	end

	-- First value only: CompareRecords also returns the deciding field.
	local better = CompareRecords(
		FillCandidateRecord(candidateRecord, candidate, candidateCount, candidatePrice, score),
		currentBest,
		allowBuffFood,
		preferHybrid
	)
	return better
end

--------------------------------------------------------------------------------
-- Ranked Candidates (Multi-Use Macros)
--------------------------------------------------------------------------------

--[[
    The ranked definitions (ranked = true — the ns.MultiUseMacroTypes
    categories) stack up to ns.MULTI_USE_MAX_ITEMS /use lines per macro, so
    instead of tracking a single running winner they collect every usable
    candidate during the scan into rankedCandidates (declared above, keyed
    by typeName from the registry) and are ranked once it completes. The
    other categories keep the single-winner IsBetter path.
]]

local function AddRankedCandidate(typeName, id, data, score, count)
	local list = rankedCandidates[typeName]
	list[#list + 1] = {
		id = id,
		value = score,
		price = data.price,
		count = count,
		isPercent = data.isPercent or false,
		isHybrid = (data.healthValue > 0 and data.manaValue > 0),
	}
end

--[[
    Pairwise sort form for the ranked categories — the same RANKING_PRIORITY
    chain with allowBuffFood and preferHybrid always false: percent heals
    first, then higher score, lower price, non-hybrid, fewer copies, itemID.
    Ranked records carry no isBuffFood/isConjured fields, so those steps
    compare nil-to-nil and pass through.
]]
local function CompareRankedCandidates(a, b)
	-- First value only: table.sort must see a plain boolean comparator.
	local outranks = CompareRecords(a, b, false, false)
	return outranks
end

local function RankCandidates()
	for typeName, list in pairs(rankedCandidates) do
		table.sort(list, CompareRankedCandidates)

		local entry = best[typeName]
		local winner = list[1]
		if winner then
			entry.id = winner.id
			entry.value = winner.value
			entry.price = winner.price
			entry.count = winner.count
		end
		for rank = 1, math.min(#list, ns.MULTI_USE_MAX_ITEMS) do
			entry.topIDs[rank] = list[rank].id
		end
	end
end

--------------------------------------------------------------------------------
-- Diagnostic Candidate Retention
--------------------------------------------------------------------------------

--[[
    Feeds the Diagnostic Tools Selection Report, which answers "why that item
    and not this one." Every category keeps its top few candidates with the
    RANKING_PRIORITY step that separated each from the winner.

    Retention runs only while ns.diagnostics.enabled is true, so normal play
    pays one boolean test per candidate and nothing else. The table is runtime
    only: it hangs off ns, is wiped at the start of every scan, and is never
    declared in the defaults or written to SavedVariables.

    Ranked categories need no retention of their own -- RankCandidates already
    sorts their full candidate list into final order, so the runners-up are the
    entries below the winner and CaptureDiagnosticCandidates just copies them.
    Only the single-winner categories, which keep no list, retain as they scan.

    One invariant this leans on: retention ranks candidates against each other,
    while the selection ranks each candidate against the winner record in
    `best`. The two agree only because every category whose isBuffFood /
    isPercent / isHybrid / isConjured can actually vary (Food and Water) copies
    those onto the winner through winnerExtras, and they are constant-false for
    every other category's item types. A future single-winner category with a
    varying flag and no winnerExtras would surface here as a runner-up ranked
    above the winner -- which is a real selection bug, not a reporting one.
]]
local DIAGNOSTIC_CANDIDATE_LIMIT = 5

local diagnosticCandidates = {}
ns.DiagnosticCandidates = diagnosticCandidates

local function CopyCandidateRecord(record)
	return {
		id = record.id,
		value = record.value,
		price = record.price,
		count = record.count,
		isBuffFood = record.isBuffFood,
		isPercent = record.isPercent,
		isConjured = record.isConjured,
		isHybrid = record.isHybrid,
	}
end

local function GetCandidateList(typeName)
	local list = diagnosticCandidates[typeName]
	if not list then
		list = {}
		diagnosticCandidates[typeName] = list
	end
	return list
end

--[[
    Ordered insert capped at DIAGNOSTIC_CANDIDATE_LIMIT, ranked by the same
    comparator the selection ran, so entry 1 is always the category's winner
    and the entries below it are the real runners-up rather than whichever
    items the bag walk happened to reach first.
]]
local function RetainCandidate(typeName, record, allowBuffFood, preferHybrid)
	local list = GetCandidateList(typeName)

	local position = #list + 1
	for i = 1, #list do
		local outranks = CompareRecords(record, list[i], allowBuffFood, preferHybrid)
		if outranks then
			position = i
			break
		end
	end

	if position > DIAGNOSTIC_CANDIDATE_LIMIT then
		return
	end

	table.insert(list, position, CopyCandidateRecord(record))
	list[DIAGNOSTIC_CANDIDATE_LIMIT + 1] = nil
end

--[[
    Runs once per scan, after RankCandidates has settled the ranked lists:
    copies the ranked categories' runners-up, then annotates every retained
    runner-up with the step that separated it from its category's winner.
    Ranked categories always compare with buff food and hybrid preference off,
    matching CompareRankedCandidates.
]]
local function CaptureDiagnosticCandidates()
	if not ns.diagnostics.enabled then
		return
	end

	for _, def in ipairs(ns.RegisteredMacroDefs) do
		local list
		local allowBuffFood, preferHybrid

		if def.ranked then
			local source = rankedCandidates[def.typeName]
			list = GetCandidateList(def.typeName)
			for i = 1, math.min(#source, DIAGNOSTIC_CANDIDATE_LIMIT) do
				list[i] = CopyCandidateRecord(source[i])
			end
			allowBuffFood, preferHybrid = false, false
		else
			list = diagnosticCandidates[def.typeName]
			allowBuffFood = def.allowBuffFood and ns.AllowBuffFood
			preferHybrid = def.preferHybrid
		end

		if list then
			local winner = list[1]
			for i = 2, #list do
				local _, decidedBy = CompareRecords(winner, list[i], allowBuffFood, preferHybrid)
				list[i].decidedBy = decidedBy
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Bag Scanning
--------------------------------------------------------------------------------

local itemCounts = {}
local slotItems = {}

function ns.ScanBags()
	--[[
        Refresh the zone at scan time. A zone change during combat is gated out
        by the lockdown guard in Core's dispatcher, so ZONE_CHANGED_NEW_AREA
        never updates the cache mid-fight; reading it here keeps zone-restricted
        item filtering from running against a stale map after combat drops.
    ]]
	ns.CachedMapID = C_Map.GetBestMapForUnit("player")

	--[[
        Party/raid-restricted Buff Food, Scrolls, and Pet Food go stale when
        group composition or the mode dropdown changes — those flip whether a
        feature is active but have no dedicated UpdateAuraTracking call, so
        ns.WellFedState and UNIT_AURA registration would otherwise drift.
        ScanBags is the single point every rescan passes through, so reconcile
        aura tracking here, before AllowBuffFood reads ns.WellFedState below.
    ]]
	if ns.UpdateAuraTracking then
		ns.UpdateAuraTracking()
	end

	local playerLevel = ns.CachedPlayerLevel
	local currentMap = ns.CachedMapID
	--[[
        Arena-only consumables (e.g. Star's Tears) are gated on the live
        instance type instead of a zone-ID list, so every arena is covered with
        no map IDs to maintain. IsInInstance is safe on Era (returns "none").
        ScanBags re-runs on PLAYER_ENTERING_WORLD and ZONE_CHANGED_NEW_AREA, so
        this refreshes on every arena entry and exit.
    ]]
	local inArena = select(2, IsInInstance()) == "arena"
	local firstAidSkill = ns.CurrentFirstAidSkill or 0
	local alchemySkill = ns.CurrentAlchemySkill or 0
	local engineeringSkill = ns.CurrentEngineeringSkill or 0
	local settings = (ns.db and ns.db.profile) or {}
	local itemCache = (ns.db and ns.db.profile.itemCache) or {}

	--[[
        Testing aid: targeting yourself forces the Food macro into plain-food
        mode — no scrolls, no buff food, just the best non-buff food. Useful
        for verifying what the macro picks without re-toggling settings.
        Scrolls are already suppressed on any friendly-player target (including
        self) in UpdateMacros, so we only need to disable buff-food here.
    ]]
	local targetingSelf = UnitExists("target") and UnitIsUnit("target", "player")

	--[[
        Arena rule: scrolls, pet buff food, and buff food cannot be consumed in
        a PvP Arena, so the Food macro must stay in plain (non-buff) food mode
        there. Buff-food preference is gated here; the scroll and pet-buff
        override resolvers are gated below.
    ]]
	ns.AllowBuffFood = settings.useBuffFood
		and ns.IsModeActive(settings.buffFoodMode)
		and not ns.WellFedState
		and not targetingSelf
		and not inArena

	BuildSelectionTables()

	for _, entry in pairs(best) do
		ResetBest(entry)
	end

	for _, list in pairs(rankedCandidates) do
		wipe(list)
	end

	--[[
	    Wiped unconditionally, not just while diagnostics are enabled, so
	    turning the panel off leaves no stale candidate list behind for the
	    next report to present as current.
	]]
	for _, list in pairs(diagnosticCandidates) do
		wipe(list)
	end

	local dataRetry = false
	wipe(itemCounts)
	wipe(slotItems)

	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, ns.GetContainerNumSlots(bag) do
			local info = ns.GetContainerItemInfo(bag, slot)
			if info and info.itemID then
				local id = info.itemID
				itemCounts[id] = (itemCounts[id] or 0) + info.stackCount
				if not slotItems[id] then
					slotItems[id] = info.hyperlink
				end
			end
		end
	end

	--[[
        Overrides check happens before standard consumable scan. Skipped
        entirely in a PvP Arena (see the arena rule above): scroll mode and pet
        buff food can't be used there, so both stay nil and the Food macro keeps
        its plain food/conjure form.
    ]]
	if inArena then
		ns.ScrollOverrideIDs = nil
		ns.PetBuffOverrideID = nil
	else
		ns.ScrollOverrideIDs = ns.FindScrollOverrides(itemCounts)
		ns.PetBuffOverrideID = ns.FindPetBuffOverride(itemCounts)
	end

	local ignoreList = (ns.db and ns.db.profile.ignoreList) or {}

	for id, hyperlink in pairs(slotItems) do
		if not ignoreList[id] then
			-- Skip scroll items from normal consumable processing
			if ns.ScrollItemLookup and ns.ScrollItemLookup[id] then
				-- Scrolls are handled by the scroll override system
			else
				local data = itemCache[id]
				--[[
                    Drop cache entries from an older schema so CacheItemData
                    re-derives them below. Test the NEWEST cached field, not an
                    old one: version-stamp invalidation only fires on a release
                    bump, so a same-version update (dev edit) that adds a field
                    would otherwise keep stale entries missing it. The newest
                    field is damageValue (CacheItemData always writes it);
                    the older fields are kept in the test to also catch
                    pre-maxStack/-arenaUsable/-isConjured entries.
                ]]
				if
					data
					and data ~= "IGNORE"
					and (
						data.maxStack == nil
						or data.arenaUsable == nil
						or data.isConjured == nil
						or data.damageValue == nil
					)
				then
					data = nil
					itemCache[id] = nil
				end
				if not data then
					data = ns.CacheItemData(id)
				end

				if not data then
					dataRetry = true
				elseif data ~= "IGNORE" then
					local usable = true

					if data.requiredLevel > playerLevel then
						usable = false
					end

					if usable and data.requiredFirstAid > 0 and data.requiredFirstAid > firstAidSkill then
						usable = false
					end

					if usable and (data.requiredAlchemy or 0) > 0 and (data.requiredAlchemy or 0) > alchemySkill then
						usable = false
					end

					if
						usable
						and (data.requiredEngineering or 0) > 0
						and (data.requiredEngineering or 0) > engineeringSkill
					then
						usable = false
					end

					--[[
                        Engineering specialization gate (Global Thermal Sapper
                        Charge requires Goblin Engineer). Checked live rather
                        than cached at login because the specialization can be
                        learned mid-session; SPELLS_CHANGED triggers the rescan.
                        Same IsSpellKnown + IsPlayerSpell fallback as
                        GetSmartSpell — profession passives can live on either
                        surface depending on client.
                    ]]
					if usable and data.requiredSpellID then
						local known = IsSpellKnown(data.requiredSpellID)
						if not known and IsPlayerSpell then
							known = IsPlayerSpell(data.requiredSpellID)
						end
						if not known then
							usable = false
						end
					end

					if usable and data.zones then
						usable = (currentMap ~= nil) and (data.zones[currentMap] == true)
					end

					if usable and data.arenaOnly and not inArena then
						usable = false
					end

					--[[
                        In a PvP Arena only conjured food/water and the arena-only
                        drinks (Star's Tears/Lament) can be consumed -- regular
                        food and drink are blocked. Gate the rest out so the macro
                        never selects a drink that fails on press in the arena.
                        Ranking within what survives is unchanged (highest value,
                        then price, then count).
                    ]]
					if usable and inArena then
						local t = data.itemType
						local isFoodOrWater = (t == "food" or t == "water" or t == "foodwater")
						if isFoodOrWater and not data.arenaUsable then
							usable = false
						end
					end

					if usable then
						local totalCount = itemCounts[id]

						--[[
                            Dispatch the item to every registered definition
                            whose itemTypes set claims its cached itemType.
                            Deliberately not first-match-wins: more than one
                            category may consume the same item — a potion
                            with both health and mana values feeds Health
                            Potion and Mana Potion, and a foodwater hybrid
                            feeds Food and Water.
                        ]]
						for _, def in ipairs(ns.RegisteredMacroDefs) do
							if
								def.itemTypes
								and def.itemTypes[data.itemType]
								and (not def.accepts or def.accepts(data))
							then
								local score = def.score(data)
								if def.ranked then
									AddRankedCandidate(def.typeName, id, data, score, totalCount)
								else
									local entry = best[def.typeName]
									-- allowBuffFood defs track the live scan
									-- preference; everyone else compares with
									-- the buff-food step gated off.
									local allowBuffFood = def.allowBuffFood and ns.AllowBuffFood
									if
										IsBetter(
											data,
											totalCount,
											data.price,
											entry,
											score,
											allowBuffFood,
											def.preferHybrid
										)
									then
										entry.id = id
										entry.value = score
										entry.price = data.price
										entry.count = totalCount
										if def.winnerExtras then
											def.winnerExtras(entry, data, hyperlink)
										end
									end

									if ns.diagnostics.enabled then
										RetainCandidate(
											def.typeName,
											FillCandidateRecord(candidateRecord, data, totalCount, data.price, score),
											allowBuffFood,
											def.preferHybrid
										)
									end
								end
							end
						end
					end
				end
			end
		end
	end

	RankCandidates()
	CaptureDiagnosticCandidates()

	ns.BestFoodID = best["Food"].id
	ns.BestFoodLink = best["Food"].link

	return best, dataRetry
end
