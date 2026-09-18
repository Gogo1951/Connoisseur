local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "zhTW")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

--[[
    Macro names cannot exceed 16 total characters. Macros are found by name, so
    a shipped name never changes: a new translation creates a second macro and
    leaves every player's existing one stale on their action bar.
]]

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

--[[
    Spliced into /cast lines as "Spell(Rank N)" when a macro pins a spell rank,
    so it must be the client's own rank word, never a nicer synonym -- a locale
    that changes it breaks every rank-pinned macro for players in that client.
]]

L["RANK"] = "等級"

-- Joins the items of a printed list: a Readiness Report clause, or the Restocker's "Couldn't move" list.
L["LIST_SEPARATOR"] = "、"

--------------------------------------------------------------------------------
-- Pet Diets
--------------------------------------------------------------------------------

--[[
    Diet names as returned by the pet diet reader, which is localized. These
    values MUST match the client's strings exactly (verify in-game with a pet
    out: /dump GetPetFoodTypes() on Era and TBC,
    /dump C_PetInfo.GetPetFoodTypes() on Forever). Used to build
    ns.PET_DIET_MAP in Data/Pet-Foods.lua.

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

-- { item link, item ID, zone, subzone, map ID, Discord link }
L["MESSAGE_BUG_REPORT"] =
	"看來你發現了一個錯誤！%s (%s) 無法在 %s > %s (%s) 使用。請將此問題回報給我們，以便修正。謝謝！%s"
L["MESSAGE_NO_ITEM"] = "背包中未找到合適的%s。"
L["MESSAGE_MACRO_SLOTS_FULL"] =
	"由於你的巨集欄位已滿，部分 Connoisseur 巨集未能建立。請刪除不再使用的巨集以騰出欄位，或在 選項 > 插件 > Connoisseur > 巨集 中關閉不需要的 Connoisseur 巨集。"

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

    The joins are keys of their own so a locale can use its own punctuation:
    READINESS_CLAUSE_FORMAT puts a clause's label before its items, the items
    are joined with LIST_SEPARATOR, and the clauses with
    READINESS_CLAUSE_SEPARATOR.
]]

L["READINESS_TITLE"] = "就緒報告"
-- { clause label, its items }
L["READINESS_CLAUSE_FORMAT"] = "%s%s"
L["READINESS_CLAUSE_SEPARATOR"] = "。"

-- Clause labels, in the order the lines print them.
L["READINESS_MISSING_BUFFS"] = "缺少增益："
L["READINESS_EXPIRING"] = "即將到期："
L["READINESS_MISSING_ITEMS"] = "缺少物品："
L["READINESS_DAMAGED_GEAR"] = "受損裝備："
L["READINESS_CHARACTER"] = "角色："
L["READINESS_QUESTIONABLE_GEAR"] = "裝備了非戰鬥裝備："

--[[
    What the report calls each thing. The Readiness Report panel labels its
    switches with these same keys, so a switch names exactly the line it
    controls; a switch that needs other words than its line (Main Hand Weapon
    Buff, PvP Flag On) keeps an OPTIONS_READINESS_* label of its own.

    Deliberately its own set rather than the shared LABEL_* keys the macro
    messages use: those name an item you are being offered ("Health Potion"),
    these name a gap in your preparation ("Healing Potion"), and the two want
    to be reworded independently.
]]
L["READINESS_FLASK"] = "精煉藥劑或 2 種藥劑"
L["READINESS_WELL_FED"] = "吃飽喝足"
L["READINESS_PET_WELL_FED"] = "吃飽喝足（寵物）"
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
-- Talent points the character has not spent: exactly one, or %d for two or more.
L["READINESS_UNSPENT_TALENTS_ONE"] = "1 個未使用的天賦點"
L["READINESS_UNSPENT_TALENTS_MANY"] = "%d 個未使用的天賦點"

--------------------------------------------------------------------------------
-- ConnoisseurTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnoisseurTip("key") or ConnoisseurTipIf. See Features/Macros/Runtime.lua.

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
L["MENU_BUFF_FOOD_DESCRIPTION"] = '缺少"吃飽喝足"增益時，優先使用可提供該增益的食物。'
L["FEATURE_SCROLL_BUFFS"] = "卷軸增益"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "當你缺少卷軸增益時，將你的食物巨集轉變為卷軸施放器。"

-- Section titles and ignore-list actions in the mini-map tooltip.
L["MINIMAP_BEST_FOOD"] = "當前食物"
L["MINIMAP_BEST_PET_FOOD"] = "當前寵物食物"
-- Weapon-slot titles beside the rogue's resolved poison, in the Attention Rogues block.
L["MINIMAP_MAIN_HAND"] = "主手"
L["MINIMAP_OFF_HAND"] = "副手"
--[[
    The value shown beside an item title when nothing resolved. Kept to a single
    word so it fits in the tooltip's right column, which never wraps -- the full
    sentence, MESSAGE_NO_ITEM, explains it on the wrapping line underneath.
]]
L["MINIMAP_NONE"] = "無"
L["MINIMAP_IGNORE_LIST"] = "忽略列表"
L["MENU_IGNORE"] = "忽略"
L["MENU_CLEAR_IGNORE"] = "清除忽略列表"

