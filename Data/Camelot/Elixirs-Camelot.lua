local _, ns = ...

--------------------------------------------------------------------------------
-- Flasks and Elixirs
--------------------------------------------------------------------------------

--[[
    What counts as being flasked, for the Readiness Report's Flask or 2x Elixirs
    check (Features/Readiness-Report-Probes.lua).

    The rule the check applies is: a flask, OR two different elixirs.

    TWO DIFFERENT ELIXIRS IS THE WHOLE TEST, and it is enough because the client
    enforces the rest: from TBC on, a character may carry one battle elixir and
    one guardian elixir at a time, so any two elixir auras up together are
    already one of each. Nothing here has to know which kind an elixir is, which
    is why neither table carries that column -- it cannot be read off an aura at
    runtime, and deriving it would mean a spell-category pass no item table can
    answer.

    Keyed by the BUFF's spell ID, not the item's: the report reads the player's
    auras, and several items share one buff while a few grant a buff whose id
    does not match the item at all. That is also why several rows share an id,
    so the source query is deduped by spell on the way in.

    THE SOURCE IS spell_elixir, not the item tables. It is the server's own
    classification, and its mask is the only thing that separates a battle or
    guardian elixir (1 and 2, both collected here) from a utility one. Water
    Breathing and Noggenfogger are elixirs by item subclass but appear in no
    mask, which is exactly right: they occupy no elixir slot, so counting them
    would call a player with water breathing and Noggenfogger fully flasked.

    Flasks are masks 3, 7 and 11 (plain, Unstable, Shattrath), unioned with the
    flask items the item_template pass found. The union is deliberate and errs
    toward silence: an id here that is not really a flask only means the report
    stays quiet, while a missing one means nagging a player who IS flasked --
    the failure that gets a switch turned off for good.
]]

--[[
    Source: Validate Data on the WoW Forever client (1.60.1, build 69977).

    SELECT se.mask, se.entry AS buffSpellId, it.name
    FROM spell_elixir se
    LEFT JOIN item_template it ON it.spellid_1 = se.entry
    ORDER BY se.mask, it.name;
]]
-- { [buffSpellID] = true }, -- Flask Name
ns.FLASK_BUFF_IDS = {
	[17629] = true, -- Flask of Chromatic Resistance
	[17627] = true, -- Flask of Distilled Wisdom
	[17628] = true, -- Flask of Supreme Power
	[17626] = true, -- Flask of the Titans
}

-- { [buffSpellID] = true }, -- Elixir Name
ns.ELIXIR_BUFF_IDS = {
	[11390] = true, -- Arcane Elixir
	[27653] = true, -- Bloodkelp Elixir of Dodging
	[27652] = true, -- Bloodkelp Elixir of Resistance
	[10692] = true, -- Cerebral Cortex Compound
	[15231] = true, -- Crystal Force
	[15233] = true, -- Crystal Ward
	[11328] = true, -- Deprecated Alchemy Elixir Template
	[17537] = true, -- Elixir of Brute Force
	[3220] = true, -- Elixir of Defense
	[11406] = true, -- Elixir of Demonslaying
	[7844] = true, -- Elixir of Firepower
	[3593] = true, -- Elixir of Fortitude
	[21920] = true, -- Elixir of Frost Power
	[8212] = true, -- Elixir of Giant Growth
	[11405] = true, -- Elixir of Giants
	[11334] = true, -- Elixir of Greater Agility
	[11349] = true, -- Elixir of Greater Defense
	[26276] = true, -- Elixir of Greater Firepower
	[11396] = true, -- Elixir of Greater Intellect
	[3160] = true, -- Elixir of Lesser Agility
	[2367] = true, -- Elixir of Lion's Strength
	[2374] = true, -- Elixir of Minor Agility
	[673] = true, -- Elixir of Minor Defense
	[2378] = true, -- Elixir of Minor Fortitude
	[3164] = true, -- Elixir of Ogre's Strength
	[11474] = true, -- Elixir of Shadow Power
	[11348] = true, -- Elixir of Superior Defense
	[17538] = true, -- Elixir of the Mongoose
	[17535] = true, -- Elixir of the Sages
	[11319] = true, -- Elixir of Water Walking
	[3166] = true, -- Elixir of Wisdom
	[11371] = true, -- Gift of Arthas
	[10693] = true, -- Gizzard Gum
	[17539] = true, -- Greater Arcane Elixir
	[10669] = true, -- Ground Scorpok Assay
	[16325] = true, -- Juju Chill
	[16326] = true, -- Juju Ember
	[16321] = true, -- Juju Escape
	[16322] = true, -- Juju Flurry
	[16327] = true, -- Juju Guile
	[16329] = true, -- Juju Might
	[16323] = true, -- Juju Power
	[10668] = true, -- Lung Juice Cocktail
	[24363] = true, -- Mageblood Elixir
	[11364] = true, -- Magic Resistance Potion
	[3223] = true, -- Major Troll's Blood Elixir
	[24361] = true, -- Mighty Troll's Blood Elixir
	[2380] = true, -- Minor Magic Resistance Potion
	[10667] = true, -- R.O.I.D.S.
	[24417] = true, -- Sheen of Zanza
	[24382] = true, -- Spirit of Zanza
	[3222] = true, -- Strong Troll's Blood Elixir
	[24383] = true, -- Swiftness of Zanza
	[3219] = true, -- Weak Troll's Blood Elixir
	[17038] = true, -- Winterfall Firewater
}
