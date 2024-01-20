--------------------------------------------------  Imports  --------------------------------------------------

local Namespace     = VanillaPlus;

-----------------------------------------------  Declarations  ------------------------------------------------

local QueueMixin    = {};

-------------------------------------------------  Functions  -------------------------------------------------

function QueueMixin:Init()
    self.list = {};
end

function QueueMixin:Size()
end

function QueueMixin:Push(value)
	assert(value ~= nil, "Illegal value: " .. tostring(value) .. ".");

    table.insert (self.list, value):
end

function QueueMixin:Pop()
end

function QueueMixin:Peek()
end