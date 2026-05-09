local _, ns = ...
ns.RawData = ns.RawData or {}

-- SELECT entry, name FROM item_template
-- WHERE entry IN (5513, 5514, 8007, 8008, 22044)
-- ORDER BY entry;
-- Mana Amount derived from the restore-mana spell on
-- item_template.spellid_1.
ns.RawData.ManaGem = {
    -- [ID] = {Mana Amount, {Allowed Zones}}, -- Name

    [5514] = {390}, -- Mana Agate
    [5513] = {585}, -- Mana Jade
    [8007] = {829}, -- Mana Citrine
    [8008] = {1073}, -- Mana Ruby
    [22044] = {2340} -- Mana Emerald
}