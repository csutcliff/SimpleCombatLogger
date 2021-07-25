local SimpleCombatLogger = LibStub("AceAddon-3.0"):NewAddon("SimpleCombatLogger", "AceConsole-3.0", "AceEvent-3.0")
local LoggingCombat = _G.LoggingCombat
local GetInstanceInfo = _G.GetInstanceInfo
local IsRatedBattleground = C_PvP.IsRatedBattleground
local IsRatedArena = C_PvP.IsRatedArena
local IsArenaSkirmish = C_PvP.IsArenaSkirmish
local IsLoggingArena = false

local options = {
    name = "SimpleCombatLogger",
    handler = SimpleCombatLogger,
    type = "group",
    args = {
        enable = {
            name = "Enabled",
            desc = "Enables / Disables the addon",
            type = "toggle",
            set = function(info, value) SimpleCombatLogger:SetEnable(value) end,
            get = function(info) return SimpleCombatLogger.db.profile.enable end
        },
        disableaclprompt = {
            name = "Disable ACL Reminder",
            desc = "Disables the Advanced Combat Logging prompt",
            type = "toggle",
            set = function(info, value) SimpleCombatLogger.db.profile.disableaclprompt = value end,
            get = function(info) return SimpleCombatLogger.db.profile.disableaclprompt end
        },
        enabledebug = {
            name = "Debug",
            desc = "Enable Debug output",
            type = "toggle",
            set = function(info, value) SimpleCombatLogger.db.profile.enabledebug = value end,
            get = function(info) return SimpleCombatLogger.db.profile.enabledebug end
        },
        party = {
            name = "Party",
            type = "group",
            args = {
                normal = {
                    name = "Normal",
                    desc = "Enables / Disables normal dungeon logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.party.normal = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.party.normal end
                },
                heroic = {
                    name = "Heroic",
                    desc = "Enables / Disables heroic dungeon logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.party.heroic = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.party.heroic end
                },
                mythicplus = {
                    name = "Mythic Plus",
                    desc = "Enables / Disables mythic plus logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.party.mythicplus = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.party.mythicplus end
                },
                mythic = {
                    name = "Mythic",
                    desc = "Enables / Disables mythic dungeon logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.party.mythic = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.party.mythic end
                },
                timewalking = {
                    name = "Timewalking",
                    desc = "Enables / Disables timewalking dungeon logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.party.timewalking = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.party.timewalking end
                },
            }
        },
        raid = {
            name = "Raid",
            type = "group",
            args = {
                lfr = {
                    name = "LFR",
                    desc = "Enables / Disables LFR raid logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.raid.lfr = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.lfr end
                },
                normal = {
                    name = "Normal",
                    desc = "Enables / Disables normal raid logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.raid.normal = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.normal end
                },
                heroic = {
                    name = "Heroic",
                    desc = "Enables / Disables heroic raid logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.raid.heroic = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.heroic end
                },
                mythic = {
                    name = "Mythic",
                    desc = "Enables / Disables mythic raid logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.raid.mythic = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.mythic end
                },
                timewalking = {
                    name = "Timewalking",
                    desc = "Enables / Disables timewalking raid logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.raid.timewalking = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.timewalking end
                },
            }
        },
        pvp = {
            name = "PvP",
            type = "group",
            args = {
                regularbg = {
                    name = "Battlegrounds",
                    desc = "Enables / Disables battleground logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.pvp.regularbg = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.pvp.regularbg end
                },
                ratedbg = {
                    name = "Rated Battlegrounds",
                    desc = "Enables / Disables rated battleground logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.pvp.ratedbg = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.pvp.ratedbg end
                },
                arenakirmish = {
                    name = "Arena Skirmish",
                    desc = "Enables / Disables arena skirmish logging",
                    type = "toggle",
                    set = function(info, value) SimpleCombatLogger.db.profile.pvp.arenakirmish = value end,
                    get = function(info) return SimpleCombatLogger.db.profile.pvp.arenaskirmish end
                },
                ratedarena = {
                    name = "Rated Arena",
                    desc = "Enables / Disables rated arena logging",
                    type = "toggle",
                    set = function(info, value) SimpleCombatLogger.db.profile.pvp.ratedarena = value end,
                    get = function(info) return SimpleCombatLogger.db.profile.pvp.ratedarena end
                },
            }
        },
        scenario = {
            name = "Scenarios",
            type = "group",
            args = {
                torghast = {
                    name = "Torghast",
                    desc = "Enables / Disables Torghast logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.scenario.torghast = value
                        SimpleCombatLogger:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.scenario.torghast end
                }
            }
        }
    }
}

