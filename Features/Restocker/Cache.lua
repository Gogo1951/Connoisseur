local RS = CRS_ADDON ---@type RestockerAddon

---@class GIICacheItem
---@field itemId number
---@field itemName string
---@field itemLink string Printable colored clickable item link
---@field itemRarity number 0=poor, 1=normal, 2=uncommon, 3=rare ... etc
---@field itemLevel number
---@field itemMinLevel number
---@field itemType string One of "Armor", "Consumable", "Container", ... see Wiki "ItemType"
---@field itemSubType string Same as itemType
---@field itemStackCount number
---@field itemEquipLoc string "" or a constant INVTYPE_HEAD for example
---@field itemTexture string|number Texture or icon id
---@field itemSellPrice number Copper price for the item

---Stores arg to results mapping for GetItemInfo
local getItemInfoCache = --[[---@type {[number|string]: GIICacheItem}]] {}

---Calls GetItemInfo and saves the results, or not (if nil was returned)
---@param arg number|string
---@return GIICacheItem|nil
function RS.GetItemInfo(arg)
  if getItemInfoCache[arg] ~= nil then
    return getItemInfoCache[arg]
  end

  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType
  , itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(arg)
  if itemName == nil then
    return nil
  end

  local cacheItem = --[[---@type GIICacheItem]] {
    itemId = tonumber(--[[---@not nil]] string.match(itemLink, "item:(%d+)")),
    itemName = itemName,
    itemLink = itemLink,
    itemRarity = itemRarity,
    itemLevel = itemLevel,
    itemMinLevel = itemMinLevel,
    itemType = itemType,
    itemSubType = itemSubType,
    itemStackCount = itemStackCount,
    itemEquipLoc = itemEquipLoc,
    itemTexture = itemTexture,
    itemSellPrice = itemSellPrice
  }
  getItemInfoCache[arg] = cacheItem
  return cacheItem
end

--[[
  A printable, hoverable, shift-clickable link for an item, always.

  GetItemInfo returns nothing until the client has resolved an item, and on a
  fresh login that is exactly when the Restocker wants to name things -- so
  falling back to a bare name meant the reminder printed plain text most of the
  time. A link built by hand from the id works the moment it is printed: the
  client resolves |Hitem:| on hover, so the tooltip is correct even while the
  cache behind it is still cold.

  The colour on the hand-built form is white rather than the item's quality
  colour, which is the one thing that cannot be known without the cache. The
  cached link is preferred whenever it exists, and it carries the real colour.
]]
---@param itemID number|nil
---@param fallbackName string|nil Stored name, used while the cache is cold
---@return string
function RS.GetItemLink(itemID, fallbackName)
  local info = itemID and RS.GetItemInfo(itemID) or nil
  if info and info.itemLink then
    return info.itemLink
  end

  if itemID then
    local label = (fallbackName and fallbackName ~= "") and fallbackName or ("item:" .. itemID)
    return "|cffffffff|Hitem:" .. itemID .. "|h[" .. label .. "]|h|r"
  end

  return fallbackName or "?"
end
