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

--[[
    The same flavor as the number the Data/ tables flag their rows with -- the
    upgrade ladders and the poison recipes both carry an expansion column, and
    both resolve it against this. Anything newer than the three we know about
    counts as the newest, which lets every row through rather than stranding a
    future client on Classic data.
]]
ns.CURRENT_EXPANSION = ns.EXPANSION_WRATH
if ns.IsEra then
	ns.CURRENT_EXPANSION = ns.EXPANSION_CLASSIC
elseif ns.IsTBC then
	ns.CURRENT_EXPANSION = ns.EXPANSION_TBC
end

--------------------------------------------------------------------------------
-- Item & Container API Shims
--------------------------------------------------------------------------------

--[[
    Cross-client API shims, resolved once at load so call sites stay
    branch-free and never hit "attempt to index nil" on a missing global. Each
    shim picks the API by existence, never by a truthy result.

    Item readers live on C_Item on retail and as globals on Classic/TBC, and
    the two surfaces return the same shape, so those fall back freely.

    C_Container is the container surface on both target clients (see the TOC
    ## Interface line), so the two container readers below are that surface and
    nothing else -- which is why Features/Item-Cache.lua and the Restocker call
    C_Container directly with no shim at all. Neither has a legacy fallback and
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
		-- Same two-step knowledge check as ns.GetSmartSpell.
		local known = IsSpellKnown(data[1])
		if not known and IsPlayerSpell then
			known = IsPlayerSpell(data[1])
		end
		if known then
			return true
		end
	end
	return false
end
