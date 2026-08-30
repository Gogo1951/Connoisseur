local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Starter List Categories
--------------------------------------------------------------------------------

--[[
    What the first-run Restock List window can offer, one row per checkbox.
    Features/Restocker/Restocker-Starter-List.lua owns every decision made about
    these rows -- which ladder each resolves to, who is offered it, what a tick
    adds. This file only says what exists.

    `chainKey` names a ladder in ns.FoodUpgradeChains; the feature file resolves
    it at load and drops any row whose ladder is missing, which is why the key is
    a plain string here.
]]

--[[
    The popup asks for WHOLE STACKS, not raw counts, because stacks are the
    unit a bag slot thinks in. Every food and water staple on the ladders
    vendors in stacks of 20, ammo in stacks of 200, and the consumable
    reagents in stacks of 20, so the stack sizes below are constants of the
    data, not guesses.

    A tick defaults to one stack -- or to defaultStacks, where one is the
    wrong opening offer -- and the dropdown beside it runs to a per-category
    cap: 18 for ammo, where a hunter genuinely fills an 18-slot quiver, and a
    tighter 4 everywhere else, where more stacks than that is just a heavier
    corpse run.

    A STACK SIZE OF 1 turns the same dropdown into a plain count, which is
    what an item that never stacks needs: Soul Shards take a bag slot each, so
    the choice is how many slots to give them, and the dropdown says "20"
    rather than "20 Stacks".

    A category with an explicit choices list offers those counts INSTEAD of
    every number up to a cap. Soul Shards step in fours from 12 to 40 -- a
    soul bag's worth at each of the sizes a warlock actually carries -- which
    is the same question a forty-entry dropdown would ask, without the
    scrolling. maxStacks is the cap for the every-number kind and is what
    choices replaces, so a category sets one or the other, never both.

    A category with fixedAmount instead of a stack size gets no dropdown at
    all: totems are tools you own one of.
]]
local FOOD_STACK_SIZE = 20
local FOOD_MAX_STACKS = 4
local AMMO_STACK_SIZE = 200
local AMMO_MAX_STACKS = 18
local POISON_STACK_SIZE = 20
local POISON_MAX_STACKS = 4
local REAGENT_STACK_SIZE = 20
local REAGENT_MAX_STACKS = 4
local SINGLE_STACK_SIZE = 1
local SOUL_SHARD_CHOICES = { 12, 16, 20, 24, 28, 32, 36, 40 }
local SOUL_SHARD_DEFAULT = 20

--------------------------------------------------------------------------------
-- Ladder And Class Keys
--------------------------------------------------------------------------------

--[[
    Canonical diet numbering (Data/Pet-Foods.lua); the English keys are always
    present alongside the localized aliases.
]]
local DIET = ns.PetDietMap

-- Canonical poison-group numbering (Data/Poisons.lua).
local POISON_GROUP = ns.POISON_GROUPS

--[[
    Class sets. classes on a category is WHO IS OFFERED it (absent = every
    class); defaultFor is who gets it PRE-TICKED when the window opens. Mana
    classes get water ticked; the manaless still see the row, unticked -- a
    warrior can carry water for a druid friend, but nobody decides that for
    them. Death Knights only exist on a Wrath client, which is exactly why
    their entries need no expansion gate of their own: no other client has a
    character that can see them.
]]
local AMMO_CLASSES = { HUNTER = true, WARRIOR = true, ROGUE = true }
local MANA_CLASSES =
	{ DRUID = true, HUNTER = true, MAGE = true, PALADIN = true, PRIEST = true, SHAMAN = true, WARLOCK = true }

