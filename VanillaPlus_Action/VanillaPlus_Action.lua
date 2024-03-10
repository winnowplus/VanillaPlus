--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                 = VanillaPlus;
local CreateAndInitFromMixin    = Namespace.CreateAndInitFromMixin;
local EventRegistry             = Namespace.EventRegistry;

local GetSpell                  = Namespace.GetSpell;

-- GetActionText and HasAction should not be overridden.
local StandardAPI               = Namespace.StandardAPI;
StandardAPI.GetActionText       = StandardAPI.GetActionText or GetActionText;
StandardAPI.HasAction           = StandardAPI.HasAction or HasAction;

StandardAPI.ActionHasRange      = StandardAPI.ActionHasRange or ActionHasRange;
StandardAPI.GetActionCooldown   = StandardAPI.GetActionCooldown or GetActionCooldown;
StandardAPI.GetActionCount      = StandardAPI.GetActionCount or GetActionCount;
StandardAPI.GetActionTexture    = StandardAPI.GetActionTexture or GetActionTexture;
StandardAPI.IsActionInRange     = StandardAPI.IsActionInRange or IsActionInRange;
StandardAPI.IsAttackAction      = StandardAPI.IsAttackAction or IsAttackAction;
StandardAPI.IsAutoRepeatAction  = StandardAPI.IsAutoRepeatAction or IsAutoRepeatAction;
StandardAPI.IsCurrentAction     = StandardAPI.IsCurrentAction or IsCurrentAction;
StandardAPI.IsUsableAction      = StandardAPI.IsUsableAction or IsUsableAction;
StandardAPI.IsConsumableAction  = StandardAPI.IsConsumableAction or IsConsumableAction;
StandardAPI.IsEquippedAction    = StandardAPI.IsEquippedAction or IsEquippedAction;
StandardAPI.UseAction           = StandardAPI.UseAction or UseAction;

-----------------------------------------------  Declarations  ------------------------------------------------

local SPELL                     = "SPELL";
local ITEM                      = "ITEM";
local MACRO                     = "MACRO";

local SpellActionMixin          = {};
local ItemActionMixin           = {};
local MacroActionMixin          = {};

local ACTIONS                   = {};

-------------------------------------------------  Functions  -------------------------------------------------

function SpellActionMixin:Init(slot, name)
    self.class, self.slot, self.name = SPELL, slot, name;
end

function ItemActionMixin:Init(slot, name)
    self.class, self.slot, self.name = ITEM, slot, name;
end

function MacroActionMixin:Init(slot, name)
    self.class, self.slot, self.name = MACRO, slot, name;
end

function Namespace.GetAction(slot)
    local action = ACTIONS[slot];

    if(action == nil and StandardAPI.HasAction(slot) == 1) then
        local actionText = StandardAPI.GetActionText(slot);

        if(actionText ~= nil) then
            action = CreateAndInitFromMixin(MacroActionMixin, slot, actionText);
        else
            VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
            VanillaPlusTooltip:ClearLines();
            VanillaPlusTooltip:SetAction(slot);
            
            local textLeft1 = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:IsShown() and VanillaPlusTooltipTextLeft1:GetText() or nil;
            local textRight1 = VanillaPlusTooltipTextRight1 and VanillaPlusTooltipTextRight1:IsShown() and VanillaPlusTooltipTextRight1:GetText() or nil;
            
            if(StandardAPI.IsEquippedAction(slot) == 1) then
                action = CreateAndInitFromMixin(ItemActionMixin, slot, textLeft1);
            else
                local fullname = (textRight1 == nil or textRight1 == "") and textLeft1 or textLeft1 .. "(" .. textRight1 .. ")";
                local spell = GetSpell(fullname);

                if(spell ~= nil) then
                    action = CreateAndInitFromMixin(SpellActionMixin, slot, fullname);
                else
                    action = CreateAndInitFromMixin(ItemActionMixin, slot, textLeft1);
                end
            end
        end

        ACTIONS[slot] = action;
    end

    return action;
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local lastExecutedAt = 0;

local function ON_UPDATE(uptime)
    if(uptime - lastExecutedAt < 0.1) then
        return;
    else
        

        lastExecutedAt = uptime;
    end
end

local function ON_ACTIONBAR_SLOT_CHANGED()
    ACTIONS[arg1] = nil;
end

EventRegistry:RegisterCallback("UPDATE", ON_UPDATE);
EventRegistry:RegisterFrameEventAndCallback("ACTIONBAR_SLOT_CHANGED", ON_ACTIONBAR_SLOT_CHANGED);