local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "ruRU")
if not L then
	return
end

-- [[ RUSSIAN (ruRU) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Бинты"
L["MACRO_EXPLOSIVES"] = "- Взрывчатка"
L["MACRO_FEED_PET"] = "- Корм. питомца"
L["MACRO_FOOD"] = "- Еда"
L["MACRO_HEALTH_POTION"] = "- Леч. зелье"
L["MACRO_HEALTHSTONE"] = "- Кам. здоровья"
L["MACRO_MANA_GEM"] = "- Мана-камень"
L["MACRO_MANA_POTION"] = "- Зелье маны"
L["MACRO_POISONS"] = "- Яды"
L["MACRO_SOULSTONE"] = "- Кам. души"
L["MACRO_WATER"] = "- Вода"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "Уровень"

--------------------------------------------------------------------------------
-- Pet Diets
--------------------------------------------------------------------------------

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

L["DIET_BREAD"] = "Хлеб"
L["DIET_CHEESE"] = "Сыр"
L["DIET_FISH"] = "Рыба"
L["DIET_FRUIT"] = "Фрукты"
L["DIET_FUNGUS"] = "Грибы"
L["DIET_MEAT"] = "Мясо"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] =
	"Похоже, вы нашли ошибку! %s (%s) нельзя использовать в %s > %s (%s). Пожалуйста, сообщите об этом, чтобы мы могли исправить. Спасибо! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Подходящий %s не найден в сумках."
L["MSG_MACRO_SLOTS_FULL"] =
	"Некоторые макросы Connoisseur не удалось создать, так как ячейки макросов заполнены. Освободите место, удалив макросы, которые вы больше не используете, или отключите ненужные макросы Connoisseur в меню Настройки > Модификации > Connoisseur."

L["CHAT_LOADED"] =
	"Версия %s. Настройки (включая возможность отключения этого сообщения) находятся в Настройки > Модификации > Connoisseur. Нравится аддон? Расскажите другу! (="

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "Всё готово"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "Не хватает: %s"

L["READY_WELL_FED"] = "Сытость"
L["READY_SCROLLS"] = "Свитки"
L["READY_PET_FED"] = "Питомец накормлен"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d мин"
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s меньше 1 мин"

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] =
	"В данный момент у вас нет подходящей еды для питомца."
L["TIP_PET_NO_SKILLS"] =
	"В данный момент вы не знаете способности Призыв питомца, Отозвать питомца, Кормление питомца или Воскрешение питомца."
L["TIP_PET_NO_MEND"] =
	"В данный момент вы не знаете способность Лечение питомца."
L["TIP_NO_HAND_POISON"] = "Выбранный яд для этого оружия закончился."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "В данный момент вы не знаете способность %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["MENU_BUFF_FOOD"] = "Еда с эффектом"
L["MENU_BUFF_FOOD_DESCRIPTION"] =
	'Приоритет еды, дающей эффект "Сытость", если он отсутствует.'
L["MENU_SCROLL_BUFFS"] = "Баффы от свитков"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Превращает ваш макрос Еды в аппликатор свитков, когда вам не хватает баффов от свитков."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Текущая еда"
L["UI_BEST_PET_FOOD"] = "Текущая еда для питомца"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "Правая рука"
L["UI_OFF_HAND"] = "Левая рука"
L["UI_IGNORE_LIST"] = "Список игнорирования"
L["MENU_IGNORE"] = "Игнорировать"
L["MENU_CLEAR_IGNORE"] = "Очистить игнор-лист"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Настройки Connoisseur"
L["MENU_OPTIONS_KEYBIND"] = "Shift + СКМ"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

L["PREFIX_HUNTER"] = "Внимание Охотники"
L["PREFIX_MAGE"] = "Внимание Маги"
L["PREFIX_ROGUE"] = "Внимание Разбойники"
L["PREFIX_WARLOCK"] = "Внимание Чернокнижники"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to — the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "О вашем макросе Кормления питомца..."
L["TIP_MAGE_MACROS"] = "О ваших макросах Еды, Воды и Мана-камня..."
L["TIP_ROGUE_MACROS"] = "О вашем макросе Ядов..."
L["TIP_WARLOCK_MACROS"] = "О ваших макросах Камня здоровья и Камня души..."

L["TIP_HUNTER_ALL_IN_ONE"] =
	"Кормление питомца: универсальная кнопка для питомца!"
L["TIP_HUNTER_CALL"] =
	"ЛКМ, чтобы автоматически призвать, накормить или воскресить питомца."
L["TIP_HUNTER_MEND"] =
	"ПКМ или дождитесь боя, чтобы применить Лечение питомца."
