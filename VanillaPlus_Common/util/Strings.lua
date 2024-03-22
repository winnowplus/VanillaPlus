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
    local tbl, lastEnd = {}, 1;
    local pattern = "(.-)" .. seperatorPattern;
    local startIndex, endIndex, capture = string.find(str, pattern, lastEnd);
    
    while(startIndex ~= nil) do
        if(startIndex ~= 1 or capture ~= "") then
            table.insert(tbl, capture);
        end

        lastEnd = endIndex + 1;
        startIndex, endIndex, capture = string.find(str, pattern, lastEnd);
    end
    
    if(lastEnd <= string.len(str)) then
        capture = string.sub(str, lastEnd);
        table.insert(tbl, capture);
    end
    
    return tbl;
end