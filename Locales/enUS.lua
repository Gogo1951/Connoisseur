local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "enUS", true)
if not L then return end

-- [[ DEFAULT ENGLISH (enUS) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["BRAND"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Bandage"
L["MACRO_FEED_PET"] = "- Feed Pet"
L["MACRO_FOOD"] = "- Food"
L["MACRO_HEALTH_POTION"] = "- Health Potion"
L["MACRO_HEALTHSTONE"] = "- Healthstone"
L["MACRO_MANA_GEM"] = "- Mana Gem"
L["MACRO_MANA_POTION"] = "- Mana Potion"
L["MACRO_SOULSTONE"] = "- Soulstone"
L["MACRO_WATER"] = "- Water"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "Rank"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] = "Looks like you found a bug! %s (%s) can't be used in %s > %s (%s). Please report this so we can get it fixed. Thanks! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "No suitable %s found in your bags."

L["CHAT_LOADED"] = "Version @project-version@. Settings (including the option to disable this message) can be found under Options > AddOns > Connoisseur. Enjoying the addon? Tell a friend about it! (="

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "Prioritize Buff Food"
L["MENU_BUFF_FOOD_DESC"] = 'Prioritizes food that grants the "Well Fed" buff, when the buff is missing.'
L["MENU_CLEAR_IGNORE"] = "Clear Ignore List"
L["MENU_IGNORE"] = "Ignore"

L["MENU_SCROLL_BUFFS"] = "Scroll Buffs"
L["MENU_SCROLL_BUFFS_DESC"] = "Turns your Food macro into a scroll-applier when you're missing scroll buffs."
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

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Always"
L["MODE_PARTY"] = "Only when in Party"
L["MODE_RAID"] = "Only when in Raid"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "Auto-updating macros for your best food, buff food, water, healing and mana potions, healthstones, scrolls, soulstones, mana gems, and bandages. One-click conjuring for Mages and Warlocks, smart Feed Pet for Hunters. Optimal nutrition, peak performance."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Enable Welcome Message"
L["OPTIONS_WELCOME_MESSAGE_DESC"] = "Print a welcome message in chat on login."

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "Prioritize Buff Food"
L["OPTIONS_BUFF_FOOD_DESC"] = 'Prioritizes food that grants the "Well Fed" buff, when the buff is missing.'

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Scroll Buffs"
L["OPTIONS_USE_SCROLLS"] = "Include Scroll Buffs"
L["OPTIONS_USE_SCROLLS_DESC"] = "Turns your Food macro into a dedicated scroll-applier whenever you're missing scroll buffs. Tap once to apply scrolls; tap again to eat. Scrolls are off the GCD, target you, and the macro reverts to food the moment you target another friendly player."
L["OPTIONS_SCROLL_TYPES"] = "Include Scroll Types in Check"
L["OPTIONS_SCROLL_AGILITY"] = "Agility"
L["OPTIONS_SCROLL_INTELLECT"] = "Intellect"
L["OPTIONS_SCROLL_PROTECTION"] = "Protection"
L["OPTIONS_SCROLL_SPIRIT"] = "Spirit"
L["OPTIONS_SCROLL_STAMINA"] = "Stamina"
L["OPTIONS_SCROLL_STRENGTH"] = "Strength"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Pets Food Buffs"
L["OPTIONS_USE_PET_BUFFS"] = "Use Pet Food Buffs"
L["OPTIONS_USE_PET_BUFFS_DESC"] = 'Uses Pet Food, as part of your Food macro, when the "Well Fed" buff is missing from your pet.'
L["OPTIONS_PET_BUFF_TYPES"] = "Include Pet Food Types in Check"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Kibler's Bits"
L["OPTIONS_PET_BUFF_SPORELING"] = "Sporeling Snacks"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druids"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Enable DruidMacroHelper Integration"
L["OPTIONS_DRUID_MACRO_HELPER_DESC"] = "Builds powershifting macros for Health Potions, Mana Potions, and Healthstones using DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "After Consumable, Switch to"
L["DRUID_FORM_BEAR"] = "Bear"
L["DRUID_FORM_CAT"] = "Cat"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Night Elves"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Shadowmeld Drinking"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Appends Shadowmeld to your Water macro so you stealth while drinking."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Opens the Connoisseur options interface."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Enable Macros"
L["OPTIONS_ENABLE_MACROS_DESC"] = "Toggle which macros Connoisseur creates and maintains. Disabling a macro will also remove it."

-- Reset
L["OPTIONS_RESET_HEADER"] = "Reset"
L["OPTIONS_RESET_IGNORE_DESC"] = "Remove all items from the ignore list."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Are you sure you want to clear the ignore list?"
L["OPTIONS_RESET_ALL"] = "Reset All Connoisseur Options"
L["OPTIONS_RESET_ALL_DESC"] = "Reset all settings and the ignore list back to defaults."
L["OPTIONS_RESET_ALL_CONFIRM"] = "Reset all Connoisseur options to defaults?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback & Support"
