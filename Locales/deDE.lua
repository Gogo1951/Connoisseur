local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "deDE")
if not L then return end

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
L["MACRO_FEED_PET"] = "- Tier füttern"
L["MACRO_FOOD"] = "- Essen"
L["MACRO_HEALTH_POTION"] = "- Heiltrank"
L["MACRO_HEALTHSTONE"] = "- GS"
L["MACRO_MANA_GEM"] = "- Manastein"
L["MACRO_MANA_POTION"] = "- Manatrank"
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

L["MSG_BUG_REPORT"] = "Du hast einen Bug gefunden! %s (%s) kann nicht in %s > %s (%s) benutzt werden. Bitte melde dies, damit wir es beheben können. Danke! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Kein geeignetes %s in deinen Taschen gefunden."
L["MSG_MACRO_SLOTS_FULL"] = "Einige Connoisseur-Makros konnten nicht erstellt werden, da deine Makroplätze voll sind. Gib einen Platz frei, indem du Makros löschst, die du nicht mehr benötigst, oder deaktiviere nicht benötigte Connoisseur-Makros unter Optionen > AddOns > Connoisseur."

L["CHAT_LOADED"] = "Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) finden sich unter Optionen > AddOns > Connoisseur. Gefällt dir das Addon? Erzähle einem Freund davon! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Core.lua.

L["TIP_PET_NO_FOOD"] = "Du hast derzeit kein nützliches Futter für dein Tier."
L["TIP_PET_NO_SKILLS"] = "Du kennst derzeit nicht Tier füttern, Tier heilen oder Tier wiederbeleben."
L["TIP_PET_NO_MEND"] = "Du kennst derzeit nicht Tier heilen."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Du kennst derzeit nicht %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "Buff-Essen bevorzugen"
L["MENU_BUFF_FOOD_DESCRIPTION"] = "Bevorzugt Essen, das den \"Satt\"-Buff gewährt, wenn der Buff fehlt."
L["MENU_CLEAR_IGNORE"] = "Ignorierliste löschen"
L["MENU_IGNORE"] = "Ignorieren"

L["MENU_SCROLL_BUFFS"] = "Schriftrollen-Buffs"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "Verwandelt dein Essen-Makro in einen Schriftrollen-Anwender, wenn dir Schriftrollen-Buffs fehlen."
L["MENU_OPTIONS_HINT"] = "Weitere Optionen verfügbar unter Optionen > AddOns > Connoisseur."

L["PREFIX_HUNTER"] = "Achtung Jäger"
L["PREFIX_MAGE"] = "Achtung Magier"
L["PREFIX_WARLOCK"] = "Achtung Hexenmeister"

L["TIP_DOWNRANK"] = "Wenn du einen Spieler mit niedrigerer Stufe anvisierst, wird das Makro Gegenstände herbeizaubern, die für dessen Stufe angemessen sind."
L["TIP_HUNTER_FEED_PET"] = "Tier füttern ist ein All-in-One-Tier-Button! Klicken, um dein Tier automatisch zu rufen, zu füttern oder wiederzubeleben. Rechtsklick oder im Kampf benutzen, um Tier heilen zu wirken. Shift gedrückt halten, um Wiederbeleben zu erzwingen, oder Strg, um es wegzuschicken."
L["TIP_MAGE_CONJURE"] = "Rechtsklick auf dein Essen- oder Wasser-Makro, um Essen oder Wasser herbeizuzaubern."
L["TIP_MAGE_GEM"] = "Rechtsklick auf dein Manastein-Makro, um einen neuen Stein herbeizuzaubern. Erneuter Rechtsklick, um einen Ersatzstein niedrigerer Stufe herbeizuzaubern."
L["TIP_MAGE_TABLE"] = "Mittelklick, um Ritual der Erfrischung zu wirken."
L["TIP_WARLOCK_CONJURE"] = "Rechtsklick auf dein Gesundheitsstein- oder Seelenstein-Makro, um einen Gesundheitsstein oder Seelenstein herzustellen. Erneuter Rechtsklick auf dein Gesundheitsstein-Makro, um einen Ersatzstein niedrigerer Stufe herbeizuzaubern."
L["TIP_WARLOCK_SOUL"] = "Mittelklick, um Ritual der Seelen zu wirken."