--[[
    Restocker Report block in the mini-map tooltip. While the outstanding
    restocking orders are few enough to fit, it lists them under the header,
    one item per row; past that it shows only how many there are, beside the
    header. An order is one Restock List row with Buy switched on that is still
    short in your bags, so the count is of rows and not of missing units -- nine
    outstanding orders can be nine single juices or nine full stacks. The header
    beside it supplies the "restocking", so the count only needs the noun.

    The count only ever stands in for a list too long to show, so it is never
    one and needs no singular.

    The count sits in the tooltip's right column, beside the header, so it has
    to stay short enough to read as a value rather than a sentence. The
    all-stocked case has no header and no count: STOCKED replaces the whole
    row, on a wrapping line of its own, so it can be a full sentence.

    ITEM_COUNT is the right-hand value of a listed row: { have, wanted }, the
    ratio RESTOCKER_REMINDER_ITEM prints. Wordless, so there is nothing to
    translate, but a key anyway for the same reason that one is.
]]
L["MINIMAP_RESTOCKER_REPORT"] = "Restocker 報告"
L["MINIMAP_RESTOCKER_NEEDED"] = "%d 項未完成訂單"
L["MINIMAP_RESTOCKER_ITEM_COUNT"] = "%d/%d"
L["MINIMAP_RESTOCKER_STOCKED"] = "恭喜，你的補給已全部備齊！"

-- Options entry at the bottom of the mini-map tooltip.
L["MENU_OPTIONS"] = "Connoisseur 選項"
L["MENU_OPTIONS_KEYBIND"] = "Shift + 中鍵點擊"

--------------------------------------------------------------------------------
-- Class Tips
--------------------------------------------------------------------------------

--[[
    Class-colored headers and click tips shown in the mini-map tooltip for the
    player's class.
]]

L["PREFIX_HUNTER"] = "獵人請注意"
L["PREFIX_MAGE"] = "法師請注意"
L["PREFIX_ROGUE"] = "盜賊請注意"
L["PREFIX_WARLOCK"] = "術士請注意"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line. The Mage
    and Warlock tips name the macro they belong to, since those blocks cover
    more than one macro and a bare "Right-Click" would be ambiguous; the Hunter
    and Rogue blocks cover one macro each, which the subtitle names.

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
L["TIP_HUNTER_MEND"] = "右鍵點擊，或在戰鬥中點擊，即可施放治療寵物。"
L["TIP_HUNTER_MODIFIERS"] = "按住 Shift 強制復活，按住 Ctrl 解散寵物。"

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "右鍵點擊你的食物或水巨集以施放造食術或造水術。"
L["TIP_MAGE_DOWNRANK"] = "以等級較低的玩家為目標時，將製造適合其等級的食物或水。"
L["TIP_MAGE_TABLE"] = "中鍵點擊你的食物或水巨集以施放餐點儀式。"
L["TIP_MAGE_GEM"] =
	"右鍵點擊你的法力寶石巨集以製造一顆新的寶石。再次右鍵點擊以製造一顆低等級備用寶石。"

L["TIP_WARLOCK_HEALTHSTONE"] =
	"右鍵點擊你的治療石巨集以施放製造治療石。再次右鍵點擊以製造一顆低等級備用治療石。"
L["TIP_WARLOCK_DOWNRANK"] = "以等級較低的玩家為目標時，將製造適合其等級的治療石。"
L["TIP_WARLOCK_SOULSTONE"] = "右鍵點擊你的靈魂石巨集以施放製造靈魂石。"
L["TIP_WARLOCK_SOUL"] = "中鍵點擊你的治療石巨集以施放靈魂儀式。"

L["TIP_ROGUE_OFF_HAND"] = "左鍵點擊塗抹你的副手毒藥。"
L["TIP_ROGUE_MAIN_HAND"] = "右鍵點擊塗抹你的主手毒藥。"
L["TIP_ROGUE_REPLACE"] = "既有毒藥會自動替換。"
L["TIP_ROGUE_WINDOW"] = "中鍵點擊開啟毒藥製作視窗。"

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

