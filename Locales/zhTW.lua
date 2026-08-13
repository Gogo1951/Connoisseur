local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "zhTW")
if not L then
	return
end

-- [[ TRADITIONAL CHINESE (zhTW) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- 繃帶"
L["MACRO_EXPLOSIVES"] = "- 爆炸物"
L["MACRO_FEED_PET"] = "- 餵養寵物"
L["MACRO_FOOD"] = "- 食物"
L["MACRO_HEALTH_POTION"] = "- 治療藥水"
L["MACRO_HEALTHSTONE"] = "- 治療石"
L["MACRO_MANA_GEM"] = "- 法力寶石"
L["MACRO_MANA_POTION"] = "- 法力藥水"
L["MACRO_POISONS"] = "- 毒藥"
L["MACRO_SOULSTONE"] = "- 靈魂石"
L["MACRO_WATER"] = "- 水"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "等級"

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

L["DIET_BREAD"] = "麵包"
L["DIET_CHEESE"] = "乳酪"
L["DIET_FISH"] = "魚"
L["DIET_FRUIT"] = "水果"
L["DIET_FUNGUS"] = "蘑菇"
L["DIET_MEAT"] = "肉"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] =
	"看來你發現了一個BUG！%s (%s) 無法在 %s > %s (%s) 使用。請報告給我們以便修復。謝謝！ %s"
L["MSG_NO_ITEM"] = "背包中未找到合適的 %s。"
L["MSG_MACRO_SLOTS_FULL"] =
	"由於你的巨集空位已滿，部分 Connoisseur 巨集無法創建。請刪除不再使用的巨集以釋放空位，或在 選項 > 插件 > Connoisseur 中關閉不需要的巨集。"

L["CHAT_LOADED"] =
	"版本 %s。設定（包括停用此訊息的選項）可以在 選項 > 插件 > Connoisseur 中找到。喜歡這個插件嗎？告訴朋友吧！(="

L["CHAT_OPTIONS_IN_COMBAT"] = "基於安全考量，戰鬥中無法開啟選項介面。"

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "準備就緒！"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "缺少：%s"

L["READY_WELL_FED"] = "進食充分"
L["READY_SCROLLS"] = "卷軸"
L["READY_PET_FED"] = "寵物已進食"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d 分鐘"
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s 不足 1 分鐘"

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "你目前沒有任何對寵物有用的食物。"
L["TIP_PET_NO_SKILLS"] = "你目前還沒有學會召喚寵物、解散寵物、餵養寵物或復活寵物。"
L["TIP_PET_NO_MEND"] = "你目前還沒有學會治療寵物。"
L["TIP_NO_HAND_POISON"] = "這把武器所選的毒藥已用完。"

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "你目前還沒有學會%s。"

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the mini-map tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "增益食物"
L["MENU_BUFF_FOOD_DESCRIPTION"] = '當缺少 "進食充分" BUFF時，優先使用提供該BUFF的食物。'
L["FEATURE_SCROLL_BUFFS"] = "卷軸增益"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "當你缺少卷軸增益時，將你的食物巨集轉變為卷軸施放器。"

-- Section titles and ignore-list actions in the mini-map tooltip.
L["UI_BEST_FOOD"] = "當前食物"
L["UI_BEST_PET_FOOD"] = "當前寵物食物"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "主手"
L["UI_OFF_HAND"] = "副手"
L["UI_IGNORE_LIST"] = "忽略列表"
L["MENU_IGNORE"] = "忽略"
L["MENU_CLEAR_IGNORE"] = "清除忽略列表"

--[[
    Restocker Report block in the mini-map tooltip: how many restocking orders
    are still outstanding, never the items themselves. An order is one row of
    the Restock List, so the count is of rows below target and not of missing
    units -- nine outstanding orders can be nine single juices or nine full
    stacks. The header above supplies the "restocking", so the lines under it
    only need the noun.

    Separate singular and plural strings rather than a composed "%d order(s)",
    so every locale can phrase the count its own way.
]]
L["UI_RESTOCKER_REPORT"] = "補貨報告"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 項未完成訂單"
L["UI_RESTOCKER_NEEDED"] = "%d 項未完成訂單"
L["UI_RESTOCKER_STOCKED"] = "恭喜，你的補給已經備齊！"

-- Options entry at the bottom of the mini-map tooltip.
L["MENU_OPTIONS"] = "Connoisseur 選項"
L["MENU_OPTIONS_KEYBIND"] = "Shift + 中鍵點擊"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

--[[
    Class-colored headers and conjure/pet tips shown in the mini-map tooltip for
    the player's class.
]]

L["PREFIX_HUNTER"] = "獵人請注意"
L["PREFIX_MAGE"] = "法師請注意"
L["PREFIX_ROGUE"] = "盜賊請注意"
L["PREFIX_WARLOCK"] = "術士請注意"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to — the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "關於你的餵養寵物巨集……"
L["TIP_MAGE_MACROS"] = "關於你的食物、水和法力寶石巨集……"
L["TIP_ROGUE_MACROS"] = "關於你的毒藥巨集……"
L["TIP_WARLOCK_MACROS"] = "關於你的治療石和靈魂石巨集……"

L["TIP_HUNTER_ALL_IN_ONE"] = "餵養寵物是一個全能寵物按鈕！"
L["TIP_HUNTER_CALL"] = "左鍵點擊可自動召喚、餵養或復活你的寵物。"
L["TIP_HUNTER_MEND"] = "右鍵點擊或等到進入戰鬥即可施放治療寵物。"
L["TIP_HUNTER_MODIFIERS"] = "按住 Shift 強制復活，按住 Ctrl 解散寵物。"

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "右鍵點擊你的食物或水巨集以製造食物或水。"
L["TIP_MAGE_DOWNRANK"] = "以等級較低的玩家為目標時，將製造適合其等級的食物或水。"
L["TIP_MAGE_TABLE"] = "中鍵點擊你的食物或水巨集以施放召喚餐桌。"
L["TIP_MAGE_GEM"] =
	"右鍵點擊你的法力寶石巨集以製造一顆新的寶石。再次右鍵點擊以製造一顆低等級備用寶石。"

L["TIP_WARLOCK_HEALTHSTONE"] =
	"右鍵點擊你的治療石巨集以製造治療石。再次右鍵點擊以製造一顆低等級備用治療石。"
L["TIP_WARLOCK_DOWNRANK"] = "以等級較低的玩家為目標時，將製造適合其等級的治療石。"
L["TIP_WARLOCK_SOULSTONE"] = "右鍵點擊你的靈魂石巨集以製造靈魂石。"
L["TIP_WARLOCK_SOUL"] = "中鍵點擊你的治療石巨集以施放靈魂儀式。"

L["TIP_ROGUE_OFF_HAND"] = "左鍵點擊塗抹你的副手毒藥。"
L["TIP_ROGUE_MAIN_HAND"] = "右鍵點擊塗抹你的主手毒藥。"
L["TIP_ROGUE_REPLACE"] = "既有毒藥會自動替換。"
L["TIP_ROGUE_WINDOW"] = "中鍵點擊開啟毒藥製作視窗。"

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

--[[
    Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
    One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
]]

L["LABEL_BANDAGE"] = "繃帶"
L["LABEL_EXPLOSIVE"] = "爆炸物"
L["LABEL_FOOD"] = "食物"
L["LABEL_HEALTH_POTION"] = "治療藥水"
L["LABEL_HEALTHSTONE"] = "治療石"
L["LABEL_MANA_GEM"] = "法力寶石"
L["LABEL_MANA_POTION"] = "法力藥水"
L["LABEL_PET_FOOD"] = "寵物食物"
L["LABEL_POISONS"] = "毒藥"
L["LABEL_SOULSTONE"] = "靈魂石"
L["LABEL_WATER"] = "水"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the mini-map tooltip and options panel.

L["UI_ENABLED"] = "已啟用"
L["UI_DISABLED"] = "已停用"
L["UI_TOGGLE"] = "切換"
L["UI_LEFT_CLICK"] = "左鍵點擊"
L["UI_RIGHT_CLICK"] = "右鍵點擊"
L["UI_MIDDLE_CLICK"] = "中鍵點擊"
L["UI_SHIFT_LEFT"] = "Shift + 左鍵點擊"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "總是"
L["MODE_PARTY"] = "僅在小隊或團隊時"
L["MODE_RAID"] = "僅在團隊時"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"自動取用你最好的食物、增益食物、水、藥水、治療石、繃帶和卷軸的巨集，外加一份補貨清單，讓你的背包始終充足，並隨著你升級自動升級消耗品。便利性自動化，巔峰表現。"

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "啟用歡迎訊息"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "登入時在聊天框列印歡迎訊息。"

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "啟用小地圖按鈕"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "顯示小地圖按鈕。"

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "在按鈕上顯示巨集名稱"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"在你的動作條按鈕上顯示巨集名稱文字。預設為關閉，會隱藏暴雪最近重新顯示的名稱。"

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "藥水與治療石"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"巨集在戰鬥中無法更改（這是暴雪的限制），因此每個藥水和治療石巨集都預先包含你最好的物品以及最多兩個備用物品。在較長的戰鬥中，圖示和提示可能會過時並顯示錯誤的物品，但點擊該巨集將始終使用你背包中實際擁有的最佳物品。"
L["OPTIONS_COMBINE_HEALTHSTONES"] = "將治療石合併到治療藥水巨集中"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"將你最好的治療石添加到治療藥水巨集的底部，這樣按一次即可同時使用藥水和治療石。"

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "增益重新施放"
L["OPTIONS_REAPPLY"] = "提前補充即將到期的增益"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"戰鬥時間常常超過增益的剩餘時間。剩餘時間低於門檻的增益將視為已過期，巨集會在開怪前提供新的增益。適用於增益食物、卷軸增益和寵物食物增益。"
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "當剩餘不足 1 分鐘時"
L["REAPPLY_THRESHOLD_N"] = "當剩餘不足 %d 分鐘時"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "準備確認"
L["OPTIONS_READY_CHECK"] = "在準備確認時回報狀態"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"每次開始準備確認時，輸出你缺少什麼以及所追蹤增益的剩餘時間，僅你自己可見。"

--[[
    Three features are suppressed in a PvP Arena, and each says so with the
    same sentence. It lives here once and is appended at the call site
    (Options/Options-Macros.lua), so every locale translates it a single time
    and the caveat can never drift between the three.
]]
L["OPTIONS_DISABLED_IN_ARENAS"] = "在競技場中停用。"

--[[
    Buff Food. The section header reuses FEATURE_BUFF_FOOD, and the options
    description reuses MENU_BUFF_FOOD_DESCRIPTION plus the arena note above --
    the mini-map tooltip and the options panel say the same thing, so they read
    from one key rather than two copies of one sentence.
]]
L["OPTIONS_BUFF_FOOD"] = "優先增益食物"
L["OPTIONS_BUFF_FOOD_DETAIL"] = "專業提示：以自己為目標總會讓食物巨集跳過增益食物和卷軸。"

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "包含卷軸增益"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"按一次施放缺少的卷軸，再按一次進食。卷軸不佔用GCD且以你自己為目標；以友方玩家為目標時會跳過卷軸。"
L["OPTIONS_SCROLL_TYPES"] = "在檢查中包含卷軸類型"
L["OPTIONS_SCROLL_AGILITY"] = "敏捷"
L["OPTIONS_SCROLL_INTELLECT"] = "智力"
L["OPTIONS_SCROLL_PROTECTION"] = "防護"
L["OPTIONS_SCROLL_SPIRIT"] = "精神"
L["OPTIONS_SCROLL_STAMINA"] = "耐力"
L["OPTIONS_SCROLL_STRENGTH"] = "力量"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "爆炸物"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"@player 選項會跳過目標指示圈，直接在你腳下引爆炸彈，非常適合目標處於近戰距離時使用。"
L["EXPLOSIVES_MODE_ATPLAYER"] = "左鍵點擊 @player，右鍵點擊投擲"
L["EXPLOSIVES_MODE_TOSS"] = "左鍵點擊投擲，右鍵點擊 @player"

--[[
    Ignore List. The rows are items, so the only copy here is the add box and
    the placeholder shown while the client is still resolving an item's name.
    The section header and the clear-all button reuse UI_IGNORE_LIST and
    MENU_CLEAR_IGNORE, which the mini-map tooltip already carries.
]]
L["OPTIONS_IGNORE_DESCRIPTION"] =
	"無論多好，Connoisseur 都不會選擇這些物品。右鍵點擊小地圖按鈕可忽略它目前推薦的食物，也可以在下方新增物品。"
L["OPTIONS_IGNORE_ADD_ID"] = "以物品 ID 新增"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"輸入物品 ID，或在此輸入框取得焦點時按住 Shift + 點擊聊天中的物品連結。"
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "輸入物品 ID，或按住 Shift + 點擊聊天中的物品連結。"
L["OPTIONS_IGNORE_REMOVE"] = "移除"
L["OPTIONS_IGNORE_EMPTY"] = "此列表為空。"
L["OPTIONS_IGNORE_CLEAR_CONFIRM"] = "要從忽略列表中移除所有物品嗎？"
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "正在載入 ID：%d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "寵物食物增益"
L["OPTIONS_USE_PET_BUFFS"] = "使用寵物食物增益"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'當你的寵物缺少 "進食充分" BUFF時，在你的食物巨集中加入寵物食物。'
L["OPTIONS_PET_BUFF_TYPES"] = "在檢查中包含寵物食物類型"
L["OPTIONS_PET_BUFF_KIBLERS"] = "基布雷爾的寵物食品"
L["OPTIONS_PET_BUFF_SPORELING"] = "孢子村點心"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "德魯伊"
L["OPTIONS_DRUID_MACRO_HELPER"] = "啟用 DruidMacroHelper 整合"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"使用 DruidMacroHelper (/dmh) 為治療藥水、法力藥水和治療石構建變形巨集。"
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "返回熊形態"
L["DRUID_FORM_CAT"] = "返回獵豹形態"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "夜精靈"
L["OPTIONS_STEALTH_DRINKING"] = "啟用喝水時潛行"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] = "將影遁添加到你的水巨集中，以便你在喝水時潛行。"
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	"將影遁添加到你的食物巨集中，以便你在進食時潛行。"
L["OPTIONS_STEALTH_PICK_ONE"] =
	"專業提示：只選一個。你可以同時進食和喝水，但潛行後再進食或喝水會解除潛行。"

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "盜賊"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"讓毒藥巨集始終裝載每種毒藥類型可用的最高等級。左鍵塗抹副手，右鍵塗抹主手，既有毒藥會自動替換。"
L["OPTIONS_POISON_MAIN_HAND"] = "主手毒藥類型"
L["OPTIONS_POISON_OFF_HAND"] = "副手毒藥類型"
L["OPTIONS_STEALTH_EATING"] = "啟用進食時潛行"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] =
	"將潛行添加到你的食物巨集中，以便你在進食時潛行。"

