--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                 = VanillaPlus;

local GetPlayerBuff             = GetPlayerBuff;
local GetPlayerBuffTexture      = GetPlayerBuffTexture;
local GetPlayerBuffApplications = GetPlayerBuffApplications;
local GetPlayerBuffDispelType   = GetPlayerBuffDispelType;
local GetPlayerBuffTimeLeft     = GetPlayerBuffTimeLeft;
local UnitBuff                  = UnitBuff;
local UnitDebuff                = UnitDebuff;

-----------------------------------------------  Declarations  ------------------------------------------------

local PLAYER_AURA_SLOT_OFFSET   = -1; -- -1 for Vanilla, 0 for Tbc

-------------------------------------------------  Functions  -------------------------------------------------

local function PrivateGetPlayerAura(slot, filter)
    local auraIndex, untilCancelled = GetPlayerBuff(PLAYER_AURA_SLOT_OFFSET + slot, filter);
    if(auraIndex < 0) then
        return;
    end

    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetPlayerBuff(auraIndex);

    return {
        name        = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:GetText(),
        icon        = GetPlayerBuffTexture(auraIndex),
        count       = GetPlayerBuffApplications(auraIndex),
        dispelType  = GetPlayerBuffDispelType(auraIndex),
        timeLeft    = untilCancelled and math.huge or GetPlayerBuffTimeLeft(auraIndex),
        index       = auraIndex
    };
end

local function PrivateGetUnitBuff(unit, slot)
    local icon, count = UnitBuff(unit, slot);
    if(icon == nil) then
        return;
    end

    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetUnitBuff(unit, slot);

    return {
        name    = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:GetText(),
        icon    = icon,
        count   = count,
        slot    = slot
    };
end

local function PrivateGetUnitDebuff(unit, slot)
    local icon, count, dispelType = UnitDebuff(unit, slot);
    if(icon == nil) then
        return;
    end

    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetUnitDebuff(unit, slot);

    return {
        name        = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:GetText(),
        icon        = icon,
        count       = count,
        dispelType  = dispelType,
        slot        = slot
    };
end

Namespace.GetPlayerAura = PrivateGetPlayerAura;
Namespace.GetUnitBuff = PrivateGetUnitBuff;
Namespace.GetUnitDebuff = PrivateGetUnitDebuff;

function Namespace.FindPlayerAura(filter, predicate, ...)
    assert(type(unit) == "string", "Illegal unit: " .. tostring(unit) .. ", a string is required.");
	assert(type(predicate) == "function", "Illegal predicate: " .. tostring(predicate) .. ", a function is required.");

    local slot, aura = 0, nil;

    repeat
        slot = slot + 1;
        aura = PrivateGetPlayerAura(slot, filter);

        if(aura ~= nil and predicate(aura, unpack(arg))) then
            return aura;
        end
    until(aura == nil)
end

function Namespace.ListPlayerAura(filter, predicate, ...)
    assert(type(unit) == "string", "Illegal unit: " .. tostring(unit) .. ", a string is required.");
	assert(type(predicate) == "function", "Illegal predicate: " .. tostring(predicate) .. ", a function is required.");

    local result, slot, aura = {}, 0, nil;

    repeat
        slot = slot + 1;
        aura = PrivateGetPlayerAura(slot, filter);

        if(aura ~= nil and predicate(aura, unpack(arg))) then
            table.insert(result, aura);
        end
    until(aura == nil)

    return result;
end

function Namespace.FindUnitBuff(unit, predicate, ...)
    assert(type(unit) == "string", "Illegal unit: " .. tostring(unit) .. ", a string is required.");
	assert(type(predicate) == "function", "Illegal predicate: " .. tostring(predicate) .. ", a function is required.");

    local slot, aura = 0, nil;

    repeat
        slot = slot + 1;
        aura = PrivateGetUnitBuff(unit, slot);

        if(aura ~= nil and predicate(aura, unpack(arg))) then
            return aura;
        end
    until(aura == nil)
end

function Namespace.ListUnitBuff(unit, predicate, ...)
    assert(type(unit) == "string", "Illegal unit: " .. tostring(unit) .. ", a string is required.");
	assert(type(predicate) == "function", "Illegal predicate: " .. tostring(predicate) .. ", a function is required.");

    local result, slot, aura = {}, 0, nil;

    repeat
        slot = slot + 1;
        aura = PrivateGetUnitBuff(unit, slot);

        if(aura ~= nil and predicate(aura, unpack(arg))) then
            table.insert(result, aura);
        end
    until(aura == nil)

    return result;
end

function Namespace.FindUnitDebuff(unit, predicate, ...)
    assert(type(unit) == "string", "Illegal unit: " .. tostring(unit) .. ", a string is required.");
	assert(type(predicate) == "function", "Illegal predicate: " .. tostring(predicate) .. ", a function is required.");

    local slot, aura = 0, nil;

    repeat
        slot = slot + 1;
        aura = PrivateGetUnitDebuff(unit, slot);

        if(aura ~= nil and predicate(aura, unpack(arg))) then
            return aura;
        end
    until(aura == nil)
end

function Namespace.ListUnitDebuff(unit, predicate, ...)
    assert(type(unit) == "string", "Illegal unit: " .. tostring(unit) .. ", a string is required.");
	assert(type(predicate) == "function", "Illegal predicate: " .. tostring(predicate) .. ", a function is required.");

    local result, slot, aura = {}, 0, nil;

    repeat
        slot = slot + 1;
        aura = PrivateGetUnitDebuff(unit, slot);

        if(aura ~= nil and predicate(aura, unpack(arg))) then
            table.insert(result, aura);
        end
    until(aura == nil)

    return result;
end