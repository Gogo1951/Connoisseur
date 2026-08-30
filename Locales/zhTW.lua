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
-- Readiness Report
--------------------------------------------------------------------------------

--[[
    Printed when a ready check starts, as a header plus up to three lines. Each
    line is a set of "Label : a, b, c" clauses joined by ". ", and every part of
    it is dropped when it has nothing to say -- a clean character prints nothing
    at all, so there is no all-clear string here and must not be one.
]]

L["READINESS_TITLE"] = "就緒報告"

-- Clause labels, in the order the lines print them.
L["READINESS_MISSING_BUFFS"] = "缺少增益："
L["READINESS_EXPIRING"] = "即將到期："
L["READINESS_MISSING_ITEMS"] = "缺少物品："
L["READINESS_DAMAGED_GEAR"] = "受損裝備："
L["READINESS_CHARACTER"] = "角色："
L["READINESS_QUESTIONABLE_GEAR"] = "裝備了非戰鬥裝備："

--[[
    What the report calls each thing. Deliberately its own set rather than the
    shared LABEL_* keys the macro messages use: those name an item you are being
    offered ("Health Potion"), these name a gap in your preparation ("Healing
    Potion"), and the two want to be reworded independently.
]]
L["READINESS_FLASK"] = "合劑或 2 種藥劑"
L["READINESS_WELL_FED"] = "進食充分"
L["READINESS_PET_WELL_FED"] = "進食充分（寵物）"
L["READINESS_SCROLLS"] = "卷軸"
L["READINESS_SOULSTONE"] = "靈魂石未啟用"
L["READINESS_MAIN_HAND"] = "主手"
L["READINESS_OFF_HAND"] = "副手"
L["READINESS_HEALTHSTONE"] = "治療石"
L["READINESS_MANA_GEM"] = "法力寶石"
L["READINESS_HEALING_POTION"] = "治療藥水"
L["READINESS_MANA_POTION"] = "法力藥水"
L["READINESS_BANDAGES"] = "繃帶"
L["READINESS_PVP_ON"] = "PvP 已開啟！"

-- { buff name, whole minutes left }
L["READINESS_TIME_MINUTES"] = "%s %d 分鐘"
-- %s is the buff name; used when under a minute is left.
L["READINESS_TIME_EXPIRING"] = "%s 不足 1 分鐘"
-- { dominant talent tree, slash-joined point spread }
L["READINESS_SPEC_FORMAT"] = "%s (%s)"
-- %d is the number of talent points the character has not spent.
L["READINESS_UNSPENT_TALENTS"] = "%d 點未分配天賦"

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
--[[
    The value shown beside an item title when nothing resolved. Kept to a single
    word so it fits in the tooltip's right column, which never wraps -- the full
    sentence, MSG_NO_ITEM, explains it on the wrapping line underneath.
]]
L["UI_NONE"] = "無"
L["UI_IGNORE_LIST"] = "忽略列表"
L["MENU_IGNORE"] = "忽略"
L["MENU_CLEAR_IGNORE"] = "清除忽略列表"

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
L["UI_RESTOCKER_REPORT"] = "補貨報告"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 項未完成訂單"
L["UI_RESTOCKER_NEEDED"] = "%d 項未完成訂單"
L["UI_RESTOCKER_STOCKED_SHORT"] = "補給齊全"
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
    tip names the macro it belongs to -- the blocks cover more than one macro,
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
    One per macro type (resolved via ns.MacroConfig in ConnNoItem), plus Pet Food.
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
	"在你的動作條按鈕上顯示巨集名稱文字。預設為關閉，會隱藏遊戲自行顯示的名稱。"

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
L["OPTIONS_READINESS_HEADER"] = "就緒報告"
L["OPTIONS_READINESS_ENABLE"] = "在準備確認時啟用就緒報告"
--[[
    Says what the report does AND that it stays quiet, because the quiet is the
    feature: a player who turns this on and sees nothing for three pulls has to
    know that is the report working rather than the report broken.
]]
L["OPTIONS_READINESS_DESCRIPTION"] =
	"準備確認開始時，輸出一份僅自己可見的清單，列出還需要處理的問題。你已就緒時它什麼也不說。"

--[[
    The reset button under the master toggle. It needs a control of its own
    because these settings are account-wide: the stock Reset Profile reaches
    only the character's own profile, so nothing else on any panel can return
    them to their defaults.

    The confirm names the one consequence a player would not otherwise predict.
    Off is what the report ships as, so resetting switches it back off, and a
    page that emptied itself with no warning would read as a bug.
]]
L["OPTIONS_READINESS_RESET"] = "重置就緒報告設定"
L["OPTIONS_READINESS_RESET_DESCRIPTION"] =
	"將本頁的所有開關和兩個閾值恢復為全新安裝時的設定。其他頁面不受影響。"
L["OPTIONS_READINESS_RESET_CONFIRM"] =
	"將就緒報告的所有設定重置為預設值？這也會重新關閉報告本身。"

--[[
    The three sections, each a real header over the switches it covers. They name
    what the line is called in chat, so the panel and the report read as the same
    feature.
]]
L["OPTIONS_READINESS_BUFFS_HEADER"] = "缺少增益"
L["OPTIONS_READINESS_ITEMS_HEADER"] = "缺少物品"
L["OPTIONS_READINESS_CHARACTER_HEADER"] = "角色"

-- Missing Buffs
L["OPTIONS_READINESS_FLASK"] = "合劑或 2 種藥劑"
L["OPTIONS_READINESS_FLASK_DESCRIPTION"] =
	"擁有一瓶合劑，或一瓶戰鬥藥劑加一瓶守護藥劑，即視為已備齊。"
L["OPTIONS_READINESS_WELL_FED"] = "進食充分"
L["OPTIONS_READINESS_WELL_FED_DESCRIPTION"] = "需要在巨集設定中開啟增益食物。"
L["OPTIONS_READINESS_PET_WELL_FED"] = "進食充分（寵物）"
L["OPTIONS_READINESS_PET_WELL_FED_DESCRIPTION"] = "僅限獵人。需要在巨集設定中開啟寵物食物增益。"
L["OPTIONS_READINESS_SCROLLS"] = "卷軸增益"
L["OPTIONS_READINESS_SCROLLS_DESCRIPTION"] = "以你在巨集設定中選擇使用的卷軸為準。"
--[[
    The one entry that asks about the GROUP rather than the player's own bags,
    which the helper text has to say outright: a raid carrying seven unused
    stones is not covered, and one deployed stone covers it.
]]
L["OPTIONS_READINESS_SOULSTONE"] = "靈魂石未啟用"
L["OPTIONS_READINESS_SOULSTONE_DESCRIPTION"] =
	"檢查是否有靈魂石在某人身上生效，而不是有一顆躺在背包裡。需要隊伍中有術士。"
L["OPTIONS_READINESS_MAIN_HAND"] = "主手武器增益"
L["OPTIONS_READINESS_OFF_HAND"] = "副手武器增益"
L["OPTIONS_READINESS_WEAPON_DESCRIPTION"] =
	"任何臨時武器附魔都算：磨刀石、油劑、毒藥或薩滿的武器增益。"
--[[
    Says the Shaman exemption outright, because a main-hand line that goes quiet
    the moment a Shaman joins reads as a broken switch otherwise.
]]
L["OPTIONS_READINESS_MAIN_HAND_DESCRIPTION"] = "任何臨時武器附魔都算。隊伍中有薩滿時保持沉默。"
--[[
    Names the OTHER threshold so the two cannot be mistaken for each other: the
    Macros panel has one that decides when a macro treats a buff as spent, and
    this one only decides when the report mentions it.
]]
L["OPTIONS_READINESS_EXPIRING"] = "增益到期時間少於"
L["OPTIONS_READINESS_EXPIRING_DESCRIPTION"] =
	"列出你身上所有即將消失的增益，而不只是 Connoisseur 施加的。與巨集設定裡的增益補充相互獨立，那邊決定巨集何時提供新的增益。"
-- %s is a whole or half number of minutes.
L["OPTIONS_READINESS_EXPIRING_MINUTES"] = "%s 分鐘"
-- The one-minute entry alone; one plural template cannot render it grammatically.
L["OPTIONS_READINESS_EXPIRING_MINUTES_ONE"] = "1 分鐘"

-- Missing Items
L["OPTIONS_READINESS_HEALTHSTONE"] = "治療石"
L["OPTIONS_READINESS_HEALTHSTONE_DESCRIPTION"] =
	"僅當隊伍中有可以索取的術士，或你自己就是術士時才顯示。"
L["OPTIONS_READINESS_MANA_GEM"] = "法力寶石"
L["OPTIONS_READINESS_MANA_GEM_DESCRIPTION"] = "僅當你使用法師時顯示。"
L["OPTIONS_READINESS_HEALING_POTION"] = "治療藥水"
L["OPTIONS_READINESS_HEALING_POTION_DESCRIPTION"] = "最好在開戰前備足。戰鬥中沒人能遞給你藥水。"
L["OPTIONS_READINESS_MANA_POTION"] = "法力藥水"
L["OPTIONS_READINESS_MANA_POTION_DESCRIPTION"] = "僅當你使用需要法力的職業時顯示。"
L["OPTIONS_READINESS_BANDAGES"] = "繃帶"
L["OPTIONS_READINESS_BANDAGES_DESCRIPTION"] = "在你沒有任何可用繃帶時提醒，急救技能也計算在內。"
L["OPTIONS_READINESS_DURABILITY"] = "受損裝備低於"
L["OPTIONS_READINESS_DURABILITY_DESCRIPTION"] =
	"連結每件耐久度低於該值的已裝備物品。按單件計算，所以一件損壞的武器也會顯示。"
-- %d is a durability percentage.
L["OPTIONS_READINESS_DURABILITY_PERCENT"] = "%d%%"

-- Character
L["OPTIONS_READINESS_SPEC"] = "當前天賦"
L["OPTIONS_READINESS_SPEC_DESCRIPTION"] = "輸出你的天賦分配，以及尚未使用的點數。"
L["OPTIONS_READINESS_PVP"] = "PvP 標記開啟"
L["OPTIONS_READINESS_PVP_DESCRIPTION"] = "當你的 PvP 標記開啟時發出警告。"
L["OPTIONS_READINESS_QUESTIONABLE_GEAR"] = "裝備了非戰鬥裝備"
L["OPTIONS_READINESS_QUESTIONABLE_GEAR_DESCRIPTION"] =
	"連結不該出現在戰鬥中的已裝備物品，比如 PvP 飾品或魚竿。"

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
    Ignore List panel (Options-Ignore-List.lua). One tree scope per list: the
    account-wide Global list, then one per character. The rows are items, so
    the copy here is the panel description, the scope and promote labels, the
    add box, and the placeholder shown while the client is still resolving an
    item's name. The mini-map tooltip's section keeps its own UI_IGNORE_LIST
    and MENU_CLEAR_IGNORE keys.
]]
L["OPTIONS_IGNORE_LIST_TAB"] = "忽略列表"
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"被忽略的物品不會被任何巨集選中。食物、水、藥水，任何東西都一樣。全域列表對所有角色生效，角色列表只對該角色生效。右鍵點擊小地圖按鈕可忽略目前最佳食物。"
L["OPTIONS_IGNORE_GLOBAL"] = "全域"
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] = "將該物品移到全域列表，使其在所有角色上都被忽略。"
L["OPTIONS_IGNORE_ADD_ID"] = "以物品 ID 新增"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"輸入物品 ID，或在此輸入框取得焦點時按住 Shift + 點擊聊天中的物品連結。"
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "輸入物品 ID，或按住 Shift + 點擊聊天中的物品連結。"
L["OPTIONS_IGNORE_REMOVE"] = "移除"
L["OPTIONS_IGNORE_EMPTY"] = "此列表為空。"
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
    The Starter List Builder pop-up. This toggle and the pop-up's own "Don't
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

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "補貨視窗"

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
L["RESTOCKER_PROFILE_EXISTS"] = '已存在名為"%s"的清單。'
L["RESTOCKER_BANK_NOT_OPEN"] = "銀行未開啟。"
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (ns.OnRestockerBankOpen), not stored as a preference.
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
--[[
    Printed once per vendor visit when the crafting-reagent buyer stands down:
    this merchant stocks some of the reagents the Restock List needs but not
    all of them, and reagents buy all-or-nothing (VendorStocksAllReagents in
    Features/Restocker/Restocker-Merchant.lua). Silent at vendors stocking none.
]]
L["RESTOCKER_REAGENTS_SKIPPED"] =
	"這個商人沒有販售你的毒藥所需的全部材料。跳過購買這些材料。"
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

    The claim has to be earned, which is why the merchant restock's PurchaseMerchantItem
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
L["RESTOCKER_HELP_PROFILE_ADD"] = "新增一個以該名稱命名的清單。"
L["RESTOCKER_HELP_PROFILE_DELETE"] = "刪除該名稱的清單。"
L["RESTOCKER_HELP_PROFILE_RENAME"] = "將當前清單重新命名為該名稱。"
L["RESTOCKER_HELP_PROFILE_COPY"] = "將該清單複製到當前清單。"
L["RESTOCKER_HELP_PROFILE_USE"] = "切換到該名稱的清單。"

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
L["STARTER_POPUP_INTRO_EMPTY"] = "你的補貨清單是空的，我們來新增一些物品好讓你上手。"
-- Shown instead when the window is opened over a list that already has items on it.
L["STARTER_POPUP_INTRO_STOCKED"] =
	"勾選你想保持補給的基礎物資。已在你補貨清單上的物品會顯示為已勾選。"
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
	"%s ：把成品毒藥加入清單，Connoisseur 會自動在任何販售全部所需材料的商人處購買。"
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
L["RESTOCKER_FILTER_CLEAR_TOOLTIP"] = "清除"
L["RESTOCKER_ADD_BUTTON"] = "新增"
L["RESTOCKER_LIST_BUILDER_BUTTON"] = "開啟清單助手"
L["RESTOCKER_LIST_BUILDER_TOOLTIP"] =
	"開啟清單助手，內容與新角色收到的基礎物資相同。助手開啟期間此視窗會關閉。"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "新增物品"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "從背包拖放一個物品，或輸入數字物品 ID。"
