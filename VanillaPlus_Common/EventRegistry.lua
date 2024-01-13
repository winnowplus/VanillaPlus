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

    local onEvent = function(...)
        DEFAULT_CHAT_FRAME:AddMessage(event);
        DEFAULT_CHAT_FRAME:AddMessage(type(arg));
        DEFAULT_CHAT_FRAME:AddMessage(tostring(arg1));
        
        for key, value in pairs(arg) do
            DEFAULT_CHAT_FRAME:AddMessage(tostring(key) .. " - " .. tostring(value));
        end
    end

    self.eventFrame = eventFrame;
    self.eventFrame:SetScript("OnEvent", onEvent);
end

function EventRegistryMixin:RegisterFrameEventAndCallback(frameEvent, func, owner)
    local original = self.callbackCount[frameEvent];
    self:RegisterCallback(frameEvent, func, owner);
    local current = self.callbackCount[frameEvent];

    if(current == 1 and original ~= 1) then
        self.eventFrame:RegisterEvent(frameEvent);
    end
end

function EventRegistryMixin:UnregisterFrameEventAndCallback(frameEvent, owner)
    local original = self.callbackCount[frameEvent];
    self:UnregisterCallback(frameEvent, owner);
    local current = self.callbackCount[frameEvent];

    if(current == 0 and original ~= 0)then
        self.eventFrame:UnregisterEvent(frameEvent);
    end
end

-------------------------------------------  Default EventRegistry  -------------------------------------------

Namespace.EventRegistry = CreateAndInitFromMixin(EventRegistryMixin, VanillaPlusTooltip);

local function TestCallback1()
end

Namespace.EventRegistry:RegisterFrameEventAndCallback("ACTIONBAR_SLOT_CHANGED", TestCallback1);