local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local Header = ns.OptionsHeader
local Desc = ns.OptionsDesc
local Spacer = ns.OptionsSpacer

--------------------------------------------------------------------------------
-- Active-State Predicates
--------------------------------------------------------------------------------

--[[
    Each feature's mode dropdown and option sub-controls are hidden until the
    feature toggle is on, mirroring the guide's "hide unavailable controls"
    rule. These read the per-character settings table that InitVars guarantees.
]]

local function GetCharSettings()
    return ns.db and ns.db.profile
end

local function BuffFoodActive()
    local s = GetCharSettings()
    return s and s.useBuffFood
end

local function ScrollsActive()
    local s = GetCharSettings()
    return s and s.useScrolls
end

local function PetBuffActive()
    local s = GetCharSettings()
    return s and s.usePetBuffFood
end

--------------------------------------------------------------------------------
-- Shared Widget Factories
--------------------------------------------------------------------------------

--[[
    Group-restriction mode dropdown shared by Buff Food, Scrolls, and Pet Food.
    Hidden until the owning feature is enabled; selecting a mode rewrites the
    macros under the throttle.
]]
local function FeatureMode(settingKey, activeFn, order)
    return {
        type = "select",
        name = "",
        order = order,
        width = "normal",
        values = ns.MODE_VALUES,
        sorting = ns.MODE_ORDER,
        hidden = function()
            return not activeFn()
        end,
        get = function()
            return ns.db.profile[settingKey] or "always"
        end,
        set = function(_, value)
            ns.db.profile[settingKey] = value
            if ns.ResetMacroState then
                ns.ResetMacroState()
            end
            ns.RequestUpdate()
        end,
    }
end

-- Toggle for one entry inside a per-character settings subtable (scroll/pet types).
local function SubsetToggle(subtable, key, label, order)
    return {
        type = "toggle",
        name = label,
        order = order,
        get = function()
            local t = ns.db.profile[subtable]
            return t and t[key]
        end,
        set = function(_, value)
            ns.db.profile[subtable][key] = value
            if ns.ResetMacroState then
                ns.ResetMacroState()
            end
            ns.RequestUpdate()
        end,
    }
end

--[[
    One factory for the ten Enable Macros toggles. hiddenFn is optional —
    Feed Pet uses it to stay hidden on non-Hunter characters.
]]
local function MacroToggle(label, key, order, hiddenFn)
    return {
        type = "toggle",
        name = label,
        order = order,
        width = "normal",
        hidden = hiddenFn,
        get = function()
            return ns.db.profile.enabledMacros[key]
        end,
        set = function(_, value)
            ns.db.profile.enabledMacros[key] = value
            if ns.ResetMacroState then
                ns.ResetMacroState()
            end
            ns.RequestUpdate()
        end,
    }
end

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

--[[
    The single settings page. Per the guide's Main Page Layout, all
    feature-specific settings live here rather than as separate Blizzard
    sub-panels: general settings, the Buff Food / Scroll / Explosives / Pet
    Food tuning sections, Enable Macros, the class/race-gated Druid and Night
    Elf sections (hidden for other characters), reset, feedback links, and
    version. Only
    Diagnostic Tools is a separate panel. Order values are grouped in blocks
    (100s per section) so sections can be reordered or extended without
    renumbering their neighbors.
]]

