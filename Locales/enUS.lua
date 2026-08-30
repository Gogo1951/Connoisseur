local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "enUS", true)
if not L then
	return
end

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

--[[
    Diet names as returned by GetPetFoodTypes(), which is localized. These
    values MUST match the client's strings exactly (verify in-game with
    /dump GetPetFoodTypes() while a pet is out). Used to build
    ns.PetDietMap in Data/Pet-Foods.lua.

    They are ALSO the food checkbox labels in the Starter List pop-up, so they
    read as ordinary labels while carrying that hard constraint. Translate them
    as the client's own diet words, never as the nicer label they look like --
    a locale that "improves" one here stops matching that client's strings and
    silently breaks pet-food selection for everyone playing in it.
]]

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
-- Readiness Report
--------------------------------------------------------------------------------

--[[
    Printed when a ready check starts, as a header plus up to three lines. Each
    line is a set of "Label : a, b, c" clauses joined by ". ", and every part of
    it is dropped when it has nothing to say -- a clean character prints nothing
    at all, so there is no all-clear string here and must not be one.
]]

L["READINESS_TITLE"] = "Readiness Report"

-- Clause labels, in the order the lines print them.
L["READINESS_MISSING_BUFFS"] = "Missing Buffs :"
L["READINESS_EXPIRING"] = "Expiring Soon :"
L["READINESS_MISSING_ITEMS"] = "Missing Items :"
L["READINESS_DAMAGED_GEAR"] = "Damaged Gear :"
L["READINESS_CHARACTER"] = "Character :"
L["READINESS_QUESTIONABLE_GEAR"] = "Non-combat Gear Equipped :"

