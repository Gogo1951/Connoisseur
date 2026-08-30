local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Restock Lists
--------------------------------------------------------------------------------

--[[
    The player's named shopping lists, and the compact form they are saved in.
    These are not AceDB profiles: each is a list of items, each character
    remembers which one it uses, and the stock Reset Profile control never
    reaches them.
]]

--------------------------------------------------------------------------------
-- Add List
--------------------------------------------------------------------------------

function ns.AddRestockList(newProfile)
	local settings = ns.restockSettings

	--[[
	    Never overwrite an existing list: an unguarded add replaced it with an empty
	    one and the items were unrecoverable. Same refusal ns.RenameCurrentRestockList makes.
	    ns.CreateRestockList and ns.CloneCurrentRestockList pick a free name before calling in.
	]]
	if settings.profiles[newProfile] ~= nil then
		ns.PrintMessage(string.format(L["RESTOCKER_PROFILE_EXISTS"], newProfile))
		return
	end

	settings.profiles[newProfile] = {}
	ns.UseRestockList(newProfile)

	local menu = ns.restockWindow or ns.CreateRestockWindow()
	menu:Show()
	ns.UpdateRestockList()

	ns.UpdateRestockListWidgets()
end

--------------------------------------------------------------------------------
-- Default List Names
--------------------------------------------------------------------------------

--[[
    The name a brand-new list gets: the character's class, because class is
    what actually decides a shopping list -- every Warlock wants shards and
    stones, whichever alt is holding the bags. The localized class name, since
    this is a player-facing, player-editable name like any the player could
    type themselves.

    An existing list with that name is NEVER joined automatically: it is some
    other character's curated list, and quietly attaching a new character to it
    would let that character's Starter List picks and level-up upgrades write
    into it uninvited. The new list takes a numbered variant instead
    ("Warrior (2)"), and merging the two stays the player's own call, through
    Copy. Characters that already have a profileKeys entry never come through
    here, so nobody's existing setup is renamed or moved.
]]
local function FreeClassListName(settings)
	local className = UnitClass("player")
	local name = className
	local suffix = 2
	while settings.profiles[name] ~= nil do
		name = className .. " (" .. suffix .. ")"
		suffix = suffix + 1
	end
	return name
end

--------------------------------------------------------------------------------
-- Delete List
--------------------------------------------------------------------------------

function ns.DeleteRestockList(profile)
	local settings = ns.restockSettings
	if profile == nil or settings.profiles[profile] == nil then
		return
	end
	--[[
	    Deleting the CURRENT list clears via the ns.UseRestockList fallback below;
	    this covers deleting any other list, which ns.UseRestockList never sees.
	]]
	ns.ClearRestockNewItems()
	local currentProfile = settings.currentProfile

	if currentProfile == profile then
		settings.profiles[currentProfile] = nil
		local firstKey = next(settings.profiles)
		if firstKey then
			ns.UseRestockList(firstKey)
		else
			-- Nothing left: start a fresh class-named list (no name can collide here).
			local fallback = FreeClassListName(settings)
			settings.profiles[fallback] = {}
			ns.UseRestockList(fallback)
		end
	else
		settings.profiles[profile] = nil
	end

	if not ns.restockWindow then
		ns.CreateRestockWindow()
	end
	ns.UpdateRestockListWidgets()
end

--------------------------------------------------------------------------------
-- List Widgets
--------------------------------------------------------------------------------

-- Sync the profile dropdown text and the rename box with the active profile.
function ns.UpdateRestockListWidgets()
	local settings = ns.restockSettings
	if not ns.restockWindow then
		return
	end
	ns.RefreshRestockListDropdown()
	local box = ns.restockWindow.profileRenameBox
	if box then
		box:SetText(settings.currentProfile or "")
		box:ClearFocus()
	end
end

--------------------------------------------------------------------------------
-- Rename List
--------------------------------------------------------------------------------

