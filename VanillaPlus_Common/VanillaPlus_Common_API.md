# VanillaPlus_Common API

## Mixin

+ VanillaPlus.Mixin(object, ...) - Mixin attributes from ... (one or more tables) to object (a table).
+ VanillaPlus.CreateFromMixins(...) - Create a table from ... (one or more mixins).
+ VanillaPlus.CreateAndInitFromMixin(mixin, ...) - Create a table from mixin, and then call its Init method with ... (zero or more parameters).

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
  + A spell has attributes: slot, bookType, texture, name, rank, fullname.
  + Spell:GetCooldown() - Returns the cooldown data of the spell.
  + Spell:GetCost() - Returns cost number and power type of the spell.
