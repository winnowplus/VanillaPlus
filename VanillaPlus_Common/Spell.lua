--------------------------------------------------  Imports  --------------------------------------------------

local Namespace                 = VanillaPlus;
local GetLogger                 = Namespace.GetLogger;
local CreateAndInitFromMixin    = Namespace.CreateAndInitFromMixin;
local EventRegistry             = Namespace.EventRegistry;

local GetSpellName              = GetSpellName;
local GetSpellTexture           = GetSpellTexture;
local GetSpellCooldown          = GetSpellCooldown;
local GetNumSpellTabs           = GetNumSpellTabs;
local GetSpellTabInfo           = GetSpellTabInfo;

local GetTime                   = GetTime;

-----------------------------------------------  Declarations  ------------------------------------------------

local Logger                    = GetLogger("VanillaPlus", 0);
local SpellMixin		        = {};
local SPELL_CACHE               = {};

-------------------------------------------------  Functions  -------------------------------------------------

function SpellMixin:Init(slot, bookType)
    self.slot, self.bookType, self.name, self.rank = slot, bookType, GetSpellName(slot, bookType);

    if(self.name ~= nil) then
        self.fullname = (self.rank == nil or self.rank == "") and self.name or self.name .. "(" .. self.rank .. ")";

        SPELL_CACHE[bookType][self.fullname] = self;
        SPELL_CACHE[bookType][self.name] = self;
    end
end

function SpellMixin:GetTexture()
    if(self.texture == nil) then
        self.texture = GetSpellTexture(self.slot, self.bookType);
    end

    return self.texture;
end

function SpellMixin:GetCooldown()
    local start, duration, enabled = GetSpellCooldown(self.slot, self.bookType);

    if(enabled == 0) then
        return 0, true;
    elseif(start == 0) then
        return 0, false;
    else
        return start + duration - GetTime(), false;
    end
end

local function GetPlayerSpellCahce()
    if(SPELL_CACHE[BOOKTYPE_SPELL] == nil) then
        SPELL_CACHE[BOOKTYPE_SPELL] = {};

        for tabIndex = 1, GetNumSpellTabs() do
            local _, _, offset, numSpells = GetSpellTabInfo(tabIndex);

            for slot = offset + 1, offset + numSpells do
                CreateAndInitFromMixin(SpellMixin, slot, BOOKTYPE_SPELL);
            end
        end
    end

    return SPELL_CACHE[BOOKTYPE_SPELL];
end

local function GetPetSpellCahce()
    if(SPELL_CACHE[BOOKTYPE_PET] == nil) then
        SPELL_CACHE[BOOKTYPE_PET] = {};

        local slot, spell = 0, nil;

        repeat
            slot = slot + 1;
            spell = CreateAndInitFromMixin(SpellMixin, slot, BOOKTYPE_PET);
        until(spell.name == nil)
    end

    return SPELL_CACHE[BOOKTYPE_PET];
end

function Namespace.GetPlayerSpell(spellName)
    return GetPlayerSpellCahce()[spellName];
end

function Namespace.GetPetSpell(spellName)
    return GetPetSpellCahce()[spellName];
end

function Namespace.GetSpell(spellName)
    return GetPlayerSpellCahce()[spellName] or GetPetSpellCahce()[spellName];
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function ON_LEARNED_SPELL_IN_TAB()
    Logger:Debug("LEARNED_SPELL_IN_TAB ", arg1);

    SPELL_CACHE[BOOKTYPE_SPELL] = nil;
end

local function CleanPetSpellCahce()
    SPELL_CACHE[BOOKTYPE_PET] = nil;
end

EventRegistry:RegisterFrameEventAndCallback("LEARNED_SPELL_IN_TAB", ON_LEARNED_SPELL_IN_TAB);