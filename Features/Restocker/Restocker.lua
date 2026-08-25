local _TOCNAME, ns = ... ---@type string, table
local L = ns.L

---@class RsRestockerModule
---@field settings RsSettings
local restockerModule = CrsModule.restockerModule
restockerModule.settings = --[[---@type RsSettings]] {}

local restockItemList = {} ---@type RsTradeCommand[]

local mainFrameModule = CrsModule.mainFrameModule
local bankModule = CrsModule.bankModule
local eventsModule = CrsModule.eventsModule
local merchantModule = CrsModule.merchantModule
local envModule = CrsKvModuleManager.envModule

local RS = --[[---@type RestockerAddon]] {}
CRS_ADDON = RS ---@type RestockerAddon

-- AceEvent-3.0 replacement: one frame dispatches each registered WoW event to its
-- handler. Handlers receive the event's own args (no leading event-name argument --
-- that is what the handler signatures in Events.lua expect).
local rsEventFrame = CreateFrame("Frame")
local rsEventHandlers = {} ---@type {[string]: function}
rsEventFrame:SetScript("OnEvent", function(_, event, ...)
  local handler = rsEventHandlers[event]
  if handler then
    handler(...)
  end
end)

---@param event string
---@param handler function
function RS:RegisterEvent(event, handler)
  rsEventHandlers[event] = handler
  rsEventFrame:RegisterEvent(event)
end

-- AceConsole-3.0 replacement: all prints go through Connoisseur's branded chat line.
function RS:Print(...)
  local parts = {}
  for i = 1, select("#", ...) do
    parts[i] = tostring((select(i, ...)))
  end
  ns.PrintMessage(table.concat(parts, " "))
end

--[[
  Items added during this viewing of the window, keyed by itemID.

  A long Restock List buries a just-added item in whatever type group it
  belongs to, so newly added items are pulled into a "New" group at the top
  where their Withdraw/Deposit/Buy/reputation controls can be set straight
  away.

  "New" is a note about THIS list, THIS sitting -- so it clears the moment
  either becomes untrue: when the Restocker window closes (MainFrame.lua's
  OnHide), when the Starter List popup closes (its host's OnHide in
  Options-Starter-List-Popup.lua), and on every profile event -- create,
  switch, clone, copy, delete -- via RS:UseProfile plus the two direct sites
  in DeleteProfile and CopyProfile that never pass through it.

  Deliberately a plain field on RS rather than anything under settings: this is
  view state for one sitting and must never reach SavedVariables.
]]
RS.newItems = {}

function RS.ClearNewItems()
  wipe(RS.newItems)
end

--[[
  REMINDER DETAIL

  Every restock reminder is either a headline on its own or a headline plus one
  line per item you are short of. Stored as a mode rather than a boolean so the
  option reads as a choice ("Simple" or "Verbose") instead of an unlabelled
  switch, and so a third level could be added without another setting.
]]
RS.REMINDER_SIMPLE = "simple"
RS.REMINDER_VERBOSE = "verbose"

---Print a reminder: the headline, then in verbose mode a line per short item.
---Callers pass the list they already built, so nothing is counted twice.
---@param headline string
---@param mode string RS.REMINDER_SIMPLE or RS.REMINDER_VERBOSE
---@param groceries table[] From RS.BuildGroceryList
function RS.PrintShortfall(headline, mode, groceries)
  RS:Print(headline)
  if mode ~= RS.REMINDER_VERBOSE then
    return
  end
  for _, entry in ipairs(groceries) do
    RS:Print(string.format(L["RESTOCKER_REMINDER_ITEM"],
      entry.have, entry.wanted, RS.GetItemLink(entry.itemID, entry.itemName)))
  end
end

---The "orders outstanding" headline, singular or plural. The count is of
---grocery-list rows, not of missing units, which is what the wording says.
---@param count number Short rows, i.e. #RS.BuildGroceryList()
---@return string
function RS.ShortfallHeadline(count)
  if count == 1 then
    return L["RESTOCKER_STILL_SHORT_ONE"]
  end
  return string.format(L["RESTOCKER_STILL_SHORT_MANY"], count)
end

-- Alert played when you reach an inn or city with something left to restock.
-- Built from _TOCNAME so renaming the add-on folder cannot break the path.
RS.RESTOCK_ALERT_SOUND = "Interface\\AddOns\\" .. _TOCNAME .. "\\Includes\\Sounds\\Low-Battery.ogg"

