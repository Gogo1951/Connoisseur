local _, ns = ...
local L = ns.L

--[[
    Readiness -- the ready-check self-audit. Prints one player-only line naming
    the consumables the character is missing and how much time is left on the
    buffs the add-on already tracks. Nothing is ever sent to group chat; this
    add-on has no sent-chat path at all (see Features/Announcements.lua).

    Exposes: ns.ReportReadiness.
]]

--------------------------------------------------------------------------------
-- Buff Time Formatting
--------------------------------------------------------------------------------

--[[
    Expirations follow the Scanner-Character convention: nil means the buff is
    absent (the caller reports it as missing instead), 0 means the aura carries
    no duration and renders as a bare label, since there is no clock to report.
]]
local function FormatBuffTime(label, expiration)
	if expiration == nil then
		return nil
	end
	if expiration == 0 then
		return label
	end

	local remaining = expiration - GetTime()
	if remaining < 60 then
		return string.format(L["READY_TIME_EXPIRING"], label)
	end
	return string.format(L["READY_TIME_MINUTES"], label, math.floor(remaining / 60))
end

--------------------------------------------------------------------------------
-- Missing Consumables
--------------------------------------------------------------------------------

--[[
    Reads the winners from the last ScanBags pass (ns.BestSelection) rather
    than rescanning: the scan re-runs on every bag change under its own
    throttle, so the result is already current. A nil id means nothing usable
    was found for that category.

    Mana Potion is skipped for characters with no mana pool and Bandage for
    characters who never trained First Aid, so the line never asks a Warrior
    for a mana potion.
]]
local function AddMissingItems(missing)
	local selection = ns.BestSelection
	if not selection then
		return
	end

	local function Check(typeName, label)
		local entry = selection[typeName]
		if entry and not entry.id then
			missing[#missing + 1] = label
		end
	end

	Check("Health Potion", L["LABEL_HEALTH_POTION"])
	if (UnitPowerMax("player", 0) or 0) > 0 then
		Check("Mana Potion", L["LABEL_MANA_POTION"])
	end
	Check("Healthstone", L["LABEL_HEALTHSTONE"])
	if (ns.CurrentFirstAidSkill or 0) > 0 then
		Check("Bandage", L["LABEL_BANDAGE"])
	end
end

--------------------------------------------------------------------------------
-- Tracked Buffs
--------------------------------------------------------------------------------

--[[
    One snapshot pass covers Well Fed and every scroll type; the pet's buff is
    a second unit and so a second read.

    Scrolls report as one aggregate line rather than six: ns.ScrollOverrideIDs
    is the macro's own verdict on what it would fire, so a non-empty list means
    the set is incomplete, and the time shown is the soonest of the enabled
    types so the line names the one that lapses first. Scrolls covered by a
    class buff rather than a scroll leave no timed aura behind, which falls
    through to the bare label.

    A feature the user has switched off is left out entirely -- reporting on
    scrolls a character doesn't use would be noise, not readiness.
]]
local function AddBuffLines(missing, buffs)
	local settings = ns.db and ns.db.global
	if not settings then
		return
	end

	local snapshot = ns.GetPlayerBuffSnapshot()

	if settings.useBuffFood and ns.IsModeActive(settings.buffFoodMode) then
		local line = FormatBuffTime(L["READY_WELL_FED"], snapshot.wellFedExpiration)
		if line then
			buffs[#buffs + 1] = line
		else
			missing[#missing + 1] = L["READY_WELL_FED"]
		end
	end

	if settings.useScrolls and ns.IsModeActive(settings.scrollsMode) then
		if ns.ScrollOverrideIDs and #ns.ScrollOverrideIDs > 0 then
			missing[#missing + 1] = L["READY_SCROLLS"]
		else
			local soonest
			for scrollType, enabled in pairs(settings.scrollTypes or {}) do
				local entry = enabled and snapshot.scrolls[scrollType]
				local expiration = entry and entry.expiration
				if expiration and expiration ~= 0 and (not soonest or expiration < soonest) then
					soonest = expiration
				end
			end
			buffs[#buffs + 1] = FormatBuffTime(L["READY_SCROLLS"], soonest or 0)
		end
	end

	if settings.usePetBuffFood and ns.IsModeActive(settings.petBuffFoodMode) and UnitExists("pet") then
		local line = FormatBuffTime(L["READY_PET_FED"], ns.GetPetFoodBuffExpiration())
		if line then
			buffs[#buffs + 1] = line
		else
			missing[#missing + 1] = L["READY_PET_FED"]
		end
	end
end

--------------------------------------------------------------------------------
-- Ready Check Report
--------------------------------------------------------------------------------

--[[
    Routed from Core's dispatcher on READY_CHECK. The group test is a
    belt-and-braces guard: a ready check can only start in a group, but the
    report is worthless solo and cheap to skip.
]]
function ns.ReportReadiness()
	local settings = ns.db and ns.db.global
	if not (settings and settings.readyCheckReport) then
		return
	end
	if not IsInGroup() then
		return
	end

	local missing, buffs = {}, {}
	AddMissingItems(missing)
	AddBuffLines(missing, buffs)

	local segments = {}
	if #missing > 0 then
		segments[1] = string.format(L["READY_MISSING"], table.concat(missing, ", "))
	else
		segments[1] = L["READY_ALL_CLEAR"]
	end
	for _, line in ipairs(buffs) do
		segments[#segments + 1] = line
	end

	ns.PrintMessage(table.concat(segments, " // "))
end