--[[
    Restocker options panel. The tree label stays "Restocker" in every locale
    (brand fragment, localization allowlist); the panel header reuses
    RESTOCKER_WINDOW_TITLE.
]]
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"根據每個角色的補貨清單保持背包補給充足。自動向商人購買，並在背包與銀行之間搬運物品。輸入 %s 打開清單。"
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "在銀行打開"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "造訪銀行時打開 Restocker 視窗。"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "在商人處打開"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "造訪商人時打開 Restocker 視窗。"
L["OPTIONS_RESTOCKER_REMIND"] = "啟用城鎮補貨提醒"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"當補貨清單尚有缺口，且你抵達旅店或城市，或登入時已身處其中，在聊天中輸出提醒。"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "啟用商人補貨提醒"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"關閉商人視窗時回報未完成的補貨訂單。沒有時保持安靜。"
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "啟用銀行補貨提醒"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"關閉銀行時回報未完成的補貨訂單。沒有時保持安靜。"

--[[
    The starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] = "補貨清單為空時啟用清單助手"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"當此角色的補貨清單為空時，在登入時提供一份入門補貨清單。"

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "簡潔"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "詳細"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "播放音效"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] = "在提醒的同時播放提示音，適合聊天繁忙的時候。"
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "點擊試聽提示音。"
L["OPTIONS_RESTOCKER_DEBUG"] = "啟用 Restocker 除錯訊息"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"在聊天視窗中逐步輸出 Restocker 的銀行/商人補貨決策。訊息較多；在關閉前會跨登入階段保持開啟。"

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "補貨視窗"
L["OPTIONS_RESTOCKER_ADVANCED_HEADER"] = "進階"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "致謝"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"我一直很喜歡 Restocker，很高興它能在 Connoisseur 中繼續存在。非常感謝撰寫了最初 Auto Restocker 的 ChiliFajita，以及在 Classic 與潘達利亞之謎期間讓它延續下來的 kvakvs 和 guardycmw。"

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的選項介面。"
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "開啟 Restocker 視窗以管理你的補貨清單。"

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "巨集"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur 會為每種消耗品各建立一個巨集，並隨著背包變化保持更新，讓你快捷列上的按鈕始終取用你身上最好的物品。請在下方選擇要建立哪些巨集，然後設定每個巨集如何挑選物品。"
L["OPTIONS_ENABLE_MACROS_HEADER"] = "啟用巨集"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"切換 Connoisseur 創建和維護哪些巨集。停用一個巨集也會將其移除。"

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "反饋與支援"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "版本"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "已匯入你的 Restocker 清單。"
L["RESTOCKER_PROFILE_EXISTS"] = '已存在名為"%s"的設定檔。'
L["RESTOCKER_BANK_NOT_OPEN"] = "銀行未開啟。"
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"補貨完成。開啟銀行時按住 Shift 可跳過補貨。輸入 %s 編輯你的補貨清單。"
L["RESTOCKER_STOPPED_BOTH_FULL"] = "補貨已停止。你的背包和銀行都已滿。"
L["RESTOCKER_STOPPED_BANK_FULL"] = "補貨已停止。你的銀行已滿；請騰出一格後重新開啟。"
L["RESTOCKER_STOPPED_BAG_FULL"] = "補貨已停止。你的背包已滿；請騰出一格後重新開啟銀行。"
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "補貨已停止。無法繼續進行。"
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] = "補貨已停止。無法移動：%s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (多餘)"
L["RESTOCKER_STOPPED_ERROR"] = "補貨因錯誤而停止：%s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] = "你的背包已滿。跳過商人補貨。"
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "在城裡的時候別忘了補貨！"

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
L["RESTOCKER_STILL_SHORT_ONE"] = "還有 1 項補貨訂單未完成。"
L["RESTOCKER_STILL_SHORT_MANY"] = "還有 %d 項補貨訂單未完成。"

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, old amount, new link, new amount },
    outgoing tier on the left and incoming on the right.

    Both amounts are carried because they are not always equal: a swap onto a
    tier the list already holds merges the two rows, so the new amount is the
    sum rather than the old amount moved across.
]]
L["RESTOCKER_UPGRADED"] = "你的補貨清單已升級。"
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d 升級為 %sx%d。"

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
L["RESTOCKER_RESTOCKED_ONE"] = "已完成 1 項補貨訂單。"
L["RESTOCKER_RESTOCKED_MANY"] = "已完成 %d 項補貨訂單。"

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "有 1 項補貨訂單僅部分完成。"
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] = "有 %d 項補貨訂單僅部分完成。"

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "顯示 Restocker 視窗。"
L["RESTOCKER_HELP_PROFILE_ADD"] = "新增一個以該名稱命名的設定檔。"
L["RESTOCKER_HELP_PROFILE_DELETE"] = "刪除該名稱的設定檔。"
L["RESTOCKER_HELP_PROFILE_RENAME"] = "將目前設定檔重新命名為該名稱。"
L["RESTOCKER_HELP_PROFILE_COPY"] = "將該設定檔複製到目前設定檔。"
L["RESTOCKER_HELP_PROFILE_USE"] = "切換到該名稱的設定檔。"

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
L["STARTER_POPUP_INTRO_EMPTY"] = "你的補貨清單是空的，我們來新增一些物品好讓你上手。"
L["STARTER_POPUP_INTRO_HOW"] =
	"你勾選的一切都會在開啟商人或銀行時自動補足，而常規物資會隨著等級提升自動升級，所以你手上永遠是目前最好的。"
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] = "你隨時可以輸入 %s 來調整這份清單，或稍後新增更多物品。"
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "食物與水"
L["STARTER_POPUP_FOOD_HEADER"] = "食物"
L["STARTER_POPUP_AMMO_HEADER"] = "彈藥"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "子彈"
L["STARTER_POPUP_ARROWS"] = "箭矢"

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
L["STARTER_POPUP_REAGENTS_HEADER"] = "材料與工具"
L["STARTER_POPUP_POISONS_HEADER"] = "毒藥"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s ：把成品毒藥加入清單，Connoisseur 會自動在任何販售材料的商人處購買。"
L["STARTER_POPUP_POISON_ANESTHETIC"] = "麻醉"
L["STARTER_POPUP_POISON_CRIPPLING"] = "致殘"
L["STARTER_POPUP_POISON_DEADLY"] = "致命"
L["STARTER_POPUP_POISON_INSTANT"] = "速效"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "遲鈍"
L["STARTER_POPUP_POISON_WOUND"] = "創傷"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "爐石"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "致盲粉塵"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "閃光粉塵"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "盜賊工具"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "屍體粉塵"
L["STARTER_POPUP_REAGENT_WILDS"] = "野生漿果"
L["STARTER_POPUP_REAGENT_SEEDS"] = "種子"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "秘法之塵"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "輕羽毛"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "傳送符文"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "傳送門符文"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "神聖符記"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "王者符記"
L["STARTER_POPUP_REAGENT_CANDLES"] = "蠟燭"
L["STARTER_POPUP_REAGENT_ANKH"] = "安卡"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "魚鱗"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "魚油"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "大地圖騰"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "火焰圖騰"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "水之圖騰"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "空氣圖騰"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "惡魔雕像"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "地獄火石"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "靈魂碎片"
--[[
    Checkbox tooltips: { item link, amount }. The first is for ladder items;
    the second for single-tier reagents, which never upgrade.
]]
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"將 %s 加入你的補貨清單，在背包中保留 %d 個，並隨著你的等級自動升級。"
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] = "將 %s 加入補貨清單，並在背包中保留 %d 個。"
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 for food, water and poisons, 200 for ammo); the tooltip
    below carries the per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 疊"
