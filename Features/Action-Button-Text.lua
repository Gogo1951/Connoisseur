local _, ns = ...

--------------------------------------------------------------------------------
-- Macro-Name Visibility
--------------------------------------------------------------------------------

--[[
    Blizzard recently began showing the macro-name text on action buttons again.
    Many players who never asked for it assume this add-on turned it on, so we
    default to hiding it and expose an "Enable Macro Names on Buttons" toggle.

    The name is a font string per button; setting its alpha to 0 hides it and
    survives the SetText calls that fire when an action changes, so a single
    application holds until the UI is rebuilt. ApplyMacroNameVisibility is
    therefore re-run on every PLAYER_ENTERING_WORLD (see Features/Core.lua) so a
    /reload or relog re-hides the freshly created font strings.

    Only the five default bars carry macro names in Classic; the same list the
    community fix uses. Nil-guarded so a bar add-on that removes a font string
    can't error us.
]]
local ACTION_BAR_PREFIXES = {
	"ActionButton",
	"MultiBarBottomLeftButton",
	"MultiBarBottomRightButton",
	"MultiBarRightButton",
	"MultiBarLeftButton",
}

function ns.ApplyMacroNameVisibility()
	local alpha = (ns.db and ns.db.global and ns.db.global.showMacroNames) and 1 or 0
	for _, prefix in ipairs(ACTION_BAR_PREFIXES) do
		for i = 1, 12 do
			local name = _G[prefix .. i .. "Name"]
			if name then
				name:SetAlpha(alpha)
			end
		end
	end
end

--[[
    Options-panel toggle. A boolean sets the state directly (matching what
    AceConfig hands the set callback); reapplying immediately shows/hides the
    text without waiting for a bar refresh.
]]
function ns.ToggleMacroNames(value)
	local settings = ns.db.global
	if value == nil then
		settings.showMacroNames = not settings.showMacroNames
	else
		settings.showMacroNames = value
	end
	ns.ApplyMacroNameVisibility()
end