--[[
    One label per macro type, dropped as-is into other strings: MESSAGE_NO_ITEM
    ("No suitable %s found...") from ConnoisseurNoItem and the mini-map tooltip,
    and OPTIONS_MACRO_TOGGLE_DESCRIPTION. LABEL_WATER is also the List Builder's
    Water checkbox.
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

-- Generic labels used in the mini-map tooltip.

L["MINIMAP_ENABLED"] = "已啟用"
L["MINIMAP_DISABLED"] = "已停用"
L["MINIMAP_TOGGLE"] = "切換"
L["MINIMAP_LEFT_CLICK"] = "左鍵點擊"
L["MINIMAP_RIGHT_CLICK"] = "右鍵點擊"
L["MINIMAP_MIDDLE_CLICK"] = "中鍵點擊"
L["MINIMAP_SHIFT_LEFT"] = "Shift + 左鍵點擊"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

-- Caption and hover text on the mode sub-row under Buff Food, Scroll Buffs, and Pet Food Buffs; %s is that section's name.
L["OPTIONS_MODE_CAPTION"] = "使用時機"
L["OPTIONS_MODE_DESCRIPTION"] = "選擇你的食物巨集何時提供%s：總是提供，或僅在組隊時提供。"
L["MODE_ALWAYS"] = "總是"
L["MODE_PARTY"] = "僅在隊伍或團隊中"
L["MODE_RAID"] = "僅在團隊中"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"自動取用你最好的食物、增益食物、水、藥水、治療石、繃帶和卷軸的巨集，外加一份補貨清單，讓你的背包始終充足，並隨著你升級自動升級消耗品。為巔峰表現打造的便利性自動化。"

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "啟用歡迎訊息"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "登入時在聊天視窗中輸出歡迎訊息。"

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "啟用小地圖按鈕"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "顯示小地圖按鈕。"

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "在按鈕上顯示巨集名稱"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"在你的快捷列按鈕上顯示巨集名稱文字，Connoisseur 預設會隱藏這些文字。"

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "藥水與治療石"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"巨集在戰鬥中無法更改（這是暴雪的限制），因此每個藥水和治療石巨集都預先包含你最好的物品以及最多兩個備用物品。在較長的戰鬥中，圖示和提示可能會過時並顯示錯誤的物品，但點擊該巨集將始終使用你背包中實際擁有的最佳物品。"
L["OPTIONS_COMBINE_HEALTHSTONES"] = "將治療石合併到治療藥水巨集中"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"將你最好的治療石加入治療藥水巨集的底部，這樣按一次即可同時使用藥水和治療石。"

-- Mana Gems & Runes
L["OPTIONS_MANA_GEMS_HEADER"] = "法力寶石與符文"
L["OPTIONS_MANA_GEMS_DESCRIPTION"] =
	"惡魔符文和黑暗符文與法力寶石共用冷卻時間，但使用時會消耗生命力，因此除非你選擇加入，否則法力寶石巨集不會包含它們。"
L["OPTIONS_INCLUDE_MANA_RUNES"] = "將惡魔符文和黑暗符文加入法力寶石巨集"
L["OPTIONS_INCLUDE_MANA_RUNES_DESCRIPTION"] =
	"將你的惡魔符文和黑暗符文與法力寶石一同排序，這樣當符文是你的最佳選擇或你的法力寶石用完時，法力寶石巨集就會使用符文。"

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "增益重新施放"
L["OPTIONS_REAPPLY"] = "提前補充即將到期的增益"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"將剩餘時間低於你所設門檻的增益食物、卷軸增益和寵物食物增益視為已到期，讓你的巨集在開怪前提供新的增益。"
--[[
    Threshold dropdown, on the sub-row under the Re-Apply toggle. The values
    carry the "when" themselves, so the caption only names the setting.
]]
L["OPTIONS_REAPPLY_THRESHOLD_CAPTION"] = "門檻"
L["OPTIONS_REAPPLY_THRESHOLD_DESCRIPTION"] =
	"設定增益離到期還剩多久時，你的巨集就會提供新的增益。"
L["REAPPLY_THRESHOLD_ONE"] = "當剩餘不足 1 分鐘時"
L["REAPPLY_THRESHOLD_MANY"] = "當剩餘不足 %d 分鐘時"

-- Readiness Report
L["TAB_READINESS_REPORT"] = "就緒報告"
L["OPTIONS_READINESS_ENABLE"] = "在準備確認時啟用就緒報告"
--[[
    Says what the report does AND that it stays quiet, because the quiet is the
    feature: a player who turns this on and sees nothing for three pulls has to
    know that is the report working rather than the report broken.
]]
L["OPTIONS_READINESS_DESCRIPTION"] =
	"準備確認開始時，輸出一份僅你可見的清單，列出仍需處理的事項；如果你已準備就緒，則完全不會輸出任何內容。"

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
	"將本頁的所有開關和兩個門檻恢復為預設值，其他頁面皆不受影響。"
L["OPTIONS_READINESS_RESET_CONFIRM"] =
	"將就緒報告的所有設定重置為預設值？這也會重新關閉報告本身。"

--[[
    The three sections, each a real header over the switches it covers. They
    name what the line is called in chat, so the panel and the report read as
    the same feature.
]]
L["OPTIONS_READINESS_BUFFS_HEADER"] = "缺少增益"
L["OPTIONS_READINESS_ITEMS_HEADER"] = "缺少物品"
L["OPTIONS_READINESS_CHARACTER_HEADER"] = "角色"

-- Missing Buffs
L["OPTIONS_READINESS_FLASK_DESCRIPTION"] =
	"一瓶精煉藥劑，或戰鬥藥劑與守護藥劑各一瓶，均視為已滿足。"
L["OPTIONS_READINESS_WELL_FED_DESCRIPTION"] = "需要在巨集頁面中開啟增益食物。"
L["OPTIONS_READINESS_PET_WELL_FED_DESCRIPTION"] =
	"僅限獵人，且需要在巨集頁面中開啟寵物食物增益。"
L["OPTIONS_READINESS_SCROLLS"] = "卷軸增益"
L["OPTIONS_READINESS_SCROLLS_DESCRIPTION"] =
	"需要在巨集頁面中開啟卷軸增益，並且只檢查該處所選的卷軸類型。"
--[[
    The one entry that asks about the GROUP rather than the player's own bags,
    which the helper text has to say outright: a raid carrying seven unused
    stones is not covered, and one deployed stone covers it.
]]
L["OPTIONS_READINESS_SOULSTONE_DESCRIPTION"] =
	"僅限術士：檢查隊伍中是否有人身上有生效的靈魂石，而不是背包裡是否有一顆靈魂石。"
L["OPTIONS_READINESS_MAIN_HAND"] = "主手武器增益"
--[[
    Says the Shaman exemption outright, because a main-hand line that goes quiet
    the moment a Shaman joins reads as a broken switch otherwise.
]]
L["OPTIONS_READINESS_MAIN_HAND_DESCRIPTION"] =
	"任何臨時武器附魔都算，且隊伍中有薩滿時不會回報此項。"
L["OPTIONS_READINESS_OFF_HAND"] = "副手武器增益"
L["OPTIONS_READINESS_OFF_HAND_DESCRIPTION"] =
	"任何臨時武器附魔都算：磨刀石、油劑、毒藥或薩滿的武器增益。"
--[[
    Names the OTHER threshold so the two cannot be mistaken for each other: the
    Macros panel has one that decides when a macro treats a buff as spent, and
    this one only decides when the report mentions it.
]]
L["OPTIONS_READINESS_EXPIRING"] = "增益到期時間少於"
L["OPTIONS_READINESS_EXPIRING_DESCRIPTION"] =
	"列出你身上所有即將到期的增益，而不僅是 Connoisseur 施加的那些；此設定與巨集頁面中的增益重新施放相互獨立。"
-- %s is a whole or half number of minutes.
L["OPTIONS_READINESS_EXPIRING_MINUTES"] = "%s 分鐘"
-- The one-minute entry alone; one plural template cannot render it grammatically.
L["OPTIONS_READINESS_EXPIRING_MINUTES_ONE"] = "1 分鐘"
L["OPTIONS_READINESS_EXPIRING_CAPTION"] = "剩餘時間"
L["OPTIONS_READINESS_EXPIRING_THRESHOLD_DESCRIPTION"] =
	"設定增益離到期還剩多久時，報告才會列出它。"

-- Missing Items
L["OPTIONS_READINESS_HEALTHSTONE_DESCRIPTION"] =
	"僅當隊伍中有可以索取的術士，或你自己就是術士時才顯示。"
L["OPTIONS_READINESS_MANA_GEM_DESCRIPTION"] = "僅當你的角色是法師時顯示。"
L["OPTIONS_READINESS_HEALING_POTION_DESCRIPTION"] =
	"值得在開怪前備好，因為戰鬥中沒人能遞給你藥水。"
L["OPTIONS_READINESS_MANA_POTION_DESCRIPTION"] = "僅當你的角色是使用法力的職業時顯示。"
L["OPTIONS_READINESS_BANDAGES_DESCRIPTION"] = "當你身上沒有急救技能允許使用的繃帶時提醒。"
L["OPTIONS_READINESS_DURABILITY"] = "受損裝備低於"
L["OPTIONS_READINESS_DURABILITY_DESCRIPTION"] =
	"連結耐久度低於該值的每件已裝備物品；按單件計算，因此即使只有一把武器損壞也會顯示。"
-- %d is a durability percentage.
L["OPTIONS_READINESS_DURABILITY_PERCENT"] = "%d%%"
L["OPTIONS_READINESS_DURABILITY_CAPTION"] = "耐久度"
L["OPTIONS_READINESS_DURABILITY_THRESHOLD_DESCRIPTION"] =
	"設定物品耐久度降到多低時，報告才會連結它。"

-- Character
L["OPTIONS_READINESS_SPEC"] = "當前天賦"
L["OPTIONS_READINESS_SPEC_DESCRIPTION"] = "輸出你的天賦分配，以及尚未使用的點數。"
L["OPTIONS_READINESS_PVP"] = "PvP 標記開啟"
L["OPTIONS_READINESS_PVP_DESCRIPTION"] = "當你的 PvP 標記開啟時發出警告。"
L["OPTIONS_READINESS_QUESTIONABLE_GEAR"] = "裝備了非戰鬥裝備"
L["OPTIONS_READINESS_QUESTIONABLE_GEAR_DESCRIPTION"] =
	"連結不該出現在戰鬥中的已裝備物品，比如騎乘馬鞭或魚竿。"

--[[
    Buff Food. The section header reuses FEATURE_BUFF_FOOD. The options
    description is a key of its own because it carries the arena exception,
    which the mini-map tooltip's MENU_BUFF_FOOD_DESCRIPTION has no room for.
]]
L["OPTIONS_BUFF_FOOD"] = "優先增益食物"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'缺少"吃飽喝足"增益時，優先使用可提供該增益的食物，競技場中除外。'
L["OPTIONS_BUFF_FOOD_DETAIL"] = "專業提示：以自己為目標總會讓食物巨集跳過增益食物和卷軸。"

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "包含卷軸增益"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"你的食物巨集第一次按下時會使用缺少的卷軸，再按一次則進食；以友方玩家為目標或身處競技場時會跳過卷軸。"
L["OPTIONS_SCROLL_TYPES"] = "在檢查中包含卷軸類型"
L["OPTIONS_SCROLL_AGILITY"] = "敏捷"
L["OPTIONS_SCROLL_INTELLECT"] = "智力"
L["OPTIONS_SCROLL_PROTECTION"] = "保護"
L["OPTIONS_SCROLL_SPIRIT"] = "精神"
L["OPTIONS_SCROLL_STAMINA"] = "耐力"
L["OPTIONS_SCROLL_STRENGTH"] = "力量"
-- Hover text on each scroll type and pet food type; %s is that type's own label.
L["OPTIONS_BUFF_TYPE_DESCRIPTION"] = '檢查缺少的增益時包含"%s"。'

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "爆炸物"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"@player 選項會跳過目標指示圈，直接將爆炸物在你腳下引爆，非常適合目標處於近戰距離時使用。"
L["OPTIONS_EXPLOSIVES_CLICK_LAYOUT"] = "點擊方式"
L["OPTIONS_EXPLOSIVES_CLICK_LAYOUT_DESCRIPTION"] =
	"選擇用哪個鍵投擲爆炸物，用哪個鍵將它在你腳下引爆。"
L["EXPLOSIVES_MODE_ATPLAYER"] = "左鍵點擊 @player，右鍵點擊投擲"
L["EXPLOSIVES_MODE_TOSS"] = "左鍵點擊投擲，右鍵點擊 @player"

--[[
    Ignore List panel (Options-Ignore-List.lua). One tree scope per list: the
    account-wide Global list, then the current character and every other
    character with something ignored. The rows are items, so the copy here is
    the panel description, the scope and promote labels, the add box, Remove,
    the empty-list line, and LOADING_ITEM, the placeholder shown while the
    client is still resolving an item's name (the mini-map tooltip and the List
    Builder use it too). The mini-map tooltip's section keeps its own
    MINIMAP_IGNORE_LIST and MENU_CLEAR_IGNORE keys.
]]
L["TAB_IGNORE_LIST"] = "忽略列表"
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"被忽略的物品永遠不會被任何巨集選用。食物、水、藥水，任何東西都一樣。全域列表對所有角色生效；角色列表只對該角色生效。右鍵點擊小地圖按鈕可忽略你當前的最佳食物。"
L["OPTIONS_IGNORE_GLOBAL"] = "全域"
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] = "將此物品移至全域列表，使其在所有角色上都被忽略。"
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
	'當你的寵物缺少"吃飽喝足"增益時，將寵物食物加入你的食物巨集，競技場中除外。'
