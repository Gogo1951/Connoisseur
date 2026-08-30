local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--[[
    Readiness -- the Readiness Report. When a ready check starts, prints a
    private list of what still needs fixing. Nothing is ever sent to group chat;
    this add-on has no sent-chat path at all (see Features/Announcements.lua).

    SILENCE IS THE DEFAULT OUTPUT. A section with nothing wrong is not printed,
    and a report with no sections is not printed at all -- there is no all-clear
    line. That is the whole reason the report can afford to cover this much: a
    prepared player sees nothing, so the only reports anyone reads are the ones
    that need reading. Never add a line that fires when something is FINE.

    Shape, one print per line, each dropped when empty:

        Connoisseur // Readiness Report
        Connoisseur // Missing Buffs : ... . Expiring Soon : ...
        Connoisseur // Missing Items : ... . Damaged Gear : ...
        Connoisseur // Character : ... . Non-combat Gear Equipped : ...

    Every line goes through ns.PrintMessage, so every line carries the brand --
    the same shape the Restock List's own reports print in, where a headline is
    followed by branded detail lines. A report is several prints rather than one
    message, and a chat window interleaves other add-ons between them, so a body
    line with no brand on it reads as coming from somewhere else.

    Each category answers to its own account-wide switch, all of them dead while
    the master switch is off; see Data/Default-Settings.lua for the defaults.

    The whole report is skipped inside a PvP Arena. That predates the character
    and gear lines, which ARE actionable in an arena prep window -- see the note
    on ns.ReportReadiness before changing it.
]]

--------------------------------------------------------------------------------
-- Line Assembly
--------------------------------------------------------------------------------

--[[
    One "Label : a, b, c" clause. Sections are joined with ". " into a line, so
    a clause never carries its own trailing stop.
]]
local function Clause(label, values)
	if #values == 0 then
		return nil
	end
	return GetColor("TITLE") .. label .. "|r " .. GetColor("TEXT") .. table.concat(values, ", ") .. "|r"
end

