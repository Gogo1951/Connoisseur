local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "itIT")
if not L then return end

-- [[ ITALIAN (itIT) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

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
-- Pet Diets
--------------------------------------------------------------------------------

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

L["DIET_BREAD"] = "Pane"
L["DIET_CHEESE"] = "Formaggio"
L["DIET_FISH"] = "Pesce"
L["DIET_FRUIT"] = "Frutta"
L["DIET_FUNGUS"] = "Fungo"
L["DIET_MEAT"] = "Carne"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] = "Sembra che tu abbia trovato un bug! %s (%s) non può essere usato in %s > %s (%s). Segnalalo per aiutarci a risolverlo. Grazie! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Nessun %s adatto trovato nelle tue borse."
L["MSG_MACRO_SLOTS_FULL"] = "Alcune macro di Connoisseur non sono state create perché gli slot delle macro sono pieni. Libera uno slot eliminando le macro che non usi più, oppure disattiva le macro di Connoisseur che non ti servono in Opzioni > Addon > Connoisseur."

L["CHAT_LOADED"] = "Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > Addon > Connoisseur. Ti piace l'addon? Parlane a un amico! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Core.lua.

L["TIP_PET_NO_FOOD"] = "Al momento non hai alcun cibo utile per il tuo famiglio."
L["TIP_PET_NO_SKILLS"] = "Al momento non conosci Nutri Famiglio, Cura Famiglio o Rianima Famiglio."
L["TIP_PET_NO_MEND"] = "Al momento non conosci Cura Famiglio."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Al momento non conosci %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "Priorità Cibo con Buff"
L["MENU_BUFF_FOOD_DESCRIPTION"] = "Dà priorità al cibo che fornisce il buff \"Ben Nutrito\", quando il buff è assente."
L["MENU_CLEAR_IGNORE"] = "Svuota Lista Ignorati"
L["MENU_IGNORE"] = "Ignora"

L["MENU_SCROLL_BUFFS"] = "Buff Pergamena"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "Trasforma la tua macro Cibo in un applicatore di pergamene quando ti mancano i buff delle pergamene."
L["MENU_OPTIONS_HINT"] = "Impostazioni aggiuntive in Opzioni > Addon > Connoisseur."

L["PREFIX_HUNTER"] = "Attenzione Cacciatori"
L["PREFIX_MAGE"] = "Attenzione Maghi"
L["PREFIX_WARLOCK"] = "Attenzione Stregoni"

L["TIP_DOWNRANK"] = "Selezionare un giocatore di livello inferiore farà creare alla macro oggetti adatti al suo livello."
L["TIP_HUNTER_FEED_PET"] = "Nutri Famiglio è un pulsante tutto-in-uno! Clicca per Richiamare, Nutrire o Rianimare automaticamente il tuo famiglio. Clic col tasto destro o in combattimento per lanciare Cura Famiglio. Tieni premuto Shift per forzare Rianima, o Ctrl per Congeda."
L["TIP_MAGE_CONJURE"] = "Clic col tasto destro sulle tue macro Cibo o Acqua per Creare Cibo o Acqua."
L["TIP_MAGE_GEM"] = "Clic col tasto destro sulla tua macro Gemma di Mana per crearne una nuova. Clic destro di nuovo per creare una gemma di grado inferiore di scorta."
L["TIP_MAGE_TABLE"] = "Clic centrale per lanciare Rituale del Rinfresco."
L["TIP_WARLOCK_CONJURE"] = "Clic col tasto destro sulle tue macro Pietra della Salute o Pietra dell'Anima per crearne una. Clic destro di nuovo sulla tua macro Pietra della Salute per creare una pietra di grado inferiore di scorta."
L["TIP_WARLOCK_SOUL"] = "Clic centrale per lanciare Rituale delle Anime."

L["UI_BEST_FOOD"] = "Cibo Attuale"
L["UI_BEST_PET_FOOD"] = "Cibo Famiglio"

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
L["LABEL_BANDAGE"] = "Benda"
L["LABEL_FOOD"] = "Cibo"
L["LABEL_HEALTH_POTION"] = "Pozione di Salute"
L["LABEL_HEALTHSTONE"] = "Pietra della Salute"
L["LABEL_MANA_GEM"] = "Gemma di Mana"
L["LABEL_MANA_POTION"] = "Pozione di Mana"
L["LABEL_PET_FOOD"] = "Cibo Famiglio"
L["LABEL_SOULSTONE"] = "Pietra dell'Anima"
L["LABEL_WATER"] = "Acqua"
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

L["OPTIONS_DESCRIPTION"] = "Macro che si aggiornano automaticamente per il tuo miglior cibo, cibo con buff, acqua, pergamene, pozioni di cura e mana, pietre della salute, pietre dell'anima, gemme di mana e bende. Evocazione con un clic per Maghi e Stregoni, Nutri Famiglio intelligente per Cacciatori. Nutrizione ottimale, massime prestazioni."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Abilita messaggio di benvenuto"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Stampa un messaggio di benvenuto nella chat all'accesso."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Abilita pulsante della minimappa"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Mostra il pulsante della minimappa."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Pozioni e Pietre della Salute"
L["OPTIONS_POTIONS_DESCRIPTION"] = "Le macro non possono cambiare durante il combattimento (questa è una restrizione della Blizzard), quindi ogni macro per Pozioni e Pietre della Salute è pre-costruita con il tuo miglior oggetto più fino a due alternative. Nei combattimenti più lunghi, l'icona e il tooltip possono diventare obsoleti e mostrare l'oggetto sbagliato, ma cliccando sulla macro verrà sempre utilizzato il miglior oggetto che hai effettivamente nelle borse."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "Combina le Pietre della Salute nella macro della Pozione di Salute"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] = "Aggiunge la tua migliore Pietra della Salute in fondo alla macro della Pozione di Salute, così una singola pressione usa una pozione e una Pietra della Salute."

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "Priorità Cibo con Buff"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = "Dà priorità al cibo che fornisce il buff \"Ben Nutrito\", quando il buff è assente."
L["OPTIONS_BUFF_FOOD_DETAIL"] = "Suggerimento pro: Avere te stesso come bersaglio fa sì che la macro Cibo ignori sempre il cibo con buff e le pergamene."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Buff Pergamena"
L["OPTIONS_USE_SCROLLS"] = "Includi Buff Pergamena"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] = "Trasforma la tua macro Cibo in un applicatore di pergamene dedicato ogni volta che ti mancano i buff delle pergamene. Tocca una volta per applicare le pergamene; tocca di nuovo per mangiare. Le pergamene ignorano il GCD, hanno te come bersaglio e la macro ritorna al cibo nel momento in cui selezioni un altro giocatore amico."
L["OPTIONS_SCROLL_TYPES"] = "Includi Tipi di Pergamena nel Controllo"
L["OPTIONS_SCROLL_AGILITY"] = "Agilità"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelletto"
L["OPTIONS_SCROLL_PROTECTION"] = "Protezione"
L["OPTIONS_SCROLL_SPIRIT"] = "Spirito"
L["OPTIONS_SCROLL_STAMINA"] = "Tempra"
L["OPTIONS_SCROLL_STRENGTH"] = "Forza"

