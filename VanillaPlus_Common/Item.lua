--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                 = VanillaPlus;
local EventRegistry             = Namespace.EventRegistry;

local GetInventoryItemTexture   = GetInventoryItemTexture;
local GetInventoryItemCooldown  = GetInventoryItemCooldown;

local GetContainerItemInfo      = GetContainerItemInfo;
local GetContainerItemCooldown  = GetContainerItemCooldown;

-----------------------------------------------  Declarations  ------------------------------------------------

local InventoryItemMixin        = {};
local ContainerItemMixin        = {};

local PLAYER_INVENTORY          = {};
local PLAYER_INVENTORY_BY_NAME  = {};

-------------------------------------------------  Functions  -------------------------------------------------

function InventoryItemMixin:Init(unit, slot)
    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetInventoryItem(unit, slot);

    self.unit, self.slot = unit, slot;
    self.name = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:GetText();
end

function InventoryItemMixin:GetTexture()
    if(self.texture == nil) then
        self.texture = GetInventoryItemTexture(self.unit, self.slot);
    end

    return self.texture;
end

function InventoryItemMixin:GetCooldown()
    return GetInventoryItemCooldown(self.unit, self.slot);
end

function ContainerItemMixin:Init(bag, slot)
    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetBagItem(bag, slot);

    self.bag, self.slot = bag, slot;
    self.name = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:GetText();
end

function ContainerItemMixin:GetTexture()
    if(self.texture == nil) then
        self.texture = GetContainerItemInfo(self.bag, self.slot);
    end

    return self.texture;
end

function ContainerItemMixin:GetCooldown()
    return GetContainerItemCooldown(self.bag, self.slot);
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function ON_UNIT_INVENTORY_CHANGED()
    Namespace.GetLogger("VanillaPlus", 0):Debug("UNIT_INVENTORY_CHANGED ", arg1, " ", arg2);
end

local function ON_BAG_UPDATE()
    Namespace.GetLogger("VanillaPlus", 0):Debug("BAG_UPDATE ", arg1);
end

EventRegistry:RegisterFrameEventAndCallback("UNIT_INVENTORY_CHANGED", ON_UNIT_INVENTORY_CHANGED);
EventRegistry:RegisterFrameEventAndCallback("BAG_UPDATE", ON_BAG_UPDATE);