local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "koKR")
if not L then return end

-- [[ KOREAN (koKR) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["BRAND"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- 붕대"
L["MACRO_FEED_PET"] = "- 먹이 주기"
L["MACRO_FOOD"] = "- 음식"
L["MACRO_HEALTH_POTION"] = "- 치유 물약"
L["MACRO_HEALTHSTONE"] = "- 생명석"
L["MACRO_MANA_GEM"] = "- 마나 보석"
L["MACRO_MANA_POTION"] = "- 마나 물약"
L["MACRO_SOULSTONE"] = "- 영혼석"
L["MACRO_WATER"] = "- 물"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "레벨"

--------------------------------------------------------------------------------
-- Pet Diets
--------------------------------------------------------------------------------

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

L["DIET_BREAD"] = "빵"
L["DIET_CHEESE"] = "치즈"
L["DIET_FISH"] = "생선"
L["DIET_FRUIT"] = "과일"
L["DIET_FUNGUS"] = "버섯"
L["DIET_MEAT"] = "고기"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] = "버그를 발견한 것 같습니다! %s (%s) 아이템은 %s > %s (%s)에서 사용할 수 없습니다. 수정할 수 있도록 제보해 주세요. 감사합니다! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "가방에 적합한 %s(이)가 없습니다."
L["MSG_MACRO_SLOTS_FULL"] = "매크로 슬롯이 가득 차서 일부 Connoisseur 매크로를 생성할 수 없습니다. 더 이상 사용하지 않는 매크로를 삭제하여 슬롯을 비우거나 설정 > 애드온 > Connoisseur에서 필요 없는 매크로를 끄십시오."

L["CHAT_LOADED"] = "버전 %s. 설정(이 메시지 비활성화 옵션 포함)은 설정 > 애드온 > Connoisseur에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Core.lua.

L["TIP_PET_NO_FOOD"] = "현재 소환수에게 줄 수 있는 적절한 먹이가 없습니다."
L["TIP_PET_NO_SKILLS"] = "현재 야수 먹이 주기, 야수 치료 또는 야수 되살리기를 배우지 않았습니다."
L["TIP_PET_NO_MEND"] = "현재 야수 치료를 배우지 않았습니다."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "현재 %s 기술을 배우지 않았습니다."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

L["MENU_BUFF_FOOD"] = "버프 음식 우선"
L["MENU_BUFF_FOOD_DESCRIPTION"] = "\"포만감\" 버프가 없을 때 해당 버프를 주는 음식을 우선 사용합니다."
L["MENU_CLEAR_IGNORE"] = "차단 목록 초기화"
L["MENU_IGNORE"] = "차단"

L["MENU_SCROLL_BUFFS"] = "두루마리 버프"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "두루마리 버프가 없을 때 음식 매크로를 두루마리 적용기로 전환합니다."
L["MENU_OPTIONS_HINT"] = "설정 > 애드온 > Connoisseur에서 추가 옵션을 사용할 수 있습니다."

L["PREFIX_HUNTER"] = "사냥꾼 주의"
L["PREFIX_MAGE"] = "마법사 주의"
L["PREFIX_WARLOCK"] = "흑마법사 주의"

L["TIP_DOWNRANK"] = "자신보다 레벨이 낮은 플레이어를 대상으로 하면 해당 레벨에 맞는 아이템을 창조합니다."
L["TIP_HUNTER_FEED_PET"] = "야수 먹이 주기는 올인원 야수 버튼입니다! 클릭하여 자동으로 야수를 부르거나, 먹이를 주거나, 되살립니다. 전투 중에 사용하거나 우클릭하면 야수 치료를 시전합니다. Shift 키를 누른 채 클릭하면 강제로 되살리기를 시전하며, Ctrl 키를 누르면 소환을 해제합니다."
L["TIP_MAGE_CONJURE"] = "음식 또는 물 매크로를 우클릭하면 음식 또는 물을 창조합니다."
L["TIP_MAGE_GEM"] = "마나 보석 매크로를 우클릭하여 새 보석을 창조합니다. 다시 우클릭하면 낮은 등급의 보조 보석을 창조합니다."
L["TIP_MAGE_TABLE"] = "마우스 휠(가운데) 클릭 시 재충전의 의식을 시전합니다."
L["TIP_WARLOCK_CONJURE"] = "생명석 또는 영혼석 매크로를 우클릭하면 생명석 또는 영혼석을 창조합니다. 생명석 매크로를 다시 우클릭하면 낮은 등급의 보조 생명석을 창조합니다."
L["TIP_WARLOCK_SOUL"] = "마우스 휠(가운데) 클릭 시 영혼의 의식을 시전합니다."

L["UI_BEST_FOOD"] = "현재 음식"
L["UI_BEST_PET_FOOD"] = "현재 최고 먹이"

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.
L["LABEL_BANDAGE"] = "붕대"
L["LABEL_FOOD"] = "음식"
L["LABEL_HEALTH_POTION"] = "치유 물약"
L["LABEL_HEALTHSTONE"] = "생명석"
L["LABEL_MANA_GEM"] = "마나 보석"
L["LABEL_MANA_POTION"] = "마나 물약"
L["LABEL_PET_FOOD"] = "야수 먹이"
L["LABEL_SOULSTONE"] = "영혼석"
L["LABEL_WATER"] = "물"
L["UI_DISABLED"] = "비활성화됨"
L["UI_ENABLED"] = "활성화됨"
L["UI_IGNORE_LIST"] = "차단 목록"
L["UI_LEFT_CLICK"] = "좌클릭"
L["UI_MIDDLE_CLICK"] = "휠클릭"
L["UI_RIGHT_CLICK"] = "우클릭"
L["UI_SHIFT_LEFT"] = "Shift + 좌클릭"
L["UI_TOGGLE"] = "토글"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "항상"
L["MODE_PARTY"] = "파티 중일 때만"
L["MODE_RAID"] = "공격대 중일 때만"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "최고의 음식, 버프 음식, 물, 두루마리, 치유 및 마나 물약, 생명석, 영혼석, 마나 보석, 붕대에 대해 자동으로 업데이트되는 매크로입니다. 마법사와 흑마법사를 위한 원클릭 창조, 사냥꾼을 위한 스마트한 야수 먹이 주기 기능. 최적의 영양 상태, 최고의 성능."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "환영 메시지 활성화"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "로그인 시 채팅창에 환영 메시지를 출력합니다."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "물약 및 생명석"
L["OPTIONS_POTIONS_DESCRIPTION"] = "전투 중에는 매크로를 변경할 수 없으므로(블리자드 제한 사항), 각 물약 및 생명석 매크로는 최고 아이템과 최대 2개의 예비 아이템으로 사전 구성됩니다. 긴 전투에서는 아이콘과 툴팁이 갱신되지 않아 잘못된 아이템을 표시할 수 있지만, 매크로를 클릭하면 항상 가방에 있는 실제 최고 아이템이 사용됩니다."

-- Buff Food
L["OPTIONS_BUFF_FOOD"] = "버프 음식 우선"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = "\"포만감\" 버프가 없을 때 해당 버프를 주는 음식을 우선 사용합니다."
L["OPTIONS_BUFF_FOOD_DETAIL"] = "프로 팁: 자신을 대상으로 지정하면 음식 매크로가 항상 버프 음식과 두루마리를 건너뜁니다."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "두루마리 버프"
L["OPTIONS_USE_SCROLLS"] = "두루마리 버프 포함"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] = "두루마리 버프가 없을 때마다 음식 매크로를 전용 두루마리 적용기로 전환합니다. 한 번 누르면 두루마리를 적용하고, 다시 누르면 음식을 먹습니다. 두루마리는 전역 재사용 대기시간(GCD)의 영향을 받지 않고 자신을 대상으로 하며, 다른 우호적인 플레이어를 대상으로 지정하는 순간 매크로가 음식으로 되돌아갑니다."
L["OPTIONS_SCROLL_TYPES"] = "확인할 두루마리 유형 포함"
L["OPTIONS_SCROLL_AGILITY"] = "민첩성"
L["OPTIONS_SCROLL_INTELLECT"] = "지능"
L["OPTIONS_SCROLL_PROTECTION"] = "보호"
L["OPTIONS_SCROLL_SPIRIT"] = "정신력"
L["OPTIONS_SCROLL_STAMINA"] = "체력"
L["OPTIONS_SCROLL_STRENGTH"] = "힘"

-- Pets Food Buffs
L["OPTIONS_PET_HEADER"] = "소환수 음식 버프"
L["OPTIONS_USE_PET_BUFFS"] = "소환수 음식 버프 사용"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] = "소환수에게 \"포만감\" 버프가 없을 때 음식 매크로의 일부로 소환수 음식을 사용합니다."
L["OPTIONS_PET_BUFF_TYPES"] = "확인할 소환수 음식 유형 포함"
L["OPTIONS_PET_BUFF_KIBLERS"] = "키블러의 간식"
L["OPTIONS_PET_BUFF_SPORELING"] = "스포어가르 간식"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "드루이드"
L["OPTIONS_DRUID_MACRO_HELPER"] = "DruidMacroHelper 연동 활성화"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] = "DruidMacroHelper(/dmh)를 사용하여 치유 물약, 마나 물약, 생명석에 대한 변신 매크로를 생성합니다."
L["OPTIONS_DRUID_RETURN_FORM"] = "소모품 사용 후 변신"
L["DRUID_FORM_BEAR"] = "곰"
L["DRUID_FORM_CAT"] = "표범"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "나이트 엘프"
L["OPTIONS_SHADOWMELD_DRINKING"] = "그림자 숨기 상태로 마시기"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] = "물 매크로에 그림자 숨기를 추가하여 물을 마시는 동안 은신합니다."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESCRIPTION"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Connoisseur 설정 인터페이스를 엽니다."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "매크로 활성화"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] = "Connoisseur가 생성하고 관리할 매크로를 선택합니다. 매크로를 비활성화하면 해당 매크로도 삭제됩니다."

-- Reset
L["OPTIONS_RESET_HEADER"] = "초기화"
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "차단 목록에서 모든 아이템을 제거합니다."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "차단 목록을 지우시겠습니까?"
L["OPTIONS_RESET_ALL"] = "모든 Connoisseur 설정 초기화"
L["OPTIONS_RESET_ALL_DESCRIPTION"] = "모든 설정 및 차단 목록을 기본값으로 되돌립니다."
L["OPTIONS_RESET_ALL_CONFIRM"] = "모든 Connoisseur 설정을 기본값으로 초기화하시겠습니까?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "피드백 및 지원"