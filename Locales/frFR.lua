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

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

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
	"Vous avez trouvé un bug ! %s (%s) ne peut pas être utilisé à %s > %s (%s). Merci de le signaler pour correction. https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Aucun %s approprié trouvé dans vos sacs."
L["MSG_MACRO_SLOTS_FULL"] =
	"Certaines macros Connoisseur n'ont pas pu être créées car vos emplacements de macros sont pleins. Libérez un emplacement en supprimant les macros que vous n'utilisez plus, ou désactivez les macros Connoisseur dont vous n'avez pas besoin dans Options > AddOns > Connoisseur."

L["CHAT_LOADED"] =
	"Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent dans Options > AddOns > Connoisseur. Vous aimez l'addon ? Parlez-en à un ami ! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "Vous n'avez actuellement aucune nourriture utile pour votre familier."
L["TIP_PET_NO_SKILLS"] =
	"Vous ne connaissez actuellement pas Nourrir le familier, Guérison du familier ou Ressusciter le familier."
L["TIP_PET_NO_MEND"] = "Vous ne connaissez actuellement pas Guérison du familier."
L["TIP_NO_HAND_POISON"] = "Vous n'avez plus le poison choisi pour cette arme."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Vous ne connaissez actuellement pas %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["MENU_BUFF_FOOD_DESCRIPTION"] =
	'Priorise la nourriture conférant l\'amélioration "Bien nourri" si elle est absente.'
L["MENU_SCROLL_BUFFS"] = "Améliorations de parchemins"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Transforme votre macro Nourriture en applicateur de parchemins lorsqu'il vous manque des améliorations de parchemins."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Nourriture"
L["UI_BEST_PET_FOOD"] = "Nourriture pour familier"
L["UI_IGNORE_LIST"] = "Liste d'exclusion"
L["MENU_IGNORE"] = "Ignorer"
L["MENU_CLEAR_IGNORE"] = "Vider la liste d'exclusion"

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

L["TIP_DOWNRANK"] = "Cibler un joueur de bas niveau adaptera le rang des objets créés par la macro."
L["TIP_HUNTER_FEED_PET"] =
	"Nourrir le familier est un bouton tout-en-un ! Cliquez pour appeler, nourrir ou ressusciter automatiquement votre familier. Faites un clic droit ou utilisez-le en combat pour lancer Guérison du familier. Maintenez Maj pour forcer la Résurrection, ou Ctrl pour le Renvoyer."
L["TIP_MAGE_CONJURE"] = "Clic droit sur vos macros Nourriture ou Eau pour en créer."
L["TIP_MAGE_GEM"] =
	"Clic droit sur votre macro Gemme de mana pour en créer une nouvelle. Cliquez à nouveau avec le bouton droit pour créer une gemme de rang inférieur en secours."
L["TIP_MAGE_TABLE"] = "Clic milieu pour lancer Rituel de rafraîchissement."
L["TIP_WARLOCK_CONJURE"] =
	"Clic droit sur vos macros Pierre de soins ou Pierre d'âme pour en créer une. Cliquez à nouveau avec le bouton droit sur votre macro Pierre de soins pour créer une pierre de rang inférieur en secours."
L["TIP_WARLOCK_SOUL"] = "Clic milieu pour lancer Rituel des âmes."
L["TIP_ROGUE_POISONS"] =
	"Clic gauche applique votre poison de main gauche, clic droit celui de main droite. Les poisons existants sont remplacés automatiquement. Clic milieu ouvre la fenêtre Poisons."

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
L["MODE_PARTY"] = "Uniquement en groupe"
L["MODE_RAID"] = "Uniquement en raid"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Des macros à mise à jour automatique pour votre meilleure nourriture, nourriture avec amélioration, eau, parchemins, potions de soins et de mana, pierres de soins, pierres d'âme, gemmes de mana et bandages. Invocation en un clic pour les Mages et Démonistes, Nourrir le familier intelligent pour les Chasseurs. Nutrition optimale, performances maximales."

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
L["OPTIONS_REAPPLY_THRESHOLD"] = "Considérer comme expirée quand"
L["REAPPLY_THRESHOLD_ONE"] = "< 1 minute restante"
L["REAPPLY_THRESHOLD_N"] = "< %d minutes restantes"

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "Nourriture à amélioration"
L["OPTIONS_BUFF_FOOD"] = "Priorité : Bien nourri"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'Priorise la nourriture conférant l\'amélioration "Bien nourri" si elle est absente.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Astuce de pro : Vous cibler vous-même forcera toujours la macro Nourriture à ignorer la nourriture avec amélioration et les parchemins."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Améliorations de parchemins"
L["OPTIONS_USE_SCROLLS"] = "Incluir les parchemins"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Transforme votre macro Nourriture en applicateur de parchemins dédié lorsqu'il vous manque des améliorations de parchemins. Appuyez une fois pour appliquer les parchemins ; appuyez à nouveau pour manger. Les parchemins sont hors du GCD, vous ciblent, et la macro redevient de la nourriture dès que vous ciblez un autre joueur amical."
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
L["EXPLOSIVES_MODE_ATPLAYER"] = "Clic Gauche @Player, Clic Droit Lancer"
L["EXPLOSIVES_MODE_TOSS"] = "Clic Gauche Lancer, Clic Droit @Player"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Améliorations de nourriture pour familier"
L["OPTIONS_USE_PET_BUFFS"] = "Utiliser les améliorations de nourriture pour familier"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	"Utilise de la nourriture pour familier dans votre macro Nourriture lorsque votre familier n'a pas l'amélioration \"Bien nourri\"."
L["OPTIONS_PET_BUFF_TYPES"] = "Inclure les types de nourriture pour familier à vérifier"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Morceaux de Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Casse-croûte sporélin"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druides"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Activer l'intégration de DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Crée des macros de powershifting pour les potions de soins, les potions de mana et les pierres de soins à l'aide de DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Après le consommable, passer en"
L["DRUID_FORM_BEAR"] = "Ours"
L["DRUID_FORM_CAT"] = "Chat"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfes de la nuit"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Boire avec Camouflage dans l'ombre"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] =
	"Ajoute Camouflage dans l'ombre à votre macro d'Eau pour vous camoufler pendant que vous buvez."

