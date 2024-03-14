--------------------------------------------------  Imports  --------------------------------------------------

local Namespace             = VanillaPlus;
local GetSpell              = Namespace.GetSpell;

local UnitExists            = UnitExists;
local UnitCanAssist         = UnitCanAssist;
local UnitCanAttack         = UnitCanAttack;
local UnitIsDeadOrGhost     = UnitIsDeadOrGhost;
local UnitAffectingCombat   = UnitAffectingCombat;

-----------------------------------------------  Declarations  ------------------------------------------------

local Conditionals          = {};
Namespace.Conditionals      = Conditionals;

-------------------------------------------------  Functions  -------------------------------------------------

function Conditionals.exists(target)
    return UnitExists(target);
end

function Conditionals.help(target)
    return UnitCanAssist("player", target);
end

function Conditionals.harm(target)
    return UnitCanAttack("player", target);
end

function Conditionals.dead(target)
    return UnitIsDeadOrGhost(target);
end

function Conditionals.combat()
    return UnitAffectingCombat("player");
end

function Conditionals.mod(placeholder, value)
    if(value == nil) then
        return IsAltKeyDown() or IsControlKeyDown() or IsShiftKeyDown();
    else

    end
end

Conditionals.modifier = Conditionals.mod;

function Conditionals.stance(placeholder, value)

end

Conditionals.form = Conditionals.stance;

function Conditionals.known(placeholder, value)
    return GetSpell(value) ~= nil;
end

function Conditionals.active(placeholder, value)
    local spell = GetSpell(value);

    return spell ~= nil and spell:IsActive();
end

function Conditionals.rdy(placeholder, value)
    local usable = GetSpell(value); -- TODO ITEMS
    local start, duration, enabled = usable:GetCooldown();

    return duration <= 1.5;
end

for mod, func in pairs(Conditionals) do
    Conditionals["no" .. mod] = function(target, value)
        return not fuc(target, value);
    end
end