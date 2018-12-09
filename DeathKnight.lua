local addon_name, Main = ...

local function L(text)
  return (Main.Strings and Main.Strings[text]) or text
end

if select(2, UnitClass("player")) == 'DEATHKNIGHT' then


  local RUNE_BLOOD = 1
  local RUNE_UNHOLY = 2
  local RUNE_FROST = 3
  local RUNE_DEATH = 4

  local BLOOD = "blood"
  local UNHOLY = "unholy"
  local FROST = "frost"

  local SPELL = "spell"
  local SLOT1 = "slot1"
  local SLOT2 = "slot2"
  local SLOT3 = "slot3"
  local SLOT4 = "slot4"
  local SLOT5 = "slot5"
  local INT = "interrupt"

  local BUFF   = "buff"
  local DEBUFF = "debuff"
  local AURA = "aura"
  local PRIO = "prio"
  local AOE  = "aoe"
  local SKIP = "skip"
  local INIT = "init"
  local VAR = "var"
  local TBAR = "toolbar"

  local NO_CONDITION = false
  local ON_COOLDOWN = false


  local function GetRunes()
  --scans all active runes
    local HasDepletedRune = false
    local ref = GetTime()
    local Total = 0
    for i = 1, 6 do
      local st, cd, ok = GetRuneCooldown(i)
      if ok then
        Total = Total + 1
      elseif st > ref then
        HasDepletedRune = true
      end
    end
    return Total, HasDepletedRune
  end

