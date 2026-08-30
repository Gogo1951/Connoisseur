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
-- Readiness Report
--------------------------------------------------------------------------------

--[[
    Printed when a ready check starts, as a header plus up to three lines. Each
    line is a set of "Label : a, b, c" clauses joined by ". ", and every part of
    it is dropped when it has nothing to say -- a clean character prints nothing
    at all, so there is no all-clear string here and must not be one.
]]

L["READINESS_TITLE"] = "Отчёт о готовности"

-- Clause labels, in the order the lines print them.
L["READINESS_MISSING_BUFFS"] = "Не хватает баффов:"
L["READINESS_EXPIRING"] = "Скоро истекает:"
L["READINESS_MISSING_ITEMS"] = "Не хватает предметов:"
L["READINESS_DAMAGED_GEAR"] = "Повреждённое снаряжение:"
L["READINESS_CHARACTER"] = "Персонаж:"
L["READINESS_QUESTIONABLE_GEAR"] = "Надето небоевое снаряжение:"

--[[
    What the report calls each thing. Deliberately its own set rather than the
    shared LABEL_* keys the macro messages use: those name an item you are being
    offered ("Health Potion"), these name a gap in your preparation ("Healing
    Potion"), and the two want to be reworded independently.
]]
L["READINESS_FLASK"] = "Настой или 2 эликсира"
L["READINESS_WELL_FED"] = "Сытость"
L["READINESS_PET_WELL_FED"] = "Сытость (питомец)"
L["READINESS_SCROLLS"] = "Свитки"
L["READINESS_SOULSTONE"] = "Камень души не активен"
L["READINESS_MAIN_HAND"] = "Правая рука"
L["READINESS_OFF_HAND"] = "Левая рука"
L["READINESS_HEALTHSTONE"] = "Камень здоровья"
L["READINESS_MANA_GEM"] = "Мана-камень"
L["READINESS_HEALING_POTION"] = "Лечебное зелье"
L["READINESS_MANA_POTION"] = "Зелье маны"
L["READINESS_BANDAGES"] = "Бинты"
L["READINESS_PVP_ON"] = "PvP включён!"

-- { buff name, whole minutes left }
L["READINESS_TIME_MINUTES"] = "%s %d мин"
-- %s is the buff name; used when under a minute is left.
L["READINESS_TIME_EXPIRING"] = "%s меньше 1 мин"
-- { dominant talent tree, slash-joined point spread }
L["READINESS_SPEC_FORMAT"] = "%s (%s)"
-- %d is the number of talent points the character has not spent.
L["READINESS_UNSPENT_TALENTS"] = "Нераспределённых очков талантов: %d"

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
    One per macro type (resolved via ns.MacroConfig in ConnNoItem), plus Pet Food.
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
L["OPTIONS_READINESS_HEADER"] = "Отчёт о готовности"
L["OPTIONS_READINESS_ENABLE"] =
	"Включить отчёт о готовности при проверке готовности"
--[[
    Says what the report does AND that it stays quiet, because the quiet is the
    feature: a player who turns this on and sees nothing for three pulls has to
    know that is the report working rather than the report broken.
]]
L["OPTIONS_READINESS_DESCRIPTION"] =
	"Когда начинается проверка готовности, выводит личный список того, что ещё нужно исправить. Видите его только вы, а когда вы готовы, он не пишет ничего."

--[[
    The reset button under the master toggle. It needs a control of its own
    because these settings are account-wide: the stock Reset Profile reaches
    only the character's own profile, so nothing else on any panel can return
    them to their defaults.

    The confirm names the one consequence a player would not otherwise predict.
    Off is what the report ships as, so resetting switches it back off, and a
    page that emptied itself with no warning would read as a bug.
]]
L["OPTIONS_READINESS_RESET"] = "Сбросить настройки отчёта о готовности"
L["OPTIONS_READINESS_RESET_DESCRIPTION"] =
	"Возвращает все переключатели на этой странице и оба порога к настройкам свежей установки. Другие страницы не затрагиваются."
L["OPTIONS_READINESS_RESET_CONFIRM"] =
	"Сбросить все настройки отчёта о готовности к значениям по умолчанию? Это также снова выключит сам отчёт."

--[[
    The three sections, each a real header over the switches it covers. They name
    what the line is called in chat, so the panel and the report read as the same
    feature.
]]
L["OPTIONS_READINESS_BUFFS_HEADER"] = "Не хватает баффов"
L["OPTIONS_READINESS_ITEMS_HEADER"] = "Не хватает предметов"
L["OPTIONS_READINESS_CHARACTER_HEADER"] = "Персонаж"

-- Missing Buffs
L["OPTIONS_READINESS_FLASK"] = "Настой или 2 эликсира"
L["OPTIONS_READINESS_FLASK_DESCRIPTION"] =
	"Засчитывает настой, либо один боевой и один защитный эликсир."
L["OPTIONS_READINESS_WELL_FED"] = "Сытость"
L["OPTIONS_READINESS_WELL_FED_DESCRIPTION"] =
	"Требуется включённая еда с эффектом в разделе Макросы."
L["OPTIONS_READINESS_PET_WELL_FED"] = "Сытость (питомец)"
L["OPTIONS_READINESS_PET_WELL_FED_DESCRIPTION"] =
	"Только для охотников. Требуются включённые баффы от еды для питомцев в разделе Макросы."
L["OPTIONS_READINESS_SCROLLS"] = "Баффы от свитков"
L["OPTIONS_READINESS_SCROLLS_DESCRIPTION"] =
	"По свиткам, которые вы выбрали использовать в разделе Макросы."
--[[
    The one entry that asks about the GROUP rather than the player's own bags,
    which the helper text has to say outright: a raid carrying seven unused
    stones is not covered, and one deployed stone covers it.
]]
L["OPTIONS_READINESS_SOULSTONE"] = "Камень души не активен"
L["OPTIONS_READINESS_SOULSTONE_DESCRIPTION"] =
	"Проверяет, что камень души активен на ком-то, а не лежит в сумке. Требуется чернокнижник в группе."
L["OPTIONS_READINESS_MAIN_HAND"] = "Бафф оружия (правая рука)"
L["OPTIONS_READINESS_OFF_HAND"] = "Бафф оружия (левая рука)"
L["OPTIONS_READINESS_WEAPON_DESCRIPTION"] =
	"Считается любое временное улучшение оружия: камень, масло, яд или шаманский бафф оружия."
--[[
    Says the Shaman exemption outright, because a main-hand line that goes quiet
    the moment a Shaman joins reads as a broken switch otherwise.
]]
L["OPTIONS_READINESS_MAIN_HAND_DESCRIPTION"] =
	"Считается любое временное улучшение оружия. Молчит, когда в группе есть шаман."
--[[
    Names the OTHER threshold so the two cannot be mistaken for each other: the
    Macros panel has one that decides when a macro treats a buff as spent, and
    this one only decides when the report mentions it.
]]
L["OPTIONS_READINESS_EXPIRING"] = "Баффы истекают в течение"
L["OPTIONS_READINESS_EXPIRING_DESCRIPTION"] =
	"Называет каждый бафф на вас, который скоро закончится, а не только наложенные Connoisseur. Не связано с обновлением баффов в разделе Макросы, которое решает, когда макрос предложит новый."
-- %s is a whole or half number of minutes.
L["OPTIONS_READINESS_EXPIRING_MINUTES"] = "%s мин."
-- The one-minute entry alone; one plural template cannot render it grammatically.
L["OPTIONS_READINESS_EXPIRING_MINUTES_ONE"] = "1 мин."

-- Missing Items
L["OPTIONS_READINESS_HEALTHSTONE"] = "Камень здоровья"
L["OPTIONS_READINESS_HEALTHSTONE_DESCRIPTION"] =
	"Показывается, только когда в группе есть чернокнижник, у которого можно попросить камень, или когда вы сами чернокнижник."
L["OPTIONS_READINESS_MANA_GEM"] = "Мана-камень"
L["OPTIONS_READINESS_MANA_GEM_DESCRIPTION"] = "Показывается только на маге."
L["OPTIONS_READINESS_HEALING_POTION"] = "Лечебное зелье"
L["OPTIONS_READINESS_HEALING_POTION_DESCRIPTION"] =
	"Лучше запастись до начала боя. Посреди боя зелье вам никто не передаст."
L["OPTIONS_READINESS_MANA_POTION"] = "Зелье маны"
L["OPTIONS_READINESS_MANA_POTION_DESCRIPTION"] =
	"Показывается только на классах, использующих ману."
L["OPTIONS_READINESS_BANDAGES"] = "Бинты"
L["OPTIONS_READINESS_BANDAGES_DESCRIPTION"] =
	"Сообщает, когда у вас нет ни одного пригодного бинта, с учётом навыка первой помощи."
L["OPTIONS_READINESS_DURABILITY"] = "Повреждённое снаряжение ниже"
L["OPTIONS_READINESS_DURABILITY_DESCRIPTION"] =
	"Приводит ссылку на каждый надетый предмет с прочностью ниже этой. Считается по каждому предмету, так что одно сломанное оружие всё равно видно."
-- %d is a durability percentage.
L["OPTIONS_READINESS_DURABILITY_PERCENT"] = "%d%%"

-- Character
L["OPTIONS_READINESS_SPEC"] = "Текущая специализация"
L["OPTIONS_READINESS_SPEC_DESCRIPTION"] =
	"Выводит распределение талантов и очки, которые вы ещё не потратили."
L["OPTIONS_READINESS_PVP"] = "Включён режим PvP"
L["OPTIONS_READINESS_PVP_DESCRIPTION"] =
	"Предупреждает, когда у вас включён режим PvP."
L["OPTIONS_READINESS_QUESTIONABLE_GEAR"] = "Надето небоевое снаряжение"
L["OPTIONS_READINESS_QUESTIONABLE_GEAR_DESCRIPTION"] =
	"Приводит ссылки на надетые предметы, которым не место в бою, например PvP-аксессуар или удочку."

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
    Ignore List panel (Options-Ignore-List.lua). One tree scope per list: the
    account-wide Global list, then one per character. The rows are items, so
    the copy here is the panel description, the scope and promote labels, the
    add box, and the placeholder shown while the client is still resolving an
    item's name. The mini-map tooltip's section keeps its own UI_IGNORE_LIST
    and MENU_CLEAR_IGNORE keys.
]]
L["OPTIONS_IGNORE_LIST_TAB"] = "Список игнорирования"
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Игнорируемые предметы никогда не выбираются ни одним макросом. Еда, вода, зелья, что угодно. Общий список действует для всех персонажей, а список персонажа только для него. Щёлкните правой кнопкой по значку у миникарты, чтобы игнорировать текущую лучшую еду."
L["OPTIONS_IGNORE_GLOBAL"] = "Общий"
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Переносит предмет в общий список, чтобы он игнорировался у всех персонажей."
L["OPTIONS_IGNORE_ADD_ID"] = "Добавить по ID предмета"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Введите ID предмета или сделайте Shift + Клик по ссылке на предмет в чате, пока это поле активно."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] =
	"Введите ID предмета или сделайте Shift + Клик по ссылке на предмет в чате."
