local addonName, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local MODE_VALUES = {
    always = L["MODE_ALWAYS"],
    party  = L["MODE_PARTY"],
    raid   = L["MODE_RAID"],
}

--------------------------------------------------------------------------------
-- AceConfig Helpers
--------------------------------------------------------------------------------

local function Header(text, order)
    return {
        type = "header",
        name = GetColor("TITLE") .. text .. "|r",
        order = order
    }
end

local function Desc(text, order)
    return {
        type = "description",
        name = text,
        fontSize = "medium",
        order = order
    }
end

local function Spacer(order)
    return {
        type = "description",
        name = " ",
        order = order
    }
end

--------------------------------------------------------------------------------
-- Options Table
--------------------------------------------------------------------------------

local function GetOptions()
    return {
        name = L["BRAND"],
        type = "group",
        args = {
            descIntro = Desc(L["OPTIONS_DESC"], 1),
            -- /Commands
            spaceCommands0 = Spacer(5),
            headerCommands = Header(L["OPTIONS_COMMANDS_HEADER"], 6),
            spaceCommands1 = Spacer(7),
            descCommands = Desc(
                GetColor("INFO") .. L["OPTIONS_COMMANDS_DESC"] .. "|r" .. "  " .. L["OPTIONS_COMMANDS_DETAIL"],
                8
            ),
            -- Buff Food
            spaceBuff0 = Spacer(10),
            headerBuff = Header(L["MENU_BUFF_FOOD"], 11),
            descBuff = Desc(GetColor("DESC") .. L["OPTIONS_BUFF_FOOD_DESC"] .. "|r", 12),
            spaceBuff1 = Spacer(13),
            toggleBuffFood = {
                type = "toggle",
                name = L["OPTIONS_BUFF_FOOD"],
                desc = L["OPTIONS_BUFF_FOOD_DESC"],
                order = 14,
                width = 1.5,
                get = function()
                    return ConnoisseurCharDB and ConnoisseurCharDB.settings and ConnoisseurCharDB.settings.useBuffFood
                end,
                set = function(_, value)
                    if ns.ToggleBuffFood then
                        ns.ToggleBuffFood()
                    end
                end
            },
            buffFoodMode = {
                type = "select",
                name = "",
                order = 15,
                width = "normal",
                values = MODE_VALUES,
                sorting = ns.MODE_ORDER,
                disabled = function()
                    return not (ConnoisseurCharDB and ConnoisseurCharDB.settings and
                        ConnoisseurCharDB.settings.useBuffFood)
                end,
                get = function()
                    return ConnoisseurCharDB and ConnoisseurCharDB.settings and ConnoisseurCharDB.settings.buffFoodMode or
                        "always"
                end,
                set = function(_, value)
                    ConnoisseurCharDB.settings.buffFoodMode = value
                    if ns.ResetMacroState then
                        ns.ResetMacroState()
                    end
                    ns.RequestUpdate()
                end
            },
            -- Scroll Buffs
            spaceScroll0 = Spacer(20),
            headerScroll = Header(L["OPTIONS_SCROLL_HEADER"], 21),
            descScroll = Desc(GetColor("DESC") .. L["OPTIONS_USE_SCROLLS_DESC"] .. "|r", 22),
            spaceScroll1 = Spacer(23),
            toggleScrolls = {
                type = "toggle",
                name = L["OPTIONS_USE_SCROLLS"],
                desc = L["OPTIONS_USE_SCROLLS_DESC"],
                order = 24,
                width = 1.5,
                get = function()
                    return ConnoisseurCharDB and ConnoisseurCharDB.settings and ConnoisseurCharDB.settings.useScrolls
                end,
                set = function(_, value)
                    if ns.ToggleScrollBuffs then
                        ns.ToggleScrollBuffs()
                    end
                end
            },
            scrollsMode = {
                type = "select",
                name = "",
                order = 25,
                width = "normal",
                values = MODE_VALUES,
                sorting = ns.MODE_ORDER,
                disabled = function()
                    return not (ConnoisseurCharDB and ConnoisseurCharDB.settings and
                        ConnoisseurCharDB.settings.useScrolls)
                end,
                get = function()
                    return ConnoisseurCharDB and ConnoisseurCharDB.settings and ConnoisseurCharDB.settings.scrollsMode or
                        "always"
                end,
                set = function(_, value)
                    ConnoisseurCharDB.settings.scrollsMode = value
                    if ns.ResetMacroState then
                        ns.ResetMacroState()
                    end
                    ns.RequestUpdate()
                end
            },
            spaceScrollTypes0 = Spacer(29),
            scrollTypesGroup = {
                type = "group",
                name = L["OPTIONS_SCROLL_TYPES"],
                order = 30,
                inline = true,
                hidden = function()
                    return not (ConnoisseurCharDB and ConnoisseurCharDB.settings and
                        ConnoisseurCharDB.settings.useScrolls)
                end,
                args = {
                    scrollAgility = {
                        type = "toggle",
                        name = L["OPTIONS_SCROLL_AGILITY"],
                        order = 1,
                        get = function()
                            local st =
                                ConnoisseurCharDB and ConnoisseurCharDB.settings and
                                ConnoisseurCharDB.settings.scrollTypes
                            return st and st.Agility
                        end,
                        set = function(_, value)
                            ConnoisseurCharDB.settings.scrollTypes.Agility = value
                            if ns.ResetMacroState then
                                ns.ResetMacroState()
                            end
                            ns.RequestUpdate()
                        end
                    },
                    scrollIntellect = {
                        type = "toggle",
                        name = L["OPTIONS_SCROLL_INTELLECT"],
                        order = 2,
                        get = function()
                            local st =
                                ConnoisseurCharDB and ConnoisseurCharDB.settings and
                                ConnoisseurCharDB.settings.scrollTypes
                            return st and st.Intellect
                        end,
                        set = function(_, value)
                            ConnoisseurCharDB.settings.scrollTypes.Intellect = value
                            if ns.ResetMacroState then
                                ns.ResetMacroState()
                            end
                            ns.RequestUpdate()
                        end
                    },
                    scrollProtection = {
                        type = "toggle",
                        name = L["OPTIONS_SCROLL_PROTECTION"],
                        order = 3,
                        get = function()
                            local st =
                                ConnoisseurCharDB and ConnoisseurCharDB.settings and
                                ConnoisseurCharDB.settings.scrollTypes
                            return st and st.Protection
                        end,
                        set = function(_, value)
                            ConnoisseurCharDB.settings.scrollTypes.Protection = value
                            if ns.ResetMacroState then
                                ns.ResetMacroState()
                            end
                            ns.RequestUpdate()
                        end
                    },
                    scrollSpirit = {
                        type = "toggle",
                        name = L["OPTIONS_SCROLL_SPIRIT"],
                        order = 4,
                        get = function()
                            local st =
                                ConnoisseurCharDB and ConnoisseurCharDB.settings and
                                ConnoisseurCharDB.settings.scrollTypes
                            return st and st.Spirit
                        end,
                        set = function(_, value)
                            ConnoisseurCharDB.settings.scrollTypes.Spirit = value
                            if ns.ResetMacroState then
                                ns.ResetMacroState()
                            end
                            ns.RequestUpdate()
                        end
                    },
                    scrollStamina = {
                        type = "toggle",
                        name = L["OPTIONS_SCROLL_STAMINA"],
                        order = 5,
                        get = function()
                            local st =
                                ConnoisseurCharDB and ConnoisseurCharDB.settings and
                                ConnoisseurCharDB.settings.scrollTypes
                            return st and st.Stamina
                        end,
                        set = function(_, value)
                            ConnoisseurCharDB.settings.scrollTypes.Stamina = value
                            if ns.ResetMacroState then
                                ns.ResetMacroState()
                            end
                            ns.RequestUpdate()
                        end
                    },
                    scrollStrength = {
                        type = "toggle",
                        name = L["OPTIONS_SCROLL_STRENGTH"],
                        order = 6,
                        get = function()
                            local st =
                                ConnoisseurCharDB and ConnoisseurCharDB.settings and
                                ConnoisseurCharDB.settings.scrollTypes
                            return st and st.Strength
                        end,
                        set = function(_, value)
                            ConnoisseurCharDB.settings.scrollTypes.Strength = value
                            if ns.ResetMacroState then
                                ns.ResetMacroState()
                            end
                            ns.RequestUpdate()
                        end
                    }
                }
            },
            -- Pets
            spacePet0 = Spacer(35),
            headerPet = Header(L["OPTIONS_PET_HEADER"], 36),
            descPet = Desc(GetColor("DESC") .. L["OPTIONS_USE_PET_BUFFS_DESC"] .. "|r", 37),
            spacePet1 = Spacer(38),
            togglePetBuffs = {
                type = "toggle",
                name = L["OPTIONS_USE_PET_BUFFS"],
                desc = L["OPTIONS_USE_PET_BUFFS_DESC"],
                order = 39,
                width = 1.5,
                get = function()
                    return ConnoisseurCharDB and ConnoisseurCharDB.settings and
                        ConnoisseurCharDB.settings.usePetBuffFood
                end,
                set = function(_, value)
                    ConnoisseurCharDB.settings.usePetBuffFood = value
                    if ns.UpdateAuraTracking then
                        ns.UpdateAuraTracking()
                    end
                    if ns.ResetMacroState then
                        ns.ResetMacroState()
                    end
                    ns.RequestUpdate()
                end
            },
            petBuffFoodMode = {
                type = "select",
                name = "",
                order = 40,
                width = "normal",
                values = MODE_VALUES,
                sorting = ns.MODE_ORDER,
                disabled = function()
                    return not (ConnoisseurCharDB and ConnoisseurCharDB.settings and
                        ConnoisseurCharDB.settings.usePetBuffFood)
                end,
                get = function()
                    return ConnoisseurCharDB and ConnoisseurCharDB.settings and
                        ConnoisseurCharDB.settings.petBuffFoodMode or
                        "always"
                end,
                set = function(_, value)
                    ConnoisseurCharDB.settings.petBuffFoodMode = value
                    if ns.ResetMacroState then
                        ns.ResetMacroState()
                    end
                    ns.RequestUpdate()
                end
            },
            spacePetTypes0 = Spacer(40),
            petTypesGroup = {
                type = "group",
                name = L["OPTIONS_PET_BUFF_TYPES"],
                order = 41,
                inline = true,
                hidden = function()
                    return not (ConnoisseurCharDB and ConnoisseurCharDB.settings and
                        ConnoisseurCharDB.settings.usePetBuffFood)
                end,
                args = {
                    petKiblers = {
                        type = "toggle",
                        name = L["OPTIONS_PET_BUFF_KIBLERS"],
                        order = 1,
                        get = function()
                            local pt =
                                ConnoisseurCharDB and ConnoisseurCharDB.settings and
                                ConnoisseurCharDB.settings.petBuffTypes
                            return pt == nil or pt.KiblersBits ~= false
                        end,
                        set = function(_, value)
                            if not ConnoisseurCharDB.settings.petBuffTypes then
                                ConnoisseurCharDB.settings.petBuffTypes = {KiblersBits = true, SporelingSnacks = true}
                            end
                            ConnoisseurCharDB.settings.petBuffTypes.KiblersBits = value
                            if ns.ResetMacroState then
                                ns.ResetMacroState()
                            end
                            ns.RequestUpdate()
                        end
                    },
                    petSporeling = {
                        type = "toggle",
                        name = L["OPTIONS_PET_BUFF_SPORELING"],
                        order = 2,
                        get = function()
                            local pt =
                                ConnoisseurCharDB and ConnoisseurCharDB.settings and
                                ConnoisseurCharDB.settings.petBuffTypes
                            return pt == nil or pt.SporelingSnacks ~= false
                        end,
                        set = function(_, value)
                            if not ConnoisseurCharDB.settings.petBuffTypes then
                                ConnoisseurCharDB.settings.petBuffTypes = {KiblersBits = true, SporelingSnacks = true}
                            end
                            ConnoisseurCharDB.settings.petBuffTypes.SporelingSnacks = value
                            if ns.ResetMacroState then
                                ns.ResetMacroState()
                            end
                            ns.RequestUpdate()
                        end
                    }
                }
            },
            -- Night Elves
            spaceNightElf0 = {
                type = "description",
                name = " ",
                order = 50,
                hidden = function()
                    return not ns.IsNightElf
                end
            },
            headerNightElf = {
                type = "header",
                name = GetColor("TITLE") .. L["OPTIONS_NIGHTELF_HEADER"] .. "|r",
                order = 51,
                hidden = function()
                    return not ns.IsNightElf
                end
            },
            spaceNightElf1 = {
                type = "description",
                name = " ",
                order = 52,
                hidden = function()
                    return not ns.IsNightElf
                end
            },
            toggleShadowmeldDrinking = {
                type = "toggle",
                name = L["OPTIONS_SHADOWMELD_DRINKING"],
                desc = L["OPTIONS_SHADOWMELD_DRINKING_DESC"],
                order = 53,
                width = "full",
                hidden = function()
                    return not ns.IsNightElf
                end,
                get = function()
                    return ConnoisseurCharDB and ConnoisseurCharDB.settings and
                        ConnoisseurCharDB.settings.enableShadowmeldDrinking
                end,
                set = function(_, value)
                    if ns.ToggleShadowmeldDrinking then
                        ns.ToggleShadowmeldDrinking()
                    end
                end
            },
            -- Reset
            spaceReset0 = Spacer(80),
            headerReset = Header(L["OPTIONS_RESET_HEADER"], 81),
            spaceReset1 = Spacer(82),
            resetIgnore = {
                type = "execute",
                name = L["MENU_CLEAR_IGNORE"],
                desc = L["OPTIONS_RESET_IGNORE_DESC"],
                order = 83,
                width = "normal",
                confirm = true,
                confirmText = L["OPTIONS_RESET_IGNORE_CONFIRM"],
                func = function()
                    if ConnoisseurCharDB and ConnoisseurCharDB.ignoreList then
                        wipe(ConnoisseurCharDB.ignoreList)
                    end
                    if ns.UpdateMacros then
                        ns.UpdateMacros(true)
                    end
                end
            },
            -- Feedback & Support
            spaceCommunity0 = Spacer(90),
            headerCommunity = Header(L["OPTIONS_COMMUNITY_HEADER"], 91),
            spaceCommunity1 = Spacer(92),
            curseforgeLabel = Desc(GetColor("TITLE") .. "CurseForge" .. "|r", 93),
            curseforgeURL = {
                type = "input",
                name = "",
                order = 94,
                width = "double",
                get = function()
                    return ns.CURSEFORGE_URL
                end,
                set = function()
                end
            },
            spaceCommunity2 = Spacer(95),
            githubLabel = Desc(GetColor("TITLE") .. "GitHub" .. "|r", 96),
            githubURL = {
                type = "input",
                name = "",
                order = 97,
                width = "double",
                get = function()
                    return ns.GITHUB_URL
                end,
                set = function()
                end
            },
            spaceCommunity3 = Spacer(98),
            discordLabel = Desc(GetColor("TITLE") .. "Discord" .. "|r", 99),
            discordURL = {
                type = "input",
                name = "",
                order = 100,
                width = "double",
                get = function()
                    return ns.DISCORD_URL
                end,
                set = function()
                end
            }
        }
    }
end

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

AceConfig:RegisterOptionsTable(addonName, GetOptions)

local mainPanel = AceConfigDialog:AddToBlizOptions(addonName, L["BRAND"])

function ns.OpenOptions()
    if Settings and Settings.GetCategory then
        local category = Settings.GetCategory(L["BRAND"])
        if category then
            Settings.OpenToCategory(category.ID)
            return
        end
    end
    if InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(mainPanel)
        InterfaceOptionsFrame_OpenToCategory(mainPanel)
        return
    end
    AceConfigDialog:Open(addonName)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

SLASH_CONNOISSEUR1 = "/foodie"
SlashCmdList["CONNOISSEUR"] = function()
    if ns.OpenOptions then
        ns.OpenOptions()
    end
end