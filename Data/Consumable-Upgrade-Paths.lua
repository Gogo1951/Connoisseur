local _, ns = ...

--------------------------------------------------------------------------------
-- Consumable Upgrade Paths
--------------------------------------------------------------------------------

--[[
    The staple ladders. Each family goes up in fixed steps, so a Restock List
    entry can follow the player instead of going stale: at level 45 "Soft
    Banana Bread" is what you want, at 55 it is not.

    Deliberately a table of its own rather than columns on
    ns.RawData.FoodAndWater or ns.RawData.Potions. Those answer "what does this
    item restore?" for hundreds of items; this one answers "what should replace
    this on a shopping list?" for a curated few. Bolting the second onto the
    first would nil-pad most rows, push an already-positional row wider, and
    still leave the ordering to be re-derived at runtime -- the ordering IS the
    data here.

    THE EXPANSION FLAG IS HAND-SET, and has to be. A Wrath database cannot say
    when an item was added: the ID blocks interleave (the Northrend food
    staples are 33443-33454, below TBC's Naaru Ration at 34780), and vendorMaps
    describes 3.3.5, where Azeroth vendors already stock Northrend food. It
    only changes an outcome in a few places -- reqLevel 55-60, where Classic
    Era would otherwise reach for Outland goods, and 65, where TBC and Wrath
    offer equivalents -- but there it is the only thing that is right.

    minLevel is item_template.RequiredLevel, the level the item becomes USABLE,
    which for food runs ten below the ItemLevel ladder of the same items.
]]

--[[
    SOURCE, food and water (CMaNGoS, Wrath). Ammo is the same query with
    `class = 6 AND subclass IN (2, 3)` (2 arrow, 3 bullet) plus dmg_min1 and
    dmg_max1 to confirm the ordering.

        SELECT it.entry, it.name, it.ItemLevel, it.RequiredLevel, it.FoodType,
               it.spellid_1, it.BuyPrice, COUNT(DISTINCT nv.entry) AS vendors,
               MIN(nv.maxcount) AS minStock, MAX(nv.ExtendedCost) AS extCost,
               GROUP_CONCAT(DISTINCT c.map ORDER BY c.map) AS vendorMaps
        FROM item_template it
        JOIN npc_vendor nv        ON nv.item  = it.entry
        JOIN creature_template ct ON ct.Entry = nv.entry
        LEFT JOIN creature c      ON c.id     = ct.Entry
        WHERE it.class = 0 AND it.subclass = 5
        GROUP BY it.entry
        ORDER BY it.FoodType, it.ItemLevel, it.entry;

    Every food, water and ammo tier below is gold-buyable and unlimited stock:
    extCost = 0, minStock = 0, BuyPrice > 0. That filter is what drops the
    arena and token foods (Star's Tears, Marsh Lichen) and the limited-stock
    ones (Blackened Basilisk, Steaming Chicken Soup) -- none of which a restock
    list can rely on. Where a tier had several candidates the one on the most
    vendors won.

    POTIONS ARE THE EXCEPTION TO ALL OF THAT. Past the first tier or two they
    are Alchemy goods off the auction house, not vendor stock, so no
    npc_vendor query produces them and the "sold by a merchant" rule does not
    apply. Their ladder is still real -- Greater becomes Superior at 35 the
    same way bread becomes pie at 45 -- and the Restocker still moves them to
    and from the bank. It only means their Buy toggle has nothing to buy from.
]]

ns.EXPANSION_CLASSIC = 0
ns.EXPANSION_TBC = 1
ns.EXPANSION_WRATH = 2

--[[
    diet uses ns.PetDietMap's numbering (Data/Pet-Foods.lua), NOT
    item_template.FoodType. The two disagree on four of six values -- the
    database calls cheese 3 and bread 4, Connoisseur calls bread 3 and cheese
    4, and it swaps fruit and fungus too -- so a FoodType pasted in raw from
    SQL would silently mislabel most of this file. Water is 0: drinks have no
    FoodType at all, which is also why they are absent from Pet-Foods.lua.
]]
local WATER, MEAT, FISH, BREAD, CHEESE, FRUIT, FUNGUS = 0, 1, 2, 3, 4, 5, 6

local CLASSIC, TBC, WRATH = ns.EXPANSION_CLASSIC, ns.EXPANSION_TBC, ns.EXPANSION_WRATH

--[[
    kind is what the ladder is, for anything that needs to tell them apart;
    diet is carried on the food chains only, where it ties to ns.PetDietMap.

    Arrows and bullets are separate ladders on purpose. A hunter's weapon
    decides which they can fire, so upgrading an arrow into a bullet would
    leave them holding ammo they cannot use.

    Tiers are ordered by minLevel, then by expansion. That ordering is load
    bearing: where two tiers share a level (65 in every food family) the
    selector keeps the last one it accepts, so a TBC client stops at the TBC
    item and a Wrath client goes on to the Wrath one.
]]
ns.FoodUpgradeChains = {
	{
		kind = "water",
		diet = WATER,
		tiers = {
			{ 1, 159, CLASSIC }, -- Refreshing Spring Water
			{ 5, 1179, CLASSIC }, -- Ice Cold Milk
			{ 15, 1205, CLASSIC }, -- Melon Juice
			{ 25, 1708, CLASSIC }, -- Sweet Nectar
			{ 35, 1645, CLASSIC }, -- Moonberry Juice
			{ 45, 8766, CLASSIC }, -- Morning Glory Dew
			{ 60, 28399, TBC }, -- Filtered Draenic Water
			{ 65, 27860, TBC }, -- Purified Draenic Water
			{ 65, 35954, WRATH }, -- Sweetened Goat's Milk
			{ 70, 33444, WRATH }, -- Pungent Seal Whey
			{ 75, 33445, WRATH }, -- Honeymint Tea
		},
	},
	{
		kind = "food",
		diet = MEAT,
		tiers = {
			{ 1, 117, CLASSIC }, -- Tough Jerky
			{ 5, 2287, CLASSIC }, -- Haunch of Meat
			{ 15, 3770, CLASSIC }, -- Mutton Chop
			{ 25, 3771, CLASSIC }, -- Wild Hog Shank
			{ 35, 4599, CLASSIC }, -- Cured Ham Steak
			{ 45, 8952, CLASSIC }, -- Roasted Quail
			{ 55, 27854, TBC }, -- Smoked Talbuk Venison
			{ 65, 29451, TBC }, -- Clefthoof Ribs
			{ 65, 33454, WRATH }, -- Salted Venison
			{ 75, 35953, WRATH }, -- Mead Basted Caribou
		},
	},
	{
		kind = "food",
		diet = FISH,
		tiers = {
			{ 1, 787, CLASSIC }, -- Slitherskin Mackerel
			{ 5, 4592, CLASSIC }, -- Longjaw Mud Snapper
			{ 15, 4593, CLASSIC }, -- Bristle Whisker Catfish
			{ 25, 4594, CLASSIC }, -- Rockscale Cod
			{ 35, 21552, CLASSIC }, -- Striped Yellowtail
			{ 45, 8957, CLASSIC }, -- Spinefin Halibut
			{ 55, 27858, TBC }, -- Sunspring Carp
			{ 65, 29452, TBC }, -- Zangar Trout
			{ 65, 33451, WRATH }, -- Fillet of Icefin
			{ 75, 35951, WRATH }, -- Poached Emperor Salmon
		},
	},
	{
		--[[
            Homemade Cherry Pie is BREAD, not fruit. item_template files it
            under FoodType 6 and the database is simply wrong -- Pet-Foods.lua
            already carries the same correction (diet 3) and says so. Taking
            the SQL at its word would have left bread with no tier at 45 and
            given fruit two.
        ]]
		kind = "food",
		diet = BREAD,
		tiers = {
			{ 1, 4540, CLASSIC }, -- Tough Hunk of Bread
			{ 5, 4541, CLASSIC }, -- Freshly Baked Bread
			{ 15, 4542, CLASSIC }, -- Moist Cornbread
			{ 25, 4544, CLASSIC }, -- Mulgore Spice Bread
			{ 35, 4601, CLASSIC }, -- Soft Banana Bread
			{ 45, 8950, CLASSIC }, -- Homemade Cherry Pie
			{ 55, 27855, TBC }, -- Mag'har Grainbread
			{ 65, 29449, TBC }, -- Bladespire Bagel
			{ 65, 33449, WRATH }, -- Crusty Flatbread
			{ 75, 35950, WRATH }, -- Sweet Potato Bread
		},
	},
	{
		kind = "food",
		diet = CHEESE,
		tiers = {
			{ 1, 2070, CLASSIC }, -- Darnassian Bleu
			{ 5, 414, CLASSIC }, -- Dalaran Sharp
			{ 15, 422, CLASSIC }, -- Dwarven Mild
			{ 25, 1707, CLASSIC }, -- Stormwind Brie
			{ 35, 3927, CLASSIC }, -- Fine Aged Cheddar
			{ 45, 8932, CLASSIC }, -- Alterac Swiss
			{ 55, 27857, TBC }, -- Garadar Sharp
			{ 65, 29448, TBC }, -- Mag'har Mild Cheese
			{ 65, 33443, WRATH }, -- Sour Goat Cheese
			{ 75, 35952, WRATH }, -- Briny Hardcheese
		},
	},
	{
		-- Deep Fried Plantains takes 45, not Homemade Cherry Pie: see the bread
		-- chain above for why the database's fruit label on the pie is wrong.
		kind = "food",
		diet = FRUIT,
		tiers = {
			{ 1, 4536, CLASSIC }, -- Shiny Red Apple
			{ 5, 4537, CLASSIC }, -- Tel'Abim Banana
			{ 15, 4538, CLASSIC }, -- Snapvine Watermelon
			{ 25, 4539, CLASSIC }, -- Goldenbark Apple
			{ 35, 4602, CLASSIC }, -- Moon Harvest Pumpkin
			{ 45, 8953, CLASSIC }, -- Deep Fried Plantains
			{ 55, 27856, TBC }, -- Skethyl Berries
			{ 65, 29450, TBC }, -- Telaari Grapes
			{ 65, 35949, WRATH }, -- Tundra Berries
			{ 75, 35948, WRATH }, -- Savory Snowplum
		},
	},
	{
		kind = "food",
		diet = FUNGUS,
		tiers = {
			{ 1, 4604, CLASSIC }, -- Forest Mushroom Cap
			{ 5, 4605, CLASSIC }, -- Red-speckled Mushroom
			{ 15, 4606, CLASSIC }, -- Spongy Morel
			{ 25, 4607, CLASSIC }, -- Delicious Cave Mold
			{ 35, 4608, CLASSIC }, -- Raw Black Truffle
			{ 45, 8948, CLASSIC }, -- Dried King Bolete
			{ 55, 27859, TBC }, -- Zangar Caps
			{ 65, 29453, TBC }, -- Sporeggar Mushroom
			{ 65, 33452, WRATH }, -- Honey-Spiced Lichen
			{ 75, 35947, WRATH }, -- Sparkling Frostcap
		},
	},

	--[[
        AMMO

        Rep ammo is excluded, and the intended filter did not work:
        npc_vendor's condition_id is empty in the source database, so the Halaa
        token ammo and the Sha'tari / Ogri'la / Shattered Sun rep ammo all came
        back looking unconditional. Vendor count separates them instead, and
        cleanly -- the staples sit on 54 to 120 vendors and every rep, token or
        quartermaster line on 1 to 4, with nothing in between. Excluded on that
        basis: Scout's Arrow, Halaani Razorshaft, Halaani Grimshot, Warden's
        Arrow, Hellfire Shot, Felbane Slugs, Mysterious Arrow, Mysterious
        Shell, Timeless Arrow, Timeless Shell.

        That an item leaves the ladder is the whole behaviour the exclusion
        buys: a player who switches to rep ammo holds something with no chain
        entry, so its Upgrade button greys out and Connoisseur leaves it alone.

        The two ladders mirror each other exactly, tier for tier and damage for
        damage. Engineering ammo (Thorium Headed Arrow, Mithril Gyro-Shot) beats
        both and appears in neither, because none of it is sold by a vendor.
    ]]
	{
		kind = "arrow",
		tiers = {
			{ 1, 2512, CLASSIC }, -- Rough Arrow
			{ 10, 2515, CLASSIC }, -- Sharp Arrow
			{ 25, 3030, CLASSIC }, -- Razor Arrow
			{ 40, 11285, CLASSIC }, -- Jagged Arrow
			{ 55, 28053, TBC }, -- Wicked Arrow
			{ 65, 28056, TBC }, -- Blackflight Arrow
			{ 75, 41586, WRATH }, -- Terrorshaft Arrow
		},
	},
	{
		kind = "bullet",
		tiers = {
			{ 1, 2516, CLASSIC }, -- Light Shot
			{ 10, 2519, CLASSIC }, -- Heavy Shot
			{ 25, 3033, CLASSIC }, -- Solid Shot
			{ 40, 11284, CLASSIC }, -- Accurate Slugs
			{ 55, 28060, TBC }, -- Impact Shot
			{ 65, 28061, TBC }, -- Ironbite Shell
			{ 75, 41584, WRATH }, -- Frostbite Bullets
		},
	},

	--[[
        ROGUE POISONS

        The tier rows mirror ns.PoisonData (Data/Poisons.lua), which the
        Poisons macro already ships -- keep the two in step. group is
        ns.PoisonGroupBaseItems' numbering from the same file, which is how
        the Starter List popup finds each ladder.

        Poisons are vendor staples like the ammo above -- every rank is
        gold-buyable in unlimited stock from poison vendors -- so the ladder
        rule applies as written. Confirm against the database with the food
        query up top, filtered by name instead of class/subclass (the poison
        subclass moved between client generations):

            SELECT it.entry, it.name, it.ItemLevel, it.RequiredLevel, it.BuyPrice,
                   COUNT(DISTINCT nv.entry) AS vendors, MIN(nv.maxcount) AS minStock,
                   MAX(nv.ExtendedCost) AS extCost
            FROM item_template it
            LEFT JOIN npc_vendor nv ON nv.item = it.entry
            WHERE it.name REGEXP '^(Anesthetic|Crippling|Deadly|Instant|Mind-numbing|Wound) Poison'
            GROUP BY it.entry
            ORDER BY it.name, it.RequiredLevel;

        LEFT JOIN rather than the header query's inner join, so a rank with
        no vendor row still shows up and an exclusion is a decision instead
        of an accident.

        THE EXPANSION FLAG IS HAND-SET here too, from release history:
        Anesthetic is TBC's new poison, so its whole chain waits for a TBC
        client; the 22xxx ranks are TBC vendor goods and the 43xxx ranks are
        Wrath's -- inert on both shipping clients, here for the day that
        changes, like the Runic potions below.
    ]]
	{
		kind = "poison",
		group = 1,
		tiers = {
			{ 68, 21835, TBC }, -- Anesthetic Poison
			{ 77, 43237, WRATH }, -- Anesthetic Poison II
		},
	},
	{
		kind = "poison",
		group = 2,
		tiers = {
			{ 20, 3775, CLASSIC }, -- Crippling Poison
			{ 50, 3776, CLASSIC }, -- Crippling Poison II
		},
	},
	{
		kind = "poison",
		group = 3,
		tiers = {
			{ 30, 2892, CLASSIC }, -- Deadly Poison
			{ 38, 2893, CLASSIC }, -- Deadly Poison II
			{ 46, 8984, CLASSIC }, -- Deadly Poison III
			{ 54, 8985, CLASSIC }, -- Deadly Poison IV
			{ 60, 20844, CLASSIC }, -- Deadly Poison V
			{ 62, 22053, TBC }, -- Deadly Poison VI
			{ 70, 22054, TBC }, -- Deadly Poison VII
			{ 76, 43232, WRATH }, -- Deadly Poison VIII
			{ 80, 43233, WRATH }, -- Deadly Poison IX
		},
	},
	{
		kind = "poison",
		group = 4,
		tiers = {
			{ 20, 6947, CLASSIC }, -- Instant Poison
			{ 28, 6949, CLASSIC }, -- Instant Poison II
			{ 36, 6950, CLASSIC }, -- Instant Poison III
			{ 44, 8926, CLASSIC }, -- Instant Poison IV
			{ 52, 8927, CLASSIC }, -- Instant Poison V
			{ 60, 8928, CLASSIC }, -- Instant Poison VI
			{ 68, 21927, TBC }, -- Instant Poison VII
			{ 73, 43230, WRATH }, -- Instant Poison VIII
			{ 79, 43231, WRATH }, -- Instant Poison IX
		},
	},
	{
		kind = "poison",
		group = 5,
		tiers = {
			{ 24, 5237, CLASSIC }, -- Mind-numbing Poison
			{ 38, 6951, CLASSIC }, -- Mind-numbing Poison II
			{ 52, 9186, CLASSIC }, -- Mind-numbing Poison III
		},
	},
	{
		kind = "poison",
		group = 6,
		tiers = {
			{ 32, 10918, CLASSIC }, -- Wound Poison
			{ 40, 10920, CLASSIC }, -- Wound Poison II
			{ 48, 10921, CLASSIC }, -- Wound Poison III
			{ 56, 10922, CLASSIC }, -- Wound Poison IV
			{ 64, 22055, TBC }, -- Wound Poison V
			{ 72, 43234, WRATH }, -- Wound Poison VI
			{ 78, 43235, WRATH }, -- Wound Poison VII
		},
	},

	--[[
        CLASS REAGENTS

        One chain per Starter List reagent checkbox, keyed by the reagent
        string; single-tier chains are deliberate -- a one-rung ladder gives
        a reagent the same level gate and expansion gate every real ladder
        gets, for free. (Their Upgrade toggle in the Restocker window is
        active but inert: there is never a later tier to move to.) The
        multi-tier groups here -- Seeds, Wilds, Candles -- upgrade exactly
        like the food ladders above.

        EVERY minLevel BELOW IS AN ESTIMATE of the level the reagent's spell
        is first trainable, awaiting hand-adjustment -- unlike the rest of
        this file these are NOT item_template.RequiredLevel, because reagents
        carry no required level of their own; the spell is the gate.

        A tier's optional FOURTH field is the last expansion the item exists
        in: Blinding Powder left the game after Classic, so its row is
        CLASSIC-to-CLASSIC and a TBC client never offers it (see BestTier in
        Features/Restocker/Upgrade.lua).

        Soul Shards are the potions of this block: no vendor sells them, so
        their Buy toggle has nothing to buy from, while the bank half of the
        Restocker still moves them. Corpse Dust is Wrath vendor stock, which
        never matters on the shipping clients -- no Death Knight exists to
        see it, so the class gate does the work the expansion flag would.
    ]]
	{
		--[[
		    The worked example, offered to every class: nothing sells it and
		    everyone already owns one, so it demonstrates that the Restock
		    List tracks anything at all -- the bank half still applies, and
		    the Buy toggle simply has nothing to buy, like the Alchemy
		    potions below.
		]]
		kind = "reagent",
		reagent = "hearthstone",
		tiers = {
			{ 1, 6948, CLASSIC }, -- Hearthstone
		},
	},
	{
		kind = "reagent",
		reagent = "corpse-dust",
		tiers = {
			{ 55, 37201, WRATH }, -- Corpse Dust (Raise Dead)
		},
	},
	{
		-- Gift of the Wild by rank.
		kind = "reagent",
		reagent = "wilds",
		tiers = {
			{ 50, 17021, CLASSIC }, -- Wild Berries
			{ 60, 17026, CLASSIC }, -- Wild Thornroot
			{ 70, 22148, TBC }, -- Wild Quillvine
			{ 80, 44605, WRATH }, -- Wild Spineleaf
		},
	},
	{
		-- Rebirth by rank.
		kind = "reagent",
		reagent = "seeds",
		tiers = {
			{ 20, 17034, CLASSIC }, -- Maple Seed
			{ 30, 17035, CLASSIC }, -- Stranglethorn Seed
			{ 40, 17036, CLASSIC }, -- Ashwood Seed
			{ 50, 17037, CLASSIC }, -- Hornbeam Seed
			{ 60, 17038, CLASSIC }, -- Ironwood Seed
			{ 69, 22147, TBC }, -- Flintweed Seed
			{ 79, 44614, WRATH }, -- Starleaf Seed
		},
	},
	{
		kind = "reagent",
		reagent = "arcane-powder",
		tiers = {
			{ 56, 17020, CLASSIC }, -- Arcane Powder (Arcane Brilliance)
		},
	},
	{
		-- Slow Fall at 12; the priest's Levitate trains at 34. One chain
		-- serves both classes, so the earlier level opens it.
		kind = "reagent",
		reagent = "light-feather",
		tiers = {
			{ 12, 17056, CLASSIC }, -- Light Feather
		},
	},
	{
		kind = "reagent",
		reagent = "rune-of-teleportation",
		tiers = {
			{ 20, 17031, CLASSIC }, -- Rune of Teleportation
		},
	},
	{
		kind = "reagent",
		reagent = "rune-of-portals",
		tiers = {
			{ 40, 17032, CLASSIC }, -- Rune of Portals
		},
	},
	{
		kind = "reagent",
		reagent = "symbol-of-divinity",
		tiers = {
			{ 30, 17033, CLASSIC }, -- Symbol of Divinity (Divine Intervention)
		},
	},
	{
		kind = "reagent",
		reagent = "symbol-of-kings",
		tiers = {
			{ 52, 21177, CLASSIC }, -- Symbol of Kings (Greater Blessings)
		},
	},
	{
		-- Prayer of Fortitude by rank; TBC's prayers reuse the Sacred Candle,
		-- so no TBC tier exists.
		kind = "reagent",
		reagent = "candles",
		tiers = {
			{ 48, 17028, CLASSIC }, -- Holy Candle
			{ 60, 17029, CLASSIC }, -- Sacred Candle
			{ 70, 44615, WRATH }, -- Devout Candle
		},
	},
	{
		kind = "reagent",
		reagent = "thieves-tools",
		tiers = {
			{ 16, 5060, CLASSIC }, -- Thieves' Tools (Pick Lock)
		},
	},
	{
		kind = "reagent",
		reagent = "flash-powder",
		tiers = {
			{ 22, 5140, CLASSIC }, -- Flash Powder (Vanish)
		},
	},
	{
		-- Removed after Classic (Blind lost its reagent), hence the fourth field.
		kind = "reagent",
		reagent = "blinding-powder",
		tiers = {
			{ 34, 6510, CLASSIC, CLASSIC }, -- Blinding Powder (Blind)
		},
	},
	{
		kind = "reagent",
		reagent = "ankh",
		tiers = {
			{ 30, 17030, CLASSIC }, -- Ankh (Reincarnation)
		},
	},
	{
		kind = "reagent",
		reagent = "fish-scales",
		tiers = {
			{ 22, 17057, CLASSIC }, -- Shiny Fish Scales (Water Breathing)
		},
	},
	{
		kind = "reagent",
		reagent = "fish-oil",
		tiers = {
			{ 28, 17058, CLASSIC }, -- Fish Oil (Water Walking)
		},
	},
	{
		kind = "reagent",
		reagent = "earth-totem",
		tiers = {
			{ 4, 5175, CLASSIC }, -- Earth Totem
		},
	},
	{
		kind = "reagent",
		reagent = "fire-totem",
		tiers = {
			{ 10, 5176, CLASSIC }, -- Fire Totem
		},
	},
	{
		kind = "reagent",
		reagent = "water-totem",
		tiers = {
			{ 20, 5177, CLASSIC }, -- Water Totem
		},
	},
	{
		kind = "reagent",
		reagent = "air-totem",
		tiers = {
			{ 30, 5178, CLASSIC }, -- Air Totem
		},
	},
	{
		kind = "reagent",
		reagent = "demonic-figurine",
		tiers = {
			{ 60, 16583, CLASSIC }, -- Demonic Figurine (Ritual of Doom)
		},
	},
	{
		kind = "reagent",
		reagent = "infernal-stone",
		tiers = {
			{ 50, 5565, CLASSIC }, -- Infernal Stone (Inferno)
		},
	},
	{
		kind = "reagent",
		reagent = "soul-shard",
		tiers = {
			{ 10, 6265, CLASSIC }, -- Soul Shard (Drain Soul)
		},
	},

	--[[
        POTIONS -- HAND-CURATED

        The standard Alchemy ladders, taken from ns.RawData.Potions (the
        restore amounts there confirm the ordering: 70/140/280/455/700/1050/
        1500 healing, 140/280/455/700/900/1350/1800 mana). Every non-standard
        potion in that table is deliberately absent -- the Combat, Auchenai,
        Crystal, Ogre Brew, Nethergon, Salve, Draught and Injector variants are
        zone-locked, quest-locked or reward items, and none belongs on a
        ladder a shopping list follows automatically.

        minLevel is item_template.RequiredLevel like every other ladder here,
        but it had to be asked for directly -- potions never appear in an
        npc_vendor query, so the source query above does not reach them:

            SELECT entry, name, ItemLevel, RequiredLevel
            FROM item_template
            WHERE entry IN (118,858,929,1710,3928,13446,22829,33447,
                            2455,3385,3827,6149,13443,13444,22832,33448)
            ORDER BY entry;

        Note the two ladders do NOT step together -- healing goes
        1/3/12/21/35/45/55/70 and mana 5/14/22/31/41/49/55/70 -- so a character
        carrying both will often upgrade one and not the other on the same
        level. That is correct, not a rounding error in this table.

        Runic Healing and Runic Mana are Wrath items and are NOT in
        ns.RawData.Potions, which stops at TBC like the rest of the add-on.
        They are inert on both shipping clients and are here for the day that
        changes.
    ]]
	{
		kind = "healing-potion",
		tiers = {
			{ 1, 118, CLASSIC }, -- Minor Healing Potion
			{ 3, 858, CLASSIC }, -- Lesser Healing Potion
			{ 12, 929, CLASSIC }, -- Healing Potion
			{ 21, 1710, CLASSIC }, -- Greater Healing Potion
			{ 35, 3928, CLASSIC }, -- Superior Healing Potion
			{ 45, 13446, CLASSIC }, -- Major Healing Potion
			{ 55, 22829, TBC }, -- Super Healing Potion
			{ 70, 33447, WRATH }, -- Runic Healing Potion
		},
	},
	{
		kind = "mana-potion",
		tiers = {
			{ 5, 2455, CLASSIC }, -- Minor Mana Potion
			{ 14, 3385, CLASSIC }, -- Lesser Mana Potion
			{ 22, 3827, CLASSIC }, -- Mana Potion
			{ 31, 6149, CLASSIC }, -- Greater Mana Potion
			{ 41, 13443, CLASSIC }, -- Superior Mana Potion
			{ 49, 13444, CLASSIC }, -- Major Mana Potion
			{ 55, 22832, TBC }, -- Super Mana Potion
			{ 70, 33448, WRATH }, -- Runic Mana Potion
		},
	},
}
