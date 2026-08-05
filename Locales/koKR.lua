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

L["MSG_BUG_REPORT"] =
	"버그를 발견한 것 같습니다! %s (%s) 아이템은 %s > %s (%s)에서 사용할 수 없습니다. 수정할 수 있도록 제보해 주세요. 감사합니다! %s"
L["MSG_NO_ITEM"] = "가방에 적합한 %s(이)가 없습니다."
L["MSG_MACRO_SLOTS_FULL"] =
	"매크로 슬롯이 가득 차서 일부 Connoisseur 매크로를 생성할 수 없습니다. 더 이상 사용하지 않는 매크로를 삭제하여 슬롯을 비우거나 설정 > 애드온 > Connoisseur에서 필요 없는 매크로를 끄십시오."

L["CHAT_LOADED"] =
	"버전 %s. 설정(이 메시지 비활성화 옵션 포함)은 설정 > 애드온 > Connoisseur에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

L["CHAT_OPTIONS_IN_COMBAT"] = "안전을 위해 전투 중에는 설정 인터페이스를 열 수 없습니다."

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "준비 완료!"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "부족: %s"

L["READY_WELL_FED"] = "포만감"
L["READY_SCROLLS"] = "두루마리"
L["READY_PET_FED"] = "소환수 포만감"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d분"
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s 1분 미만"

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

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "버프 음식"
L["MENU_BUFF_FOOD_DESCRIPTION"] =
	'"포만감" 버프가 없을 때 해당 버프를 주는 음식을 우선 사용합니다.'
L["FEATURE_SCROLL_BUFFS"] = "두루마리 버프"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"두루마리 버프가 없을 때 음식 매크로를 두루마리 적용기로 전환합니다."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "현재 음식"
L["UI_BEST_PET_FOOD"] = "현재 소환수 먹이"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "주 무기"
L["UI_OFF_HAND"] = "보조 무기"
L["UI_IGNORE_LIST"] = "차단 목록"
L["MENU_IGNORE"] = "차단"
L["MENU_CLEAR_IGNORE"] = "차단 목록 초기화"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Connoisseur 설정"
L["MENU_OPTIONS_KEYBIND"] = "Shift + 휠클릭"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

L["PREFIX_HUNTER"] = "사냥꾼 주의"
L["PREFIX_MAGE"] = "마법사 주의"
L["PREFIX_ROGUE"] = "도적 주의"
L["PREFIX_WARLOCK"] = "흑마법사 주의"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to — the blocks cover more than one macro,
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

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

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

-- Generic labels reused across the minimap tooltip and options panel.

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
	"최고의 음식, 버프 음식, 물, 물약, 생명석, 두루마리, 영혼석, 붕대, 독, 폭발물에 대해 자동으로 업데이트되는 매크로입니다. 원클릭 창조, 스마트한 야수 먹이 주기, 상인과 은행에서의 자동 보충 기능. 최적의 영양 상태, 최고의 성능."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "환영 메시지 활성화"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "로그인 시 채팅창에 환영 메시지를 출력합니다."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "미니맵 버튼 활성화"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "미니맵 버튼을 표시합니다."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "버튼에 매크로 이름 표시"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"행동 단축바 버튼에 매크로 이름 텍스트를 표시합니다. 기본값은 꺼짐이며, 블리자드가 최근 다시 표시하기 시작한 이름을 숨깁니다."

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
L["OPTIONS_READY_CHECK_HEADER"] = "준비 확인"
L["OPTIONS_READY_CHECK"] = "준비 확인 시 상태 보고"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"준비 확인이 시작될 때마다 부족한 것과 추적 중인 버프의 남은 시간을 출력합니다. 자신에게만 보입니다."

-- Buff Food. The section header reuses FEATURE_BUFF_FOOD.
L["OPTIONS_BUFF_FOOD"] = "버프 음식 우선"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'"포만감" 버프가 없을 때 해당 버프를 주는 음식을 우선 사용합니다. 투기장에서는 비활성화됩니다.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"프로 팁: 자신을 대상으로 지정하면 음식 매크로가 항상 버프 음식과 두루마리를 건너뜁니다."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "두루마리 버프 포함"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"한 번 누르면 부족한 두루마리를 적용하고, 다시 누르면 음식을 먹습니다. 두루마리는 전역 재사용 대기시간(GCD)의 영향을 받지 않고 자신을 대상으로 하며, 우호적인 플레이어를 대상으로 지정하면 건너뜁니다. 투기장에서는 비활성화됩니다."
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

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "소환수 음식 버프"
L["OPTIONS_USE_PET_BUFFS"] = "소환수 음식 버프 사용"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'소환수에게 "포만감" 버프가 없을 때 음식 매크로에 소환수 음식을 추가합니다. 투기장에서는 비활성화됩니다.'
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