function RS:Show()
  if RS.loaded then
    local menu = RS.MainFrame or mainFrameModule:CreateMenu();
    menu:Show()
    return RS:Update()
  end
end

function RS:Hide()
  if RS.loaded then
    local menu = RS.MainFrame or mainFrameModule:CreateMenu();
    return menu:Hide()
  end
end

function RS:Toggle()
  if RS.loaded then
    local menu = RS.MainFrame or mainFrameModule:CreateMenu();
    return menu:SetShown(not menu:IsShown()) or false
  end
end

---One slash-help line: the command in C_INFO, then the localized description
---(TEXT restored for the tail, since RS:Print wraps the whole body in TEXT).
local function rsSlashHelpLine(command, description)
  return ns.GetColor("INFO") .. command .. "|r" .. ns.GetColor("TEXT") .. "  " .. description
end

RS.commands = {
  show = rsSlashHelpLine("/crs show", L["RESTOCKER_HELP_SHOW"]),
  config = rsSlashHelpLine("/crs config", L["OPTIONS_COMMAND_DESCRIPTION"]),
  profile = --[[---@type {[string]: string}]] {
    add = rsSlashHelpLine("/crs profile add [name]", L["RESTOCKER_HELP_PROFILE_ADD"]),
    delete = rsSlashHelpLine("/crs profile delete [name]", L["RESTOCKER_HELP_PROFILE_DELETE"]),
    rename = rsSlashHelpLine("/crs profile rename [name]", L["RESTOCKER_HELP_PROFILE_RENAME"]),
    copy = rsSlashHelpLine("/crs profile copy [name]", L["RESTOCKER_HELP_PROFILE_COPY"]),
    use = rsSlashHelpLine("/crs profile use [name]", L["RESTOCKER_HELP_PROFILE_USE"])
  }
}

--[[
  SLASH COMMANDS
]]
function RS:SlashCommand(args)
  local command, rest = strsplit(" ", args, 2)
  command = command:lower()

  if command == "show" then
    RS:Show()
  elseif command == "profile" then
    if rest == "" or rest == nil then
      for _, v in pairs(RS.commands.profile) do
        RS:Print(v)
      end
      return
    end

    local subcommand, name = strsplit(" ", rest, 2)

    -- Every profile subcommand needs a name; print its usage line instead of
    -- erroring on a nil table key when the name is missing.
    if (name == nil or name == "") and RS.commands.profile[subcommand] then
      RS:Print(RS.commands.profile[subcommand])
      return
    end

    if subcommand == "add" then
      RS:AddProfile(name)
    elseif subcommand == "delete" then
      RS:DeleteProfile(name)
    elseif subcommand == "rename" then
      RS:RenameCurrentProfile(name)
    elseif subcommand == "use" then
      RS:ChangeProfile(name)
    elseif subcommand == "copy" then
      RS:CopyProfile(name)
    end
  elseif command == "help" then
    for _, eachCommand in pairs(RS.commands) do
      if type(eachCommand) == "table" then
        for _, eachSubcommand in pairs( --[[---@type table]] eachCommand) do
          RS:Print(eachSubcommand)
        end
      else
        RS:Print(eachCommand)
      end
    end
    return
  elseif command == "config" then
    if ns.OpenOptionsPanel then
      ns:OpenOptionsPanel()
    end
    return
  else
    RS:Toggle()
  end
  RS:Update()
end

