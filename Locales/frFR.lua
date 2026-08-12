local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "frFR")
if not L then
	return
end

-- [[ FRENCH (frFR) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Bandage"
L["MACRO_EXPLOSIVES"] = "- Explosifs"
L["MACRO_FEED_PET"] = "- Nourrir fam."
L["MACRO_FOOD"] = "- Manger"
L["MACRO_HEALTH_POTION"] = "- Pot. Soins"
L["MACRO_HEALTHSTONE"] = "- Pierre"
L["MACRO_MANA_GEM"] = "- Gemme de mana"
L["MACRO_MANA_POTION"] = "- Pot. Mana"
L["MACRO_POISONS"] = "- Poisons"
L["MACRO_SOULSTONE"] = "- Pierre d'âme"
L["MACRO_WATER"] = "- Boire"

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

L["DIET_BREAD"] = "Pain"
L["DIET_CHEESE"] = "Fromage"
L["DIET_FISH"] = "Poisson"
L["DIET_FRUIT"] = "Fruit"
L["DIET_FUNGUS"] = "Champignon"
L["DIET_MEAT"] = "Viande"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] =
	"Vous avez trouvé un bug ! %s (%s) ne peut pas être utilisé à %s > %s (%s). Merci de le signaler pour correction. %s"
L["MSG_NO_ITEM"] = "Aucun %s approprié trouvé dans vos sacs."
L["MSG_MACRO_SLOTS_FULL"] =
	"Certaines macros Connoisseur n'ont pas pu être créées car vos emplacements de macros sont pleins. Libérez un emplacement en supprimant les macros que vous n'utilisez plus, ou désactivez les macros Connoisseur dont vous n'avez pas besoin dans Options > AddOns > Connoisseur."

L["CHAT_LOADED"] =
	"Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent dans Options > AddOns > Connoisseur. Vous aimez l'addon ? Parlez-en à un ami ! (="

L["CHAT_OPTIONS_IN_COMBAT"] = "Par mesure de sécurité, l'interface des options ne peut pas être ouverte en combat."

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "Prêt !"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "Manquant : %s"

L["READY_WELL_FED"] = "Bien nourri"
L["READY_SCROLLS"] = "Parchemins"
L["READY_PET_FED"] = "Familier nourri"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d min"
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s moins d'1 min"

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "Vous n'avez actuellement aucune nourriture utile pour votre familier."
L["TIP_PET_NO_SKILLS"] =
	"Vous ne connaissez actuellement pas Appeler le familier, Renvoyer le familier, Nourrir le familier ou Ressusciter le familier."
L["TIP_PET_NO_MEND"] = "Vous ne connaissez actuellement pas Guérison du familier."
L["TIP_NO_HAND_POISON"] = "Vous n'avez plus le poison choisi pour cette arme."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Vous ne connaissez actuellement pas %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "Nourriture à amélioration"
L["MENU_BUFF_FOOD_DESCRIPTION"] =
	'Priorise la nourriture conférant l\'amélioration "Bien nourri" si elle est absente.'
L["FEATURE_SCROLL_BUFFS"] = "Améliorations de parchemins"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Transforme votre macro Nourriture en applicateur de parchemins lorsqu'il vous manque des améliorations de parchemins."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Nourriture actuelle"
L["UI_BEST_PET_FOOD"] = "Nourriture actuelle du familier"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "Main droite"
L["UI_OFF_HAND"] = "Main gauche"
L["UI_IGNORE_LIST"] = "Liste d'exclusion"
L["MENU_IGNORE"] = "Ignorer"
L["MENU_CLEAR_IGNORE"] = "Vider la liste d'exclusion"

--[[
    Restocker Report block in the minimap tooltip: how many restocking orders
    are still outstanding, never the items themselves. An order is one row of
    the Restock List, so the count is of rows below target and not of missing
    units -- nine outstanding orders can be nine single juices or nine full
    stacks. The header above supplies the "restocking", so the lines under it
    only need the noun.

    Separate singular and plural strings rather than a composed "%d order(s)",
    so every locale can phrase the count its own way.
]]
L["UI_RESTOCKER_REPORT"] = "Rapport de réapprovisionnement"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 commande en attente"
L["UI_RESTOCKER_NEEDED"] = "%d commandes en attente"
L["UI_RESTOCKER_STOCKED"] = "Félicitations, vos réserves sont au complet !"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Options de Connoisseur"
L["MENU_OPTIONS_KEYBIND"] = "Maj + Clic Milieu"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

L["PREFIX_HUNTER"] = "Attention Chasseurs"
L["PREFIX_MAGE"] = "Attention Mages"
L["PREFIX_ROGUE"] = "Attention Voleurs"
L["PREFIX_WARLOCK"] = "Attention Démonistes"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to — the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "À propos de votre macro Nourrir le familier..."
L["TIP_MAGE_MACROS"] = "À propos de vos macros Nourriture, Eau et Gemme de mana..."
L["TIP_ROGUE_MACROS"] = "À propos de votre macro Poisons..."
L["TIP_WARLOCK_MACROS"] = "À propos de vos macros Pierre de soins et Pierre d'âme..."

L["TIP_HUNTER_ALL_IN_ONE"] = "Nourrir le familier est un bouton tout-en-un !"
L["TIP_HUNTER_CALL"] = "Clic gauche pour appeler, nourrir ou ressusciter automatiquement votre familier."
L["TIP_HUNTER_MEND"] = "Clic droit ou attendez le combat pour lancer Guérison du familier."
L["TIP_HUNTER_MODIFIERS"] = "Maintenez Maj pour forcer la Résurrection, ou Ctrl pour le Renvoyer."

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "Clic droit sur vos macros Nourriture ou Eau pour en créer."
L["TIP_MAGE_DOWNRANK"] =
	"Cibler un joueur de niveau inférieur créera de la nourriture ou de l'eau adaptée à son niveau."
L["TIP_MAGE_TABLE"] = "Clic milieu sur vos macros Nourriture ou Eau pour lancer Rituel de rafraîchissement."
L["TIP_MAGE_GEM"] =
	"Clic droit sur votre macro Gemme de mana pour en créer une nouvelle. Cliquez à nouveau avec le bouton droit pour créer une gemme de rang inférieur en secours."

L["TIP_WARLOCK_HEALTHSTONE"] =
	"Clic droit sur votre macro Pierre de soins pour créer une Pierre de soins. Cliquez à nouveau avec le bouton droit pour créer une pierre de rang inférieur en secours."
L["TIP_WARLOCK_DOWNRANK"] = "Cibler un joueur de niveau inférieur créera une Pierre de soins adaptée à son niveau."
L["TIP_WARLOCK_SOULSTONE"] = "Clic droit sur votre macro Pierre d'âme pour créer une Pierre d'âme."
L["TIP_WARLOCK_SOUL"] = "Clic milieu sur votre macro Pierre de soins pour lancer Rituel des âmes."

L["TIP_ROGUE_OFF_HAND"] = "Clic gauche applique votre poison de main gauche."
L["TIP_ROGUE_MAIN_HAND"] = "Clic droit applique votre poison de main droite."
L["TIP_ROGUE_REPLACE"] = "Les poisons existants sont remplacés automatiquement."
L["TIP_ROGUE_WINDOW"] = "Clic milieu ouvre la fenêtre Poisons."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

L["LABEL_BANDAGE"] = "Bandage"
L["LABEL_EXPLOSIVE"] = "Explosif"
L["LABEL_FOOD"] = "Nourriture"
L["LABEL_HEALTH_POTION"] = "Potion de soins"
L["LABEL_HEALTHSTONE"] = "Pierre de soins"
L["LABEL_MANA_GEM"] = "Gemme de mana"
L["LABEL_MANA_POTION"] = "Potion de mana"
L["LABEL_PET_FOOD"] = "Nourriture pour familier"
L["LABEL_POISONS"] = "Poison"
L["LABEL_SOULSTONE"] = "Pierre d'âme"
L["LABEL_WATER"] = "Eau"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the minimap tooltip and options panel.

L["UI_ENABLED"] = "Activé"
L["UI_DISABLED"] = "Désactivé"
L["UI_TOGGLE"] = "Basculer"
L["UI_LEFT_CLICK"] = "Clic Gauche"
L["UI_RIGHT_CLICK"] = "Clic Droit"
L["UI_MIDDLE_CLICK"] = "Clic Milieu"
L["UI_SHIFT_LEFT"] = "Maj + Clic Gauche"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Toujours"
L["MODE_PARTY"] = "Uniquement en groupe ou en raid"
L["MODE_RAID"] = "Uniquement en raid"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Des macros à mise à jour automatique pour votre meilleure nourriture, nourriture avec amélioration, eau, potions, pierres de soins, parchemins, pierres d'âme, bandages, poisons et explosifs. Invocation en un clic, Nourrir le familier intelligent, réapprovisionnement automatique chez le marchand et à la banque. Nutrition optimale, performances maximales."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Activer le message de bienvenue"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Affiche un message de bienvenue dans le chat lors de la connexion."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Activer le bouton de la minicarte"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Affiche le bouton de la minicarte."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Activer les noms de macro sur les boutons"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Affiche le texte du nom de macro sur les boutons de votre barre d'action. Désactivé par défaut, ce qui masque les noms que Blizzard a récemment recommencé à afficher."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Potions et Pierres de soins"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"Les macros ne peuvent pas être modifiées en combat (c'est une restriction de Blizzard), chaque macro de Potion et de Pierre de soins est donc pré-générée avec votre meilleur objet ainsi que deux options de secours. Lors de longs combats, l'icône et l'infobulle peuvent devenir obsolètes et afficher le mauvais objet, mais cliquer sur la macro utilisera toujours le meilleur objet que vous possédez réellement dans vos sacs."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "Combiner les Pierres de soins dans la macro de Potion de soins"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"Ajoute votre meilleure Pierre de soins à la fin de la macro de Potion de soins, de sorte qu'une seule pression utilise une potion et une Pierre de soins."

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "Renouvellement des améliorations"
L["OPTIONS_REAPPLY"] = "Renouveler les améliorations expirantes"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"Les combats durent souvent plus longtemps que vos améliorations. Les améliorations dont le temps restant est inférieur au seuil sont considérées comme expirées, afin que vos macros en proposent une nouvelle avant le combat. S'applique à Nourriture à amélioration, Améliorations de parchemins et Améliorations de nourriture pour familier."
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "Quand il reste < 1 minute"
L["REAPPLY_THRESHOLD_N"] = "Quand il reste < %d minutes"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "Vérification de préparation"
L["OPTIONS_READY_CHECK"] = "Signaler l'état lors d'une vérification de préparation"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"Affiche ce qu'il vous manque et le temps restant sur vos améliorations suivies à chaque vérification de préparation ; vous seul pouvez le voir."

-- Buff Food. The section header reuses FEATURE_BUFF_FOOD.
L["OPTIONS_BUFF_FOOD"] = "Priorité : Bien nourri"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'Priorise la nourriture conférant l\'amélioration "Bien nourri" si elle est absente. Désactivé en arène.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Astuce de pro : Vous cibler vous-même forcera toujours la macro Nourriture à ignorer la nourriture avec amélioration et les parchemins."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "Inclure les parchemins"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Appuyez une fois pour appliquer les parchemins manquants, à nouveau pour manger. Les parchemins sont hors du GCD et vous ciblent ; cibler un joueur amical les ignore. Désactivé en arène."
L["OPTIONS_SCROLL_TYPES"] = "Types de parchemins à vérifier"
L["OPTIONS_SCROLL_AGILITY"] = "Agilité"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelligence"
L["OPTIONS_SCROLL_PROTECTION"] = "Protection"
L["OPTIONS_SCROLL_SPIRIT"] = "Esprit"
L["OPTIONS_SCROLL_STAMINA"] = "Endurance"
L["OPTIONS_SCROLL_STRENGTH"] = "Force"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "Explosifs"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"L'option @player ignore le réticule de ciblage et déclenche l'explosif à vos pieds. Idéal quand votre cible est au corps à corps."
L["EXPLOSIVES_MODE_ATPLAYER"] = "Clic Gauche @player, Clic Droit Lancer"
L["EXPLOSIVES_MODE_TOSS"] = "Clic Gauche Lancer, Clic Droit @player"

--[[
    Ignore List. The rows are items, so the only copy here is the add box and
    the placeholder shown while the client is still resolving an item's name.
    The section header and the clear-all button reuse UI_IGNORE_LIST and
    MENU_CLEAR_IGNORE, which the mini-map tooltip already carries.
]]
L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Objets que Connoisseur ne choisira jamais, aussi bons soient-ils. Faites un Clic Droit sur le bouton de la minicarte pour ignorer la nourriture qu'il propose sur le moment, ou ajoutez un objet ci-dessous."
L["OPTIONS_IGNORE_ADD_ID"] = "Ajouter par ID d'objet"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Saisissez un ID d'objet, ou faites Maj + Clic sur un lien d'objet dans le chat pendant que ce champ est actif."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "Saisissez un ID d'objet, ou faites Maj + Clic sur un lien d'objet dans le chat."
L["OPTIONS_IGNORE_REMOVE"] = "Retirer"
L["OPTIONS_IGNORE_EMPTY"] = "Cette liste est vide."
L["OPTIONS_IGNORE_CLEAR_CONFIRM"] = "Retirer tous les objets de votre liste d'exclusion ?"
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "Chargement de l'ID : %d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Améliorations de nourriture pour familier"
L["OPTIONS_USE_PET_BUFFS"] = "Utiliser les améliorations de nourriture pour familier"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	"Ajoute de la nourriture pour familier à votre macro Nourriture lorsque votre familier n'a pas l'amélioration \"Bien nourri\". Désactivé en arène."
L["OPTIONS_PET_BUFF_TYPES"] = "Inclure les types de nourriture pour familier à vérifier"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Morceaux de Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Casse-croûte sporélin"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druides"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Activer l'intégration de DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Crée des macros de powershifting pour les potions de soins, les potions de mana et les pierres de soins à l'aide de DruidMacroHelper (/dmh)."
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "Retour en Ours"
L["DRUID_FORM_CAT"] = "Retour en Chat"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfes de la nuit"
L["OPTIONS_STEALTH_DRINKING"] = "Activer le camouflage en buvant"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] =
	"Ajoute Camouflage dans l'ombre à votre macro d'Eau pour vous camoufler pendant que vous buvez."
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	"Ajoute Camouflage dans l'ombre à votre macro Nourriture pour vous camoufler pendant que vous mangez."
L["OPTIONS_STEALTH_PICK_ONE"] =
	"Astuce de pro : Choisissez-en un. Vous pouvez manger et boire en même temps, mais manger ou boire après vous être camouflé rompra le camouflage."

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "Voleurs"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Garde la macro Poisons chargée avec le meilleur rang utilisable de chaque type de poison. Clic gauche pour la main gauche, clic droit pour la main droite ; les poisons existants sont remplacés automatiquement."
L["OPTIONS_POISON_MAIN_HAND"] = "Type de poison de main droite"
L["OPTIONS_POISON_OFF_HAND"] = "Type de poison de main gauche"
L["OPTIONS_STEALTH_EATING"] = "Activer le camouflage en mangeant"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] =
	"Ajoute Camouflage à votre macro Nourriture pour vous camoufler pendant que vous mangez."