L["OPTIONS_PET_BUFF_TYPES"] = "在檢查中包含寵物食物類型"
L["OPTIONS_PET_BUFF_KIBLERS"] = "基布雷爾的零嘴"
L["OPTIONS_PET_BUFF_SPORELING"] = "小孢子點心"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "德魯伊"
L["OPTIONS_DRUID_MACRO_HELPER"] = "啟用 DruidMacroHelper 整合"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"使用 DruidMacroHelper (/dmh) 為治療藥水、法力藥水和治療石建立變形巨集。"
--[[
    Return-form dropdown, on the sub-row under the DruidMacroHelper toggle. The
    macro powershifts out of form, uses the consumable, then returns to this
    one, so the values name that return.
]]
L["OPTIONS_DRUID_RETURN_FORM_CAPTION"] = "返回形態"
L["OPTIONS_DRUID_RETURN_FORM_DESCRIPTION"] = "選擇你的變形巨集在使用物品後讓你返回哪種形態。"
L["DRUID_FORM_BEAR"] = "返回熊形態"
L["DRUID_FORM_CAT"] = "返回獵豹形態"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "夜精靈"
L["OPTIONS_STEALTH_DRINKING"] = "啟用喝水時潛行"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] = "將影遁加入你的水巨集中，以便你在喝水時潛行。"
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	"將影遁加入你的食物巨集中，以便你在進食時潛行。"
L["OPTIONS_STEALTH_PICK_ONE"] =
	"專業提示：只選一個。你可以同時進食和喝水，但潛行後再進食或喝水會解除潛行。"

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "盜賊"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"讓毒藥巨集始終裝載每種毒藥類型可用的最高等級。左鍵塗抹副手，右鍵塗抹主手，既有毒藥會自動替換。"
L["OPTIONS_POISON_MAIN_HAND"] = "主手毒藥類型"
L["OPTIONS_POISON_OFF_HAND"] = "副手毒藥類型"
L["OPTIONS_POISON_MAIN_HAND_DESCRIPTION"] = "選擇你的毒藥巨集在右鍵點擊時塗抹到主手的毒藥。"
L["OPTIONS_POISON_OFF_HAND_DESCRIPTION"] = "選擇你的毒藥巨集在左鍵點擊時塗抹到副手的毒藥。"
--[[
    Poison group names for the poison dropdowns, shown only until the client has
    cached the group's base item and can name it itself.
]]
L["POISON_GROUP_ANESTHETIC"] = "麻醉毒藥"
L["POISON_GROUP_CRIPPLING"] = "致殘毒藥"
L["POISON_GROUP_DEADLY"] = "致命毒藥"
L["POISON_GROUP_INSTANT"] = "速效毒藥"
L["POISON_GROUP_MIND_NUMBING"] = "麻痺毒藥"
L["POISON_GROUP_WOUND"] = "致傷毒藥"
-- Shared by the Rogue (Stealth) and Night Elf (Shadowmeld) toggles; a character sees one at most.
L["OPTIONS_STEALTH_EATING"] = "啟用進食時潛行"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] = "將潛行加入你的食物巨集中，以便你在進食時潛行。"

