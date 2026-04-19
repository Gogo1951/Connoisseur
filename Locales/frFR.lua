local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "frFR")
if not L then return end

-- [[ FRENCH (frFR) ]] --
L["BRAND"] = "Connoisseur"

-- Macro Names Can't Exceed 16 Total Characters
L["MACRO_BANDAGE"] = "- Bandage"
L["MACRO_FEED_PET"]= "- Nourrir fam."
L["MACRO_FOOD"]    = "- Manger"
L["MACRO_HPOT"]    = "- Pot. Soins"
L["MACRO_HS"]      = "- Pierre"
L["MACRO_MGEM"]    = "- Gemme de mana"
L["MACRO_MPOT"]    = "- Pot. Mana"
L["MACRO_SS"]      = "- Pierre d'âme"
L["MACRO_WATER"]   = "- Boire"

L["ERR_ZONE"] = "Vous ne pouvez pas utiliser cela ici."
L["RANK"]     = "Rang"

L["MSG_BUG_REPORT"] = "Vous avez trouvé un bug ! %s (%s) ne peut pas être utilisé à %s > %s (%s). Merci de le signaler pour correction. https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"]    = "Aucun %s approprié trouvé dans vos sacs."

L["MENU_BUFF_FOOD"]      = "Priorité : Bien nourri"
L["MENU_BUFF_FOOD_DESC"] = "Priorise la nourriture conférant l'amélioration \"Bien nourri\" si elle est absente."
L["MENU_CLEAR_IGNORE"]   = "Vider la liste d'exclusion"
L["MENU_IGNORE"]         = "Ignorer"
L["MENU_RESET"]          = "Réinitialiser"
L["MENU_SCAN"]           = "Forcer le scan"
L["MENU_TITLE"]          = "Consommables"

L["MENU_SCROLL_BUFFS"]      = "Améliorations de parchemins"
L["MENU_SCROLL_BUFFS_DESC"] = "Utilise des parchemins de caractéristiques dans votre macro Nourriture si l'amélioration est absente."
L["MENU_OPTIONS_HINT"]      = "Options supplémentaires disponibles dans Options > AddOns > Connoisseur."

L["PREFIX_HUNTER"]  = "Attention Chasseurs"
L["PREFIX_MAGE"]    = "Attention Mages"
L["PREFIX_WARLOCK"] = "Attention Démonistes"

L["TIP_DOWNRANK"]        = "Cibler un joueur de bas niveau adaptera le rang des objets créés par la macro."
L["TIP_HUNTER_FEED_PET"] = "Nourrir le familier est un bouton tout-en-un ! Cliquez pour appeler, nourrir ou ressusciter automatiquement votre familier. Faites un clic droit ou utilisez-le en combat pour lancer Guérison du familier. Maintenez Maj pour forcer la Résurrection, ou Ctrl pour le Renvoyer."
L["TIP_MAGE_CONJURE"]    = "Clic droit sur vos macros Nourriture ou Eau pour en créer."
L["TIP_MAGE_GEM"]        = "Clic droit sur votre macro Gemme de mana pour en créer une nouvelle. Cliquez à nouveau avec le bouton droit pour créer une gemme de rang inférieur en secours."
L["TIP_MAGE_TABLE"]      = "Clic milieu pour lancer Rituel de rafraîchissement."
L["TIP_WARLOCK_CONJURE"] = "Clic droit sur vos macros Pierre de soins ou Pierre d'âme pour en créer une."
L["TIP_WARLOCK_SOUL"]    = "Clic milieu pour lancer Rituel des âmes."

L["UI_BEST_FOOD"]    = "Meilleure nourriture"
L["UI_BEST_PET_FOOD"]= "Nourriture pour familier"
L["UI_DISABLED"]     = "Désactivé"
L["UI_ENABLED"]      = "Activé"
L["UI_IGNORE_LIST"]  = "Liste d'exclusion"
L["UI_LEFT_CLICK"]   = "Clic Gauche"
L["UI_MIDDLE_CLICK"] = "Clic Milieu"
L["UI_RIGHT_CLICK"]  = "Clic Droit"
L["UI_SHIFT_LEFT"]   = "Maj + Clic Gauche"
L["UI_TOGGLE"]       = "Basculer"

