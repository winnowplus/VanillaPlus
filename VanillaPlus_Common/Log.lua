--------------------------------------------------  Imports  --------------------------------------------------

local Namespace				= VanillaPlus;
local CreateAndInitFromMixin= Namespace.CreateAndInitFromMixin;
local DefaultLogLevel		= Namespace.LogLevel;

-----------------------------------------------  Declarations  ------------------------------------------------

local LoggerMixin		= {};
local TempOutputTable	= {};

-------------------------------------------------  Functions  -------------------------------------------------

local function Serialize(data)
	if(data == nil) then
		return "nil";
	elseif(type(data) == "number") then
		return tostring(data);
	elseif(type(data) == "string") then
		return data;
	elseif(type(data) == "boolean") then
		return data and "true" or "false";
	elseif(type(data) == "table") then
		local index, tmp = 1, {};

		for key, value in pairs(data) do
			tmp[index] = string.format(type(key) == "number" and "[%s]=%s" or "%s=%s", Serialize(key), type(value) == "string" and '"' .. Serialize(value) .. '"' or Serialize(value));
			index = index + 1;
		end

		return string.format("{%s}", table.concat(tmp, ", "));
	else
		return string.format("<%s>", type(data) or "UNKNOWN");
	end
end

local function Output(...)
	if(DEFAULT_CHAT_FRAME == nil) then
		return;
	end
	
	table.wipe(TempOutputTable);
	local numArgs = arg.n;
	
	if(numArgs == 0) then
		DEFAULT_CHAT_FRAME:AddMessage("nil");
	else
		for index = 1, numArgs do
			local value = arg[index];
			TempOutputTable[index] = Serialize(value);
		end
		
		DEFAULT_CHAT_FRAME:AddMessage(table.concat(TempOutputTable));
	end
end

function LoggerMixin:Init(name, level)
	assert(type(name) == "string", "Illegal name: " .. tostring(name) .. ", a string is required.");
	assert(type(level) == "number", "Illegal level: " .. tostring(level) .. ", a number is required.");

    self.name = name;
    self.level = level;
end

function LoggerMixin:Debug(...)
	if(self.level < 1) then
		Output("|cff80c0ff", self.name, " DEBUG: ", HIGHLIGHT_FONT_COLOR_CODE, unpack(arg));
	end
end

function LoggerMixin:Info(...)
	if(self.level < 2) then
		Output("|cff80c0ff", self.name, " INFO: ", HIGHLIGHT_FONT_COLOR_CODE, unpack(arg));
	end
end

function LoggerMixin:Warn(...)
	if(self.level < 3) then
		Output("|cff80c0ff", self.name, " WARN: ", HIGHLIGHT_FONT_COLOR_CODE, unpack(arg));
	end
end

function LoggerMixin:Error(...)
	Output("|cff80c0ff", self.name, " ERROR: ", HIGHLIGHT_FONT_COLOR_CODE, unpack(arg));
end

function Namespace.GetLogger(name, level)
    return CreateAndInitFromMixin(LoggerMixin, name or "VanillaPlus", level or DefaultLogLevel);
end