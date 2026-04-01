local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "enUS", true)
if not L then
    return
end

-- [[ DEFAULT ENGLISH (enUS) ]] --
L["BRAND"] = "Connoisseur"

-- Macro Names Can't Exceed 16 Total Characters
L["MACRO_BANDAGE"] = "- Bandage"
L["MACRO_FOOD"] = "- Food"
L["MACRO_HPOT"] = "- Health Potion"
L["MACRO_HS"] = "- Healthstone"
L["MACRO_MGEM"] = "- Mana Gem"
L["MACRO_MPOT"] = "- Mana Potion"
L["MACRO_SS"] = "- Soulstone"
L["MACRO_WATER"] = "- Water"
L["MACRO_FEED_PET"] = "- Feed Pet"

L["ERR_ZONE"] = "You can't use that here."
L["RANK"] = "Rank"

L["MSG_BUG_REPORT"] = "Looks like you found a bug! %s (%s) can't be used in %s > %s (%s). Please report this so we can get it fixed. Thanks! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "No suitable %s found in your bags."

L["MENU_BUFF_FOOD"] = "Prioritize Buff Food"
L["MENU_BUFF_FOOD_DESC"] = 'Prioritizes food that grants the "Well Fed" buff, when the buff is missing.'
L["MENU_CLEAR_IGNORE"] = "Clear Ignore List"
L["MENU_IGNORE"] = "Ignore"
L["MENU_RESET"] = "Reset"
L["MENU_SCAN"] = "Force Scan"
L["MENU_TITLE"] = "Consumables"

L["MENU_SCROLL_BUFFS"] = "Scroll Buffs"
L["MENU_SCROLL_BUFFS_DESC"] = "Uses attribute scrolls as part of your Food macro when the scroll buff is missing."
L["MENU_OPTIONS_HINT"] = "Additional settings can be found under Options > AddOns > Connoisseur."

L["PREFIX_HUNTER"] = "Attention Hunters"
L["PREFIX_MAGE"] = "Attention Mages"
L["PREFIX_WARLOCK"] = "Attention Warlocks"

L["TIP_DOWNRANK"] = "Targeting a lower-level player will cause the macro to conjure items appropriate for their level."
L["TIP_HUNTER_FEED_PET"] = "Feed Pet is an All-in-One Pet Button! Click to automatically Call, Feed, or Revive your pet. Right-Click or wait for combat to cast Mend Pet. Hold Shift to force Revive, or Ctrl to Dismiss."
L["TIP_MAGE_CONJURE"] = "Right-Click on your Food or Water macros to Create Food or Water."
L["TIP_MAGE_GEM"] = "Right-Click on your Mana Gem macro to conjure a new gem. Right-Click again to conjure a lower-rank backup."
L["TIP_MAGE_TABLE"] = "Middle-click to cast Ritual of Refreshment."
L["TIP_WARLOCK_CONJURE"] = "Right-Click on your Healthstone or Soulstone macros to create a Healthstone or Soulstone."
L["TIP_WARLOCK_SOUL"] = "Middle-click to cast Ritual of Souls."

L["UI_BEST_FOOD"] = "Current Best Food"
L["UI_BEST_PET_FOOD"] = "Current Pet Food"
L["UI_DISABLED"] = "Disabled"
L["UI_ENABLED"] = "Enabled"
L["UI_IGNORE_LIST"] = "Ignore List"
L["UI_LEFT_CLICK"] = "Left-Click"
L["UI_MIDDLE_CLICK"] = "Middle-Click"
L["UI_RIGHT_CLICK"] = "Right-Click"
L["UI_SHIFT_LEFT"] = "Shift + Left-Click"
L["UI_TOGGLE"] = "Toggle"

-- Options Panel
L["OPTIONS_DESC"] = "Creates macros to use the best food, water, potions, healthstones, soulstones, mana gems, or bandages available to you."
L["OPTIONS_BUFF_FOOD"] = "Prioritize Buff Food"
L["OPTIONS_BUFF_FOOD_DESC"] = 'Prioritizes food that grants the "Well Fed" buff, when the buff is missing.'
L["OPTIONS_SCROLL_HEADER"] = "Scroll Buffs"
L["OPTIONS_USE_SCROLLS"] = "Include Scroll Buffs"
L["OPTIONS_USE_SCROLLS_DESC"] = "Uses scrolls, when the scroll buff is missing, as part of your Food macro."
L["OPTIONS_SCROLL_TYPES"] = "Include Scroll Types in Check"
L["OPTIONS_SCROLL_AGILITY"] = "Agility"
L["OPTIONS_SCROLL_INTELLECT"] = "Intellect"
L["OPTIONS_SCROLL_PROTECTION"] = "Protection"
L["OPTIONS_SCROLL_SPIRIT"] = "Spirit"
L["OPTIONS_SCROLL_STAMINA"] = "Stamina"
L["OPTIONS_SCROLL_STRENGTH"] = "Strength"

L["OPTIONS_PET_HEADER"] = "Pets Food Buffs"
L["OPTIONS_USE_PET_BUFFS"] = "Use Pet Food Buffs"
L["OPTIONS_USE_PET_BUFFS_DESC"] = 'Uses Pet Food, as part of your Food macro, when the "Well Fed" buff is missing from your pet.'
L["OPTIONS_PET_BUFF_TYPES"] = "Include Pet Food Types in Check"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Kibler's Bits"
L["OPTIONS_PET_BUFF_SPORELING"] = "Sporeling Snacks"

L["OPTIONS_NIGHTELF_HEADER"] = "Night Elves"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Shadowmeld Drinking"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Appends Shadowmeld to your Water macro so you stealth while drinking."

L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"] = "/foodie"

L["OPTIONS_RESET_HEADER"] = "Reset"
L["OPTIONS_RESET_IGNORE_DESC"] = "Remove all items from the ignore list."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Are you sure you want to clear the ignore list?"
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback & Support"