--[[
    What the report calls each thing. Deliberately its own set rather than the
    shared LABEL_* keys the macro messages use: those name an item you are being
    offered ("Health Potion"), these name a gap in your preparation ("Healing
    Potion"), and the two want to be reworded independently.
]]
L["READINESS_FLASK"] = "Flask or 2x Elixirs"
L["READINESS_WELL_FED"] = "Well Fed"
L["READINESS_PET_WELL_FED"] = "Well Fed (Pet)"
L["READINESS_SCROLLS"] = "Scrolls"
L["READINESS_SOULSTONE"] = "Soulstone Inactive"
L["READINESS_MAIN_HAND"] = "Main Hand"
L["READINESS_OFF_HAND"] = "Off Hand"
L["READINESS_HEALTHSTONE"] = "Healthstone"
L["READINESS_MANA_GEM"] = "Mana Gem"
L["READINESS_HEALING_POTION"] = "Healing Potion"
L["READINESS_MANA_POTION"] = "Mana Potion"
L["READINESS_BANDAGES"] = "Bandages"
L["READINESS_PVP_ON"] = "PvP Flagged!"

-- { buff name, whole minutes left }
L["READINESS_TIME_MINUTES"] = "%s %d min"
-- %s is the buff name; used when under a minute is left.
L["READINESS_TIME_EXPIRING"] = "%s under 1 min"
-- { dominant talent tree, slash-joined point spread }
L["READINESS_SPEC_FORMAT"] = "%s (%s)"
-- %d is the number of talent points the character has not spent.
L["READINESS_UNSPENT_TALENTS"] = "%d Unspent Talent Points"

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

-- Feature toggles shown in the mini-map tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "Buff Food"
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Prioritizes food that grants "Well Fed" whenever the buff is missing.'
L["FEATURE_SCROLL_BUFFS"] = "Scroll Buffs"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "Turns your Food macro into a scroll-applier when you're missing scroll buffs."

-- Section titles and ignore-list actions in the mini-map tooltip.
L["UI_BEST_FOOD"] = "Current Food"
L["UI_BEST_PET_FOOD"] = "Current Pet Food"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "Main Hand"
L["UI_OFF_HAND"] = "Off Hand"
--[[
    The value shown beside an item title when nothing resolved. Kept to a single
    word so it fits in the tooltip's right column, which never wraps -- the full
    sentence, MSG_NO_ITEM, explains it on the wrapping line underneath.
]]
L["UI_NONE"] = "None"
L["UI_IGNORE_LIST"] = "Ignore List"
L["MENU_IGNORE"] = "Ignore"
L["MENU_CLEAR_IGNORE"] = "Clear Ignore List"

--[[
    Restocker Report block in the mini-map tooltip: how many restocking orders
    are still outstanding, never the items themselves. An order is one row of
    the Restock List, so the count is of rows below target and not of missing
    units -- nine outstanding orders can be nine single juices or nine full
    stacks. The header beside it supplies the "restocking", so the count only
    needs the noun.

    Separate singular and plural strings rather than a composed "%d order(s)",
    so every locale can phrase the count its own way.

    The count sits in the tooltip's right column, beside the header, so each of
    these has to stay short enough to read as a value rather than a sentence --
    which is why the all-stocked case is two strings: STOCKED_SHORT for the
    column, and the full congratulation on the wrapping line below it.
]]
L["UI_RESTOCKER_REPORT"] = "Restocker Report"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 Order Outstanding"
L["UI_RESTOCKER_NEEDED"] = "%d Orders Outstanding"
L["UI_RESTOCKER_STOCKED_SHORT"] = "Fully Stocked"
L["UI_RESTOCKER_STOCKED"] = "Congratulations, you're fully stocked up!"

-- Options entry at the bottom of the mini-map tooltip.
L["MENU_OPTIONS"] = "Connoisseur Options"
L["MENU_OPTIONS_KEYBIND"] = "Shift + Middle-Click"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

--[[
    Class-colored headers and conjure/pet tips shown in the mini-map tooltip for
    the player's class.
]]

L["PREFIX_HUNTER"] = "Attention Hunters"
L["PREFIX_MAGE"] = "Attention Mages"
L["PREFIX_ROGUE"] = "Attention Rogues"
L["PREFIX_WARLOCK"] = "Attention Warlocks"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to -- the blocks cover more than one macro,
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

--[[
    Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
    One per macro type (resolved via ns.MacroConfig in ConnNoItem), plus Pet Food.
]]

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

-- Generic labels reused across the mini-map tooltip and options panel.

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
	"Macros that automatically use your best food, buff food, water, potions, healthstones, bandages, and scrolls, plus a Restock List that keeps your bags full and upgrades your consumables as you level. Quality of life automation, peak performance."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Enable Welcome Message"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Print a welcome message in chat on login."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Enable Mini-map Button"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Show the mini-map button."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Enable Macro Names on Buttons"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Show the macro name text on your action bar buttons. Off by default, which hides the names the game shows on its own."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Potions & Healthstones"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"Macros cannot change during combat (this is a Blizzard restriction), so each Potion and Healthstone macro is pre-built with your best item plus up to two fallbacks. On longer fights the icon and tooltip can go stale and show the wrong item, but clicking the macro will always use the best item you actually have in your bags."
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
L["OPTIONS_READINESS_HEADER"] = "Readiness Report"
L["OPTIONS_READINESS_ENABLE"] = "Enable Readiness Report on Ready Check"
--[[
    Says what the report does AND that it stays quiet, because the quiet is the
    feature: a player who turns this on and sees nothing for three pulls has to
    know that is the report working rather than the report broken.
]]
L["OPTIONS_READINESS_DESCRIPTION"] =
	"When a ready check starts, prints a private list of what still needs fixing. Only you see it, and it says nothing at all when you are ready."

--[[
    The reset button under the master toggle. It needs a control of its own
    because these settings are account-wide: the stock Reset Profile reaches
    only the character's own profile, so nothing else on any panel can return
    them to their defaults.

    The confirm names the one consequence a player would not otherwise predict.
    Off is what the report ships as, so resetting switches it back off, and a
    page that emptied itself with no warning would read as a bug.
]]
L["OPTIONS_READINESS_RESET"] = "Reset Readiness Report Settings"
L["OPTIONS_READINESS_RESET_DESCRIPTION"] =
	"Returns every switch on this page, and both thresholds, to the settings a fresh install ships with. Nothing on any other page is affected."
L["OPTIONS_READINESS_RESET_CONFIRM"] =
	"Reset every Readiness Report setting to its default? This also switches the report itself back off."

--[[
    The three sections, each a real header over the switches it covers. They name
    what the line is called in chat, so the panel and the report read as the same
    feature.
]]
L["OPTIONS_READINESS_BUFFS_HEADER"] = "Missing Buffs"
L["OPTIONS_READINESS_ITEMS_HEADER"] = "Missing Items"
L["OPTIONS_READINESS_CHARACTER_HEADER"] = "Character"

-- Missing Buffs
L["OPTIONS_READINESS_FLASK"] = "Flask or 2x Elixirs"
L["OPTIONS_READINESS_FLASK_DESCRIPTION"] = "Counts a flask, or one battle elixir and one guardian elixir, as covered."
L["OPTIONS_READINESS_WELL_FED"] = "Well Fed"
L["OPTIONS_READINESS_WELL_FED_DESCRIPTION"] = "Needs Buff Food turned on under Macros."
L["OPTIONS_READINESS_PET_WELL_FED"] = "Well Fed (Pet)"
L["OPTIONS_READINESS_PET_WELL_FED_DESCRIPTION"] = "Hunters only. Needs Pet Buff Food turned on under Macros."
L["OPTIONS_READINESS_SCROLLS"] = "Scroll Buffs"
L["OPTIONS_READINESS_SCROLLS_DESCRIPTION"] = "Based on the scrolls you have selected to use, under Macros."
--[[
    The one entry that asks about the GROUP rather than the player's own bags,
    which the helper text has to say outright: a raid carrying seven unused
    stones is not covered, and one deployed stone covers it.
]]
L["OPTIONS_READINESS_SOULSTONE"] = "Soulstone Inactive"
L["OPTIONS_READINESS_SOULSTONE_DESCRIPTION"] =
	"Checks that a Soulstone is active on someone, not that one is sitting in a bag. Needs a Warlock in your group."
L["OPTIONS_READINESS_MAIN_HAND"] = "Main Hand Weapon Buff"
L["OPTIONS_READINESS_OFF_HAND"] = "Off Hand Weapon Buff"
L["OPTIONS_READINESS_WEAPON_DESCRIPTION"] =
	"Any temporary weapon enchant counts: a stone, an oil, a poison, or a Shaman weapon buff."
--[[
    Says the Shaman exemption outright, because a main-hand line that goes quiet
    the moment a Shaman joins reads as a broken switch otherwise.
]]
L["OPTIONS_READINESS_MAIN_HAND_DESCRIPTION"] =
	"Any temporary weapon enchant counts. Stays quiet when there is a Shaman in your group."
--[[
    Names the OTHER threshold so the two cannot be mistaken for each other: the
    Macros panel has one that decides when a macro treats a buff as spent, and
    this one only decides when the report mentions it.
]]
L["OPTIONS_READINESS_EXPIRING"] = "Buffs Expiring Within"
L["OPTIONS_READINESS_EXPIRING_DESCRIPTION"] =
	"Names every buff on you that is about to lapse, not just the ones Connoisseur applies. Separate from Buff Re-Application under Macros, which decides when a macro offers a fresh one."
-- %s is a whole or half number of minutes.
L["OPTIONS_READINESS_EXPIRING_MINUTES"] = "%s Minutes"
-- The one-minute entry alone; one plural template cannot render it grammatically.
L["OPTIONS_READINESS_EXPIRING_MINUTES_ONE"] = "1 Minute"

-- Missing Items
L["OPTIONS_READINESS_HEALTHSTONE"] = "Healthstone"
L["OPTIONS_READINESS_HEALTHSTONE_DESCRIPTION"] =
	"Only shown when there's a Warlock in your group to ask, or when you're the Warlock."
L["OPTIONS_READINESS_MANA_GEM"] = "Mana Gem"
L["OPTIONS_READINESS_MANA_GEM_DESCRIPTION"] = "Only shown when you're on a Mage."
L["OPTIONS_READINESS_HEALING_POTION"] = "Healing Potion"
L["OPTIONS_READINESS_HEALING_POTION_DESCRIPTION"] =
	"Best if you stock up before a pull. Nobody can hand you a potion mid-fight."
L["OPTIONS_READINESS_MANA_POTION"] = "Mana Potion"
L["OPTIONS_READINESS_MANA_POTION_DESCRIPTION"] = "Only shown when you're on a class that uses mana."
L["OPTIONS_READINESS_BANDAGES"] = "Bandages"
L["OPTIONS_READINESS_BANDAGES_DESCRIPTION"] = "Reports whenever you have none you can use, First Aid skill included."
L["OPTIONS_READINESS_DURABILITY"] = "Damaged Gear Below"
L["OPTIONS_READINESS_DURABILITY_DESCRIPTION"] =
	"Links every equipped item under this much durability. Measured per item, so one broken weapon still shows."
-- %d is a durability percentage.
L["OPTIONS_READINESS_DURABILITY_PERCENT"] = "%d%%"

-- Character
L["OPTIONS_READINESS_SPEC"] = "Current Spec"
L["OPTIONS_READINESS_SPEC_DESCRIPTION"] = "Prints your talent spread, and any points you have not spent."
L["OPTIONS_READINESS_PVP"] = "PvP Flag On"
L["OPTIONS_READINESS_PVP_DESCRIPTION"] = "Warns when your PvP flag is up."
L["OPTIONS_READINESS_QUESTIONABLE_GEAR"] = "Non-combat Gear Equipped"
L["OPTIONS_READINESS_QUESTIONABLE_GEAR_DESCRIPTION"] =
	"Links equipped items that do not belong in a fight, such as a PvP trinket or a fishing pole."

--[[
    Three features are suppressed in a PvP Arena, and each says so with the
    same sentence. It lives here once and is appended at the call site
    (Options/Options-Macros.lua), so every locale translates it a single time
    and the caveat can never drift between the three.
]]
L["OPTIONS_DISABLED_IN_ARENAS"] = "Disabled in Arenas."

--[[
    Buff Food. The section header reuses FEATURE_BUFF_FOOD, and the options
    description reuses MENU_BUFF_FOOD_DESCRIPTION plus the arena note above --
    the mini-map tooltip and the options panel say the same thing, so they read
    from one key rather than two copies of one sentence.
]]
L["OPTIONS_BUFF_FOOD"] = "Prioritize Buff Food"
L["OPTIONS_BUFF_FOOD_DETAIL"] = "Pro Tip: Targeting yourself always makes the Food macro skip buff food and scrolls."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "Include Scroll Buffs"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Tap once to apply missing scrolls, again to eat. Scrolls are off the GCD and self-cast; targeting a friendly player skips them."
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

--[[
    Ignore List panel (Options-Ignore-List.lua). One tree scope per list: the
    account-wide Global list, then one per character. The rows are items, so
    the copy here is the panel description, the scope and promote labels, the
    add box, and the placeholder shown while the client is still resolving an
    item's name. The mini-map tooltip's section keeps its own UI_IGNORE_LIST
    and MENU_CLEAR_IGNORE keys.
]]
L["OPTIONS_IGNORE_LIST_TAB"] = "Ignore List"
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Ignored items are never picked by any macro. Food, water, potions, anything. The Global list covers every character, a character's list covers only that one. Right-Click the mini-map button to ignore your current best food."
L["OPTIONS_IGNORE_GLOBAL"] = "Global"
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] = "Move this item to the Global list, so it is ignored on every character."
L["OPTIONS_IGNORE_ADD_ID"] = "Add by Item ID"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Type an item ID, or Shift + Click an item link in chat while this box has focus."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "Type an item ID, or Shift + Click an item link in chat."
L["OPTIONS_IGNORE_REMOVE"] = "Remove"
L["OPTIONS_IGNORE_EMPTY"] = "This list is empty."
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "Loading ID: %d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Pet Food Buffs"
L["OPTIONS_USE_PET_BUFFS"] = "Use Pet Food Buffs"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] = 'Adds Pet Food to your Food macro when your pet is missing "Well Fed".'
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

