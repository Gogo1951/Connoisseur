local _, ns = ...

--------------------------------------------------------------------------------
-- Questionable Equipment
--------------------------------------------------------------------------------

--[[
    Items that are fine to own and wrong to be wearing when a pull starts. Read
    by the Non-combat Gear Equipped check in Features/Readiness-Probes.lua.

    THIS TABLE IS THE EXCEPTIONS, NOT THE LIST. Nearly everything worth catching
    is a whole weapon subclass -- every fishing pole, every mining pick and
    skinning knife, the tournament lances -- and the check answers those from
    the equipped item's own class and subclass, so they need no rows here and a
    pole added in a later patch is covered on the day it ships.

    What is left is the handful that share a subclass with real gear: trinkets.
    No property tells a Riding Crop from a raid trinket, so those are named.
]]

--[[
    SELECT entry, name, class, subclass, InventoryType
    FROM item_template
    WHERE class = 4 AND subclass = 0 AND InventoryType = 12
    ORDER BY name;
]]

-- [itemID] = true, -- Item Name
ns.QuestionableEquipment = {
	[25653] = true, -- Riding Crop
	[37254] = true, -- Super Simian Sphere
}
