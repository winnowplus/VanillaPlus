--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                 = VanillaPlus;
local EventRegistry             = Namespace.EventRegistry;

-----------------------------------------------  Declarations  ------------------------------------------------

local ContainerItemMixin        = {};

-------------------------------------------------  Functions  -------------------------------------------------

function ContainerItemMixin:Init(bagID, slot)
    self.bagID, self.slot = bagID, slot;
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function ON_BAG_UPDATE()
    Namespace.GetLogger("VanillaPlus", 0):Debug("BAG_UPDATE ", arg1);
end

EventRegistry:RegisterFrameEventAndCallback("BAG_UPDATE", ON_BAG_UPDATE);