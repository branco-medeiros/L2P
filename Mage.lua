local addon_name, Main = ...

local function L(text)
  return (Main.Strings and Main.Strings[text]) or text
end


if select(2, UnitClass("player")) == 'MAGE' then

  local ARCANE = "arcane"
	local ARC = ARCANE
  local FROST = "frost"
  local FIRE = "fire"

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


	local frost = {}
	local fire = {}
	local arc = {}
	
	local function GetEnemyIsClose(Ctx, distance)
		distance = distance or 3
		local result = CheckInteractDistance("target", distance) or false
		if not result and Ctx.Attackers > 0 then
			for k, n in pairs(Ctx.AttackerList) do
				if CheckInteractDistance(k, distance) then
					result = true
					break
				end
			end
		end
		if not result and Ctx.Mobs > 0 then
			for k, n in pairs(Ctx.MobList) do
				if CheckInteractDistance(k, distance) then
					result = true
					break
				end
			end
		end
		return result
	end
	
	frost.SPI = {
		Blizzard = 190356,
		BrainFreezeBuff = 190447,
		ColdSnap = 235219,
		CometStorm = 153595,
		ConeOfCold = 120,
		Counterspell = 2139,
		Ebonbolt = 214634,
		FingersOfFrostBuff = 112965,
		Flurry = 44614,
		Freeze = 231596, -- pet
		Frostbolt = 116,
		FrostNova = 122,
		FrozenOrb = 84714,
		GlacialSpike = 199786,
		IceBarrierBuff = 11426,
		IceLance = 30455,
		IceNova = 157997,    
		IcyVeins = 12472,
		MirrorImage = 55342,
		RayOfFrost = 205021,
		RuneOfPower = 116011,
		RuneOfPowerBuff = 116014,
		TimeWarp = 80353,
		WintersChillDebuff = 228358,
		xx = 0
	}
  
	frost.SPN = Main:CreateSpellNames(frost.SPI)
  
	
  frost.Init = function (this, Ctx)
		local SPN = frost.SPN
		local SPI = frost.SPI
		
		Ctx.RuneOfPowerBuff = Ctx:CheckBuff(SPN.RuneOfPowerBuff) > 0
		
		local c, d = Ctx:CheckBuff(SPN.FingersOfFrostBuff)
		Ctx.FingersOfFrostCharges = c
		Ctx.FingersOfFrostBuff = c > 0 
		
		Ctx.BrainFreezeBuff = Ctx:CheckBuff(SPN.BrainFreezeBuff) > 0
		Ctx.WintersChillDebuff = Ctx:CheckDebuff(SPI.WintersChillDebuff) > 0
		
		Ctx.EnemyIsCloseEnough = GetEnemyIsClose(Ctx)
		
		--Ctx.WaterjetDebuff = Ctx:CheckDebuff(SPN.WaterJet) > 0
	end
    
    
	frost.OnBlizzard = function (this, Ctx)
		return Ctx.Mobs > 3
	end
	
	
	frost.OnCometStormMoving = function (this, Ctx)
		return Ctx.IsMoving
	end
	
	
	frost.OnConeOfCold = function (this, Ctx)
		return Ctx.EnemyIsCloseEnough
	end
	
	
	frost.OnConeOfColdMoving = function (this, Ctx)
		return Ctx.IsMoving and Ctx.EnemyIsCloseEnough
	end
	
	
	frost.OnEbonbolt = function (this, Ctx)
		return not Ctx.BrainFreezeBuff
	end
	
	frost.OnFreeze = function(this, Ctx)
		return Ctx.FingersOfFrostCharges < 2
	end
	
	
	frost.OnFrostBoltWaterJet = function(this, Ctx)
		return Ctx.WaterjetDebuff
	end
	
	frost.OnFrostBomb = function(this, Ctx)
		return Ctx.FingersOfFrostBuff
	end
	
	frost.OnFrostNova = function(this, Ctx)
		return Ctx.EnemyIsCloseEnough
	end
	
	
	frost.OnFrostNovaMoving = function(this, Ctx)
		return Ctx.IsMoving and Ctx.EnemyIsCloseEnough
	end
	
 frost.OnIceLance = function(this, Ctx)
		return Ctx.FingersOfFrostBuff or Ctx.WintersChillDebuff
	end  
	
 frost.OnIceLanceMoving = function(this, Ctx)
		return Ctx.IsMoving
	end  
	
 frost.OnIceNovaMoving = function(this, Ctx)
		return Ctx.IsMoving
	end  
	
	frost.OnMirrorImage = function(this, Ctx)
		-- boss fight or many aoe or desperate
		return Ctx.IsBossFight or Ctx.Mobs > 4 or Ctx.HealthPercent < 0.7
	end
	
	frost.OnRuneOfPower = function(this, Ctx)
		-- boss fight, big aoe or desperate
		return Ctx.IsBossFight or Ctx.Mobs > 4 or Ctx.HealthPercent < 0.7
	end
	
	frost.OnWaterJet = function(this, Ctx)
		return Ctx.FingersOfFrostCharges < 2 and (
			Ctx.IsBossFight or Ctx.Mobs == 1
		)
	end

	local SPI = frost.SPI
	local SPN = frost.SPN
	
	frost.cmds = {
		{FROST, SPELL, "blizzard",                SPI.Blizzard, frost.OnBlizzard, NoInstant = true},
		{FROST, SPELL, "blizzard-instant",        SPI.Blizzard, ON_COOLDOWN, NoTarget=true},
		{FROST, SPELL, "ebonbolt",                SPI.Ebonbolt, frost.OnEbonbolt, NoInstant = true},
		{FROST, SPELL, "comet-storm",             SPI.CometStorm, ON_COOLDOWN},
		{FROST, SPELL, "comet-storm-moving",      SPI.CometStorm, frost.OnCometStormMoving},
		{FROST, SPELL, "cone-of-cold",            SPI.ConeOfCold, frost.OnConeOfCold},
		{FROST, SPELL, "cone-of-cold-moving",     SPI.ConeOfCold, frost.OnConeOfColdMoving},
		{FROST, SPELL, "counterspell",            SPI.Counterspell, ON_COOLDOWN},
		{FROST, SPELL, "cold-snap",               SPI.ColdSnap, ON_COOLDOWN, NoTarget=true},
		{FROST, SPELL, "flurry",                  SPI.Flurry, ON_COOLDOWN},
		{FROST, SPELL, "freeze",                  SPI.Freeze, frost.OnFreeze, PetSpell=true},
		{FROST, SPELL, "frostbolt",               SPI.Frostbolt, ON_COOLDOWN, NoInstant=true},
		{FROST, SPELL, "frost-nova", 							SPI.FrostNova, frost.OnFrostNova},
		{FROST, SPELL, "frost-nova-moving", 			SPI.FrostNova, frost.OnFrostNovaMoving},
		{FROST, SPELL, "frozen-orb",              SPI.FrozenOrb, ON_COOLDOWN, NoRange=true},
		{FROST, SPELL, "glacial-spike",           SPI.GlacialSpike, ON_COOLDOWN, NoInstant = true},
		{FROST, SPELL, "ice-lance",               SPI.IceLance, frost.OnIceLance},
		{FROST, SPELL, "ice-lance-filler",        SPI.IceLance, ON_COOLDOWN},
		{FROST, SPELL, "ice-lance-moving",        SPI.IceLance, frost.OnIceLanceMoving},
		{FROST, SPELL, "ice-nova",                SPI.IceNova, ON_COOLDOWN},
		{FROST, SPELL, "ice-nova-moving",         SPI.IceNova, frost.OnIceNovaMoving},
		{FROST, SPELL, "icy-veins",               SPI.IcyVeins, ON_COOLDOWN},
		{FROST, SPELL, "mirror-image",            SPI.MirrorImage, frost.OnMirrorImage},
		{FROST, SPELL, "ray-of-frost",            SPI.RayOfFrost, ON_COOLDOWN, NoInstant = true},
		{FROST, SPELL, "rune-of-power",           SPI.RuneOfPower, frost.OnRuneOfPower, NoTarget=true, NoInstant=true},
		{FROST, SPELL, "time-warp",               SPI.TimeWarp, ON_COOLDOWN},
	
		-- PRIORITIES
		{FROST, PRIO, "ice-lance"},
		{FROST, PRIO, "flurry"},
		{FROST, PRIO, "frozen-orb"},
		{FROST, PRIO, "blizzard-instant"},

		{FROST, PRIO, "comet-storm-moving"},
		{FROST, PRIO, "ice-nova-moving"},
		{FROST, PRIO, "cone-of-cold-moving"},
		{FROST, PRIO, "frost-nova-moving"},
		{FROST, PRIO, "ice-lance-moving"},

		{FROST, PRIO, "freeze"},
		{FROST, PRIO, "ebonbolt"},
		{FROST, PRIO, "frost-bomb"},
		{FROST, PRIO, "ray-of-frost"},
		{FROST, PRIO, "glacial-spike"},
		{FROST, PRIO, "comet-storm"},
		{FROST, PRIO, "ice-nova"},
		{FROST, PRIO, "frostbolt"},
		{FROST, PRIO, "cone-of-cold"},
		{FROST, PRIO, "frost-nova"},
		{FROST, PRIO, "ice-lance-filler"},
		
		{FROST, VAR,   "AoeMin", 0},
		{FROST, INT,   'counterspell'},
		{FROST, SLOT1,  BUFF, {SPN.IceBarrierBuff}, SPN.IceBarrierBuff},
		{FROST, SLOT2,  BUFF, SPN.RuneOfPowerBuff, SPN.RuneOfPower},
		{FROST, SLOT3,  SPELL, 'icy-veins', SPN.IcyVeins},
		{FROST, SLOT4,  SPELL, 'time-warp', SPN.TimeWarp},
		{FROST, SLOT5,  SPELL, "cold-snap", SPN.ColdSnap},
		{FROST, INIT,   frost.Init}
	}
	
  
  
  fire.SPI = {
		AlextraszasFuryTalent = 235870,
		BlastWave = 157981, --
		BlazingBarrierBuff = 235313, --
		Cinderstorm = 198929,
		Combustion = 190319, --
		ConcentratedFlame = 295373,
		Counterspell = 2139,
		DragonsBreath = 31661,
		FireBlast = 108853, --
		Fireball = 133, --
		Flamestrike = 2120, --
		HeatingUpBuff = 48107, --
		HotStreak = 195283, --
		HotStreakBuff = 48108, --?
		IgniteDebuff = 12654,
		KaelthassUltimateAbilityBuff = 209455, --
		LivingBomb = 44457, --
		Meteor = 153561, --
		MirrorImage = 55342, --
		PhoenixFlames = 257541, --
		Pyroblast = 11366, --
		Pyroclasm = 269651, --
		RuneOfPower = 116011, --
		RuneOfPowerBuff = 116014,
		Scorch = 2948, --
		TimeWarp = 80353,
		xx = 0
	}

	fire.SPN = Main:CreateSpellNames(fire.SPI)
	
	fire.Init = function(this, Ctx)
		local SPN = fire.SPN
		local SPI = fire.SPI
		local s, e, d = Ctx:CheckBuff(SPN.Combustion)
		Ctx.CombustionBuff = s > 0
		Ctx.CombustionRemain = e
		
		Ctx.HeatingUpBuff = Ctx:CheckBuff(SPN.HeatingUpBuff) > 0
		Ctx.HotStreakBuff = Ctx:CheckBuff(SPN.HotStreakBuff) > 0
		Ctx.IgniteDebuff = Ctx:CheckDebuff(SPN.IgniteDebuff) > 0
		Ctx.PyroclasmUp = Ctx:CheckBuff(SPI.Pyroclasm) > 0
		
		Ctx.PhoenixFlamesCharges = Ctx:SpellCharges(SPN.PhoenixFlames)

		Ctx.IsEquippedDarcklisDiadem = IsEquippedItem(132863)
		Ctx.IsEquippedKoralons = IsEquippedItem(132454)
		
		Ctx.HasTalentAlextrazasFury = Ctx:HasTalent(4, 2)
		Ctx.HasTalentSearingTouch = Ctx:HasTalent(1, 3)
		
		Ctx.KaeltasBuffUp = Ctx:CheckBuff(SPI.KaelthassUltimateAbilityBuff) > 0
		Ctx.PyroblastCastTime = select(4, GetSpellInfo(SPI.Pyroblast))
		
		Ctx.EnemyIsCloseEnough = GetEnemyIsClose(Ctx)
		
	end
	
	fire.OnCombustion = function(this, Ctx)
		return Ctx.IsBossFight or	
			Ctx.HasBloodlust or
			Ctx.HealthPercent < 0.6
	end
	
	fire.OnBlastWave = function(this, Ctx)
		return true
	end

	fire.OnDragonsBreath = function(this, Ctx)
		return (Ctx.IsEquippedDarcklisDiadem or
			Ctx.HasTalentAlextrazasFury) and 
			Ctx.EnemyIsCloseEnough
	end

	fire.OnDragonsBreathAttack = function(this, Ctx)
		return not Ctx.IsBossFight and Ctx.EnemyIsCloseEnough
	end

	fire.OnFireBlast = function(this, Ctx)
		return Ctx.HeatingUpBuff
	end

	fire.OnFireBlastAttack = function(this, Ctx)
		return not Ctx.IsBossFight
	end

	fire.OnFireball = function(this, Ctx)
		return not (Ctx.HeatingUpBuff or Ctx.HotStreakBuff) and not Ctx.IsMoving
	end

	fire.OnFlamestrike = function(this, Ctx)
		return Ctx.Mobs > 4
	end

	fire.OnMeteor = function(this, Ctx)
		return Ctx.IsBossFight or Ctx.Mobs > 2 or Ctx.HealthPercent < 0.6
	end

	fire.OnMirrorImage = function(this, Ctx)
		return Ctx.IsBossFight or 
			Ctx.HealthPercent < 0.6 or
			Ctx.HasBloodlust
	end

	fire.OnPhoenixFlames = function(this, Ctx)
		return Ctx.PhoenixFlamesCharges > 1
	end

	fire.OnPhoenixFlamesAttack = function(this, Ctx)
		return not Ctx.IsBossFight
	end

	fire.OnPyroblast = function(this, Ctx)
		return true
	end

	fire.OnPyroblastSlow = function(this, Ctx)
		return not Ctx.IsMoving and
		(
			(
				Ctx.KaeltasBuffUp and 
				Ctx.CombustionUp and 
				Ctx.PyroblastCastTime < Ctx.CombustionRemain
			) or 
			Ctx.PyroclasmUp or
			Ctx.KaeltasBuffUp 	
		)
	end

	fire.OnScorch = function(this, Ctx)
		return Ctx.HasTalentSearingTouch or 
			(Ctx.IsEquippedKoralons and Ctx.TargetHealthPercent <= 0.3)
	end

	fire.OnScorchMoving = function(this, Ctx)
		return Ctx.IsMoving
	end

	SPI = fire.SPI
	SPN = fire.SPN
	
	
	fire.cmds = {
		{FIRE, SPELL, "blast-wave",          		SPI.BlastWave, fire.OnBlastWave},
		{FIRE, SPELL, "combustion",          		SPI.Combustion, fire.OnCombustion, NoTarget=true, Secondary=true},
		{FIRE, SPELL, "combustion-spell",       SPI.Combustion, ON_COOLDOWN, NoTarget=true},
		{FIRE, SPELL, "concentrated-flame",     SPI.ConcentratedFlame, ON_COOLDOWN},
		{FIRE, SPELL, "counterspell",        		SPI.Counterspell, ON_COOLDOWN},
		{FIRE, SPELL, "dragons-breath",      		SPI.DragonsBreath, fire.OnDragonsBreath, NoTarget=true},
		{FIRE, SPELL, "dragons-breath-attack",  SPI.DragonsBreath, fire.OnDragonsBreathAttack},
		{FIRE, SPELL, "fire-blast",          		SPI.FireBlast, fire.OnFireBlast},
		{FIRE, SPELL, "fire-blast-attack",      SPI.FireBlast, fire.OnFireBlastAttack},
		{FIRE, SPELL, "fireball",            		SPI.Fireball, fire.OnFireball, NoInstant = true},
		{FIRE, SPELL, "flamestrike",         		SPI.Flamestrike, fire.OnFlamestrike},
		{FIRE, SPELL, "living-bomb",         		SPI.LivingBomb, ON_COOLDOWN},
		{FIRE, SPELL, "meteor",              		SPI.Meteor, fire.OnMeteor, NoTarget=true},
		{FIRE, SPELL, "mirror-image",           SPI.MirrorImage, fire.OnMirrorImage, NoTarget=true, Secondary=true},
		{FIRE, SPELL, "phoenix-flames",      		SPI.PhoenixFlames, fire.OnPhoenixFlames},
		{FIRE, SPELL, "phoenix-flames-attack",  SPI.PhoenixFlames, fire.OnPhoenixFlamesAttack},
		{FIRE, SPELL, "pyroblast",           		SPI.Pyroblast, fire.OnPyroblast},
		{FIRE, SPELL, "pyroblast-slow",      		SPI.Pyroblast, fire.OnPyroblastSlow, NoInstant=true},
		{FIRE, SPELL, "rune-of-power", 			 		SPI.RuneOfPower, ON_COOLDOWN, NoTarget=true},
		{FIRE, SPELL, "scorch",              		SPI.Scorch, fire.OnScorch, NoInstant=true},
		{FIRE, SPELL, "scorch-moving",       		SPI.Scorch, fire.OnScorchMoving, NoInstant=true},
		{FIRE, SPELL, "time-warp",           		SPI.TimeWarp, ON_COOLDOWN, NoTarget=true},
		
		
		{FIRE, PRIO, "mirror-image"},
		{FIRE, PRIO, "combustion"},
		{FIRE, PRIO, "pyroblast"},
		{FIRE, PRIO, "phoenix-flames-attack"},
		{FIRE, PRIO, "fire-blast-attack"},
		{FIRE, PRIO, "phoenix-flames"},
		{FIRE, PRIO, "dragons-breath"},
		{FIRE, PRIO, "flamestrike"},
		{FIRE, PRIO, "fire-blast"},
		{FIRE, PRIO, "dragons-breath-attack"},
		{FIRE, PRIO, "fireball"},
		{FIRE, PRIO, "concentrated-flame"},
		{FIRE, PRIO, "meteor"},
		{FIRE, PRIO, "blast-wave"},
		{FIRE, PRIO, "living-bomb"},
		{FIRE, PRIO, "scorch-moving"},
		{FIRE, PRIO, "pyroblast-slow"},
		{FIRE, PRIO, "scorch"},
		
		{FIRE, VAR,   "AoeMin", 0},
		{FIRE, INT,   'counterspell'},
		{FIRE, SLOT1,  BUFF, {SPN.BlazingBarrierBuff}, SPN.BlazingBarrierBuff},
		{FIRE, SLOT2,  SPELL, 'time-warp', SPN.TimeWarp},
		{FIRE, SLOT3,  SPELL, "combustion-spell", SPN.Combustion},
		{FIRE, SLOT4,  BUFF, SPN.RuneOfPower, SPN.RuneOfPower},
		{FIRE, INIT,   fire.Init}
	}
    
	arc.SPId = {
		ArcaneBarrage	=	44425,
		ArcaneBlast	=	30451,
		ArcaneExplosion	=	1449,
		ArcaneMissiles	=	5143,
		ArcaneOrb	=	153626,
		ArcanePower	=	12042,
		ChargedUp	=	205032,
		Clearcasting	=	263725,
		Evocation	=	12051,
		MirrorImage	=	55342,
		NetherTempest	=	114923,
		PresenceOfMind	=	205025,
		PrismaticBarrier	=	235450,
		RuleOfThrees	=	264774,
		RuneOfPower	=	116011,
		Supernova	=	157980,
		TimeWarp = 80353,
		zz = 0
	}
	
	arc.SPN = Main:CreateSpellNames(arc.SPId)

