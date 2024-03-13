--------------------------------------------------  Imports  --------------------------------------------------

local Namespace     = VanillaPlus;

-----------------------------------------------  Declarations  ------------------------------------------------

local Strings       = {};
Namespace.Strings   = Strings;

-------------------------------------------------  Functions  -------------------------------------------------

function Strings.Trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1");
end

function Strings.Split(str, seperatorPattern)
    local tbl = {};
    local pattern = "(.-)" .. seperatorPattern;
    local lastEnd = 1;
    local s, e, cap = string.find(str, pattern, 1);
   
    while(s ~= nil) do
        if(s ~= 1 or cap ~= "") then
            table.insert(tbl, cap);
        end

        lastEnd = e + 1;
        s, e, cap = string.find(str, pattern, lastEnd);
    end
    
    if(lastEnd <= string.len(str)) then
        cap = string.sub(str, lastEnd);
        table.insert(tbl, cap);
    end
    
    return tbl;
end