L["TIP_HUNTER_MODIFIERS"] =
	"Удерживайте Shift для принудительного Воскрешения или Ctrl, чтобы отозвать питомца."

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "Правый клик по макросу Еды или Воды для сотворения."
L["TIP_MAGE_DOWNRANK"] =
	"Если выбрать целью игрока более низкого уровня, будут сотворены Еда или Вода, подходящие его уровню."
L["TIP_MAGE_TABLE"] =
	"Средний клик по макросу Еды или Воды для сотворения Ритуала подкрепления."
L["TIP_MAGE_GEM"] =
	"Правый клик по макросу Мана-камня для сотворения нового камня. Повторный правый клик для сотворения камня низшего ранга в качестве запасного."

L["TIP_WARLOCK_HEALTHSTONE"] =
	"Правый клик по макросу Камня здоровья, чтобы создать Камень здоровья. Повторный правый клик создаёт камень низшего ранга в качестве запасного."
L["TIP_WARLOCK_DOWNRANK"] =
	"Если выбрать целью игрока более низкого уровня, будет создан Камень здоровья, подходящий его уровню."
L["TIP_WARLOCK_SOULSTONE"] =
	"Правый клик по макросу Камня души, чтобы создать Камень души."
L["TIP_WARLOCK_SOUL"] =
	"Средний клик по макросу Камня здоровья для сотворения Ритуала душ."

L["TIP_ROGUE_OFF_HAND"] = "ЛКМ наносит яд на левую руку."
L["TIP_ROGUE_MAIN_HAND"] = "ПКМ наносит яд на правую руку."
L["TIP_ROGUE_REPLACE"] = "Нанесённые яды заменяются автоматически."
L["TIP_ROGUE_WINDOW"] = "СКМ открывает окно ядов."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

L["LABEL_BANDAGE"] = "Бинты"
L["LABEL_EXPLOSIVE"] = "Взрывчатка"
L["LABEL_FOOD"] = "Еда"
L["LABEL_HEALTH_POTION"] = "Лечебное зелье"
L["LABEL_HEALTHSTONE"] = "Камень здоровья"
L["LABEL_MANA_GEM"] = "Мана-камень"
L["LABEL_MANA_POTION"] = "Зелье маны"
L["LABEL_PET_FOOD"] = "Еда для питомца"
L["LABEL_POISONS"] = "Яд"
L["LABEL_SOULSTONE"] = "Камень души"
L["LABEL_WATER"] = "Вода"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the minimap tooltip and options panel.

L["UI_ENABLED"] = "Включено"
L["UI_DISABLED"] = "Отключено"
L["UI_TOGGLE"] = "Переключить"
L["UI_LEFT_CLICK"] = "ЛКМ"
L["UI_RIGHT_CLICK"] = "ПКМ"
L["UI_MIDDLE_CLICK"] = "СКМ"
L["UI_SHIFT_LEFT"] = "Shift + ЛКМ"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Всегда"
L["MODE_PARTY"] = "Только в группе или рейде"
L["MODE_RAID"] = "Только в рейде"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Автоматически обновляемые макросы для вашей лучшей еды, еды с баффами, воды, зелий, камней здоровья, свитков, камней души, бинтов, ядов и взрывчатки. Сотворение в один клик, умное Кормление питомца, автоматическое пополнение у торговца и из банка. Оптимальное питание, пиковая эффективность."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Включить приветственное сообщение"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] =
	"Выводить приветственное сообщение в чат при входе в игру."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Включить кнопку на миникарте"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Показать кнопку на миникарте."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Включить названия макросов на кнопках"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Показывает текст названия макроса на кнопках панели команд. По умолчанию выключено, что скрывает названия, которые Blizzard недавно снова начала показывать."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Зелья и Камни здоровья"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"Макросы не могут изменяться во время боя (это ограничение Blizzard), поэтому каждый макрос Зелья и Камня здоровья создается заранее с вашим лучшим предметом и до двух запасных вариантов. В затяжных боях иконка и подсказка могут устареть и показывать не тот предмет, но клик по макросу всегда будет использовать лучший предмет, который у вас действительно есть в сумках."