--[[
    In-box placeholder for the add row; the tooltip above carries the detail.
    Kept to a phrase rather than a sentence: it sets the width of both boxes on
    that row, and the row cannot afford two fields wide enough for a long one.
]]
L["RESTOCKER_ADD_PLACEHOLDER"] = "將物品拖曳至此，或輸入其 ID"
L["RESTOCKER_PROFILE_LABEL"] = "清單"
L["RESTOCKER_PROFILE_TOOLTIP"] =
	"此角色正在使用的補貨清單。點擊可切換到其他清單，或新建一個。"
L["RESTOCKER_RENAME_LABEL"] = "重新命名"
L["RESTOCKER_NEW_PROFILE"] = "新清單"
L["RESTOCKER_COPY_PROFILE"] = "複製"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in ns.SetupRestockerTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "將此清單複製為一個新清單"
-- %s becomes "<list name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s 副本"
L["RESTOCKER_DELETE_PROFILE"] = "刪除"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "刪除此清單"
L["RESTOCKER_RENAME_TOOLTIP"] = "重新命名此清單。所有使用它的角色都會跟隨新名稱。"
-- %s is the list name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] = "確定要刪除此清單嗎？|n|n%s|n|n此操作無法復原。"
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

--[[
    Column headings over the list.

    Keep these SHORT. A heading sets its column's width, and every pixel a
    heading takes comes out of the item name beside it. Six full-length
    headings do not fit beside a readable name at the smallest window size.

    "Take" and "Store" are short because they never appear alone: both sit
    under a "Bank" band, which is what makes them exact. Translate them as a
    pair with that band in mind, and keep them a single short word each.
]]
L["RESTOCKER_COLUMN_ITEM"] = "物品"
L["RESTOCKER_COLUMN_WITHDRAW"] = "取出"
L["RESTOCKER_COLUMN_DEPOSIT"] = "存入"
L["RESTOCKER_COLUMN_REPUTATION"] = "聲望"
L["RESTOCKER_COLUMN_AMOUNT"] = "數量"