L["OPTIONS_IGNORE_REMOVE"] = "Убрать"
L["OPTIONS_IGNORE_EMPTY"] = "Список пуст."
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
    The Starter List Builder pop-up. This toggle and the pop-up's own "Don't
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

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "Окно пополнения"

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
L["RESTOCKER_PROFILE_EXISTS"] = 'Список с именем "%s" уже существует.'
L["RESTOCKER_BANK_NOT_OPEN"] = "Банк не открыт."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (ns.OnRestockerBankOpen), not stored as a preference.
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
--[[
    Printed once per vendor visit when the crafting-reagent buyer stands down:
    this merchant stocks some of the reagents the Restock List needs but not
    all of them, and reagents buy all-or-nothing (VendorStocksAllReagents in
    Features/Restocker/Restocker-Merchant.lua). Silent at vendors stocking none.
]]
L["RESTOCKER_REAGENTS_SKIPPED"] =
	"У этого торговца есть не все ингредиенты, необходимые для ваших ядов. Ничего куплено не будет."
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

    The claim has to be earned, which is why the merchant restock's PurchaseMerchantItem
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
L["RESTOCKER_HELP_PROFILE_ADD"] = "Добавляет список с этим именем."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Удаляет список с этим именем."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Переименовывает текущий список в это имя."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Копирует этот список в текущий список."
L["RESTOCKER_HELP_PROFILE_USE"] = "Переключает активный список на это имя."

