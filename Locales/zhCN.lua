local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "zhCN")
if not L then
	return
end

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
L["MACRO_EXPLOSIVES"] = "- 爆炸物"
L["MACRO_FEED_PET"] = "- 喂养宠物"
L["MACRO_FOOD"] = "- 食物"
L["MACRO_HEALTH_POTION"] = "- 治疗药水"
L["MACRO_HEALTHSTONE"] = "- 治疗石"
L["MACRO_MANA_GEM"] = "- 法力宝石"
L["MACRO_MANA_POTION"] = "- 法力药水"
L["MACRO_POISONS"] = "- 毒药"
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

L["MSG_BUG_REPORT"] =
	"看来你发现了一个BUG！%s (%s) 无法在 %s > %s (%s) 使用。请报告给我们以便修复。谢谢！ https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "背包中未找到合适的 %s。"
L["MSG_MACRO_SLOTS_FULL"] =
	"由于你的宏空位已满，部分 Connoisseur 宏无法创建。请删除不再使用的宏以释放空位，或在 选项 > 插件 > Connoisseur 中关闭不需要的宏。"

L["CHAT_LOADED"] =
	"版本 %s。设置（包括禁用此消息的选项）可以在 选项 > 插件 > Connoisseur 中找到。喜欢这个插件吗？告诉朋友吧！(="

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "准备就绪！"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "缺少：%s"

L["READY_WELL_FED"] = "进食充分"
L["READY_SCROLLS"] = "卷轴"
L["READY_PET_FED"] = "宠物已进食"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d 分钟"
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s 不足 1 分钟"

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "你目前没有任何对宠物有用的食物。"
L["TIP_PET_NO_SKILLS"] = "你目前还没有学会召唤宠物、解散宠物、喂养宠物或复活宠物。"
L["TIP_PET_NO_MEND"] = "你目前还没有学会治疗宠物。"
L["TIP_NO_HAND_POISON"] = "这把武器所选的毒药已用完。"

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "你目前还没有学会%s。"

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["MENU_BUFF_FOOD"] = "增益食物"
L["MENU_BUFF_FOOD_DESCRIPTION"] = '当缺少 "进食充分" BUFF时，优先使用提供该BUFF的食物。'
L["MENU_SCROLL_BUFFS"] = "卷轴增益"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "当你缺少卷轴增益时，将你的食物宏转变为卷轴施放器。"

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "当前食物"
L["UI_BEST_PET_FOOD"] = "当前宠物食物"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "主手"
L["UI_OFF_HAND"] = "副手"
L["UI_IGNORE_LIST"] = "忽略列表"
L["MENU_IGNORE"] = "忽略"
L["MENU_CLEAR_IGNORE"] = "清除忽略列表"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Connoisseur 选项"
L["MENU_OPTIONS_KEYBIND"] = "Shift + 中键点击"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

L["PREFIX_HUNTER"] = "猎人请注意"
L["PREFIX_MAGE"] = "法师请注意"
L["PREFIX_ROGUE"] = "潜行者请注意"
L["PREFIX_WARLOCK"] = "术士请注意"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to — the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "关于你的喂养宠物宏……"
L["TIP_MAGE_MACROS"] = "关于你的食物、水和法力宝石宏……"
L["TIP_ROGUE_MACROS"] = "关于你的毒药宏……"
L["TIP_WARLOCK_MACROS"] = "关于你的治疗石和灵魂石宏……"

L["TIP_HUNTER_ALL_IN_ONE"] = "喂养宠物是一个全能宠物按钮！"
L["TIP_HUNTER_CALL"] = "左键点击可自动召唤、喂养或复活你的宠物。"
L["TIP_HUNTER_MEND"] = "右键点击或等到进入战斗即可施放治疗宠物。"
L["TIP_HUNTER_MODIFIERS"] = "按住 Shift 强制复活，按住 Ctrl 解散宠物。"

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "右键点击你的食物或水宏以制造食物或水。"
L["TIP_MAGE_DOWNRANK"] = "以等级较低的玩家为目标时，将制造适合其等级的食物或水。"
L["TIP_MAGE_TABLE"] = "中键点击你的食物或水宏以施放召唤餐桌。"
L["TIP_MAGE_GEM"] =
	"右键点击你的法力宝石宏以制造一颗新的宝石。再次右键点击以制造一颗低等级备用宝石。"

