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
	"看来你发现了一个BUG！%s (%s) 无法在 %s > %s (%s) 使用。请报告给我们以便修复。谢谢！ %s"
L["MSG_NO_ITEM"] = "背包中未找到合适的 %s。"
L["MSG_MACRO_SLOTS_FULL"] =
	"由于你的宏空位已满，部分 Connoisseur 宏无法创建。请删除不再使用的宏以释放空位，或在 选项 > 插件 > Connoisseur 中关闭不需要的宏。"

L["CHAT_LOADED"] =
	"版本 %s。设置（包括禁用此消息的选项）可以在 选项 > 插件 > Connoisseur 中找到。喜欢这个插件吗？告诉朋友吧！(="

L["CHAT_OPTIONS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开选项界面。"

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

-- Feature toggles shown in the mini-map tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "增益食物"
L["MENU_BUFF_FOOD_DESCRIPTION"] = '当缺少 "进食充分" BUFF时，优先使用提供该BUFF的食物。'
L["FEATURE_SCROLL_BUFFS"] = "卷轴增益"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "当你缺少卷轴增益时，将你的食物宏转变为卷轴施放器。"

-- Section titles and ignore-list actions in the mini-map tooltip.
L["UI_BEST_FOOD"] = "当前食物"
L["UI_BEST_PET_FOOD"] = "当前宠物食物"
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
L["UI_RESTOCKER_REPORT"] = "补货报告"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 项未完成订单"
L["UI_RESTOCKER_NEEDED"] = "%d 项未完成订单"
L["UI_RESTOCKER_STOCKED"] = "恭喜，你的补给已经备齐！"

-- Options entry at the bottom of the mini-map tooltip.
L["MENU_OPTIONS"] = "Connoisseur 选项"
L["MENU_OPTIONS_KEYBIND"] = "Shift + 中键点击"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

--[[
    Class-colored headers and conjure/pet tips shown in the mini-map tooltip for
    the player's class.
]]

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

--[[
    Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
    One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
]]

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

-- Generic labels reused across the mini-map tooltip and options panel.

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
	"自动取用你最好的食物、增益食物、水、药水、治疗石、绷带和卷轴的宏，外加一份补货清单，让你的背包始终充足，并随着你升级自动升级消耗品。便利性自动化，巅峰表现。"

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
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "当剩余不足 1 分钟时"
L["REAPPLY_THRESHOLD_N"] = "当剩余不足 %d 分钟时"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "准备确认"
L["OPTIONS_READY_CHECK"] = "在准备确认时报告状态"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"每次开始准备确认时，输出你缺少什么以及所追踪增益的剩余时间，仅你自己可见。"

--[[
    Three features are suppressed in a PvP Arena, and each says so with the
    same sentence. It lives here once and is appended at the call site
    (Options/Options-Macros.lua), so every locale translates it a single time
    and the caveat can never drift between the three.
]]
L["OPTIONS_DISABLED_IN_ARENAS"] = "在竞技场中禁用。"

--[[
    Buff Food. The section header reuses FEATURE_BUFF_FOOD, and the options
    description reuses MENU_BUFF_FOOD_DESCRIPTION plus the arena note above --
    the mini-map tooltip and the options panel say the same thing, so they read
    from one key rather than two copies of one sentence.
]]
L["OPTIONS_BUFF_FOOD"] = "优先增益食物"
L["OPTIONS_BUFF_FOOD_DETAIL"] = "专业提示：以自己为目标总是会让食物宏跳过增益食物和卷轴。"

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "包含卷轴增益"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"按一次施放缺少的卷轴，再按一次进食。卷轴不占用GCD且以你自己为目标；以友方玩家为目标时会跳过卷轴。"
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

--[[
    Ignore List. The rows are items, so the only copy here is the add box and
    the placeholder shown while the client is still resolving an item's name.
    The section header and the clear-all button reuse UI_IGNORE_LIST and
    MENU_CLEAR_IGNORE, which the mini-map tooltip already carries.
]]
L["OPTIONS_IGNORE_DESCRIPTION"] =
	"无论多好，Connoisseur 都不会选择这些物品。右键点击小地图按钮可忽略它当前推荐的食物，也可以在下方添加物品。"
L["OPTIONS_IGNORE_ADD_ID"] = "按物品 ID 添加"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"输入物品 ID，或在此输入框处于焦点时按住 Shift + 点击聊天中的物品链接。"
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "输入物品 ID，或按住 Shift + 点击聊天中的物品链接。"
L["OPTIONS_IGNORE_REMOVE"] = "移除"
L["OPTIONS_IGNORE_EMPTY"] = "此列表为空。"
L["OPTIONS_IGNORE_CLEAR_CONFIRM"] = "要从忽略列表中移除所有物品吗？"
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "正在载入 ID：%d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "宠物食物增益"
L["OPTIONS_USE_PET_BUFFS"] = "使用宠物食物增益"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'当你的宠物缺少 "进食充分" BUFF时，在你的食物宏中加入宠物食物。'
L["OPTIONS_PET_BUFF_TYPES"] = "在检查中包含宠物食物类型"
L["OPTIONS_PET_BUFF_KIBLERS"] = "基布雷尔的宠物食品"
L["OPTIONS_PET_BUFF_SPORELING"] = "孢子村点心"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "德鲁伊"
L["OPTIONS_DRUID_MACRO_HELPER"] = "启用 DruidMacroHelper 整合"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"使用 DruidMacroHelper (/dmh) 为治疗药水、法力药水和治疗石构建变形宏。"
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "返回熊形态"
L["DRUID_FORM_CAT"] = "返回猎豹形态"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "暗夜精灵"
L["OPTIONS_STEALTH_DRINKING"] = "启用喝水时潜行"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] = "将影遁添加到你的水宏中，以便你在喝水时潜行。"
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

