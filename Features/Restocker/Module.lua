-- Load order for the Restocker block in Consumable-Connoisseur.toc (originally from
-- the retired standalone Restocker.toc) -- keep the TOC and this list in sync:
--   Module.lua
--   KvEnv.lua
--   Restocker.lua
--   RestockerClass.lua
--   BuyCommand.lua
--   Recipe.lua
--   BuyIngredients.lua
--   Events.lua
--   Settings.lua
--   MainFrame.lua
--   ListFrame.lua
--   Bank.lua
--   Merchant.lua
--   Item.lua
--   Cache.lua
--   Bag.lua
--   Inventory.lua

---@class CrsModuleModule
---@field bagModule RsBagModule
---@field bankModule RsBankModule
---@field buyCommandModule RsBuyCommandModule
---@field buyIngredientsModule RsBuyIngredientsModule
---@field eventsModule RsEventsModule
---@field inventoryModule RsInventoryModule
---@field itemModule RsItemModule
---@field mainFrameModule RsMainFrameModule
---@field merchantModule RsMerchantModule
---@field recipeModule RsRecipeModule
---@field restockerModule RsRestockerModule
---@field settingsModule RsSettingsModule
local rsModule = {
  bagModule = {},
  bankModule = {},
  buyCommandModule = {},
  buyIngredientsModule = {},
  eventsModule = {},
  itemModule = {},
  inventoryModule = {},
  mainFrameModule = {},
  merchantModule = {},
  recipeModule = {},
  restockerModule = {},
  settingsModule = {},
}
CrsModule = rsModule

---For each known module call function by fnName and optional context will be
---passed as 1st argument, can be ignored (defaults to nil)
---module:EarlyModuleInit (called early on startup)
---module:LateModuleInit (called late on startup, after entered world)
function CrsModule:CallInEachModule(fnName, context)
  for _name, module in pairs( --[[---@type table]] rsModule) do
    -- Only interested in table fields, skip functions
    if module and type(module) == "table" and module[fnName] then
      module[fnName](context)
    end
  end
end