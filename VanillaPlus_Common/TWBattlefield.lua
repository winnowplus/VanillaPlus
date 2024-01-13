--------------------------------------------------  Imports  --------------------------------------------------

local Namespace = VanillaPlus;
local STRING_CONTAINS = Namespace.Predicates.STRING_CONTAINS;
local GetLogger = Namespace.GetLogger;
local EventRegistry = Namespace.EventRegistry;

local GetBattlefieldInfo = GetBattlefieldInfo;
local GetNumBattlefields = GetNumBattlefields;
local GetBattlefieldInstanceInfo = GetBattlefieldInstanceInfo;
local GetBattlefieldStatus = GetBattlefieldStatus;

local time = time;

-----------------------------------------------  Declarations  ------------------------------------------------

local Logger            = GetLogger();
local BattlefieldDataSet= {};

-------------------------------------------------  Functions  -------------------------------------------------

local function GetBattlefieldData(battlefieldName)
    local battlefieldData = BattlefieldDataSet[battlefieldName];


    if(not battlefieldData) then
        battlefieldData = {
            indexMap = {},
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
    local indexMap, exist, miss, offset = {}, {}, {}, 0;
    local numInstances = GetNumBattlefields();
    local battlefieldData = GetBattlefieldData(battlefieldName);

    for instanceIndex = 1, numInstances do
        local expectID = instanceIndex + offset;
        local instanceID = GetBattlefieldInstanceInfo(instanceIndex);
        indexMap[instanceID] = instanceIndex;
        exist[instanceID] = battlefieldData.exist[instanceID] or systime;

        if(expectID < instanceID) then
            for missID = expectID, instanceID - 1 do
                table.insert(miss, missID);
                battlefieldData.expect[missID] = systime;
                offset = offset + 1;
            end
        end
    end

    local lastMissID = numInstances + offset + 1;
    table.insert(miss, lastMissID);
    battlefieldData.expect[lastMissID] = systime;
    local estimate = table.concat(miss, ", ") .. "...";

    -- Report
    if(battlefieldData.report) then
        if(estimate ~= battlefieldData.estimate) then
            Logger:Info("New Instance would be ", battlefieldName, " ", RED_FONT_COLOR_CODE, estimate);
            battlefieldData.reportedAt = systime;
        elseif(systime - battlefieldData.reportedAt > battlefieldData.reportInterval) then
            Logger:Info("New Instance would be ", battlefieldName, " ", estimate);
            battlefieldData.reportedAt = systime;
        end
    end

    -- Save Battlefield Instances Data
    battlefieldData.indexMap = indexMap;
    battlefieldData.exist = exist;
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

function Namespace.AcceptBattlefieldPortByName(battlefieldShortName, acceptCode)
    local index, status, _, instanceID = Namespace.GetBattlefieldStatusByName(battlefieldShortName);

    if(index > 0) then
        AcceptBattlefieldPort(index, acceptCode);
    end
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
        local index, status, _, instanceID = Namespace.GetBattlefieldStatusByName(battlefieldName);
        UpdateBattlefieldInstances(battlefieldName);

        if(index == 0) then
            JoinBattlefield(0);
        end

        BattlefieldFrameCloseButton:Click();
    else
        Namespace.ShowTWBattlefieldList(battlefieldShortName);
    end
end

function Namespace.JoinNewestTWBattlefield(battlefieldShortName, expireSeconds)
    local shown, battlefieldName = Namespace.IsBattlefieldListShown(battlefieldShortName);
    expireSeconds = expireSeconds or 100;

    if(shown) then
        UpdateBattlefieldInstances(battlefieldName);
        local systime = time();
        local battlefieldData = GetBattlefieldData(battlefieldName);
        local index, status, _, instanceID = Namespace.GetBattlefieldStatusByName(battlefieldName);
        local newestInstanceID, newestInstanceTime = 0, 0;

        for existInstanceID, existInstanceTime in pairs(battlefieldData.exist) do
            if(existInstanceTime > newestInstanceTime and existInstanceTime > systime - expireSeconds) then
                newestInstanceID = existInstanceID;
                newestInstanceTime = existInstanceTime;
            end
        end

        if(newestInstanceID > 0 and newestInstanceID ~= instanceID) then
            AcceptBattlefieldPort(index, 0);
            JoinBattlefield(battlefieldData.indexMap[newestInstanceID]);
        elseif(index == 0) then
            JoinBattlefield(0);
        end

        BattlefieldFrameCloseButton:Click();
    else
        Namespace.ShowTWBattlefieldList(battlefieldShortName);
    end
end

function Namespace.AutoRejoinTWBattlefield(battlefieldShortName, expireSeconds)
    local shown, battlefieldName = Namespace.IsBattlefieldListShown(battlefieldShortName);
    expireSeconds = expireSeconds or 100;

    if(shown) then
        local systime = time();
        local battlefieldData = GetBattlefieldData(battlefieldName);
        local index, status, _, instanceID = Namespace.GetBattlefieldStatusByName(battlefieldName);
        UpdateBattlefieldInstances(battlefieldName);

        if(status == "confirm" and battlefieldData.exist[instanceID] and battlefieldData.exist[instanceID] < systime - expireSeconds) then
            AcceptBattlefieldPort(index, 0);
            JoinBattlefield(0);
        elseif(index == 0) then
            JoinBattlefield(0);
        end

        BattlefieldFrameCloseButton:Click();
    else
        Namespace.ShowTWBattlefieldList(battlefieldShortName);
    end
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function OnBattlefieldsShow()
    DEFAULT_CHAT_FRAME:AddMessage(event .. tostring(arg1));
end

EventRegistry:RegisterFrameEventAndCallback("BATTLEFIELDS_SHOW", OnBattlefieldsShow);