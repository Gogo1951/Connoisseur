local _, ns = ...

--------------------------------------------------------------------------------
-- Mage Conjure Resolvers
--------------------------------------------------------------------------------

--[[
    Each resolver returns a table describing how the corresponding macro
    should compose its right-click (/btn:2) and middle-click (/btn:3)
    conjure slots — or, when the relevant spell isn't yet learned, which
    ConnTip key to fire on that click so the player understands the macro
    will gain functionality at the right level.

    See Macro-Builder-General.lua's ConjureResolvers table for the full
    protocol. Returning nil means "this macro has no conjure semantics for
    this character" — appropriate for non-mage classes.
]]

ns.ConjureResolvers = ns.ConjureResolvers or {}

--[[
    Water and Food share a middle-click slot (Refreshment Table) so the
    branching is identical except for which "primary" conjure category
    drives the right-click slot.
]]
local function ResolveWaterOrFood(rightList, rightMissKey)
    if not ns.IsMage then return nil end

    local info = {}

    if ns.KnowsAny(rightList) then
        info.rightName, info.rightID = ns.GetSmartSpell(rightList)
    else
        --[[
            Mage who can theoretically learn this — print a tip on
            right-click (and also on left-click when bags are empty).
        ]]
        info.rightMiss = rightMissKey
        info.noItemMiss = rightMissKey
    end

    --[[
        Middle-click: Ritual of Refreshment is a level-70 ability (Rank 2
        at 80 in Wrath). The table serves the whole raid, so ignoreTarget
        keeps a low-level friendly target from downranking it, and the
        unpinned /cast always fires the highest rank known. If the mage
        hasn't learned it yet AND the spell exists on this client, the
        middle-click prints "you don't know Ritual of Refreshment." On
        clients where the spell isn't implemented (Era 1.15), the tip
        resolves to nil at print time and silently does nothing.
    ]]
    if ns.KnowsAny(ns.ConjureSpells.MageCreateTable) then
        info.middleName, info.middleID = ns.GetSmartSpell(ns.ConjureSpells.MageCreateTable, true)
    else
        info.middleMiss = "nctable"
    end

    return info
end

ns.ConjureResolvers["Water"] = function()
    return ResolveWaterOrFood(ns.ConjureSpells.MageCreateWater, "ncwater")
end

ns.ConjureResolvers["Food"] = function()
    return ResolveWaterOrFood(ns.ConjureSpells.MageCreateFood, "ncfood")
end

--[[
    Mana Gem: single conjure slot on right-click. Unique-equipped items
    mean GetSmartSpell needs checkUnique=true so a second press conjures
    the next rank down rather than failing on a duplicate.
]]
ns.ConjureResolvers["Mana Gem"] = function()
    if not ns.IsMage then return nil end

    local info = {}
    if ns.KnowsAny(ns.ConjureSpells.MageCreateManaGem) then
        info.rightName, info.rightID = ns.GetSmartSpell(ns.ConjureSpells.MageCreateManaGem, true, true)
    else
        info.rightMiss = "ncgem"
        --[[
            Mana Gems are class-exclusive; a mage without the spell almost
            certainly has no Mana Gem in bags either, so left-click should
            explain that rather than the generic "no item found" message.
        ]]
        info.noItemMiss = "ncgem"
    end
    return info
end
