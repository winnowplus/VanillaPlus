--------------------------------------------------  Imports  --------------------------------------------------

local Namespace         = VanillaPlus;
local GetLogger         = Namespace.GetLogger;

local Strings           = Namespace.Strings;
local Predicates        = Namespace.Predicates;
local GetSpell          = Namespace.GetSpell;

local GetSpellName      = GetSpellName;
local GetSpellTexture   = GetSpellTexture;

-----------------------------------------------  Declarations  ------------------------------------------------

local Logger            = GetLogger();

-------------------------------------------------  Functions  -------------------------------------------------

function Namespace.TestStrings()
    assert(Strings.Trim("xyz123") == "xyz123");
    assert(Strings.Trim(" xyz123") == "xyz123");
    assert(Strings.Trim("  xyz123") == "xyz123");
    assert(Strings.Trim(" xyz123 ") == "xyz123");
    assert(Strings.Trim("  xyz123  ") == "xyz123");
    assert(Strings.Trim("   xyz123 ") == "xyz123");
    assert(Strings.Trim("  xyz123     ") == "xyz123");

    local tbl = {"foo", "bar", "baz", "test"};

    local splitted = Strings.Split("foo/bar/baz/test","/");
    for key, value in ipairs(tbl) do assert(splitted[key] == value); end
    assert(splitted[5] == nil);

    splitted = Strings.Split("/foo/bar/baz/test","/");
    for key, value in ipairs(tbl) do assert(splitted[key] == value); end
    assert(splitted[5] == nil);

    splitted = Strings.Split("/foo/bar/baz/test/","/");
    for key, value in ipairs(tbl) do assert(splitted[key] == value); end
    assert(splitted[5] == nil);

    splitted = Strings.Split("//foo////bar/baz///test///","/+");
    for key, value in ipairs(tbl) do assert(splitted[key] == value); end
    assert(splitted[5] == nil);

    splitted = Strings.Split("/foo/bar//baz/test///","/");
    assert(splitted[1] == "foo" and splitted[2] == "bar" and splitted[3] == "" and splitted[4] == "baz" and splitted[5] == "test" and splitted[6] == "" and splitted[7] == "");
end

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
            assert(spell.texture == GetSpellTexture(slot - 1, bookType));

            spell = GetSpell(lastName);
            assert(spell ~= nil and spell.name == lastName);
            assert(spell.slot == slot - 1 and spell.bookType == bookType);
            assert(spell.texture == GetSpellTexture(slot - 1, bookType));
        end

        if(name ~= nil) then
            fullname = (rank == nil or rank == "") and name or name .. "(" .. rank .. ")";

            local spell = GetSpell(fullname, bookType);
            assert(spell ~= nil and spell.name == name and spell.rank == rank and spell.fullname == fullname);
            assert(spell.slot == slot and spell.bookType == bookType);
            assert(spell.texture == GetSpellTexture(slot, bookType));

            spell = GetSpell(fullname);
            assert(spell ~= nil and spell.name == name and spell.rank == rank and spell.fullname == fullname);
            assert(spell.slot == slot and spell.bookType == bookType);
            assert(spell.texture == GetSpellTexture(slot, bookType));

            lastName = name;
        end
    until(name == nil)
end

function Namespace.TestSpell()
    TestGetSpell(BOOKTYPE_SPELL);
    TestGetSpell(BOOKTYPE_PET);
end

function Namespace.TestCommon()
    Namespace.TestStrings();    Logger:Info("TestStrings Pass");
    Namespace.TestPredicates(); Logger:Info("TestPredicates Pass");
    Namespace.TestSpell();      Logger:Info("TestSpell Pass");
end