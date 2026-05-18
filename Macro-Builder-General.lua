local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor
local Config = ns.Config

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
    return UnitExists("target")
        and UnitIsFriend("player", "target")
        and UnitIsPlayer("target")
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

            if checkUnique and ns.ConjuredManaGemItemIDBySpell
                and ns.ConjuredManaGemItemIDBySpell[spellID] then
                if ns.GetItemCount(ns.ConjuredManaGemItemIDBySpell[spellID]) > 0 then
                    shouldSkip = true
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
        Fallback only when the player knows at least one spell in the list
        but none matched the level cap (targeting a low-level friend).
    ]]
    if not ns.KnowsAny(spellList) then
        return nil, 0
    end

    local lowestRank = spellList[#spellList]
    local fallbackName = GetSpellInfo(lowestRank[1])
    if lowestRank[3] then
        return fallbackName .. "(" .. L["RANK"] .. " " .. lowestRank[3] .. ")", lowestRank[1]
    end
    return fallbackName, lowestRank[1]
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

--------------------------------------------------------------------------------
-- Macro Enablement
--------------------------------------------------------------------------------

function ns.IsMacroEnabled(typeName)
    local settings = ConnoisseurCharDB and ConnoisseurCharDB.settings
    local enabled = settings and settings.enabledMacros
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

local function WriteMacro(macroName, icon, body, stateKey, typeName)
    local index = GetMacroIndexByName(macroName)
    if index == 0 then
        CreateMacro(macroName, icon, body, 1)
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
    the global helper defined in Core.lua. The Core UI_ERROR_MESSAGE handler
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
    local lines = { "#showtooltip" }
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

    Returns the block string (may be empty) and the count of "miss" tips
    present (so the caller can include them in the state key).
]]

local function BuildConjureBlock(info)
    if not info then return "", 0 end

    local rightName, rightID   = info.rightName,  info.rightID
    local middleName, middleID = info.middleName, info.middleID
    local rightMiss, middleMiss = info.rightMiss, info.middleMiss

    if not (rightName or middleName or rightMiss or middleMiss) then
        return "", 0
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
    if rightMiss  then missStop = missStop .. "[btn:2]" end
    if middleMiss then missStop = missStop .. "[btn:3]" end
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

    return table.concat(lines, "\n") .. "\n", (rightMiss and 1 or 0) + (middleMiss and 1 or 0)
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
            local itemID = best[typeName] and best[typeName].id

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
                classBody, classStateID = ns.BuildDruidMacroOverride(typeName, itemID)
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

            local tooltipLine, actionBlock, icon

            if itemID then
                tooltipLine = "#showtooltip item:" .. itemID .. "\n"

                if petBuffOverride then
                    -- Pet food buffs target the pet
                    actionBlock = StateWriteLine(itemID) .. "/use [@pet] item:" .. itemID
                else
                    actionBlock = StateWriteLine(itemID) .. "/use item:" .. itemID
                end

                icon = ns.QUESTION_MARK_ICON
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
                icon = ns.QUESTION_MARK_ICON
            else
                local message = string.format(L["MSG_NO_ITEM"], typeName)
                tooltipLine = "#showtooltip item:" .. config.defaultID .. "\n"
                actionBlock = string.format(
                    "/run print('%s%s%s // %s%s')",
                    GetColor("INFO"),
                    L["BRAND"],
                    GetColor("MUTED"),
                    GetColor("TEXT"),
                    message
                )
                icon = ns.QUESTION_MARK_ICON
            end

            local conjureBlock = ""
            if conjureInfo then
                conjureBlock = (BuildConjureBlock(conjureInfo))
            end

            local shadowmeldBlock = ""
            if appendShadowmeld and ns.ShadowmeldSpellName then
                shadowmeldBlock = "\n/cast [nostealth] " .. ns.ShadowmeldSpellName
            end

            --[[
                State encoding — captures every input that affects the
                written body. Format:
                  ITEMID(_C(_M:mid)?(_R:rid)?(_MR:key)?(_MM:key)?(_NI:key)?)?(_SM)?
                Scroll mode uses a "SCROLLS:..." prefix instead, so the
                two key spaces never collide and a transition between
                modes always triggers a rewrite.
            ]]

            local stateParts = { itemID and tostring(itemID) or "none" }
            if conjureInfo and (conjureInfo.rightName or conjureInfo.middleName
                                or conjureInfo.rightMiss or conjureInfo.middleMiss
                                or conjureInfo.noItemMiss) then
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
                WriteMacro(config.macro, ns.QUESTION_MARK_ICON, body, stateID, typeName)
            end

            end -- if scrollMode / class override / standard
        end
    end

    --[[
        Feed Pet (Hunter only). Note: we no longer require FeedPetSpellName
        here — Macro-Builder-Hunters owns the knowledge-tier logic and is
        responsible for emitting a print-only stub for pre-10 hunters.
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
