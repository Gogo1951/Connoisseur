-- Headless test for the Readiness Report (no WoW client needed).
--
-- Run it with:   lua Features/Tests/ReadinessTest.lua        (from the add-on root)
--
-- Like UpgradeLevelTest, this does NOT model the logic: it loads the REAL
-- Data/Soulstones.lua, Features/Readiness-Probes.lua and Features/Readiness.lua
-- and drives ns.ReportReadiness behind the thinnest stubs that will hold them
-- up (a bag-scan result, an aura table, a chat sink, and the group/unit APIs).
-- Modelling would have re-implemented the very gates these scenarios exist to
-- pin down.
--
-- WHAT IS PINNED HERE.
--
-- SILENCE FIRST. The report says nothing when a character is ready, and nothing
-- about a section that has nothing wrong. That is the property everything else
-- rests on -- a report that greets a prepared player is one that gets switched
-- off -- so it is the first thing tested and the thing most of the later
-- scenarios re-check in passing.
--
-- Then the crossings: fifteen account-wide switches against gates that answer to
-- the GROUP (a warlock for the two warlock-made items), to the CLASS (Mage for
-- the gem, a mana class for the mana potion), to the CLIENT (flask on TBC and
-- not on Era), and to the per-character macro switches for the buffs. None of
-- those crossings is visible in any one function.
--
-- The soulstone entry is the odd one out and gets the most attention: it asks
-- whether a stone is ACTIVE ON SOMEONE IN THE GROUP, not whether one is sitting
-- in a bag, and it matches the aura by spell id OR by the localized name every
-- rank shares. One scenario deliberately hands it an id that is NOT in
-- ns.SoulstoneBuffSpellIDs, because the name pass is what makes a wrong or
-- missing id in that table harmless.

local ROOT = arg[1] or "."

local ns = { L = {}, RawData = {} }

--------------------------------------------------------------------------------
-- Stubs
--------------------------------------------------------------------------------

--[[
    Locale keys resolve to their own name, so an assertion can read back exactly
    which string the report chose without depending on its English wording.
    Format keys keep their placeholders so the substitution still shows.
]]
setmetatable(ns.L, {
	__index = function(_, key)
		if key == "READINESS_TIME_MINUTES" then
			return "%s|%dm"
		elseif key == "READINESS_TIME_EXPIRING" then
			return "%s|<1m"
		elseif key == "READINESS_SPEC_FORMAT" then
			return "%s(%s)"
		elseif key == "READINESS_UNSPENT_TALENTS" then
			return "%dunspent"
		end
		return key
	end,
})

-- Colour escapes would bury the labels the assertions read, so they resolve to nothing.
function ns.GetColor()
	return ""
end

local world, printed

local function ResetWorld()
	world = {
		inGroup = true,
		inRaid = true,
		members = 3,
		-- classToken per unit; anything absent is a WARRIOR (i.e. not a warlock).
		classes = {},
		-- Aura list per unit: { {name = ..., spellID = ..., expiration = ...}, ... }
		auras = {},
		-- ns.BestSelection stand-in: an id means "carrying one".
		carrying = {},
		instanceType = "raid",
		wellFed = nil,
		petFed = nil,
		scrollExpiration = nil,
		isEra = false,
		flasked = true,
		mainHandMissing = false,
		offHandMissing = false,
		damaged = {},
		questionable = {},
		spec = nil,
		unspent = nil,
		pvp = false,
		usesMana = true,
	}
	printed = {}
end

function IsInGroup()
	return world.inGroup
end
function IsInRaid()
	return world.inRaid
end
function GetNumGroupMembers()
	return world.members
end
function IsInInstance()
	return true, world.instanceType
end
function GetTime()
	return 1000
end
function UnitExists(unit)
	return world.auras[unit] ~= nil or world.classes[unit] ~= nil or unit == "player"
end
function UnitClass(unit)
	return world.classes[unit] or "Warrior", world.classes[unit] or "WARRIOR"