-- Rogues
L["OPTIONS_POISONS_HEADER"] = "Poisons"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Garde la macro Poisons chargée avec le meilleur rang utilisable de chaque type de poison. Clic gauche pour la main gauche, clic droit pour la main droite ; les poisons existants sont remplacés automatiquement."
L["OPTIONS_POISON_MAIN_HAND"] = "Main droite"
L["OPTIONS_POISON_OFF_HAND"] = "Main gauche"

-- Restocker
L["OPTIONS_RESTOCKER_HEADER"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Garde vos sacs approvisionnés selon une liste de réapprovisionnement par personnage. Achète automatiquement chez les marchands et déplace les objets entre les sacs et la banque. Tapez /crs pour ouvrir la liste."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Ouvrir à la banque"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Ouvre la fenêtre de Restocker lors d'une visite à la banque."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Ouvrir chez le marchand"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Ouvre la fenêtre de Restocker lors d'une visite chez un marchand."
L["OPTIONS_RESTOCKER_DEBUG"] = "Activer les messages de débogage de Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Affiche dans le chat les décisions de réapprovisionnement de Restocker, étape par étape (banque et marchand). Verbeux ; reste actif d'une session à l'autre jusqu'à désactivation."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_FOODIE"] = "/foodie"
L["OPTIONS_COMMANDS_FOODIE_DETAIL"] = "Ouvre l'interface des options de Connoisseur."
L["OPTIONS_COMMANDS_CRS"] = "/crs"
L["OPTIONS_COMMANDS_CRS_DETAIL"] = "Ouvre la fenêtre Restocker pour gérer votre liste de réapprovisionnement."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Activer les macros"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Permet d'activer ou de désactiver les macros créées et gérées par Connoisseur. La désactivation d'une macro la supprimera également."

-- Ignore List
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "Retire tous les objets de la liste d'exclusion."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Voulez-vous vraiment vider la liste d'exclusion ?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Commentaires et Assistance"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "Vos listes Restocker ont été importées."
L["RESTOCKER_PROFILE_EXISTS"] = 'Un profil nommé "%s" existe déjà.'
L["RESTOCKER_BANK_NOT_OPEN"] = "La banque n'est pas ouverte."
-- %s is the /crs slash command, colored at the call site.
L["RESTOCKER_COMPLETE"] =
	"Réapprovisionnement terminé. Maintenez Maj pour l'ignorer la prochaine fois. Tapez %s pour modifier votre liste de réapprovisionnement."
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
L["RESTOCKER_FINISHED_RESTOCKING"] = "Réapprovisionnement effectué (%d achats réalisés)."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Affiche la fenêtre Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Ajoute un profil portant ce nom."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Supprime le profil portant ce nom."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Renomme le profil actuel avec ce nom."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copie ce profil dans le profil actuel."
L["RESTOCKER_HELP_PROFILE_USE"] = "Active le profil portant ce nom."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filtrer les objets..."
L["RESTOCKER_ADD_BUTTON"] = "Ajouter"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Ajouter un objet"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "Déposez un objet depuis vos sacs, ou saisissez un ID d'objet numérique."
L["RESTOCKER_PROFILE_LABEL"] = "Profil :"
L["RESTOCKER_RENAME_LABEL"] = "Renommer :"
L["RESTOCKER_NEW_PROFILE"] = "Nouveau profil"
L["RESTOCKER_GROUP_OTHER"] = "Autre"
L["RESTOCKER_REMOVE_TOOLTIP"] = "Retire cet objet de la liste de réapprovisionnement."
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
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (%d%% de remise)"
L["RESTOCKER_REPUTATION_ANY"] = "Aucune"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Amical"
L["RESTOCKER_REPUTATION_HONORED"] = "Honoré"
L["RESTOCKER_REPUTATION_REVERED"] = "Révéré"
L["RESTOCKER_REPUTATION_EXALTED"] = "Exalté"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Réputation requise auprès du marchand"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	"N'achète qu'auprès d'un marchand dont vous avez au moins ce niveau de réputation."
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Une meilleure réputation signifie aussi des prix plus bas (Amical 5%, Honoré 10%, Révéré 15%, Exalté 20%)."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Cliquez pour choisir un niveau de réputation"
