local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "itIT")
if not L then return end

-- [[ ITALIAN (itIT) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["BRAND"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Benda"
L["MACRO_FEED_PET"] = "- Nutri Famiglio"
L["MACRO_FOOD"] = "- Cibo"
L["MACRO_HEALTH_POTION"] = "- Poz. Salute"
L["MACRO_HEALTHSTONE"] = "- Pietra Salute"
L["MACRO_MANA_GEM"] = "- Gemma di Mana"
L["MACRO_MANA_POTION"] = "- Poz. Mana"
L["MACRO_SOULSTONE"] = "- Pietra Anima"
L["MACRO_WATER"] = "- Acqua"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "Grado"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] = "Sembra che tu abbia trovato un bug! %s (%s) non può essere usato in %s > %s (%s). Segnalalo per aiutarci a risolverlo. Grazie! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Nessun %s adatto trovato nelle tue borse."

L["CHAT_LOADED"] = "Versione @project-version@. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > Addon > Connoisseur. Ti piace l'addon? Parlane a un amico! (="

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "Priorità Cibo con Buff"
L["MENU_BUFF_FOOD_DESC"] = "Dà priorità al cibo che fornisce il buff \"Ben Nutrito\", quando il buff è assente."
L["MENU_CLEAR_IGNORE"] = "Svuota Lista Ignorati"
L["MENU_IGNORE"] = "Ignora"

L["MENU_SCROLL_BUFFS"] = "Buff Pergamena"
L["MENU_SCROLL_BUFFS_DESC"] = "Trasforma la tua macro Cibo in un applicatore di pergamene quando ti mancano i buff delle pergamene."
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

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Sempre"
L["MODE_PARTY"] = "Solo in gruppo"
L["MODE_RAID"] = "Solo in incursione"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "Macro che si aggiornano automaticamente per il tuo miglior cibo, cibo con buff, acqua, pergamene, pozioni di cura e mana, pietre della salute, pietre dell'anima, gemme di mana e bende. Evocazione con un clic per Maghi e Stregoni, Nutri Famiglio intelligente per Cacciatori. Nutrizione ottimale, massime prestazioni."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Abilita messaggio di benvenuto"
L["OPTIONS_WELCOME_MESSAGE_DESC"] = "Stampa un messaggio di benvenuto nella chat all'accesso."

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "Priorità Cibo con Buff"
L["OPTIONS_BUFF_FOOD_DESC"] = "Dà priorità al cibo che fornisce il buff \"Ben Nutrito\", quando il buff è assente."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Buff Pergamena"
L["OPTIONS_USE_SCROLLS"] = "Includi Buff Pergamena"
L["OPTIONS_USE_SCROLLS_DESC"] = "Trasforma la tua macro Cibo in un applicatore di pergamene dedicato ogni volta che ti mancano i buff delle pergamene. Tocca una volta per applicare le pergamene; tocca di nuovo per mangiare. Le pergamene ignorano il GCD, hanno te come bersaglio e la macro ritorna al cibo nel momento in cui selezioni un altro giocatore amico."
L["OPTIONS_SCROLL_TYPES"] = "Includi Tipi di Pergamena nel Controllo"
L["OPTIONS_SCROLL_AGILITY"] = "Agilità"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelletto"
L["OPTIONS_SCROLL_PROTECTION"] = "Protezione"
L["OPTIONS_SCROLL_SPIRIT"] = "Spirito"
L["OPTIONS_SCROLL_STAMINA"] = "Tempra"
L["OPTIONS_SCROLL_STRENGTH"] = "Forza"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS"] = "Usa Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS_DESC"] = "Usa Cibo per Famigli come parte della tua macro Cibo quando manca il buff \"Ben Nutrito\" sul tuo famiglio."
L["OPTIONS_PET_BUFF_TYPES"] = "Includi Tipi di Cibo Famiglio nel Controllo"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Bocconcini di Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Spuntini degli Sporeggiar"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druidi"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Abilita l'integrazione DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESC"] = "Crea macro di mutaforma per Pozioni di Salute, Pozioni di Mana e Pietre della Salute utilizzando DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Dopo il consumabile, passa a"
L["DRUID_FORM_BEAR"] = "Orso"
L["DRUID_FORM_CAT"] = "Gatto"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfi della Notte"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Bere con Fondersi con l'Ombra"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Aggiunge Fondersi con l'Ombra alla tua macro Acqua per renderti furtivo mentre bevi."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Apre l'interfaccia delle opzioni di Connoisseur."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Abilita Macro"
L["OPTIONS_ENABLE_MACROS_DESC"] = "Scegli quali macro Connoisseur deve creare e mantenere. Disabilitare una macro la rimuoverà anche."

-- Reset
L["OPTIONS_RESET_HEADER"] = "Reimposta"
L["OPTIONS_RESET_IGNORE_DESC"] = "Rimuovi tutti gli oggetti dalla lista ignorati."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Sei sicuro di voler svuotare la lista ignorati?"
L["OPTIONS_RESET_ALL"] = "Reimposta Tutte le Opzioni di Connoisseur"
L["OPTIONS_RESET_ALL_DESC"] = "Reimposta tutte le impostazioni e la lista ignorati ai valori predefiniti."
L["OPTIONS_RESET_ALL_CONFIRM"] = "Reimpostare tutte le opzioni di Connoisseur ai valori predefiniti?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback e Supporto"