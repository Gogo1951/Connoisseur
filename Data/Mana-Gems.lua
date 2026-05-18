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
    [33312] = {3330}, -- Mana Sapphire
    [22044] = {2340}, -- Mana Emerald
    [8008] = {1073}, -- Mana Ruby
    [8007] = {829}, -- Mana Citrine
    [5513] = {585}, -- Mana Jade
    [5514] = {390}, -- Mana Agate
}

--[[
    Conjure-spell ID → conjured-item ID. Mana Gems are unique-equipped, so
    GetSmartSpell consults this to skip a rank whose item the mage already
    holds — a second press conjures the next rank down instead of failing
    on a duplicate.
]]
ns.ConjuredManaGemItemIDBySpell = {
    [27101] = 22044, -- Conjure Mana Emerald
    [10054] = 8008, -- Conjure Mana Ruby
    [10053] = 8007, -- Conjure Mana Citrine
    [3552] = 5513, -- Conjure Mana Jade
    [759] = 5514, -- Conjure Mana Agate
}