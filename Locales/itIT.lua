local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "itIT")
if not L then
	return
end

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
L["MACRO_EXPLOSIVES"] = "- Esplosivi"
L["MACRO_FEED_PET"] = "- Nutri Famiglio"
L["MACRO_FOOD"] = "- Cibo"
L["MACRO_HEALTH_POTION"] = "- Poz. Salute"
L["MACRO_HEALTHSTONE"] = "- Pietra Salute"
L["MACRO_MANA_GEM"] = "- Gemma di Mana"
L["MACRO_MANA_POTION"] = "- Poz. Mana"
L["MACRO_POISONS"] = "- Veleni"
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

L["MSG_BUG_REPORT"] =
	"Sembra che tu abbia trovato un bug! %s (%s) non può essere usato in %s > %s (%s). Segnalalo per aiutarci a risolverlo. Grazie! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Nessun %s adatto trovato nelle tue borse."
L["MSG_MACRO_SLOTS_FULL"] =
	"Alcune macro di Connoisseur non sono state create perché gli slot delle macro sono pieni. Libera uno slot eliminando le macro che non usi più, oppure disattiva le macro di Connoisseur che non ti servono in Opzioni > Addon > Connoisseur."

L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > Addon > Connoisseur. Ti piace l'addon? Parlane a un amico! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "Al momento non hai alcun cibo utile per il tuo famiglio."
L["TIP_PET_NO_SKILLS"] = "Al momento non conosci Nutri Famiglio, Cura Famiglio o Rianima Famiglio."
L["TIP_PET_NO_MEND"] = "Al momento non conosci Cura Famiglio."
L["TIP_NO_HAND_POISON"] = "Hai esaurito il veleno scelto per quest'arma."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Al momento non conosci %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Dà priorità al cibo che fornisce il buff "Ben Nutrito", quando il buff è assente.'
L["MENU_SCROLL_BUFFS"] = "Buff Pergamena"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Trasforma la tua macro Cibo in un applicatore di pergamene quando ti mancano i buff delle pergamene."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Cibo Attuale"
L["UI_BEST_PET_FOOD"] = "Cibo Famiglio"
L["UI_IGNORE_LIST"] = "Lista Ignorati"
L["MENU_IGNORE"] = "Ignora"
L["MENU_CLEAR_IGNORE"] = "Svuota Lista Ignorati"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Opzioni di Connoisseur"
L["MENU_OPTIONS_KEYBIND"] = "Shift + Clic Centrale"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

L["PREFIX_HUNTER"] = "Attenzione Cacciatori"
L["PREFIX_MAGE"] = "Attenzione Maghi"
L["PREFIX_ROGUE"] = "Attenzione Ladri"
L["PREFIX_WARLOCK"] = "Attenzione Stregoni"

L["TIP_DOWNRANK"] =
	"Selezionare un giocatore di livello inferiore farà creare alla macro oggetti adatti al suo livello."
L["TIP_HUNTER_FEED_PET"] =
	"Nutri Famiglio è un pulsante tutto-in-uno! Clicca per Richiamare, Nutrire o Rianimare automaticamente il tuo famiglio. Clic col tasto destro o in combattimento per lanciare Cura Famiglio. Tieni premuto Shift per forzare Rianima, o Ctrl per Congeda."
L["TIP_MAGE_CONJURE"] = "Clic col tasto destro sulle tue macro Cibo o Acqua per Creare Cibo o Acqua."
L["TIP_MAGE_GEM"] =
	"Clic col tasto destro sulla tua macro Gemma di Mana per crearne una nuova. Clic destro di nuovo per creare una gemma di grado inferiore di scorta."
L["TIP_MAGE_TABLE"] = "Clic centrale per lanciare Rituale del Rinfresco."
L["TIP_WARLOCK_CONJURE"] =
	"Clic col tasto destro sulle tue macro Pietra della Salute o Pietra dell'Anima per crearne una. Clic destro di nuovo sulla tua macro Pietra della Salute per creare una pietra di grado inferiore di scorta."