end

-- One AuraData table per aura, the shape C_UnitAuras.GetBuffDataByIndex returns.
C_UnitAuras = {
	GetBuffDataByIndex = function(unit, index)
		local list = world.auras[unit]
		local entry = list and list[index]
		if not entry then
			return nil
		end
		return { name = entry.name, spellId = entry.spellID, expirationTime = entry.expiration or 0 }
	end,
}

--[[
    Only the soulstone ranks these scenarios name. An id absent from here models
    a rank the client has not got, which is what sends SoulstoneBuffName on to
    the next id in the list.
]]
local SPELL_NAMES = { [20707] = "Soulstone Resurrection" }
function GetSpellInfo(spellID)
	return SPELL_NAMES[spellID]
end

ns.BestSelection = setmetatable({}, {
	__index = function(_, typeName)
		return { id = world.carrying[typeName] }
	end,
})

function ns.GetPlayerBuffSnapshot()
	return {
		wellFedExpiration = world.wellFed,
		scrolls = { arcane = { expiration = world.scrollExpiration } },
	}
end

function ns.ShouldTrackPetFood()
	return world.petFed ~= false
end

function ns.GetPetFoodBuffExpiration()
	return world.petFed or nil
end

function ns.IsModeActive()
	return true
end

--[[
    The probes are stubbed rather than loaded: every one of them reads an API
    this harness has no business modelling (durability, talent tabs, weapon
    enchants), and what the report does WITH their answers is the thing under
    test. ns.GetExpiringBuffs is the exception -- it is the real one, loaded
    below, because the sorting and the sub-minute split are report behaviour.
]]
function ns.HasFlaskOrElixirs()
	return world.flasked
end
function ns.GetMissingWeaponBuffs()
	return world.mainHandMissing, world.offHandMissing
end
function ns.GetDamagedGear()
	return world.damaged
end
function ns.GetQuestionableEquipment()
	return world.questionable
end
function ns.GetCurrentSpecLabel()
	return world.spec
end
function ns.GetUnspentTalentPoints()
	return world.unspent
end
function ns.IsPvPFlagged()
	return world.pvp
end
function ns.PlayerUsesMana()
	return world.usesMana
end

