local _, ns = ...

if ns.IS_DISCOVERY then
	return
end

--------------------------------------------------------------------------------
-- Additional "Well Fed" Buffs
--------------------------------------------------------------------------------

--[[
    Source: Validate Data on the Classic Era client (1.15.9, build 69722).
    Increased Stamina (25661) and Fizzy Energy Drink (29040) came from the
    wago.tools tables for build 1.15.9.69722, for the next Validate Data run
    to confirm.
]]

-- { buffID = true }
ns.WELL_FED_BUFF_IDS = {
	[18125] = true, -- Blessed Sunfruit
	[18141] = true, -- Blessed Sunfruit Juice
	[18191] = true, -- Increased Stamina
	[18192] = true, -- Increased Agility
	[18193] = true, -- Increased Spirit
	[18194] = true, -- Mana Regeneration
	[18222] = true, -- Health Regeneration
	[22730] = true, -- Increased Intellect
	[23697] = true, -- Alterac Spring Water
	[25661] = true, -- Increased Stamina (Dirge's Kickin' Chimaerok Chops)
	[29040] = true, -- Fizzy Energy Drink
}

-- Icons the Well Fed buffs show, matched on the aura's icon when its spell ID is in no table.
-- { [iconFileID] = true }
ns.WELL_FED_ICON_IDS = {
	[136000] = true, -- Well Fed
	[133943] = true, -- Well Fed
}