--[[
    A report line from its clauses, or nil when every one of them was empty.

    The clause colours sit INSIDE what ns.PrintMessage wraps in C_TEXT. A |r
    resets to the default rather than to the enclosing colour, which is why each
    clause re-opens C_TEXT after its label instead of relying on the wrapper's.
]]
local function Line(...)
	local clauses = {}
	for index = 1, select("#", ...) do
		local clause = select(index, ...)
		if clause then
			clauses[#clauses + 1] = clause
		end
	end
	if #clauses == 0 then
		return nil
	end
	return table.concat(clauses, GetColor("SEPARATOR") .. ". |r")
end

--------------------------------------------------------------------------------
-- Missing Buffs
--------------------------------------------------------------------------------

--[[
    Walks every group member, the player included. Raid unit ids already cover
    the player, party ids do not, so the player is tested up front and the loop
    length differs between the two.
]]
local function AnyGroupMember(test)
	if test("player") then
		return true
	end

	local members = GetNumGroupMembers() or 0
	local inRaid = IsInRaid()
	local prefix = inRaid and "raid" or "party"
	local count = inRaid and members or (members - 1)

	for index = 1, count do
		if test(prefix .. index) then
			return true
		end
	end

	return false
end

--[[
    Whether anyone present is of a class, the player included -- AnyGroupMember
    tests "player" first, so "in the group" always covers "is you".

    Two entries ask this. A Warlock is who produces a Healthstone or a
    Soulstone, so with none present neither is actionable. A Shaman is who makes
    the weapon-buff line moot; see its caller.
]]
local function GroupHasClass(classToken)
	return AnyGroupMember(function(unit)
		return select(2, UnitClass(unit)) == classToken
	end)
end

--[[
    The soulstone aura's own localized name, resolved once from whichever id in
    ns.SoulstoneBuffSpellIDs the client answers for. Every rank shares one name,
    so this single string covers them all -- including a rank whose id is wrong
    or missing from that list, which is why the name pass exists at all. `false`
    is the cached "asked and got nothing" answer, so a cold spell cache costs
    one lookup rather than one per aura per unit.
]]
local soulstoneBuffName

local function SoulstoneBuffName()
	if soulstoneBuffName == nil then
		soulstoneBuffName = false
		for _, spellID in ipairs(ns.SoulstoneBuffSpellIDs) do
			local name = GetSpellInfo(spellID)
			if name then
				soulstoneBuffName = name
				break
			end
		end
	end
	return soulstoneBuffName or nil
end

local soulstoneBuffLookup = {}
for _, spellID in ipairs(ns.SoulstoneBuffSpellIDs) do
	soulstoneBuffLookup[spellID] = true
end

local function UnitHasSoulstone(unit)
	if not UnitExists(unit) then
		return false
	end

	local wantedName = SoulstoneBuffName()
	for index = 1, 40 do
		local aura = C_UnitAuras.GetBuffDataByIndex(unit, index, "HELPFUL")
		if not aura then
			return false
		end
		if soulstoneBuffLookup[aura.spellId] or (wantedName and aura.name == wantedName) then
			return true
		end
	end

	return false
end

--[[
    Whether a soulstone is UP on anyone in the group, which is the only thing a
    raid actually cares about. Deliberately NOT "does someone hold a stone":
    seven unused stones in seven bags resurrect nobody, and one deployed on the
    healer covers the pull.

    LIMITATION: the aura APIs only answer for members the client can see.
    Someone in another room or out of range reports no auras at all, so a stone
    on them reads as absent. That makes the failure a false "missing", never a
    false "all clear" -- and at a ready check the group is normally stacked up
    for the pull, which is the one moment this runs.
]]
local function GroupHasSoulstone()
	return AnyGroupMember(UnitHasSoulstone)
end

--[[
    Every buff answers to TWO switches: the per-character macro switch saying
    the character uses the thing at all, and the account-wide report switch
    saying to mention it. The macro switch stays first in each test -- reporting
    a buff the character never applies would be noise whatever the report is set
    to. Flask, weapon buffs and the group soulstone have no macro behind them,
    so they answer to their report switch alone.
]]
local function BuildMissingBuffs(settings, reports)
	local missing = {}

	--[[
	    TBC and later only, which is a maintainer decision rather than a data
	    one: Era has flasks and elixirs, but they are not what an Era raid runs
	    on, so the line would be wrong for most of the people it fired at. The
	    option hides itself on Era to match (Options/Options-Readiness.lua).
	]]
	if reports.readinessFlask and not ns.IsEra and not ns.HasFlaskOrElixirs() then
		missing[#missing + 1] = L["READINESS_FLASK"]
	end

	if reports.readinessWellFed and settings.useBuffFood and ns.IsModeActive(settings.buffFoodMode) then
		local snapshot = ns.GetPlayerBuffSnapshot()
		if snapshot.wellFedExpiration == nil then
			missing[#missing + 1] = L["READINESS_WELL_FED"]
		end
	end

	--[[
	    The same gate the macro uses, so the report can only ask for a buff the
	    add-on would actually apply -- never from a Hunter too low for the food
	    to exist, and never for a dead pet, which is a resurrection problem
	    rather than a feeding one.
	]]
	if reports.readinessPetWellFed and ns.ShouldTrackPetFood() and ns.GetPetFoodBuffExpiration() == nil then
		missing[#missing + 1] = L["READINESS_PET_WELL_FED"]
	end

	--[[
	    Coverage is settled from the aura snapshot, never from
	    ns.ScrollOverrideIDs alone: that list holds only scrolls the player has
	    in bags, so someone missing the buffs with no scrolls to fire would read
	    as covered. A type counts as covered by its own scroll buff or by a
	    conflicting class buff.
	]]
	if reports.readinessScrolls and settings.useScrolls and ns.IsModeActive(settings.scrollsMode) then
		local snapshot = ns.GetPlayerBuffSnapshot()
		local uncovered = false
		for scrollType, enabled in pairs(settings.scrollTypes or {}) do
			if enabled then
				local entry = snapshot.scrolls[scrollType]
				if not (entry and (entry.expiration or entry.conflictAmount)) then
					uncovered = true
				end
			end
		end
		if uncovered or (ns.ScrollOverrideIDs and #ns.ScrollOverrideIDs > 0) then
			missing[#missing + 1] = L["READINESS_SCROLLS"]
		end
	end

	--[[
	    The one entry that asks the GROUP rather than the player. Gated on a
	    Warlock being present, because with nobody to cast it a missing soulstone
	    is not actionable, just a nag nothing can clear.
	]]
	if reports.readinessSoulstone and GroupHasClass("WARLOCK") and not GroupHasSoulstone() then
		missing[#missing + 1] = L["READINESS_SOULSTONE"]
	end

	--[[
	    Any temporary enchant counts -- a stone, an oil, a poison, a shaman
	    imbue -- because GetWeaponEnchantInfo answers whether the slot carries
	    one without caring which.

	    A SHAMAN IN THE GROUP SATISFIES THE MAIN HAND, and only the main hand:
	    that is the slot their buff answers for, so with one present the line
	    stops being a thing the player has to act on. The off hand asks the
	    same question with no such exemption. Resolved once for the pair rather
	    than per slot, so the group walk runs at most once per report.
	]]
	if reports.readinessMainHandBuff or reports.readinessOffHandBuff then
		local mainHandMissing, offHandMissing = ns.GetMissingWeaponBuffs()
		if reports.readinessMainHandBuff and mainHandMissing and not GroupHasClass("SHAMAN") then
			missing[#missing + 1] = L["READINESS_MAIN_HAND"]
		end
		if reports.readinessOffHandBuff and offHandMissing then
			missing[#missing + 1] = L["READINESS_OFF_HAND"]
		end
	end

	return missing
end

--[[
    Buffs about to lapse, named with whole minutes left. Under a minute reads as
    its own phrase rather than "0 min", which would look like a bug.
]]
local function BuildExpiring(reports)
	local expiring = {}

	if not reports.readinessExpiring then
		return expiring
	end

	local threshold = reports.readinessExpiringThreshold or 150
	for _, entry in ipairs(ns.GetExpiringBuffs(threshold)) do
		if entry.remaining < 60 then
			expiring[#expiring + 1] = string.format(L["READINESS_TIME_EXPIRING"], entry.name)
		else
			expiring[#expiring + 1] =
				string.format(L["READINESS_TIME_MINUTES"], entry.name, math.floor(entry.remaining / 60))
		end
	end

	return expiring
end

--------------------------------------------------------------------------------
-- Missing Items
--------------------------------------------------------------------------------

--[[
    Reads the winners from the last ScanBags pass (ns.BestSelection) rather than
    rescanning: the scan re-runs on every bag change under its own throttle, so
    the result is already current. A nil id means nothing usable was found.

    ScanBags fills every category whether or not its macro is enabled -- the
    enabled check lives in the macro writer, not the scanner -- so these read
    real bag contents, and a player who turned a macro off still gets a truthful
    answer about what they are carrying.
]]
local function CarryingNone(typeName)
	local selection = ns.BestSelection
	local entry = selection and selection[typeName]
	return entry ~= nil and entry.id == nil
end

local function BuildMissingItems(reports)
	local missing = {}

	--[[
	    The Healthstone carries a Warlock gate on top of its switch, for the same
	    reason the soulstone does: with nobody present to ask, a missing stone is
	    not something the player can act on.
	]]
	if reports.readinessHealthstone and CarryingNone("Healthstone") and GroupHasClass("WARLOCK") then
		missing[#missing + 1] = L["READINESS_HEALTHSTONE"]
	end

	-- Mage-only: mana gems are conjured, so anywhere else this could only ever read "missing".
	if reports.readinessManaGem and ns.IsMage and CarryingNone("Mana Gem") then
		missing[#missing + 1] = L["READINESS_MANA_GEM"]
	end

	if reports.readinessHealingPotion and CarryingNone("Health Potion") then
		missing[#missing + 1] = L["READINESS_HEALING_POTION"]
	end

	if reports.readinessManaPotion and ns.PlayerUsesMana() and CarryingNone("Mana Potion") then
		missing[#missing + 1] = L["READINESS_MANA_POTION"]
	end

	if reports.readinessBandages and CarryingNone("Bandage") then
		missing[#missing + 1] = L["READINESS_BANDAGES"]
	end

	return missing
end

--------------------------------------------------------------------------------
-- Character
--------------------------------------------------------------------------------

local function BuildCharacter(reports)
	local entries = {}

	if reports.readinessSpec then
		local spec = ns.GetCurrentSpecLabel()
		if spec then
			entries[#entries + 1] = spec
		end
		local unspent = ns.GetUnspentTalentPoints()
		if unspent then
			entries[#entries + 1] = string.format(L["READINESS_UNSPENT_TALENTS"], unspent)
		end
	end

	if reports.readinessPvP and ns.IsPvPFlagged() then
		-- The one entry coloured as a warning rather than a value; it is the one that bites.
		entries[#entries + 1] = GetColor("OFF") .. L["READINESS_PVP_ON"] .. "|r" .. GetColor("TEXT")
	end

	return entries
end

--------------------------------------------------------------------------------
-- Readiness Report
--------------------------------------------------------------------------------

--[[
    The report's body lines, or nil when there is nothing to say.

    Split from the printing so Diagnostic Tools can render the same answer on
    demand, without waiting for a ready check. That is the only way to tell the
    report's two silences apart -- "you are ready" and "it never ran" look
    identical in a chat window, which is exactly how long a silent failure can
    hide.

    Deliberately ignores the master switch and the arena gate: this answers what
    the report WOULD say, and the caller decides whether it is allowed to say it.
]]
function ns.BuildReadinessLines()
	local reports = ns.db and ns.db.global
	local settings = ns.db and ns.db.profile
	if not (reports and settings) then
		return nil
	end

	local buffsLine = Line(
		Clause(L["READINESS_MISSING_BUFFS"], BuildMissingBuffs(settings, reports)),
		Clause(L["READINESS_EXPIRING"], BuildExpiring(reports))
	)

	local damaged = reports.readinessDurability and ns.GetDamagedGear(reports.readinessDurabilityThreshold or 20) or {}
	local itemsLine = Line(
		Clause(L["READINESS_MISSING_ITEMS"], BuildMissingItems(reports)),
		Clause(L["READINESS_DAMAGED_GEAR"], damaged)
	)

	local questionable = reports.readinessQuestionableGear and ns.GetQuestionableEquipment() or {}
	local characterLine = Line(
		Clause(L["READINESS_CHARACTER"], BuildCharacter(reports)),
		Clause(L["READINESS_QUESTIONABLE_GEAR"], questionable)
	)

	--[[
	    Nothing wrong, nothing said. nil rather than an empty table, so a caller
	    cannot accidentally print a header over no lines -- a prepared player
	    gets no output at all rather than an all-clear. See the note at the top
	    of this file before adding one.
	]]
	if not (buffsLine or itemsLine or characterLine) then
		return nil
	end

	--[[
	    Appended one at a time, never gathered with ipairs over a literal holding
	    all three: any of them can be nil, and ipairs stops dead at the first
	    hole -- so a report whose Buffs line was empty would return the Items and
	    Character lines as an EMPTY list, print its header, and say nothing under
	    it. The guard above already guarantees at least one survives.
	]]
	local lines = {}
	if buffsLine then
		lines[#lines + 1] = buffsLine
	end
	if itemsLine then
		lines[#lines + 1] = itemsLine
	end
	if characterLine then
		lines[#lines + 1] = characterLine
	end
	return lines
end

--[[
    Routed from Core's dispatcher on READY_CHECK. Owns the two gates that decide
    whether the report is allowed to speak at all -- the master switch and the
    arena skip; what it would say is ns.BuildReadinessLines' business.

    THERE IS NO GROUP TEST, deliberately. One used to sit here, guarding against
    a solo report -- but a ready check cannot be STARTED outside a group, so the
    event never arrives solo and the test could never be false when this runs.
    It was unreachable rather than protective, and every group-dependent entry
    already gates on the relevant class being present anyway.

    The arena skip predates the character and gear lines. Arenas block buff
    food, scrolls and pet food, so when the report was only about consumables
    there was nothing left in it worth printing there. Durability, the PvP flag
    and a wrong trinket ARE actionable in the prep window, so this gate is now
    suppressing lines it was never written about -- revisit it rather than
    assuming it still earns its place.
]]
function ns.ReportReadiness()
	local reports = ns.db and ns.db.global
	if not (reports and reports.readinessReportEnabled) then
		return
	end
	if select(2, IsInInstance()) == "arena" then
		return
	end

	local lines = ns.BuildReadinessLines()
	if not lines then
		return
	end

	ns.PrintMessage(L["READINESS_TITLE"])
	for _, line in ipairs(lines) do
		ns.PrintMessage(line)
	end
end
