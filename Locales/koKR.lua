local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "koKR")
if not L then
	return
end

-- [[ KOREAN (koKR) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- 붕대"
L["MACRO_EXPLOSIVES"] = "- 폭발물"
L["MACRO_FEED_PET"] = "- 먹이 주기"
L["MACRO_FOOD"] = "- 음식"
L["MACRO_HEALTH_POTION"] = "- 치유 물약"
L["MACRO_HEALTHSTONE"] = "- 생명석"
L["MACRO_MANA_GEM"] = "- 마나 보석"
L["MACRO_MANA_POTION"] = "- 마나 물약"
L["MACRO_POISONS"] = "- 독"
L["MACRO_SOULSTONE"] = "- 영혼석"
L["MACRO_WATER"] = "- 물"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "레벨"

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

L["DIET_BREAD"] = "빵"
L["DIET_CHEESE"] = "치즈"
L["DIET_FISH"] = "생선"
L["DIET_FRUIT"] = "과일"
L["DIET_FUNGUS"] = "버섯"
L["DIET_MEAT"] = "고기"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] =
	"버그를 발견한 것 같습니다! %s (%s) 아이템은 %s > %s (%s)에서 사용할 수 없습니다. 수정할 수 있도록 제보해 주세요. 감사합니다! %s"
L["MSG_NO_ITEM"] = "가방에 적합한 %s(이)가 없습니다."
L["MSG_MACRO_SLOTS_FULL"] =
	"매크로 슬롯이 가득 차서 일부 Connoisseur 매크로를 생성할 수 없습니다. 더 이상 사용하지 않는 매크로를 삭제하여 슬롯을 비우거나 설정 > 애드온 > Connoisseur에서 필요 없는 매크로를 끄십시오."

L["CHAT_LOADED"] =
	"버전 %s. 설정(이 메시지 비활성화 옵션 포함)은 설정 > 애드온 > Connoisseur에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

L["CHAT_OPTIONS_IN_COMBAT"] = "안전을 위해 전투 중에는 설정 인터페이스를 열 수 없습니다."

--------------------------------------------------------------------------------
-- Readiness Report
--------------------------------------------------------------------------------

--[[
    Printed when a ready check starts, as a header plus up to three lines. Each
    line is a set of "Label : a, b, c" clauses joined by ". ", and every part of
    it is dropped when it has nothing to say -- a clean character prints nothing
    at all, so there is no all-clear string here and must not be one.
]]

L["READINESS_TITLE"] = "준비 보고서"

-- Clause labels, in the order the lines print them.
L["READINESS_MISSING_BUFFS"] = "부족한 버프:"
L["READINESS_EXPIRING"] = "곧 만료:"
L["READINESS_MISSING_ITEMS"] = "부족한 아이템:"
L["READINESS_DAMAGED_GEAR"] = "손상된 장비:"
L["READINESS_CHARACTER"] = "캐릭터:"
L["READINESS_QUESTIONABLE_GEAR"] = "비전투용 장비 착용:"

--[[
    What the report calls each thing. Deliberately its own set rather than the
    shared LABEL_* keys the macro messages use: those name an item you are being
    offered ("Health Potion"), these name a gap in your preparation ("Healing
    Potion"), and the two want to be reworded independently.
]]
L["READINESS_FLASK"] = "영약 또는 비약 2종"
L["READINESS_WELL_FED"] = "포만감"
L["READINESS_PET_WELL_FED"] = "포만감 (소환수)"
L["READINESS_SCROLLS"] = "두루마리"
L["READINESS_SOULSTONE"] = "영혼석 비활성"
L["READINESS_MAIN_HAND"] = "주 무기"
L["READINESS_OFF_HAND"] = "보조 무기"
L["READINESS_HEALTHSTONE"] = "생명석"
L["READINESS_MANA_GEM"] = "마나 보석"
L["READINESS_HEALING_POTION"] = "치유 물약"
L["READINESS_MANA_POTION"] = "마나 물약"
L["READINESS_BANDAGES"] = "붕대"
L["READINESS_PVP_ON"] = "PvP 활성!"

-- { buff name, whole minutes left }
L["READINESS_TIME_MINUTES"] = "%s %d분"
-- %s is the buff name; used when under a minute is left.
L["READINESS_TIME_EXPIRING"] = "%s 1분 미만"
-- { dominant talent tree, slash-joined point spread }
L["READINESS_SPEC_FORMAT"] = "%s (%s)"
-- %d is the number of talent points the character has not spent.
L["READINESS_UNSPENT_TALENTS"] = "미사용 특성 점수 %d개"

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "현재 소환수에게 줄 수 있는 적절한 먹이가 없습니다."
L["TIP_PET_NO_SKILLS"] =
	"현재 야수 부르기, 야수 돌려보내기, 야수 먹이 주기 또는 야수 되살리기를 배우지 않았습니다."
L["TIP_PET_NO_MEND"] = "현재 야수 치료를 배우지 않았습니다."
L["TIP_NO_HAND_POISON"] = "이 무기에 바를 선택한 독이 없습니다."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "현재 %s 기술을 배우지 않았습니다."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the mini-map tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "버프 음식"
L["MENU_BUFF_FOOD_DESCRIPTION"] =
	'"포만감" 버프가 없을 때 해당 버프를 주는 음식을 우선 사용합니다.'
L["FEATURE_SCROLL_BUFFS"] = "두루마리 버프"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"두루마리 버프가 없을 때 음식 매크로를 두루마리 적용기로 전환합니다."

-- Section titles and ignore-list actions in the mini-map tooltip.
L["UI_BEST_FOOD"] = "현재 음식"
L["UI_BEST_PET_FOOD"] = "현재 소환수 먹이"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "주 무기"
L["UI_OFF_HAND"] = "보조 무기"
--[[
    The value shown beside an item title when nothing resolved. Kept to a single
    word so it fits in the tooltip's right column, which never wraps -- the full
    sentence, MSG_NO_ITEM, explains it on the wrapping line underneath.
]]
L["UI_NONE"] = "없음"
L["UI_IGNORE_LIST"] = "차단 목록"
L["MENU_IGNORE"] = "차단"
L["MENU_CLEAR_IGNORE"] = "차단 목록 초기화"

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
L["UI_RESTOCKER_REPORT"] = "보충 보고서"
L["UI_RESTOCKER_NEEDED_ONE"] = "미완료 주문 1건"
L["UI_RESTOCKER_NEEDED"] = "미완료 주문 %d건"
L["UI_RESTOCKER_STOCKED_SHORT"] = "보급 완료"
L["UI_RESTOCKER_STOCKED"] = "축하합니다, 보급품이 모두 채워졌습니다!"

-- Options entry at the bottom of the mini-map tooltip.
L["MENU_OPTIONS"] = "Connoisseur 설정"
L["MENU_OPTIONS_KEYBIND"] = "Shift + 휠클릭"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

--[[
    Class-colored headers and conjure/pet tips shown in the mini-map tooltip for
    the player's class.
]]

L["PREFIX_HUNTER"] = "사냥꾼 주의"
L["PREFIX_MAGE"] = "마법사 주의"
L["PREFIX_ROGUE"] = "도적 주의"
L["PREFIX_WARLOCK"] = "흑마법사 주의"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to -- the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "먹이 주기 매크로 안내..."
L["TIP_MAGE_MACROS"] = "음식, 물, 마나 보석 매크로 안내..."
L["TIP_ROGUE_MACROS"] = "독 매크로 안내..."
L["TIP_WARLOCK_MACROS"] = "생명석 및 영혼석 매크로 안내..."

L["TIP_HUNTER_ALL_IN_ONE"] = "먹이 주기는 올인원 소환수 버튼입니다!"
L["TIP_HUNTER_CALL"] = "좌클릭하면 소환수를 자동으로 부르거나, 먹이를 주거나, 되살립니다."
L["TIP_HUNTER_MEND"] = "우클릭하거나 전투에 들어가면 야수 치료를 시전합니다."
L["TIP_HUNTER_MODIFIERS"] = "Shift를 누르면 되살리기를 강제하고, Ctrl을 누르면 돌려보냅니다."

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "음식 또는 물 매크로를 우클릭하면 음식 또는 물을 창조합니다."
L["TIP_MAGE_DOWNRANK"] =
	"레벨이 낮은 플레이어를 대상으로 지정하면 그 레벨에 맞는 음식이나 물을 창조합니다."
L["TIP_MAGE_TABLE"] = "음식 또는 물 매크로를 휠클릭하면 재충전의 의식을 시전합니다."
L["TIP_MAGE_GEM"] =
	"마나 보석 매크로를 우클릭하여 새 보석을 창조합니다. 다시 우클릭하면 낮은 등급의 보조 보석을 창조합니다."

L["TIP_WARLOCK_HEALTHSTONE"] =
	"생명석 매크로를 우클릭하면 생명석을 만듭니다. 다시 우클릭하면 낮은 등급의 예비 생명석을 만듭니다."
L["TIP_WARLOCK_DOWNRANK"] =
	"레벨이 낮은 플레이어를 대상으로 지정하면 그 레벨에 맞는 생명석을 만듭니다."
L["TIP_WARLOCK_SOULSTONE"] = "영혼석 매크로를 우클릭하면 영혼석을 만듭니다."
L["TIP_WARLOCK_SOUL"] = "생명석 매크로를 휠클릭하면 영혼의 의식을 시전합니다."

L["TIP_ROGUE_OFF_HAND"] = "좌클릭하면 보조 무기에 독을 바릅니다."
L["TIP_ROGUE_MAIN_HAND"] = "우클릭하면 주 무기에 독을 바릅니다."
L["TIP_ROGUE_REPLACE"] = "기존 독은 자동으로 교체됩니다."
L["TIP_ROGUE_WINDOW"] = "휠클릭하면 독 제조 창을 엽니다."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

--[[
    Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
    One per macro type (resolved via ns.MacroConfig in ConnNoItem), plus Pet Food.
]]

L["LABEL_BANDAGE"] = "붕대"
L["LABEL_EXPLOSIVE"] = "폭발물"
L["LABEL_FOOD"] = "음식"
L["LABEL_HEALTH_POTION"] = "치유 물약"
L["LABEL_HEALTHSTONE"] = "생명석"
L["LABEL_MANA_GEM"] = "마나 보석"
L["LABEL_MANA_POTION"] = "마나 물약"
L["LABEL_PET_FOOD"] = "야수 먹이"
L["LABEL_POISONS"] = "독"
L["LABEL_SOULSTONE"] = "영혼석"
L["LABEL_WATER"] = "물"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the mini-map tooltip and options panel.

L["UI_ENABLED"] = "활성화됨"
L["UI_DISABLED"] = "비활성화됨"
L["UI_TOGGLE"] = "토글"
L["UI_LEFT_CLICK"] = "좌클릭"
L["UI_RIGHT_CLICK"] = "우클릭"
L["UI_MIDDLE_CLICK"] = "휠클릭"
L["UI_SHIFT_LEFT"] = "Shift + 좌클릭"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "항상"
L["MODE_PARTY"] = "파티 또는 공격대에서만"
L["MODE_RAID"] = "공격대 중일 때만"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"최고의 음식, 버프 음식, 물, 물약, 생명석, 붕대, 두루마리를 자동으로 사용하는 매크로에, 가방을 가득 채워 두고 레벨에 맞춰 소모품을 승급해 주는 보충 목록까지. 편의성 자동화, 최고의 성능."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "환영 메시지 활성화"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "로그인 시 채팅창에 환영 메시지를 출력합니다."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "미니맵 버튼 활성화"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "미니맵 버튼을 표시합니다."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "버튼에 매크로 이름 표시"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"행동 단축바 버튼에 매크로 이름 텍스트를 표시합니다. 기본값은 꺼짐이며, 게임이 자체적으로 표시하는 이름을 숨깁니다."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "물약 및 생명석"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"전투 중에는 매크로를 변경할 수 없으므로(블리자드 제한 사항), 각 물약 및 생명석 매크로는 최고 아이템과 최대 2개의 예비 아이템으로 사전 구성됩니다. 긴 전투에서는 아이콘과 툴팁이 갱신되지 않아 잘못된 아이템을 표시할 수 있지만, 매크로를 클릭하면 항상 가방에 있는 실제 최고 아이템이 사용됩니다."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "생명석을 치유 물약 매크로에 결합"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"가장 좋은 생명석을 치유 물약 매크로의 하단에 추가하여, 한 번 누르면 물약과 생명석을 모두 사용합니다."

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "버프 재적용"
L["OPTIONS_REAPPLY"] = "만료 임박 버프 재적용"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"전투는 종종 버프의 남은 시간보다 오래 지속됩니다. 남은 시간이 기준보다 적은 버프는 이미 만료된 것으로 간주되어, 전투 전에 매크로가 새 버프를 제안합니다. 버프 음식, 두루마리 버프, 소환수 음식 버프에 적용됩니다."
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "1분 미만 남았을 때"
L["REAPPLY_THRESHOLD_N"] = "%d분 미만 남았을 때"

-- Ready Check
L["OPTIONS_READINESS_HEADER"] = "준비 보고서"
L["OPTIONS_READINESS_ENABLE"] = "준비 확인 시 준비 보고서 사용"
--[[
    Says what the report does AND that it stays quiet, because the quiet is the
    feature: a player who turns this on and sees nothing for three pulls has to
    know that is the report working rather than the report broken.
]]
L["OPTIONS_READINESS_DESCRIPTION"] =
	"준비 확인이 시작되면 아직 고쳐야 할 것들의 목록을 개인적으로 출력합니다. 자신에게만 보이며, 준비가 되어 있으면 아무것도 출력하지 않습니다."

--[[
    The reset button under the master toggle. It needs a control of its own
    because these settings are account-wide: the stock Reset Profile reaches
    only the character's own profile, so nothing else on any panel can return
    them to their defaults.

    The confirm names the one consequence a player would not otherwise predict.
    Off is what the report ships as, so resetting switches it back off, and a
    page that emptied itself with no warning would read as a bug.
]]
L["OPTIONS_READINESS_RESET"] = "준비 보고서 설정 초기화"
L["OPTIONS_READINESS_RESET_DESCRIPTION"] =
	"이 페이지의 모든 스위치와 두 기준값을 새로 설치했을 때의 설정으로 되돌립니다. 다른 페이지에는 영향이 없습니다."
L["OPTIONS_READINESS_RESET_CONFIRM"] =
	"준비 보고서의 모든 설정을 기본값으로 초기화할까요? 보고서 자체도 다시 꺼집니다."

--[[
    The three sections, each a real header over the switches it covers. They name
    what the line is called in chat, so the panel and the report read as the same
    feature.
]]
L["OPTIONS_READINESS_BUFFS_HEADER"] = "부족한 버프"
L["OPTIONS_READINESS_ITEMS_HEADER"] = "부족한 아이템"
L["OPTIONS_READINESS_CHARACTER_HEADER"] = "캐릭터"

-- Missing Buffs
L["OPTIONS_READINESS_FLASK"] = "영약 또는 비약 2종"
L["OPTIONS_READINESS_FLASK_DESCRIPTION"] =
	"영약 하나, 또는 전투 비약과 수호 비약 각 하나를 갖춘 것으로 인정합니다."
L["OPTIONS_READINESS_WELL_FED"] = "포만감"
L["OPTIONS_READINESS_WELL_FED_DESCRIPTION"] = "매크로 설정에서 버프 음식을 켜야 합니다."
L["OPTIONS_READINESS_PET_WELL_FED"] = "포만감 (소환수)"
L["OPTIONS_READINESS_PET_WELL_FED_DESCRIPTION"] =
	"사냥꾼 전용. 매크로 설정에서 소환수 음식 버프를 켜야 합니다."
L["OPTIONS_READINESS_SCROLLS"] = "두루마리 버프"
L["OPTIONS_READINESS_SCROLLS_DESCRIPTION"] =
	"매크로 설정에서 사용하도록 선택한 두루마리를 기준으로 합니다."
--[[
    The one entry that asks about the GROUP rather than the player's own bags,
    which the helper text has to say outright: a raid carrying seven unused
    stones is not covered, and one deployed stone covers it.
]]
L["OPTIONS_READINESS_SOULSTONE"] = "영혼석 비활성"
L["OPTIONS_READINESS_SOULSTONE_DESCRIPTION"] =
	"영혼석이 가방에 있는지가 아니라 누군가에게 활성화되어 있는지 확인합니다. 그룹에 흑마법사가 있어야 합니다."
L["OPTIONS_READINESS_MAIN_HAND"] = "주 무기 버프"
L["OPTIONS_READINESS_OFF_HAND"] = "보조 무기 버프"
L["OPTIONS_READINESS_WEAPON_DESCRIPTION"] =
	"일시적인 무기 강화라면 무엇이든 인정합니다. 숫돌, 기름, 독, 주술사 무기 버프 모두 해당합니다."
--[[
    Says the Shaman exemption outright, because a main-hand line that goes quiet
    the moment a Shaman joins reads as a broken switch otherwise.
]]
L["OPTIONS_READINESS_MAIN_HAND_DESCRIPTION"] =
	"일시적인 무기 강화라면 무엇이든 인정합니다. 그룹에 주술사가 있으면 조용히 넘어갑니다."
--[[
    Names the OTHER threshold so the two cannot be mistaken for each other: the
    Macros panel has one that decides when a macro treats a buff as spent, and
    this one only decides when the report mentions it.
]]
L["OPTIONS_READINESS_EXPIRING"] = "버프 만료 기준 시간"
L["OPTIONS_READINESS_EXPIRING_DESCRIPTION"] =
	"Connoisseur가 적용한 것만이 아니라 곧 사라질 모든 버프를 알려 줍니다. 매크로 설정의 버프 재적용과는 별개로, 그쪽은 매크로가 언제 새 버프를 권할지 정합니다."
-- %s is a whole or half number of minutes.
L["OPTIONS_READINESS_EXPIRING_MINUTES"] = "%s분"
-- The one-minute entry alone; one plural template cannot render it grammatically.
L["OPTIONS_READINESS_EXPIRING_MINUTES_ONE"] = "1분"

-- Missing Items
L["OPTIONS_READINESS_HEALTHSTONE"] = "생명석"
L["OPTIONS_READINESS_HEALTHSTONE_DESCRIPTION"] =
	"부탁할 흑마법사가 그룹에 있거나, 자신이 흑마법사일 때만 표시됩니다."
L["OPTIONS_READINESS_MANA_GEM"] = "마나 보석"
L["OPTIONS_READINESS_MANA_GEM_DESCRIPTION"] = "마법사일 때만 표시됩니다."
L["OPTIONS_READINESS_HEALING_POTION"] = "치유 물약"
L["OPTIONS_READINESS_HEALING_POTION_DESCRIPTION"] =
	"전투 전에 채워 두는 것이 좋습니다. 전투 중에는 아무도 물약을 건네줄 수 없습니다."
L["OPTIONS_READINESS_MANA_POTION"] = "마나 물약"
L["OPTIONS_READINESS_MANA_POTION_DESCRIPTION"] = "마나를 사용하는 클래스일 때만 표시됩니다."
L["OPTIONS_READINESS_BANDAGES"] = "붕대"
L["OPTIONS_READINESS_BANDAGES_DESCRIPTION"] =
	"응급치료 숙련도를 감안해, 사용할 수 있는 붕대가 하나도 없을 때 알려 줍니다."
L["OPTIONS_READINESS_DURABILITY"] = "손상된 장비 (내구도 기준)"
L["OPTIONS_READINESS_DURABILITY_DESCRIPTION"] =
	"내구도가 이 기준보다 낮은 착용 장비를 모두 링크합니다. 장비별로 측정하므로 무기 하나만 부서져도 표시됩니다."
-- %d is a durability percentage.
L["OPTIONS_READINESS_DURABILITY_PERCENT"] = "%d%%"

-- Character
L["OPTIONS_READINESS_SPEC"] = "현재 특성"
L["OPTIONS_READINESS_SPEC_DESCRIPTION"] = "특성 분배와 아직 사용하지 않은 점수를 출력합니다."
L["OPTIONS_READINESS_PVP"] = "PvP 상태 켜짐"
L["OPTIONS_READINESS_PVP_DESCRIPTION"] = "PvP 상태가 켜져 있으면 경고합니다."
L["OPTIONS_READINESS_QUESTIONABLE_GEAR"] = "비전투용 장비 착용"
L["OPTIONS_READINESS_QUESTIONABLE_GEAR_DESCRIPTION"] =
	"PvP 장신구나 낚싯대처럼 전투에 어울리지 않는 착용 장비를 링크합니다."

--[[
    Three features are suppressed in a PvP Arena, and each says so with the
    same sentence. It lives here once and is appended at the call site
    (Options/Options-Macros.lua), so every locale translates it a single time
    and the caveat can never drift between the three.
]]
L["OPTIONS_DISABLED_IN_ARENAS"] = "투기장에서는 비활성화됩니다."

--[[
    Buff Food. The section header reuses FEATURE_BUFF_FOOD, and the options
    description reuses MENU_BUFF_FOOD_DESCRIPTION plus the arena note above --
    the mini-map tooltip and the options panel say the same thing, so they read
    from one key rather than two copies of one sentence.
]]
L["OPTIONS_BUFF_FOOD"] = "버프 음식 우선"
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"프로 팁: 자신을 대상으로 지정하면 음식 매크로가 항상 버프 음식과 두루마리를 건너뜁니다."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "두루마리 버프 포함"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"한 번 누르면 부족한 두루마리를 적용하고, 다시 누르면 음식을 먹습니다. 두루마리는 전역 재사용 대기시간(GCD)의 영향을 받지 않고 자신을 대상으로 하며, 우호적인 플레이어를 대상으로 지정하면 건너뜁니다."
L["OPTIONS_SCROLL_TYPES"] = "확인할 두루마리 유형 포함"
L["OPTIONS_SCROLL_AGILITY"] = "민첩성"
L["OPTIONS_SCROLL_INTELLECT"] = "지능"
L["OPTIONS_SCROLL_PROTECTION"] = "보호"
L["OPTIONS_SCROLL_SPIRIT"] = "정신력"
L["OPTIONS_SCROLL_STAMINA"] = "체력"
L["OPTIONS_SCROLL_STRENGTH"] = "힘"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "폭발물"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"@player 옵션은 조준 원 없이 폭발물을 발밑에서 바로 터뜨립니다. 대상이 근접 거리일 때 이상적입니다."
L["EXPLOSIVES_MODE_ATPLAYER"] = "좌클릭 @player, 우클릭 던지기"
L["EXPLOSIVES_MODE_TOSS"] = "좌클릭 던지기, 우클릭 @player"

--[[
    Ignore List panel (Options-Ignore-List.lua). One tree scope per list: the
    account-wide Global list, then one per character. The rows are items, so
    the copy here is the panel description, the scope and promote labels, the
    add box, and the placeholder shown while the client is still resolving an
    item's name. The mini-map tooltip's section keeps its own UI_IGNORE_LIST
    and MENU_CLEAR_IGNORE keys.
]]
L["OPTIONS_IGNORE_LIST_TAB"] = "차단 목록"
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"차단한 아이템은 어떤 매크로에서도 선택되지 않습니다. 음식, 물, 물약 등 무엇이든 해당됩니다. 전체 목록은 모든 캐릭터에 적용되고, 캐릭터 목록은 해당 캐릭터에만 적용됩니다. 미니맵 버튼을 우클릭하면 현재 최적의 음식을 차단합니다."
L["OPTIONS_IGNORE_GLOBAL"] = "전체"
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"이 아이템을 전체 목록으로 옮겨 모든 캐릭터에서 차단합니다."
L["OPTIONS_IGNORE_ADD_ID"] = "아이템 ID로 추가"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"아이템 ID를 입력하거나, 이 입력란이 선택된 상태에서 대화창의 아이템 링크를 Shift + 클릭하세요."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] =
	"아이템 ID를 입력하거나, 대화창의 아이템 링크를 Shift + 클릭하세요."
L["OPTIONS_IGNORE_REMOVE"] = "제거"
L["OPTIONS_IGNORE_EMPTY"] = "목록이 비어 있습니다."
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "ID 불러오는 중: %d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "소환수 음식 버프"
L["OPTIONS_USE_PET_BUFFS"] = "소환수 음식 버프 사용"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'소환수에게 "포만감" 버프가 없을 때 음식 매크로에 소환수 음식을 추가합니다.'
L["OPTIONS_PET_BUFF_TYPES"] = "확인할 소환수 음식 유형 포함"
L["OPTIONS_PET_BUFF_KIBLERS"] = "키블러의 간식"
L["OPTIONS_PET_BUFF_SPORELING"] = "스포어가르 간식"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "드루이드"
L["OPTIONS_DRUID_MACRO_HELPER"] = "DruidMacroHelper 연동 활성화"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"DruidMacroHelper(/dmh)를 사용하여 치유 물약, 마나 물약, 생명석에 대한 변신 매크로를 생성합니다."
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "곰으로 복귀"
L["DRUID_FORM_CAT"] = "표범으로 복귀"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "나이트 엘프"
L["OPTIONS_STEALTH_DRINKING"] = "마실 때 은신 사용"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] =
	"물 매크로에 그림자 숨기를 추가하여 물을 마시는 동안 은신합니다."
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	"음식 매크로에 그림자 숨기를 추가하여 음식을 먹는 동안 은신합니다."
L["OPTIONS_STEALTH_PICK_ONE"] =
	"프로 팁: 하나만 선택하세요. 먹기와 마시기는 동시에 할 수 있지만, 은신한 뒤에 먹거나 마시면 은신이 풀립니다."

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "도적"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"독 매크로를 각 독 종류의 사용 가능한 최고 등급으로 유지합니다. 좌클릭은 보조 무기에, 우클릭은 주 무기에 바르며, 기존 독은 자동으로 교체됩니다."
L["OPTIONS_POISON_MAIN_HAND"] = "주 무기 독 종류"
L["OPTIONS_POISON_OFF_HAND"] = "보조 무기 독 종류"
L["OPTIONS_STEALTH_EATING"] = "먹을 때 은신 사용"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] =
	"음식 매크로에 은신을 추가하여 음식을 먹는 동안 은신합니다."

