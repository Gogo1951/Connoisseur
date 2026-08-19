local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "deDE")
if not L then
	return
end

-- [[ GERMAN (deDE) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Verband"
L["MACRO_EXPLOSIVES"] = "- Sprengstoff"
L["MACRO_FEED_PET"] = "- Tier füttern"
L["MACRO_FOOD"] = "- Essen"
L["MACRO_HEALTH_POTION"] = "- Heiltrank"
L["MACRO_HEALTHSTONE"] = "- GS"
L["MACRO_MANA_GEM"] = "- Manastein"
L["MACRO_MANA_POTION"] = "- Manatrank"
L["MACRO_POISONS"] = "- Gifte"
L["MACRO_SOULSTONE"] = "- Seelenstein"
L["MACRO_WATER"] = "- Wasser"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "Rang"

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

L["DIET_BREAD"] = "Brot"
L["DIET_CHEESE"] = "Käse"
L["DIET_FISH"] = "Fisch"
L["DIET_FRUIT"] = "Obst"
L["DIET_FUNGUS"] = "Pilz"
L["DIET_MEAT"] = "Fleisch"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] =
	"Du hast einen Bug gefunden! %s (%s) kann nicht in %s > %s (%s) benutzt werden. Bitte melde dies, damit wir es beheben können. Danke! %s"
L["MSG_NO_ITEM"] = "Kein geeignetes %s in deinen Taschen gefunden."
L["MSG_MACRO_SLOTS_FULL"] =
	"Einige Connoisseur-Makros konnten nicht erstellt werden, da deine Makroplätze voll sind. Gib einen Platz frei, indem du Makros löschst, die du nicht mehr benötigst, oder deaktiviere nicht benötigte Connoisseur-Makros unter Optionen > AddOns > Connoisseur."

L["CHAT_LOADED"] =
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) finden sich unter Optionen > AddOns > Connoisseur. Gefällt dir das Addon? Erzähle einem Freund davon! (="

L["CHAT_OPTIONS_IN_COMBAT"] = "Aus Sicherheitsgründen kann das Optionsmenü im Kampf nicht geöffnet werden."

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "Alles bereit!"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "Fehlt: %s"

L["READY_WELL_FED"] = "Satt"
L["READY_SCROLLS"] = "Schriftrollen"
L["READY_PET_FED"] = "Tier satt"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d Min."
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s unter 1 Min."

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "Du hast derzeit kein nützliches Futter für dein Tier."
L["TIP_PET_NO_SKILLS"] = "Du kennst derzeit nicht Tier rufen, Tier wegschicken, Tier füttern oder Tier wiederbeleben."
L["TIP_PET_NO_MEND"] = "Du kennst derzeit nicht Tier heilen."
L["TIP_NO_HAND_POISON"] = "Für diese Waffe ist das gewählte Gift aufgebraucht."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Du kennst derzeit nicht %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the mini-map tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "Buff-Essen"
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Bevorzugt Essen, das den "Satt"-Buff gewährt, wenn der Buff fehlt.'
L["FEATURE_SCROLL_BUFFS"] = "Schriftrollen-Buffs"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Verwandelt dein Essen-Makro in einen Schriftrollen-Anwender, wenn dir Schriftrollen-Buffs fehlen."

-- Section titles and ignore-list actions in the mini-map tooltip.
L["UI_BEST_FOOD"] = "Aktuelles Essen"
L["UI_BEST_PET_FOOD"] = "Aktuelles Tierfutter"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "Waffenhand"
L["UI_OFF_HAND"] = "Schildhand"
--[[
    The value shown beside an item title when nothing resolved. Kept to a single
    word so it fits in the tooltip's right column, which never wraps -- the full
    sentence, MSG_NO_ITEM, explains it on the wrapping line underneath.
]]
L["UI_NONE"] = "Keins"
L["UI_IGNORE_LIST"] = "Ignorierliste"
L["MENU_IGNORE"] = "Ignorieren"
L["MENU_CLEAR_IGNORE"] = "Ignorierliste löschen"

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
L["UI_RESTOCKER_REPORT"] = "Nachschubbericht"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 offener Posten"
L["UI_RESTOCKER_NEEDED"] = "%d offene Posten"
L["UI_RESTOCKER_STOCKED_SHORT"] = "Vorrat komplett"
L["UI_RESTOCKER_STOCKED"] = "Glückwunsch, dein Vorrat ist komplett!"

-- Options entry at the bottom of the mini-map tooltip.
L["MENU_OPTIONS"] = "Connoisseur-Optionen"
L["MENU_OPTIONS_KEYBIND"] = "Shift + Mittelklick"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

--[[
    Class-colored headers and conjure/pet tips shown in the mini-map tooltip for
    the player's class.
]]

L["PREFIX_HUNTER"] = "Achtung Jäger"
L["PREFIX_MAGE"] = "Achtung Magier"
L["PREFIX_ROGUE"] = "Achtung Schurken"
L["PREFIX_WARLOCK"] = "Achtung Hexenmeister"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to -- the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "Zu deinem Tier-füttern-Makro..."
L["TIP_MAGE_MACROS"] = "Zu deinen Essen-, Wasser- und Manastein-Makros..."
L["TIP_ROGUE_MACROS"] = "Zu deinem Gifte-Makro..."
L["TIP_WARLOCK_MACROS"] = "Zu deinen Gesundheitsstein- und Seelenstein-Makros..."

L["TIP_HUNTER_ALL_IN_ONE"] = "Tier füttern ist ein All-in-One-Tier-Button!"
L["TIP_HUNTER_CALL"] = "Linksklick, um dein Tier automatisch zu rufen, zu füttern oder wiederzubeleben."
L["TIP_HUNTER_MEND"] = "Rechtsklick oder warte auf den Kampf, um Tier heilen zu wirken."
L["TIP_HUNTER_MODIFIERS"] = "Halte Shift, um Wiederbeleben zu erzwingen, oder Strg zum Wegschicken."

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "Rechtsklick auf dein Essen- oder Wasser-Makro, um Essen oder Wasser herbeizuzaubern."
L["TIP_MAGE_DOWNRANK"] =
	"Wenn du einen Spieler niedrigerer Stufe anvisierst, wird Essen oder Wasser passend zu dessen Stufe herbeigezaubert."
L["TIP_MAGE_TABLE"] = "Mittelklick auf dein Essen- oder Wasser-Makro, um Ritual der Erfrischung zu wirken."
L["TIP_MAGE_GEM"] =
	"Rechtsklick auf dein Manastein-Makro, um einen neuen Stein herbeizuzaubern. Erneuter Rechtsklick, um einen Ersatzstein niedrigerer Stufe herbeizuzaubern."

L["TIP_WARLOCK_HEALTHSTONE"] =
	"Rechtsklick auf dein Gesundheitsstein-Makro, um einen Gesundheitsstein herzustellen. Erneuter Rechtsklick, um einen Ersatzstein niedrigerer Stufe herbeizuzaubern."
L["TIP_WARLOCK_DOWNRANK"] =
	"Wenn du einen Spieler niedrigerer Stufe anvisierst, wird ein Gesundheitsstein passend zu dessen Stufe erstellt."
L["TIP_WARLOCK_SOULSTONE"] = "Rechtsklick auf dein Seelenstein-Makro, um einen Seelenstein herzustellen."
L["TIP_WARLOCK_SOUL"] = "Mittelklick auf dein Gesundheitsstein-Makro, um Ritual der Seelen zu wirken."

L["TIP_ROGUE_OFF_HAND"] = "Linksklick trägt dein Schildhand-Gift auf."
L["TIP_ROGUE_MAIN_HAND"] = "Rechtsklick trägt dein Waffenhand-Gift auf."
L["TIP_ROGUE_REPLACE"] = "Vorhandene Gifte werden automatisch ersetzt."
L["TIP_ROGUE_WINDOW"] = "Mittelklick öffnet das Gifte-Fenster."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

--[[
    Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
    One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
]]

L["LABEL_BANDAGE"] = "Verband"
L["LABEL_EXPLOSIVE"] = "Sprengstoff"
L["LABEL_FOOD"] = "Essen"
L["LABEL_HEALTH_POTION"] = "Heiltrank"
L["LABEL_HEALTHSTONE"] = "Gesundheitsstein"
L["LABEL_MANA_GEM"] = "Manastein"
L["LABEL_MANA_POTION"] = "Manatrank"
L["LABEL_PET_FOOD"] = "Tierfutter"
L["LABEL_POISONS"] = "Gift"
L["LABEL_SOULSTONE"] = "Seelenstein"
L["LABEL_WATER"] = "Wasser"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the mini-map tooltip and options panel.

L["UI_ENABLED"] = "Aktiviert"
L["UI_DISABLED"] = "Deaktiviert"
L["UI_TOGGLE"] = "Umschalten"
L["UI_LEFT_CLICK"] = "Linksklick"
L["UI_RIGHT_CLICK"] = "Rechtsklick"
L["UI_MIDDLE_CLICK"] = "Mittelklick"
L["UI_SHIFT_LEFT"] = "Shift + Linksklick"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Immer"
L["MODE_PARTY"] = "Nur in Gruppe oder Schlachtzug"
L["MODE_RAID"] = "Nur in einem Schlachtzug"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Makros, die automatisch dein bestes Essen, Buff-Essen, Wasser, Tränke, Gesundheitssteine, Verbände und Schriftrollen verwenden, dazu eine Nachschubliste, die deine Taschen gefüllt hält und deine Verbrauchsgegenstände mit deiner Stufe aufwertet. Komfort-Automatisierung, Höchstleistung."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Willkommensnachricht aktivieren"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Gibt beim Einloggen eine Willkommensnachricht im Chat aus."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Minikarten-Button aktivieren"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Zeigt den Minikarten-Button an."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Makronamen auf Buttons aktivieren"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Zeigt den Makronamen-Text auf den Buttons deiner Aktionsleisten an. Standardmäßig aus, wodurch die Namen ausgeblendet werden, die das Spiel von sich aus anzeigt."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Tränke & Gesundheitssteine"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"Makros können während des Kampfes nicht geändert werden (dies ist eine Blizzard-Einschränkung). Daher wird jedes Trank- und Gesundheitsstein-Makro im Voraus mit deinem besten Gegenstand und bis zu zwei Ersatzgegenständen erstellt. Bei längeren Kämpfen können das Symbol und der Tooltip veralten und den falschen Gegenstand anzeigen, aber ein Klick auf das Makro verwendet immer den besten Gegenstand, den du tatsächlich in deinen Taschen hast."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "Gesundheitssteine mit Heiltrank-Makro kombinieren"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"Fügt deinen besten Gesundheitsstein unten an das Heiltrank-Makro an, sodass ein Tastendruck einen Trank und einen Gesundheitsstein verwendet."

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "Buff-Erneuerung"
L["OPTIONS_REAPPLY"] = "Ablaufende Buffs erneuern"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"Kämpfe dauern oft länger, als deine Buffs noch halten. Buffs mit weniger Restzeit als dem Schwellenwert gelten als bereits abgelaufen, sodass deine Makros vor dem Pull einen frischen anbieten. Gilt für Buff-Essen, Schriftrollen-Buffs und Tierfutter-Buffs."
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "Wenn < 1 Minute übrig"
L["REAPPLY_THRESHOLD_N"] = "Wenn < %d Minuten übrig"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "Bereitschaftsprüfung"
L["OPTIONS_READY_CHECK"] = "Bereitschaft bei Bereitschaftsprüfung melden"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"Gibt bei jeder Bereitschaftsprüfung aus, was dir fehlt und wie lange deine verfolgten Buffs noch halten. Nur für dich sichtbar."

--[[
    Three features are suppressed in a PvP Arena, and each says so with the
    same sentence. It lives here once and is appended at the call site
    (Options/Options-Macros.lua), so every locale translates it a single time
    and the caveat can never drift between the three.
]]
L["OPTIONS_DISABLED_IN_ARENAS"] = "In Arenen deaktiviert."

--[[
    Buff Food. The section header reuses FEATURE_BUFF_FOOD, and the options
    description reuses MENU_BUFF_FOOD_DESCRIPTION plus the arena note above --
    the mini-map tooltip and the options panel say the same thing, so they read
    from one key rather than two copies of one sentence.
]]
L["OPTIONS_BUFF_FOOD"] = "Buff-Essen bevorzugen"
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Profi-Tipp: Wenn du dich selbst anvisierst, lässt das Essen-Makro Buff-Essen und Schriftrollen immer aus."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "Schriftrollen-Buffs einschließen"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Einmal tippen, um fehlende Schriftrollen anzuwenden, erneut tippen zum Essen. Schriftrollen unterliegen nicht dem GCD und zielen auf dich selbst; wer einen befreundeten Spieler anvisiert, überspringt sie."
L["OPTIONS_SCROLL_TYPES"] = "Schriftrollentypen in Prüfung einschließen"
L["OPTIONS_SCROLL_AGILITY"] = "Beweglichkeit"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelligenz"
L["OPTIONS_SCROLL_PROTECTION"] = "Schutz"
L["OPTIONS_SCROLL_SPIRIT"] = "Willenskraft"
L["OPTIONS_SCROLL_STAMINA"] = "Ausdauer"
L["OPTIONS_SCROLL_STRENGTH"] = "Stärke"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "Sprengstoff"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"Die @player-Option überspringt den Zielkreis und zündet den Sprengstoff direkt zu deinen Füßen. Ideal, wenn dein Ziel in Nahkampfreichweite ist."
L["EXPLOSIVES_MODE_ATPLAYER"] = "Linksklick @player, Rechtsklick Werfen"
L["EXPLOSIVES_MODE_TOSS"] = "Linksklick Werfen, Rechtsklick @player"

--[[
    Ignore List. The rows are items, so the only copy here is the add box and
    the placeholder shown while the client is still resolving an item's name.
    The section header and the clear-all button reuse UI_IGNORE_LIST and
    MENU_CLEAR_IGNORE, which the mini-map tooltip already carries.
]]
L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Gegenstände, die Connoisseur niemals auswählt, egal wie gut sie sind. Rechtsklicke den Minikartenbutton, um das gerade vorgeschlagene Essen zu ignorieren, oder füge unten einen Gegenstand hinzu."
L["OPTIONS_IGNORE_ADD_ID"] = "Nach Gegenstands-ID hinzufügen"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Gib eine Gegenstands-ID ein oder mache Shift + Klick auf einen Gegenstandslink im Chat, während dieses Feld ausgewählt ist."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] =
	"Gib eine Gegenstands-ID ein oder mache Shift + Klick auf einen Gegenstandslink im Chat."
L["OPTIONS_IGNORE_REMOVE"] = "Entfernen"
L["OPTIONS_IGNORE_EMPTY"] = "Diese Liste ist leer."
L["OPTIONS_IGNORE_CLEAR_CONFIRM"] = "Alle Gegenstände von deiner Ignorierliste entfernen?"
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "Lade ID: %d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Tierfutter-Buffs"
L["OPTIONS_USE_PET_BUFFS"] = "Tierfutter-Buffs verwenden"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Fügt deinem Essen-Makro Tierfutter hinzu, wenn deinem Tier der "Satt"-Buff fehlt.'
L["OPTIONS_PET_BUFF_TYPES"] = "Tierfutter-Arten in Prüfung einschließen"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Kiblers Häppchen"
L["OPTIONS_PET_BUFF_SPORELING"] = "Sporelingshappen"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druiden"
L["OPTIONS_DRUID_MACRO_HELPER"] = "DruidMacroHelper-Integration aktivieren"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Erstellt Powershifting-Makros für Heiltränke, Manatränke und Gesundheitssteine mithilfe von DruidMacroHelper (/dmh)."
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "Zurück zu Bär"
L["DRUID_FORM_CAT"] = "Zurück zu Katze"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Nachtelfen"
L["OPTIONS_STEALTH_DRINKING"] = "Verstohlenes Trinken aktivieren"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] =
	"Fügt Schattenmimik zu deinem Wasser-Makro hinzu, damit du beim Trinken unsichtbar wirst."
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	"Fügt Schattenmimik zu deinem Essen-Makro hinzu, damit du beim Essen unsichtbar wirst."
L["OPTIONS_STEALTH_PICK_ONE"] =
	"Profi-Tipp: Wähle eines. Du kannst gleichzeitig essen und trinken, aber Essen oder Trinken nach dem Verstecken beendet deine Tarnung."

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "Schurken"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Hält das Gifte-Makro mit dem besten nutzbaren Rang jedes Gifttyps bestückt. Linksklick trägt auf die Schildhand auf, Rechtsklick auf die Waffenhand; vorhandene Gifte werden automatisch ersetzt."
L["OPTIONS_POISON_MAIN_HAND"] = "Gifttyp Waffenhand"
L["OPTIONS_POISON_OFF_HAND"] = "Gifttyp Schildhand"
L["OPTIONS_STEALTH_EATING"] = "Verstohlenes Essen aktivieren"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] =
	"Fügt Schleichen zu deinem Essen-Makro hinzu, damit du beim Essen schleichst."

