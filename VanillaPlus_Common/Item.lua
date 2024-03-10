--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                         = VanillaPlus;
local CreateAndInitFromMixin            = Namespace.CreateAndInitFromMixin;
local EventRegistry                     = Namespace.EventRegistry;

local StandardAPI                       = Namespace.StandardAPI;
StandardAPI.GetInventoryItemTexture     = StandardAPI.GetInventoryItemTexture or GetInventoryItemTexture;
StandardAPI.GetInventoryItemCooldown    = StandardAPI.GetInventoryItemCooldown or GetInventoryItemCooldown;

StandardAPI.GetContainerItemInfo        = StandardAPI.GetContainerItemInfo or GetContainerItemInfo;
StandardAPI.GetContainerItemCooldown    = StandardAPI.GetContainerItemCooldown or GetContainerItemCooldown;

-----------------------------------------------  Declarations  ------------------------------------------------

local PLAYER_INVENTORY_ITEMS            = nil;

local InventoryItemMixin                = {};
local ContainerItemMixin                = {};

-------------------------------------------------  Functions  -------------------------------------------------

function InventoryItemMixin:Init(unit, slot)
    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetInventoryItem(unit, slot);

    self.unit, self.slot = unit, slot;
    self.name = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:IsShown() and VanillaPlusTooltipTextLeft1:GetText() or nil;
end

function InventoryItemMixin:GetTexture()
    if(self.texture == nil) then
        self.texture = StandardAPI.GetInventoryItemTexture(self.unit, self.slot);
    end

    return self.texture;
end

function InventoryItemMixin:GetCooldown()
    return StandardAPI.GetInventoryItemCooldown(self.unit, self.slot);
end

function ContainerItemMixin:Init(bag, slot)
    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetBagItem(bag, slot);

    self.bag, self.slot = bag, slot;
    self.name = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:IsShown() and VanillaPlusTooltipTextLeft1:GetText() or nil;
end

function ContainerItemMixin:GetTexture()
    if(self.texture == nil) then
        self.texture = StandardAPI.GetContainerItemInfo(self.bag, self.slot);
    end

    return self.texture;
end

function ContainerItemMixin:GetCooldown()
    return StandardAPI.GetContainerItemCooldown(self.bag, self.slot);
end

local function GetPlayerInventoryCahce()
    if(PLAYER_INVENTORY_ITEMS == nil) then
        PLAYER_INVENTORY_ITEMS = {};

        for slot = 0, 19 do
            PLAYER_INVENTORY_ITEMS[slot] = CreateAndInitFromMixin(InventoryItemMixin, "player", slot);
        end
    end

    return PLAYER_INVENTORY_ITEMS;
end

function Namespace.GetPlayerInventoryItem(slot)
    return GetPlayerInventoryCahce()[slot];
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function ON_UNIT_INVENTORY_CHANGED()
    if(arg1 == "player") then
        PLAYER_INVENTORY_ITEMS = nil;
    end
end

local function ON_BAG_UPDATE()
    
end

EventRegistry:RegisterFrameEventAndCallback("UNIT_INVENTORY_CHANGED", ON_UNIT_INVENTORY_CHANGED);
EventRegistry:RegisterFrameEventAndCallback("BAG_UPDATE", ON_BAG_UPDATE);