--------------------------------------------------------------------------------
-- BLOOD
--------------------------------------------------------------------------------

  local blood = {}
  --[[
    vampiric-blood:notarget = true
    rune-tap:notarget = true
    icebound-fortitude:notarget = true
    dancing-rune-weapon:notarget = true
    death-and-decay:notarget = true
    blooddrinker:noinstant = true
    blood-boil:rangespell = death-strike
    vampiric-blood = critically-low-health
    death-strike.heal = low-health
    rune-tap = critically-low-health and is-being-damaged
    icebound-fortitude = low-health and is-being-damaged
    bone-storm = critically-low-health
    consumption = low-health
    dancing-rune-weapon = is-boss-fight or enemies > 1 or low-health
    marrowrend = bone-shield-expiring
    death-strike = blood-shield-expiring or next-rune-spender-will-overcap-runic-power
    blooddrinker = dancing-rune-weapon-is-not-up
    blood-boil = target-does-not-have-blood-plague or blood-boil-charges > 1
    marrowrend.no-drw = bone-shield-stacks < 7 and dancing-rune-weapon-is-not-up
    marrowrend.drw = bone-shield-stacks < 5 and dancing-rune-weapon-is-up
    death-and-decay.cs = has-buff-crimson-scourge
    rune-strike = rune-strike-charges == 2 and rune-count < 4
    death-and-decay = enemies > 2 and rune-count > 2
    heart-strike = rune-count > 2 or death-strike-not-usable
    blood-boil.drw = dancing-rune-weapon-is-up
    mark-of-blood = target-does-not-have-mark-of-blood
    blood-boil.filler = true
    rune-strike.filler = true
    mind-freeze:interrupt = true
    AntiMagicShell = 48707
    BloodBoil = 50842
    BloodPlague = 55078
    BloodShield = 77535
    Blooddrinker = 206931
    BoneShield = 195181
    BoneStorm = 194844
    BonesOfTheDamned = 279503
    CrimsonScourge = 81141
    Consumption = 205224
    DancingRuneWeapon = 49028
    DarkCommand = 56222
    DeathGrip = 49576
    DeathStrike = 49998
    DeathAndDecay = 43265
    DeathsAdvance = 48265
    HeartStrike = 206930
    IceboundFortitude = 48792
    Marrowrend = 195182
    MarkOfBlood = 206940
    MindFreeze = 47528
    Ossuary = 219786
    RedThirst = 205723
    RuneStrike = 210764
    RuneTap = 194679
    VampiricBlood = 55233

  ]]

  blood.SID = {
    AntiMagicShell = 48707,
    BloodBoil = 50842,
    BloodPlague = 55078,
    BloodShield = 77535,
    Blooddrinker = 206931,
    BoneShield = 195181,
    BoneStorm = 194844,
    BonesOfTheDamned = 279503,
    Consumption = 205224,
    CrimsonScourge = 81141,
    DancingRuneWeapon = 49028,
    DarkCommand = 56222,
    DeathAndDecay = 43265,
    DeathGrip = 49576,
    DeathStrike = 49998,
    DeathsAdvance = 48265,
    HeartStrike = 206930,
    IceboundFortitude = 48792,
    MarkOfBlood = 206940,
    Marrowrend = 195182,
    MindFreeze = 47528,
    Ossuary = 219786,
    RedThirst = 205723,
    RuneStrike = 210764,
    RuneTap = 194679,
    VampiricBlood = 55233,
    zz = 0
  }

  blood.SPN = Main:CreateSpellNames(blood.SID)

  blood.onBloodBoil = function(this, ctx)
    return ctx.TargetDoesNotHaveBloodPlague 
      or ctx.BloodBoilCharges > 1 
  end

  blood.onBloodBoilDrw = function(this, ctx)
    return ctx.DancingRuneWeaponIsUp 
  end

  blood.onBloodBoilFiller = function(this, ctx)
    return true 
  end

  blood.onBlooddrinker = function(this, ctx)
    return ctx.DancingRuneWeaponIsNotUp 
  end

  blood.onBoneStorm = function(this, ctx)
    return ctx.CriticallyLowHealth 
  end

  blood.onConsumption = function(this, ctx)
    return ctx.LowHealth 
  end

  blood.onDancingRuneWeapon = function(this, ctx)
    return ctx.IsBossFight 
      or ctx.Enemies > 1 
      or ctx.LowHealth 
  end

  blood.onDeathAndDecay = function(this, ctx)
    return ctx.Enemies > 2 
      and ctx.RuneCount > 2 
  end

  blood.onDeathAndDecayCs = function(this, ctx)
    return ctx.HasBuffCrimsonScourge 
  end

  blood.onDeathStrike = function(this, ctx)
    return ctx.BloodShieldExpiring 
      or ctx.NextRuneSpenderWillOvercapRunicPower 
  end

  blood.onDeathStrikeHeal = function(this, ctx)
    return ctx.LowHealth 
  end

  blood.onHeartStrike = function(this, ctx)
    return ctx.RuneCount > 2 
      or ctx.DeathStrikeNotUsable 
  end

  blood.onIceboundFortitude = function(this, ctx)
    return ctx.LowHealth 
      and ctx.IsBeingDamaged 
  end

  blood.onMarkOfBlood = function(this, ctx)
    return ctx.TargetDoesNotHaveMarkOfBlood 
  end

  blood.onMarrowrend = function(this, ctx)
    return ctx.BoneShieldExpiring 
  end

  blood.onMarrowrendDrw = function(this, ctx)
    return ctx.BoneShieldStacks < 5 
      and ctx.DancingRuneWeaponIsUp 
  end

  blood.onMarrowrendNoDrw = function(this, ctx)
    return ctx.BoneShieldStacks < 7 
      and ctx.DancingRuneWeaponIsNotUp 
  end

  blood.onMindFreezeInterrupt = function(this, ctx)
    return true 
  end

  blood.onRuneStrike = function(this, ctx)
    return ctx.RuneStrikeCharges == 2 
      and ctx.RuneCount < 4 
  end

  blood.onRuneStrikeFiller = function(this, ctx)
    return true 
  end

  blood.onRuneTap = function(this, ctx)
    return ctx.CriticallyLowHealth 
      and ctx.IsBeingDamaged 
  end

  blood.onVampiricBlood = function(this, ctx)
    return ctx.CriticallyLowHealth 
  end


  blood.Init = function(this, ctx)
    blood.doInit(this, ctx)
  --[[
    ctx.BloodBoilCharges = UNKNOWN
    ctx.BloodShieldExpiring = UNKNOWN
    ctx.BoneShieldExpiring = UNKNOWN
    ctx.BoneShieldStacks = UNKNOWN
    ctx.CriticallyLowHealth = UNKNOWN
    ctx.DancingRuneWeaponIsNotUp = UNKNOWN
    ctx.DancingRuneWeaponIsUp = UNKNOWN
    ctx.DeathStrikeNotUsable = UNKNOWN
    ctx.Enemies = UNKNOWN
    ctx.HasBuffCrimsonScourge = UNKNOWN
    ctx.IsBeingDamaged = UNKNOWN
    ctx.IsBossFight = UNKNOWN
    ctx.LowHealth = UNKNOWN
    ctx.NextRuneSpenderWillOvercapRunicPower = UNKNOWN
    ctx.RuneCount = UNKNOWN
    ctx.RuneStrikeCharges = UNKNOWN
    ctx.TargetDoesNotHaveBloodPlague = UNKNOWN
    ctx.TargetDoesNotHaveMarkOfBlood = UNKNOWN
  ]]
  end

  blood.SPEC = {
    {BLOOD, SPELL, "blood-boil",             blood.SID.BloodBoil,              blood.onBloodBoil, RangeSpell=blood.SID.DeathStrike},
    {BLOOD, SPELL, "blood-boil.drw",         blood.SID.BloodBoil,              blood.onBloodBoilDrw, RangeSpell=blood.SID.DeathStrike},
    {BLOOD, SPELL, "blood-boil.filler",      blood.SID.BloodBoil,              blood.onBloodBoilFiller, RangeSpell=blood.SID.DeathStrike},
    {BLOOD, SPELL, "blooddrinker",           blood.SID.Blooddrinker,           blood.onBlooddrinker, NoInstant=true},
    {BLOOD, SPELL, "bone-storm",             blood.SID.BoneStorm,              blood.onBoneStorm},
    {BLOOD, SPELL, "consumption",            blood.SID.Consumption,            blood.onConsumption},
    {BLOOD, SPELL, "dancing-rune-weapon",    blood.SID.DancingRuneWeapon,      blood.onDancingRuneWeapon, NoTarget=true},
    {BLOOD, SPELL, "death-and-decay",        blood.SID.DeathAndDecay,          blood.onDeathAndDecay, NoTarget=true},
    {BLOOD, SPELL, "death-and-decay.cs",     blood.SID.DeathAndDecay,          blood.onDeathAndDecayCs, NoTarget=true},
    {BLOOD, SPELL, "death-strike",           blood.SID.DeathStrike,            blood.onDeathStrike},
    {BLOOD, SPELL, "death-strike.heal",      blood.SID.DeathStrike,            blood.onDeathStrikeHeal},
    {BLOOD, SPELL, "heart-strike",           blood.SID.HeartStrike,            blood.onHeartStrike},
    {BLOOD, SPELL, "icebound-fortitude",     blood.SID.IceboundFortitude,      blood.onIceboundFortitude, NoTarget=true},
    {BLOOD, SPELL, "mark-of-blood",          blood.SID.MarkOfBlood,            blood.onMarkOfBlood},
    {BLOOD, SPELL, "marrowrend",             blood.SID.Marrowrend,             blood.onMarrowrend},
    {BLOOD, SPELL, "marrowrend.drw",         blood.SID.Marrowrend,             blood.onMarrowrendDrw},
    {BLOOD, SPELL, "marrowrend.no-drw",      blood.SID.Marrowrend,             blood.onMarrowrendNoDrw},
    {BLOOD, SPELL, "mind-freeze:interrupt",  blood.SID.MindFreeze,             blood.onMindFreezeInterrupt},
    {BLOOD, SPELL, "rune-strike",            blood.SID.RuneStrike,             blood.onRuneStrike},
    {BLOOD, SPELL, "rune-strike.filler",     blood.SID.RuneStrike,             blood.onRuneStrikeFiller},
    {BLOOD, SPELL, "rune-tap",               blood.SID.RuneTap,                blood.onRuneTap, NoTarget=true},
    {BLOOD, SPELL, "vampiric-blood",         blood.SID.VampiricBlood,          blood.onVampiricBlood, NoTarget=true},

    --prio
    {BLOOD, PRIO, "vampiric-blood"},
    {BLOOD, PRIO, "death-strike.heal"},
    {BLOOD, PRIO, "rune-tap"},
    {BLOOD, PRIO, "icebound-fortitude"},
    {BLOOD, PRIO, "bone-storm"},
    {BLOOD, PRIO, "consumption"},
    {BLOOD, PRIO, "dancing-rune-weapon"},
    {BLOOD, PRIO, "marrowrend"},
    {BLOOD, PRIO, "death-strike"},
    {BLOOD, PRIO, "blooddrinker"},
    {BLOOD, PRIO, "blood-boil"},
    {BLOOD, PRIO, "marrowrend.no-drw"},
    {BLOOD, PRIO, "marrowrend.drw"},
    {BLOOD, PRIO, "death-and-decay.cs"},
    {BLOOD, PRIO, "rune-strike"},
    {BLOOD, PRIO, "death-and-decay"},
    {BLOOD, PRIO, "heart-strike"},
    {BLOOD, PRIO, "blood-boil.drw"},
    {BLOOD, PRIO, "mark-of-blood"},
    {BLOOD, PRIO, "blood-boil.filler"},
    {BLOOD, PRIO, "rune-strike.filler"},

    {BLOOD, INIT, blood.Init},
    {BLOOD, INT, "mind-freeze:interrupt"},
  }

  -- further initialization
  table.insert(blood.SPEC, {BLOOD, AOE,  {}})
  table.insert(blood.SPEC, {BLOOD, VAR,   "AoeMin", 0})
  table.insert(blood.SPEC, {BLOOD, SLOT1, BUFF, {blood.SPN.BoneShield}, blood.SPN.BoneShield})
  
  blood.doInit = function(this, ctx)
    local SPN = blood.SPN
    local SID = blood.SID
    local gcdx2 = ctx.GCD * 2
    
    ctx.BloodBoilCharges = ctx:SpellCharges(SPN.BloodBoil)
    
    local c, e = ctx:CheckBuff(SID.BloodShield)
    ctx.BloodShieldExpiring = c == 0 or e < gcdx2
    
    c, e = ctx:CheckBuff(SID.BoneShield)
    ctx.BoneShieldExpiring = c == 0 or e < gcdx2 
    
    ctx.BoneShieldStacks = c
    
    ctx.CriticallyLowHealth = ctx.HealthPercent < 0.4

    c, e = ctx:CheckBuff(SID.DancingRuneWeapon)
    ctx.DancingRuneWeaponIsNotUp = c == 0
    ctx.DancingRuneWeaponIsUp = c > 0
    
    ctx.DeathStrikeNotUsable = not IsUsableSpell(SPN.DeathStrike)
    
    ctx.Enemies = math.max(ctx.Mobs, ctx.Attackers)
    
    c, e = ctx:CheckBuff(SID.CrimsonScourge)
    ctx.HasBuffCrimsonScourge = c > 0
    
    ctx.IsBeingDamaged = ctx.WeAreBeingAttacked
    ctx.LowHealth = ctx.HealthPercent < 0.7
    
    ctx.NextRuneSpenderWillOvercapRunicPower = UNKNOWN
    
    ctx.OnCooldown = true
    ctx.RuneCount, ctx.HasDepletedRune = GetRunes(ctx)
    
    ctx.RuneStrikeCharges = ctx:SpellCharges(SPN.RuneStrike)
    
    c, e = ctx:CheckDebuff(SID.BloodPlague)
    ctx.TargetDoesNotHaveBloodPlague = c == 0
    
    c, e = ctx:CheckDebuff(SID.MarkOfBlood)
    ctx.TargetDoesNotHaveMarkOfBlood = c == 0
    
    ctx.TargetIsNear = ctx:CheckEnemyDistance()
  end
 
