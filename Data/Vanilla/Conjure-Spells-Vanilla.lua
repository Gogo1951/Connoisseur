local _, ns = ...

if ns.IS_DISCOVERY then
	return
end

--------------------------------------------------------------------------------
-- Mage and Warlock Spells
--------------------------------------------------------------------------------

--[[
    Source: carried over from the pre-split Data/Data.lua, which every client
    loaded alike, with the warlock stones' rank column dropped for the Classic
    Era client.
]]

--[[
    Conjure spell lists. Features/Macros/Smart-Spell.lua sorts each by requiredLevel,
    highest first, at load, so row order carries no meaning. Each entry is:

        { spellID, requiredLevel[, rankNumber] }

    spellID        The conjure spell the macro /casts.
    requiredLevel  The level needed to USE the conjured item — not the
                   level the spell is learned (Create Healthstone (Minor)
                   is learned at 10, but its stone is usable at level 1).
                   GetSmartSpell compares this against the player's level
                   — or a friendly target's level — so the macro downranks
                   to conjure an item the recipient can actually use. For
                   lists that never downrank by target (Mana Gems,
                   Soulstones) and the ritual utilities (Refreshment
                   Table, Ritual of Souls), it is simply the spell's
                   learn level.
    rankNumber     Optional. When present, the /cast line is written as
                   "Spell Name(Rank N)" to pin that exact rank. Omitted
                   where every entry already has a unique spell name: each
                   Mana Gem tier is its own spell, and on this client so is
                   each warlock stone tier (see the RECURRING BUG note on
                   WarlockCreateHealthstone).

    Soulstone rows name their max target level in the trailing comment.
]]
ns.CONJURE_SPELLS = {
	MageCreateTable = {
		-- {Spell ID, Spell Learn Level}
	},
	MageCreateWater = {
		-- {Spell ID, Conjured Item Usage Level, Spell Rank}, -- Conjured Item
		-- The rank column is the spell's own rank, not its position here.
		{ 10140, 55, 7 }, -- Conjured Crystal Water
		{ 10139, 45, 6 }, -- Conjured Sparkling Water
		{ 10138, 35, 5 }, -- Conjured Mineral Water
		{ 6127, 25, 4 }, -- Conjured Spring Water
		{ 5506, 15, 3 }, -- Conjured Purified Water
		{ 5505, 5, 2 }, -- Conjured Fresh Water
		{ 5504, 1, 1 }, -- Conjured Water
	},
	MageCreateFood = {
		-- {Spell ID, Conjured Item Usage Level, Spell Rank}, -- Conjured Item
		-- The rank column is the spell's own rank, not its position here.
		{ 28612, 55, 7 }, -- Conjured Cinnamon Roll
		{ 10145, 45, 6 }, -- Conjured Sweet Roll
		{ 10144, 35, 5 }, -- Conjured Sourdough
		{ 6129, 25, 4 }, -- Conjured Pumpernickel
		{ 990, 15, 3 }, -- Conjured Rye
		{ 597, 5, 2 }, -- Conjured Bread
		{ 587, 1, 1 }, -- Conjured Muffin
	},
	MageCreateManaGem = {
		-- {Spell ID, Spell Learn Level}, -- Spell Name
		{ 10054, 58 }, -- Conjure Mana Ruby
		{ 10053, 48 }, -- Conjure Mana Citrine
		{ 3552, 38 }, -- Conjure Mana Jade
		{ 759, 28 }, -- Conjure Mana Agate
	},
	WarlockCreateSoulwell = {
		-- {Spell ID, Spell Learn Level}
	},
	WarlockCreateHealthstone = {
		--[[
		    RECURRING BUG — this has broken Era three times; read before
		    touching this table, WarlockCreateSoulstone, or GetSmartSpell.
		    On the Classic Era client each warlock stone tier is its own
		    distinctly-named spell, so C_Spell.GetSpellName already returns
		    the fully-qualified name ("Create Healthstone (Minor)"). It must
		    be cast bare: appending "(Rank N)" yields "Create Healthstone
		    (Minor)(Rank 1)", a spell that does not exist, and the /cast
		    silently no-ops. That is why these rows carry no rank column,
		    while the TBC folders' rows do: there the stones are one spell
		    with numeric ranks. Mage Conjure Water/Food ARE numeric-rank on
		    every client, so their rank column is correct everywhere — do
		    not "simplify" the two spell families together.
		]]
		-- {Spell ID, Conjured Item Usage Level}, -- Conjured Item
		{ 11730, 48 }, -- Major Healthstone
		{ 11729, 36 }, -- Greater Healthstone
		{ 5699, 24 }, -- Healthstone
		{ 6202, 12 }, -- Lesser Healthstone
		{ 6201, 1 }, -- Minor Healthstone
	},
	WarlockCreateSoulstone = {
		--[[
		    Max Target Level: a soulstone cannot be used on players ABOVE
		    that level. It needs no selection logic — the caps rise with
		    rank, so casting the best known rank always satisfies the cap.
		    The resolver passes ignoreTarget=true, which is why the second
		    column is the learn level rather than an item usage level.

		    No rank column, for the same reason as Healthstones: see the
		    RECURRING BUG note on WarlockCreateHealthstone above.
		]]
		-- {Spell ID, Spell Learn Level}, -- Conjured Item (Max Target Level)
		{ 20757, 60 }, -- Major Soulstone (max target level 70)
		{ 20756, 50 }, -- Greater Soulstone (max target level 60)
		{ 20755, 40 }, -- Soulstone (max target level 50)
		{ 20752, 30 }, -- Lesser Soulstone (max target level 40)
		{ 693, 18 }, -- Minor Soulstone (max target level 30)
	},
}

--[[
    Spell IDs that ConnoisseurTip resolves at print time: one per conjure table
    in ns.CONJURE_SPELLS above that has rows, taken from its rank-1 entry, plus
    the Rogue's Poisons skill, which is not a conjure.
]]
ns.MISSING_SPELL_MESSAGE_IDS = {
	-- Mage conjures
	noConjureWater = 5504, -- Conjure Water (rank 1)
	noConjureFood = 587, -- Conjure Food (rank 1)
	noConjureManaGem = 759, -- Conjure Mana Agate
	-- Warlock conjures
	noCreateHealthstone = 6201, -- Create Healthstone (Minor)
	noCreateSoulstone = 693, -- Create Soulstone (Minor)
	-- Rogue poisons
	noPoisonsSkill = 2842, -- Poisons (the rogue poison-crafting skill)
}
