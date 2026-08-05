local _, ns = ...
local Config = ns.Config

--------------------------------------------------------------------------------
-- Hunter Tools
--------------------------------------------------------------------------------

--[[
    All hunter-specific logic lives here (organizing rule: see
    Tools-Mages.lua): pet-spell resolution, pet food scanning, the
    pet-buff-food override resolver, dead-pet handling, and the Feed Pet macro.

    Feed Pet is Hunter-only and owns its whole update cycle: knowledge tiers
    (print-only stub for pre-10 hunters, Mend-less cascade at 10-11, full
    cascade at 12+), pet-spell resolution, dead-pet detection, and its own
    macro state, all in this file. The definition at the bottom routes the
    engine's update to UpdateFeedPetMacro or removes the macro when disabled;
    for non-Hunters it does nothing at all.
]]

--------------------------------------------------------------------------------
-- Pet Spell Resolution
--------------------------------------------------------------------------------

--[[
    Resolves each pet spell's name only if the player actually knows the spell.
    GetSpellInfo returns a name even for unlearned spells, so a level-8 hunter
    without Mend Pet would otherwise get a macro referencing a spell they can't
    cast. Core re-runs this on PLAYER_LEVEL_UP and SPELLS_CHANGED so a
    newly-learned spell (Mend Pet at 12) starts participating without a /reload.
]]
local function ResolveIfKnown(spellID)
	local known = IsSpellKnown(spellID)
	if not known and IsPlayerSpell then
		known = IsPlayerSpell(spellID)
	end
	if known then
		return GetSpellInfo(spellID)
	end
	return nil
end

function ns.ResolveHunterSpells()
	if not ns.IsHunter then
		return
	end
	ns.FeedPetSpellName = ResolveIfKnown(ns.FEED_PET_SPELL_ID)
	ns.RevivePetSpellName = ResolveIfKnown(ns.REVIVE_PET_SPELL_ID)
	ns.MendPetSpellName = ResolveIfKnown(ns.MEND_PET_SPELL_ID)
	ns.CallPetSpellName = ResolveIfKnown(ns.CALL_PET_SPELL_ID)
	ns.DismissPetSpellName = ResolveIfKnown(ns.DISMISS_PET_SPELL_ID)
end

--------------------------------------------------------------------------------
-- Pet Food Scanning
--------------------------------------------------------------------------------

ns.BestPetFoodID = nil
ns.BestPetFoodLink = nil

--[[
    Builds a set of quest IDs the player currently has in their quest log.
    Used by ScanPetFood to skip foods that are objectives for active quests.
]]

local activeQuestIDs = {}

local function BuildActiveQuestSet()
	wipe(activeQuestIDs)
	for questIndex = 1, GetNumQuestLogEntries() do
		local _, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(questIndex)
		-- Include completed-but-not-turned-in quests too: turn-in still consumes the items.
		if not isHeader and questID then
			activeQuestIDs[questID] = true
		end
	end
end

local function IsNeededForQuest(questIDs)
	for _, questID in ipairs(questIDs) do
		if activeQuestIDs[questID] then
			return true
		end
	end
	return false
end

--[[
    Selects the lowest-itemLevel food that still gives maximum happiness
    (petLevel - foodItemLevel between 0 and 10). Ties broken by sell price
    (lower wins), then total count in bags (fewer wins).

    If no food sits in the max-happiness bracket, falls back to the food
    closest to (but above) the pet's level. Pets eat above-level food, just
    wastefully — better than letting the pet go hungry.

    Note: there is no upper cap on how far above pet level the fallback can
    reach. Confirmed empirically on Classic Era (1.15.x): a level-8 cat will
    happily eat level-70 meat. The fallback ranks by lowest food level first,
    so the *least* wasteful option still wins when multiple are available.

    All data (itemLevel, dietID, sellPrice, questIDs) comes from the stored
    ns.PetFoodData table. No server queries are needed during scanning.

    Quest objective foods are skipped whenever the player has that quest in
    their log (including completed-but-not-turned-in), since turn-in consumes
    the items.
]]

