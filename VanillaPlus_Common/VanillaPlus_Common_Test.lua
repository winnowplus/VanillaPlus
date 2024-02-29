--------------------------------------------------  Imports  --------------------------------------------------

local Namespace     = VanillaPlus;
local Predicates    = Namespace.Predicates;

-----------------------------------------------  Declarations  ------------------------------------------------

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

local function TestGetSpellSlot(bookType)
    local slot, name, rank, fullName, lastName = 0, nil, nil, nil, nil;

    repeat
        slot = slot + 1;
        name, rank = GetSpellName(slot, bookType);

        if(lastName ~= nil and lastName ~= name) then
            local name_slot, name_bookType = Namespace.GetPlayerSpellSlot(lastName);
            local name_slot1, name_bookType1 = Namespace.GetSpellSlot(lastName);
            assert(name_slot == slot);
            assert(name_bookType == bookType);
            assert(name_slot1 == slot);
            assert(name_bookType1 == bookType);
        end

        if(name ~= nil) then
            fullname = (rank == nil or rank == "") and name or name .. "(" .. rank .. ")";

            local fullname_slot, fullname_bookType = Namespace.GetPlayerSpellSlot(fullname);
            local fullname_slot1, fullname_bookType1 = Namespace.GetSpellSlot(fullname);
            assert(fullname_slot == slot);
            assert(fullname_bookType == bookType);
            assert(fullname_slot1 == slot);
            assert(fullname_bookType1 == bookType);
        end
    until(name == nil)
end

function Namespace.TestSpell()
    TestGetSpellSlot(BOOKTYPE_SPELL);
    TestGetSpellSlot(BOOKTYPE_PET);
end

function Namespace.TestCommon()
    Namespace.TestPredicates();
    Namespace.TestSpell();
end