--[[
    Restocker options panel. The tree label stays "Restocker" in every locale
    (brand fragment, localization allowlist); the panel header reuses
    RESTOCKER_WINDOW_TITLE.
]]
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Keeps your bags stocked from a per-character Restock List, buying from vendors and moving items to and from the bank automatically. Type %s to open the list."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Open at Bank"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Open the Restocker window when you visit the bank."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Open at Merchant"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Open the Restocker window when you visit a merchant."
L["OPTIONS_RESTOCKER_REMIND"] = "Enable In-Town Restock Reminders"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"Prints a chat reminder when your Restock List is short of something and you reach an inn or a city, or log in already standing in one."
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "Enable At-Merchant Restock Reminders"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"Reports outstanding restocking orders when you close a merchant window. Silent when there are none."
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "Enable At-Bank Restock Reminders"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"Reports outstanding restocking orders when you close the bank. Silent when there are none."

--[[
    The Starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] = "Enable List Builder When Restock List Is Empty"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"Offers a starter Restock List at login whenever this character's list is empty."

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "Simple"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "Verbose"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "Play Sound"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] = "Plays an alert alongside the reminder, for when chat is busy."
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "Click to hear the alert."

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "Restocker Window"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "Praise"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"I've always loved Restocker, and I'm grateful for the opportunity to have it live on inside Connoisseur. Huge thanks to ChiliFajita, who wrote the original Auto Restocker, and to kvakvs and guardycmw, who kept it going through Classic and Mists of Pandaria."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "Opens the Restocker window to manage your Restock List."

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "Macros"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur builds one macro per consumable and keeps it current as your bags change, so the button on your bar always reaches for the best item you're carrying. Choose which macros to create below, then set how each one picks its item."
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
L["RESTOCKER_PROFILE_EXISTS"] = 'A list named "%s" already exists.'
L["RESTOCKER_BANK_NOT_OPEN"] = "The bank is not open."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (ns.OnRestockerBankOpen), not stored as a preference.
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
--[[
    Printed once per vendor visit when the crafting-reagent buyer stands down:
    this merchant stocks some of the reagents the Restock List needs but not
    all of them, and reagents buy all-or-nothing (VendorStocksAllReagents in
    Features/Restocker/Restocker-Merchant.lua). Silent at vendors stocking none.
]]
L["RESTOCKER_REAGENTS_SKIPPED"] = "This merchant doesn't stock every ingredient your poisons need. Skipping them all."
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "Don't forget to restock while you are in town!"

