local SimpleCombatLogger = LibStub("AceAddon-3.0"):NewAddon("SimpleCombatLogger", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local IsLoggingCombat = false
local DelayStopTimer = nil

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
        delaystop = {
            name = "Delayed Log Stop",
            desc = "Delay the stopping of combat logging by 30 seconds, this can help compatibility with some external programs such as SquadOV",
            type = "toggle",
            set = function(info, value) SimpleCombatLogger.db.profile.delaystop = value end,
            get = function(info) return SimpleCombatLogger.db.profile.delaystop end
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
                arenaskirmish = {
                    name = "Arena Skirmish",
                    desc = "Enables / Disables arena skirmish logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.pvp.arenaskirmish = value
                        SimpleCombatLogger:CheckArenaLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLogger.db.profile.pvp.arenaskirmish end
                },
                ratedarena = {
                    name = "Rated Arena",
                    desc = "Enables / Disables rated arena logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLogger.db.profile.pvp.ratedarena = value
                        SimpleCombatLogger:CheckArenaLogging(nil)
                    end,
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
        enabledebug = false,
        delaystop = true,
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
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SimpleCombatLogger", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SimpleCombatLogger", "SimpleCombatLogger")
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SCL/Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SCL/Profiles", "Profiles", "SimpleCombatLogger")
    self:RegisterChatCommand("scl", "ChatCommand");
    self:RegisterChatCommand("SimpleCombatLogger", "ChatCommand");
    hooksecurefunc("LoggingCombat", function(state)
        IsLoggingCombat = state
        if (self.db.profile.enabledebug) then
            self:Print("LoggingCombat called with: " .. tostring(state));
        end
    end);
end

function SimpleCombatLogger:RefreshConfig()
    self:CheckToggleLogging(nil)
end

function SimpleCombatLogger:EnableACL()
    SetCVar("advancedCombatLogging", 1)
end

function SimpleCombatLogger:OnEnable()
    if (not self.db.profile.enable) then
        self:OnDisable()
        return
    end

    self:Print("Enabled")
    if (not self.db.profile.disableaclprompt and GetCVar("advancedCombatLogging") == "0") then
        StaticPopup_Show ("SCL_ENABLE_ACL")
    end
    self:RegisterEvent("UPDATE_INSTANCE_INFO", "CheckEnableLogging")
    self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "CheckEnableLogging")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "CheckDisableLogging")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ArenaEventTimer")
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
    elseif (input:trim() == "test") then
        self:Print("Logging Combat: " .. tostring(IsLoggingCombat))
        self:Print("Instance Info: " .. tostring(GetInstanceInfo()))
        self:Print("Rated Arena: " .. tostring(C_PvP.IsRatedArena()))
        self:Print("Arena Skirmish: " .. tostring(IsArenaSkirmish()))
        self:Print("Rated BG: " .. tostring(C_PvP.IsRatedBattleground()))
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(SimpleCombatLogger, "SimpleCombatLogger", "SimpleCombatLogger", input)
    end
end

function SimpleCombatLogger:SetEnable(value)
    if (self.db.profile.enable == value) then
        return
    end
    self.db.profile.enable = value
    if (value) then
        SimpleCombatLogger:OnEnable()
    else
        SimpleCombatLogger:OnDisable()
    end
end

function SimpleCombatLogger:StartLogging()
    if (DelayStopTimer ~= nil) then
        self:CancelTimer(DelayStopTimer)
        DelayStopTimer = nil
    end
    if (not IsLoggingCombat) then
        self:Print("Starting Combat Logging")
        if (LoggingCombat(true)) then
            if (self.db.profile.enabledebug) then
                self:Print("Successfully started Combat Logging")
            end
        else
            self:Print("Failed to start Combat Logging") -- this should never be hit
        end
    end
end

