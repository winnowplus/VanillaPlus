--------------------------------------------------  Imports  --------------------------------------------------

local Namespace = VanillaPlus;
local STRING_CONTAINS = Namespace.Predicates.STRING_CONTAINS;
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
            estimate = "",
            report = false,
            reportInterval = 10,
            reportedAt = 0
        };

        BattlefieldDataSet[battlefieldName] = battlefieldData;
    end

    return battlefieldData;
end

local function UpdateBattlefieldInstances(expectBattlefieldName)
    local battlefieldName = GetBattlefieldInfo();

    if(battlefieldName ~= expectBattlefieldName) then
        return;
    end

    -- Iterate Battlefield Instances
    local systime = time();
    local exist, expect, offset = {}, {}, 0;
    local numInstances = GetNumBattlefields();
    local battlefieldData = GetBattlefieldData(battlefieldName);

    for instanceIndex = 1, numInstances do
        local instanceID = GetBattlefieldInstanceInfo(instanceIndex);
        local expectID = instanceIndex + offset;
        exist[instanceID] = battlefieldData.exist[instanceID] or systime;

        if(expectID < instanceID) then
            for missID = expectID, instanceID - 1 do
                table.insert(expect, missID);
                offset = offset + 1;
            end
        end
    end

    local lastMissID = numInstances + offset + 1;
    table.insert(expect, lastMissID);
    local estimate = table.concat(expect, ", ") .. "...";

    -- Report
    if(battlefieldData.report and (estimate ~= battlefieldData.estimate or systime - battlefieldData.reportedAt > battlefieldData.reportInterval)) then
        Logger:Info("New Instance would be ", battlefieldName, " ", estimate);
        battlefieldData.reportedAt = systime;
    end

    -- Save Battlefield Instances Data
    battlefieldData.exist = exist;
    battlefieldData.expect = expect;
    battlefieldData.estimate = estimate;
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

function Namespace.IsBattlefieldListShown(battlefieldShortName)
    local battlefieldName = GetBattlefieldInfo();
    local shown = BattlefieldFrame and BattlefieldFrame:IsShown() and STRING_CONTAINS(battlefieldName, battlefieldShortName) or false;

    return shown, battlefieldName;
end

function Namespace.GetBattlefieldStatusByName(battlefieldShortName)
    for index = 1, MAX_BATTLEFIELD_QUEUES do
        local status, battlefieldName, instanceID = GetBattlefieldStatus(index);

        if(STRING_CONTAINS(battlefieldName, battlefieldShortName)) then
            return index, status, battlefieldName, instanceID;
        end
    end

    return 0;
end

--------------------------------------------  Turtle WoW Specific  --------------------------------------------

function Namespace.ShowTWBattlefieldList(battlefieldShortName)
    TWMiniMapBattlefieldFrame:Click();

    for index = 1, 10 do
        local dropDownListButton = _G["DropDownList1Button" .. tostring(index)];

        if(dropDownListButton and STRING_CONTAINS(dropDownListButton:GetText(), battlefieldShortName)) then
            dropDownListButton:Click();
            return true;
        end
    end
end

function Namespace.JoinTWBattlefield(battlefieldShortName)
    local shown, battlefieldName = Namespace.IsBattlefieldListShown(battlefieldShortName);

    if(shown) then
        UpdateBattlefieldInstances(battlefieldName);
        BattlefieldFrameJoinButton:Click();
    else
        Namespace.ShowTWBattlefieldList(battlefieldShortName);
    end
end

function Namespace.AutoRejoinTWBattlefield(battlefieldShortName)
    local shown, battlefieldName = Namespace.IsBattlefieldListShown(battlefieldShortName);

    if(shown) then
        UpdateBattlefieldInstances(battlefieldName);

        local systime = time();
        local battlefieldData = GetBattlefieldData(battlefieldName);
        local index, status, _, instanceID = Namespace.GetBattlefieldStatusByName(battlefieldShortName);

        if(status == "confirm") then
            local seen = battlefieldData.exist[instanceID];

            if(seen and seen < systime - 120) then
                AcceptBattlefieldPort(index, 0);
            end
        end

        BattlefieldFrameJoinButton:Click();
    else
        Namespace.ShowTWBattlefieldList(battlefieldShortName);
    end
end