L["MODE_ALWAYS"] = "Toujours"
L["MODE_PARTY"]  = "Uniquement en groupe"
L["MODE_RAID"]   = "Uniquement en raid"

-- Options Panel
L["OPTIONS_DESC"] = "Crée des macros à mise à jour automatique pour vos meilleurs consommables, en suivant les améliorations pour vous garder au sommet de vos performances. Comprend un Feed-O-Matic tout-en-un pour les Chasseurs et une invocation intelligente par clic droit pour les Mages et Démonistes qui s'adapte au niveau de votre cible."
L["OPTIONS_BUFF_FOOD"]         = "Priorité : Bien nourri"
L["OPTIONS_BUFF_FOOD_DESC"]    = "Priorise la nourriture conférant l'amélioration \"Bien nourri\" si elle est absente."
L["OPTIONS_SCROLL_HEADER"]     = "Améliorations de parchemins"
L["OPTIONS_USE_SCROLLS"]       = "Incluir les parchemins"
L["OPTIONS_USE_SCROLLS_DESC"]  = "Utilise des parchemins, si l'amélioration est absente, dans votre macro Nourriture."
L["OPTIONS_SCROLL_TYPES"]      = "Types de parchemins à vérifier"
L["OPTIONS_SCROLL_AGILITY"]    = "Agilité"
L["OPTIONS_SCROLL_INTELLECT"]  = "Intelligence"
L["OPTIONS_SCROLL_PROTECTION"] = "Protection"
L["OPTIONS_SCROLL_SPIRIT"]     = "Esprit"
L["OPTIONS_SCROLL_STAMINA"]    = "Endurance"
L["OPTIONS_SCROLL_STRENGTH"]   = "Force"

L["OPTIONS_PET_HEADER"]        = "Améliorations de nourriture pour familier"
L["OPTIONS_USE_PET_BUFFS"]     = "Utiliser les améliorations de nourriture pour familier"
L["OPTIONS_USE_PET_BUFFS_DESC"]= "Utilise de la nourriture pour familier dans votre macro Nourriture lorsque votre familier n'a pas l'amélioration \"Bien nourri\"."
L["OPTIONS_PET_BUFF_TYPES"]    = "Inclure les types de nourriture pour familier à vérifier"
L["OPTIONS_PET_BUFF_KIBLERS"]  = "Morceaux de Kibler"
L["OPTIONS_PET_BUFF_SPORELING"]= "Casse-croûte sporélin"

L["OPTIONS_NIGHTELF_HEADER"]           = "Elfes de la nuit"
L["OPTIONS_SHADOWMELD_DRINKING"]      = "Boire avec Camouflage dans l'ombre"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Ajoute Camouflage dans l'ombre à votre macro d'Eau pour vous camoufler pendant que vous buvez."

L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"]   = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Ouvre l'interface des options de Connoisseur."

L["OPTIONS_ENABLE_MACROS_HEADER"] = "Activer les macros"
L["OPTIONS_ENABLE_MACROS_DESC"]   = "Permet d'activer ou de désactiver les macros créées et gérées par Connoisseur. La désactivation d'une macro la supprimera également."

L["OPTIONS_RESET_HEADER"]         = "Réinitialiser"
L["OPTIONS_RESET_IGNORE_DESC"]    = "Retire tous les objets de la liste d'exclusion."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Voulez-vous vraiment vider la liste d'exclusion ?"
L["OPTIONS_RESET_ALL"]            = "Réinitialiser toutes les options de Connoisseur"
L["OPTIONS_RESET_ALL_DESC"]       = "Réinitialiser tous les paramètres et la liste d'exclusion à leurs valeurs par défaut."
L["OPTIONS_RESET_ALL_CONFIRM"]    = "Réinitialiser toutes les options de Connoisseur par défaut ?"

L["OPTIONS_COMMUNITY_HEADER"]     = "Commentaires et Assistance"