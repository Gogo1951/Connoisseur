local _, ns = ...

if ns.IS_DISCOVERY then
	return
end

-- TODO: Add SQL Query
--[[
    Source: Validate Data on the Classic Era client (1.15.9, build 69722).
    Wildvine Potion (9144) came from the wago.tools tables for build
    1.15.9.69722, for the next Validate Data run to confirm.

    Healing/Mana amounts derived from item_template.spellid_1 spell
    effects; Allowed Zones from Map/Area restrictions where present.
]]
-- [ID] = {Healing Amount, Mana Amount, {Allowed Zones} or nil, requiredAlchemy or nil}, -- Name
ns.POTIONS = {
	[18839] = { 700, 0 }, -- Combat Healing Potion
	[18841] = { 0, 900 }, -- Combat Mana Potion
	[23578] = { 0, 1350 }, -- Diet McWeaksauce
	[4596] = { 140, 0 }, -- Discolored Healing Potion
	[1072] = { 0, 280 }, -- Full Moonshine
	[1710] = { 455, 0 }, -- Greater Healing Potion
	[6149] = { 0, 700 }, -- Greater Mana Potion
	[929] = { 280, 0 }, -- Healing Potion
	[858] = { 140, 0 }, -- Lesser Healing Potion
	[3385] = { 0, 280 }, -- Lesser Mana Potion
	[17348] = { 980, 0, { 1459, 1460, 1461 } }, -- Major Healing Draught
	[13446] = { 1050, 0 }, -- Major Healing Potion
	[17351] = { 0, 980, { 1459, 1460, 1461 } }, -- Major Mana Draught
	[13444] = { 0, 1350 }, -- Major Mana Potion
	[18253] = { 1440, 1440 }, -- Major Rejuvenation Potion
	[3827] = { 0, 455 }, -- Mana Potion
	[118] = { 70, 0 }, -- Minor Healing Potion
	[2455] = { 0, 140 }, -- Minor Mana Potion
	[2456] = { 90, 90 }, -- Minor Rejuvenation Potion
	[3087] = { 0, 140 }, -- Mug of Shimmer Stout
	[17349] = { 560, 0, { 1459, 1460, 1461 } }, -- Superior Healing Draught
	[3928] = { 700, 0 }, -- Superior Healing Potion
	[17352] = { 0, 560, { 1459, 1460, 1461 } }, -- Superior Mana Draught
	[13443] = { 0, 900 }, -- Superior Mana Potion
	[23579] = { 1050, 0 }, -- The McWeaksauce Classic
	-- Whipper Root Tuber (11951) is absent on purpose: its live row is in Healthstones-Vanilla.lua, sharing the Healthstone cooldown category.
	[9144] = { 1, 1 }, -- Wildvine Potion
}
