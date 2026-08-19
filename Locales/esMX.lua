local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "esMX")
if not L then
	return
end

-- [[ LATIN AMERICAN SPANISH (esMX) ]] --

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
	"¡Parece que encontraste un error! %s (%s) no se puede usar en %s > %s (%s). Por favor repórtalo para que podamos arreglarlo. ¡Gracias! %s"
L["MSG_NO_ITEM"] = "No se encontró ningún %s adecuado en tus bolsas."
L["MSG_MACRO_SLOTS_FULL"] =
	"Algunas macros de Connoisseur no se pudieron crear porque tus ranuras de macros están llenas. Libera espacio eliminando macros que ya no uses, o desactiva las macros de Connoisseur que no necesites en Opciones > Accesorios > Connoisseur."

L["CHAT_LOADED"] =
	"Versión %s. Los ajustes (incluida la opción de desactivar este mensaje) se encuentran en Opciones > Accesorios > Connoisseur. ¿Te gusta el accesorio? ¡Cuéntaselo a un amigo! (="

L["CHAT_OPTIONS_IN_COMBAT"] = "Como medida de seguridad, la interfaz de opciones no se puede abrir durante el combate."

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "¡Todo listo!"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "Falta: %s"

L["READY_WELL_FED"] = "Bien alimentado"
L["READY_SCROLLS"] = "Pergaminos"
L["READY_PET_FED"] = "Mascota alimentada"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d min"
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s menos de 1 min"

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "Actualmente no tienes ninguna comida útil para tu mascota."
L["TIP_PET_NO_SKILLS"] = "Actualmente no conoces Llamar mascota, Retirar mascota, Alimentar mascota o Revivir mascota."
L["TIP_PET_NO_MEND"] = "Actualmente no conoces Aliviar mascota."
L["TIP_NO_HAND_POISON"] = "Te has quedado sin el veneno elegido para esta arma."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Actualmente no conoces %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the mini-map tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "Comida con beneficio"
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Prioriza la comida que otorga el beneficio "Bien alimentado" cuando te falta.'
L["FEATURE_SCROLL_BUFFS"] = "Beneficios de pergaminos"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Convierte tu macro de Comida en un aplicador de pergaminos cuando te faltan beneficios de pergaminos."

-- Section titles and ignore-list actions in the mini-map tooltip.
L["UI_BEST_FOOD"] = "Comida actual"
L["UI_BEST_PET_FOOD"] = "Comida de mascota actual"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "Mano derecha"
L["UI_OFF_HAND"] = "Mano izquierda"
--[[
    The value shown beside an item title when nothing resolved. Kept to a single
    word so it fits in the tooltip's right column, which never wraps -- the full
    sentence, MSG_NO_ITEM, explains it on the wrapping line underneath.
]]
L["UI_NONE"] = "Ninguno"
L["UI_IGNORE_LIST"] = "Lista de ignorados"
L["MENU_IGNORE"] = "Ignorar"
L["MENU_CLEAR_IGNORE"] = "Borrar lista de ignorados"

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
L["UI_RESTOCKER_REPORT"] = "Informe de reabastecimiento"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 pedido pendiente"
L["UI_RESTOCKER_NEEDED"] = "%d pedidos pendientes"
L["UI_RESTOCKER_STOCKED_SHORT"] = "Todo abastecido"
L["UI_RESTOCKER_STOCKED"] = "¡Enhorabuena, lo tienes todo abastecido!"

-- Options entry at the bottom of the mini-map tooltip.
L["MENU_OPTIONS"] = "Opciones de Connoisseur"
L["MENU_OPTIONS_KEYBIND"] = "Shift + Clic central"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

--[[
    Class-colored headers and conjure/pet tips shown in the mini-map tooltip for
    the player's class.
]]

L["PREFIX_HUNTER"] = "Atención Cazadores"
L["PREFIX_MAGE"] = "Atención Magos"
L["PREFIX_ROGUE"] = "Atención Pícaros"
L["PREFIX_WARLOCK"] = "Atención Brujos"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to -- the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "Sobre tu macro de Alimentar mascota..."
L["TIP_MAGE_MACROS"] = "Sobre tus macros de Comida, Agua y Gema de maná..."
L["TIP_ROGUE_MACROS"] = "Sobre tu macro de Venenos..."
L["TIP_WARLOCK_MACROS"] = "Sobre tus macros de Piedra de salud y Piedra de alma..."

