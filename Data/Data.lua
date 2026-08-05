local ADDON_NAME, ns = ...

--[[
    Canonical in-Lua identity (brand name), decoupled from the packaged
    folder/slug — ADDON_NAME is "Consumable-Connoisseur". This is the single
    source for the AceLocale GetLocale lookup, the LibDBIcon registration key,
    and the LDB object name, so all three stay in lockstep and match the
    NewLocale("Connoisseur") literal in every Locales/ file. APIs keyed off the
    packaged add-on (GetAddOnMetadata, the TOC Version token) still use
    ADDON_NAME, not this.
]]
ns.LOCALE_NAME = "Connoisseur"

ns.L = LibStub("AceLocale-3.0"):GetLocale(ns.LOCALE_NAME)

--------------------------------------------------------------------------------
-- Brand Colors
--------------------------------------------------------------------------------

local C_TITLE = "FFD100" -- Gold: Titles, Headers, Section Names
local C_INFO = "00BBFF" -- Blue: Interactions, Toggles, Links, Keybinds, Slash Commands
local C_BODY = "FFFFFF" -- White: Descriptions, Options Body Text
local C_HELP = "CCCCCC" -- Silver: Pro Tips, Helper Text
local C_TEXT = "FFFFFF" -- White: Messages, Values, Spell Names
local C_ON = "33CC33" -- Green: On
local C_OFF = "CC3333" -- Red: Off
local C_SEPARATOR = "AAAAAA" -- Gray: Separators, Dividers
local C_MUTED = "808080" -- Dark Gray: Meta-data, Version Numbers

--[[
    Raw hex palette. Features/Utilities.lua derives the |cff-prefixed COLORS
    table and the ns.GetColor accessor from this, keeping Data files logic-free.
]]
ns.PALETTE = {
	TITLE = C_TITLE,
	INFO = C_INFO,
	BODY = C_BODY,
	HELP = C_HELP,
	TEXT = C_TEXT,
	ON = C_ON,
	OFF = C_OFF,
	SEPARATOR = C_SEPARATOR,
	MUTED = C_MUTED,
}

--------------------------------------------------------------------------------
-- Class Colors
--------------------------------------------------------------------------------

ns.CLASS_COLORS = {
	DEATHKNIGHT = "C41E3A",
	DRUID = "FF7C0A",
	HUNTER = "AAD372",
	MAGE = "3FC7EB",
	PALADIN = "F48CBA",
	PRIEST = "FFFFFF",
	ROGUE = "FFF468",
	SHAMAN = "0070DD",
	WARLOCK = "8788EE",
	WARRIOR = "C69B6D",
}

--------------------------------------------------------------------------------
-- URLs
--------------------------------------------------------------------------------

ns.CURSEFORGE_URL = "https://www.curseforge.com/wow/addons/consumable-connoisseur"
ns.GITHUB_URL = "https://github.com/Gogo1951/Connoisseur"
ns.DISCORD_URL = "https://discord.gg/eh8hKq992Q"
ns.WAGO_URL = "https://addons.wago.io/addons/connoisseur"

--------------------------------------------------------------------------------
-- AceConfig Registry Names
--------------------------------------------------------------------------------

