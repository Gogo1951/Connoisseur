local _, ns = ...
local L = ns.L
local Config = ns.Config

--[[
    The macro-callback globals (ConnFire, ConnTip, ConnIf, ConnNoItem) and the
    ConnoisseurState transport live in Features/Macro-Runtime.lua, which loads
    before this file. This file emits the `/run Conn...` lines that invoke them.
]]

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local currentMacroState = {}

--------------------------------------------------------------------------------
-- Conjure Resolver Registry
--------------------------------------------------------------------------------

--[[
    Class-specific macro builder files register entries here, keyed by
    macro typeName ("Water", "Food", "Mana Gem", "Healthstone", "Soulstone").
    Each entry is a function returning a table:

      {
        rightName, rightID,    -- /cast spell on [btn:2] (or nil)
        middleName, middleID,  -- /cast spell on [btn:3] (or nil)
        rightMiss,             -- ConnTip key to fire on [btn:2] when right
                                  is not yet learned (or nil)
        middleMiss,            -- ConnTip key to fire on [btn:3] when middle
                                  is not yet learned (or nil)
        noItemMiss,            -- ConnTip key to fire on left-click when there
                                  is no item to /use AND the class can learn
                                  the conjure (replaces the generic no-item
                                  message). (or nil)
      }

    Returning nil from the resolver means "no conjure semantics for this
    macro type for this player" — leave the macro body as plain /use item.
]]
ns.ConjureResolvers = ns.ConjureResolvers or {}

--------------------------------------------------------------------------------
-- Target Helpers
--------------------------------------------------------------------------------

--[[
    Single source of truth for "is the current target a friendly player." Used
    by both GetSmartSpell (for conjure rank downranking) and the scroll block
    builder (which drops scrolls so a Mage can right-click to conjure food
    for a friend without firing scrolls on themselves).
]]
local function HasFriendlyPlayerTarget()
    return UnitExists("target") and UnitIsFriend("player", "target") and UnitIsPlayer("target")
end
ns.HasFriendlyPlayerTarget = HasFriendlyPlayerTarget

--------------------------------------------------------------------------------
-- Smart Spell Resolution
--------------------------------------------------------------------------------

--[[
    Picks the highest-rank spell the player knows that the target (or player)
    can still receive. Targeting a friendly player of lower level drops the
    rank down so the conjured item matches their level cap.
]]
function ns.GetSmartSpell(spellList, ignoreTarget, checkUnique)
    if not spellList then
        return nil, 0
    end

    local levelCap = UnitLevel("player")

    if not ignoreTarget and HasFriendlyPlayerTarget() then
        local targetLevel = UnitLevel("target")
        if targetLevel > 0 then
            levelCap = targetLevel
        end
    end

    for _, data in ipairs(spellList) do
        local spellID, requiredLevel, rankNumber = data[1], data[2], data[3]

        local known = IsSpellKnown(spellID)
        if not known and IsPlayerSpell then
            known = IsPlayerSpell(spellID)
        end

        if known and requiredLevel <= levelCap then
            local shouldSkip = false

            local conjuredItems = checkUnique and ns.ConjuredItemIDsBySpell and ns.ConjuredItemIDsBySpell[spellID]
            if conjuredItems then
                for _, conjuredItemID in ipairs(conjuredItems) do
                    if ns.GetItemCount(conjuredItemID) > 0 then
                        shouldSkip = true
                        break
                    end
                end
            end

            if not shouldSkip then
                local spellName = GetSpellInfo(spellID)
                if spellName then
                    if rankNumber then
                        return spellName .. "(" .. L["RANK"] .. " " .. rankNumber .. ")", spellID
                    end
                    return spellName, spellID
                end
            end
        end
    end

    --[[
        Fallback when no rank matched the level cap (targeting a low-level
        friend): walk the list bottom-up and use the lowest rank the player
        actually KNOWS. Players can skip training low ranks, so the list's
        last entry may be untrained — and /cast of an untrained spell is a
        silent no-op that would make the conjure click look broken. Knows
        nothing at all → nil, 0, same as an empty list.
    ]]
    for i = #spellList, 1, -1 do
        local spellID, rankNumber = spellList[i][1], spellList[i][3]

        local known = IsSpellKnown(spellID)
        if not known and IsPlayerSpell then
            known = IsPlayerSpell(spellID)
        end

        if known then
            local fallbackName = GetSpellInfo(spellID)
            if fallbackName then
                if rankNumber then
                    return fallbackName .. "(" .. L["RANK"] .. " " .. rankNumber .. ")", spellID
                end
                return fallbackName, spellID
            end
        end
    end

    return nil, 0
