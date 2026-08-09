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
    rule. These read the per-character settings table that InitVars guarantees.

    Settings live on the AceDB profile, so every character configures its own
    consumables. The exceptions on this panel are account-wide and read
    ns.db.global directly: Macro Names on Buttons and the Enable Macros
    toggles (see Data/Default-Settings.lua for why each one stays there).
]]

local function GetSettings()
	return ns.db and ns.db.profile
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

--[[
    Gates for the dropdowns that sit beside their feature toggle: each is hidden
    until its toggle is on, matching the mode dropdowns above.
]]
local function ReapplyThresholdHidden()
	local s = GetSettings()
	return not (s and s.earlyReapply)
end

local function DruidReturnFormHidden()
	if not ns.IsDruid then
		return true
	end
	local s = GetSettings()
	return not (s and s.enableDruidMacroHelper)
end

local function NotDruid()
	return not ns.IsDruid
end

local function NotRogue()
	return not ns.IsRogue
end

--[[
    Night Elf Rogues see the Rogues section instead -- it already carries
    Stealth Eating, and Shadowmeld drinking is folded into the Rogue macro.
]]
local function NotNightElf()
	return not ns.IsNightElf or ns.IsRogue
end

--------------------------------------------------------------------------------
-- Shared Widget Factories
--------------------------------------------------------------------------------