L["TIP_WARLOCK_HEALTHSTONE"] =
	"右键点击你的治疗石宏以制造治疗石。再次右键点击以制造一颗低等级备用治疗石。"
L["TIP_WARLOCK_DOWNRANK"] = "以等级较低的玩家为目标时，将制造适合其等级的治疗石。"
L["TIP_WARLOCK_SOULSTONE"] = "右键点击你的灵魂石宏以制造灵魂石。"
L["TIP_WARLOCK_SOUL"] = "中键点击你的治疗石宏以施放灵魂仪式。"

L["TIP_ROGUE_OFF_HAND"] = "左键点击涂抹你的副手毒药。"
L["TIP_ROGUE_MAIN_HAND"] = "右键点击涂抹你的主手毒药。"
L["TIP_ROGUE_REPLACE"] = "已有毒药会自动替换。"
L["TIP_ROGUE_WINDOW"] = "中键点击打开毒药制作窗口。"

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

L["LABEL_BANDAGE"] = "绷带"
L["LABEL_EXPLOSIVE"] = "爆炸物"
L["LABEL_FOOD"] = "食物"
L["LABEL_HEALTH_POTION"] = "治疗药水"
L["LABEL_HEALTHSTONE"] = "治疗石"
L["LABEL_MANA_GEM"] = "法力宝石"
L["LABEL_MANA_POTION"] = "法力药水"
L["LABEL_PET_FOOD"] = "宠物食物"
L["LABEL_POISONS"] = "毒药"
L["LABEL_SOULSTONE"] = "灵魂石"
L["LABEL_WATER"] = "水"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the minimap tooltip and options panel.

