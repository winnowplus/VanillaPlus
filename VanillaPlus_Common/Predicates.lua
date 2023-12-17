--------------------------------------------------  Imports  --------------------------------------------------

local Namespace         = VanillaPlus;

-----------------------------------------------  Declarations  ------------------------------------------------

local Predicates        = {};
Namespace.Predicates    = Predicates;

-------------------------------------------------  Functions  -------------------------------------------------

function Predicates.ALWAYS_TRUE(...)
    return true;
end

function Predicates.ALWAYS_FALSE(...)
    return false;
end

function Predicates.AURA_NAME_EQUALS(aura, expectName)
    return aura and aura.name == expectName or false;
end

function Predicates.AURA_NAME_INCLUDES(aura, expectName)
    return aura and aura.name and expectName and string.find(aura.name, expectName) and true or false;
end