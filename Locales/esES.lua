local addonName, ns = ...

-- [[ SPANISH (esES + esMX) ]] --
local strings = {
    --------------------------------------------------------------------------------
    -- Brand
    --------------------------------------------------------------------------------

    ["BRAND"] = "Connoisseur",

    --------------------------------------------------------------------------------
    -- Macro Names
    --------------------------------------------------------------------------------

    -- Macro names cannot exceed 16 total characters.

    ["MACRO_BANDAGE"] = "- Venda",
    ["MACRO_FEED_PET"] = "- Alim. mascota",
    ["MACRO_FOOD"] = "- Comida",
    ["MACRO_HEALTH_POTION"] = "- Poc. Salud",
    ["MACRO_HEALTHSTONE"] = "- Piedra",
    ["MACRO_MANA_GEM"] = "- Gema de maná",
    ["MACRO_MANA_POTION"] = "- Poc. Maná",
    ["MACRO_SOULSTONE"] = "- Piedra de alma",
    ["MACRO_WATER"] = "- Agua",

    --------------------------------------------------------------------------------
    -- Common
    --------------------------------------------------------------------------------

    ["RANK"] = "Rango",

    --------------------------------------------------------------------------------
    -- Chat Messages
    --------------------------------------------------------------------------------

    ["MSG_BUG_REPORT"] = "¡Parece que encontraste un error! %s (%s) no se puede usar en %s > %s (%s). Por favor repórtalo para que podamos arreglarlo. ¡Gracias! https://discord.gg/eh8hKq992Q",
    ["MSG_NO_ITEM"] = "No se encontró ningún %s adecuado en tus bolsas.",

    ["CHAT_LOADED"] = "Versión @project-version@. Los ajustes (incluida la opción de desactivar este mensaje) se encuentran en Opciones > Accesorios > Connoisseur. ¿Te gusta el accesorio? ¡Cuéntaselo a un amigo! (=",

    --------------------------------------------------------------------------------
    -- Minimap Tooltip
    --------------------------------------------------------------------------------

    ["MENU_BUFF_FOOD"] = "Priorizar comida con beneficios",
    ["MENU_BUFF_FOOD_DESC"] = "Prioriza la comida que otorga el beneficio \"Bien alimentado\" cuando te falta.",
    ["MENU_CLEAR_IGNORE"] = "Borrar lista de ignorados",
    ["MENU_IGNORE"] = "Ignorar",

    ["MENU_SCROLL_BUFFS"] = "Beneficios de pergaminos",
    ["MENU_SCROLL_BUFFS_DESC"] = "Convierte tu macro de Comida en un aplicador de pergaminos cuando te faltan beneficios de pergaminos.",
    ["MENU_OPTIONS_HINT"] = "Opciones adicionales disponibles en Opciones > Accesorios > Connoisseur.",

    ["PREFIX_HUNTER"] = "Atención Cazadores",
    ["PREFIX_MAGE"] = "Atención Magos",
    ["PREFIX_WARLOCK"] = "Atención Brujos",

    ["TIP_DOWNRANK"] = "Seleccionar a un jugador de menor nivel hará que la macro conjure objetos apropiados para su nivel.",
    ["TIP_HUNTER_FEED_PET"] = "¡Alimentar mascota es un botón todo en uno! Haz clic para llamar, alimentar o revivir a tu mascota automáticamente. Haz clic derecho o úsalo en combate para lanzar Aliviar mascota. Mantén presionado Shift para forzar Revivir, o Ctrl para Retirar.",
    ["TIP_MAGE_CONJURE"] = "Clic derecho en tus macros de Comida o Agua para crear Comida o Agua.",
    ["TIP_MAGE_GEM"] = "Clic derecho en tu macro de Gema de maná para conjurar una nueva gema. Vuelve a hacer clic derecho para conjurar una gema de rango inferior como respaldo.",
    ["TIP_MAGE_TABLE"] = "Clic central para lanzar Ritual de refrigerio.",
    ["TIP_WARLOCK_CONJURE"] = "Clic derecho en tus macros de Piedra de salud o Piedra de alma para crear una Piedra de salud o Piedra de alma.",
    ["TIP_WARLOCK_SOUL"] = "Clic central para lanzar Ritual de almas.",

    ["UI_BEST_FOOD"] = "Mejor comida actual",
    ["UI_BEST_PET_FOOD"] = "Comida de mascota",
    ["UI_DISABLED"] = "Desactivado",
    ["UI_ENABLED"] = "Activado",
    ["UI_IGNORE_LIST"] = "Lista de ignorados",
    ["UI_LEFT_CLICK"] = "Clic izquierdo",
    ["UI_MIDDLE_CLICK"] = "Clic central",
    ["UI_RIGHT_CLICK"] = "Clic derecho",
    ["UI_SHIFT_LEFT"] = "Shift + Clic izquierdo",
    ["UI_TOGGLE"] = "Alternar",

    --------------------------------------------------------------------------------
    -- Mode Values
    --------------------------------------------------------------------------------

    ["MODE_ALWAYS"] = "Siempre",
    ["MODE_PARTY"] = "Solo en grupo",
    ["MODE_RAID"] = "Solo en banda",

    --------------------------------------------------------------------------------
    -- Options Panel
    --------------------------------------------------------------------------------

    ["OPTIONS_DESC"] = "Macros que se actualizan automáticamente para tu mejor comida, comida con beneficios, agua, pergaminos, pociones de salud y maná, piedras de salud, piedras de alma, gemas de maná y vendas. Conjuración con un solo clic para Magos y Brujos, Alimentar mascota inteligente para Cazadores. Nutrición óptima, máximo rendimiento.",

    -- Welcome Message
    ["OPTIONS_WELCOME_MESSAGE"] = "Activar mensaje de bienvenida",
    ["OPTIONS_WELCOME_MESSAGE_DESC"] = "Muestra un mensaje de bienvenida en el chat al iniciar sesión.",

    -- Buff Food
    ["OPTIONS_BUFF_FOOD"] = "Priorizar comida con beneficios",
    ["OPTIONS_BUFF_FOOD_DESC"] = "Prioriza la comida que otorga el beneficio \"Bien alimentado\" cuando te falta.",

    -- Scroll Buffs
    ["OPTIONS_SCROLL_HEADER"] = "Beneficios de pergaminos",
    ["OPTIONS_USE_SCROLLS"] = "Incluir beneficios de pergaminos",
    ["OPTIONS_USE_SCROLLS_DESC"] = "Convierte tu macro de Comida en un aplicador de pergaminos dedicado siempre que te falten beneficios de pergaminos. Toca una vez para aplicar pergaminos; toca de nuevo para comer. Los pergaminos no activan el GCD, te tienen como objetivo y la macro vuelve a ser de comida en el momento en que seleccionas a otro jugador amistoso.",
    ["OPTIONS_SCROLL_TYPES"] = "Incluir tipos de pergaminos en la comprobación",
    ["OPTIONS_SCROLL_AGILITY"] = "Agilidad",
    ["OPTIONS_SCROLL_INTELLECT"] = "Intelecto",
    ["OPTIONS_SCROLL_PROTECTION"] = "Protección",
    ["OPTIONS_SCROLL_SPIRIT"] = "Espíritu",
    ["OPTIONS_SCROLL_STAMINA"] = "Aguante",
    ["OPTIONS_SCROLL_STRENGTH"] = "Fuerza",

    -- Pet Food Buffs
    ["OPTIONS_PET_HEADER"] = "Beneficios de comida de mascota",
    ["OPTIONS_USE_PET_BUFFS"] = "Usar beneficios de comida de mascota",
    ["OPTIONS_USE_PET_BUFFS_DESC"] = "Usa comida de mascota, como parte de tu macro de Comida, cuando a tu mascota le falta el beneficio \"Bien alimentado\".",
    ["OPTIONS_PET_BUFF_TYPES"] = "Incluir tipos de comida de mascota en la comprobación",
    ["OPTIONS_PET_BUFF_KIBLERS"] = "Bocado de Kibler",
    ["OPTIONS_PET_BUFF_SPORELING"] = "Bocados de esporino",

    -- Druids
    ["OPTIONS_DRUIDS_HEADER"] = "Druidas",
    ["OPTIONS_DRUID_MACRO_HELPER"] = "Activar integración con DruidMacroHelper",
    ["OPTIONS_DRUID_MACRO_HELPER_DESC"] = "Crea macros de powershifting para pociones de salud, pociones de maná y piedras de salud usando DruidMacroHelper (/dmh).",
    ["OPTIONS_DRUID_RETURN_FORM"] = "Después del consumible, cambiar a",
    ["DRUID_FORM_BEAR"] = "Oso",
    ["DRUID_FORM_CAT"] = "Gato",

    -- Night Elves
    ["OPTIONS_NIGHTELF_HEADER"] = "Elfos de la noche",
    ["OPTIONS_SHADOWMELD_DRINKING"] = "Beber con Fusión de las sombras",
    ["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Añade Fusión de las sombras a tu macro de Agua para entrar en sigilo mientras bebes.",

    -- /Commands
    ["OPTIONS_COMMANDS_HEADER"] = "/Commands",
    ["OPTIONS_COMMANDS_DESC"] = "/foodie",
    ["OPTIONS_COMMANDS_DETAIL"] = "Abre la interfaz de opciones de Connoisseur.",

    -- Enable Macros
    ["OPTIONS_ENABLE_MACROS_HEADER"] = "Activar macros",
    ["OPTIONS_ENABLE_MACROS_DESC"] = "Alterna qué macros crea y mantiene Connoisseur. Al desactivar una macro también se eliminará.",

    -- Reset
    ["OPTIONS_RESET_HEADER"] = "Reiniciar",
    ["OPTIONS_RESET_IGNORE_DESC"] = "Eliminar todos los objetos de la lista de ignorados.",
    ["OPTIONS_RESET_IGNORE_CONFIRM"] = "¿Estás seguro de que quieres borrar la lista de ignorados?",
    ["OPTIONS_RESET_ALL"] = "Restablecer todas las opciones de Connoisseur",
    ["OPTIONS_RESET_ALL_DESC"] = "Restablecer todos los ajustes y la lista de ignorados a sus valores predeterminados.",
    ["OPTIONS_RESET_ALL_CONFIRM"] = "¿Restablecer todas las opciones de Connoisseur a sus valores predeterminados?",

    -- Feedback & Support
    ["OPTIONS_COMMUNITY_HEADER"] = "Comentarios y soporte"
}

local L_esES = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "esES")
if L_esES then
    for k, v in pairs(strings) do L_esES[k] = v end
end

local L_esMX = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "esMX")
if L_esMX then
    for k, v in pairs(strings) do L_esMX[k] = v end
end