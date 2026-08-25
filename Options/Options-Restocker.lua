local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local Header = ns.OptionsHeader
local Desc = ns.OptionsDesc
local Spacer = ns.OptionsSpacer

--[[
    Speaker control beside the Play Sound toggle, matching Thanks for the Buff's
    DefineSoundPreview exactly -- same texture, same size, same width. An
    execute carrying an image renders as an AceGUI Icon rather than a captioned
    button, so it reads as a play control instead of a second setting. name
    stays empty so the Icon draws no caption; the label rides in desc, which
    AceConfigDialog shows on hover. The texture is the client's own voice-chat
    speaker, so it matches the UI in every locale without shipping art.

    It is deliberately not hidden when the toggle is off -- hearing the alert
    before turning it on is the point.

    Its Play Sound toggle must NOT be full-width, or the speaker is pushed onto
    a line of its own (TFTB learned this the same way).
]]
local SOUND_ICON = "Interface\\Common\\VoiceChat-Speaker"
local SOUND_ICON_SIZE = 18
local SOUND_ICON_WIDTH = 0.15

--------------------------------------------------------------------------------
-- Indented Sub-Options
--------------------------------------------------------------------------------

--[[
    One indented sub-option row, nested the same way in every Gogo1951 add-on.

    The row leads with a blank indent cell, which moves the checkbox itself.
    Padding the label instead would indent only the caption -- AceConfig pins a
    checkbox at the left edge of its own widget -- leaving the box lined up with
    its parent's and the words drifting away from it.

    SubLabel then colors the caption HELP silver against the parent's white, so
    the row reads as subordinate rather than merely shifted.

    The whole row is wrapped in an inline group with no name, which AceConfig
    renders as a bare SimpleGroup -- no border, no title, no padding -- at
    "fill" width. That wrapper is load-bearing, not decoration. Laid out flat,
    the indent and its control are just two more widgets in the panel's flow,
    kept together only by their widths happening to fill the line; the pair
    after them then packs onto whatever space is left and its indent stops
    indenting anything. A fill widget always gets a line to itself, so one group
    per sub-option pins one row per sub-option no matter what the pane is doing.

    Inside the group the controls need slack rather than an exact fit: a row
    summing to the full pane width sits on the wrap boundary, where a pass that
    measures a control before its width is applied tips the control onto its own
    line and strands the indent above it.

    Hiding belongs on the group, never on the controls inside it -- hiding only
    the control would leave its indent cell behind as a blank line.
]]
local function SubRow(order, hidden, controls, indentWidth)
	local args = {
		indent = {
			type = "description",
			name = " ",
			width = indentWidth or ns.OPTIONS_SUB_INDENT_WIDTH,
			order = 1,
		},
	}

	for index, control in ipairs(controls) do
		control.order = index + 1
		args["control" .. index] = control
	end

	return {
		type = "group",
		name = "",
		inline = true,
		order = order,
		hidden = hidden,
		args = args,
	}
end

local function SubLabel(text)
	return GetColor("HELP") .. text .. "|r"
end

--------------------------------------------------------------------------------
-- Restocker Panel
--------------------------------------------------------------------------------

--[[
    Restocker keeps its own account-wide SavedVariable (ConnoisseurRestockerDB),
    bound to CrsModule.restockerModule.settings at PLAYER_LOGIN -- it is not
    part of the AceDB database, so these controls read and write through this
    accessor instead of ns.db.profile. Its scoping is unchanged: the toggles
    below are account-wide, while each character defaults to its own restock
    list.
]]
local function GetRestockerSettings()
	local restockerModule = CrsModule and CrsModule.restockerModule
	return restockerModule and restockerModule.settings
end

-- The sound row only means anything while the in-town reminder itself is on.
local function RemindHidden()
	local s = GetRestockerSettings()
	return not (s and s.restockReminderChat)
end

-- Repaint the panel so a toggle's dependent rows appear without a reopen.
local function Refresh()
	LibStub("AceConfigRegistry-3.0"):NotifyChange(ns.OPTIONS_REGISTRY.Restocker)
end

local function PlayAlert()
	if CRS_ADDON and CRS_ADDON.RESTOCK_ALERT_SOUND then
		PlaySoundFile(CRS_ADDON.RESTOCK_ALERT_SOUND, "Master")
	end
end

