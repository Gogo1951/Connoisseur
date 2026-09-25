local _, ns = ...

if ns.IS_DISCOVERY then
	return
end

--------------------------------------------------------------------------------
-- Scroll Data
--------------------------------------------------------------------------------

--[[
    Source: Validate Data on the Classic Era client (1.15.9, build 69722).
    Conflict spells 13326, 364161, 16876, 16875, 13864, 23947 and 23948 came
    from the wago.tools tables for build 1.15.9.69722, for the next Validate
    Data run to confirm.
]]
-- TODO: Add SQL Query
-- [scrollType] = { items = { ... }, conflictSpells = { ... } }
ns.SCROLL_DATA = {
	Agility = {
		-- {itemID, buffID, requiredLevel, amount}, -- Name
		items = {
			{ 10309, 12174, 55, 17 }, -- Scroll of Agility IV
			{ 4425, 8117, 40, 13 }, -- Scroll of Agility III
			{ 1477, 8116, 25, 9 }, -- Scroll of Agility II
			{ 3012, 8115, 10, 5 }, -- Scroll of Agility
		},
		-- Stacks with everything in Classic/TBC
		-- [spellID] = amount, -- Name
		conflictSpells = {},
	},
	Intellect = {
		-- {itemID, buffID, requiredLevel, amount}, -- Name
		items = {
			{ 10308, 12176, 50, 16 }, -- Scroll of Intellect IV
			{ 4419, 8098, 35, 12 }, -- Scroll of Intellect III
			{ 2290, 8097, 20, 8 }, -- Scroll of Intellect II
			{ 955, 8096, 5, 4 }, -- Scroll of Intellect
		},
		-- [spellID] = amount, -- Name
		conflictSpells = {
			[23028] = 31, -- Arcane Brilliance (Rank 1)
			[10157] = 31, -- Arcane Intellect (Rank 5)
			[16876] = 31, -- Arcane Intellect (Rank 5)
			[10156] = 22, -- Arcane Intellect (Rank 4)
			[1461] = 15, -- Arcane Intellect (Rank 3)
			[13326] = 10, -- Arcane Intellect
			[1460] = 7, -- Arcane Intellect (Rank 2)
			[364161] = 7, -- Arcane Intellect (Rank 2)
			[1459] = 2, -- Arcane Intellect (Rank 1)
		},
	},
	Protection = {
		-- {itemID, buffID, requiredLevel, amount}, -- Name
		items = {
			{ 10305, 12175, 45, 240 }, -- Scroll of Protection IV
			{ 4421, 8095, 30, 180 }, -- Scroll of Protection III
			{ 1478, 8094, 15, 120 }, -- Scroll of Protection II
			{ 3013, 8091, 1, 60 }, -- Scroll of Protection
		},
		-- Stacks with Devotion Aura, Stoneskin, etc. in Classic/TBC
		-- [spellID] = amount, -- Name
		conflictSpells = {},
	},
	Stamina = {
		-- {itemID, buffID, requiredLevel, amount}, -- Name
		items = {
			{ 10307, 12178, 50, 16 }, -- Scroll of Stamina IV
			{ 4422, 8101, 35, 12 }, -- Scroll of Stamina III
			{ 1711, 8100, 20, 8 }, -- Scroll of Stamina II
			{ 1180, 8099, 5, 4 }, -- Scroll of Stamina
		},
		-- [spellID] = amount, -- Name
		conflictSpells = {
			[10938] = 54, -- Power Word: Fortitude (Rank 6)
			[21564] = 54, -- Prayer of Fortitude (Rank 2)
			[23948] = 54, -- Power Word: Fortitude (Rank 6)
			[10937] = 43, -- Power Word: Fortitude (Rank 5)
			[21562] = 43, -- Prayer of Fortitude (Rank 1)
			[23947] = 43, -- Power Word: Fortitude (Rank 5)
			[2791] = 32, -- Power Word: Fortitude (Rank 4)
			[1245] = 20, -- Power Word: Fortitude (Rank 3)
			[1244] = 8, -- Power Word: Fortitude (Rank 2)
			[1243] = 3, -- Power Word: Fortitude (Rank 1)
			[13864] = 3, -- Power Word: Fortitude
		},
	},
	Spirit = {
		-- {itemID, buffID, requiredLevel, amount}, -- Name
		items = {
			{ 10306, 12177, 45, 15 }, -- Scroll of Spirit IV
			{ 4424, 8114, 30, 11 }, -- Scroll of Spirit III
			{ 1712, 8113, 15, 7 }, -- Scroll of Spirit II
			{ 1181, 8112, 1, 3 }, -- Scroll of Spirit
		},
		-- [spellID] = amount, -- Name
		conflictSpells = {
			[27841] = 40, -- Divine Spirit (Rank 4)
			[27681] = 40, -- Prayer of Spirit (Rank 1)
			[16875] = 35, -- Divine Spirit (Rank 3)
			[14819] = 33, -- Divine Spirit (Rank 3)
			[14818] = 23, -- Divine Spirit (Rank 2)
			[14752] = 17, -- Divine Spirit (Rank 1)
		},
	},
	Strength = {
		-- {itemID, buffID, requiredLevel, amount}, -- Name
		items = {
			{ 10310, 12179, 55, 17 }, -- Scroll of Strength IV
			{ 4426, 8120, 40, 13 }, -- Scroll of Strength III
			{ 2289, 8119, 25, 9 }, -- Scroll of Strength II
			{ 954, 8118, 10, 5 }, -- Scroll of Strength
		},
		-- Stacks with everything in Classic/TBC
		-- [spellID] = amount, -- Name
		conflictSpells = {},
	},
}
