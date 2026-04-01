local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "ruRU")
if not L then return end

-- [[ RUSSIAN (ruRU) ]] --
L["BRAND"] = "Connoisseur"

-- Macro Names Can't Exceed 16 Total Characters
L["MACRO_BANDAGE"] = "- Бинты"
L["MACRO_FOOD"]    = "- Еда"
L["MACRO_HPOT"]    = "- Леч. зелье"
L["MACRO_HS"]      = "- Кам. здоровья"
L["MACRO_MGEM"]    = "- Мана-камень"
L["MACRO_MPOT"]    = "- Зелье маны"
L["MACRO_SS"]      = "- Кам. души"
L["MACRO_WATER"]   = "- Вода"
L["MACRO_FEED_PET"]= "- Корм. питомца"

L["ERR_ZONE"] = "Вы не можете использовать это здесь."
L["RANK"]     = "Уровень"

L["MSG_BUG_REPORT"] = "Похоже, вы нашли ошибку! %s (%s) нельзя использовать в %s > %s (%s). Пожалуйста, сообщите об этом, чтобы мы могли исправить. Спасибо! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"]    = "Подходящий %s не найден в сумках."

L["MENU_BUFF_FOOD"]      = "Еда с баффами"
L["MENU_BUFF_FOOD_DESC"] = "Приоритет еды, дающей эффект \"Сытость\", если он отсутствует."
L["MENU_CLEAR_IGNORE"]   = "Очистить игнор-лист"
L["MENU_IGNORE"]         = "Игнорировать"
L["MENU_RESET"]          = "Сброс"
L["MENU_SCAN"]           = "Сканировать"
L["MENU_TITLE"]          = "Расходники"

L["MENU_SCROLL_BUFFS"]      = "Баффы от свитков"
L["MENU_SCROLL_BUFFS_DESC"] = "Использует свитки характеристик как часть макроса еды, если бафф от свитка отсутствует."
L["MENU_OPTIONS_HINT"]      = "Дополнительные настройки доступны в Настройки > Модификации > Connoisseur."

L["PREFIX_HUNTER"]  = "Внимание Охотники"
L["PREFIX_MAGE"]    = "Внимание Маги"
L["PREFIX_WARLOCK"] = "Внимание Чернокнижники"

L["TIP_DOWNRANK"]        = "Выбор игрока низкого уровня создаст предметы, подходящие для его уровня."
L["TIP_HUNTER_FEED_PET"] = "Кормление питомца — это универсальная кнопка! Нажмите, чтобы автоматически призвать, покормить или воскресить питомца. Кликните правой кнопкой мыши или используйте в бою для Лечения питомца. Удерживайте Shift для принудительного Воскрешения, или Ctrl, чтобы Прогнать."
L["TIP_MAGE_CONJURE"]    = "Правый клик по макросу Еды или Воды для сотворения."
L["TIP_MAGE_GEM"]        = "Правый клик по макросу Мана-камня для сотворения нового камня. Повторный правый клик для сотворения камня низшего ранга в качестве запасного."
L["TIP_MAGE_TABLE"]      = "Средний клик для сотворения Ритуала подкрепления."
L["TIP_WARLOCK_CONJURE"] = "Правый клик по макросу Камня здоровья или Камня души для сотворения."
L["TIP_WARLOCK_SOUL"]    = "Средний клик для сотворения Ритуала душ."

L["UI_BEST_FOOD"]    = "Лучшая еда"
L["UI_BEST_PET_FOOD"]= "Еда для питомца"
L["UI_DISABLED"]     = "Отключено"
L["UI_ENABLED"]      = "Включено"
L["UI_IGNORE_LIST"]  = "Список игнорирования"
L["UI_LEFT_CLICK"]   = "ЛКМ"
L["UI_MIDDLE_CLICK"] = "СКМ"
L["UI_RIGHT_CLICK"]  = "ПКМ"
L["UI_SHIFT_LEFT"]   = "Shift + ЛКМ"
L["UI_TOGGLE"]       = "Переключить"

-- Options Panel
L["OPTIONS_DESC"]              = "Создает макросы для использования лучшей еды, воды, зелий, камней здоровья, камней душ, мана-камней или бинтов, доступных вам."
L["OPTIONS_BUFF_FOOD"]         = "Еда с баффами"
L["OPTIONS_BUFF_FOOD_DESC"]    = "Приоритет еды, дающей эффект \"Сытость\", если он отсутствует."
L["OPTIONS_SCROLL_HEADER"]     = "Баффы от свитков"
L["OPTIONS_USE_SCROLLS"]       = "Включить баффы от свитков"
L["OPTIONS_USE_SCROLLS_DESC"]  = "Использует свитки, если бафф от свитка отсутствует, как часть макроса еды."
L["OPTIONS_SCROLL_TYPES"]      = "Включить типы свитков в проверку"
L["OPTIONS_SCROLL_AGILITY"]    = "Ловкость"
L["OPTIONS_SCROLL_INTELLECT"]  = "Интеллект"
L["OPTIONS_SCROLL_PROTECTION"] = "Защита"
L["OPTIONS_SCROLL_SPIRIT"]     = "Дух"
L["OPTIONS_SCROLL_STAMINA"]    = "Выносливость"
L["OPTIONS_SCROLL_STRENGTH"]   = "Сила"

L["OPTIONS_PET_HEADER"]        = "Баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS"]     = "Использовать баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS_DESC"]= "Использует еду для питомца как часть макроса еды, если у питомца отсутствует бафф \"Сытость\"."
L["OPTIONS_PET_BUFF_TYPES"]    = "Включить типы еды для питомцев в проверку"
L["OPTIONS_PET_BUFF_KIBLERS"]  = "Кусочки Киблера"
L["OPTIONS_PET_BUFF_SPORELING"]= "Закуска из спор"

L["OPTIONS_NIGHTELF_HEADER"]           = "Ночные эльфы"
L["OPTIONS_SHADOWMELD_DRINKING"]      = "Питье со Слиться с тенью"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Добавляет способность «Слиться с тенью» в макрос воды, чтобы вы уходили в незаметность во время питья."

L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"]   = "/foodie"

L["OPTIONS_RESET_HEADER"]      = "Сброс"
L["OPTIONS_RESET_IGNORE_DESC"] = "Удалить все предметы из списка игнорирования."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Вы уверены, что хотите очистить список игнорирования?"
L["OPTIONS_COMMUNITY_HEADER"]  = "Обратная связь и поддержка"