--[[
    Restocker options panel. The tree label stays "Restocker" in every locale
    (brand fragment, localization allowlist); the panel header reuses
    RESTOCKER_WINDOW_TITLE.
]]
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Hält die Taschen anhand einer charakterbezogenen Nachschubliste gefüllt. Kauft automatisch bei Händlern ein und verschiebt Gegenstände zwischen Taschen und Bank. %s öffnet die Liste."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Bei der Bank öffnen"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Öffnet das Restocker-Fenster beim Besuch der Bank."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Beim Händler öffnen"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Öffnet das Restocker-Fenster beim Besuch eines Händlers."
L["OPTIONS_RESTOCKER_REMIND"] = "Nachschub-Erinnerungen in der Stadt aktivieren"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"Gibt eine Chat-Erinnerung aus, wenn deiner Nachschubliste etwas fehlt und du ein Gasthaus oder eine Stadt erreichst oder dich beim Anmelden bereits in einem befindest."
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "Nachschub-Erinnerungen beim Händler aktivieren"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"Meldet offene Nachschubposten, wenn du ein Händlerfenster schließt. Bleibt still, wenn keine offen sind."
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "Nachschub-Erinnerungen bei der Bank aktivieren"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"Meldet offene Nachschubposten, wenn du die Bank schließt. Bleibt still, wenn keine offen sind."

