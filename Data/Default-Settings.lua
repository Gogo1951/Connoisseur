local _, ns = ...

--------------------------------------------------------------------------------
-- Database Defaults
--------------------------------------------------------------------------------

--[[
    The single AceDB-3.0 defaults table. Features/Core.lua passes this to
    AceDB:New, which applies the defaults itself -- there is no hand-rolled
    merge. Scalar and table defaults are physically copied into the saved
    table (copyDefaults via rawset) when a scope is first accessed; only
    */** wildcard defaults resolve through a metatable. An explicit user
    value, including false, is never overridden either way.

    Almost everything the user configures lives under `profile`, so it is
    per-character: each character gets its own "Name - Realm" profile and can
    run a different set of consumables. That is the point -- a level-15 alt and
    a raiding 60 want different buff food, and two Rogues want their own poison
    pairs. The stock Profiles panel (Options/Options-Profiles.lua) is therefore
    meaningful: switching, copying, or resetting a profile moves real settings.

    What stays under `global` (account-wide), each for a concrete reason rather
    than convenience:
      * showWelcome    -- one login greeting per account, not per character.
      * showMacroNames -- a client-wide action-bar appearance tweak.
      * readinessReportEnabled -- a behaviour preference (does Connoisseur speak
                          up on a ready check?) rather than a consumable choice.
      * enabledMacros  -- the macros themselves are account-wide: they live in
                          the shared General macro tab, so which ones exist has
                          to be one choice for the whole account. Keeping the
                          setting here means the two agree -- a character switch
                          never adds or removes a macro, it only rewrites the
                          shared bodies to that character's best items.
      * minimap        -- LibDBIcon reads this subtable directly and owns its
                          contents (position etc.), so keeping it off the
                          profile means switching, resetting, or deleting a
                          profile never moves the minimap button.
      * ignoreList     -- the account-wide half of the Ignore List, hiding an
                          item from every character's macros at once; the
                          per-character half keeps the same key on the profile,
                          and Features/Ignore-List.lua reads both.
      * readiness*     -- the per-category switches under
                          readinessReportEnabled, each answered once for the
                          account like the master toggle above it. Their own
                          reasons are on the keys.
      * restocker      -- the Restock List subsystem, account-wide in full. Its
                          reason is on the key itself.

    The derived item cache (itemCache / itemCacheVersion) is deliberately NOT
    declared here: Core lazy-inits it on the profile and owns its version-stamp
    invalidation, so it never needs a default.
]]
--[[
    Retired saved keys, cleared out of every saved file. Two eras are in here.

    The readyCheck* set is the Ready Check report's own switches, retired when
    it became the Readiness Report: its sections were re-cut rather than renamed
    -- several switches split, one was dropped, and the defaults changed -- so
    nothing there maps onto a new key.

    readinessReport is the Readiness Report's first master switch, retired when
    the report became opt-in. It has to be cleared rather than reused: AceDB
    copies scalar defaults into the saved table, so it already sits as true in
    every existing saved file, and reading that back would switch the report on
    for exactly the players the soft launch keeps it off for. Its replacement is
    readinessReportEnabled below.

    Features/Core.lua nils them all at the same point it clears the Restocker's
    own retired keys.

    Delete this list once no saved file can still be carrying them.
]]
ns.RETIRED_READY_CHECK_KEYS = {
	"readyCheckReport",
	"readyCheckHealthstone",
	"readyCheckHealthPotion",
	"readyCheckManaPotion",
	"readyCheckScrolls",
	"readyCheckWellFed",
	"readyCheckPetFood",
	"readyCheckBuffTimes",
	"readyCheckSoulstone",
	"readyCheckManaGem",
	"readyCheckBandage",
	"readinessReport",
}

ns.DATABASE_DEFAULTS = {
	profile = {
		ignoreList = {},
		combineHealthstones = false,
		--[[
		    Early re-application: with earlyReapply on, a food/scroll/pet buff
		    whose remaining time is under earlyReapplyThreshold (seconds)
		    counts as already expired, so the macros offer a fresh application
		    before a pull. See BuffCountsAsActive in Scanner-Character.lua.
		]]
		earlyReapply = false,
		earlyReapplyThreshold = 120,
		useBuffFood = false,
		buffFoodMode = "always",
		useScrolls = false,
		scrollsMode = "always",
		scrollTypes = {
			Agility = true,
			Intellect = true,
			Protection = true,
			Spirit = true,
			Stamina = true,
			Strength = true,
		},
		--[[
		    Off by default, like every other opt-in feature here. Pet buff food
		    is a min-maxer's tool -- it needs level 55+, a live pet, and a
		    steady supply of Kibler's Bits or Sporeling Snacks -- so a new user
		    should never meet it uninvited. Leave this false.
		]]
		usePetBuffFood = false,
		petBuffFoodMode = "always",
		petBuffTypes = {
			KiblersBits = true,
			SporelingSnacks = true,
		},
		--[[
		    Explosive macro click layout: "atplayer" fires [@player] on
		    left-click and the standard toss on right-click; "toss" swaps
		    the buttons. See BuildExplosiveUseLine in Features/Macros/Explosive.lua.
		]]
		explosivesClickMode = "atplayer",
		enableDruidMacroHelper = false,
		druidReturnForm = "bear",
		enableShadowmeldDrinking = false,
		--[[
		    Stealth Eating appends the character's stealth ability to the Food
		    macro -- Stealth for Rogues, Shadowmeld for other Night Elves. One
		    key serves both; the class/race gate lives in Food.lua's appendBlock.
		    Per-character, so a Night Elf Druid enabling it no longer switches
		    it on for the account's Rogues.
		]]
		enableStealthEating = false,
		--[[
		    Rogue poison groups per weapon slot, keyed by ns.PoisonGroupBaseItems
		    group IDs (4 = Instant Poison). See Data/Poisons.lua.
		]]
		mainHandPoisonGroup = 4,
		offHandPoisonGroup = 4,
	},
	global = {
		ignoreList = {},
		showWelcome = true,
		--[[
		    The Restock List subsystem, account-wide in full. None of it is an
		    AceDB profile: `profiles` here are the player's own named shopping
		    lists and `profileKeys` maps a character to the one it uses, so the
		    stock Reset Profile control must never reach them. Putting them on
		    global is what guarantees that -- a profile switch or reset cannot
		    empty a hand-built list or re-offer the Starter List to a character
		    that already answered it.

		    The two reminder modes differ on purpose: in town you are away from
		    your bags and the detail is the whole point, while at a merchant or
		    a bank you are already looking at the window that fixes it.
		]]
		restocker = {
			profiles = {},
			profileKeys = {},
			starterListDismissed = {},
			framePos = {},
			restockReminderChat = true,
			restockReminderSound = true,
			restockReminderMode = "verbose",
			merchantReminder = true,
			merchantReminderMode = "simple",
			bankReminder = true,
			bankReminderMode = "simple",
			autoOpenAtBank = false,
			autoOpenAtMerchant = false,
		},
		--[[
		    Macro-name text on the default action bars. Off by default so the
		    add-on hides the names Blizzard recently began showing again; the
		    "Enable Macro Names on Buttons" toggle is its inverse (see
		    Features/Action-Button-Text.lua).
		]]
		showMacroNames = false,
		--[[
		    The Readiness Report: on a ready check, one private print naming what
		    still needs fixing. A behaviour preference -- whether you want
		    Connoisseur speaking up at all -- rather than a consumable choice, so
		    it is answered once for the account rather than per character, and so
		    is every category switch under it.

		    Silence is the report's normal output: a category with nothing wrong
		    prints nothing, and a clean character prints nothing at all. That is
		    what lets it cover this much without becoming noise, so a switch here
		    should only ever be able to ADD a line about something broken.

		    Beta soft launch: the report ships OFF and every player opts in. The
		    key is deliberately a NEW one rather than the retired readinessReport
		    -- that name already sits as true in every existing saved file, so
		    re-using it would read the old value back and switch the report on for
		    everyone who already has the add-on. See ns.RETIRED_READY_CHECK_KEYS
		    above, which is what clears it.
		]]
		readinessReportEnabled = false,
		--[[
		    Which categories the report covers. Each is answered once for the
		    account, like the master toggle above, and every one of them is dead
		    while readinessReportEnabled is off.

		    Three ship ON, and they share a reason: each is something another
		    player standing next to you can fix inside the few seconds a ready
		    check gives you. A Warlock can hand you a stone, a Warlock can put a
		    soulstone up, and a Mage conjures their own gem. Every one of them
		    also self-gates on the class being present, so none of the three can
		    nag at a group that cannot answer it.

		    Everything else ships OFF. A report that fires on a fresh install for
		    things the player never asked about is one they switch off entirely
		    rather than tune, and the switches are cheap to find once they go
		    looking. The two potions especially: mid-pull an empty potion slot is
		    not something anyone can act on.
		]]
		-- Missing Buffs
		readinessFlask = false,
		readinessWellFed = false,
		readinessPetWellFed = false,
		readinessScrolls = false,
		readinessSoulstone = true,
		readinessMainHandBuff = false,
		readinessOffHandBuff = false,
		--[[
		    Buffs about to lapse, in seconds. Distinct from the Macros panel's
		    Buff Re-Application threshold, which decides when the MACROS treat a
		    buff as spent: this one only decides when the report mentions one,
		    covers every aura on the character rather than the tracked ones, and
		    reaches further out because a raid leader's pull timer is longer than
		    a macro press.
		]]
		readinessExpiring = false,
		readinessExpiringThreshold = 150,

		-- Missing Items
		readinessHealthstone = true,
		readinessManaGem = true,
		readinessHealingPotion = false,
		readinessManaPotion = false,
		readinessBandages = false,
		--[[
		    Percent, compared against the LOWEST equipped item rather than an
		    average: one weapon at 5% is the thing that breaks mid-pull, and an
		    average hides it behind seventeen healthy pieces.
		]]
		readinessDurability = false,
		readinessDurabilityThreshold = 20,

		-- Character
		readinessSpec = false,
		readinessPvP = false,
		readinessQuestionableGear = false,
		--[[
		    Which macros Connoisseur maintains. Account-wide because the macros
		    are: they live in the shared General macro tab, so unchecking one
		    removes the shared macro for every character. Feed Pet and Poisons
		    are class-gated on top of this toggle and build only for Hunters and
		    Rogues; the conjure-capable macros (Healthstone, Mana Gem,
		    Soulstone) are built for every class, with only their conjure clicks
		    class-gated.
		]]
		enabledMacros = {
			["Bandage"] = true,
			["Explosive"] = true,
			["Feed Pet"] = true,
			["Food"] = true,
			["Health Potion"] = true,
			["Healthstone"] = true,
			["Mana Gem"] = true,
			["Mana Potion"] = true,
			["Poisons"] = true,
			["Soulstone"] = true,
			["Water"] = true,
		},
		--[[
		    Minimap button visibility. LibDBIcon reads `hide` from this subtable,
		    so it stays the single source of truth -- the "Enable Minimap Button"
		    toggle is its inverse (hide = false means shown). LibDBIcon owns the
		    rest of the subtable (position, etc.); living under `global`, it is
		    untouched by profile switches and resets.
		]]
		minimap = {
			hide = false,
		},
	},
}
