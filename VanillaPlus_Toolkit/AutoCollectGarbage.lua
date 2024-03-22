--------------------------------------------------  Imports  --------------------------------------------------

local Namespac              = VanillaPlus;
local EventRegistry         = Namespace.EventRegistry;

local UnitAffectingCombat   = UnitAffectingCombat;
local collectgarbage        = collectgarbage;

----------------------------------------------  Event Callbacks  ----------------------------------------------

local lastExecutedAt = 0;

local function ON_UPDATE(uptime)
    if(uptime - lastExecutedAt < 30 or UnitAffectingCombat("player")) then
        return;
    else
        collectgarbage();

        lastExecutedAt = uptime;
    end
end

EventRegistry:RegisterCallback("UPDATE", ON_UPDATE);