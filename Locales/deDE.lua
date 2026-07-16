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

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

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
	"Du hast einen Bug gefunden! %s (%s) kann nicht in %s > %s (%s) benutzt werden. Bitte melde dies, damit wir es beheben können. Danke! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Kein geeignetes %s in deinen Taschen gefunden."
L["MSG_MACRO_SLOTS_FULL"] =
	"Einige Connoisseur-Makros konnten nicht erstellt werden, da deine Makroplätze voll sind. Gib einen Platz frei, indem du Makros löschst, die du nicht mehr benötigst, oder deaktiviere nicht benötigte Connoisseur-Makros unter Optionen > AddOns > Connoisseur."

L["CHAT_LOADED"] =
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) finden sich unter Optionen > AddOns > Connoisseur. Gefällt dir das Addon? Erzähle einem Freund davon! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "Du hast derzeit kein nützliches Futter für dein Tier."
L["TIP_PET_NO_SKILLS"] = "Du kennst derzeit nicht Tier füttern, Tier heilen oder Tier wiederbeleben."
L["TIP_PET_NO_MEND"] = "Du kennst derzeit nicht Tier heilen."
L["TIP_NO_HAND_POISON"] = "Für diese Waffe ist das gewählte Gift aufgebraucht."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Du kennst derzeit nicht %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Bevorzugt Essen, das den "Satt"-Buff gewährt, wenn der Buff fehlt.'
L["MENU_SCROLL_BUFFS"] = "Schriftrollen-Buffs"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Verwandelt dein Essen-Makro in einen Schriftrollen-Anwender, wenn dir Schriftrollen-Buffs fehlen."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Aktuelles Essen"
L["UI_BEST_PET_FOOD"] = "Aktuelles Tierfutter"
L["UI_IGNORE_LIST"] = "Ignorierliste"
L["MENU_IGNORE"] = "Ignorieren"
L["MENU_CLEAR_IGNORE"] = "Ignorierliste löschen"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Connoisseur-Optionen"
L["MENU_OPTIONS_KEYBIND"] = "Shift + Mittelklick"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

L["PREFIX_HUNTER"] = "Achtung Jäger"
L["PREFIX_MAGE"] = "Achtung Magier"
L["PREFIX_ROGUE"] = "Achtung Schurken"
L["PREFIX_WARLOCK"] = "Achtung Hexenmeister"

L["TIP_DOWNRANK"] =
	"Wenn du einen Spieler mit niedrigerer Stufe anvisierst, wird das Makro Gegenstände herbeizaubern, die für dessen Stufe angemessen sind."
L["TIP_HUNTER_FEED_PET"] =
	"Tier füttern ist ein All-in-One-Tier-Button! Klicken, um dein Tier automatisch zu rufen, zu füttern oder wiederzubeleben. Rechtsklick oder im Kampf benutzen, um Tier heilen zu wirken. Shift gedrückt halten, um Wiederbeleben zu erzwingen, oder Strg, um es wegzuschicken."
L["TIP_MAGE_CONJURE"] = "Rechtsklick auf dein Essen- oder Wasser-Makro, um Essen oder Wasser herbeizuzaubern."
L["TIP_MAGE_GEM"] =
	"Rechtsklick auf dein Manastein-Makro, um einen neuen Stein herbeizuzaubern. Erneuter Rechtsklick, um einen Ersatzstein niedrigerer Stufe herbeizuzaubern."
L["TIP_MAGE_TABLE"] = "Mittelklick, um Ritual der Erfrischung zu wirken."
L["TIP_WARLOCK_CONJURE"] =
	"Rechtsklick auf dein Gesundheitsstein- oder Seelenstein-Makro, um einen Gesundheitsstein oder Seelenstein herzustellen. Erneuter Rechtsklick auf dein Gesundheitsstein-Makro, um einen Ersatzstein niedrigerer Stufe herbeizuzaubern."
L["TIP_WARLOCK_SOUL"] = "Mittelklick, um Ritual der Seelen zu wirken."
L["TIP_ROGUE_POISONS"] =
	"Linksklick trägt euer Schildhand-Gift auf, Rechtsklick euer Waffenhand-Gift. Vorhandene Gifte werden automatisch ersetzt. Mittelklick öffnet das Gifte-Fenster."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

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

