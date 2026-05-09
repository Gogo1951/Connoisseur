local _, ns = ...
ns.RawData = ns.RawData or {}

-- SELECT entry, name FROM item_template
-- WHERE name LIKE '%Healthstone%'
-- ORDER BY entry;
-- Heal Amount derived from the heal spell on item_template.spellid_1.
ns.RawData.Healthstone = {
    -- [ID] = {Healthstone Amount, {Allowed Zones}}, -- Name

    [19011] = {960}, -- Greater Healthstone
    [19010] = {880}, -- Greater Healthstone
    [5510] = {800}, -- Greater Healthstone
    [19009] = {600}, -- Healthstone
    [19008] = {550}, -- Healthstone
    [5509] = {500}, -- Healthstone
    [19007] = {300}, -- Lesser Healthstone
    [19006] = {275}, -- Lesser Healthstone
    [5511] = {250}, -- Lesser Healthstone
    [19013] = {1440}, -- Major Healthstone
    [19012] = {1320}, -- Major Healthstone
    [9421] = {1200}, -- Major Healthstone
    [22105] = {2496}, -- Master Healthstone
    [22104] = {2288}, -- Master Healthstone
    [22103] = {2080}, -- Master Healthstone
    [19005] = {120}, -- Minor Healthstone
    [19004] = {110}, -- Minor Healthstone
    [5512] = {100} -- Minor Healthstone
}