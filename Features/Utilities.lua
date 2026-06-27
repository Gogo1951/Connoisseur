local _, ns = ...

--[[
    Utilities -- stateless, cross-cutting helpers used by multiple files: the
    color accessor, cross-client API shims, and small game-state predicates.
    No module state, no SavedVariables.

    Exposes: ns.GetColor, ns.COLORS, ns.GetItemCount, ns.GetItemIcon,
    ns.GetContainerNumSlots, ns.GetContainerItemInfo, ns.IsModeActive,
    ns.KnowsAny.
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

local COLORS = {
    TITLE = COLOR_PREFIX .. ns.PALETTE.TITLE,
    INFO = COLOR_PREFIX .. ns.PALETTE.INFO,
    BODY = COLOR_PREFIX .. ns.PALETTE.BODY,
    TEXT = COLOR_PREFIX .. ns.PALETTE.TEXT,
    ON = COLOR_PREFIX .. ns.PALETTE.ON,
    OFF = COLOR_PREFIX .. ns.PALETTE.OFF,
    SEPARATOR = COLOR_PREFIX .. ns.PALETTE.SEPARATOR,
    MUTED = COLOR_PREFIX .. ns.PALETTE.MUTED
}

ns.COLORS = COLORS

function ns.GetColor(key)
    return COLORS[key] or COLORS.TEXT
end

--------------------------------------------------------------------------------
-- Item & Container API Shims
--------------------------------------------------------------------------------

--[[
    Cross-client API shims, resolved once at load so call sites stay
    branch-free and never hit "attempt to index nil" on a missing global.
    Item readers live on C_Item on retail and as globals on Classic/TBC;
    container readers are the reverse — C_Container is the only surface on the
    target clients (Era 1.15.8 / TBC 2.5.5), with the old globals kept only as
    a pre-C_Container fallback. Each shim picks the API by existence, never by
    a truthy result.
]]
ns.GetItemCount = (C_Item and C_Item.GetItemCount) or GetItemCount
ns.GetItemIcon = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
ns.GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
ns.GetContainerItemInfo = (C_Container and C_Container.GetContainerItemInfo) or GetContainerItemInfo

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
