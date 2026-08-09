local _, ns = ...

--------------------------------------------------------------------------------
-- Warlock Conjure Resolution
--------------------------------------------------------------------------------

--[[
    All warlock conjure resolution lives here (organizing rule and resolver
    contract: see Tools-Mages.lua and Engine.lua's definition protocol).

    Both stone families are represented differently per client flavor (Era:
    distinctly-named tiers cast bare; TBC: numeric ranks). That split is
    handled at engine level, NOT here: the rankIsTBCOnly flag lives on the
    ns.ConjureSpells tables (Data/Data.lua) and ns.GetSmartSpell (Engine.lua)
    applies it. See the RECURRING BUG note on WarlockCreateHealthstone in
    Data/Data.lua before touching rank handling.
]]

--[[
    Right-click creates a healthstone; middle-click summons a Soulwell (TBC+
    ability). Healthstones are unique per tier, so GetSmartSpell runs with
    checkUnique=true: once a tier is in bags the next press conjures the rank
    below it instead of failing on a duplicate. Target downranking stays on
    (ignoreTarget=false) so a lower-level friendly target still gets a stone
    they can use. A pre-level-6 warlock won't have Create Healthstone yet —
    vanishingly rare in practice, but the macro still explains itself on click
    if so.
]]
function ns.ResolveWarlockHealthstoneConjure()
	if not ns.IsWarlock then
		return nil
	end

	local info = {}

	if ns.KnowsAny(ns.ConjureSpells.WarlockCreateHealthstone) then
		info.rightName, info.rightID = ns.GetSmartSpell(ns.ConjureSpells.WarlockCreateHealthstone, false, true)
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
    Right-click only, always the best known conjure. No checkUnique downgrade
    here (unlike Healthstones): soulstones share a 30-minute use cooldown that
    matches the buff duration, so only one stone can ever be deployed at a
    time — conjuring a lower rank while holding the best one would just waste a
    soul shard. Right-clicking while holding the stone gets the game's own
    "You already have one of those" error; the addon prints nothing. Target
    downranking stays off (ignoreTarget=true): the best known rank already
    satisfies the max-target-level caps (see WarlockCreateSoulstone in
    Data.lua). Lowest rank unlocks at level 18, so a 1-17 warlock sees the
    missing-spell tip on both right-click (where they expected the conjure)
    and left-click (since they almost certainly don't have a Soulstone item to
    /use).
]]
function ns.ResolveWarlockSoulstoneConjure()
	if not ns.IsWarlock then
		return nil
	end

	local info = {}

	if ns.KnowsAny(ns.ConjureSpells.WarlockCreateSoulstone) then
		info.rightName, info.rightID = ns.GetSmartSpell(ns.ConjureSpells.WarlockCreateSoulstone, true, false)
	else
		info.rightMiss = "ncss"
		info.noItemMiss = "ncss"
	end

	return info
end
