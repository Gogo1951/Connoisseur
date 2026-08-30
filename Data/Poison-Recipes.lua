local _, ns = ...

--------------------------------------------------------------------------------
-- Poison Recipes
--------------------------------------------------------------------------------

--[[
    What a rogue poison costs to craft. Read by
    Features/Restocker/Restocker-Crafting-Reagents.lua: when the Restock List is short of a
    poison, the shortfall is turned into an order for these reagents, and the
    vendor has to stock every one of them before any is bought.

    Blizzard rebalanced most of these counts in TBC, so a row carries the
    expansion it belongs to and only this client's rows are loaded. A row with no
    expansion column is the same on both.

    Vials are listed like any other reagent rather than special-cased: a recipe
    needs one, the vendor has to sell it, and the all-or-nothing gate treats it
    as it treats the rest.
]]

-- TODO: Add SQL Query

local CLASSIC, TBC = ns.EXPANSION_CLASSIC, ns.EXPANSION_TBC

--[[
    Reagents by ID, so the rows below stay one line each:
      2928 Dust of Decay          8924 Dust of Deterioration
      2930 Essence of Pain        8923 Essence of Agony
      2931 Maiden's Anguish       5173 Deathweed
      3371 Empty Vial             3372 Leaded Vial            8925 Crystal Vial
]]

-- { craftedItemID, { { reagentID, count }, ... }[, expansion] }, -- Crafted item
ns.PoisonRecipes = {
	-- Instant Poisons
	{ 21927, { { 2931, 1 }, { 8925, 1 } }, TBC }, -- Instant Poison VII
	{ 8928, { { 8924, 2 }, { 8925, 1 } }, TBC }, -- Instant Poison VI
	{ 8927, { { 8924, 2 }, { 8925, 1 } }, TBC }, -- Instant Poison V
	{ 8926, { { 8924, 1 }, { 8925, 1 } }, TBC }, -- Instant Poison IV
	{ 6950, { { 8924, 2 }, { 3372, 1 } }, TBC }, -- Instant Poison III
	{ 6949, { { 2928, 1 }, { 3372, 1 } }, TBC }, -- Instant Poison II
	{ 8928, { { 8924, 4 }, { 8925, 1 } }, CLASSIC }, -- Instant Poison VI
	{ 8927, { { 8924, 3 }, { 8925, 1 } }, CLASSIC }, -- Instant Poison V
	{ 8926, { { 8924, 2 }, { 8925, 1 } }, CLASSIC }, -- Instant Poison IV
	{ 6950, { { 8924, 1 }, { 3372, 1 } }, CLASSIC }, -- Instant Poison III
	{ 6949, { { 2928, 3 }, { 3372, 1 } }, CLASSIC }, -- Instant Poison II
	{ 6947, { { 2928, 1 }, { 3371, 1 } } }, -- Instant Poison

	-- Crippling Poisons
	{ 3776, { { 8923, 1 }, { 8925, 1 } }, TBC }, -- Crippling Poison II
	{ 3776, { { 8923, 3 }, { 8925, 1 } }, CLASSIC }, -- Crippling Poison II
	{ 3775, { { 2930, 1 }, { 3371, 1 } } }, -- Crippling Poison

	-- Deadly Poisons
	{ 22054, { { 2931, 1 }, { 8925, 1 } }, TBC }, -- Deadly Poison VII
	{ 22053, { { 2931, 1 }, { 8925, 1 } }, TBC }, -- Deadly Poison VI
	{ 20844, { { 5173, 2 }, { 8925, 1 } }, TBC }, -- Deadly Poison V
	{ 8985, { { 5173, 2 }, { 8925, 1 } }, TBC }, -- Deadly Poison IV
	{ 8984, { { 5173, 1 }, { 8925, 1 } }, TBC }, -- Deadly Poison III
	{ 2893, { { 5173, 2 }, { 3372, 1 } }, TBC }, -- Deadly Poison II
	{ 2892, { { 5173, 1 }, { 3372, 1 } }, TBC }, -- Deadly Poison
	{ 20844, { { 5173, 7 }, { 8925, 1 } }, CLASSIC }, -- Deadly Poison V
	{ 8985, { { 5173, 5 }, { 8925, 1 } }, CLASSIC }, -- Deadly Poison IV
	{ 8984, { { 5173, 3 }, { 8925, 1 } }, CLASSIC }, -- Deadly Poison III
	{ 2893, { { 5173, 2 }, { 3372, 1 } }, CLASSIC }, -- Deadly Poison II
	{ 2892, { { 5173, 1 }, { 3372, 1 } }, CLASSIC }, -- Deadly Poison

	-- Mind-numbing Poisons
	{ 9186, { { 8923, 1 }, { 8925, 1 } }, TBC }, -- Mind-numbing Poison III
	{ 6951, { { 8923, 1 }, { 3372, 1 } }, TBC }, -- Mind-numbing Poison II
	{ 5237, { { 2928, 1 }, { 3371, 1 } }, TBC }, -- Mind-numbing Poison
	{ 9186, { { 8924, 2 }, { 8923, 2 }, { 8925, 1 } }, CLASSIC }, -- Mind-numbing Poison III
	{ 6951, { { 2928, 4 }, { 2930, 4 }, { 3372, 1 } }, CLASSIC }, -- Mind-numbing Poison II
	{ 5237, { { 2928, 1 }, { 2930, 1 }, { 3371, 1 } }, CLASSIC }, -- Mind-numbing Poison

	-- Wound Poisons
	{ 22055, { { 8923, 2 }, { 8925, 1 } }, TBC }, -- Wound Poison V
	{ 10922, { { 8923, 1 }, { 5173, 1 }, { 8925, 1 } }, TBC }, -- Wound Poison IV
	{ 10921, { { 8923, 1 }, { 8925, 1 } }, TBC }, -- Wound Poison III
	{ 10920, { { 2930, 1 }, { 5173, 1 }, { 3372, 1 } }, TBC }, -- Wound Poison II
	{ 10918, { { 2930, 1 }, { 3372, 1 } }, TBC }, -- Wound Poison
	{ 10922, { { 8923, 2 }, { 5173, 2 }, { 8925, 1 } }, CLASSIC }, -- Wound Poison IV
	{ 10921, { { 8923, 1 }, { 5173, 2 }, { 8925, 1 } }, CLASSIC }, -- Wound Poison III
	{ 10920, { { 2930, 1 }, { 5173, 2 }, { 3372, 1 } }, CLASSIC }, -- Wound Poison II
	{ 10918, { { 2930, 1 }, { 5173, 1 }, { 3372, 1 } }, CLASSIC }, -- Wound Poison

	-- Anesthetic Poison
	{ 21835, { { 2931, 1 }, { 5173, 1 }, { 8925, 1 } }, TBC }, -- Anesthetic Poison
}
