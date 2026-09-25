local _, ns = ...

--[[
    Source: Validate Data on the TBC Anniversary client (2.5.6, build 69795).

    SELECT
        CONCAT('    [', s.entry, '] = {', (st.EffectBasePoints1 + 1),
               ', ', s.RequiredLevel, '}, -- ', s.name) AS `RAW_DATA`
    FROM (
        SELECT entry, name, RequiredLevel, spellid_1 AS spellid, spellcategory_1 AS cat FROM item_template
        UNION ALL SELECT entry, name, RequiredLevel, spellid_2, spellcategory_2 FROM item_template
        UNION ALL SELECT entry, name, RequiredLevel, spellid_3, spellcategory_3 FROM item_template
        UNION ALL SELECT entry, name, RequiredLevel, spellid_4, spellcategory_4 FROM item_template
        UNION ALL SELECT entry, name, RequiredLevel, spellid_5, spellcategory_5 FROM item_template
    ) s
    JOIN spell_template st ON st.Id = s.spellid
    WHERE s.cat > 0
      AND s.cat IN (
            SELECT cat FROM (
                SELECT spellcategory_1 AS cat FROM item_template WHERE entry = 32578
                UNION ALL SELECT spellcategory_2 FROM item_template WHERE entry = 32578
                UNION ALL SELECT spellcategory_3 FROM item_template WHERE entry = 32578
                UNION ALL SELECT spellcategory_4 FROM item_template WHERE entry = 32578
                UNION ALL SELECT spellcategory_5 FROM item_template WHERE entry = 32578
            ) src WHERE cat > 0
      )
      AND st.Effect1 = 10            -- SPELL_EFFECT_HEAL (flat direct heal)
      AND st.EffectBasePoints1 > 0
      AND s.entry NOT IN (
            30347,   -- Alexander's Test Healthstone
            43657    -- Royal Guide of Escape Routes
      )
    ORDER BY (st.EffectBasePoints1 + 1) DESC, s.RequiredLevel DESC, s.entry DESC;

]]
-- [ID] = {Healthstone Amount, Required Level}, -- Name
ns.HEALTHSTONES = {
	[22105] = { 2496, 60 }, -- Master Healthstone
	[22104] = { 2288, 60 }, -- Master Healthstone
	[22103] = { 2080, 60 }, -- Master Healthstone
	[32578] = { 2000, 0 }, -- Charged Crystal Focus
	[19013] = { 1440, 48 }, -- Major Healthstone
	[19012] = { 1320, 48 }, -- Major Healthstone
	[9421] = { 1200, 48 }, -- Major Healthstone
	[15723] = { 1050, 50 }, -- Tea with Sugar
	[19011] = { 960, 36 }, -- Greater Healthstone
	[19010] = { 880, 36 }, -- Greater Healthstone
	[5510] = { 800, 36 }, -- Greater Healthstone
	[11951] = { 700, 45 }, -- Whipper Root Tuber
	[19009] = { 600, 24 }, -- Healthstone
	[19008] = { 550, 24 }, -- Healthstone
	[14894] = { 525, 0 }, -- Lily Root
	[5509] = { 500, 24 }, -- Healthstone
	[19007] = { 300, 12 }, -- Lesser Healthstone
	[19006] = { 275, 12 }, -- Lesser Healthstone
	[5511] = { 250, 12 }, -- Lesser Healthstone
	[19005] = { 120, 1 }, -- Minor Healthstone
	[19004] = { 110, 1 }, -- Minor Healthstone
	[5512] = { 100, 1 }, -- Minor Healthstone
	[5205] = { 71, 5 }, -- Sprouted Frond
	[23329] = { 18, 0 }, -- Enriched Lasher Root
}
