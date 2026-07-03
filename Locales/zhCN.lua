local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "zhCN")
if not L then return end

-- [[ SIMPLIFIED CHINESE (zhCN) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- 绷带"
L["MACRO_FEED_PET"] = "- 喂养宠物"
L["MACRO_FOOD"] = "- 食物"
L["MACRO_HEALTH_POTION"] = "- 治疗药水"
L["MACRO_HEALTHSTONE"] = "- 治疗石"
L["MACRO_MANA_GEM"] = "- 法力宝石"
L["MACRO_MANA_POTION"] = "- 法力药水"
L["MACRO_SOULSTONE"] = "- 灵魂石"
L["MACRO_WATER"] = "- 水"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "等级"

--------------------------------------------------------------------------------
-- Pet Diets
--------------------------------------------------------------------------------

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

L["DIET_BREAD"] = "面包"
L["DIET_CHEESE"] = "奶酪"
L["DIET_FISH"] = "鱼"
L["DIET_FRUIT"] = "水果"
L["DIET_FUNGUS"] = "蘑菇"
L["DIET_MEAT"] = "肉"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] = "看来你发现了一个BUG！%s (%s) 无法在 %s > %s (%s) 使用。请报告给我们以便修复。谢谢！ https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "背包中未找到合适的 %s。"
L["MSG_MACRO_SLOTS_FULL"] = "由于你的宏空位已满，部分 Connoisseur 宏无法创建。请删除不再使用的宏以释放空位，或在 选项 > 插件 > Connoisseur 中关闭不需要的宏。"

L["CHAT_LOADED"] = "版本 %s。设置（包括禁用此消息的选项）可以在 选项 > 插件 > Connoisseur 中找到。喜欢这个插件吗？告诉朋友吧！(="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macro-Builder-General.lua.

L["TIP_PET_NO_FOOD"] = "你目前没有任何对宠物有用的食物。"
L["TIP_PET_NO_SKILLS"] = "你目前还没有学会喂养宠物、治疗宠物或复活宠物。"
L["TIP_PET_NO_MEND"] = "你目前还没有学会治疗宠物。"

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "你目前还没有学会%s。"

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "优先增益食物"
L["MENU_BUFF_FOOD_DESCRIPTION"] = "当缺少 \"进食充分\" BUFF时，优先使用提供该BUFF的食物。"
L["MENU_CLEAR_IGNORE"] = "清除忽略列表"
L["MENU_IGNORE"] = "忽略"

L["MENU_SCROLL_BUFFS"] = "卷轴增益"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "当你缺少卷轴增益时，将你的食物宏转变为卷轴施放器。"
L["MENU_OPTIONS_HINT"] = "在 选项 > 插件 > Connoisseur 中有更多选项可用。"

L["PREFIX_HUNTER"] = "猎人请注意"
L["PREFIX_MAGE"] = "法师请注意"
L["PREFIX_WARLOCK"] = "术士请注意"

L["TIP_DOWNRANK"] = "选中低等级玩家为目标时，宏将制造适合其等级的物品。"
L["TIP_HUNTER_FEED_PET"] = "喂养宠物是一个多合一的宠物按钮！点击可自动召唤、喂养或复活你的宠物。右键点击或等待战斗来施放治疗宠物。按住Shift强制复活，按住Ctrl解散。"
L["TIP_MAGE_CONJURE"] = "右键点击你的食物或水宏以制造食物或水。"
L["TIP_MAGE_GEM"] = "右键点击你的法力宝石宏以制造一颗新的宝石。再次右键点击以制造一颗低等级备用宝石。"
L["TIP_MAGE_TABLE"] = "中键点击以施放召唤餐桌。"
L["TIP_WARLOCK_CONJURE"] = "右键点击你的治疗石或灵魂石宏以制造治疗石或灵魂石。再次右键点击你的治疗石宏以制造一颗低等级备用治疗石。"
L["TIP_WARLOCK_SOUL"] = "中键点击以施放灵魂仪式。"

L["UI_BEST_FOOD"] = "当前食物"
L["UI_BEST_PET_FOOD"] = "当前宠物食物"

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
L["LABEL_BANDAGE"] = "绷带"
L["LABEL_FOOD"] = "食物"
L["LABEL_HEALTH_POTION"] = "治疗药水"
L["LABEL_HEALTHSTONE"] = "治疗石"
L["LABEL_MANA_GEM"] = "法力宝石"
L["LABEL_MANA_POTION"] = "法力药水"
L["LABEL_PET_FOOD"] = "宠物食物"
L["LABEL_SOULSTONE"] = "灵魂石"
L["LABEL_WATER"] = "水"
L["UI_DISABLED"] = "已禁用"
L["UI_ENABLED"] = "已启用"
L["UI_IGNORE_LIST"] = "忽略列表"
L["UI_LEFT_CLICK"] = "左键点击"
L["UI_MIDDLE_CLICK"] = "中键点击"
L["UI_RIGHT_CLICK"] = "右键点击"
L["UI_SHIFT_LEFT"] = "Shift + 左键点击"
L["UI_TOGGLE"] = "切换"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "总是"
L["MODE_PARTY"] = "仅在小队时"
L["MODE_RAID"] = "仅在团队时"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "为你最好的食物、增益食物、水、卷轴、治疗和法力药水、治疗石、灵魂石、法力宝石和绷带创建自动更新的宏。为法师和术士提供一键制造，为猎人提供智能喂食。最佳营养，巅峰表现。"

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "启用欢迎消息"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "登录时在聊天框打印欢迎消息。"

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "启用小地图按钮"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "显示小地图按钮。"

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "药水与治疗石"
L["OPTIONS_POTIONS_DESCRIPTION"] = "宏在战斗中无法更改（这是暴雪的限制），因此每个药水和治疗石宏都预先包含你最好的物品以及最多两个备用物品。在较长的战斗中，图标和提示可能会过时并显示错误的物品，但点击该宏将始终使用你背包中实际拥有的最佳物品。"
L["OPTIONS_COMBINE_HEALTHSTONES"] = "将治疗石合并到治疗药水宏中"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] = "将你最好的治疗石添加到治疗药水宏的底部，这样按一次即可同时使用药水和治疗石。"

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "优先增益食物"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = "当缺少 \"进食充分\" BUFF时，优先使用提供该BUFF的食物。"
L["OPTIONS_BUFF_FOOD_DETAIL"] = "专业提示：以自己为目标总是会让食物宏跳过增益食物和卷轴。"

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "卷轴增益"
L["OPTIONS_USE_SCROLLS"] = "包含卷轴增益"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] = "只要你缺少卷轴增益，就会将你的食物宏转变为专用的卷轴施放器。按一次施放卷轴；再按一次进食。卷轴不占用GCD，以你为目标，并且当你的目标是其他友方玩家时，宏会立刻还原为食物。"
L["OPTIONS_SCROLL_TYPES"] = "在检查中包含卷轴类型"
L["OPTIONS_SCROLL_AGILITY"] = "敏捷"
L["OPTIONS_SCROLL_INTELLECT"] = "智力"
L["OPTIONS_SCROLL_PROTECTION"] = "防护"
L["OPTIONS_SCROLL_SPIRIT"] = "精神"
L["OPTIONS_SCROLL_STAMINA"] = "耐力"
L["OPTIONS_SCROLL_STRENGTH"] = "力量"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "宠物食物增益"
L["OPTIONS_USE_PET_BUFFS"] = "使用宠物食物增益"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] = "当你的宠物缺少 \"进食充分\" BUFF时，在你的食物宏中使用宠物食物。"
L["OPTIONS_PET_BUFF_TYPES"] = "在检查中包含宠物食物类型"
L["OPTIONS_PET_BUFF_KIBLERS"] = "基布雷尔的宠物食品"
L["OPTIONS_PET_BUFF_SPORELING"] = "孢子村点心"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "德鲁伊"
L["OPTIONS_DRUID_MACRO_HELPER"] = "启用 DruidMacroHelper 整合"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] = "使用 DruidMacroHelper (/dmh) 为治疗药水、法力药水和治疗石构建变形宏。"
L["OPTIONS_DRUID_RETURN_FORM"] = "使用消耗品后，切换至"
L["DRUID_FORM_BEAR"] = "熊"
L["DRUID_FORM_CAT"] = "猎豹"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "暗夜精灵"
L["OPTIONS_SHADOWMELD_DRINKING"] = "影遁饮水"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] = "将影遁添加到你的水宏中，以便你在喝水时潜行。"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESCRIPTION"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "打开 Connoisseur 选项界面。"

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "启用宏"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] = "切换 Connoisseur 创建和维护哪些宏。禁用一个宏也会将其移除。"

-- Reset
L["OPTIONS_RESET_HEADER"] = "重置"
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "从忽略列表中移除所有物品。"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "你确定要清除忽略列表吗？"
L["OPTIONS_RESET_ALL"] = "重置所有 Connoisseur 选项"
L["OPTIONS_RESET_ALL_DESCRIPTION"] = "将所有设置和忽略列表重置为默认值。"
L["OPTIONS_RESET_ALL_CONFIRM"] = "将所有 Connoisseur 选项重置为默认值？"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "反馈与支持"
