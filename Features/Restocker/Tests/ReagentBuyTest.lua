-- Headless test for the crafting-reagent purchase order (no WoW API needed).
--
-- Run it with:   lua Tests/ReagentBuyTest.lua
--
-- It models the SAME two steps the live addon uses:
--   * BuyIngredients.lua CraftingPurchaseOrder -- how many reagents the shortfall needs
--   * Merchant.lua PurchaseMerchantItem       -- how many of those a vendor slot delivers
--
-- The reported bug lives in the first: 40 Instant Poison VI wanted, 18 sitting in the
-- BANK, and the order came out at 22 crafts (22 Crystal Vial, 88 Dust of Deterioration)
-- because the shortfall counted bank stock -- which a tradeskill at a vendor cannot reach.
-- The half-target gate in the same block was worse: it bought NOTHING, silently, whenever
-- anything was banked and the shortfall was under half the target.
--
-- The second is independent and hits the same reagents: BuyMerchantItem will not sell more
-- than one stack per call, and the limited-stock branch passed the vendor's whole count in
-- a single call, so a poison supplier holding several stacks sold nothing while the addon
-- reported the order filled.

-- Classic Instant Poison VI: 4x Dust of Deterioration + 1x Crystal Vial (BuyIngredients.lua).
local RECIPE = { { name = "Dust of Deterioration", count = 4 }, { name = "Crystal Vial", count = 1 } }

local pass = 0

--[[
  CraftingPurchaseOrder, as shipped after the fix: bags only, no threshold, reagents
  already held come off the order and never go negative.
]]
---@param wanted number Profile amount for the crafted item
---@param inBags number Crafted items in BAGS
---@param inBank number Crafted items in the BANK (must not affect the result)
---@param reagentsInBags table<string, number>
local function craftingPurchaseOrder(wanted, inBags, inBank, reagentsInBags)
  local order = {}
  local missing = wanted - inBags -- inBank is deliberately unused
  if missing > 0 then
    for _, ing in ipairs(RECIPE) do
      order[ing.name] = (order[ing.name] or 0) + ing.count * missing
    end
  end
  for reagent in pairs(order) do
    local have = (reagentsInBags or {})[reagent] or 0
    if have > 0 then
      local remaining = order[reagent] - have
      order[reagent] = remaining > 0 and remaining or 0
    end
  end
  return order
end

---@param label string
local function orderScenario(label, wanted, inBags, inBank, reagentsInBags, wantDust, wantVial)
  local order = craftingPurchaseOrder(wanted, inBags, inBank, reagentsInBags)
  local dust = order["Dust of Deterioration"] or 0
  local vial = order["Crystal Vial"] or 0
  assert(dust == wantDust, ("%s: dust want %d got %d"):format(label, wantDust, dust))
  assert(vial == wantVial, ("%s: vial want %d got %d"):format(label, wantVial, vial))
  print(("  ok  %-46s -> %3d dust, %3d vial"):format(label, dust, vial))
  pass = pass + 1
end

print("CRAFTING PURCHASE ORDER")
-- THE REPORTED BUG. 40 wanted, none in bags, 18 banked. The old code counted the bank,
-- got a shortfall of 22, and bought 88 dust / 22 vial -- enough to craft 22, not 40.
orderScenario("40 wanted, 0 bags, 18 bank (the report)", 40, 0, 18, nil, 160, 40)
-- Same shortfall, same answer, wherever the bank sits. Bank stock is simply not an input.
orderScenario("40 wanted, 0 bags, 0 bank", 40, 0, 0, nil, 160, 40)
orderScenario("40 wanted, 0 bags, 500 bank", 40, 0, 500, nil, 160, 40)
-- THE SILENT-ZERO CLIFF. Old rule: anything banked raised the floor to half the target,
-- so 19 short of 40 bought nothing at all. Any shortfall is worth buying for now.
orderScenario("40 wanted, 21 bags, 21 bank (under old floor)", 40, 21, 21, nil, 76, 19)
-- Bags DO count -- this is the case that always worked, and must keep working.
orderScenario("40 wanted, 18 bags, 0 bank", 40, 18, 0, nil, 88, 22)
-- Fully stocked in bags: buy nothing.
orderScenario("40 wanted, 40 bags", 40, 40, 0, nil, 0, 0)
orderScenario("40 wanted, 55 bags (over target)", 40, 55, 0, nil, 0, 0)
-- Reagents already held come off the order.
orderScenario("40 wanted, 0 bags, 60 dust held", 40, 0, 0, { ["Dust of Deterioration"] = 60 }, 100, 40)
-- A reagent SURPLUS floors at zero. It must never go negative: Restock() folds these
-- numbers into purchaseOrders under the same localized name as a merchant restock line,
-- where a negative would quietly shrink an order the player actually asked for.
orderScenario("40 wanted, 400 dust held (surplus)", 40, 0, 0, { ["Dust of Deterioration"] = 400 }, 0, 40)