L["TIP_WARLOCK_SOUL"] = "Clic centrale per lanciare Rituale delle Anime."
L["TIP_ROGUE_POISONS"] =
	"Clic sinistro applica il veleno della mano secondaria, clic destro quello della mano principale. I veleni esistenti vengono sostituiti automaticamente. Clic centrale apre la finestra Veleni."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

L["LABEL_BANDAGE"] = "Benda"
L["LABEL_EXPLOSIVE"] = "Esplosivo"
L["LABEL_FOOD"] = "Cibo"
L["LABEL_HEALTH_POTION"] = "Pozione di Salute"
L["LABEL_HEALTHSTONE"] = "Pietra della Salute"
L["LABEL_MANA_GEM"] = "Gemma di Mana"
L["LABEL_MANA_POTION"] = "Pozione di Mana"
L["LABEL_PET_FOOD"] = "Cibo Famiglio"
L["LABEL_POISONS"] = "Veleno"
L["LABEL_SOULSTONE"] = "Pietra dell'Anima"
L["LABEL_WATER"] = "Acqua"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the minimap tooltip and options panel.

L["UI_ENABLED"] = "Abilitato"
L["UI_DISABLED"] = "Disabilitato"
L["UI_TOGGLE"] = "Attiva/Disattiva"
L["UI_LEFT_CLICK"] = "Clic Sinistro"
L["UI_RIGHT_CLICK"] = "Clic Destro"
L["UI_MIDDLE_CLICK"] = "Clic Centrale"
L["UI_SHIFT_LEFT"] = "Shift + Clic Sinistro"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Sempre"
L["MODE_PARTY"] = "Solo in gruppo"
L["MODE_RAID"] = "Solo in incursione"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Macro che si aggiornano automaticamente per il tuo miglior cibo, cibo con buff, acqua, pergamene, pozioni di cura e mana, pietre della salute, pietre dell'anima, gemme di mana e bende. Evocazione con un clic per Maghi e Stregoni, Nutri Famiglio intelligente per Cacciatori. Nutrizione ottimale, massime prestazioni."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Abilita messaggio di benvenuto"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Stampa un messaggio di benvenuto nella chat all'accesso."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Abilita pulsante della minimappa"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Mostra il pulsante della minimappa."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Abilita i nomi delle macro sui pulsanti"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Mostra il testo del nome della macro sui pulsanti della barra delle azioni. Disattivato per impostazione predefinita, il che nasconde i nomi che Blizzard ha recentemente ricominciato a mostrare."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Pozioni e Pietre della Salute"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"Le macro non possono cambiare durante il combattimento (questa è una restrizione della Blizzard), quindi ogni macro per Pozioni e Pietre della Salute è pre-costruita con il tuo miglior oggetto più fino a due alternative. Nei combattimenti più lunghi, l'icona e il tooltip possono diventare obsoleti e mostrare l'oggetto sbagliato, ma cliccando sulla macro verrà sempre utilizzato il miglior oggetto che hai effettivamente nelle borse."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "Combina le Pietre della Salute nella macro della Pozione di Salute"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"Aggiunge la tua migliore Pietra della Salute in fondo alla macro della Pozione di Salute, così una singola pressione usa una pozione e una Pietra della Salute."

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "Rinnovo Buff"
L["OPTIONS_REAPPLY"] = "Rinnova i Buff in scadenza"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"I combattimenti spesso durano più di quanto resta ai tuoi buff. I buff con meno tempo rimanente della soglia contano come già scaduti, così le macro ne offrono uno nuovo prima del pull. Si applica a Cibo con Buff, Buff Pergamena e Buff Cibo Famiglio."
L["OPTIONS_REAPPLY_THRESHOLD"] = "Considera scaduto quando"
L["REAPPLY_THRESHOLD_ONE"] = "< 1 minuto rimanente"
L["REAPPLY_THRESHOLD_N"] = "< %d minuti rimanenti"

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "Cibo con Buff"
L["OPTIONS_BUFF_FOOD"] = "Priorità Cibo con Buff"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'Dà priorità al cibo che fornisce il buff "Ben Nutrito", quando il buff è assente.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Suggerimento pro: Avere te stesso come bersaglio fa sì che la macro Cibo ignori sempre il cibo con buff e le pergamene."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Buff Pergamena"
L["OPTIONS_USE_SCROLLS"] = "Includi Buff Pergamena"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Trasforma la tua macro Cibo in un applicatore di pergamene dedicato ogni volta che ti mancano i buff delle pergamene. Tocca una volta per applicare le pergamene; tocca di nuovo per mangiare. Le pergamene ignorano il GCD, hanno te come bersaglio e la macro ritorna al cibo nel momento in cui selezioni un altro giocatore amico."
L["OPTIONS_SCROLL_TYPES"] = "Includi Tipi di Pergamena nel Controllo"
L["OPTIONS_SCROLL_AGILITY"] = "Agilità"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelletto"
L["OPTIONS_SCROLL_PROTECTION"] = "Protezione"
L["OPTIONS_SCROLL_SPIRIT"] = "Spirito"
L["OPTIONS_SCROLL_STAMINA"] = "Tempra"
L["OPTIONS_SCROLL_STRENGTH"] = "Forza"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "Esplosivi"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"L'opzione @player salta il reticolo di puntamento e fa detonare l'esplosivo ai tuoi piedi. Ideale quando il bersaglio è in mischia."
L["EXPLOSIVES_MODE_ATPLAYER"] = "Clic Sinistro @Player, Clic Destro Lancio"
L["EXPLOSIVES_MODE_TOSS"] = "Clic Sinistro Lancio, Clic Destro @Player"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS"] = "Usa Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Usa Cibo per Famigli come parte della tua macro Cibo quando manca il buff "Ben Nutrito" sul tuo famiglio.'
L["OPTIONS_PET_BUFF_TYPES"] = "Includi Tipi di Cibo Famiglio nel Controllo"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Bocconcini di Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Spuntini degli Sporeggiar"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druidi"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Abilita l'integrazione DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Crea macro di mutaforma per Pozioni di Salute, Pozioni di Mana e Pietre della Salute utilizzando DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Dopo il consumabile, passa a"
L["DRUID_FORM_BEAR"] = "Orso"
L["DRUID_FORM_CAT"] = "Gatto"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfi della Notte"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Bere con Fondersi con l'Ombra"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] =
	"Aggiunge Fondersi con l'Ombra alla tua macro Acqua per renderti furtivo mentre bevi."