-- Restocker options panel. The tree label stays "Restocker" in every locale
-- (brand fragment, localization allowlist); the panel header reuses
-- RESTOCKER_WINDOW_TITLE.
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Garde vos sacs approvisionnés selon une liste de réapprovisionnement par personnage. Achète automatiquement chez les marchands et déplace les objets entre les sacs et la banque. Tapez %s pour ouvrir la liste."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Ouvrir à la banque"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Ouvre la fenêtre de Restocker lors d'une visite à la banque."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Ouvrir chez le marchand"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Ouvre la fenêtre de Restocker lors d'une visite chez un marchand."
L["OPTIONS_RESTOCKER_REMIND"] = "Activer les rappels de réapprovisionnement en ville"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"Affiche un rappel dans le chat quand il manque quelque chose à votre liste de réapprovisionnement et que vous arrivez dans une auberge ou une ville, ou que vous vous y trouvez déjà à la connexion."
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "Activer les rappels de réapprovisionnement chez le marchand"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"Signale les commandes de réapprovisionnement en attente quand vous fermez une fenêtre de marchand. Reste silencieux s'il n'y en a aucune."
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "Activer les rappels de réapprovisionnement à la banque"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"Signale les commandes de réapprovisionnement en attente quand vous fermez la banque. Reste silencieux s'il n'y en a aucune."