L["UI_ENABLED"] = "已启用"
L["UI_DISABLED"] = "已禁用"
L["UI_TOGGLE"] = "切换"
L["UI_LEFT_CLICK"] = "左键点击"
L["UI_RIGHT_CLICK"] = "右键点击"
L["UI_MIDDLE_CLICK"] = "中键点击"
L["UI_SHIFT_LEFT"] = "Shift + 左键点击"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "总是"
L["MODE_PARTY"] = "仅在小队或团队时"
L["MODE_RAID"] = "仅在团队时"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"为你最好的食物、增益食物、水、药水、治疗石、卷轴、灵魂石、绷带、毒药和爆炸物创建自动更新的宏。一键制造，智能喂养宠物，自动向商人和银行补货。最佳营养，巅峰表现。"

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "启用欢迎消息"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "登录时在聊天框打印欢迎消息。"

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "启用小地图按钮"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "显示小地图按钮。"

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "在按钮上显示宏名称"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"在你的动作条按钮上显示宏名称文字。默认关闭，将隐藏暴雪最近重新显示的名称。"

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "药水与治疗石"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"宏在战斗中无法更改（这是暴雪的限制），因此每个药水和治疗石宏都预先包含你最好的物品以及最多两个备用物品。在较长的战斗中，图标和提示可能会过时并显示错误的物品，但点击该宏将始终使用你背包中实际拥有的最佳物品。"
L["OPTIONS_COMBINE_HEALTHSTONES"] = "将治疗石合并到治疗药水宏中"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"将你最好的治疗石添加到治疗药水宏的底部，这样按一次即可同时使用药水和治疗石。"

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "增益重新应用"
L["OPTIONS_REAPPLY"] = "提前补充即将到期的增益"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"战斗时长常常超过增益的剩余时间。剩余时间低于阈值的增益将视为已过期，宏会在开怪前提供新的增益。适用于增益食物、卷轴增益和宠物食物增益。"
L["OPTIONS_REAPPLY_THRESHOLD"] = "视为过期的条件"
L["REAPPLY_THRESHOLD_ONE"] = "剩余不足 1 分钟"
L["REAPPLY_THRESHOLD_N"] = "剩余不足 %d 分钟"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "准备确认"
L["OPTIONS_READY_CHECK"] = "在准备确认时报告状态"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"每次开始准备确认时，输出你缺少什么以及所追踪增益的剩余时间，仅你自己可见。"

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "增益食物"
L["OPTIONS_BUFF_FOOD"] = "优先增益食物"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'当缺少 "进食充分" BUFF时，优先使用提供该BUFF的食物。在竞技场中禁用。'
L["OPTIONS_BUFF_FOOD_DETAIL"] = "专业提示：以自己为目标总是会让食物宏跳过增益食物和卷轴。"

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "卷轴增益"
L["OPTIONS_USE_SCROLLS"] = "包含卷轴增益"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"按一次施放缺少的卷轴，再按一次进食。卷轴不占用GCD且以你自己为目标；以友方玩家为目标时会跳过卷轴。在竞技场中禁用。"
L["OPTIONS_SCROLL_TYPES"] = "在检查中包含卷轴类型"
L["OPTIONS_SCROLL_AGILITY"] = "敏捷"
L["OPTIONS_SCROLL_INTELLECT"] = "智力"
L["OPTIONS_SCROLL_PROTECTION"] = "防护"
L["OPTIONS_SCROLL_SPIRIT"] = "精神"
L["OPTIONS_SCROLL_STAMINA"] = "耐力"
L["OPTIONS_SCROLL_STRENGTH"] = "力量"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "爆炸物"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"@player 选项会跳过目标指示圈，直接在你脚下引爆炸弹，非常适合目标处于近战距离时使用。"
L["EXPLOSIVES_MODE_ATPLAYER"] = "左键点击 @player，右键点击投掷"
L["EXPLOSIVES_MODE_TOSS"] = "左键点击投掷，右键点击 @player"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "宠物食物增益"
L["OPTIONS_USE_PET_BUFFS"] = "使用宠物食物增益"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'当你的宠物缺少 "进食充分" BUFF时，在你的食物宏中加入宠物食物。在竞技场中禁用。'
L["OPTIONS_PET_BUFF_TYPES"] = "在检查中包含宠物食物类型"
L["OPTIONS_PET_BUFF_KIBLERS"] = "基布雷尔的宠物食品"
L["OPTIONS_PET_BUFF_SPORELING"] = "孢子村点心"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "德鲁伊"
L["OPTIONS_DRUID_MACRO_HELPER"] = "启用 DruidMacroHelper 整合"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"使用 DruidMacroHelper (/dmh) 为治疗药水、法力药水和治疗石构建变形宏。"
L["OPTIONS_DRUID_RETURN_FORM"] = "使用消耗品后，切换至"
L["DRUID_FORM_BEAR"] = "熊"
L["DRUID_FORM_CAT"] = "猎豹"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "暗夜精灵"
L["OPTIONS_SHADOWMELD_DRINKING"] = "启用喝水时潜行"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] = "将影遁添加到你的水宏中，以便你在喝水时潜行。"
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	"将影遁添加到你的食物宏中，以便你在进食时潜行。"
L["OPTIONS_STEALTH_PICK_ONE"] =
	"专业提示：只选一个。你可以同时进食和喝水，但潜行后再进食或喝水会解除潜行。"

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "潜行者"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"让毒药宏始终装载每种毒药类型可用的最高等级。左键涂抹副手，右键涂抹主手，已有毒药会自动替换。"
L["OPTIONS_POISON_MAIN_HAND"] = "主手毒药类型"
L["OPTIONS_POISON_OFF_HAND"] = "副手毒药类型"
L["OPTIONS_STEALTH_EATING"] = "启用进食时潜行"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] = "将潜行添加到你的食物宏中，以便你在进食时潜行。"

-- Restocker. The section header reuses RESTOCKER_WINDOW_TITLE.
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"根据每个角色的补货清单保持背包补给充足。自动向商人购买，并在背包与银行之间搬运物品。输入 /crs 打开清单。"
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "在银行打开"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "访问银行时打开 Restocker 窗口。"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "在商人处打开"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "访问商人时打开 Restocker 窗口。"
L["OPTIONS_RESTOCKER_DEBUG"] = "启用 Restocker 调试信息"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"在聊天框中逐步输出 Restocker 的银行/商人补货决策。信息较多；在关闭前会跨会话保持开启。"