--[[
    Headline for the merchant and bank reminders, which report on the way out
    rather than nudging on arrival, so the count is the message. The in-town
    reminder keeps its own line above.

    The count is of restocking orders -- rows of the Restock List still below
    their target -- which is why it does not say "items". An earlier draft read
    "You're still short 9 items", and a bare object after "short" forces the
    unit reading: "short 9 apples" is nine apples missing. The number here is
    nine ROWS, each short by anything from one juice to a full stack. "Order"
    can only mean a line on a list, so the ambiguity cannot come back, and it
    is the word the code already uses (BuildPurchaseOrder, purchaseOrders).

    "Outstanding" is load-bearing, not decoration. "Restocking order" alone can
    be read as the sequence restocking happens in, and the list UI is sortable,
    so the word forcing the purchase-order sense has to stay beside the noun.
    Same job as "filled" on RESTOCKER_RESTOCKED_ONE -- never print the bare
    noun without one of them.
]]
L["RESTOCKER_STILL_SHORT_ONE"] = "1 restocking order outstanding."
L["RESTOCKER_STILL_SHORT_MANY"] = "%d restocking orders outstanding."

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, old amount, new link, new amount },
    outgoing tier on the left and incoming on the right.

    Both amounts are carried because they are not always equal: a swap onto a
    tier the list already holds merges the two rows, so the new amount is the
    sum rather than the old amount moved across.
]]
L["RESTOCKER_UPGRADED"] = "Your Restock List has been upgraded."
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d upgrades to %sx%d."