--[[
    The starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] = "Activer l'assistant de liste quand la liste de réapprovisionnement est vide"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"Propose une liste de réapprovisionnement de départ à la connexion dès que celle de ce personnage est vide."

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "Simple"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "Détaillé"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "Jouer un son"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] =
	"Joue une alerte en même temps que le rappel, pour quand le chat est chargé."
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "Cliquez pour écouter l'alerte."
L["OPTIONS_RESTOCKER_DEBUG"] = "Activer les messages de débogage de Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Affiche dans le chat les décisions de réapprovisionnement de Restocker, étape par étape (banque et marchand). Verbeux ; reste actif d'une session à l'autre jusqu'à désactivation."

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "Fenêtre de réapprovisionnement"
L["OPTIONS_RESTOCKER_ADVANCED_HEADER"] = "Avancé"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "Remerciements"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"J'ai toujours adoré Restocker, et je suis ravi qu'il continue de vivre au sein de Connoisseur. Un immense merci à ChiliFajita, qui a écrit l'Auto Restocker d'origine, ainsi qu'à kvakvs et guardycmw, qui l'ont fait vivre à travers Classic et Mists of Pandaria."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Ouvre l'interface des options de cet add-on."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "Ouvre la fenêtre Restocker pour gérer votre liste de réapprovisionnement."

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "Macros"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur crée une macro par consommable et la tient à jour au fil des changements dans vos sacs, pour que le bouton de votre barre attrape toujours le meilleur objet que vous transportez. Choisissez ci-dessous les macros à créer, puis réglez la façon dont chacune choisit son objet."
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Activer les macros"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Permet d'activer ou de désactiver les macros créées et gérées par Connoisseur. La désactivation d'une macro la supprimera également."

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "Commentaires et Assistance"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "Version"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "Vos listes Restocker ont été importées."
L["RESTOCKER_PROFILE_EXISTS"] = 'Un profil nommé "%s" existe déjà.'
L["RESTOCKER_BANK_NOT_OPEN"] = "La banque n'est pas ouverte."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"Réapprovisionnement terminé. Maintenez Maj en ouvrant la banque pour ignorer le réapprovisionnement. Tapez %s pour modifier votre liste de réapprovisionnement."
L["RESTOCKER_STOPPED_BOTH_FULL"] = "Réapprovisionnement arrêté. Vos sacs et votre banque sont pleins."
L["RESTOCKER_STOPPED_BANK_FULL"] =
	"Réapprovisionnement arrêté. Votre banque est pleine ; libérez un emplacement et rouvrez-la."
