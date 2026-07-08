local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "zhTW")
if not L then return end

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

L["MSG_BUG_REPORT"] = "看來你發現了一個BUG！%s (%s) 無法在 %s > %s (%s) 使用。請報告給我們以便修復。謝謝！ https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "背包中未找到合適的 %s。"
L["MSG_MACRO_SLOTS_FULL"] = "由於你的巨集空位已滿，部分 Connoisseur 巨集無法創建。請刪除不再使用的巨集以釋放空位，或在 選項 > 插件 > Connoisseur 中關閉不需要的巨集。"

L["CHAT_LOADED"] = "版本 %s。設定（包括停用此訊息的選項）可以在 選項 > 插件 > Connoisseur 中找到。喜歡這個插件嗎？告訴朋友吧！(="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macro-Builder-General.lua.

L["TIP_PET_NO_FOOD"] = "你目前沒有任何對寵物有用的食物。"
L["TIP_PET_NO_SKILLS"] = "你目前還沒有學會餵養寵物、治療寵物或復活寵物。"
L["TIP_PET_NO_MEND"] = "你目前還沒有學會治療寵物。"

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "你目前還沒有學會%s。"

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["MENU_BUFF_FOOD"] = "優先增益食物"
L["MENU_BUFF_FOOD_DESCRIPTION"] = "當缺少 \"進食充分\" BUFF時，優先使用提供該BUFF的食物。"
L["MENU_SCROLL_BUFFS"] = "卷軸增益"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "當你缺少卷軸增益時，將你的食物巨集轉變為卷軸施放器。"

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "當前食物"
L["UI_BEST_PET_FOOD"] = "當前寵物食物"
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
L["PREFIX_WARLOCK"] = "術士請注意"

L["TIP_DOWNRANK"] = "選中低等級玩家為目標時，巨集將製造適合其等級的物品。"
L["TIP_HUNTER_FEED_PET"] = "餵養寵物是一個多合一的寵物按鈕！點擊可自動召喚、餵養或復活你的寵物。右鍵點擊或等待戰鬥來施放治療寵物。按住Shift強制復活，按住Ctrl解散。"
L["TIP_MAGE_CONJURE"] = "右鍵點擊你的食物或水巨集以製造食物或水。"
L["TIP_MAGE_GEM"] = "右鍵點擊你的法力寶石巨集以製造一顆新的寶石。再次右鍵點擊以製造一顆低等級備用寶石。"
L["TIP_MAGE_TABLE"] = "中鍵點擊以施放召喚餐桌。"
L["TIP_WARLOCK_CONJURE"] = "右鍵點擊你的治療石或靈魂石巨集以製造治療石或靈魂石。再次右鍵點擊你的治療石巨集以製造一顆低等級備用治療石。"
L["TIP_WARLOCK_SOUL"] = "中鍵點擊以施放靈魂儀式。"

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
L["MODE_PARTY"] = "僅在小隊時"
L["MODE_RAID"] = "僅在團隊時"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "為你最好的食物、增益食物、水、卷軸、治療和法力藥水、治療石、靈魂石、法力寶石和繃帶創建自動更新的巨集。為法師和術士提供一鍵製造，為獵人提供智能餵食。最佳營養，巔峰表現。"

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "啟用歡迎訊息"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "登入時在聊天框列印歡迎訊息。"

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "啟用小地圖按鈕"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "顯示小地圖按鈕。"

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "藥水與治療石"
L["OPTIONS_POTIONS_DESCRIPTION"] = "巨集在戰鬥中無法更改（這是暴雪的限制），因此每個藥水和治療石巨集都預先包含你最好的物品以及最多兩個備用物品。在較長的戰鬥中，圖示和提示可能會過時並顯示錯誤的物品，但點擊該巨集將始終使用你背包中實際擁有的最佳物品。"
L["OPTIONS_COMBINE_HEALTHSTONES"] = "將治療石合併到治療藥水巨集中"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] = "將你最好的治療石添加到治療藥水巨集的底部，這樣按一次即可同時使用藥水和治療石。"

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "增益食物"
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

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "爆炸物"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] = "@player 選項會跳過目標指示圈，直接在你腳下引爆炸彈——非常適合目標處於近戰距離時使用。"
L["EXPLOSIVES_MODE_ATPLAYER"] = "左鍵點擊 @Player，右鍵點擊投擲"
L["EXPLOSIVES_MODE_TOSS"] = "左鍵點擊投擲，右鍵點擊 @Player"

-- Pet Food Buffs
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

-- Ignore List
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "從忽略列表中移除所有物品。"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "你確定要清除忽略列表嗎？"

-- Profiles (Reset All Profiles -- the stock AceDBOptions widgets are not localized here)
L["OPTIONS_RESET_ALL_PROFILES"] = "重置所有設定檔"
L["OPTIONS_RESET_ALL_PROFILES_DESCRIPTION"] = "將此帳號的所有設定檔重置為預設設定。"
L["OPTIONS_RESET_ALL_PROFILES_CONFIRM"] = "這將把你帳號上所有角色的設定檔重置為預設設定。此操作無法復原。是否繼續？"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "反饋與支援"