L["STARTER_POPUP_STACK_MANY"] = "%d 疊"
L["STARTER_POPUP_STACKS_DESCRIPTION"] = "要備多少疊。這裡的一疊是 %d 個。"
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] =
	"要備多少個。這些不能堆疊，因此每個都會佔用一個背包格。"
L["STARTER_POPUP_DISMISS"] = "此角色不再顯示。"
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"否則每次登入時只要補貨清單為空，這些建議就會再次出現。"

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "篩選物品..."
L["RESTOCKER_ADD_BUTTON"] = "新增"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "新增物品"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "從背包拖放一個物品，或輸入數字物品 ID。"
-- In-box placeholder for the add row; the tooltip above carries the detail.
L["RESTOCKER_ADD_PLACEHOLDER"] = "將物品拖曳至此，或輸入其 ID..."
L["RESTOCKER_PROFILE_LABEL"] = "設定檔："
L["RESTOCKER_RENAME_LABEL"] = "重新命名："
L["RESTOCKER_NEW_PROFILE"] = "新設定檔"
L["RESTOCKER_COPY_PROFILE"] = "複製"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in RS.SetupTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "將此設定檔複製為一個新設定檔"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s 副本"
L["RESTOCKER_DELETE_PROFILE"] = "刪除"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "刪除此設定檔"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] = "確定要刪除此設定檔嗎？|n|n%s|n|n此操作無法復原。"
--[[
    Row controls in the Restocker window. UPGRADE is disabled on any item that
    is not on a ladder in Data/Consumable-Upgrade-Paths.lua, which on a real
    list is most of them.
]]
L["RESTOCKER_UPGRADE_LABEL"] = "自動升級"
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "隨等級升級"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"食物、水、彈藥和藥水隨著等級有清晰的升級路線，所以 Connoisseur 會替你把這一項往上調。其餘的則交給你自己慢慢調整。"

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "銀行"
L["RESTOCKER_ROW_MERCHANT"] = "商人"
L["RESTOCKER_ROW_UPGRADE"] = "升級"