L["RESTOCKER_STOPPED_BAG_FULL"] =
	"Réapprovisionnement arrêté. Vos sacs sont pleins ; libérez un emplacement et rouvrez la banque."
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "Réapprovisionnement arrêté. Aucun progrès possible."
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] = "Réapprovisionnement arrêté. Impossible de déplacer : %s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (en trop)"
L["RESTOCKER_STOPPED_ERROR"] = "Réapprovisionnement arrêté à cause d'une erreur : %s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] = "Vos sacs sont pleins. Réapprovisionnement chez le marchand ignoré."
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "N'oubliez pas de vous réapprovisionner pendant que vous êtes en ville !"

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
L["RESTOCKER_STILL_SHORT_ONE"] = "1 commande de réapprovisionnement en attente."
L["RESTOCKER_STILL_SHORT_MANY"] = "%d commandes de réapprovisionnement en attente."

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, old amount, new link, new amount },
    outgoing tier on the left and incoming on the right.

    Both amounts are carried because they are not always equal: a swap onto a
    tier the list already holds merges the two rows, so the new amount is the
    sum rather than the old amount moved across.
]]
L["RESTOCKER_UPGRADED"] = "Votre liste de réapprovisionnement a été mise à niveau."
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d devient %sx%d."

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
L["RESTOCKER_RESTOCKED_ONE"] = "1 commande de réapprovisionnement honorée."
L["RESTOCKER_RESTOCKED_MANY"] = "%d commandes de réapprovisionnement honorées."

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "1 commande de réapprovisionnement partiellement honorée."
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] = "%d commandes de réapprovisionnement partiellement honorées."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Affiche la fenêtre Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Ajoute un profil portant ce nom."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Supprime le profil portant ce nom."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Renomme le profil actuel avec ce nom."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copie ce profil dans le profil actuel."
L["RESTOCKER_HELP_PROFILE_USE"] = "Active le profil portant ce nom."

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
	"Votre liste de réapprovisionnement est vide, alors ajoutons quelques objets pour bien démarrer."
