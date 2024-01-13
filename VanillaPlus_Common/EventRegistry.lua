--------------------------------------------------  Imports  --------------------------------------------------

local Namespace				= VanillaPlus;
local CallbackRegistryMixin = Namespace.CallbackRegistryMixin;
local CreateFromMixins      = Namespace.CreateFromMixins;
local CreateAndInitFromMixin= Namespace.CreateAndInitFromMixin;

-----------------------------------------------  Declarations  ------------------------------------------------

local EventRegistryMixin    = CreateFromMixins(CallbackRegistryMixin);
Namespace.EventRegistryMixin= EventRegistryMixin;

-------------------------------------------------  Functions  -------------------------------------------------

function EventRegistryMixin:Init(eventFrame)
    assert(type(eventFrame) == "table", "Illegal eventFrame: " .. tostring(eventFrame) .. ", a Frame is required.");
    assert(type(eventFrame.IsObjectType) == "function", "Illegal eventFrame: " .. tostring(eventFrame) .. ", a Frame is required.");
    assert(eventFrame:IsObjectType("Frame") == 1, "Illegal eventFrame: " .. tostring(eventFrame) .. ", a Frame is required.");

    CallbackRegistryMixin.Init(self);
    self.eventFrame = eventFrame;
    self.eventFrame:SetScript("OnEvent", function(...)
		self:TriggerEvent(event, unpack(arg));
	end);
    --OnUpdate
end

function EventRegistryMixin:RegisterFrameEventAndCallback(frameEvent, func, owner)
    local original = self.callbackCount[frameEvent];
    local result = self:RegisterCallback(frameEvent, func, owner);
    local current = self.callbackCount[frameEvent];

    if(current == 1 and original ~= 1) then
        self.eventFrame:RegisterEvent(frameEvent);
    end

    return result;
end

function EventRegistryMixin:UnregisterFrameEventAndCallback(frameEvent, owner)
    local original = self.callbackCount[frameEvent];
    local result = self:UnregisterCallback(frameEvent, owner);
    local current = self.callbackCount[frameEvent];

    if(current == 0 and original ~= 0)then
        self.eventFrame:UnregisterEvent(frameEvent);
    end

    return result;
end

-------------------------------------------  Default EventRegistry  -------------------------------------------

Namespace.EventRegistry = CreateAndInitFromMixin(EventRegistryMixin, VanillaPlusTooltip);



------ Test code
local function TestCallback1(...)
    DEFAULT_CHAT_FRAME:AddMessage((event or "nilevent") .. tostring(arg1));
end

local owner1 = Namespace.EventRegistry:RegisterFrameEventAndCallback("ACTIONBAR_SLOT_CHANGED", TestCallback1);

local function TestCallback2(...)

end

local owner2 = Namespace.EventRegistry:RegisterFrameEventAndCallback("ACTIONBAR_SLOT_CHANGED", TestCallback2);

local function TestCallback3(...)
    DEFAULT_CHAT_FRAME:AddMessage("TestCallback3");
end

local owner3 = Namespace.EventRegistry:RegisterFrameEventAndCallback("BATTLEFIELDS_SHOW", TestCallback3);
Namespace.EventRegistry:UnregisterFrameEventAndCallback("BATTLEFIELDS_SHOW", owner3);