--[[
    The starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] = "Listen-Assistent aktivieren, wenn die Nachschubliste leer ist"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"Bietet beim Anmelden eine Start-Nachschubliste an, wenn die Liste dieses Charakters leer ist."

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "Einfach"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "Ausführlich"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "Ton abspielen"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] =
	"Spielt zusätzlich zur Erinnerung einen Hinweiston, falls im Chat gerade viel los ist."
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "Klicke, um den Hinweiston zu hören."
L["OPTIONS_RESTOCKER_DEBUG"] = "Restocker-Debugmeldungen aktivieren"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Gibt Restockers schrittweise Bank- und Händlerentscheidungen im Chat aus. Gesprächig; bleibt über Sitzungen hinweg aktiv, bis es abgeschaltet wird."

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "Nachschubfenster"
L["OPTIONS_RESTOCKER_ADVANCED_HEADER"] = "Erweitert"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "Danksagung"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"Ich habe Restocker immer geliebt und freue mich, dass es in Connoisseur weiterlebt. Riesigen Dank an ChiliFajita, der den ursprünglichen Auto Restocker geschrieben hat, und an kvakvs und guardycmw, die ihn durch Classic und Mists of Pandaria am Leben gehalten haben."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet das Optionsmenü dieses Add-ons."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "Öffnet das Restocker-Fenster zum Verwalten deiner Nachschubliste."

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "Makros"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur erstellt ein Makro pro Verbrauchsgegenstand und hält es aktuell, während sich deine Taschen ändern, damit die Schaltfläche auf deiner Leiste immer zum besten Gegenstand greift, den du dabeihast. Wähle unten, welche Makros erstellt werden, und lege dann fest, wie jedes seinen Gegenstand auswählt."
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Makros aktivieren"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Schaltet um, welche Makros Connoisseur erstellt und pflegt. Wenn du ein Makro deaktivierst, wird es auch entfernt."

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback & Unterstützung"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "Version"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_PROFILE_EXISTS"] = 'Ein Profil namens "%s" existiert bereits.'
L["RESTOCKER_BANK_NOT_OPEN"] = "Die Bank ist nicht geöffnet."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"Auffüllen abgeschlossen. Halte Shift beim Öffnen der Bank, um das Auffüllen zu überspringen. Tippe %s, um deine Nachschubliste zu bearbeiten."
L["RESTOCKER_STOPPED_BOTH_FULL"] = "Auffüllen gestoppt. Deine Taschen und deine Bank sind voll."
L["RESTOCKER_STOPPED_BANK_FULL"] =
	"Auffüllen gestoppt. Deine Bank ist voll; mache einen Platz frei und öffne sie erneut."
