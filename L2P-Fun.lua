-- L2P-Fun
-- encapsulates calls to the wow api

-- AceAddon prelude for library registration
local MAJOR, MINOR = "L2P-Fun", 1
local Fun = LibStub:NewLibrary(MAJOR, MINOR)
if not Fun then return end

------- Get Spell Info

function Fun.GetSpellInfo(...)
  return C_Spell.GetSpellInfo(...)
end

function Fun.XGetSpellInfo(...)
  local tb = C_Spell.GetSpellInfo(...) or {}
   -- name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon
  return tb.name, nil, tb.iconID, tb.castTime, tb.minRange, tb.maxRange, tb.spellID, tb.originalIconID
end

------- Get Spell Cooldown

function Fun.GetSpellCooldown(...)
  return C_Spell.GetSpellCooldown(...) or {}
end

function Fun.XGetSpellCooldown(...)
  local tb = C_Spell.GetSpellCooldown(...) or {}
  return tb.startTime, tb.duration, tb.isEnabled
end

------ UnitBuff, UnitAura, UnitDebuff etc

function Fun.UnitBuff(unit, idx)
  return C_UnitAuras.GetAuraDataByIndex(unit, idx, "HELPFUL")
end

function Fun.XUnitBuff(unit, idx)
 local aura = C_UnitAuras.GetAuraDataByIndex(unit, idx, "HELPFUL") or {}
 -- name, icon, count, dispelType, duration, 
 -- expirationTime, source, isStealable, nameplateShowPersonal,
 -- spellId, canApplyAura, isBossDebuff, castByPlayer, 
 -- nameplateShowAll, timeMod
 return aura.name, aura.icon, aura.applications, aura.dispellName, aura.duration,
  aura.expirationTime, aura.sourceUnit, aura.isStealable, aura.nameplateShowPersonal,
  aura.spellId, aura.canApplyAura, aura.isBossAura, aura.isFromPlayerOrPlayerPet,
  aura.nameplateShowAll, aura.timeMod
 
end

function Fun.UnitDebuff(unit, idx)
  return C_UnitAuras.GetAuraDataByIndex(unit, idx, "HARMFUL")
end

function Fun.XUnitDebuff(unit, idx)
 local aura = C_UnitAuras.GetAuraDataByIndex(unit, idx, "HARMFUL") or {}
 -- name, icon, count, dispelType, duration, 
 -- expirationTime, source, isStealable, nameplateShowPersonal,
 -- spellId, canApplyAura, isBossDebuff, castByPlayer, 
 -- nameplateShowAll, timeMod
 return aura.name, aura.icon, aura.applications, aura.dispellName, aura.duration,
  aura.expirationTime, aura.sourceUnit, aura.isStealable, aura.nameplateShowPersonal,
  aura.spellId, aura.canApplyAura, aura.isBossAura, aura.isFromPlayerOrPlayerPet,
  aura.nameplateShowAll, aura.timeMod
 
end

----- GetSpellCharges

function Fun.GetSpellCharges(...)
  return C_Spell.GetSpellCharges(...)
end

function Fun.XGetSpellCharges(...)
  local info = C_Spell.GetSpellCharges(...) or {}
  
  -- currentCharges, maxCharges, cooldownStart, 
  -- cooldownDuration, chargeModRate
  return info.currentCharges, info.maxCharges, info.cooldownStartTime, 
    info.cooldownDuration, chargeModRate
end

----- IsUsableSpell

function Fun.IsUsableSpell(...)
  return C_Spell.IsSpellUsable(...)
end

----- IsSpellInRange
function Fun.IsSPellInRange(...)
  return C_Spell.IsSpellInRange(...)
end

function Fun.XIsSPellInRange(idx, book, unit)
  local ret;
  if not unit then
    local name = idx
    unit = book
    ret = C_Spell.IsSpellInRange(name, unit)
  else
    local stype =  ((book == nil or book == "spell") and 0) or 1
    ret = C_SpellBook.IsSpellBookItemInRange(idx, stype, unit)
  end
  return (ret == true and 1) or (ret == false or 0) or nil
end

----- SpellHasRange
function Fun.SpellHasRange(...)
  return C_Spell.SpellHasRange(...)
end

function Fun.XSpellHasRange(idx, book)
  local stype = ((book == nil or book == "spell") and 0) or 1
  return C_Spell.SpellHasRange(idx, book)
end

----- GetSpellTexture
function Fun.GetSpellTexture(...)
  return C_Spell.GetSpellTexture(...)
end

function Fun.XGetSpellTexture(...)
  local ret = C_Spell.GetSpellTexture(...)
  return ret
end

----- Native api

function Fun.GetSpellName(id)
  return C_Spell.GetSpellName(id)
end

----- SpellBook

function Fun.GetSpellBookItemName(...)
	return C_SpellBook.GetSpellBookItemName(...)
end
