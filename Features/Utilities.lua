local _, ns = ...

--[[
    Utilities -- stateless, cross-cutting helpers used by multiple files: the
    color accessor, cross-client API shims, and small game-state predicates.
    No module state, no SavedVariables.

    Exposes: ns.GetColor, ns.COLORS, ns.IsEra, ns.IsTBC, ns.GetItemCount,
    ns.GetItemIcon, ns.GetContainerNumSlots, ns.GetContainerItemInfo,
    ns.IsModeActive, ns.KnowsAny.
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

--------------------------------------------------------------------------------
-- Client Flavor
--------------------------------------------------------------------------------

--[[
    The single source of truth for which game client we are running on. The
    TOC ships one Lua codebase for both target clients (see the TOC
    ## Interface line), and a handful of spell mechanics differ between
    them. Anything that must branch on flavor reads ns.IsEra / ns.IsTBC — never
    re-derives WOW_PROJECT_ID inline, and never assumes one flavor's behavior
    is universal. WOW_PROJECT_ID is a client global set before addons load, so
    these are safe to resolve here at file-load time.

    The known flavor split — warlock Healthstone/Soulstone rank pinning — is
    declared in data (rankIsTBCOnly in ns.ConjureSpells, Data/Data.lua) and
    applied by ns.GetSmartSpell (Features/Macros/Engine.lua). See the
    RECURRING BUG note on WarlockCreateHealthstone before touching either.
]]
ns.IsEra = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
ns.IsTBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)

--------------------------------------------------------------------------------
-- Item & Container API Shims
--------------------------------------------------------------------------------

--[[
    Cross-client API shims, resolved once at load so call sites stay
    branch-free and never hit "attempt to index nil" on a missing global. Each
    shim picks the API by existence, never by a truthy result.

    Item readers live on C_Item on retail and as globals on Classic/TBC, and
    the two surfaces return the same shape, so those fall back freely.

    C_Container is the container surface on the target clients (see the TOC
    ## Interface line), which is why Features/Restocker/Item.lua calls
    C_Container.GetContainerItemInfo directly with no shim at all. Both
    surfaces GetContainerNumSlots can resolve to carry a row in
    ns.DIAGNOSTIC_API_CHECKS.

    GetContainerItemInfo therefore has no fallback, and must not be given one:
    the legacy global returns a flat list of values where C_Container returns a
    table, and every call site here indexes the result (info.itemID,
    info.stackCount, info.hyperlink). A fallback could only ever error.
    GetContainerNumSlots keeps its own because both surfaces return a plain
    number.
]]
ns.GetItemCount = (C_Item and C_Item.GetItemCount) or GetItemCount
ns.GetItemIcon = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
ns.GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
ns.GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo

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
		if IsSpellKnown(data[1]) then
			return true
		end
	end
	return false
end
