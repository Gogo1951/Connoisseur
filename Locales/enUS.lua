local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "enUS", true)
if not L then
	return
end

-- [[ DEFAULT ENGLISH (enUS) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Bandage"
L["MACRO_EXPLOSIVES"] = "- Explosives"
L["MACRO_FEED_PET"] = "- Feed Pet"
L["MACRO_FOOD"] = "- Food"
L["MACRO_HEALTH_POTION"] = "- Health Potion"
L["MACRO_HEALTHSTONE"] = "- Healthstone"
L["MACRO_MANA_GEM"] = "- Mana Gem"
L["MACRO_MANA_POTION"] = "- Mana Potion"
L["MACRO_POISONS"] = "- Poisons"
L["MACRO_SOULSTONE"] = "- Soulstone"
L["MACRO_WATER"] = "- Water"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "Rank"

--------------------------------------------------------------------------------
-- Pet Diets
--------------------------------------------------------------------------------

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

L["DIET_BREAD"] = "Bread"
L["DIET_CHEESE"] = "Cheese"
L["DIET_FISH"] = "Fish"
L["DIET_FRUIT"] = "Fruit"
L["DIET_FUNGUS"] = "Fungus"
L["DIET_MEAT"] = "Meat"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] =
	"Looks like you found a bug! %s (%s) can't be used in %s > %s (%s). Please report this so we can get it fixed. Thanks! %s"
L["MSG_NO_ITEM"] = "No suitable %s found in your bags."
L["MSG_MACRO_SLOTS_FULL"] =
	"Some Connoisseur macros couldn't be created because your macro slots are full. Free up a slot by deleting macros you no longer use, or turn off any Connoisseur macros you don't need under Options > AddOns > Connoisseur."

L["CHAT_LOADED"] =
	"Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Connoisseur. Enjoying the add-on? Tell a friend about it! (="

L["CHAT_OPTIONS_IN_COMBAT"] = "As a safety precaution, the Options Interface cannot be opened during combat."

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "Ready to go!"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "Missing: %s"

L["READY_WELL_FED"] = "Well Fed"
L["READY_SCROLLS"] = "Scrolls"
L["READY_PET_FED"] = "Pet Fed"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d min"
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s under 1 min"

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "You don't currently have any food that is useful for your pet."
L["TIP_PET_NO_SKILLS"] = "You don't currently know Call Pet, Dismiss Pet, Feed Pet, or Revive Pet."
L["TIP_PET_NO_MEND"] = "You don't currently know Mend Pet."
L["TIP_NO_HAND_POISON"] = "You're out of the selected poison for this weapon."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "You don't currently know %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "Buff Food"
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Prioritizes food that grants "Well Fed" whenever the buff is missing.'
L["FEATURE_SCROLL_BUFFS"] = "Scroll Buffs"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "Turns your Food macro into a scroll-applier when you're missing scroll buffs."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Current Food"
L["UI_BEST_PET_FOOD"] = "Current Pet Food"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "Main Hand"
L["UI_OFF_HAND"] = "Off Hand"
L["UI_IGNORE_LIST"] = "Ignore List"
L["MENU_IGNORE"] = "Ignore"
L["MENU_CLEAR_IGNORE"] = "Clear Ignore List"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Connoisseur Options"
L["MENU_OPTIONS_KEYBIND"] = "Shift + Middle-Click"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

L["PREFIX_HUNTER"] = "Attention Hunters"
L["PREFIX_MAGE"] = "Attention Mages"
L["PREFIX_ROGUE"] = "Attention Rogues"
L["PREFIX_WARLOCK"] = "Attention Warlocks"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to — the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "Regarding your Feed Pet macro..."
L["TIP_MAGE_MACROS"] = "Regarding your Food, Water, and Mana Gem macros..."
L["TIP_ROGUE_MACROS"] = "Regarding your Poisons macro..."
L["TIP_WARLOCK_MACROS"] = "Regarding your Healthstone and Soulstone macros..."

L["TIP_HUNTER_ALL_IN_ONE"] = "Feed Pet is an All-in-One Pet Button!"
L["TIP_HUNTER_CALL"] = "Left-Click to automatically Call, Feed, or Revive your pet."
L["TIP_HUNTER_MEND"] = "Right-Click or wait for combat to cast Mend Pet."
L["TIP_HUNTER_MODIFIERS"] = "Hold Shift to force Revive, or Ctrl to Dismiss."

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "Right-Click on your Food or Water macros to Conjure Food or Water."
L["TIP_MAGE_DOWNRANK"] = "Targeting a lower-level player will conjure Food or Water appropriate for their level."
L["TIP_MAGE_TABLE"] = "Middle-Click on your Food or Water macros to cast Ritual of Refreshment."
L["TIP_MAGE_GEM"] =
	"Right-Click on your Mana Gem macro to conjure a new gem. Right-Click again to conjure a lower-rank backup."

L["TIP_WARLOCK_HEALTHSTONE"] =
	"Right-Click on your Healthstone macro to Create a Healthstone. Right-Click again to conjure a lower-rank backup."
L["TIP_WARLOCK_DOWNRANK"] = "Targeting a lower-level player will create a Healthstone appropriate for their level."
L["TIP_WARLOCK_SOULSTONE"] = "Right-Click on your Soulstone macro to Create a Soulstone."
L["TIP_WARLOCK_SOUL"] = "Middle-Click on your Healthstone macro to cast Ritual of Souls."

L["TIP_ROGUE_OFF_HAND"] = "Left-Click applies your Off Hand poison."
L["TIP_ROGUE_MAIN_HAND"] = "Right-Click applies your Main Hand poison."
L["TIP_ROGUE_REPLACE"] = "Existing poisons are replaced automatically."
L["TIP_ROGUE_WINDOW"] = "Middle-Click opens the Poisons window."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

L["LABEL_BANDAGE"] = "Bandage"
L["LABEL_EXPLOSIVE"] = "Explosive"
L["LABEL_FOOD"] = "Food"
L["LABEL_HEALTH_POTION"] = "Health Potion"
L["LABEL_HEALTHSTONE"] = "Healthstone"
L["LABEL_MANA_GEM"] = "Mana Gem"
L["LABEL_MANA_POTION"] = "Mana Potion"
L["LABEL_PET_FOOD"] = "Pet Food"
L["LABEL_POISONS"] = "Poison"
L["LABEL_SOULSTONE"] = "Soulstone"
L["LABEL_WATER"] = "Water"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the minimap tooltip and options panel.

L["UI_ENABLED"] = "Enabled"
L["UI_DISABLED"] = "Disabled"
L["UI_TOGGLE"] = "Toggle"
L["UI_LEFT_CLICK"] = "Left-Click"
L["UI_RIGHT_CLICK"] = "Right-Click"
L["UI_MIDDLE_CLICK"] = "Middle-Click"
L["UI_SHIFT_LEFT"] = "Shift + Left-Click"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Always"
L["MODE_PARTY"] = "Only when in a Party or Raid"
L["MODE_RAID"] = "Only when in a Raid"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Auto-updating macros for your best food, buff food, water, potions, healthstones, scrolls, soulstones, bandages, poisons, and explosives. One-click conjuring, smart Feed Pet, automatic vendor and bank restocking. Optimal nutrition, peak performance."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Enable Welcome Message"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Print a welcome message in chat on login."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Enable Mini-map Button"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Show the mini-map button."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Enable Macro Names on Buttons"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Show the macro name text on your action bar buttons. Off by default, which hides the names Blizzard recently began showing again."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Potions & Healthstones"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"Macros cannot change during combat (this is a Blizzard restriction), so each Potion & Healthstone macro is pre-built with your best item plus up to two fallbacks. On longer fights the icon and tooltip can go stale and show the wrong item, but clicking the macro will always use the best item you actually have in your bags."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "Combine Healthstones into Health Potion Macro"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"Adds your best Healthstone to the bottom of the Health Potion macro, so one press uses a potion and a Healthstone."

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "Buff Re-Application"
L["OPTIONS_REAPPLY"] = "Re-Apply Expiring Buffs"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"Fights often outlast what's left on your buffs. Buffs with less time remaining than your threshold count as already expired, so your macros offer a fresh one before the pull. Applies to Buff Food, Scroll Buffs, and Pet Food Buffs."
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "When < 1 Minute Left"
L["REAPPLY_THRESHOLD_N"] = "When < %d Minutes Left"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "Ready Check"
L["OPTIONS_READY_CHECK"] = "Report Readiness on Ready Check"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"Prints what you're missing and how long your tracked buffs have left whenever a ready check starts, where only you can see it."

-- Buff Food. The section header reuses FEATURE_BUFF_FOOD.
L["OPTIONS_BUFF_FOOD"] = "Prioritize Buff Food"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'Prioritizes food that grants "Well Fed" whenever the buff is missing. Disabled in Arenas.'
L["OPTIONS_BUFF_FOOD_DETAIL"] = "Pro Tip: Targeting yourself always makes the Food macro skip buff food and scrolls."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "Include Scroll Buffs"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Tap once to apply missing scrolls, again to eat. Scrolls are off the GCD and self-cast; targeting a friendly player skips them. Disabled in Arenas."
L["OPTIONS_SCROLL_TYPES"] = "Include Scroll Types in Check"
L["OPTIONS_SCROLL_AGILITY"] = "Agility"
L["OPTIONS_SCROLL_INTELLECT"] = "Intellect"
L["OPTIONS_SCROLL_PROTECTION"] = "Protection"
L["OPTIONS_SCROLL_SPIRIT"] = "Spirit"
L["OPTIONS_SCROLL_STAMINA"] = "Stamina"
L["OPTIONS_SCROLL_STRENGTH"] = "Strength"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "Explosives"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"The @player option skips the targeting reticle and sets the explosive off right at your feet, ideal when your target is in melee range."
L["EXPLOSIVES_MODE_ATPLAYER"] = "Left-Click @player, Right-Click Toss"
L["EXPLOSIVES_MODE_TOSS"] = "Left-Click Toss, Right-Click @player"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Pet Food Buffs"
L["OPTIONS_USE_PET_BUFFS"] = "Use Pet Food Buffs"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Adds Pet Food to your Food macro when your pet is missing "Well Fed". Disabled in Arenas.'
L["OPTIONS_PET_BUFF_TYPES"] = "Include Pet Food Types in Check"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Kibler's Bits"
L["OPTIONS_PET_BUFF_SPORELING"] = "Sporeling Snacks"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druids"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Enable DruidMacroHelper Integration"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Builds powershifting macros for Health Potions, Mana Potions, and Healthstones using DruidMacroHelper (/dmh)."
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "Return to Bear"
L["DRUID_FORM_CAT"] = "Return to Cat"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Night Elves"
L["OPTIONS_STEALTH_DRINKING"] = "Enable Stealth Drinking"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] = "Appends Shadowmeld to your Water macro so you stealth while drinking."
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] = "Appends Shadowmeld to your Food macro so you stealth while eating."
L["OPTIONS_STEALTH_PICK_ONE"] =
	"Pro Tip: Pick one. You can eat and drink at the same time, but eating or drinking after you stealth will break your stealth."

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "Rogues"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Keeps the Poisons macro loaded with the best usable rank of each poison type. Left-Click applies to your Off Hand, Right-Click to your Main Hand, and existing poisons are replaced automatically."
L["OPTIONS_POISON_MAIN_HAND"] = "Main Hand Poison Type"
L["OPTIONS_POISON_OFF_HAND"] = "Off Hand Poison Type"
L["OPTIONS_STEALTH_EATING"] = "Enable Stealth Eating"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] = "Appends Stealth to your Food macro so you stealth while eating."

