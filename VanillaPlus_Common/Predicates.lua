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
    assert(type(str) == "string", "Illegal str: " .. tostring(str) .. ", a string is required.");
    assert(type(substr) == "string", "Illegal substr: " .. tostring(substr) .. ", a string is required.");

    return string.find(str, substr) and true or false;
end

function Predicates.AURA_NAME_EQUALS(aura, expect)
    assert(type(aura) == "table", "Illegal aura: " .. tostring(aura) .. ", a table is required.");

    return aura.name == expect or false;
end

function Predicates.AURA_NAME_CONTAINS(aura, expect)
    assert(type(aura) == "table", "Illegal aura: " .. tostring(aura) .. ", a table is required.");
    assert(type(aura.name) == "string", "Illegal aura.name: " .. tostring(aura.name) .. ", a string is required.");
    assert(type(expect) == "string", "Illegal expect: " .. tostring(expect) .. ", a string is required.");
    
    return string.find(aura.name, expect) and true or false;
end