local defaults = {
    profile = {
        enable = true,
        disableaclprompt = false,
        party = {
            ["*"] = true,
        },
        raid = {
            ["*"] = true,
        },
        pvp = {
            ["*"] = true,
        },
        scenario = {
            ["*"] = true,
        },
    }
}

function SimpleCombatLogger:OnInitialize()
    -- Called when the addon is initialized

    -- ACL Prompt
    StaticPopupDialogs["SCL_ENABLE_ACL"] = {
        text = "Advaned Combat Logging is required for most combat log parsers, would you like to enable it?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            SimpleCombatLogger:EnableACL()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
      }

    -- Initialisation
    self.db = LibStub("AceDB-3.0"):New("SimpleCombatLoggerDB", defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
    db = self.db.profile
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SimpleCombatLogger", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SimpleCombatLogger", "SimpleCombatLogger")
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SCL/Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SCL/Profiles", "Profiles", "SimpleCombatLogger")
    self:RegisterChatCommand("scl", "ChatCommand");
    self:RegisterChatCommand("SimpleCombatLogger", "ChatCommand");
end

function SimpleCombatLogger:OnProfileChanged(db,name)
    db = self.db.profile
    self:CheckLogging(nil)
end

function SimpleCombatLogger:EnableACL()
    SetCVar("advancedCombatLogging", 1)
end

function SimpleCombatLogger:OnEnable()
    if (not db.enable) then
        self:OnDisable()
        return
    end

    self:Print("Enabled")
    if (not db.disableaclprompt and GetCVar("advancedCombatLogging") == "0") then
        StaticPopup_Show ("SCL_ENABLE_ACL")
    end
    self:RegisterEvent("UPDATE_INSTANCE_INFO", "CheckEnableLogging")
    self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "CheckEnableLogging")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "CheckDisableLogging")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckArenaLogging")
    self:CheckToggleLogging(nil)
end



function SimpleCombatLogger:OnDisable()
    self:Print("Disabled")
    self:UnregisterEvent("UPDATE_INSTANCE_INFO")
    self:UnregisterEvent("PLAYER_DIFFICULTY_CHANGED")
    self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
    self:StopLogging()
end

function SimpleCombatLogger:ChatCommand(input)
    if (not input or input:trim() == "") then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    elseif (input:trim() == "enable") then
        self:SetEnable(true)
    elseif (input:trim() == "disable") then
        self:SetEnable(false)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(SimpleCombatLogger, "SimpleCombatLogger", "SimpleCombatLogger", input)
    end
end

function SimpleCombatLogger:SetEnable(value)
    if (db.enable == value) then
        return
    end
    db.enable = value
    if (value) then
        SimpleCombatLogger:OnEnable()
    else
        SimpleCombatLogger:OnDisable()
    end
end

function SimpleCombatLogger:StartLogging()
    if not LoggingCombat() then
        self:Print("Starting Combat Logging")
        LoggingCombat(true)
    end
end

function SimpleCombatLogger:StopLogging()
    if LoggingCombat() then
        self:Print("Stopping Combat Logging")
        LoggingCombat(false)
    end
end

function SimpleCombatLogger:CheckToggleLogging(event)
    self:CheckDisableLogging(event)
    self:CheckEnableLogging(event)
end

