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

function Predicates.EQUALS(one, another)
    return one == another;
end

function Predicates.STRING_CONTAINS(str, substr)
    return str and substr and string.find(str, substr) and true or false;
end

function Predicates.AURA_NAME_EQUALS(aura, expect)
    return aura and aura.name == expect or false;
end

function Predicates.AURA_NAME_CONTAINS(aura, expect)
    return aura and aura.name and expect and string.find(aura.name, expect) and true or false;
end