L["TIP_HUNTER_ALL_IN_ONE"] = "¡Alimentar mascota es un botón de mascota todo en uno!"
L["TIP_HUNTER_CALL"] = "Clic izquierdo para llamar, alimentar o revivir a tu mascota automáticamente."
L["TIP_HUNTER_MEND"] = "Clic derecho o espera al combate para lanzar Aliviar mascota."
L["TIP_HUNTER_MODIFIERS"] = "Mantén Shift para forzar Revivir, o Ctrl para Retirar."

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "Clic derecho en tus macros de Comida o Agua para crear Comida o Agua."
L["TIP_MAGE_DOWNRANK"] = "Seleccionar a un jugador de menor nivel conjurará Comida o Agua apropiada para su nivel."
L["TIP_MAGE_TABLE"] = "Clic central en tus macros de Comida o Agua para lanzar Ritual de refrigerio."
L["TIP_MAGE_GEM"] =
	"Clic derecho en tu macro de Gema de maná para conjurar una nueva gema. Vuelve a hacer clic derecho para conjurar una gema de rango inferior como respaldo."

L["TIP_WARLOCK_HEALTHSTONE"] =
	"Clic derecho en tu macro de Piedra de salud para crear una Piedra de salud. Vuelve a hacer clic derecho para conjurar una de rango inferior como respaldo."
L["TIP_WARLOCK_DOWNRANK"] =
	"Seleccionar a un jugador de menor nivel creará una Piedra de salud apropiada para su nivel."
L["TIP_WARLOCK_SOULSTONE"] = "Clic derecho en tu macro de Piedra de alma para crear una Piedra de alma."
L["TIP_WARLOCK_SOUL"] = "Clic central en tu macro de Piedra de salud para lanzar Ritual de almas."

L["TIP_ROGUE_OFF_HAND"] = "Clic izquierdo aplica el veneno de tu mano izquierda."
L["TIP_ROGUE_MAIN_HAND"] = "Clic derecho aplica el veneno de tu mano derecha."
L["TIP_ROGUE_REPLACE"] = "Los venenos existentes se reemplazan automáticamente."
L["TIP_ROGUE_WINDOW"] = "Clic central abre la ventana de Venenos."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

--[[
    Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
    One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
]]

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

-- Generic labels reused across the mini-map tooltip and options panel.

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
L["MODE_PARTY"] = "Solo en grupo o banda"
L["MODE_RAID"] = "Solo en banda"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Macros que usan automáticamente tu mejor comida, comida con beneficio, agua, pociones, piedras de salud, vendas y pergaminos, además de una lista de reabastecimiento que mantiene tus bolsas llenas y mejora tus consumibles conforme subes de nivel. Automatización de calidad de vida, máximo rendimiento."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Activar mensaje de bienvenida"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Muestra un mensaje de bienvenida en el chat al iniciar sesión."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Activar botón del minimapa"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Muestra el botón del minimapa."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Activar nombres de macro en los botones"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Muestra el texto del nombre de macro en los botones de tu barra de acción. Desactivado por defecto, lo que oculta los nombres que el juego muestra por su cuenta."

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
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "Cuando quede < 1 minuto"
L["REAPPLY_THRESHOLD_N"] = "Cuando queden < %d minutos"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "Comprobación de estado"
L["OPTIONS_READY_CHECK"] = "Informar del estado en la comprobación"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"Muestra lo que te falta y cuánto tiempo les queda a tus beneficios controlados cada vez que empieza una comprobación de estado; solo tú puedes verlo."

--[[
    Three features are suppressed in a PvP Arena, and each says so with the
    same sentence. It lives here once and is appended at the call site
    (Options/Options-Macros.lua), so every locale translates it a single time
    and the caveat can never drift between the three.
]]
L["OPTIONS_DISABLED_IN_ARENAS"] = "Desactivado en las Arenas."

--[[
    Buff Food. The section header reuses FEATURE_BUFF_FOOD, and the options
    description reuses MENU_BUFF_FOOD_DESCRIPTION plus the arena note above --
    the mini-map tooltip and the options panel say the same thing, so they read
    from one key rather than two copies of one sentence.
]]
L["OPTIONS_BUFF_FOOD"] = "Priorizar comida con beneficios"
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Consejo experto: Seleccionarte a ti mismo siempre hace que la macro de comida omita la comida con beneficios y los pergaminos."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "Incluir beneficios de pergaminos"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Toca una vez para aplicar los pergaminos que faltan, otra vez para comer. Los pergaminos no activan el GCD y se lanzan sobre ti; seleccionar a un jugador amistoso los omite."
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
L["EXPLOSIVES_MODE_ATPLAYER"] = "Clic izquierdo @player, clic derecho Lanzar"
L["EXPLOSIVES_MODE_TOSS"] = "Clic izquierdo Lanzar, clic derecho @player"

