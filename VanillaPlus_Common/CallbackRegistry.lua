--------------------------------------------------  Imports  --------------------------------------------------

local Namespace				    = VanillaPlus;
local CreateAndInitFromMixin    = Namespace.CreateAndInitFromMixin;

-----------------------------------------------  Declarations  ------------------------------------------------

local CallbackRegistryMixin     = {};
Namespace.CallbackRegistryMixin = CallbackRegistryMixin;

-------------------------------------------------  Functions  -------------------------------------------------

DEFAULT_CHAT_FRAME:AddMessage("VanillaPlusTooltip ..." ... VanillaPlusTooltip:GetObjectType());