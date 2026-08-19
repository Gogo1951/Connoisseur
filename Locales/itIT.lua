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
	"Sembra che tu abbia trovato un bug! %s (%s) non può essere usato in %s > %s (%s). Segnalalo per aiutarci a risolverlo. Grazie! %s"
L["MSG_NO_ITEM"] = "Nessun %s adatto trovato nelle tue borse."
L["MSG_MACRO_SLOTS_FULL"] =
	"Alcune macro di Connoisseur non sono state create perché gli slot delle macro sono pieni. Libera uno slot eliminando le macro che non usi più, oppure disattiva le macro di Connoisseur che non ti servono in Opzioni > Addon > Connoisseur."

L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > Addon > Connoisseur. Ti piace l'addon? Parlane a un amico! (="

L["CHAT_OPTIONS_IN_COMBAT"] =
	"Per sicurezza, l'interfaccia delle opzioni non può essere aperta durante il combattimento."

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "Tutto pronto!"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "Manca: %s"

L["READY_WELL_FED"] = "Ben Nutrito"
L["READY_SCROLLS"] = "Pergamene"
L["READY_PET_FED"] = "Famiglio Nutrito"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d min"
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s meno di 1 min"

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "Al momento non hai alcun cibo utile per il tuo famiglio."
L["TIP_PET_NO_SKILLS"] =
	"Al momento non conosci Richiama Famiglio, Congeda Famiglio, Nutri Famiglio o Rianima Famiglio."
L["TIP_PET_NO_MEND"] = "Al momento non conosci Cura Famiglio."
L["TIP_NO_HAND_POISON"] = "Hai esaurito il veleno scelto per quest'arma."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Al momento non conosci %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the mini-map tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "Cibo con Buff"
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Dà priorità al cibo che fornisce il buff "Ben Nutrito", quando il buff è assente.'
L["FEATURE_SCROLL_BUFFS"] = "Buff Pergamena"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Trasforma la tua macro Cibo in un applicatore di pergamene quando ti mancano i buff delle pergamene."

-- Section titles and ignore-list actions in the mini-map tooltip.
L["UI_BEST_FOOD"] = "Cibo Attuale"
L["UI_BEST_PET_FOOD"] = "Cibo Famiglio Attuale"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "Mano Principale"
L["UI_OFF_HAND"] = "Mano Secondaria"
--[[
    The value shown beside an item title when nothing resolved. Kept to a single
    word so it fits in the tooltip's right column, which never wraps -- the full
    sentence, MSG_NO_ITEM, explains it on the wrapping line underneath.
]]
L["UI_NONE"] = "Nessuno"
L["UI_IGNORE_LIST"] = "Lista Ignorati"
L["MENU_IGNORE"] = "Ignora"
L["MENU_CLEAR_IGNORE"] = "Svuota Lista Ignorati"

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
L["UI_RESTOCKER_REPORT"] = "Rapporto di rifornimento"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 ordine in sospeso"
L["UI_RESTOCKER_NEEDED"] = "%d ordini in sospeso"
L["UI_RESTOCKER_STOCKED_SHORT"] = "Scorte al completo"
L["UI_RESTOCKER_STOCKED"] = "Complimenti, hai le scorte al completo!"

-- Options entry at the bottom of the mini-map tooltip.
L["MENU_OPTIONS"] = "Opzioni di Connoisseur"
L["MENU_OPTIONS_KEYBIND"] = "Shift + Clic Centrale"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

--[[
    Class-colored headers and conjure/pet tips shown in the mini-map tooltip for
    the player's class.
]]

