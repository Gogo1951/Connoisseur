local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "esMX")
if not L then return end

-- [[ LATIN AMERICAN SPANISH (esMX) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["BRAND"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Venda"
L["MACRO_FEED_PET"] = "- Alim. mascota"
L["MACRO_FOOD"] = "- Comida"
L["MACRO_HEALTH_POTION"] = "- Poc. Salud"
L["MACRO_HEALTHSTONE"] = "- Piedra"
L["MACRO_MANA_GEM"] = "- Gema de maná"
L["MACRO_MANA_POTION"] = "- Poc. Maná"
L["MACRO_SOULSTONE"] = "- Piedra de alma"
L["MACRO_WATER"] = "- Agua"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "Rango"

--------------------------------------------------------------------------------
-- Pet Diets
--------------------------------------------------------------------------------

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

L["DIET_BREAD"] = "Pan"
L["DIET_CHEESE"] = "Queso"
L["DIET_FISH"] = "Pescado"
L["DIET_FRUIT"] = "Fruta"
L["DIET_FUNGUS"] = "Hongo"
L["DIET_MEAT"] = "Carne"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] = "¡Parece que encontraste un error! %s (%s) no se puede usar en %s > %s (%s). Por favor repórtalo para que podamos arreglarlo. ¡Gracias! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "No se encontró ningún %s adecuado en tus bolsas."
L["MSG_MACRO_SLOTS_FULL"] = "Algunas macros de Connoisseur no se pudieron crear porque tus ranuras de macros están llenas. Libera espacio eliminando macros que ya no uses, o desactiva las macros de Connoisseur que no necesites en Opciones > Accesorios > Connoisseur."

L["CHAT_LOADED"] = "Versión %s. Los ajustes (incluida la opción de desactivar este mensaje) se encuentran en Opciones > Accesorios > Connoisseur. ¿Te gusta el accesorio? ¡Cuéntaselo a un amigo! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Core.lua.

L["TIP_PET_NO_FOOD"] = "Actualmente no tienes ninguna comida útil para tu mascota."
L["TIP_PET_NO_SKILLS"] = "Actualmente no conoces Alimentar mascota, Aliviar mascota o Revivir mascota."
L["TIP_PET_NO_MEND"] = "Actualmente no conoces Aliviar mascota."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Actualmente no conoces %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "Priorizar comida con beneficios"
L["MENU_BUFF_FOOD_DESCRIPTION"] = "Prioriza la comida que otorga el beneficio \"Bien alimentado\" cuando te falta."
L["MENU_CLEAR_IGNORE"] = "Borrar lista de ignorados"
L["MENU_IGNORE"] = "Ignorar"

L["MENU_SCROLL_BUFFS"] = "Beneficios de pergaminos"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "Convierte tu macro de Comida en un aplicador de pergaminos cuando te faltan beneficios de pergaminos."
L["MENU_OPTIONS_HINT"] = "Opciones adicionales disponibles en Opciones > Accesorios > Connoisseur."

L["PREFIX_HUNTER"] = "Atención Cazadores"
L["PREFIX_MAGE"] = "Atención Magos"
L["PREFIX_WARLOCK"] = "Atención Brujos"

L["TIP_DOWNRANK"] = "Seleccionar a un jugador de menor nivel hará que la macro conjure objetos apropiados para su nivel."
L["TIP_HUNTER_FEED_PET"] = "¡Alimentar mascota es un botón todo en uno! Haz clic para llamar, alimentar o revivir a tu mascota automáticamente. Haz clic derecho o úsalo en combate para lanzar Aliviar mascota. Mantén presionado Shift para forzar Revivir, o Ctrl para Retirar."
L["TIP_MAGE_CONJURE"] = "Clic derecho en tus macros de Comida o Agua para crear Comida o Agua."
L["TIP_MAGE_GEM"] = "Clic derecho en tu macro de Gema de maná para conjurar una nueva gema. Vuelve a hacer clic derecho para conjurar una gema de rango inferior como respaldo."
L["TIP_MAGE_TABLE"] = "Clic central para lanzar Ritual de refrigerio."
L["TIP_WARLOCK_CONJURE"] = "Clic derecho en tus macros de Piedra de salud o Piedra de alma para crear una Piedra de salud o Piedra de alma. Vuelve a hacer clic derecho en tu macro de Piedra de salud para conjurar una de rango inferior como respaldo."
L["TIP_WARLOCK_SOUL"] = "Clic central para lanzar Ritual de almas."

L["UI_BEST_FOOD"] = "Comida actual"
L["UI_BEST_PET_FOOD"] = "Comida de mascota"

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
L["LABEL_BANDAGE"] = "Venda"
L["LABEL_FOOD"] = "Comida"
L["LABEL_HEALTH_POTION"] = "Poción de salud"
L["LABEL_HEALTHSTONE"] = "Piedra de salud"
L["LABEL_MANA_GEM"] = "Gema de maná"
L["LABEL_MANA_POTION"] = "Poción de maná"
L["LABEL_PET_FOOD"] = "Comida de mascota"
L["LABEL_SOULSTONE"] = "Piedra de alma"
L["LABEL_WATER"] = "Agua"
L["UI_DISABLED"] = "Desactivado"
L["UI_ENABLED"] = "Activado"
L["UI_IGNORE_LIST"] = "Lista de ignorados"
L["UI_LEFT_CLICK"] = "Clic izquierdo"
L["UI_MIDDLE_CLICK"] = "Clic central"
L["UI_RIGHT_CLICK"] = "Clic derecho"
L["UI_SHIFT_LEFT"] = "Shift + Clic izquierdo"
L["UI_TOGGLE"] = "Alternar"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Siempre"
L["MODE_PARTY"] = "Solo en grupo"
L["MODE_RAID"] = "Solo en banda"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Macros que se actualizan automáticamente para tu mejor comida, comida con beneficios, agua, pergaminos, pociones de salud y maná, piedras de salud, piedras de alma, gemas de maná y vendas. Conjuración con un solo clic para Magos y Brujos, Alimentar mascota inteligente para Cazadores. Nutrición óptima, máximo rendimiento."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Activar mensaje de bienvenida"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Muestra un mensaje de bienvenida en el chat al iniciar sesión."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Pociones y Piedras de salud"
L["OPTIONS_POTIONS_DESCRIPTION"] = "Las macros no pueden cambiar durante el combate (es una restricción de Blizzard), por lo que cada macro de Poción y Piedra de salud se crea previamente con tu mejor objeto más hasta dos alternativas. En combates largos, el icono y la descripción pueden quedar obsoletos y mostrar un objeto equivocado, pero al hacer clic en la macro siempre se usará el mejor objeto que realmente tengas en tus bolsas."

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "Priorizar comida con beneficios"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = "Prioriza la comida que otorga el beneficio \"Bien alimentado\" cuando te falta."
L["OPTIONS_BUFF_FOOD_DETAIL"] = "Consejo experto: Seleccionarte a ti mismo siempre hace que la macro de comida omita la comida con beneficios y los pergaminos."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Beneficios de pergaminos"
L["OPTIONS_USE_SCROLLS"] = "Incluir beneficios de pergaminos"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] = "Convierte tu macro de Comida en un aplicador de pergaminos dedicado siempre que te falten beneficios de pergaminos. Toca una vez para aplicar pergaminos; toca de nuevo para comer. Los pergaminos no activan el GCD, te tienen como objetivo y la macro vuelve a ser de comida en el momento en que seleccionas a otro jugador amistoso."
L["OPTIONS_SCROLL_TYPES"] = "Incluir tipos de pergaminos en la comprobación"
L["OPTIONS_SCROLL_AGILITY"] = "Agilidad"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelecto"
L["OPTIONS_SCROLL_PROTECTION"] = "Protección"
L["OPTIONS_SCROLL_SPIRIT"] = "Espíritu"
L["OPTIONS_SCROLL_STAMINA"] = "Aguante"
L["OPTIONS_SCROLL_STRENGTH"] = "Fuerza"

-- Pets Food Buffs
L["OPTIONS_PET_HEADER"] = "Beneficios de comida de mascota"
L["OPTIONS_USE_PET_BUFFS"] = "Usar beneficios de comida de mascota"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] = "Usa comida de mascota, como parte de tu macro de Comida, cuando a tu mascota le falta el beneficio \"Bien alimentado\"."
L["OPTIONS_PET_BUFF_TYPES"] = "Incluir tipos de comida de mascota en la comprobación"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Bocado de Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Bocados de esporino"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druidas"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Activar integración con DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] = "Crea macros de powershifting para pociones de salud, pociones de maná y piedras de salud usando DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Después del consumible, cambiar a"
L["DRUID_FORM_BEAR"] = "Oso"
L["DRUID_FORM_CAT"] = "Gato"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfos de la noche"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Beber con Fusión de las sombras"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] = "Añade Fusión de las sombras a tu macro de Agua para entrar en sigilo mientras bebes."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESCRIPTION"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Abre la interfaz de opciones de Connoisseur."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Activar macros"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] = "Alterna qué macros crea y mantiene Connoisseur. Al desactivar una macro también se eliminará."

-- Reset
L["OPTIONS_RESET_HEADER"] = "Reiniciar"
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "Eliminar todos los objetos de la lista de ignorados."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "¿Estás seguro de que quieres borrar la lista de ignorados?"
L["OPTIONS_RESET_ALL"] = "Restablecer todas las opciones de Connoisseur"
L["OPTIONS_RESET_ALL_DESCRIPTION"] = "Restablecer todos los ajustes y la lista de ignorados a sus valores predeterminados."
L["OPTIONS_RESET_ALL_CONFIRM"] = "¿Restablecer todas las opciones de Connoisseur a sus valores predeterminados?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Comentarios y soporte"