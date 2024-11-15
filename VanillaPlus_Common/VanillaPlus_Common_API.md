# VanillaPlus_Common API

## Mixin

+ VanillaPlus.Mixin(object, ...) - Mixin attributes from ... (one or more tables) to object (a table).
+ VanillaPlus.CreateFromMixins(...) - Create a table from ... (one or more mixins).
+ VanillaPlus.CreateAndInitFromMixin(mixin, ...) - Create a table from mixin, and then call its Init method with ... (zero or more parameters).

## Strings

+ VanillaPlus.Strings.Trim(str) - Trims any leading or trailing white space from the given string.
+ VanillaPlus.Strings.Split(str, seperatorPattern) - Splits the given string into a list of sub-strings.

## Predicates

+ VanillaPlus.Predicates.ALWAYS_TRUE(...) - Always returns true.
+ VanillaPlus.Predicates.ALWAYS_FALSE(...) - Always returns false.
+ VanillaPlus.Predicates.EQUALS(one, another) - Returns true if one == another.
+ VanillaPlus.Predicates.STRING_CONTAINS(str, substr) - Returns true if str contains substr.
+ VanillaPlus.Predicates.AURA_NAME_EQUALS(aura, expect) - Returns true if aura.name == expect.
+ VanillaPlus.Predicates.AURA_NAME_CONTAINS(aura, expect) - Returns true if aura.name contains expect.

## Log

+ VanillaPlus.GetLogger(name, level) - Returns a Logger of given name (string) and level (number - 0: DEBUG, 1: INFO, 2: WARN, 3: ERROR).
  + Logger:Debug(...) - Log debug message.
  + Logger:Info(...) - Log info message.
  + Logger:Warn(...) - Log warn message.
  + Logger:Error(...) - Log error message.

## EventRegistry

+ VanillaPlus.EventRegistry:RegisterCallback(event, func, owner) - Register callback for customize event.
+ VanillaPlus.EventRegistry:RegisterFrameEventAndCallback(frameEvent, func, owner) - Register callback for WoW frame event.
+ VanillaPlus.EventRegistry:UnregisterCallback(event, owner) - Unregister callback for customize event.
+ VanillaPlus.EventRegistry:UnregisterFrameEventAndCallback(frameEvent, owner) - Unregister callback for WoW frame event.
+ VanillaPlus.EventRegistry:TriggerEvent(event, ...) - Trigger customize event.

## Spell

+ VanillaPlus.GetSpell(spellName, bookType) - Returns spell by name and bookType.
  + A spell has attributes: slot, bookType, name, rank, fullname.
  + Spell:GetTexture() - Returns the texture path of the spell.
  + Spell:GetCooldown() - Returns the cooldown data of the spell.
  + Spell:GetCost() - Returns cost number and power type of the spell.

## Unit

+ VanillaPlus.GetPlayerAura(slot, filter) - Get player's aura by slot and filter.
+ VanillaPlus.FindPlayerAura(filter, predicate, ...) - Find player's aura by filter and predicate.
+ VanillaPlus.ListPlayerAura(filter, predicate, ...) - List player's aura by filter and predicate.
+ VanillaPlus.GetUnitBuff(unit, slot) - Get buff by unit and slot.
+ VanillaPlus.FindUnitBuff(unit, predicate, ...) - Find buff by unit and predicate.
+ VanillaPlus.ListUnitBuff(unit, predicate, ...) - List buff by unit and predicate.
+ VanillaPlus.GetUnitDebuff(unit, slot) - Get debuff by unit and slot.
+ VanillaPlus.FindUnitDebuff(unit, predicate, ...) - Find debuff by unit and predicate.
+ VanillaPlus.ListUnitDebuff(unit, predicate, ...) - List debuff by unit and predicate.