function SimpleCombatLogger:StopLogging()
    if (IsLoggingCombat) then
        if (self.db.profile.delaystop) then
            if (self.db.profile.enabledebug) then
                self:Print("Delay enabled, stopping in 30 seconds")
            end
            if (DelayStopTimer ~= nil) then
                if (self.db.profile.enabledebug) then
                    self:Print("Another delayed stop is queued, overwriting it")
                end
                self:CancelTimer(DelayStopTimer)
            end
            DelayStopTimer = self:ScheduleTimer("StopLoggingNow", 30)
        else
            self:StopLoggingNow()
        end
    elseif (self.db.profile.enabledebug) then
        self:Print("Combat logging is already stopped")
    end
end

function SimpleCombatLogger:StopLoggingNow()
    DelayStopTimer = nil
    if (IsLoggingCombat) then
        self:Print("Stopping Combat Logging")
        if (not LoggingCombat(false)) then
            if (self.db.profile.enabledebug) then
                self:Print("Successfully stopped Combat Logging")
            end
        elseif (self.db.profile.enabledebug) then
            self:Print("Failed to stop Combat Logging")
        end
    elseif (self.db.profile.enabledebug) then
        self:Print("Combat Logging is not running")
    end
end

function SimpleCombatLogger:ArenaEventTimer(event)
    if (self.db.profile.enabledebug) then
        self:Print("Event: " .. tostring(event))
        self:Print("Instance Info: " .. tostring(GetInstanceInfo()))
    end
    local _, instanceType = GetInstanceInfo();
    if (instanceType == "arena") then
        if (self.db.profile.enabledebug) then
            self:Print("Scheduling arena check for 5 seconds")
        end
        self:ScheduleTimer("CheckArenaLogging", 5)
    end
end

function SimpleCombatLogger:CheckToggleLogging(event)
    if (IsLoggingCombat) then
        self:CheckDisableLogging(nil)
    else
        self:CheckEnableLogging(nil)
    end
end

function SimpleCombatLogger:CheckEnableLogging(event)
    if (self.db.profile.enabledebug) then
        self:Print("Check Enable")
        self:Print("Currently Logging: " .. tostring(IsLoggingCombat))
        self:Print("Event: " .. tostring(event))
        self:Print("Instance Info: " .. tostring(GetInstanceInfo()))
    end
    local _, instanceType, difficultyID = GetInstanceInfo();
    if (instanceType == "pvp") then
        if (C_PvP.IsRatedBattleground()) then -- Returns false in regular BG, need to test in rated
            if (self.db.profile.pvp.ratedbg) then
                self:StartLogging()
            end
        elseif (self.db.profile.pvp.regularbg) then
            self:StartLogging()
        end
    elseif (instanceType == "party") then
        if (difficultyID == 1) then -- Normal
            if (self.db.profile.party.normal) then
                self:StartLogging()
            end
        elseif (difficultyID == 2) then -- Heroic
            if (self.db.profile.party.heroic) then
                self:StartLogging()
            end
        elseif (difficultyID == 8) then -- Mythic Plus
            if (self.db.profile.party.mythicplus) then
                self:StartLogging()
            end
        elseif (difficultyID == 23) then -- Mythic
            if (self.db.profile.party.mythic) then
                self:StartLogging()
            end
        elseif (difficultyID == 24) then -- Timewalking
            if (self.db.profile.party.timewalking) then
                self:StartLogging()
            end
        end
    elseif (instanceType == "raid") then
        if (difficultyID == 7 or difficultyID == 17) then -- LFR
            if (self.db.profile.raid.lfr) then
                self:StartLogging()
            end
        elseif (difficultyID == 3 or difficultyID == 4 or difficultyID == 9 or difficultyID == 14) then -- Normal
            if (self.db.profile.raid.normal) then
                self:StartLogging()
            end
        elseif (difficultyID == 5 or difficultyID == 6 or difficultyID == 15) then -- Heroic
            if (self.db.profile.raid.heroic) then
                self:StartLogging()
            end
        elseif (difficultyID == 16) then -- Mythic
            if (self.db.profile.raid.mythic) then
                self:StartLogging()
            end
        elseif (difficultyID == 33 or difficultyID == 151) then -- Timewalking
            if (self.db.profile.raid.timewalking) then
                self:StartLogging()
            end
        end
    elseif (instanceType == "scenario") then
        if (difficultyID == 167) then -- Torghast
            if (self.db.profile.scenario.torghast) then
                self:StartLogging()
            end
        end
    end
