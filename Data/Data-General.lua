local _, ns = ...

ns.L = LibStub("AceLocale-3.0"):GetLocale("Connoisseur")

--------------------------------------------------------------------------------
-- Brand Colors
--------------------------------------------------------------------------------

local C_TITLE = "FFD100" -- Gold: Titles, Headers, Section Names
local C_INFO = "00BBFF" -- Blue: Interactions, Toggles, Links, Keybinds, Slash Commands
local C_BODY = "CCCCCC" -- Silver: Descriptions, Help Text
local C_TEXT = "FFFFFF" -- White: Messages, Values, Spell Names
local C_ON = "33CC33" -- Green: On
local C_OFF = "CC3333" -- Red: Off
local C_SEPARATOR = "AAAAAA" -- Gray: Separators, Dividers
local C_MUTED = "808080" -- Dark Gray: Meta-data, Version Numbers

local COLOR_PREFIX = "|cff"

local COLORS = {
    TITLE = COLOR_PREFIX .. C_TITLE,
    INFO = COLOR_PREFIX .. C_INFO,
    DESC = COLOR_PREFIX .. C_BODY,
    TEXT = COLOR_PREFIX .. C_TEXT,
    ON = COLOR_PREFIX .. C_ON,
    OFF = COLOR_PREFIX .. C_OFF,
    SEPARATOR = COLOR_PREFIX .. C_SEPARATOR,
    MUTED = COLOR_PREFIX .. C_MUTED
}

function ns.GetColor(key)
    return COLORS[key] or COLORS.TEXT
end

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
    ITEMS = "A335EE"
}

--------------------------------------------------------------------------------
-- URLs
--------------------------------------------------------------------------------

ns.CURSEFORGE_URL = "https://www.curseforge.com/wow/addons/consumable-connoisseur"
ns.GITHUB_URL = "https://github.com/Gogo1951/Connoisseur"
ns.DISCORD_URL = "https://discord.gg/eh8hKq992Q"

--------------------------------------------------------------------------------
-- Icons
--------------------------------------------------------------------------------

-- Interface\Icons\INV_Misc_QuestionMark
ns.QUESTION_MARK_ICON = 134400

--------------------------------------------------------------------------------
-- Macro Configuration
--------------------------------------------------------------------------------

ns.Config = {
    ["Bandage"] = {macro = ns.L["MACRO_BANDAGE"], defaultID = 1251},
    ["Food"] = {macro = ns.L["MACRO_FOOD"], defaultID = 5349},
    ["Health Potion"] = {macro = ns.L["MACRO_HEALTH_POTION"], defaultID = 118},
    ["Healthstone"] = {macro = ns.L["MACRO_HEALTHSTONE"], defaultID = 5512},
    ["Mana Gem"] = {macro = ns.L["MACRO_MANA_GEM"], defaultID = 5514},
    ["Mana Potion"] = {macro = ns.L["MACRO_MANA_POTION"], defaultID = 2455},
    ["Soulstone"] = {macro = ns.L["MACRO_SOULSTONE"], defaultID = 5232},
    ["Water"] = {macro = ns.L["MACRO_WATER"], defaultID = 5350},
    ["Feed Pet"] = {macro = ns.L["MACRO_FEED_PET"], defaultID = 117}
}

--------------------------------------------------------------------------------
-- Shadowmeld
--------------------------------------------------------------------------------

ns.SHADOWMELD_SPELL_ID = 20580

--------------------------------------------------------------------------------
-- Druid Forms (DruidMacroHelper integration)
--------------------------------------------------------------------------------

ns.DRUID_DIRE_BEAR_FORM_SPELL_ID = 9634
ns.DRUID_BEAR_FORM_SPELL_ID = 5487
ns.DRUID_CAT_FORM_SPELL_ID = 768

-- Which macro types are eligible for DMH wrapping when the druid toggle is on.
ns.DMHMacroTypes = {
    ["Health Potion"] = true,
    ["Mana Potion"]   = true,
    ["Healthstone"]   = true,
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
    ["Healthstone"]   = { "/dmh start", "/dmh cd hs" },
    ["Mana Potion"]   = { "/dmh stun gcd cd pot" },
}

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

--[[
    Canned chat messages the macro bodies can fire via `/run ConnTip("key")`.
    ConnTip (in Core.lua) consults two tables:
      ns.MessageStrings        → static message text
      ns.MissingSpellMessageIDs → spell IDs that ConnTip resolves at print time
                                   via GetSpellInfo, producing "You don't
                                   currently know <Localized Spell Name>."
    A spell ID that doesn't exist on the current client (e.g. Refreshment
    Table in Era 1.15) returns nil from GetSpellInfo, so ConnTip silently
    skips the print rather than naming a spell the player will never see.
]]

ns.MessageStrings = {
    nofood   = "You don't currently have any food that is useful for your pet.",
    noskills = "You don't currently know Feed Pet, Mend Pet, or Revive Pet.",
    nomend   = "You don't currently know Mend Pet.",
}

