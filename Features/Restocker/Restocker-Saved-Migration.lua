local _, ns = ...

--------------------------------------------------------------------------------
-- Adopting The Standalone Saved Variable
--------------------------------------------------------------------------------

-- MIGRATION (remove after 2026-09-29)
--[[
    One-time upgrade shim. Delete on the first code pass after that date, all
    five pieces together:
      1. this section
      2. ConnoisseurRestockerDB in ## SavedVariables in all three flavor TOCs
         (Consumable-Connoisseur_Vanilla.toc, _TBC.toc and _Camelot.toc)
      3. the ns.AdoptStandaloneRestockerDB() call in Features/Core.lua
      4. ConnoisseurRestockerDB in .luacheckrc's globals
      5. the adoption scenarios in
         Features/Restocker/Tests/Restocker-Saved-Migration-Test.lua
    The file itself and its TOC lines stay for the key rename below.
]]

--[[
    Every release up to and including 2026.08.25.A kept the Restock List in its
    own account-wide SavedVariable, ConnoisseurRestockerDB, alongside the
    add-on's AceDB file rather than inside it. It lives at ns.db.global.restocker
    now, so one saved table holds everything and the Restocker's settings sit
    with the rest of the account-wide keys.

    Without this step every upgrading player loses their lists, and loses them
    for good. The new code reads an empty ns.db.global.restocker, and WoW writes
    back only the variables the TOC declares -- so at the first logout the old
    table is dropped from the saved file and there is nothing left to recover.
    That makes this a first-login job: it has to run before anything reads the
    new home, on the very first session of the new build.

    ConnoisseurRestockerDB is therefore still named in ## SavedVariables, and has
    to stay there while this runs: an undeclared variable is not one WoW owes us
    back. Once adopted it is set to nil, so the next save writes the file without
    it and this can never run twice on the same data.

    The declaration goes out with this file, not before it -- see the retirement
    note at the top.
]]

--[[
    The keys carried across: every key the shipped standalone build wrote that
    the current code still reads.

    debugMessages is the one it wrote that is deliberately NOT here -- it was the
    Restocker's persisted debug switch, now a runtime-only diagnostics flag, and
    Features/Core.lua clears it from the new table by name. Nor is anything from
    the builds before it (loginMessage, slashCommand, sortColumn, dataVersion):
    those keys sit in saved files as leftovers the shipped code had already
    stopped reading, and copying them over would park them in the new file
    forever.

    profiles and profileKeys come across as they are. The item lines inside a
    list need no conversion, since the one-line format did not change, and the
    character keys behind profileKeys and starterListDismissed did not change
    either, so each character comes back to the list it was already using. The
    old key names are kept here on purpose: ns.RenameRestockerSavedKeys below
    moves them to their current names in the same login.
]]
local ADOPTED_KEYS = {
	"profiles",
	"profileKeys",
	"currentProfile",
	"starterListDismissed",
	"framePos",
	"restockReminderChat",
	"restockReminderSound",
	"restockReminderMode",
	"merchantReminder",
	"merchantReminderMode",
	"bankReminder",
	"bankReminderMode",
	"autoOpenAtBank",
	"autoOpenAtMerchant",
}

--[[
    Whether the new table already holds a list the player built. A brand-new
    character gets an empty class-named list from ns.InitCharacterRestockList, so
    "has any lists" would call that a populated setup and refuse to adopt over
    it; a single saved item is the first thing that only a real setup has. Both
    key names count, because this runs before the rename below: lists saved by
    an older release still sit under profiles here, and lists saved since the
    rename sit under lists.
]]
local function HoldsRestockItems(settings)
	for _, listsKey in ipairs({ "lists", "profiles" }) do
		for _, list in pairs(settings[listsKey] or {}) do
			if next(list) ~= nil then
				return true
			end
		end
	end
	return false
end