--[[
    Restocker options panel. The tree label stays "Restocker" in every locale
    (brand fragment, localization allowlist); the panel header reuses
    RESTOCKER_WINDOW_TITLE.
]]
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"캐릭터별 보충 목록에 따라 가방을 채워 줍니다. 상인에게서 자동으로 구매하고 가방과 은행 사이에서 아이템을 옮깁니다. %s 명령어로 목록을 엽니다."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "은행에서 열기"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "은행 방문 시 Restocker 창을 엽니다."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "상인에게서 열기"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "상인 방문 시 Restocker 창을 엽니다."
L["OPTIONS_RESTOCKER_REMIND"] = "마을 보충 알림 사용"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"보충 목록에 부족한 것이 있고 여관이나 도시에 도착하거나 이미 그곳에 있는 상태로 접속했을 때 대화창에 알림을 표시합니다."
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "상인 보충 알림 사용"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"상인 창을 닫을 때 미완료된 보충 주문을 알려 줍니다. 없으면 아무 말도 하지 않습니다."
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "은행 보충 알림 사용"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"은행을 닫을 때 미완료된 보충 주문을 알려 줍니다. 없으면 아무 말도 하지 않습니다."

--[[
    The Starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] = "보충 목록이 비어 있을 때 목록 도우미 사용"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"이 캐릭터의 보충 목록이 비어 있으면 접속할 때 기본 보충 목록을 제안합니다."

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "간단히"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "자세히"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "소리 재생"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] =
	"대화창이 바쁠 때를 위해 알림과 함께 경고음을 재생합니다."
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "클릭하면 경고음을 들어 볼 수 있습니다."

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "보충 창"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "감사의 말"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"저는 늘 Restocker를 좋아했고, 이것이 Connoisseur 안에서 계속 살아 있게 되어 기쁩니다. 원조 Auto Restocker를 만든 ChiliFajita, 그리고 Classic과 판다리아의 안개를 거치며 이를 이어 온 kvakvs와 guardycmw에게 큰 감사를 전합니다."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 인터페이스를 엽니다."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "보충 목록을 관리할 Restocker 창을 엽니다."

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "매크로"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"Connoisseur는 소모품마다 매크로를 하나씩 만들고 가방이 바뀔 때마다 최신 상태로 유지하므로, 바에 놓인 버튼은 항상 지금 가진 최고의 아이템을 집습니다. 아래에서 만들 매크로를 고른 다음, 각 매크로가 아이템을 고르는 방식을 설정하세요."
L["OPTIONS_ENABLE_MACROS_HEADER"] = "매크로 활성화"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Connoisseur가 생성하고 관리할 매크로를 선택합니다. 매크로를 비활성화하면 해당 매크로도 삭제됩니다."

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "피드백 및 지원"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "버전"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_PROFILE_EXISTS"] = '"%s" 이름의 목록이 이미 있습니다.'
L["RESTOCKER_BANK_NOT_OPEN"] = "은행이 열려 있지 않습니다."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (ns.OnRestockerBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"보충이 완료되었습니다. 은행을 열 때 Shift를 누르고 있으면 보충을 건너뜁니다. 보충 목록을 편집하려면 %s 명령어를 입력하세요."
L["RESTOCKER_STOPPED_BOTH_FULL"] = "보충이 중단되었습니다. 가방과 은행이 모두 가득 찼습니다."
L["RESTOCKER_STOPPED_BANK_FULL"] =
	"보충이 중단되었습니다. 은행이 가득 찼습니다. 칸을 비우고 다시 여세요."
L["RESTOCKER_STOPPED_BAG_FULL"] =
	"보충이 중단되었습니다. 가방이 가득 찼습니다. 칸을 비우고 은행을 다시 여세요."
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "보충이 중단되었습니다. 더 이상 진행할 수 없습니다."
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] = "보충이 중단되었습니다. 옮기지 못함: %s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (초과분)"
L["RESTOCKER_STOPPED_ERROR"] = "오류로 보충이 중단되었습니다: %s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] = "가방이 가득 찼습니다. 상인 보충을 건너뜁니다."
--[[
    Printed once per vendor visit when the crafting-reagent buyer stands down:
    this merchant stocks some of the reagents the Restock List needs but not
    all of them, and reagents buy all-or-nothing (VendorStocksAllReagents in
    Features/Restocker/Restocker-Merchant.lua). Silent at vendors stocking none.
]]
L["RESTOCKER_REAGENTS_SKIPPED"] =
	"이 상인은 독 제조에 필요한 재료를 모두 취급하지 않습니다. 아무것도 구매하지 않습니다."
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "마을에 있는 동안 보충하는 것을 잊지 마세요!"

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
L["RESTOCKER_STILL_SHORT_ONE"] = "보충 주문 1건이 남아 있습니다."
L["RESTOCKER_STILL_SHORT_MANY"] = "보충 주문 %d건이 남아 있습니다."

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, old amount, new link, new amount },
    outgoing tier on the left and incoming on the right.

    Both amounts are carried because they are not always equal: a swap onto a
    tier the list already holds merges the two rows, so the new amount is the
    sum rather than the old amount moved across.
]]
L["RESTOCKER_UPGRADED"] = "보충 목록이 갱신되었습니다."
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d을(를) %sx%d(으)로 업그레이드."

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
L["RESTOCKER_RESTOCKED_ONE"] = "보충 주문 1건을 완료했습니다."
L["RESTOCKER_RESTOCKED_MANY"] = "보충 주문 %d건을 완료했습니다."

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "보충 주문 1건을 일부만 채웠습니다."
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] = "보충 주문 %d건을 일부만 채웠습니다."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Restocker 창을 표시합니다."
L["RESTOCKER_HELP_PROFILE_ADD"] = "해당 이름의 목록을 추가합니다."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "해당 이름의 목록을 삭제합니다."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "현재 목록의 이름을 해당 이름으로 바꿉니다."
L["RESTOCKER_HELP_PROFILE_COPY"] = "해당 목록을 현재 목록으로 복사합니다."
L["RESTOCKER_HELP_PROFILE_USE"] = "활성 목록을 해당 이름으로 전환합니다."

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
L["STARTER_POPUP_INTRO_EMPTY"] =
	"보충 목록이 비어 있으니, 시작할 수 있도록 아이템을 몇 가지 추가해 봅시다."