-- Restocker. The section header reuses RESTOCKER_WINDOW_TITLE.
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Keeps your bags stocked from a per-character Restock List, buying from vendors and moving items to and from the bank automatically. Type %s to open the list."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Open at Bank"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Open the Restocker window when you visit the bank."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Open at Merchant"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Open the Restocker window when you visit a merchant."
L["OPTIONS_RESTOCKER_DEBUG"] = "Enable Restocker Debug Messages"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Prints Restocker's step-by-step bank/merchant restocking decisions to chat. Noisy; persists across sessions until turned off."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "Opens the Restocker window to manage your Restock List."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Enable Macros"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Toggle which macros Connoisseur creates and maintains. Disabling a macro will also remove it."

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback & Support"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "Version"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "Imported your Restocker lists."
L["RESTOCKER_PROFILE_EXISTS"] = 'A profile named "%s" already exists.'
L["RESTOCKER_BANK_NOT_OPEN"] = "The bank is not open."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"Restocking complete. Hold Shift while opening the bank to skip restocking. Type %s to edit your Restock List."
L["RESTOCKER_STOPPED_BOTH_FULL"] = "Restocking stopped. Both your bags and your bank are full."
L["RESTOCKER_STOPPED_BANK_FULL"] = "Restocking stopped. Your bank is full; free a slot and reopen it."
L["RESTOCKER_STOPPED_BAG_FULL"] = "Restocking stopped. Your bags are full; free a slot and reopen the bank."
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "Restocking stopped. No progress could be made."
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] = "Restocking stopped. Couldn't move: %s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (extra)"
L["RESTOCKER_STOPPED_ERROR"] = "Restocking stopped due to an error: %s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] = "Your bags are full. Skipping merchant restock."
L["RESTOCKER_FINISHED_RESTOCKING"] = "Finished restocking (purchases: %d)."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Shows the Restocker window."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Adds a profile with that name."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Deletes the profile with that name."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Renames the current profile to that name."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copies that profile into the current profile."
L["RESTOCKER_HELP_PROFILE_USE"] = "Switches the active profile to that name."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filter items..."
L["RESTOCKER_ADD_BUTTON"] = "Add"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Add an Item"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "Drop an item from your bag, or type a numeric item ID."
L["RESTOCKER_PROFILE_LABEL"] = "Profile:"
L["RESTOCKER_RENAME_LABEL"] = "Rename:"
L["RESTOCKER_NEW_PROFILE"] = "New Profile"
L["RESTOCKER_COPY_PROFILE"] = "Copy"
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Clone this profile into a new one."
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s Copy"
L["RESTOCKER_DELETE_PROFILE"] = "Delete"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Delete this profile."
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] = "Are you sure you want to delete this profile?|n|n%s|n|nThis can't be undone."
L["RESTOCKER_GROUP_OTHER"] = "Other"
L["RESTOCKER_REMOVE_TOOLTIP"] = "Remove this item from the Restock List."
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "Amount to Restock"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "Press Enter when finished editing."
L["RESTOCKER_BUY_LABEL"] = "Buy"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "Buy from Merchant"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "Buy the necessary quantity from the merchant when the merchant window is open."
L["RESTOCKER_DEPOSIT_LABEL"] = "Deposit"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "Stash to Bank"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] = "Store extra items in the bank when the bank is open. Use 0 to store all."
L["RESTOCKER_WITHDRAW_LABEL"] = "Withdraw"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "Restock from Bank"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "Take needed items from the bank when the bank is open."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "Required Reputation"
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (%d%% off)"
L["RESTOCKER_REPUTATION_ANY"] = "Any"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Friendly"
L["RESTOCKER_REPUTATION_HONORED"] = "Honored"
L["RESTOCKER_REPUTATION_REVERED"] = "Revered"
L["RESTOCKER_REPUTATION_EXALTED"] = "Exalted"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Required Vendor Reputation"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] = "Only buy from a vendor you are at least this standing with."
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Higher standing also means a cheaper price (Friendly 5%, Honored 10%, Revered 15%, Exalted 20%)."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Click to choose a standing."
