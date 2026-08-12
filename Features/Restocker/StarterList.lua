local _, ns = ...
local L = ns.L
local RS = CRS_ADDON ---@type RestockerAddon

local restockerModule = CrsModule.restockerModule ---@type RsRestockerModule

--------------------------------------------------------------------------------
-- Starter Restock List
--------------------------------------------------------------------------------

--[[
    First-run suggestions for the Restock List. A character past level 5 who
    logs in with nothing on their list gets a small window of staples
    (Options/Options-Starter-List-Popup.lua): tick one and the best tier for
    the character's level goes on the list with the same everything-on
    defaults as a hand-added item. From there the normal machinery owns it --
    merchants top it up, and Upgrade.lua walks it up its ladder on level-up.

    Every offering -- foods, water, ammo, poisons, class reagents -- is drawn
    from the ladders in ns.FoodUpgradeChains rather than a list of its own,
    so the popup can never offer a staple the upgrader would not then
    maintain. Single-tier "ladders" (most reagents) ride the same rails and
    simply never move.

    A few staples arrive PRE-TICKED for the class (defaultFor below): the
    window opens with bread already on the list for everyone, water for the
    mana classes, meat for hunters. Unticking before closing removes them
    again -- and leaves the list empty, so the window returns next login,
    same as closing it untouched.
]]

--[[
    The popup asks for WHOLE STACKS, not raw counts, because stacks are the
    unit a bag slot thinks in. Every food and water staple on the ladders
    vendors in stacks of 20, ammo in stacks of 200, and the consumable
    reagents in stacks of 20, so the stack sizes below are constants of the
    data, not guesses.

    A tick defaults to one stack -- or to defaultStacks, where one is the
    wrong opening offer -- and the dropdown beside it runs to a per-category
    cap: 18 for ammo, where a hunter genuinely fills an 18-slot quiver, and a
    tighter 4 everywhere else, where more stacks than that is just a heavier
    corpse run.

    A STACK SIZE OF 1 turns the same dropdown into a plain count, which is
    what an item that never stacks needs: Soul Shards take a bag slot each, so
    the choice is how many slots to give them, and the dropdown says "20"
    rather than "20 Stacks".

    A category with an explicit choices list offers those counts INSTEAD of
    every number up to a cap. Soul Shards step in fours from 12 to 40 -- a
    soul bag's worth at each of the sizes a warlock actually carries -- which
    is the same question a forty-entry dropdown would ask, without the
    scrolling. maxStacks is the cap for the every-number kind and is what
    choices replaces, so a category sets one or the other, never both.

    A category with fixedAmount instead of a stack size gets no dropdown at
    all: totems are tools you own one of.
]]
local FOOD_STACK_SIZE = 20
local FOOD_MAX_STACKS = 4
local AMMO_STACK_SIZE = 200
local AMMO_MAX_STACKS = 18
local POISON_STACK_SIZE = 20
local POISON_MAX_STACKS = 4
local REAGENT_STACK_SIZE = 20
local REAGENT_MAX_STACKS = 4
local SINGLE_STACK_SIZE = 1
local SOUL_SHARD_CHOICES = { 12, 16, 20, 24, 28, 32, 36, 40 }
local SOUL_SHARD_DEFAULT = 20

-- Ladders keyed for the category list below: food by diet number, poisons
-- by group number, reagents by their reagent string, the single-ladder kinds
-- by kind. Potions are deliberately absent -- past the first tiers they are
-- Alchemy goods no vendor restock can rely on.
local chainsByKey = {}
for _, chain in ipairs(ns.FoodUpgradeChains or {}) do
	if chain.kind == "food" then
		chainsByKey["food:" .. chain.diet] = chain
	elseif chain.kind == "poison" then
		chainsByKey["poison:" .. chain.group] = chain
	elseif chain.kind == "reagent" then
		chainsByKey["reagent:" .. chain.reagent] = chain
	else
		chainsByKey[chain.kind] = chain
	end
end

-- Canonical diet numbering (Data/Pet-Foods.lua); the English keys are always
-- present alongside the localized aliases.
local DIET = ns.PetDietMap