L["OPTIONS_COMBINE_HEALTHSTONES"] =
	"Объединить Камни здоровья в макрос Лечебного зелья"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"Добавляет ваш лучший Камень здоровья в конец макроса Лечебного зелья, поэтому одно нажатие использует и зелье, и Камень здоровья."

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "Обновление баффов"
L["OPTIONS_REAPPLY"] = "Обновлять истекающие баффы"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"Бои часто длятся дольше, чем осталось вашим баффам. Баффы, у которых осталось меньше времени, чем порог, считаются уже истёкшими, и макросы предлагают новый перед боем. Действует для еды с эффектом, баффов от свитков и еды для питомцев."
L["OPTIONS_REAPPLY_THRESHOLD"] = "Считать истёкшим, когда"
L["REAPPLY_THRESHOLD_ONE"] = "< 1 минуты"
L["REAPPLY_THRESHOLD_N"] = "< %d минут"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "Проверка готовности"
L["OPTIONS_READY_CHECK"] = "Сообщать о готовности при проверке"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"При каждой проверке готовности выводит, чего вам не хватает и сколько времени осталось у отслеживаемых баффов; видно только вам."

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "Еда с эффектом"
L["OPTIONS_BUFF_FOOD"] = "Еда с баффами"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'Приоритет еды, дающей эффект "Сытость", если он отсутствует. Отключено на аренах.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Совет профи: Выбор себя в качестве цели всегда заставляет макрос еды пропускать еду с баффами и свитки."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Баффы от свитков"
L["OPTIONS_USE_SCROLLS"] = "Включить баффы от свитков"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Нажмите один раз, чтобы применить недостающие свитки, и ещё раз, чтобы поесть. Свитки не зависят от ГКД и применяются к вам; если целью выбран дружественный игрок, они пропускаются. Отключено на аренах."
L["OPTIONS_SCROLL_TYPES"] = "Включить типы свитков в проверку"
L["OPTIONS_SCROLL_AGILITY"] = "Ловкость"
L["OPTIONS_SCROLL_INTELLECT"] = "Интеллект"
L["OPTIONS_SCROLL_PROTECTION"] = "Защита"
L["OPTIONS_SCROLL_SPIRIT"] = "Дух"
L["OPTIONS_SCROLL_STAMINA"] = "Выносливость"
L["OPTIONS_SCROLL_STRENGTH"] = "Сила"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "Взрывчатка"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"Вариант @player пропускает прицельный круг и подрывает взрывчатку прямо у ваших ног. Идеально, когда цель в ближнем бою."
L["EXPLOSIVES_MODE_ATPLAYER"] = "ЛКМ @player, ПКМ Бросок"
L["EXPLOSIVES_MODE_TOSS"] = "ЛКМ Бросок, ПКМ @player"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS"] = "Использовать баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Добавляет еду для питомца в макрос еды, если у питомца отсутствует бафф "Сытость". Отключено на аренах.'
L["OPTIONS_PET_BUFF_TYPES"] = "Включить типы еды для питомцев в проверку"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Кусочки Киблера"
L["OPTIONS_PET_BUFF_SPORELING"] = "Закуска из спор"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Друиды"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Включить интеграцию DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Создает макросы смены облика для лечебных зелий, зелий маны и камней здоровья с помощью DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "После расходуемого предмета сменить на"
L["DRUID_FORM_BEAR"] = "Медведь"
L["DRUID_FORM_CAT"] = "Кошка"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Ночные эльфы"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Включить незаметность при питье"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] =
	'Добавляет способность "Слиться с тенью" в макрос воды, чтобы вы уходили в незаметность во время питья.'
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	'Добавляет способность "Слиться с тенью" в макрос еды, чтобы вы уходили в незаметность во время еды.'
L["OPTIONS_STEALTH_PICK_ONE"] =
	"Совет профи: Выберите что-то одно. Есть и пить можно одновременно, но еда или питьё после ухода в незаметность прервут её."

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "Разбойники"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Держит макрос ядов заряженным лучшим доступным рангом каждого типа яда: левый клик наносит на левую руку, правый клик наносит на правую, а нанесённые яды заменяются автоматически."
L["OPTIONS_POISON_MAIN_HAND"] = "Тип яда для правой руки"
L["OPTIONS_POISON_OFF_HAND"] = "Тип яда для левой руки"
L["OPTIONS_STEALTH_EATING"] = "Включить незаметность при еде"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] =
	'Добавляет способность "Скрытность" в макрос еды, чтобы вы уходили в скрытность во время еды.'

-- Restocker. The section header reuses RESTOCKER_WINDOW_TITLE.
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Пополняет сумки по списку пополнения для каждого персонажа. Автоматически покупает у торговцев и перемещает предметы между сумками и банком. Введите /crs, чтобы открыть список."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Открывать в банке"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] =
	"Открывает окно Restocker при посещении банка."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Открывать у торговца"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] =
	"Открывает окно Restocker при посещении торговца."
