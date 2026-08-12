local _, ns = ...

--------------------------------------------------------------------------------
-- Bandage Macro
--------------------------------------------------------------------------------

-- Standard single-item macro; the engine's default body needs no hooks.
ns.RegisterMacroType({
	typeName = "Bandage",

	-- Selection: best bandage by adjusted heal (zone-restricted bandages
	-- get the +2 burn-first bonus — see ns.AdjustedScore).
	itemTypes = { bandage = true },
	score = function(data)
		return ns.AdjustedScore(data, data.healthValue)
	end,
})