--[[
  UPDATE
]]
function RS:Update()
  local settings = restockerModule.settings
  local currentProfile = --[[---@not nil]] settings.profiles[settings.currentProfile]

  -- Gather items (profile is keyed by itemID, so walk it with pairs)
  wipe(restockItemList)
  for _, v in pairs(currentProfile) do
    table.insert(restockItemList, v)
  end

  -- Sort and group into a render list -- a mix of section-header entries and item
  -- entries (headers only when sorting by type). See ListFrame.lua:BuildRenderList.
  local renderList = self:BuildRenderList(restockItemList)

  -- Release every pooled item row and header row back to the hidden frame
  for _, f in ipairs(RS.framepool) do
    f.isInUse = false
    f:SetParent(RS.hiddenFrame)
    f:Hide()
  end
  for _, h in ipairs(RS.headerpool) do
    h.isInUse = false
    h:SetParent(RS.hiddenFrame)
    h:Hide()
  end

  --[[
    Position each entry by a running offset rather than by row index: an
    expanded row is taller than its neighbours, so index * ROW_HEIGHT would
    overlap everything below it. The same accumulator gives the scroll child
    its height, which is what keeps the scroll bar's range honest.
  ]]
  local scrollChild = RS.MainFrame.scrollChild
  local offset = 0
  for _, entry in ipairs(renderList) do
    local f = entry.header and self:GetHeaderRow() or self:GetFirstEmpty(entry.item)
    local expanded = not entry.header and RS.IsRowExpanded(entry.item)
    local height = expanded and RS.ROW_HEIGHT_EXPANDED or RS.ROW_HEIGHT

    --[[
      An empty row's worth of air on BOTH sides of an expanded row, so the
      open item and its detail controls read as one block lifted out of the
      list. Pure layout: no frame fills the gaps, and the accumulator carries
      them into the scroll child's height like real rows.
    ]]
    if expanded then
      offset = offset + RS.ROW_HEIGHT
    end

    f.isInUse = true
    f:SetParent(scrollChild)
    f:ClearAllPoints()
    f:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -offset)
    f:SetSize(scrollChild:GetWidth(), height)
    if entry.header then
      f.text:SetText(entry.header)
    else
      self:UpdateRestockListRow(f, entry.item)
    end
    f:Show()
    offset = offset + height

    if expanded then
      offset = offset + RS.ROW_HEIGHT
    end
  end

  scrollChild:SetHeight(math.max(1, offset))
end

--[[
  GET FIRST UNUSED SCROLLCHILD FRAME
]]
---@param item RsTradeCommand
---@return RsRestockingListRow
function RS:GetFirstEmpty(item)
  for i, frame in ipairs(RS.framepool) do
    if not frame.isInUse then
      return frame
    end
  end
  return self:CreateRestockListRow(item)
end

--[[
  ADD PROFILE
]]
---@param newProfile string
function RS:AddProfile(newProfile)
  local settings = restockerModule.settings

  -- Never overwrite an existing list: an unguarded add replaced it with an empty
  -- one and the items were unrecoverable. Same refusal RenameCurrentProfile makes.
  -- CreateNewProfile and CloneCurrentProfile pick a free name before calling in.
  if settings.profiles[newProfile] ~= nil then
    RS:Print(string.format(L["RESTOCKER_PROFILE_EXISTS"], newProfile))
    return
  end

  settings.profiles[newProfile] = {} ---@type RsTradeCommand
  RS:UseProfile(newProfile)

  local menu = RS.MainFrame or mainFrameModule:CreateMenu()
  menu:Show()
  RS:Update()

  RS:UpdateProfileWidgets()
end

--[[
  DELETE PROFILE
]]
---@param profile string
function RS:DeleteProfile(profile)
  local settings = restockerModule.settings
  if profile == nil or settings.profiles[profile] == nil then
    return
  end
  -- Deleting the CURRENT profile clears via the UseProfile fallback below;
  -- this covers deleting any other profile, which UseProfile never sees.
  RS.ClearNewItems()
  local currentProfile = settings.currentProfile

  if currentProfile == profile then
    settings.profiles[currentProfile] = nil
    local firstKey = next(settings.profiles)
    if firstKey then
      RS:UseProfile( --[[---@not nil]] firstKey)
    else
      -- Nothing left: fall back to this character's own (empty) list
      local charKey = RS:GetCharKey()
      settings.profiles[charKey] = {}
      RS:UseProfile(charKey)
    end
  else
    settings.profiles[profile] = nil
  end

  local menu = RS.MainFrame or mainFrameModule:CreateMenu()
  RS.profileSelectedForDeletion = ""
  RS:UpdateProfileWidgets()
end

--[[
  PROFILE WIDGETS
]]
---Sync the profile dropdown text and the rename box with the active profile.
function RS:UpdateProfileWidgets()
  local settings = restockerModule.settings
  if not RS.MainFrame then
    return
  end
  UIDropDownMenu_SetText(RS.MainFrame.profileDropDownMenu, settings.currentProfile)
  local box = RS.MainFrame.profileRenameBox
  if box then
    box:SetText(settings.currentProfile or "")
    box:ClearFocus()
  end
