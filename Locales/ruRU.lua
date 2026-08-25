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
	"Похоже, вы нашли ошибку! %s (%s) нельзя использовать в %s > %s (%s). Пожалуйста, сообщите об этом, чтобы мы могли исправить. Спасибо! %s"
L["MSG_NO_ITEM"] = "Подходящий %s не найден в сумках."
L["MSG_MACRO_SLOTS_FULL"] =
	"Некоторые макросы Connoisseur не удалось создать, так как ячейки макросов заполнены. Освободите место, удалив макросы, которые вы больше не используете, или отключите ненужные макросы Connoisseur в меню Настройки > Модификации > Connoisseur."

L["CHAT_LOADED"] =
	"Версия %s. Настройки (включая возможность отключения этого сообщения) находятся в Настройки > Модификации > Connoisseur. Нравится аддон? Расскажите другу! (="

L["CHAT_OPTIONS_IN_COMBAT"] =
	"В целях безопасности интерфейс настроек нельзя открыть в бою."

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "Всё готово!"
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

-- Feature toggles shown in the mini-map tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "Еда с эффектом"
L["MENU_BUFF_FOOD_DESCRIPTION"] =
	'Приоритет еды, дающей эффект "Сытость", если он отсутствует.'
L["FEATURE_SCROLL_BUFFS"] = "Баффы от свитков"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Превращает ваш макрос Еды в аппликатор свитков, когда вам не хватает баффов от свитков."

-- Section titles and ignore-list actions in the mini-map tooltip.
L["UI_BEST_FOOD"] = "Текущая еда"
L["UI_BEST_PET_FOOD"] = "Текущая еда для питомца"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "Правая рука"
L["UI_OFF_HAND"] = "Левая рука"
--[[
    The value shown beside an item title when nothing resolved. Kept to a single
    word so it fits in the tooltip's right column, which never wraps -- the full
    sentence, MSG_NO_ITEM, explains it on the wrapping line underneath.
]]
L["UI_NONE"] = "Нет"
L["UI_IGNORE_LIST"] = "Список игнорирования"
L["MENU_IGNORE"] = "Игнорировать"
L["MENU_CLEAR_IGNORE"] = "Очистить игнор-лист"

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
L["UI_RESTOCKER_REPORT"] = "Отчёт о пополнении"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 невыполненный заказ"
L["UI_RESTOCKER_NEEDED"] = "Невыполненных заказов: %d"
L["UI_RESTOCKER_STOCKED_SHORT"] = "Запасы пополнены"
L["UI_RESTOCKER_STOCKED"] = "Поздравляем, запасы полностью пополнены!"

-- Options entry at the bottom of the mini-map tooltip.
L["MENU_OPTIONS"] = "Настройки Connoisseur"
L["MENU_OPTIONS_KEYBIND"] = "Shift + СКМ"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

--[[
    Class-colored headers and conjure/pet tips shown in the mini-map tooltip for
    the player's class.
]]

L["PREFIX_HUNTER"] = "Внимание Охотники"
L["PREFIX_MAGE"] = "Внимание Маги"
L["PREFIX_ROGUE"] = "Внимание Разбойники"
L["PREFIX_WARLOCK"] = "Внимание Чернокнижники"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to -- the blocks cover more than one macro,
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

--[[
    Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
    One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
]]

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

-- Generic labels reused across the mini-map tooltip and options panel.

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
	"Макросы, которые автоматически используют вашу лучшую еду, еду с эффектом, воду, зелья, камни здоровья, бинты и свитки, а также список пополнения, который держит сумки полными и повышает уровень ваших расходуемых предметов вместе с вашим. Автоматизация для удобства, пиковая эффективность."

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
	"Показывает текст названия макроса на кнопках панели команд. По умолчанию выключено, что скрывает названия, которые игра показывает сама по себе."

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
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "Когда осталось < 1 минуты"
L["REAPPLY_THRESHOLD_N"] = "Когда осталось < %d минут"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "Проверка готовности"
L["OPTIONS_READY_CHECK"] = "Сообщать о готовности при проверке"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"При каждой проверке готовности выводит, чего вам не хватает и сколько времени осталось у отслеживаемых баффов; видно только вам."

