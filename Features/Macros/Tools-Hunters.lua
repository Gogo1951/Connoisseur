local _, ns = ...
local Config = ns.Config

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
    if not ns.IsHunter then return end
    ns.FeedPetSpellName = ResolveIfKnown(ns.FEED_PET_SPELL_ID)
    ns.RevivePetSpellName = ResolveIfKnown(ns.REVIVE_PET_SPELL_ID)
    ns.MendPetSpellName = ResolveIfKnown(ns.MEND_PET_SPELL_ID)
    ns.CallPetSpellName = ResolveIfKnown(ns.CALL_PET_SPELL_ID)
    ns.DismissPetSpellName = ResolveIfKnown(ns.DISMISS_PET_SPELL_ID)
end

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local currentPetFoodState = nil

function ns.ResetHunterMacroState()
    currentPetFoodState = nil
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
-- Feed Pet Macro (Hunter)
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
        macro-limit trims in Macro-Builder-General.lua and -Druids.lua.
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

function ns.UpdateFeedPetMacro(forced)
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
    if not (ns.FeedPetSpellName and ns.RevivePetSpellName
        and ns.CallPetSpellName and ns.DismissPetSpellName) then
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
        .. "_" .. (itemID and tostring(itemID) or "none")
        .. "_" .. (ns.PetDeadDismissed and "DD" or "ND")

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
