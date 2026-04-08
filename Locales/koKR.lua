local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "koKR")
if not L then return end

-- [[ KOREAN (koKR) ]] --
L["BRAND"] = "Connoisseur"

-- Macro Names Can't Exceed 16 Total Characters
L["MACRO_BANDAGE"] = "- 붕대"
L["MACRO_FOOD"]    = "- 음식"
L["MACRO_HPOT"]    = "- 치유 물약"
L["MACRO_HS"]      = "- 생명석"
L["MACRO_MGEM"]    = "- 마나 보석"
L["MACRO_MPOT"]    = "- 마나 물약"
L["MACRO_SS"]      = "- 영혼석"
L["MACRO_WATER"]   = "- 물"
L["MACRO_FEED_PET"]= "- 먹이 주기"

L["ERR_ZONE"] = "여기선 사용할 수 없습니다."
L["RANK"]     = "레벨"

L["MSG_BUG_REPORT"] = "버그를 발견한 것 같습니다! %s (%s) 아이템은 %s > %s (%s)에서 사용할 수 없습니다. 수정할 수 있도록 제보해 주세요. 감사합니다! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"]    = "가방에 적합한 %s(이)가 없습니다."

L["MENU_BUFF_FOOD"]      = "버프 음식 우선"
L["MENU_BUFF_FOOD_DESC"] = "\"포만감\" 버프가 없을 때 해당 버프를 주는 음식을 우선 사용합니다."
L["MENU_CLEAR_IGNORE"]   = "차단 목록 초기화"
L["MENU_IGNORE"]         = "차단"
L["MENU_RESET"]          = "초기화"
L["MENU_SCAN"]           = "강제 스캔"
L["MENU_TITLE"]          = "소모품"

L["MENU_SCROLL_BUFFS"]      = "두루마리 버프"
L["MENU_SCROLL_BUFFS_DESC"] = "두루마리 버프가 없을 때 음식 매크로의 일부로 능력치 두루마리를 사용합니다."
L["MENU_OPTIONS_HINT"]      = "설정 > 애드온 > Connoisseur에서 추가 옵션을 사용할 수 있습니다."

L["PREFIX_HUNTER"]  = "사냥꾼 주의"
L["PREFIX_MAGE"]    = "마법사 주의"
L["PREFIX_WARLOCK"] = "흑마법사 주의"

L["TIP_DOWNRANK"]        = "자신보다 레벨이 낮은 플레이어를 대상으로 하면 해당 레벨에 맞는 아이템을 창조합니다."
L["TIP_HUNTER_FEED_PET"] = "야수 먹이 주기는 올인원 야수 버튼입니다! 클릭하여 자동으로 야수를 부르거나, 먹이를 주거나, 되살립니다. 전투 중에 사용하거나 우클릭하면 야수 치료를 시전합니다. Shift 키를 누른 채 클릭하면 강제로 되살리기를 시전하며, Ctrl 키를 누르면 소환을 해제합니다."
L["TIP_MAGE_CONJURE"]    = "음식 또는 물 매크로를 우클릭하면 음식 또는 물을 창조합니다."
L["TIP_MAGE_GEM"]        = "마나 보석 매크로를 우클릭하여 새 보석을 창조합니다. 다시 우클릭하면 낮은 등급의 보조 보석을 창조합니다."
L["TIP_MAGE_TABLE"]      = "마우스 휠(가운데) 클릭 시 재충전의 의식을 시전합니다."
L["TIP_WARLOCK_CONJURE"] = "생명석 또는 영혼석 매크로를 우클릭하면 생명석 또는 영혼석을 창조합니다."
L["TIP_WARLOCK_SOUL"]    = "마우스 휠(가운데) 클릭 시 영혼의 의식을 시전합니다."

L["UI_BEST_FOOD"]    = "현재 최고 음식"
L["UI_BEST_PET_FOOD"]= "현재 최고 먹이"
L["UI_DISABLED"]     = "비활성화됨"
L["UI_ENABLED"]      = "활성화됨"
L["UI_IGNORE_LIST"]  = "차단 목록"
L["UI_LEFT_CLICK"]   = "좌클릭"
L["UI_MIDDLE_CLICK"] = "휠클릭"
L["UI_RIGHT_CLICK"]  = "우클릭"
L["UI_SHIFT_LEFT"]   = "Shift + 좌클릭"
L["UI_TOGGLE"]       = "토글"

L["MODE_ALWAYS"] = "항상"
L["MODE_PARTY"]  = "파티 중일 때만"
L["MODE_RAID"]   = "공격대 중일 때만"

-- Options Panel
L["OPTIONS_DESC"] = "최고의 소모품에 대해 자동 업데이트 매크로를 생성하고, 버프를 추적하여 최상의 성능을 유지합니다. 사냥꾼을 위한 올인원 야수 먹이 주기 기능과 마법사 및 흑마법사를 위해 대상의 레벨에 맞춰 조절되는 스마트한 우클릭 창조 기능을 제공합니다."
L["OPTIONS_BUFF_FOOD"]         = "버프 음식 우선"
L["OPTIONS_BUFF_FOOD_DESC"]    = "\"포만감\" 버프가 없을 때 해당 버프를 주는 음식을 우선 사용합니다."
L["OPTIONS_SCROLL_HEADER"]     = "두루마리 버프"
L["OPTIONS_USE_SCROLLS"]       = "두루마리 버프 포함"
L["OPTIONS_USE_SCROLLS_DESC"]  = "두루마리 버프가 없을 때 음식 매크로의 일부로 두루마리를 사용합니다."
L["OPTIONS_SCROLL_TYPES"]      = "확인할 두루마리 유형 포함"
L["OPTIONS_SCROLL_AGILITY"]    = "민첩성"
L["OPTIONS_SCROLL_INTELLECT"]  = "지능"
L["OPTIONS_SCROLL_PROTECTION"] = "보호"
L["OPTIONS_SCROLL_SPIRIT"]     = "정신력"
L["OPTIONS_SCROLL_STAMINA"]    = "체력"
L["OPTIONS_SCROLL_STRENGTH"]   = "힘"

L["OPTIONS_PET_HEADER"]        = "소환수 음식 버프"
L["OPTIONS_USE_PET_BUFFS"]     = "소환수 음식 버프 사용"
L["OPTIONS_USE_PET_BUFFS_DESC"]= "소환수에게 \"포만감\" 버프가 없을 때 음식 매크로의 일부로 소환수 음식을 사용합니다."
L["OPTIONS_PET_BUFF_TYPES"]    = "확인할 소환수 음식 유형 포함"
L["OPTIONS_PET_BUFF_KIBLERS"]  = "키블러의 간식"
L["OPTIONS_PET_BUFF_SPORELING"]= "스포어가르 간식"

L["OPTIONS_NIGHTELF_HEADER"]           = "나이트 엘프"
L["OPTIONS_SHADOWMELD_DRINKING"]      = "그림자 숨기 상태로 마시기"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "물 매크로에 그림자 숨기를 추가하여 물을 마시는 동안 은신합니다."

L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"]   = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Connoisseur 설정 인터페이스를 엽니다."

L["OPTIONS_RESET_HEADER"]         = "초기화"
L["OPTIONS_RESET_IGNORE_DESC"]    = "차단 목록에서 모든 아이템을 제거합니다."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "차단 목록을 지우시겠습니까?"
L["OPTIONS_COMMUNITY_HEADER"]     = "피드백 및 지원"