L["STARTER_POPUP_INTRO_HOW"] =
	"Tout ce que vous cochez est réapprovisionné automatiquement dès que vous ouvrez un marchand ou votre banque, et les articles courants montent en gamme tout seuls à mesure que vous gagnez des niveaux, pour que vous ayez toujours le meilleur disponible."
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] =
	"Vous pouvez à tout moment ajuster cette liste, ou ajouter d'autres objets plus tard, en tapant %s."
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "Nourriture et eau"
L["STARTER_POPUP_FOOD_HEADER"] = "Nourriture"
L["STARTER_POPUP_AMMO_HEADER"] = "Munitions"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "Balles"
L["STARTER_POPUP_ARROWS"] = "Flèches"

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
L["STARTER_POPUP_REAGENTS_HEADER"] = "Composants et outils"
L["STARTER_POPUP_POISONS_HEADER"] = "Poisons"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s : Ajoutez le poison fini à votre liste, et Connoisseur achètera automatiquement les ingrédients chez tout marchand qui les vend."
L["STARTER_POPUP_POISON_ANESTHETIC"] = "Anesthésiant"
L["STARTER_POPUP_POISON_CRIPPLING"] = "Paralysant"
L["STARTER_POPUP_POISON_DEADLY"] = "Mortel"
L["STARTER_POPUP_POISON_INSTANT"] = "Instantané"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "Engourdissant"
L["STARTER_POPUP_POISON_WOUND"] = "Blessure"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "Pierre de foyer"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "Poudre aveuglante"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "Poudre éclair"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "Outils de voleur"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "Poussière de cadavre"
L["STARTER_POPUP_REAGENT_WILDS"] = "Baies sauvages"
L["STARTER_POPUP_REAGENT_SEEDS"] = "Graines"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "Poudre arcanique"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "Plume légère"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "Runes de téléportation"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "Runes de portail"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "Symbole divin"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "Symbole des rois"
L["STARTER_POPUP_REAGENT_CANDLES"] = "Bougies"
L["STARTER_POPUP_REAGENT_ANKH"] = "Ankh"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "Écailles de poisson"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "Huile de poisson"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "Totem de terre"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "Totem de feu"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "Totem d'eau"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "Totem d'air"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "Figurine"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "Pierre infernale"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "Fragments d'âme"
-- Checkbox tooltips: { item link, amount }. The first is for ladder items;
-- the second for single-tier reagents, which never upgrade.
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"Ajoute %s à votre liste de réapprovisionnement, en gardant %d dans vos sacs et en les améliorant à mesure que vous montez en niveau."
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] =
	"Ajoute %s à votre liste de réapprovisionnement et garde %d dans vos sacs."
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 for food, water and poisons, 200 for ammo); the tooltip
    below carries the per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 pile"
