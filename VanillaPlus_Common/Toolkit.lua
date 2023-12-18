--------------------------------------------------  Imports  --------------------------------------------------

local Namespace = VanillaPlus;

-------------------------------------------------  Functions  -------------------------------------------------

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