L["PREFIX_HUNTER"] = "Attenzione Cacciatori"
L["PREFIX_MAGE"] = "Attenzione Maghi"
L["PREFIX_ROGUE"] = "Attenzione Ladri"
L["PREFIX_WARLOCK"] = "Attenzione Stregoni"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to -- the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "Riguardo alla tua macro Nutri Famiglio..."
L["TIP_MAGE_MACROS"] = "Riguardo alle tue macro Cibo, Acqua e Gemma di Mana..."
L["TIP_ROGUE_MACROS"] = "Riguardo alla tua macro Veleni..."
L["TIP_WARLOCK_MACROS"] = "Riguardo alle tue macro Pietra della Salute e Pietra dell'Anima..."

L["TIP_HUNTER_ALL_IN_ONE"] = "Nutri Famiglio è un pulsante tutto-in-uno per il famiglio!"
L["TIP_HUNTER_CALL"] = "Clic sinistro per richiamare, nutrire o rianimare automaticamente il tuo famiglio."
L["TIP_HUNTER_MEND"] = "Clic destro o attendi il combattimento per lanciare Cura Famiglio."
L["TIP_HUNTER_MODIFIERS"] = "Tieni premuto Shift per forzare Rianima, o Ctrl per Congedare."

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "Clic col tasto destro sulle tue macro Cibo o Acqua per Creare Cibo o Acqua."
L["TIP_MAGE_DOWNRANK"] = "Selezionare un giocatore di livello inferiore creerà Cibo o Acqua adatti al suo livello."
L["TIP_MAGE_TABLE"] = "Clic centrale sulle tue macro Cibo o Acqua per lanciare Rituale del Rinfresco."
L["TIP_MAGE_GEM"] =
	"Clic col tasto destro sulla tua macro Gemma di Mana per crearne una nuova. Clic destro di nuovo per creare una gemma di grado inferiore di scorta."

L["TIP_WARLOCK_HEALTHSTONE"] =
	"Clic destro sulla tua macro Pietra della Salute per creare una Pietra della Salute. Clic destro di nuovo per creare una pietra di grado inferiore di scorta."
L["TIP_WARLOCK_DOWNRANK"] =
	"Selezionare un giocatore di livello inferiore creerà una Pietra della Salute adatta al suo livello."
L["TIP_WARLOCK_SOULSTONE"] = "Clic destro sulla tua macro Pietra dell'Anima per creare una Pietra dell'Anima."
L["TIP_WARLOCK_SOUL"] = "Clic centrale sulla tua macro Pietra della Salute per lanciare Rituale delle Anime."

L["TIP_ROGUE_OFF_HAND"] = "Clic sinistro applica il veleno della mano secondaria."
L["TIP_ROGUE_MAIN_HAND"] = "Clic destro applica il veleno della mano principale."
L["TIP_ROGUE_REPLACE"] = "I veleni esistenti vengono sostituiti automaticamente."
L["TIP_ROGUE_WINDOW"] = "Clic centrale apre la finestra dei Veleni."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

--[[
    Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
    One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
]]

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

-- Generic labels reused across the mini-map tooltip and options panel.

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
L["MODE_PARTY"] = "Solo in gruppo o incursione"
L["MODE_RAID"] = "Solo in incursione"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Macro che usano automaticamente il tuo miglior cibo, cibo con buff, acqua, pozioni, pietre della salute, bende e pergamene, più una lista di rifornimento che tiene piene le tue borse e migliora i tuoi consumabili man mano che sali di livello. Automazione per il comfort di gioco, massime prestazioni."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Abilita messaggio di benvenuto"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Stampa un messaggio di benvenuto nella chat all'accesso."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Abilita pulsante della minimappa"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Mostra il pulsante della minimappa."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Abilita i nomi delle macro sui pulsanti"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Mostra il testo del nome della macro sui pulsanti della barra delle azioni. Disattivato per impostazione predefinita, il che nasconde i nomi che il gioco mostra da solo."

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
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "Quando rimane < 1 minuto"
L["REAPPLY_THRESHOLD_N"] = "Quando rimangono < %d minuti"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "Controllo Preparazione"
L["OPTIONS_READY_CHECK"] = "Segnala lo stato al controllo preparazione"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"Mostra cosa ti manca e quanto tempo resta ai buff monitorati a ogni controllo di preparazione; lo vedi solo tu."

