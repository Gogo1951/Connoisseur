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

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

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

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "增益食物"
L["MENU_BUFF_FOOD_DESCRIPTION"] = '當缺少 "進食充分" BUFF時，優先使用提供該BUFF的食物。'
L["FEATURE_SCROLL_BUFFS"] = "卷軸增益"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "當你缺少卷軸增益時，將你的食物巨集轉變為卷軸施放器。"

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "當前食物"
L["UI_BEST_PET_FOOD"] = "當前寵物食物"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "主手"
L["UI_OFF_HAND"] = "副手"
L["UI_IGNORE_LIST"] = "忽略列表"
L["MENU_IGNORE"] = "忽略"
L["MENU_CLEAR_IGNORE"] = "清除忽略列表"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Connoisseur 選項"
L["MENU_OPTIONS_KEYBIND"] = "Shift + 中鍵點擊"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

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

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

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

-- Generic labels reused across the minimap tooltip and options panel.

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
	"為你最好的食物、增益食物、水、藥水、治療石、卷軸、靈魂石、繃帶、毒藥和爆炸物創建自動更新的巨集。一鍵製造，智慧餵養寵物，自動向商人和銀行補貨。最佳營養，巔峰表現。"

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

-- Buff Food. The section header reuses FEATURE_BUFF_FOOD.
L["OPTIONS_BUFF_FOOD"] = "優先增益食物"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'當缺少 "進食充分" BUFF時，優先使用提供該BUFF的食物。在競技場中停用。'
L["OPTIONS_BUFF_FOOD_DETAIL"] = "專業提示：以自己為目標總會讓食物巨集跳過增益食物和卷軸。"

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "包含卷軸增益"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"按一次施放缺少的卷軸，再按一次進食。卷軸不佔用GCD且以你自己為目標；以友方玩家為目標時會跳過卷軸。在競技場中停用。"
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

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "寵物食物增益"
L["OPTIONS_USE_PET_BUFFS"] = "使用寵物食物增益"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'當你的寵物缺少 "進食充分" BUFF時，在你的食物巨集中加入寵物食物。在競技場中停用。'
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

-- Restocker. The section header reuses RESTOCKER_WINDOW_TITLE.
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"根據每個角色的補貨清單保持背包補給充足。自動向商人購買，並在背包與銀行之間搬運物品。輸入 %s 打開清單。"
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "在銀行打開"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "造訪銀行時打開 Restocker 視窗。"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "在商人處打開"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "造訪商人時打開 Restocker 視窗。"
L["OPTIONS_RESTOCKER_DEBUG"] = "啟用 Restocker 除錯訊息"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"在聊天視窗中逐步輸出 Restocker 的銀行/商人補貨決策。訊息較多；在關閉前會跨登入階段保持開啟。"

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的選項介面。"
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "開啟 Restocker 視窗以管理你的補貨清單。"

-- Enable Macros
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
L["RESTOCKER_FINISHED_RESTOCKING"] = "補貨結束（購買：%d）。"

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "顯示 Restocker 視窗。"
L["RESTOCKER_HELP_PROFILE_ADD"] = "新增一個以該名稱命名的設定檔。"
L["RESTOCKER_HELP_PROFILE_DELETE"] = "刪除該名稱的設定檔。"
L["RESTOCKER_HELP_PROFILE_RENAME"] = "將目前設定檔重新命名為該名稱。"
L["RESTOCKER_HELP_PROFILE_COPY"] = "將該設定檔複製到目前設定檔。"
L["RESTOCKER_HELP_PROFILE_USE"] = "切換到該名稱的設定檔。"

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "篩選物品..."
L["RESTOCKER_ADD_BUTTON"] = "新增"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "新增物品"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "從背包拖放一個物品，或輸入數字物品 ID。"
L["RESTOCKER_PROFILE_LABEL"] = "設定檔："
L["RESTOCKER_RENAME_LABEL"] = "重新命名："
L["RESTOCKER_NEW_PROFILE"] = "新設定檔"
L["RESTOCKER_COPY_PROFILE"] = "複製"
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "將此設定檔複製為一個新設定檔。"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s 副本"
L["RESTOCKER_DELETE_PROFILE"] = "刪除"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "刪除此設定檔。"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] = "確定要刪除此設定檔嗎？|n|n%s|n|n此操作無法復原。"
L["RESTOCKER_GROUP_OTHER"] = "其他"
L["RESTOCKER_REMOVE_TOOLTIP"] = "將此物品從補貨清單中移除。"
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
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (優惠 %d%%)"
L["RESTOCKER_REPUTATION_ANY"] = "任意"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "友好"
L["RESTOCKER_REPUTATION_HONORED"] = "尊敬"
L["RESTOCKER_REPUTATION_REVERED"] = "崇敬"
L["RESTOCKER_REPUTATION_EXALTED"] = "崇拜"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "所需商人聲望"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] = "只向聲望不低於此等級的商人購買。"
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"聲望越高價格也越便宜（友好 5%，尊敬 10%，崇敬 15%，崇拜 20%）。"
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "點擊選擇聲望等級。"