function ns.ScanPetFood()
	ns.BestPetFoodID = nil
	ns.BestPetFoodLink = nil

	if not ns.PetFoodData or not ns.PetDietMap then
		return
	end

	-- Must have a living pet out
	if not UnitExists("pet") or UnitIsDead("pet") or UnitIsGhost("pet") then
		return
	end

	local petLevel = UnitLevel("pet")
	if not petLevel or petLevel < 1 then
		return
	end

	-- Build a set of diet IDs the current pet accepts
	local petDiets = { GetPetFoodTypes() }
	if not petDiets or #petDiets == 0 then
		return
	end

	local dietSet = {}
	for _, dietName in ipairs(petDiets) do
		local dietID = ns.PetDietMap[dietName]
		if dietID then
			dietSet[dietID] = true
		end
	end

	-- Snapshot the player's active quests once per scan
	BuildActiveQuestSet()

	local ignoreList = (ns.db and ns.db.profile.ignoreList) or {}

	local bestID, bestLink
	local bestLevel = 999
	local bestPrice = 999999
	local bestCount = 999999

	--[[
        Wasteful fallback: pets will eat food above their level when no in-bracket
        option is available. Prefer the food closest to pet level (lowest waste).
    ]]
	local fallbackID, fallbackLink
	local fallbackLevel = 999
	local fallbackPrice = 999999
	local fallbackCount = 999999

	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, ns.GetContainerNumSlots(bag) do
			local info = ns.GetContainerItemInfo(bag, slot)
			if info and info.itemID then
				local id = info.itemID
				local foodData = ns.PetFoodData[id]

				if foodData and not ignoreList[id] then
					local foodLevel = foodData[1]
					local foodDiet = foodData[2]
					local sellPrice = foodData[3]
					local questIDs = foodData[4]

					if dietSet[foodDiet] then
						local levelDelta = petLevel - foodLevel
						local inHappyBracket = (levelDelta >= 0 and levelDelta <= 10)
						local isAbovePet = (levelDelta < 0)

						if inHappyBracket or isAbovePet then
							-- Skip foods needed for active quests
							local skipQuest = false
							if questIDs then
								skipQuest = IsNeededForQuest(questIDs)
							end

							if not skipQuest then
								local totalCount = ns.GetItemCount(id)

								if inHappyBracket then
									-- Prefer: lowest itemLevel, then lowest sell price, then fewest in bags
									local isBetter = false
									if not bestID then
										isBetter = true
									elseif foodLevel ~= bestLevel then
										isBetter = foodLevel < bestLevel
									elseif sellPrice ~= bestPrice then
										isBetter = sellPrice < bestPrice
									else
										isBetter = totalCount < bestCount
									end

									if isBetter then
										bestID = id
										bestLink = info.hyperlink
										bestLevel = foodLevel
										bestPrice = sellPrice
										bestCount = totalCount
									end
								else
									--[[
                                        Fallback (food above pet level). No upper cap:
                                        pets will eat food at any level higher than their
                                        own (confirmed: lvl-8 cat eats lvl-70 meat). Prefer
                                        closest to pet level (lowest), then cheapest, then
                                        fewest in bags.
                                    ]]
									local isBetter = false
									if not fallbackID then
										isBetter = true
									elseif foodLevel ~= fallbackLevel then
										isBetter = foodLevel < fallbackLevel
									elseif sellPrice ~= fallbackPrice then
										isBetter = sellPrice < fallbackPrice
									else
										isBetter = totalCount < fallbackCount
									end

									if isBetter then
										fallbackID = id
										fallbackLink = info.hyperlink
										fallbackLevel = foodLevel
										fallbackPrice = sellPrice
										fallbackCount = totalCount
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if bestID then
		ns.BestPetFoodID = bestID
		ns.BestPetFoodLink = bestLink
	else
		ns.BestPetFoodID = fallbackID
		ns.BestPetFoodLink = fallbackLink
	end
end

--------------------------------------------------------------------------------
-- Pet Buff Override
--------------------------------------------------------------------------------

-- Written by ScanBags on every rescan (forced nil in a PvP Arena); Food.lua's
-- macro hooks read it to splice the pet-buff-food line into the Food macro.
ns.PetBuffOverrideID = nil