-- Shown instead when the window is opened over a list that already has items on it.
L["STARTER_POPUP_INTRO_STOCKED"] =
	"계속 채워 둘 기본 물품을 고르세요. 이미 보충 목록에 있는 것은 체크되어 있습니다."
L["STARTER_POPUP_INTRO_HOW"] =
	"선택한 항목은 상인이나 은행을 열 때마다 자동으로 채워지고, 기본 소모품은 레벨이 오르면 스스로 상위 등급으로 바뀌므로 항상 최선의 물건을 갖게 됩니다."
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] =
	"%s 명령어를 입력하면 언제든지 이 목록을 조정하거나 아이템을 더 추가할 수 있습니다."
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "음식 및 물"
L["STARTER_POPUP_FOOD_HEADER"] = "음식"
L["STARTER_POPUP_AMMO_HEADER"] = "탄약"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "총알"
L["STARTER_POPUP_ARROWS"] = "화살"
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
L["STARTER_POPUP_REAGENTS_HEADER"] = "재료 및 도구"
L["STARTER_POPUP_POISONS_HEADER"] = "독"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s : 완성된 독을 목록에 추가하면 Connoisseur가 재료를 모두 취급하는 상인에게서 자동으로 구매합니다."
L["STARTER_POPUP_POISON_ANESTHETIC"] = "마취"
L["STARTER_POPUP_POISON_CRIPPLING"] = "무력화"
L["STARTER_POPUP_POISON_DEADLY"] = "치명적인"
L["STARTER_POPUP_POISON_INSTANT"] = "속효성"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "정신 마비"
L["STARTER_POPUP_POISON_WOUND"] = "상처"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "귀환석"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "실명 가루"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "섬광 가루"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "도둑의 도구"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "시체 가루"
L["STARTER_POPUP_REAGENT_WILDS"] = "야생 열매"
L["STARTER_POPUP_REAGENT_SEEDS"] = "씨앗"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "비전 가루"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "가벼운 깃털"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "순간이동 룬"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "차원문 룬"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "신성의 상징"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "제왕의 상징"
L["STARTER_POPUP_REAGENT_CANDLES"] = "양초"
L["STARTER_POPUP_REAGENT_ANKH"] = "앙크"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "물고기 비늘"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "생선 기름"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "대지 토템"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "불 토템"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "물 토템"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "공기 토템"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "악마 조각상"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "지옥소환석"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "영혼의 파편"
--[[
    Checkbox tooltips: { item link, amount }. The first is for ladder items;
    the second for single-tier reagents, which never upgrade.
]]
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"%s을(를) 보충 목록에 추가하고, 가방에 %d개를 유지하며 레벨에 맞춰 상위 등급으로 바꿔 줍니다."
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] =
	"%s을(를) 보충 목록에 추가하고 가방에 %d개를 유지합니다."
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 for food, water and poisons, 200 for ammo); the tooltip
    below carries the per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1묶음"