--[[
    Starter List pop-up: the login window that offers vendor staples when the
    Restock List is empty (Features/Restocker/Restocker-Starter-List.lua). Its title
    reuses RESTOCKER_WINDOW_TITLE below, and the six food staples reuse the
    DIET_ keys above, so the popup names bread whatever the pet-food tooltips
    call it.

    The intro is three short paragraphs: why the window opened, what a tick
    does, and the way back in. Joined with blank lines at the call site, so
    each reads as its own breath rather than one wall.
]]
L["STARTER_POPUP_INTRO_EMPTY"] =
	"Ваш список пополнения пуст, так что давайте добавим несколько предметов для начала."
-- Shown instead when the window is opened over a list that already has items on it.
L["STARTER_POPUP_INTRO_STOCKED"] =
	"Выберите припасы, которые нужно держать в запасе. То, что уже есть в вашем списке пополнения, отмечено."
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
	"%s : Добавьте готовый яд в список, и Connoisseur автоматически купит ингредиенты у любого торговца, который продает их все."
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
L["RESTOCKER_FILTER_CLEAR_TOOLTIP"] = "Очистить"
L["RESTOCKER_ADD_BUTTON"] = "Добавить"
L["RESTOCKER_LIST_BUILDER_BUTTON"] = "Открыть мастер списка"
L["RESTOCKER_LIST_BUILDER_TOOLTIP"] =
	"Открывает мастер списка с тем же набором припасов, который предлагается новому персонажу. Это окно закрывается, пока он открыт."
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Добавить предмет"
L["RESTOCKER_ADD_TOOLTIP_BODY"] =
	"Перетащите предмет из сумки или введите числовой ID предмета."