--[[
    Three features are suppressed in a PvP Arena, and each says so with the
    same sentence. It lives here once and is appended at the call site
    (Options/Options-Macros.lua), so every locale translates it a single time
    and the caveat can never drift between the three.
]]
L["OPTIONS_DISABLED_IN_ARENAS"] = "Disattivato nelle Arene."

--[[
    Buff Food. The section header reuses FEATURE_BUFF_FOOD, and the options
    description reuses MENU_BUFF_FOOD_DESCRIPTION plus the arena note above --
    the mini-map tooltip and the options panel say the same thing, so they read
    from one key rather than two copies of one sentence.
]]
L["OPTIONS_BUFF_FOOD"] = "Priorità Cibo con Buff"
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Suggerimento pro: Avere te stesso come bersaglio fa sì che la macro Cibo ignori sempre il cibo con buff e le pergamene."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "Includi Buff Pergamena"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Tocca una volta per applicare le pergamene mancanti, di nuovo per mangiare. Le pergamene ignorano il GCD e hanno te come bersaglio; selezionare un giocatore amico le salta."
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
L["EXPLOSIVES_MODE_ATPLAYER"] = "Clic Sinistro @player, Clic Destro Lancio"
L["EXPLOSIVES_MODE_TOSS"] = "Clic Sinistro Lancio, Clic Destro @player"

--[[
    Ignore List. The rows are items, so the only copy here is the add box and
    the placeholder shown while the client is still resolving an item's name.
    The section header and the clear-all button reuse UI_IGNORE_LIST and
    MENU_CLEAR_IGNORE, which the mini-map tooltip already carries.
]]
L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Oggetti che Connoisseur non sceglierà mai, per quanto buoni siano. Fai Clic Destro sul pulsante della minimappa per ignorare il cibo che sta proponendo in quel momento, oppure aggiungi un oggetto qui sotto."
L["OPTIONS_IGNORE_ADD_ID"] = "Aggiungi tramite ID oggetto"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Digita un ID oggetto, oppure fai Shift + Clic su un collegamento a un oggetto in chat mentre questo campo è attivo."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] =
	"Digita un ID oggetto, oppure fai Shift + Clic su un collegamento a un oggetto in chat."
L["OPTIONS_IGNORE_REMOVE"] = "Rimuovi"
L["OPTIONS_IGNORE_EMPTY"] = "Questa lista è vuota."
L["OPTIONS_IGNORE_CLEAR_CONFIRM"] = "Rimuovere tutti gli oggetti dalla tua Lista Ignorati?"
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "Caricamento ID: %d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS"] = "Usa Buff Cibo Famiglio"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Aggiunge Cibo per Famigli alla tua macro Cibo quando manca il buff "Ben Nutrito" sul tuo famiglio.'
L["OPTIONS_PET_BUFF_TYPES"] = "Includi Tipi di Cibo Famiglio nel Controllo"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Bocconcini di Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Spuntini degli Sporeggiar"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druidi"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Abilita l'integrazione DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Crea macro di mutaforma per Pozioni di Salute, Pozioni di Mana e Pietre della Salute utilizzando DruidMacroHelper (/dmh)."
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "Torna a Orso"
L["DRUID_FORM_CAT"] = "Torna a Gatto"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfi della Notte"
L["OPTIONS_STEALTH_DRINKING"] = "Abilita furtività mentre bevi"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] =
	"Aggiunge Fondersi con l'Ombra alla tua macro Acqua per renderti furtivo mentre bevi."
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	"Aggiunge Fondersi con l'Ombra alla tua macro Cibo per renderti furtivo mentre mangi."
L["OPTIONS_STEALTH_PICK_ONE"] =
	"Suggerimento pro: Scegline uno. Puoi mangiare e bere allo stesso tempo, ma mangiare o bere dopo esserti reso furtivo interromperà la furtività."

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "Ladri"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Mantiene la macro Veleni carica con il miglior rango utilizzabile di ogni tipo di veleno: clic sinistro applica alla mano secondaria, clic destro alla mano principale, e i veleni esistenti vengono sostituiti automaticamente."
L["OPTIONS_POISON_MAIN_HAND"] = "Tipo di veleno mano principale"
L["OPTIONS_POISON_OFF_HAND"] = "Tipo di veleno mano secondaria"
L["OPTIONS_STEALTH_EATING"] = "Abilita furtività mentre mangi"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] =
	"Aggiunge Furtività alla tua macro Cibo per renderti furtivo mentre mangi."

