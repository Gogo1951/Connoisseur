local _, ns = ...
local Config = ns.Config

--------------------------------------------------------------------------------
-- Poisons Macro (Rogue)
--------------------------------------------------------------------------------

--[[
    Rogue-only, and like Feed Pet it owns its whole update cycle: the body
    doesn't fit the engine's standard tooltip+conjure+/use shape.

    Click layout (see the TIP_ROGUE_* strings):
      Left-Click   → apply the Off Hand poison group's best rank to slot 17
      Right-Click  → apply the Main Hand poison group's best rank to slot 16
      Middle-Click → open the Poisons crafting window (if known)

    The body applies in two steps — /use the poison item, then /use the
    inventory slot number — and then clicks StaticPopup1Button1 to confirm
    the client's "replace your current enchant/poison" popup, so pressing the
    macro overwrites whatever poison is already on the weapon. The trailing
    UIErrorsFrame:Clear() swallows the noise from clicking with no off-hand
    weapon equipped or a poison already pending.

    The player picks a poison GROUP per hand (Options → Poisons, Rogues
    only); the scan resolves each group to the best rank the rogue can use
    and actually has in bags. Poisons aren't soulbound, so a twink can carry
    ranks above their level — the required-level column in Data/Poisons.lua
    gates those out.

    The tooltip/icon always tracks the Main Hand pick (falling back to the
    Off Hand item, then the config default) so the button reads as "your
    main poison."
]]

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local currentPoisonState = nil

function ns.ResetPoisonMacroState()
	currentPoisonState = nil
end

--------------------------------------------------------------------------------
-- Derived Poison Lookups
--------------------------------------------------------------------------------