-- Generic labels reused across the minimap tooltip and options panel.

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
L["MODE_PARTY"] = "Nur in einer Gruppe"
L["MODE_RAID"] = "Nur in einem Schlachtzug"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Sich automatisch aktualisierende Makros für dein bestes Essen, Buff-Essen, Wasser, Schriftrollen, Heil- und Manatränke, Gesundheitssteine, Seelensteine, Manasteine und Verbände. Herbeizaubern mit einem Klick für Magier und Hexenmeister, intelligentes Tier füttern für Jäger. Optimale Ernährung, Höchstleistung."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Willkommensnachricht aktivieren"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Gibt beim Einloggen eine Willkommensnachricht im Chat aus."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Minikarten-Button aktivieren"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Zeigt den Minikarten-Button an."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Makronamen auf Buttons aktivieren"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Zeigt den Makronamen-Text auf den Buttons deiner Aktionsleisten an. Standardmäßig aus, wodurch die Namen ausgeblendet werden, die Blizzard kürzlich wieder eingeblendet hat."

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
	"Kämpfe dauern oft länger, als eure Buffs noch halten. Buffs mit weniger Restzeit als dem Schwellenwert gelten als bereits abgelaufen, sodass eure Makros vor dem Pull einen frischen anbieten. Gilt für Buff-Essen, Schriftrollen-Buffs und Tierfutter-Buffs."
L["OPTIONS_REAPPLY_THRESHOLD"] = "Als abgelaufen behandeln bei"
L["REAPPLY_THRESHOLD_ONE"] = "< 1 Minute übrig"
L["REAPPLY_THRESHOLD_N"] = "< %d Minuten übrig"

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "Buff-Essen"
L["OPTIONS_BUFF_FOOD"] = "Buff-Essen bevorzugen"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = 'Bevorzugt Essen, das den "Satt"-Buff gewährt, wenn der Buff fehlt.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Profi-Tipp: Wenn du dich selbst anvisierst, lässt das Essen-Makro Buff-Essen und Schriftrollen immer aus."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Schriftrollen-Buffs"
L["OPTIONS_USE_SCROLLS"] = "Schriftrollen-Buffs einschließen"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Verwandelt dein Essen-Makro in einen dedizierten Schriftrollen-Anwender, wann immer dir Schriftrollen-Buffs fehlen. Einmal tippen, um Schriftrollen anzuwenden; nochmal tippen, um zu essen. Schriftrollen unterliegen nicht dem GCD, zielen auf dich ab und das Makro wechselt sofort wieder zu Essen, wenn du einen anderen befreundeten Spieler anvisierst."
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
L["EXPLOSIVES_MODE_ATPLAYER"] = "Linksklick @Player, Rechtsklick Werfen"
L["EXPLOSIVES_MODE_TOSS"] = "Linksklick Werfen, Rechtsklick @Player"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Tierfutter-Buffs"
L["OPTIONS_USE_PET_BUFFS"] = "Tierfutter-Buffs verwenden"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Verwendet Tierfutter als Teil deines Essen-Makros, wenn deinem Tier der "Satt"-Buff fehlt.'
L["OPTIONS_PET_BUFF_TYPES"] = "Tierfutter-Arten in Prüfung einschließen"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Kiblers Häppchen"
L["OPTIONS_PET_BUFF_SPORELING"] = "Sporelingshappen"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druiden"
L["OPTIONS_DRUID_MACRO_HELPER"] = "DruidMacroHelper-Integration aktivieren"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Erstellt Powershifting-Makros für Heiltränke, Manatränke und Gesundheitssteine mithilfe von DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Nach Verbrauchsgut wechseln in"
L["DRUID_FORM_BEAR"] = "Bär"
L["DRUID_FORM_CAT"] = "Katze"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Nachtelfen"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Schattenmimik beim Trinken"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] =
	"Fügt Schattenmimik zu deinem Wasser-Makro hinzu, damit du beim Trinken unsichtbar wirst."

-- Rogues
L["OPTIONS_POISONS_HEADER"] = "Gifte"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Hält das Gifte-Makro mit dem besten nutzbaren Rang jedes Gifttyps bestückt. Linksklick trägt auf die Schildhand auf, Rechtsklick auf die Waffenhand; vorhandene Gifte werden automatisch ersetzt."
L["OPTIONS_POISON_MAIN_HAND"] = "Waffenhand"
L["OPTIONS_POISON_OFF_HAND"] = "Schildhand"

