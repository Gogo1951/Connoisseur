local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "esES")
if not L then
	return
end

-- [[ SPANISH (esES) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Venda"
L["MACRO_EXPLOSIVES"] = "- Explosivos"
L["MACRO_FEED_PET"] = "- Alim. mascota"
L["MACRO_FOOD"] = "- Comida"
L["MACRO_HEALTH_POTION"] = "- Poc. Salud"
L["MACRO_HEALTHSTONE"] = "- Piedra"
L["MACRO_MANA_GEM"] = "- Gema de maná"
L["MACRO_MANA_POTION"] = "- Poc. Maná"
L["MACRO_POISONS"] = "- Venenos"
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

L["MSG_BUG_REPORT"] =
	"¡Parece que encontraste un error! %s (%s) no se puede usar en %s > %s (%s). Por favor repórtalo para que podamos arreglarlo. ¡Gracias! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "No se encontró ningún %s adecuado en tus bolsas."
L["MSG_MACRO_SLOTS_FULL"] =
	"Algunas macros de Connoisseur no se pudieron crear porque tus ranuras de macros están llenas. Libera espacio eliminando macros que ya no uses, o desactiva las macros de Connoisseur que no necesites en Opciones > Accesorios > Connoisseur."

L["CHAT_LOADED"] =
	"Versión %s. Los ajustes (incluida la opción de desactivar este mensaje) se encuentran en Opciones > Accesorios > Connoisseur. ¿Te gusta el accesorio? ¡Cuéntaselo a un amigo! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "Actualmente no tienes ninguna comida útil para tu mascota."
L["TIP_PET_NO_SKILLS"] = "Actualmente no conoces Alimentar mascota, Aliviar mascota o Revivir mascota."
L["TIP_PET_NO_MEND"] = "Actualmente no conoces Aliviar mascota."
L["TIP_NO_HAND_POISON"] = "Te has quedado sin el veneno elegido para esta arma."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Actualmente no conoces %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Prioriza la comida que otorga el beneficio "Bien alimentado" cuando te falta.'
L["MENU_SCROLL_BUFFS"] = "Beneficios de pergaminos"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Convierte tu macro de Comida en un aplicador de pergaminos cuando te faltan beneficios de pergaminos."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Comida actual"
L["UI_BEST_PET_FOOD"] = "Comida de mascota"
L["UI_IGNORE_LIST"] = "Lista de ignorados"
L["MENU_IGNORE"] = "Ignorar"
L["MENU_CLEAR_IGNORE"] = "Borrar lista de ignorados"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Opciones de Connoisseur"
L["MENU_OPTIONS_KEYBIND"] = "Shift + Clic central"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

L["PREFIX_HUNTER"] = "Atención Cazadores"
L["PREFIX_MAGE"] = "Atención Magos"
L["PREFIX_ROGUE"] = "Atención Pícaros"
L["PREFIX_WARLOCK"] = "Atención Brujos"

L["TIP_DOWNRANK"] =
	"Seleccionar a un jugador de menor nivel hará que la macro conjure objetos apropiados para su nivel."
L["TIP_HUNTER_FEED_PET"] =
	"¡Alimentar mascota es un botón todo en uno! Haz clic para llamar, alimentar o revivir a tu mascota automáticamente. Haz clic derecho o úsalo en combate para lanzar Aliviar mascota. Mantén presionado Shift para forzar Revivir, o Ctrl para Retirar."
L["TIP_MAGE_CONJURE"] = "Clic derecho en tus macros de Comida o Agua para crear Comida o Agua."
L["TIP_MAGE_GEM"] =
	"Clic derecho en tu macro de Gema de maná para conjurar una nueva gema. Vuelve a hacer clic derecho para conjurar una gema de rango inferior como respaldo."
L["TIP_MAGE_TABLE"] = "Clic central para lanzar Ritual de refrigerio."
L["TIP_WARLOCK_CONJURE"] =
	"Clic derecho en tus macros de Piedra de salud o Piedra de alma para crear una Piedra de salud o Piedra de alma. Vuelve a hacer clic derecho en tu macro de Piedra de salud para conjurar una de rango inferior como respaldo."
L["TIP_WARLOCK_SOUL"] = "Clic central para lanzar Ritual de almas."
L["TIP_ROGUE_POISONS"] =
	"Clic izquierdo aplica el veneno de tu mano izquierda, clic derecho el de tu mano derecha. Los venenos existentes se reemplazan automáticamente. Clic central abre la ventana de Venenos."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

L["LABEL_BANDAGE"] = "Venda"
L["LABEL_EXPLOSIVE"] = "Explosivo"
L["LABEL_FOOD"] = "Comida"
L["LABEL_HEALTH_POTION"] = "Poción de salud"
L["LABEL_HEALTHSTONE"] = "Piedra de salud"
L["LABEL_MANA_GEM"] = "Gema de maná"
L["LABEL_MANA_POTION"] = "Poción de maná"
L["LABEL_PET_FOOD"] = "Comida de mascota"
L["LABEL_POISONS"] = "Veneno"
L["LABEL_SOULSTONE"] = "Piedra de alma"
L["LABEL_WATER"] = "Agua"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the minimap tooltip and options panel.

L["UI_ENABLED"] = "Activado"
L["UI_DISABLED"] = "Desactivado"
L["UI_TOGGLE"] = "Alternar"
L["UI_LEFT_CLICK"] = "Clic izquierdo"
L["UI_RIGHT_CLICK"] = "Clic derecho"
L["UI_MIDDLE_CLICK"] = "Clic central"
L["UI_SHIFT_LEFT"] = "Shift + Clic izquierdo"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Siempre"
L["MODE_PARTY"] = "Solo en grupo"
L["MODE_RAID"] = "Solo en banda"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Macros que se actualizan automáticamente para tu mejor comida, comida con beneficios, agua, pergaminos, pociones de salud y maná, piedras de salud, piedras de alma, gemas de maná y vendas. Conjuración con un solo clic para Magos y Brujos, Alimentar mascota inteligente para Cazadores. Nutrición óptima, máximo rendimiento."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Activar mensaje de bienvenida"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Muestra un mensaje de bienvenida en el chat al iniciar sesión."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Activar botón del minimapa"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Muestra el botón del minimapa."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Activar nombres de macro en los botones"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Muestra el texto del nombre de macro en los botones de tu barra de acción. Desactivado por defecto, lo que oculta los nombres que Blizzard ha vuelto a mostrar recientemente."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Pociones y Piedras de salud"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"Las macros no pueden cambiar durante el combate (es una restricción de Blizzard), por lo que cada macro de Poción y Piedra de salud se crea previamente con tu mejor objeto más hasta dos alternativas. En combates largos, el icono y la descripción pueden quedar obsoletos y mostrar un objeto equivocado, pero al hacer clic en la macro siempre se usará el mejor objeto que realmente tengas en tus bolsas."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "Combinar Piedras de salud en la macro de Poción de salud"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"Añade tu mejor Piedra de salud al final de la macro de Poción de salud, para que al presionar una vez se use una poción y una Piedra de salud."

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "Renovación de beneficios"
L["OPTIONS_REAPPLY"] = "Renovar beneficios a punto de expirar"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"Los combates suelen durar más que lo que queda de tus beneficios. Los beneficios con menos tiempo restante que el umbral cuentan como expirados, de modo que tus macros ofrecen uno nuevo antes del combate. Se aplica a Comida con beneficio, Beneficios de pergaminos y Beneficios de comida de mascota."
L["OPTIONS_REAPPLY_THRESHOLD"] = "Tratar como expirado cuando"
L["REAPPLY_THRESHOLD_ONE"] = "< 1 minuto restante"
L["REAPPLY_THRESHOLD_N"] = "< %d minutos restantes"

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "Comida con beneficio"
L["OPTIONS_BUFF_FOOD"] = "Priorizar comida con beneficios"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = 'Prioriza la comida que otorga el beneficio "Bien alimentado" cuando te falta.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Consejo experto: Seleccionarte a ti mismo siempre hace que la macro de comida omita la comida con beneficios y los pergaminos."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Beneficios de pergaminos"
L["OPTIONS_USE_SCROLLS"] = "Incluir beneficios de pergaminos"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Convierte tu macro de Comida en un aplicador de pergaminos dedicado siempre que te falten beneficios de pergaminos. Toca una vez para aplicar pergaminos; toca de nuevo para comer. Los pergaminos no activan el GCD, te tienen como objetivo y la macro vuelve a ser de comida en el momento en que seleccionas a otro jugador amistoso."
L["OPTIONS_SCROLL_TYPES"] = "Incluir tipos de pergaminos en la comprobación"
L["OPTIONS_SCROLL_AGILITY"] = "Agilidad"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelecto"
L["OPTIONS_SCROLL_PROTECTION"] = "Protección"
L["OPTIONS_SCROLL_SPIRIT"] = "Espíritu"
L["OPTIONS_SCROLL_STAMINA"] = "Aguante"
L["OPTIONS_SCROLL_STRENGTH"] = "Fuerza"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "Explosivos"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"La opción @player omite la retícula de selección y detona el explosivo justo a tus pies. Ideal cuando tu objetivo está a distancia cuerpo a cuerpo."
L["EXPLOSIVES_MODE_ATPLAYER"] = "Clic izquierdo @Player, clic derecho Lanzar"
L["EXPLOSIVES_MODE_TOSS"] = "Clic izquierdo Lanzar, clic derecho @Player"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Beneficios de comida de mascota"
L["OPTIONS_USE_PET_BUFFS"] = "Usar beneficios de comida de mascota"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Usa comida de mascota, como parte de tu macro de Comida, cuando a tu mascota le falta el beneficio "Bien alimentado".'
L["OPTIONS_PET_BUFF_TYPES"] = "Incluir tipos de comida de mascota en la comprobación"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Bocado de Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Bocados de esporino"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druidas"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Activar integración con DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Crea macros de powershifting para pociones de salud, pociones de maná y piedras de salud usando DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Después del consumible, cambiar a"
L["DRUID_FORM_BEAR"] = "Oso"
L["DRUID_FORM_CAT"] = "Gato"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfos de la noche"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Beber con Fusión de las sombras"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] =
	"Añade Fusión de las sombras a tu macro de Agua para entrar en sigilo mientras bebes."

-- Rogues
L["OPTIONS_POISONS_HEADER"] = "Venenos"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Mantiene la macro de Venenos cargada con el mejor rango utilizable de cada tipo de veneno: clic izquierdo aplica a tu mano izquierda, clic derecho a tu mano derecha, y los venenos existentes se reemplazan automáticamente."
L["OPTIONS_POISON_MAIN_HAND"] = "Mano derecha"
L["OPTIONS_POISON_OFF_HAND"] = "Mano izquierda"

-- Restocker
L["OPTIONS_RESTOCKER_HEADER"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Mantiene tus bolsas abastecidas según una lista de reabastecimiento por personaje. Compra automáticamente a los vendedores y mueve objetos entre las bolsas y el banco. Escribe /crs para abrir la lista."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Abrir en el banco"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Abre la ventana de Restocker al visitar el banco."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Abrir con el vendedor"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Abre la ventana de Restocker al visitar a un vendedor."
L["OPTIONS_RESTOCKER_DEBUG"] = "Activar mensajes de depuración de Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Muestra en el chat las decisiones de reabastecimiento de Restocker paso a paso (banco y vendedor). Ruidoso; permanece activo entre sesiones hasta que se desactive."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_FOODIE"] = "/foodie"
L["OPTIONS_COMMANDS_FOODIE_DETAIL"] = "Abre la interfaz de opciones de Connoisseur."
L["OPTIONS_COMMANDS_CRS"] = "/crs"
L["OPTIONS_COMMANDS_CRS_DETAIL"] = "Abre la ventana de Restocker para gestionar tu lista de reabastecimiento."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Activar macros"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Alterna qué macros crea y mantiene Connoisseur. Al desactivar una macro también se eliminará."

-- Ignore List
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "Eliminar todos los objetos de la lista de ignorados."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "¿Estás seguro de que quieres borrar la lista de ignorados?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Comentarios y soporte"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "Se importaron tus listas de Restocker."
L["RESTOCKER_PROFILE_EXISTS"] = 'Ya existe un perfil llamado "%s".'
L["RESTOCKER_BANK_NOT_OPEN"] = "El banco no está abierto."
-- %s is the /crs slash command, colored at the call site.
L["RESTOCKER_COMPLETE"] =
	"Reabastecimiento completado. Mantén Mayús para omitirlo la próxima vez. Escribe %s para editar tu lista de reabastecimiento."
L["RESTOCKER_STOPPED_BOTH_FULL"] = "Reabastecimiento detenido. Tus bolsas y tu banco están llenos."
L["RESTOCKER_STOPPED_BANK_FULL"] =
	"Reabastecimiento detenido. Tu banco está lleno; libera un espacio y vuelve a abrirlo."
L["RESTOCKER_STOPPED_BAG_FULL"] =
	"Reabastecimiento detenido. Tus bolsas están llenas; libera un espacio y vuelve a abrir el banco."
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "Reabastecimiento detenido. No se pudo avanzar."
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] = "Reabastecimiento detenido. No se pudo mover: %s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (sobrante)"
L["RESTOCKER_STOPPED_ERROR"] = "Reabastecimiento detenido por un error: %s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] = "Tus bolsas están llenas. Se omite el reabastecimiento del vendedor."
L["RESTOCKER_FINISHED_RESTOCKING"] = "Reabastecimiento terminado (%d compras realizadas)."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Muestra la ventana de Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Añade un perfil con ese nombre."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Elimina el perfil con ese nombre."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Cambia el nombre del perfil actual a ese nombre."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copia ese perfil en el perfil actual."
L["RESTOCKER_HELP_PROFILE_USE"] = "Cambia el perfil activo a ese nombre."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filtrar objetos..."
L["RESTOCKER_ADD_BUTTON"] = "Añadir"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Añadir un objeto"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "Suelta un objeto desde tus bolsas o escribe un ID de objeto numérico."
L["RESTOCKER_PROFILE_LABEL"] = "Perfil:"
L["RESTOCKER_RENAME_LABEL"] = "Renombrar:"
L["RESTOCKER_NEW_PROFILE"] = "Perfil nuevo"
L["RESTOCKER_GROUP_OTHER"] = "Otros"
L["RESTOCKER_REMOVE_TOOLTIP"] = "Quita este objeto de la lista de reabastecimiento."
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "Cantidad a mantener"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "Pulsa Intro cuando termines de editar."
L["RESTOCKER_BUY_LABEL"] = "Comprar"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "Comprar al vendedor"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "Compra la cantidad necesaria cuando la ventana del vendedor esté abierta."
L["RESTOCKER_DEPOSIT_LABEL"] = "Depositar"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "Guardar en el banco"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"Guarda los objetos sobrantes en el banco cuando esté abierto. Usa 0 para guardarlo todo."
L["RESTOCKER_WITHDRAW_LABEL"] = "Retirar"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "Reabastecer desde el banco"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "Toma los objetos necesarios del banco cuando esté abierto."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "Reputación requerida"
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (%d%% de descuento)"
L["RESTOCKER_REPUTATION_ANY"] = "Cualquiera"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Amistoso"
L["RESTOCKER_REPUTATION_HONORED"] = "Honorable"
L["RESTOCKER_REPUTATION_REVERED"] = "Venerado"
L["RESTOCKER_REPUTATION_EXALTED"] = "Exaltado"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Reputación requerida con el vendedor"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] = "Solo compra a vendedores con los que tengas al menos esta reputación."
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Una reputación más alta también significa precios más baratos (Amistoso 5%, Honorable 10%, Venerado 15%, Exaltado 20%)."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Haz clic para elegir una reputación"
