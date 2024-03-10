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
    return string.find(str, substr) ~= nil;
end

function Predicates.AURA_NAME_EQUALS(aura, expect)
    return aura.name == expect;
end

function Predicates.AURA_NAME_CONTAINS(aura, expect)
    return string.find(aura.name, expect) ~= nil;
end