--[[
    Called from InitializeSavedVariables in Features/Core.lua, after AceDB:New has built
    ns.db and before ns.InitializeRestocker reads ns.db.global.restocker.
]]
function ns.AdoptStandaloneRestockerDB()
	local standalone = ConnoisseurRestockerDB
	if type(standalone) ~= "table" then
		return
	end

	local settings = ns.db.global.restocker

	--[[
	    Adopt only onto an untouched table. Reaching here with real lists already
	    in place means the adoption ran in an earlier session and the client died
	    before the save that clears the old table, so what is in the old one is a
	    stale copy of what is already here -- and the player has been editing the
	    new one since.
	]]
	if not HoldsRestockItems(settings) then
		for _, key in ipairs(ADOPTED_KEYS) do
			if standalone[key] ~= nil then
				settings[key] = standalone[key]
			end
		end
	end

	-- Adopted, or knowingly passed over: either way the old table has served out its life.
	ConnoisseurRestockerDB = nil
end

--------------------------------------------------------------------------------
-- Renaming The Restocker Saved Keys
--------------------------------------------------------------------------------

-- MIGRATION (remove after 2026-10-18)
--[[
    One-time rename shim. The adoption above retires first, which leaves this
    and the Blinding Powder repair below, on the same date, as the file's last
    sections: delete on the first code pass after that date, all seven pieces
    together:
      1. this file
      2. its line in all three flavor TOCs (Consumable-Connoisseur_Vanilla.toc,
         _TBC.toc and _Camelot.toc)
      3. the ns.RenameRestockerSavedKeys() call in Features/Core.lua
      4. the ns.RepairBlindingPowderRows() call in Features/Core.lua
      5. the ns.NameBlindingPowderRows() line in Features/Restocker/Restocker-List.lua
      6. the ns.NameBlindingPowderRows stubs in Restocker-Cold-Item-Test.lua and
         Restocker-Starter-List-Test.lua (Features/Restocker/Tests/)
      7. Features/Restocker/Tests/Restocker-Saved-Migration-Test.lua
]]

--[[
    Older releases saved the Restock Lists and the window position under names
    that were abbreviated or called a list a profile. The code reads only the
    current names, so without this a returning player would find the window back
    at its default spot and every character on a fresh empty list, with their
    real lists still in the saved file under names nothing reads.

    AceDB has already filled the current names with the empty defaults from
    Data/Default-Settings.lua by the time this runs, so a key moves when its new
    name is missing or empty, and the old name is then cleared. A new name that
    already holds data is never overwritten, which also makes this safe to run
    on a file it has already renamed.
]]
local RENAMED_RESTOCKER_KEYS = {
	profiles = "lists",
	profileKeys = "listsByCharacter",
	currentProfile = "currentList",
	framePos = "framePosition",
}

local RENAMED_POSITION_KEYS = {
	xOfs = "xOffset",
	yOfs = "yOffset",
}

local function IsMissingOrEmpty(value)
	return value == nil or value == "" or (type(value) == "table" and next(value) == nil)
end

local function RenameSavedKeys(saved, renamedKeys)
	for oldKey, newKey in pairs(renamedKeys) do
		if saved[oldKey] ~= nil and IsMissingOrEmpty(saved[newKey]) then
			saved[newKey] = saved[oldKey]
			saved[oldKey] = nil
		end
	end
end

--[[
    Called from InitializeSavedVariables in Features/Core.lua right after
    ns.AdoptStandaloneRestockerDB, so a legacy table adopted under the old names
    is renamed in the same login, before ns.InitializeRestocker reads it.
]]
function ns.RenameRestockerSavedKeys()
	local settings = ns.db.global.restocker
	RenameSavedKeys(settings, RENAMED_RESTOCKER_KEYS)
	if type(settings.framePosition) == "table" then
		RenameSavedKeys(settings.framePosition, RENAMED_POSITION_KEYS)
	end
end

--------------------------------------------------------------------------------
-- Repairing The Blinding Powder Rows
--------------------------------------------------------------------------------

-- MIGRATION (remove after 2026-10-18)
--[[
    One-time repair shim. It shares the rename's date and goes in the same pass:
    the rename section's list above names its call in Features/Core.lua and its
    line in Features/Restocker/Restocker-List.lua.
]]

