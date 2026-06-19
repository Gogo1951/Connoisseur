local _, ns = ...

--------------------------------------------------------------------------------
-- Default Settings
--------------------------------------------------------------------------------

--[[
    Per-character default configuration, applied as an additive merge by
    InitVars / ResetSettings in Features/Core.lua (nil fields filled, explicit
    user values never overwritten).
]]
ns.DEFAULT_CONFIGURATION = {
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
    enableShadowmeldDrinking = false,
    enableDruidMacroHelper = false,
    druidReturnForm = "bear",
    usePetBuffFood = false,
    petBuffFoodMode = "always",
    petBuffTypes = {
        KiblersBits = true,
        SporelingSnacks = true
    }
}

--------------------------------------------------------------------------------
-- Account Default Settings
--------------------------------------------------------------------------------

--[[
    Account-wide defaults (shared across every character), applied to
    ConnoisseurDB on init by the same additive ApplyDefaults merge (nil fields
    only, saved values preserved) that fills ns.DEFAULT_CONFIGURATION into the
    per-character ConnoisseurCharDB.settings. Separate table because these live
    in the account-scope SavedVariable.
]]
ns.DEFAULT_ACCOUNT_CONFIGURATION = {
    showWelcome = true,
    --[[
        Minimap button visibility. LibDBIcon reads `hide` from this subtable, so
        it stays the single source of truth -- the "Enable Minimap Button"
        toggle is its inverse (hide = false means shown). Only `hide` is seeded;
        LibDBIcon owns the rest of the subtable (position, etc.), which
        ResetSettings preserves so the button keeps its placement across resets.
    ]]
    minimap = {
        hide = false
    },
    --[[
        Macro enablement is account-wide: the macros live in the shared General
        macro tab, so which ones Connoisseur maintains is an account-level
        choice, not per-character. Unchecking one removes the shared macro for
        every character. Class-gated macros (Feed Pet, conjures) still build
        only for the right class regardless of the toggle.
    ]]
    enabledMacros = {
        ["Bandage"] = true,
        ["Feed Pet"] = true,
        ["Food"] = true,
        ["Health Potion"] = true,
        ["Healthstone"] = true,
        ["Mana Gem"] = true,
        ["Mana Potion"] = true,
        ["Soulstone"] = true,
        ["Water"] = true
    }
}
