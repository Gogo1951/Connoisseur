local _, ns = ...

--------------------------------------------------------------------------------
-- Health Potion Macro
--------------------------------------------------------------------------------

ns.RegisterMacroType({
	typeName = "Health Potion",

	-- Selection: every potion with a heal value competes (a hybrid potion
	-- also feeds Mana Potion), ranked by adjusted heal into topIDs for the
	-- stacked /use fallback lines.
	itemTypes = { potion = true },
	accepts = function(data)
		return data.healthValue > 0
	end,
	score = function(data)
		return ns.AdjustedScore(data, data.healthValue)
	end,
	ranked = true,

	--[[
        Healthstone stacking: when the player opts in, the Health Potion
        macro gets the best Healthstone's ranked /use lines appended below
        the potion lines — potions and healthstones live in separate cooldown
        categories, so one press fires one of each. The Healthstone topIDs
        come straight from the scan and are populated regardless of whether
        the standalone Healthstone macro is enabled. The engine gates this on
        having a potion to stack onto and sheds these lines first in the
        macro-length trim.
    ]]
	getStackIDs = function(best)
		local settings = ns.db and ns.db.profile
		if not (settings and settings.combineHealthstones) then
			return nil
		end
		local hsEntry = best["Healthstone"]
		if hsEntry and hsEntry.topIDs and #hsEntry.topIDs > 0 then
			return hsEntry.topIDs
		end
		return nil
	end,
})