--[[
    Mage and Warlock conjure spell IDs — keyed match the conjure tables
    above. The IDs here are the rank-1 entries from ns.ConjureSpells.
]]
ns.MissingSpellMessageIDs = {
    -- Mage conjures
    ncwater = 5504,  -- Conjure Water (rank 1)
    ncfood  = 587,   -- Conjure Food (rank 1)
    ncgem   = 759,   -- Conjure Mana Agate
    nctable = 43987, -- Refreshment Table (TBC+)
    -- Warlock conjures
    nchs = 6201,  -- Create Healthstone (Minor)
    ncss = 693,   -- Create Soulstone (Minor)
    ncsw = 29893, -- Ritual of Souls (TBC+)
}

--------------------------------------------------------------------------------
-- Hunter Pet Spells
--------------------------------------------------------------------------------

ns.FEED_PET_SPELL_ID = 6991
ns.REVIVE_PET_SPELL_ID = 982
ns.MEND_PET_SPELL_ID = 136
ns.CALL_PET_SPELL_ID = 883
ns.DISMISS_PET_SPELL_ID = 2641

--------------------------------------------------------------------------------
-- Pet Buff Food
--------------------------------------------------------------------------------

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
    [23697] = true -- Alterac Spring Water
}

--------------------------------------------------------------------------------
-- Default Settings
--------------------------------------------------------------------------------

ns.SETTINGS_DEFAULTS = {
    useBuffFood = false,
    buffFoodMode = "always",
    useScrolls = false,
    scrollsMode = "always",
    scrollTypes = {
        Agility = true,
        Intellect = true,
        Protection = true,
        Spirit = true,
        Stamina = true,
        Strength = true
    },
    enableShadowmeldDrinking = false,
    enableDruidMacroHelper = false,
    druidReturnForm = "bear",
    usePetBuffFood = false,
    petBuffFoodMode = "always",
    petBuffTypes = {
        KiblersBits = true,
        SporelingSnacks = true
    },
    enabledMacros = {
        ["Bandage"] = true,
        ["Feed Pet"] = true,
        ["Food"] = true,
        ["Health Potion"] = true,
        ["Healthstone"] = true,
        ["Mana Gem"] = true,
        ["Mana Potion"] = true,
        ["Soulstone"] = true,
        ["Water"] = true
    }
}

--------------------------------------------------------------------------------
-- Mode Order
--------------------------------------------------------------------------------

ns.MODE_ORDER = {"always", "party", "raid"}

--------------------------------------------------------------------------------
-- Mage and Warlock Spells
--------------------------------------------------------------------------------

-- { spellID, requiredLevel[, rankNumber] }
ns.ConjureSpells = {
    MageCreateTable = {
        {43987, 70}
    },
    MageCreateWater = {
        {27090, 65, 9}, -- Conjured Glacier Water
        {37420, 60, 8}, -- Conjured Mountain Spring Water
        {10140, 55, 7}, -- Conjured Crystal Water
        {10139, 45, 6}, -- Conjured Sparkling Water
        {10138, 35, 5}, -- Conjured Mineral Water
        {6127, 25, 4}, -- Conjured Spring Water
        {5506, 15, 3}, -- Conjured Fresh Water
        {5505, 5, 2}, -- Conjured Purified Water
        {5504, 1, 1} -- Conjured Fresh Water
    },
    MageCreateFood = {
        {33717, 65, 8}, -- Magical Croissant
        {28612, 55, 7}, -- Conjured Cinnamon Roll
        {10145, 45, 6}, -- Conjured Sweet Roll
        {10144, 35, 5}, -- Conjured Sourdough
        {6129, 25, 4}, -- Conjured Pumpernickel
        {990, 15, 3}, -- Conjured Rye
        {597, 5, 2}, -- Conjured Bread
        {587, 1, 1} -- Conjured Muffin
    },
    MageCreateManaGem = {
        {27101, 68}, -- Conjure Mana Emerald
        {10054, 58}, -- Conjure Mana Ruby
        {10053, 48}, -- Conjure Mana Citrine
        {3552, 38}, -- Conjure Mana Jade
        {759, 28} -- Conjure Mana Agate
    },
    WarlockCreateSoulwell = {
        {29893, 68}
    },
    WarlockCreateHealthstone = {
        {27230, 60, 6}, -- Master Healthstone
        {11730, 48, 5}, -- Major Healthstone
        {11729, 36, 4}, -- Greater Healthstone
        {5699, 24, 3}, -- Healthstone
        {6202, 12, 2}, -- Lesser Healthstone
        {6201, 1, 1} -- Minor Healthstone
    },
    WarlockCreateSoulstone = {
        {27238, 70, 6}, -- Master Soulstone
        {20757, 60, 5}, -- Major Soulstone
        {20756, 50, 4}, -- Greater Soulstone
        {20755, 40, 3}, -- Soulstone
        {20752, 30, 2}, -- Lesser Soulstone
        {693, 18, 1} -- Minor Soulstone
    }
}