--[[
    Each reminder is a toggle plus the dropdown choosing how much it says.

    The split is lopsided because the two sides are: the toggle carries a whole
    sentence ("Enable At-Merchant Restock Reminder") while the dropdown carries
    one word. An even half-and-half truncated every caption to "Enable
    At-Merchant Restock Re..." while the dropdown sat half empty, so the toggle
    takes the larger share and the dropdown keeps just enough to clear its
    arrow. Together they still fill one row.

    Not the same split as the Buff Re-Application row, which has the opposite
    problem -- short label, long values -- and stays even.
]]
local REMINDER_TOGGLE_WIDTH = 2.2
local REMINDER_MODE_WIDTH = 0.8

local function ReminderModes()
	return {
		[CRS_ADDON.REMINDER_SIMPLE] = L["OPTIONS_RESTOCKER_MODE_SIMPLE"],
		[CRS_ADDON.REMINDER_VERBOSE] = L["OPTIONS_RESTOCKER_MODE_VERBOSE"],
	}
end

local REMINDER_MODE_ORDER = { "simple", "verbose" }

-- A reminder's on/off toggle.
local function ReminderToggle(labelKey, descKey, settingKey, order, onSet)
	return {
		type = "toggle",
		name = L[labelKey],
		desc = L[descKey],
		order = order,
		width = REMINDER_TOGGLE_WIDTH,
		get = function()
			local s = GetRestockerSettings()
			return s and s[settingKey]
		end,
		set = function(_, value)
			local s = GetRestockerSettings()
			if s then
				s[settingKey] = value
			end
			if onSet then
				onSet()
			end
		end,
	}
end

--[[
    The Simple/Verbose dropdown beside a reminder toggle. Hidden with the
    reminder off -- how loudly a silent reminder speaks is not a question.
]]
local function ReminderMode(settingKey, enabledKey, order)
	return {
		type = "select",
		name = "",
		order = order,
		width = REMINDER_MODE_WIDTH,
		values = ReminderModes,
		sorting = REMINDER_MODE_ORDER,
		hidden = function()
			local s = GetRestockerSettings()
			return not (s and s[enabledKey])
		end,
		get = function()
			local s = GetRestockerSettings()
			return (s and s[settingKey]) or CRS_ADDON.REMINDER_VERBOSE
		end,
		set = function(_, value)
			local s = GetRestockerSettings()
			if s then
				s[settingKey] = value
			end
		end,
	}
end

