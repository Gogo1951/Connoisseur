local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local Header = ns.OptionsHeader
local Desc = ns.OptionsDesc
local Spacer = ns.OptionsSpacer
local RowLabel = ns.OptionsRowLabel
local SubRow, SubLabel = ns.OptionsSubRow, ns.OptionsSubLabel

--[[
    Sub-row cells, sized to their contents with room to spare rather than to the
    row budget; see ns.OptionsSubRow on why an exact fit must be avoided.
]]
local SUB_CAPTION_WIDTH = 1.0
local SUB_SELECT_WIDTH = 1.4

-- The click-layout values are long phrases, so that row gives its label less than the standard share.
local EXPLOSIVES_LABEL_WIDTH = 1.4

--------------------------------------------------------------------------------
-- Active-State Predicates
--------------------------------------------------------------------------------

--[[
    Each feature's mode sub-row and option sub-controls are hidden until the
    feature toggle is on. These read the per-character settings table that
    InitializeSavedVariables guarantees.

    Settings live on the AceDB profile, so every character configures its own
    consumables. The exceptions on this panel are account-wide and read
    ns.db.global directly: Macro Names on Buttons and the Enable Macros
    toggles (see Data/Default-Settings.lua for why each one stays there).
]]

local function GetSettings()
	return ns.db and ns.db.profile
end

local function BuffFoodActive()
	local settings = GetSettings()
	return settings and settings.useBuffFood
end

local function ScrollsActive()
	local settings = GetSettings()
	return settings and settings.useScrolls
end

local function PetBuffActive()
	local settings = GetSettings()
	return settings and settings.usePetBuffFood
end

--[[
    Gates for the sub-rows under their feature toggle: each is hidden until its
    toggle is on, matching the mode sub-rows above.
]]
local function ReapplyThresholdHidden()
	local settings = GetSettings()
	return not (settings and settings.earlyReapply)
end

local function DruidReturnFormHidden()
	if not ns.isDruid then
		return true
	end
	local settings = GetSettings()
	return not (settings and settings.enableDruidMacroHelper)
end

local function NotDruid()
	return not ns.isDruid
end

local function NotRogue()
	return not ns.isRogue
end

--[[
    Night Elf Rogues see the Rogues section instead -- it already carries
    Stealth Eating, and Shadowmeld drinking is folded into the Rogue macro.
]]
local function NotNightElf()
	return not ns.isNightElf or ns.isRogue
end

--------------------------------------------------------------------------------
-- Shared Widget Factories
--------------------------------------------------------------------------------

-- A sub-row's silver caption cell, naming the control beside it.
local function SubCaption(key)
	return {
		type = "description",
		name = SubLabel(L[key]),
		fontSize = "medium",
		width = SUB_CAPTION_WIDTH,
	}
end

--[[
    Group-restriction mode sub-row shared by Buff Food, Scrolls, and Pet Food,
    indented under the feature toggle and hidden until it is on. Selecting a
    mode rewrites the macros under the throttle.
]]
local function FeatureModeRow(settingKey, featureName, activeFn, order)
	return SubRow(order, function()
		return not activeFn()
	end, {
		SubCaption("OPTIONS_MODE_CAPTION"),
		{
			type = "select",
			name = "",
			desc = string.format(L["OPTIONS_MODE_DESCRIPTION"], featureName),
			width = SUB_SELECT_WIDTH,
			values = ns.MODE_VALUES,
			sorting = ns.MODE_ORDER,
			get = function()
				return ns.db.profile[settingKey] or "always"
			end,
			set = function(_, value)
				ns.db.profile[settingKey] = value
				ns.ResetMacroState()
				ns.RequestUpdate()
			end,
		},
	})
end

-- Toggle for one entry inside a per-character settings subtable (scroll/pet types).
local function SubsetToggle(subtableKey, key, label, order)
	return {
		type = "toggle",
		name = label,
		desc = string.format(L["OPTIONS_BUFF_TYPE_DESCRIPTION"], label),
		order = order,
		get = function()
			local subtable = ns.db.profile[subtableKey]
			return subtable and subtable[key]
		end,
		set = function(_, value)
			ns.db.profile[subtableKey][key] = value
			ns.ResetMacroState()
			ns.RequestUpdate()
		end,
	}
end