-- Pets Food Buffs
L["OPTIONS_PET_HEADER"] = "Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS"] = "Usa Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] = "Usa Cibo per Famigli come parte della tua macro Cibo quando manca il buff \"Ben Nutrito\" sul tuo famiglio."
L["OPTIONS_PET_BUFF_TYPES"] = "Includi Tipi di Cibo Famiglio nel Controllo"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Bocconcini di Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Spuntini degli Sporeggiar"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druidi"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Abilita l'integrazione DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] = "Crea macro di mutaforma per Pozioni di Salute, Pozioni di Mana e Pietre della Salute utilizzando DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Dopo il consumabile, passa a"
L["DRUID_FORM_BEAR"] = "Orso"
L["DRUID_FORM_CAT"] = "Gatto"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfi della Notte"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Bere con Fondersi con l'Ombra"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] = "Aggiunge Fondersi con l'Ombra alla tua macro Acqua per renderti furtivo mentre bevi."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESCRIPTION"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Apre l'interfaccia delle opzioni di Connoisseur."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Abilita Macro"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] = "Scegli quali macro Connoisseur deve creare e mantenere. Disabilitare una macro la rimuoverà anche."

-- Reset
L["OPTIONS_RESET_HEADER"] = "Reimposta"
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "Rimuovi tutti gli oggetti dalla lista ignorati."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Sei sicuro di voler svuotare la lista ignorati?"
L["OPTIONS_RESET_ALL"] = "Reimposta Tutte le Opzioni di Connoisseur"
L["OPTIONS_RESET_ALL_DESCRIPTION"] = "Reimposta tutte le impostazioni e la lista ignorati ai valori predefiniti."
L["OPTIONS_RESET_ALL_CONFIRM"] = "Reimpostare tutte le opzioni di Connoisseur ai valori predefiniti?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback e Supporto"
