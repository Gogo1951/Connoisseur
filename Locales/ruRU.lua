local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "ruRU")
if not L then return end

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
L["MACRO_FEED_PET"] = "- Корм. питомца"
L["MACRO_FOOD"] = "- Еда"
L["MACRO_HEALTH_POTION"] = "- Леч. зелье"
L["MACRO_HEALTHSTONE"] = "- Кам. здоровья"
L["MACRO_MANA_GEM"] = "- Мана-камень"
L["MACRO_MANA_POTION"] = "- Зелье маны"
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

L["MSG_BUG_REPORT"] = "Похоже, вы нашли ошибку! %s (%s) нельзя использовать в %s > %s (%s). Пожалуйста, сообщите об этом, чтобы мы могли исправить. Спасибо! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Подходящий %s не найден в сумках."
L["MSG_MACRO_SLOTS_FULL"] = "Некоторые макросы Connoisseur не удалось создать, так как ячейки макросов заполнены. Освободите место, удалив макросы, которые вы больше не используете, или отключите ненужные макросы Connoisseur в меню Настройки > Модификации > Connoisseur."

L["CHAT_LOADED"] = "Версия %s. Настройки (включая возможность отключения этого сообщения) находятся в Настройки > Модификации > Connoisseur. Нравится аддон? Расскажите другу! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Core.lua.

L["TIP_PET_NO_FOOD"] = "В данный момент у вас нет подходящей еды для питомца."
L["TIP_PET_NO_SKILLS"] = "В данный момент вы не знаете способности Кормление питомца, Лечение питомца или Воскрешение питомца."
L["TIP_PET_NO_MEND"] = "В данный момент вы не знаете способность Лечение питомца."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "В данный момент вы не знаете способность %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "Еда с баффами"
L["MENU_BUFF_FOOD_DESCRIPTION"] = "Приоритет еды, дающей эффект \"Сытость\", если он отсутствует."
L["MENU_CLEAR_IGNORE"] = "Очистить игнор-лист"
L["MENU_IGNORE"] = "Игнорировать"

L["MENU_SCROLL_BUFFS"] = "Баффы от свитков"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "Превращает ваш макрос Еды в аппликатор свитков, когда вам не хватает баффов от свитков."
L["MENU_OPTIONS_HINT"] = "Дополнительные настройки доступны в Настройки > Модификации > Connoisseur."

L["PREFIX_HUNTER"] = "Внимание Охотники"
L["PREFIX_MAGE"] = "Внимание Маги"
L["PREFIX_WARLOCK"] = "Внимание Чернокнижники"

L["TIP_DOWNRANK"] = "Выбор игрока низкого уровня создаст предметы, подходящие для его уровня."
L["TIP_HUNTER_FEED_PET"] = "Кормление питомца — это универсальная кнопка! Нажмите, чтобы автоматически призвать, покормить или воскресить питомца. Кликните правой кнопкой мыши или используйте в бою для Лечения питомца. Удерживайте Shift для принудительного Воскрешения, или Ctrl, чтобы Прогнать."
L["TIP_MAGE_CONJURE"] = "Правый клик по макросу Еды или Воды для сотворения."
L["TIP_MAGE_GEM"] = "Правый клик по макросу Мана-камня для сотворения нового камня. Повторный правый клик для сотворения камня низшего ранга в качестве запасного."
L["TIP_MAGE_TABLE"] = "Средний клик для сотворения Ритуала подкрепления."
L["TIP_WARLOCK_CONJURE"] = "Правый клик по макросу Камня здоровья или Камня души для сотворения. Повторный правый клик по макросу Камня здоровья для сотворения камня низшего ранга в качестве запасного."
L["TIP_WARLOCK_SOUL"] = "Средний клик для сотворения Ритуала душ."

