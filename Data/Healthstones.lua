local _, ns = ...
ns.RawData = ns.RawData or {}

--[[

SELECT 
    CONCAT(
        '    [', it.entry, '] = {', 
        
        -- Calculates the instant heal amount perfectly from spellid_2
        (st.EffectBasePoints1 + 1), 
        
        ', ', it.RequiredLevel, 
        
        '}, -- ', it.name
    ) AS `ns.RawData.Healthstone`
FROM item_template it
JOIN spell_template st ON it.spellid_2 = st.Id
WHERE it.class = 0 
  AND it.name LIKE '%Healthstone%'
  AND it.spellid_2 > 0
  AND st.EffectBasePoints1 > 0 
  -- Filters out Alexander's Test Healthstone
  AND it.entry != 30347 
ORDER BY 
    -- Sorts by the largest heal amount first, grouping Master down to Minor
    (st.EffectBasePoints1 + 1) DESC, 
    it.RequiredLevel DESC,
    it.entry DESC;

]]

ns.RawData.Healthstone = {
    -- [ID] = {Healthstone Amount, Required Level, {Allowed Zones}}, -- Name

    [36894] = {5136, 69}, -- Fel Healthstone
    [36893] = {4708, 69}, -- Fel Healthstone
    [36892] = {4280, 69}, -- Fel Healthstone
    [36891] = {4200, 63}, -- Demonic Healthstone
    [36890] = {3850, 63}, -- Demonic Healthstone
    [36889] = {3500, 63}, -- Demonic Healthstone
    [22105] = {2496, 60}, -- Master Healthstone
    [22104] = {2288, 60}, -- Master Healthstone
    [22103] = {2080, 60}, -- Master Healthstone
    [19013] = {1440, 48}, -- Major Healthstone
    [19012] = {1320, 48}, -- Major Healthstone
    [9421] = {1200, 48}, -- Major Healthstone
    [19011] = {960, 36}, -- Greater Healthstone
    [19010] = {880, 36}, -- Greater Healthstone
    [5510] = {800, 36}, -- Greater Healthstone
    [19009] = {600, 24}, -- Healthstone
    [19008] = {550, 24}, -- Healthstone
    [5509] = {500, 24}, -- Healthstone
    [19007] = {300, 12}, -- Lesser Healthstone
    [19006] = {275, 12}, -- Lesser Healthstone
    [5511] = {250, 12}, -- Lesser Healthstone
    [19005] = {120, 1}, -- Minor Healthstone
    [19004] = {110, 1}, -- Minor Healthstone
    [5512] = {100, 1}, -- Minor Healthstone
}