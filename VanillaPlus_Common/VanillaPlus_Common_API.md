# VanillaPlus_Common API

## Predicates

- VanillaPlus.Predicates.ALWAYS_TRUE(...) - Always return true.
- VanillaPlus.Predicates.ALWAYS_FALSE(...) - Always return false.
- VanillaPlus.Predicates.EQUALS(one, another) - Return true if one == another.
- VanillaPlus.Predicates.STRING_CONTAINS(str, substr) - Return true if str contains substr.
- VanillaPlus.Predicates.AURA_NAME_EQUALS(aura, expect) - Return true if aura.name == expect.
- VanillaPlus.Predicates.AURA_NAME_CONTAINS(aura, expect) - Return true if aura.name contains expect.

## Mixin

- VanillaPlus.Mixin(object, ...) - Mixin attributes from ... (one or more tables) to object (table).
- VanillaPlus.CreateFromMixins(...) - Create a table from one or more mixins.
- VanillaPlus.CreateAndInitFromMixin(mixin, ...) - Create a table from mixin, and then call its Init method with given parameters (...).

## Log

- VanillaPlus.GetLogger(name, level) - Return a Logger with specific name (string) and level (number).
  - Logger:Debug(...) - Output debug message.
  - Logger:Info(...) - Output info message.
  - Logger:Warn(...) - Output warn message.
  - Logger:Error(...) - Output error message.

## EventRegistry

- VanillaPlus.EventRegistry:RegisterCallback(event, func, owner) - Register callback for customize event.
- VanillaPlus.EventRegistry:RegisterFrameEventAndCallback(frameEvent, func, owner) - Register callback for WoW frame event.
- VanillaPlus.EventRegistry:UnregisterCallback(event, owner) - Unregister callback for customize event.
- VanillaPlus.EventRegistry:UnregisterFrameEventAndCallback(frameEvent, owner) - Unregister callback for WoW frame event.
- VanillaPlus.EventRegistry:TriggerEvent(event, ...) - Trigger customize event.

## Unit

- VanillaPlus.GetPlayerAura(slot, filter) - Get player's aura by given slot and filter.
- VanillaPlus.FindPlayerAura(filter, predicate, ...) - Find player's aura by given filter and predicate.
- VanillaPlus.ListPlayerAura(filter, predicate, ...) - List player's aura by given filter and predicate.
- VanillaPlus.GetUnitBuff(unit, slot) - Get buff by given unit and slot.
- VanillaPlus.FindUnitBuff(unit, predicate, ...) - Find buff by given unit and predicate.
- VanillaPlus.ListUnitBuff(unit, predicate, ...) - List buff by given unit and predicate.
- VanillaPlus.GetUnitDebuff(unit, slot) - Get debuff by given unit and slot.
- VanillaPlus.FindUnitDebuff(unit, predicate, ...) - Find debuff by given unit and predicate.
- VanillaPlus.ListUnitDebuff(unit, predicate, ...) - List debuff by given unit and predicate.