L["RESTOCKER_GROUP_OTHER"] = "其他"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "新增"
--[[
    The category pane's first entry, above the item types. Selected by default,
    and the only way back to the whole list once a type has been picked, so it
    has to read as "everything" rather than as another type.
]]
L["RESTOCKER_GROUP_ALL"] = "全部物品"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "將此物品從補貨清單中移除"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "補貨數量"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "編輯完成後按 Enter。"
L["RESTOCKER_BUY_LABEL"] = "購買"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "向商人購買"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "商人視窗開啟時購買所需數量。"

--[[
    Some vendor slots hold only a few units and trickle back over time, which is
    how Classic sells its scarce consumables. Extra empties those slots outright
    rather than buying the shortfall, so the tooltip has to say three things: what
    it buys, that unlimited stock is never touched, and why anyone would want it.
]]
L["RESTOCKER_EXTRA_LABEL"] = "額外"
L["RESTOCKER_EXTRA_TOOLTIP_TITLE"] = "額外購買"
L["RESTOCKER_EXTRA_TOOLTIP_STOCK"] = "買光商人此物品的全部存貨，即使超出你的目標數量。"
L["RESTOCKER_EXTRA_TOOLTIP_LIMITED"] =
	"僅對限量存貨生效，即商人緩慢補貨的稀缺商品。無限供應的商品不受影響。"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "存入銀行"
--[[
    Names the Amount column, so it is coupled to RESTOCKER_COLUMN_AMOUNT: a locale
    that renders that heading differently has to say the same word here, or the
    sentence points at a column the player cannot find.
]]
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] = "銀行開啟時將多餘物品存入銀行。填 0 表示全部存入。"
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

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "所需商人聲望"
--[[
    Quotes the cell's own value, which couples this line to
    RESTOCKER_REPUTATION_ANY: a locale that renders that standing differently
    has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'選定一個聲望等級後，Connoisseur 會跳過你尚未達到該等級的商人。"聲望：任意"則向任何商人購買。'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"聲望還會降低價格：友好 5%，尊敬 10%，崇敬 15%，崇拜 20%。"
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "點擊進行變更。"
