local _, ns = ...

if not ns.IS_DISCOVERY then
	return
end

--------------------------------------------------------------------------------
-- Macro Default Items
--------------------------------------------------------------------------------

--[[
    The item each macro shows (#showtooltip) while the bags hold nothing it
    can use, keyed by ns.MACRO_CONFIG's macro type (Data/Data.lua).
]]

--[[
    Source: the pre-split shared data files, as the Classic Era client loaded
    them, pruned of the rows Validate Data on the Classic Era client (1.15.9,
    build 69722) flagged NOT ON CLIENT. The values await Validate Data on a
    Season of Discovery realm.
]]
-- [macroType] = itemID, -- Item Name
ns.MACRO_DEFAULT_ITEM_IDS = {
	["Bandage"] = 1251, -- Linen Bandage
	["Explosive"] = 4358, -- Rough Dynamite
	["Food"] = 5349, -- Conjured Muffin
	["Health Potion"] = 118, -- Minor Healing Potion
	["Healthstone"] = 5512, -- Minor Healthstone
	["Mana Gem"] = 5514, -- Mana Agate
	["Mana Potion"] = 2455, -- Minor Mana Potion
	["Soulstone"] = 5232, -- Minor Soulstone
	["Water"] = 5350, -- Conjured Water
	["Feed Pet"] = 117, -- Tough Jerky
	["Poisons"] = 6947, -- Instant Poison
}
