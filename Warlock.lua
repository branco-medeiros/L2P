local addon_name, Main = ...

local function L(text)
  return (Main.Strings and Main.Strings[text]) or text
end

if select(2, UnitClass("player")) == 'WARLOCK' then
  local SPN = {
  -- Spell Names -> Localized Name
		ChaosBolt 						= GetSpellInfo(116858),
		Conflagrate 					= GetSpellInfo(17962),
		Corruption 						= GetSpellInfo(172),
		CurseOfEnfeeblement 	= GetSpellInfo(109466),
		CurseOfTheElements 		= GetSpellInfo(1490),
		DarkSoulInstability 	= GetSpellInfo(113858),
		DrainLife 						= GetSpellInfo(689),
		Fear 									= GetSpellInfo(5782),
		FelFlaem 							= GetSpellInfo(77799),
		FireAndBrimstone 			= GetSpellInfo(108683),
		Havoc 								= GetSpellInfo(80240),
		HealthFunnel 					= GetSpellInfo(755),
		HowlOfTerror 					= GetSpellInfo(5484),
		Immolate 							= GetSpellInfo(348),
		Incinerate 						= GetSpellInfo(29722),
		LifeTap 							= GetSpellInfo(1454),
		RainOfFire 						= GetSpellInfo(5740),
		ShadowBolt 						= GetSpellInfo(686),
		ShadowBurn 						= GetSpellInfo(17877),
		SiphonLife 						= GetSpellInfo(63106),
		TwilightWard 					= GetSpellInfo(6229),
    zz=0
  }


  local function Init(self, Ctx)
  -- Initializes the variables used by each condition
		Ctx.ManaPercent = UnitPower("player")/UnitPowerMax("player")
    Ctx.LowHealth = Ctx.HealthPercent < .3

  end

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

  local AFFL = "Affliction"
  local DEMO = "Demonology"
  local DEST = "Destruction"

  function Main:GetEngine()
    return self:InitSpecs(
      {AFFL, SKIP},
      {DEMO, SKIP},
      {DEST, SKIP},

      --------------------------------------------------------------------------
      -- RETRIBUTION
      --------------------------------------------------------------------------

			-- Example
      {RETR, SPELL, "aoe-crusader-strike",           SPN.CrusaderStrike, function(this, Ctx) return Ctx.SealOfTheRighteousOn end},
      {RETR, SPELL, "aoe-holy-prism",                SPN.HolyPrism},
      {RETR, SPELL, "aoe-lights-hammer",             SPN.LightsHammer, NoTarget = true, NoRange = true},
			{RETR, SPELL, "aoe-exorcism",                  SPN.Exorcism, function(this, Ctx) return Ctx.HasMassExorcism end},
      {RETR, SPELL, "avenging-wrath",                SPN.AvengingWrath, NoRange = true},
      {RETR, SPELL, "big-divine-storm",              SPN.DivineStorm, function(this, Ctx) return Ctx.HolyPower5 end, RangeSpell = SPN.HammerOfJustice},
      {RETR, SPELL, "big-templars-verdict",          SPN.TemplarsVerdict, function(this, Ctx) return Ctx.HolyPower5 end},
      {RETR, SPELL, "crusader-strike",               SPN.CrusaderStrike},
      {RETR, SPELL, "big-divine-crusade",            SPN.DivineStorm, function(this, Ctx) return Ctx.HasDivineCrusade and (Ctx.HolyPower == 5) end, RangeSpell = SPN.HammerOfJustice},
      {RETR, SPELL, "divine-crusade",                SPN.DivineStorm, function(this, Ctx) return Ctx.HasDivineCrusade and (Ctx.HolyPower < 5) end, RangeSpell = SPN.HammerOfJustice},
      {RETR, SPELL, "divine-storm",                  SPN.DivineStorm, function(this, Ctx) return Ctx.HolyPower3 end, RangeSpell = SPN.HammerOfJustice},
      {RETR, SPELL, "execution-sentence",            SPN.ExecutionSentence, NoRange = true, function(this, Ctx) return Ctx.IsBossFight or Ctx.HealthPercent < .7 end},
      {RETR, SPELL, "big-exorcism",                  SPN.Exorcism, function(this, Ctx) return Ctx.HasWarriorOfTheLight end},
      {RETR, SPELL, "exorcism",                      SPN.Exorcism},
      {RETR, SPELL, "guardian-of-the-ancient-kings", SPN.GuardianOfTheAncientKings, NoRange = true,  NoTarget = true},
      {RETR, SPELL, "hammer-of-the-righteous",       SPN.HammerOfTheRighteous},
      {RETR, SPELL, "hammer-of-wrath",               SPN.HammerOfWrath},
      {RETR, SPELL, "harsh-word-of-glory",           SPN.WordOfGlory, function(this, Ctx) return IsHarmfulSpell(SPN.WordOfGlory) and Ctx.HolyPower3 end},
      {RETR, SPELL, "holy-prism",                    SPN.HolyPrism, function(this, Ctx) return Ctx.IsBossFight or Ctx.HealthPercent < .7 end},
      {RETR, SPELL, "inquisition",                   SPN.Inquisition, function(this, Ctx) return Ctx.NeedInquisition end,  NoRange = true, NoTarget = true},
      {RETR, SPELL, "judgement",                     SPN.Judgement},
      {RETR, SPELL, "lights-hammer",                 SPN.LightsHammer, NoTarget = true, NoRange = true, function(this, Ctx) return Ctx.IsBossFight or Ctx.HealthPercent < .7 end},
      {RETR, SPELL, "rebuke",                        SPN.Rebuke},
      {RETR, SPELL, "sacred-shield",                 SPN.SacredShield, NoTarget = true, NoRange = true, function(this, Ctx) return not Ctx.HasSacredShield end},
      {RETR, SPELL, "templars-verdict",              SPN.TemplarsVerdict, function(this, Ctx) return Ctx.HolyPower3 end},
      {RETR, SPELL, "word-of-glory",                 SPN.WordOfGlory, function(this, Ctx) return Ctx.LowHealth and Ctx.AnyHolyPower end, NoRange = true, NoTarget = true},

      --------------------------------------------------------------------------
      -- rotation
      --------------------------------------------------------------------------

      {RETR, PRIO, {"word-of-glory", "inquisition", "lights-hammer", "holy-prism", "execution-sentence", "big-divine-crusade", "big-templars-verdict", "big-exorcism", "hammer-of-wrath", "divine-crusade", "crusader-strike", "judgement", "exorcism", "templars-verdict", "harsh-word-of-glory", "sacred-shield"}},
      {RETR, AOE,  {"word-of-glory", "inquisition", "big-divine-crusade", "big-divine-storm", "execution-sentence", "aoe-lights-hammer", "aoe-holy-prism", "aoe-exorcism", "big-exorcism",  "hammer-of-wrath", "divine-crusade", "aoe-crusader-strike", "hammer-of-the-righteous", "judgement", "exorcism", "divine-storm", "harsh-word-of-glory", "sacred-shield"}},

      --------------------------------------------------------------------------
      -- etc
      --------------------------------------------------------------------------

      {RETR, INIT, Init},
      {RETR, VAR, "AoeMin", 2},
      {RETR, SLOT1, AURA,   {SPN.SealOfTruth, SPN.SealOfRightousness, SPN.SealOfJustice, SPN.SealOfInsight}, format(L"Active Seal. Prefer %s", SPN.SealOfTruth)},
      {RETR, SLOT2, SPELL,  "guardian-of-the-ancient-kings", SPN.GuardianOfTheAncientKings},
      {RETR, SLOT3, SPELL,  "avenging-wrath", SPN.AvengingWrath},
      {RETR, SLOT4, BUFF,   {SPN.RighteousFury}, format(L"Alerts when %s is on", SPN.RighteousFury)},
      {RETR, SLOT5, BUFF,   {SPN.DivineCrusade}, format(L"Alerts when %s is on", SPN.DivineCrusade)},
      {RETR, INT,           "rebuke", SPN.Rebuke}


    )

  end
end