--[[
    Ignore List. The rows are items, so the only copy here is the add box and
    the placeholder shown while the client is still resolving an item's name.
    The section header and the clear-all button reuse UI_IGNORE_LIST and
    MENU_CLEAR_IGNORE, which the mini-map tooltip already carries.
]]
L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Objetos que Connoisseur nunca elegirá, por buenos que sean. Haz clic derecho en el botón del minimapa para ignorar la comida que ofrece en ese momento, o añade un objeto abajo."
L["OPTIONS_IGNORE_ADD_ID"] = "Añadir por ID de objeto"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Escribe un ID de objeto, o haz Mayús + Clic en un enlace de objeto del chat mientras este campo está activo."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "Escribe un ID de objeto, o haz Mayús + Clic en un enlace de objeto del chat."
L["OPTIONS_IGNORE_REMOVE"] = "Quitar"
L["OPTIONS_IGNORE_EMPTY"] = "Esta lista está vacía."
L["OPTIONS_IGNORE_CLEAR_CONFIRM"] = "¿Quitar todos los objetos de tu lista de ignorados?"
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "Cargando ID: %d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Beneficios de comida de mascota"
L["OPTIONS_USE_PET_BUFFS"] = "Usar beneficios de comida de mascota"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Añade comida de mascota a tu macro de Comida cuando a tu mascota le falta el beneficio "Bien alimentado".'
L["OPTIONS_PET_BUFF_TYPES"] = "Incluir tipos de comida de mascota en la comprobación"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Bocado de Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Bocados de esporino"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druidas"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Activar integración con DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Crea macros de powershifting para pociones de salud, pociones de maná y piedras de salud usando DruidMacroHelper (/dmh)."
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "Volver a Oso"
L["DRUID_FORM_CAT"] = "Volver a Gato"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfos de la noche"
L["OPTIONS_STEALTH_DRINKING"] = "Activar sigilo al beber"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] =
	"Añade Fusión de las sombras a tu macro de Agua para entrar en sigilo mientras bebes."
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	"Añade Fusión de las sombras a tu macro de Comida para entrar en sigilo mientras comes."
L["OPTIONS_STEALTH_PICK_ONE"] =
	"Consejo experto: Elige uno. Puedes comer y beber a la vez, pero comer o beber después de entrar en sigilo lo romperá."

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "Pícaros"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Mantiene la macro de Venenos cargada con el mejor rango utilizable de cada tipo de veneno: clic izquierdo aplica a tu mano izquierda, clic derecho a tu mano derecha, y los venenos existentes se reemplazan automáticamente."
L["OPTIONS_POISON_MAIN_HAND"] = "Tipo de veneno de mano derecha"
L["OPTIONS_POISON_OFF_HAND"] = "Tipo de veneno de mano izquierda"
L["OPTIONS_STEALTH_EATING"] = "Activar sigilo al comer"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] =
	"Añade Sigilo a tu macro de Comida para entrar en sigilo mientras comes."

--[[
    Restocker options panel. The tree label stays "Restocker" in every locale
    (brand fragment, localization allowlist); the panel header reuses
    RESTOCKER_WINDOW_TITLE.
]]
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Mantiene tus bolsas abastecidas según una lista de reabastecimiento por personaje. Compra automáticamente a los vendedores y mueve objetos entre las bolsas y el banco. Escribe %s para abrir la lista."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Abrir en el banco"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Abre la ventana de Restocker al visitar el banco."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Abrir con el vendedor"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Abre la ventana de Restocker al visitar a un vendedor."
L["OPTIONS_RESTOCKER_REMIND"] = "Activar recordatorios de reabastecimiento en la ciudad"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"Muestra un recordatorio en el chat cuando a tu lista de reabastecimiento le falta algo y llegas a una posada o una ciudad, o ya estás en una al iniciar sesión."
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "Activar recordatorios de reabastecimiento en el vendedor"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"Informa de los pedidos de reabastecimiento pendientes al cerrar la ventana del vendedor. Guarda silencio si no hay ninguno."
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "Activar recordatorios de reabastecimiento en el banco"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"Informa de los pedidos de reabastecimiento pendientes al cerrar el banco. Guarda silencio si no hay ninguno."