--[[
    Releases 2026.08.09.A through 2026.08.30.A had 6510, Infantry Gauntlets, on
    the Rogue's Blinding Powder ladder in Data/Consumable-Upgrade-Paths.lua,
    where Blinding Powder is 5530. Ticking Blinding Powder in the Starter List
    popup saved a gauntlets row. With the ladder fixed nothing ties that row to
    Blinding Powder any more, and the Restocker would go on stocking gauntlets
    for it.

    The row moves to 5530 with its amount and every flag as saved, but not its
    label. The merchant buys by the saved name, so a gauntlets name would still
    buy gauntlets, while a blank one is filled from the item cache when
    ns.InflateSavedRestockItems unpacks the list later in this same login. If the
    client has not loaded Blinding Powder by then, the row waits without a name,
    which buys nothing, until ns.NameBlindingPowderRows below names it.

    A list that already holds Blinding Powder keeps that row and just loses the
    stray. That row is the player adding the same staple by hand, so adding the
    stray's amount to it would stock it twice.

    Era only: no other client ever offered the ladder, so a 6510 row there is one
    the player added on purpose.
]]
local INFANTRY_GAUNTLETS = 6510
local BLINDING_POWDER = 5530

--[[
    A saved line minus its label. The label is the leading run of non-numeric
    fields, the same split the parser in Restocker-Saved-Format.lua makes, so the
    amount and every flag after it come back exactly as saved.
]]
local function WithoutLabel(line)
	local fields = {}
	for field in (line .. ","):gmatch("([^,]*),") do
		fields[#fields + 1] = field:match("^%s*(.-)%s*$")
	end
	for index, field in ipairs(fields) do
		if tonumber(field) ~= nil then
			return table.concat(fields, ", ", index)
		end
	end
	return ""
end

--[[
    Called from InitializeSavedVariables in Features/Core.lua right after
    ns.RenameRestockerSavedKeys, so a list still saved under an old name is
    repaired in the same login, and before ns.InitializeRestocker unpacks it.
]]
function ns.RepairBlindingPowderRows()
	if ns.FLAVOR ~= "Vanilla" then
		return
	end

	for _, list in pairs(ns.db.global.restocker.lists or {}) do
		local stray = list[INFANTRY_GAUNTLETS]
		local repaired
		if type(stray) == "string" then
			repaired = WithoutLabel(stray)
		elseif type(stray) == "table" then
			--[[
			    A table left by a crash. Unpacking names saved lines only, so
			    this one is always named by ns.NameBlindingPowderRows below.
			]]
			stray.itemID = BLINDING_POWDER
			stray.itemName = ""
			stray.itemType = nil
			stray.itemLink = nil
			repaired = stray
		end

		if repaired ~= nil then
			list[INFANTRY_GAUNTLETS] = nil
			if list[BLINDING_POWDER] == nil then
				list[BLINDING_POWDER] = repaired
			end
		end
	end
end

--[[
    Names every repaired row still without a name once the client has loaded
    Blinding Powder, and says whether one is still waiting. Unpacking names a
    blank row only when the client already has the item at login, and nothing
    else names one later, so a Rogue carrying no Blinding Powder could otherwise
    keep a row the merchant never buys, login after login.

    Called from ns.SyncRestockItemInfoSubscription (Restocker-List.lua), which
    keeps GET_ITEM_INFO_RECEIVED registered while this returns true. Every
    answer's handler forgets that item's miss and ends by syncing, so the
    Blinding Powder answer is what names the row. The ns.GetItemData call is also
    what asks the client, for a row nothing else asked about.
]]
function ns.NameBlindingPowderRows()
	if ns.FLAVOR ~= "Vanilla" then
		return false
	end

	local unnamed = {}
	for _, list in pairs((ns.restockSettings and ns.restockSettings.lists) or {}) do
		local row = list[BLINDING_POWDER]
		if type(row) == "table" and (row.itemName or "") == "" then
			unnamed[#unnamed + 1] = row
		end
	end
	if #unnamed == 0 then
		return false
	end

	local info = ns.GetItemData(BLINDING_POWDER)
	if not info then
		return true
	end
	for _, row in ipairs(unnamed) do
		row.itemName = info.itemName
		if info.itemType and info.itemType ~= "" then
			row.itemType = info.itemType
		end
	end
	-- The first sync at login runs before the window is built, and a new window draws the names itself.
	if ns.restockWindow then
		ns.UpdateRestockList()
	end
	return false
end