L["STARTER_POPUP_STACK_MANY"] = "%d묶음"
L["STARTER_POPUP_STACKS_DESCRIPTION"] =
	"몇 묶음을 유지할지 정합니다. 여기서 한 묶음은 %d개입니다."
--[[
    The same dropdown where the staple does not stack (Soul Shards): the
    choices are bare numbers, so only the tooltip needs words.
]]
L["STARTER_POPUP_COUNT_DESCRIPTION"] =
	"몇 개를 유지할지 정합니다. 이 항목은 겹쳐지지 않으므로 하나당 가방 한 칸을 차지합니다."
L["STARTER_POPUP_DISMISS"] = "이 캐릭터에서 다시 표시하지 않기."
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"그렇지 않으면 보충 목록이 비어 있는 상태로 접속할 때마다 이 제안이 다시 나타납니다."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "아이템 필터..."
L["RESTOCKER_FILTER_CLEAR_TOOLTIP"] = "지우기"
L["RESTOCKER_ADD_BUTTON"] = "추가"
L["RESTOCKER_LIST_BUILDER_BUTTON"] = "목록 도우미 열기"
L["RESTOCKER_LIST_BUILDER_TOOLTIP"] =
	"새 캐릭터에게 제공되는 것과 같은 기본 물품 구성인 목록 도우미를 엽니다. 도우미가 열려 있는 동안 이 창은 닫힙니다."
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "아이템 추가"
L["RESTOCKER_ADD_TOOLTIP_BODY"] =
	"가방에서 아이템을 끌어다 놓거나 숫자 아이템 ID를 입력하세요."
