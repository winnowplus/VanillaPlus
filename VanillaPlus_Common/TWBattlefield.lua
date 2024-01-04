--------------------------------------------------  Imports  --------------------------------------------------

local Namespace = VanillaPlus;
local Predicates = Namespace.Predicates;
local GetLogger = Namespace.GetLogger;

local GetBattlefieldInfo = GetBattlefieldInfo;
local GetNumBattlefields = GetNumBattlefields;
local GetBattlefieldInstanceInfo = GetBattlefieldInstanceInfo;
local GetBattlefieldStatus = GetBattlefieldStatus;

local time = time;
local uptime = GetTime;

-----------------------------------------------  Declarations  ------------------------------------------------

local Logger            = GetLogger();
local BattlefieldDataSet= {};

-------------------------------------------------  Functions  -------------------------------------------------

local function GetBattlefieldData(battlefieldName)
    local battlefieldData = BattlefieldDataSet[battlefieldName];

    if(not battlefieldData) then
        battlefieldData = {
            exist   = {},
            expect  = {},
            expectDesc = "",
            report = false,
            reportInterval = 10,
            reportedAt = 0,
            autoQueue = false
        };

        BattlefieldDataSet[battlefieldName] = battlefieldData;
    end

    return battlefieldData;
end

local function UpdateBattlefieldInstances()
    local battlefieldName = GetBattlefieldInfo();
    if(not battlefieldName) then
        return;
    end

    -- Iterate Battlefield Instances
    local systime = time();
    local exist, expect, offset = {}, {}, 0;
    local battlefieldData = GetBattlefieldData(battlefieldName);
    local numInstances = GetNumBattlefields();

    for instanceIndex = 1, numInstances do
        local instanceId = GetBattlefieldInstanceInfo(instanceIndex);
        local expectId = instanceIndex + offset;
        exist[instanceId] = battlefieldData.exist[instanceId] or systime;

        if(expectId < instanceId) then
            for missId = expectId, instanceId - 1 do
                table.insert(expect, missId);
                offset = offset + 1;
            end
        end
    end

    table.insert(expect, numInstances + offset + 1);
    local expectDesc = table.concat(expect, ", ") .. "...";

    -- Report
    if(battlefieldData.report and (expectDesc ~= battlefieldData.expectDesc or systime - battlefieldData.reportedAt > battlefieldData.reportInterval)) then
        Logger:Info("New Instance would be ", battlefieldName, " ", expectDesc);
        battlefieldData.reportedAt = systime;
    end

    -- Save Battlefield Instances Data
    battlefieldData.exist = exist;
    battlefieldData.expect = expect;
    battlefieldData.expectDesc = expectDesc;
end

function Namespace.GetBattlefieldProperty(battlefieldName, key)
    if(not battlefieldName) then
        return;
    end

    local battlefieldData = GetBattlefieldData(battlefieldName);
    return battlefieldData[key];
end

function Namespace.SetBattlefieldProperty(battlefieldName, key, value)
    if(not battlefieldName) then
        return;
    end

    local battlefieldData = GetBattlefieldData(battlefieldName);
    battlefieldData[key] = value;
end

function Namespace.IsBattlefieldListShown(expectName)
    local battlefieldName = GetBattlefieldInfo();
    local shown = BattlefieldFrame and BattlefieldFrame:IsShown() and Predicates.STRING_CONTAINS(battlefieldName, expectName) or false;

    return shown, battlefieldName;
end

function Namespace.GetBattlefieldStatusByName(expectName)
    local status, mapName, instanceID;

    for index = 1, MAX_BATTLEFIELD_QUEUES do
        status, mapName, instanceID = GetBattlefieldStatus(index);

        if(Predicates.STRING_CONTAINS(mapName, expectName)) then
            return index, status, mapName, instanceID;
        end
    end

    return 0;
end

--------------------------------------------  Turtle WoW Specific  --------------------------------------------

function Namespace.ShowTWBattlefieldList(expectName)
    TWMiniMapBattlefieldFrame:Click();

    for index = 1, 10 do
        local dropDownListButton = _G["DropDownList1Button" .. tostring(index)];

        if(dropDownListButton and Predicates.STRING_CONTAINS(dropDownListButton:GetText(), expectName)) then
            dropDownListButton:Click();
            return true;
        end
    end
end

function Namespace.JoinTWBattlefield(expectName)
    local shown, battlefieldName = Namespace.IsBattlefieldListShown(expectName);

    if(shown) then
        UpdateBattlefieldInstances();
        BattlefieldFrameJoinButton:Click();
    else
        Namespace.ShowTWBattlefieldList(expectName);
    end
end

function Namespace.