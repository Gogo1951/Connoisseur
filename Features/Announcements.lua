local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Player Prints
--------------------------------------------------------------------------------

--[[
    Player-only chat print: branded add-on name, separator, then the message
    body. This add-on sends no cross-player chat, so there is no whisper/group
    announce path here.
]]
function ns.PrintMessage(text)
	print(
		GetColor("INFO")
			.. L["ADDON_TITLE"]
			.. "|r "
			.. GetColor("SEPARATOR")
			.. "//"
			.. "|r "
			.. GetColor("TEXT")
			.. text
			.. "|r"
	)
end

--------------------------------------------------------------------------------
-- Welcome Message
--------------------------------------------------------------------------------

--[[
    PLAYER_ENTERING_WORLD fires on instance transitions and reloads, not just
    initial login, so a flag keeps the welcome to once per session. Reads
    ns.db.profile.showWelcome (default on, toggled in Options).
]]
local welcomePrinted = false

function ns.PrintWelcome()
	if welcomePrinted then
		return
	end
	if not (ns.db and ns.db.profile.showWelcome) then
		return
	end
	welcomePrinted = true
	ns.PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
end
