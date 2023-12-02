--------------------------------------------------  Imports  --------------------------------------------------

local Namespace = VanillaPlus;

-------------------------------------------------  Functions  -------------------------------------------------

local function PrivateMixin(object, ...)
    for index, mixin in ipairs(arg) do
		for key, value in pairs(mixin) do
			object[key] = value;
		end
	end

	return object;
end

local function PrivateCreateFromMixins(...)
	return PrivateMixin({}, unpack(arg))
end

Namespace.Mixin = PrivateMixin;
Namespace.CreateFromMixins = PrivateCreateFromMixins;

function Namespace.CreateAndInitFromMixin(mixin, ...)
	local object = PrivateCreateFromMixins(mixin);
	object:Init(unpack(arg));
	return object;
end