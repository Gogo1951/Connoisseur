-- luacheck: allow defined, ignore 121 122 131 143
--[[
    Headless test for the List Builder's stack counts (no WoW client needed).

    Run it with:   lua Tests/Restocker-Starter-List-Test.lua        (from Features/Restocker/)

    Like the upgrade test, this does NOT model the feature. Every scenario loads the REAL
    enUS strings, ladders, category rows, Restocker-Starter-List.lua and the pop-up that
    draws it, plus the item memo (Item-Cache.lua) and the GET_ITEM_INFO_RECEIVED handler
    (Restocker-List.lua). Only the client is simulated: C_Item.GetItemInfo answers for an item
    once it has resolved, asking about any other item queues a server query, and deliver()
    answers the queue, firing GET_ITEM_INFO_RECEIVED only while the event is registered,
    which is all a real frame hears.

    THE BUG THIS PINS DOWN. The builder measured a stack in constants per category, 20 for
    every class reagent, so "1 Stack" of Symbol of Divinity put 20 on a paladin's list: four
    bag slots of an item that stacks to 5. A stack is now whatever the item reports.
    Scenario 1 is that report. Scenarios 2-5 are sizes that broke the same way (Symbol of
    Kings stacks to 100) or differ by client (Ankh and Rune of Teleportation are bigger on
    TBC), which no table of constants could get right on both.

    Scenario 9 pins a second bug found beside it. The memo remembered a miss until
    GET_ITEM_INFO_RECEIVED was heard, and the event is only registered while something is
    waiting on it. The login route's warm-up and every checkbox tooltip asked the memo
    about cold staples, so the answers arrived unheard and the misses were never
    forgotten: ticking such a row afterwards parked it in pendingStarterAdds for good, the
    box ticked and nothing added. Restocker-Cold-Item-Test.lua pins the memo's own fix.

    Scenario 11 pins the intro line. The login trigger writes the class's pre-ticked staples
    onto the list just before the window opens, so a builder that asked the list whether it
    was empty greeted a new character with the line meant for a list that already had items.

    Scenario 12 pins the names. Poison and reagent rows carry no strings of their own: each
    is named by the client -- a poison type for its ladder's first item, any other row for the
    item a tick adds -- shows loading text until that item resolves, and sorts by the name.
]]

local ROOT = arg[1] or "../.."

-- The items these scenarios resolve: { name, item type }.
local ITEMS = {
	[8766] = { "Morning Glory Dew", "Consumable" },
	[8950] = { "Homemade Cherry Pie", "Consumable" },
	[6265] = { "Soul Shard", "Reagent" },
	[6948] = { "Hearthstone", "Miscellaneous" },
	[17030] = { "Ankh", "Reagent" },
	[17031] = { "Rune of Teleportation", "Reagent" },
	[17033] = { "Symbol of Divinity", "Reagent" },
	[21177] = { "Symbol of Kings", "Reagent" },
	[2892] = { "Deadly Poison", "Consumable" },
	[3775] = { "Crippling Poison", "Consumable" },
	[5237] = { "Mind-numbing Poison", "Consumable" },
	[6947] = { "Instant Poison", "Consumable" },
	[8928] = { "Instant Poison VI", "Consumable" },
	[10918] = { "Wound Poison", "Consumable" },
	[17034] = { "Maple Seed", "Reagent" },
	[17038] = { "Ironwood Seed", "Reagent" },
}

--[[
    Max stack by client, from each item's Wowhead tooltip on classic and tbc; the poison and
    seed rows, which only the Era scenarios ask about, from the Classic Era item table.
]]
local STACKS = {
	era = {
		[8766] = 20,
		[8950] = 20,
		[6265] = 1,
		[6948] = 1,
		[17030] = 5,
		[17031] = 10,
		[17033] = 5,
		[21177] = 100,
		[2892] = 20,
		[3775] = 20,
		[5237] = 20,
		[6947] = 20,
		[8928] = 20,
		[10918] = 20,
		[17034] = 20,
		[17038] = 20,
	},
	tbc = {
		[8766] = 20,
		[8950] = 20,
		[6265] = 1,
		[6948] = 1,
		[17030] = 10,
		[17031] = 20,
		[17033] = 5,
		[21177] = 100,
	},
}
local FOLDER = { era = "Vanilla", tbc = "TBC" }

local failures = 0

