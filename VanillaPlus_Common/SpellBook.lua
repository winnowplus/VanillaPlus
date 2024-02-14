--------------------------------------------------  Imports  --------------------------------------------------

local Namespace         = VanillaPlus;
local EventRegistry     = Namespace.EventRegistry;

local GetNumSpellTabs   = GetNumSpellTabs;
local GetSpellTabInfo   = GetSpellTabInfo;
local GetSpellName      = GetSpellName;

-----------------------------------------------  Declarations  ------------------------------------------------

local SPELL_NAME_FORMAT	= "%s (" .. LEVEL .. " %d)";

local SPELL_CACHE       = nil;
local PET_SPELL_CACHE   = nil;

-------------------------------------------------  Functions  -------------------------------------------------

local function GetSpellCahce()
    if(SPELL_CACHE ~= nil) then
        return SPELL_CACHE;
    end

    SPELL_CACHE = {};

    for tabIndex = GetNumSpellTabs(), 1, -1 do
        local _, _, offset, numSpells = GetSpellTabInfo(tabIndex);

        for spellSlot = offset + numSpells, offset + 1, -1 do
            local spellName, spellRank = GetSpellName(spellSlot, BOOKTYPE_SPELL);

            if(spellName ~= nil) then
                local spell = {name = spellName, rank = spellRank, fullname = spellName .. "(" .. spellRank .. ")", slot = spellSlot, bookType = BOOKTYPE_SPELL};

                SPELL_CACHE[fullname] = spell;
                SPELL_CACHE[name] = SPELL_CACHE[name] or spell;
            end
        end
    end
end

function Namespace.GetSpellSlot(fullname)
    local spell = GetSpellCahce()[fullname];

    if(spell ~= nil) then
        return spell.slot, spell.bookType;
    end
end

----------------------------------------------  Event Callbacks  ----------------------------------------------

local function CleanSpellCahce()
    SPELL_CACHE = nil;
end

EventRegistry:RegisterFrameEventAndCallback("LEARNED_SPELL_IN_TAB", CleanSpellCahce);
--EventRegistry:RegisterFrameEventAndCallback("SPELLS_CHANGED", TestSpellChange);