--[[
    In-box placeholder for the add row; the tooltip above carries the detail.
    Kept to a phrase rather than a sentence: it sets the width of both boxes on
    that row, and the row cannot afford two fields wide enough for a long one.
]]
L["RESTOCKER_ADD_PLACEHOLDER"] = "Перетащите сюда предмет или введите ID"
L["RESTOCKER_PROFILE_LABEL"] = "Список"
L["RESTOCKER_PROFILE_TOOLTIP"] =
	"Список пополнения, который использует этот персонаж. Нажмите, чтобы переключиться на другой или начать новый."
L["RESTOCKER_RENAME_LABEL"] = "Переименовать"
L["RESTOCKER_NEW_PROFILE"] = "Новый список"
L["RESTOCKER_COPY_PROFILE"] = "Копировать"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in ns.SetupRestockerTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Клонирует этот список в новый"
-- %s becomes "<list name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s (копия)"
L["RESTOCKER_DELETE_PROFILE"] = "Удалить"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Удаляет этот список"
L["RESTOCKER_RENAME_TOOLTIP"] =
	"Переименовывает этот список. Все персонажи, использующие его, следуют новому имени."
-- %s is the list name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"Вы уверены, что хотите удалить этот список?|n|n%s|n|nЭто нельзя отменить."
--[[
    The Upgrade toggle. One string serves both the column heading and every
    row's checkbox, so it has to read for a single item and for the whole
    column at once -- which is why it names categories rather than "this item".

    The categories are exactly the ladder kinds in
    Data/Consumable-Upgrade-Paths.lua: food, water, arrow and bullet, poison,
    healing and mana potion, and the class reagents. Naming anything else here
    promises an upgrade that never arrives, since the toggle is disabled on any
    item that is not on a ladder -- which on a real list is most of them.
]]
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

