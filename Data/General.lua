local _, ns = ...

assert(ns.L, "Consumable Connoisseur: Locales must be loaded before Data/General.lua — check your .toc load order.")

--------------------------------------------------------------------------------
-- Brand Colors
--------------------------------------------------------------------------------

ns.Colors = {
    TITLE    = "FFD100",
    INFO     = "00BBFF",
    DESC     = "CCCCCC",
    TEXT     = "FFFFFF",
    SUCCESS  = "33CC33",
    DISABLED = "CC3333",
    SEP      = "AAAAAA",
    MUTED    = "808080",
}

function ns.GetColor(key)
    return "|cff" .. (ns.Colors[key] or ns.Colors.TEXT)
end


--------------------------------------------------------------------------------
-- URLs
--------------------------------------------------------------------------------

ns.CURSEFORGE_URL = "https://www.curseforge.com/wow/addons/consumable-connoisseur"
ns.GITHUB_URL     = "https://github.com/Gogo1951/Consumable-Connoisseur"
ns.DISCORD_URL    = "https://discord.gg/eh8hKq992Q"

--------------------------------------------------------------------------------
-- Macro Configuration
--------------------------------------------------------------------------------

ns.Config = {
    ["Bandage"]       = { macro = ns.L["MACRO_BANDAGE"], defaultID = 1251  },
    ["Food"]          = { macro = ns.L["MACRO_FOOD"],    defaultID = 5349  },
    ["Health Potion"] = { macro = ns.L["MACRO_HPOT"],    defaultID = 118   },
    ["Healthstone"]   = { macro = ns.L["MACRO_HS"],      defaultID = 5512  },
    ["Mana Gem"]      = { macro = ns.L["MACRO_MGEM"],    defaultID = 5514  },
    ["Mana Potion"]   = { macro = ns.L["MACRO_MPOT"],    defaultID = 2455  },
    ["Soulstone"]     = { macro = ns.L["MACRO_SS"],      defaultID = 5232  },
    ["Water"]         = { macro = ns.L["MACRO_WATER"],   defaultID = 5350  },
}

--------------------------------------------------------------------------------
-- Additional "Well Fed" Buff IDs
--------------------------------------------------------------------------------

ns.WellFedBuffIDs = {
    [18125] = true, -- blessed-sunfruit
    [18141] = true, -- blessed-sunfruit-juice
    [18191] = true, -- increased-stamina
    [18192] = true, -- increased-agility
    [18193] = true, -- increased-spirit
    [18194] = true, -- mana-regeneration
    [18222] = true, -- health-regeneration
    [22730] = true, -- increased-intellect
    [23697] = true, -- alterac-spring-water
}

--------------------------------------------------------------------------------
-- Default Settings
--------------------------------------------------------------------------------

ns.SETTINGS_DEFAULTS = {
    useBuffFood = false,
    useScrolls  = false,
    scrollTypes = {
        Agility    = true,
        Intellect  = true,
        Protection = true,
        Spirit     = true,
        Stamina    = true,
        Strength   = true,
    },
}

--------------------------------------------------------------------------------
-- Utility
--------------------------------------------------------------------------------

function ns.KnowsAny(spellList)
    if not spellList then return false end
    for _, data in ipairs(spellList) do
        if IsSpellKnown(data[1]) then
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- Mage and Warlock Spells
--------------------------------------------------------------------------------

ns.ConjureSpells = {
    MageCreateTable = {
        { 43987, 70 },
    },
    MageCreateWater = {
        { 27090, 65, 9 }, -- Rank 9 (Conjured Glacier Water)
        { 37420, 60, 8 }, -- Rank 8 (Conjured Mountain Spring Water)
        { 10140, 55, 7 }, -- Rank 7 (Conjured Crystal Water)
        { 10139, 45, 6 }, -- Rank 6 (Conjured Sparkling Water)
        { 10138, 35, 5 }, -- Rank 5 (Conjured Mineral Water)
        { 6127,  25, 4 }, -- Rank 4 (Conjured Spring Water)
        { 5506,  15, 3 }, -- Rank 3 (Conjured Fresh Water)
        { 5505,   5, 2 }, -- Rank 2 (Conjured Purified Water)
        { 5504,   1, 1 }, -- Rank 1 (Conjured Fresh Water)
    },
    MageCreateFood = {
        { 33717, 65, 8 }, -- Rank 8 (Magical Croissant)
        { 28612, 55, 7 }, -- Rank 7 (Conjured Cinnamon Roll)
        { 10145, 45, 6 }, -- Rank 6 (Conjured Sweet Roll)
        { 10144, 35, 5 }, -- Rank 5 (Conjured Sourdough)
        { 6129,  25, 4 }, -- Rank 4 (Conjured Pumpernickel)
        { 990,   15, 3 }, -- Rank 3 (Conjured Rye)
        { 597,    5, 2 }, -- Rank 2 (Conjured Bread)
        { 587,    1, 1 }, -- Rank 1 (Conjured Muffin)
    },
    MageCreateManaGem = {
        { 27101, 68 }, -- Conjure Mana Emerald
        { 10054, 58 }, -- Conjure Mana Ruby
        { 10053, 48 }, -- Conjure Mana Citrine
        { 3552,  38 }, -- Conjure Mana Jade
        { 759,   28 }, -- Conjure Mana Agate
    },
    WarlockCreateSoulwell = {
        { 29893, 68 },
    },
    WarlockCreateHealthstone = {
        { 27230, 60, 6 }, -- Rank 6 (Master Healthstone)
        { 11730, 48, 5 }, -- Rank 5 (Major Healthstone)
        { 11729, 36, 4 }, -- Rank 4 (Greater Healthstone)
        { 5699,  24, 3 }, -- Rank 3 (Healthstone)
        { 6202,  12, 2 }, -- Rank 2 (Lesser Healthstone)
        { 6201,   1, 1 }, -- Rank 1 (Minor Healthstone)
    },
    WarlockCreateSoulstone = {
        { 27238, 70, 6 }, -- Rank 6 (Master Soulstone)
        { 20757, 60, 5 }, -- Rank 5 (Major Soulstone)
        { 20756, 50, 4 }, -- Rank 4 (Greater Soulstone)
        { 20755, 40, 3 }, -- Rank 3 (Soulstone)
        { 20752, 30, 2 }, -- Rank 2 (Lesser Soulstone)
        { 693,   18, 1 }, -- Rank 1 (Minor Soulstone)
    },
}