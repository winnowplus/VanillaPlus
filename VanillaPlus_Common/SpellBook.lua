--------------------------------------------------  Imports  --------------------------------------------------

local Namespace         = VanillaPlus;
local EventRegistry     = Namespace.EventRegistry;

local GetNumSpellTabs   = GetNumSpellTabs;
local GetSpellTabInfo   = GetSpellTabInfo;
local GetSpellName      = GetSpellName;

-----------------------------------------------  Declarations  ------------------------------------------------

local SPELL_NAME_REGEX  = "(.+)%((.+)%)";

-------------------------------------------------  Functions  -------------------------------------------------

local function TestLearnedSpell()
    Namespace.GetLogger():Info("LEARNED_SPELL_IN_TAB ", arg1);
end

local function TestSpellChange()
    Namespace.GetLogger():Info("SPELLS_CHANGED ", arg1);
end

EventRegistry:RegisterFrameEventAndCallback("LEARNED_SPELL_IN_TAB", TestLearnedSpell);
EventRegistry:RegisterFrameEventAndCallback("SPELLS_CHANGED", TestSpellChange);