--------------------------------------------------  Imports  --------------------------------------------------

local Namespace         = VanillaPlus;
local GetLogger         = Namespace.GetLogger;
local EventRegistry     = Namespace.EventRegistry;

local GetSpellName      = GetSpellName;
local GetNumSpellTabs   = GetNumSpellTabs;
local GetSpellTabInfo   = GetSpellTabInfo;

-----------------------------------------------  Declarations  ------------------------------------------------

local Logger            = GetLogger(nil, 0);
local PLAYER_SPELL_CACHE= nil;
local PET_SPELL_CACHE   = nil;

-------------------------------------------------  Functions  -------------------------------------------------

local function CollectSpell(collection, slot, bookType)
    local name, rank = GetSpellName(slot, bookType);

    if(name ~= nil) then
        local fullname = (rank == nil or rank == "") and name or name .. "(" .. rank .. ")";
        local spell = {name = name, rank = rank, fullname = fullname, slot = slot, bookType = bookType};
        
        collection[fullname] = spell;
        collection[name] = spell;

        return spell;
    end
end

local function GetPlayerSpellCahce()
    if(PLAYER_SPELL_CACHE == nil) then
        PLAYER_SPELL_CACHE = {};

        for tabIndex = 1, GetNumSpellTabs() do
            local _, _, offset, numSpells = GetSpellTabInfo(tabIndex);

            for slot = offset + 1, offset + numSpells do
                CollectSpell(PLAYER_SPELL_CACHE, slot, BOOKTYPE_SPELL);
            end
        end
    end

    return PLAYER_SPELL_CACHE;
end

local function GetPetSpellCahce()
    if(PET_SPELL_CACHE == nil) then
        PET_SPELL_CACHE = {};

        local slot, spell = 0, nil;

        repeat
            slot = slot + 1;
            spell = CollectSpell(PET_SPELL_CACHE, slot, BOOKTYPE_PET);
        until(spell == nil)
    end

    return PET_SPELL_CACHE;
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

    PLAYER_SPELL_CACHE = nil;
end

local function CleanPetSpellCahce()
    PET_SPELL_CACHE = nil;
end

EventRegistry:RegisterFrameEventAndCallback("LEARNED_SPELL_IN_TAB", ON_LEARNED_SPELL_IN_TAB);