--[[
    Restocker options panel. The tree label stays "Restocker" in every locale
    (brand fragment, localization allowlist); the panel header reuses
    RESTOCKER_WINDOW_TITLE.
]]
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"根据每个角色的补货清单保持背包补给充足。自动向商人购买，并在背包与银行之间搬运物品。输入 %s 打开清单。"
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "在银行打开"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "访问银行时打开 Restocker 窗口。"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "在商人处打开"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "访问商人时打开 Restocker 窗口。"
L["OPTIONS_RESTOCKER_REMIND"] = "启用城镇补货提醒"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"当补货清单尚有缺口，且你抵达旅店或城市，或登录时已身处其中，在聊天中输出提醒。"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "启用商人补货提醒"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"关闭商人窗口时报告未完成的补货订单。没有时保持安静。"
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "启用银行补货提醒"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"关闭银行时报告未完成的补货订单。没有时保持安静。"

--[[
    The starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] = "补货清单为空时启用清单助手"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"当此角色的补货清单为空时，在登录时提供一份入门补货清单。"

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "简洁"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "详细"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "播放声音"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] = "在提醒的同时播放提示音，适合聊天繁忙的时候。"
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "点击试听提示音。"
L["OPTIONS_RESTOCKER_DEBUG"] = "启用 Restocker 调试信息"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"在聊天框中逐步输出 Restocker 的银行/商人补货决策。信息较多；在关闭前会跨会话保持开启。"

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "补货窗口"
L["OPTIONS_RESTOCKER_ADVANCED_HEADER"] = "高级"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "致谢"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"我一直很喜欢 Restocker，很高兴它能在 Connoisseur 中继续存在。非常感谢编写了最初 Auto Restocker 的 ChiliFajita，以及在 Classic 与熊猫人之谜期间让它延续下来的 kvakvs 和 guardycmw。"

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "打开此插件的选项界面。"
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "打开 Restocker 窗口以管理你的补货清单。"

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "宏"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur 会为每种消耗品各建立一个宏，并随着背包变化保持更新，让你动作条上的按钮始终取用你身上最好的物品。请在下方选择要创建哪些宏，然后设置每个宏如何挑选物品。"
L["OPTIONS_ENABLE_MACROS_HEADER"] = "启用宏"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"切换 Connoisseur 创建和维护哪些宏。禁用一个宏也会将其移除。"

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "反馈与支持"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "版本"

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
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "在城里的时候别忘了补货！"

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
L["RESTOCKER_STILL_SHORT_ONE"] = "还有 1 项补货订单未完成。"
L["RESTOCKER_STILL_SHORT_MANY"] = "还有 %d 项补货订单未完成。"

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, old amount, new link, new amount },
    outgoing tier on the left and incoming on the right.

    Both amounts are carried because they are not always equal: a swap onto a
    tier the list already holds merges the two rows, so the new amount is the
    sum rather than the old amount moved across.
]]
L["RESTOCKER_UPGRADED"] = "你的补货清单已升级。"
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d 升级为 %sx%d。"

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
L["RESTOCKER_RESTOCKED_ONE"] = "已完成 1 项补货订单。"
L["RESTOCKER_RESTOCKED_MANY"] = "已完成 %d 项补货订单。"

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "有 1 项补货订单仅部分完成。"
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] = "有 %d 项补货订单仅部分完成。"

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "显示 Restocker 窗口。"
L["RESTOCKER_HELP_PROFILE_ADD"] = "添加一个以该名称命名的配置。"
L["RESTOCKER_HELP_PROFILE_DELETE"] = "删除该名称的配置。"
L["RESTOCKER_HELP_PROFILE_RENAME"] = "将当前配置重命名为该名称。"
L["RESTOCKER_HELP_PROFILE_COPY"] = "将该配置复制到当前配置。"
L["RESTOCKER_HELP_PROFILE_USE"] = "切换到该名称的配置。"

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
L["STARTER_POPUP_INTRO_EMPTY"] = "你的补货清单是空的，我们来添加一些物品好让你上手。"
L["STARTER_POPUP_INTRO_HOW"] =
	"你勾选的一切都会在打开商人或银行时自动补足，而常规物资会随着等级提升自动升级，所以你手上永远是当前最好的。"
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] = "你随时可以输入 %s 来调整这份清单，或稍后添加更多物品。"
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "食物与水"
L["STARTER_POPUP_FOOD_HEADER"] = "食物"
L["STARTER_POPUP_AMMO_HEADER"] = "弹药"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "子弹"
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
L["STARTER_POPUP_REAGENTS_HEADER"] = "材料与工具"
L["STARTER_POPUP_POISONS_HEADER"] = "毒药"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s ：把成品毒药加入清单，Connoisseur 会自动在任何出售材料的商人处购买。"
L["STARTER_POPUP_POISON_ANESTHETIC"] = "麻醉"
L["STARTER_POPUP_POISON_CRIPPLING"] = "致残"
L["STARTER_POPUP_POISON_DEADLY"] = "致命"
L["STARTER_POPUP_POISON_INSTANT"] = "速效"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "迟钝"
L["STARTER_POPUP_POISON_WOUND"] = "创伤"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "炉石"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "致盲粉"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "闪光粉"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "盗贼工具"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "尸体粉尘"
L["STARTER_POPUP_REAGENT_WILDS"] = "野生浆果"
L["STARTER_POPUP_REAGENT_SEEDS"] = "种子"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "奥术之尘"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "轻羽毛"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "传送符文"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "传送门符文"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "神圣符记"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "王者符记"
L["STARTER_POPUP_REAGENT_CANDLES"] = "蜡烛"
L["STARTER_POPUP_REAGENT_ANKH"] = "安卡"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "鱼鳞"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "鱼油"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "大地图腾"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "火焰图腾"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "水之图腾"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "空气图腾"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "恶魔雕像"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "地狱火石"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "灵魂碎片"
--[[
    Checkbox tooltips: { item link, amount }. The first is for ladder items;
    the second for single-tier reagents, which never upgrade.
]]
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"将 %s 加入你的补货清单，在背包中保留 %d 个，并随着你的等级自动升级。"
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] = "将 %s 加入补货清单，并在背包中保留 %d 个。"
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 for food, water and poisons, 200 for ammo); the tooltip
    below carries the per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 组"
