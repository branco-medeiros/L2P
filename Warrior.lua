local addon_name, Main = ...

local function L(text)
  return (Main.Strings and Main.Strings[text]) or text
end

if select(2, UnitClass("player")) == 'WARRIOR' then

  local ARMS = "arms"
  local FURY = "fury"
  local PROT = "prot"

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

	local DIST_INSPECT = 1 -- 28 yards
	local DIST_TRADE = 2 -- 11.11 yards
	local DIST_DUEL = 3 -- 9.9 yards
	local DIST_FOLLOW = 4 -- 28 yards

	
  local fury = {}
  local arms = {}
  local prot = {}
	
	arms.SPId = {
		Avatar 							= 107574, 
		BattleShout 				= 6673, 
		Bladestorm					= 222341,
		BoundingStride 			= 202163, 
		Charge							= 100,
		Cleave 							= 845, 
		ColossusSmash 			= 167105, 
		ColossusSmashDebuff = 208086, 
		DeadlyCalm					= 262228,
		DeepWounds 					= 262304, 
		DefensiveStance 		= 197690, 
		DieByTheSword 			= 118038, 
		DoubleTime 					= 103827, 
		Dreadnaught 				= 262150, 
		Execute 						= 163201, 
		FervorOfBattle 			= 202316, 
		HeroicLeap 					= 6544,
		ImpendingVictory		= 202168,
		InForTheKill 				= 248621,
		InForTheKillBuff		= 248622,
		IntimidatingShout		= 5246,
		Massacre 						= 281001, 
		MortalStrike 				= 12294, 
		Overpower 					= 7384,
		Pummel 							= 6552,
		RallyingCry 				= 97462,
		RallyingCryBuff			= 97463,
		Ravager 						= 152277, 
		Rend 								= 772, 
		Skullsplitter 			= 260643, 
		Slam 								= 1464,
		StormBolt						= 107570,
		SuddenDeath 				= 29725,
		SuddenDeathBuff 		= 52437,
		SweepingStrikes 		= 260708, 
		VictoryRush					= 34428,
		Warbreaker 					= 262161, 
		Whirlwind 					= 1680, 		
		zz = 0
	}
	
	arms.SPN = Main:CreateSpellNames(arms.SPId)
  
  arms.Init = function(this, Ctx)
		local SPN = arms.SPN
		local SPId = arms.SPId
		
    local MaxRage = UnitPowerMax("player", SPELL_POWER_RAGE)
    Ctx.Rage = UnitPower("player", SPELL_POWER_RAGE)
    Ctx.RagePercent = Ctx.Rage / MaxRage

		Ctx.LowHealth = Ctx.HealthPercent < 0.45
		Ctx.NeedsHealth = Ctx.HealthPercent <= 0.8

    -- has colossus smash debuff, yes or no?
    local s, d = Ctx:CheckDebuff(SPN.ColossusSmashDebuff)
    Ctx.ColossusSmashOn = s > 0
		
		Ctx.ColossusSmashCooldown = Ctx:SpellCooldown(SPN.ColossusSmash)
		Ctx.WarbreakerCooldown = Ctx:SpellCooldown(SPN.Warbreaker)
		if(Ctx.WarbreakerCooldown < Ctx.ColossusSmashCooldown) then 
			Ctx.ColossusSmashCooldown = Ctx.WarbreakerCooldown
		end

    -- time ramaining on the rend debuf
    s, d = Ctx:CheckDebuff(SPN.Rend)
    Ctx.RendOn = s > 0
		Ctx.RendRemaining = d

		s, d = Ctx:CheckBuff(SPId.SuddenDeathBuff)
		Ctx.SuddenDeathOn = s > 0
		
		Ctx.FervorOfBattleTalented = Ctx:HasTalent(3, 2)

		Ctx.IAmTheTarget = UnitIsUnit("boss1target", "player")
		
		Ctx.HasCleave = IsPlayerSpell(SPId.Cleave)
  end
  
	arms.onAvatar =  function(this, Ctx)
		return Ctx.ColossusSmashCooldown < 10
	end
	
	arms.onBladestorm =  function(this, Ctx)
		return Ctx.ColossusSmashOn
	end

	arms.onCharge = function(this, Ctx)
		return Ctx.Rage < 80
	end
	
	arms.onCleave =  function(this, Ctx)
		return Ctx.Mobs > 2
	end
	
	arms.onColossusSmash = function(this, Ctx)
		return true
	end
	
	arms.onDeadlyCalm =  function(this, Ctx)
		return Ctx.ColossusSmashOn 
			or Ctx.ExecuteOn
	end
	
	arms.onDefensiveStance =  function(this, Ctx)
		return Ctx.LowHealth or
			(Ctx.IsBossFight and Ctx.IAmTheTarget)
	end
	
	arms.onDieByTheSword =  function(this, Ctx)
		return Ctx.WeAreBeingAttacked and Ctx.LowHealth
	end
	
	arms.onExecute =  function(this, Ctx)
		return Ctx.Rage > 40 or Ctx.ColossusSmashOn
	end
	
	arms.onExecuteSuddenDeath =  function(this, Ctx)
		return Ctx.SuddenDeathOn
	end

	arms.onImpendingVictory =  function(this, Ctx)
		return Ctx.NeedsHealth
	end
	
	arms.onIntimidatingShout =  function(this, Ctx)
		return Ctx.LowHealth and not Ctx.IsBossFight and Ctx.Attackers > 1
	end
	
	arms.onMortalStrike =  function(this, Ctx)
		return not (Ctx.HasCleave and Ctx.Mobs > 2)
	end
	
	arms.onOverpower =  function(this, Ctx)
		return true
	end
	
	arms.onRavager = function(this, Ctx)
		return true
	end
	
	arms.onRend = function(this, Ctx)
		return (not Ctx.RendOn or Ctx.RendRemaining < 4)
			and not Ctx.ColossusSmashOn
	end
	
	arms.onSlam =  function(this, Ctx)
		return true
	end
	
	arms.onSkullsplitter = function(this, Ctx)
		return Ctx.Rage < 80
	end
	
	arms.onSweepingStrikes =  function(this, Ctx)
		return Ctx.Attackers > 1
	end
	
	arms.onVictoryRush = function(this, Ctx)
		return Ctx.NeedsHealth
	end
	
	arms.onWarbreaker = function(this, Ctx)
		return true
	end
	
	arms.onWhirlwind =  function(this, Ctx)
		return Ctx.FervorOfBattleTalented or Ctx.Mobs > 1
	end
	
	
	
	
  ------------------------------------------------------------------------------
	-- PROTECTION --
  ------------------------------------------------------------------------------
  prot.SPId = {
		Avatar							= 107574,
    BattleCry           = 1719,
    BerserkerRage       = 18499,
    Bladestorm          = 46924,
    Bloodbath           = 12292,
		Cleave							= 845,
		CleaveBuff					= 188923,
		ColossusSmash				= 167105,
		ColossusSmashDebuff = 208086,
    DeepWounds          = 115767,
    DefensiveStance     = 71,
    DemoralizingShout   = 1160,
    Devastate           = 20243,
		DieByTheSword				= 118038,
    DragonRoar          = 118000,
    Execute             = 5308,
    FocusedRage         = 207982,
    HeroicLeap          = 6544,
		HeroicThrow         = 174529,
    IgnorePain          = 190456,
    ImpendingVictory    = 202168,
    Intercept           = 198304,
    IntimidatingShout   = 5246,
    LastStand           = 12975,
    MortalStrike        = 12294,
		MortalWounds				= 115804,
		NeltharionsFury			= 203524,
    Overpower           = 7384,
    Pummel              = 6552,
    Ravager             = 152277,
		Rend								= 772,
    Recklessness        = 1719,
    Revenge             = 6572,
    ShieldBlock         = 2565,
    ShieldBlockBuff     = 132404,
    ShieldSlam          = 23922,
    ShieldWall          = 871,
		Siegebreaker				= 176289,
    ShockWave           = 46968,
		ArmsShockwave       = 136847,
    Slam                = 1464,
    StormBolt           = 107570,
		SuddenDeath					= 52437,
		SwordAndBoard				= 46953,
    ThunderClap         = 6343,
    Ultimatum           = 122509,
		UnyieldingStrikes   = 169686,
    Victorious          = 32216,
    VictoryRush         = 34428,
		Warbreaker					= 209577,
    Whilrwind           = 1680,
    zz                  = 0
  }

	prot.SPN = Main:CreateSpellNames(prot.SPId)
	
  prot.Init = function(this, Ctx)
		local SPN = prot.SPN
		local SPId = prot.SPId
		
    local MaxRage = UnitPowerMax("player", SPELL_POWER_RAGE)
    Ctx.Rage = UnitPower("player", SPELL_POWER_RAGE)
    Ctx.RagePercent = Ctx.Rage / MaxRage
		
		Ctx.LowHealth = Ctx.HealthPercent < 0.45

    local s, d = GetSpellCooldown(SPN.ShieldSlam)
    Ctx.ShieldSlam = (s == 0 and 0) or (s + d - Ctx.Now)

    s, d = Ctx:CheckBuff(SPN.FocusedRage)
    Ctx.HasFocusedRage = s > 0

    s, d = Ctx:CheckBuff(SPN.ShieldBlockBuff)
    Ctx.HasShieldBlock = s > 0

    Ctx.ShieldBlockCharges = GetSpellCharges(SPN.ShieldBlock)

    s, d = Ctx:CheckBuff(SPN.IgnorePain)
    Ctx.HasIgnorePain = s > 0

    s, d = Ctx:CheckDebuff(SPN.ThunderClap)
    Ctx.HasThunderClap = s > 0
		
  end
  
  prot.BattleCry = function(this, Ctx)
    return Ctx.IsBossFight or (Ctx.Mobs or 0) > 2
  end

  prot.DemoralizingShout = function(this, Ctx)
    return (Ctx.IsBossFight or (Ctx.Mobs or 0) > 2 or (Ctx.HealthPercent or 1) < .85)
    and Ctx.WeAreBeingAttacked
  end


  prot.FocusedRage = function(this, Ctx)
    return not Ctx.HasFocusedRage
		and Ctx.HasShieldBlock
		-- and Ctx.ShieldSlam < 1.5
  end


  prot.IgnorePain = function(this, Ctx)
    return not Ctx.HasIgnorePain
    and Ctx.WeAreBeingAttacked
		and Ctx.RagePercent < 0.5
    --and Ctx.PainPerSecond >= 0.005
  end


  prot.ImpendingVictory = function(this, Ctx)
    return Ctx.HealthPercent <= .85
  end


  prot.ImpendingVictoryHeal = function(this, Ctx)
    return Ctx.HealthPercent <= .4
  end


  prot.LastStand = function(this, Ctx)
     return Ctx.HealthPercent < .4
  end


	prot.NeltharionsFury = function(this, Ctx)
		return Ctx.WeAreBeingAttacked
		and Ctx.HealthPercent < .5
		and Ctx.PainPerSecond >= 0.01
	end


  prot.RevengeAoe = function(this, Ctx)
    return Ctx.Mobs > 2
  end


  prot.ShieldBlock = function(this, Ctx)
     return not Ctx.HasShieldBlock
     and Ctx.WeAreBeingAttacked
		 --and Ctx.PainPerSecond >= 0.005
     --and Ctx.ShieldBlockCharges > 1
  end


	prot.ShockWave = function(this, Ctx)
		return Ctx.Mobs >= 2
		or not Ctx.IsBossFight
	end


	prot.ThunderClap = function(this, Ctx)
		return not Ctx.HasThunderClap
	end

  function Main:GetEngine()
    return self:InitSpecs(
      {ARMS, SKIP},
      {FURY, SKIP},
      {PROT, SKIP},

      --------------------------------------------------------------------------
      -- ARMS
      --------------------------------------------------------------------------
			
      {ARMS, SPELL, "avatar",								arms.SPId.Avatar, 						arms.onAvatar, NoTarget=true},
      {ARMS, SPELL, "bladestorm",						arms.SPId.Bladestorm, 				arms.onBladestorm, NoTarget=true},
      {ARMS, SPELL, "cleave",								arms.SPId.Cleave,							arms.onCleave},
      {ARMS, SPELL, "charge",								arms.SPId.Charge,							arms.onCharge},
      {ARMS, SPELL, "colossus-smash",				arms.SPId.ColossusSmash,			arms.onColossusSmash, NoTarget=true},
      {ARMS, SPELL, "deadly-calm",					arms.SPId.DeadlyCalm, 				arms.onDeadlyCalm, NoTarget=true},
      {ARMS, SPELL, "defensive-stance",			arms.SPId.DefensiveStance,		arms.onDefensiveStance, NoTarget=true},
      {ARMS, SPELL, "die-by-the-sword",			arms.SPId.DieByTheSword,			arms.onDieByTheSword, NoTarget=true},
      {ARMS, SPELL, "execute",							arms.SPId.Execute, 						arms.onExecute},
      {ARMS, SPELL, "execute-sudden-death",	arms.SPId.Execute,						arms.onExecuteSuddenDeath},
      {ARMS, SPELL, "impending-victory",		arms.SPId.ImpendingVictory,		arms.onImpendingVictory},
      {ARMS, SPELL, "intimidating-shout",		arms.SPId.IntimidatingShout,	arms.onIntimidatingShout, NoTarget=true},
      {ARMS, SPELL, "mortal-strike",				arms.SPId.MortalStrike,				arms.onMortalStrike},
      {ARMS, SPELL, "overpower",						arms.SPId.Overpower,					arms.onOverpower},
      {ARMS, SPELL, "pummel", 							arms.SPId.Pummel,							ON_COOLDOWN},
      {ARMS, SPELL, "rallying-cry",					arms.SPId.RallyingCry,				ON_COOLDOWN, NoTarget=true},
      {ARMS, SPELL, "ravager",							arms.SPId.Ravager,						arms.onRavager},
      {ARMS, SPELL, "rend",									arms.SPId.Rend,								arms.onRend},
      {ARMS, SPELL, "skullsplitter",				arms.SPId.Skullsplitter,			arms.onSkullsplitter},
      {ARMS, SPELL, "slam",									arms.SPId.Slam, 							arms.onSlam},
      {ARMS, SPELL, "sweeping-strikes",			arms.SPId.SweepingStrikes,		arms.onSweepingStrikes, NoTarget=true},
      {ARMS, SPELL, "warbreaker",						arms.SPId.Warbreaker,					arms.onWarbreaker, NoTarget=true},
			{ARMS, SPELL, "victory-rush",					arms.SPId.VictoryRush,				arms.onVictoryRush},
      {ARMS, SPELL, "whirlwind",						arms.SPId.Whirlwind,					arms.onWhirlwind},

      {ARMS, PRIO, "impending-victory"},
      {ARMS, PRIO, "victory-rush"},
			{ARMS, PRIO, "die-by-the-sword"},
			{ARMS, PRIO, "defensive-stance"},
			{ARMS, PRIO, "intimidating-shout"},

			
			{ARMS, PRIO, "sweeping-strikes"},
			{ARMS, PRIO, "rend"},
			{ARMS, PRIO, "skullsplitter"},
			{ARMS, PRIO, "avatar"},
			{ARMS, PRIO, "warbreaker"},
			{ARMS, PRIO, "colossus-smash"},
			{ARMS, PRIO, "execute-sudden-death"},
			{ARMS, PRIO, "cleave"},
			{ARMS, PRIO, "mortal-strike"},
			{ARMS, PRIO, "ravager"},
			{ARMS, PRIO, "overpower"},
			{ARMS, PRIO, "whirlwind"},
			{ARMS, PRIO, "slam"},
			{ARMS, PRIO, "execute"},

			{ARMS, AOE,   {}},

      {ARMS, INIT,  arms.Init},
      {ARMS, VAR,   "AoeMin", 0},
			{ARMS, SLOT1, SPELL, "bladestorm"},
			{ARMS, SLOT2, SPELL, "rallying-cry"},
      {ARMS, INT, "pummel"},

      --------------------------------------------------------------------------
      -- PROT
      --------------------------------------------------------------------------

      {PROT, SPELL, "battle-cry",        			prot.SPId.BattleCry, 							ON_COOLDOWN, NoTarget=true},
      {PROT, SPELL, "demoralizing-shout",			prot.SPId.DemoralizingShout, 			ON_COOLDOWN, NoTarget=true},
      {PROT, SPELL, "devastate",         			prot.SPId.Devastate, 							ON_COOLDOWN},
      {PROT, SPELL, "focused-rage",      			prot.SPId.FocusedRage, 						prot.onFocusedRage, NoTarget=true},
      {PROT, SPELL, "ignore-pain",       			prot.SPId.IgnorePain, 						prot.onIgnorePain, NoTarget=true, NoRange=true},
      {PROT, SPELL, "impending-victory", 			prot.SPId.ImpendingVictory, 			prot.onImpendingVictory},
      {PROT, SPELL, "impending-victory-heal", prot.SPId.ImpendingVictory, 			prot.onImpendingVictoryHeal},
			{PROT, SPELL, "intercept",							prot.SPId.Intercept,							prot.onIntercept},
			{PROT, SPELL, "heroic-throw", 		 			prot.SPId.HeroicThrow, 						ON_COOLDOWN},
      {PROT, SPELL, "last-stand",        			prot.SPId.LastStand, 							prot.onLastStand},
      {PROT, SPELL, "pummel",            			prot.SPId.Pummel, 								ON_COOLDOWN},
      {PROT, SPELL, "revenge",           			prot.SPId.Revenge, 								ON_COOLDOWN, RangeSpell=prot.SPId.ShieldSlam},
      {PROT, SPELL, "revenge-aoe",       			prot.SPId.Revenge, 								prot.onRevengeAoe, RangeSpell=prot.SPId.ShieldSlam},
      {PROT, SPELL, "shield-block",      			prot.SPId.ShieldBlock, 						prot.onShieldBlock, NoRange=true, NoTarget=true},
      {PROT, SPELL, "shield-slam",       			prot.SPId.ShieldSlam, 						ON_COOLDOWN},
      {PROT, SPELL, "shock-wave",        			prot.SPId.ShockWave, 							ON_COOLDOWN},
      {PROT, SPELL, "thunder-clap",      			prot.SPId.ThunderClap, 						prot.onThunderClap},

      {PROT, PRIO,  "last-stand"},
      {PROT, PRIO,  "impending-victory-heal"},
      {PROT, PRIO,  "ignore-pain"},
      {PROT, PRIO,  "shield-block"},
      {PROT, PRIO,  "shield-slam"},
      {PROT, PRIO,  "revenge"},
      {PROT, PRIO,  "impending-victory"},
      {PROT, PRIO,  "thunder-clap"},
      {PROT, PRIO,  "shock-wave"},
      {PROT, PRIO,  "devastate"},
      {PROT, AOE,   {}},

      {PROT, INIT,  prot.Init},
      {PROT, VAR,   "AoeMin",               0},
			{PROT, SLOT1, SPELL,                  "intercept"},
			{PROT, SLOT2, SPELL,                  "battle-cry",  format(L"%s. Use on cooldown", prot.SPN.BattleCry)},
			{PROT, SLOT3, SPELL,                  "demoralizing-shout", format(L"%s. Use on cooldown", prot.SPN.DemoralizingShout)},
      {PROT, INT,                           "pummel"}

			)
  end
end