--[[
    Verbose follow-up line, one per short item: { have, wanted, item link }.
    Shared by all three reminders. Wordless on purpose -- the headline above it
    supplies the context, so there is nothing here to translate. It stays a
    locale key anyway so a locale that needs a different order can reorder it
    (same as RESTOCKER_STUCK_ITEM_FORMAT).
]]
L["RESTOCKER_REMINDER_ITEM"] = "%d/%d %s"

--[[
    Printed after buying at a vendor. Counts restocking orders FILLED -- rows
    whose whole requested amount was ordered -- not BuyMerchantItem calls and
    not vendor slots. Forty juice bought in two stacks of twenty is one order
    filled; six of a requested twenty is not one at all, and belongs to the
    partial line below.

    The claim has to be earned, which is why the merchant restock's PurchaseMerchantItem
    reports whether it got the full amount instead of the caller inferring it
    from a unit count. What the vendor did not stock is deliberately not
    mentioned here: the mini-map's Restocker Report owns the outstanding state,
    this line owns the event, and neither repeats the other.
]]
L["RESTOCKER_RESTOCKED_ONE"] = "1 restocking order filled."
L["RESTOCKER_RESTOCKED_MANY"] = "%d restocking orders filled."

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "1 restocking order partly filled."
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] = "%d restocking orders partly filled."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Shows the Restocker window."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Adds a list with that name."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Deletes the list with that name."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Renames the current list to that name."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copies that list into the current list."
L["RESTOCKER_HELP_PROFILE_USE"] = "Switches the active list to that name."

