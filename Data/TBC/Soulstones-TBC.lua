local _, ns = ...

-- TODO: Add SQL Query
--[[
    Source: Validate Data on the TBC Anniversary client (2.5.6, build 69795).

    Rank Value: the stone's resurrection health, used as a sortable
    preference score (Minor < Lesser < Soulstone < Greater < Major <
    Master).
]]
-- [ID] = {Rank Value}, -- Name
ns.SOULSTONES = {
	[22116] = { 2900 }, -- Master Soulstone
	[16896] = { 2200 }, -- Major Soulstone
	[16895] = { 1600 }, -- Greater Soulstone
	[16893] = { 1100 }, -- Soulstone
	[16892] = { 750 }, -- Lesser Soulstone
	[5232] = { 400 }, -- Minor Soulstone
}

--[[
    No soulstone rows in ns.CONJURED_ITEM_IDS_BY_SPELL, on purpose (see
    Conjured-Items-TBC.lua): soulstones share a 30-minute use cooldown that
    matches the buff duration, so only one stone can ever be deployed at
    a time — conjuring a lower rank while holding the best one would
    just waste a soul shard. The Soulstone resolver therefore runs with
    checkUnique=false and always offers the best known conjure.
]]

--[[
    The Soulstone RESURRECTION auras — what a stone leaves on whoever it was
    used on. Distinct from the Create Soulstone spells in ns.CONJURE_SPELLS
    (Conjure-Spells-TBC.lua), which are what a warlock casts to MAKE one,
    and distinct again from the item ids above, which are the stones sitting in
    a bag.

    The readiness report wants the aura: a raid cares that a stone is deployed
    on someone, not that seven unused ones are riding around in seven bags.

    Ranks pair one-for-one with the conjure spells.

    The report also matches on the aura's own localized name, which every rank
    shares and which is read from C_Spell.GetSpellName rather than written down
    here — so a wrong id in this list costs nothing as long as one id still
    resolves.
]]
-- buffSpellID, -- Rank, Name (conjure spell ID)
ns.SOULSTONE_BUFF_SPELL_IDS = {
	20707, -- Rank 1, Minor    (conjure 693)
	20762, -- Rank 2, Lesser   (conjure 20752)
	20763, -- Rank 3, Soulstone (conjure 20755)
	20764, -- Rank 4, Greater  (conjure 20756)
	20765, -- Rank 5, Major    (conjure 20757)
	27239, -- Rank 6, Master   (conjure 27238)
}
