--------------------------------------------------  Imports  --------------------------------------------------

local Namespace				    = VanillaPlus;

-----------------------------------------------  Declarations  ------------------------------------------------

local INTERNAL_OWNER_COUNT		= 0;
local INTERNAL_OWNER_FORMAT		= "VP_INTERNAL_CALLBACK_OWNER_%d";
local INTERNAL_OWNER_PATTERN	= "VP_INTERNAL_CALLBACK_OWNER_%d+";

local CallbackRegistryMixin     = {};
Namespace.CallbackRegistryMixin	= CallbackRegistryMixin;

-------------------------------------------------  Functions  -------------------------------------------------

local function GenerateInternalOwner()
	INTERNAL_OWNER_COUNT = INTERNAL_OWNER_COUNT + 1;
	
	return string.format(INTERNAL_OWNER_FORMAT, INTERNAL_OWNER_COUNT);
end

local function IsInternalOwner(owner)
	return type(owner) == "string" and owner == string.match(owner, INTERNAL_OWNER_PATTERN);
end

function CallbackRegistryMixin:Init()
	self.callbackTable = {};
	self.callbackCount = {};
end

function CallbackRegistryMixin:RegisterCallback(event, func, owner)
	assert(type(event) == "string", "Illegal event: " .. tostring(event) .. ", a string is required.");
	assert(type(func) == "function", "Illegal func: " .. tostring(func) .. ", a function is required.");

	if(owner == nil) then
		owner = GenerateInternalOwner();
	end

	self.callbackTable[event] = self.callbackTable[event] or {};

	if(self.callbackTable[event][owner] == nil) then
		self.callbackCount[event] = (self.callbackCount[event] or 0) + 1;
	end

	self.callbackTable[event][owner] = func;

	return owner;
end

function CallbackRegistryMixin:UnregisterCallback(event, owner)
	assert(type(event) == "string", "Illegal event: " .. tostring(event) .. ", a string is required.");
	assert(owner ~= nil, "Illegal owner: " .. tostring(owner) .. ".");

	if(self.callbackTable[event] ~= nil and self.callbackTable[event][owner] ~= nil) then
		self.callbackTable[event][owner] = nil;
		self.callbackCount[event] = self.callbackCount[event] - 1;

		if(self.callbackCount[event] == 0) then
			self.callbackTable[event] = nil;
		end
	end
end

function CallbackRegistryMixin:TriggerEvent(event, ...)
	assert(type(event) == "string", "Illegal event: " .. tostring(event) .. ", a string is required.");

	if(self.callbackTable[event] ~= nil) then
		for owner, func in pairs(self.callbackTable[event]) do
			if(IsInternalOwner(owner)) then
				func(unpack(arg));
			else
				func(owner, unpack(arg));
			end
		end
	end
end