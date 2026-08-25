local _, ns = ...
ns.RawData = ns.RawData or {}

--[[

SELECT 
    CONCAT(
        '    [', it.entry, '] = {', 
        
        -- Calculates the instant mana restore amount
        (st.EffectBasePoints1 + 1), 
        
        '}, -- ', it.name
    ) AS `ns.RawData.ManaGem`
FROM item_template it
-- Failsafe: Joins on spellid_1, but seamlessly falls back to spellid_2 if slot 1 is blank
JOIN spell_template st ON st.Id = COALESCE(NULLIF(it.spellid_1, 0), NULLIF(it.spellid_2, 0))
WHERE it.name IN (
    'Mana Agate', 
    'Mana Jade', 
    'Mana Citrine', 
    'Mana Ruby', 
    'Mana Emerald', 
    'Mana Sapphire'
)
  -- Garbage collector for any weird [PH] or test server gems
  AND st.EffectBasePoints1 > 0 
ORDER BY 
    (st.EffectBasePoints1 + 1) DESC, 
    it.entry DESC;

]]

ns.RawData.ManaGem = {
	-- [ID] = {Mana Amount, {Allowed Zones}}, -- Name
	[33312] = { 3330 }, -- Mana Sapphire
	[22044] = { 2340 }, -- Mana Emerald
	[8008] = { 1073 }, -- Mana Ruby
	[8007] = { 829 }, -- Mana Citrine
	[5513] = { 585 }, -- Mana Jade
	[5514] = { 390 }, -- Mana Agate
}

--[[
    Conjure-spell ID → conjured-item IDs, shared across data files (see
    also Healthstones.lua). Conjured stones are unique in bags, so
    GetSmartSpell consults this when called with checkUnique to skip a
    rank whose item the player already holds — the macro then conjures
    the next rank down instead of failing on a duplicate. Values are
    lists; each Mana Gem spell produces exactly one item.
]]
ns.ConjuredItemIDsBySpell = ns.ConjuredItemIDsBySpell or {}

ns.ConjuredItemIDsBySpell[42985] = { 33312 } -- Conjure Mana Sapphire
ns.ConjuredItemIDsBySpell[27101] = { 22044 } -- Conjure Mana Emerald
ns.ConjuredItemIDsBySpell[10054] = { 8008 } -- Conjure Mana Ruby
ns.ConjuredItemIDsBySpell[10053] = { 8007 } -- Conjure Mana Citrine
ns.ConjuredItemIDsBySpell[3552] = { 5513 } -- Conjure Mana Jade
ns.ConjuredItemIDsBySpell[759] = { 5514 } -- Conjure Mana Agate