L["RESTOCKER_STOPPED_BAG_FULL"] =
	"Auffüllen gestoppt. Deine Taschen sind voll; mache einen Platz frei und öffne die Bank erneut."
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "Auffüllen gestoppt. Es konnte kein Fortschritt erzielt werden."
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] = "Auffüllen gestoppt. Konnte nicht verschieben: %s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (überschüssig)"
L["RESTOCKER_STOPPED_ERROR"] = "Auffüllen wegen eines Fehlers gestoppt: %s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] = "Deine Taschen sind voll. Händler-Auffüllen wird übersprungen."
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "Vergiss nicht, deinen Nachschub aufzufüllen, solange du in der Stadt bist!"

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
L["RESTOCKER_STILL_SHORT_ONE"] = "1 Nachschubposten offen."
L["RESTOCKER_STILL_SHORT_MANY"] = "%d Nachschubposten offen."

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, old amount, new link, new amount },
    outgoing tier on the left and incoming on the right.

    Both amounts are carried because they are not always equal: a swap onto a
    tier the list already holds merges the two rows, so the new amount is the
    sum rather than the old amount moved across.
]]
L["RESTOCKER_UPGRADED"] = "Deine Nachschubliste wurde aufgewertet."
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d wird zu %sx%d."

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

    The claim has to be earned, which is why merchantModule:PurchaseMerchantItem
    reports whether it got the full amount instead of the caller inferring it
    from a unit count. What the vendor did not stock is deliberately not
    mentioned here: the mini-map's Restocker Report owns the outstanding state,
    this line owns the event, and neither repeats the other.
]]
L["RESTOCKER_RESTOCKED_ONE"] = "1 Nachschubposten erfüllt."
L["RESTOCKER_RESTOCKED_MANY"] = "%d Nachschubposten erfüllt."

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "1 Nachschubposten teilweise erfüllt."
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] = "%d Nachschubposten teilweise erfüllt."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Zeigt das Restocker-Fenster."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Legt ein Profil mit diesem Namen an."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Löscht das Profil mit diesem Namen."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Benennt das aktuelle Profil in diesen Namen um."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Kopiert dieses Profil in das aktuelle Profil."
L["RESTOCKER_HELP_PROFILE_USE"] = "Wechselt das aktive Profil zu diesem Namen."

