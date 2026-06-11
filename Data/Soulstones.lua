local _, ns = ...
ns.RawData = ns.RawData or {}

--[[
    SELECT entry, name FROM item_template
    WHERE name LIKE '%Soulstone%'
    ORDER BY entry;

    Rank Value: the stone's resurrection health, used as a sortable
    preference score (Minor < Lesser < Soulstone < Greater < Major <
    Master < Demonic).
]]
ns.RawData.Soulstone = {
    -- [ID] = {Rank Value}, -- Name
    [36895] = {5300}, -- Demonic Soulstone
    [22116] = {2900}, -- Master Soulstone
    [16896] = {2200}, -- Major Soulstone
    [16895] = {1600}, -- Greater Soulstone
    [16893] = {1100}, -- Soulstone
    [16892] = {750}, -- Lesser Soulstone
    [5232] = {400}, -- Minor Soulstone
}

--[[
    No conjure-downgrade map here, on purpose (compare Healthstones.lua
    and Mana-Gems.lua): soulstones share a 30-minute use cooldown that
    matches the buff duration, so only one stone can ever be deployed at
    a time — conjuring a lower rank while holding the best one would
    just waste a soul shard. The Soulstone resolver therefore runs with
    checkUnique=false and always offers the best known conjure.
]]