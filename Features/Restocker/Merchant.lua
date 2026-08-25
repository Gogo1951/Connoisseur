local _, ns = ... ---@type string, table
local L = ns.L
local RS = CRS_ADDON ---@type RestockerAddon

local restockerModule = CrsModule.restockerModule ---@type RsRestockerModule

---@class RsMerchantModule
---@field merchantIsOpen boolean
---@field lastTimeRestocked number GetTime() of last restock
local merchantModule = CrsModule.merchantModule

merchantModule.merchantIsOpen = false
merchantModule.lastTimeRestocked = GetTime()

local bagModule = CrsModule.bagModule
local buyIngredientsModule = CrsModule.buyIngredientsModule
local buyItemModule = CrsModule.buyCommandModule

---@param theTable table|nil
function merchantModule:CountTableItems(theTable)
  if not theTable then
    return 0
  end

  local count = 0
  for _, _ in pairs(--[[---@not nil]] theTable) do
    count = count + 1
  end
  return count
end

-- NOTE: this addon must NEVER sell at a merchant. Having too many of an item is fine and is
-- left untouched. The old merchantModule:BuildSellOrder (which vendored the excess) has been
-- removed for that reason; only BuildPurchaseOrder (buy when too few) remains.

---@param purchaseOrders RsTradeCommandsByName
---@param eachRestockRecord RsTradeCommand
---@param vendorReaction number
function merchantModule:BuildPurchaseOrder(purchaseOrders, eachRestockRecord, vendorReaction)
  local haveInBag = GetItemCount(eachRestockRecord.itemName, false, false)
  local amount = eachRestockRecord.amount or 0
  local requiredReaction = eachRestockRecord.reaction or 0

  if requiredReaction > vendorReaction then
    -- Deliberately silent: this vendor is below the item's required standing, and
    -- announcing every skipped item at every vendor would flood chat.
  elseif amount > 0 then
    local toBuy = amount - haveInBag

    if toBuy > 0 then
      local purchaseOrder = purchaseOrders[eachRestockRecord.itemName]
      if not purchaseOrder then
        -- add new
        purchaseOrders[eachRestockRecord.itemName] = buyItemModule:Create(
            toBuy, eachRestockRecord.itemName, eachRestockRecord.itemID, eachRestockRecord.itemLink)
      else
        -- update amount, add more
        purchaseOrder.amount = purchaseOrder.amount + toBuy
      end
    end -- if tobuy > 0
  end -- if amount
end