end

--[[
  RENAME PROFILE
]]
---@param newName string
function RS:RenameCurrentProfile(newName)
  local settings = restockerModule.settings
  local currentProfile = settings.currentProfile

  -- Trim; ignore empty names and no-ops, and never clobber an existing profile.
  newName = (newName or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if newName == "" or newName == currentProfile then
    RS:UpdateProfileWidgets()
    return
  end
  if settings.profiles[newName] ~= nil then
    RS:Print(string.format(L["RESTOCKER_PROFILE_EXISTS"], newName))
    RS:UpdateProfileWidgets()
    return
  end

  settings.profiles[newName] = settings.profiles[currentProfile]
  settings.profiles[currentProfile] = nil

  -- Every character following the old name keeps following it under the new
  -- name (otherwise their profileKeys would dangle and they'd get a fresh
  -- empty list with the old name on next login).
  for charKey, profileName in pairs(settings.profileKeys or {}) do
    if profileName == currentProfile then
      settings.profileKeys[charKey] = newName
    end
  end

  RS:UseProfile(newName)
  RS:UpdateProfileWidgets()
end

--[[
  NEW PROFILE (dropdown entry)
]]
---Create and switch to a fresh, uniquely named profile, then focus the rename
---box so the real name can be typed immediately.
function RS:CreateNewProfile()
  local settings = restockerModule.settings
  local base = L["RESTOCKER_NEW_PROFILE"]
  local name = base
  local n = 2
  while settings.profiles[name] ~= nil do
    name = base .. " " .. n
    n = n + 1
  end
  RS:AddProfile(name)
  local box = RS.MainFrame and RS.MainFrame.profileRenameBox
  if box then
    box:SetFocus()
    box:HighlightText()
  end
end

--[[
  COPY PROFILE (footer button)
]]
---Clone the active profile into a new, uniquely named profile ("<name> Copy",
---then "<name> Copy 2", ...), switch to the clone, and focus the rename box so
---the real name can be typed immediately.
function RS:CloneCurrentProfile()
  local settings = restockerModule.settings
  local sourceName = settings.currentProfile
  local source = sourceName and settings.profiles[sourceName]
  if not source then
    return
  end

  local base = string.format(L["RESTOCKER_PROFILE_COPY_NAME"], sourceName)
  local name = base
  local n = 2
  while settings.profiles[name] ~= nil do
    name = base .. " " .. n
    n = n + 1
  end

  settings.profiles[name] = CopyTable(source)
  RS:UseProfile(name)

  local menu = RS.MainFrame or mainFrameModule:CreateMenu()
  menu:Show()
  RS:Update()
  RS:UpdateProfileWidgets()

  local box = RS.MainFrame and RS.MainFrame.profileRenameBox
  if box then
    box:SetFocus()
    box:HighlightText()
  end
end

--[[
  CHANGE PROFILE
]]
function RS:ChangeProfile(newProfile)
  if newProfile == nil or newProfile == "" then
    return
  end
  RS:UseProfile(newProfile)

  RS:UpdateProfileWidgets()
  RS:Update()

  if bankModule.bankIsOpen then
    eventsModule.OnBankOpen(true)
  end

  if merchantModule.merchantIsOpen then
    eventsModule.OnMerchantShow()
  end
end

--[[
  COPY PROFILE
]]
---@param profileToCopy string
function RS:CopyProfile(profileToCopy)
  local settings = restockerModule.settings

  if profileToCopy == nil or settings.profiles[profileToCopy] == nil then
    return
  end

  local copyProfile = CopyTable(settings.profiles[profileToCopy])
  settings.profiles[settings.currentProfile] = copyProfile

  -- The copy replaced this list's contents wholesale, so the "New" notes no
  -- longer describe anything in it -- and no UseProfile runs to clear them.
  RS.ClearNewItems()
  RS:Update()
end

-- Bump this when the saved data layout changes. v5 = profiles keyed by itemID, each
-- item saved on ONE line as a compact string "type, name, amount, stash, fromBank,
-- buy [, reaction]" (1/0 for booleans). The itemID lives only in the table key;
-- itemLink is never stored (rebuilt from itemID). Older lines without the type, or
-- with a repeated id, are still read correctly and rewritten in the new form on save.
local RS_DATA_VERSION = 5

---Strip a saved item down to the clean format and keep its itemID synced to its key.
---Drops the bulky itemLink (we can always rebuild it from the itemID).
---@param item RsTradeCommand
---@param itemID number
local function rsCleanItem(item, itemID)
  item.itemID = itemID
  item.itemLink = nil
  return item
end

-- ----------------------------------------------------------------------------
-- One-line saved format. Each item is stored as a single comma-separated string
-- so the SavedVariables file has exactly one physical line per item (a real Lua
-- table would be expanded across many lines by WoW's serializer).
-- Field order: itemType, itemName, amount, stashTobank, restockFromBank,
--              buyFromMerchant, reaction, upgrade.  Booleans are 1 / 0.
-- reaction and upgrade are always written, where reaction alone used to be
-- written only when set. Reading stayed backward compatible without a version
-- bump because the parser already treats a missing trailing field as absent:
-- an old line with no reaction reads reaction 0 and upgrade nil, and nil is
-- the "on" default.
-- itemType is the human-readable class from GetItemInfo (e.g. "Consumable",
-- "Quest", "Trade Goods") and leads so the file sorts into groups. It is purely a
-- convenience label (re-derived from the itemID); only the name is used at runtime.
-- The itemID is NOT stored -- the table key IS the itemID (single source of truth).
-- Neither itemType nor itemName may contain a comma (no WoW values do).
-- ----------------------------------------------------------------------------

---Resolve an item's human-readable type, preferring the live game data and falling
---back to whatever was saved (so it survives even when the item isn't cached yet).
---@param item RsTradeCommand
---@return string|nil
local function rsItemType(item)
  local info = RS.GetItemInfo(item.itemID)
  if info and info.itemType and info.itemType ~= "" then
    return info.itemType
  end
  return item.itemType
end

---@param item RsTradeCommand
---@return string
local function rsItemToString(item)
  local parts = {}
  local itemType = rsItemType(item)
  if itemType and itemType ~= "" then
    parts[#parts + 1] = itemType
  end
  parts[#parts + 1] = item.itemName or ""
  parts[#parts + 1] = item.amount or 0
  parts[#parts + 1] = item.stashTobank and 1 or 0
  parts[#parts + 1] = item.restockFromBank and 1 or 0
  -- buyFromMerchant defaults to true (nil), so only false is "off"
  parts[#parts + 1] = (item.buyFromMerchant == false) and 0 or 1
  --[[
    Both trailing fields go out every time now. Writing reaction only when set
    worked while it was last, but upgrade sits behind it, and an optional field
    in the middle would shift the one after it.
  ]]
  parts[#parts + 1] = (item.reaction and item.reaction > 0) and item.reaction or 0
  -- upgrade defaults to true (nil), so only false is "off"
  parts[#parts + 1] = (item.upgrade == false) and 0 or 1
  return table.concat(parts, ", ")
end

---@param s string The saved one-line string
---@param key number|string The table key (authoritative itemID)
---@return RsTradeCommand
local function rsItemFromString(s, key)
  local itemID = tonumber(key)
  local f = {}
  for _, part in ipairs({ strsplit(",", s) }) do
    f[#f + 1] = strtrim(part)
  end

  -- The label (type and/or name) is the leading run of non-numeric fields; the
  -- numeric data (amount, flags, [reaction]) follows. This makes the parser tolerant
  -- of every format we've used: "type, name, ...", "name, ...", and the old
  -- "name, id, ..." (the repeated id is handled just below).
  local dataStart
  for j = 1, #f do
    if tonumber(f[j]) ~= nil then dataStart = j; break end
  end
  dataStart = dataStart or (#f + 1)
  local labelEnd = dataStart - 1

  local amount = tonumber(f[dataStart]) or 0
  local stash = tonumber(f[dataStart + 1])
  local fromBank = tonumber(f[dataStart + 2])
  local buy = tonumber(f[dataStart + 3])
  local rxn = tonumber(f[dataStart + 4]) or 0
  local upg = tonumber(f[dataStart + 5])

  -- Name is the last label field; an optional type leads it.
  local itemName = (labelEnd >= 1) and f[labelEnd] or ""
  local itemType = (labelEnd >= 2) and f[1] or nil

  -- buyFromMerchant defaults to true (stored as nil); only an explicit 0 means off.
  -- Note: don't fold this into "x and false or nil" -- false is falsy in Lua, so that
  -- idiom would always yield nil and we could never store the "off" state.
  local buyFromMerchant = nil
  if buy == 0 then
    buyFromMerchant = false
  end

  return --[[---@type RsTradeCommand]] {
    itemName = itemName,
    itemType = itemType,
    itemID = itemID,
    amount = amount,
    stashTobank = (stash == 1) or nil,
    restockFromBank = (fromBank == 1) or nil,
    buyFromMerchant = buyFromMerchant,
    reaction = rxn > 0 and rxn or nil,
    -- Same nil-is-on rule as buyFromMerchant; only an explicit 0 means off.
    upgrade = (upg == 0) and false or nil,
  }
end

---Convert every saved item to its in-memory table form (called on login). Tolerates
---tables left behind by a crash/reload and hand-edited entries; keeps itemID synced
---to the table key and drops any stale itemLink. Idempotent.
---@param db RsSettings
local function rsInflate(db)
  for _, profile in pairs(db.profiles or {}) do
    for key, item in pairs(--[[---@not nil]] profile) do
      if type(item) == "string" then
        local inflated = rsItemFromString(item, key)
        -- Best-effort: refresh name/type from the item cache when it's known
        local info = RS.GetItemInfo(inflated.itemID)
        if info then
          if inflated.itemName == "" then inflated.itemName = info.itemName end
          if info.itemType and info.itemType ~= "" then inflated.itemType = info.itemType end
        end
        profile[key] = inflated
      elseif type(item) == "table" then
        rsCleanItem( --[[---@type RsTradeCommand]] item, tonumber(key) or item.itemID)
      end
    end
  end
end

---Convert every in-memory item table to its one-line saved string (called on logout
---so WoW writes the compact format to disk). Idempotent.
---@param db RsSettings
local function rsDeflate(db)
  for _, profile in pairs(db.profiles or {}) do
    for key, item in pairs(--[[---@not nil]] profile) do
      if type(item) == "table" then
        profile[key] = rsItemToString( --[[---@type RsTradeCommand]] item)
      end
    end
  end
end

---Remove empty profiles that no character points at or owns (e.g. a leftover
---"default" from an older version). Both sides of profileKeys are kept: the
---profile a character POINTS AT (the value) and that character's own eponymous
---list (the key) — so switching away from your own list never deletes the list
---you would switch back to.
---@param db RsSettings
local function rsPruneEmptyOrphans(db)
  local keep = {}
  for charKey, name in pairs(db.profileKeys or {}) do
    keep[name] = true
    keep[charKey] = true
  end
  if db.currentProfile then
    keep[db.currentProfile] = true
  end
  for name, profile in pairs(db.profiles or {}) do
    if not keep[name] and next( --[[---@not nil]] profile) == nil then
      db.profiles[name] = nil
    end
  end
end

---Pack all in-memory item tables back into the one-line saved strings. Called from
---eventsModule.OnLogout right before WoW writes the SavedVariables file. Exposed as a
---method so the events module (which can't see the file-local rsDeflate) can call it.
function RS:DeflateForSave()
  rsDeflate(restockerModule.settings)
end

---Stable per-character identity used to pick that character's own list.
---@return string "Name-Realm" (realm spaces stripped), or just "Name" if no realm
function RS:GetCharKey()
  local name = UnitName("player") or "Unknown"
  local realm = GetRealmName() or ""
  realm = ( --[[---@not nil]] realm:gsub("%s+", ""))
  if realm ~= "" then
    return name .. "-" .. realm
  end
  return name
end

---Switch the active profile AND remember the choice for THIS character, so each
---character returns to its own list next login. Use this instead of writing
---settings.currentProfile directly.
---@param name string
function RS:UseProfile(name)
  if name == nil or name == "" then
    return
  end
  -- Any profile event stales the "New" group, and every one of them --
  -- create, switch, clone, delete-with-fallback, login init -- passes
  -- through here. (A rename lands here too and clears; a note about "what
  -- I just added" does not outrank keeping this the single choke point.)
  RS.ClearNewItems()
  local settings = restockerModule.settings
  settings.currentProfile = name
  settings.profileKeys = settings.profileKeys or {}
  settings.profileKeys[RS:GetCharKey()] = name
end

---Pick the profile this character should use on login (its remembered choice, or a
---fresh profile named after the character), creating it if missing.
function RS:InitCharacterProfile()
  local settings = restockerModule.settings
  settings.profiles = settings.profiles or --[[---@type RsProfileCollection]] {}
  settings.profileKeys = settings.profileKeys or {}

  local charKey = RS:GetCharKey()
  local profileName = settings.profileKeys[charKey] or charKey

  -- Every character always has its own eponymous list to come back to, even
  -- while it points at another profile (also restores lists lost to the
  -- pre-fix orphan pruning).
  settings.profiles[charKey] = settings.profiles[charKey] or {}
  settings.profiles[profileName] = settings.profiles[profileName] or {}
  RS:UseProfile(profileName)
end

function RS:loadSettings()
  local settings = restockerModule.settings
  settings.profiles = settings.profiles or --[[---@type RsProfileCollection]] {}

  -- currentProfile is chosen per-character in InitCharacterProfile (called right
  -- after loadSettings), so we no longer force a shared "default" profile here.
  settings.framePos = settings.framePos or {}
  settings.autoOpenAtBank = settings.autoOpenAtBank or false
  settings.autoOpenAtMerchant = settings.autoOpenAtMerchant or false

  --[[
    The `or false` idiom above cannot express a default of true -- it would
    rewrite a deliberate false on every login -- so the town reminders test for
    nil instead. All three ship on: the reminder is the feature, and a reminder
    nobody configured should still tell them what they are short of and make a
    noise about it.

    Only an unset value is filled in, so a player who turned one off keeps it
    off through every future login.
  ]]
  if settings.restockReminderChat == nil then
    settings.restockReminderChat = true
  end
  if settings.restockReminderSound == nil then
    settings.restockReminderSound = true
  end
  if settings.merchantReminder == nil then
    settings.merchantReminder = true
  end
  if settings.bankReminder == nil then
    settings.bankReminder = true
  end

  --[[
    In town you are away from your bags and the detail is the whole point, so
    that one defaults to the full list. At a merchant or a bank you are already
    looking at the window that can fix it, so those two default to the count
    alone and stay out of the way.
  ]]
  settings.restockReminderMode = settings.restockReminderMode or RS.REMINDER_VERBOSE
  settings.merchantReminderMode = settings.merchantReminderMode or RS.REMINDER_SIMPLE
  settings.bankReminderMode = settings.bankReminderMode or RS.REMINDER_SIMPLE
end

--[[
  REGISTER SLASH COMMANDS
]]
function RS:RegisterSlashCommands()
  SLASH_CONNOISSEURRESTOCKER1 = "/crs"
  SlashCmdList.CONNOISSEURRESTOCKER = function(msg)
    RS:SlashCommand(msg)
  end
end

---Print a debug message, but only when debug messages are enabled. Accepts an optional
---printf-style format plus args, so the (potentially expensive) string is only built
---when debugging is actually on -- prefer RS:Debug("x=%s", v) over RS:Debug("x="..v).
---@param fmt string
function RS:Debug(fmt, ...)
  if not restockerModule.settings.debugMessages then
    return
  end
  local msg = fmt
  if select("#", ...) > 0 then
    msg = string.format(fmt, ...)
  end
  ns.PrintMessage(tostring(msg))
end

RS.ICON_FORMAT = "|T%s:0:0:0:0:64:64:4:60:4:60|t"

---Creates a string which will display a picture in a FontString
---@param texture string - path to UI texture file (for example can come from
---  GetContainerItemInfo(bag, slot) or spell info etc
function RS.FormatTexture(texture)
  return string.format(RS.ICON_FORMAT, texture)
end

--[[
  TOOLTIPS

  Every explanatory tooltip in the Restocker window routes through here, so the
  colors, the spacing, and the wrap all live in one place.

  Shape: a gold title, then white body lines with a blank line before each, so
  a multi-line tooltip reads as paragraphs instead of one wall. Same spacing
  idiom as AddSpacedLines in Minimap-Button.lua. Single-body tooltips are
  unaffected -- they get the one spacer under the title either way.

  Colors are passed explicitly rather than left to default, because the two
  defaults disagree -- SetText falls back to gold and AddLine to white -- which
  is how titles ended up white and body text gold. Callers pass plain strings
  now; no |cff escapes.

  The trailing `true` on each line is the textWrap argument. Without it a
  tooltip is exactly as wide as its longest line, and the longer strings here
  (the reputation control's discount line especially) rendered a tooltip wider
  than the game window. With it the client breaks each line at its standard
  tooltip width -- which is also why we do not hand-measure a pixel budget: the
  client's own break points are correct in locales that don't put spaces
  between words.

  A one-argument call is a whole tooltip in one line, and renders as the title.
]]
local TOOLTIP_TITLE_R, TOOLTIP_TITLE_G, TOOLTIP_TITLE_B = 1, 0.82, 0 -- gold
local TOOLTIP_BODY_R, TOOLTIP_BODY_G, TOOLTIP_BODY_B = 1, 1, 1       -- white

---@param control WowControl
---@param title string
---@param ... string Body lines, each shown on its own line under the title
function RS.SetupTooltip(control, title, ...)
  local body = { ... }
  control:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:SetText(title, TOOLTIP_TITLE_R, TOOLTIP_TITLE_G, TOOLTIP_TITLE_B, 1, true)
    for i = 1, #body do
      GameTooltip:AddLine(" ") -- blank line under the title, then between each pair
      GameTooltip:AddLine(body[i], TOOLTIP_BODY_R, TOOLTIP_BODY_G, TOOLTIP_BODY_B, true)
    end
    GameTooltip:Show()
  end)
  control:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
end

---AceAddon handler
function RS:OnInitialize()
  -- do init tasks here, like loading the Saved Variables,
  -- or setting up slash commands.
  self.loaded = false
  envModule:DetectVersions()
end

---AceAddon handler
function RS:OnEnable()
  -- Saved variables are stored account-wide in ConnoisseurRestockerDB, in the same
  -- layout standalone Restocker kept in RestockerDB: profiles keyed by itemID,
  -- without itemLink. Each character keeps its own list (profile named after the
  -- character), so all characters share one file but Warrior and Priest see
  -- separate lists.
  ConnoisseurRestockerDB = ConnoisseurRestockerDB or --[[---@type RsSettings]] {}

  if ConnoisseurRestockerDB.dataVersion == nil then
    ConnoisseurRestockerDB.profiles = ConnoisseurRestockerDB.profiles or {}
    ConnoisseurRestockerDB.dataVersion = RS_DATA_VERSION
  end
  ConnoisseurRestockerDB.profileKeys = ConnoisseurRestockerDB.profileKeys or {}

  restockerModule.settings = ConnoisseurRestockerDB

  self.framepool = --[[---@type RsRestockingListRow[] ]] {}
  self.headerpool = --[[---@type RsControl[] ]] {} -- section-header rows (sort by type)
  self.hiddenFrame = CreateFrame("Frame", nil, --[[---@type WowControl]] UIParent)
  self.hiddenFrame:Hide()
  self:loadSettings()

  -- Unpack the one-line string entries into in-memory tables (and tolerate any tables
  -- left by a crash or pasted in by hand). Item links are rebuilt from the itemID.
  rsInflate(restockerModule.settings)

  -- Select this character's own list (creating it if this is a fresh character)
  self:InitCharacterProfile()

  -- Drop leftover empty orphan profiles (e.g. an old shared "default")
  rsPruneEmptyOrphans(restockerModule.settings)
  -- (Re-packing into the one-line form happens in eventsModule.OnLogout, which calls
  --  RS:DeflateForSave just before WoW writes the SavedVariables file.)

  RS:RegisterSlashCommands()

  eventsModule:InitEvents()

  CrsModule:CallInEachModule("OnModuleInit", nil)

  if not RS.MainFrame then
    mainFrameModule:CreateMenu()
  end -- setup the UI

  RS.loaded = true
end

-- AceAddon-3.0 replacement: OnInitialize/OnEnable used to be Ace lifecycle handlers.
-- Run them at PLAYER_LOGIN, by which point SavedVariables and every Restocker file
-- (this loads early in the Restocker block) are in place.
local rsLoginFrame = CreateFrame("Frame")
rsLoginFrame:RegisterEvent("PLAYER_LOGIN")
rsLoginFrame:SetScript("OnEvent", function(frame)
  frame:UnregisterEvent("PLAYER_LOGIN")
  RS:OnInitialize()
  RS:OnEnable()
end)
