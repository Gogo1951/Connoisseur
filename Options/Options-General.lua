local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local Header = ns.OptionsHeader
local Desc = ns.OptionsDesc
local Spacer = ns.OptionsSpacer

--------------------------------------------------------------------------------
-- Active-State Predicates
--------------------------------------------------------------------------------

--[[
    Each feature's mode dropdown and option sub-controls are hidden until the
    feature toggle is on, mirroring the guide's "hide unavailable controls"
    rule. These read the account-wide settings table that InitVars guarantees.
]]

local function GetSettings()
	return ns.db and ns.db.global
end

--[[
    Restocker keeps its own account-wide SavedVariable (ConnoisseurRestockerDB),
    bound to CrsModule.restockerModule.settings at PLAYER_LOGIN — it is not part
    of the AceDB database, so its controls read and write through this accessor
    instead of ns.db.global.
]]
local function GetRestockerSettings()
	local restockerModule = CrsModule and CrsModule.restockerModule
	return restockerModule and restockerModule.settings
end

local function BuffFoodActive()
	local s = GetSettings()
	return s and s.useBuffFood
end

local function ScrollsActive()
	local s = GetSettings()
	return s and s.useScrolls
end

local function PetBuffActive()
	local s = GetSettings()
	return s and s.usePetBuffFood
end

--------------------------------------------------------------------------------
-- Shared Widget Factories
--------------------------------------------------------------------------------