--[[
    Page order: the three reminders (the only things here that speak up on
    their own, so they lead), then the window's auto-open behavior, then the
    debug switch under Advanced where it will not be tripped over, then Praise.

    Only the sound is a genuine sub-option, so only it uses SubRow.
    The three reminders are peers at the top level, each a toggle paired with
    the dropdown that says how much it reports.
]]
function ns.BuildRestockerOptions()
	return {
		type = "group",
		name = L["OPTIONS_RESTOCKER_TAB"],
		args = {
			descRestocker = Desc(
				GetColor("BODY")
					.. string.format(
						L["OPTIONS_RESTOCKER_DESCRIPTION"],
						GetColor("INFO") .. L["RESTOCKER_COMMAND"] .. "|r" .. GetColor("BODY")
					)
					.. "|r",
				1
			),
			spaceRemind0 = Spacer(2),

			--[[
                In-Town Reminders. Both the chat line and the sound fire on the
                same signal -- the game's resting status, which turns on in inns
                and cities -- and only when the Restock List is actually short
                of something. All three reminders ship on; this one defaults to
                Verbose and the other two to Simple (Restocker.lua
                loadSettings).
            ]]
			toggleRestockerRemind = ReminderToggle(
				"OPTIONS_RESTOCKER_REMIND",
				"OPTIONS_RESTOCKER_REMIND_DESCRIPTION",
				"restockReminderChat",
				3,
				-- Reveal or hide this reminder's dropdown and sound row without a reopen.
				Refresh
			),
			modeRestockerRemind = ReminderMode("restockReminderMode", "restockReminderChat", 4),

			--[[
                The speaker shares this row, so the toggle takes a plain unit
                width -- full-width would push the speaker onto a line of its
                own (the same thing TFTB's DefineSoundToggle warns about).

                Only the in-town reminder gets a sound: it arrives while you are
                running around, where a chat line is easy to miss. The merchant
                and bank reminders fire on a window you just closed, so you are
                already looking at the screen.
            ]]
			soundRow = SubRow(5, RemindHidden, {
				{
					type = "toggle",
					name = SubLabel(L["OPTIONS_RESTOCKER_REMIND_SOUND"]),
					desc = L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"],
					get = function()
						local s = GetRestockerSettings()
						return s and s.restockReminderSound
					end,
					set = function(_, value)
						local s = GetRestockerSettings()
						if s then
							s.restockReminderSound = value
						end
					end,
				},
				{
					type = "execute",
					name = "",
					desc = L["OPTIONS_RESTOCKER_SOUND_PREVIEW"],
					image = SOUND_ICON,
					imageWidth = SOUND_ICON_SIZE,
					imageHeight = SOUND_ICON_SIZE,
					width = SOUND_ICON_WIDTH,
					func = PlayAlert,
				},
			}),

			--[[
                Closing-window reminders. Peers of the in-town one, not children
                of it -- each answers a different moment, and turning off the
                nudge you get walking into town should not silence the report
                you get walking away from a vendor. Both stay quiet unless
                something is actually short.
            ]]
			spaceMerchant0 = Spacer(8),
			toggleRestockerMerchantRemind = ReminderToggle(
				"OPTIONS_RESTOCKER_MERCHANT_REMIND",
				"OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION",
				"merchantReminder",
				9,
				Refresh
			),
			modeRestockerMerchantRemind = ReminderMode("merchantReminderMode", "merchantReminder", 10),

			spaceBank0 = Spacer(11),
			toggleRestockerBankRemind = ReminderToggle(
				"OPTIONS_RESTOCKER_BANK_REMIND",
				"OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION",
				"bankReminder",
				12,
				Refresh
			),
			modeRestockerBankRemind = ReminderMode("bankReminderMode", "bankReminder", 13),

			--[[
                The starter List Builder. Reads the same per-character flag the
                pop-up's own dismiss box writes, inverted: this row says
                "enable", that box says "don't show again", and one shipping on
                against one shipping off is what makes each read naturally where
                it sits.

                Not a Restocker settings key like its neighbours -- the flag is
                keyed per character inside the Restocker DB, so it goes through
                RS rather than the shared settings accessor.
            ]]
			spaceStarter0 = Spacer(14),
			toggleStarterList = {
				type = "toggle",
				name = L["OPTIONS_RESTOCKER_STARTER_LIST"],
				desc = L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"],
				order = 15,
				width = "full",
				get = function()
					return not (CRS_ADDON and CRS_ADDON.IsStarterPopupDismissed and CRS_ADDON.IsStarterPopupDismissed())
				end,
				set = function(_, value)
					if CRS_ADDON and CRS_ADDON.SetStarterPopupDismissed then
						CRS_ADDON.SetStarterPopupDismissed(not value)
					end
				end,
			},

			-- Restocker Window
			spaceWindow0 = Spacer(20),
			headerWindow = Header(L["OPTIONS_RESTOCKER_WINDOW_HEADER"], 21),
			spaceWindow1 = Spacer(22),
			toggleRestockerBank = {
				type = "toggle",
				name = L["OPTIONS_RESTOCKER_OPEN_BANK"],
				desc = L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"],
				order = 23,
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
				order = 24,
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

			-- Advanced
			spaceAdvanced0 = Spacer(30),
			headerAdvanced = Header(L["OPTIONS_RESTOCKER_ADVANCED_HEADER"], 31),
			spaceAdvanced1 = Spacer(32),
			toggleRestockerDebug = {
				type = "toggle",
				name = L["OPTIONS_RESTOCKER_DEBUG"],
				desc = L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"],
				order = 33,
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

			--[[
                Praise. Restocker is not original work -- the feature is adopted
                code, and the people who wrote it and kept it alive are named
                here rather than only in the README, because the players using
                it are the ones who should see it. The three names match
                README.md's History section; keep the two in step.

                Names are proper nouns and stay as written in every locale
                (localization allowlist), like the service names on General.
            ]]
			spacePraise0 = Spacer(900),
			headerPraise = Header(L["OPTIONS_RESTOCKER_PRAISE_HEADER"], 901),
			spacePraise1 = Spacer(902),
			descPraise = Desc(GetColor("BODY") .. L["OPTIONS_RESTOCKER_PRAISE"] .. "|r", 903),
		},
	}
end