--[[
    Stable AceConfig appName per options panel, derived from ADDON_NAME. Read by
    Options/*.lua for RegisterOptionsTable / AddToBlizOptions. Never localized,
    never built inline.
]]
ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME .. "_General",
	Profiles = ADDON_NAME .. "_Profiles",
	Diagnostics = ADDON_NAME .. "_Diagnostics",
}

--------------------------------------------------------------------------------
-- Icons
--------------------------------------------------------------------------------

-- Interface\Icons\INV_Misc_QuestionMark
ns.QUESTION_MARK_ICON = 134400

--------------------------------------------------------------------------------
-- Options Layout Grid
--------------------------------------------------------------------------------

--[[
    Widths for the label-beside-control rows in Options/. A row is an
    ns.OptionsRowLabel cell plus its control, and the two always total
    ns.OPTIONS_ROW_WIDTH, so every row ends where every other row ends. A row
    whose control needs more room passes its own width to ns.OptionsRowLabel and
    gives the control the remainder.
]]
ns.OPTIONS_ROW_WIDTH = 2.6
ns.OPTIONS_LABEL_WIDTH = 1.3
ns.OPTIONS_CONTROL_WIDTH = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_LABEL_WIDTH

-- The item lists' remove column, sized to its icon rather than a caption.
ns.OPTIONS_REMOVE_ICON_WIDTH = 0.25

-- The blank cell a sub-option row leads with, sized to the parent's checkbox.
ns.OPTIONS_SUB_INDENT_WIDTH = 0.115

--------------------------------------------------------------------------------
-- Macro Configuration
--------------------------------------------------------------------------------

-- label: localized display name plugged into MSG_NO_ITEM by ConnNoItem.
ns.Config = {
	["Bandage"] = { macro = ns.L["MACRO_BANDAGE"], defaultID = 1251, label = ns.L["LABEL_BANDAGE"] },
	["Explosive"] = { macro = ns.L["MACRO_EXPLOSIVES"], defaultID = 4358, label = ns.L["LABEL_EXPLOSIVE"] },
	["Food"] = { macro = ns.L["MACRO_FOOD"], defaultID = 5349, label = ns.L["LABEL_FOOD"] },
	["Health Potion"] = { macro = ns.L["MACRO_HEALTH_POTION"], defaultID = 118, label = ns.L["LABEL_HEALTH_POTION"] },
	["Healthstone"] = { macro = ns.L["MACRO_HEALTHSTONE"], defaultID = 5512, label = ns.L["LABEL_HEALTHSTONE"] },
	["Mana Gem"] = { macro = ns.L["MACRO_MANA_GEM"], defaultID = 5514, label = ns.L["LABEL_MANA_GEM"] },
	["Mana Potion"] = { macro = ns.L["MACRO_MANA_POTION"], defaultID = 2455, label = ns.L["LABEL_MANA_POTION"] },
	["Soulstone"] = { macro = ns.L["MACRO_SOULSTONE"], defaultID = 5232, label = ns.L["LABEL_SOULSTONE"] },
	["Water"] = { macro = ns.L["MACRO_WATER"], defaultID = 5350, label = ns.L["LABEL_WATER"] },
	["Feed Pet"] = { macro = ns.L["MACRO_FEED_PET"], defaultID = 117, label = ns.L["LABEL_PET_FOOD"] },
	["Poisons"] = { macro = ns.L["MACRO_POISONS"], defaultID = 6947, label = ns.L["LABEL_POISONS"] },
}

--[[
    Macro types whose macros stack up to MULTI_USE_MAX_ITEMS ranked /use
    lines, best item first. Once the best item runs out mid-combat — where
    macros cannot be rewritten — the press falls through to the next-best
    item. Only safe for categories whose items all share an item cooldown,
    so a single press still consumes exactly one item.
]]
ns.MULTI_USE_MAX_ITEMS = 3

ns.MultiUseMacroTypes = {
	["Health Potion"] = true,
	["Healthstone"] = true,
	["Mana Potion"] = true,
}

--[[
    Number of free General macro slots Connoisseur leaves untouched for the
    player. At 0 nothing is reserved, so macro creation pauses only when the
    General macro book is completely full. When it pauses, a once-per-session
    chat message fires and creation resumes automatically once a slot frees
    up. See ns.TryCreateMacro in Macros/Engine.lua.
]]
ns.MACRO_SLOT_CUSHION = 0

--------------------------------------------------------------------------------
-- Stealth Abilities
--------------------------------------------------------------------------------

ns.SHADOWMELD_SPELL_ID = 20580

--[[
    Rogue Stealth, rank 1. GetSpellInfo resolves the base name "Stealth", which
    a bare /cast fires at the highest rank the rogue knows (Stealth Eating).
]]
ns.STEALTH_SPELL_ID = 1784

--------------------------------------------------------------------------------
-- Druid Forms (DruidMacroHelper integration)
--------------------------------------------------------------------------------

ns.DRUID_DIRE_BEAR_FORM_SPELL_ID = 9634
ns.DRUID_BEAR_FORM_SPELL_ID = 5487
ns.DRUID_CAT_FORM_SPELL_ID = 768

-- Which macro types are eligible for DMH wrapping when the druid toggle is on.
ns.DMHMacroTypes = {
	["Health Potion"] = true,
	["Mana Potion"] = true,
	["Healthstone"] = true,
}

--[[
    The /dmh guard prefix lines prepended to each DMH-wrapped macro body.
    Copied from the DruidMacroHelper addon's own example macros:
      HP / HS  → "/dmh start" (stun + GCD + mana) plus a "/dmh cd <token>" line
      MP       → "/dmh stun gcd cd pot" (skips the mana check, since the
                 whole point of a mana pot is that the druid is OOM)
]]
ns.DMHGuards = {
	["Health Potion"] = { "/dmh start", "/dmh cd pot" },
	["Healthstone"] = { "/dmh start", "/dmh cd hs" },
	["Mana Potion"] = { "/dmh stun gcd cd pot" },
}

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

--[[
    Canned chat messages the macro bodies can fire via `/run ConnTip("key")`.
    ConnTip (in Features/Macros/Runtime.lua) consults two tables:
      ns.MessageStrings        → static message text
      ns.MissingSpellMessageIDs → spell IDs that ConnTip resolves at print time
                                   via GetSpellInfo, producing "You don't
                                   currently know <Localized Spell Name>."
    A spell ID that doesn't exist on the current client (e.g. Refreshment
    Table in Era 1.15) returns nil from GetSpellInfo, so ConnTip silently
    skips the print rather than naming a spell the player will never see.
]]
ns.MessageStrings = {
	nofood = ns.L["TIP_PET_NO_FOOD"],
	noskills = ns.L["TIP_PET_NO_SKILLS"],
	nomend = ns.L["TIP_PET_NO_MEND"],
	nopois = ns.L["TIP_NO_HAND_POISON"],
}

--[[
    Mage and Warlock conjure spell IDs — keys match the conjure tables in
    ns.ConjureSpells below. The IDs here are the rank-1 entries from those tables.
]]
ns.MissingSpellMessageIDs = {
	-- Mage conjures
	ncwater = 5504, -- Conjure Water (rank 1)
	ncfood = 587, -- Conjure Food (rank 1)
	ncgem = 759, -- Conjure Mana Agate
	nctable = 43987, -- Ritual of Refreshment (TBC+)
	-- Warlock conjures
	nchs = 6201, -- Create Healthstone (Minor)
	ncss = 693, -- Create Soulstone (Minor)
	ncsw = 29893, -- Ritual of Souls (TBC+)
	-- Rogue poisons
	npois = 2842, -- Poisons (the rogue poison-crafting skill)
}

--------------------------------------------------------------------------------
-- Rogue Poisons Skill
--------------------------------------------------------------------------------

--[[
    "Poisons" (spell 2842) — the rogue poison-crafting skill; the same ID on
    Era and TBC. Knowing it gates the Poisons macro (a rogue without it can't
    apply poisons at all) and provides the middle-click crafting branch.
]]
ns.POISONS_SPELL_ID = 2842

--------------------------------------------------------------------------------
-- Hunter Pet Spells
--------------------------------------------------------------------------------

ns.CALL_PET_SPELL_ID = 883
ns.DISMISS_PET_SPELL_ID = 2641
ns.FEED_PET_SPELL_ID = 6991
ns.MEND_PET_SPELL_ID = 136
ns.REVIVE_PET_SPELL_ID = 982

--------------------------------------------------------------------------------
-- Pet Buff Food
--------------------------------------------------------------------------------
-- Hunter and Warlock pet buff foods.

ns.KIBLERS_BITS_ITEM_ID = 33874
ns.SPORELING_SNACKS_ITEM_ID = 27656

ns.KIBLERS_BUFF_ID = 43771
ns.SPORELING_BUFF_ID = 33272

--------------------------------------------------------------------------------
-- Additional "Well Fed" Buff IDs
--------------------------------------------------------------------------------

-- { buffID = true }
ns.WellFedBuffIDs = {
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

--------------------------------------------------------------------------------
-- Mode Order
--------------------------------------------------------------------------------

ns.MODE_ORDER = { "always", "party", "raid" }

--------------------------------------------------------------------------------
-- Mage and Warlock Spells
--------------------------------------------------------------------------------
--[[
    Conjure spell lists, best rank first. Each entry is:

        { spellID, requiredLevel[, rankNumber][, maxTargetLevel] }

    spellID        The conjure spell the macro /casts.
    requiredLevel  The level needed to USE the conjured item — not the
                   level the spell is learned (Create Healthstone (Minor)
                   is learned at 6, but its stone is usable at level 1).
                   GetSmartSpell compares this against the player's level
                   — or a friendly target's level — so the macro downranks
                   to conjure an item the recipient can actually use. For
                   lists that never downrank by target (Mana Gems,
                   Soulstones) and the ritual utilities (Refreshment
                   Table, Ritual of Souls), it is simply the spell's
                   learn level.
    rankNumber     Optional. When present, the /cast line is written as
                   "Spell Name(Rank N)" to pin that exact rank. Omitted
                   where every entry already has a unique spell name
                   (each Mana Gem tier is its own spell). Lists flagged
                   rankIsTBCOnly pin the rank ONLY on TBC — see the
                   RECURRING BUG note on WarlockCreateHealthstone.
    maxTargetLevel Optional, documentation only (Soulstones) — every
                   consumer (GetSmartSpell, KnowsAny, the Core spell
                   cache) reads only the first three fields.

    A list may also carry named flags (skipped by ipairs, so harmless to
    every entry walker):

    rankIsTBCOnly  The rank column is a TBC-only representation;
                   GetSmartSpell emits the "(Rank N)" suffix for this
                   list only when ns.IsTBC.
]]
ns.ConjureSpells = {
	MageCreateTable = {
		-- {Spell ID, Spell Learn Level}
		{ 58659, 80 }, -- Ritual of Refreshment, Rank 2
		{ 43987, 70 }, -- Ritual of Refreshment, Rank 1
	},
	MageCreateWater = {
		-- {Spell ID, Conjured Item Usage Level, Spell Rank}, -- Conjured Item
		--[[
            Conjure Refreshment (Wrath) makes items that are food AND water,
            so its two ranks lead both lists. The rank column is the spell's
            own rank, not its position here.
        ]]
		{ 42956, 80, 2 }, -- Conjured Mana Strudel (Conjure Refreshment, Rank 2)
		{ 42955, 74, 1 }, -- Conjured Mana Pie (Conjure Refreshment, Rank 1)
		{ 27090, 65, 9 }, -- Conjured Glacier Water
		{ 37420, 60, 8 }, -- Conjured Mountain Spring Water
		{ 10140, 55, 7 }, -- Conjured Crystal Water
		{ 10139, 45, 6 }, -- Conjured Sparkling Water
		{ 10138, 35, 5 }, -- Conjured Mineral Water
		{ 6127, 25, 4 }, -- Conjured Spring Water
		{ 5506, 15, 3 }, -- Conjured Purified Water
		{ 5505, 5, 2 }, -- Conjured Fresh Water
		{ 5504, 1, 1 }, -- Conjured Water
	},
	MageCreateFood = {
		-- {Spell ID, Conjured Item Usage Level, Spell Rank}, -- Conjured Item
		--[[
            Conjure Refreshment (Wrath) makes items that are food AND water,
            so its two ranks lead both lists. The rank column is the spell's
            own rank, not its position here.
        ]]
		{ 42956, 80, 2 }, -- Conjured Mana Strudel (Conjure Refreshment, Rank 2)
		{ 42955, 74, 1 }, -- Conjured Mana Pie (Conjure Refreshment, Rank 1)
		{ 33717, 65, 8 }, -- Conjured Croissant
		{ 28612, 55, 7 }, -- Conjured Cinnamon Roll
		{ 10145, 45, 6 }, -- Conjured Sweet Roll
		{ 10144, 35, 5 }, -- Conjured Sourdough
		{ 6129, 25, 4 }, -- Conjured Pumpernickel
		{ 990, 15, 3 }, -- Conjured Rye
		{ 597, 5, 2 }, -- Conjured Bread
		{ 587, 1, 1 }, -- Conjured Muffin
	},
	MageCreateManaGem = {
		-- {Spell ID, Spell Learn Level}, -- Spell Name
		{ 42985, 77 }, -- Conjure Mana Sapphire
		{ 27101, 68 }, -- Conjure Mana Emerald
		{ 10054, 58 }, -- Conjure Mana Ruby
		{ 10053, 48 }, -- Conjure Mana Citrine
		{ 3552, 38 }, -- Conjure Mana Jade
		{ 759, 28 }, -- Conjure Mana Agate
	},
	WarlockCreateSoulwell = {
		-- {Spell ID, Spell Learn Level}
		{ 58887, 80 }, -- Ritual of Souls, Rank 2
		{ 29893, 68 }, -- Ritual of Souls, Rank 1
	},
	WarlockCreateHealthstone = {
		--[[
            RECURRING BUG — this has broken Era three times; read before
            touching this table, WarlockCreateSoulstone, or GetSmartSpell.
            The warlock stones are represented DIFFERENTLY per flavor:
              • Era:  each tier is its own distinctly-named spell, so
                      GetSpellInfo already returns the fully-qualified name
                      ("Create Healthstone (Minor)"). It must be cast bare —
                      appending "(Rank N)" yields "Create Healthstone
                      (Minor)(Rank 1)", a spell that does not exist, and the
                      /cast silently no-ops.
              • TBC:  one spell with numeric ranks, cast as
                      "Create Healthstone(Rank N)".
            rankIsTBCOnly makes GetSmartSpell pin the rank on TBC only. Mage
            Conjure Water/Food ARE numeric-rank on BOTH flavors, so their
            rank suffix is correct everywhere — do not "simplify" the two
            spell families together.
        ]]
		rankIsTBCOnly = true,
		-- {Spell ID, Conjured Item Usage Level, Spell Rank}, -- Conjured Item
		{ 47878, 69, 8 }, -- Fel Healthstone
		{ 47871, 63, 7 }, -- Demonic Healthstone
		{ 27230, 60, 6 }, -- Master Healthstone
		{ 11730, 48, 5 }, -- Major Healthstone
		{ 11729, 36, 4 }, -- Greater Healthstone
		{ 5699, 24, 3 }, -- Healthstone
		{ 6202, 12, 2 }, -- Lesser Healthstone
		{ 6201, 1, 1 }, -- Minor Healthstone
	},
	WarlockCreateSoulstone = {
		--[[
            Max Target Level: a soulstone cannot be used on players ABOVE
            that level. It needs no selection logic — the caps rise with
            rank, so casting the best known rank always satisfies the cap.
            The resolver passes ignoreTarget=true, which is why the second
            column is the learn level rather than an item usage level.

            rankIsTBCOnly: same Era-vs-TBC representation split as
            Healthstones — see the RECURRING BUG note on
            WarlockCreateHealthstone above.
        ]]
		rankIsTBCOnly = true,
		-- {Spell ID, Spell Learn Level, Spell Rank, Max Target Level}, -- Conjured Item
		{ 47884, 76, 7, 80 }, -- Demonic Soulstone (Wrath)
		{ 27238, 70, 6, 80 }, -- Master Soulstone (TBC)
		{ 20757, 60, 5, 70 }, -- Major Soulstone
		{ 20756, 50, 4, 60 }, -- Greater Soulstone
		{ 20755, 40, 3, 50 }, -- Soulstone
		{ 20752, 30, 2, 40 }, -- Lesser Soulstone
		{ 693, 18, 1, 30 }, -- Minor Soulstone
	},
}