--[[
    In-box placeholder for the add row; the tooltip above carries the detail.
    Kept to a phrase rather than a sentence: it sets the width of both boxes on
    that row, and the row cannot afford two fields wide enough for a long one.
]]
L["RESTOCKER_ADD_PLACEHOLDER"] = "여기에 아이템을 놓거나, ID를 입력하세요"
L["RESTOCKER_PROFILE_LABEL"] = "목록"
L["RESTOCKER_PROFILE_TOOLTIP"] =
	"이 캐릭터가 사용 중인 보충 목록입니다. 클릭하여 다른 목록으로 전환하거나 새 목록을 시작하세요."
L["RESTOCKER_RENAME_LABEL"] = "이름 바꾸기"
L["RESTOCKER_NEW_PROFILE"] = "새 목록"
L["RESTOCKER_COPY_PROFILE"] = "복사"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in ns.SetupRestockerTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "이 목록을 새 목록으로 복제합니다"
-- %s becomes "<list name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s 복사본"
L["RESTOCKER_DELETE_PROFILE"] = "삭제"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "이 목록을 삭제합니다"
L["RESTOCKER_RENAME_TOOLTIP"] =
	"이 목록의 이름을 바꿉니다. 이 목록을 사용하는 모든 캐릭터가 새 이름을 따릅니다."
