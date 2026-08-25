local _, ns = ...
local L = ns.L

--[[
    Readiness -- the ready-check self-audit. Prints one player-only line naming
    what the character can still fix before the pull and how much time is left
    on the buffs the add-on already tracks. Nothing is ever sent to group chat;
    this add-on has no sent-chat path at all (see Features/Announcements.lua).

    Scope is deliberately narrow: a Healthstone, Well Fed, scrolls, and pet
    food. All four are obtainable or usable on the spot. Potions and bandages
    are not reported -- a player who is out of them mid-raid cannot do anything
    about it, so the line would only add noise to the part that matters.

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
    Whether anyone present can actually produce a Healthstone. Raid unit ids
    cover every member including the player, party ids cover everyone except
    them, so the player is tested separately rather than folded into the loop.
]]
local function GroupHasWarlock()
	if ns.IsWarlock then
		return true
	end

	local members = GetNumGroupMembers() or 0
	local inRaid = IsInRaid()
	local prefix = inRaid and "raid" or "party"
	local count = inRaid and members or (members - 1)

	for index = 1, count do
		local _, classToken = UnitClass(prefix .. index)
		if classToken == "WARLOCK" then
			return true
		end
	end

	return false
end

--[[
    Reads the winner from the last ScanBags pass (ns.BestSelection) rather than
    rescanning: the scan re-runs on every bag change under its own throttle, so
    the result is already current. A nil id means nothing usable was found.

    The Healthstone is the only item reported, and only when the group holds a
    warlock to ask. Everything in this report has to be something the player can
    still act on in the seconds a ready check gives them -- ask the warlock for a
    stone, eat, apply a scroll, feed the pet -- and with no warlock present a
    missing stone is not actionable, just a nag nothing can clear. Potions and
    bandages are deliberately excluded for the same reason: mid-raid there is
    nothing to be done about an empty potion slot, so naming it is noise rather
    than readiness.
]]
local function AddMissingItems(missing)
	if not GroupHasWarlock() then
		return
	end

	local selection = ns.BestSelection
	local entry = selection and selection["Healthstone"]
	if entry and not entry.id then
		missing[#missing + 1] = L["LABEL_HEALTHSTONE"]
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
	local settings = ns.db and ns.db.profile
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

	--[[
        Coverage is settled from the aura snapshot, never from
        ns.ScrollOverrideIDs alone: that list holds only scrolls the player has
        in bags, so someone missing the buffs with no scrolls to fire would read
        as covered. A type counts as covered by its own scroll buff or by a
        conflicting class buff; the reported time is the soonest of the timed
        ones, so the line names whichever lapses first.
    ]]
	if settings.useScrolls and ns.IsModeActive(settings.scrollsMode) then
		local uncovered = false
		local soonest
		for scrollType, enabled in pairs(settings.scrollTypes or {}) do
			if enabled then
				local entry = snapshot.scrolls[scrollType]
				local expiration = entry and entry.expiration
				if not (expiration or (entry and entry.conflictAmount)) then
					uncovered = true
				elseif expiration and expiration ~= 0 and (not soonest or expiration < soonest) then
					soonest = expiration
				end
			end
		end

		if uncovered or (ns.ScrollOverrideIDs and #ns.ScrollOverrideIDs > 0) then
			missing[#missing + 1] = L["READY_SCROLLS"]
		else
			buffs[#buffs + 1] = FormatBuffTime(L["READY_SCROLLS"], soonest or 0)
		end
	end

	--[[
        Same gate the macro uses, so the report can only ask for a buff the
        add-on would actually apply -- never from a Hunter too low for the food
        to exist, and never for a dead pet (which is a resurrection problem, not
        a feeding one).
    ]]
	if ns.ShouldTrackPetFood() then
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
	-- The report toggle is account-wide; the buffs it reports on are per-character.
	if not (ns.db and ns.db.global.readyCheckReport) then
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