--[[
    Starter List pop-up: the login window that offers vendor staples when the
    Restock List is empty (Features/Restocker/StarterList.lua). Its title
    reuses RESTOCKER_WINDOW_TITLE below, and the six food staples reuse the
    DIET_ keys above, so the popup names bread whatever the pet-food tooltips
    call it.

    The intro is three short paragraphs: why the window opened, what a tick
    does, and the way back in. Joined with blank lines at the call site, so
    each reads as its own breath rather than one wall.
]]
L["STARTER_POPUP_INTRO_EMPTY"] =
	"Deine Nachschubliste ist leer, also lass uns ein paar Gegenstände hinzufügen, damit du loslegen kannst."
L["STARTER_POPUP_INTRO_HOW"] =
	"Alles, was du ankreuzt, wird automatisch aufgefüllt, sobald du einen Händler oder deine Bank öffnest, und Standardwaren werten sich mit deiner Stufe von selbst auf, sodass du immer das Beste dabeihast."
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] =
	"Du kannst diese Liste jederzeit anpassen oder später weitere Gegenstände hinzufügen, indem du %s eingibst."
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "Essen & Wasser"
L["STARTER_POPUP_FOOD_HEADER"] = "Essen"
L["STARTER_POPUP_AMMO_HEADER"] = "Munition"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "Kugeln"
L["STARTER_POPUP_ARROWS"] = "Pfeile"

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
L["STARTER_POPUP_REAGENTS_HEADER"] = "Reagenzien & Werkzeuge"
L["STARTER_POPUP_POISONS_HEADER"] = "Gifte"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s : Setze das fertige Gift auf deine Liste, und Connoisseur kauft die Zutaten automatisch bei jedem Händler, der sie führt."
L["STARTER_POPUP_POISON_ANESTHETIC"] = "Betäubung"
L["STARTER_POPUP_POISON_CRIPPLING"] = "Lähmung"
L["STARTER_POPUP_POISON_DEADLY"] = "Tödlich"
L["STARTER_POPUP_POISON_INSTANT"] = "Sofort"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "Geistbetäubung"
L["STARTER_POPUP_POISON_WOUND"] = "Wunde"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "Ruhestein"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "Blendpulver"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "Blitzpulver"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "Diebeswerkzeug"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "Leichenstaub"
L["STARTER_POPUP_REAGENT_WILDS"] = "Wilde Beeren"
L["STARTER_POPUP_REAGENT_SEEDS"] = "Samen"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "Arkanpulver"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "Leichte Feder"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "Teleportrunen"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "Portalrunen"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "Göttlichkeit"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "Königssymbol"
L["STARTER_POPUP_REAGENT_CANDLES"] = "Kerzen"
L["STARTER_POPUP_REAGENT_ANKH"] = "Ankh"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "Fischschuppen"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "Fischöl"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "Erdtotem"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "Feuertotem"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "Wassertotem"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "Lufttotem"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "Dämonenfigur"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "Infernalstein"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "Seelensplitter"
--[[
    Checkbox tooltips: { item link, amount }. The first is for ladder items;
    the second for single-tier reagents, which never upgrade.
]]
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"Fügt %s zu deiner Nachschubliste hinzu, hält %d davon in deinen Taschen und wertet sie mit deiner Stufe auf."
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] =
	"Fügt %s zu deiner Nachschubliste hinzu und hält %d in deinen Taschen bereit."
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 for food, water and poisons, 200 for ammo); the tooltip
    below carries the per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 Stapel"
