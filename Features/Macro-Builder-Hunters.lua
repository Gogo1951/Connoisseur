local _, ns = ...
local Config = ns.Config

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local currentPetFoodState = nil

function ns.ResetHunterMacroState()
    currentPetFoodState = nil
end

--------------------------------------------------------------------------------
-- Feed Pet Macro (Hunter)
--------------------------------------------------------------------------------

--[[
    Logic flow prioritizes modifier inputs first, then pet state, then combat.
    By combining multiple conditions into bracket groups (e.g., [btn:2][combat]),
    we save a massive amount of string characters ensuring the macro stays well
    under the 255 character limit even in highly localized clients (German, etc).

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

local function BuildFeedPetBody(tier, itemID)
    if tier == "A" then
        return table.concat({
            "#showtooltip",
            '/run ConnTip("noskills")',
        }, "\n")
    end

    local feedName    = ns.FeedPetSpellName
    local reviveName  = ns.RevivePetSpellName
    local callName    = ns.CallPetSpellName
    local dismissName = ns.DismissPetSpellName
    local mendName    = ns.MendPetSpellName  -- nil in Tier B

    --[[
        When we know the pet is dead but dismissed, [nopet] uses Revive Pet
        instead of Call Pet so a single click revives without the user
        needing to remember the dead state.
    ]]
    local nopetSpell = (ns.PetDeadDismissed and reviveName) or callName

    --[[
        Modifier cascade. Tier C includes the Mend Pet branch on
        [btn:2][combat]; Tier B omits it (and we print a tip earlier in the
        macro to explain why right-click/combat does nothing useful).
    ]]
    local castLine = "/cast [mod:ctrl] " .. dismissName
        .. "; [mod:shift][@pet,dead] " .. reviveName
        .. "; [nopet] " .. nopetSpell
    if mendName then
        castLine = castLine .. "; [btn:2][combat] " .. mendName
    end
    castLine = castLine .. "; " .. feedName

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

    lines[#lines + 1] = castLine

    --[[
        Halt before /use when /cast dispatched to a non-Feed-Pet branch.
        Tier C still needs [btn:2][combat] in the stop set; Tier B already
        handled those above, so the post-cast stop only guards the
        modifier/no-pet/dead-pet dispatches.
    ]]
    local stopConditions = mendName
        and "[mod][btn:2][nopet][@pet,dead][combat]"
        or  "[mod][nopet][@pet,dead]"
    lines[#lines + 1] = "/stopmacro " .. stopConditions

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
