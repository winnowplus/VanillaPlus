--------------------------------------------------  Imports  --------------------------------------------------

local Namespace     = VanillaPlus;
local GetLogger     = Namespace.GetLogger;

local Predicates    = Namespace.Predicates;
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
    local slot, name, rank, fullName, lastName = 0;

    repeat
        slot = slot + 1;
        name, rank = GetSpellName(slot, bookType);

        if(lastName ~= nil and lastName ~= name) then
            local spell = GetSpell(lastName, bookType);
            assert(spell ~= nil and spell.name == lastName);
            assert(spell.slot == slot - 1 and spell.bookType == bookType);
            assert(spell:GetTexture() == GetSpellTexture(slot - 1, bookType));

            spell = GetSpell(lastName);
            assert(spell ~= nil and spell.name == lastName);
            assert(spell.slot == slot - 1 and spell.bookType == bookType);
            assert(spell:GetTexture() == GetSpellTexture(slot - 1, bookType));
        end

        if(name ~= nil) then
            fullname = (rank == nil or rank == "") and name or name .. "(" .. rank .. ")";

            local spell = GetSpell(lastName, bookType);
            assert(spell ~= nil and spell.name == name and spell.rank == rank and spell.fullname == fullname);
            assert(spell.slot == slot and spell.bookType == bookType);
            assert(spell:GetTexture() == GetSpellTexture(slot, bookType));

            spell = GetSpell(fullname);
            assert(spell ~= nil and spell.name == name and spell.rank == rank and spell.fullname == fullname);
            assert(spell.slot == slot and spell.bookType == bookType);
            assert(spell:GetTexture() == GetSpellTexture(slot, bookType));

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