--[[
    Restocker options panel. The tree label stays "Restocker" in every locale:
    it is the feature's proper name, so there is nothing in it to translate.
]]
L["TAB_RESTOCKER"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"根據你的補貨清單保持背包物資充足，自動向商人購買，並在背包與銀行之間搬運物品。輸入 %s 開啟清單。"
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "在銀行開啟"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "造訪銀行時開啟 Restocker 視窗。"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "在商人處開啟"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "造訪商人時開啟 Restocker 視窗。"
L["OPTIONS_RESTOCKER_REMIND"] = "啟用城鎮補貨提醒"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"當補貨清單尚有缺口，且你抵達旅店或城市，或登入時已身處其中，在聊天中輸出提醒。"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "啟用商人補貨提醒"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] = "關閉商人視窗時，回報所有未完成的補貨訂單。"
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "啟用銀行補貨提醒"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] = "關閉銀行時，回報所有未完成的補貨訂單。"

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

    One word each, deliberately: the sub-row dropdown holding them is only wide
    enough to clear its arrow.
]]
L["OPTIONS_RESTOCKER_REMIND_MODE_CAPTION"] = "詳細程度"
L["OPTIONS_RESTOCKER_REMIND_MODE_DESCRIPTION"] =
	"選擇提醒只有一行，還是為你缺少的每件物品各加一行。"
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "簡潔"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "詳細"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "播放音效"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] = "在提醒的同時播放提示音，適合聊天繁忙的時候。"
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "點擊試聽提示音。"

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "Restocker 視窗"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale; the sentences around them translate.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "致謝"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"我一直很喜歡 Restocker，很感激能有機會讓它在 Connoisseur 中延續下去。非常感謝撰寫最初 Auto Restocker 的 ChiliFajita，以及在經典版與潘達利亞之謎期間一直維護它的 kvakvs 和 guardycmw。"

