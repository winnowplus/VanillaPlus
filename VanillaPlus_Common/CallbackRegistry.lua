--------------------------------------------------  Imports  --------------------------------------------------

local Namespace				    = VanillaPlus;
local CreateAndInitFromMixin    = Namespace.CreateAndInitFromMixin;

-----------------------------------------------  Declarations  ------------------------------------------------

local CallbackRegistryMixin     = {};
Namespace.CallbackRegistryMixin = CallbackRegistryMixin;

-------------------------------------------------  Functions  -------------------------------------------------

--callbackTable

function CallbackRegistryMixin:RegisterCallback(event, func, owner)
	assert(type(event) == "string", "Illegal event: " .. tostring(event) .. ", a string is required.");
	assert(type(func) == "function", "Illegal level: " .. tostring(func) .. ", a function is required.");
end