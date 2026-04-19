local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "itIT")
if not L then
    return
end

-- [[ ITALIAN (itIT) ]] --
L["BRAND"] = "Connoisseur"

-- Macro Names Can't Exceed 16 Total Characters
L["MACRO_BANDAGE"] = "- Benda"
L["MACRO_FEED_PET"] = "- Nutri Famiglio"
L["MACRO_FOOD"] = "- Cibo"
L["MACRO_HPOT"] = "- Poz. Salute"
L["MACRO_HS"] = "- Pietra Salute"
L["MACRO_MGEM"] = "- Gemma di Mana"
L["MACRO_MPOT"] = "- Poz. Mana"
L["MACRO_SS"] = "- Pietra Anima"
L["MACRO_WATER"] = "- Acqua"

L["ERR_ZONE"] = "Non puoi usarlo qui."
L["RANK"] = "Grado"

L["MSG_BUG_REPORT"] = "Sembra che tu abbia trovato un bug! %s (%s) non può essere usato in %s > %s (%s). Segnalalo per aiutarci a risolverlo. Grazie! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Nessun %s adatto trovato nelle tue borse."

L["MENU_BUFF_FOOD"] = "Priorità Cibo con Buff"
L["MENU_BUFF_FOOD_DESC"] = 'Dà priorità al cibo che fornisce il buff "Ben Nutrito", quando il buff è assente.'
L["MENU_CLEAR_IGNORE"] = "Svuota Lista Ignorati"
L["MENU_IGNORE"] = "Ignora"
L["MENU_RESET"] = "Reimposta"
L["MENU_SCAN"] = "Forza Scansione"
L["MENU_TITLE"] = "Consumabili"

L["MENU_SCROLL_BUFFS"] = "Buff Pergamena"
L["MENU_SCROLL_BUFFS_DESC"] = "Usa pergamene degli attributi come parte della tua macro Cibo quando il buff della pergamena è assente."
L["MENU_OPTIONS_HINT"] = "Impostazioni aggiuntive in Opzioni > Addon > Connoisseur."

L["PREFIX_HUNTER"] = "Attenzione Cacciatori"
L["PREFIX_MAGE"] = "Attenzione Maghi"
L["PREFIX_WARLOCK"] = "Attenzione Stregoni"

L["TIP_DOWNRANK"] = "Selezionare un giocatore di livello inferiore farà creare alla macro oggetti adatti al suo livello."
L["TIP_HUNTER_FEED_PET"] = "Nutri Famiglio è un pulsante tutto-in-uno! Clicca per Richiamare, Nutrire o Rianimare automaticamente il tuo famiglio. Clic col tasto destro o in combattimento per lanciare Cura Famiglio. Tieni premuto Shift per forzare Rianima, o Ctrl per Congeda."
L["TIP_MAGE_CONJURE"] = "Clic col tasto destro sulle tue macro Cibo o Acqua per Creare Cibo o Acqua."
L["TIP_MAGE_GEM"] = "Clic col tasto destro sulla tua macro Gemma di Mana per crearne una nuova. Clic destro di nuovo per creare una gemma di grado inferiore di scorta."
L["TIP_MAGE_TABLE"] = "Clic centrale per lanciare Rituale del Rinfresco."
L["TIP_WARLOCK_CONJURE"] = "Clic col tasto destro sulle tue macro Pietra della Salute o Pietra dell'Anima per crearne una."
L["TIP_WARLOCK_SOUL"] = "Clic centrale per lanciare Rituale delle Anime."

L["UI_BEST_FOOD"] = "Miglior Cibo Attuale"
L["UI_BEST_PET_FOOD"] = "Cibo Famiglio"
L["UI_DISABLED"] = "Disabilitato"
L["UI_ENABLED"] = "Abilitato"
L["UI_IGNORE_LIST"] = "Lista Ignorati"
L["UI_LEFT_CLICK"] = "Clic Sinistro"
L["UI_MIDDLE_CLICK"] = "Clic Centrale"
L["UI_RIGHT_CLICK"] = "Clic Destro"
L["UI_SHIFT_LEFT"] = "Shift + Clic Sinistro"
L["UI_TOGGLE"] = "Attiva/Disattiva"

L["MODE_ALWAYS"] = "Sempre"
L["MODE_PARTY"] = "Solo in gruppo"
L["MODE_RAID"] = "Solo in incursione"

-- Options Panel
L["OPTIONS_DESC"] = "Crea macro che si aggiornano automaticamente per i tuoi migliori consumabili, tracciando i buff per mantenerti al massimo delle prestazioni. Include un Feed-O-Matic tutto in uno per Cacciatori e un'evocazione intelligente con il clic destro per Maghi e Stregoni che si adatta al livello del tuo bersaglio."
L["OPTIONS_BUFF_FOOD"] = "Priorità Cibo con Buff"
L["OPTIONS_BUFF_FOOD_DESC"] = 'Dà priorità al cibo che fornisce il buff "Ben Nutrito", quando il buff è assente.'
L["OPTIONS_SCROLL_HEADER"] = "Buff Pergamena"
L["OPTIONS_USE_SCROLLS"] = "Includi Buff Pergamena"
L["OPTIONS_USE_SCROLLS_DESC"] = "Usa pergamene, quando il buff è assente, come parte della tua macro Cibo."
L["OPTIONS_SCROLL_TYPES"] = "Includi Tipi di Pergamena nel Controllo"
L["OPTIONS_SCROLL_AGILITY"] = "Agilità"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelletto"
L["OPTIONS_SCROLL_PROTECTION"] = "Protezione"
L["OPTIONS_SCROLL_SPIRIT"] = "Spirito"
L["OPTIONS_SCROLL_STAMINA"] = "Tempra"
L["OPTIONS_SCROLL_STRENGTH"] = "Forza"

L["OPTIONS_PET_HEADER"] = "Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS"] = "Usa Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS_DESC"] = 'Usa Cibo per Famigli come parte della tua macro Cibo quando manca il buff "Ben Nutrito" sul tuo famiglio.'
L["OPTIONS_PET_BUFF_TYPES"] = "Includi Tipi di Cibo Famiglio nel Controllo"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Bocconcini di Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Spuntini degli Sporeggiar"

L["OPTIONS_NIGHTELF_HEADER"] = "Elfi della Notte"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Bere con Fondersi con l'Ombra"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Aggiunge Fondersi con l'Ombra alla tua macro Acqua per renderti furtivo mentre bevi."

L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Apre l'interfaccia delle opzioni di Connoisseur."

L["OPTIONS_ENABLE_MACROS_HEADER"] = "Abilita Macro"
L["OPTIONS_ENABLE_MACROS_DESC"] = "Scegli quali macro Connoisseur deve creare e mantenere. Disabilitare una macro la rimuoverà anche."

L["OPTIONS_RESET_HEADER"] = "Reimposta"
L["OPTIONS_RESET_IGNORE_DESC"] = "Rimuovi tutti gli oggetti dalla lista ignorati."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Sei sicuro di voler svuotare la lista ignorati?"
L["OPTIONS_RESET_ALL"] = "Reimposta Tutte le Opzioni di Connoisseur"
L["OPTIONS_RESET_ALL_DESC"] = "Reimposta tutte le impostazioni e la lista ignorati ai valori predefiniti."
L["OPTIONS_RESET_ALL_CONFIRM"] = "Reimpostare tutte le opzioni di Connoisseur ai valori predefiniti?"

L["OPTIONS_COMMUNITY_HEADER"] = "Feedback e Supporto"