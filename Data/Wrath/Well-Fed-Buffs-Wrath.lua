local _, ns = ...

--------------------------------------------------------------------------------
-- Additional "Well Fed" Buffs
--------------------------------------------------------------------------------

--[[
    Source: the rows a Wrath client loaded from the pre-split shared tables
    (TBC's rows at the split, plus any tagged for Wrath), kept until a Wrath
    TOC ships and Validate Data runs there.
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
}

-- Icons the Well Fed buffs show, matched on the aura's icon when its spell ID is in no table.
-- { [iconFileID] = true }
ns.WELL_FED_ICON_IDS = {
	[136000] = true, -- Well Fed
	[133943] = true, -- Well Fed
}
