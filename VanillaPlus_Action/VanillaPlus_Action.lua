--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                 = VanillaPlus;
local StandardAPI               = Namespace.StandardAPI;
local CreateAndInitFromMixin    = Namespace.CreateAndInitFromMixin;
local EventRegistry             = Namespace.EventRegistry;

-- GetActionText and HasAction should not be overridden.
local GetActionText             = GetActionText;
local HasAction                 = HasAction;

StandardAPI.ActionHasRange      = ActionHasRange;
StandardAPI.GetActionCooldown   = GetActionCooldown;
StandardAPI.GetActionCount      = GetActionCount;
StandardAPI.GetActionTexture    = GetActionTexture;
StandardAPI.IsActionInRange     = IsActionInRange;
StandardAPI.IsAttackAction      = IsAttackAction;
StandardAPI.IsAutoRepeatAction  = IsAutoRepeatAction;
StandardAPI.IsCurrentAction     = IsCurrentAction;
StandardAPI.IsUsableAction      = IsUsableAction;
StandardAPI.IsConsumableAction  = IsConsumableAction;
StandardAPI.IsEquippedAction    = IsEquippedAction;
StandardAPI.UseAction           = UseAction;

-----------------------------------------------  Declarations  ------------------------------------------------

local ACTIONS                   = {};

local StandardActionMixin       = {};
local MacroActionMixin          = {};

-------------------------------------------------  Functions  -------------------------------------------------

function StandardActionMixin:Init(slot)
    self.slot = slot;
end

function MacroActionMixin:Init(slot)
    self.slot = slot;
end

local function PrivateGetAction(slot)
    local action = ACTIONS[slot];

    if(action == nil and HasAction(slot) == 1) then
        local actionText = GetActionText(slot);
        action == actionText == nil and CreateAndInitFromMixin(StandardActionMixin, slot) or CreateAndInitFromMixin(MacroActionMixin, slot);
        
        ACTIONS[slot] = action;
    end

    return action;
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function ON_ACTIONBAR_SLOT_CHANGED()
    Namespace.GetLogger("VanillaPlus", 0):Debug("ACTIONBAR_SLOT_CHANGED ", arg1);
end

EventRegistry:RegisterFrameEventAndCallback("ACTIONBAR_SLOT_CHANGED", ON_ACTIONBAR_SLOT_CHANGED);