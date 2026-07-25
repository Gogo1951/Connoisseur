local _, ns = ...

--------------------------------------------------------------------------------
-- Profiles Panel
--------------------------------------------------------------------------------

--[[
    The stock AceDBOptions-3.0 profiles panel (profile picker, Copy From, Delete
    a Profile, Reset Profile), returned as-is -- nothing added, nothing removed.
    The widgets come already localized from AceDBOptions, so there are no locale
    keys of our own. Registered second-to-last, directly above Diagnostic Tools
    (see Options.lua).
]]
function ns.BuildProfilesOptions()
	return LibStub("AceDBOptions-3.0"):GetOptionsTable(ns.db)
end