-- %s is the list name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"이 목록을 정말 삭제하시겠습니까?|n|n%s|n|n되돌릴 수 없습니다."
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
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "레벨에 맞춰 승급"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"음식, 물, 탄약, 물약은 레벨에 따른 상위 등급이 명확해서 Connoisseur가 대신 올려 줍니다. 그 밖의 것은 시간을 두고 직접 조정하시면 됩니다."

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "은행"
L["RESTOCKER_ROW_MERCHANT"] = "상인"
L["RESTOCKER_ROW_UPGRADE"] = "업그레이드"

--[[
    Column headings over the list.

    Keep these SHORT. A heading sets its column's width, and every pixel a
    heading takes comes out of the item name beside it. Six full-length
    headings do not fit beside a readable name at the smallest window size.

    "Take" and "Store" are short because they never appear alone: both sit
    under a "Bank" band, which is what makes them exact. Translate them as a
    pair with that band in mind, and keep them a single short word each.
]]
L["RESTOCKER_COLUMN_ITEM"] = "아이템"
L["RESTOCKER_COLUMN_WITHDRAW"] = "꺼내기"
L["RESTOCKER_COLUMN_DEPOSIT"] = "보관"
L["RESTOCKER_COLUMN_REPUTATION"] = "평판"
L["RESTOCKER_COLUMN_AMOUNT"] = "수량"