local function check(label, got, want)
	if got == want then
		print(("  ok    %s = %s"):format(label, tostring(got)))
	else
		failures = failures + 1
		print(("  FAIL  %s: got %s, want %s"):format(label, tostring(got), tostring(want)))
	end
end

--[[
    One login: a fresh namespace with every file loaded again and nothing resolved. The
    memo, the pending adds and the pop-up's caches are all file locals, so a scenario
    only starts clean by reloading them.
]]
local function session(classToken, level, client)
	client = client or "era"
	local resolved, queued, registered, warmed = {}, {}, {}, {}
	local ns = {}

	C_Item = {
		GetItemInfo = function(itemID)
			local item = ITEMS[itemID]
			if not (item and resolved[itemID]) then
				queued[itemID] = true
				return nil
			end
			local link = "|cffffffff|Hitem:" .. itemID .. "|h[" .. item[1] .. "]|h|r"
			return item[1], link, 1, 1, 1, item[2], "", STACKS[client][itemID]
		end,
	}
	function UnitLevel()
		return level
	end
	function UnitClass()
		return classToken, classToken
	end
	function InCombatLockdown()
		return false
	end
	C_Timer = { After = function() end }

	-- AceLocale hands enUS its table; AceConfigDialog builds the window on Open, as the real one does.
	local L = {}
	local opened -- the build the last Open drew
	function LibStub(name)
		if name == "AceLocale-3.0" then
			return {
				NewLocale = function()
					return L
				end,
				GetLocale = function()
					return L
				end,
			}
		end
		return {
			SetDefaultSize = function() end,
			Open = function()
				opened = ns.BuildStarterListPopupOptions()
			end,
			OpenFrames = {},
		}
	end

	function ns.SetEventRegistered(event, enabled)
		registered[event] = enabled or nil
	end
	function ns.UpdateRestockList() end
	function ns.GetCharacterKey()
		return "Tester - Realm"
	end
	ns.pendingRecipes = {}
	-- MIGRATION (remove after 2026-10-18): the Blinding Powder name wait, which Restocker-Saved-Migration-Test covers.
	function ns.NameBlindingPowderRows()
		return false
	end
	ns.restockerLoaded = true
	ns.restockSettings = { currentList = "Test", lists = { Test = {} }, starterListDismissed = {} }

	-- What the pop-up takes from Options/Options-Utilities.lua.
	function ns.GetColor()
		return ""
	end
	function ns.OptionsHeader(text, order)
		return { type = "header", name = text, order = order }
	end
	function ns.OptionsDesc(text, order)
		return { type = "description", name = text, order = order }
	end
	function ns.OptionsSpacer(order)
		return { type = "description", name = " ", order = order }
	end
	function ns.WarmItemCache(itemIDs)
		for _, itemID in ipairs(itemIDs) do
			warmed[itemID] = true
		end
	end

	local function loadAddonFile(path)
		-- Add-on files are chunks taking (addonName, ns) as varargs, the way WoW loads them.
		return assert(loadfile(ROOT .. "/" .. path))("Consumable-Connoisseur", ns)
	end
	loadAddonFile("Locales/enUS.lua")
	ns.L = L
	loadAddonFile("Data/Data.lua")
	loadAddonFile("Features/Item-Cache.lua")
	loadAddonFile("Data/" .. FOLDER[client] .. "/Consumable-Upgrade-Paths-" .. FOLDER[client] .. ".lua")
	loadAddonFile("Features/Restocker/Restocker-Upgrade.lua")
	loadAddonFile("Features/Restocker/Restocker-List.lua")
	loadAddonFile("Features/Restocker/Restocker-Starter-List.lua")
	loadAddonFile("Options/Options-Starter-List-Popup.lua")

	-- Core's dispatcher, reduced to the one event in play.
	ns.restockerEventHandlers = { GET_ITEM_INFO_RECEIVED = ns.OnRestockerItemInfoReceived }

	local s = { ns = ns, L = L, list = ns.restockSettings.lists.Test, warmed = warmed }

	function s.resolve(...)
		for _, itemID in ipairs({ ... }) do
			resolved[itemID] = true
		end
	end

	-- The server answers every query so far; returns how many answers the handler heard.
	function s.deliver()
		local answered = {}
		for itemID in pairs(queued) do
			answered[#answered + 1] = itemID
		end
		local heard = 0
		for _, itemID in ipairs(answered) do
			queued[itemID] = nil
			resolved[itemID] = true
			if registered.GET_ITEM_INFO_RECEIVED then
				heard = heard + 1
				ns.restockerEventHandlers.GET_ITEM_INFO_RECEIVED(itemID, true)
			end
		end
		return heard
	end

	-- One staple's checkbox and stacks dropdown, from a fresh build of the window.
	function s.controls(key)
		for _, option in pairs(ns.BuildStarterListPopupOptions().args) do
			if option.type == "group" and option.args["toggle" .. key] then
				return option.args["toggle" .. key], option.args["stacks" .. key]
			end
		end
		error("no staple " .. key)
	end

	-- The given staples' keys in the order a fresh build of the window shows them.
	function s.order(keys)
		local wanted = {}
		for _, key in ipairs(keys) do
			wanted[key] = true
		end
		local rows = {}
		for _, option in pairs(ns.BuildStarterListPopupOptions().args) do
			if option.type == "group" then
				rows[#rows + 1] = option
			end
		end
		table.sort(rows, function(a, b)
			return a.order < b.order
		end)
		local shown = {}
		for _, row in ipairs(rows) do
			local toggles = {}
			for name, control in pairs(row.args) do
				local key = name:match("^toggle(.+)$")
				if key and wanted[key] then
					toggles[#toggles + 1] = { key = key, order = control.order }
				end
			end
			table.sort(toggles, function(a, b)
				return a.order < b.order
			end)
			for _, toggle in ipairs(toggles) do
				shown[#shown + 1] = toggle.key
			end
		end
		return table.concat(shown, ",")
	end

	function s.amount(itemID)
		return s.list[itemID] and s.list[itemID].amount
	end

	-- Whether the window the last Open drew leads with the given intro line.
	function s.openedWithIntro(key)
		return opened ~= nil and opened.args.descIntro.name:find(L[key], 1, true) ~= nil
	end

	return s
end

--------------------------------------------------------------------------------

print("1. The report: 1 Stack of Symbol of Divinity is 5, not 20")
local s = session("PALADIN", 60)
s.resolve(17033)
local toggle, stacks = s.controls("divinitysymbol")
check("dropdown opens on", stacks.get(), 1)
toggle.set(nil, true)
check("amount", s.amount(17033), 5)
check("dropdown tooltip", stacks.desc(), s.L["STARTER_POPUP_STACKS_DESCRIPTION"]:format(5))
check(
	"checkbox tooltip",
	toggle.desc(),
	s.L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"]:format("|cffffffff|Hitem:17033|h[Symbol of Divinity]|h|r", 5)
)

print("2. Symbol of Kings stacks to 100, and a count picked before the tick scales by it")
s = session("PALADIN", 60)
s.resolve(21177)
toggle, stacks = s.controls("kingssymbol")
stacks.set(nil, 3)
check("picking a count adds the staple", toggle.get(), true)
check("amount", s.amount(21177), 300)

print("3. Food keeps its 20")
s = session("PALADIN", 60)
s.resolve(8950)
s.controls("bread").set(nil, true)
check("Homemade Cherry Pie", s.amount(8950), 20)

print("4. The size is the client's: Ankh and Rune of Teleportation are bigger on TBC")
for _, client in ipairs({ "era", "tbc" }) do
	s = session("SHAMAN", 60, client)
	s.resolve(17030)
	s.controls("ankh").set(nil, true)
	check(client .. " Ankh", s.amount(17030), STACKS[client][17030])

	s = session("MAGE", 60, client)
	s.resolve(17031)
	s.controls("teleportrunes").set(nil, true)
	check(client .. " Rune of Teleportation", s.amount(17031), STACKS[client][17031])
end

print("5. A listed entry reads and writes in its own item's stacks")
s = session("PALADIN", 60)
s.resolve(21177, 17033)
s.list[21177] = { itemID = 21177, amount = 200 }
s.list[17033] = { itemID = 17033, amount = 12 }
local _, kings = s.controls("kingssymbol")
local _, divinity = s.controls("divinitysymbol")
check("200 Symbols of Kings read as", kings.get(), 2)
check("a hand-edited 12 Symbols of Divinity round to", divinity.get(), 2)
kings.set(nil, 4)
check("4 stacks of Kings write", s.amount(21177), 400)
divinity.set(nil, 3)
check("3 stacks of Divinity write", s.amount(17033), 15)

print("6. Soul Shards count shards, whatever a stack would be")
s = session("WARLOCK", 60)
s.resolve(6265)
_, stacks = s.controls("soulshards")
check("offers bare counts", stacks.values[28], "28")
check("opens on", stacks.get(), 20)
check("tooltip", stacks.desc(), s.L["STARTER_POPUP_COUNT_DESCRIPTION"])
stacks.set(nil, 28)
check("28 shards", s.amount(6265), 28)
s.list[6265].amount = 30
check("a hand-edited 30 reads as", stacks.get(), 32)

print("7. A fixed amount stays fixed")
s = session("PALADIN", 60)
s.resolve(6948)
s.controls("hearthstone").set(nil, true)
check("Hearthstone", s.amount(6948), 1)

print("8. A cold item: the window warms it and says so, and a tick waits for the answer")
s = session("PALADIN", 60)
toggle, stacks = s.controls("kingssymbol")
local loading = s.L["LOADING_ITEM"]:format(21177) .. "|r"
check("handed to the warmer", s.warmed[21177], true)
check("checkbox tooltip", toggle.desc(), loading)
check("dropdown tooltip", stacks.desc(), loading)
toggle.set(nil, true)
check("no row before the answer", s.list[21177], nil)
check("box reads ticked meanwhile", toggle.get(), true)
check("answer heard", s.deliver() > 0, true)
check("amount once resolved", s.amount(21177), 100)
check("dropdown tooltip once resolved", stacks.desc(), s.L["STARTER_POPUP_STACKS_DESCRIPTION"]:format(100))

print("9. A tooltip hovered, then a tick after the answer landed unheard, still adds")
s = session("PALADIN", 60)
s.resolve(8950, 8766) -- the pre-ticked pie and dew are already in bags, so nothing waits
s.ns.MaybeShowStarterListPopup()
check("defaults added", s.amount(8950) ~= nil and s.amount(8766) ~= nil, true)
toggle = s.controls("kingssymbol")
toggle.desc()
check("nothing was listening", s.deliver(), 0)
toggle.set(nil, true)
s.deliver()
check("Symbol of Kings added", s.amount(21177), 100)
check("nothing left pending", s.ns.HasPendingStarterAdds(), false)

print("10. A listed entry whose item has not resolved takes no guessed write")
s = session("PALADIN", 60)
s.list[21177] = { itemID = 21177, amount = 200 }
_, kings = s.controls("kingssymbol")
check("reads as the opening offer", kings.get(), 1)
kings.set(nil, 3)
check("amount untouched", s.amount(21177), 200)
check("reads as the choice meanwhile", kings.get(), 3)
s.resolve(21177)
check("reads the entry once resolved", kings.get(), 2)

print("11. The login route opens on the empty-list intro, even after its pre-ticks land")
s = session("PALADIN", 60)
s.resolve(8950, 8766) -- the pre-ticked pie and dew resolve, so both land before the window opens
s.ns.MaybeShowStarterListPopup()
check("pre-ticks already on the list", s.amount(8950) ~= nil and s.amount(8766) ~= nil, true)
check("login route leads with the empty-list intro", s.openedWithIntro("STARTER_POPUP_INTRO_EMPTY"), true)
s.ns.ShowStarterListPopup()
check("the List Builder button over the same list", s.openedWithIntro("STARTER_POPUP_INTRO_STOCKED"), true)

print("12. Poison and reagent rows are named by the client, and sort by that name")
s = session("ROGUE", 60)
local instant = s.controls("instant")
check("a cold name shows loading text", instant.name(), s.L["LOADING_ITEM"]:format(6947) .. "|r")
check("the first item is handed to the warmer", s.warmed[6947], true)
check("so is the item a tick adds", s.warmed[8928], true)
s.resolve(6947)
check("named for the ladder's first item", instant.name(), "Instant Poison")
local POISONS = { "crippling", "deadly", "instant", "mindnumbing", "wound" }
check("named rows first, cold ones by item ID", s.order(POISONS), "instant,deadly,crippling,mindnumbing,wound")
s.resolve(2892, 3775, 5237, 10918)
check("then A to Z by name", s.order(POISONS), "crippling,deadly,instant,mindnumbing,wound")

s = session("DRUID", 60)
s.resolve(17038)
check("a reagent ladder is named for what a tick adds", s.controls("seeds").name(), "Ironwood Seed")
s = session("DRUID", 20)
s.resolve(17034)
check("which follows the character's level", s.controls("seeds").name(), "Maple Seed")

print("")
if failures == 0 then
	print("ALL STARTER LIST SCENARIOS PASSED")
else
	print(("%d STARTER LIST CHECK(S) FAILED"):format(failures))
	os.exit(1)
end