--[[
    Starter List pop-up: the login window that offers vendor staples when the
    Restock List is empty (Features/Restocker/Restocker-Starter-List.lua). Its title
    reuses RESTOCKER_WINDOW_TITLE below, and the six food staples reuse the
    DIET_ keys above, so the popup names bread whatever the pet-food tooltips
    call it.

    The intro is three short paragraphs: why the window opened, what a tick
    does, and the way back in. Joined with blank lines at the call site, so
    each reads as its own breath rather than one wall.
]]
L["STARTER_POPUP_INTRO_EMPTY"] = "Your Restock List is empty, so let's add some items to get you started."
-- Shown instead when the window is opened over a list that already has items on it.
L["STARTER_POPUP_INTRO_STOCKED"] =
	"Pick the staples you want kept stocked. Anything already on your Restock List is checked."
L["STARTER_POPUP_INTRO_HOW"] =
	"Anything you check is kept stocked automatically whenever you open a merchant or your bank, and commodity items upgrade themselves as you level, so you'll always have the best available."
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] = "You can always adjust this list, or add more items later, by typing %s."
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "Food & Water"
L["STARTER_POPUP_FOOD_HEADER"] = "Food"
L["STARTER_POPUP_AMMO_HEADER"] = "Ammo"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "Bullets"
L["STARTER_POPUP_ARROWS"] = "Arrows"
--[[
    The Reagents & Tools section: class tools and spell reagents, at most a
    handful per class. Rogues additionally get a Poisons section of their
    own, whose note under the header reuses PREFIX_ROGUE (rogue-colored at
    the call site) to say the ingredients take care of themselves. The
    poison labels are short forms on purpose -- the section heading plus the
    tooltip's exact rank carry the rest -- and LABEL_POISONS ("Poison",
    singular) belongs to the macro's no-item message and is not reused here.
    The other reagent labels are kept inside about fifteen characters so
    they hold the popup's reagent-row label cell.
]]
L["STARTER_POPUP_REAGENTS_HEADER"] = "Reagents & Tools"
L["STARTER_POPUP_POISONS_HEADER"] = "Poisons"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s : Add the finished poison to your list, and Connoisseur buys the ingredients automatically at any vendor that stocks them all."
L["STARTER_POPUP_POISON_ANESTHETIC"] = "Anesthetic"
L["STARTER_POPUP_POISON_CRIPPLING"] = "Crippling"
L["STARTER_POPUP_POISON_DEADLY"] = "Deadly"
L["STARTER_POPUP_POISON_INSTANT"] = "Instant"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "Mind-numbing"
L["STARTER_POPUP_POISON_WOUND"] = "Wound"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "Hearthstone"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "Blinding Powder"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "Flash Powder"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "Thieves' Tools"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "Corpse Dust"
L["STARTER_POPUP_REAGENT_WILDS"] = "Wilds"
L["STARTER_POPUP_REAGENT_SEEDS"] = "Seeds"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "Arcane Powder"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "Light Feather"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "Teleport Runes"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "Portal Runes"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "Divinity Symbol"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "Kings Symbol"
L["STARTER_POPUP_REAGENT_CANDLES"] = "Candles"
L["STARTER_POPUP_REAGENT_ANKH"] = "Ankh"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "Fish Scales"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "Fish Oil"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "Earth Totem"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "Fire Totem"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "Water Totem"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "Air Totem"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "Demonic Figurine"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "Infernal Stone"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "Soul Shards"
--[[
    Checkbox tooltips: { item link, amount }. The first is for ladder items;
    the second for single-tier reagents, which never upgrade.
]]
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"Adds %s to your Restock List, keeping %d in your bags and upgrading them as you level."
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] = "Adds %s to your Restock List, keeping %d in your bags."
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 for food, water and poisons, 200 for ammo); the tooltip
    below carries the per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 Stack"
