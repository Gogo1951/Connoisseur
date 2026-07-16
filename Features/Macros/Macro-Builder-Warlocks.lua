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
    Soulwell (TBC+ ability). Healthstones are unique per tier, so
    GetSmartSpell runs with checkUnique=true: once a tier is in bags the
    next press conjures the rank below it instead of failing on a
    duplicate. Target downranking stays on (ignoreTarget=false) so a
    lower-level friendly target still gets a stone they can use. A
    pre-level-6 warlock won't have Create Healthstone yet — vanishingly
    rare in practice, but the macro still explains itself on click if so.
]]
ns.ConjureResolvers["Healthstone"] = function()
    if not ns.IsWarlock then return nil end

    local info = {}

    if ns.KnowsAny(ns.ConjureSpells.WarlockCreateHealthstone) then
        info.rightName, info.rightID =
            ns.GetSmartSpell(ns.ConjureSpells.WarlockCreateHealthstone, false, true)
    else
        info.rightMiss = "nchs"
        info.noItemMiss = "nchs"
    end

    --[[
        The Soulwell serves the whole raid, so ignoreTarget keeps a
        low-level friendly target from downranking it; the unpinned
        /cast always fires the highest rank known.
    ]]
    if ns.KnowsAny(ns.ConjureSpells.WarlockCreateSoulwell) then
        info.middleName, info.middleID = ns.GetSmartSpell(ns.ConjureSpells.WarlockCreateSoulwell, true)
    else
        info.middleMiss = "ncsw"
    end

    return info
end

--[[
    Soulstone: right-click only, always the best known conjure. No
    checkUnique downgrade here (unlike Healthstones): soulstones share a
    30-minute use cooldown that matches the buff duration, so only one
    stone can ever be deployed at a time — conjuring a lower rank while
    holding the best one would just waste a soul shard. Right-clicking
    while holding the stone gets the game's own "You already have one
    of those" error; the addon prints nothing. Target downranking stays off
    (ignoreTarget=true): the best known rank already satisfies the
    max-target-level caps (see WarlockCreateSoulstone in
    Data.lua). Lowest rank unlocks at level 18, so a 1-17
    warlock sees the missing-spell tip on both right-click (where they
    expected the conjure) and left-click (since they almost certainly
    don't have a Soulstone item to /use).
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
