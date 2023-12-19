--------------------------------------------------  Imports  --------------------------------------------------

local Namespace = VanillaPlus;
local GetLogger = Namespace.GetLogger;

local GetNumBattlefields = GetNumBattlefields;
local GetBattlefieldInstanceInfo = GetBattlefieldInstanceInfo;
local GetBattlefieldInfo = GetBattlefieldInfo;

-----------------------------------------------  Declarations  ------------------------------------------------

local Logger = GetLogger();

-------------------------------------------------  Functions  -------------------------------------------------

local function NameIncludes(actual, except)
    return actual and except and string.find(actual, except) and true or false;
end

local function PrivateSelectTWBattlefield(twBattlefieldIndex, twBattlefieldName)
    local dropDownListButton = _G["DropDownList1Button" .. tostring(twBattlefieldIndex)];

    if(DropDownList1:IsShown() and dropDownListButton and NameIncludes(dropDownListButton:GetText(), twBattlefieldName)) then
        dropDownListButton:Click();
    else
        TWMiniMapBattlefieldFrame:Click();
        dropDownListButton:Click();
    end
end

local function PrivateInformTWBattlefieldNewInstances()
    local instances = {};
    local offset = 0;
    local numInstances = GetNumBattlefields();

    for instanceIndex = 1, numInstances do
        local instanceId = GetBattlefieldInstanceInfo(instanceIndex);
        local expectId = instanceIndex + offset;

        if(expectId < instanceId) then
            for missId = expectId, instanceId - 1 do
                table.insert(instances, missId);
                offset = offset + 1;
            end
        end
    end

    table.insert(instances, tostring(numInstances + offset + 1) .. "+");

    Logger:Info("New Instance would be ", table.concat(instances, ", "));
end

function Namespace.ShowTWBattlefield(twBattlefieldIndex, twBattlefieldNam, informNewInstances)
    local currBattlefield = GetBattlefieldInfo();

    if(not BattlefieldFrame:IsShown() or not NameIncludes(currBattlefield, twBattlefieldNam)) then
        PrivateSelectTWBattlefield(twBattlefieldIndex, twBattlefieldNam);
    elseif(informNewInstances) then
        PrivateInformTWBattlefieldNewInstances();
    end
end

function Namespace.JoinTWBattlefield(twBattlefieldIndex, twBattlefieldNam, informNewInstances)
    local currBattlefield = GetBattlefieldInfo();

    if(not BattlefieldFrame:IsShown() or not NameIncludes(currBattlefield, twBattlefieldNam)) then
        PrivateSelectTWBattlefield(twBattlefieldIndex, twBattlefieldNam);
    elseif(informNewInstances) then
        PrivateInformTWBattlefieldNewInstances();
        BattlefieldFrameJoinButton:Click();
    else
        BattlefieldFrameJoinButton:Click();
    end
end