-- Canonical poison-group numbering (ns.PoisonGroupBaseItems, Data/Poisons.lua).
local POISON_GROUP = { ANESTHETIC = 1, CRIPPLING = 2, DEADLY = 3, INSTANT = 4, MIND_NUMBING = 5, WOUND = 6 }

--[[
    Class sets. classes on a category is WHO IS OFFERED it (absent = every
    class); defaultFor is who gets it PRE-TICKED when the window opens. Mana
    classes get water ticked; the manaless still see the row, unticked -- a
    warrior can carry water for a druid friend, but nobody decides that for
    them. Death Knights only exist on a Wrath client, which is exactly why
    their entries need no expansion gate of their own: no other client has a
    character that can see them.
]]
local AMMO_CLASSES = { HUNTER = true, WARRIOR = true, ROGUE = true }
local MANA_CLASSES = { DRUID = true, HUNTER = true, MAGE = true, PALADIN = true, PRIEST = true, SHAMAN = true, WARLOCK = true }

--[[
    One entry per checkbox. section groups entries under the popup's
    headings; label reuses the DIET_ keys for food, so the popup names bread
    whatever the pet-food tooltips call it.

    The order HERE is for the maintainer's eye -- grouped by section, then
    by class. Display order is the popup's to compute (SectionCategories in
    Options-Starter-List-Popup.lua): dropdown staples first, fixed-amount
    singles after, each run alphabetical by localized label.

    Built defensively: a category whose ladder went missing is dropped here
    rather than crashing the popup open.
]]
local STARTER_CATEGORIES = {}
for _, spec in ipairs({
	-- Food, everyone. Bread arrives ticked for all; meat ticked for hunters
	-- (their pet eats it too).
	{ key = "bread", section = "food", label = L["DIET_BREAD"], chainKey = "food:" .. DIET["Bread"], stackSize = FOOD_STACK_SIZE, maxStacks = FOOD_MAX_STACKS, defaultFor = "all" },
	{ key = "cheese", section = "food", label = L["DIET_CHEESE"], chainKey = "food:" .. DIET["Cheese"], stackSize = FOOD_STACK_SIZE, maxStacks = FOOD_MAX_STACKS },
	{ key = "fish", section = "food", label = L["DIET_FISH"], chainKey = "food:" .. DIET["Fish"], stackSize = FOOD_STACK_SIZE, maxStacks = FOOD_MAX_STACKS },
	{ key = "fruit", section = "food", label = L["DIET_FRUIT"], chainKey = "food:" .. DIET["Fruit"], stackSize = FOOD_STACK_SIZE, maxStacks = FOOD_MAX_STACKS },
	{ key = "fungus", section = "food", label = L["DIET_FUNGUS"], chainKey = "food:" .. DIET["Fungus"], stackSize = FOOD_STACK_SIZE, maxStacks = FOOD_MAX_STACKS },
	{ key = "meat", section = "food", label = L["DIET_MEAT"], chainKey = "food:" .. DIET["Meat"], stackSize = FOOD_STACK_SIZE, maxStacks = FOOD_MAX_STACKS, defaultFor = { HUNTER = true } },

	-- Water, everyone; pre-ticked for the classes that drink for mana.
	{ key = "water", section = "water", label = L["LABEL_WATER"], chainKey = "water", stackSize = FOOD_STACK_SIZE, maxStacks = FOOD_MAX_STACKS, defaultFor = MANA_CLASSES },

	-- Ammo, launcher classes only.
	{ key = "bullets", section = "ammo", label = L["STARTER_POPUP_BULLETS"], chainKey = "bullet", stackSize = AMMO_STACK_SIZE, maxStacks = AMMO_MAX_STACKS, classes = AMMO_CLASSES },
	{ key = "arrows", section = "ammo", label = L["STARTER_POPUP_ARROWS"], chainKey = "arrow", stackSize = AMMO_STACK_SIZE, maxStacks = AMMO_MAX_STACKS, classes = AMMO_CLASSES },

	--[[
	    Poisons, their own headed section for rogues (alphabetical, like the
	    foods) -- the popup adds a note under its header that the ingredients
	    buy themselves. Availability does the level work: every ladder opens
	    at its spell's training level, so the section fills out as the rogue
	    earns each type -- and Anesthetic's all-TBC ladder simply never comes
	    up on Era.
	]]
	{ key = "anesthetic", section = "poisons", label = L["STARTER_POPUP_POISON_ANESTHETIC"], chainKey = "poison:" .. POISON_GROUP.ANESTHETIC, stackSize = POISON_STACK_SIZE, maxStacks = POISON_MAX_STACKS, classes = { ROGUE = true } },
	{ key = "crippling", section = "poisons", label = L["STARTER_POPUP_POISON_CRIPPLING"], chainKey = "poison:" .. POISON_GROUP.CRIPPLING, stackSize = POISON_STACK_SIZE, maxStacks = POISON_MAX_STACKS, classes = { ROGUE = true } },
	{ key = "deadly", section = "poisons", label = L["STARTER_POPUP_POISON_DEADLY"], chainKey = "poison:" .. POISON_GROUP.DEADLY, stackSize = POISON_STACK_SIZE, maxStacks = POISON_MAX_STACKS, classes = { ROGUE = true } },
	{ key = "instant", section = "poisons", label = L["STARTER_POPUP_POISON_INSTANT"], chainKey = "poison:" .. POISON_GROUP.INSTANT, stackSize = POISON_STACK_SIZE, maxStacks = POISON_MAX_STACKS, classes = { ROGUE = true } },
	{ key = "mindnumbing", section = "poisons", label = L["STARTER_POPUP_POISON_MIND_NUMBING"], chainKey = "poison:" .. POISON_GROUP.MIND_NUMBING, stackSize = POISON_STACK_SIZE, maxStacks = POISON_MAX_STACKS, classes = { ROGUE = true } },
	{ key = "wound", section = "poisons", label = L["STARTER_POPUP_POISON_WOUND"], chainKey = "poison:" .. POISON_GROUP.WOUND, stackSize = POISON_STACK_SIZE, maxStacks = POISON_MAX_STACKS, classes = { ROGUE = true } },
	--[[
	    Reagents & Tools. Hearthstone is offered to every class -- the worked
	    example that ANYTHING can go on the Restock List, not just the
	    consumables the add-on curates -- alongside each class's own entries.
	]]
	{ key = "hearthstone", section = "reagents", label = L["STARTER_POPUP_REAGENT_HEARTHSTONE"], chainKey = "reagent:hearthstone", fixedAmount = 1 },
	{ key = "blindingpowder", section = "reagents", label = L["STARTER_POPUP_REAGENT_BLINDING_POWDER"], chainKey = "reagent:blinding-powder", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { ROGUE = true } },
	{ key = "flashpowder", section = "reagents", label = L["STARTER_POPUP_REAGENT_FLASH_POWDER"], chainKey = "reagent:flash-powder", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { ROGUE = true } },
	-- A tool, not a consumable: you own one.
	{ key = "thievestools", section = "reagents", label = L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"], chainKey = "reagent:thieves-tools", fixedAmount = 1, classes = { ROGUE = true } },

	{ key = "corpsedust", section = "reagents", label = L["STARTER_POPUP_REAGENT_CORPSE_DUST"], chainKey = "reagent:corpse-dust", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { DEATHKNIGHT = true } },

	{ key = "seeds", section = "reagents", label = L["STARTER_POPUP_REAGENT_SEEDS"], chainKey = "reagent:seeds", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { DRUID = true } },
	{ key = "wilds", section = "reagents", label = L["STARTER_POPUP_REAGENT_WILDS"], chainKey = "reagent:wilds", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { DRUID = true } },

	-- Light Feather serves the mage's Slow Fall and the priest's Levitate.
	{ key = "arcanepowder", section = "reagents", label = L["STARTER_POPUP_REAGENT_ARCANE_POWDER"], chainKey = "reagent:arcane-powder", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { MAGE = true } },
	{ key = "lightfeather", section = "reagents", label = L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"], chainKey = "reagent:light-feather", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { MAGE = true, PRIEST = true } },
	{ key = "teleportrunes", section = "reagents", label = L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"], chainKey = "reagent:rune-of-teleportation", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { MAGE = true } },
	{ key = "portalrunes", section = "reagents", label = L["STARTER_POPUP_REAGENT_PORTAL_RUNES"], chainKey = "reagent:rune-of-portals", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { MAGE = true } },

	{ key = "divinitysymbol", section = "reagents", label = L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"], chainKey = "reagent:symbol-of-divinity", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { PALADIN = true } },
	{ key = "kingssymbol", section = "reagents", label = L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"], chainKey = "reagent:symbol-of-kings", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { PALADIN = true } },

	{ key = "candles", section = "reagents", label = L["STARTER_POPUP_REAGENT_CANDLES"], chainKey = "reagent:candles", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { PRIEST = true } },

	{ key = "ankh", section = "reagents", label = L["STARTER_POPUP_REAGENT_ANKH"], chainKey = "reagent:ankh", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { SHAMAN = true } },
	{ key = "fishscales", section = "reagents", label = L["STARTER_POPUP_REAGENT_FISH_SCALES"], chainKey = "reagent:fish-scales", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { SHAMAN = true } },
	{ key = "fishoil", section = "reagents", label = L["STARTER_POPUP_REAGENT_FISH_OIL"], chainKey = "reagent:fish-oil", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { SHAMAN = true } },
	-- Totems are tools: one each, no dropdown.
	{ key = "earthtotem", section = "reagents", label = L["STARTER_POPUP_REAGENT_EARTH_TOTEM"], chainKey = "reagent:earth-totem", fixedAmount = 1, classes = { SHAMAN = true } },
	{ key = "firetotem", section = "reagents", label = L["STARTER_POPUP_REAGENT_FIRE_TOTEM"], chainKey = "reagent:fire-totem", fixedAmount = 1, classes = { SHAMAN = true } },
	{ key = "watertotem", section = "reagents", label = L["STARTER_POPUP_REAGENT_WATER_TOTEM"], chainKey = "reagent:water-totem", fixedAmount = 1, classes = { SHAMAN = true } },
	{ key = "airtotem", section = "reagents", label = L["STARTER_POPUP_REAGENT_AIR_TOTEM"], chainKey = "reagent:air-totem", fixedAmount = 1, classes = { SHAMAN = true } },

	-- Soul Shards never stack, so their dropdown counts bag slots rather than
	-- stacks (stackSize 1), offering the soul-bag sizes above and opening on
	-- a middling one.
	{ key = "figurine", section = "reagents", label = L["STARTER_POPUP_REAGENT_FIGURINE"], chainKey = "reagent:demonic-figurine", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { WARLOCK = true } },
	{ key = "infernalstone", section = "reagents", label = L["STARTER_POPUP_REAGENT_INFERNAL_STONE"], chainKey = "reagent:infernal-stone", stackSize = REAGENT_STACK_SIZE, maxStacks = REAGENT_MAX_STACKS, classes = { WARLOCK = true } },
	{ key = "soulshards", section = "reagents", label = L["STARTER_POPUP_REAGENT_SOUL_SHARDS"], chainKey = "reagent:soul-shard", stackSize = SINGLE_STACK_SIZE, choices = SOUL_SHARD_CHOICES, defaultStacks = SOUL_SHARD_DEFAULT, classes = { WARLOCK = true } },
}) do
	local chain = chainsByKey[spec.chainKey]
	if chain then
		spec.chain = chain
		spec.chainKey = nil
		STARTER_CATEGORIES[#STARTER_CATEGORIES + 1] = spec
	end
end

---@return table[] The category list, for the popup builder.
function RS.GetStarterCategories()
	return STARTER_CATEGORIES
end

---Is this category for this character's class? No classes set means everyone.
---@param category table One of STARTER_CATEGORIES
---@return boolean
function RS.IsStarterCategoryForClass(category)
	if category.classes == nil then
		return true
	end
	local _, classToken = UnitClass("player")
	return category.classes[classToken] == true
end

---A category is offerable only when its ladder yields an item right now:
---this hides reagents whose spell the character has not trained toward yet
---(their ladders open at the spell's level), and whole chains from another
---expansion -- Anesthetic on an Era client, and Blinding Powder anywhere
---PAST Classic, via the tier's removed-after field. Food, water and ammo
---all open at level 1, so it never hides them.
---@param category table One of STARTER_CATEGORIES
---@return boolean
function RS.IsStarterCategoryAvailable(category)
	return RS.BestChainItemID(category.chain, UnitLevel("player") or 1) ~= nil
end

---Whether the class sees this section at all -- true when any of the
---section's categories is for this class. Level and expansion availability
---are the popup builder's per-category concern, not this gate's.
---@param section string "food", "water", "poisons", "reagents" or "ammo"
---@return boolean
function RS.IsStarterSectionVisible(section)
	for _, category in ipairs(STARTER_CATEGORIES) do
		if category.section == section and RS.IsStarterCategoryForClass(category) then
			return true
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Ticking a Staple
--------------------------------------------------------------------------------

local function rsCurrentProfile()
	local settings = restockerModule.settings
	return settings and settings.profiles and settings.profiles[settings.currentProfile]
end

---Any tier of this ladder already on the list? The whole chain is checked
---rather than today's best tier, so the box stays ticked after a level-up
---moves the entry, and unticking removes whichever tier is actually there.
---@return number|nil itemID The listed tier's itemID
local function rsChainItemOnList(profile, chain)
	for _, tier in ipairs(chain.tiers) do
		if profile[tier[2]] ~= nil then
			return tier[2]
		end
	end
	return nil
end

--[[
    Ticked staples whose item had not resolved yet, [itemID] = category.
    GetItemInfo asks the server on a miss, so the retry rides on
    GET_ITEM_INFO_RECEIVED (Events.lua) -- the same arrangement as Upgrade.lua's
    deferred moves, and for the same reason: inserting before the answer
    arrives would write a nameless row. The box reads as ticked while an add
    is pending, so the click visibly takes.
]]
local pendingStarterAdds = {}

---@return boolean
function RS.HasPendingStarterAdds()
	return next(pendingStarterAdds) ~= nil
end

function RS.RetryPendingStarterAdds()
	local retry = pendingStarterAdds
	pendingStarterAdds = {}
	for _, category in pairs(retry) do
		RS.AddStarterCategory(category)
	end
end

---What a tick of this category puts on the list right now.
---@param category table One of STARTER_CATEGORIES
---@return number amount
local function rsCategoryAmount(category)
	if category.fixedAmount then
		return category.fixedAmount
	end
	return RS.GetStarterCategoryStacks(category) * category.stackSize
end

---@param category table One of STARTER_CATEGORIES
function RS.AddStarterCategory(category)
	local profile = rsCurrentProfile()
	if not profile or rsChainItemOnList(profile, category.chain) then
		return
	end

	local itemID = RS.BestChainItemID(category.chain, UnitLevel("player") or 1)
	if not itemID then
		return
	end

	local info = RS.GetItemInfo(itemID)
	if not info then
		pendingStarterAdds[itemID] = category
		return
	end

	-- Same shape and same everything-on defaults as a hand-added item
	-- (RS:addItem in MainFrame.lua); only the amount differs.
	profile[itemID] = {
		itemName = info.itemName,
		itemType = info.itemType,
		itemID = itemID,
		amount = rsCategoryAmount(category),
		buyFromMerchant = true,
		stashTobank = true,
		restockFromBank = true,
	}

	-- Into the window's "New" group, so the first /crs after this popup opens
	-- on the rows it created with their controls ready.
	RS.newItems[itemID] = true

	RS:Update()
end

---@param category table One of STARTER_CATEGORIES
function RS.RemoveStarterCategory(category)
	-- A pending add must be cancelled too, or it would land after the untick.
	for itemID, pending in pairs(pendingStarterAdds) do
		if pending == category then
			pendingStarterAdds[itemID] = nil
		end
	end

	local profile = rsCurrentProfile()
	if not profile then
		return
	end

	local removed = false
	for _, tier in ipairs(category.chain.tiers) do
		local itemID = tier[2]
		if profile[itemID] ~= nil then
			profile[itemID] = nil
			RS.newItems[itemID] = nil
			removed = true
		end
	end
	if removed then
		RS:Update()
	end
end

---The popup checkbox handler: ticking adds, unticking removes.
---@param category table One of STARTER_CATEGORIES
---@param checked boolean
function RS.SetStarterCategory(category, checked)
	if checked then
		RS.AddStarterCategory(category)
	else
		RS.RemoveStarterCategory(category)
	end
end

---@param category table One of STARTER_CATEGORIES
---@return boolean
function RS.IsStarterCategoryChecked(category)
	local profile = rsCurrentProfile()
	if profile and rsChainItemOnList(profile, category.chain) then
		return true
	end
	for _, pending in pairs(pendingStarterAdds) do
		if pending == category then
			return true
		end
	end
	return false
end

--[[
    The stack count each dropdown shows and writes, clamped to
    1..category.maxStacks. fixedAmount categories have no dropdown; they
    answer 1 and ignore writes, so no caller needs its own guard.

    Two homes, and the list wins: while the staple is ON the list the count is
    derived from the entry's real amount (rounded to the nearest whole stack,
    so a hand-edited amount in the Restocker window still reads sensibly
    here), and writing pushes straight back onto that entry. While it is off
    the list the choice is view state in selectedStacks -- one sitting only,
    never saved -- so a stack count can be picked BEFORE ticking the box, and
    survives an untick-retick without a row ever existing to carry it.

    An untouched dropdown opens on defaultStacks where the category sets one,
    and on one stack otherwise -- the opening offer, not a saved choice, so it
    reads the same on a fresh character as on a fifth one.
]]
local selectedStacks = {} -- [category.key] = stacks, while the staple is not on the list

---What a raw count reads as in the dropdown. The every-number categories
---simply clamp; one that offers a handful (Soul Shards) snaps up to the
---smallest offer that still covers the count, so an amount the dropdown could
---not have produced -- hand-edited in the Restocker window, or left behind by
---a shorter choices list -- lands on a real entry instead of blanking it.
---@param category table One of STARTER_CATEGORIES
---@param count number
---@return number stacks
local function rsSnapStacks(category, count)
	local choices = category.choices
	if not choices then
		return math.max(1, math.min(category.maxStacks, count))
	end
	for _, offered in ipairs(choices) do
		if count <= offered then
			return offered
		end
	end
	return choices[#choices]
end

---@param category table One of STARTER_CATEGORIES
---@return number stacks
function RS.GetStarterCategoryStacks(category)
	if category.fixedAmount then
		return 1
	end
	local profile = rsCurrentProfile()
	local listedID = profile and rsChainItemOnList(profile, category.chain)
	if listedID then
		local amount = profile[listedID].amount or category.stackSize
		local stacks = math.floor(amount / category.stackSize + 0.5)
		return rsSnapStacks(category, stacks)
	end
	return selectedStacks[category.key] or category.defaultStacks or 1
end

---@param category table One of STARTER_CATEGORIES
---@param stacks number
function RS.SetStarterCategoryStacks(category, stacks)
	if category.fixedAmount then
		return
	end
	stacks = rsSnapStacks(category, math.floor(stacks))
	selectedStacks[category.key] = stacks

	local profile = rsCurrentProfile()
	local listedID = profile and rsChainItemOnList(profile, category.chain)
	if listedID then
		profile[listedID].amount = stacks * category.stackSize
		RS:Update()
		return
	end

	--[[
	    Off the list, picking a count IS asking for the staple. The dropdown
	    beside an unticked box otherwise does nothing you can see -- it only
	    pre-loads what a later tick would add -- so setting one to 28 and
	    watching the Restock List stay empty reads as the add being broken.
	    The tick goes through the same add path the checkbox uses, and
	    AceConfigDialog's post-set NotifyChange is what makes the box opposite
	    show itself ticked.
	]]
	RS.AddStarterCategory(category)
end

---The checkbox tooltip: the exact item a tick adds right now, with the
---count the current stack choice (or fixed amount) works out to. Ladder
---items mention the upgrading; single-tier reagents, which never move, get
---the plain form. RS.GetItemLink never returns nil, so this reads correctly
---even while the item is still resolving.
---@param category table One of STARTER_CATEGORIES
---@return string
function RS.DescribeStarterCategory(category)
	local itemID = RS.BestChainItemID(category.chain, UnitLevel("player") or 1)
	local template = (#category.chain.tiers > 1) and L["STARTER_POPUP_ITEM_DESCRIPTION"]
		or L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"]
	return string.format(template, RS.GetItemLink(itemID, nil), rsCategoryAmount(category))
end

--------------------------------------------------------------------------------
-- Don't-Show-Again
--------------------------------------------------------------------------------

--[[
    Per character, keyed like settings.profileKeys, and stored in the
    Restocker's own account-wide DB rather than on an AceDB profile -- a
    profile can be switched, copied or reset, and none of those should
    resurrect (or suppress) a login window a character already answered.

    A cleared flag is stored as nil rather than false, so the table only ever
    carries the characters that opted out.
]]

---@return boolean
function RS.IsStarterPopupDismissed()
	local settings = restockerModule.settings
	local dismissed = settings and settings.starterListDismissed
	return dismissed ~= nil and dismissed[RS:GetCharKey()] == true
end

---@param value boolean
function RS.SetStarterPopupDismissed(value)
	local settings = restockerModule.settings
	if not settings then
		return
	end
	settings.starterListDismissed = settings.starterListDismissed or {}
	settings.starterListDismissed[RS:GetCharKey()] = value and true or nil
end

--------------------------------------------------------------------------------
-- Login Trigger
--------------------------------------------------------------------------------

-- "After level 5": a level-5 character is still on starter-zone money; by 6
-- they have met vendors worth a shopping list.
local STARTER_MIN_LEVEL = 6

-- Matches Core.lua's post-login settle timer: past the loading-screen flurry,
-- and usually long enough for the item queries warmed below to be answered
-- before anyone hovers a checkbox.
local STARTER_POPUP_DELAY = 3

---Does this class get this category pre-ticked?
---@param category table One of STARTER_CATEGORIES
---@return boolean
local function rsIsDefaultCategory(category)
	local defaultFor = category.defaultFor
	if defaultFor == nil then
		return false
	end
	if defaultFor == "all" then
		return true
	end
	local _, classToken = UnitClass("player")
	return defaultFor[classToken] == true
end

function RS.MaybeShowStarterListPopup()
	if not RS.loaded or RS.IsStarterPopupDismissed() then
		return
	end
	if (UnitLevel("player") or 1) < STARTER_MIN_LEVEL then
		return
	end

	local profile = rsCurrentProfile()
	if not profile or next(profile) ~= nil then
		return
	end

	--[[
	    Nothing OFFERABLE means nothing to show -- with bread open to every
	    class at level 1 that is a formality today, but it keeps a future
	    class or data change from opening an empty window. Logging in
	    mid-combat skips this login -- the empty list is still empty
	    tomorrow.
	]]
	local level = UnitLevel("player") or 1
	local anyOffered = false
	for _, category in ipairs(STARTER_CATEGORIES) do
		if RS.IsStarterCategoryForClass(category) then
			local itemID = RS.BestChainItemID(category.chain, level)
			if itemID then
				anyOffered = true
				-- Warm the cache so the tooltips can name their items on first hover.
				RS.GetItemInfo(itemID)
			end
		end
	end
	if not anyOffered or InCombatLockdown() then
		return
	end

	--[[
	    The pre-ticked staples go on the list just before the window opens,
	    through the same add path a hand-tick uses -- so the window opens
	    with those boxes genuinely checked, and unticking one takes it
	    straight back off. Only ever from here: the popup is the only place
	    the defaults exist, so a player who never sees it never has a list
	    written for them.
	]]
	for _, category in ipairs(STARTER_CATEGORIES) do
		if rsIsDefaultCategory(category)
			and RS.IsStarterCategoryForClass(category)
			and RS.IsStarterCategoryAvailable(category)
		then
			RS.AddStarterCategory(category)
		end
	end

	if ns.ShowStarterListPopup then
		ns:ShowStarterListPopup()
	end
end

--[[
    Fresh logins only. isInitialLogin is false on /reload and on every
    mid-session loading screen, and both would otherwise re-open a window the
    player already closed this sitting -- the "don't spam them" half of the
    feature is this one argument. Registered in Events.lua alongside the rest
    of the Restocker's event wiring.
]]
---@param isInitialLogin boolean
function RS.OnStarterListEnteringWorld(isInitialLogin, _isReloadingUi)
	if not isInitialLogin then
		return
	end
	C_Timer.After(STARTER_POPUP_DELAY, RS.MaybeShowStarterListPopup)
end
