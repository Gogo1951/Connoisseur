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

    Five things stay under `global` (account-wide), each for a concrete reason
    rather than convenience:
      * showWelcome    -- one login greeting per account, not per character.
      * showMacroNames -- a client-wide action-bar appearance tweak.
      * readyCheckReport -- a behaviour preference (does Connoisseur speak up on
                          a ready check?) rather than a consumable choice.
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

    The derived item cache (itemCache / itemCacheVersion) is deliberately NOT
    declared here: Core lazy-inits it on the profile and owns its version-stamp
    invalidation, so it never needs a default.
]]
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
		showWelcome = true,
		--[[
            Macro-name text on the default action bars. Off by default so the
            add-on hides the names Blizzard recently began showing again; the
            "Enable Macro Names on Buttons" toggle is its inverse (see
            Features/Action-Button-Text.lua).
        ]]
		showMacroNames = false,
		--[[
            Ready-check self-audit: prints one player-only line naming what is
            missing and how long the tracked buffs have left. Reports on the
            same buffs earlyReapplyThreshold governs, but is itself a behaviour
            preference -- whether you want Connoisseur speaking up at all -- so
            it is answered once for the account rather than per character.
        ]]
		readyCheckReport = true,
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