--FUNCTIONS

	arc.Init = function(this, Ctx)
		local SPN = arc.SPN
		local SPI = arc.SPId
		
		Ctx.ArcaneCharges = UnitPower("player", Enum.PowerType.ArcaneCharges) or 0
		Ctx.ManaPercent = UnitPower("player", Enum.PowerType.Mana)/UnitPowerMax("player", Enum.PowerType.Mana)

		local s, d = Ctx:CheckBuff(SPI.ArcanePower)
		Ctx.HasArcanePower = s > 0
		Ctx.ArcanePowerRemaining = d
		Ctx.ArcanePowerUp = Ctx:SpellCooldown(SPN.ArcanePower) == 0
		
		Ctx.IsBurnPhase = Ctx.ArcaneCharges == 4 
			and (Ctx.HasArcanePower or Ctx.ArcanePowerUp)
			and Ctx.ManaPercent > 0.3
		
		
		s, d = Ctx:CheckDebuff(SPI.NetherTempest) 
		Ctx.HasNetherTempest = s > 0
		Ctx.NetherTempestRemaining = d
    
		s, d = Ctx:CheckBuff(SPI.RuleOfThrees)
		Ctx.HasRuleOfThrees = s > 0
		
		s, d = Ctx:CheckBuff(SPI.Clearcasting)
		Ctx.HasClearcasting = s > 0
		
	end
	
	arc.onArcaneBarrage = function(this, Ctx)
		return Ctx.ArcaneCharges > 3 
	end


	arc.onArcaneBlast = function(this, Ctx)
		return true
	end


	arc.onArcaneBlast3x = function(this, Ctx)
		return Ctx.HasRuleOfThrees
	end


	arc.onArcaneExplosion = function(this, Ctx)
		return Ctx.EnemyIsCloseEnough and 
			(Ctx.Attackers > 2 or Ctx.Mobs > 2 or Ctx.HealthPercent < 0.7) 
	end


	arc.onArcaneMissiles = function(this, Ctx)
		return Ctx.HasClearcasting
	end


	arc.onArcaneOrb = function(this, Ctx)
		return Ctx.ArcaneCharges < 4
	end


	arc.onArcanePower = function(this, Ctx)
		return Ctx.IsBossFight 
			or Ctx.Attackers > 2 
			or Ctx.Mobs > 2 
			or Ctx.HealthPercent < 0.7
	end


	arc.onChargedUp = function(this, Ctx)
		return Ctx.ArcaneCharges < 2
	end


	arc.onEvocation = function(this, Ctx)
		return Ctx.ManaPercent < 0.1
	end


	arc.onNetherTempest = function(this, Ctx)
		return Ctx.ArcaneCharges > 3 and
			(not Ctx.HasNetherTempest or Ctx.NetherTempestRemaining < 2*Ctx.GCD)
	end


	arc.onPresenceOfMind = function(this, Ctx)
		return Ctx.HasArcanePower and Ctx.ArcanePowerRemaining < 2*Ctx.GCD
	end


	arc.onSupernova = function(this, Ctx)
		return not Ctx.IsBurnPhase
	end


	SPN = arc.SPN
	SPI = arc.SPId
	
	--SPELLS
	arc.cmds = {
		{ARC, SPELL, "arcane-barrage", 							arc.SPId.ArcaneBarrage, 			arc.onArcaneBarrage, NoInstant=true},
		{ARC, SPELL, "arcane-blast", 								arc.SPId.ArcaneBlast, 				arc.onArcaneBlast, NoInstant=true},
		{ARC, SPELL, "arcane-blast-3x", 						arc.SPId.ArcaneBlast, 				arc.onArcaneBlast3x, NoInstant=true},
		{ARC, SPELL, "arcane-explosion", 						arc.SPId.ArcaneExplosion, 		arc.onArcaneExplosion},
		{ARC, SPELL, "arcane-missiles", 						arc.SPId.ArcaneMissiles, 			arc.onArcaneMissiles, NoInstant=true},
		{ARC, SPELL, "arcane-orb", 									arc.SPId.ArcaneOrb, 					arc.onArcaneOrb},
		{ARC, SPELL, "charged-up", 									arc.SPId.ChargedUp, 					arc.onChargedUp},
		{ARC, SPELL, "evocation", 									arc.SPId.Evocation, 					arc.onEvocation, NoTarget=true},
		{ARC, SPELL, "mirror-image", 								arc.SPId.MirrorImage, 				ON_COOLDOWN, NoTarget=true},
		{ARC, SPELL, "nether-tempest", 							arc.SPId.NetherTempest, 			arc.onNetherTempest},
		{ARC, SPELL, "presence-of-mind", 						arc.SPId.PresenceOfMind, 			arc.onPresenceOfMind, NoTarget=true},
		{ARC, SPELL, "prismatic-barrier", 					arc.SPId.PrismaticBarrier, 		ON_COOLDOWN, NoTarget=true},
		{ARC, SPELL, "rune-of-power", 							arc.SPId.RuneOfPower, 				ON_COOLDOWN, NoTarget=true},
		{ARC, SPELL, "supernova", 									arc.SPId.Supernova, 					arc.onSupernova},
		{ARC, SPELL, "time-warp",           				SPI.TimeWarp, 								ON_COOLDOWN, NoTarget=true},
		
		
		{ARC, PRIO, "evocation"},
		{ARC, PRIO, "charged-up"},
		{ARC, PRIO, "arcane-orb"},
		{ARC, PRIO, "nether-tempest"},
		{ARC, PRIO, "arcane-blast-3x"},
		{ARC, PRIO, "arcane-power"},
		{ARC, PRIO, "arcane-barrage"},
		{ARC, PRIO, "arcane-explosion"},
		{ARC, PRIO, "arcane-missiles"},
		{ARC, PRIO, "super-nova"},
		{ARC, PRIO, "presence-of-mind"},
		{ARC, PRIO, "arcane-blast"},
		
		
		{ARC, VAR,   "AoeMin", 0},
		{ARC, INT,   'counterspell'},
		{ARC, SLOT1,  BUFF, {SPN.PrismaticBarrier}, SPN.PrismaticBarrier},
		{ARC, SLOT2,  SPELL, 'time-warp', SPN.TimeWarp},
		{ARC, SLOT3,  SPELL, "rune-of-power", SPN.RuneOfPower},
		{ARC, SLOT4,  SPELL, "mirror-image", SPN.MirrorImage},
		{ARC, INIT,   arc.Init}
	}

  

  local FROST_CMDS = frost.cmds
  local FIRE_CMDS = fire.cmds
	local ARC_CMDS = arc.cmds
  
  --------------------------------------------------------------------------------
  function Main:GetEngine()
  --------------------------------------------------------------------------------
     return self:InitSpecs(
      Main.joinTables(
        {{ARCANE, SKIP},{FIRE, SKIP},{FROST, SKIP}},
        FROST_CMDS,
        FIRE_CMDS,
				ARC_CMDS
      )
    )
  end -- Main:GetEngine
end -- if
