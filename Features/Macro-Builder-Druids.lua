local _, ns = ...

--------------------------------------------------------------------------------
-- DruidMacroHelper Integration
--------------------------------------------------------------------------------

--[[
    When the Druid toggle is on, HP/MP/HS macros are rewritten to use DMH
    syntax so the druid powershifts out of form, /uses the consumable, and
    shifts back into the form chosen by settings.druidReturnForm (bear or
    cat). Hard-coded rather than auto-tracked: macros can't be edited
    during combat, so a mid-combat form swap on an auto-tracking macro
    could return the druid to the wrong form.

    Guard prefixes follow the DMH addon's own examples:
      HP / HS  → "/dmh start" (stun + gcd + mana) plus a /dmh cd line
      MP       → "/dmh stun gcd cd pot" (skips the mana check, since the
                 whole point of a mana pot is that the druid is OOM)

    Eligible macro types and guard prefixes both live in Data.lua
    (ns.DMHMacroTypes, ns.DMHGuards) so the data is shared and not buried
    here.
]]

local function ShouldUseDMHMacro(typeName)
    if not ns.IsDruid then return false end
    if not (ns.DMHMacroTypes and ns.DMHMacroTypes[typeName]) then return false end
    local settings = ConnoisseurCharDB and ConnoisseurCharDB.settings
    return settings and settings.enableDruidMacroHelper and true or false
end

local function GetDruidReturnForm()
    local settings = ConnoisseurCharDB and ConnoisseurCharDB.settings
    local key = settings and settings.druidReturnForm
    if key ~= "cat" then key = "bear" end
    local name = (key == "cat") and ns.DruidCatFormName or ns.DruidBearFormName
    return key, name
end

local function BuildDMHBody(typeName, useIDs, formName)
    local lines = {
        "#showtooltip item:" .. useIDs[1],
        "/run ConnFire(" .. useIDs[1] .. ")",
    }
    for _, guard in ipairs(ns.DMHGuards[typeName]) do
        lines[#lines + 1] = guard
    end
    --[[
        Stacked ranked /use lines, best item first — combat fallback when
        the best item is depleted. See BuildUseBlock in
        Macro-Builder-General.lua for the shared-cooldown reasoning.
    ]]
    local firstUse = #lines + 1
    for _, id in ipairs(useIDs) do
        lines[#lines + 1] = "/use item:" .. id
    end
    lines[#lines + 1] = "/cast !" .. formName
    lines[#lines + 1] = "/dmh end"
    local body = table.concat(lines, "\n") .. "\n"

    --[[
        The client truncates macro bodies at 255 bytes, which here would
        chop the trailing /dmh end line and leave DMH guards dangling.
        Drop stacked /use lines from the bottom until the body fits; the
        rank-1 line is never dropped. Mirrors the trim in
        Macro-Builder-General.lua.
    ]]
    while #body > 255 and #lines > firstUse + 2 do
        table.remove(lines, #lines - 2)
        body = table.concat(lines, "\n") .. "\n"
    end
    return body
end

--------------------------------------------------------------------------------
-- Public Hook
--------------------------------------------------------------------------------

--[[
    The General builder consults this for every macro type/itemID pair it is
    about to write, passing the ranked multi-use id list when one applies
    (best item first; falls back to the single itemID). Returns
    (body, stateID) when the DMH override applies; returns nil to mean
    "use the standard macro body."

    A druid who hasn't learned bear or cat yet (no return form available)
    also gets nil, so the standard body wins rather than emitting an
    unusable "/cast !" line.
]]

function ns.BuildDruidMacroOverride(typeName, itemID, rankedIDs)
    if not itemID then return nil end
    if not ShouldUseDMHMacro(typeName) then return nil end

    local formKey, formName = GetDruidReturnForm()
    if not formName then return nil end

    local useIDs = rankedIDs
    if not useIDs or #useIDs == 0 then
        useIDs = { itemID }
    end

    local body = BuildDMHBody(typeName, useIDs, formName)
    local stateID = "DMH:" .. formKey .. ":" .. table.concat(useIDs, ",")
    return body, stateID
end