L["STARTER_POPUP_STACK_MANY"] = "%d piles"
L["STARTER_POPUP_STACKS_DESCRIPTION"] = "Combien de piles garder en réserve. Ici, une pile vaut %d."
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] =
	"Combien en garder en réserve. Ils ne s'empilent pas, chacun occupe donc un emplacement de sac."
L["STARTER_POPUP_DISMISS"] = "Ne plus afficher pour ce personnage."
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"Sinon, ces suggestions reviennent à chaque connexion qui trouve votre liste de réapprovisionnement vide."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filtrer les objets..."
L["RESTOCKER_ADD_BUTTON"] = "Ajouter"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Ajouter un objet"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "Déposez un objet depuis vos sacs, ou saisissez un ID d'objet numérique."
-- In-box placeholder for the add row; the tooltip above carries the detail.
L["RESTOCKER_ADD_PLACEHOLDER"] = "Déposez un objet ici, ou saisissez son ID..."
L["RESTOCKER_PROFILE_LABEL"] = "Profil :"
L["RESTOCKER_RENAME_LABEL"] = "Renommer :"
L["RESTOCKER_NEW_PROFILE"] = "Nouveau profil"
L["RESTOCKER_COPY_PROFILE"] = "Copier"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in RS.SetupTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Clone ce profil dans un nouveau"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s Copie"
L["RESTOCKER_DELETE_PROFILE"] = "Supprimer"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Supprime ce profil"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"Voulez-vous vraiment supprimer ce profil ?|n|n%s|n|nCette action est irréversible."
--[[
    Row controls in the Restocker window. UPGRADE is disabled on any item that
    is not on a ladder in Data/Consumable-Upgrade-Paths.lua, which on a real
    list is most of them.
]]
L["RESTOCKER_UPGRADE_LABEL"] = "Amélioration auto"
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "Améliorer avec votre niveau"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"La nourriture, l'eau, les munitions et les potions ont des paliers d'amélioration nets à mesure que vous montez en niveau, alors Connoisseur fait progresser cet objet pour vous. Tout le reste vous appartient et s'ajuste avec le temps."

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "Banque"
L["RESTOCKER_ROW_MERCHANT"] = "Marchand"
L["RESTOCKER_ROW_UPGRADE"] = "Amélioration"

