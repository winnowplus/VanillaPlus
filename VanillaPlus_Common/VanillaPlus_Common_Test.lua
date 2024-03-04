--------------------------------------------------  Imports  --------------------------------------------------

local Namespace     = VanillaPlus;
local GetLogger     = Namespace.GetLogger;

local Predicates    = Namespace.Predicates;

local GetPlayerSpell= Namespace.GetPlayerSpell;
local GetPetSpell   = Namespace.GetPetSpell;
local GetSpell      = Namespace.GetSpell;

-----------------------------------------------  Declarations  ------------------------------------------------

local Logger        = GetLogger();

-------------------------------------------------  Functions  -------------------------------------------------

function Namespace.TestPredicates()
    local str, substr, notsubstr = "命令圣印", "圣印", "光环";
    local aura = {name = str};

    assert(Predicates.STRING_CONTAINS(str, str));
    assert(Predicates.STRING_CONTAINS(str, substr));
    assert(not Predicates.STRING_CONTAINS(str, notsubstr));

    assert(Predicates.AURA_NAME_EQUALS(aura, str));
    assert(not Predicates.AURA_NAME_EQUALS(aura, substr));

    assert(Predicates.AURA_NAME_CONTAINS(aura, str));
    assert(Predicates.AURA_NAME_CONTAINS(aura, substr));
    assert(not Predicates.AURA_NAME_CONTAINS(aura, notsubstr));
end

local function TestGetSpell(bookType)
    local spellFunc;

    if(bookType == BOOKTYPE_SPELL) then
        spellFunc = GetPlayerSpell;
    elseif(bookType == BOOKTYPE_PET) then
        spellFunc = GetSpell;
    else
        Logger:Error("Illegal bookType: ", bookType, ".");
    end

    local slot, name, rank, fullName, lastName = 0, nil, nil, nil, nil;

    repeat
        slot = slot + 1;
        name, rank = GetSpellName(slot, bookType);

        if(lastName ~= nil and lastName ~= name) then
            local spell = spellFunc(lastName);
            local spell1 = GetSpell(lastName);

            assert(spell ~= nil and spell.name == lastName and spell.slot == slot - 1 and spell.bookType == bookType);
            assert(spell1 ~= nil and spell1.name == lastName and spell1.slot == slot - 1 and spell1.bookType == bookType);
        end

        if(name ~= nil) then
            fullname = (rank == nil or rank == "") and name or name .. "(" .. rank .. ")";

            local spell = spellFunc(fullname);
            local spell1 = GetSpell(fullname);

            assert(spell ~= nil and spell.name == name and spell.rank == rank and spell.fullname == fullname and spell.slot == slot and spell.bookType == bookType);
            assert(spell1 ~= nil and spell1.name == name and spell1.rank == rank and spell1.fullname == fullname and spell1.slot == slot and spell1.bookType == bookType);

            lastName = name;
        end
    until(name == nil)
end

function Namespace.TestSpell()
    TestGetSpell(BOOKTYPE_SPELL);
    TestGetSpell(BOOKTYPE_PET);
end

function Namespace.TestCommon()
    Namespace.TestPredicates(); Logger:Info("TestPredicates Pass");
    Namespace.TestSpell();      Logger:Info("TestSpell Pass");
end