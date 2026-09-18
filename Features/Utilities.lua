local _, ns = ...

--[[
    Utilities -- stateless, cross-cutting helpers used by multiple files: the
    color accessor, cross-client API shims, and small game-state predicates.
    No module state, no SavedVariables.
]]

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

--[[
    Derived color table and accessor. The raw hex palette lives in
    Data/Data.lua (ns.PALETTE); this file prefixes each entry with the
    |cff escape and exposes ns.GetColor. Append |r at the point of use.
]]
local COLOR_PREFIX = "|cff"

local COLORS = {}
for key, hex in pairs(ns.PALETTE) do
	COLORS[key] = COLOR_PREFIX .. hex
end

ns.COLORS = COLORS

function ns.GetColor(key)
	return COLORS[key] or COLORS.TEXT
end

--[[
    "RRGGBB" to the {r, g, b} 0-1 triple the frame APIs take. Exposed rather than
    kept private to the palette loop below so that a UI file needing a colour
    from outside the brand palette can still write it as the hex it was chosen
    as, instead of committing six hand-divided decimals no one can check by eye.
]]
function ns.HexToRGB(hex)
	return {
		r = tonumber(hex:sub(1, 2), 16) / 255,
		g = tonumber(hex:sub(3, 4), 16) / 255,
		b = tonumber(hex:sub(5, 6), 16) / 255,
	}
end

--[[
    The same palette as numbers, for the APIs that take components rather than
    an escape string -- SetTextColor, SetColorTexture, SetVertexColor. Derived
    from ns.PALETTE at load rather than written out again, so a palette edit
    reaches the drawn frames and the coloured text together instead of moving
    one and leaving the other behind.
]]
ns.COLORS_RGB = {}
for key, hex in pairs(ns.PALETTE) do
	ns.COLORS_RGB[key] = ns.HexToRGB(hex)
end

--------------------------------------------------------------------------------
-- Client Flavor
--------------------------------------------------------------------------------

--[[
    The single source of truth for which game client we are running on. One
    Lua codebase ships for Classic Era, TBC Anniversary and WoW Forever, and a
    handful of spell mechanics and data rows differ between them. Anything that
    must branch on flavor reads ns.IS_ERA / ns.IS_TBC / ns.IS_FOREVER — never
    re-derives WOW_PROJECT_ID inline, and never assumes one flavor's behavior
    is universal. WOW_PROJECT_ID is a client global set before addons load, so
    these are safe to resolve here at file-load time.

    Forever is the Retail client (it reports WOW_PROJECT_MAINLINE) running
    Classic Era data, so every data or spell-mechanic branch treats it as Era:
    test (ns.IS_ERA or ns.IS_FOREVER), never ns.IS_ERA alone.

    The known flavor split — warlock Healthstone/Soulstone rank pinning — is
    declared in data (rankIsTBCOnly in ns.CONJURE_SPELLS, Data/Data.lua) and
    applied by ns.GetSmartSpell (Features/Macros/Engine.lua). See the
    RECURRING BUG note on WarlockCreateHealthstone before touching either.
]]
ns.IS_ERA = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
ns.IS_TBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
ns.IS_FOREVER = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)

--[[
    The same flavor as the number the Data/ tables flag their rows with -- the
    upgrade ladders and the poison recipes both carry an expansion column, and
    both resolve it against this. Forever carries Era's data, so it resolves to
    Classic. Any other client counts as the newest, which lets every row
    through rather than stranding a future client on Classic data.
]]
ns.CURRENT_EXPANSION = ns.EXPANSION_WRATH
if ns.IS_ERA or ns.IS_FOREVER then
	ns.CURRENT_EXPANSION = ns.EXPANSION_CLASSIC
elseif ns.IS_TBC then
	ns.CURRENT_EXPANSION = ns.EXPANSION_TBC
end

--------------------------------------------------------------------------------
-- Item & Container API Shims
--------------------------------------------------------------------------------

