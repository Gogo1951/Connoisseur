local _, ns = ...

--------------------------------------------------------------------------------
-- Database Defaults
--------------------------------------------------------------------------------

--[[
    The single AceDB-3.0 defaults table. Features/Core.lua passes this to
    AceDB:New, which applies the defaults via metatables -- there is no
    hand-rolled merge and no per-scope copy step.

    Everything the user configures lives under `global`, so it is account-wide:
    set once on any character, it applies on all of them. Each character still
    gets its own "Name - Realm" profile, and the only thing that lives there is
    the Ignore List -- genuinely per-character state, so one character can mute
    a food item without muting it everywhere.

    `global.minimap` is account-level for the same reason as the settings, so
    switching, resetting, or deleting profiles never moves the minimap button
    (LibDBIcon reads its `hide` flag directly).

    The derived item cache (itemCache / itemCacheVersion) is deliberately NOT
    declared here: Core lazy-inits it on the profile and owns its version-stamp
    invalidation, so it never needs a default.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		ignoreList = {},
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
		useBuffFood = false,
		buffFoodMode = "always",
		--[[
            Early re-application: with earlyReapply on, a food/scroll/pet buff
            whose remaining time is under earlyReapplyThreshold (seconds)
            counts as already expired, so the macros offer a fresh application
            before a pull. See BuffCountsAsActive in Scanner-Character.lua.
        ]]
		earlyReapply = false,
		earlyReapplyThreshold = 120,
		--[[
            Ready-check self-audit: prints one player-only line naming what is
            missing and how long the tracked buffs have left. Reports on the
            same buffs the threshold above governs. See Features/Readiness.lua.
        ]]
		readyCheckReport = true,
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
            Explosive macro click layout: "atplayer" fires [@player] on
            left-click and the standard toss on right-click; "toss" swaps
            the buttons. See BuildExplosiveUseLine in Features/Macros/Explosive.lua.
        ]]
		explosivesClickMode = "atplayer",
		enableShadowmeldDrinking = false,
		--[[
            Stealth Eating appends the character's stealth ability to the Food
            macro -- Stealth for Rogues, Shadowmeld for other Night Elves. One
            key serves both; the class/race gate lives in Food.lua's appendBlock.
        ]]
		enableStealthEating = false,
		combineHealthstones = false,
		enableDruidMacroHelper = false,
		druidReturnForm = "bear",
		usePetBuffFood = false,
		petBuffFoodMode = "always",
		--[[
            Rogue poison groups per weapon slot, keyed by ns.PoisonGroupBaseItems
            group IDs (4 = Instant Poison). See Data/Poisons.lua.
        ]]
		mainHandPoisonGroup = 4,
		offHandPoisonGroup = 4,
		petBuffTypes = {
			KiblersBits = true,
			SporelingSnacks = true,
		},
		--[[
            Macro enablement is account-wide. The macros live in the shared
            General macro tab, so which ones Connoisseur maintains is one choice
            for the whole account; unchecking one removes the shared macro.
            Class-gated macros (Feed Pet, conjures) still build only for the
            right class regardless of the toggle.
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