--[[
  PurchaseMerchantItem, as shipped after the fix: cap to the vendor's stock first, then
  walk the whole order in stackCount chunks. Returns units actually ordered and whether
  that covered the request.
]]
---@param amount number Units on the purchase order
---@param merchantAvailable number Vendor stock; -1 is unlimited, 0 is sold out
---@param stackCount number Item stack size
local function purchaseMerchantItem(amount, merchantAvailable, stackCount)
  local calls = {}
  local unitsOrdered = 0
  if stackCount < 1 then
    stackCount = 1
  end

  local wanted = amount
  if merchantAvailable > 0 and wanted > merchantAvailable then
    wanted = merchantAvailable
  end

  for n = wanted, 1, -stackCount do
    local chunk = (n > stackCount) and stackCount or n
    calls[#calls + 1] = chunk
    unitsOrdered = unitsOrdered + chunk
  end

  if merchantAvailable == 0 then
    unitsOrdered = 0
  end

  return unitsOrdered, unitsOrdered > 0 and unitsOrdered >= amount, calls
end

local function buyScenario(label, amount, avail, stack, wantUnits, wantFilled)
  local units, filled, calls = purchaseMerchantItem(amount, avail, stack)
  assert(units == wantUnits, ("%s: units want %d got %d"):format(label, wantUnits, units))
  assert(filled == wantFilled, ("%s: filled want %s got %s"):format(label, tostring(wantFilled), tostring(filled)))
  -- The invariant the old limited-stock branch broke: no single call may exceed a stack.
  for _, chunk in ipairs(calls) do
    assert(chunk <= stack, ("%s: call of %d exceeds stack %d"):format(label, chunk, stack))
    assert(chunk > 0, label .. ": non-positive call")
  end
  print(("  ok  %-46s -> %3d units in %d calls, filled=%s"):format(label, units, #calls, tostring(filled)))
  pass = pass + 1
end

print("\nMERCHANT PURCHASE")
-- THE STACK BUG. A poison supplier stocking 40 dust against an order of 160 used to make
-- ONE call for 40 -- four stacks in a single buy, which the server refuses -- and still
-- credited 40 units and claimed the order filled.
buyScenario("160 dust, vendor has 40, stacks of 10", 160, 40, 10, 40, false)
-- Unlimited stock (-1) is the common case and is unchanged.
buyScenario("160 dust, unlimited, stacks of 10", 160, -1, 10, 160, true)
-- Limited but sufficient.
buyScenario("40 vial, vendor has 100, stacks of 5", 40, 100, 5, 40, true)
-- Exactly enough.
buyScenario("40 vial, vendor has 40, stacks of 5", 40, 40, 5, 40, true)
-- Sold out buys nothing and claims nothing.
buyScenario("160 dust, sold out", 160, 0, 10, 0, false)
-- Uncached item falls back to single-unit buys.
buyScenario("7 dust, unlimited, uncached stack of 1", 7, -1, 1, 7, true)
-- A zero-amount order (the reagent path can produce one) must never read as filled.
buyScenario("0 dust, unlimited", 0, -1, 10, 0, false)

--[[
  END TO END: the reported case, all the way to units in the bag. 40 wanted, 18 banked,
  nothing held, an unlimited poison supplier. The order must cover 40 crafts, not 22.
]]
print("\nEND TO END")
local order = craftingPurchaseOrder(40, 0, 18, nil)
local dustUnits = purchaseMerchantItem(order["Dust of Deterioration"], -1, 10)
local vialUnits = purchaseMerchantItem(order["Crystal Vial"], -1, 5)
local craftable = math.min(math.floor(dustUnits / 4), math.floor(vialUnits / 1))
assert(craftable == 40, ("end to end: craftable want 40 got %d"):format(craftable))
print(("  ok  bought %d dust + %d vial -> %d crafts (was 22)"):format(dustUnits, vialUnits, craftable))
pass = pass + 1

print(("\nALL %d REAGENT BUY SCENARIOS PASSED"):format(pass))
