local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "deDE")
if not L then return end

-- [[ GERMAN (deDE) ]] --
L["BRAND"] = "Connoisseur"

-- Macro Names Can't Exceed 16 Total Characters
L["MACRO_BANDAGE"] = "- Verband"
L["MACRO_FOOD"]    = "- Essen"
L["MACRO_HPOT"]    = "- Heiltrank"
L["MACRO_HS"]      = "- GS"
L["MACRO_MGEM"]    = "- Manastein"
L["MACRO_MPOT"]    = "- Manatrank"
L["MACRO_SS"]      = "- Seelenstein"
L["MACRO_WATER"]   = "- Wasser"
L["MACRO_FEED_PET"]= "- Tier füttern"

L["ERR_ZONE"] = "Das kannst du hier nicht benutzen."
L["RANK"]     = "Rang"

L["MSG_BUG_REPORT"] = "Du hast einen Bug gefunden! %s (%s) kann nicht in %s > %s (%s) benutzt werden. Bitte melde dies, damit wir es beheben können. Danke! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"]    = "Kein geeignetes %s in deinen Taschen gefunden."

L["MENU_BUFF_FOOD"]      = "Buff-Essen bevorzugen"
L["MENU_BUFF_FOOD_DESC"] = "Bevorzugt Essen, das den \"Satt\"-Buff gewährt, wenn der Buff fehlt."
L["MENU_CLEAR_IGNORE"]   = "Ignorierliste löschen"
L["MENU_IGNORE"]         = "Ignorieren"
L["MENU_RESET"]          = "Zurücksetzen"
L["MENU_SCAN"]           = "Scan erzwingen"
L["MENU_TITLE"]          = "Verbrauchsgüter"

L["MENU_SCROLL_BUFFS"]      = "Schriftrollen-Buffs"
L["MENU_SCROLL_BUFFS_DESC"] = "Verwendet Attributs-Schriftrollen als Teil deines Essen-Makros, wenn der Schriftrollen-Buff fehlt."
L["MENU_OPTIONS_HINT"]      = "Weitere Optionen verfügbar unter Optionen > AddOns > Connoisseur."

L["PREFIX_HUNTER"]  = "Achtung Jäger"
L["PREFIX_MAGE"]    = "Achtung Magier"
L["PREFIX_WARLOCK"] = "Achtung Hexenmeister"

L["TIP_DOWNRANK"]        = "Wenn du einen Spieler mit niedrigerer Stufe anvisierst, wird das Makro Gegenstände herbeizaubern, die für dessen Stufe angemessen sind."
L["TIP_HUNTER_FEED_PET"] = "Tier füttern ist ein All-in-One-Tier-Button! Klicken, um dein Tier automatisch zu rufen, zu füttern oder wiederzubeleben. Rechtsklick oder im Kampf benutzen, um Tier heilen zu wirken. Shift gedrückt halten, um Wiederbeleben zu erzwingen, oder Strg, um es wegzuschicken."
L["TIP_MAGE_CONJURE"]    = "Rechtsklick auf dein Essen- oder Wasser-Makro, um Essen oder Wasser herbeizuzaubern."
L["TIP_MAGE_GEM"]        = "Rechtsklick auf dein Manastein-Makro, um einen neuen Stein herbeizuzaubern. Erneuter Rechtsklick, um einen Ersatzstein niedrigerer Stufe herbeizuzaubern."
L["TIP_MAGE_TABLE"]      = "Mittelklick, um Ritual der Erfrischung zu wirken."
L["TIP_WARLOCK_CONJURE"] = "Rechtsklick auf dein Gesundheitsstein- oder Seelenstein-Makro, um einen Gesundheitsstein oder Seelenstein herzustellen."
L["TIP_WARLOCK_SOUL"]    = "Mittelklick, um Ritual der Seelen zu wirken."

L["UI_BEST_FOOD"]    = "Aktuelles bestes Essen"
L["UI_BEST_PET_FOOD"]= "Aktuelles Tierfutter"
L["UI_DISABLED"]     = "Deaktiviert"
L["UI_ENABLED"]      = "Aktiviert"
L["UI_IGNORE_LIST"]  = "Ignorierliste"
L["UI_LEFT_CLICK"]   = "Linksklick"
L["UI_MIDDLE_CLICK"] = "Mittelklick"
L["UI_RIGHT_CLICK"]  = "Rechtsklick"
L["UI_SHIFT_LEFT"]   = "Shift + Linksklick"
L["UI_TOGGLE"]       = "Umschalten"

-- Options Panel
L["OPTIONS_DESC"]              = "Erstellt Makros, um das beste verfügbare Essen, Wasser, Tränke, Gesundheitssteine, Seelensteine, Manasteine oder Verbände zu verwenden."
L["OPTIONS_BUFF_FOOD"]         = "Buff-Essen bevorzugen"
L["OPTIONS_BUFF_FOOD_DESC"]    = "Bevorzugt Essen, das den \"Satt\"-Buff gewährt, wenn der Buff fehlt."
L["OPTIONS_SCROLL_HEADER"]     = "Schriftrollen-Buffs"
L["OPTIONS_USE_SCROLLS"]       = "Schriftrollen-Buffs einschließen"
L["OPTIONS_USE_SCROLLS_DESC"]  = "Verwendet Schriftrollen, wenn der Schriftrollen-Buff fehlt, als Teil deines Essen-Makros."
L["OPTIONS_SCROLL_TYPES"]      = "Schriftrollentypen in Prüfung einschließen"
L["OPTIONS_SCROLL_AGILITY"]    = "Beweglichkeit"
L["OPTIONS_SCROLL_INTELLECT"]  = "Intelligenz"
L["OPTIONS_SCROLL_PROTECTION"] = "Schutz"
L["OPTIONS_SCROLL_SPIRIT"]     = "Willenskraft"
L["OPTIONS_SCROLL_STAMINA"]    = "Ausdauer"
L["OPTIONS_SCROLL_STRENGTH"]   = "Stärke"

L["OPTIONS_PET_HEADER"]        = "Tierfutter-Buffs"
L["OPTIONS_USE_PET_BUFFS"]     = "Tierfutter-Buffs verwenden"
L["OPTIONS_USE_PET_BUFFS_DESC"]= "Verwendet Tierfutter als Teil deines Essen-Makros, wenn deinem Tier der \"Satt\"-Buff fehlt."
L["OPTIONS_PET_BUFF_TYPES"]    = "Tierfutter-Arten in Prüfung einschließen"
L["OPTIONS_PET_BUFF_KIBLERS"]  = "Kiblers Häppchen"
L["OPTIONS_PET_BUFF_SPORELING"]= "Sporelingshappen"

L["OPTIONS_NIGHTELF_HEADER"]           = "Nachtelfen"
L["OPTIONS_SHADOWMELD_DRINKING"]      = "Schattenmimik beim Trinken"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Fügt Schattenmimik zu deinem Wasser-Makro hinzu, damit du beim Trinken unsichtbar wirst."

L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"]   = "/foodie"

L["OPTIONS_RESET_HEADER"]         = "Zurücksetzen"
L["OPTIONS_RESET_IGNORE_DESC"]    = "Alle Gegenstände von der Ignorierliste entfernen."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Bist du sicher, dass du die Ignorierliste löschen möchtest?"
L["OPTIONS_COMMUNITY_HEADER"]     = "Feedback & Support"