-- Rogues
L["OPTIONS_POISONS_HEADER"] = "Veleni"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Mantiene la macro Veleni carica con il miglior rango utilizzabile di ogni tipo di veleno: clic sinistro applica alla mano secondaria, clic destro alla mano principale, e i veleni esistenti vengono sostituiti automaticamente."
L["OPTIONS_POISON_MAIN_HAND"] = "Mano principale"
L["OPTIONS_POISON_OFF_HAND"] = "Mano secondaria"

-- Restocker
L["OPTIONS_RESTOCKER_HEADER"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Mantiene le borse rifornite in base a una lista di rifornimento per personaggio. Compra automaticamente dai mercanti e sposta gli oggetti tra le borse e la banca. Digita /crs per aprire la lista."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Apri in banca"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Apre la finestra di Restocker quando visiti la banca."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Apri dal mercante"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Apre la finestra di Restocker quando visiti un mercante."
L["OPTIONS_RESTOCKER_DEBUG"] = "Attiva i messaggi di debug di Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Stampa in chat le decisioni di rifornimento di Restocker passo per passo (banca e mercante). Prolisso; resta attivo tra le sessioni finché non viene disattivato."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_FOODIE"] = "/foodie"
L["OPTIONS_COMMANDS_FOODIE_DETAIL"] = "Apre l'interfaccia delle opzioni di Connoisseur."
L["OPTIONS_COMMANDS_CRS"] = "/crs"
L["OPTIONS_COMMANDS_CRS_DETAIL"] = "Apre la finestra di Restocker per gestire la tua lista di rifornimento."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Abilita Macro"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Scegli quali macro Connoisseur deve creare e mantenere. Disabilitare una macro la rimuoverà anche."

-- Ignore List
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "Rimuovi tutti gli oggetti dalla lista ignorati."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Sei sicuro di voler svuotare la lista ignorati?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback e Supporto"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "Le tue liste di Restocker sono state importate."
L["RESTOCKER_PROFILE_EXISTS"] = 'Esiste già un profilo chiamato "%s".'
L["RESTOCKER_BANK_NOT_OPEN"] = "La banca non è aperta."
-- %s is the /crs slash command, colored at the call site.
L["RESTOCKER_COMPLETE"] =
	"Rifornimento completato. Tieni premuto Maiusc per saltarlo la prossima volta. Digita %s per modificare la tua lista di rifornimento."
L["RESTOCKER_STOPPED_BOTH_FULL"] = "Rifornimento interrotto. Le tue borse e la tua banca sono piene."
L["RESTOCKER_STOPPED_BANK_FULL"] = "Rifornimento interrotto. La tua banca è piena; libera uno spazio e riaprila."
L["RESTOCKER_STOPPED_BAG_FULL"] =
	"Rifornimento interrotto. Le tue borse sono piene; libera uno spazio e riapri la banca."
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "Rifornimento interrotto. Nessun progresso possibile."
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] = "Rifornimento interrotto. Impossibile spostare: %s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (in eccesso)"
L["RESTOCKER_STOPPED_ERROR"] = "Rifornimento interrotto a causa di un errore: %s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] = "Le tue borse sono piene. Rifornimento dal mercante saltato."
L["RESTOCKER_FINISHED_RESTOCKING"] = "Rifornimento terminato (%d acquisti effettuati)."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Mostra la finestra di Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Aggiunge un profilo con quel nome."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Elimina il profilo con quel nome."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Rinomina il profilo attuale con quel nome."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copia quel profilo nel profilo attuale."
L["RESTOCKER_HELP_PROFILE_USE"] = "Passa al profilo con quel nome."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filtra oggetti..."
L["RESTOCKER_ADD_BUTTON"] = "Aggiungi"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Aggiungi un oggetto"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "Trascina un oggetto dalle tue borse o digita un ID oggetto numerico."
L["RESTOCKER_PROFILE_LABEL"] = "Profilo:"
L["RESTOCKER_RENAME_LABEL"] = "Rinomina:"
L["RESTOCKER_NEW_PROFILE"] = "Nuovo profilo"
L["RESTOCKER_GROUP_OTHER"] = "Altro"
L["RESTOCKER_REMOVE_TOOLTIP"] = "Rimuove questo oggetto dalla lista di rifornimento."
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "Quantità da mantenere"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "Premi Invio quando hai finito."
L["RESTOCKER_BUY_LABEL"] = "Compra"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "Compra dal mercante"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "Compra la quantità necessaria quando la finestra del mercante è aperta."
L["RESTOCKER_DEPOSIT_LABEL"] = "Deposita"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "Deposita in banca"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"Ripone gli oggetti in eccesso in banca quando è aperta. Usa 0 per riporre tutto."
L["RESTOCKER_WITHDRAW_LABEL"] = "Preleva"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "Rifornisci dalla banca"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "Preleva gli oggetti necessari dalla banca quando è aperta."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "Reputazione richiesta"
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (%d%% di sconto)"
L["RESTOCKER_REPUTATION_ANY"] = "Qualsiasi"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Amichevole"
L["RESTOCKER_REPUTATION_HONORED"] = "Onorato"
L["RESTOCKER_REPUTATION_REVERED"] = "Riverito"
L["RESTOCKER_REPUTATION_EXALTED"] = "Osannato"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Reputazione richiesta col mercante"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] = "Compra solo da mercanti con cui hai almeno questa reputazione."
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Una reputazione più alta significa anche prezzi più bassi (Amichevole 5%, Onorato 10%, Riverito 15%, Osannato 20%)."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Clicca per scegliere una reputazione"