L["STARTER_POPUP_STACK_MANY"] = "%d Stacks"
L["STARTER_POPUP_STACKS_DESCRIPTION"] = "How many stacks to keep stocked. One stack here is %d."
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] = "How many to keep stocked. These do not stack, so each one takes a bag slot."
L["STARTER_POPUP_DISMISS"] = "Don't show this again for this character."
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"These suggestions otherwise return on any login that finds your Restock List empty."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filter items..."
L["RESTOCKER_FILTER_CLEAR_TOOLTIP"] = "Clear"
L["RESTOCKER_ADD_BUTTON"] = "Add"
L["RESTOCKER_LIST_BUILDER_BUTTON"] = "Open List Builder"
L["RESTOCKER_LIST_BUILDER_TOOLTIP"] =
	"Opens the List Builder, the same set of staples a new character is offered. This window closes while it is open."
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Add an Item"
L["RESTOCKER_ADD_TOOLTIP_BODY"] =
	"Drop an item from your bags, Shift-click an item link, or type a numeric item ID. Press Enter to add what you typed."
--[[
    In-box placeholder for the add row; the tooltip above carries the detail.
    Kept to a phrase rather than a sentence: it sets the width of both boxes on
    that row, and the row cannot afford two fields wide enough for a long one.
]]
L["RESTOCKER_ADD_PLACEHOLDER"] = "Drop Item here, or type Item ID"
L["RESTOCKER_PROFILE_LABEL"] = "List"
L["RESTOCKER_PROFILE_TOOLTIP"] =
	"The Restock List this character is using. Click to switch to another, or to start a new one."
L["RESTOCKER_RENAME_LABEL"] = "Rename"
L["RESTOCKER_NEW_PROFILE"] = "New List"
L["RESTOCKER_COPY_PROFILE"] = "Copy"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in ns.SetupRestockerTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Clone this list into a new one"
-- %s becomes "<list name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s Copy"
L["RESTOCKER_DELETE_PROFILE"] = "Delete"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Delete this list"
L["RESTOCKER_RENAME_TOOLTIP"] = "Rename this list. Every character using it follows the new name."
-- %s is the list name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] = "Are you sure you want to delete this list?|n|n%s|n|nThis can't be undone."
--[[
    The Upgrade toggle. One string serves both the column heading and every
    row's checkbox, so it has to read for a single item and for the whole
    column at once -- which is why it names categories rather than "this item".

    The categories are exactly the ladder kinds in
    Data/Consumable-Upgrade-Paths.lua: food, water, arrow and bullet, poison,
    healing and mana potion, and the class reagents. Naming anything else here
    promises an upgrade that never arrives, since the toggle is disabled on any
    item that is not on a ladder -- which on a real list is most of them.
]]
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "Upgrade As You Level"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"Food, water, ammo, poisons, potions and class reagents have clean upgrade paths as you level. Allow Connoisseur to upgrade these items for you over time."

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "Bank"
L["RESTOCKER_ROW_MERCHANT"] = "Merchant"
L["RESTOCKER_ROW_UPGRADE"] = "Upgrade"