--[[
  GROCERY LIST

  What the current profile is short of right now: the same shortfall
  BuildPurchaseOrder computes, minus the vendor. Used by the mini-map tooltip
  and the entering-town reminder, both of which run while the player is
  standing in the open with no merchant window in sight.

  Two differences from a real purchase order, both because there is no vendor:
  the required-reputation gate is skipped (it depends on which vendor you walk
  up to), and crafting reagents are left out (BuyIngredients resolves those
  against the merchant's stock). So this answers "what am I low on", which is
  what a shopping list is, rather than "what will this vendor sell me".

  Counts are bags only -- GetItemCount(id, false, false) -- matching what the
  merchant restock compares against, so the list agrees with what would
  actually be bought.
]]
---@return table[] Sorted { itemID, itemName, have, wanted, needed }, empty when fully stocked
function RS.BuildGroceryList()
  local settings = restockerModule.settings
  local profile = settings and settings.profiles and settings.profiles[settings.currentProfile]
  local list = {}
  if not profile then
    return list
  end

  for _, record in pairs(profile) do
    local wanted = record.amount or 0
    local key = record.itemID or record.itemName
    -- nil buyFromMerchant defaults to true, the same rule Restock() uses
    if key and wanted > 0 and (record.buyFromMerchant == nil or record.buyFromMerchant) then
      local have = GetItemCount(key, false, false) or 0
      local short = wanted - have
      if short > 0 then
        -- have/wanted ride along for the verbose town reminder, which reports
        -- the ratio rather than the shortfall.
        list[#list + 1] = {
          itemID = record.itemID,
          itemName = record.itemName,
          have = have,
          wanted = wanted,
          needed = short,
        }
      end
    end
  end

  table.sort(list, function(a, b)
    return (a.itemName or "") < (b.itemName or "")
  end)
  return list
end

---@param purchaseOrders RsTradeCommandsByName
---@param ingredientName string Name of ingredient to add to purchaseOrders
---@param toBuy number Requested amount
function merchantModule:UpdatePurchaseOrdersWithCraftingReagents(purchaseOrders, ingredientName, toBuy)
  if not purchaseOrders[ingredientName] then
    purchaseOrders[ingredientName] = buyItemModule:Create(toBuy, ingredientName, nil, nil)
  else
    local purchase = purchaseOrders[ingredientName]
    purchase.amount = purchase.amount + toBuy
  end
end

--[[
  ALL-OR-NOTHING REAGENTS

  Crafting reagents (rogue poison ingredients) are bought only at a vendor
  that stocks EVERY reagent the crafting order still needs. Half a recipe is
  worse than none: a trade-goods vendor that carries Crystal Vials but no
  Dust of Deterioration used to fill the bags with vials that could not
  become poisons until some other vendor supplied the rest. A poison
  supplier carries the full set, so this gate simply keeps the reagent
  buying at poison suppliers.

  "Needs" means an amount still to buy after bags were counted -- a reagent
  the bags already cover is not required of the vendor, so dust-only is fine
  when the vials are in the bags. "Stocks" means the slot is purchasable
  right now: unlimited (-1) or a limited count above zero. A sold-out
  limited slot counts as NOT stocked -- buying the others would strand the
  player exactly the way this rule forbids.

  Quantity coverage is deliberately not required: a limited slot holding 4
  of the 6 dust wanted still crafts 4 poisons, and the chunked buy loop
  already caps to vendor stock. The rule is about missing reagent TYPES.

  This gate covers the crafting order only. An item the player put on the
  Restock List directly (vials included) is their explicit ask and buys
  exactly as before.
]]
---@param craftingPurchaseOrder table<string, number> Localized reagent name to amount still to buy
---@return boolean allStocked Every needed reagent is purchasable at this vendor
---@return boolean anyStocked At least one needed reagent is purchasable at this vendor
function merchantModule:VendorStocksAllReagents(craftingPurchaseOrder)
  local needed = {} ---@type {[string]: boolean}
  local neededCount = 0
  for reagentName, amount in pairs(craftingPurchaseOrder) do
    if amount > 0 then
      needed[reagentName] = true
      neededCount = neededCount + 1
    end
  end

  -- Nothing left to buy: the gate passes and no reagent line is at stake.
  if neededCount == 0 then
    return true, false
  end

  local stockedCount = 0
  for i = 1, GetMerchantNumItems() do
    local itemName, _, _, _, numAvailable = GetMerchantItemInfo(i)
    if itemName and needed[itemName] and (numAvailable == -1 or numAvailable > 0) then
      needed[itemName] = nil -- count each reagent once, however many slots carry it
      stockedCount = stockedCount + 1
      if stockedCount == neededCount then
        return true, true
      end
    end
  end

  return false, stockedCount > 0
end

--[[
  Buys one merchant slot if it is on the purchase order, and returns how many
  UNITS were ordered plus whether that covered the whole order.

  It used to return a count of BuyMerchantItem calls, which is a number no
  player can interpret -- forty juice bought in stacks of twenty reported "2".

  The second return is what the caller turns into "3 restocking orders filled".
  A vendor holding six of a requested twenty leaves that order short, and the
  chat line may not say otherwise, so the claim is decided here rather than
  inferred from a unit count: this is the only place that still knows what the
  order asked for and what the vendor actually had. Bag counts cannot settle it
  either way -- they do not update until BAG_UPDATE, well after this returns.

  Fulfilled orders are flagged rather than removed, so the caller can tell what
  this vendor did not stock without re-reading those bag counts.
]]
---@param i number Merchant item index
---@param purchaseOrders RsTradeCommandsByName
---@return number unitsOrdered
---@return boolean orderFilled Whole requested amount was ordered
function merchantModule:PurchaseMerchantItem(i, purchaseOrders)
  local itemName, _, _, _, merchantAvailable, _, _ = GetMerchantItemInfo(i)
  local itemLink = GetMerchantItemLink(i)

  -- is item from merchant in our purchase order?
  local buyItem = purchaseOrders[itemName]
  local unitsOrdered = 0
  local orderFilled = false

  if buyItem then
    -- Link and cached record are both missing until the client resolves the item, so fall
    -- back to single-unit buys, which BuyMerchantItem accepts for anything.
    local itemInfo = itemLink and RS.GetItemInfo(itemLink) or nil
    local stackCount = itemInfo and itemInfo.itemStackCount or 1
    if stackCount < 1 then
      stackCount = 1
    end

    --[[
      BuyMerchantItem will not sell more than one stack per call, which is what
      the stackCount loop below is for. Capping against the vendor's stock used
      to bypass that loop and pass merchantAvailable through in a single call,
      so a limited slot holding more than one stack -- a poison supplier's
      reagents, exactly the case this path exists for -- had its call rejected
      and still credited the full amount, reporting an order filled that never
      arrived. Capping the target first lets one chunked loop serve both cases.
    ]]
    local wanted = buyItem.amount
    if merchantAvailable > 0 and wanted > merchantAvailable then
      wanted = merchantAvailable
    end

    for n = wanted, 1, -stackCount do
      local chunk = (n > stackCount) and stackCount or n
      BuyMerchantItem(i, chunk)
      unitsOrdered = unitsOrdered + chunk
    end -- forloop

    --[[
      A sold-out slot reports numAvailable 0; unlimited stock reports -1, which is
      why the cap above tests for a POSITIVE count. Neither reading can buy from
      an empty slot -- the loop still runs and the server rejects every call --
      so what it asked for is not what it got, and passing those units up would
      announce a partial fill for a slot that gave us nothing.
    ]]
    if merchantAvailable == 0 then
      unitsOrdered = 0
    end

    -- The > 0 half matters for a zero-amount order, which the crafting-reagent
    -- path can create: nothing bought must never read as an order filled.
    orderFilled = unitsOrdered > 0 and unitsOrdered >= buyItem.amount

    buyItem.purchased = true
  end -- if purchaseOrders[itemName]

  return unitsOrdered, orderFilled
end

---@alias RsTradeCommandsByName {[string]: RsTradeCommand}

function merchantModule:Restock()
  local settings = restockerModule.settings
  if self:CountTableItems(settings.profiles[settings.currentProfile]) == 0 then
    return
  end -- If profile is emtpy then return

  if GetTime() - self.lastTimeRestocked < 1 then
    return
  end -- If vendor reopened within 1 second then return (only activate addon once per second)

  self.lastTimeRestocked = GetTime()

  -- Don't try to buy anything when the bags have no free slot -- the purchase would just
  -- fail with "Inventory is full". (The bank restock already bails on full bags via
  -- CheckBankBagSpace.)
  if not bagModule:CheckSpace(bagModule.PLAYER_BAGS) then
    RS:Print(L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"])
    return
  end

  if settings.autoOpenAtMerchant then
    RS:Show()
  end

  local craftingPurchaseOrder = buyIngredientsModule:CraftingPurchaseOrder() or {}

  --[[
    All-or-nothing (see VendorStocksAllReagents above): a vendor missing any
    needed reagent buys NO reagents. The print fires only when this vendor
    stocked some of them -- the case that used to buy vials on their own --
    and stays silent at vendors that stock none, where a skipped reagent
    order is not news.
  ]]
  local allReagentsStocked, anyReagentStocked = self:VendorStocksAllReagents(craftingPurchaseOrder)
  if not allReagentsStocked then
    if anyReagentStocked then
      RS:Print(L["RESTOCKER_REAGENTS_SKIPPED"])
    end
    craftingPurchaseOrder = {}
  end

  local purchaseOrders = --[[---@type RsTradeCommandsByName]] {}
  local restockList = settings.profiles[settings.currentProfile]
  -- "npc" is the unit we are actually interacting with; the vendor is usually not targeted.
  local vendorReaction = UnitReaction("npc", "player") or UnitReaction("target", "player") or 0

  -- Build the Purchase Orders table used for buying items
  for _, eachRestockRecord in pairs(--[[---@not nil]] restockList) do
    if eachRestockRecord.buyFromMerchant or eachRestockRecord.buyFromMerchant == nil then -- nil defaults to true
      self:BuildPurchaseOrder(purchaseOrders, eachRestockRecord, vendorReaction)
    end
  end

  -- Insert craft reagents for missing items into purchase orders, or add
  for ingredientName, toBuy in pairs(craftingPurchaseOrder) do
    self:UpdatePurchaseOrdersWithCraftingReagents(purchaseOrders, ingredientName, toBuy)
  end

  -- Loop through vendor items
  local ordersFilled = 0
  local ordersPartlyFilled = 0
  for i = 1, GetMerchantNumItems() do
    if not RS.buying then
      return
    end

    local unitsOrdered, orderFilled = self:PurchaseMerchantItem(i, purchaseOrders)
    if orderFilled then
      ordersFilled = ordersFilled + 1
    elseif unitsOrdered > 0 then
      ordersPartlyFilled = ordersPartlyFilled + 1
    end
  end -- for loop GetMerchantNumItems()

  --[[
    Report what happened, and nothing more. Anything this vendor did not stock
    is still outstanding, but the mini-map's Restocker Report already says so --
    the chat line covers the event, the tooltip covers the outstanding state,
    and neither repeats the other.

    Filled and partly filled are counted apart and printed apart, so a mixed run
    needs no combined string and a clean one never mentions partials. Both are
    silent at zero, which keeps a vendor that stocked nothing on our list quiet.
  ]]
  if ordersFilled == 1 then
    RS:Print(L["RESTOCKER_RESTOCKED_ONE"])
  elseif ordersFilled > 1 then
    RS:Print(string.format(L["RESTOCKER_RESTOCKED_MANY"], ordersFilled))
  end

  if ordersPartlyFilled == 1 then
    RS:Print(L["RESTOCKER_RESTOCKED_PARTIAL_ONE"])
  elseif ordersPartlyFilled > 1 then
    RS:Print(string.format(L["RESTOCKER_RESTOCKED_PARTIAL_MANY"], ordersPartlyFilled))
  end
end