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
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] =
	"В данный момент у вас нет подходящей еды для питомца."
L["TIP_PET_NO_SKILLS"] =
	"В данный момент вы не знаете способности Кормление питомца, Лечение питомца или Воскрешение питомца."
L["TIP_PET_NO_MEND"] =
	"В данный момент вы не знаете способность Лечение питомца."
L["TIP_NO_HAND_POISON"] = "Выбранный яд для этого оружия закончился."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "В данный момент вы не знаете способность %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["MENU_BUFF_FOOD_DESCRIPTION"] =
	'Приоритет еды, дающей эффект "Сытость", если он отсутствует.'
L["MENU_SCROLL_BUFFS"] = "Баффы от свитков"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Превращает ваш макрос Еды в аппликатор свитков, когда вам не хватает баффов от свитков."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Еда"
L["UI_BEST_PET_FOOD"] = "Еда для питомца"
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

L["TIP_DOWNRANK"] =
	"Выбор игрока низкого уровня создаст предметы, подходящие для его уровня."
L["TIP_HUNTER_FEED_PET"] =
	"Кормление питомца: универсальная кнопка для вашего питомца! Нажмите, чтобы автоматически призвать, покормить или воскресить питомца. Кликните правой кнопкой мыши или дождитесь боя для Лечения питомца. Удерживайте Shift для принудительного Воскрешения, или Ctrl, чтобы Прогнать."
L["TIP_MAGE_CONJURE"] = "Правый клик по макросу Еды или Воды для сотворения."
L["TIP_MAGE_GEM"] =
	"Правый клик по макросу Мана-камня для сотворения нового камня. Повторный правый клик для сотворения камня низшего ранга в качестве запасного."
L["TIP_MAGE_TABLE"] = "Средний клик для сотворения Ритуала подкрепления."
L["TIP_WARLOCK_CONJURE"] =
	"Правый клик по макросу Камня здоровья или Камня души для сотворения. Повторный правый клик по макросу Камня здоровья для сотворения камня низшего ранга в качестве запасного."
L["TIP_WARLOCK_SOUL"] = "Средний клик для сотворения Ритуала душ."
L["TIP_ROGUE_POISONS"] =
	"Левый клик наносит яд для левой руки, правый клик наносит яд для правой руки; нанесённые яды заменяются автоматически. Средний клик открывает окно ядов."

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
L["MODE_PARTY"] = "Только в группе"
L["MODE_RAID"] = "Только в рейде"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Автоматически обновляемые макросы для вашей лучшей еды, еды с баффами, воды, свитков, лечебных зелий и зелий маны, камней здоровья, камней души, мана-камней и бинтов. Сотворение в один клик для Магов и Чернокнижников, умное Кормление питомца для Охотников. Оптимальное питание, пиковая эффективность."

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

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "Еда с эффектом"
L["OPTIONS_BUFF_FOOD"] = "Еда с баффами"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'Приоритет еды, дающей эффект "Сытость", если он отсутствует.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Совет профи: Выбор себя в качестве цели всегда заставляет макрос еды пропускать еду с баффами и свитки."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Баффы от свитков"
L["OPTIONS_USE_SCROLLS"] = "Включить баффы от свитков"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Превращает ваш макрос Еды в специальный аппликатор свитков всякий раз, когда вам не хватает баффов от свитков. Нажмите один раз, чтобы применить свитки; нажмите еще раз, чтобы поесть. Свитки не зависят от ГКД, применяются к вам, и макрос возвращается к еде в тот момент, когда вы берете в цель другого дружественного игрока."
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
L["EXPLOSIVES_MODE_ATPLAYER"] = "ЛКМ @Player, ПКМ Бросок"
L["EXPLOSIVES_MODE_TOSS"] = "ЛКМ Бросок, ПКМ @Player"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS"] = "Использовать баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Использует еду для питомца как часть макроса еды, если у питомца отсутствует бафф "Сытость".'
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
L["OPTIONS_SHADOWMELD_DRINKING"] = "Питье со Слиться с тенью"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] =
	'Добавляет способность "Слиться с тенью" в макрос воды, чтобы вы уходили в незаметность во время питья.'

-- Rogues
L["OPTIONS_POISONS_HEADER"] = "Яды"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Держит макрос ядов заряженным лучшим доступным рангом каждого типа яда: левый клик наносит на левую руку, правый клик наносит на правую, а нанесённые яды заменяются автоматически."
L["OPTIONS_POISON_MAIN_HAND"] = "Правая рука"
L["OPTIONS_POISON_OFF_HAND"] = "Левая рука"

-- Restocker
L["OPTIONS_RESTOCKER_HEADER"] = "Restocker"
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

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_FOODIE"] = "/foodie"
L["OPTIONS_COMMANDS_FOODIE_DETAIL"] = "Открывает интерфейс настроек Connoisseur."
L["OPTIONS_COMMANDS_CRS"] = "/crs"
L["OPTIONS_COMMANDS_CRS_DETAIL"] =
	"Открывает окно Restocker для управления списком пополнения."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Включить макросы"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Выбор макросов, которые Connoisseur создает и поддерживает. Отключение макроса также удалит его."

-- Ignore List
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] =
	"Удалить все предметы из списка игнорирования."
L["OPTIONS_RESET_IGNORE_CONFIRM"] =
	"Вы уверены, что хотите очистить список игнорирования?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Обратная связь и поддержка"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "Ваши списки Restocker импортированы."
L["RESTOCKER_PROFILE_EXISTS"] = 'Профиль с именем "%s" уже существует.'
L["RESTOCKER_BANK_NOT_OPEN"] = "Банк не открыт."
-- %s is the /crs slash command, colored at the call site.
L["RESTOCKER_COMPLETE"] =
	"Пополнение завершено. Удерживайте Shift, чтобы пропустить в следующий раз. Введите %s, чтобы изменить список пополнения."
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
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Щёлкните, чтобы выбрать репутацию"
