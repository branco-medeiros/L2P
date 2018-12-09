local _, Main = ...
if select(2, UnitClass("player")) == 'PALADIN' then

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

  local ITEM_JUSTICE_GAZE = 137065
  local ITEM_LIADRINS_FURY = 137048
  local ITEM_WHISPER_OF_THE_NATHREZIM = 137020

  local HOLY = "Holy"
  local PROT = "Protection"
  local RETR = "Retribution"

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

	local retr = {}
	local prot = {}
	local holy = {}

  local SPELL_POWER_HOLY_POWER = 9
	
	------------------------------------------------------------------------------
	-- RETRIBUTION
	------------------------------------------------------------------------------
  retr.SPId = {
		AvengingWrath							 = 31884,
		ArcaneTorrent							 = 155145,
		BlessedHammer							 = 204019,
    BladeOfJustice             = 184575,
    BlindingLight              = 115750,
    Consecration               = 205228,
    Crusade                    = 231895,
    CrusaderStrike             = 35395,
    DivinePurpose              = 223817,
    DivineShield               = 642,
    DivineStorm                = 53385,
    ExecutionSentence          = 267798,
    ExecutionSentenceDebuff    = 267799,
		EyeForAnEye                = 205191,
    FiresOfJustice             = 209785,
		FlashOfLight               = 19750,
		HandOfHindrance						 = 183218,
    HammerOfJustice            = 853,
    HammerOfWrath              = 24275,
		Inquisition								 = 84963,
    Judgment                   = 20271, --231663,
		JudgmentDebuff						 = 197277,
    JusticarsVengeance         = 215661,
		LayOnHands                 = 633,
    Rebuke                     = 96231,
    Retribution                = 183436,
    RighteousVerdictBuff       = 267611,
    ScarletInquisitorsExp 		 = 248289,
		SelflessHealer						 = 85804,
		ShieldOfVengeance          = 184662,
    TemplarsVerdict            = 85256,
		WakeOfAshes                = 255937,
		WakeOfAshesDebuff					 = 255941,
    WhisperOfTheNathrezim      = 207633,
    WordOfGlory                = 210191,
    Zeal                       = 217020,
    zz=0
  }

	retr.SPN = Main:CreateSpellNames(retr.SPId)
	
	retr.Init = function(this, Ctx)
  -- Initializes the variables used by each condition

		local SPN = retr.SPN
		local SPId = retr.SPId

    local function react(s, e, d)
      if s == nil or d == nil then return false end
      local gcdx2 = Ctx.GCDx2
      return s > 0 and (d <= 2 or (d - e < gcdx2))
    end
    
    
      
    Ctx.GCDx2 = Ctx.GCD * 2
    Ctx.TargetHealthPercent = UnitHealth("target")/UnitHealthMax("target")
    Ctx.LowHealth = Ctx.HealthPercent <= .5
		Ctx.MediumHealth = not Ctx.LowHealth and Ctx.HealthPercent <= .85

		-- Holypower management
		Ctx.HolyPower = UnitPower("player", SPELL_POWER_HOLY_POWER) or 0

		
    local s, e, d = Ctx:CheckBuff(SPN.DivinePurpose)
    Ctx.DivinePurposeUp = s > 0
    Ctx.DivinePurposeRemain = e
    Ctx.DivinePurposeReact = react(s, e, d)
		
		Ctx.HammerOfWrathEnabled = IsPlayerSpell(SPId.HammerOfWrath) and Ctx:IsSpellAvailable(SPId.HammerOfWrath)
		Ctx.HammerOfWrathCoooldown = Ctx:SpellCooldown(SPN.HammerOfWrath)

		Ctx.IsSpellCrusade = IsPlayerSpell(SPId.Crusade)
    Ctx.CrusadeStacks = Ctx:CheckBuff(SPN.Crusade)
    Ctx.CrusadeUp = Ctx.CrusadeStacks > 0
		Ctx.CrusadeCooldown = Ctx:SpellCooldown(SPN.Crusade)
		
		s, e, d = Ctx:CheckBuff(SPN.Inquisition)
		Ctx.InquisitionUp = s > 0
		Ctx.InquisitionRemain = e
		
		Ctx.IsSpellExecutionSentence = IsPlayerSpell(SPId.ExecutionSentence)
		Ctx.ExecutionSentenceCooldown = Ctx:SpellCooldown(SPN.ExecutionSentence)
		
		Ctx.AvengingWrathCooldown = Ctx:SpellCooldown(SPN.AvengingWrath)
		
		Ctx.HasTalentDivineJudgment = Ctx:HasTalent(4, 1)
		Ctx.IsDivineStormCastable = (Ctx.Mobs >= 3) or
			(Ctx.HasTalentDivineJudgment and Ctx.Mobs >= 2) or
			(Ctx.HasTalentDivineRight and Ctx.TargetHealthPercent <= 0.2 and not Ctx.DivineRightUp)

		Ctx.BladeOfJusticeCooldown = Ctx:SpellCooldown(SPN.BladeOfJustice)
		Ctx.JudgmentCooldown = Ctx:SpellCooldown(SPN.Judgment)
		Ctx.ConsecrationCooldown = Ctx:SpellCooldown(SPN.Consecration)
    Ctx.CrusaderStrikeCharges = Ctx:SpellCharges(SPN.CrusaderStrike)
		
		Ctx.TargetStunned = Ctx:CheckDebuff({SPN.HammerOfJustice, SPN.BlindingLight, SPId.WakeOfAshesDebuff}) > 0

		Ctx.NeedJusticarsVengeance = IsPlayerSpell(SPId.JusticarsVengeance) and 
			not Ctx:IsSpellAvailable(SPId.JusticarsVengeance)
			
		Ctx.NeedWordOfGlory = IsPlayerSpell(SPId.WordOfGlory) and
			not Ctx:IsSpellAvailable(SPId.WordOfGlory)
			
		Ctx.TargetHasJudgment = Ctx:CheckDebuff(SPId.JudgmentDebuff)
  end

  -- check spells conditions
	
	retr.onHP5 = function(this, ctx)
	  return ctx.HolyPower > 4 or ctx.DivinePurposeUp
	end
	
	retr.onFinisher = function(this, ctx)
		return ctx.HammerOfWrathEnabled and
			(
				ctx.DivinePurposeUp or 
				(ctx.CrusadeUp and ctx.CrusadeStacks < 10 )
			)
	end
	
	retr.onInquisition = function(this, ctx)
		return ctx.HolyPower > 2 and (
			(not ctx.InquisitionUp) or
			(ctx.InquisitionRemain < 5) or
			(ctx.IsSpellExecutionSentence and ctx.ExecutionSentenceCooldown < 10 and ctx.InquisitionRemain < 15) or
			(ctx.AvengingWrathCooldown > 0 and ctx.AvengingWrathCooldown  < 15 and ctx.InquisitionRemain < 20)
		)
	end
	
	retr.onExecutionSentence = function(this, ctx)
		return not ctx.IsDivineStormCastable
	end
	
	retr.onDivineStorm = function(this, ctx)
		return ctx.IsDivineStormCastable
	end
	
	
	retr.onDivineStormHP5 = function(this, ctx)
		return retr.onHP5(this, ctx) and retr.onDivineStorm(this, ctx)
	end
	
	retr.onTemplarsVerdict = function(this, ctx)
		return not ctx.IsDivineStormCastable
	end
		
	retr.onTemplarsVerdictHP5 = function(this, ctx)
		return retr.onHP5(this, ctx) and retr.onTemplarsVerdict(this, ctx)
	end
	
	retr.onWakeOfAshes = function(this, ctx)
		return (ctx.HolyPower <= 0) or
			(ctx.HolyPower == 1 and ctx.BladeOfJusticeCooldown > ctx.GCD)
	end

	retr.onWakeOfAshesHeal = function(this, ctx)
		return (ctx.HealthPercent < 0.6) and
			(ctx.NeedJusticarsVengeance or ctx.NeedWordOfGlory) and
			(ctx.HolyPower <= 2)
	end
	
	retr.onBladeOfJustice = function(this, ctx)
		return (ctx.HolyPower <= 2) or
		(
			ctx.HolyPower == 3 and 
			(ctx.HammerOfWrathCoooldown  > ctx.GCDx2 or not ctx.HammerOfWrathEnabled)
		)
	end

	retr.onBladeOfJusticeHeal = function(this, ctx)
		return (ctx.HealthPercent < 0.6) and
			(ctx.NeedJusticarsVengeance or ctx.NeedWordOfGlory)
	end

	retr.onJudgment = function(this, ctx)
		return (ctx.HolyPower <= 3) or
		(
			ctx.HolyPower <= 4 and 
			ctx.BladeOfJusticeCooldown > ctx.GCDx2
		)
	end

	retr.onJudgmentHeal = function(this, ctx)
		return not Ctx.TargetHasJudgment
	end
	
	retr.onJudgmentHeal = function(this, ctx)
		return (ctx.HealthPercent < 0.6) and
			(ctx.NeedJusticarsVengeance or ctx.NeedWordOfGlory)
	end
	
	
	retr.onHammerOfWrath = function(this, ctx)
		return ctx.HolyPower <= 4
	end
	
	retr.onHammerOfWrathHeal = function(this, ctx)
		return (ctx.HealthPercent < 0.6) and
			(ctx.NeedJusticarsVengeance or ctx.NeedWordOfGlory)
	end
	
	retr.onConsecration = function(this, ctx)
		return (ctx.HolyPower <= 2) or
			(ctx.HolyPower <= 3 and ctx.BladeOfJusticeCooldown > ctx.GCDx2) or 
			(ctx.HolyPower == 4 and ctx.BladeOfJusticeCooldown > ctx.GCDx2 and ctx.JudgmentCooldown > ctx.GCDx2)
	end
	
	retr.onConsecrationHeal = function(this, ctx)
		return (ctx.HealthPercent < 0.6) and
			(ctx.NeedJusticarsVengeance or ctx.NeedWordOfGlory)
	end
	
	retr.onCrusaderStrike = function(this, ctx)
		return (ctx.CrusaderStrikeCharges >= 1.75) and 
			(
				ctx.HolyPower <= 2 or 
				(ctx.HolyPower <= 3 and ctx.BladeOfJusticeCooldown > ctx.GCDx2) or 
				(ctx.HolyPower == 4 and ctx.BladeOfJusticeCooldown > ctx.GCDx2 and ctx.JudgmentCooldown > ctx.GCDx2)
			)
	end
	
	retr.onCrusaderStrikeFiller = function(tis, ctx)
		return ctx.HolyPower < 5
	end
	
	retr.onCrusaderStrikeHeal = function(this, ctx)
		return (ctx.HealthPercent < 0.6) and
			(ctx.NeedJusticarsVengeance or ctx.NeedWordOfGlory)
	end

  retr.onJusticarsVengeance = function(this, ctx)
    return ctx.DivinePurposeUp and ctx.TargetStunned
  end

	-- PVP Spells
	retr.onHammerOfJustice = function(this, ctx)
		return ctx.IsPvp
	end
	
	retr.onHandOfHindrance = function(this, ctx)
		return ctx.IsPvp
	end
  
  --- healing conditions
  retr.onDivineShield = function(this, ctx)
    return ctx.HealthPercent <= 0.4 and
			(ctx.PainPerSecond > 0) 
  end
  
  retr.onLayOnHands = function(this, ctx)
    return ctx.HealthPercent <= 0.2
  end
  
  retr.onWordOfGlory = function(this, ctx)
    return ctx.HealthPercent <= 0.6
  end
  
  retr.onJusticarsVengeanceHeal = function(this, ctx)
    return ctx.HealthPercent <= 0.6
  end

  retr.onShieldOfVengeance = function(this, ctx)
    return ctx.HealthPercent < 0.6 and 
		(ctx.PainPerSecond > 0)
  end
  
    

	local SPN = retr.SPN
	local SPId = retr.SPId
  local RETR_CMDS = {

		{RETR, SPELL, "blade-of-justice",							 	SPId.BladeOfJustice, 				retr.onBladeOfJustice},
		{RETR, SPELL, "blade-of-justice-heal",					SPId.BladeOfJustice, 				retr.onBladeOfJusticeHeal},
		{RETR, SPELL, "consecration", 									SPId.Consecration, 					retr.onConsecration, NoTarget=true},
		{RETR, SPELL, "consecration-heal", 							SPId.Consecration, 					retr.onConsecrationHeal, NoTarget=true},
		{RETR, SPELL, "crusader-strike", 								SPId.CrusaderStrike, 				retr.onCrusaderStrike},
		{RETR, SPELL, "crusader-strike-filler", 				SPId.CrusaderStrike, 				retr.OnCrusaderStrikeFiller},
		{RETR, SPELL, "crusader-strike-heal", 					SPId.CrusaderStrike, 				retr.onCrusaderStrikeHeal},
		{RETR, SPELL, "divine-storm", 									SPId.DivineStorm, 					retr.onDivineStorm},
		{RETR, SPELL, "divine-storm-hp5", 							SPId.DivineStorm, 					retr.onDivineStormHP5},
		{RETR, SPELL, "execution-sentence", 						SPId.ExecutionSentence, 		retr.onExecutionSentence},
		{RETR, SPELL, "hammer-of-wrath", 								SPId.HammerOfWrath, 				retr.onHammerOfWrath},
		{RETR, SPELL, "hammer-of-wrath-heal", 					SPId.HammerOfWrath, 				retr.onHammerOfWrathHeal},
		{RETR, SPELL, "inquisition", 										SPId.Inquisition, 					retr.onInquisition, NoTarget=true},
		{RETR, SPELL, "judgment", 											SPId.Judgment, 							retr.onJudgment},
		{RETR, SPELL, "judgment-debuff", 								SPId.Judgment, 							retr.onJudgmentDebuff},
		{RETR, SPELL, "judgment-heal", 									SPId.Judgment, 							retr.onJudgmentHeal},
    {RETR, SPELL, "justicars-vengeance",		    		SPId.JusticarsVengeance,		retr.onJusticarsVengeance},
		{RETR, SPELL, "templars-verdict", 							SPId.TemplarsVerdict, 			retr.onTemplarsVerdict},
		{RETR, SPELL, "templars-verdict-hp5", 					SPId.TemplarsVerdict, 			retr.onTemplarsVerdictHP5},
		{RETR, SPELL, "wake-of-ashes", 									SPId.WakeOfAshes, 					retr.onWakeOfAshes, RangeSpell=SPId.JusticarsVengeance},
		{RETR, SPELL, "wake-of-ashes-heal", 						SPId.WakeOfAshes, 					retr.onWakeOfAshesHeal, NoTarget=true},
	
     -- other dps spells
    {RETR, SPELL, "blinding-light",                 SPId.BlindingLight,         ON_COOLDOWN, RangeSpell=SPId.HammerOfJustice},
    {RETR, SPELL, "eye-for-an-eye",                 SPId.EyeForAnEye,           ON_COOLDOWN},

    -- pvp spells
		{RETR, SPELL, "hammer-of-justice", 							SPId.HammerOfJustice, 			retr.onHammerOfJustice},
		{RETR, SPELL, "hand-of-hindrance", 							SPId.HandOfHindrance, 			retr.onHandOfHindrance},
		
    
    -- healing
    {RETR, SPELL, "word-of-glory",                  SPId.WordOfGlory,           retr.onWordOfGlory, NoTarget = true},
    {RETR, SPELL, "divine-shield",                  SPId.DivineShield,          retr.onDivineShield, NoTarget = true},
    {RETR, SPELL, "lay-on-hands",                   SPId.LayOnHands,            retr.onLayOnHands, NoTarget = true},
    {RETR, SPELL, "justicars-vengeance-heal",		    SPId.JusticarsVengeance,		retr.onJusticarsVengeanceHeal},
    {RETR, SPELL, "shield-of-vengeance",            SPId.ShieldOfVengeance,     retr.onShieldOfVengeance, NoTarget = true},
    
    
    -- icon spells
    {RETR, SPELL, "avenging-wrath",                 SPId.AvengingWrath,         ON_COOLDOWN, NoTarget = true},
    {RETR, SPELL, "rebuke",                         SPId.Rebuke},
    {RETR, SPELL, "shield-of-vengeance-icon",       SPId.ShieldOfVengeance,     ON_COOLDOWN, NoTarget = true},


    --------------------------------------------------------------------------
    -- rotation
    --------------------------------------------------------------------------
    {RETR, PRIO, "divine-shield"},
    {RETR, PRIO, "lay-on-hands"},
    {RETR, PRIO, "word-of-glory"},
    {RETR, PRIO, "justicars-vengeance-heal"},
    {RETR, PRIO, "shield-of-vengeance"},
		{RETR, PRIO, "blade-of-justice-heal"},
		{RETR, PRIO, "judgment-heal"},
		{RETR, PRIO, "hammer-of-wrath-heal"},
		{RETR, PRIO, "consecration-heal"},
		{RETR, PRIO, "crusader-strike-heal"},
		{RETR, PRIO, "wake-of-ashes-heal"},

		{RETR, PRIO, "judgment-debuff"},
		{RETR, PRIO, "inquisition"},
		{RETR, PRIO, "divine-storm-hp5"},
		{RETR, PRIO, "execution-sentence"},
		{RETR, PRIO, "templars-verdict-hp5"},

		{RETR, PRIO, "wake-of-ashes"},
		{RETR, PRIO, "blade-of-justice"},
		{RETR, PRIO, "judgment"},
		{RETR, PRIO, "hammer-of-wrath"},
		{RETR, PRIO, "consecration"},
		
		{RETR, PRIO, "crusader-strike"},
		{RETR, PRIO, "hammer-of-justice"},
		{RETR, PRIO, "hand-of-hindrance"},
		{RETR, PRIO, "blinding-light"},
		{RETR, PRIO, "eye-for-an-eye"},
		
		{RETR, PRIO, "divine-storm"},
		{RETR, PRIO, "templars-verdict"},

		{RETR, PRIO, "crusader-strike-filler"},
    {RETR, AOE,  {}},

    --------------------------------------------------------------------------
    -- etc
    --------------------------------------------------------------------------

    {RETR, INIT, retr.Init},
    {RETR, COLS, 6},
    {RETR, ICON, SPELL,  "avenging-wrath",  format(L"Default cooldown (%s)", SPN.AvengingWrath)},
    {RETR, ICON, SPELL,  "shield-of-vengeance-icon", format(L"Alerts when %s is up", SPN.ShieldOfVengeance)},
    {RETR, ICON, BUFF,   {SPN.Retribution}, format(L"Alerts when %s is on", SPN.Retribution)},
    {RETR, ICON, BUFF,   {SPN.DivinePurpose}, format(L"Alerts when %s is on", SPN.DivinePurpose)},
    {RETR, ICON, BUFF, 	 {SPN.Inquisition}, format(L"Alerts when %s is on", SPN.Inquisition)},
    {RETR, ICON, BUFF, 	 {SPN.SelflessHealer}, format(L"Alerts when %s is on", SPN.SelflessHealer)},
    {RETR, INT,          "rebuke", SPN.Rebuke}
  }


	------------------------------------------------------------------------------
	-- PROTECTION
	------------------------------------------------------------------------------
	
  prot.SPId = {
    ArdentDefender             = 31850,
    AvengersShield             = 31935,
    AvengingWrath              = 31884,
		BastionOfLight						 = 204035,
		BlessedHammer							 = 204019,
    BlindingLight              = 115750,
    Consecration               = 26573,
		ConsecrationBuff					 = 188370,
		ConsecrationDebuff				 = 204242,
    DivineShield               = 642,
		FlashOfLight               = 19750,
		GuardianOfAncientKings     = 86659,
		HandOfHindrance						 = 183218,
		HandOfTheProtector         = 21652,
    HammerOfJustice            = 853,
    HammerOfTheRighteous       = 53595,
    Judgment                   = 20271,
		LayOnHands                 = 633,
		LightOfTheProtector        = 184092,
    Rebuke                     = 96231,
		Seraphin                   = 152262,
    ShieldOfTheRighteous       = 53600,
    ShieldOfTheRighteousBuff   = 132403,
    zz=0
  }

	prot.SPN = Main:CreateSpellNames(prot.SPId)
	
	prot.Init = function(this, Ctx)
		local SPN = prot.SPN
		local SPId = prot.SPId
		
    Ctx.MinMana= (Ctx.vars and Ctx.vars.MinMana) or .2
    Ctx.ManaPercent = UnitPower("player")/UnitPowerMax("player")
    Ctx.MinHealth = (Ctx.vars and Ctx.vars.MinHealth) or .3

    Ctx.LowHealth = Ctx.HealthPercent <= .5
		Ctx.MediumHealth = Ctx.HealthPercent <= .85


		Ctx.IsSpellBlessedHammer = IsPlayerSpell(SPId.BlessedHammer)
		Ctx.IsSpellHammerOfTheRightous = not Ctx.IsSpellBlessedHammer

		local s, e = Ctx:CheckBuff(SPN.ArdentDefender)
		Ctx.ArdentDefender =  e
		Ctx.ArdentDefenderUp = s > 0

		Ctx.ShieldOfTheRighteousCharges = Ctx:SpellCharges(SPN.ShieldOfTheRighteous)

		
		s, e = GetSpellCooldown(SPN.Consecration)
		if s ~= nil and s > 0 and (Ctx.ConsecrationTime == nil or Ctx.ConsecrationTime ~= s) then 
			Ctx.ConsecrationTime = s  
		end

		s, e = Ctx:CheckBuff(SPId.ConsecrationBuff)
		Ctx.ConsecrationUp = s > 0
		-- e is not reliable, check the last time we cast consecration instead
		Ctx.ConsecrationRemaining = (Ctx.ConsecrationTime ~= nil and Ctx.ConsecrationTime + 12 - Ctx.Now) or 0
		
		Ctx.AvengersShieldCooldown = Ctx:SpellCooldown(SPN.AvengersShield)
		
		_, Ctx.ShieldOfTheRighteous = Ctx:CheckBuff(SPN.ShieldOfTheRighteous)
		Ctx.ShieldOfTheRighteousUp = Ctx.ShieldOfTheRighteous

		Ctx.ConsecrationCooldown = Ctx:SpellCooldown(SPN.Consecration)
		Ctx.LightOfTheProtectorCooldown = Ctx:SpellCooldown(SPN.LightOfTheProtector)
		
		Ctx.HasTalentCrusadersJudgment = Ctx:HasTalent(2, 2)
		Ctx.JudgmentCharges = Ctx:SpellCharges(SPN.Judgment)
		
		Ctx.TargetIsClose = CheckInteractDistance("target", 3) or false
		Ctx.TargetHasConsecration = Ctx:CheckDebuff(SPId.ConsecrationDebuff)
		
		Ctx.TargetIsCasting = UnitCastingInfo("target") and true
	end


	prot.onArdentDefender = function(this, Ctx)
		return Ctx.LowHealth
	end

	prot.onBastionOfLight = function(this, Ctx)
		return Ctx.WeAreBeingAttacked and 
		(Ctx.HealthPercent <= .6) and 
		(Ctx.ShieldOfTheRighteousCharges == 0)
	end


	prot.onBlessedHammer = function(this, Ctx)
		return Ctx.IsSpellBlessedHammer
	end

	prot.onConsecration = function(this, Ctx)
    return not Ctx.ConsecrationUp 
			or (Ctx.TargetIsClose and not Ctx.TargetHasConsecration)
			or Ctx.ConsecrationRemaining < (Ctx.GCD*2)
		--[[
		local t = Ctx.onConsecrationDbg or 0
		if Ctx.Now - t > 1 then 
			print("Consecratio UP:", Ctx.ConsecrationUp)
			Ctx.onConsecrationDbg = Ctx.Now
		end
		]]
		--return not Ctx.ConsecrationUp
	end
	
	
	prot.onFlashOfLight = function(this, Ctx)
		return Ctx.HealthPercent < 0.3
	end

	prot.onGuardianOfAncientKings = function(this, Ctx)
		return Ctx.LowHealth
	end


	prot.onHammerOfJustice = function(this, Ctx)
		return Ctx.IsPvp 
	end


	prot.onHammerOfTheRighteous = function(this, Ctx)
  -- ensure hammer of the righteous exists (wow lua bug)
		return Ctx.IsSpellHammerOfTheRightous
	end

	prot.onJudgment = function(this, Ctx)
		return not Ctx.HasTalentCrusadersJudgment or 
		Ctx.JudgmentCharges >= 2 or
		(Ctx.AvengersShieldCooldown > Ctx.GCD * 3)
	end
	
	
	prot.onLayOnHands = function(this, Ctx)
		return Ctx.LowHealth and not Ctx.ArdentDefenderUp
	end


	prot.onLightOfTheProtector = function(this, Ctx)
		return Ctx.HealthPercent <= .8
	end


	prot.onShieldOfTheRighteous = function(this, Ctx)
  -- activates SotR if we are being damaged and we have more than 1 charge
  -- or if we are beeing beaten even if we have just one charge
		local inDamage = Ctx.WeAreBeingAttacked or Ctx.PainPerSecond > 0
		local healthDeclining = Ctx.HealthPercent < 0.9
		local betterUseThatCharge = Ctx.ShieldOfTheRighteousCharges >= 2 or Ctx.HealthPercent < 0.7
		return Ctx.TargetIsCasting or --if the target is casting something bad is coming
			(inDamage and healthDeclining and betterUseThatCharge)
	end

	prot.onShieldOfTheRighteousFiller = function(this, Ctx)
		return Ctx.ShieldOfTheRighteousCharges >= 2
	end

	SPN = prot.SPN
	SPId = prot.SPId
		
  local PROT_CMDS = {
    {PROT, SPELL, "ardent-defender",               SPN.ArdentDefender,          prot.onArdentDefender, NoRange = true},
    {PROT, SPELL, "avengers-shield",               SPN.AvengersShield,          ON_COOLDOWN},
    {PROT, SPELL, "avenging-wrath",                SPN.AvengingWrath,           ON_COOLDOWN, NoTarget= true},
    {PROT, SPELL, "blessed-hammer",                SPN.BlessedHammer,           prot.onBlessedHammer},
    {PROT, SPELL, "bastion-of-light",              SPN.BastionOfLight,          prot.onBastionOfLight, NoTarget = true, NoRange = true},
    {PROT, SPELL, "consecration",                  SPN.Consecration,            prot.onConsecration, NoTarget = true},
    {PROT, SPELL, "flash-of-light",                SPN.FlashOfLight,            prot.onFlashOfLight, NoRange = true, NoTarget = true, NoInstant=true, Tooltip="Low Health"},
    {PROT, SPELL, "guardian-of-ancient-kings",     SPN.GuardianOfAncientKings,  prot.onGuardianOfAncientKings, NoTarget = true, NoRange = true},
    {PROT, SPELL, "hand-of-the-protector",         SPN.HandOfTheProtector,      prot.onHandOfTheProtector, NoTarget = true, NoRange = true},
    {PROT, SPELL, "hammer-of-justice",             SPN.HammerOfJustice,         prot.onHammerOfJustice},
    {PROT, SPELL, "hammer-of-the-righteous",       SPN.HammerOfTheRighteous,    prot.onHammerOfTheRighteous},
    {PROT, SPELL, "judgment",                      SPN.Judgment,                prot.onJudgment},
    {PROT, SPELL, "light-of-the-protector",        SPN.LightOfTheProtector,     prot.onLightOfTheProtector, NoTarget = true, NoRange = true},
    {PROT, SPELL,  "lay-on-hands",                 SPN.LayOnHands,              prot.onLayOnHands, NoTarget=true, NoRange=true},
    {PROT, SPELL, "rebuke",                        SPN.Rebuke,                  ON_COOLDOWN},
    {PROT, SPELL, "shield-of-the-righteous",       SPN.ShieldOfTheRighteous,    prot.onShieldOfTheRighteous, NoTarget=true},
    {PROT, SPELL, "shield-of-the-righteous-filler", SPN.ShieldOfTheRighteous,   prot.onShieldOfTheRighteousFiller, NoTarget=true},

    --------------------------------------------------------------------------
    -- rotation
    --------------------------------------------------------------------------

    {PROT, PRIO, "ardent-defender"},
    {PROT, PRIO, "lay-on-hands"},
    {PROT, PRIO, "guardian-of-ancient-kings"},
    {PROT, PRIO, "light-of-the-protector"},
    {PROT, PRIO, "bastion-of-light"},
    {PROT, PRIO, "shield-of-the-righteous"},
    {PROT, PRIO, "flash-of-light"},
    {PROT, PRIO, "hammer-of-justice"},
    {PROT, PRIO, "consecration"},
    {PROT, PRIO, "judgment"},
    {PROT, PRIO, "avengers-shield"},
    {PROT, PRIO, "hammer-of-the-righteous"},
    {PROT, PRIO, "blessed-hammer"},
    {PROT, PRIO, "shield-of-the-righteous-filler"},

    {PROT, AOE, {}},

    --------------------------------------------------------------------------
    -- etc
    --------------------------------------------------------------------------

    {PROT, INIT,  prot.Init},
    --{PROT, VAR,   "MaxHealth", {Value = .3, MinValue = 0, MaxValue = 1, Description = format(L"Maximum health for %s", "[none]")}},
    {PROT, VAR,   "AoeMin",    0},
    {PROT, SLOT1, SPELL,       "avenging-wrath", format(L"%s cooldown", SPN.AvengingWrath)},
    {PROT, INT,                "rebuke", SPN.Rebuke}
  }

	
  function Main:GetEngine()
    return self:InitSpecs(
      Main.joinTables(
        {{HOLY, SKIP},{PROT, SKIP},{RETR, SKIP}},
        RETR_CMDS,
        PROT_CMDS
      )
    )
  end -- GetEngine

  Main.retr = retr
	Main.prot = prot
end