--[[
    Cross-client API shims, resolved once at load so call sites stay
    branch-free and never hit "attempt to index nil" on a missing global. Each
    shim picks the API by existence, never by a truthy result.

    Item readers live on C_Item on all three target clients, and the legacy
    globals are Blizzard's deprecated aliases of the same functions, so those
    fall back freely.

    C_Container is the container surface on all three target clients, so the
    two container readers below are that surface and
    nothing else -- which is why the Restocker calls C_Container directly with
    no shim at all. Neither has a legacy fallback and
    neither may be given one: the legacy GetContainerItemInfo returns a flat
    list of values where C_Container returns a table, and every call site here
    indexes the result (info.itemID, info.stackCount, info.hyperlink), so a
    fallback could only ever error.
]]
ns.GetItemCount = (C_Item and C_Item.GetItemCount) or GetItemCount
ns.GetItemIcon = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
ns.GetContainerNumSlots = C_Container.GetContainerNumSlots
ns.GetContainerItemInfo = C_Container.GetContainerItemInfo

--------------------------------------------------------------------------------
-- Spell Knowledge
--------------------------------------------------------------------------------

--[[
    On Forever the IsSpellKnown and IsPlayerSpell globals exist only in
    Blizzard's deprecation layer, which the loadDeprecationFallbacks CVar
    switches off. C_SpellBook ships on all three clients, so these read it
    directly: ns.IsSpellKnown is exactly the deprecated IsSpellKnown (in the
    spellbook, overrides excluded) and ns.IsPlayerSpell is IsPlayerSpell.
    Callers wanting "does the player know it" test both.
]]
function ns.IsSpellKnown(spellID)
	return C_SpellBook.IsSpellInSpellBook(spellID, Enum.SpellBookSpellBank.Player, false)
end

function ns.IsPlayerSpell(spellID)
	return C_SpellBook.IsSpellKnown(spellID)
end

--------------------------------------------------------------------------------
-- Quest, Skill, Pet & Merchant API Shims
--------------------------------------------------------------------------------

--[[
    Forever runs on the Retail client, which has dropped these legacy readers
    for namespaced ones that return a table; Era and TBC have only the legacy
    globals. Each shim gives its call sites one shape on all three clients: the
    legacy return order, except the quest reader (a quest ID, nil for a header
    line) and the pet diet reader (a list).

    Spell names need no shim: every call site reads C_Spell.GetSpellName, which
    all three clients ship, and Forever has no GetSpellInfo.
]]
if C_QuestLog and C_QuestLog.GetInfo then
	ns.GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries

	function ns.GetQuestLogQuestID(questIndex)
		local info = C_QuestLog.GetInfo(questIndex)
		if info and not info.isHeader then
			return info.questID
		end
	end
else
	ns.GetNumQuestLogEntries = GetNumQuestLogEntries

	function ns.GetQuestLogQuestID(questIndex)
		local _, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(questIndex)
		if not isHeader then
			return questID
		end
	end
end

if C_SkillInfo and C_SkillInfo.GetSkillLineInfo then
	ns.GetNumSkillLines = C_SkillInfo.GetNumSkillLines

	function ns.GetSkillLineInfo(skillIndex)
		local info = C_SkillInfo.GetSkillLineInfo(skillIndex)
		if info then
			return info.name, info.isHeader, not info.isCollapsed, info.rank
		end
	end
else
	ns.GetNumSkillLines = GetNumSkillLines
	ns.GetSkillLineInfo = GetSkillLineInfo
end

if C_PetInfo and C_PetInfo.GetPetFoodTypes then
	ns.GetPetFoodTypes = C_PetInfo.GetPetFoodTypes
else
	function ns.GetPetFoodTypes()
		return { GetPetFoodTypes() }
	end
end

if C_MerchantFrame and C_MerchantFrame.GetItemInfo then
	function ns.GetMerchantItemInfo(index)
		local info = C_MerchantFrame.GetItemInfo(index)
		if info then
			return info.name, info.texture, info.price, info.stackCount, info.numAvailable
		end
	end
else
	ns.GetMerchantItemInfo = GetMerchantItemInfo
end

--------------------------------------------------------------------------------
-- Game-State Predicates
--------------------------------------------------------------------------------

function ns.IsModeActive(mode)
	if mode == "always" then
		return true
	end
	if mode == "party" then
		return IsInGroup()
	end
	if mode == "raid" then
		return IsInRaid()
	end
	return true
end

function ns.KnowsAny(spellList)
	if not spellList then
		return false
	end
	for _, data in ipairs(spellList) do
		if ns.IsSpellKnown(data[1]) or ns.IsPlayerSpell(data[1]) then
			return true
		end
	end
	return false
end