end

--------------------------------------------------------------------------------
-- Shadowmeld Suffix
--------------------------------------------------------------------------------

local function ShouldAppendShadowmeld(typeName)
    if typeName ~= "Water" then
        return false
    end
    if not ns.IsNightElf then
        return false
    end
    local settings = ConnoisseurCharDB and ConnoisseurCharDB.settings
    if not settings or not settings.enableShadowmeldDrinking then
        return false
    end
    return ns.ShadowmeldSpellName ~= nil
end

--[[
    Healthstone stacking opt-in. When on, the Health Potion macro gets the
    best Healthstone's ranked /use lines appended below the potion lines —
    potions and healthstones live in separate cooldown categories, so one
    press fires one of each.
]]
local function ShouldStackHealthstones()
    local settings = ConnoisseurCharDB and ConnoisseurCharDB.settings
    return settings and settings.combineHealthstones and true or false
end

--------------------------------------------------------------------------------
-- Macro Enablement
--------------------------------------------------------------------------------

function ns.IsMacroEnabled(typeName)
    local enabled = ConnoisseurDB and ConnoisseurDB.enabledMacros
    if not enabled then
        return true
    end
    return enabled[typeName] ~= false
end

local function DeleteMacroIfExists(macroName, typeName)
    local index = GetMacroIndexByName(macroName)
    if index and index > 0 then
        DeleteMacro(index)
    end
    currentMacroState[typeName] = nil
end

--------------------------------------------------------------------------------
-- Macro Writing
--------------------------------------------------------------------------------

--[[
    CreateMacro wrapper, shared with the Hunter builder. The perCharacter
    argument is deliberately omitted: Connoisseur macros always live in
    the General (account-wide) tab. All characters share the same nine
    slots, and each character's first update pass after login rewrites
    the shared bodies to its own best items, so the macros self-heal on
    every character switch.

    Do NOT pass a numeric 1 here to "mean" General — this client
    boolean-checks the argument (verified in-game: true lands in the
    character-specific tab, 1 lands in General), so a number only
    produces a General macro by accident and would silently flip tabs if
    a future build starts accepting numbers as true. Omitting the
    argument is the unambiguous spelling of "General tab" on every
    client.

    Creation is skipped entirely when it would dip into the player's last
    ns.MACRO_SLOT_CUSHION free General slots — those stay reserved for
    the player's own macros. pcall plus the nil-check still covers both
    failure modes of a truly full macro book (some client builds raise an
    error, others return nil), in case another addon races us past the
    cushion. Either way the warning prints once per session, and callers
    leave their state key unset on failure so creation retries — and
    resumes automatically — once slots free up.
]]
local macroSlotsWarned = false

local function WarnMacroSlots()
    if not macroSlotsWarned then
        macroSlotsWarned = true
        ns.PrintMessage(L["MSG_MACRO_SLOTS_FULL"])
    end
end

function ns.TryCreateMacro(macroName, icon, body)
    local numGeneral = GetNumMacros()
    local cap = MAX_ACCOUNT_MACROS or 120
    if (cap - numGeneral) <= ns.MACRO_SLOT_CUSHION then
        WarnMacroSlots()
        return false
    end

    local ok, newIndex = pcall(CreateMacro, macroName, icon, body)
    if ok and newIndex then
        return true
    end
    WarnMacroSlots()
    return false
end

local function WriteMacro(macroName, icon, body, stateKey, typeName)
    local index = GetMacroIndexByName(macroName)
    if index == 0 then
        --[[
            On a failed create, leave the state key unset so the next
            update cycle retries — the macro then appears automatically
            once the player frees a slot, no /reload needed.
        ]]
        if not ns.TryCreateMacro(macroName, icon, body) then
            currentMacroState[typeName] = nil
            return
        end
    else
        local existingBody = GetMacroBody(macroName)
        if existingBody ~= body then
            EditMacro(index, macroName, icon, body)
        end
    end
    currentMacroState[typeName] = stateKey
