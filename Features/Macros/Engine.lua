local _, ns = ...
local L = ns.L
local Config = ns.Config

--[[
    Engine -- the shared macro-writing machinery. Owns the definition
    registry, macro create/edit/delete plumbing, the conjure-block builder,
    smart spell resolution, the standard-body and state-key builders, the
    macro-length trim, and the update loop that drives one registered
    definition per macro.

    Per-macro behavior lives in Features/Macros/<Name>.lua files, each of
    which calls ns.RegisterMacroType with a definition table:

      typeName          -- key into ns.Config (required)

    Selection fields — how the scanner picks this category's item. A
    definition with an itemTypes set participates in ScanBags: every usable
    bag item is dispatched to each definition claiming its cached itemType
    (more than one may claim the same item — a hybrid potion feeds Health
    Potion and Mana Potion, a foodwater item feeds Food and Water). The
    shared tiebreak ladder (RANKING_PRIORITY) stays in Scanner-Inventory.

      itemTypes         -- set of ns.CacheItemData itemType strings this
                           category consumes, e.g. {potion = true}
      accepts(data)     -- optional extra gate on the cached item data
                           (Health Potion: data.healthValue > 0)
      score(data)       -- the value fed to the ranking ladder, e.g.
                           ns.AdjustedScore(data, data.healthValue)
      ranked            -- true: collect all candidates and rank into the
                           winner's topIDs (the multi-use types); otherwise
                           a single running winner is kept
      allowBuffFood     -- true: compare with the scanner's live
                           ns.AllowBuffFood preference (Food, Water); absent:
                           the ladder's buff-food step stays gated off
      preferHybrid      -- direction of the ladder's hybrid step: true
                           prefers hybrid food/water (Food), false prefers
                           dedicated items (Water)
      winnerExtras(winner, data, hyperlink) -- store extra fields on the
                           winning record (Food: isBuffFood, isPercent, link,
                           isHybrid, isConjured; Water: the same minus link —
                           nothing reads a water link)

    Body hooks — what the written macro looks like.

      conjure()         -- class conjure resolver; returns the info table
                           documented under Conjure Protocol below, or nil
                           when this character has no conjure semantics
                           (Mage Food/Water/Mana Gem, Warlock Healthstone/
                           Soulstone)
      modifyItem(id)    -- replace the scanned best item before body assembly
                           (Food's pet-buff override)
      buildUseLine(id)  -- custom /use line(s) for the item; nil falls back to
                           the standard single- or multi-use block (Explosive's
                           click layout, Food's [@pet] line)
      getStackIDs(best) -- ranked ids appended below the main block
                           (Health Potion's healthstone stacking)
      buildModeOverride(context) -- full-body takeover; returns body, stateKey
                           or nil (Food's scroll-only mode). Mode state keys
                           MUST use their own prefix (e.g. "SCROLLS:") so they
                           can never collide with standard ITEMID-keys — a
                           transition into or out of the mode always rewrites.
      stateExtras(parts, id) -- append extra state-key parts (Explosive's
                           "EX:mode" click layout)
      appendBlock()     -- returns (text, stateFlag) appended after the action
                           block: Water's Shadowmeld line (flag "SM") and
                           Food's Stealth Eating line (flag "SE")
      customUpdate(forced) -- the definition owns its whole update; it is
                           skipped by the standard loop (Feed Pet, which
                           routes to the Hunter builder)

    The macro-callback globals (ConnFire, ConnTip, ConnIf, ConnNoItem) and the
    ConnoisseurState transport live in Features/Macros/Runtime.lua, which loads
    immediately after this file. This file only emits `/run Conn...` lines into
    macro bodies at update time, long after load, so the later load order is
    safe -- nothing here calls those globals while the file is being read.
]]

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local currentMacroState = {}

--------------------------------------------------------------------------------
-- Definition Registry
--------------------------------------------------------------------------------

local macroDefs = {}
local customDefs = {}

--[[
    The scanner reads the standard definitions' selection fields at scan
    time (Scanner-Inventory loads before this file, so it cannot see the
    local directly; every scan happens long after all registrations).
]]
ns.RegisteredMacroDefs = macroDefs

--[[
    The custom definitions, exposed on the same terms for diagnostics only.
    They own their whole update and never reach the scanner's ranking ladder,
    so the Selection Report names them as resolved elsewhere rather than
    leaving the reader to wonder why Feed Pet and Poisons are missing from it.
]]
ns.RegisteredCustomMacroDefs = customDefs

function ns.RegisterMacroType(def)
	if def.customUpdate then
		customDefs[#customDefs + 1] = def
	else
		macroDefs[#macroDefs + 1] = def
	end
end

--------------------------------------------------------------------------------
-- Conjure Protocol
--------------------------------------------------------------------------------

--[[
    A definition's `conjure` hook is a function returning a table:

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
    Class gating (ns.IsMage / ns.IsWarlock) lives inside each resolver.
]]

--------------------------------------------------------------------------------
-- Target Helpers
--------------------------------------------------------------------------------

--[[
    Single source of truth for "is the current target a friendly player." Used
    by both GetSmartSpell (for conjure rank downranking) and the scroll-mode
    gate (which drops scrolls so a Mage can right-click to conjure food
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

	--[[
        RECURRING BUG guard — on Era the warlock stone tiers are
        distinctly-named spells and must be cast bare; appending "(Rank N)"
        builds a spell name that does not exist and the /cast silently
        no-ops. Those lists are flagged rankIsTBCOnly in ns.ConjureSpells —
        see the note on WarlockCreateHealthstone in Data/Data.lua. Unflagged
        lists (Mage Conjure Water/Food) pin ranks on both flavors.
    ]]
	local pinRank = not (ns.IsEra and spellList.rankIsTBCOnly)

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
					if rankNumber and pinRank then
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
				if rankNumber and pinRank then
					return fallbackName .. "(" .. L["RANK"] .. " " .. rankNumber .. ")", spellID
				end
				return fallbackName, spellID
			end
		end
	end

	return nil, 0
end

--------------------------------------------------------------------------------
-- Macro Enablement
--------------------------------------------------------------------------------

--[[
    Which macros the account wants. Account-wide to match the macros themselves,
    which live in the shared General tab (see the CreateMacro wrapper below), so
    a character switch never adds or removes a macro -- it only rewrites the
    shared bodies to that character's best items.
]]
function ns.IsMacroEnabled(typeName)
	local enabled = ns.db and ns.db.global.enabledMacros
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
    the global helper defined in Features/Macros/Runtime.lua. The Core
    UI_ERROR_MESSAGE handler reads lastID and lastTime to correlate a
    zone-restriction error with the item that triggered it.

    Using the global helper instead of an inline /run snippet keeps the macro
    body short — important for the Food macro when stacking scroll uses
    against the 255 macro-body ceiling. The helper name is deliberately short
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
ns.BuildUseBlock = BuildUseBlock

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
-- Standard Body Builder
--------------------------------------------------------------------------------

--[[
    Assembles a standard macro body — the single answer to "what does a
    Connoisseur macro body look like." The canonical emitted macro is:

      #showtooltip item:13446
      /run ConnFire(13446)
      /use item:13446

    Every other line is contributed by a definition hook:

      #showtooltip item:<id>  -- always first; config.defaultID when no item
      <conjure block>         -- def.conjure, via BuildConjureBlock: /run ConnIf
                                 miss tips with their /stopmacro guard, then the
                                 /cast [btn:3]/[btn:2] line and its /stopmacro
      /run ConnFire(<id>)     -- StateWriteLine (macro-fire context for the
                                 zone-error handler); only when an item exists
      /use item:<id>          -- the action: def.buildUseLine's custom line(s)
                                 (Explosive's click layout, Food's [@pet] line),
                                 else one line per ranked id for multi-use
                                 types, else this plain single /use
      /use item:<stackID>     -- def.getStackIDs ids appended below the main
                                 block (Health Potion's healthstone stacking)
      <appended block>        -- def.appendBlock text (Water's Shadowmeld line)

    With no item in bags the action line becomes /run ConnTip("<noItemMiss>")
    when the class can learn the conjure, else /run ConnNoItem("<typeName>").
    Ends with the macro-length trim, which sheds stacked healthstone lines and
    then ranked fallback /use lines from the bottom up.
]]
local function BuildStandardBody(def, config, itemID, useIDs, stackIDs, conjureInfo, appendText)
	local tooltipLine, actionBlock

	if itemID then
		tooltipLine = "#showtooltip item:" .. itemID .. "\n"

		local customLine = def.buildUseLine and def.buildUseLine(itemID) or nil
		if customLine then
			actionBlock = StateWriteLine(itemID) .. customLine
		elseif useIDs then
			actionBlock = StateWriteLine(itemID) .. BuildUseBlock(useIDs)
		else
			actionBlock = StateWriteLine(itemID) .. "/use item:" .. itemID
		end

		-- Append the stacked ranked lines (Health Potion stacking).
		if stackIDs then
			actionBlock = actionBlock .. "\n" .. BuildUseBlock(stackIDs)
		end
	elseif conjureInfo and conjureInfo.noItemMiss then
		--[[
            The player's class can conjure this category but hasn't learned
            the spell yet. Replace the generic "no item in bags" message
            with the more useful "you don't know X" message so the player
            understands the macro will gain functionality at the right
            level.
        ]]
		tooltipLine = "#showtooltip item:" .. config.defaultID .. "\n"
		actionBlock = '/run ConnTip("' .. conjureInfo.noItemMiss .. '")'
	else
		tooltipLine = "#showtooltip item:" .. config.defaultID .. "\n"
		actionBlock = '/run ConnNoItem("' .. def.typeName .. '")'
	end

	local conjureBlock = ""
	if conjureInfo then
		conjureBlock = BuildConjureBlock(conjureInfo)
	end

	local appendedBlock = appendText or ""

	local body = tooltipLine .. conjureBlock .. actionBlock .. appendedBlock

	--[[
        The client caps macro bodies at 255 and the unit of that cap is
        unconfirmed, so the guard measures #body (bytes) — never smaller than
        a character count, so it holds under either reading. See
        README-Technical; never convert this to a character count.

        Overflow corrupts the last /use line: the warlock Healthstone conjure
        block plus three /use lines can overflow in multibyte locales (e.g.
        ruRU spell names), and Health Potion stacking adds the Healthstone
        lines on top. Shed the stacked Healthstone lines from the bottom
        first, then potion fallback lines; the rank-1 potion line is never
        dropped.
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
			body = tooltipLine .. conjureBlock .. actionBlock .. appendedBlock
		end
	end

	return body
end

--------------------------------------------------------------------------------
-- State Key Builder
--------------------------------------------------------------------------------

--[[
    State encoding — captures every input that affects the written body.
    Format:
      ITEMIDS(+HS:stackIDs)?(_C(_M:mid)?(_R:rid)?(_MR:key)?(_MM:key)?(_NI:key)?)?(_EX:mode)?(_SM|_SE)?
    where ITEMIDS is the single itemID, or a comma-joined ranked list for
    multi-use types so a change in any fallback rank also triggers a
    rewrite. +HS: carries the stacked Healthstone ids (Health Potion's
    getStackIDs hook). _EX:mode comes from Explosive's stateExtras hook (its
    click layout), so flipping the dropdown rewrites the macro; _SM and _SE
    are the append-block flags (Water's Shadowmeld line and Food's Stealth
    Eating line). Mode overrides use their own prefix
    ("SCROLLS:...") instead, so the key spaces never collide and a
    transition between modes always triggers a rewrite. Every input that
    affects the body MUST appear in the key — a lossy key causes stale
    macros.
]]
local function BuildStateKey(def, itemID, useIDs, stackIDs, conjureInfo, appendFlag)
	local itemKey = itemID and tostring(itemID) or "none"
	if useIDs then
		itemKey = table.concat(useIDs, ",")
	end
	if stackIDs then
		itemKey = itemKey .. "+HS:" .. table.concat(stackIDs, ",")
	end
	local stateParts = { itemKey }
	if
		conjureInfo
		and (
			conjureInfo.rightName
			or conjureInfo.middleName
			or conjureInfo.rightMiss
			or conjureInfo.middleMiss
			or conjureInfo.noItemMiss
		)
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
	if def.stateExtras then
		def.stateExtras(stateParts, itemID)
	end
	if appendFlag then
		stateParts[#stateParts + 1] = appendFlag
	end
	return table.concat(stateParts, "_")
end

--------------------------------------------------------------------------------
-- Macro Update Loop
--------------------------------------------------------------------------------

--[[
    One-time OnHide hook on the Blizzard Macro UI. The frame is load-on-demand,
    so the hook can only be installed once the frame exists -- the deferral
    guard in UpdateMacros is the first code to see it shown. MacroFrame saves
    its edit box back over the selected macro when the selection changes and
    when it hides, so a Connoisseur macro the user had selected may just have
    been reverted to the text from when the frame opened. The state keys can't
    see that -- they track what WE last wrote, and after a revert they match a
    body that is no longer there -- so drop them all and rebuild from scratch.
]]
local macroUIHooked = false

local function EnsureMacroUIHook()
	if macroUIHooked or not MacroFrame then
		return
	end
	macroUIHooked = true
	MacroFrame:HookScript("OnHide", function()
		ns.ResetMacroState()
		ns.RequestUpdate()
	end)
end

function ns.UpdateMacros(forced)
	--[[
        The wipe runs ahead of the deferral guards so a forced rebuild that
        arrives in combat or with the Macro UI open keeps its force: the
        deferred pass runs unforced, and only the wiped state guarantees it
        rewrites bodies whose state key did not change.
    ]]
	if forced then
		wipe(currentMacroState)
	end

	if InCombatLockdown() then
		ns.RequestUpdate()
		return
	end

	--[[
        Writing while the Blizzard Macro UI is open is worse than useless: the
        open frame never refreshes (the user stares at the old body and
        concludes the rebuild is broken), and its save-back then reverts the
        write -- leaving currentMacroState recording a body the macro no longer
        has, which blocks every later rewrite whose state key matches (the
        "stale macros until something else changes" failure). Defer exactly
        like combat: leave the work pending and let the throttle retry; the
        OnHide hook above forces the full rebuild the moment the frame closes.
    ]]
	if MacroFrame and MacroFrame:IsShown() then
		EnsureMacroUIHook()
		ns.RequestUpdate()
		return
	end

	if not ns.ConjureSpells then
		return
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
        Computed once per update and handed to buildModeOverride hooks via the
        shared context (only Food consumes it today).
    ]]
	local friendlyPlayerTarget = HasFriendlyPlayerTarget()
	local context = {
		best = best,
		activeScrollIDs = (not friendlyPlayerTarget) and ns.ScrollOverrideIDs or nil,
	}

	for _, def in ipairs(macroDefs) do
		local typeName = def.typeName
		local config = Config[typeName]

		if not ns.IsMacroEnabled(typeName) then
			DeleteMacroIfExists(config.macro, typeName)
		else
			local bestEntry = best[typeName]
			local itemID = bestEntry and bestEntry.id

			-- Definition hook: swap the scanned item (Food's pet-buff override).
			if def.modifyItem then
				itemID = def.modifyItem(itemID)
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
                Definition hook: ranked ids appended below the main block
                (Health Potion's healthstone stacking). Gated on itemID so we
                only stack when there is actually a main item to stack onto —
                no item means the macro stays its plain "no item" form.
            ]]
			local stackIDs
			if itemID and def.getStackIDs then
				stackIDs = def.getStackIDs(best)
			end

			--[[
                Class-specific macro overrides. The Druid builder owns the
                DMH-wrap path (HP/MP/HS). Returns nil here means "no override
                for this type/item" — fall through to the standard body.
            ]]
			local classBody, classStateID
			if itemID and ns.BuildDruidMacroOverride then
				classBody, classStateID = ns.BuildDruidMacroOverride(typeName, itemID, useIDs, stackIDs)
			end

			--[[
                Definition hook: full-body mode override (Food's scroll-only
                mode). Checked before the class override, matching the old
                scroll-mode precedence.
            ]]
			local modeBody, modeStateID
			if def.buildModeOverride then
				modeBody, modeStateID = def.buildModeOverride(context)
			end

			if modeBody then
				--[[
                    Mode override: the definition produced a fully formed body
                    and a state key it owns. Mode state keys use their own
                    prefix ("SCROLLS:") so they can never collide with the
                    standard ITEMID-prefixed key, which guarantees a rewrite
                    happens at every transition into and out of the mode
                    (target-change, scroll-applied, bag scan removing the last
                    scroll item, etc).
                ]]
				if currentMacroState[typeName] ~= modeStateID or forced then
					WriteMacro(config.macro, ns.QUESTION_MARK_ICON, modeBody, modeStateID, typeName)
				end
			elseif classBody then
				--[[
                    Class-override mode. The class builder produced a fully
                    formed macro body and a state key it owns; we just write
                    it. State keys from class builders MUST be prefixed
                    distinctly (e.g. "DMH:") so they cannot collide with the
                    standard or mode-override keys — a transition into or out
                    of override mode always triggers a rewrite.
                ]]
				if currentMacroState[typeName] ~= classStateID or forced then
					WriteMacro(config.macro, ns.QUESTION_MARK_ICON, classBody, classStateID, typeName)
				end
			else
				--[[
                    Class-specific conjure spells (or "spell not yet learned"
                    print tips). The definition's resolver may return nil for
                    macro types this player's class doesn't engage with.
                ]]
				local conjureInfo = def.conjure and def.conjure() or nil

				-- Definition hook: appended block + its state flag (Shadowmeld).
				local appendText, appendFlag
				if def.appendBlock then
					appendText, appendFlag = def.appendBlock()
				end

				local stateID = BuildStateKey(def, itemID, useIDs, stackIDs, conjureInfo, appendFlag)

				if currentMacroState[typeName] ~= stateID or forced then
					local body = BuildStandardBody(def, config, itemID, useIDs, stackIDs, conjureInfo, appendText)
					WriteMacro(config.macro, ns.QUESTION_MARK_ICON, body, stateID, typeName)
				end
			end -- if mode override / class override / standard
		end
	end

	--[[
        Definitions that own their whole update cycle (Feed Pet, which routes
        to the Hunter builder and gates on ns.IsHunter internally).
    ]]
	for _, def in ipairs(customDefs) do
		def.customUpdate(forced)
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
	if ns.ResetPoisonMacroState then
		ns.ResetPoisonMacroState()
	end
	if ns.ResetScrollBuffTracking then
		ns.ResetScrollBuffTracking()
	end
end