L["STARTER_POPUP_STACK_MANY"] = "%d Stapel"
L["STARTER_POPUP_STACKS_DESCRIPTION"] = "Wie viele Stapel vorrätig bleiben sollen. Ein Stapel sind hier %d."
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] =
	"Wie viele vorrätig bleiben sollen. Diese stapeln sich nicht, daher belegt jedes einen Taschenplatz."
L["STARTER_POPUP_DISMISS"] = "Für diesen Charakter nicht mehr anzeigen."
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"Andernfalls erscheinen diese Vorschläge bei jeder Anmeldung erneut, bei der deine Nachschubliste leer ist."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Gegenstände filtern..."
L["RESTOCKER_ADD_BUTTON"] = "Hinzufügen"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Gegenstand hinzufügen"
L["RESTOCKER_ADD_TOOLTIP_BODY"] =
	"Ziehe einen Gegenstand aus deiner Tasche hierher oder gib eine numerische Gegenstands-ID ein."
-- In-box placeholder for the add row; the tooltip above carries the detail.
L["RESTOCKER_ADD_PLACEHOLDER"] = "Gegenstand hierher ziehen oder ID eingeben..."
L["RESTOCKER_PROFILE_LABEL"] = "Profil:"
L["RESTOCKER_RENAME_LABEL"] = "Umbenennen:"
L["RESTOCKER_NEW_PROFILE"] = "Neues Profil"
L["RESTOCKER_COPY_PROFILE"] = "Kopieren"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in RS.SetupTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Klont dieses Profil in ein neues"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s Kopie"
L["RESTOCKER_DELETE_PROFILE"] = "Löschen"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Löscht dieses Profil"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"Möchtest du dieses Profil wirklich löschen?|n|n%s|n|nDas kann nicht rückgängig gemacht werden."
--[[
    Row controls in the Restocker window. UPGRADE is disabled on any item that
    is not on a ladder in Data/Consumable-Upgrade-Paths.lua, which on a real
    list is most of them.
]]
L["RESTOCKER_UPGRADE_LABEL"] = "Auto-Aufwertung"
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "Mit deiner Stufe aufwerten"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"Essen, Wasser, Munition und Tränke haben klare Aufwertungspfade, während du aufsteigst, also zieht Connoisseur diesen Eintrag für dich mit. Alles andere passt du mit der Zeit selbst an."

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "Bank"
L["RESTOCKER_ROW_MERCHANT"] = "Händler"
L["RESTOCKER_ROW_UPGRADE"] = "Aufwertung"