L["RESTOCKER_GROUP_OTHER"] = "Autre"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "Nouveaux"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "Retire cet objet de la liste de réapprovisionnement"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "Quantité à maintenir"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "Appuyez sur Entrée quand vous avez terminé."
L["RESTOCKER_BUY_LABEL"] = "Acheter"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "Acheter chez le marchand"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "Achète la quantité nécessaire quand la fenêtre du marchand est ouverte."
L["RESTOCKER_DEPOSIT_LABEL"] = "Déposer"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "Déposer à la banque"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] = "Range les objets en trop à la banque quand elle est ouverte. 0 range tout."
L["RESTOCKER_WITHDRAW_LABEL"] = "Retirer"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "Réapprovisionner depuis la banque"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "Prend les objets nécessaires dans la banque quand elle est ouverte."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "Réputation requise"
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (%d%% de remise)"
L["RESTOCKER_REPUTATION_ANY"] = "Aucune"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Amical"
L["RESTOCKER_REPUTATION_HONORED"] = "Honoré"
L["RESTOCKER_REPUTATION_REVERED"] = "Révéré"
L["RESTOCKER_REPUTATION_EXALTED"] = "Exalté"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]
L["RESTOCKER_REPUTATION_BUTTON_FORMAT"] = "Répu. : %s"

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Réputation requise auprès du marchand"
--[[
    Quotes the button's own label. That couples this line to
    RESTOCKER_REPUTATION_BUTTON_FORMAT and RESTOCKER_REPUTATION_ANY -- a locale
    that renders the button differently has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	"Choisissez un niveau de réputation et Connoisseur ignorera les marchands avec lesquels vous ne l'avez pas atteint. \"Répu. : Aucune\" achète chez n'importe quel marchand."
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"La réputation réduit aussi le prix : Amical 5 %, Honoré 10 %, Révéré 15 %, Exalté 20 %."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Cliquez pour changer."