-- Every line the report prints, joined, so an assertion can read the whole report.
function print(text)
	printed[#printed + 1] = text
end
local realPrint = io.write
local function say(text)
	realPrint(text .. "\n")
end

function ns.PrintMessage(text)
	printed[#printed + 1] = text
end

--------------------------------------------------------------------------------

local function loadAddonFile(path)
	-- Addon files are chunks taking (addonName, ns) as varargs, the way WoW loads them.
	return assert(loadfile(ROOT .. "/" .. path))("Consumable-Connoisseur", ns)
end

loadAddonFile("Data/Soulstones.lua")
loadAddonFile("Features/Readiness.lua")

--[[
    The real ns.GetExpiringBuffs, taken from the probes file and grafted on after
    the stubs above so it wins. Loading the whole probes file would drag in the
    equipment and talent APIs this harness deliberately does not model.
]]
do
	local probes = { L = ns.L }
	setmetatable(probes, { __index = ns, __newindex = rawset })
	loadfile(ROOT .. "/Features/Readiness-Probes.lua")("Consumable-Connoisseur", probes)
	ns.GetExpiringBuffs = probes.GetExpiringBuffs
end

--------------------------------------------------------------------------------

local failures = 0

local function check(label, got, want)
	if got == want then
		say(("  ok    %s = %s"):format(label, tostring(got)))
	else
		failures = failures + 1
		say(("  FAIL  %s: got %s, want %s"):format(label, tostring(got), tostring(want)))
	end
end

--[[
    The whole report as one string. Colour terminators are stripped: they are a
    rendering artefact of every coloured span, and leaving them in would make
    every assertion below a wall of |r that says nothing about behaviour.
]]
local function report()
	return (table.concat(printed, " ~ "):gsub("|r", ""))
end

--[[
    Every switch off, so each scenario turns on exactly the one it is about and a
    leak from any other shows up as an unexpected label in the printed report.
]]
local function settings(overrides)
	local global = {
		readinessReport = true,
		readinessFlask = false,
		readinessWellFed = false,
		readinessPetWellFed = false,
		readinessScrolls = false,
		readinessSoulstone = false,
		readinessMainHandBuff = false,
		readinessOffHandBuff = false,
		readinessExpiring = false,
		readinessExpiringThreshold = 150,
		readinessHealthstone = false,
		readinessManaGem = false,
		readinessHealingPotion = false,
		readinessManaPotion = false,
		readinessBandages = false,
		readinessDurability = false,
		readinessDurabilityThreshold = 20,
		readinessSpec = false,
		readinessPvP = false,
		readinessQuestionableGear = false,
	}
	for key, value in pairs(overrides or {}) do
		global[key] = value
	end
	ns.db = {
		global = global,
		profile = { useBuffFood = true, useScrolls = true, usePetBuffFood = true, scrollTypes = { arcane = true } },
	}
	ns.IsEra = world.isEra
	ns.IsMage = world.classes.player == "MAGE"
end

local WARLOCK_IN_RAID = { raid2 = "WARLOCK" }
local SOULSTONE_ON_RAID3 = { raid3 = { { name = "Soulstone Resurrection", spellID = 20707 } } }

--------------------------------------------------------------------------------

say("SILENCE")

say("1. Nothing wrong anywhere: the report does not print at all")
ResetWorld()
world.classes = WARLOCK_IN_RAID
world.auras = SOULSTONE_ON_RAID3
settings({ readinessSoulstone = true, readinessHealthstone = true })
world.carrying = { Healthstone = 5512 }
ns.ReportReadiness()
check("no output", #printed, 0)

say("2. Master switch off: silent even with everything missing")
ResetWorld()
world.classes = WARLOCK_IN_RAID
settings({ readinessReport = false, readinessSoulstone = true, readinessHealthstone = true })
ns.ReportReadiness()
check("no output", #printed, 0)

say("3. In an arena: silent, nothing in the report is actionable there")
ResetWorld()
world.instanceType = "arena"
world.classes = WARLOCK_IN_RAID
settings({ readinessSoulstone = true })
ns.ReportReadiness()
check("no output", #printed, 0)

say("4. Only the Character line has anything: the other two lines are absent")
ResetWorld()
settings({ readinessPvP = true })
world.pvp = true
ns.ReportReadiness()
check("header plus one line", #printed, 2)
check("character named", report(), "READINESS_TITLE ~ READINESS_CHARACTER READINESS_PVP_ON")

say("")
say("MISSING BUFFS")

say("5. Soulstone ACTIVE on a raid member: nothing to report")
ResetWorld()
world.classes = WARLOCK_IN_RAID
world.auras = SOULSTONE_ON_RAID3
settings({ readinessSoulstone = true })
ns.ReportReadiness()
check("no output", #printed, 0)

say("6. Warlock present, NO soulstone up anywhere: reported")
ResetWorld()
world.classes = WARLOCK_IN_RAID
settings({ readinessSoulstone = true })
ns.ReportReadiness()
check("soulstone named", report(), "READINESS_TITLE ~ READINESS_MISSING_BUFFS READINESS_SOULSTONE")

say("7. Aura id NOT in the table, matched on the shared name instead")
ResetWorld()
world.classes = WARLOCK_IN_RAID
world.auras = { raid3 = { { name = "Soulstone Resurrection", spellID = 999999 } } }
settings({ readinessSoulstone = true })
ns.ReportReadiness()
check("name pass covers it", #printed, 0)

say("8. No warlock in the group: not actionable, so not reported")
ResetWorld()
settings({ readinessSoulstone = true })
ns.ReportReadiness()
check("no output", #printed, 0)

say("9. Flask missing on TBC: reported")
ResetWorld()
settings({ readinessFlask = true })
world.flasked = false
ns.ReportReadiness()
check("flask named", report(), "READINESS_TITLE ~ READINESS_MISSING_BUFFS READINESS_FLASK")

say("10. Same character on Classic Era: the flask line does not exist there")
ResetWorld()
world.isEra = true
settings({ readinessFlask = true })
world.flasked = false
ns.ReportReadiness()
check("no output", #printed, 0)

say("11. Weapon buffs, main hand only missing")
ResetWorld()
settings({ readinessMainHandBuff = true, readinessOffHandBuff = true })
world.mainHandMissing = true
ns.ReportReadiness()
check("main hand alone", report(), "READINESS_TITLE ~ READINESS_MISSING_BUFFS READINESS_MAIN_HAND")

say("12. Off-hand switch off, off hand missing: not reported")
ResetWorld()
settings({ readinessMainHandBuff = true, readinessOffHandBuff = false })
world.offHandMissing = true
ns.ReportReadiness()
check("no output", #printed, 0)

say("12a. A Shaman in the group satisfies the MAIN HAND, so it goes quiet")
ResetWorld()
world.classes = { raid2 = "SHAMAN" }
settings({ readinessMainHandBuff = true, readinessOffHandBuff = true })
world.mainHandMissing = true
ns.ReportReadiness()
check("no output", #printed, 0)

say("12b. That exemption is the main hand's alone: the off hand still reports")
ResetWorld()
world.classes = { raid2 = "SHAMAN" }
settings({ readinessMainHandBuff = true, readinessOffHandBuff = true })
world.mainHandMissing = true
world.offHandMissing = true
ns.ReportReadiness()
check("off hand alone", report(), "READINESS_TITLE ~ READINESS_MISSING_BUFFS READINESS_OFF_HAND")

say("12c. The player BEING the Shaman counts as one in the group")
ResetWorld()
world.classes = { player = "SHAMAN" }
settings({ readinessMainHandBuff = true })
world.mainHandMissing = true
ns.ReportReadiness()
check("no output", #printed, 0)

say("")
say("EXPIRING SOON")

say("13. A buff inside the threshold is named with whole minutes")
ResetWorld()
settings({ readinessExpiring = true })
world.auras = { player = { { name = "Kings", spellID = 1, expiration = 1000 + 100 } } }
ns.ReportReadiness()
check("named with minutes", report(), "READINESS_TITLE ~ READINESS_EXPIRING Kings|1m")

say("14. Under a minute reads as its own phrase, never as 0 min")
ResetWorld()
settings({ readinessExpiring = true })
world.auras = { player = { { name = "Kings", spellID = 1, expiration = 1000 + 30 } } }
ns.ReportReadiness()
check("sub-minute phrase", report(), "READINESS_TITLE ~ READINESS_EXPIRING Kings|<1m")

say("15. A buff outside the threshold is not expiring")
ResetWorld()
settings({ readinessExpiring = true })
world.auras = { player = { { name = "Kings", spellID = 1, expiration = 1000 + 600 } } }
ns.ReportReadiness()
check("no output", #printed, 0)

say("16. A buff with no duration never expires")
ResetWorld()
settings({ readinessExpiring = true })
world.auras = { player = { { name = "Aura", spellID = 1, expiration = 0 } } }
ns.ReportReadiness()
check("no output", #printed, 0)

say("17. Soonest first, whatever order the client hands them over in")
ResetWorld()
settings({ readinessExpiring = true })
world.auras = {
	player = {
		{ name = "Later", spellID = 1, expiration = 1000 + 140 },
		{ name = "Sooner", spellID = 2, expiration = 1000 + 70 },
	},
}
ns.ReportReadiness()
check("sorted", report(), "READINESS_TITLE ~ READINESS_EXPIRING Sooner|1m, Later|2m")

say("")
say("MISSING ITEMS")

say("18. Healthstone missing WITH a warlock present: reported")
ResetWorld()
world.classes = WARLOCK_IN_RAID
settings({ readinessHealthstone = true })
ns.ReportReadiness()
check("healthstone named", report(), "READINESS_TITLE ~ READINESS_MISSING_ITEMS READINESS_HEALTHSTONE")

say("19. Healthstone missing with NO warlock: nobody to ask, so silent")
ResetWorld()
settings({ readinessHealthstone = true })
ns.ReportReadiness()
check("no output", #printed, 0)

say("20. Mana gem on a Mage: reported")
ResetWorld()
world.classes = { player = "MAGE" }
settings({ readinessManaGem = true })
ns.ReportReadiness()
check("gem named", report(), "READINESS_TITLE ~ READINESS_MISSING_ITEMS READINESS_MANA_GEM")

say("21. Mana gem on a Warrior: a line that could only ever read missing")
ResetWorld()
settings({ readinessManaGem = true })
ns.ReportReadiness()
check("no output", #printed, 0)

say("22. Mana potion on a class with no mana bar: not reported")
ResetWorld()
settings({ readinessManaPotion = true })
world.usesMana = false
ns.ReportReadiness()
check("no output", #printed, 0)

say("23. Damaged gear rides the Items line, after what is missing")
ResetWorld()
settings({ readinessBandages = true, readinessDurability = true })
world.damaged = { "[Axe]" }
ns.ReportReadiness()
check(
	"both clauses",
	report(),
	"READINESS_TITLE ~ READINESS_MISSING_ITEMS READINESS_BANDAGES. READINESS_DAMAGED_GEAR [Axe]"
)

say("")
say("CHARACTER")

say("24. Spec and unspent points print together")
ResetWorld()
settings({ readinessSpec = true })
world.spec = "Fury(0/31/20)"
world.unspent = 3
ns.ReportReadiness()
check("both", report(), "READINESS_TITLE ~ READINESS_CHARACTER Fury(0/31/20), 3unspent")

say("25. No unspent points: only the spec")
ResetWorld()
settings({ readinessSpec = true })
world.spec = "Fury(0/31/20)"
ns.ReportReadiness()
check("spec alone", report(), "READINESS_TITLE ~ READINESS_CHARACTER Fury(0/31/20)")

say("26. Questionable gear rides the Character line")
ResetWorld()
settings({ readinessQuestionableGear = true })
world.questionable = { "[Fishing Pole]" }
ns.ReportReadiness()
check("gear named", report(), "READINESS_TITLE ~ READINESS_QUESTIONABLE_GEAR [Fishing Pole]")

say("")
say("ALL THREE LINES")

say("27. A wholly unprepared character: three lines, every clause present")
ResetWorld()
world.classes = WARLOCK_IN_RAID
settings({
	readinessSoulstone = true,
	readinessHealthstone = true,
	readinessBandages = true,
	readinessDurability = true,
	readinessPvP = true,
	readinessExpiring = true,
})
world.auras = { player = { { name = "Kings", spellID = 1, expiration = 1000 + 100 } } }
world.damaged = { "[Axe]" }
world.pvp = true
ns.ReportReadiness()
check("four prints", #printed, 4)
check(
	"whole report",
	report(),
	"READINESS_TITLE"
		.. " ~ READINESS_MISSING_BUFFS READINESS_SOULSTONE. READINESS_EXPIRING Kings|1m"
		.. " ~ READINESS_MISSING_ITEMS READINESS_HEALTHSTONE, READINESS_BANDAGES. READINESS_DAMAGED_GEAR [Axe]"
		.. " ~ READINESS_CHARACTER READINESS_PVP_ON"
)

say("")
if failures == 0 then
	say("ALL READINESS SCENARIOS PASSED")
else
	say(failures .. " READINESS SCENARIOS FAILED")
	os.exit(1)
end