--[[
    Three features are suppressed in a PvP Arena, and each says so with the
    same sentence. It lives here once and is appended at the call site
    (Options/Options-Macros.lua), so every locale translates it a single time
    and the caveat can never drift between the three.
]]
L["OPTIONS_DISABLED_IN_ARENAS"] = "Отключено на аренах."

--[[
    Buff Food. The section header reuses FEATURE_BUFF_FOOD, and the options
    description reuses MENU_BUFF_FOOD_DESCRIPTION plus the arena note above --
    the mini-map tooltip and the options panel say the same thing, so they read
    from one key rather than two copies of one sentence.
]]
L["OPTIONS_BUFF_FOOD"] = "Еда с баффами"
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Совет профи: Выбор себя в качестве цели всегда заставляет макрос еды пропускать еду с баффами и свитки."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "Включить баффы от свитков"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Нажмите один раз, чтобы применить недостающие свитки, и ещё раз, чтобы поесть. Свитки не зависят от ГКД и применяются к вам; если целью выбран дружественный игрок, они пропускаются."
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

--[[
    Ignore List. The rows are items, so the only copy here is the add box and
    the placeholder shown while the client is still resolving an item's name.
    The section header and the clear-all button reuse UI_IGNORE_LIST and
    MENU_CLEAR_IGNORE, which the mini-map tooltip already carries.
]]
L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Предметы, которые Connoisseur никогда не выберет, какими бы хорошими они ни были. Щёлкните правой кнопкой по значку у миникарты, чтобы игнорировать предлагаемую сейчас еду, или добавьте предмет ниже."
L["OPTIONS_IGNORE_ADD_ID"] = "Добавить по ID предмета"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Введите ID предмета или сделайте Shift + Клик по ссылке на предмет в чате, пока это поле активно."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] =
	"Введите ID предмета или сделайте Shift + Клик по ссылке на предмет в чате."
L["OPTIONS_IGNORE_REMOVE"] = "Убрать"
L["OPTIONS_IGNORE_EMPTY"] = "Список пуст."
L["OPTIONS_IGNORE_CLEAR_CONFIRM"] = "Убрать все предметы из списка игнорирования?"
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "Загрузка ID: %d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS"] = "Использовать баффы от еды для питомцев"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Добавляет еду для питомца в макрос еды, если у питомца отсутствует бафф "Сытость".'
L["OPTIONS_PET_BUFF_TYPES"] = "Включить типы еды для питомцев в проверку"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Кусочки Киблера"
L["OPTIONS_PET_BUFF_SPORELING"] = "Закуска из спор"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Друиды"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Включить интеграцию DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Создает макросы смены облика для лечебных зелий, зелий маны и камней здоровья с помощью DruidMacroHelper (/dmh)."
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "Вернуться в облик медведя"
L["DRUID_FORM_CAT"] = "Вернуться в облик кошки"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Ночные эльфы"
L["OPTIONS_STEALTH_DRINKING"] = "Включить незаметность при питье"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] =
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

--[[
    Restocker options panel. The tree label stays "Restocker" in every locale
    (brand fragment, localization allowlist); the panel header reuses
    RESTOCKER_WINDOW_TITLE.
]]
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Пополняет сумки по списку пополнения для каждого персонажа. Автоматически покупает у торговцев и перемещает предметы между сумками и банком. Введите %s, чтобы открыть список."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Открывать в банке"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] =
	"Открывает окно Restocker при посещении банка."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Открывать у торговца"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] =
	"Открывает окно Restocker при посещении торговца."
L["OPTIONS_RESTOCKER_REMIND"] = "Включить напоминания о пополнении в городе"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"Выводит напоминание в чат, когда в списке пополнения чего-то не хватает и вы добираетесь до таверны или города либо уже находитесь в них при входе в игру."
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] =
	"Включить напоминания о пополнении у торговца"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"Сообщает о невыполненных заказах на пополнение, когда вы закрываете окно торговца. Молчит, если таких нет."
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "Включить напоминания о пополнении в банке"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"Сообщает о невыполненных заказах на пополнение, когда вы закрываете банк. Молчит, если таких нет."

