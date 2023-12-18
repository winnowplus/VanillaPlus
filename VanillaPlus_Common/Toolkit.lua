--------------------------------------------------  Imports  --------------------------------------------------

local Namespace = VanillaPlus;
local GetLogger = Namespace.GetLogger;

-----------------------------------------------  Declarations  ------------------------------------------------

local BATTLEFIELD_ZONE_NAME_REGEX   = "(.+)%s(%d+)";
local Logger                        = GetLogger();

-------------------------------------------------  Functions  -------------------------------------------------

-- turtle specific
function Namespace.ShowTurtleWowBattlefieldFrame(twBattlefieldIndex)
    if(BattlefieldFrame:IsShown()) then
        return;
    end

    local button = _G["DropDownList1Button" .. tostring(twBattlefieldIndex)];

    if(DropDownList1:IsShown()) then
        button:Click();
    else
        TWMiniMapBattlefieldFrame:Click();
        button:Click();
    end
end

function Namespace.InformNewBattlefieldZoneIndex()
    if(not BattlefieldFrame:IsShown()) then
        return;
    end

    local expectIndex = 1;
    local zone = _G["BattlefieldZone" .. tostring(expectIndex + 1)];

    while(zone ~= nil) do
        local _, _, _, indexStr = string.find(zone:GetText(), BATTLEFIELD_ZONE_NAME_REGEX);
        local index = tonumber(indexStr);

        if(index ~= expectIndex) then
            break;
        else
            expectIndex = expectIndex + 1;
            zone = _G["BattlefieldZone2" .. tostring(expectIndex + 1)];
        end
    end
    
    Logger:Info("New zone would be: ", expectIndex);
    return;
end