--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                 = VanillaPlus;
local EventRegistry             = Namespace.EventRegistry;

-----------------------------------------------  Declarations  ------------------------------------------------

local InventoryItemMixin        = {};
local ContainerItemMixin        = {};

-------------------------------------------------  Functions  -------------------------------------------------

function InventoryItemMixin:Init(unit, slot)
    self.unit, self.slot = unit, slot;
end

function ContainerItemMixin:Init(bag, slot)
    self.bag, self.slot = bag, slot;
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function ON_BAG_UPDATE()
    Namespace.GetLogger("VanillaPlus", 0):Debug("BAG_UPDATE ", arg1);
end

EventRegistry:RegisterFrameEventAndCallback("BAG_UPDATE", ON_BAG_UPDATE);