L["STARTER_POPUP_STACK_MANY"] = "%d 组"
L["STARTER_POPUP_STACKS_DESCRIPTION"] = "要备多少组。这里的一组是 %d 个。"
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] =
	"要备多少个。这些不能堆叠，因此每个都会占用一个背包格。"
L["STARTER_POPUP_DISMISS"] = "此角色不再显示。"
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"否则每次登录时只要补货清单为空，这些建议就会再次出现。"

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "筛选物品..."
L["RESTOCKER_ADD_BUTTON"] = "添加"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "添加物品"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "从背包拖放一个物品，或输入数字物品 ID。"
-- In-box placeholder for the add row; the tooltip above carries the detail.
L["RESTOCKER_ADD_PLACEHOLDER"] = "将物品拖到此处，或输入其 ID..."
L["RESTOCKER_PROFILE_LABEL"] = "配置："
L["RESTOCKER_RENAME_LABEL"] = "重命名："
L["RESTOCKER_NEW_PROFILE"] = "新配置"
L["RESTOCKER_COPY_PROFILE"] = "复制"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in RS.SetupTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "将此配置克隆为一个新配置"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s 副本"
L["RESTOCKER_DELETE_PROFILE"] = "删除"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "删除此配置"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] = "确定要删除此配置吗？|n|n%s|n|n此操作无法撤销。"
--[[
    Row controls in the Restocker window. UPGRADE is disabled on any item that
    is not on a ladder in Data/Consumable-Upgrade-Paths.lua, which on a real
    list is most of them.
]]
L["RESTOCKER_UPGRADE_LABEL"] = "自动升级"
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "随等级升级"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"食物、水、弹药和药水随着等级有清晰的升级路线，所以 Connoisseur 会替你把这一项往上调。其余的则交给你自己慢慢调整。"

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "银行"
L["RESTOCKER_ROW_MERCHANT"] = "商人"
L["RESTOCKER_ROW_UPGRADE"] = "升级"

L["RESTOCKER_GROUP_OTHER"] = "其他"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "新增"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "将此物品从补货清单中移除"
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
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (优惠 %d%%)"
L["RESTOCKER_REPUTATION_ANY"] = "任意"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "友善"
L["RESTOCKER_REPUTATION_HONORED"] = "尊敬"
L["RESTOCKER_REPUTATION_REVERED"] = "崇敬"
L["RESTOCKER_REPUTATION_EXALTED"] = "崇拜"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]
L["RESTOCKER_REPUTATION_BUTTON_FORMAT"] = "声望：%s"

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "所需商人声望"
--[[
    Quotes the button's own label. That couples this line to
    RESTOCKER_REPUTATION_BUTTON_FORMAT and RESTOCKER_REPUTATION_ANY -- a locale
    that renders the button differently has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'选定一个声望等级后，Connoisseur 会跳过你尚未达到该等级的商人。"声望：任意"则向任何商人购买。'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"声望还会降低价格：友善 5%，尊敬 10%，崇敬 15%，崇拜 20%。"
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "点击进行更改。"
