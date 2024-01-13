--------------------------------------------------  Imports  --------------------------------------------------

local Namespace				= VanillaPlus;
local CallbackRegistryMixin = Namespace.CallbackRegistryMixin;
local CreateFromMixins      = Namespace.CreateFromMixins;
local CreateAndInitFromMixin= Namespace.CreateAndInitFromMixin;

local GetTime               = GetTime;

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
    self.eventFrame:SetScript("OnEvent", function()
		self:TriggerEvent(event);
	end);
    self.eventFrame:SetScript("OnUpdate", function()
		self:TriggerEvent("OnUpdate", GetTime());
	end);
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

Namespace.EventRegistry = CreateAndInitFromMixin(EventRegistryMixin, VanillaPlusEventFrame);

local lastUpdate = 0;

local function TestOnUpdate(uptime)
    if (uptime - lastUpdate) < 1 then return end
    
    DEFAULT_CHAT_FRAME:AddMessage("TestOnUpdate" .. tostring(uptime));
    lastUpdate = uptime;
end

Namespace.EventRegistry:RegisterCallback("OnUpdate", TestOnUpdate);