--[[
    Returns the item ID of the pet food buff that should be used, or nil.
    Called by ScanBags with its per-scan bag item counts. The aura probe it
    consults, ns.HasPetFoodBuff, stays in Scanner-Character.lua: it shares
    that file's private early-reapply helper (BuffCountsAsActive) with the
    Well Fed and scroll probes.
]]
function ns.FindPetBuffOverride(bagItemCounts)
	--[[
        Feature toggle, group restriction, level, and a live pet all live in
        ns.ShouldTrackPetFood (Scanner-Character.lua) so the readiness report
        applies exactly the same gate.
    ]]
	if not ns.ShouldTrackPetFood() then
		return nil
	end

	if ns.HasPetFoodBuff() then
		return nil
	end

	local petTypes = ns.db.profile.petBuffTypes

	if
		petTypes.KiblersBits
		and bagItemCounts[ns.KIBLERS_BITS_ITEM_ID]
		and bagItemCounts[ns.KIBLERS_BITS_ITEM_ID] > 0
	then
		return ns.KIBLERS_BITS_ITEM_ID
	end

	if
		petTypes.SporelingSnacks
		and bagItemCounts[ns.SPORELING_SNACKS_ITEM_ID]
		and bagItemCounts[ns.SPORELING_SNACKS_ITEM_ID] > 0
	then
		return ns.SPORELING_SNACKS_ITEM_ID
	end

	return nil
end

--------------------------------------------------------------------------------
-- UI Error Handling (Hunter)
--------------------------------------------------------------------------------

--[[
    Detect a dead-but-dismissed pet. When Call Pet fails because the pet is
    dead, the client fires SPELL_FAILED_TARGETS_DEAD; we catch it and flip the
    flag so the macro rebuilds with Revive Pet on the next cycle. If the error
    ID changes in a future build, update this check. Core's dispatcher routes
    UI_ERROR_MESSAGE here ahead of its combat-lockdown guard, so this still
    fires mid-fight.
]]
function ns.HandleHunterPetError(msg)
	if not ns.IsHunter then
		return
	end
	if UnitExists("pet") or not msg then
		return
	end
	local deadMsg = SPELL_FAILED_TARGETS_DEAD
	if deadMsg and msg == deadMsg then
		ns.PetDeadDismissed = true
		ns.RequestUpdate()
	end
end

--------------------------------------------------------------------------------
-- Pet State Events (Hunter)
--------------------------------------------------------------------------------

--[[
    UNIT_PET handler routed from Core's dispatcher. When the player's pet
    appears or changes, clear the dead-dismissed flag so the Feed Pet macro
    stops offering Revive, then rebuild. The flag reset is Hunter-specific;
    the rebuild runs for every class the dispatcher forwards.
]]
function ns.HandlePetChanged(unit)
	if unit ~= "player" then
		return
	end
	if ns.IsHunter and UnitExists("pet") and not UnitIsDead("pet") then
		ns.PetDeadDismissed = false
	end
	ns.RequestUpdate()
end

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local currentPetFoodState = nil

function ns.ResetHunterMacroState()
	currentPetFoodState = nil
end

--------------------------------------------------------------------------------
-- Feed Pet Macro Body
--------------------------------------------------------------------------------

--[[
    Logic flow prioritizes modifier inputs first, then pet state, then combat.
    Combining conditions into bracket groups (e.g., [btn:2][combat]) keeps the
    body compact, but the cast cascade still names up to five client-localized
    spells, so a body that fits in enUS can exceed the 255-byte macro limit in
    multibyte locales: BuildFeedPetBody trims optional branches to fit (below).

    The macro adapts to which pet spells the hunter actually knows:
      Tier A (pre-10; any of Feed/Revive/
              Call/Dismiss Pet missing)  → print-only stub explaining the gap
      Tier B (10-11, no Mend Pet)        → full cascade minus Mend Pet, plus a
                                           click-time print on [btn:2][combat]
      Tier C (12+, every pet spell known) → full cascade as documented below

    Tier C modifier actions:
      [mod:ctrl]                 → Dismiss Pet
      [mod:shift] OR [@pet,dead] → Revive Pet
      [nopet]                    → Call Pet (or Revive Pet when dead-dismissed)
      [btn:2] OR [combat]        → Mend Pet
      default                    → Feed Pet + /use food
]]