L["RESTOCKER_GROUP_OTHER"] = "기타"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "신규"
--[[
    The category pane's first entry, above the item types. Selected by default,
    and the only way back to the whole list once a type has been picked, so it
    has to read as "everything" rather than as another type.
]]
L["RESTOCKER_GROUP_ALL"] = "모든 아이템"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "이 아이템을 보충 목록에서 제거합니다"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "보충할 수량"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "편집을 마치면 Enter를 누르세요."
L["RESTOCKER_BUY_LABEL"] = "구매"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "상인에게서 구매"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "상인 창이 열려 있을 때 필요한 수량을 구매합니다."

--[[
    Some vendor slots hold only a few units and trickle back over time, which is
    how Classic sells its scarce consumables. Extra empties those slots outright
    rather than buying the shortfall, so the tooltip has to say three things: what
    it buys, that unlimited stock is never touched, and why anyone would want it.
]]
L["RESTOCKER_EXTRA_LABEL"] = "추가"
L["RESTOCKER_EXTRA_TOOLTIP_TITLE"] = "추가 구매"
L["RESTOCKER_EXTRA_TOOLTIP_STOCK"] =
	"목표 수량을 넘더라도 상인이 가진 이 아이템의 재고를 전부 구매합니다."
L["RESTOCKER_EXTRA_TOOLTIP_LIMITED"] =
	"상인이 조금씩 다시 채우는 한정 재고에만 적용됩니다. 무제한 재고는 무시합니다."
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "은행에 보관"
--[[
    Names the Amount column, so it is coupled to RESTOCKER_COLUMN_AMOUNT: a locale
    that renders that heading differently has to say the same word here, or the
    sentence points at a column the player cannot find.
]]
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"은행이 열려 있을 때 초과분을 은행에 보관합니다. 0을 입력하면 전부 보관합니다."
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "은행에서 보충"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] =
	"은행이 열려 있을 때 필요한 아이템을 은행에서 가져옵니다."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "필요 평판"
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (%d%% 할인)"
L["RESTOCKER_REPUTATION_ANY"] = "무관"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "우호적"
L["RESTOCKER_REPUTATION_HONORED"] = "명예로운"
L["RESTOCKER_REPUTATION_REVERED"] = "확고한"
L["RESTOCKER_REPUTATION_EXALTED"] = "숭배받는"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "상인에게 필요한 평판"
--[[
    Quotes the cell's own value, which couples this line to
    RESTOCKER_REPUTATION_ANY: a locale that renders that standing differently
    has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'평판을 고르면 그 단계에 이르지 못한 상인은 Connoisseur가 건너뜁니다. "평판: 무관"은(는) 모든 상인에게서 구매합니다.'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"평판이 높으면 가격도 내려갑니다: 우호적 5%, 명예로운 10%, 확고한 15%, 숭배받는 20%."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "클릭하면 변경합니다."
