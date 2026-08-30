local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Restock List Slash Command
--------------------------------------------------------------------------------

--[[
    One slash-help line: the command in C_INFO, then the localized description
    (TEXT restored for the tail, since ns.PrintMessage wraps the whole body in TEXT).
]]
local function SlashHelpLine(command, description)
	return ns.GetColor("INFO") .. command .. "|r" .. ns.GetColor("TEXT") .. "  " .. description
end

ns.restockerCommands = {
	show = SlashHelpLine("/crs show", L["RESTOCKER_HELP_SHOW"]),
	config = SlashHelpLine("/crs config", L["OPTIONS_COMMAND_DESCRIPTION"]),
	profile = {
		add = SlashHelpLine("/crs profile add [name]", L["RESTOCKER_HELP_PROFILE_ADD"]),
		delete = SlashHelpLine("/crs profile delete [name]", L["RESTOCKER_HELP_PROFILE_DELETE"]),
		rename = SlashHelpLine("/crs profile rename [name]", L["RESTOCKER_HELP_PROFILE_RENAME"]),
		copy = SlashHelpLine("/crs profile copy [name]", L["RESTOCKER_HELP_PROFILE_COPY"]),
		use = SlashHelpLine("/crs profile use [name]", L["RESTOCKER_HELP_PROFILE_USE"]),
	},
}

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

function ns.HandleRestockerCommand(args)
	local command, rest = strsplit(" ", args, 2)
	command = command:lower()

	if command == "show" then
		ns.ShowRestockWindow()
	elseif command == "profile" then
		if rest == "" or rest == nil then
			for _, v in pairs(ns.restockerCommands.profile) do
				ns.PrintMessage(v)
			end
			return
		end

		local subcommand, name = strsplit(" ", rest, 2)

		--[[
		    Every profile subcommand needs a name; print its usage line instead of
		    erroring on a nil table key when the name is missing.
		]]
		if (name == nil or name == "") and ns.restockerCommands.profile[subcommand] then
			ns.PrintMessage(ns.restockerCommands.profile[subcommand])
			return
		end

		if subcommand == "add" then
			ns.AddRestockList(name)
		elseif subcommand == "delete" then
			ns.DeleteRestockList(name)
		elseif subcommand == "rename" then
			ns.RenameCurrentRestockList(name)
		elseif subcommand == "use" then
			ns.SwitchRestockList(name)
		elseif subcommand == "copy" then
			ns.CopyIntoCurrentRestockList(name)
		end
	elseif command == "help" then
		for _, eachCommand in pairs(ns.restockerCommands) do
			if type(eachCommand) == "table" then
				for _, eachSubcommand in pairs(eachCommand) do
					ns.PrintMessage(eachSubcommand)
				end
			else
				ns.PrintMessage(eachCommand)
			end
		end
		return
	elseif command == "config" then
		if ns.OpenOptionsPanel then
			ns.OpenOptionsPanel()
		end
		return
	else
		ns.ToggleRestockWindow()
	end
	ns.UpdateRestockList()
end
