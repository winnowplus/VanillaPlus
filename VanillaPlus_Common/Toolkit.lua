--------------------------------------------------  Imports  --------------------------------------------------

local Namespace = VanillaPlus;
local GetLogger = Namespace.GetLogger;

local GetBattlefieldInfo = GetBattlefieldInfo;
local GetNumBattlefields = GetNumBattlefields;
local GetBattlefieldInstanceInfo = GetBattlefieldInstanceInfo;

-----------------------------------------------  Declarations  ------------------------------------------------

local Logger = GetLogger();

-------------------------------------------------  Functions  -------------------------------------------------

-- turtle specific
function Namespace.ShowTurtleWowBattlefieldFrame(twBattlefieldIndex, twBattlefieldName)
    if(not BattlefieldFrame:IsShown() or twBattlefieldName ~= GetBattlefieldInfo()) then
        local dropDownListButton = _G["DropDownList1Button" .. tostring(twBattlefieldIndex)];

        if(DropDownList1:IsShown()) then
            dropDownListButton:Click();
        else
            TWMiniMapBattlefieldFrame:Click();
            dropDownListButton:Click();
        end
    end
end

function Namespace.InformNewBattlefieldInstances(twBattlefieldName)
    if(BattlefieldFrame:IsShown() and twBattlefieldName == GetBattlefieldInfo()) then
        local offset = 0;
        local instances = {};
        local numInstances = GetNumBattlefields();

        for instanceIndex=1, numInstances do
            local instanceId = GetBattlefieldInstanceInfo(instanceIndex);
    
            if(instanceId == nil or instanceId ~= instanceIndex + offset) then
                table.insert(instances, instanceIndex + offset);
                offset = offset + 1;
            end
        end

        table.insert(instances, tostring(numInstances + offset + 1) .. "+");

        Logger:Info("New Instance would be ", table.concat(instances, ", "));
    end
end