local _, ns = ...

--------------------------------------------------------------------------------
-- Mana Gem Macro
--------------------------------------------------------------------------------

ns.RegisterMacroType({
	typeName = "Mana Gem",

	-- Selection: single winner by raw mana value.
	itemTypes = { managem = true },
	score = function(data)
		return data.manaValue
	end,

	--[[
	    Mage conjure resolution (single right-click slot, checkUnique
	    downranking) lives in Tools-Mages.lua; called at update time.
	]]
	conjure = function()
		return ns.ResolveMageManaGemConjure()
	end,
})