L["OPTIONS_RESTOCKER_DEBUG"] = "Включить отладочные сообщения Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Выводит в чат пошаговые решения Restocker при пополнении из банка и у торговца. Многословно; остаётся включённым между сеансами, пока не выключить."

-- /Commands. The command literals stay in code; these are the descriptions.
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_FOODIE_DETAIL"] = "Открывает интерфейс настроек Connoisseur."
L["OPTIONS_COMMANDS_CRS_DETAIL"] =
	"Открывает окно Restocker для управления списком пополнения."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Включить макросы"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Выбор макросов, которые Connoisseur создает и поддерживает. Отключение макроса также удалит его."

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Обратная связь и поддержка"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "Ваши списки Restocker импортированы."
L["RESTOCKER_PROFILE_EXISTS"] = 'Профиль с именем "%s" уже существует.'
L["RESTOCKER_BANK_NOT_OPEN"] = "Банк не открыт."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"Пополнение завершено. Удерживайте Shift при открытии банка, чтобы пропустить пополнение. Введите %s, чтобы изменить список пополнения."
L["RESTOCKER_STOPPED_BOTH_FULL"] =
	"Пополнение остановлено. Ваши сумки и банк переполнены."
L["RESTOCKER_STOPPED_BANK_FULL"] =
	"Пополнение остановлено. Ваш банк переполнен; освободите ячейку и откройте его снова."
L["RESTOCKER_STOPPED_BAG_FULL"] =
	"Пополнение остановлено. Ваши сумки переполнены; освободите ячейку и откройте банк снова."
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "Пополнение остановлено. Продвижения нет."
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] =
	"Пополнение остановлено. Не удалось переместить: %s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (лишнее)"
L["RESTOCKER_STOPPED_ERROR"] = "Пополнение остановлено из-за ошибки: %s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] =
	"Ваши сумки переполнены. Пополнение у торговца пропущено."
L["RESTOCKER_FINISHED_RESTOCKING"] = "Пополнение завершено (покупок: %d)."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Показывает окно Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Добавляет профиль с этим именем."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Удаляет профиль с этим именем."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Переименовывает текущий профиль в это имя."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Копирует этот профиль в текущий."
L["RESTOCKER_HELP_PROFILE_USE"] = "Переключает активный профиль на это имя."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Фильтр предметов..."
L["RESTOCKER_ADD_BUTTON"] = "Добавить"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Добавить предмет"
L["RESTOCKER_ADD_TOOLTIP_BODY"] =
	"Перетащите предмет из сумки или введите числовой ID предмета."
L["RESTOCKER_PROFILE_LABEL"] = "Профиль:"
L["RESTOCKER_RENAME_LABEL"] = "Переименовать:"
L["RESTOCKER_NEW_PROFILE"] = "Новый профиль"
L["RESTOCKER_COPY_PROFILE"] = "Копировать"
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Клонирует этот профиль в новый."
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s (копия)"
L["RESTOCKER_DELETE_PROFILE"] = "Удалить"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Удаляет этот профиль."
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"Вы уверены, что хотите удалить этот профиль?|n|n%s|n|nЭто нельзя отменить."
L["RESTOCKER_GROUP_OTHER"] = "Прочее"
L["RESTOCKER_REMOVE_TOOLTIP"] = "Убирает этот предмет из списка пополнения."
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "Количество для пополнения"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "Нажмите Enter, когда закончите."
L["RESTOCKER_BUY_LABEL"] = "Купить"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "Покупать у торговца"
L["RESTOCKER_BUY_TOOLTIP_BODY"] =
	"Покупает нужное количество, когда открыто окно торговца."
L["RESTOCKER_DEPOSIT_LABEL"] = "Сдать"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "Складывать в банк"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"Складывает лишние предметы в банк, когда он открыт. Укажите 0, чтобы сложить всё."
L["RESTOCKER_WITHDRAW_LABEL"] = "Забрать"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "Пополнять из банка"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] =
	"Берёт нужные предметы из банка, когда он открыт."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "Требуемая репутация"
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (скидка %d%%)"
L["RESTOCKER_REPUTATION_ANY"] = "Любая"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Дружелюбие"
L["RESTOCKER_REPUTATION_HONORED"] = "Уважение"
L["RESTOCKER_REPUTATION_REVERED"] = "Почтение"
L["RESTOCKER_REPUTATION_EXALTED"] = "Превознесение"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Требуемая репутация у торговца"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	"Покупать только у торговцев, с которыми у вас не ниже этой репутации."
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Более высокая репутация также означает более низкие цены (Дружелюбие 5%, Уважение 10%, Почтение 15%, Превознесение 20%)."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Щёлкните, чтобы выбрать репутацию."