--[[
    Group-restriction mode dropdown shared by Buff Food, Scrolls, and Pet Food.
    Hidden until the owning feature is enabled; selecting a mode rewrites the
    macros under the throttle. Shares a row with its feature toggle -- the
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
			return ns.db.profile[settingKey] or "always"
		end,
		set = function(_, value)
			ns.db.profile[settingKey] = value
			if ns.ResetMacroState then
				ns.ResetMacroState()
			end
			ns.RequestUpdate()
		end,
	}
end

-- Toggle for one entry inside a per-character settings subtable (scroll/pet types).
local function SubsetToggle(subtable, key, label, order)
	return {
		type = "toggle",
		name = label,
		order = order,
		get = function()
			local t = ns.db.profile[subtable]
			return t and t[key]
		end,
		set = function(_, value)
			ns.db.profile[subtable][key] = value
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
		hidden = NotRogue,
		get = function()
			return ns.db.profile[settingKey] or 4
		end,
		set = function(_, value)
			ns.db.profile[settingKey] = value
			if ns.ResetMacroState then
				ns.ResetMacroState()
			end
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

-- ns.OptionsSpacer takes no `hidden`, so a class-gated spacer is inlined.
local function GatedSpacer(order, hiddenFn)
	return {
		type = "description",
		name = " ",
		order = order,
		hidden = hiddenFn,
	}
end

local function GatedDesc(text, order, hiddenFn)
	return {
		type = "description",
		name = text,
		fontSize = "medium",
		order = order,
		hidden = hiddenFn,
	}
end

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

--[[
    The items the scanner will never pick. Rendered through the shared item-list
    builder (ns:BuildItemListOptions), so it adds and removes exactly like every
    other player-managed list in these add-ons; this file supplies only the
    section's own head and the callbacks.

    Every mutation resets macro state and requests a rebuild, because the list is
    a scan input: an item ignored while its macro already names it has to be
    written out of that body, not just out of the list. The builder issues the
    NotifyChange that redraws the panel.
]]
local function IgnoreListTable()
	return (ns.db and ns.db.profile.ignoreList) or {}
end

local function IgnoreListChanged()
	if ns.ResetMacroState then
		ns.ResetMacroState()
	end
	ns.RequestUpdate()
end

local function BuildIgnoreListArgs()
	return ns:BuildItemListOptions({
		startOrder = 410,
		notifyKey = ns.OPTIONS_REGISTRY.Macros,
		getSourceTable = IgnoreListTable,
		onAdd = function(itemId)
			IgnoreListTable()[itemId] = true
			IgnoreListChanged()
		end,
		onRemove = function(itemId)
			IgnoreListTable()[itemId] = nil
			IgnoreListChanged()
		end,
		labels = {
			addName = L["OPTIONS_IGNORE_ADD_ID"],
			addHelp = L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"],
			addInvalid = L["OPTIONS_IGNORE_ADD_ID_INVALID"],
			removeDesc = L["OPTIONS_IGNORE_REMOVE"],
			empty = L["OPTIONS_IGNORE_EMPTY"],
		},
	})
end

--------------------------------------------------------------------------------
-- Macros Panel
--------------------------------------------------------------------------------

--[[
    Everything that shapes the macros Connoisseur builds, in one page: which
    macros exist, then how each behaves. Page order is Macro Names on Buttons,
    Enable Macros, Potions & Healthstones, Buff Re-Application, Buff Food,
    Scroll Buffs, Pet Food Buffs, Explosives, Ignore List, then the
    class/race-gated Druids, Rogues, and Night Elves sections, which hide
    themselves for characters they do not apply to.

    Order values keep the spaced blocks these sections used on the General page
    so a section can be reordered or extended without renumbering its
    neighbors. What stayed behind on General is add-on-level behavior that does
    not touch a macro: the welcome message, the mini-map button, /Commands, and
    Ready Check.

    Registered as this builder function rather than a built table (see
    Options/Options.lua), so AceConfig re-invokes it on every open and every
    NotifyChange -- which is what keeps the Ignore List rows current.
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
				if ns.ToggleMacroNames then
					ns.ToggleMacroNames(value)
				end
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
			return not ns.IsHunter
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
				local s = GetSettings()
				return s and s.combineHealthstones
			end,
			set = function(_, value)
				ns.db.profile.combineHealthstones = value
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
			--[[
                    Not the usual toggle "double" + select "normal" split: this
                    dropdown's values are whole phrases ("When < 2 Minutes...")
                    rather than the one-word modes the other rows show, and at a
                    third of the row they crowded the arrow. An even half-and-half
                    split gives the copy room without wrapping the label.
                ]]
			width = 1.5,
			get = function()
				local s = GetSettings()
				return s and s.earlyReapply
			end,
			set = function(_, value)
				ns.db.profile.earlyReapply = value
				if ns.ResetMacroState then
					ns.ResetMacroState()
				end
				ns.RequestUpdate()
			end,
		},
		reapplyThreshold = {
			type = "select",
			name = "",
			order = 96,
			width = 1.5,
			values = {
				[60] = L["REAPPLY_THRESHOLD_ONE"],
				[120] = string.format(L["REAPPLY_THRESHOLD_N"], 2),
				[180] = string.format(L["REAPPLY_THRESHOLD_N"], 3),
				[240] = string.format(L["REAPPLY_THRESHOLD_N"], 4),
				[300] = string.format(L["REAPPLY_THRESHOLD_N"], 5),
			},
			sorting = { 60, 120, 180, 240, 300 },
			hidden = ReapplyThresholdHidden,
			get = function()
				return ns.db.profile.earlyReapplyThreshold or 120
			end,
			set = function(_, value)
				ns.db.profile.earlyReapplyThreshold = value
				if ns.ResetMacroState then
					ns.ResetMacroState()
				end
				ns.RequestUpdate()
			end,
		},

		-- Buff Food
		spaceBuff0 = Spacer(100),
		headerBuff = Header(L["FEATURE_BUFF_FOOD"], 101),
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
		spaceScrollTypes0 = GatedSpacer(207, function()
			return not ScrollsActive()
		end),
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
				ns.db.profile.usePetBuffFood = value
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
		spacePetTypes0 = GatedSpacer(307, function()
			return not PetBuffActive()
		end),
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
				return ns.db.profile.explosivesClickMode or "atplayer"
			end,
			set = function(_, value)
				ns.db.profile.explosivesClickMode = value
				if ns.ResetMacroState then
					ns.ResetMacroState()
				end
				ns.RequestUpdate()
			end,
		},

		--[[
                Ignore List. The head sits here; the add box and the rows are
                merged in from the shared builder below, starting at order 410.
                Clearing the whole list is the destructive action, so it is the
                one control here that confirms -- removing a single row is one
                click and no confirm.
            ]]
		spaceIgnore0 = Spacer(400),
		headerIgnore = Header(L["UI_IGNORE_LIST"], 401),
		spaceIgnore1 = Spacer(402),
		descIgnore = Desc(GetColor("BODY") .. L["OPTIONS_IGNORE_DESCRIPTION"] .. "|r", 403),
		spaceIgnore2 = Spacer(404),
		clearIgnoreList = {
			type = "execute",
			name = L["MENU_CLEAR_IGNORE"],
			width = "double",
			order = 405,
			confirm = true,
			confirmText = L["OPTIONS_IGNORE_CLEAR_CONFIRM"],
			disabled = function()
				return next(IgnoreListTable()) == nil
			end,
			func = function()
				wipe(IgnoreListTable())
				IgnoreListChanged()
			end,
		},
		spaceIgnore3 = Spacer(406),

		-- Druids
		spaceDruid0 = GatedSpacer(500, NotDruid),
		headerDruid = Header(L["OPTIONS_DRUIDS_HEADER"], 501, NotDruid),
		spaceDruid1 = GatedSpacer(502, NotDruid),
		toggleDruidMacroHelper = {
			type = "toggle",
			name = L["OPTIONS_DRUID_MACRO_HELPER"],
			desc = L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"],
			order = 503,
			width = "double",
			hidden = NotDruid,
			get = function()
				return ns.db and ns.db.profile and ns.db.profile.enableDruidMacroHelper
			end,
			set = function(_, value)
				if ns.ToggleDruidMacroHelper then
					ns.ToggleDruidMacroHelper(value)
				end
			end,
		},
		druidReturnForm = {
			type = "select",
			name = "",
			order = 504,
			width = "normal",
			values = {
				bear = L["DRUID_FORM_BEAR"],
				cat = L["DRUID_FORM_CAT"],
			},
			sorting = { "bear", "cat" },
			hidden = DruidReturnFormHidden,
			get = function()
				return ns.db.profile.druidReturnForm or "bear"
			end,
			set = function(_, value)
				ns.db.profile.druidReturnForm = value
				if ns.ResetMacroState then
					ns.ResetMacroState()
				end
				ns.RequestUpdate()
			end,
		},

		--[[
                Rogues -- poison group per weapon slot plus Stealth Eating.
                Group names come from the client's own item names
                (ns.GetPoisonGroupName), so the dropdown labels localize for
                free. Hidden for other classes; Night Elf Rogues see THIS
                section (the Night Elves one hides itself for Rogues).
            ]]
		spaceRogue0 = GatedSpacer(520, NotRogue),
		headerRogue = Header(L["OPTIONS_ROGUES_HEADER"], 521, NotRogue),
		spaceRogue1 = GatedSpacer(522, NotRogue),
		descPoisons = GatedDesc(GetColor("BODY") .. L["OPTIONS_POISONS_DESCRIPTION"] .. "|r", 523, NotRogue),
		spaceRogue2 = GatedSpacer(524, NotRogue),
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
			hidden = NotRogue,
		},
		mainHandPoison = PoisonHandDropdown("", "mainHandPoisonGroup", 526),
		spaceRogue3 = GatedSpacer(527, NotRogue),
		labelOffHandPoison = {
			type = "description",
			name = GetColor("TITLE") .. L["OPTIONS_POISON_OFF_HAND"] .. "|r",
			fontSize = "medium",
			width = "double",
			order = 528,
			hidden = NotRogue,
		},
		offHandPoison = PoisonHandDropdown("", "offHandPoisonGroup", 529),
		spaceRogue4 = GatedSpacer(530, NotRogue),
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
				if ns.ToggleStealthEating then
					ns.ToggleStealthEating(value)
				end
			end,
		},

		-- Night Elves
		spaceNightElf0 = GatedSpacer(600, NotNightElf),
		headerNightElf = Header(L["OPTIONS_NIGHTELF_HEADER"], 601, NotNightElf),
		spaceNightElf1 = GatedSpacer(602, NotNightElf),
		toggleShadowmeldDrinking = {
			type = "toggle",
			name = L["OPTIONS_STEALTH_DRINKING"],
			desc = L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"],
			order = 603,
			width = "full",
			hidden = NotNightElf,
			get = function()
				return ns.db and ns.db.profile and ns.db.profile.enableShadowmeldDrinking
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
			hidden = NotNightElf,
			get = function()
				return ns.db and ns.db.profile and ns.db.profile.enableStealthEating
			end,
			set = function(_, value)
				if ns.ToggleStealthEating then
					ns.ToggleStealthEating(value)
				end
			end,
		},
		spaceNightElf2 = GatedSpacer(605, NotNightElf),
		descStealthPickOne = GatedDesc(GetColor("HELP") .. L["OPTIONS_STEALTH_PICK_ONE"] .. "|r", 606, NotNightElf),
	}

	-- The Ignore List's add box and item rows, seated under the head above.
	for key, option in pairs(BuildIgnoreListArgs()) do
		args[key] = option
	end

	return {
		type = "group",
		name = L["OPTIONS_MACROS_TAB"],
		args = args,
	}
end