--[[
    Restocker options panel. The tree label stays "Restocker" in every locale
    (brand fragment, localization allowlist); the panel header reuses
    RESTOCKER_WINDOW_TITLE.
]]
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Mantiene le borse rifornite in base a una lista di rifornimento per personaggio. Compra automaticamente dai mercanti e sposta gli oggetti tra le borse e la banca. Digita %s per aprire la lista."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Apri in banca"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Apre la finestra di Restocker quando visiti la banca."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Apri dal mercante"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Apre la finestra di Restocker quando visiti un mercante."
L["OPTIONS_RESTOCKER_REMIND"] = "Attiva i promemoria di rifornimento in città"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"Stampa un promemoria in chat quando manca qualcosa alla tua lista di rifornimento e raggiungi una locanda o una città, o ti trovi già in una all'accesso."
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "Attiva i promemoria di rifornimento dal mercante"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"Segnala gli ordini di rifornimento in sospeso quando chiudi la finestra del mercante. Resta in silenzio se non ce ne sono."
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "Attiva i promemoria di rifornimento in banca"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"Segnala gli ordini di rifornimento in sospeso quando chiudi la banca. Resta in silenzio se non ce ne sono."

--[[
    The starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] = "Attiva il generatore di lista quando la lista di rifornimento è vuota"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"Propone una lista di rifornimento iniziale all'accesso ogni volta che quella di questo personaggio è vuota."

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "Semplice"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "Dettagliato"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "Riproduci suono"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] =
	"Riproduce un avviso insieme al promemoria, per quando la chat è affollata."
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "Clicca per ascoltare l'avviso."
L["OPTIONS_RESTOCKER_DEBUG"] = "Attiva i messaggi di debug di Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Stampa in chat le decisioni di rifornimento di Restocker passo per passo (banca e mercante). Prolisso; resta attivo tra le sessioni finché non viene disattivato."

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "Finestra del Rifornimento"
L["OPTIONS_RESTOCKER_ADVANCED_HEADER"] = "Avanzate"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "Ringraziamenti"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"Ho sempre amato Restocker, e sono felice che continui a vivere dentro Connoisseur. Un grazie enorme a ChiliFajita, che ha scritto l'Auto Restocker originale, e a kvakvs e guardycmw, che lo hanno tenuto in vita attraverso Classic e Mists of Pandaria."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di questo add-on."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "Apre la finestra di Restocker per gestire la tua lista di rifornimento."

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "Macro"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur crea una macro per ogni consumabile e la tiene aggiornata mentre le tue borse cambiano, così il pulsante sulla barra punta sempre al miglior oggetto che stai portando. Scegli qui sotto quali macro creare, poi imposta come ciascuna sceglie il suo oggetto."
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Abilita Macro"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Scegli quali macro Connoisseur deve creare e mantenere. Disabilitare una macro la rimuoverà anche."

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback e Supporto"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "Versione"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_PROFILE_EXISTS"] = 'Esiste già un profilo chiamato "%s".'
L["RESTOCKER_BANK_NOT_OPEN"] = "La banca non è aperta."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"Rifornimento completato. Tieni premuto Maiusc mentre apri la banca per saltare il rifornimento. Digita %s per modificare la tua lista di rifornimento."
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
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "Non dimenticare di rifornirti mentre sei in città!"

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
L["RESTOCKER_STILL_SHORT_ONE"] = "1 ordine di rifornimento in sospeso."
L["RESTOCKER_STILL_SHORT_MANY"] = "%d ordini di rifornimento in sospeso."

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, old amount, new link, new amount },
    outgoing tier on the left and incoming on the right.

    Both amounts are carried because they are not always equal: a swap onto a
    tier the list already holds merges the two rows, so the new amount is the
    sum rather than the old amount moved across.
]]
L["RESTOCKER_UPGRADED"] = "La tua lista di rifornimento è stata aggiornata."
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d diventa %sx%d."

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
L["RESTOCKER_RESTOCKED_ONE"] = "1 ordine di rifornimento evaso."
L["RESTOCKER_RESTOCKED_MANY"] = "%d ordini di rifornimento evasi."

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "1 ordine di rifornimento evaso in parte."
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] = "%d ordini di rifornimento evasi in parte."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Mostra la finestra di Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Aggiunge un profilo con quel nome."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Elimina il profilo con quel nome."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Rinomina il profilo attuale con quel nome."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copia quel profilo nel profilo attuale."
L["RESTOCKER_HELP_PROFILE_USE"] = "Passa al profilo con quel nome."

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
	"La tua lista di rifornimento è vuota, quindi aggiungiamo qualche oggetto per iniziare."
