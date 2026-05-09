local _, ns = ...
ns.RawData = ns.RawData or {}

-- SELECT entry, name FROM item_template
-- WHERE class = 0 AND subclass = 7
-- ORDER BY entry;
-- Bandage Amount and First Aid skill requirement come from the heal
-- spell on item_template.spellid_1; Allowed Zones from Map/Area
-- restrictions where present.
ns.RawData.Bandage = {
    -- [ID] = {Bandage Amount, First Aid Skill, {Allowed Zones}}, -- Name

    [19307] = {2000, 225, {1459}}, -- Alterac Heavy Runecloth Bandage
    [20065] = {1104, 175, {1461}}, -- Arathi Basin Mageweave Bandage
    [20066] = {2000, 225, {1461}}, -- Arathi Basin Runecloth Bandage
    [20067] = {640, 125, {1461}}, -- Arathi Basin Silk Bandage
    [20232] = {1104, 175, {1461}}, -- Defiler's Mageweave Bandage
    [20234] = {2000, 225, {1461}}, -- Defiler's Runecloth Bandage
    [20235] = {640, 125, {1461}}, -- Defiler's Silk Bandage
    [2581] = {114, 20}, -- Heavy Linen Bandage
    [8545] = {1104, 175}, -- Heavy Mageweave Bandage
    [21991] = {3400, 325}, -- Heavy Netherweave Bandage
    [14530] = {2000, 225}, -- Heavy Runecloth Bandage
    [6451] = {640, 125}, -- Heavy Silk Bandage
    [3531] = {301, 75}, -- Heavy Wool Bandage
    [20237] = {1104, 175, {1461}}, -- Highlander's Mageweave Bandage
    [20243] = {2000, 225, {1461}}, -- Highlander's Runecloth Bandage
    [20244] = {640, 125, {1461}}, -- Highlander's Silk Bandage
    [1251] = {66, 1}, -- Linen Bandage
    [8544] = {800, 150}, -- Mageweave Bandage
    [21990] = {2800, 300}, -- Netherweave Bandage
    [14529] = {1360, 200}, -- Runecloth Bandage
    [6450] = {400, 100}, -- Silk Bandage
    [19067] = {1104, 175, {1460}}, -- Warsong Gulch Mageweave Bandage
    [19066] = {2000, 225, {1460}}, -- Warsong Gulch Runecloth Bandage
    [19068] = {640, 125, {1460}}, -- Warsong Gulch Silk Bandage
    [3530] = {161, 50} -- Wool Bandage
}