L["UI_BEST_FOOD"] = "Еда"
L["UI_BEST_PET_FOOD"] = "Еда для питомца"

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
L["LABEL_BANDAGE"] = "Бинты"
L["LABEL_FOOD"] = "Еда"
L["LABEL_HEALTH_POTION"] = "Лечебное зелье"
L["LABEL_HEALTHSTONE"] = "Камень здоровья"
L["LABEL_MANA_GEM"] = "Мана-камень"
L["LABEL_MANA_POTION"] = "Зелье маны"
L["LABEL_PET_FOOD"] = "Еда для питомца"
L["LABEL_SOULSTONE"] = "Камень души"
L["LABEL_WATER"] = "Вода"
L["UI_DISABLED"] = "Отключено"
L["UI_ENABLED"] = "Включено"
L["UI_IGNORE_LIST"] = "Список игнорирования"
L["UI_LEFT_CLICK"] = "ЛКМ"
L["UI_MIDDLE_CLICK"] = "СКМ"
L["UI_RIGHT_CLICK"] = "ПКМ"
L["UI_SHIFT_LEFT"] = "Shift + ЛКМ"
L["UI_TOGGLE"] = "Переключить"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Всегда"
L["MODE_PARTY"] = "Только в группе"
L["MODE_RAID"] = "Только в рейде"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Автоматически обновляемые макросы для вашей лучшей еды, еды с баффами, воды, свитков, лечебных зелий и зелий маны, камней здоровья, камней души, мана-камней и бинтов. Сотворение в один клик для Магов и Чернокнижников, умное Кормление питомца для Охотников. Оптимальное питание, пиковая эффективность."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Включить приветственное сообщение"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Выводить приветственное сообщение в чат при входе в игру."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Включить кнопку у миникарты"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Показать кнопку у миникарты."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Зелья и Камни здоровья"
L["OPTIONS_POTIONS_DESCRIPTION"] = "Макросы не могут изменяться во время боя (это ограничение Blizzard), поэтому каждый макрос Зелья и Камня здоровья создается заранее с вашим лучшим предметом и до двух запасных вариантов. В затяжных боях иконка и подсказка могут устареть и показывать не тот предмет, но клик по макросу всегда будет использовать лучший предмет, который у вас действительно есть в сумках."

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "Еда с баффами"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = "Приоритет еды, дающей эффект \"Сытость\", если он отсутствует."
L["OPTIONS_BUFF_FOOD_DETAIL"] = "Совет профи: Выбор себя в качестве цели всегда заставляет макрос еды пропускать еду с баффами и свитки."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Баффы от свитков"
L["OPTIONS_USE_SCROLLS"] = "Включить баффы от свитков"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] = "Превращает ваш макрос Еды в специальный аппликатор свитков всякий раз, когда вам не хватает баффов от свитков. Нажмите один раз, чтобы применить свитки; нажмите еще раз, чтобы поесть. Свитки не зависят от ГКД, применяются к вам, и макрос возвращается к еде в тот момент, когда вы берете в цель другого дружественного игрока."
L["OPTIONS_SCROLL_TYPES"] = "Включить типы свитков в проверку"
L["OPTIONS_SCROLL_AGILITY"] = "Ловкость"
L["OPTIONS_SCROLL_INTELLECT"] = "Интеллект"
L["OPTIONS_SCROLL_PROTECTION"] = "Защита"
L["OPTIONS_SCROLL_SPIRIT"] = "Дух"
L["OPTIONS_SCROLL_STAMINA"] = "Выносливость"
L["OPTIONS_SCROLL_STRENGTH"] = "Сила"

-- Pets Food Buffs
L["OPTIONS_PET_HEADER"] = "Баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS"] = "Использовать баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] = "Использует еду для питомца как часть макроса еды, если у питомца отсутствует бафф \"Сытость\"."
L["OPTIONS_PET_BUFF_TYPES"] = "Включить типы еды для питомцев в проверку"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Кусочки Киблера"
L["OPTIONS_PET_BUFF_SPORELING"] = "Закуска из спор"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Друиды"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Включить интеграцию DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] = "Создает макросы смены облика для лечебных зелий, зелий маны и камней здоровья с помощью DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "После расходуемого предмета сменить на"
L["DRUID_FORM_BEAR"] = "Медведь"
L["DRUID_FORM_CAT"] = "Кошка"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Ночные эльфы"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Питье со Слиться с тенью"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] = "Добавляет способность «Слиться с тенью» в макрос воды, чтобы вы уходили в незаметность во время питья."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESCRIPTION"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Открывает интерфейс настроек Connoisseur."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Включить макросы"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] = "Выбор макросов, которые Connoisseur создает и поддерживает. Отключение макроса также удалит его."

-- Reset
L["OPTIONS_RESET_HEADER"] = "Сброс"
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "Удалить все предметы из списка игнорирования."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Вы уверены, что хотите очистить список игнорирования?"
L["OPTIONS_RESET_ALL"] = "Сбросить все настройки Connoisseur"
L["OPTIONS_RESET_ALL_DESCRIPTION"] = "Сбросить все настройки и список игнорирования по умолчанию."
L["OPTIONS_RESET_ALL_CONFIRM"] = "Сбросить все настройки Connoisseur по умолчанию?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Обратная связь и поддержка"