--[[
    The starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] =
	"Включить помощник списка, когда список пополнения пуст"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"Предлагает начальный список пополнения при входе, если у этого персонажа он пуст."

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "Кратко"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "Подробно"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "Проигрывать звук"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] =
	"Проигрывает сигнал вместе с напоминанием, когда в чате оживлённо."
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "Нажмите, чтобы прослушать сигнал."
L["OPTIONS_RESTOCKER_DEBUG"] = "Включить отладочные сообщения Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Выводит в чат пошаговые решения Restocker при пополнении из банка и у торговца. Многословно; остаётся включённым между сеансами, пока не выключить."

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "Окно пополнения"
L["OPTIONS_RESTOCKER_ADVANCED_HEADER"] = "Дополнительно"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "Благодарности"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"Я всегда любил Restocker и рад, что он продолжает жить внутри Connoisseur. Огромное спасибо ChiliFajita, автору оригинального Auto Restocker, а также kvakvs и guardycmw, которые поддерживали его в Classic и Mists of Pandaria."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Открывает интерфейс настроек этого аддона."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] =
	"Открывает окно Restocker для управления списком пополнения."

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "Макросы"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur создаёт по одному макросу на каждый расходуемый предмет и обновляет его вслед за содержимым сумок, так что кнопка на панели всегда тянется к лучшему предмету, который у вас есть. Выберите ниже, какие макросы создавать, а затем настройте, как каждый из них выбирает предмет."
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Включить макросы"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Выбор макросов, которые Connoisseur создает и поддерживает. Отключение макроса также удалит его."

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "Обратная связь и поддержка"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "Версия"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
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
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "Не забудьте пополнить запасы, пока вы в городе!"

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
L["RESTOCKER_STILL_SHORT_ONE"] = "1 заказ на пополнение не выполнен."
L["RESTOCKER_STILL_SHORT_MANY"] = "Не выполнено заказов на пополнение: %d."

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, old amount, new link, new amount },
    outgoing tier on the left and incoming on the right.

    Both amounts are carried because they are not always equal: a swap onto a
    tier the list already holds merges the two rows, so the new amount is the
    sum rather than the old amount moved across.
]]
L["RESTOCKER_UPGRADED"] = "Ваш список пополнения обновлён."
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d заменено на %sx%d."

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
L["RESTOCKER_RESTOCKED_ONE"] = "1 заказ на пополнение выполнен."
L["RESTOCKER_RESTOCKED_MANY"] = "Выполнено заказов на пополнение: %d."

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "1 заказ на пополнение выполнен частично."
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] =
	"Частично выполнено заказов на пополнение: %d."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Показывает окно Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Добавляет профиль с этим именем."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Удаляет профиль с этим именем."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Переименовывает текущий профиль в это имя."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Копирует этот профиль в текущий."
L["RESTOCKER_HELP_PROFILE_USE"] = "Переключает активный профиль на это имя."

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
	"Ваш список пополнения пуст, так что давайте добавим несколько предметов для начала."
L["STARTER_POPUP_INTRO_HOW"] =
	"Всё, что вы отметите, пополняется автоматически при открытии торговца или банка, а базовые товары сами повышаются в ранге по мере роста уровня, так что у вас всегда будет лучшее из доступного."
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] =
	"Вы всегда можете изменить этот список или добавить предметы позже, введя %s."
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "Еда и вода"
L["STARTER_POPUP_FOOD_HEADER"] = "Еда"
L["STARTER_POPUP_AMMO_HEADER"] = "Боеприпасы"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "Пули"
L["STARTER_POPUP_ARROWS"] = "Стрелы"

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
L["STARTER_POPUP_REAGENTS_HEADER"] = "Реагенты и инструменты"
L["STARTER_POPUP_POISONS_HEADER"] = "Яды"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s : Добавьте готовый яд в список, и Connoisseur автоматически купит ингредиенты у любого торговца, который их продает."
L["STARTER_POPUP_POISON_ANESTHETIC"] = "Анестезия"
L["STARTER_POPUP_POISON_CRIPPLING"] = "Калечащий"
L["STARTER_POPUP_POISON_DEADLY"] = "Смертельный"
L["STARTER_POPUP_POISON_INSTANT"] = "Мгновенный"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "Отупляющий"
L["STARTER_POPUP_POISON_WOUND"] = "Ранящий"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "Камень возвращения"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "Ослепляющий порошок"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "Порошок вспышки"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "Воровские инструменты"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "Трупный прах"
L["STARTER_POPUP_REAGENT_WILDS"] = "Дикие ягоды"
L["STARTER_POPUP_REAGENT_SEEDS"] = "Семена"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "Чародейский порошок"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "Легкое перо"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "Руны телепортации"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "Руны порталов"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "Символ божественности"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "Символ королей"
L["STARTER_POPUP_REAGENT_CANDLES"] = "Свечи"
L["STARTER_POPUP_REAGENT_ANKH"] = "Анкх"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "Рыбья чешуя"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "Рыбий жир"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "Тотем земли"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "Тотем огня"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "Тотем воды"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "Тотем воздуха"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "Статуэтка"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "Камень инфернала"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "Осколки души"
--[[
    Checkbox tooltips: { item link, amount }. The first is for ladder items;
    the second for single-tier reagents, which never upgrade.
]]
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"Добавляет %s в список пополнения, держит %d в сумках и повышает ранг по мере роста уровня."
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] =
	"Добавляет %s в список пополнения и держит %d в сумках."
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 for food, water and poisons, 200 for ammo); the tooltip
    below carries the per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 стопка"