L["RESTOCKER_GROUP_OTHER"] = "Sonstiges"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "Neu"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "Entfernt diesen Gegenstand von der Nachschubliste"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "Aufzufüllende Menge"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "Drücke Enter, wenn du fertig bist."
L["RESTOCKER_BUY_LABEL"] = "Kaufen"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "Beim Händler kaufen"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "Kauft die benötigte Menge beim Händler, wenn das Händlerfenster geöffnet ist."
L["RESTOCKER_DEPOSIT_LABEL"] = "Einlagern"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "In der Bank einlagern"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"Lagert überschüssige Gegenstände in der Bank ein, wenn die Bank geöffnet ist. 0 lagert alles ein."
L["RESTOCKER_WITHDRAW_LABEL"] = "Abheben"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "Aus der Bank auffüllen"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "Entnimmt benötigte Gegenstände aus der Bank, wenn die Bank geöffnet ist."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "Benötigter Ruf"
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (%d%% Rabatt)"
L["RESTOCKER_REPUTATION_ANY"] = "Beliebig"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Freundlich"
L["RESTOCKER_REPUTATION_HONORED"] = "Wohlwollend"
L["RESTOCKER_REPUTATION_REVERED"] = "Respektvoll"
L["RESTOCKER_REPUTATION_EXALTED"] = "Ehrfürchtig"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]
L["RESTOCKER_REPUTATION_BUTTON_FORMAT"] = "Ruf: %s"

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Benötigter Händlerruf"
--[[
    Quotes the button's own label. That couples this line to
    RESTOCKER_REPUTATION_BUTTON_FORMAT and RESTOCKER_REPUTATION_ANY -- a locale
    that renders the button differently has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'Wähle einen Ruf, und Connoisseur überspringt Händler, bei denen du ihn nicht erreicht hast. "Ruf: Beliebig" kauft bei jedem Händler.'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Der Ruf senkt auch den Preis: Freundlich 5 %, Wohlwollend 10 %, Respektvoll 15 %, Ehrfürchtig 20 %."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Klicke zum Ändern."