function SimpleCombatLogger:CheckEnableLogging(event)
    if (db.profile.enabledebug) then
        self:Print("Check Enable")
        self:Print(event)
        self:Print(GetInstanceInfo())
    end
    local _, instanceType, difficultyID = GetInstanceInfo();
    if (instanceType == "pvp") then
        if (IsRatedBattleground()) then -- Returns false in regular BG, need to test in rated
            if (db.pvp.ratedbg) then
                self:StartLogging()
            end
        elseif (db.pvp.regularbg) then
            self:StartLogging()
        end
    elseif (instanceType == "party") then
        if (difficultyID == 1) then -- Normal
            if (db.party.normal) then
                self:StartLogging()
            end
        elseif (difficultyID == 2) then -- Heroic
            if (db.party.heroic) then
                self:StartLogging()
            end
        elseif (difficultyID == 8) then -- Mythic Plus
            if (db.party.mythicplus) then
                self:StartLogging()
            end
        elseif (difficultyID == 23) then -- Mythic
            if (db.party.mythic) then
                self:StartLogging()
            end
        elseif (difficultyID == 24) then -- Timewalking
            if (db.party.timewalking) then
                self:StartLogging()
            end
        end
    elseif (instanceType == "raid") then
        if (difficultyID == 7 or difficultyID == 17) then -- LFR
            if (db.raid.lfr) then
                self:StartLogging()
            end
        elseif (difficultyID == 3 or difficultyID == 4 or difficultyID == 9 or difficultyID == 14) then -- Normal
            if (db.raid.normal) then
                self:StartLogging()
            end
        elseif (difficultyID == 5 or difficultyID == 6 or difficultyID == 15) then -- Heroic
            if (db.raid.heroic) then
                self:StartLogging()
            end
        elseif (difficultyID == 16) then -- Mythic
            if (db.raid.mythic) then
                self:StartLogging()
            end
        elseif (difficultyID == 33 or difficultyID == 151) then -- Timewalking
            if (db.raid.timewalking) then
                self:StartLogging()
            end
        end
    elseif (instanceType == "scenario") then
        if (difficultyID == 167) then -- Torghast
            if (db.scenario.torghast) then
                self:StartLogging()
            end
        end
    end
end

function SimpleCombatLogger:CheckArenaLogging(event)
    if (db.profile.enabledebug) then
        self:Print("Check Arena")
        self:Print(event)
        self:Print(GetInstanceInfo())
    end
    local _, instanceType = GetInstanceInfo();
    if (instanceType == "arena") then
        if (IsRatedArena() and not IsArenaSkirmish()) then
            if (db.pvp.ratedarena) then
                IsLoggingArena = true
                self:StartLogging()
            else
                IsLoggingArena = false
                self:StopLogging()
            end
        elseif (IsArenaSkirmish() and db.pvp.arenakirmish) then
            IsLoggingArena = true
            self:StartLogging()
        else
            IsLoggingArena = false
            self:StopLogging()
        end
    elseif (IsLoggingArena) then
        IsLoggingArena = false
        self:StopLogging()
    end
end

function SimpleCombatLogger:CheckDisableLogging(event)
    if (db.profile.enabledebug) then
        self:Print("Check Disable")
        self:Print(event)
        self:Print(GetInstanceInfo())
    end
    local _, instanceType, difficultyID = GetInstanceInfo();
    if (instanceType == nil or instanceType == "none") then
        self:StopLogging()
        return
    elseif (instanceType == "pvp") then
        if (IsRatedBattleground()) then -- Returns false in regular BG, need to test in rated
            if (not db.pvp.ratedbg) then
                self:StopLogging()
            end
        elseif (not db.pvp.regularbg) then
            self:StopLogging()
        end
    elseif (instanceType == "party") then
        if (difficultyID == 1) then -- Normal
            if (not db.party.normal) then
                self:StopLogging()
            end
        elseif (difficultyID == 2) then -- Heroic
            if (not db.party.heroic) then
                self:StopLogging()
            end
        elseif (difficultyID == 8) then -- Mythic Plus
            if (not db.party.mythicplus) then
                self:StopLogging()
            end
        elseif (difficultyID == 23) then -- Mythic
            if (not db.party.mythic) then
                self:StopLogging()
            end
        elseif (difficultyID == 24) then -- Timewalking
            if (not db.party.timewalking) then
                self:StopLogging()
            end
        else
            self:StopLogging()
        end
    elseif (instanceType == "raid") then
        if (difficultyID == 7 or difficultyID == 17) then -- LFR
            if (not db.raid.lfr) then
                self:StopLogging()
            end
        elseif (difficultyID == 3 or difficultyID == 4 or difficultyID == 9 or difficultyID == 14) then -- Normal
            if (not db.raid.normal) then
                self:StopLogging()
            end
        elseif (difficultyID == 5 or difficultyID == 6 or difficultyID == 15) then -- Heroic
            if (not db.raid.heroic) then
                self:StopLogging()
            end
        elseif (difficultyID == 16) then -- Mythic
            if (not db.raid.mythic) then
                self:StopLogging()
            end
        elseif (difficultyID == 33 or difficultyID == 151) then -- Timewalking
            if (not db.raid.timewalking) then
                self:StopLogging()
            end
        else
            self:StopLogging()
        end
    elseif (instanceType == "scenario") then
        if (difficultyID == 167) then -- Torghast
            if (not db.scenario.torghast) then
                self:StopLogging()
            end
        end
    end
end