L["STARTER_POPUP_STACK_MANY"] = "Стопок: %d"
L["STARTER_POPUP_STACKS_DESCRIPTION"] =
	"Сколько стопок держать в запасе. Одна стопка здесь равна %d."
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] =
	"Сколько держать в запасе. Они не складываются в стопки, поэтому каждый занимает ячейку сумки."
L["STARTER_POPUP_DISMISS"] = "Больше не показывать для этого персонажа."
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"Иначе эти предложения будут появляться при каждом входе, когда список пополнения окажется пустым."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Фильтр предметов..."
L["RESTOCKER_ADD_BUTTON"] = "Добавить"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Добавить предмет"
L["RESTOCKER_ADD_TOOLTIP_BODY"] =
	"Перетащите предмет из сумки или введите числовой ID предмета."
-- In-box placeholder for the add row; the tooltip above carries the detail.
L["RESTOCKER_ADD_PLACEHOLDER"] = "Перетащите сюда предмет или введите его ID..."
L["RESTOCKER_PROFILE_LABEL"] = "Профиль:"
L["RESTOCKER_RENAME_LABEL"] = "Переименовать:"
L["RESTOCKER_NEW_PROFILE"] = "Новый профиль"
L["RESTOCKER_COPY_PROFILE"] = "Копировать"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in RS.SetupTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Клонирует этот профиль в новый"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s (копия)"
L["RESTOCKER_DELETE_PROFILE"] = "Удалить"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Удаляет этот профиль"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"Вы уверены, что хотите удалить этот профиль?|n|n%s|n|nЭто нельзя отменить."
--[[
    Row controls in the Restocker window. UPGRADE is disabled on any item that
    is not on a ladder in Data/Consumable-Upgrade-Paths.lua, which on a real
    list is most of them.
]]
L["RESTOCKER_UPGRADE_LABEL"] = "Автоулучшение"
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "Улучшать с ростом уровня"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"У еды, воды, боеприпасов и зелий есть чёткие ступени улучшения по мере роста уровня, поэтому Connoisseur поднимает этот предмет за вас. Всё остальное вы настраиваете сами со временем."

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "Банк"
L["RESTOCKER_ROW_MERCHANT"] = "Торговец"
L["RESTOCKER_ROW_UPGRADE"] = "Улучшение"

L["RESTOCKER_GROUP_OTHER"] = "Прочее"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "Новые"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "Убирает этот предмет из списка пополнения"
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
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (скидка %d%%)"
L["RESTOCKER_REPUTATION_ANY"] = "Любая"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Дружелюбие"
L["RESTOCKER_REPUTATION_HONORED"] = "Уважение"
L["RESTOCKER_REPUTATION_REVERED"] = "Почтение"
L["RESTOCKER_REPUTATION_EXALTED"] = "Превознесение"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]
L["RESTOCKER_REPUTATION_BUTTON_FORMAT"] = "Реп.: %s"

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Требуемая репутация у торговца"
--[[
    Quotes the button's own label. That couples this line to
    RESTOCKER_REPUTATION_BUTTON_FORMAT and RESTOCKER_REPUTATION_ANY -- a locale
    that renders the button differently has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'Выберите уровень репутации, и Connoisseur пропустит торговцев, с которыми вы его не достигли. "Реп.: Любая" покупает у любого торговца.'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Репутация также снижает цену: Дружелюбие 5%, Уважение 10%, Почтение 15%, Превознесение 20%."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Нажмите, чтобы изменить."