--[[
    Per-group candidate lists sorted best-first (highest required level =
    highest rank), precomputed once from ns.PoisonData (Data/Poisons.lua, which
    loads before this file) so the per-update scan is a plain walk. Same pattern
    as the derived scroll lookups in Features/Scanner-Character.lua. Every
    consumer reads ns.PoisonsByGroup from inside a function, so the build only
    needs to finish before the first macro update.
]]
ns.PoisonsByGroup = {}
for itemID, row in pairs(ns.PoisonData) do
	local group = row[2]
	local list = ns.PoisonsByGroup[group]
	if not list then
		list = {}
		ns.PoisonsByGroup[group] = list
	end
	list[#list + 1] = { itemID, row[1] }
end
for _, list in pairs(ns.PoisonsByGroup) do
	table.sort(list, function(a, b)
		if a[2] ~= b[2] then
			return a[2] > b[2]
		end
		return a[1] > b[1]
	end)
end

--------------------------------------------------------------------------------
-- Poison Resolution
--------------------------------------------------------------------------------

--[[
    Localized group name for the Options dropdowns: the base (rank 1) item's
    client-localized name, so poison types never need locale strings. Falls
    back to the English series name while GetItemInfo is still cold (the
    call itself triggers the async load, so a reopened dropdown heals).
]]
function ns.GetPoisonGroupName(groupID)
	local baseItem = ns.PoisonGroupBaseItems and ns.PoisonGroupBaseItems[groupID]
	if baseItem then
		local name = GetItemInfo(baseItem)
		if name then
			return name
		end
	end
	return ns.PoisonGroupFallbackNames and ns.PoisonGroupFallbackNames[groupID] or tostring(groupID)
end

--[[
    Best usable poison for a group: the lists in ns.PoisonsByGroup are sorted
    best-first, so the first entry the rogue meets the level requirement for
    AND has in bags wins. Returns nil when the group has nothing usable.
]]
local function FindBestPoison(groupID)
	local list = ns.PoisonsByGroup and ns.PoisonsByGroup[groupID]
	if not list then
		return nil
	end
	local playerLevel = ns.CachedPlayerLevel or 1
	for _, entry in ipairs(list) do
		if entry[2] <= playerLevel and ns.GetItemCount(entry[1]) > 0 then
			return entry[1]
		end
	end
	return nil
end

--[[
    The player's group pick for one hand, resolved to its best usable item.
    hand is "main" or "off"; the group falls back to Instant Poison (4),
    matching ns.DATABASE_DEFAULTS.
]]
local function BestPoisonForHand(hand)
	local settings = ns.db and ns.db.profile
	local key = (hand == "off") and "offHandPoisonGroup" or "mainHandPoisonGroup"
	return FindBestPoison((settings and settings[key]) or 4)
end

--[[
    Resolved poison for one hand as (itemID, itemLink), for the minimap
    tooltip. Resolved on demand rather than published the way ns.BestPetFoodID
    is: the answer tracks bag contents, which change without a macro rebuild,
    and there is no rebuild at all while the Poisons macro is disabled.
]]
function ns.GetBestPoisonForHand(hand)
	local id = BestPoisonForHand(hand)
	if not id then
		return nil, nil
	end
	return id, select(2, GetItemInfo(id))
end

local function KnowsPoisons()
	local known = IsSpellKnown(ns.POISONS_SPELL_ID)
	if not known and IsPlayerSpell then
		known = IsPlayerSpell(ns.POISONS_SPELL_ID)
	end
	return known
end

--------------------------------------------------------------------------------
-- Poisons Macro Body
--------------------------------------------------------------------------------

--[[
    Four body shapes:

      no Poisons skill → tip-only stub ("You don't currently know Poisons.")
      neither hand     → crafting middle-click + "no suitable Poison found"
      one hand missing → working hand keeps its branch; the missing hand's
                         click prints TIP_NO_HAND_POISON via ConnIf and halts
      both hands       → the full dual-apply body

    [btn:2] is the Main Hand branch; everything that isn't btn:2/btn:3 —
    left-click and keybind presses (which register as left-click, see
    Macros/Explosive.lua) — is the Off Hand branch, tested as [btn:1].
]]
local function BuildPoisonsBody(knows, mainID, offID)
	local tooltipID = mainID or offID or Config["Poisons"].defaultID
	local lines = { "#showtooltip item:" .. tooltipID }

	if not knows then
		lines[#lines + 1] = '/run ConnTip("npois")'
		return table.concat(lines, "\n")
	end

	local poisonsName = GetSpellInfo(ns.POISONS_SPELL_ID)
	if poisonsName then
		lines[#lines + 1] = "/cast [btn:3] " .. poisonsName
		lines[#lines + 1] = "/stopmacro [btn:3]"
	end

	if not mainID and not offID then
		lines[#lines + 1] = '/run ConnNoItem("Poisons")'
		return table.concat(lines, "\n")
	end

	if not mainID then
		lines[#lines + 1] = '/run ConnIf("[btn:2]","nopois")'
		lines[#lines + 1] = "/stopmacro [btn:2]"
	elseif not offID then
		lines[#lines + 1] = '/run ConnIf("[btn:1]","nopois")'
		lines[#lines + 1] = "/stopmacro [btn:1]"
	end

	if mainID and offID then
		lines[#lines + 1] = "/use [btn:2] item:" .. mainID .. "; item:" .. offID
		lines[#lines + 1] = "/use [btn:2] 16; 17"
	elseif mainID then
		lines[#lines + 1] = "/use item:" .. mainID
		lines[#lines + 1] = "/use 16"
	else
		lines[#lines + 1] = "/use item:" .. offID
		lines[#lines + 1] = "/use 17"
	end

	lines[#lines + 1] = "/click StaticPopup1Button1"
	lines[#lines + 1] = "/run UIErrorsFrame:Clear()"

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Poisons Update
--------------------------------------------------------------------------------

local function UpdatePoisonsMacro(forced)
	if InCombatLockdown() then
		ns.RequestUpdate()
		return
	end

	if forced then
		currentPoisonState = nil
	end

	local config = Config["Poisons"]
	if not config then
		return
	end

	local knows = KnowsPoisons()
	local mainID = knows and BestPoisonForHand("main") or nil
	local offID = knows and BestPoisonForHand("off") or nil

	--[[
        Every input that affects the body: skill knowledge, and the resolved
        item per hand (which already encodes the group picks and bag
        contents). Same lossless-key rule as the engine's standard keys.
    ]]
	local stateID = (knows and "K" or "NK")
		.. "_"
		.. (mainID and tostring(mainID) or "none")
		.. "_"
		.. (offID and tostring(offID) or "none")

	if currentPoisonState == stateID and not forced then
		return
	end

	local body = BuildPoisonsBody(knows, mainID, offID)

	local index = GetMacroIndexByName(config.macro)
	if index == 0 then
		-- On a failed create, leave the state unset so the next update retries.
		if not ns.TryCreateMacro(config.macro, ns.QUESTION_MARK_ICON, body) then
			currentPoisonState = nil
			return
		end
	else
		local existingBody = GetMacroBody(config.macro)
		if existingBody ~= body then
			EditMacro(index, config.macro, ns.QUESTION_MARK_ICON, body)
		end
	end

	currentPoisonState = stateID
end

--------------------------------------------------------------------------------
-- Definition
--------------------------------------------------------------------------------

ns.RegisterMacroType({
	typeName = "Poisons",

	customUpdate = function(forced)
		if not ns.IsRogue then
			return
		end
		if ns.IsMacroEnabled("Poisons") then
			UpdatePoisonsMacro(forced)
		else
			local config = Config["Poisons"]
			if config then
				local index = GetMacroIndexByName(config.macro)
				if index and index > 0 then
					DeleteMacro(index)
				end
				ns.ResetPoisonMacroState()
			end
		end
	end,
})
