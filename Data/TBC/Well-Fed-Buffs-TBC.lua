local _, ns = ...

--------------------------------------------------------------------------------
-- Additional "Well Fed" Buffs
--------------------------------------------------------------------------------

--[[
    Source: Validate Data on the TBC Anniversary client (2.5.6, build 69795).
    Increased Stamina (25661), Fizzy Energy Drink (29040), the nine Brewfest
    "Well Fed" buffs (44097-44102, 44104-44106) and Hot Apple Cider's Well Fed
    (45245) came from the wago.tools tables for build 2.5.6.69795, for the next
    Validate Data run to confirm.
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
	[44097] = true, -- "Well Fed" (Barleybrew Clear, Small Step Brew)
	[44098] = true, -- "Well Fed" (Barleybrew Light, Long Stride Brew)
	[44099] = true, -- "Well Fed" (Barleybrew Dark, Path of Brew)
	[44100] = true, -- "Well Fed" (Thunder 45, Jungle River Water)
	[44101] = true, -- "Well Fed" (Thunderbrew Ale, Brewdoo Magic)
	[44102] = true, -- "Well Fed" (Thunderbrew Stout, Stout Shrunken Head)
	[44104] = true, -- "Well Fed" (Gordok Grog)
	[44105] = true, -- "Well Fed" (Ogre Mead)
	[44106] = true, -- "Well Fed" (Mudder's Milk)
	[45245] = true, -- Well Fed (Hot Apple Cider)
}

-- Icons the Well Fed buffs show, matched on the aura's icon when its spell ID is in no table.
-- { [iconFileID] = true }
ns.WELL_FED_ICON_IDS = {
	[136000] = true, -- Well Fed
	[133943] = true, -- Well Fed
}
