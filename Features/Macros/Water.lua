local _, ns = ...

--------------------------------------------------------------------------------
-- Water Macro
--------------------------------------------------------------------------------

ns.RegisterMacroType({
	typeName = "Water",

	--[[
        Selection: any drink competes, including the water half of a
        foodwater hybrid (which also feeds Food), by raw mana value. The
        buff-food gate matches Food's — a buff drink only competes while
        ns.AllowBuffFood is on. Unlike Food, ties prefer the DEDICATED
        drink (preferHybrid = false): the hybrid is better saved for the
        Food slot, and Water never stores a link (nothing reads one).
    ]]
	itemTypes = { water = true, foodwater = true },
	accepts = function(data)
		return not (data.isBuffFood and not ns.AllowBuffFood)
	end,
	score = function(data)
		return data.manaValue
	end,
	allowBuffFood = true,
	preferHybrid = false,
	winnerExtras = function(winner, data)
		winner.isBuffFood = data.isBuffFood
		winner.isPercent = data.isPercent
		winner.isHybrid = (data.itemType == "foodwater")
		winner.isConjured = data.isConjured
	end,

	-- Mage conjure: shared Water/Food resolution (Refreshment Table on
	-- middle-click) lives in Tools-Mages.lua; called at update time.
	conjure = function()
		return ns.ResolveMageWaterOrFoodConjure(ns.ConjureSpells.MageCreateWater, "ncwater")
	end,

	--[[
        Night Elf Shadowmeld drinking: appends a stealth cast below the drink
        line so the player melds while drinking. The "SM" flag keeps the
        append in the state key so toggling the option rewrites the macro.
    ]]
	appendBlock = function()
		--[[
            Night Elves only -- and not Night Elf Rogues: their options section
            is the Rogues one (which has no Stealth Drinking toggle), so this
            append must never fire off a stale enableShadowmeldDrinking value.
        ]]
		if not ns.IsNightElf or ns.IsRogue then
			return nil
		end
		local settings = ns.db and ns.db.profile
		if not settings or not settings.enableShadowmeldDrinking then
			return nil
		end
		if not ns.ShadowmeldSpellName then
			return nil
		end
		return "\n/cast [nostealth] " .. ns.ShadowmeldSpellName, "SM"
	end,
})
