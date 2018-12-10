local _, Main = ...
if select(2, UnitClass("player")) == 'DEMONHUNTER' then

  --------------------------------------------------------------------------------
  function Main.L(text)
  --------------------------------------------------------------------------------
  -- the ubiquitous locale funtion
  --------------------------------------------------------------------------------
    return (Main.Strings and Main.Strings[text]) or text
  end

  local L = Main.L
  local ShowMsg = Main.ShowMsg
  local ShowError = Main.ShowError
  local DebugMsg = Main.DebugMsg


  local HAVOC = "havoc"
  local VENG = "veng"

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
  local ICON = "icon"
  local COLS = "cols"
  
  local NO_CONDITION = false
  local ON_COOLDOWN = false

	local veng = {}
  
	------------------------------------------------------------------------------
	-- VENGEANCE
	------------------------------------------------------------------------------
  veng.SPID = {
		BurningAlive			= 207739,
		ConsumeMagic			= 183752,
		DemonSpikes				= 203720,
		EmpowerWards			= 218256,
		FelEruption				= 211881,
		Felblade					= 213241,
		FieryBrand 				= 204021,
		Fracture 					= 209795,
		ImmolationAura		= 178740,
		InfernalStrike		= 189110,
		Metamorphosis			= 187827,
		Shear	 						= 203783,
		SigilOfChains			= 202138,
		SigilOfFlame			= 204596,
		SigilOfMisery			= 207684,
		SigilOfSilence		= 202137,
		SoulBarrier				= 227225,
		SoulCarver				= 207407,
		SoulCleave				= 228477,
		SpiritBomb				= 218679,
		zz								= 0
	}
	
	veng.SPN = Main:CreateSpellNames(veng.SPID)
	
	veng.Init = function(this, Ctx)
  -- Initializes the variables used by each condition
    Ctx.TargetHealthPercent = UnitHealth("target")/UnitHealthMax("target")
    Ctx.LowHealth = Ctx.HealthPercent <= .5
		Ctx.MediumHealth = not Ctx.LowHealth and Ctx.HealthPercent <= .85
		Ctx.Pain = UnitPower("player", SPELL_POWER_PAIN) or 0
		Ctx.InfernalStrikeCharges = Ctx:SpellCharges(veng.SPN.InfernalStrike)
		Ctx.HasFlameCrashTalent = Ctx:HasTalent(3, 2)
  end

		veng.OnBurningAlive = function(this, ctx)
			return true
		end
		
		veng.OnConsumeMagic = function(this, ctx)
			return true
		end
		
		veng.OnDemonSpikes = function(this, ctx)
			return ctx.WeAreBeingAttacked and
			(ctx.HealthPercent < 0.6
			or (ctx.HealthPercent < 0.8 and ctx.IsBossFight))
		end
		
		veng.OnEmpowerWards = function(this, ctx)
			return ctx.WeAreBeingAttacked and
			(ctx.HealthPercent < 0.6
			or (ctx.HealthPercent < 0.8 and ctx.IsBossFight))
		end
		
		veng.OnFelblade = function(this, ctx)
			return true
		end
		
		veng.OnFelEruption = function(this, ctx)
			return true
		end
		
		veng.OnFieryBrand = function(this, ctx)
			return ctx.HealthPercent < 0.9
			or ctx.IsBossFight
		end
		
		veng.OnFracture = function(this, ctx)
			return true
		end
		
		veng.OnImmolationAura = function(this, ctx)
			return ctx.Pain < 71
		end
		
		veng.OnInfernalStrike = function(this, ctx)
			return ctx.HasFlameCrashTalent or this.Charges > 1
		end
		
		veng.OnMetamorphosis = function(this, ctx)
			return ctx.HealthPercent < 0.35
		end		
		
		veng.OnShear = function(this, ctx)
			return ctx.Pain < 91
		end
		
		veng.OnSigilOfChains = function(this, ctx)
			return true
		end
		
		veng.OnSigilOfFlame = function(this, ctx)
			return true
		end
		
		veng.OnSigilOfMisery = function(this, ctx)
			return true
		end
		
		veng.OnSigilOfSilence = function(this, ctx)
			return true
		end
		
		veng.OnSoulBarrier = function(this, ctx)
			return ctx.HealthPercent < 0.5
			and ctx.WeAreBeingAttacked
		end
		
		veng.OnSoulCarver = function(this, ctx)
			return true
		end
		
		veng.OnSoulCleave = function(this, ctx)
			return true
		end
		
		veng.OnSoulCleaveHeals = function(this, ctx)
			return ctx.HealthPercent < 0.5
		end
		
		veng.OnSpiritBomb = function(this, ctx)
			return true
		end
		
		veng.OnSpiritBombHeals = function(this, ctx)
			return ctx.HealthPercent < 0.5
		end
		
	local SPId = veng.SPID
  veng.SPEC = {
		{VENG, SPELL, "consume-magic",			        SPId.ConsumeMagic, false},
		{VENG, SPELL, "demon-spikes",			        	SPId.DemonSpikes, veng.OnDemonSpikes, NoTarget=true},
		{VENG, SPELL, "empower-wards",			        SPId.EmpowerWards, veng.OnEmpowerWards, NoTarget=true},
		{VENG, SPELL, "fel-eruption",			        	SPId.FelEruption, veng.OnFelEruption},
		{VENG, SPELL, "felblade",			          		SPId.Felblade, veng.OnFelblade},
		{VENG, SPELL, "fiery-brand",			          SPId.FieryBrand, veng.OnFieryBrand},
		{VENG, SPELL, "fracture",			          		SPId.Fracture, veng.OnFracture},
		{VENG, SPELL, "immolation-aura",			      SPId.ImmolationAura, veng.OnImmolationAura, NoTarget=true},
		{VENG, SPELL, "infernal-strike",			      SPId.InfernalStrike, veng.OnInfernalStrike, NoTarget=true},
		{VENG, SPELL, "metamorphosis",			        SPId.Metamorphosis, veng.OnMetamorphosis, NoTarget=true},
		{VENG, SPELL, "metamorphosis-icon",			    SPId.Metamorphosis, NoTarget=true},
		{VENG, SPELL, "shear",			          			SPId.Shear, veng.OnShear},
		{VENG, SPELL, "sigil-of-chains",			      SPId.SigilOfChains, veng.OnSigilOfChains, NoTarget=true},
		{VENG, SPELL, "sigil-of-flame",			      	SPId.SigilOfFlame, veng.OnSigilOfFlame, NoTarget=true},
		{VENG, SPELL, "sigil-of-misery",			      SPId.SigilOfMisery, veng.OnSigilOfMisery, NoTarget=true},
		{VENG, SPELL, "sigil-of-silence",			    	SPId.SigilOfSilence, veng.OnSigilOfSilence, NoTarget = true},
		{VENG, SPELL, "soul-barrier",			          SPId.SoulBarrier, veng.OnSoulBarrier, NoTarget=true},
		{VENG, SPELL, "soul-carver",			          SPId.SoulCarver, veng.OnSoulCarver},
		{VENG, SPELL, "soul-cleave",			          SPId.SoulCleave, veng.OnSoulCleave},
		{VENG, SPELL, "soul-cleave-heals",			    SPId.SoulCleave, veng.OnSoulCleaveHeals},
		{VENG, SPELL, "spirit-bomb",			          SPId.SpiritBomb, veng.OnSpiritBomb},
		{VENG, SPELL, "spirit-bomb-heals",			    SPId.SpiritBomb, veng.OnSpiritBombHeals},

    --------------------------------------------------------------------------
    -- rotation
    --------------------------------------------------------------------------
		-- healing, mitigation
		{VENG, PRIO, "metamorphosis"}, 			-- pain gen
        {VENG, PRIO, "soul-cleave-heals"}, 	-- pain consumer
        {VENG, PRIO, "spirit-bomb-heals"},
		{VENG, PRIO, "soul-barrier"},
		{VENG, PRIO, "demon-spikes"}, 			-- pain consumer
		{VENG, PRIO, "empower-wards"},

		-- free strikes
    {VENG, PRIO, "soul-carver"},
    {VENG, PRIO, "infernal-strike"},

    {VENG, PRIO, "sigil-of-flame"},

    {VENG, PRIO, "immolation-aura"}, 		-- pain gen
		
		-- pain consumption
    {VENG, PRIO, "fracture"}, 					-- pain consumer
    {VENG, PRIO, "spirit-bomb"},
    {VENG, PRIO, "felblade"},
    {VENG, PRIO, "fel-eruption"},
    {VENG, PRIO, "soul-cleave"}, 				-- pain consumer
    {VENG, PRIO, "shear"}, 							-- pain gen

    {VENG, AOE,  {}},

    --------------------------------------------------------------------------
    -- etc
    --------------------------------------------------------------------------

    {VENG, INIT, veng.Init},
    {VENG, COLS, 6},
    {VENG, ICON, SPELL,  "metamorphosis-icon",  format(L"Healing Cooldown (%s)", veng.SPN.Metamorphosis)},
    {VENG, ICON, SPELL,  "sigil-of-flame", format(L"AOE (%s)", veng.SPN.SigilOfFlame)},
    {VENG, ICON, SPELL,  "sigil-of-chains", format(L"AOE pull (%s)", veng.SPN.SigilOfChains)},
    {VENG, ICON, SPELL,  "sigil-of-silence", format(L"AOE interrupt (%s)", veng.SPN.SigilOfSilence)},
    {VENG, INT,          "consume-magic", veng.SPN.ConsumeMagic}
  }


	------------------------------------------------------------------------------
	-- HAVOC
	------------------------------------------------------------------------------

  local havoc = {}
  --[[
  Annihilation = 201427
  BladeDance = 188499
  BlindFury = 203550
  Blur = 198589
  ChaosBrand = 255260
  ChaosNova = 179057
  ChaosStrike = 162794
  ConsumeMagic = 278326
  CycleOfHatred = 258887
  DarkSlash = 258860
  Darkness = 196718
  DeathSweep = 210152
  DemonBlades = 203555
  DemonsBite = 162243
  Demonic = 213410
  DemonicAppetite = 206478
  DemonicWards = 278386
  Disrupt = 183752
  EyeBeam = 198013
  FelBarrage = 258925
  FelMastery = 192939
  FelRush = 195072
  Felblade = 232893
  FirstBlood = 206416
  Glide = 131347
  ImmolationAura = 258920
  Imprison = 217832
  InsatiableHunger = 258876
  Metamorphosis = 191427
  Momentum = 206476
  Nemesis = 206491
  ShatteredSouls = 178940
  ThrowGlaive = 185123
  Torment = 185245
  TrailOfRuin = 258881
  VengefulRetreat = 198793


  fel-barrage:noinstant = true
  eye-beam:noinstant = true
  disrupt:interrupt = true
  fel-rush:notarget = true
  metamorphosis:notarget = true
   
  vengeful-retreat.escape = we-are-being-attacked and low-health
  blur = we-are-being-attacked and low-health or pain-index > 3
  vengeful-retreat.momentum = momentum-talented and not has-momentum-buff
  fel-rush.momentum = has-momentum-buff and fury > 80
  fel-barrage = target-is-near and (is-boss-fight or enemies > 1)
  dark-slash = fury >= 80
  eye-beam = target-is-near and (is-boss-fight or enemies > 1)
  nemesis = is-boss-fight or (we-are-being-attacked and low-health)
  metamorphosis = is-boss-fight or (we-are-being-attacked and low-health)
  blade-dance.aoe = enemies > 2
  death-sweep.aoe = enemies > 2
  immolation-aura = target-is-near
  blade-dance = true
  death-sweep = true
  felblade = fury < 80
  dark-slash = true
  chaos-strike = true
  annihilation = true
  demons-bite = fury < 80
  fel-rush.2charges = fel-rush-charges > 1
  throw-glaive.filler = true
  fel-rush.filler = true

  ]]

  havoc.SID = {
    Annihilation = 201427,
    BladeDance = 188499,
    BlindFury = 203550,
    Blur = 198589,
    ChaosBrand = 255260,
    ChaosNova = 179057,
    ChaosStrike = 162794,
    ConsumeMagic = 278326,
    CycleOfHatred = 258887,
    DarkSlash = 258860,
    Darkness = 196718,
    DeathSweep = 210152,
    DemonBlades = 203555,
    Demonic = 213410,
    DemonicAppetite = 206478,
    DemonicWards = 278386,
    DemonsBite = 162243,
    Disrupt = 183752,
    EyeBeam = 198013,
    FelBarrage = 258925,
    FelMastery = 192939,
    FelRush = 195072,
    Felblade = 232893,
    FirstBlood = 206416,
    Glide = 131347,
    ImmolationAura = 258920,
    Imprison = 217832,
    InsatiableHunger = 258876,
    Metamorphosis = 191427,
    Momentum = 206476,
    Nemesis = 206491,
    ShatteredSouls = 178940,
    ThrowGlaive = 185123,
    Torment = 185245,
    TrailOfRuin = 258881,
    VengefulRetreat = 198793,
    zz = 0
  }

  havoc.SPN = Main:CreateSpellNames(havoc.SID)

  havoc.onAnnihilation = function(this, ctx)
    return true 
  end

  havoc.onBladeDance = function(this, ctx)
    return true 
  end

  havoc.onBladeDanceAoe = function(this, ctx)
    return ctx.Enemies > 2 
  end

  havoc.onBlur = function(this, ctx)
    return ctx.WeAreBeingAttacked 
      and ctx.PainPerSecond > 0 
  end

  havoc.onChaosStrike = function(this, ctx)
    return true 
  end

  havoc.onDarkSlash = function(this, ctx)
    return ctx.Fury >= 80 
  end

  havoc.onDarkSlash = function(this, ctx)
    return true 
  end

  havoc.onDeathSweep = function(this, ctx)
    return true 
  end

  havoc.onDeathSweepAoe = function(this, ctx)
    return ctx.Enemies > 2 
  end

  havoc.onDemonsBite = function(this, ctx)
    return ctx.Fury < 80 
  end

  havoc.onDisruptInterrupt = function(this, ctx)
    return true 
  end

  havoc.onEyeBeam = function(this, ctx)
    return ctx.TargetIsNear 
      and (ctx.IsBossFight 
      or ctx.Enemies > 1 ) 
  end

  havoc.onFelBarrage = function(this, ctx)
    return ctx.TargetIsNear 
      and (ctx.IsBossFight 
      or ctx.Enemies > 1 ) 
  end

  havoc.onFelRush2charges = function(this, ctx)
    return ctx.FelRushCharges > 1 
  end

  havoc.onFelRushFiller = function(this, ctx)
    return true 
  end

  havoc.onFelRushMomentum = function(this, ctx)
    return ctx.HasMomentumBuff 
      and ctx.Fury > 80 
  end

  havoc.onFelblade = function(this, ctx)
    return ctx.Fury < 80 
  end

  havoc.onImmolationAura = function(this, ctx)
    return ctx.TargetIsNear 
  end

  havoc.onMetamorphosis = function(this, ctx)
    return ctx.IsBossFight 
      or (ctx.WeAreBeingAttacked 
      and ctx.LowHealth ) 
  end

  havoc.onNemesis = function(this, ctx)
    return ctx.IsBossFight 
      or (ctx.WeAreBeingAttacked 
      and ctx.LowHealth ) 
  end

  havoc.onThrowGlaiveFiller = function(this, ctx)
    return true 
  end

  havoc.onVengefulRetreatEscape = function(this, ctx)
    return ctx.WeAreBeingAttacked 
      and ctx.LowHealth 
  end


  havoc.Init = function(this, ctx)
    havoc.doInit(this, ctx)
  --[[
    ctx.Enemies = UNKNOWN
    ctx.FelRushCharges = UNKNOWN
    ctx.Fury = UNKNOWN
    ctx.HasMomentumBuff = UNKNOWN
    ctx.IsBossFight = UNKNOWN
    ctx.LowHealth = UNKNOWN
    ctx.PainPerSecond = UNKNOWN
    ctx.TargetIsNear = UNKNOWN
    ctx.WeAreBeingAttacked = UNKNOWN
  ]]
  end

  havoc.SPEC = {
    {HAVOC, SPELL, "annihilation",             havoc.SID.Annihilation,             havoc.onAnnihilation},
    {HAVOC, SPELL, "blade-dance",              havoc.SID.BladeDance,               havoc.onBladeDance},
    {HAVOC, SPELL, "blade-dance.aoe",          havoc.SID.BladeDance,               havoc.onBladeDanceAoe},
    {HAVOC, SPELL, "blur",                     havoc.SID.Blur,                     havoc.onBlur},
    {HAVOC, SPELL, "chaos-strike",             havoc.SID.ChaosStrike,              havoc.onChaosStrike},
    {HAVOC, SPELL, "dark-slash",               havoc.SID.DarkSlash,                havoc.onDarkSlash},
    {HAVOC, SPELL, "dark-slash",               havoc.SID.DarkSlash,                havoc.onDarkSlash},
    {HAVOC, SPELL, "death-sweep",              havoc.SID.DeathSweep,               havoc.onDeathSweep},
    {HAVOC, SPELL, "death-sweep.aoe",          havoc.SID.DeathSweep,               havoc.onDeathSweepAoe},
    {HAVOC, SPELL, "demons-bite",              havoc.SID.DemonsBite,               havoc.onDemonsBite},
    {HAVOC, SPELL, "disrupt:interrupt",        havoc.SID.Disrupt,                  havoc.onDisruptInterrupt},
    {HAVOC, SPELL, "eye-beam",                 havoc.SID.EyeBeam,                  havoc.onEyeBeam, NoInstant=true},
    {HAVOC, SPELL, "fel-barrage",              havoc.SID.FelBarrage,               havoc.onFelBarrage, NoInstant=true},
    {HAVOC, SPELL, "fel-rush.2charges",        havoc.SID.FelRush,                  havoc.onFelRush2charges, NoTarget=true},
    {HAVOC, SPELL, "fel-rush.filler",          havoc.SID.FelRush,                  havoc.onFelRushFiller, NoTarget=true},
    {HAVOC, SPELL, "fel-rush.momentum",        havoc.SID.FelRush,                  havoc.onFelRushMomentum, NoTarget=true},
    {HAVOC, SPELL, "felblade",                 havoc.SID.Felblade,                 havoc.onFelblade},
    {HAVOC, SPELL, "immolation-aura",          havoc.SID.ImmolationAura,           havoc.onImmolationAura},
    {HAVOC, SPELL, "metamorphosis",            havoc.SID.Metamorphosis,            havoc.onMetamorphosis, NoTarget=true},
    {HAVOC, SPELL, "nemesis",                  havoc.SID.Nemesis,                  havoc.onNemesis},
    {HAVOC, SPELL, "throw-glaive.filler",      havoc.SID.ThrowGlaive,              havoc.onThrowGlaiveFiller},
    {HAVOC, SPELL, "vengeful-retreat.escape",  havoc.SID.VengefulRetreat,          havoc.onVengefulRetreatEscape},

    --prio
    {HAVOC, PRIO, "vengeful-retreat.escape"},
    {HAVOC, PRIO, "blur"},
    {HAVOC, PRIO, "fel-rush.momentum"},
    {HAVOC, PRIO, "fel-barrage"},
    {HAVOC, PRIO, "dark-slash"},
    {HAVOC, PRIO, "eye-beam"},
    {HAVOC, PRIO, "nemesis"},
    {HAVOC, PRIO, "metamorphosis"},
    {HAVOC, PRIO, "blade-dance.aoe"},
    {HAVOC, PRIO, "death-sweep.aoe"},
    {HAVOC, PRIO, "immolation-aura"},
    {HAVOC, PRIO, "blade-dance"},
    {HAVOC, PRIO, "death-sweep"},
    {HAVOC, PRIO, "felblade"},
    {HAVOC, PRIO, "dark-slash"},
    {HAVOC, PRIO, "chaos-strike"},
    {HAVOC, PRIO, "annihilation"},
    {HAVOC, PRIO, "demons-bite"},
    {HAVOC, PRIO, "fel-rush.2charges"},
    {HAVOC, PRIO, "throw-glaive.filler"},
    {HAVOC, PRIO, "fel-rush.filler"},

    {HAVOC, INIT, havoc.Init},
    {HAVOC, INT, "disrupt:interrupt"},
  }

  table.insert(havoc.SPEC, {HAVOC, ICON, SPELL, "metamorphosis"})
  
  havoc.doInit = function(this, ctx)
    ctx.FelRushCharges = ctx:SpellCharges(havoc.SID.FelRush)
    ctx.Fury = UnitPower("player")
    ctx.HasMomentumBuff = ctx:CheckBuff(havoc.SID.Momentum) > 0
    ctx.LowHealth = ctx.HealthPercent < 0.7
    ctx.TargetIsNear = ctx:CheckEnemyIsClose()
  end
  
  Main.specs = {havoc = havoc, veng = veng}
  
  function Main:GetEngine()
    return self:InitSpecs(
      Main.joinTables(
        {{HAVOC, SKIP}, {VENG, SKIP}},
        havoc.SPEC,
        veng.SPEC
      )
    )
  end -- GetEngine

end