function ns.RenameCurrentRestockList(newName)
	local settings = ns.restockSettings
	local currentProfile = settings.currentProfile

	-- Trim; ignore empty names and no-ops, and never clobber an existing profile.
	newName = (newName or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if newName == "" or newName == currentProfile then
		ns.UpdateRestockListWidgets()
		return
	end
	if settings.profiles[newName] ~= nil then
		ns.PrintMessage(string.format(L["RESTOCKER_PROFILE_EXISTS"], newName))
		ns.UpdateRestockListWidgets()
		return
	end

	settings.profiles[newName] = settings.profiles[currentProfile]
	settings.profiles[currentProfile] = nil

	--[[
	    Every character following the old name keeps following it under the new
	    name (otherwise their profileKeys entries would dangle and they'd get a fresh
	    empty list with the old name on next login).
	]]
	for charKey, profileName in pairs(settings.profileKeys or {}) do
		if profileName == currentProfile then
			settings.profileKeys[charKey] = newName
		end
	end

	ns.UseRestockList(newName)
	ns.UpdateRestockListWidgets()
end

--[[
    The dropdown's "New List" entry. Starts a fresh list seeded with the class
    name (numbered on collision, like every new list), switches to it, then
    focuses the rename box so a different name is one keystroke away.
]]
function ns.CreateRestockList()
	ns.AddRestockList(FreeClassListName(ns.restockSettings))
	local box = ns.restockWindow and ns.restockWindow.profileRenameBox
	if box then
		box:SetFocus()
		box:HighlightText()
	end
end

--[[
    The footer's Copy button. Clones the active list into a new, uniquely named
    one ("<name> Copy", then "<name> Copy 2", ...), switches to the clone, and
    focuses the rename box so the real name can be typed immediately.
]]
function ns.CloneCurrentRestockList()
	local settings = ns.restockSettings
	local sourceName = settings.currentProfile
	local source = sourceName and settings.profiles[sourceName]
	if not source then
		return
	end

	local base = string.format(L["RESTOCKER_PROFILE_COPY_NAME"], sourceName)
	local name = base
	local suffix = 2
	while settings.profiles[name] ~= nil do
		name = base .. " " .. suffix
		suffix = suffix + 1
	end

	settings.profiles[name] = CopyTable(source)
	ns.UseRestockList(name)

	local menu = ns.restockWindow or ns.CreateRestockWindow()
	menu:Show()
	ns.UpdateRestockList()
	ns.UpdateRestockListWidgets()

	local box = ns.restockWindow and ns.restockWindow.profileRenameBox
	if box then
		box:SetFocus()
		box:HighlightText()
	end
end

--------------------------------------------------------------------------------
-- Change List
--------------------------------------------------------------------------------

function ns.SwitchRestockList(newProfile)
	if newProfile == nil or newProfile == "" then
		return
	end
	ns.UseRestockList(newProfile)

	ns.UpdateRestockListWidgets()
	ns.UpdateRestockList()

	if ns.bankIsOpen then
		ns.OnRestockerBankOpen()
	end

	if ns.merchantIsOpen then
		ns.OnRestockerMerchantShow()
	end
end

--------------------------------------------------------------------------------
-- Copy List
--------------------------------------------------------------------------------

function ns.CopyIntoCurrentRestockList(profileToCopy)
	local settings = ns.restockSettings

	if profileToCopy == nil or settings.profiles[profileToCopy] == nil then
		return
	end

	local copyProfile = CopyTable(settings.profiles[profileToCopy])
	settings.profiles[settings.currentProfile] = copyProfile

	--[[
	    The copy replaced this list's contents wholesale, so the "New" notes no
	    longer describe anything in it -- and no ns.UseRestockList runs to clear them.
	]]
	ns.ClearRestockNewItems()
	ns.UpdateRestockList()
end

-- Stable per-character identity: profileKeys and the Starter List dismissal flags key on it.
function ns.GetCharacterKey()
	local name = UnitName("player") or "Unknown"
	local realm = GetRealmName() or ""
	realm = (realm:gsub("%s+", ""))
	if realm ~= "" then
		return name .. "-" .. realm
	end
	return name
end

--[[
    Switch the active profile AND remember the choice for THIS character, so each
    character returns to its own list next login. Use this instead of writing
    settings.currentProfile directly.
]]
function ns.UseRestockList(name)
	if name == nil or name == "" then
		return
	end
	--[[
	    Any profile event stales the "New" group, and every one of them --
	    create, switch, clone, delete-with-fallback, login init -- passes
	    through here. (A rename lands here too and clears; a note about "what
	    I just added" does not outrank keeping this the single choke point.)
	]]
	ns.ClearRestockNewItems()
	local settings = ns.restockSettings
	settings.currentProfile = name
	settings.profileKeys = settings.profileKeys or {}
	settings.profileKeys[ns.GetCharacterKey()] = name
end

--[[
    Pick the list this character uses on login: its remembered choice, or --
    for a character seen for the first time -- a fresh class-named list
    (FreeClassListName above). Only characters with no profileKeys entry get
    the class scheme, so no existing setup is renamed or moved.

    The pointed-at list is created when missing, because another character can
    delete it between logins. The old backstop that gave every character an
    eponymous "Name-Realm" list is gone with the naming scheme that needed it,
    so hand-deleting one of those legacy lists finally sticks.
]]
function ns.InitCharacterRestockList()
	local settings = ns.restockSettings
	settings.profiles = settings.profiles or {}
	settings.profileKeys = settings.profileKeys or {}

	local profileName = settings.profileKeys[ns.GetCharacterKey()] or FreeClassListName(settings)

	settings.profiles[profileName] = settings.profiles[profileName] or {}
	ns.UseRestockList(profileName)
end