function ns.BuildGeneralOptions()
    return {
        name = L["ADDON_TITLE"],
        type = "group",
        args = {
            descIntro = Desc(L["OPTIONS_DESCRIPTION"], 1),

            -- Welcome Message
            spaceWelcome0 = Spacer(10),
            toggleWelcomeMessage = {
                type = "toggle",
                name = L["OPTIONS_WELCOME_MESSAGE"],
                desc = L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"],
                order = 11,
                width = "full",
                get = function()
                    return ns.db and ns.db.profile.showWelcome
                end,
                set = function(_, value)
                    if ns.db then
                        ns.db.profile.showWelcome = value
                    end
                end,
            },

            -- Minimap Button
            toggleMinimapButton = {
                type = "toggle",
                name = L["OPTIONS_MINIMAP_BUTTON"],
                desc = L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"],
                order = 13,
                width = "full",
                get = function()
                    return not (ns.db and ns.db.global.minimap and ns.db.global.minimap.hide)
                end,
                set = function(_, value)
                    if ns.ToggleMinimapButton then
                        ns.ToggleMinimapButton(value)
                    end
                end,
            },

            -- /Commands
            spaceCommands0 = Spacer(20),
            headerCommands = Header(L["OPTIONS_COMMANDS_HEADER"], 21),
            spaceCommands1 = Spacer(22),
            descCommands = Desc(
                GetColor("INFO") .. L["OPTIONS_COMMANDS_DESCRIPTION"] .. "|r" .. "  " .. L["OPTIONS_COMMANDS_DETAIL"],
                23
            ),

            -- Potions & Healthstones
            spacePotions0 = Spacer(30),
            headerPotions = Header(L["OPTIONS_POTIONS_HEADER"], 31),
            spacePotions1 = Spacer(32),
            descPotions = Desc(GetColor("BODY") .. L["OPTIONS_POTIONS_DESCRIPTION"] .. "|r", 33),
            spacePotions2 = Spacer(34),
            toggleCombineHealthstones = {
                type = "toggle",
                name = L["OPTIONS_COMBINE_HEALTHSTONES"],
                desc = L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"],
                order = 35,
                width = "full",
                get = function()
                    local s = GetCharSettings()
                    return s and s.combineHealthstones
                end,
                set = function(_, value)
                    ns.db.profile.combineHealthstones = value
                    if ns.ResetMacroState then
                        ns.ResetMacroState()
                    end
                    ns.RequestUpdate()
                end,
            },

            -- Buff Food
            spaceBuff0 = Spacer(100),
            headerBuff = Header(L["OPTIONS_BUFF_FOOD_HEADER"], 101),
            spaceBuff1 = Spacer(102),
            descBuff = Desc(GetColor("BODY") .. L["OPTIONS_BUFF_FOOD_DESCRIPTION"] .. "|r", 103),
            spaceBuff2 = Spacer(104),
            toggleBuffFood = {
                type = "toggle",
                name = L["OPTIONS_BUFF_FOOD"],
                desc = L["OPTIONS_BUFF_FOOD_DESCRIPTION"],
                order = 105,
                width = "full",
                get = function()
                    return BuffFoodActive()
                end,
                set = function(_, value)
                    if ns.ToggleBuffFood then
                        ns.ToggleBuffFood(value)
                    end
                end,
            },
            buffFoodMode = FeatureMode("buffFoodMode", BuffFoodActive, 106),
            spaceBuff3 = Spacer(107),
            detailBuff = Desc(GetColor("BODY") .. L["OPTIONS_BUFF_FOOD_DETAIL"] .. "|r", 108),

            -- Scroll Buffs
            spaceScroll0 = Spacer(200),
            headerScroll = Header(L["OPTIONS_SCROLL_HEADER"], 201),
            spaceScroll1 = Spacer(202),
            descScroll = Desc(GetColor("BODY") .. L["OPTIONS_USE_SCROLLS_DESCRIPTION"] .. "|r", 203),
            spaceScroll2 = Spacer(204),
            toggleScrolls = {
                type = "toggle",
                name = L["OPTIONS_USE_SCROLLS"],
                desc = L["OPTIONS_USE_SCROLLS_DESCRIPTION"],
                order = 205,
                width = "full",
                get = function()
                    return ScrollsActive()
                end,
                set = function(_, value)
                    if ns.ToggleScrollBuffs then
                        ns.ToggleScrollBuffs(value)
                    end
                end,
            },
            scrollsMode = FeatureMode("scrollsMode", ScrollsActive, 206),
            spaceScrollTypes0 = Spacer(207, function()
                return not ScrollsActive()
            end),
            scrollTypesGroup = {
                type = "group",
                name = L["OPTIONS_SCROLL_TYPES"],
                order = 208,
                inline = true,
                hidden = function()
                    return not ScrollsActive()
                end,
                args = {
                    scrollAgility = SubsetToggle("scrollTypes", "Agility", L["OPTIONS_SCROLL_AGILITY"], 1),
                    scrollIntellect = SubsetToggle("scrollTypes", "Intellect", L["OPTIONS_SCROLL_INTELLECT"], 2),
                    scrollProtection = SubsetToggle("scrollTypes", "Protection", L["OPTIONS_SCROLL_PROTECTION"], 3),
                    scrollSpirit = SubsetToggle("scrollTypes", "Spirit", L["OPTIONS_SCROLL_SPIRIT"], 4),
                    scrollStamina = SubsetToggle("scrollTypes", "Stamina", L["OPTIONS_SCROLL_STAMINA"], 5),
                    scrollStrength = SubsetToggle("scrollTypes", "Strength", L["OPTIONS_SCROLL_STRENGTH"], 6),
                },
            },

            -- Explosives
            spaceExplosives0 = Spacer(250),
            headerExplosives = Header(L["OPTIONS_EXPLOSIVES_HEADER"], 251),
            spaceExplosives1 = Spacer(252),
            descExplosives = Desc(GetColor("BODY") .. L["OPTIONS_EXPLOSIVES_DESCRIPTION"] .. "|r", 253),
            spaceExplosives2 = Spacer(254),
            explosivesClickMode = {
                type = "select",
                name = "",
                order = 255,
                width = "double",
                values = {
                    atplayer = L["EXPLOSIVES_MODE_ATPLAYER"],
                    toss = L["EXPLOSIVES_MODE_TOSS"],
                },
                sorting = {"atplayer", "toss"},
                get = function()
                    return ns.db.profile.explosivesClickMode or "atplayer"
                end,
                set = function(_, value)
                    ns.db.profile.explosivesClickMode = value
                    if ns.ResetMacroState then
                        ns.ResetMacroState()
                    end
                    ns.RequestUpdate()
                end,
            },

            -- Pet Food Buffs
            spacePet0 = Spacer(300),
            headerPet = Header(L["OPTIONS_PET_HEADER"], 301),
            spacePet1 = Spacer(302),
            descPet = Desc(GetColor("BODY") .. L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] .. "|r", 303),
            spacePet2 = Spacer(304),
            togglePetBuffs = {
                type = "toggle",
                name = L["OPTIONS_USE_PET_BUFFS"],
                desc = L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"],
                order = 305,
                width = "full",
                get = function()
                    return PetBuffActive()
                end,
                set = function(_, value)
                    ns.db.profile.usePetBuffFood = value
                    if ns.UpdateAuraTracking then
                        ns.UpdateAuraTracking()
                    end
                    if ns.ResetMacroState then
                        ns.ResetMacroState()
                    end
                    ns.RequestUpdate()
                end,
            },
            petBuffFoodMode = FeatureMode("petBuffFoodMode", PetBuffActive, 306),
            spacePetTypes0 = Spacer(307, function()
                return not PetBuffActive()
            end),
            petTypesGroup = {
                type = "group",
                name = L["OPTIONS_PET_BUFF_TYPES"],
                order = 308,
                inline = true,
                hidden = function()
                    return not PetBuffActive()
                end,
                args = {
                    petKiblers = SubsetToggle("petBuffTypes", "KiblersBits", L["OPTIONS_PET_BUFF_KIBLERS"], 1),
                    petSporeling = SubsetToggle("petBuffTypes", "SporelingSnacks", L["OPTIONS_PET_BUFF_SPORELING"], 2),
                },
            },

            -- Enable Macros
            spaceEnable0 = Spacer(400),
            headerEnableMacros = Header(L["OPTIONS_ENABLE_MACROS_HEADER"], 401),
            spaceEnable1 = Spacer(402),
            descEnableMacros = Desc(GetColor("BODY") .. L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] .. "|r", 403),
            spaceEnable2 = Spacer(404),
            enableBandage = MacroToggle(L["MACRO_BANDAGE"], "Bandage", 405),
            enableExplosive = MacroToggle(L["MACRO_EXPLOSIVES"], "Explosive", 406),
            enableFeedPet = MacroToggle(L["MACRO_FEED_PET"], "Feed Pet", 407, function() return not ns.IsHunter end),
            enableFood = MacroToggle(L["MACRO_FOOD"], "Food", 408),
            enableHealthPotion = MacroToggle(L["MACRO_HEALTH_POTION"], "Health Potion", 409),
            enableHealthstone = MacroToggle(L["MACRO_HEALTHSTONE"], "Healthstone", 410),
            enableManaGem = MacroToggle(L["MACRO_MANA_GEM"], "Mana Gem", 411),
            enableManaPotion = MacroToggle(L["MACRO_MANA_POTION"], "Mana Potion", 412),
            enableSoulstone = MacroToggle(L["MACRO_SOULSTONE"], "Soulstone", 413),
            enableWater = MacroToggle(L["MACRO_WATER"], "Water", 414),

            -- Druids
            spaceDruid0 = {
                type = "description",
                name = " ",
                order = 500,
                hidden = function() return not ns.IsDruid end,
            },
            headerDruid = {
                type = "header",
                name = GetColor("TITLE") .. L["OPTIONS_DRUIDS_HEADER"] .. "|r",
                order = 501,
                hidden = function() return not ns.IsDruid end,
            },
            spaceDruid1 = {
                type = "description",
                name = " ",
                order = 502,
                hidden = function() return not ns.IsDruid end,
            },
            toggleDruidMacroHelper = {
                type = "toggle",
                name = L["OPTIONS_DRUID_MACRO_HELPER"],
                desc = L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"],
                order = 503,
                width = "full",
                hidden = function() return not ns.IsDruid end,
                get = function()
                    return ns.db and ns.db.profile
                        and ns.db.profile.enableDruidMacroHelper
                end,
                set = function(_, value)
                    if ns.ToggleDruidMacroHelper then
                        ns.ToggleDruidMacroHelper(value)
                    end
                end,
            },
            druidReturnForm = {
                type = "select",
                name = L["OPTIONS_DRUID_RETURN_FORM"],
                order = 504,
                width = "normal",
                values = {
                    bear = L["DRUID_FORM_BEAR"],
                    cat = L["DRUID_FORM_CAT"],
                },
                sorting = {"bear", "cat"},
                hidden = function()
                    if not ns.IsDruid then return true end
                    local settings = ns.db and ns.db.profile
                    return not (settings and settings.enableDruidMacroHelper)
                end,
                get = function()
                    return ns.db.profile.druidReturnForm or "bear"
                end,
                set = function(_, value)
                    ns.db.profile.druidReturnForm = value
                    if ns.ResetMacroState then
                        ns.ResetMacroState()
                    end
                    ns.RequestUpdate()
                end,
            },

            -- Night Elves
            spaceNightElf0 = {
                type = "description",
                name = " ",
                order = 600,
                hidden = function() return not ns.IsNightElf end,
            },
            headerNightElf = {
                type = "header",
                name = GetColor("TITLE") .. L["OPTIONS_NIGHTELF_HEADER"] .. "|r",
                order = 601,
                hidden = function() return not ns.IsNightElf end,
            },
            spaceNightElf1 = {
                type = "description",
                name = " ",
                order = 602,
                hidden = function() return not ns.IsNightElf end,
            },
            toggleShadowmeldDrinking = {
                type = "toggle",
                name = L["OPTIONS_SHADOWMELD_DRINKING"],
                desc = L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"],
                order = 603,
                width = "full",
                hidden = function() return not ns.IsNightElf end,
                get = function()
                    return ns.db and ns.db.profile
                        and ns.db.profile.enableShadowmeldDrinking
                end,
                set = function(_, value)
                    if ns.ToggleShadowmeldDrinking then
                        ns.ToggleShadowmeldDrinking(value)
                    end
                end,
            },

            --[[
                Ignore List -- clearing it is a feature action, not a settings
                reset, so it stays on the General panel. Both grades of settings
                reset (Reset Profile, Reset All Profiles) live on the Profiles
                panel per the guide.
            ]]
            spaceIgnore0 = Spacer(800),
            headerIgnore = Header(L["UI_IGNORE_LIST"], 801),
            spaceIgnore1 = Spacer(802),
            resetIgnore = {
                type = "execute",
                name = L["MENU_CLEAR_IGNORE"],
                desc = L["OPTIONS_RESET_IGNORE_DESCRIPTION"],
                order = 803,
                width = "normal",
                confirm = true,
                confirmText = L["OPTIONS_RESET_IGNORE_CONFIRM"],
                func = function()
                    if ns.db and ns.db.profile.ignoreList then
                        wipe(ns.db.profile.ignoreList)
                    end
                    if ns.UpdateMacros then
                        ns.UpdateMacros(true)
                    end
                end,
            },

            -- Feedback & Support
            spaceCommunity0 = Spacer(900),
            headerCommunity = Header(L["OPTIONS_COMMUNITY_HEADER"], 901),
            spaceCommunity1 = Spacer(902),
            discordLabel = Desc(GetColor("TITLE") .. "Discord" .. "|r", 903),
            discordURL = {
                type = "input",
                name = "",
                order = 904,
                width = "double",
                get = function() return ns.DISCORD_URL end,
                set = function() end,
            },
            spaceCommunity2 = Spacer(905),
            githubLabel = Desc(GetColor("TITLE") .. "GitHub" .. "|r", 906),
            githubURL = {
                type = "input",
                name = "",
                order = 907,
                width = "double",
                get = function() return ns.GITHUB_URL end,
                set = function() end,
            },
            spaceCommunity3 = Spacer(908),
            curseforgeLabel = Desc(GetColor("TITLE") .. "CurseForge" .. "|r", 909),
            curseforgeURL = {
                type = "input",
                name = "",
                order = 910,
                width = "double",
                get = function() return ns.CURSEFORGE_URL end,
                set = function() end,
            },
            spaceCommunity4 = Spacer(911),
            wagoLabel = Desc(GetColor("TITLE") .. "Wago" .. "|r", 912),
            wagoURL = {
                type = "input",
                name = "",
                order = 913,
                width = "double",
                get = function() return ns.WAGO_URL end,
                set = function() end,
            },

            -- Version
            spaceVersion0 = {
                type = "description",
                name = " ",
                width = "full",
                order = 998,
            },
            versionLine = {
                type = "description",
                name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
                fontSize = "medium",
                order = 999,
            },
        },
    }
end