L["RESTOCKER_GROUP_OTHER"] = "其他"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "新增"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "將此物品從補貨清單中移除"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "補貨數量"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "編輯完成後按 Enter。"
L["RESTOCKER_BUY_LABEL"] = "購買"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "向商人購買"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "商人視窗開啟時購買所需數量。"
L["RESTOCKER_DEPOSIT_LABEL"] = "存入"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "存入銀行"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] = "銀行開啟時將多餘物品存入銀行。填 0 表示全部存入。"
L["RESTOCKER_WITHDRAW_LABEL"] = "取出"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "從銀行補貨"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "銀行開啟時從銀行取出所需物品。"

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "所需聲望"
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (優惠 %d%%)"
L["RESTOCKER_REPUTATION_ANY"] = "任意"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "友好"
L["RESTOCKER_REPUTATION_HONORED"] = "尊敬"
L["RESTOCKER_REPUTATION_REVERED"] = "崇敬"
L["RESTOCKER_REPUTATION_EXALTED"] = "崇拜"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]
L["RESTOCKER_REPUTATION_BUTTON_FORMAT"] = "聲望：%s"

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "所需商人聲望"
--[[
    Quotes the button's own label. That couples this line to
    RESTOCKER_REPUTATION_BUTTON_FORMAT and RESTOCKER_REPUTATION_ANY -- a locale
    that renders the button differently has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'選定一個聲望等級後，Connoisseur 會跳過你尚未達到該等級的商人。"聲望：任意"則向任何商人購買。'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"聲望還會降低價格：友好 5%，尊敬 10%，崇敬 15%，崇拜 20%。"
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "點擊進行變更。"