--[[
    Group-restriction mode dropdown shared by Buff Food, Scrolls, and Pet Food.
    Hidden until the owning feature is enabled; selecting a mode rewrites the
    macros under the throttle. Shares a row with its feature toggle — the
    toggle is width "double" and this select "normal", so both fit one row
    (same recipe as MagicEraser's Auto Vend row).
]]
local function FeatureMode(settingKey, activeFn, order)
	return {
		type = "select",
		name = "",
		order = order,
		width = "normal",
		values = ns.MODE_VALUES,
		sorting = ns.MODE_ORDER,
		hidden = function()
			return not activeFn()
		end,
		get = function()
			return ns.db.global[settingKey] or "always"
		end,
		set = function(_, value)
			ns.db.global[settingKey] = value
			if ns.ResetMacroState then
				ns.ResetMacroState()
			end
			ns.RequestUpdate()
		end,
	}
end

-- Toggle for one entry inside an account-wide settings subtable (scroll/pet types).
local function SubsetToggle(subtable, key, label, order)
	return {
		type = "toggle",
		name = label,
		order = order,
		get = function()
			local t = ns.db.global[subtable]
			return t and t[key]
		end,
		set = function(_, value)
			ns.db.global[subtable][key] = value
			if ns.ResetMacroState then
				ns.ResetMacroState()
			end
			ns.RequestUpdate()
		end,
	}
end

--[[
    Poison-group dropdown shared by the Main Hand and Off Hand rows. Values
    resolve through ns.GetPoisonGroupName each time the dialog renders, so
    the labels arrive once the client's item cache warms. Rogue-only, like
    the section that hosts it.
]]
local function PoisonHandDropdown(label, settingKey, order)
	return {
		type = "select",
		name = label,
		order = order,
		width = "normal",
		values = function()
			local values = {}
			for groupID in pairs(ns.PoisonGroupBaseItems or {}) do
				values[groupID] = ns.GetPoisonGroupName(groupID)
			end
			return values
		end,
		sorting = { 1, 2, 3, 4, 5, 6 },
		hidden = function()
			return not ns.IsRogue
		end,
		get = function()
			return ns.db.global[settingKey] or 4
		end,
		set = function(_, value)
			ns.db.global[settingKey] = value
			if ns.ResetMacroState then
				ns.ResetMacroState()
			end
			ns.RequestUpdate()
		end,
	}
end

--[[
    One factory for the Enable Macros toggles. hiddenFn is optional —
    Feed Pet and Poisons use it to stay hidden on the wrong class.
]]
local function MacroToggle(label, key, order, hiddenFn)
	return {
		type = "toggle",
		name = label,
		order = order,
		width = "normal",
		hidden = hiddenFn,
		get = function()
			return ns.IsMacroEnabled(key)
		end,
		set = function(_, value)
			ns.db.global.enabledMacros[key] = value
			if ns.ResetMacroState then
				ns.ResetMacroState()
			end
			ns.RequestUpdate()
		end,
	}
end

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

--[[
    The single settings page. Per the guide's Main Page Layout, all
    feature-specific settings live here rather than as separate Blizzard
    sub-panels, in order: intro and general toggles, /Commands, Potions &
    Healthstones, Buff Re-Application, Buff Food, Ready Check, Scroll Buffs,
    Pet Food Buffs, Explosives, the class/race-gated Druids, Rogues, and Night
    Elves sections (hidden for other characters), Enable Macros, Restocker,
    Feedback & Support, and version. Only Diagnostic Tools is a separate
    panel. Order values are grouped in spaced blocks so sections can be
    reordered or extended without renumbering their neighbors.
]]

function ns.BuildGeneralOptions()
	return {
		name = L["ADDON_TITLE"],
		type = "group",
		args = {
			descIntro = Desc(L["OPTIONS_DESCRIPTION"], 1),

			-- Welcome Message
			spaceWelcome0 = Spacer(10),
			toggleWelcomeMessage = {
				type = "toggle",
				name = L["OPTIONS_WELCOME_MESSAGE"],
				desc = L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"],
				order = 11,
				width = "full",
				get = function()
					return ns.db and ns.db.global.showWelcome
				end,
				set = function(_, value)
					if ns.db then
						ns.db.global.showWelcome = value
					end
				end,
			},

			-- Minimap Button
			toggleMinimapButton = {
				type = "toggle",
				name = L["OPTIONS_MINIMAP_BUTTON"],
				desc = L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"],
				order = 13,
				width = "full",
				get = function()
					return not (ns.db and ns.db.global.minimap and ns.db.global.minimap.hide)
				end,
				set = function(_, value)
					if ns.ToggleMinimapButton then
						ns.ToggleMinimapButton(value)
					end
				end,
			},

			-- Macro Names on Buttons
			toggleMacroNames = {
				type = "toggle",
				name = L["OPTIONS_MACRO_NAMES"],
				desc = L["OPTIONS_MACRO_NAMES_DESCRIPTION"],
				order = 14,
				width = "full",
				get = function()
					return ns.db and ns.db.global.showMacroNames
				end,
				set = function(_, value)
					if ns.ToggleMacroNames then
						ns.ToggleMacroNames(value)
					end
				end,
			},

			-- /Commands
			spaceCommands0 = Spacer(20),
			headerCommands = Header(L["OPTIONS_COMMANDS_HEADER"], 21),
			spaceCommands1 = Spacer(22),
			descCommands = Desc(
				GetColor("INFO") .. "/foodie" .. "|r" .. "  " .. L["OPTIONS_COMMANDS_FOODIE_DETAIL"],
				23
			),
			spaceCommands2 = Spacer(24),
			descCommandsCrs = Desc(GetColor("INFO") .. "/crs" .. "|r" .. "  " .. L["OPTIONS_COMMANDS_CRS_DETAIL"], 25),

			-- Potions & Healthstones
			spacePotions0 = Spacer(30),
			headerPotions = Header(L["OPTIONS_POTIONS_HEADER"], 31),
			spacePotions1 = Spacer(32),
			descPotions = Desc(GetColor("BODY") .. L["OPTIONS_POTIONS_DESCRIPTION"] .. "|r", 33),
			spacePotions2 = Spacer(34),
			toggleCombineHealthstones = {
				type = "toggle",
				name = L["OPTIONS_COMBINE_HEALTHSTONES"],
				desc = L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"],
				order = 35,
				width = "full",
				get = function()
					local s = GetSettings()
					return s and s.combineHealthstones
				end,
				set = function(_, value)
					ns.db.global.combineHealthstones = value
					if ns.ResetMacroState then
						ns.ResetMacroState()
					end
					ns.RequestUpdate()
				end,
			},

			--[[
                Buff Re-Application -- one global threshold governing Buff
                Food, Scroll Buffs, and Pet Food Buffs, so it sits above them.
                Dropdown keys are the threshold in seconds, stored directly in
                earlyReapplyThreshold.
            ]]
			spaceReapply0 = Spacer(90),
			headerReapply = Header(L["OPTIONS_REAPPLY_HEADER"], 91),
			spaceReapply1 = Spacer(92),
			descReapply = Desc(GetColor("BODY") .. L["OPTIONS_REAPPLY_DESCRIPTION"] .. "|r", 93),
			spaceReapply2 = Spacer(94),
			toggleReapply = {
				type = "toggle",
				name = L["OPTIONS_REAPPLY"],
				desc = L["OPTIONS_REAPPLY_DESCRIPTION"],
				order = 95,
				width = "double",
				get = function()
					local s = GetSettings()
					return s and s.earlyReapply
				end,
				set = function(_, value)
					ns.db.global.earlyReapply = value
					if ns.ResetMacroState then
						ns.ResetMacroState()
					end
					ns.RequestUpdate()
				end,
			},
			reapplyThreshold = {
				type = "select",
				name = L["OPTIONS_REAPPLY_THRESHOLD"],
				order = 96,
				width = "normal",
				values = {
					[60] = L["REAPPLY_THRESHOLD_ONE"],
					[120] = string.format(L["REAPPLY_THRESHOLD_N"], 2),
					[180] = string.format(L["REAPPLY_THRESHOLD_N"], 3),
					[240] = string.format(L["REAPPLY_THRESHOLD_N"], 4),
					[300] = string.format(L["REAPPLY_THRESHOLD_N"], 5),
				},
				sorting = { 60, 120, 180, 240, 300 },
				hidden = function()
					local s = GetSettings()
					return not (s and s.earlyReapply)
				end,
				get = function()
					return ns.db.global.earlyReapplyThreshold or 120
				end,
				set = function(_, value)
					ns.db.global.earlyReapplyThreshold = value
					if ns.ResetMacroState then
						ns.ResetMacroState()
					end
					ns.RequestUpdate()
				end,
			},

			-- Buff Food
			spaceBuff0 = Spacer(100),
			headerBuff = Header(L["OPTIONS_BUFF_FOOD_HEADER"], 101),
			spaceBuff1 = Spacer(102),
			descBuff = Desc(GetColor("BODY") .. L["OPTIONS_BUFF_FOOD_DESCRIPTION"] .. "|r", 103),
			spaceBuff2 = Spacer(104),
			toggleBuffFood = {
				type = "toggle",
				name = L["OPTIONS_BUFF_FOOD"],
				desc = L["OPTIONS_BUFF_FOOD_DESCRIPTION"],
				order = 105,
				width = "double",
				get = function()
					return BuffFoodActive()
				end,
				set = function(_, value)
					if ns.ToggleBuffFood then
						ns.ToggleBuffFood(value)
					end
				end,
			},
			buffFoodMode = FeatureMode("buffFoodMode", BuffFoodActive, 106),
			spaceBuff3 = Spacer(107),
			detailBuff = Desc(GetColor("HELP") .. L["OPTIONS_BUFF_FOOD_DETAIL"] .. "|r", 108),

			--[[
                Ready Check -- sits with the buff sections because it reports
                on the same buffs Buff Re-Application governs, in its own
                order block so neither neighbor has to be renumbered.
            ]]
			spaceReady0 = Spacer(150),
			headerReady = Header(L["OPTIONS_READY_CHECK_HEADER"], 151),
			spaceReady1 = Spacer(152),
			descReady = Desc(GetColor("BODY") .. L["OPTIONS_READY_CHECK_DESCRIPTION"] .. "|r", 153),
			spaceReady2 = Spacer(154),
			toggleReadyCheck = {
				type = "toggle",
				name = L["OPTIONS_READY_CHECK"],
				desc = L["OPTIONS_READY_CHECK_DESCRIPTION"],
				order = 155,
				width = "full",
				get = function()
					local s = GetSettings()
					return s and s.readyCheckReport
				end,
				set = function(_, value)
					ns.db.global.readyCheckReport = value
				end,
			},

			-- Scroll Buffs
			spaceScroll0 = Spacer(200),
			headerScroll = Header(L["OPTIONS_SCROLL_HEADER"], 201),
			spaceScroll1 = Spacer(202),
			descScroll = Desc(GetColor("BODY") .. L["OPTIONS_USE_SCROLLS_DESCRIPTION"] .. "|r", 203),
			spaceScroll2 = Spacer(204),
			toggleScrolls = {
				type = "toggle",
				name = L["OPTIONS_USE_SCROLLS"],
				desc = L["OPTIONS_USE_SCROLLS_DESCRIPTION"],
				order = 205,
				width = "double",
				get = function()
					return ScrollsActive()
				end,
				set = function(_, value)
					if ns.ToggleScrollBuffs then
						ns.ToggleScrollBuffs(value)
					end
				end,
			},
			scrollsMode = FeatureMode("scrollsMode", ScrollsActive, 206),
			spaceScrollTypes0 = {
				type = "description",
				name = " ",
				order = 207,
				hidden = function()
					return not ScrollsActive()
				end,
			},
			scrollTypesGroup = {
				type = "group",
				name = L["OPTIONS_SCROLL_TYPES"],
				order = 208,
				inline = true,
				hidden = function()
					return not ScrollsActive()
				end,
				args = {
					scrollAgility = SubsetToggle("scrollTypes", "Agility", L["OPTIONS_SCROLL_AGILITY"], 1),
					scrollIntellect = SubsetToggle("scrollTypes", "Intellect", L["OPTIONS_SCROLL_INTELLECT"], 2),
					scrollProtection = SubsetToggle("scrollTypes", "Protection", L["OPTIONS_SCROLL_PROTECTION"], 3),
					scrollSpirit = SubsetToggle("scrollTypes", "Spirit", L["OPTIONS_SCROLL_SPIRIT"], 4),
					scrollStamina = SubsetToggle("scrollTypes", "Stamina", L["OPTIONS_SCROLL_STAMINA"], 5),
					scrollStrength = SubsetToggle("scrollTypes", "Strength", L["OPTIONS_SCROLL_STRENGTH"], 6),
				},
			},

			-- Pet Food Buffs
			spacePet0 = Spacer(300),
			headerPet = Header(L["OPTIONS_PET_HEADER"], 301),
			spacePet1 = Spacer(302),
			descPet = Desc(GetColor("BODY") .. L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] .. "|r", 303),
			spacePet2 = Spacer(304),
			togglePetBuffs = {
				type = "toggle",
				name = L["OPTIONS_USE_PET_BUFFS"],
				desc = L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"],
				order = 305,
				width = "double",
				get = function()
					return PetBuffActive()
				end,
				set = function(_, value)
					ns.db.global.usePetBuffFood = value
					if ns.UpdateAuraTracking then
						ns.UpdateAuraTracking()
					end
					if ns.ResetMacroState then
						ns.ResetMacroState()
					end
					ns.RequestUpdate()
				end,
			},
			petBuffFoodMode = FeatureMode("petBuffFoodMode", PetBuffActive, 306),
			spacePetTypes0 = {
				type = "description",
				name = " ",
				order = 307,
				hidden = function()
					return not PetBuffActive()
				end,
			},
			petTypesGroup = {
				type = "group",
				name = L["OPTIONS_PET_BUFF_TYPES"],
				order = 308,
				inline = true,
				hidden = function()
					return not PetBuffActive()
				end,
				args = {
					petKiblers = SubsetToggle("petBuffTypes", "KiblersBits", L["OPTIONS_PET_BUFF_KIBLERS"], 1),
					petSporeling = SubsetToggle("petBuffTypes", "SporelingSnacks", L["OPTIONS_PET_BUFF_SPORELING"], 2),
				},
			},

			-- Explosives
			spaceExplosives0 = Spacer(350),
			headerExplosives = Header(L["OPTIONS_EXPLOSIVES_HEADER"], 351),
			spaceExplosives1 = Spacer(352),
			descExplosives = Desc(GetColor("BODY") .. L["OPTIONS_EXPLOSIVES_DESCRIPTION"] .. "|r", 353),
			spaceExplosives2 = Spacer(354),
			explosivesClickMode = {
				type = "select",
				name = "",
				order = 355,
				width = "double",
				values = {
					atplayer = L["EXPLOSIVES_MODE_ATPLAYER"],
					toss = L["EXPLOSIVES_MODE_TOSS"],
				},
				sorting = { "atplayer", "toss" },
				get = function()
					return ns.db.global.explosivesClickMode or "atplayer"
				end,
				set = function(_, value)
					ns.db.global.explosivesClickMode = value
					if ns.ResetMacroState then
						ns.ResetMacroState()
					end
					ns.RequestUpdate()
				end,
			},

			-- Enable Macros
			spaceEnable0 = Spacer(620),
			headerEnableMacros = Header(L["OPTIONS_ENABLE_MACROS_HEADER"], 621),
			spaceEnable1 = Spacer(622),
			descEnableMacros = Desc(GetColor("BODY") .. L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] .. "|r", 623),
			spaceEnable2 = Spacer(624),
			enableBandage = MacroToggle(L["MACRO_BANDAGE"], "Bandage", 625),
			enableExplosive = MacroToggle(L["MACRO_EXPLOSIVES"], "Explosive", 626),
			enableFeedPet = MacroToggle(L["MACRO_FEED_PET"], "Feed Pet", 627, function()
				return not ns.IsHunter
			end),
			enableFood = MacroToggle(L["MACRO_FOOD"], "Food", 628),
			enableHealthPotion = MacroToggle(L["MACRO_HEALTH_POTION"], "Health Potion", 629),
			enableHealthstone = MacroToggle(L["MACRO_HEALTHSTONE"], "Healthstone", 630),
			enableManaGem = MacroToggle(L["MACRO_MANA_GEM"], "Mana Gem", 631),
			enableManaPotion = MacroToggle(L["MACRO_MANA_POTION"], "Mana Potion", 632),
			enablePoisons = MacroToggle(L["MACRO_POISONS"], "Poisons", 633, function()
				return not ns.IsRogue
			end),
			enableSoulstone = MacroToggle(L["MACRO_SOULSTONE"], "Soulstone", 634),
			enableWater = MacroToggle(L["MACRO_WATER"], "Water", 635),

			-- Druids
			spaceDruid0 = {
				type = "description",
				name = " ",
				order = 500,
				hidden = function()
					return not ns.IsDruid
				end,
			},
			headerDruid = {
				type = "header",
				name = GetColor("TITLE") .. L["OPTIONS_DRUIDS_HEADER"] .. "|r",
				order = 501,
				hidden = function()
					return not ns.IsDruid
				end,
			},
			spaceDruid1 = {
				type = "description",
				name = " ",
				order = 502,
				hidden = function()
					return not ns.IsDruid
				end,
			},
			toggleDruidMacroHelper = {
				type = "toggle",
				name = L["OPTIONS_DRUID_MACRO_HELPER"],
				desc = L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"],
				order = 503,
				width = "double",
				hidden = function()
					return not ns.IsDruid
				end,
				get = function()
					return ns.db and ns.db.global and ns.db.global.enableDruidMacroHelper
				end,
				set = function(_, value)
					if ns.ToggleDruidMacroHelper then
						ns.ToggleDruidMacroHelper(value)
					end
				end,
			},
			druidReturnForm = {
				type = "select",
				name = L["OPTIONS_DRUID_RETURN_FORM"],
				order = 504,
				width = "normal",
				values = {
					bear = L["DRUID_FORM_BEAR"],
					cat = L["DRUID_FORM_CAT"],
				},
				sorting = { "bear", "cat" },
				hidden = function()
					if not ns.IsDruid then
						return true
					end
					local settings = ns.db and ns.db.global
					return not (settings and settings.enableDruidMacroHelper)
				end,
				get = function()
					return ns.db.global.druidReturnForm or "bear"
				end,
				set = function(_, value)
					ns.db.global.druidReturnForm = value
					if ns.ResetMacroState then
						ns.ResetMacroState()
					end
					ns.RequestUpdate()
				end,
			},

			-- Night Elves
			spaceNightElf0 = {
				type = "description",
				name = " ",
				order = 600,
				hidden = function()
					return not ns.IsNightElf or ns.IsRogue
				end,
			},
			headerNightElf = {
				type = "header",
				name = GetColor("TITLE") .. L["OPTIONS_NIGHTELF_HEADER"] .. "|r",
				order = 601,
				hidden = function()
					return not ns.IsNightElf or ns.IsRogue
				end,
			},
			spaceNightElf1 = {
				type = "description",
				name = " ",
				order = 602,
				hidden = function()
					return not ns.IsNightElf or ns.IsRogue
				end,
			},
			toggleShadowmeldDrinking = {
				type = "toggle",
				name = L["OPTIONS_SHADOWMELD_DRINKING"],
				desc = L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"],
				order = 603,
				width = "full",
				hidden = function()
					return not ns.IsNightElf or ns.IsRogue
				end,
				get = function()
					return ns.db and ns.db.global and ns.db.global.enableShadowmeldDrinking
				end,
				set = function(_, value)
					if ns.ToggleShadowmeldDrinking then
						ns.ToggleShadowmeldDrinking(value)
					end
				end,
			},
			toggleStealthEatingNightElf = {
				type = "toggle",
				name = L["OPTIONS_STEALTH_EATING"],
				desc = L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"],
				order = 604,
				width = "full",
				hidden = function()
					return not ns.IsNightElf or ns.IsRogue
				end,
				get = function()
					return ns.db and ns.db.global and ns.db.global.enableStealthEating
				end,
				set = function(_, value)
					if ns.ToggleStealthEating then
						ns.ToggleStealthEating(value)
					end
				end,
			},
			spaceNightElf2 = {
				type = "description",
				name = " ",
				order = 605,
				hidden = function()
					return not ns.IsNightElf or ns.IsRogue
				end,
			},
			descStealthPickOne = {
				type = "description",
				name = GetColor("HELP") .. L["OPTIONS_STEALTH_PICK_ONE"] .. "|r",
				fontSize = "medium",
				order = 606,
				hidden = function()
					return not ns.IsNightElf or ns.IsRogue
				end,
			},

			--[[
                Rogues -- poison group per weapon slot plus Stealth Eating.
                Group names come from the client's own item names
                (ns.GetPoisonGroupName), so the dropdown labels localize for
                free. Hidden for other classes; Night Elf Rogues see THIS
                section (the Night Elves one hides itself for Rogues).
            ]]
			spaceRogue0 = {
				type = "description",
				name = " ",
				order = 520,
				hidden = function()
					return not ns.IsRogue
				end,
			},
			headerRogue = {
				type = "header",
				name = GetColor("TITLE") .. L["OPTIONS_ROGUES_HEADER"] .. "|r",
				order = 521,
				hidden = function()
					return not ns.IsRogue
				end,
			},
			spaceRogue1 = {
				type = "description",
				name = " ",
				order = 522,
				hidden = function()
					return not ns.IsRogue
				end,
			},
			descPoisons = {
				type = "description",
				name = GetColor("BODY") .. L["OPTIONS_POISONS_DESCRIPTION"] .. "|r",
				fontSize = "medium",
				order = 523,
				hidden = function()
					return not ns.IsRogue
				end,
			},
			spaceRogue2 = {
				type = "description",
				name = " ",
				order = 524,
				hidden = function()
					return not ns.IsRogue
				end,
			},
			--[[
                Mixed rows, matching the Buff Food section: a double-width
                inline label on the left, the unlabeled dropdown right-aligned
                on the same row (same recipe as the toggle + FeatureMode pair).
            ]]
			labelMainHandPoison = {
				type = "description",
				name = GetColor("TITLE") .. L["OPTIONS_POISON_MAIN_HAND"] .. "|r",
				fontSize = "medium",
				width = "double",
				order = 525,
				hidden = function()
					return not ns.IsRogue
				end,
			},
			mainHandPoison = PoisonHandDropdown("", "mainHandPoisonGroup", 526),
			spaceRogue3 = {
				type = "description",
				name = " ",
				order = 527,
				hidden = function()
					return not ns.IsRogue
				end,
			},
			labelOffHandPoison = {
				type = "description",
				name = GetColor("TITLE") .. L["OPTIONS_POISON_OFF_HAND"] .. "|r",
				fontSize = "medium",
				width = "double",
				order = 528,
				hidden = function()
					return not ns.IsRogue
				end,
			},
			offHandPoison = PoisonHandDropdown("", "offHandPoisonGroup", 529),
			spaceRogue4 = {
				type = "description",
				name = " ",
				order = 530,
				hidden = function()
					return not ns.IsRogue
				end,
			},
			toggleStealthEatingRogue = {
				type = "toggle",
				name = L["OPTIONS_STEALTH_EATING"],
				desc = L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"],
				order = 531,
				width = "full",
				hidden = function()
					return not ns.IsRogue
				end,
				get = function()
					return ns.db and ns.db.global and ns.db.global.enableStealthEating
				end,
				set = function(_, value)
					if ns.ToggleStealthEating then
						ns.ToggleStealthEating(value)
					end
				end,
			},

			-- Restocker
			spaceRestocker0 = Spacer(700),
			headerRestocker = Header(L["RESTOCKER_WINDOW_TITLE"], 701),
			spaceRestocker1 = Spacer(702),
			descRestocker = Desc(GetColor("BODY") .. L["OPTIONS_RESTOCKER_DESCRIPTION"] .. "|r", 703),
			spaceRestocker2 = Spacer(704),
			toggleRestockerBank = {
				type = "toggle",
				name = L["OPTIONS_RESTOCKER_OPEN_BANK"],
				desc = L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"],
				order = 705,
				width = "full",
				get = function()
					local s = GetRestockerSettings()
					return s and s.autoOpenAtBank
				end,
				set = function(_, value)
					local s = GetRestockerSettings()
					if s then
						s.autoOpenAtBank = value
					end
				end,
			},
			toggleRestockerMerchant = {
				type = "toggle",
				name = L["OPTIONS_RESTOCKER_OPEN_MERCHANT"],
				desc = L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"],
				order = 706,
				width = "full",
				get = function()
					local s = GetRestockerSettings()
					return s and s.autoOpenAtMerchant
				end,
				set = function(_, value)
					local s = GetRestockerSettings()
					if s then
						s.autoOpenAtMerchant = value
					end
				end,
			},
			toggleRestockerDebug = {
				type = "toggle",
				name = L["OPTIONS_RESTOCKER_DEBUG"],
				desc = L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"],
				order = 707,
				width = "full",
				get = function()
					local s = GetRestockerSettings()
					return s and s.debugMessages == true
				end,
				set = function(_, value)
					local s = GetRestockerSettings()
					if s then
						s.debugMessages = value
					end
				end,
			},
			-- Feedback & Support
			spaceCommunity0 = Spacer(900),
			headerCommunity = Header(L["OPTIONS_COMMUNITY_HEADER"], 901),
			spaceCommunity1 = Spacer(902),
			discordLabel = Desc(GetColor("TITLE") .. "Discord" .. "|r", 903),
			discordURL = {
				type = "input",
				name = "",
				order = 904,
				width = "double",
				get = function()
					return ns.DISCORD_URL
				end,
				set = function() end,
			},
			spaceCommunity2 = Spacer(905),
			githubLabel = Desc(GetColor("TITLE") .. "GitHub" .. "|r", 906),
			githubURL = {
				type = "input",
				name = "",
				order = 907,
				width = "double",
				get = function()
					return ns.GITHUB_URL
				end,
				set = function() end,
			},
			spaceCommunity3 = Spacer(908),
			curseforgeLabel = Desc(GetColor("TITLE") .. "CurseForge" .. "|r", 909),
			curseforgeURL = {
				type = "input",
				name = "",
				order = 910,
				width = "double",
				get = function()
					return ns.CURSEFORGE_URL
				end,
				set = function() end,
			},
			spaceCommunity4 = Spacer(911),
			wagoLabel = Desc(GetColor("TITLE") .. "Wago" .. "|r", 912),
			wagoURL = {
				type = "input",
				name = "",
				order = 913,
				width = "double",
				get = function()
					return ns.WAGO_URL
				end,
				set = function() end,
			},

			-- Version
			spaceVersion0 = {
				type = "description",
				name = " ",
				width = "full",
				order = 998,
			},
			versionLine = {
				type = "description",
				name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
				fontSize = "medium",
				order = 999,
			},
		},
	}
end