--[[
    The starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] = "Activar el asistente de lista cuando la lista de reabastecimiento esté vacía"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"Ofrece una lista de reabastecimiento inicial al iniciar sesión siempre que la de este personaje esté vacía."

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "Simple"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "Detallado"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "Reproducir sonido"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] =
	"Reproduce un aviso junto al recordatorio, para cuando el chat está muy movido."
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "Haz clic para oír el aviso."
L["OPTIONS_RESTOCKER_DEBUG"] = "Activar mensajes de depuración de Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Muestra en el chat las decisiones de reabastecimiento de Restocker paso a paso (banco y vendedor). Ruidoso; permanece activo entre sesiones hasta que se desactive."

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "Ventana de reabastecimiento"
L["OPTIONS_RESTOCKER_ADVANCED_HEADER"] = "Avanzado"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "Agradecimientos"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"Siempre me ha encantado Restocker, y me alegra que siga vivo dentro de Connoisseur. Muchísimas gracias a ChiliFajita, que escribió el Auto Restocker original, y a kvakvs y guardycmw, que lo mantuvieron con vida a lo largo de Classic y Mists of Pandaria."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la interfaz de opciones de este add-on."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "Abre la ventana de Restocker para gestionar tu lista de reabastecimiento."

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "Macros"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur crea una macro por consumible y la mantiene al día conforme cambian tus bolsas, de modo que el botón de tu barra siempre busca el mejor objeto que llevas encima. Elige abajo qué macros crear y luego ajusta cómo elige su objeto cada una."
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Activar macros"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Alterna qué macros crea y mantiene Connoisseur. Al desactivar una macro también se eliminará."

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "Comentarios y soporte"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "Versión"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_PROFILE_EXISTS"] = 'Ya existe un perfil llamado "%s".'
L["RESTOCKER_BANK_NOT_OPEN"] = "El banco no está abierto."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"Reabastecimiento completado. Mantén Mayús al abrir el banco para omitir el reabastecimiento. Escribe %s para editar tu lista de reabastecimiento."
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
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "¡No olvides reabastecerte mientras estás en la ciudad!"

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
L["RESTOCKER_STILL_SHORT_ONE"] = "1 pedido de reabastecimiento pendiente."
L["RESTOCKER_STILL_SHORT_MANY"] = "%d pedidos de reabastecimiento pendientes."

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, old amount, new link, new amount },
    outgoing tier on the left and incoming on the right.

    Both amounts are carried because they are not always equal: a swap onto a
    tier the list already holds merges the two rows, so the new amount is the
    sum rather than the old amount moved across.
]]
L["RESTOCKER_UPGRADED"] = "Tu lista de reabastecimiento se ha mejorado."
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d pasa a %sx%d."

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
L["RESTOCKER_RESTOCKED_ONE"] = "1 pedido de reabastecimiento completado."
L["RESTOCKER_RESTOCKED_MANY"] = "%d pedidos de reabastecimiento completados."

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "1 pedido de reabastecimiento completado en parte."
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] = "%d pedidos de reabastecimiento completados en parte."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Muestra la ventana de Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Añade un perfil con ese nombre."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Elimina el perfil con ese nombre."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Cambia el nombre del perfil actual a ese nombre."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copia ese perfil en el perfil actual."
L["RESTOCKER_HELP_PROFILE_USE"] = "Cambia el perfil activo a ese nombre."

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
	"Tu lista de reabastecimiento está vacía, así que vamos a añadir algunos objetos para empezar."
L["STARTER_POPUP_INTRO_HOW"] =
	"Todo lo que marques se mantiene abastecido automáticamente cada vez que abres un vendedor o tu banco, y los objetos básicos se mejoran solos según subes de nivel, así que siempre tendrás lo mejor disponible."
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] =
	"Siempre puedes ajustar esta lista, o añadir más objetos más adelante, escribiendo %s."
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "Comida y agua"
L["STARTER_POPUP_FOOD_HEADER"] = "Comida"
L["STARTER_POPUP_AMMO_HEADER"] = "Munición"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "Balas"
L["STARTER_POPUP_ARROWS"] = "Flechas"

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
L["STARTER_POPUP_REAGENTS_HEADER"] = "Componentes y herramientas"
L["STARTER_POPUP_POISONS_HEADER"] = "Venenos"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s : Añade el veneno terminado a tu lista y Connoisseur comprará los ingredientes automáticamente en cualquier vendedor que los tenga."
L["STARTER_POPUP_POISON_ANESTHETIC"] = "Anestésico"
L["STARTER_POPUP_POISON_CRIPPLING"] = "Tullidor"
L["STARTER_POPUP_POISON_DEADLY"] = "Mortal"
L["STARTER_POPUP_POISON_INSTANT"] = "Instantáneo"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "Entumecedor"
L["STARTER_POPUP_POISON_WOUND"] = "Herida"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "Piedra de hogar"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "Polvo cegador"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "Polvo relámpago"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "Ganzúas"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "Polvo de cadáver"
L["STARTER_POPUP_REAGENT_WILDS"] = "Bayas silvestres"
L["STARTER_POPUP_REAGENT_SEEDS"] = "Semillas"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "Polvo arcano"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "Pluma ligera"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "Runas de teleporte"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "Runas de portal"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "Símbolo divino"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "Símbolo de reyes"
L["STARTER_POPUP_REAGENT_CANDLES"] = "Velas"
L["STARTER_POPUP_REAGENT_ANKH"] = "Anj"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "Escamas de pez"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "Aceite de pez"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "Tótem de tierra"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "Tótem de fuego"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "Tótem de agua"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "Tótem de aire"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "Figurilla"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "Piedra infernal"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "Fragmentos de alma"
--[[
    Checkbox tooltips: { item link, amount }. The first is for ladder items;
    the second for single-tier reagents, which never upgrade.
]]
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"Añade %s a tu lista de reabastecimiento, manteniendo %d en tus bolsas y mejorándolos según subes de nivel."
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] = "Añade %s a tu lista de reabastecimiento y mantiene %d en tus bolsas."
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 for food, water and poisons, 200 for ammo); the tooltip
    below carries the per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 pila"
