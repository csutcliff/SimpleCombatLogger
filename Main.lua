local SimpleCombatLogger = LibStub("AceAddon-3.0"):NewAddon("SimpleCombatLogger", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0")
local LoggingCombat = _G.LoggingCombat
local GetInstanceInfo = _G.GetInstanceInfo
local IsRatedBattleground = C_PvP.IsRatedBattleground
local IsRatedArena = C_PvP.IsRatedArena
local bucketHandle = nil

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
        party = {
            name = "Party",
            type = "group",
            args = {
                normal = {
                    name = "Normal",
                    desc = "Enables / Disables normal dungeon logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.party.normal = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.party.normal end
                },
                heroic = {
                    name = "Heroic",
                    desc = "Enables / Disables heroic dungeon logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.party.heroic = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.party.heroic end
                },
                mythicplus = {
                    name = "Mythic Plus",
                    desc = "Enables / Disables mythic plus logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.party.mythicplus = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.party.mythicplus end
                },
                mythic = {
                    name = "Mythic",
                    desc = "Enables / Disables mythic dungeon logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.party.mythic = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.party.mythic end
                },
                timewalking = {
                    name = "Timewalking",
                    desc = "Enables / Disables timewalking dungeon logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.party.timewalking = val end,
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
                    set = function(info,val) SimpleCombatLogger.db.profile.raid.lfr = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.lfr end
                },
                normal = {
                    name = "Normal",
                    desc = "Enables / Disables normal raid logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.raid.normal = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.normal end
                },
                heroic = {
                    name = "Heroic",
                    desc = "Enables / Disables heroic raid logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.raid.heroic = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.heroic end
                },
                mythic = {
                    name = "Mythic",
                    desc = "Enables / Disables mythic raid logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.raid.mythic = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.mythic end
                },
                timewalking = {
                    name = "Timewalking",
                    desc = "Enables / Disables timewalking raid logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.raid.timewalking = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.raid.timewalking end
                },
            }
        },
        pvp = {
            name = "Battleground",
            type = "group",
            args = {
                regular = {
                    name = "Non-Rated",
                    desc = "Enables / Disables battleground logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.pvp.regular = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.pvp.regular end
                },
                rated = {
                    name = "Rated",
                    desc = "Enables / Disables rated battleground logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.pvp.rated = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.pvp.rated end
                },
            }
        },
        arena = {
            name = "Arena",
            type = "group",
            args = {
                skirmish = {
                    name = "Skirmish",
                    desc = "Enables / Disables arena skirmish logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.arena.skirmish = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.arena.skirmish end
                },
                rated = {
                    name = "Rated",
                    desc = "Enables / Disables rated arena logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.arena.rated = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.arena.rated end
                },
            }
        },
    }
}

local defaults = {
    profile = {
        enable = true,
        party = {
            ["*"] = true,
        },
        raid = {
            ["*"] = true,
        },
        pvp = {
            ["*"] = true,
        },
        arena = {
            ["*"] = true,
        },
    }
}

function SimpleCombatLogger:OnInitialize()
    -- Called when the addon is initialized
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
end

function SimpleCombatLogger:OnEnable()
    if (not db.enable) then
        self:OnDisable()
        return
    end

    self:Print("Enabled")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "EventAggregate")
    self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "EventAggregate")
    self:RegisterEvent("UPDATE_INSTANCE_INFO", "EventAggregate")
    if (bucketHandle == nil) then
        -- self:Print("Registering bucket")
        bucketHandle = self:RegisterBucketMessage("SIMPLECOMBATLOGGER_AGG_EVENT", 1.0, "CheckLogging")
    end
    self:EventAggregate(nil)
    end

function SimpleCombatLogger:OnDisable()
    self:Print("Disabled")
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("PLAYER_DIFFICULTY_CHANGED")
    self:UnregisterEvent("UPDATE_INSTANCE_INFO")
    if (bucketHandle) then
        -- self:Print("Unregistering bucket")
        self:UnregisterBucket(bucketHandle)
        bucketHandle = nil
    end
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

function SimpleCombatLogger:EventAggregate(event)
    -- self:Print("Event fired")
    self:SendMessage("SIMPLECOMBATLOGGER_AGG_EVENT")
end

function SimpleCombatLogger:CheckLogging(event)
    self:Print("Aggregate handler fired")
    local _, instanceType, difficultyID = GetInstanceInfo();
    self:Print(instanceType..":"..difficultyID)
    if (instanceType == nil or instanceType == "none") then
        self:StopLogging()
        return
    elseif (instanceType == "pvp") then
        if (IsRatedBattleground()) then
            if (self.db.profile.pvp.rated) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (self.db.profile.pvp.regular) then
            self:StartLogging()
        else
            self:StopLogging()
        end
    elseif (instanceType == "arena") then
        if (IsRatedArena()) then
            if (self.db.profile.arena.rated) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (self.db.profile.arena.skirmish) then
            self:StartLogging()
        else
            self:StopLogging()
        end
    elseif (instanceType == "party") then
        if (difficultyID == 1) then -- Normal
            if (self.db.profile.party.normal) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (difficultyID == 2) then -- Heroic
            if (self.db.profile.party.heroic) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (difficultyID == 8) then -- Mythic Plus
            if (self.db.profile.party.mythicplus) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (difficultyID == 23) then -- Mythic
            if (self.db.profile.party.mythic) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (difficultyID == 24) then -- Timewalking
            if (self.db.profile.party.timewalking) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        else
            self:StopLogging()
        end
    elseif (instanceType == "raid") then
        if (difficultyID == 7 or difficultyID == 17) then -- LFR
            if (self.db.profile.raid.lfr) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (difficultyID == 3 or difficultyID == 4 or difficultyID == 9 or difficultyID == 14) then -- Normal
            if (self.db.profile.raid.normal) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (difficultyID == 5 or difficultyID == 6 or difficultyID == 15) then -- Heroic
            if (self.db.profile.raid.heroic) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (difficultyID == 16) then -- Mythic
            if (self.db.profile.raid.mythic) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        elseif (difficultyID == 33 or difficultyID == 151) then -- Timewalking
            if (self.db.profile.raid.timewalking) then
                self:StartLogging()
            else
                self:StopLogging()
            end
        else
        self:StopLogging()
        end
    end
end