end

function SimpleCombatLogger:CheckArenaLogging()
    if (self.db.profile.enabledebug) then
        self:Print("Check Arena")
        self:Print("Currently Logging: " .. tostring(IsLoggingCombat))
        self:Print("Rated Arena: " .. tostring(C_PvP.IsRatedArena()))
        self:Print("Arena Skirmish: " .. tostring(IsArenaSkirmish()))
    end
    if (C_PvP.IsRatedArena() and not IsArenaSkirmish()) then
        if (self.db.profile.pvp.ratedarena) then
            self:StartLogging()
        else
            self:StopLogging()
        end
    elseif (IsArenaSkirmish() and self.db.profile.pvp.arenaskirmish) then
        self:StartLogging()
    else
        self:StopLogging()
    end
end

function SimpleCombatLogger:CheckDisableLogging(event)
    if (self.db.profile.enabledebug) then
        self:Print("Check Disable")
        self:Print("Currently Logging: " .. tostring(IsLoggingCombat))
        self:Print("Event: " .. tostring(event))
        self:Print("Instance Info: " .. tostring(GetInstanceInfo()))
    end
    local _, instanceType, difficultyID = GetInstanceInfo();
    if (instanceType == nil or instanceType == "none") then
        self:StopLogging()
        return
    elseif (instanceType == "pvp") then
        if (C_PvP.IsRatedBattleground()) then -- Returns false in regular BG, need to test in rated
            if (not self.db.profile.pvp.ratedbg) then
                self:StopLogging()
            end
        elseif (not self.db.profile.pvp.regularbg) then
            self:StopLogging()
        end
    elseif (instanceType == "party") then
        if (difficultyID == 1) then -- Normal
            if (not self.db.profile.party.normal) then
                self:StopLogging()
            end
        elseif (difficultyID == 2) then -- Heroic
            if (not self.db.profile.party.heroic) then
                self:StopLogging()
            end
        elseif (difficultyID == 8) then -- Mythic Plus
            if (not self.db.profile.party.mythicplus) then
                self:StopLogging()
            end
        elseif (difficultyID == 23) then -- Mythic
            if (not self.db.profile.party.mythic) then
                self:StopLogging()
            end
        elseif (difficultyID == 24) then -- Timewalking
            if (not self.db.profile.party.timewalking) then
                self:StopLogging()
            end
        else
            self:StopLogging()
        end
    elseif (instanceType == "raid") then
        if (difficultyID == 7 or difficultyID == 17) then -- LFR
            if (not self.db.profile.raid.lfr) then
                self:StopLogging()
            end
        elseif (difficultyID == 3 or difficultyID == 4 or difficultyID == 9 or difficultyID == 14) then -- Normal
            if (not self.db.profile.raid.normal) then
                self:StopLogging()
            end
        elseif (difficultyID == 5 or difficultyID == 6 or difficultyID == 15) then -- Heroic
            if (not self.db.profile.raid.heroic) then
                self:StopLogging()
            end
        elseif (difficultyID == 16) then -- Mythic
            if (not self.db.profile.raid.mythic) then
                self:StopLogging()
            end
        elseif (difficultyID == 33 or difficultyID == 151) then -- Timewalking
            if (not self.db.profile.raid.timewalking) then
                self:StopLogging()
            end
        else
            self:StopLogging()
        end
    elseif (instanceType == "scenario") then
        if (difficultyID == 167) then -- Torghast
            if (not self.db.profile.scenario.torghast) then
                self:StopLogging()
            end
        end
    end
end