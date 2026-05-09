local _, ns = ...
ns.RawData = ns.RawData or {}

-- SELECT entry, name FROM item_template
-- WHERE name LIKE '%Soulstone%'
-- ORDER BY entry;
-- Rank Value: hand-curated tier score (Minor < Lesser < Soulstone <
-- Greater < Major < Master), used as a sortable preference order.
ns.RawData.Soulstone = {
    -- [ID] = {Rank Value}, -- Name

    [5232] = {400}, -- Minor Soulstone
    [16892] = {750}, -- Lesser Soulstone
    [16893] = {1100}, -- Soulstone
    [16895] = {1600}, -- Greater Soulstone
    [16896] = {2200}, -- Major Soulstone
    [22116] = {2900} -- Master Soulstone
}