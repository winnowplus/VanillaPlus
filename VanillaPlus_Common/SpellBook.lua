--------------------------------------------------  Imports  --------------------------------------------------

local Namespace         = VanillaPlus;
local EventRegistry     = Namespace.EventRegistry;

local GetNumSpellTabs   = GetNumSpellTabs;
local GetSpellTabInfo   = GetSpellTabInfo;
local GetSpellName      = GetSpellName;

-----------------------------------------------  Declarations  ------------------------------------------------

local SPELL_CACHE       = nil;
local PET_SPELL_CACHE   = nil;

-------------------------------------------------  Functions  -------------------------------------------------

local function GetSpellCahce()
    if(SPELL_CACHE == nil) then
        SPELL_CACHE = {};

        for tabIndex = GetNumSpellTabs(), 1, -1 do
            local _, _, offset, numSpells = GetSpellTabInfo(tabIndex);

            for slot = offset + numSpells, offset + 1, -1 do
                local name, rank = GetSpellName(slot, BOOKTYPE_SPELL);

                if(name ~= nil) then
                    local fullname = (rank == nil or rank == "") and name or name .. "(" .. rank .. ")";
                    local spell = {name = name, rank = rank, fullname = fullname, slot = slot, bookType = BOOKTYPE_SPELL};

                    SPELL_CACHE[fullname] = spell;
                    SPELL_CACHE[name] = SPELL_CACHE[name] or spell;
                end
            end
        end
    end

    return SPELL_CACHE;
end

local function GetPetSpellCahce()
    if(PET_SPELL_CACHE == nil) then
        PET_SPELL_CACHE = {};

        --TODO
    end

    return PET_SPELL_CACHE;
end

function Namespace.GetSpellSlot(fullname)
    local spell = GetSpellCahce()[fullname];

    if(spell ~= nil) then
        return spell.slot, spell.bookType;
    end
end

function Namespace.GetPetSpellSlot(fullname)
    local spell = GetPetSpellCahce()[fullname];

    if(spell ~= nil) then
        return spell.slot, spell.bookType;
    end
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function CleanSpellCahce()
    SPELL_CACHE = nil;
end

local function CleanPetSpellCahce()
    PET_SPELL_CACHE = nil;
end

EventRegistry:RegisterFrameEventAndCallback("LEARNED_SPELL_IN_TAB", CleanSpellCahce);
--EventRegistry:RegisterFrameEventAndCallback("SPELLS_CHANGED", TestSpellChange);