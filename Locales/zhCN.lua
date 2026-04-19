local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "zhCN")
if not L then return end

-- [[ SIMPLIFIED CHINESE (zhCN) ]] --
L["BRAND"] = "Connoisseur"

-- Macro Names Can't Exceed 16 Total Characters
L["MACRO_BANDAGE"] = "- 绷带"
L["MACRO_FEED_PET"]= "- 喂养宠物"
L["MACRO_FOOD"]    = "- 食物"
L["MACRO_HPOT"]    = "- 治疗药水"
L["MACRO_HS"]      = "- 治疗石"
L["MACRO_MGEM"]    = "- 法力宝石"
L["MACRO_MPOT"]    = "- 法力药水"
L["MACRO_SS"]      = "- 灵魂石"
L["MACRO_WATER"]   = "- 水"

L["ERR_ZONE"] = "你不能在这里使用该物品。"
L["RANK"]     = "等级"

L["MSG_BUG_REPORT"] = "看来你发现了一个BUG！%s (%s) 无法在 %s > %s (%s) 使用。请报告给我们以便修复。谢谢！ https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"]    = "背包中未找到合适的 %s。"

L["MENU_BUFF_FOOD"]      = "优先增益食物"
L["MENU_BUFF_FOOD_DESC"] = "当缺少 \"进食充分\" BUFF时，优先使用提供该BUFF的食物。"
L["MENU_CLEAR_IGNORE"]   = "清除忽略列表"
L["MENU_IGNORE"]         = "忽略"
L["MENU_RESET"]          = "重置"
L["MENU_SCAN"]           = "强制扫描"
L["MENU_TITLE"]          = "消耗品"

L["MENU_SCROLL_BUFFS"]      = "卷轴增益"
L["MENU_SCROLL_BUFFS_DESC"] = "当缺少卷轴增益时，在你的食物宏中使用属性卷轴。"
L["MENU_OPTIONS_HINT"]      = "在 选项 > 插件 > Connoisseur 中有更多选项可用。"

L["PREFIX_HUNTER"]  = "猎人请注意"
L["PREFIX_MAGE"]    = "法师请注意"
L["PREFIX_WARLOCK"] = "术士请注意"

L["TIP_DOWNRANK"]        = "选中低等级玩家为目标时，宏将制造适合其等级的物品。"
L["TIP_HUNTER_FEED_PET"] = "喂养宠物是一个多合一的宠物按钮！点击可自动召唤、喂养或复活你的宠物。右键点击或在战斗中使用会施放治疗宠物。按住Shift强制复活，按住Ctrl解散。"
L["TIP_MAGE_CONJURE"]    = "右键点击你的食物或水宏以制造食物或水。"
L["TIP_MAGE_GEM"]        = "右键点击你的法力宝石宏以制造一颗新的宝石。再次右键点击以制造一颗低等级备用宝石。"
L["TIP_MAGE_TABLE"]      = "中键点击以施放召唤餐桌。"
L["TIP_WARLOCK_CONJURE"] = "右键点击你的治疗石或灵魂石宏以制造治疗石或灵魂石。"
L["TIP_WARLOCK_SOUL"]    = "中键点击以施放灵魂仪式。"

L["UI_BEST_FOOD"]    = "当前最佳食物"
L["UI_BEST_PET_FOOD"]= "当前宠物食物"
L["UI_DISABLED"]     = "已禁用"
L["UI_ENABLED"]      = "已启用"
L["UI_IGNORE_LIST"]  = "忽略列表"
L["UI_LEFT_CLICK"]   = "左键点击"
L["UI_MIDDLE_CLICK"] = "中键点击"
L["UI_RIGHT_CLICK"]  = "右键点击"
L["UI_SHIFT_LEFT"]   = "Shift + 左键点击"
L["UI_TOGGLE"]       = "切换"

L["MODE_ALWAYS"] = "总是"
L["MODE_PARTY"]  = "仅在小队时"
L["MODE_RAID"]   = "仅在团队时"

-- Options Panel
L["OPTIONS_DESC"] = "为你最好的消耗品创建自动更新宏，追踪增益状态以保持你的最佳表现。为猎人提供多合一的自动喂食功能，为法师和术士提供根据目标等级自适应的智能右键制造功能。"
L["OPTIONS_BUFF_FOOD"]         = "优先增益食物"
L["OPTIONS_BUFF_FOOD_DESC"]    = "当缺少 \"进食充分\" BUFF时，优先使用提供该BUFF的食物。"
L["OPTIONS_SCROLL_HEADER"]     = "卷轴增益"
L["OPTIONS_USE_SCROLLS"]       = "包含卷轴增益"
L["OPTIONS_USE_SCROLLS_DESC"]  = "当缺少卷轴增益时，在你的食物宏中使用卷轴。"
L["OPTIONS_SCROLL_TYPES"]      = "在检查中包含卷轴类型"
L["OPTIONS_SCROLL_AGILITY"]    = "敏捷"
L["OPTIONS_SCROLL_INTELLECT"]  = "智力"
L["OPTIONS_SCROLL_PROTECTION"] = "防护"
L["OPTIONS_SCROLL_SPIRIT"]     = "精神"
L["OPTIONS_SCROLL_STAMINA"]    = "耐力"
L["OPTIONS_SCROLL_STRENGTH"]   = "力量"

L["OPTIONS_PET_HEADER"]        = "宠物食物增益"
L["OPTIONS_USE_PET_BUFFS"]     = "使用宠物食物增益"
L["OPTIONS_USE_PET_BUFFS_DESC"]= "当你的宠物缺少 \"进食充分\" BUFF时，在你的食物宏中使用宠物食物。"
L["OPTIONS_PET_BUFF_TYPES"]    = "在检查中包含宠物食物类型"
L["OPTIONS_PET_BUFF_KIBLERS"]  = "基布雷尔的宠物食品"
L["OPTIONS_PET_BUFF_SPORELING"]= "孢子村点心"

L["OPTIONS_NIGHTELF_HEADER"]           = "暗夜精灵"
L["OPTIONS_SHADOWMELD_DRINKING"]      = "影遁饮水"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "将影遁添加到你的水宏中，以便你在喝水时潜行。"

L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"]   = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "打开 Connoisseur 选项界面。"

L["OPTIONS_ENABLE_MACROS_HEADER"] = "启用宏"
L["OPTIONS_ENABLE_MACROS_DESC"]   = "切换 Connoisseur 创建和维护哪些宏。禁用一个宏也会将其移除。"

L["OPTIONS_RESET_HEADER"]         = "重置"
L["OPTIONS_RESET_IGNORE_DESC"]    = "从忽略列表中移除所有物品。"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "你确定要清除忽略列表吗？"
L["OPTIONS_RESET_ALL"]            = "重置所有 Connoisseur 选项"
L["OPTIONS_RESET_ALL_DESC"]       = "将所有设置和忽略列表重置为默认值。"
L["OPTIONS_RESET_ALL_CONFIRM"]    = "将所有 Connoisseur 选项重置为默认值？"

L["OPTIONS_COMMUNITY_HEADER"]     = "反馈与支持"