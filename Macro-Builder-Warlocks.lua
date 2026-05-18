local _, ns = ...

--------------------------------------------------------------------------------
-- Warlock Conjure Resolvers
--------------------------------------------------------------------------------

--[[
    See Macro-Builder-General.lua's ConjureResolvers table for the full
    protocol. Returning nil means "this macro has no conjure semantics for
    this character" — appropriate for non-warlock classes.
]]

ns.ConjureResolvers = ns.ConjureResolvers or {}

--[[
    Healthstone: right-click creates a healthstone; middle-click summons a
    Soulwell (TBC+ ability). A pre-level-6 warlock won't have Create
    Healthstone yet — vanishingly rare in practice, but the macro still
    explains itself on click if so.
]]
ns.ConjureResolvers["Healthstone"] = function()
    if not ns.IsWarlock then return nil end

    local info = {}

    if ns.KnowsAny(ns.ConjureSpells.WarlockCreateHealthstone) then
        info.rightName, info.rightID = ns.GetSmartSpell(ns.ConjureSpells.WarlockCreateHealthstone)
    else
        info.rightMiss = "nchs"
        info.noItemMiss = "nchs"
    end

    if ns.KnowsAny(ns.ConjureSpells.WarlockCreateSoulwell) then
        info.middleName, info.middleID = ns.GetSmartSpell(ns.ConjureSpells.WarlockCreateSoulwell)
    else
        info.middleMiss = "ncsw"
    end

    return info
end

--[[
    Soulstone: right-click only. Lowest rank unlocks at level 18, so a
    1-17 warlock sees the missing-spell tip on both right-click (where
    they expected the conjure) and left-click (since they almost
    certainly don't have a Soulstone item to /use).
]]
ns.ConjureResolvers["Soulstone"] = function()
    if not ns.IsWarlock then return nil end

    local info = {}

    if ns.KnowsAny(ns.ConjureSpells.WarlockCreateSoulstone) then
        info.rightName, info.rightID =
            ns.GetSmartSpell(ns.ConjureSpells.WarlockCreateSoulstone, true, false)
    else
        info.rightMiss = "ncss"
        info.noItemMiss = "ncss"
    end

    return info
end