end

--[[
    Builds the line that records macro-fire context to ConnoisseurState via
    the global helper defined at the top of this file. The Core UI_ERROR_MESSAGE handler
    reads lastID and lastTime to correlate a zone-restriction error with the
    item that triggered it.

    Using the global helper instead of an inline /run snippet keeps the macro
    body short — important for the Food macro when stacking scroll uses
    against the 255-character limit. The helper name is deliberately short
    but distinctive (Conn... prefix) to minimize collision risk with other
    addons while saving characters in every consumable macro.
]]
local function StateWriteLine(itemID)
    return "/run ConnFire(" .. itemID .. ")\n"
end

--[[
    Builds the stacked /use block for a multi-use macro type
    (ns.MultiUseMacroTypes): one line per ranked item, best first. Items
    within each such category share an item cooldown, so a press consumes
    exactly one item — the first /use whose item is in bags fires and its
    cooldown blocks the rest. The extra lines exist for combat, where
    macros cannot be rewritten: once the best item is depleted its line
    becomes a silent no-op and the press falls through to the next-best
    item. On presses where the first line fires, the blocked lines emit a
    harmless "Item is not ready yet" UI error.
]]
local function BuildUseBlock(useIDs)
    local lines = {}
    for _, id in ipairs(useIDs) do
        lines[#lines + 1] = "/use item:" .. id
    end
    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Scroll-Only Macro Body
--------------------------------------------------------------------------------

--[[
    When the player has missing scroll buffs and is not targeting a friendly
    player, the Food macro becomes a dedicated scroll-fire macro. The body
    is just `#showtooltip` plus one /use [@player] item:NNN line per scroll
    in ns.SCROLL_CHECK_ORDER priority. No food, no conjure, no state-write —
    the user taps once to apply scrolls; the next tap (with all scrolls
    applied) sees the macro flip back to its normal food form.

    Bare `#showtooltip` lets the action bar resolve the icon from the first
    usable line — the first scroll — which is exactly what the user should
    see when the button is about to fire scrolls.

    All scrolls fit comfortably under WoW's 255-char macro limit: 14 chars
    for the tooltip line + at most 6 scrolls × ~25 chars ≈ 164 chars.
]]
local function BuildScrollOnlyBody(scrollList)
    local lines = {"#showtooltip"}
    for _, scrollID in ipairs(scrollList) do
        lines[#lines + 1] = "/use [@player] item:" .. scrollID
    end
    return table.concat(lines, "\n") .. "\n"
end

--------------------------------------------------------------------------------
-- Conjure Block Builder
--------------------------------------------------------------------------------

--[[
    Composes the conjure portion of a standard macro body. Handles both
    learned and not-yet-learned spells: known spells emit /cast lines, and
    not-yet-learned spells emit /run ConnIf calls that print a "you'll get
    this later" tip when the user actually presses the click that would
    have used the spell.

    Returns the block string (may be empty).
]]
local function BuildConjureBlock(info)
    if not info then
        return ""
    end

    local rightName, middleName = info.rightName, info.middleName
    local rightMiss, middleMiss = info.rightMiss, info.middleMiss

    if not (rightName or middleName or rightMiss or middleMiss) then
        return ""
    end

    local lines = {}

    --[[
        Miss prints come first so an early /stopmacro can halt before the
        /cast line, avoiding a wasted cast attempt on a button the user
        expected to do something else.
    ]]
    if rightMiss then
        lines[#lines + 1] = '/run ConnIf("[btn:2]","' .. rightMiss .. '")'
    end
    if middleMiss then
        lines[#lines + 1] = '/run ConnIf("[btn:3]","' .. middleMiss .. '")'
    end

    local missStop = ""
    if rightMiss then
        missStop = missStop .. "[btn:2]"
    end
    if middleMiss then
        missStop = missStop .. "[btn:3]"
    end
    if missStop ~= "" then
        lines[#lines + 1] = "/stopmacro " .. missStop
    end

    if rightName or middleName then
        local castLine = ""
        local stopConditions = ""
        if middleName then
            castLine = castLine .. "[btn:3] " .. middleName .. "; "
            stopConditions = stopConditions .. "[btn:3]"
        end
        if rightName then
            castLine = castLine .. "[btn:2] " .. rightName .. "; "
            stopConditions = stopConditions .. "[btn:2]"
        end
        lines[#lines + 1] = "/cast " .. castLine
        lines[#lines + 1] = "/stopmacro " .. stopConditions
    end

    return table.concat(lines, "\n") .. "\n"
end

--------------------------------------------------------------------------------
-- Macro Update Loop
--------------------------------------------------------------------------------

function ns.UpdateMacros(forced)
    if InCombatLockdown() then
        ns.RequestUpdate()
        return
    end
    if not ns.ConjureSpells then
        return
    end

    if forced then
        wipe(currentMacroState)
    end

    local best, dataRetry = ns.ScanBags()

    if dataRetry then
        ns.RegisterDataRetry()
    else
        ns.UnregisterDataRetry()
    end

    --[[
        Scrolls are dropped from the macro when targeting a friendly player so
        the macro reads cleanly as a conjure-for-friend action (Mage food).
    ]]
    local friendlyPlayerTarget = HasFriendlyPlayerTarget()
    local activeScrollIDs = (not friendlyPlayerTarget) and ns.ScrollOverrideIDs or nil

    for typeName, config in pairs(Config) do
        -- Feed Pet is handled separately below
        if typeName == "Feed Pet" then
            -- skip, handled by UpdateFeedPetMacro
        elseif not ns.IsMacroEnabled(typeName) then
            DeleteMacroIfExists(config.macro, typeName)
        else
            local bestEntry = best[typeName]
            local itemID = bestEntry and bestEntry.id

            --[[
                Pet buff override: replaces the Food slot item with pet food.
                Scrolls are still allowed alongside (they target the player,
                pet food targets the pet — no conflict).
            ]]
            local petBuffOverride = false

            if typeName == "Food" and ns.PetBuffOverrideID then
                itemID = ns.PetBuffOverrideID
                petBuffOverride = true
            end

            --[[
                Ranked /use list for multi-use types; topIDs[1] is itemID
                itself, so the list only adds fallback lines below it.
            ]]
            local useIDs
            if itemID and ns.MultiUseMacroTypes[typeName] and bestEntry.topIDs and #bestEntry.topIDs > 0 then
                useIDs = bestEntry.topIDs
            end

            --[[
                Healthstone stacking: when the player opts in, the Health Potion
                macro gets the best Healthstone's ranked /use lines appended
                below the potion lines (see ShouldStackHealthstones). The
                Healthstone topIDs come straight from the scan and are populated
                regardless of whether the standalone Healthstone macro is
                enabled. Gated on itemID so we only stack when there is actually
                a potion to stack onto — no potion means the macro stays its
                plain "no health potion" form. nil for every other macro type.
            ]]
            local stackIDs
            if itemID and typeName == "Health Potion" and ShouldStackHealthstones() then
                local hsEntry = best["Healthstone"]
                if hsEntry and hsEntry.topIDs and #hsEntry.topIDs > 0 then
                    stackIDs = hsEntry.topIDs
                end
            end

            --[[
                Scrolls only apply to the Food macro. When active and not
                targeting a friendly player, the Food macro becomes a
                dedicated scroll-fire macro — no food, no conjure block —
                so the user taps once to apply scrolls, then the macro
                naturally flips back to food mode for the next press.
            ]]
            local scrollIDsForThisMacro = (typeName == "Food") and activeScrollIDs or nil
            local scrollMode = scrollIDsForThisMacro and #scrollIDsForThisMacro > 0

            --[[
                Class-specific macro overrides. The Druid builder owns the
                DMH-wrap path (HP/MP/HS). Returns nil here means "no override
                for this type/item" — fall through to the standard body.
            ]]
            local classBody, classStateID
            if itemID and ns.BuildDruidMacroOverride then
                classBody, classStateID = ns.BuildDruidMacroOverride(typeName, itemID, useIDs, stackIDs)
            end

            if scrollMode then
                --[[
                    Scroll mode: scrolls only, nothing else.
                    State key prefixed with "SCROLLS:" so it can never
                    collide with the standard ITEMID-prefixed key, which
                    guarantees a rewrite happens at every transition into
                    and out of scroll mode (target-change, scroll-applied,
                    bag scan removing the last scroll item, etc).
                ]]
                local body = BuildScrollOnlyBody(scrollIDsForThisMacro)
                local stateID = "SCROLLS:" .. table.concat(scrollIDsForThisMacro, ",")

                if currentMacroState[typeName] ~= stateID or forced then
                    WriteMacro(config.macro, ns.QUESTION_MARK_ICON, body, stateID, typeName)
                end
            elseif classBody then
                --[[
                    Class-override mode. The class builder produced a fully
                    formed macro body and a state key it owns; we just write
                    it. State keys from class builders MUST be prefixed
                    distinctly (e.g. "DMH:") so they cannot collide with the
                    standard or scroll-mode keys — a transition into or out
                    of override mode always triggers a rewrite.
                ]]
                if currentMacroState[typeName] ~= classStateID or forced then
                    WriteMacro(config.macro, ns.QUESTION_MARK_ICON, classBody, classStateID, typeName)
                end
            else
                --[[
                    Class-specific conjure spells (or "spell not yet learned"
                    print tips). Resolver may return nil for macro types this
                    player's class doesn't engage with.
                ]]
                local resolver = ns.ConjureResolvers[typeName]
                local conjureInfo = resolver and resolver() or nil

                local appendShadowmeld = ShouldAppendShadowmeld(typeName)

                -- Standard macro body: tooltip + conjure + action [+ shadowmeld]

                local tooltipLine, actionBlock

                if itemID then
                    tooltipLine = "#showtooltip item:" .. itemID .. "\n"

                    if petBuffOverride then
                        -- Pet food buffs target the pet
                        actionBlock = StateWriteLine(itemID) .. "/use [@pet] item:" .. itemID
                    elseif useIDs then
                        actionBlock = StateWriteLine(itemID) .. BuildUseBlock(useIDs)
                    else
                        actionBlock = StateWriteLine(itemID) .. "/use item:" .. itemID
                    end

                    -- Append the stacked Healthstone /use lines (Health Potion only).
                    if stackIDs then
                        actionBlock = actionBlock .. "\n" .. BuildUseBlock(stackIDs)
                    end
                elseif conjureInfo and conjureInfo.noItemMiss then
                    --[[
                        The player's class can conjure this category but hasn't
                        learned the spell yet. Replace the generic "no item in
                        bags" message with the more useful "you don't know X"
                        message so the player understands the macro will gain
                        functionality at the right level.
                    ]]
                    tooltipLine = "#showtooltip item:" .. config.defaultID .. "\n"
                    actionBlock = '/run ConnTip("' .. conjureInfo.noItemMiss .. '")'
                else
                    tooltipLine = "#showtooltip item:" .. config.defaultID .. "\n"
                    actionBlock = '/run ConnNoItem("' .. typeName .. '")'
                end

                local conjureBlock = ""
                if conjureInfo then
                    conjureBlock = BuildConjureBlock(conjureInfo)
                end

                local shadowmeldBlock = ""
                if appendShadowmeld and ns.ShadowmeldSpellName then
                    shadowmeldBlock = "\n/cast [nostealth] " .. ns.ShadowmeldSpellName
                end

                --[[
                    State encoding — captures every input that affects the
                    written body. Format:
                      ITEMIDS(_C(_M:mid)?(_R:rid)?(_MR:key)?(_MM:key)?(_NI:key)?)?(_SM)?
                    where ITEMIDS is the single itemID, or a comma-joined
                    ranked list for multi-use types so a change in any
                    fallback rank also triggers a rewrite. Scroll mode uses
                    a "SCROLLS:..." prefix instead, so the two key spaces
                    never collide and a transition between modes always
                    triggers a rewrite.
                ]]
                local itemKey = itemID and tostring(itemID) or "none"
                if useIDs then
                    itemKey = table.concat(useIDs, ",")
                end
                if stackIDs then
                    itemKey = itemKey .. "+HS:" .. table.concat(stackIDs, ",")
                end
                local stateParts = {itemKey}
                if
                    conjureInfo and
                        (conjureInfo.rightName or conjureInfo.middleName or conjureInfo.rightMiss or
                            conjureInfo.middleMiss or
                            conjureInfo.noItemMiss)
                 then
                    stateParts[#stateParts + 1] = "C"
                    if conjureInfo.middleName then
                        stateParts[#stateParts + 1] = "M:" .. tostring(conjureInfo.middleID)
                    end
                    if conjureInfo.rightName then
                        stateParts[#stateParts + 1] = "R:" .. tostring(conjureInfo.rightID)
                    end
                    if conjureInfo.rightMiss then
                        stateParts[#stateParts + 1] = "MR:" .. conjureInfo.rightMiss
                    end
                    if conjureInfo.middleMiss then
                        stateParts[#stateParts + 1] = "MM:" .. conjureInfo.middleMiss
                    end
                    if conjureInfo.noItemMiss then
                        stateParts[#stateParts + 1] = "NI:" .. conjureInfo.noItemMiss
                    end
                end
                if appendShadowmeld then
                    stateParts[#stateParts + 1] = "SM"
                end
                local stateID = table.concat(stateParts, "_")

                if currentMacroState[typeName] ~= stateID or forced then
                    local body = tooltipLine .. conjureBlock .. actionBlock .. shadowmeldBlock

                    --[[
                        The client truncates macro bodies at 255 bytes, which
                        would corrupt the last /use line — the warlock
                        Healthstone conjure block plus three /use lines can
                        overflow in multibyte locales (e.g. ruRU spell names),
                        and Health Potion stacking adds the Healthstone lines on
                        top. Shed the stacked Healthstone lines from the bottom
                        first, then potion fallback lines; the rank-1 potion line
                        is never dropped.
                    ]]
                    if useIDs then
                        local keepUse = #useIDs
                        local keepStack = stackIDs and #stackIDs or 0
                        while #body > 255 and (keepStack > 0 or keepUse > 1) do
                            if keepStack > 0 then
                                keepStack = keepStack - 1
                            else
                                keepUse = keepUse - 1
                            end
                            local trimmed = {}
                            for rank = 1, keepUse do
                                trimmed[rank] = useIDs[rank]
                            end
                            actionBlock = StateWriteLine(itemID) .. BuildUseBlock(trimmed)
                            if keepStack > 0 then
                                local stackTrimmed = {}
                                for rank = 1, keepStack do
                                    stackTrimmed[rank] = stackIDs[rank]
                                end
                                actionBlock = actionBlock .. "\n" .. BuildUseBlock(stackTrimmed)
                            end
                            body = tooltipLine .. conjureBlock .. actionBlock .. shadowmeldBlock
                        end
                    end

                    WriteMacro(config.macro, ns.QUESTION_MARK_ICON, body, stateID, typeName)
                end
            end -- if scrollMode / class override / standard
        end
    end

    --[[
        Feed Pet is Hunter-only. Macro-Builder-Hunters owns the knowledge-tier
        logic and emits a print-only stub for pre-10 hunters, so this block
        only routes to UpdateFeedPetMacro or removes the macro when disabled.
    ]]
    if ns.IsHunter then
        if ns.IsMacroEnabled("Feed Pet") then
            if ns.UpdateFeedPetMacro then
                ns.UpdateFeedPetMacro(forced)
            end
        else
            local config = Config["Feed Pet"]
            if config then
                local index = GetMacroIndexByName(config.macro)
                if index and index > 0 then
                    DeleteMacro(index)
                end
                if ns.ResetHunterMacroState then
                    ns.ResetHunterMacroState()
                end
            end
        end
    end

    if ns.UpdateLDB then
        ns.UpdateLDB()
    end
end

function ns.ResetMacroState()
    wipe(currentMacroState)
    if ns.ResetHunterMacroState then
        ns.ResetHunterMacroState()
    end
end