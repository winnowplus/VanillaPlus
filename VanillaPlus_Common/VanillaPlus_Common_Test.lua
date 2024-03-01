--------------------------------------------------  Imports  --------------------------------------------------

local Namespace     = VanillaPlus;
local Predicates    = Namespace.Predicates;
local GetLogger     = Namespace.GetLogger;

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
    local slot, name, rank, fullName, lastName = 0, nil, nil, nil, nil;

    repeat
        slot = slot + 1;
        name, rank = GetSpellName(slot, bookType);

        if(lastName ~= nil and lastName ~= name) then
            local spell = bookType == BOOKTYPE_SPELL and Namespace.GetPlayerSpell(lastName) or Namespace.GetPetSpell(lastName);
            local spell1 = Namespace.GetSpell(lastName);

            assert(spell ~= nil and spell.name == lastName and spell.slot == slot - 1 and spell.bookType == bookType);
            assert(spell1 ~= nil and spell1.name == lastName and spell1.slot == slot - 1 and spell1.bookType == bookType);
        end

        if(name ~= nil) then
            fullname = (rank == nil or rank == "") and name or name .. "(" .. rank .. ")";

            local spell = bookType == BOOKTYPE_SPELL and Namespace.GetPlayerSpell(fullname) or Namespace.GetPetSpell(fullname);
            local spell1 = Namespace.GetSpell(fullname);

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
    Namespace.TestPredicates(); Logger:INfo("TestPredicates Pass");
    Namespace.TestSpell();      Logger:INfo("TestSpell Pass");
end