L["STARTER_POPUP_STACK_MANY"] = "%d pilas"
L["STARTER_POPUP_STACKS_DESCRIPTION"] = "Cuántas pilas mantener abastecidas. Aquí una pila son %d."
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] =
	"Cuántos mantener abastecidos. No se apilan, así que cada uno ocupa un espacio de tu bolsa."
L["STARTER_POPUP_DISMISS"] = "No volver a mostrar esto en este personaje."
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"De lo contrario, estas sugerencias vuelven a aparecer en cualquier inicio de sesión que encuentre vacía tu lista de reabastecimiento."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filtrar objetos..."
L["RESTOCKER_ADD_BUTTON"] = "Añadir"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Añadir un objeto"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "Suelta un objeto desde tus bolsas o escribe un ID de objeto numérico."
-- In-box placeholder for the add row; the tooltip above carries the detail.
L["RESTOCKER_ADD_PLACEHOLDER"] = "Suelta un objeto aquí, o escribe su ID..."
L["RESTOCKER_PROFILE_LABEL"] = "Perfil:"
L["RESTOCKER_RENAME_LABEL"] = "Renombrar:"
L["RESTOCKER_NEW_PROFILE"] = "Perfil nuevo"
L["RESTOCKER_COPY_PROFILE"] = "Copiar"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in RS.SetupTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Clona este perfil en uno nuevo"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s Copia"
L["RESTOCKER_DELETE_PROFILE"] = "Eliminar"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Elimina este perfil"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] = "¿Seguro que quieres eliminar este perfil?|n|n%s|n|nEsto no se puede deshacer."
--[[
    Row controls in the Restocker window. UPGRADE is disabled on any item that
    is not on a ladder in Data/Consumable-Upgrade-Paths.lua, which on a real
    list is most of them.
]]
L["RESTOCKER_UPGRADE_LABEL"] = "Mejora automática"
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "Mejorar con tu nivel"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"La comida, el agua, la munición y las pociones tienen rutas de mejora claras según subes de nivel, así que Connoisseur asciende este objeto por ti. Todo lo demás queda en tus manos con el tiempo."

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "Banco"
L["RESTOCKER_ROW_MERCHANT"] = "Vendedor"
L["RESTOCKER_ROW_UPGRADE"] = "Mejora"

L["RESTOCKER_GROUP_OTHER"] = "Otros"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "Nuevos"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "Quita este objeto de la lista de reabastecimiento"
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
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (%d%% de descuento)"
L["RESTOCKER_REPUTATION_ANY"] = "Cualquiera"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Amistoso"
L["RESTOCKER_REPUTATION_HONORED"] = "Honorable"
L["RESTOCKER_REPUTATION_REVERED"] = "Venerado"
L["RESTOCKER_REPUTATION_EXALTED"] = "Exaltado"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]
L["RESTOCKER_REPUTATION_BUTTON_FORMAT"] = "Rep.: %s"

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Reputación requerida con el vendedor"
--[[
    Quotes the button's own label. That couples this line to
    RESTOCKER_REPUTATION_BUTTON_FORMAT and RESTOCKER_REPUTATION_ANY -- a locale
    that renders the button differently has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'Elige un nivel de reputación y Connoisseur omitirá los vendedores con los que no lo hayas alcanzado. "Rep.: Cualquiera" compra a cualquier vendedor.'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"La reputación también rebaja el precio: Amistoso 5%, Honorable 10%, Venerado 15%, Exaltado 20%."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Haz clic para cambiarlo."