--[[
    /Commands. Both halves of each line are locale keys: the literal, which
    stays identical in every locale since a slash command has nothing to
    translate, and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的選項介面。"
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "開啟 Restocker 視窗以管理你的補貨清單。"

--[[
    Macros panel. TAB_MACROS is the panel's label in the settings tree and the
    title on the page; OPTIONS_MACROS_DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section,
    after the page's one headerless toggle, Macro Names on Buttons.
]]
L["TAB_MACROS"] = "巨集"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur 會為每種消耗品各建立一個巨集，並隨著背包變化保持更新，讓你快捷列上的按鈕始終取用你身上最好的物品。請在下方選擇要建立哪些巨集，然後設定每個巨集如何挑選物品。"
L["OPTIONS_ENABLE_MACROS_HEADER"] = "啟用巨集"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"選擇 Connoisseur 要建立並維護哪些巨集。關閉某個巨集也會將其移除。"
-- Hover text on each Enable Macros toggle; %s is the consumable's label (LABEL_*).
L["OPTIONS_MACRO_TOGGLE_DESCRIPTION"] = "建立並維護%s巨集，取消勾選時會將其移除。"

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale; VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "回饋與支援"
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
    Printed during a merchant restock when the crafting-reagent buyer stands
    down: this merchant stocks some of the reagents the Restock List needs but
    not all of them, and reagents buy all-or-nothing (VendorStocksAllReagents in
    Features/Restocker/Restocker-Merchant.lua). Silent at vendors stocking none.
]]
L["RESTOCKER_REAGENTS_SKIPPED"] =
	"這個商人沒有販售你的毒藥所需的全部材料。跳過購買這些材料。"
