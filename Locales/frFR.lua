local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "frFR")
if not L then return end

-- [[ FRENCH (frFR) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["BRAND"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Bandage"
L["MACRO_FEED_PET"] = "- Nourrir fam."
L["MACRO_FOOD"] = "- Manger"
L["MACRO_HEALTH_POTION"] = "- Pot. Soins"
L["MACRO_HEALTHSTONE"] = "- Pierre"
L["MACRO_MANA_GEM"] = "- Gemme de mana"
L["MACRO_MANA_POTION"] = "- Pot. Mana"
L["MACRO_SOULSTONE"] = "- Pierre d'âme"
L["MACRO_WATER"] = "- Boire"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "Rang"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] = "Vous avez trouvé un bug ! %s (%s) ne peut pas être utilisé à %s > %s (%s). Merci de le signaler pour correction. https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Aucun %s approprié trouvé dans vos sacs."

L["CHAT_LOADED"] = "Version @project-version@. Les paramètres (y compris l'option pour désactiver ce message) se trouvent dans Options > AddOns > Connoisseur. Vous aimez l'addon ? Parlez-en à un ami ! (="

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "Priorité : Bien nourri"
L["MENU_BUFF_FOOD_DESC"] = "Priorise la nourriture conférant l'amélioration \"Bien nourri\" si elle est absente."
L["MENU_CLEAR_IGNORE"] = "Vider la liste d'exclusion"
L["MENU_IGNORE"] = "Ignorer"

L["MENU_SCROLL_BUFFS"] = "Améliorations de parchemins"
L["MENU_SCROLL_BUFFS_DESC"] = "Transforme votre macro Nourriture en applicateur de parchemins lorsqu'il vous manque des améliorations de parchemins."
L["MENU_OPTIONS_HINT"] = "Options supplémentaires disponibles dans Options > AddOns > Connoisseur."

L["PREFIX_HUNTER"] = "Attention Chasseurs"
L["PREFIX_MAGE"] = "Attention Mages"
L["PREFIX_WARLOCK"] = "Attention Démonistes"

L["TIP_DOWNRANK"] = "Cibler un joueur de bas niveau adaptera le rang des objets créés par la macro."
L["TIP_HUNTER_FEED_PET"] = "Nourrir le familier est un bouton tout-en-un ! Cliquez pour appeler, nourrir ou ressusciter automatiquement votre familier. Faites un clic droit ou utilisez-le en combat pour lancer Guérison du familier. Maintenez Maj pour forcer la Résurrection, ou Ctrl pour le Renvoyer."
L["TIP_MAGE_CONJURE"] = "Clic droit sur vos macros Nourriture ou Eau pour en créer."
L["TIP_MAGE_GEM"] = "Clic droit sur votre macro Gemme de mana pour en créer une nouvelle. Cliquez à nouveau avec le bouton droit pour créer une gemme de rang inférieur en secours."
L["TIP_MAGE_TABLE"] = "Clic milieu pour lancer Rituel de rafraîchissement."
L["TIP_WARLOCK_CONJURE"] = "Clic droit sur vos macros Pierre de soins ou Pierre d'âme pour en créer une."
L["TIP_WARLOCK_SOUL"] = "Clic milieu pour lancer Rituel des âmes."

L["UI_BEST_FOOD"] = "Meilleure nourriture"
L["UI_BEST_PET_FOOD"] = "Nourriture pour familier"
L["UI_DISABLED"] = "Désactivé"
L["UI_ENABLED"] = "Activé"
L["UI_IGNORE_LIST"] = "Liste d'exclusion"
L["UI_LEFT_CLICK"] = "Clic Gauche"
L["UI_MIDDLE_CLICK"] = "Clic Milieu"
L["UI_RIGHT_CLICK"] = "Clic Droit"
L["UI_SHIFT_LEFT"] = "Maj + Clic Gauche"
L["UI_TOGGLE"] = "Basculer"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Toujours"
L["MODE_PARTY"] = "Uniquement en groupe"
L["MODE_RAID"] = "Uniquement en raid"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "Des macros à mise à jour automatique pour votre meilleure nourriture, nourriture avec amélioration, eau, parchemins, potions de soins et de mana, pierres de soins, pierres d'âme, gemmes de mana et bandages. Invocation en un clic pour les Mages et Démonistes, Nourrir le familier intelligent pour les Chasseurs. Nutrition optimale, performances maximales."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Activer le message de bienvenue"
L["OPTIONS_WELCOME_MESSAGE_DESC"] = "Affiche un message de bienvenue dans le chat lors de la connexion."

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "Priorité : Bien nourri"
L["OPTIONS_BUFF_FOOD_DESC"] = "Priorise la nourriture conférant l'amélioration \"Bien nourri\" si elle est absente."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Améliorations de parchemins"
L["OPTIONS_USE_SCROLLS"] = "Inclure les parchemins"
L["OPTIONS_USE_SCROLLS_DESC"] = "Transforme votre macro Nourriture en applicateur de parchemins dédié lorsqu'il vous manque des améliorations de parchemins. Appuyez une fois pour appliquer les parchemins ; appuyez à nouveau pour manger. Les parchemins sont hors du GCD, vous ciblent, et la macro redevient de la nourriture dès que vous ciblez un autre joueur amical."
L["OPTIONS_SCROLL_TYPES"] = "Types de parchemins à vérifier"
L["OPTIONS_SCROLL_AGILITY"] = "Agilité"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelligence"
L["OPTIONS_SCROLL_PROTECTION"] = "Protection"
L["OPTIONS_SCROLL_SPIRIT"] = "Esprit"
L["OPTIONS_SCROLL_STAMINA"] = "Endurance"
L["OPTIONS_SCROLL_STRENGTH"] = "Force"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Améliorations de nourriture pour familier"
L["OPTIONS_USE_PET_BUFFS"] = "Utiliser les améliorations de nourriture pour familier"
L["OPTIONS_USE_PET_BUFFS_DESC"] = "Utilise de la nourriture pour familier dans votre macro Nourriture lorsque votre familier n'a pas l'amélioration \"Bien nourri\"."
L["OPTIONS_PET_BUFF_TYPES"] = "Inclure les types de nourriture pour familier à vérifier"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Morceaux de Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Casse-croûte sporélin"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druides"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Activer l'intégration de DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESC"] = "Crée des macros de powershifting pour les potions de soins, les potions de mana et les pierres de soins à l'aide de DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Après le consommable, passer en"
L["DRUID_FORM_BEAR"] = "Ours"
L["DRUID_FORM_CAT"] = "Chat"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfes de la nuit"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Boire avec Camouflage dans l'ombre"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Ajoute Camouflage dans l'ombre à votre macro d'Eau pour vous camoufler pendant que vous buvez."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Ouvre l'interface des options de Connoisseur."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Activer les macros"
L["OPTIONS_ENABLE_MACROS_DESC"] = "Permet d'activer ou de désactiver les macros créées et gérées par Connoisseur. La désactivation d'une macro la supprimera également."

-- Reset
L["OPTIONS_RESET_HEADER"] = "Réinitialiser"
L["OPTIONS_RESET_IGNORE_DESC"] = "Retire tous les objets de la liste d'exclusion."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Voulez-vous vraiment vider la liste d'exclusion ?"
L["OPTIONS_RESET_ALL"] = "Réinitialiser toutes les options de Connoisseur"
L["OPTIONS_RESET_ALL_DESC"] = "Réinitialiser tous les paramètres et la liste d'exclusion à leurs valeurs par défaut."
L["OPTIONS_RESET_ALL_CONFIRM"] = "Réinitialiser toutes les options de Connoisseur par défaut ?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Commentaires et Assistance"