--------------------------------------------------------------------------------
-- FROST
--------------------------------------------------------------------------------

  local frost = {}
  --[[
    mind-freeze:interrupt = true
    icebound-fortitude:notarget = true
    death-pact:notarget = true
    empower-rune-weapon:notarget = true
    icebound-fortitude = is-being-attacked-at-very-low-health
    death-strike = is-being-attacked-at-very-low-health
    death-pact = critically-low-health
    empower-rune-weapon = pillar-of-frost-soon-available or low-resources
    pillar-of-frost = on-cooldown
    breath-of-sindragosa = is-boss-fight or is-being-attacked-at-low-health
    chains-of-ice = cold-heart-charges > 19
    frostwyrms-fury = is-boss-fight or is-being-attacked-at-low-health
    glacial-advance.icy-talons = icy-talons-expiring
    frost-strike.icy-talons = icy-talons-expiring
    remorseless-winter = on-cooldown
    glacial-advance.dump-rp = gathering-storm-talented and remorseless-winter-soon-available
    frost-strike.dump-rp = gathering-storm-talented and remorseless-winter-soon-available
    howling-blast = rime-is-up
    obliterate.frozen-pulse = rune-count > 2 and frozen-pulse-talented
    glacial-advance = dump-runic-power
    frost-strike = dump-runic-power
    obliterate = rune-count > 3 or (killing-machine-is-up and not frostscythe-talented) or breath-of-sindragosa-soon-available
    frostscythe = killing-machine-is-up
    death-strike.free = medium-health and dark-succor-is-up
    obliterate.filler = true
    glacial-advance.filler = true    
    frost-strike.filler = true
    AntiMagicShell = 48707
    ArcaneTorrent = 28730
    Asphyxiate = 108194
    BlindingSleet = 207167
    BreathOfSindragosa = 152279
    ChainsOfIce = 45524
    ChainsOfSargeras = 257961
    ColdHeart = 281209
    Contagion = 267242
    ControlUndead = 111673
    DarkCommand = 56222
    DarkSuccor = 101568
    DeathFog = 248167
    DeathGrip = 49576
    DeathPact = 48743
    DeathStrike = 49998
    DeathsAdvance = 48265
    EmpowerRuneWeapon = 47568
    FrostFever = 55095
    FrostStrike = 49143
    Frostscythe = 207230
    FrostwyrmsFury = 279302
    FrozenPulse = 194909
    GatheringStorm = 194912
    GlacialAdvance = 194913
    HornOfWinter = 57330
    HowlingBlast = 49184
    IceboundFortitude = 48792
    IcyTalons = 194879
    KillingMachine = 51128
    MindFreeze = 47528
    MurderousEfficiency = 207061
    Obliterate = 49020
    Obliteration = 207256
    PillarOfFrost = 51271
    RemorselessWinter = 196770
    Rime = 59052
    RuneOfRazorice = 53343
    RunicAttenuation = 207104
    RunicEmpowerment = 81229
    UnholyStrength = 53365
    WraithWalk = 212552
  ]]

  frost.SID = {
    AntiMagicShell = 48707,
    ArcaneTorrent = 28730,
    Asphyxiate = 108194,
    BlindingSleet = 207167,
    BreathOfSindragosa = 152279,
    ChainsOfIce = 45524,
    ChainsOfSargeras = 257961,
    ColdHeart = 281209,
    Contagion = 267242,
    ControlUndead = 111673,
    DarkCommand = 56222,
    DarkSuccor = 101568,
    DeathFog = 248167,
    DeathGrip = 49576,
    DeathPact = 48743,
    DeathStrike = 49998,
    DeathsAdvance = 48265,
    EmpowerRuneWeapon = 47568,
    FrostFever = 55095,
    FrostStrike = 49143,
    Frostscythe = 207230,
    FrostwyrmsFury = 279302,
    FrozenPulse = 194909,
    GatheringStorm = 194912,
    GlacialAdvance = 194913,
    HornOfWinter = 57330,
    HowlingBlast = 49184,
    IceboundFortitude = 48792,
    IcyTalons = 194879,
    KillingMachine = 51128,
    MindFreeze = 47528,
    MurderousEfficiency = 207061,
    Obliterate = 49020,
    Obliteration = 207256,
    PillarOfFrost = 51271,
    RemorselessWinter = 196770,
    Rime = 59052,
    RuneOfRazorice = 53343,
    RunicAttenuation = 207104,
    RunicEmpowerment = 81229,
    UnholyStrength = 53365,
    WraithWalk = 212552,
    zz = 0
  }

  frost.SPN = Main:CreateSpellNames(frost.SID)

  frost.onBreathOfSindragosa = function(this, ctx)
    return ctx.IsBossFight 
      or ctx.IsBeingAttackedAtLowHealth 
  end

  frost.onChainsOfIce = function(this, ctx)
    return ctx.ColdHeartCharges > 19 
  end

  frost.onDeathPact = function(this, ctx)
    return ctx.CriticallyLowHealth 
  end

  frost.onDeathStrike = function(this, ctx)
    return ctx.IsBeingAttackedAtVeryLowHealth 
  end

  frost.onDeathStrikeFree = function(this, ctx)
    return ctx.MediumHealth 
      and ctx.DarkSuccorIsUp 
  end

  frost.onEmpowerRuneWeapon = function(this, ctx)
    return ctx.PillarOfFrostSoonAvailable 
      or ctx.LowResources 
  end

  frost.onFrostStrike = function(this, ctx)
    return ctx.DumpRunicPower 
  end

  frost.onFrostStrikeDumpRp = function(this, ctx)
    return ctx.GatheringStormTalented 
      and ctx.RemorselessWinterSoonAvailable 
  end

  frost.onFrostStrikeFiller = function(this, ctx)
    return true 
  end

  frost.onFrostStrikeIcyTalons = function(this, ctx)
    return ctx.IcyTalonsExpiring 
  end

  frost.onFrostscythe = function(this, ctx)
    return ctx.KillingMachineIsUp 
  end

  frost.onFrostwyrmsFury = function(this, ctx)
    return ctx.IsBossFight 
      or ctx.IsBeingAttackedAtLowHealth 
  end

  frost.onGlacialAdvance = function(this, ctx)
    return ctx.DumpRunicPower 
  end

  frost.onGlacialAdvanceDumpRp = function(this, ctx)
    return ctx.GatheringStormTalented 
      and ctx.RemorselessWinterSoonAvailable 
  end

  frost.onGlacialAdvanceFiller = function(this, ctx)
    return true 
  end

  frost.onGlacialAdvanceIcyTalons = function(this, ctx)
    return ctx.IcyTalonsExpiring 
  end

  frost.onHowlingBlast = function(this, ctx)
    return ctx.RimeIsUp 
  end

  frost.onIceboundFortitude = function(this, ctx)
    return ctx.IsBeingAttackedAtVeryLowHealth 
  end

  frost.onMindFreezeInterrupt = function(this, ctx)
    return true 
  end

  frost.onObliterate = function(this, ctx)
    return ctx.RuneCount > 3 
      or (ctx.KillingMachineIsUp 
      and not ctx.FrostscytheTalented ) 
      or ctx.BreathOfSindragosaSoonAvailable 
  end

  frost.onObliterateFiller = function(this, ctx)
    return true 
  end

  frost.onObliterateFrozenPulse = function(this, ctx)
    return ctx.RuneCount > 2 
      and ctx.FrozenPulseTalented 
  end

  frost.onPillarOfFrost = function(this, ctx)
    return ctx.OnCooldown 
  end

  frost.onRemorselessWinter = function(this, ctx)
    return ctx.OnCooldown 
  end


  frost.Init = function(this, ctx)
    frost.doInit(this, ctx)
  --[[
    ctx.BreathOfSindragosaSoonAvailable = UNKNOWN
    ctx.ColdHeartCharges = UNKNOWN
    ctx.CriticallyLowHealth = UNKNOWN
    ctx.DarkSuccorIsUp = UNKNOWN
    ctx.DumpRunicPower = UNKNOWN
    ctx.FrostscytheTalented = UNKNOWN
    ctx.FrozenPulseTalented = UNKNOWN
    ctx.GatheringStormTalented = UNKNOWN
    ctx.IcyTalonsExpiring = UNKNOWN
    ctx.IsBeingAttackedAtLowHealth = UNKNOWN
    ctx.IsBeingAttackedAtVeryLowHealth = UNKNOWN
    ctx.IsBossFight = UNKNOWN
    ctx.KillingMachineIsUp = UNKNOWN
    ctx.LowResources = UNKNOWN
    ctx.MediumHealth = UNKNOWN
    ctx.OnCooldown = UNKNOWN
    ctx.PillarOfFrostSoonAvailable = UNKNOWN
    ctx.RemorselessWinterSoonAvailable = UNKNOWN
    ctx.RimeIsUp = UNKNOWN
    ctx.RuneCount = UNKNOWN
  ]]
  end

  frost.SPEC = {
    {FROST, SPELL, "breath-of-sindragosa",        frost.SID.BreathOfSindragosa,          frost.onBreathOfSindragosa},
    {FROST, SPELL, "chains-of-ice",               frost.SID.ChainsOfIce,                 frost.onChainsOfIce},
    {FROST, SPELL, "death-pact",                  frost.SID.DeathPact,                   frost.onDeathPact, NoTarget=true},
    {FROST, SPELL, "death-strike",                frost.SID.DeathStrike,                 frost.onDeathStrike},
    {FROST, SPELL, "death-strike.free",           frost.SID.DeathStrike,                 frost.onDeathStrikeFree},
    {FROST, SPELL, "empower-rune-weapon",         frost.SID.EmpowerRuneWeapon,           frost.onEmpowerRuneWeapon, NoTarget=true},
    {FROST, SPELL, "frost-strike",                frost.SID.FrostStrike,                 frost.onFrostStrike},
    {FROST, SPELL, "frost-strike.dump-rp",        frost.SID.FrostStrike,                 frost.onFrostStrikeDumpRp},
    {FROST, SPELL, "frost-strike.filler",         frost.SID.FrostStrike,                 frost.onFrostStrikeFiller},
    {FROST, SPELL, "frost-strike.icy-talons",     frost.SID.FrostStrike,                 frost.onFrostStrikeIcyTalons},
    {FROST, SPELL, "frostscythe",                 frost.SID.Frostscythe,                 frost.onFrostscythe},
    {FROST, SPELL, "frostwyrms-fury",             frost.SID.FrostwyrmsFury,              frost.onFrostwyrmsFury},
    {FROST, SPELL, "glacial-advance",             frost.SID.GlacialAdvance,              frost.onGlacialAdvance},
    {FROST, SPELL, "glacial-advance.dump-rp",     frost.SID.GlacialAdvance,              frost.onGlacialAdvanceDumpRp},
    {FROST, SPELL, "glacial-advance.filler",      frost.SID.GlacialAdvance,              frost.onGlacialAdvanceFiller},
    {FROST, SPELL, "glacial-advance.icy-talons",  frost.SID.GlacialAdvance,              frost.onGlacialAdvanceIcyTalons},
    {FROST, SPELL, "howling-blast",               frost.SID.HowlingBlast,                frost.onHowlingBlast},
    {FROST, SPELL, "icebound-fortitude",          frost.SID.IceboundFortitude,           frost.onIceboundFortitude, NoTarget=true},
    {FROST, SPELL, "mind-freeze:interrupt",       frost.SID.MindFreeze,                  frost.onMindFreezeInterrupt},
    {FROST, SPELL, "obliterate",                  frost.SID.Obliterate,                  frost.onObliterate},
    {FROST, SPELL, "obliterate.filler",           frost.SID.Obliterate,                  frost.onObliterateFiller},
    {FROST, SPELL, "obliterate.frozen-pulse",     frost.SID.Obliterate,                  frost.onObliterateFrozenPulse},
    {FROST, SPELL, "pillar-of-frost",             frost.SID.PillarOfFrost,               frost.onPillarOfFrost},
    {FROST, SPELL, "remorseless-winter",          frost.SID.RemorselessWinter,           frost.onRemorselessWinter},

    --prio
    {FROST, PRIO, "icebound-fortitude"},
    {FROST, PRIO, "death-strike"},
    {FROST, PRIO, "death-pact"},
    {FROST, PRIO, "empower-rune-weapon"},
    {FROST, PRIO, "pillar-of-frost"},
    {FROST, PRIO, "breath-of-sindragosa"},
    {FROST, PRIO, "chains-of-ice"},
    {FROST, PRIO, "frostwyrms-fury"},
    {FROST, PRIO, "glacial-advance.icy-talons"},
    {FROST, PRIO, "frost-strike.icy-talons"},
    {FROST, PRIO, "remorseless-winter"},
    {FROST, PRIO, "glacial-advance.dump-rp"},
    {FROST, PRIO, "frost-strike.dump-rp"},
    {FROST, PRIO, "howling-blast"},
    {FROST, PRIO, "obliterate.frozen-pulse"},
    {FROST, PRIO, "glacial-advance"},
    {FROST, PRIO, "frost-strike"},
    {FROST, PRIO, "obliterate"},
    {FROST, PRIO, "frostscythe"},
    {FROST, PRIO, "death-strike.free"},
    {FROST, PRIO, "obliterate.filler"},
    {FROST, PRIO, "glacial-advance.filler"},
    {FROST, PRIO, "frost-strike.filler"},

    {FROST, INIT, frost.Init},
    {FROST, INT, "mind-freeze:interrupt"},
  }




  frost.doInit = function(this, ctx)
    local SID = frost.SID
    local SPN = frost.SPN
    local gcdx2 = ctx.GCD * 2
    
    local c = ctx:SpellCooldown(SID.BreathOfSindragosa)
    ctx.BreathOfSindragosaSoonAvailable = c < gcdx2
     
    local c, e = ctx:CheckBuff(SID.ColdHeart)
    ctx.ColdHeartCharges = c

    ctx.MediumHealth = ctx.HealthPercent < 0.8
    ctx.CriticallyLowHealth = ctx.HealthPercent < 0.4
  
    ctx.RunicPower = UnitPower("player", Enum.PowerType.RunicPower) or 0
    ctx.DumpRunicPower = ctx.RunicPower > 73
    
    ctx.FrostscytheTalented = ctx:HasTalent(4, 3)
    ctx.FrozenPulseTalented = ctx:HasTalent(4, 2)
    ctx.GatheringStormTalented = ctx:HasTalent(6, 1)
    
    c, e = ctx:CheckBuff(SID.IcyTalons)
    ctx.IcyTalonsExpiring = c > 0 and e < gcdx2
    
    c, e = ctx:CheckBuff(SID.DarkSuccor)
    ctx.DarkSuccorIsUp = c > 0
    
    ctx.IsBeingAttackedAtLowHealth = ctx.WeAreBeingAttacked and ctx.HealthPercent < 0.6
    ctx.IsBeingAttackedAtVeryLowHealth = ctx.WeAreBeingAttacked and ctx.HealthPercent < 0.4
    
    c, e = ctx:CheckBuff(SID.KillingMachine)
    ctx.KillingMachineIsUp = c > 0
    
    ctx.RuneCount = GetRunes()
    ctx.LowResources = ctx.RuneCount < 3 and ctx.RunicPower < 30

    ctx.OnCooldown = true
    
    c = ctx:SpellCooldown(SID.PillarOfFrost)
    ctx.PillarOfFrostSoonAvailable =  c < 10
    
    c = ctx:SpellCooldown(SID.RemorselessWinter)
    ctx.RemorselessWinterSoonAvailable = c < gcdx2
    
    c, e = ctx:CheckBuff(SID.Rime)
    ctx.RimeIsUp = c > 0
  end
 
--------------------------------------------------------------------------------
  function Main:GetEngine()
--------------------------------------------------------------------------------
    return self:InitSpecs(
      Main.joinTables(
        {{BLOOD, SKIP}, {FROST, SKIP}, {UNHOLY, SKIP}},
        blood.SPEC,
        frost.SPEC
      )
    )
   
  end
end
