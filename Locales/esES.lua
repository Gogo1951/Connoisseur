-- [[ SPANISH (esES + esMX) ]] --
local strings = {
    ["BRAND"] = "Connoisseur",

    -- Macro Names Can't Exceed 16 Total Characters
    ["MACRO_BANDAGE"] = "- Venda",
    ["MACRO_FOOD"]    = "- Comida",
    ["MACRO_HPOT"]    = "- Poc. Salud",
    ["MACRO_HS"]      = "- Piedra",
    ["MACRO_MGEM"]    = "- Gema de maná",
    ["MACRO_MPOT"]    = "- Poc. Maná",
    ["MACRO_SS"]      = "- Piedra de alma",
    ["MACRO_WATER"]   = "- Agua",
    ["MACRO_FEED_PET"]= "- Alim. mascota",

    ["ERR_ZONE"] = "No puedes usar eso aquí.",
    ["RANK"]     = "Rango",

    ["MSG_BUG_REPORT"] = "¡Parece que encontraste un error! %s (%s) no se puede usar en %s > %s (%s). Por favor repórtalo para que podamos arreglarlo. ¡Gracias! https://discord.gg/eh8hKq992Q",
    ["MSG_NO_ITEM"]    = "No se encontró ningún %s adecuado en tus bolsas.",

    ["MENU_BUFF_FOOD"]      = "Priorizar comida con beneficios",
    ["MENU_BUFF_FOOD_DESC"] = "Prioriza la comida que otorga el beneficio \"Bien alimentado\" cuando te falta.",
    ["MENU_CLEAR_IGNORE"]   = "Borrar lista de ignorados",
    ["MENU_IGNORE"]         = "Ignorar",
    ["MENU_RESET"]          = "Reiniciar",
    ["MENU_SCAN"]           = "Forzar escaneo",
    ["MENU_TITLE"]          = "Consumibles",

    ["MENU_SCROLL_BUFFS"]      = "Beneficios de pergaminos",
    ["MENU_SCROLL_BUFFS_DESC"] = "Usa pergaminos de atributos como parte de tu macro de Comida cuando falta el beneficio.",
    ["MENU_OPTIONS_HINT"]      = "Opciones adicionales disponibles en Opciones > Accesorios > Connoisseur.",

    ["PREFIX_HUNTER"]  = "Atención Cazadores",
    ["PREFIX_MAGE"]    = "Atención Magos",
    ["PREFIX_WARLOCK"] = "Atención Brujos",

    ["TIP_DOWNRANK"]        = "Seleccionar a un jugador de menor nivel hará que la macro conjure objetos apropiados para su nivel.",
    ["TIP_HUNTER_FEED_PET"] = "¡Alimentar mascota es un botón todo en uno! Haz clic para llamar, alimentar o revivir a tu mascota automáticamente. Haz clic derecho o úsalo en combate para lanzar Aliviar mascota. Mantén presionado Shift para forzar Revivir, o Ctrl para Retirar.",
    ["TIP_MAGE_CONJURE"]    = "Clic derecho en tus macros de Comida o Agua para crear Comida o Agua.",
    ["TIP_MAGE_GEM"]        = "Clic derecho en tu macro de Gema de maná para conjurar una nueva gema. Vuelve a hacer clic derecho para conjurar una gema de rango inferior como respaldo.",
    ["TIP_MAGE_TABLE"]      = "Clic central para lanzar Ritual de refrigerio.",
    ["TIP_WARLOCK_CONJURE"] = "Clic derecho en tus macros de Piedra de salud o Piedra de alma para crear una Piedra de salud o Piedra de alma.",
    ["TIP_WARLOCK_SOUL"]    = "Clic central para lanzar Ritual de almas.",

    ["UI_BEST_FOOD"]    = "Mejor comida actual",
    ["UI_BEST_PET_FOOD"]= "Comida de mascota",
    ["UI_DISABLED"]     = "Desactivado",
    ["UI_ENABLED"]      = "Activado",
    ["UI_IGNORE_LIST"]  = "Lista de ignorados",
    ["UI_LEFT_CLICK"]   = "Clic izquierdo",
    ["UI_MIDDLE_CLICK"] = "Clic central",
    ["UI_RIGHT_CLICK"]  = "Clic derecho",
    ["UI_SHIFT_LEFT"]   = "Shift + Clic izquierdo",
    ["UI_TOGGLE"]       = "Alternar",

    -- Options Panel
    ["OPTIONS_DESC"]              = "Crea macros para usar la mejor comida, agua, pociones, piedras de salud, piedras de alma, gemas de maná o vendas que tengas disponibles.",
    ["OPTIONS_BUFF_FOOD"]         = "Priorizar comida con beneficios",
    ["OPTIONS_BUFF_FOOD_DESC"]    = "Prioriza la comida que otorga el beneficio \"Bien alimentado\" cuando te falta.",
    ["OPTIONS_SCROLL_HEADER"]     = "Beneficios de pergaminos",
    ["OPTIONS_USE_SCROLLS"]       = "Incluir beneficios de pergaminos",
    ["OPTIONS_USE_SCROLLS_DESC"]  = "Usa pergaminos, cuando falta el beneficio del pergamino, como parte de tu macro de Comida.",
    ["OPTIONS_SCROLL_TYPES"]      = "Incluir tipos de pergaminos en la comprobación",
    ["OPTIONS_SCROLL_AGILITY"]    = "Agilidad",
    ["OPTIONS_SCROLL_INTELLECT"]  = "Intelecto",
    ["OPTIONS_SCROLL_PROTECTION"] = "Protección",
    ["OPTIONS_SCROLL_SPIRIT"]     = "Espíritu",
    ["OPTIONS_SCROLL_STAMINA"]    = "Aguante",
    ["OPTIONS_SCROLL_STRENGTH"]   = "Fuerza",

    ["OPTIONS_PET_HEADER"]           = "Beneficios de comida de mascota",
    ["OPTIONS_USE_PET_BUFFS"]        = "Usar beneficios de comida de mascota",
    ["OPTIONS_USE_PET_BUFFS_DESC"]   = "Usa comida de mascota, como parte de tu macro de Comida, cuando a tu mascota le falta el beneficio \"Bien alimentado\".",
    ["OPTIONS_PET_BUFF_TYPES"]       = "Incluir tipos de comida de mascota en la comprobación",
    ["OPTIONS_PET_BUFF_KIBLERS"]     = "Bocado de Kibler",
    ["OPTIONS_PET_BUFF_SPORELING"]   = "Bocados de esporino",

    ["OPTIONS_NIGHTELF_HEADER"]           = "Elfos de la noche",
    ["OPTIONS_SHADOWMELD_DRINKING"]      = "Beber con Fusión de las sombras",
    ["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Añade Fusión de las sombras a tu macro de Agua para entrar en sigilo mientras bebes.",

    ["OPTIONS_COMMANDS_HEADER"] = "/Commands",
    ["OPTIONS_COMMANDS_DESC"]   = "/foodie",

    ["OPTIONS_RESET_HEADER"]         = "Reiniciar",
    ["OPTIONS_RESET_IGNORE_DESC"]    = "Eliminar todos los objetos de la lista de ignorados.",
    ["OPTIONS_RESET_IGNORE_CONFIRM"] = "¿Estás seguro de que quieres borrar la lista de ignorados?",
    ["OPTIONS_COMMUNITY_HEADER"]     = "Comentarios y soporte"
}

local L_esES = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "esES")
if L_esES then
    for k, v in pairs(strings) do L_esES[k] = v end
end

local L_esMX = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "esMX")
if L_esMX then
    for k, v in pairs(strings) do L_esMX[k] = v end
end