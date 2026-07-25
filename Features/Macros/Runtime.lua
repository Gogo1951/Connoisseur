local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Macro Runtime Globals
--------------------------------------------------------------------------------

--[[
    Macro-callback globals.

    These are intentionally GLOBAL — macro bodies invoke them through `/run`,
    which executes in the global environment and cannot see the add-on
    namespace. This is the documented exception to the rule that the only
    globals are SavedVariables, slash commands, and named frames; each name
    carries the distinctive "Conn" prefix to keep collision risk negligible.

    They are the runtime half of the macro system: the macro builders emit
    `/run ConnFire / ConnTip / ConnIf / ConnNoItem` lines, and these functions
    run when the player presses the macro. This file loads after Announcements
    (ConnTip / ConnNoItem call ns.PrintMessage) and after Data (reads
    ns.MessageStrings, ns.MissingSpellMessageIDs, ns.Config), and before the
    macro builders that emit lines referencing these globals.
]]
--[[
    Transport between the /run snippet in consumable macros and the
    UI_ERROR_MESSAGE handler in Core. The macro writes lastID and lastTime so a
    zone-restriction error can be correlated back to its triggering item.
]]
ConnoisseurState = ConnoisseurState or {}

--[[
    Records the firing item with `/run ConnFire(itemID)` instead of inlining a
    longer snippet — the saved characters matter when stacking scroll uses
    against the 255-character macro body limit.
]]
function ConnFire(itemID)
	ConnoisseurState.lastID = itemID
	ConnoisseurState.lastTime = GetTime()
end

--[[
    Consumer half of the ConnoisseurState transport: when a consumable macro
    fires, ConnFire() above stamps lastID/lastTime. If ERR_ITEM_WRONG_ZONE
    arrives within one second, we know which item to blame and print a bug
    report naming it. Core's dispatcher routes UI_ERROR_MESSAGE here ahead of
    its combat-lockdown guard, since a zone-locked potion is usually pressed
    mid-fight.
]]
function ns.ReportZoneRestriction(msg)
	if not (ConnoisseurState.lastTime and (GetTime() - ConnoisseurState.lastTime) < 1.0) then
		return
	end
	if msg ~= ERR_ITEM_WRONG_ZONE then
		return
	end

	local mapID = C_Map.GetBestMapForUnit("player") or "0"
	local zone = GetZoneText() or "?"
	local subzone = GetSubZoneText() or ""
	if subzone == "" then
		subzone = zone
	end

	local itemID = ConnoisseurState.lastID or 0
	local link = "Item #" .. itemID
	if itemID ~= 0 then
		local _, itemLink = GetItemInfo(itemID)
		if itemLink then
			link = itemLink
		end
	end

	ns.PrintMessage(string.format(L["MSG_BUG_REPORT"], link, itemID, zone, subzone, mapID))
	ConnoisseurState.lastTime = 0
end

--[[
    Resolves a ConnTip key to its display text. Static messages come from
    ns.MessageStrings; "you don't know <spell>" keys come from
    ns.MissingSpellMessageIDs and are rendered with the localized spell name via
    GetSpellInfo at print time. A spell that doesn't exist on the current client
    returns nil here so ConnTip silently skips rather than naming a spell the
    player will never see.
]]
local function ResolveConnTip(key)
	if ns.MessageStrings and ns.MessageStrings[key] then
		return ns.MessageStrings[key]
	end
	if ns.MissingSpellMessageIDs and ns.MissingSpellMessageIDs[key] then
		local name = GetSpellInfo(ns.MissingSpellMessageIDs[key])
		if not name then
			return nil
		end
		return string.format(L["TIP_DONT_KNOW_SPELL"], name)
	end
	return nil
end

function ConnTip(key)
	local text = ResolveConnTip(key)
	if text then
		ns.PrintMessage(text)
	end
end

--[[
    Conditional sibling of ConnTip — fires the tip only when the macro
    conditional `cond` matches. Used by the Feed Pet macro for level-10/11
    hunters who don't know Mend Pet yet, so right-click or in-combat clicks
    print an explanation instead of silently doing nothing useful. We append a
    sentinel " 1" so SecureCmdOptionParse returns "1" on match and nil on miss —
    clean truthy/falsy semantics regardless of how the API treats an empty
    action body.
]]
function ConnIf(cond, key)
	if SecureCmdOptionParse(cond .. " 1") then
		ConnTip(key)
	end
end

--[[
    Prints the standardized "no suitable <type> found" chat line. Macro bodies
    call this with the internal type key (`/run ConnNoItem("Food")`). The key
    stays English inside the macro body (keeps bodies and state keys
    locale-independent) and resolves to the localized LABEL_* string via
    ns.Config at print time. Unknown keys fall back to the raw key so a stale
    macro body from an older version still prints something sensible.
]]
function ConnNoItem(typeName)
	local config = ns.Config and ns.Config[typeName]
	local label = config and config.label or typeName
	ns.PrintMessage(string.format(L["MSG_NO_ITEM"], label))
end
