local _, ns = ...

--------------------------------------------------------------------------------
-- Database Defaults
--------------------------------------------------------------------------------

--[[
    The single AceDB-3.0 defaults table. Features/Core.lua passes this to
    AceDB:New, which applies the defaults via metatables -- there is no
    hand-rolled merge and no per-scope copy step.

    Everything the user configures lives under `profile`, so it follows the
    active profile (and the shared Default profile keeps settings account-wide
    until a character opts into its own). The only thing outside the profile is
    `global.minimap`, which is account-level and profile-independent so
    switching, resetting, or deleting profiles never moves the minimap button
    (LibDBIcon reads its `hide` flag directly).

    The derived item cache (itemCache / itemCacheVersion) is deliberately NOT
    declared here: Core lazy-inits it on the profile and owns its version-stamp
    invalidation, so it never needs a default.
]]
ns.DATABASE_DEFAULTS = {
    profile = {
        showWelcome = true,
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
            Strength = true
        },
        --[[
            Explosive macro click layout: "atplayer" fires [@player] on
            left-click and the standard toss on right-click; "toss" swaps
            the buttons. See BuildExplosiveUseLine in Macro-Builder-General.
        ]]
        explosivesClickMode = "atplayer",
        enableShadowmeldDrinking = false,
        combineHealthstones = false,
        enableDruidMacroHelper = false,
        druidReturnForm = "bear",
        usePetBuffFood = false,
        petBuffFoodMode = "always",
        petBuffTypes = {
            KiblersBits = true,
            SporelingSnacks = true
        },
        --[[
            Macro enablement follows the active profile. The macros live in the
            shared General macro tab, so which ones Connoisseur maintains is a
            per-profile choice; unchecking one removes the shared macro. Class-
            gated macros (Feed Pet, conjures) still build only for the right
            class regardless of the toggle.
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
            ["Soulstone"] = true,
            ["Water"] = true
        },
        ignoreList = {}
    },
    global = {
        --[[
            Minimap button visibility. LibDBIcon reads `hide` from this subtable,
            so it stays the single source of truth -- the "Enable Minimap Button"
            toggle is its inverse (hide = false means shown). LibDBIcon owns the
            rest of the subtable (position, etc.), which ResetAllProfiles snapshots
            and restores so the button keeps its placement across resets.
        ]]
        minimap = {
            hide = false
        }
    }
}
