local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "zhTW")
if not L then return end

-- [[ TRADITIONAL CHINESE (zhTW) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["BRAND"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- 繃帶"
L["MACRO_FEED_PET"] = "- 餵養寵物"
L["MACRO_FOOD"] = "- 食物"
L["MACRO_HEALTH_POTION"] = "- 治療藥水"
L["MACRO_HEALTHSTONE"] = "- 治療石"
L["MACRO_MANA_GEM"] = "- 法力寶石"
L["MACRO_MANA_POTION"] = "- 法力藥水"
L["MACRO_SOULSTONE"] = "- 靈魂石"
L["MACRO_WATER"] = "- 水"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "等級"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] = "看來你發現了一個BUG！%s (%s) 無法在 %s > %s (%s) 使用。請報告給我們以便修復。謝謝！ https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "背包中未找到合適的 %s。"

L["CHAT_LOADED"] = "版本 %s。設定（包括停用此訊息的選項）可以在 選項 > 插件 > Connoisseur 中找到。喜歡這個插件嗎？告訴朋友吧！(="

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "優先增益食物"
L["MENU_BUFF_FOOD_DESCRIPTION"] = "當缺少 \"進食充分\" BUFF時，優先使用提供該BUFF的食物。"
L["MENU_CLEAR_IGNORE"] = "清除忽略列表"
L["MENU_IGNORE"] = "忽略"

L["MENU_SCROLL_BUFFS"] = "卷軸增益"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "當你缺少卷軸增益時，將你的食物巨集轉變為卷軸施放器。"
L["MENU_OPTIONS_HINT"] = "在 選項 > 插件 > Connoisseur 中有更多選項可用。"

L["PREFIX_HUNTER"] = "獵人請注意"
L["PREFIX_MAGE"] = "法師請注意"
L["PREFIX_WARLOCK"] = "術士請注意"

L["TIP_DOWNRANK"] = "選中低等級玩家為目標時，巨集將製造適合其等級的物品。"
L["TIP_HUNTER_FEED_PET"] = "餵養寵物是一個多合一的寵物按鈕！點擊可自動召喚、餵養或復活你的寵物。右鍵點擊或在戰鬥中使用會施放治療寵物。按住Shift強制復活，按住Ctrl解散。"
L["TIP_MAGE_CONJURE"] = "右鍵點擊你的食物或水巨集以製造食物或水。"
L["TIP_MAGE_GEM"] = "右鍵點擊你的法力寶石巨集以製造一顆新的寶石。再次右鍵點擊以製造一顆低等級備用寶石。"
L["TIP_MAGE_TABLE"] = "中鍵點擊以施放召喚餐桌。"
L["TIP_WARLOCK_CONJURE"] = "右鍵點擊你的治療石或靈魂石巨集以製造治療石或靈魂石。"
L["TIP_WARLOCK_SOUL"] = "中鍵點擊以施放靈魂儀式。"

L["UI_BEST_FOOD"] = "當前食物"
L["UI_BEST_PET_FOOD"] = "當前寵物食物"

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
L["LABEL_FOOD"] = "食物"
L["LABEL_PET_FOOD"] = "寵物食物"
L["UI_DISABLED"] = "已停用"
L["UI_ENABLED"] = "已啟用"
L["UI_IGNORE_LIST"] = "忽略列表"
L["UI_LEFT_CLICK"] = "左鍵點擊"
L["UI_MIDDLE_CLICK"] = "中鍵點擊"
L["UI_RIGHT_CLICK"] = "右鍵點擊"
L["UI_SHIFT_LEFT"] = "Shift + 左鍵點擊"
L["UI_TOGGLE"] = "切換"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "總是"
L["MODE_PARTY"] = "僅在小隊時"
L["MODE_RAID"] = "僅在團隊時"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "為你最好的食物、增益食物、水、卷軸、治療和法力藥水、治療石、靈魂石、法力寶石和繃帶創建自動更新的巨集。為法師和術士提供一鍵製造，為獵人提供智能餵食。最佳營養，巔峰表現。"

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "啟用歡迎訊息"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "登入時在聊天框列印歡迎訊息。"

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "優先增益食物"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = "當缺少 \"進食充分\" BUFF時，優先使用提供該BUFF的食物。"
L["OPTIONS_BUFF_FOOD_DETAIL"] = "專業提示：以自己為目標總會讓食物巨集跳過增益食物和卷軸。"

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "卷軸增益"
L["OPTIONS_USE_SCROLLS"] = "包含卷軸增益"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] = "只要你缺少卷軸增益，就會將你的食物巨集轉變為專用的卷軸施放器。按一次施放卷軸；再按一次進食。卷軸不佔用GCD，以你為目標，並且當你的目標是其他友方玩家時，巨集會立刻還原為食物。"
L["OPTIONS_SCROLL_TYPES"] = "在檢查中包含卷軸類型"
L["OPTIONS_SCROLL_AGILITY"] = "敏捷"
L["OPTIONS_SCROLL_INTELLECT"] = "智力"
L["OPTIONS_SCROLL_PROTECTION"] = "防護"
L["OPTIONS_SCROLL_SPIRIT"] = "精神"
L["OPTIONS_SCROLL_STAMINA"] = "耐力"
L["OPTIONS_SCROLL_STRENGTH"] = "力量"

-- Pets Food Buffs
L["OPTIONS_PET_HEADER"] = "寵物食物增益"
L["OPTIONS_USE_PET_BUFFS"] = "使用寵物食物增益"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] = "當你的寵物缺少 \"進食充分\" BUFF時，在你的食物巨集中使用寵物食物。"
L["OPTIONS_PET_BUFF_TYPES"] = "在檢查中包含寵物食物類型"
L["OPTIONS_PET_BUFF_KIBLERS"] = "基布雷爾的寵物食品"
L["OPTIONS_PET_BUFF_SPORELING"] = "孢子村點心"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "德魯伊"
L["OPTIONS_DRUID_MACRO_HELPER"] = "啟用 DruidMacroHelper 整合"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] = "使用 DruidMacroHelper (/dmh) 為治療藥水、法力藥水和治療石構建變形巨集。"
L["OPTIONS_DRUID_RETURN_FORM"] = "使用消耗品後，切換至"
L["DRUID_FORM_BEAR"] = "熊"
L["DRUID_FORM_CAT"] = "獵豹"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "夜精靈"
L["OPTIONS_SHADOWMELD_DRINKING"] = "影遁飲水"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] = "將影遁添加到你的水巨集中，以便你在喝水時潛行。"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESCRIPTION"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "打開 Connoisseur 選項介面。"

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "啟用巨集"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] = "切換 Connoisseur 創建和維護哪些巨集。停用一個巨集也會將其移除。"

-- Reset
L["OPTIONS_RESET_HEADER"] = "重置"
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "從忽略列表中移除所有物品。"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "你確定要清除忽略列表嗎？"
L["OPTIONS_RESET_ALL"] = "重置所有 Connoisseur 選項"
L["OPTIONS_RESET_ALL_DESCRIPTION"] = "將所有設定和忽略列表重置為預設值。"
L["OPTIONS_RESET_ALL_CONFIRM"] = "將所有 Connoisseur 選項重置為預設值？"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "反饋與支援"