local _, ns = ...

--------------------------------------------------------------------------------
-- Adopting The Standalone Saved Variable
--------------------------------------------------------------------------------

--[[
    RETIRE AFTER 2026-09-29 -- one-time upgrade shim, written 2026-08-30.

    Delete on the first code pass after that date, all four pieces together:
      1. this file
      2. its line in Consumable-Connoisseur.toc
      3. ConnoisseurRestockerDB in that file's ## SavedVariables
      4. the ns.AdoptStandaloneRestockerDB() call in Features/Core.lua

    The date is a prompt to look, not a guarantee. What it is really counting is
    "has everyone who is coming back logged in once since the switch", and a
    player who has not opened the game since then still has their lists in the
    old table. Deleting the four pieces above is what strands them: the next
    logout writes a file without the undeclared variable, and the lists are gone
    for good. So on the day, decide -- keep it another month, or accept that
    anyone who has been away that long starts over.
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
    profile need no conversion -- the one-line format did not change, and
    ns.InflateSavedRestockItems reads every shape it has ever had (see
    Features/Restocker/Restocker-Saved-Format.lua). The character keys behind
    profileKeys and starterListDismissed did not change either, so each character
    comes back to the list it was already using.
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
    "has any profiles" would call that a populated setup and refuse to adopt over
    it; a single saved item is the first thing that only a real setup has.
]]
local function HoldsRestockItems(settings)
	for _, profile in pairs(settings.profiles or {}) do
		if next(profile) ~= nil then
			return true
		end
	end
	return false
end

--[[
    Called from InitVars in Features/Core.lua, after AceDB:New has built
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
