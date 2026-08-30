local _, ns = ...

--------------------------------------------------------------------------------
-- Recipe Resolution
--------------------------------------------------------------------------------

--[[
    The craftable items the Restock List buys reagents for, keyed by the crafted
    item's LOCALIZED name. That key is not a convenience: it is what the merchant's
    own item names arrive as, and what BuildCraftingPurchaseOrder matches list rows
    against, so a recipe is only usable once the client has named it.

    Recipe rows live in Data/Poison-Recipes.lua.
]]
local buyIngredients = {}

--[[
    Recipes whose item data had not resolved when they were set up. Read by the
    GET_ITEM_INFO_RECEIVED handler, which is the answer to that miss arriving.
]]
ns.pendingRecipes = {}

--[[
    A recipe needs the localized name of its crafted item AND of every reagent, and
    GetItemInfo answers nil for anything the client has not cached yet -- the normal
    state during a login. A recipe missing any of those names is parked whole and
    retried when the answer arrives; adding it half-named would order reagents
    under a name nothing ever matches.
]]
local function AddRecipe(recipe)
	local function Postpone()
		ns.pendingRecipes[recipe.itemID] = recipe
		ns.SyncRestockItemInfoSubscription()
	end

	local crafted = ns.GetItemData(recipe.itemID)
	if not crafted then
		Postpone()
		return
	end

	for _, reagent in ipairs(recipe.reagents) do
		local info = ns.GetItemData(reagent.itemID)
		if not info then
			Postpone()
			return
		end
		reagent.localizedName = info.itemName
	end

	buyIngredients[crafted.itemName] = recipe
	ns.pendingRecipes[recipe.itemID] = nil
end

function ns.RetryWaitingRecipes()
	for _, recipe in pairs(ns.pendingRecipes) do
		AddRecipe(recipe)
	end
end

--------------------------------------------------------------------------------
-- Known Recipes
--------------------------------------------------------------------------------

--[[
    Turn the data rows into the runtime shape. Rows flagged for another client are
    skipped here rather than filtered downstream, so nothing past this point has to
    know a recipe can be flavor-specific.

    Called at login and again at every merchant. The guard is on buyIngredients
    rather than on a "did we run" flag on purpose: a login where the client had
    named nothing yet leaves it empty, and the merchant call is then the second
    chance to build the table. Once anything is in it, RetryWaitingRecipes owns
    the rest.
]]
function ns.SetupCraftingRecipes()
	if next(buyIngredients) then
		return
	end

	for _, row in ipairs(ns.PoisonRecipes or {}) do
		local expansion = row[3]
		if expansion == nil or expansion == ns.CURRENT_EXPANSION then
			local reagents = {}
			for _, reagent in ipairs(row[2]) do
				reagents[#reagents + 1] = { itemID = reagent[1], count = reagent[2] }
			end
			AddRecipe({ itemID = row[1], reagents = reagents })
		end
	end
end

--------------------------------------------------------------------------------
-- Reagent Purchases
--------------------------------------------------------------------------------

function ns.BuildCraftingPurchaseOrder()
	local purchaseOrder = {}
	local settings = ns.restockSettings

	local profile = settings.profiles[settings.currentProfile]

	for _, item in pairs(profile) do
		local recipe = buyIngredients[item.itemName]
		if recipe ~= nil then
			--[[
			    Bags only, matching BuildPurchaseOrder and BuildGroceryList. Bank stock
			    deliberately does not count: you are standing at a vendor, and the
			    tradeskill can only consume what is in your bags, so poisons sitting in
			    the bank must not cancel reagents for crafts you still have to make.

			    Counting it was self-defeating as well. That bank pile is one this addon
			    creates -- Restocker-Bank.lua stashes everything above `amount` -- so a full run
			    would bank the excess and then refuse to buy reagents for it. It also
			    made the same vendor visit buy different amounts depending on whether
			    the bank had been opened that session, which is when the client learns
			    bank contents.

			    The old gate that rode along with the bank count is gone with it: any
			    shortfall is worth buying for. It raised the threshold to half the
			    target whenever anything sat in the bank, so wanting 40 with 21 banked
			    was 19 short against a floor of 20 and silently bought nothing.
			]]
			local haveCrafted = GetItemCount(item.itemID, false, false) or 0
			local craftedMissing = (item.amount or 0) - haveCrafted

			if craftedMissing > 0 then
				for _, reagent in ipairs(recipe.reagents) do
					local amountToGet = reagent.count * craftedMissing
					local name = reagent.localizedName
					purchaseOrder[name] = (purchaseOrder[name] or 0) + amountToGet
				end
			end
		end
	end

	--[[
	    Reagents already in the bags come off the order. The floor matters because
	    these numbers do not stay in this table: Restock() folds them into
	    purchaseOrders alongside the merchant restock amounts, keyed by the same
	    localized name. A surplus of vials left a negative here, and a negative
	    added to a vial line the player actually asked for would quietly shrink it.

	    Keyed by the reagent's localized name rather than its itemID, because that
	    is what GetMerchantItemInfo reports and what the merchant restock merges
	    these lines against. The count has to use the same key, so this is the one
	    shortfall in the add-on that cannot be counted by ID.
	]]
	for reagent, _ in pairs(purchaseOrder) do
		local inBags = GetItemCount(reagent, false) or 0
		if inBags > 0 then
			local remaining = purchaseOrder[reagent] - inBags
			purchaseOrder[reagent] = remaining > 0 and remaining or 0
		end
	end

	return purchaseOrder
end