L["UI_BEST_FOOD"] = "Aktuelles Essen"
L["UI_BEST_PET_FOOD"] = "Aktuelles Tierfutter"

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
L["LABEL_BANDAGE"] = "Verband"
L["LABEL_FOOD"] = "Essen"
L["LABEL_HEALTH_POTION"] = "Heiltrank"
L["LABEL_HEALTHSTONE"] = "Gesundheitsstein"
L["LABEL_MANA_GEM"] = "Manastein"
L["LABEL_MANA_POTION"] = "Manatrank"
L["LABEL_PET_FOOD"] = "Tierfutter"
L["LABEL_SOULSTONE"] = "Seelenstein"
L["LABEL_WATER"] = "Wasser"
L["UI_DISABLED"] = "Deaktiviert"
L["UI_ENABLED"] = "Aktiviert"
L["UI_IGNORE_LIST"] = "Ignorierliste"
L["UI_LEFT_CLICK"] = "Linksklick"
L["UI_MIDDLE_CLICK"] = "Mittelklick"
L["UI_RIGHT_CLICK"] = "Rechtsklick"
L["UI_SHIFT_LEFT"] = "Shift + Linksklick"
L["UI_TOGGLE"] = "Umschalten"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Immer"
L["MODE_PARTY"] = "Nur in einer Gruppe"
L["MODE_RAID"] = "Nur in einem Schlachtzug"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Sich automatisch aktualisierende Makros für dein bestes Essen, Buff-Essen, Wasser, Schriftrollen, Heil- und Manatränke, Gesundheitssteine, Seelensteine, Manasteine und Verbände. Herbeizaubern mit einem Klick für Magier und Hexenmeister, intelligentes Tier füttern für Jäger. Optimale Ernährung, Höchstleistung."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Willkommensnachricht aktivieren"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Gibt beim Einloggen eine Willkommensnachricht im Chat aus."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Minikarten-Button aktivieren"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Zeigt den Minikarten-Button an."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Tränke & Gesundheitssteine"
L["OPTIONS_POTIONS_DESCRIPTION"] = "Makros können während des Kampfes nicht geändert werden (dies ist eine Blizzard-Einschränkung). Daher wird jedes Trank- und Gesundheitsstein-Makro im Voraus mit deinem besten Gegenstand und bis zu zwei Ersatzgegenständen erstellt. Bei längeren Kämpfen können das Symbol und der Tooltip veralten und den falschen Gegenstand anzeigen, aber ein Klick auf das Makro verwendet immer den besten Gegenstand, den du tatsächlich in deinen Taschen hast."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "Gesundheitssteine mit Heiltrank-Makro kombinieren"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] = "Fügt deinen besten Gesundheitsstein unten an das Heiltrank-Makro an, sodass ein Tastendruck einen Trank und einen Gesundheitsstein verwendet."

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "Buff-Essen bevorzugen"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = "Bevorzugt Essen, das den \"Satt\"-Buff gewährt, wenn der Buff fehlt."
L["OPTIONS_BUFF_FOOD_DETAIL"] = "Profi-Tipp: Wenn du dich selbst anvisierst, lässt das Essen-Makro Buff-Essen und Schriftrollen immer aus."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Schriftrollen-Buffs"
L["OPTIONS_USE_SCROLLS"] = "Schriftrollen-Buffs einschließen"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] = "Verwandelt dein Essen-Makro in einen dedizierten Schriftrollen-Anwender, wann immer dir Schriftrollen-Buffs fehlen. Einmal tippen, um Schriftrollen anzuwenden; nochmal tippen, um zu essen. Schriftrollen unterliegen nicht dem GCD, zielen auf dich ab und das Makro wechselt sofort wieder zu Essen, wenn du einen anderen befreundeten Spieler anvisierst."
L["OPTIONS_SCROLL_TYPES"] = "Schriftrollentypen in Prüfung einschließen"
L["OPTIONS_SCROLL_AGILITY"] = "Beweglichkeit"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelligenz"
L["OPTIONS_SCROLL_PROTECTION"] = "Schutz"
L["OPTIONS_SCROLL_SPIRIT"] = "Willenskraft"
L["OPTIONS_SCROLL_STAMINA"] = "Ausdauer"
L["OPTIONS_SCROLL_STRENGTH"] = "Stärke"

-- Pets Food Buffs
L["OPTIONS_PET_HEADER"] = "Tierfutter-Buffs"
L["OPTIONS_USE_PET_BUFFS"] = "Tierfutter-Buffs verwenden"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] = "Verwendet Tierfutter als Teil deines Essen-Makros, wenn deinem Tier der \"Satt\"-Buff fehlt."
L["OPTIONS_PET_BUFF_TYPES"] = "Tierfutter-Arten in Prüfung einschließen"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Kiblers Häppchen"
L["OPTIONS_PET_BUFF_SPORELING"] = "Sporelingshappen"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druiden"
L["OPTIONS_DRUID_MACRO_HELPER"] = "DruidMacroHelper-Integration aktivieren"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] = "Erstellt Powershifting-Makros für Heiltränke, Manatränke und Gesundheitssteine mithilfe von DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Nach Verbrauchsgut wechseln in"
L["DRUID_FORM_BEAR"] = "Bär"
L["DRUID_FORM_CAT"] = "Katze"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Nachtelfen"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Schattenmimik beim Trinken"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] = "Fügt Schattenmimik zu deinem Wasser-Makro hinzu, damit du beim Trinken unsichtbar wirst."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESCRIPTION"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Öffnet das Connoisseur-Optionsmenü."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Makros aktivieren"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] = "Schaltet um, welche Makros Connoisseur erstellt und pflegt. Wenn du ein Makro deaktivierst, wird es auch entfernt."

-- Reset
L["OPTIONS_RESET_HEADER"] = "Zurücksetzen"
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "Alle Gegenstände von der Ignorierliste entfernen."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Bist du sicher, dass du die Ignorierliste löschen möchtest?"
L["OPTIONS_RESET_ALL"] = "Alle Connoisseur-Optionen zurücksetzen"
L["OPTIONS_RESET_ALL_DESCRIPTION"] = "Alle Einstellungen und die Ignorierliste auf die Standardwerte zurücksetzen."
L["OPTIONS_RESET_ALL_CONFIRM"] = "Alle Connoisseur-Optionen auf Standardwerte zurücksetzen?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback & Support"