--[[
    Poison-group dropdown shared by the Main Hand and Off Hand rows. Values
    resolve through ns.GetPoisonGroupName each time the dialog renders, and any
    base item still uncached is warmed so the panel repaints with the client's
    own names. Rogue-only, like the section that hosts it.
]]
local function PoisonHandDropdown(label, description, settingKey, order)
	local sorting = {}
	for _, groupID in pairs(ns.POISON_GROUPS) do
		sorting[#sorting + 1] = groupID
	end
	table.sort(sorting)

	return {
		type = "select",
		name = label,
		desc = description,
		order = order,
		width = ns.OPTIONS_CONTROL_WIDTH,
		values = function()
			local values = {}
			local coldItemIDs = {}
			for groupID, baseItem in pairs(ns.POISON_GROUP_BASE_ITEMS or {}) do
				values[groupID] = ns.GetPoisonGroupName(groupID)
				if not C_Item.GetItemInfo(baseItem) then
					coldItemIDs[#coldItemIDs + 1] = baseItem
				end
			end
			ns.WarmItemCache(coldItemIDs, ns.OPTIONS_REGISTRY.Macros)
			return values
		end,
		sorting = sorting,
		hidden = NotRogue,
		get = function()
			return ns.db.profile[settingKey] or 4
		end,
		set = function(_, value)
			ns.db.profile[settingKey] = value
			ns.ResetMacroState()
			ns.RequestUpdate()
		end,
	}
end

--[[
    One factory for the Enable Macros toggles. hiddenFn is optional --
    Feed Pet and Poisons use it to stay hidden on the wrong class.
]]
local function MacroToggle(label, key, order, hiddenFn)
	return {
		type = "toggle",
		name = label,
		desc = string.format(L["OPTIONS_MACRO_TOGGLE_DESCRIPTION"], ns.MACRO_CONFIG[key].label),
		order = order,
		width = "normal",
		hidden = hiddenFn,
		get = function()
			return ns.IsMacroEnabled(key)
		end,
		set = function(_, value)
			ns.db.global.enabledMacros[key] = value
			ns.ResetMacroState()
			ns.RequestUpdate()
		end,
	}
end

--------------------------------------------------------------------------------
-- Macros Panel
--------------------------------------------------------------------------------

--[[
    Everything that shapes the macros Connoisseur builds, in one page: which
    macros exist, then how each behaves. Page order is Macro Names on Buttons,
    Enable Macros, Potions & Healthstones, Mana Gems & Runes, Buff
    Re-Application, Buff Food, Scroll Buffs, Pet Food Buffs, Explosives, then
    the class/race-gated Druids, Rogues, and Night Elves sections, which hide
    themselves for characters they do not apply to. The Ignore List has its
    own panel (Options-Ignore-List.lua).

    Order values keep the spaced blocks these sections used on the General page
    so a section can be reordered or extended without renumbering its
    neighbors. What stayed behind on General is add-on-level behavior that does
    not touch a macro: the welcome message, the mini-map button, and /Commands.

    Registered as this builder function rather than a built table (see
    Options/Options.lua), so AceConfig re-invokes it on every open and every
    NotifyChange, matching how every panel here registers.
]]

function ns.BuildMacrosOptions()
	local args = {
		descIntro = Desc(L["OPTIONS_MACROS_DESCRIPTION"], 1),
		spaceIntro = Spacer(2),

		-- Macro Names on Buttons
		toggleMacroNames = {
			type = "toggle",
			name = L["OPTIONS_MACRO_NAMES"],
			desc = L["OPTIONS_MACRO_NAMES_DESCRIPTION"],
			order = 3,
			width = "full",
			get = function()
				return ns.db and ns.db.global.showMacroNames
			end,
			set = function(_, value)
				ns.ToggleMacroNames(value)
			end,
		},

		-- Enable Macros
		spaceEnable0 = Spacer(10),
		headerEnableMacros = Header(L["OPTIONS_ENABLE_MACROS_HEADER"], 11),
		spaceEnable1 = Spacer(12),
		descEnableMacros = Desc(GetColor("BODY") .. L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] .. "|r", 13),
		spaceEnable2 = Spacer(14),
		enableBandage = MacroToggle(L["MACRO_BANDAGE"], "Bandage", 15),
		enableExplosive = MacroToggle(L["MACRO_EXPLOSIVES"], "Explosive", 16),
		enableFeedPet = MacroToggle(L["MACRO_FEED_PET"], "Feed Pet", 17, function()
			return not ns.isHunter
		end),
		enableFood = MacroToggle(L["MACRO_FOOD"], "Food", 18),
		enableHealthPotion = MacroToggle(L["MACRO_HEALTH_POTION"], "Health Potion", 19),
		enableHealthstone = MacroToggle(L["MACRO_HEALTHSTONE"], "Healthstone", 20),
		enableManaGem = MacroToggle(L["MACRO_MANA_GEM"], "Mana Gem", 21),
		enableManaPotion = MacroToggle(L["MACRO_MANA_POTION"], "Mana Potion", 22),
		enablePoisons = MacroToggle(L["MACRO_POISONS"], "Poisons", 23, NotRogue),
		enableSoulstone = MacroToggle(L["MACRO_SOULSTONE"], "Soulstone", 24),
		enableWater = MacroToggle(L["MACRO_WATER"], "Water", 25),

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
				local settings = GetSettings()
				return settings and settings.combineHealthstones
			end,
			set = function(_, value)
				ns.db.profile.combineHealthstones = value
				ns.ResetMacroState()
				ns.RequestUpdate()
			end,
		},

		-- Mana Gems & Runes
		spaceManaGems0 = Spacer(40),
		headerManaGems = Header(L["OPTIONS_MANA_GEMS_HEADER"], 41),
		spaceManaGems1 = Spacer(42),
		descManaGems = Desc(GetColor("BODY") .. L["OPTIONS_MANA_GEMS_DESCRIPTION"] .. "|r", 43),
		spaceManaGems2 = Spacer(44),
		toggleIncludeManaRunes = {
			type = "toggle",
			name = L["OPTIONS_INCLUDE_MANA_RUNES"],
			desc = L["OPTIONS_INCLUDE_MANA_RUNES_DESCRIPTION"],
			order = 45,
			width = "full",
			get = function()
				local settings = GetSettings()
				return settings and settings.includeManaRunes
			end,
			set = function(_, value)
				ns.db.profile.includeManaRunes = value
				ns.ResetMacroState()
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
			width = "full",
			get = function()
				local settings = GetSettings()
				return settings and settings.earlyReapply
			end,
			set = function(_, value)
				ns.db.profile.earlyReapply = value
				ns.ResetMacroState()
				ns.RequestUpdate()
			end,
		},
		reapplyThreshold = SubRow(96, ReapplyThresholdHidden, {
			SubCaption("OPTIONS_REAPPLY_THRESHOLD_CAPTION"),
			{
				type = "select",
				name = "",
				desc = L["OPTIONS_REAPPLY_THRESHOLD_DESCRIPTION"],
				width = SUB_SELECT_WIDTH,
				values = {
					[60] = L["REAPPLY_THRESHOLD_ONE"],
					[120] = string.format(L["REAPPLY_THRESHOLD_MANY"], 2),
					[180] = string.format(L["REAPPLY_THRESHOLD_MANY"], 3),
					[240] = string.format(L["REAPPLY_THRESHOLD_MANY"], 4),
					[300] = string.format(L["REAPPLY_THRESHOLD_MANY"], 5),
				},
				sorting = { 60, 120, 180, 240, 300 },
				get = function()
					return ns.db.profile.earlyReapplyThreshold or 120
				end,
				set = function(_, value)
					ns.db.profile.earlyReapplyThreshold = value
					ns.ResetMacroState()
					ns.RequestUpdate()
				end,
			},
		}),

		-- Buff Food
		spaceBuff0 = Spacer(100),
		headerBuff = Header(L["FEATURE_BUFF_FOOD"], 101),
		spaceBuff1 = Spacer(102),
		descBuff = Desc(GetColor("BODY") .. L["OPTIONS_BUFF_FOOD_DESCRIPTION"] .. "|r", 103),
		detailBuff = Desc(GetColor("HELP") .. L["OPTIONS_BUFF_FOOD_DETAIL"] .. "|r", 104),
		spaceBuff2 = Spacer(105),
		toggleBuffFood = {
			type = "toggle",
			name = L["OPTIONS_BUFF_FOOD"],
			desc = L["OPTIONS_BUFF_FOOD_DESCRIPTION"],
			order = 106,
			width = "full",
			get = function()
				return BuffFoodActive()
			end,
			set = function(_, value)
				ns.ToggleBuffFood(value)
			end,
		},
		buffFoodMode = FeatureModeRow("buffFoodMode", L["FEATURE_BUFF_FOOD"], BuffFoodActive, 107),

		-- Scroll Buffs
		spaceScroll0 = Spacer(200),
		headerScroll = Header(L["FEATURE_SCROLL_BUFFS"], 201),
		spaceScroll1 = Spacer(202),
		descScroll = Desc(GetColor("BODY") .. L["OPTIONS_USE_SCROLLS_DESCRIPTION"] .. "|r", 203),
		spaceScroll2 = Spacer(204),
		toggleScrolls = {
			type = "toggle",
			name = L["OPTIONS_USE_SCROLLS"],
			desc = L["OPTIONS_USE_SCROLLS_DESCRIPTION"],
			order = 205,
			width = "full",
			get = function()
				return ScrollsActive()
			end,
			set = function(_, value)
				ns.ToggleScrollBuffs(value)
			end,
		},
		scrollsMode = FeatureModeRow("scrollsMode", L["FEATURE_SCROLL_BUFFS"], ScrollsActive, 206),
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
			width = "full",
			get = function()
				return PetBuffActive()
			end,
			set = function(_, value)
				ns.db.profile.usePetBuffFood = value
				ns.UpdateAuraTracking()
				ns.ResetMacroState()
				ns.RequestUpdate()
			end,
		},
		petBuffFoodMode = FeatureModeRow("petBuffFoodMode", L["OPTIONS_PET_HEADER"], PetBuffActive, 306),
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
		labelExplosivesClickMode = RowLabel(
			GetColor("TITLE") .. L["OPTIONS_EXPLOSIVES_CLICK_LAYOUT"] .. "|r",
			355,
			EXPLOSIVES_LABEL_WIDTH
		),
		explosivesClickMode = {
			type = "select",
			name = "",
			desc = L["OPTIONS_EXPLOSIVES_CLICK_LAYOUT_DESCRIPTION"],
			order = 356,
			width = ns.OPTIONS_ROW_WIDTH - EXPLOSIVES_LABEL_WIDTH,
			values = {
				atplayer = L["EXPLOSIVES_MODE_ATPLAYER"],
				toss = L["EXPLOSIVES_MODE_TOSS"],
			},
			sorting = { "atplayer", "toss" },
			get = function()
				return ns.db.profile.explosivesClickMode or "atplayer"
			end,
			set = function(_, value)
				ns.db.profile.explosivesClickMode = value
				ns.ResetMacroState()
				ns.RequestUpdate()
			end,
		},

		-- Druids
		spaceDruid0 = { type = "description", name = " ", order = 500, hidden = NotDruid },
		headerDruid = Header(L["OPTIONS_DRUIDS_HEADER"], 501, NotDruid),
		spaceDruid1 = { type = "description", name = " ", order = 502, hidden = NotDruid },
		toggleDruidMacroHelper = {
			type = "toggle",
			name = L["OPTIONS_DRUID_MACRO_HELPER"],
			desc = L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"],
			order = 503,
			width = "full",
			hidden = NotDruid,
			get = function()
				return ns.db and ns.db.profile and ns.db.profile.enableDruidMacroHelper
			end,
			set = function(_, value)
				ns.ToggleDruidMacroHelper(value)
			end,
		},
		druidReturnForm = SubRow(504, DruidReturnFormHidden, {
			SubCaption("OPTIONS_DRUID_RETURN_FORM_CAPTION"),
			{
				type = "select",
				name = "",
				desc = L["OPTIONS_DRUID_RETURN_FORM_DESCRIPTION"],
				width = SUB_SELECT_WIDTH,
				values = {
					bear = L["DRUID_FORM_BEAR"],
					cat = L["DRUID_FORM_CAT"],
				},
				sorting = { "bear", "cat" },
				get = function()
					return ns.db.profile.druidReturnForm or "bear"
				end,
				set = function(_, value)
					ns.db.profile.druidReturnForm = value
					ns.ResetMacroState()
					ns.RequestUpdate()
				end,
			},
		}),

		--[[
		    Rogues -- poison group per weapon slot plus Stealth Eating.
		    Group names come from the client's own item names
		    (ns.GetPoisonGroupName), so the dropdown labels localize for
		    free. Hidden for other classes; Night Elf Rogues see THIS
		    section (the Night Elves one hides itself for Rogues).
		]]
		spaceRogue0 = { type = "description", name = " ", order = 520, hidden = NotRogue },
		headerRogue = Header(L["OPTIONS_ROGUES_HEADER"], 521, NotRogue),
		spaceRogue1 = { type = "description", name = " ", order = 522, hidden = NotRogue },
		descPoisons = {
			type = "description",
			name = GetColor("BODY") .. L["OPTIONS_POISONS_DESCRIPTION"] .. "|r",
			fontSize = "medium",
			order = 523,
			hidden = NotRogue,
		},
		spaceRogue2 = { type = "description", name = " ", order = 524, hidden = NotRogue },
		-- Label-beside-control rows: the label cell, then the unlabeled dropdown, one row wide together.
		labelMainHandPoison = {
			type = "description",
			name = GetColor("TITLE") .. L["OPTIONS_POISON_MAIN_HAND"] .. "|r",
			fontSize = "medium",
			width = ns.OPTIONS_LABEL_WIDTH,
			order = 525,
			hidden = NotRogue,
		},
		mainHandPoison = PoisonHandDropdown("", L["OPTIONS_POISON_MAIN_HAND_DESCRIPTION"], "mainHandPoisonGroup", 526),
		spaceRogue3 = { type = "description", name = " ", order = 527, hidden = NotRogue },
		labelOffHandPoison = {
			type = "description",
			name = GetColor("TITLE") .. L["OPTIONS_POISON_OFF_HAND"] .. "|r",
			fontSize = "medium",
			width = ns.OPTIONS_LABEL_WIDTH,
			order = 528,
			hidden = NotRogue,
		},
		offHandPoison = PoisonHandDropdown("", L["OPTIONS_POISON_OFF_HAND_DESCRIPTION"], "offHandPoisonGroup", 529),
		spaceRogue4 = { type = "description", name = " ", order = 530, hidden = NotRogue },
		toggleStealthEatingRogue = {
			type = "toggle",
			name = L["OPTIONS_STEALTH_EATING"],
			desc = L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"],
			order = 531,
			width = "full",
			hidden = NotRogue,
			get = function()
				return ns.db and ns.db.profile and ns.db.profile.enableStealthEating
			end,
			set = function(_, value)
				ns.ToggleStealthEating(value)
			end,
		},

		-- Night Elves
		spaceNightElf0 = { type = "description", name = " ", order = 600, hidden = NotNightElf },
		headerNightElf = Header(L["OPTIONS_NIGHTELF_HEADER"], 601, NotNightElf),
		spaceNightElf1 = { type = "description", name = " ", order = 602, hidden = NotNightElf },
		descStealthPickOne = {
			type = "description",
			name = GetColor("HELP") .. L["OPTIONS_STEALTH_PICK_ONE"] .. "|r",
			fontSize = "medium",
			order = 603,
			hidden = NotNightElf,
		},
		spaceNightElf2 = { type = "description", name = " ", order = 604, hidden = NotNightElf },
		toggleShadowmeldDrinking = {
			type = "toggle",
			name = L["OPTIONS_STEALTH_DRINKING"],
			desc = L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"],
			order = 605,
			width = "full",
			hidden = NotNightElf,
			get = function()
				return ns.db and ns.db.profile and ns.db.profile.enableShadowmeldDrinking
			end,
			set = function(_, value)
				ns.ToggleShadowmeldDrinking(value)
			end,
		},
		toggleStealthEatingNightElf = {
			type = "toggle",
			name = L["OPTIONS_STEALTH_EATING"],
			desc = L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"],
			order = 606,
			width = "full",
			hidden = NotNightElf,
			get = function()
				return ns.db and ns.db.profile and ns.db.profile.enableStealthEating
			end,
			set = function(_, value)
				ns.ToggleStealthEating(value)
			end,
		},
	}

	return {
		type = "group",
		name = L["TAB_MACROS"],
		args = args,
	}
end