-- Restocker. The section header reuses RESTOCKER_WINDOW_TITLE.
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"캐릭터별 보충 목록에 따라 가방을 채워 줍니다. 상인에게서 자동으로 구매하고 가방과 은행 사이에서 아이템을 옮깁니다. %s 명령어로 목록을 엽니다."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "은행에서 열기"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "은행 방문 시 Restocker 창을 엽니다."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "상인에게서 열기"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "상인 방문 시 Restocker 창을 엽니다."
L["OPTIONS_RESTOCKER_DEBUG"] = "Restocker 디버그 메시지 사용"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Restocker의 은행/상인 보충 결정을 단계별로 대화창에 출력합니다. 메시지가 많으며, 끌 때까지 세션이 바뀌어도 유지됩니다."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 인터페이스를 엽니다."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "보충 목록을 관리할 Restocker 창을 엽니다."

-- Enable Macros
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
L["RESTOCKER_IMPORTED_LISTS"] = "Restocker 목록을 가져왔습니다."
L["RESTOCKER_PROFILE_EXISTS"] = '"%s" 이름의 프로필이 이미 있습니다.'
L["RESTOCKER_BANK_NOT_OPEN"] = "은행이 열려 있지 않습니다."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
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
L["RESTOCKER_FINISHED_RESTOCKING"] = "보충을 마쳤습니다 (구매: %d)."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Restocker 창을 표시합니다."
L["RESTOCKER_HELP_PROFILE_ADD"] = "해당 이름의 프로필을 추가합니다."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "해당 이름의 프로필을 삭제합니다."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "현재 프로필의 이름을 해당 이름으로 바꿉니다."
L["RESTOCKER_HELP_PROFILE_COPY"] = "해당 프로필을 현재 프로필로 복사합니다."
L["RESTOCKER_HELP_PROFILE_USE"] = "활성 프로필을 해당 이름으로 전환합니다."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "아이템 필터..."
L["RESTOCKER_ADD_BUTTON"] = "추가"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "아이템 추가"
L["RESTOCKER_ADD_TOOLTIP_BODY"] =
	"가방에서 아이템을 끌어다 놓거나 숫자 아이템 ID를 입력하세요."
L["RESTOCKER_PROFILE_LABEL"] = "프로필:"
L["RESTOCKER_RENAME_LABEL"] = "이름 바꾸기:"
L["RESTOCKER_NEW_PROFILE"] = "새 프로필"
L["RESTOCKER_COPY_PROFILE"] = "복사"
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "이 프로필을 새 프로필로 복제합니다."
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s 복사본"
L["RESTOCKER_DELETE_PROFILE"] = "삭제"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "이 프로필을 삭제합니다."
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"이 프로필을 정말 삭제하시겠습니까?|n|n%s|n|n되돌릴 수 없습니다."
L["RESTOCKER_GROUP_OTHER"] = "기타"
L["RESTOCKER_REMOVE_TOOLTIP"] = "이 아이템을 보충 목록에서 제거합니다."
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "보충할 수량"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "편집을 마치면 Enter를 누르세요."
L["RESTOCKER_BUY_LABEL"] = "구매"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "상인에게서 구매"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "상인 창이 열려 있을 때 필요한 수량을 구매합니다."
L["RESTOCKER_DEPOSIT_LABEL"] = "보관"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "은행에 보관"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"은행이 열려 있을 때 초과분을 은행에 보관합니다. 0을 입력하면 전부 보관합니다."
L["RESTOCKER_WITHDRAW_LABEL"] = "찾기"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "은행에서 보충"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] =
	"은행이 열려 있을 때 필요한 아이템을 은행에서 가져옵니다."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "필요 평판"
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (%d%% 할인)"
L["RESTOCKER_REPUTATION_ANY"] = "무관"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "우호적"
L["RESTOCKER_REPUTATION_HONORED"] = "명예로운"
L["RESTOCKER_REPUTATION_REVERED"] = "확고한"
L["RESTOCKER_REPUTATION_EXALTED"] = "숭배받는"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "상인에게 필요한 평판"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] = "평판이 최소 이 단계 이상인 상인에게서만 구매합니다."
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"평판이 높을수록 가격도 저렴해집니다 (우호적 5%, 명예로운 10%, 확고한 15%, 숭배받는 20%)."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "클릭하여 평판 단계를 선택하세요."