--[[
    One entry per checkbox. section groups entries under the popup's
    headings; label reuses the DIET_ keys for food, so the popup names bread
    whatever the pet-food tooltips call it.

    The order HERE is for the maintainer's eye -- grouped by section, then
    by class. Display order is the popup's to compute (SectionCategories in
    Options-Starter-List-Popup.lua): dropdown staples first, fixed-amount
    singles after, each run alphabetical by localized label.

    Built defensively: a category whose ladder went missing is dropped here
    rather than crashing the popup open.
]]
ns.StarterListCategories = {
	--[[
	    Food, everyone. Bread arrives ticked for all; meat ticked for hunters
	    (their pet eats it too).
	]]
	{
		key = "bread",
		section = "food",
		label = L["DIET_BREAD"],
		chainKey = "food:" .. DIET["Bread"],
		stackSize = FOOD_STACK_SIZE,
		maxStacks = FOOD_MAX_STACKS,
		defaultFor = "all",
	},
	{
		key = "cheese",
		section = "food",
		label = L["DIET_CHEESE"],
		chainKey = "food:" .. DIET["Cheese"],
		stackSize = FOOD_STACK_SIZE,
		maxStacks = FOOD_MAX_STACKS,
	},
	{
		key = "fish",
		section = "food",
		label = L["DIET_FISH"],
		chainKey = "food:" .. DIET["Fish"],
		stackSize = FOOD_STACK_SIZE,
		maxStacks = FOOD_MAX_STACKS,
	},
	{
		key = "fruit",
		section = "food",
		label = L["DIET_FRUIT"],
		chainKey = "food:" .. DIET["Fruit"],
		stackSize = FOOD_STACK_SIZE,
		maxStacks = FOOD_MAX_STACKS,
	},
	{
		key = "fungus",
		section = "food",
		label = L["DIET_FUNGUS"],
		chainKey = "food:" .. DIET["Fungus"],
		stackSize = FOOD_STACK_SIZE,
		maxStacks = FOOD_MAX_STACKS,
	},
	{
		key = "meat",
		section = "food",
		label = L["DIET_MEAT"],
		chainKey = "food:" .. DIET["Meat"],
		stackSize = FOOD_STACK_SIZE,
		maxStacks = FOOD_MAX_STACKS,
		defaultFor = { HUNTER = true },
	},

	-- Water, everyone; pre-ticked for the classes that drink for mana.
	{
		key = "water",
		section = "water",
		label = L["LABEL_WATER"],
		chainKey = "water",
		stackSize = FOOD_STACK_SIZE,
		maxStacks = FOOD_MAX_STACKS,
		defaultFor = MANA_CLASSES,
	},

	-- Ammo, launcher classes only.
	{
		key = "bullets",
		section = "ammo",
		label = L["STARTER_POPUP_BULLETS"],
		chainKey = "bullet",
		stackSize = AMMO_STACK_SIZE,
		maxStacks = AMMO_MAX_STACKS,
		classes = AMMO_CLASSES,
	},
	{
		key = "arrows",
		section = "ammo",
		label = L["STARTER_POPUP_ARROWS"],
		chainKey = "arrow",
		stackSize = AMMO_STACK_SIZE,
		maxStacks = AMMO_MAX_STACKS,
		classes = AMMO_CLASSES,
	},

	--[[
	    Poisons, their own headed section for rogues (alphabetical, like the
	    foods) -- the popup adds a note under its header that the ingredients
	    buy themselves. Availability does the level work: every ladder opens
	    at its spell's training level, so the section fills out as the rogue
	    earns each type -- and Anesthetic's all-TBC ladder simply never comes
	    up on Era.
	]]
	{
		key = "anesthetic",
		section = "poisons",
		label = L["STARTER_POPUP_POISON_ANESTHETIC"],
		chainKey = "poison:" .. POISON_GROUP.ANESTHETIC,
		stackSize = POISON_STACK_SIZE,
		maxStacks = POISON_MAX_STACKS,
		classes = { ROGUE = true },
	},
	{
		key = "crippling",
		section = "poisons",
		label = L["STARTER_POPUP_POISON_CRIPPLING"],
		chainKey = "poison:" .. POISON_GROUP.CRIPPLING,
		stackSize = POISON_STACK_SIZE,
		maxStacks = POISON_MAX_STACKS,
		classes = { ROGUE = true },
	},
	{
		key = "deadly",
		section = "poisons",
		label = L["STARTER_POPUP_POISON_DEADLY"],
		chainKey = "poison:" .. POISON_GROUP.DEADLY,
		stackSize = POISON_STACK_SIZE,
		maxStacks = POISON_MAX_STACKS,
		classes = { ROGUE = true },
	},
	{
		key = "instant",
		section = "poisons",
		label = L["STARTER_POPUP_POISON_INSTANT"],
		chainKey = "poison:" .. POISON_GROUP.INSTANT,
		stackSize = POISON_STACK_SIZE,
		maxStacks = POISON_MAX_STACKS,
		classes = { ROGUE = true },
	},
	{
		key = "mindnumbing",
		section = "poisons",
		label = L["STARTER_POPUP_POISON_MIND_NUMBING"],
		chainKey = "poison:" .. POISON_GROUP.MIND_NUMBING,
		stackSize = POISON_STACK_SIZE,
		maxStacks = POISON_MAX_STACKS,
		classes = { ROGUE = true },
	},
	{
		key = "wound",
		section = "poisons",
		label = L["STARTER_POPUP_POISON_WOUND"],
		chainKey = "poison:" .. POISON_GROUP.WOUND,
		stackSize = POISON_STACK_SIZE,
		maxStacks = POISON_MAX_STACKS,
		classes = { ROGUE = true },
	},
	--[[
	    Reagents & Tools. Hearthstone is offered to every class -- the worked
	    example that ANYTHING can go on the Restock List, not just the
	    consumables the add-on curates -- alongside each class's own entries.
	]]
	{
		key = "hearthstone",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_HEARTHSTONE"],
		chainKey = "reagent:hearthstone",
		fixedAmount = 1,
	},
	{
		key = "blindingpowder",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_BLINDING_POWDER"],
		chainKey = "reagent:blinding-powder",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { ROGUE = true },
	},
	{
		key = "flashpowder",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_FLASH_POWDER"],
		chainKey = "reagent:flash-powder",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { ROGUE = true },
	},
	-- A tool, not a consumable: you own one.
	{
		key = "thievestools",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"],
		chainKey = "reagent:thieves-tools",
		fixedAmount = 1,
		classes = { ROGUE = true },
	},

	{
		key = "corpsedust",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_CORPSE_DUST"],
		chainKey = "reagent:corpse-dust",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { DEATHKNIGHT = true },
	},

	{
		key = "seeds",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_SEEDS"],
		chainKey = "reagent:seeds",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { DRUID = true },
	},
	{
		key = "wilds",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_WILDS"],
		chainKey = "reagent:wilds",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { DRUID = true },
	},

	-- Light Feather serves the mage's Slow Fall and the priest's Levitate.
	{
		key = "arcanepowder",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_ARCANE_POWDER"],
		chainKey = "reagent:arcane-powder",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { MAGE = true },
	},
	{
		key = "lightfeather",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"],
		chainKey = "reagent:light-feather",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { MAGE = true, PRIEST = true },
	},
	{
		key = "teleportrunes",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"],
		chainKey = "reagent:rune-of-teleportation",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { MAGE = true },
	},
	{
		key = "portalrunes",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_PORTAL_RUNES"],
		chainKey = "reagent:rune-of-portals",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { MAGE = true },
	},

	{
		key = "divinitysymbol",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"],
		chainKey = "reagent:symbol-of-divinity",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { PALADIN = true },
	},
	{
		key = "kingssymbol",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"],
		chainKey = "reagent:symbol-of-kings",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { PALADIN = true },
	},

	{
		key = "candles",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_CANDLES"],
		chainKey = "reagent:candles",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { PRIEST = true },
	},

	{
		key = "ankh",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_ANKH"],
		chainKey = "reagent:ankh",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { SHAMAN = true },
	},
	{
		key = "fishscales",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_FISH_SCALES"],
		chainKey = "reagent:fish-scales",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { SHAMAN = true },
	},
	{
		key = "fishoil",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_FISH_OIL"],
		chainKey = "reagent:fish-oil",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { SHAMAN = true },
	},
	-- Totems are tools: one each, no dropdown.
	{
		key = "earthtotem",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_EARTH_TOTEM"],
		chainKey = "reagent:earth-totem",
		fixedAmount = 1,
		classes = { SHAMAN = true },
	},
	{
		key = "firetotem",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_FIRE_TOTEM"],
		chainKey = "reagent:fire-totem",
		fixedAmount = 1,
		classes = { SHAMAN = true },
	},
	{
		key = "watertotem",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_WATER_TOTEM"],
		chainKey = "reagent:water-totem",
		fixedAmount = 1,
		classes = { SHAMAN = true },
	},
	{
		key = "airtotem",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_AIR_TOTEM"],
		chainKey = "reagent:air-totem",
		fixedAmount = 1,
		classes = { SHAMAN = true },
	},

	--[[
	    Soul Shards never stack, so their dropdown counts bag slots rather than
	    stacks (stackSize 1), offering the soul-bag sizes above and opening on
	    a middling one.
	]]
	{
		key = "figurine",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_FIGURINE"],
		chainKey = "reagent:demonic-figurine",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { WARLOCK = true },
	},
	{
		key = "infernalstone",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_INFERNAL_STONE"],
		chainKey = "reagent:infernal-stone",
		stackSize = REAGENT_STACK_SIZE,
		maxStacks = REAGENT_MAX_STACKS,
		classes = { WARLOCK = true },
	},
	{
		key = "soulshards",
		section = "reagents",
		label = L["STARTER_POPUP_REAGENT_SOUL_SHARDS"],
		chainKey = "reagent:soul-shard",
		stackSize = SINGLE_STACK_SIZE,
		choices = SOUL_SHARD_CHOICES,
		defaultStacks = SOUL_SHARD_DEFAULT,
		classes = { WARLOCK = true },
	},
}
