--------------------------------------------------  Imports  --------------------------------------------------

local Namespace     = VanillaPlus;

-----------------------------------------------  Declarations  ------------------------------------------------

local Strings       = {};
Namespace.Strings   = Strings;

-------------------------------------------------  Functions  -------------------------------------------------

function Strings.Trim(str)
    if(str == nil) then
        return nil;
    else
        return string.gsub(str,"^%s*(.-)%s*$", "%1");
    end
end