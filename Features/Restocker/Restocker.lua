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

RS.BAG_ICON = "Interface\\ICONS\\INV_Misc_Bag_10_Green" -- bag icon for add tooltip

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
  config = rsSlashHelpLine("/crs config", L["OPTIONS_COMMANDS_FOODIE_DETAIL"]),
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

  -- Position each entry by absolute row index so headers and items can interleave
  local scrollChild = RS.MainFrame.scrollChild
  for i, entry in ipairs(renderList) do
    local y = -(i - 1) * RS.ROW_HEIGHT
    local f = entry.header and self:GetHeaderRow() or self:GetFirstEmpty(entry.item)
    f.isInUse = true
    f:SetParent(scrollChild)
    f:ClearAllPoints()
    f:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, y)
    f:SetSize(scrollChild:GetWidth(), RS.ROW_HEIGHT)
    if entry.header then
      f.text:SetText(entry.header)
    else
      self:UpdateRestockListRow(f, entry.item)
    end
    f:Show()
  end

  scrollChild:SetHeight(math.max(1, #renderList) * RS.ROW_HEIGHT)
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
--              buyFromMerchant [, reaction].  Booleans are 1 (true) / 0 (false).
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
  if item.reaction and item.reaction > 0 then
    parts[#parts + 1] = item.reaction
  end
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

  -- MIGRATION (remove after 2026-08-15): pre-v5 saved-line tolerance; drop this
  -- repeated-id skip when the import blocks above go.
  -- Legacy form repeated the id right after the name ("name, id, amount, +3 flags").
  -- Detect it (first numeric equals this item's id, with enough trailing fields) and
  -- skip it. The >=4 guard distinguishes it from an amount that happens to equal the id.
  if tonumber(f[dataStart]) == itemID and (#f - dataStart) >= 4 then
    dataStart = dataStart + 1
  end

  local amount = tonumber(f[dataStart]) or 0
  local stash = tonumber(f[dataStart + 1])
  local fromBank = tonumber(f[dataStart + 2])
  local buy = tonumber(f[dataStart + 3])
  local rxn = tonumber(f[dataStart + 4]) or 0

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

-- MIGRATION (remove after 2026-08-15): delete this function together with its call
-- site in RS:OnEnable and the RsSettings.migratedToAccount field annotation in
-- RestockerClass.lua.
---One-time import of a character's old per-character data (RestockerSettings, a v1
---array-of-items layout) into the account-wide DB. Each profile is converted from an
---array into a table keyed by itemID and stored under a name that is namespaced to
---this character, so different characters keep separate lists in the shared file:
---  old "default"  -> "<charKey>"            (the character's main list)
---  old "raid" etc -> "<charKey> - raid"     (extra named profiles, kept distinct)
---The character is then pointed (via profileKeys) at the imported version of whatever
---profile it was using. Existing account entries win, so re-running is harmless.
---@param legacy RsSettings|nil The old per-character saved table
---@param db RsSettings The account-wide saved table
---@param charKey string This character's "Name-Realm" key
local function rsImportLegacyPerChar(legacy, db, charKey)
  if type(legacy) ~= "table" then
    return
  end

  db.profiles = db.profiles or {}
  db.profileKeys = db.profileKeys or {}

  -- Adopt shared scalar settings from the first character that migrates
  if db.framePos == nil then db.framePos = legacy.framePos end
  if db.autoOpenAtBank == nil then db.autoOpenAtBank = legacy.autoOpenAtBank end
  if db.autoOpenAtMerchant == nil then db.autoOpenAtMerchant = legacy.autoOpenAtMerchant end

  -- Map an old profile name to this character's namespaced name
  local function targetName(oldName)
    if oldName == nil or oldName == "default" then
      return charKey
    end
    return charKey .. " - " .. oldName
  end

  for name, oldProfile in pairs(legacy.profiles or {}) do
    local target = targetName(name)
    local dst = db.profiles[target] or {}
    -- Old profiles are arrays, so ipairs walks every saved item
    for _, item in ipairs(--[[---@not nil]] oldProfile) do
      local id = tonumber(item.itemID)
      if id and dst[id] == nil then
        dst[id] = rsCleanItem(CopyTable(item), id)
      end
    end
    db.profiles[target] = dst
  end

  -- Default this character to the imported version of its previously active profile
  if db.profileKeys[charKey] == nil then
    db.profileKeys[charKey] = targetName(legacy.currentProfile)
  end
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

  -- MIGRATION (remove after 2026-08-15): delete this whole adoption block; it copies
  -- the standalone Restocker add-on's RestockerDB into ConnoisseurRestockerDB.
  -- One-time adoption: a player who ran standalone Restocker gets their lists copied
  -- in the first time this loads (only while Connoisseur's own DB is still empty).
  if next(ConnoisseurRestockerDB) == nil and type(RestockerDB) == "table" then
    ConnoisseurRestockerDB = CopyTable(RestockerDB)
    ns.PrintMessage(L["RESTOCKER_IMPORTED_LISTS"])
  end

  if ConnoisseurRestockerDB.dataVersion == nil then
    ConnoisseurRestockerDB.profiles = ConnoisseurRestockerDB.profiles or {}
    ConnoisseurRestockerDB.dataVersion = RS_DATA_VERSION
  end
  ConnoisseurRestockerDB.profileKeys = ConnoisseurRestockerDB.profileKeys or {}

  -- MIGRATION (remove after 2026-08-15): delete this block (and rsImportLegacyPerChar
  -- above, plus the migratedToAccount annotation in RestockerClass.lua).
  -- One-time per-character import: fold this character's old per-character list into
  -- its own profile in the account-wide DB the first time it logs in after the update.
  if RestockerSettings and not RestockerSettings.migratedToAccount then
    rsImportLegacyPerChar( --[[---@type RsSettings]] RestockerSettings, ConnoisseurRestockerDB, self:GetCharKey())
    RestockerSettings.migratedToAccount = true
  end

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

function restockerModule:Color(hex, text)
  return "|cff" .. hex .. text .. "|r"
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
