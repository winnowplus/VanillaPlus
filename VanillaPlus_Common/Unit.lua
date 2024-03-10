--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                         = VanillaPlus;

local StandardAPI                       = Namespace.StandardAPI;
StandardAPI.GetPlayerBuff               = StandardAPI.GetPlayerBuff or GetPlayerBuff;
StandardAPI.GetPlayerBuffTexture        = StandardAPI.GetPlayerBuffTexture or GetPlayerBuffTexture;
StandardAPI.GetPlayerBuffApplications   = StandardAPI.GetPlayerBuffApplications or GetPlayerBuffApplications;
StandardAPI.GetPlayerBuffDispelType     = StandardAPI.GetPlayerBuffDispelType or GetPlayerBuffDispelType;
StandardAPI.GetPlayerBuffTimeLeft       = StandardAPI.GetPlayerBuffTimeLeft or GetPlayerBuffTimeLeft;
StandardAPI.UnitBuff                    = StandardAPI.UnitBuff or UnitBuff;
StandardAPI.UnitDebuff                  = StandardAPI.UnitDebuff or UnitDebuff;

-----------------------------------------------  Declarations  ------------------------------------------------

local PLAYER_AURA_SLOT_OFFSET           = -1; -- -1 for Vanilla, 0 for Tbc

-------------------------------------------------  Functions  -------------------------------------------------

local function PrivateGetPlayerAura(slot, filter)
    local auraIndex, untilCancelled = StandardAPI.GetPlayerBuff(PLAYER_AURA_SLOT_OFFSET + slot, filter);
    if(auraIndex < 0) then
        return;
    end

    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetPlayerBuff(auraIndex);

    return {
        name        = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:IsShown() and VanillaPlusTooltipTextLeft1:GetText() or nil,
        texture     = StandardAPI.GetPlayerBuffTexture(auraIndex),
        count       = StandardAPI.GetPlayerBuffApplications(auraIndex),
        dispelType  = StandardAPI.GetPlayerBuffDispelType(auraIndex),
        timeLeft    = untilCancelled == 1 and math.huge or StandardAPI.GetPlayerBuffTimeLeft(auraIndex),
        index       = auraIndex
    };
end

local function PrivateGetUnitBuff(unit, slot)
    local texture, count = StandardAPI.UnitBuff(unit, slot);
    if(texture == nil) then
        return;
    end

    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetUnitBuff(unit, slot);

    return {
        name    = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:IsShown() and VanillaPlusTooltipTextLeft1:GetText() or nil,
        texture = texture,
        count   = count,
        slot    = slot
    };
end

local function PrivateGetUnitDebuff(unit, slot)
    local texture, count, dispelType = StandardAPI.UnitDebuff(unit, slot);
    if(texture == nil) then
        return;
    end

    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetUnitDebuff(unit, slot);

    return {
        name        = VanillaPlusTooltipTextLeft1 and VanillaPlusTooltipTextLeft1:IsShown() and VanillaPlusTooltipTextLeft1:GetText() or nil,
        texture     = texture,
        count       = count,
        dispelType  = dispelType,
        slot        = slot
    };
end

Namespace.GetPlayerAura = PrivateGetPlayerAura;
Namespace.GetUnitBuff = PrivateGetUnitBuff;
Namespace.GetUnitDebuff = PrivateGetUnitDebuff;

function Namespace.FindPlayerAura(filter, predicate, ...)
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