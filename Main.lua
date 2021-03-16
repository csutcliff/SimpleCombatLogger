local SimpleCombatLogger = LibStub("AceAddon-3.0"):NewAddon("SimpleCombatLogger", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0")
local LoggingCombat = _G.LoggingCombat
local GetInstanceInfo = _G.GetInstanceInfo
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
          instances = {
            name = "Instances",
            type = "group",
            args = {
                mythicplus = {
                    name = "Mythic Plus",
                    desc = "Enables / Disables mythic plus logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.instances.mythicplus = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.instances.mythicplus end
                },
                raid = {
                    name = "Raid",
                    desc = "Enables / Disables raid logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.instances.raid = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.instances.raid end
                },
                pvp = {
                    name = "Battleground",
                    desc = "Enables / Disables battleground logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.instances.battleground = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.instances.battleground end
                },
                arena = {
                    name = "Arena",
                    desc = "Enables / Disables arena logging",
                    type = "toggle",
                    set = function(info,val) SimpleCombatLogger.db.profile.instances.arena = val end,
                    get = function(info) return SimpleCombatLogger.db.profile.instances.arena end
                },
            },
        }
    },
}

local defaults = {
    profile = {
        enable = true,
        instances = {
                ['*'] = true,
        },
    }
}

function SimpleCombatLogger:OnInitialize()
    -- Called when the addon is initialized
    self.db = LibStub("AceDB-3.0"):New("SimpleCombatLoggerDB", defaults, true)
    options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("SimpleCombatLogger", options, nil);
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SimpleCombatLogger", "SimpleCombatLogger")
    self:RegisterChatCommand("scl", "ChatCommand");
    self:RegisterChatCommand("SimpleCombatLogger", "ChatCommand");
end

function SimpleCombatLogger:OnEnable()
    if (self.db.profile.enable) then
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
    -- self:Print("Aggregate handler fired")
    local inInstance, instanceType = IsInInstance()

    if (not inInstance or instanceType == nil or instanceType == "none") then
        self:StopLogging()
        return
    elseif (instanceType == "pvp") then
        if (self.db.profile.instances.pvp) then
            self:StartLogging()
        else
            self:StopLogging()
        end
    elseif (instanceType == "arena") then
        if (self.db.profile.instances.arena) then
            self:StartLogging()
        else
            self:StopLogging()
        end
    elseif (instanceType == "party") then
        if (self.db.profile.instances.mythicplus) then
            local difficulty = GetInstanceDifficulty()
            if (difficulty == CHALLENGE_MODE) then
                self:StartLogging()
            end
        else
            self:StopLogging()
        end
    elseif (instanceType == "raid") then
        if (self.db.profile.instances.raid) then
            self:StartLogging()
        else
            self:StopLogging()
        end
    end
end