--[[
    Column headings over the list.

    Keep these SHORT. A heading sets its column's width, and every pixel a
    heading takes comes out of the item name beside it. Six full-length
    headings do not fit beside a readable name at the smallest window size.

    "Take" and "Store" are short because they never appear alone: both sit
    under a "Bank" band, which is what makes them exact. Translate them as a
    pair with that band in mind, and keep them a single short word each.
]]
L["RESTOCKER_COLUMN_ITEM"] = "Item"
L["RESTOCKER_COLUMN_WITHDRAW"] = "Take"
L["RESTOCKER_COLUMN_DEPOSIT"] = "Store"
L["RESTOCKER_COLUMN_REPUTATION"] = "Rep"
L["RESTOCKER_COLUMN_AMOUNT"] = "Amount"

L["RESTOCKER_GROUP_OTHER"] = "Other"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "New"
--[[
    The category pane's first entry, above the item types. Selected by default,
    and the only way back to the whole list once a type has been picked, so it
    has to read as "everything" rather than as another type.
]]
L["RESTOCKER_GROUP_ALL"] = "All items"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "Remove this item from the Restock List"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "Amount to Restock"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "Press Enter when finished editing."
L["RESTOCKER_BUY_LABEL"] = "Buy"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "Buy from Merchant"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "Buy the necessary quantity from the merchant when the merchant window is open."

--[[
    Some vendor slots hold only a few units and trickle back over time, which is
    how Classic sells its scarce consumables. Extra empties those slots outright
    rather than buying the shortfall, so the tooltip has to say three things: what
    it buys, that unlimited stock is never touched, and why anyone would want it.
]]
L["RESTOCKER_EXTRA_LABEL"] = "Extra"
L["RESTOCKER_EXTRA_TOOLTIP_TITLE"] = "Buy Extra"
L["RESTOCKER_EXTRA_TOOLTIP_STOCK"] = "Buys the vendor's whole stock of this item, even past your target amount."
L["RESTOCKER_EXTRA_TOOLTIP_LIMITED"] =
	"Only applies to limited stock, the few-at-a-time goods a vendor slowly restocks. Unlimited supply is ignored."
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "Stash to Bank"
--[[
    Names the Amount column, so it is coupled to RESTOCKER_COLUMN_AMOUNT: a locale
    that renders that heading differently has to say the same word here, or the
    sentence points at a column the player cannot find.
]]
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"Store extra items in the bank when the bank is open. Use 0 in the Amount column to store all of them."
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "Restock from Bank"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "Take needed items from the bank when the bank is open."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "Required Reputation"
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (%d%% off)"
L["RESTOCKER_REPUTATION_ANY"] = "Any"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Friendly"
L["RESTOCKER_REPUTATION_HONORED"] = "Honored"
L["RESTOCKER_REPUTATION_REVERED"] = "Revered"
L["RESTOCKER_REPUTATION_EXALTED"] = "Exalted"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Required Vendor Reputation"
--[[
    Quotes the cell's own value, which couples this line to
    RESTOCKER_REPUTATION_ANY: a locale that renders that standing differently
    has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'Pick a standing and Connoisseur skips vendors you have not reached it with. "Any" buys from any vendor.'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Standing also cuts the price: Friendly 5%, Honored 10%, Revered 15%, Exalted 20%."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Click to change."