L["STARTER_POPUP_INTRO_HOW"] =
	"Tutto ciò che spunti viene rifornito automaticamente ogni volta che apri un mercante o la tua banca, e gli oggetti di uso comune si aggiornano da soli man mano che sali di livello, così avrai sempre il meglio disponibile."
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] =
	"Puoi sempre modificare questa lista, o aggiungere altri oggetti in seguito, digitando %s."
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "Cibo e acqua"
L["STARTER_POPUP_FOOD_HEADER"] = "Cibo"
L["STARTER_POPUP_AMMO_HEADER"] = "Munizioni"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "Proiettili"
L["STARTER_POPUP_ARROWS"] = "Frecce"

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
L["STARTER_POPUP_REAGENTS_HEADER"] = "Componenti e strumenti"
L["STARTER_POPUP_POISONS_HEADER"] = "Veleni"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s : Aggiungi il veleno finito alla tua lista e Connoisseur comprerà automaticamente gli ingredienti da qualsiasi mercante che li venda."
L["STARTER_POPUP_POISON_ANESTHETIC"] = "Anestetico"
L["STARTER_POPUP_POISON_CRIPPLING"] = "Paralizzante"
L["STARTER_POPUP_POISON_DEADLY"] = "Letale"
L["STARTER_POPUP_POISON_INSTANT"] = "Istantaneo"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "Intorpidente"
L["STARTER_POPUP_POISON_WOUND"] = "Ferita"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "Pietra del ritrovo"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "Polvere accecante"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "Polvere lampo"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "Arnesi da scasso"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "Polvere di cadavere"
L["STARTER_POPUP_REAGENT_WILDS"] = "Bacche selvatiche"
L["STARTER_POPUP_REAGENT_SEEDS"] = "Semi"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "Polvere arcana"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "Piuma leggera"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "Rune di teletrasporto"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "Rune dei portali"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "Simbolo divino"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "Simbolo dei re"
L["STARTER_POPUP_REAGENT_CANDLES"] = "Candele"
L["STARTER_POPUP_REAGENT_ANKH"] = "Ankh"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "Scaglie di pesce"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "Olio di pesce"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "Totem di terra"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "Totem di fuoco"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "Totem d'acqua"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "Totem d'aria"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "Statuetta"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "Pietra infernale"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "Frammenti d'anima"
--[[
    Checkbox tooltips: { item link, amount }. The first is for ladder items;
    the second for single-tier reagents, which never upgrade.
]]
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"Aggiunge %s alla tua lista di rifornimento, tenendone %d nelle borse e aggiornandoli man mano che sali di livello."
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] = "Aggiunge %s alla tua lista di rifornimento, mantenendone %d nelle borse."
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 for food, water and poisons, 200 for ammo); the tooltip
    below carries the per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 pila"