--[[
    Column headings over the list.

    Keep these SHORT. A heading sets its column's width, and every pixel a
    heading takes comes out of the item name beside it. Six full-length
    headings do not fit beside a readable name at the smallest window size.

    "Take" and "Store" are short because they never appear alone: both sit
    under a "Bank" band, which is what makes them exact. Translate them as a
    pair with that band in mind, and keep them a single short word each.
]]
L["RESTOCKER_COLUMN_ITEM"] = "Предмет"
L["RESTOCKER_COLUMN_WITHDRAW"] = "Взять"
L["RESTOCKER_COLUMN_DEPOSIT"] = "Сложить"
L["RESTOCKER_COLUMN_REPUTATION"] = "Реп."
L["RESTOCKER_COLUMN_AMOUNT"] = "Кол-во"

L["RESTOCKER_GROUP_OTHER"] = "Прочее"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "Новые"
--[[
    The category pane's first entry, above the item types. Selected by default,
    and the only way back to the whole list once a type has been picked, so it
    has to read as "everything" rather than as another type.
]]
L["RESTOCKER_GROUP_ALL"] = "Все предметы"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "Убирает этот предмет из списка пополнения"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "Количество для пополнения"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "Нажмите Enter, когда закончите."
L["RESTOCKER_BUY_LABEL"] = "Купить"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "Покупать у торговца"
L["RESTOCKER_BUY_TOOLTIP_BODY"] =
	"Покупает нужное количество, когда открыто окно торговца."

--[[
    Some vendor slots hold only a few units and trickle back over time, which is
    how Classic sells its scarce consumables. Extra empties those slots outright
    rather than buying the shortfall, so the tooltip has to say three things: what
    it buys, that unlimited stock is never touched, and why anyone would want it.
]]
L["RESTOCKER_EXTRA_LABEL"] = "Сверх"
L["RESTOCKER_EXTRA_TOOLTIP_TITLE"] = "Покупать сверх нормы"
L["RESTOCKER_EXTRA_TOOLTIP_STOCK"] =
	"Выкупает у торговца весь запас этого предмета, даже сверх вашего целевого количества."
L["RESTOCKER_EXTRA_TOOLTIP_LIMITED"] =
	"Действует только на ограниченный товар, который торговец понемногу пополняет. Неограниченный запас не учитывается."
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "Складывать в банк"
--[[
    Names the Amount column, so it is coupled to RESTOCKER_COLUMN_AMOUNT: a locale
    that renders that heading differently has to say the same word here, or the
    sentence points at a column the player cannot find.
]]
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"Складывает лишние предметы в банк, когда он открыт. Укажите 0, чтобы сложить всё."
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

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Требуемая репутация у торговца"
--[[
    Quotes the cell's own value, which couples this line to
    RESTOCKER_REPUTATION_ANY: a locale that renders that standing differently
    has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'Выберите уровень репутации, и Connoisseur пропустит торговцев, с которыми вы его не достигли. "Реп.: Любая" покупает у любого торговца.'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Репутация также снижает цену: Дружелюбие 5%, Уважение 10%, Почтение 15%, Превознесение 20%."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Нажмите, чтобы изменить."