--[[
    Trap: the client truncates a macro body at 255 bytes, and the trailing
    "/use item:" food line is the casualty, so a truncated body silently drops
    the feed. The Tier B/C cast cascade names up to five pet spells, and
    GetSpellInfo returns CLIENT-localized names, so a body that fits in enUS
    (Tier C is ~196 bytes) overflows in multibyte locales: ruRU pet-spell names
    run roughly double the byte cost and push Tier B/C past 300 bytes.

    Rule: assemble the full body, then while it exceeds 255 bytes shed the
    optional modifier conveniences in priority order, the [mod:ctrl] Dismiss
    shortcut first and then the [mod:shift]/[@pet,dead] Revive shortcut,
    rebuilding the matching /stopmacro set each time so it stays consistent with
    the branches that remain. The [nopet] summon, the [btn:2]/[combat] Mend
    branch, the default Feed, and the /use food line are never dropped, so the
    macro's core feed/summon behavior survives in every locale.
]]
local function ComposeFeedPetBody(tier, itemID, includeDismiss, includeRevive)
	local feedName = ns.FeedPetSpellName
	local reviveName = ns.RevivePetSpellName
	local callName = ns.CallPetSpellName
	local dismissName = ns.DismissPetSpellName
	local mendName = ns.MendPetSpellName -- nil in Tier B

	--[[
        When we know the pet is dead but dismissed, [nopet] uses Revive Pet
        instead of Call Pet so a single click revives without the user
        needing to remember the dead state.
    ]]
	local nopetSpell = (ns.PetDeadDismissed and reviveName) or callName

	--[[
        Modifier cascade. Tier C includes the Mend Pet branch on
        [btn:2][combat]; Tier B omits it (and we print a tip earlier in the
        macro to explain why right-click/combat does nothing useful). The
        Dismiss and Revive shortcuts are optional and are the first to be
        dropped when the body must shrink to fit the 255-byte limit.
    ]]
	local castClauses = {}
	if includeDismiss then
		castClauses[#castClauses + 1] = "[mod:ctrl] " .. dismissName
	end
	if includeRevive then
		castClauses[#castClauses + 1] = "[mod:shift][@pet,dead] " .. reviveName
	end
	castClauses[#castClauses + 1] = "[nopet] " .. nopetSpell
	if mendName then
		castClauses[#castClauses + 1] = "[btn:2][combat] " .. mendName
	end
	castClauses[#castClauses + 1] = feedName

	local lines = { "#showtooltip" }

	if tier == "B" then
		--[[
            Tier B: explain the missing Mend Pet on the inputs that would
            have used it, then halt before the Feed Pet cascade so we don't
            try to /cast Feed Pet in combat (it would fail) or on a
            right-click the user expected to mean Mend.
        ]]
		lines[#lines + 1] = '/run ConnIf("[btn:2][combat]","nomend")'
		lines[#lines + 1] = "/stopmacro [btn:2][combat]"
	end

	lines[#lines + 1] = "/cast " .. table.concat(castClauses, "; ")

	--[[
        Halt before /use when /cast dispatched to a non-Feed-Pet branch. Each
        guard token is present only while its branch is: [mod] covers the
        ctrl/shift shortcuts, [@pet,dead] the dead-pet auto-revive, and
        [btn:2]/[combat] the Mend branch (Tier C). Token order mirrors the
        original full-body set so an untrimmed body is byte-for-byte unchanged.
    ]]
	local stopTokens = {}
	if includeDismiss or includeRevive then
		stopTokens[#stopTokens + 1] = "[mod]"
	end
	if mendName then
		stopTokens[#stopTokens + 1] = "[btn:2]"
	end
	stopTokens[#stopTokens + 1] = "[nopet]"
	if includeRevive then
		stopTokens[#stopTokens + 1] = "[@pet,dead]"
	end
	if mendName then
		stopTokens[#stopTokens + 1] = "[combat]"
	end
	lines[#lines + 1] = "/stopmacro " .. table.concat(stopTokens, "")

	if itemID then
		lines[#lines + 1] = "/use item:" .. itemID
	else
		--[[
            No useful food in bags: clicking Feed Pet should explain that
            rather than silently doing nothing on the food line.
        ]]
		lines[#lines + 1] = '/run ConnTip("nofood")'
	end

	return table.concat(lines, "\n")
end

local function BuildFeedPetBody(tier, itemID)
	if tier == "A" then
		return table.concat({
			"#showtooltip",
			'/run ConnTip("noskills")',
		}, "\n")
	end

	--[[
        Full body first, then drop the Dismiss shortcut, then the Revive
        shortcut, stopping as soon as the body fits 255 bytes (see the note
        above ComposeFeedPetBody). #body is the byte length, matching the
        macro-limit trims in Engine.lua and Integration-Druid-Macro-Helper.lua.
    ]]
	local body = ComposeFeedPetBody(tier, itemID, true, true)
	if #body > 255 then
		body = ComposeFeedPetBody(tier, itemID, false, true)
	end
	if #body > 255 then
		body = ComposeFeedPetBody(tier, itemID, false, false)
	end
	return body
end

--------------------------------------------------------------------------------
-- Feed Pet Update
--------------------------------------------------------------------------------

local function UpdateFeedPetMacro(forced)
	if InCombatLockdown() then
		ns.RequestUpdate()
		return
	end

	if forced then
		currentPetFoodState = nil
	end

	ns.ScanPetFood()

	local config = Config["Feed Pet"]
	if not config then
		return
	end
	local macroName = config.macro
	local icon = ns.QUESTION_MARK_ICON

	--[[
        Knowledge tier drives the macro shape. The Tier B/C cast line
        concatenates Feed, Revive, Call, AND Dismiss Pet, so a missing name
        for any of them — not just Feed Pet — collapses to the print-only
        stub (Tier A). The four spells normally arrive together with the
        level-10 pet quests, but this also covers a hunter mid-quest-chain
        and any transient SPELLS_CHANGED timing where IsSpellKnown hasn't
        caught up; the next SPELLS_CHANGED rebuild promotes the tier. Mend
        Pet absence is the common transient state for a level-10/11 hunter
        who hasn't trained the level-12 spell yet.
    ]]
	local tier
	if not (ns.FeedPetSpellName and ns.RevivePetSpellName and ns.CallPetSpellName and ns.DismissPetSpellName) then
		tier = "A"
	elseif not ns.MendPetSpellName then
		tier = "B"
	else
		tier = "C"
	end

	--[[
        Tier A bypasses food entirely — the macro can't act on it without
        Feed Pet — so we don't encode itemID into the state. Tiers B and C
        both rely on the food line, so we include it.
    ]]
	local itemID = (tier ~= "A") and ns.BestPetFoodID or nil

	local stateID = tier
		.. "_"
		.. (itemID and tostring(itemID) or "none")
		.. "_"
		.. (ns.PetDeadDismissed and "DD" or "ND")

	if currentPetFoodState == stateID and not forced then
		return
	end

	local body = BuildFeedPetBody(tier, itemID)

	local index = GetMacroIndexByName(macroName)
	if index == 0 then
		-- On a failed create, leave the state unset so the next update retries.
		if not ns.TryCreateMacro(macroName, icon, body) then
			currentPetFoodState = nil
			return
		end
	else
		local existingBody = GetMacroBody(macroName)
		if existingBody ~= body then
			EditMacro(index, macroName, icon, body)
		end
	end

	currentPetFoodState = stateID
end

--------------------------------------------------------------------------------
-- Definition
--------------------------------------------------------------------------------

ns.RegisterMacroType({
	typeName = "Feed Pet",

	customUpdate = function(forced)
		if not ns.IsHunter then
			return
		end
		if ns.IsMacroEnabled("Feed Pet") then
			UpdateFeedPetMacro(forced)
		else
			local config = Config["Feed Pet"]
			if config then
				local index = GetMacroIndexByName(config.macro)
				if index and index > 0 then
					DeleteMacro(index)
				end
				ns.ResetHunterMacroState()
			end
		end
	end,
})
