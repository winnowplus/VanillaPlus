--------------------------------------------------  Imports  --------------------------------------------------

local Namespace					= VanillaPlus;
local DefaultLogLevel			= Namespace.LogLevel;
local CreateAndInitFromMixin	= Namespace.CreateAndInitFromMixin;

-----------------------------------------------  Declarations  ------------------------------------------------

local LoggerMixin				= {};

-------------------------------------------------  Functions  -------------------------------------------------

local function Serialize(data)
	if(data == nil) then
		return "nil";
	end

	local dataType = type(data);

	if(dataType == "string") then
		return data;
	elseif(dataType == "number") then
		return tostring(data);
	elseif(dataType == "boolean") then
		return data and "true" or "false";
	elseif(dataType == "table") then
		local index = 1;
		local tmp = {};

		for key, value in pairs(data) do
			tmp[index] = string.format(type(key) == "number" and "[%s]=%s" or "%s=%s", Serialize(key), type(value) == "string" and '"' .. Serialize(value) .. '"' or Serialize(value));
			index = index + 1;
		end

		return string.format("{%s}", table.concat(tmp, ", "));
	else
		return string.format("<%s>", dataType or "UNKNOWN");
	end
end

local function Output(...)
	if(DEFAULT_CHAT_FRAME == nil) then
		return;
	end
	
	local numArgs = arg.n;
	
	if(numArgs == 0) then
		DEFAULT_CHAT_FRAME:AddMessage("nil");
	else
		local outputTable = {};
		
		for index = 1, numArgs do
			outputTable[index] = Serialize(arg[index]);
		end
		
		DEFAULT_CHAT_FRAME:AddMessage(table.concat(outputTable));
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