-- Printed on reaching an inn or a city while the Restock List is short of something.
L["RESTOCKER_TOWN_REMINDER"] = "在城裡的時候別忘了補貨！"

--[[
    Headline for the merchant and bank reminders, which report on the way out
    rather than nudging on arrival, so the count is the message. The in-town
    reminder keeps its own line above.

    The count is of restocking orders -- Restock List rows with Buy switched on
    that are still short in your bags -- so it never says "items", and never
    puts a bare count after "short": "short 9 apples" reads as nine apples
    missing, while the number here is nine ROWS, each short by anything from one
    juice to a full stack. "Order" can only mean a line on a list, and it is the
    word the code uses (BuildPurchaseOrder, purchaseOrders).

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
    Printed after buying at a vendor. Counts restocking orders FILLED -- Restock
    List rows and poison ingredients whose whole requested amount was ordered --
    not BuyMerchantItem calls. Forty juice bought in two stacks of twenty is one
    order filled; six of a requested twenty is not one at all, and belongs to
    the partial line below.

    The claim has to be earned, which is why the merchant restock's
    PurchaseMerchantItem reports whether it ordered the full amount instead of
    the caller inferring it from a unit count. What the vendor did not stock is
    deliberately not mentioned here: the mini-map's Restocker Report owns the
    outstanding state, this line owns the event, and neither repeats the other.
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
L["RESTOCKER_HELP_PROFILE_USE"] = "將此角色切換到該名稱的清單。"

--[[
    Starter List pop-up, the List Builder: offers staples at login when the
    Restock List is empty, and on demand from the Restocker window
    (Features/Restocker/Restocker-Starter-List.lua). Its title reuses
    RESTOCKER_WINDOW_TITLE below, and the six food staples reuse the DIET_ keys
    above, so each food row carries the client's own pet diet name.

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
    The first section's heading names the Water row beneath it as well; the
    food-only heading is the fallback for a section with no Water row.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "食物與水"
L["STARTER_POPUP_FOOD_HEADER"] = "食物"
L["STARTER_POPUP_AMMO_HEADER"] = "彈藥"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "子彈"
L["STARTER_POPUP_ARROWS"] = "箭矢"
--[[
    The Reagents & Tools section: the Hearthstone, plus each class's tools and
    spell reagents. Rogues additionally get a Poisons section of their own,
    whose note under the header reuses PREFIX_ROGUE (rogue-colored at the call
    site) to say the ingredients take care of themselves. The poison labels
    are short forms on purpose -- the section heading plus the tooltip's exact
    rank carry the rest -- and LABEL_POISONS ("Poison", singular) belongs to
    the no-item message and the Enable Macros tooltips, and is not reused
    here. The other reagent labels are kept inside about fifteen characters so
    they hold the pop-up's reagent-row label cell.
]]
L["STARTER_POPUP_REAGENTS_HEADER"] = "材料與工具"
L["STARTER_POPUP_POISONS_HEADER"] = "毒藥"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s ：將成品毒藥加入你的清單，Connoisseur 會在任何販售全部所需材料的商人處自動購買這些材料。"
L["STARTER_POPUP_POISON_ANESTHETIC"] = "麻醉"
L["STARTER_POPUP_POISON_CRIPPLING"] = "致殘"
L["STARTER_POPUP_POISON_DEADLY"] = "致命"
L["STARTER_POPUP_POISON_INSTANT"] = "速效"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "麻痺"
L["STARTER_POPUP_POISON_WOUND"] = "致傷"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "爐石"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "致盲粉"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "閃光粉"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "盜賊工具"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "屍塵"
L["STARTER_POPUP_REAGENT_WILDS"] = "野生材料"
L["STARTER_POPUP_REAGENT_SEEDS"] = "種子"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "魔粉"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "輕羽毛"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "傳送符文"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "傳送門符文"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "神聖符印"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "王者印記"
L["STARTER_POPUP_REAGENT_CANDLES"] = "蠟燭"
L["STARTER_POPUP_REAGENT_ANKH"] = "十字章"
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
    The stacks dropdown beside each staple that takes an amount. The label is
    unit-agnostic, since a stack is whatever its item stacks to; the tooltip
    below carries that item's own stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 疊"
L["STARTER_POPUP_STACK_MANY"] = "%d 疊"
L["STARTER_POPUP_STACKS_DESCRIPTION"] = "要保持備足多少疊，每疊 %d 個。"
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] =
	"要保持備足多少個；這些物品無法堆疊，因此每個都會佔用一個背包格。"
L["STARTER_POPUP_DISMISS"] = "不再為此角色顯示"
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"否則每次登入時只要補貨清單為空，這些建議就會再次出現。"

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "篩選物品……"
L["RESTOCKER_FILTER_CLEAR_TOOLTIP"] = "清除"
L["RESTOCKER_ADD_BUTTON"] = "新增"
L["RESTOCKER_LIST_BUILDER_BUTTON"] = "開啟清單助手"
L["RESTOCKER_LIST_BUILDER_TOOLTIP"] =
	"開啟清單助手（提供與新角色相同的基礎物資），並關閉此視窗。"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "新增物品"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "從背包拖入物品，或輸入物品 ID 後按 Enter。"
--[[
    In-box placeholder for the add row; the tooltip above carries the detail.
    Kept to a phrase rather than a sentence: both boxes on that row share a
    fixed width sized to this English hint, and a longer one is cut off.
]]
L["RESTOCKER_ADD_PLACEHOLDER"] = "將物品拖曳至此，或輸入物品 ID"
L["RESTOCKER_PROFILE_LABEL"] = "清單"
L["RESTOCKER_PROFILE_TOOLTIP"] = "點擊為此角色切換到其他補貨清單，或新建一個清單。"
L["RESTOCKER_RENAME_LABEL"] = "重新命名"
L["RESTOCKER_NEW_PROFILE"] = "新清單"
L["RESTOCKER_COPY_PROFILE"] = "複製"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in ns.SetupRestockerTooltip's TITLE slot, not its body, so
    they take no terminal punctuation -- matching every other title in the
    window. Don't "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "將此清單複製為新清單"
-- %s becomes "<list name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s 副本"
L["RESTOCKER_DELETE_PROFILE"] = "刪除"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "刪除此清單"
L["RESTOCKER_RENAME_TOOLTIP"] = "重新命名此清單，對所有使用它的角色生效。"
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
	"允許 Connoisseur 在你升級時，將食物、水、彈藥、毒藥、藥水和職業施法材料升級為更好的物品。"

--[[
    The band labels drawn over the Bank and Merchant column groups, and the
    Upgrade column's caption. The bands name the place an item moves to or
    from, so the column captions under them can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "銀行"
L["RESTOCKER_ROW_MERCHANT"] = "商人"
L["RESTOCKER_ROW_UPGRADE"] = "升級"

--[[
    Column headings over the list.

    Keep these SHORT. Every heading but Item can widen its column, and every
    pixel a heading takes comes out of the item name beside it. Six full-length
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
    and the way back to the whole list once a type has been picked, so it has
    to read as "everything" rather than as another type.
]]
L["RESTOCKER_GROUP_ALL"] = "全部物品"
-- Title slot, like the Copy and Delete tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "將此物品從補貨清單中移除"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "補貨數量"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "編輯完成後按 Enter。"
L["RESTOCKER_BUY_LABEL"] = "購買"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "向商人購買"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "商人視窗開啟時，向商人購買所需數量。"

--[[
    Some vendor slots hold only a few units and trickle back over time, which is
    how Classic sells its scarce consumables. Extra empties those slots outright
    rather than buying the shortfall, so the tooltip has to say what it buys and
    that only limited stock counts.
]]
L["RESTOCKER_EXTRA_LABEL"] = "額外"
L["RESTOCKER_EXTRA_TOOLTIP_TITLE"] = "額外購買"
L["RESTOCKER_EXTRA_TOOLTIP_STOCK"] =
	"買下商人此物品的全部限量存貨（即每次只有少量、會慢慢刷新的商品），即使超出你的目標數量。"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "存入銀行"
--[[
    Names the Amount column, so it is coupled to RESTOCKER_COLUMN_AMOUNT: a
    locale that renders that heading differently has to say the same word here,
    or the sentence points at a column the player cannot find.
]]
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"銀行開啟時，將多餘的物品存入銀行；若數量欄填寫 0，則全部存入。"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "從銀行補貨"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "銀行開啟時，從銀行取出所需物品。"

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "所需聲望"
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_STANDING below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (優惠 %d%%)"
L["RESTOCKER_REPUTATION_ANY"] = "任意"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "友好"
L["RESTOCKER_REPUTATION_HONORED"] = "尊敬"
L["RESTOCKER_REPUTATION_REVERED"] = "崇敬"
L["RESTOCKER_REPUTATION_EXALTED"] = "崇拜"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "所需商人聲望"
--[[
    Quotes the cell's own values, which couples this line to
    RESTOCKER_REPUTATION_ANY and the four standings above: a locale that renders
    a standing differently has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'點擊設定 Connoisseur 向商人購買前所需的聲望等級（"任意"表示在任何商人處都會購買）；聲望還會降低價格：友好 5%，尊敬 10%，崇敬 15%，崇拜 20%。'
