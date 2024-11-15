--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                 = VanillaPlus;
local CreateAndInitFromMixin    = Namespace.CreateAndInitFromMixin;
local EventRegistry             = Namespace.EventRegistry;

local GetSpellName              = GetSpellName;
local GetSpellTexture           = GetSpellTexture;
local GetSpellCooldown          = GetSpellCooldown;
local GetNumSpellTabs           = GetNumSpellTabs;
local GetSpellTabInfo           = GetSpellTabInfo;
local GetTime                   = GetTime;

-----------------------------------------------  Declarations  ------------------------------------------------

local SPELL_COST_PATTERN        = "(%d+)%s*(%S+)";
local SPELL_CACHE               = {};

local SpellMixin		        = {};

-------------------------------------------------  Functions  -------------------------------------------------

function SpellMixin:Init(slot, bookType)
    self.slot = slot;
    self.bookType = bookType;
    self.name, self.rank = GetSpellName(slot, bookType);
    self.texture = nil;

    if(self.name ~= nil) then
        self.fullname = (self.rank == nil or self.rank == "") and self.name or self.name .. "(" .. self.rank .. ")";
    end
end

function SpellMixin:GetTexture()
    if(self.texture == nil) then
        self.texture = GetSpellTexture(self.slot, self.bookType);
    end

    return self.texture;
end

function SpellMixin:GetCooldown()
    return GetSpellCooldown(self.slot, self.bookType);
end

function SpellMixin:GetCost()
    VanillaPlusTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    VanillaPlusTooltip:ClearLines();
    VanillaPlusTooltip:SetSpell(self.slot, self.bookType);

    local textLeft2 = VanillaPlusTooltipTextLeft2 and VanillaPlusTooltipTextLeft2:IsShown() and VanillaPlusTooltipTextLeft2:GetText() or nil;

    if(textLeft2 ~= nil) then
        local _, _, cost, powerTypeString = string.find(textLeft2, SPELL_COST_PATTERN);

        return cost, powerTypeString;
    end
end

local function GetPlayerSpellCahce()
    local bookType = BOOKTYPE_SPELL;

    if(SPELL_CACHE[bookType] == nil) then
        SPELL_CACHE[bookType] = {};

        for tabIndex = 1, GetNumSpellTabs() do
            local _, _, offset, numSpells = GetSpellTabInfo(tabIndex);

            for slot = offset + 1, offset + numSpells do
                local spell = CreateAndInitFromMixin(SpellMixin, slot, bookType);

                if(spell.name ~= nil) then
                    SPELL_CACHE[bookType][spell.name] = spell;
                    SPELL_CACHE[bookType][spell.fullname] = spell;
                end
            end
        end
    end

    return SPELL_CACHE[bookType];
end

local function GetPetSpellCahce()
    local bookType = BOOKTYPE_PET;

    if(SPELL_CACHE[bookType] == nil) then
        SPELL_CACHE[bookType] = {};

        local slot, spell = 0, nil;

        repeat
            slot = slot + 1;
            spell = CreateAndInitFromMixin(SpellMixin, slot, bookType);

            if(spell.name ~= nil) then
                SPELL_CACHE[bookType][spell.name] = spell;
                SPELL_CACHE[bookType][spell.fullname] = spell;
            end
        until(spell.name == nil)
    end

    return SPELL_CACHE[bookType];
end

function Namespace.GetSpell(spellName, bookType)
    if(bookType == nil) then
        return GetPlayerSpellCahce()[spellName] or GetPetSpellCahce()[spellName];
    elseif(bookType == BOOKTYPE_SPELL) then
        return GetPlayerSpellCahce()[spellName];
    elseif(bookType == BOOKTYPE_PET) then
        return GetPetSpellCahce()[spellName];
    end
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function ON_LEARNED_SPELL_IN_TAB()
    SPELL_CACHE[BOOKTYPE_SPELL] = nil;Namespace.GetLogger("VanillaPlus", 0):Debug("LEARNED_SPELL_IN_TAB");
end

local function ON_PLAYER_PET_CHANGED()
    SPELL_CACHE[BOOKTYPE_PET] = nil;
end

EventRegistry:RegisterFrameEventAndCallback("LEARNED_SPELL_IN_TAB", ON_LEARNED_SPELL_IN_TAB);
EventRegistry:RegisterFrameEventAndCallback("PLAYER_PET_CHANGED", ON_PLAYER_PET_CHANGED);