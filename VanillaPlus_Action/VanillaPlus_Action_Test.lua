--------------------------------------------------  Imports  --------------------------------------------------

local Namespace     = VanillaPlus;
local GetLogger     = Namespace.GetLogger;

local GetSpell      = Namespace.GetSpell;
local GetAction     = Namespace.GetAction;

local GetActionText = GetActionText;
local HasAction     = HasAction;

-----------------------------------------------  Declarations  ------------------------------------------------

local Logger        = GetLogger();

-------------------------------------------------  Functions  -------------------------------------------------

function Namespace.TestGetAction()
    for slot = 1, 120 do
        if(HasAction(slot) == 1) then
            local action = GetAction(slot);
            local actionText = GetActionText(slot);

            assert(action ~= nil and action.slot == slot);

            if(action.class == "SPELL") then
                assert(actionText == nil);
                assert(GetSpell(action.name) ~= nil);
            elseif(action.class == "ITEM") then
                assert(actionText == nil);
                assert(action.name ~= nil);
            elseif(action.class == "MACRO") then
                assert(action.name == actionText);
            else
                assert(false);
            end
        end
    end
end

function Namespace.TestAction()
    Namespace.TestGetAction(); Logger:Info("TestGetAction Pass");
end