-- /Commands. The command literals stay in code; these are the descriptions.
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_FOODIE_DETAIL"] = "打开 Connoisseur 选项界面。"
L["OPTIONS_COMMANDS_CRS_DETAIL"] = "打开 Restocker 窗口以管理你的补货清单。"

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "启用宏"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"切换 Connoisseur 创建和维护哪些宏。禁用一个宏也会将其移除。"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "反馈与支持"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "已导入你的 Restocker 清单。"
L["RESTOCKER_PROFILE_EXISTS"] = '已存在名为"%s"的配置。'
L["RESTOCKER_BANK_NOT_OPEN"] = "银行未打开。"
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"补货完成。打开银行时按住 Shift 可跳过补货。输入 %s 编辑你的补货清单。"
L["RESTOCKER_STOPPED_BOTH_FULL"] = "补货已停止。你的背包和银行都已满。"
L["RESTOCKER_STOPPED_BANK_FULL"] = "补货已停止。你的银行已满；请腾出一格后重新打开。"
L["RESTOCKER_STOPPED_BAG_FULL"] = "补货已停止。你的背包已满；请腾出一格后重新打开银行。"
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "补货已停止。无法继续进行。"
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] = "补货已停止。无法移动：%s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (多余)"
L["RESTOCKER_STOPPED_ERROR"] = "补货因错误而停止：%s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] = "你的背包已满。跳过商人补货。"
L["RESTOCKER_FINISHED_RESTOCKING"] = "补货结束（购买：%d）。"

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "显示 Restocker 窗口。"
L["RESTOCKER_HELP_PROFILE_ADD"] = "添加一个以该名称命名的配置。"
L["RESTOCKER_HELP_PROFILE_DELETE"] = "删除该名称的配置。"
L["RESTOCKER_HELP_PROFILE_RENAME"] = "将当前配置重命名为该名称。"
L["RESTOCKER_HELP_PROFILE_COPY"] = "将该配置复制到当前配置。"
L["RESTOCKER_HELP_PROFILE_USE"] = "切换到该名称的配置。"

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "筛选物品..."
L["RESTOCKER_ADD_BUTTON"] = "添加"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "添加物品"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "从背包拖放一个物品，或输入数字物品 ID。"
L["RESTOCKER_PROFILE_LABEL"] = "配置："
L["RESTOCKER_RENAME_LABEL"] = "重命名："
L["RESTOCKER_NEW_PROFILE"] = "新配置"
L["RESTOCKER_COPY_PROFILE"] = "复制"
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "将此配置克隆为一个新配置。"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s 副本"
L["RESTOCKER_DELETE_PROFILE"] = "删除"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "删除此配置。"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] = "确定要删除此配置吗？|n|n%s|n|n此操作无法撤销。"
L["RESTOCKER_GROUP_OTHER"] = "其他"
L["RESTOCKER_REMOVE_TOOLTIP"] = "将此物品从补货清单中移除。"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "补货数量"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "编辑完成后按回车。"
L["RESTOCKER_BUY_LABEL"] = "购买"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "向商人购买"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "商人窗口打开时购买所需数量。"
L["RESTOCKER_DEPOSIT_LABEL"] = "存入"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "存入银行"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] = "银行打开时将多余物品存入银行。填 0 表示全部存入。"
L["RESTOCKER_WITHDRAW_LABEL"] = "取出"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "从银行补货"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "银行打开时从银行取出所需物品。"

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "所需声望"
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (优惠 %d%%)"
L["RESTOCKER_REPUTATION_ANY"] = "任意"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "友善"
L["RESTOCKER_REPUTATION_HONORED"] = "尊敬"
L["RESTOCKER_REPUTATION_REVERED"] = "崇敬"
L["RESTOCKER_REPUTATION_EXALTED"] = "崇拜"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "所需商人声望"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] = "只向声望不低于此等级的商人购买。"
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"声望越高价格也越便宜（友善 5%，尊敬 10%，崇敬 15%，崇拜 20%）。"
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "点击选择声望等级。"