L["STARTER_POPUP_STACK_MANY"] = "%d pile"
L["STARTER_POPUP_STACKS_DESCRIPTION"] = "Quante pile tenere di scorta. Qui una pila è %d."
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] =
	"Quanti tenere di scorta. Non si impilano, quindi ognuno occupa uno spazio nelle borse."
L["STARTER_POPUP_DISMISS"] = "Non mostrare più per questo personaggio."
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"Altrimenti questi suggerimenti tornano a ogni accesso che trova vuota la tua lista di rifornimento."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filtra oggetti..."
L["RESTOCKER_ADD_BUTTON"] = "Aggiungi"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Aggiungi un oggetto"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "Trascina un oggetto dalle tue borse o digita un ID oggetto numerico."
-- In-box placeholder for the add row; the tooltip above carries the detail.
L["RESTOCKER_ADD_PLACEHOLDER"] = "Trascina qui un oggetto, o digita il suo ID..."
L["RESTOCKER_PROFILE_LABEL"] = "Profilo:"
L["RESTOCKER_RENAME_LABEL"] = "Rinomina:"
L["RESTOCKER_NEW_PROFILE"] = "Nuovo profilo"
L["RESTOCKER_COPY_PROFILE"] = "Copia"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in RS.SetupTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Clona questo profilo in uno nuovo"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s Copia"
L["RESTOCKER_DELETE_PROFILE"] = "Elimina"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Elimina questo profilo"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"Vuoi davvero eliminare questo profilo?|n|n%s|n|nQuesta azione non può essere annullata."
--[[
    Row controls in the Restocker window. UPGRADE is disabled on any item that
    is not on a ladder in Data/Consumable-Upgrade-Paths.lua, which on a real
    list is most of them.
]]
L["RESTOCKER_UPGRADE_LABEL"] = "Aggiornamento auto"
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "Aggiorna con il tuo livello"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"Cibo, acqua, munizioni e pozioni hanno percorsi di aggiornamento netti man mano che sali di livello, quindi Connoisseur porta avanti questo oggetto per te. Tutto il resto sta a te sistemarlo col tempo."

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "Banca"
L["RESTOCKER_ROW_MERCHANT"] = "Mercante"
L["RESTOCKER_ROW_UPGRADE"] = "Miglioramento"

L["RESTOCKER_GROUP_OTHER"] = "Altro"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "Nuovi"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "Rimuove questo oggetto dalla lista di rifornimento"
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
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (%d%% di sconto)"
L["RESTOCKER_REPUTATION_ANY"] = "Qualsiasi"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Amichevole"
L["RESTOCKER_REPUTATION_HONORED"] = "Onorato"
L["RESTOCKER_REPUTATION_REVERED"] = "Riverito"
L["RESTOCKER_REPUTATION_EXALTED"] = "Osannato"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]
L["RESTOCKER_REPUTATION_BUTTON_FORMAT"] = "Rep.: %s"

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Reputazione richiesta col mercante"
--[[
    Quotes the button's own label. That couples this line to
    RESTOCKER_REPUTATION_BUTTON_FORMAT and RESTOCKER_REPUTATION_ANY -- a locale
    that renders the button differently has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'Scegli un livello di reputazione e Connoisseur salterà i mercanti con cui non lo hai raggiunto. "Rep.: Qualsiasi" compra da qualsiasi mercante.'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"La reputazione abbassa anche il prezzo: Amichevole 5%, Onorato 10%, Riverito 15%, Osannato 20%."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Clicca per cambiare."