-- Restocker
L["OPTIONS_RESTOCKER_HEADER"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Hält die Taschen anhand einer charakterbezogenen Nachschubliste gefüllt. Kauft automatisch bei Händlern ein und verschiebt Gegenstände zwischen Taschen und Bank. /crs öffnet die Liste."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Bei der Bank öffnen"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Öffnet das Restocker-Fenster beim Besuch der Bank."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Beim Händler öffnen"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Öffnet das Restocker-Fenster beim Besuch eines Händlers."
L["OPTIONS_RESTOCKER_DEBUG"] = "Restocker-Debugmeldungen aktivieren"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Gibt Restockers schrittweise Bank- und Händlerentscheidungen im Chat aus. Gesprächig; bleibt über Sitzungen hinweg aktiv, bis es abgeschaltet wird."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_FOODIE"] = "/foodie"
L["OPTIONS_COMMANDS_FOODIE_DETAIL"] = "Öffnet das Connoisseur-Optionsmenü."
L["OPTIONS_COMMANDS_CRS"] = "/crs"
L["OPTIONS_COMMANDS_CRS_DETAIL"] = "Öffnet das Restocker-Fenster zum Verwalten deiner Nachschubliste."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Makros aktivieren"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Schaltet um, welche Makros Connoisseur erstellt und pflegt. Wenn du ein Makro deaktivierst, wird es auch entfernt."

-- Ignore List
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "Alle Gegenstände von der Ignorierliste entfernen."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Bist du sicher, dass du die Ignorierliste löschen möchtest?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback & Unterstützung"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "Deine Restocker-Listen wurden importiert."
L["RESTOCKER_PROFILE_EXISTS"] = 'Ein Profil namens "%s" existiert bereits.'
L["RESTOCKER_BANK_NOT_OPEN"] = "Die Bank ist nicht geöffnet."
-- %s is the /crs slash command, colored at the call site.
L["RESTOCKER_COMPLETE"] =
	"Auffüllen abgeschlossen. Halte Shift, um es nächstes Mal zu überspringen. Tippe %s, um deine Nachschubliste zu bearbeiten."
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
L["RESTOCKER_FINISHED_RESTOCKING"] = "Auffüllen beendet (%d Käufe getätigt)."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Zeigt das Restocker-Fenster."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Legt ein Profil mit diesem Namen an."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Löscht das Profil mit diesem Namen."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Benennt das aktuelle Profil in diesen Namen um."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Kopiert dieses Profil in das aktuelle Profil."
L["RESTOCKER_HELP_PROFILE_USE"] = "Wechselt das aktive Profil zu diesem Namen."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Gegenstände filtern..."
L["RESTOCKER_ADD_BUTTON"] = "Hinzufügen"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Gegenstand hinzufügen"
L["RESTOCKER_ADD_TOOLTIP_BODY"] =
	"Ziehe einen Gegenstand aus deiner Tasche hierher oder gib eine numerische Gegenstands-ID ein."
L["RESTOCKER_PROFILE_LABEL"] = "Profil:"
L["RESTOCKER_RENAME_LABEL"] = "Umbenennen:"
L["RESTOCKER_NEW_PROFILE"] = "Neues Profil"
L["RESTOCKER_GROUP_OTHER"] = "Sonstiges"
L["RESTOCKER_REMOVE_TOOLTIP"] = "Entfernt diesen Gegenstand von der Nachschubliste."
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
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (%d%% Rabatt)"
L["RESTOCKER_REPUTATION_ANY"] = "Beliebig"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Freundlich"
L["RESTOCKER_REPUTATION_HONORED"] = "Wohlwollend"
L["RESTOCKER_REPUTATION_REVERED"] = "Respektvoll"
L["RESTOCKER_REPUTATION_EXALTED"] = "Ehrfürchtig"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Benötigter Händlerruf"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] = "Kauft nur bei Händlern, bei denen du mindestens diesen Ruf hast."
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Höherer Ruf bedeutet außerdem günstigere Preise (Freundlich 5%, Wohlwollend 10%, Respektvoll 15%, Ehrfürchtig 20%)."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Klicke, um einen Ruf zu wählen"
