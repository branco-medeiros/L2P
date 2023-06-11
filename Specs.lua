local L2P = LibStub("AceAddon-3.0"):GetAddon("L2P")
function L2P:GetSpecData(ctx) 
  if not ctx.vars.Spec then 
    return {}
  
  elseif ctx.vars.Spec == "DEATH-KNIGHT-1" then
    return {
      SPI = {
        Animosity = 375797,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChargedBlast = 370455,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        EmpyreanLegacy = 387170,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EverburningFlame = 370819,
        FeedTheFlames = 369846,
        Fireblood = 265221,
        FontOfMagic = 375783,
        HolyBlade = 383342,
        JusticarSVengeance = 215661,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        RubyEmbers = 365937,
        Scintillation = 370821,
        Snapfire = 370783,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        VanguardSMomentum = 383314,
        Volatility = 369089,
      },

      prios = {
      },

      slots={
      },

      code={
      }
    }

  elseif ctx.vars.Spec == "MAGE-1" then
    return {
      SPI = {
        Animosity = 375797,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChargedBlast = 370455,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        EmpyreanLegacy = 387170,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EverburningFlame = 370819,
        FeedTheFlames = 369846,
        Fireblood = 265221,
        FontOfMagic = 375783,
        HolyBlade = 383342,
        JusticarSVengeance = 215661,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        RubyEmbers = 365937,
        Scintillation = 370821,
        Snapfire = 370783,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        VanguardSMomentum = 383314,
        Volatility = 369089,
      },

      prios = {
      },

      slots={
      },

      code={
      }
    }

  elseif ctx.vars.Spec == "MAGE-2" then
    return {
      SPI = {
        Animosity = 375797,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChargedBlast = 370455,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        EmpyreanLegacy = 387170,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EverburningFlame = 370819,
        FeedTheFlames = 369846,
        Fireblood = 265221,
        FontOfMagic = 375783,
        HolyBlade = 383342,
        JusticarSVengeance = 215661,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        RubyEmbers = 365937,
        Scintillation = 370821,
        Snapfire = 370783,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        VanguardSMomentum = 383314,
        Volatility = 369089,
      },

      prios = {
      },

      slots={
      },

      code={
      }
    }

  elseif ctx.vars.Spec == "PALADIN-6" then
    return {
      SPI = {
        Animosity = 375797,
        ArcaneTorrent = 155145,
        AshenHallow = 316958,
        AvengingWrath = 31884,
        BladeOfJustice = 184575,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BlessingOfAutumn = 328622,
        BlessingOfSpring = 328282,
        BlessingOfSummer = 328620,
        BlessingOfWinter = 328281,
        BlindingLight = 115750,
        BloodOfTheEnemy = 297108,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChargedBlast = 370455,
        ConcentratedFlame = 295373,
        Consecration = 26573,
        ConsecrationDebuff = 204242,
        Crusade = 231895,
        CrusaderStrike = 35395,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivinePurpose = 223817,
        DivinePurposeBuff = 223819,
        DivineResonance = 384027,
        DivineShield = 642,
        DivineStorm = 53385,
        DivineToll = 304971,
        EmpyreanLegacy = 387170,
        EmpyreanPower = 326733,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EverburningFlame = 370819,
        ExecutionSentence = 343527,
        Exorcism = 383185,
        FeedTheFlames = 369846,
        FinalReckoning = 343721,
        Fireblood = 265221,
        FiresOfJusticeBuff = 203316,
        FlashOfLight = 19750,
        FocusedAzeriteBeam = 299336,
        FontOfMagic = 375783,
        GuardianOfAzeroth = 299358,
        HammerOfJustice = 853,
        HammerOfWrath = 24275,
        HandOfHindrance = 183218,
        HolyAvenger = 105809,
        HolyBlade = 383342,
        Judgment = 20271,
        JusticarSVengeance = 215661,
        LayOnHands = 633,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        MemoryOfLucidDreams = 299374,
        PurifyingBlast = 299347,
        RadiantDecree = 384052,
        Rebuke = 96231,
        Reckoning = 247676,
        RubyEmbers = 365937,
        Scintillation = 370821,
        SelflessHealer = 114250,
        Seraphim = 152262,
        ShieldOfTheRighteous = 53600,
        ShieldOfVengeance = 184662,
        Snapfire = 370783,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        TheUnboundForce = 298452,
        VanguardSMomentum = 383314,
        VanquisherSHammer = 328204,
        VisionOfPerfection = 303344,
        Volatility = 369089,
        WakeOfAshes = 255937,
        WordOfGlory = 85673,
      },

      prios = {
        {Key="divine-shield", SpellId=642, Role={ "survival","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow and
            ctx.vars.IsBeingDamaged
          end
        },

        {Key="lay-on-hands", SpellId=633, Role={ "survival","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical
          end
        },

        {Key="shield-of-vengeance", SpellId=184662, Role={ "survival","dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow and 
            ctx.vars.IsBeingDamaged
          end
        },

        {Key="flash-of-light-free", SpellId=19750, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium and 
            ctx.vars.SelflessHealerMaxStack
          end
        },

        {Key="word-of-glory", SpellId=85673, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow
          end
        },

        {Key="justicars-vengeance-heal", SpellId=215661, Role={ "dps","spender","heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
          end
        },

        {Key="flash-of-light", SpellId=19750, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow
          end
        },

        {Key="empyrean-divine-storm", SpellId=53385, Role={ "dps","spender", },
          Description="",
          RangeSpell=85256, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.EmpyreanPowerActive
          end
        },

        {Key="shield-of-vengeance-dps", SpellId=184662, Role={ "dps","survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
            and ctx.vars.NotHpTime
          end
        },

        {Key="seraphim", SpellId=152262, Role={ "preparation","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.SeraphimActive
          end
        },

        {Key="holy-avenger", SpellId=105809, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
          end
        },

        {Key="final-reckoning", SpellId=343721, Role={ "preparation","dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="execution-sentence", SpellId=343527, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBossFight or 
            (ctx.vars.IsDangerousFight and ctx.vars.TargetNotDying)
          end
        },

        {Key="radiant-decree", SpellId=384052, Role={ "spender","dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="shield-of-the-righteous", SpellId=53600, Role={ "dps","spender", },
          Description="",
          RangeSpell=85256, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasShieldsEquipped
          end
        },

        {Key="divine-storm", SpellId=53385, Role={ "dps","spender", },
          Description="",
          RangeSpell=85256, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.MultipleTargets and 
            (ctx.vars.Has5HP or 
              ctx.vars.WingsOn or
              ctx.vars.HolyAvengerActive or
              ctx.vars.DivinePurposeActive or
              ctx.vars.FiresOfJusticeActive
            )
            
          end
        },

        {Key="templars-verdict", SpellId=85256, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.Has5HP or 
            ctx.vars.WingsOn or
            ctx.vars.HolyAvengerActive or
            ctx.vars.DivinePurposeActive or
            ctx.vars.FiresOfJusticeActive
            
          end
        },

        {Key="consecration", SpellId=26573, Role={ "hinder", },
          Description="",
          RangeSpell=184575, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsNotMoving 
            and ctx.vars.NeedsConsecration
          end
        },

        {Key="divine-toll-aoe", SpellId=304971, Role={ "dps","generator", },
          Description="",
          RangeSpell=85256, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.MultipleTargets and 
            ctx.vars.CanUseTargetBasedHPGenerator
          end
        },

        {Key="wake-of-ashes", SpellId=255937, Role={ "dps","generator", },
          Description="",
          RangeSpell=184575, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanUse3HPGenerator
            
          end
        },

        {Key="judgment", SpellId=20271, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanUse1HPGenerator
            
          end
        },

        {Key="blade-of-justice", SpellId=184575, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanUse2HPGenerator
            
          end
        },

        {Key="hammer-of-wrath", SpellId=24275, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanUse1HPGenerator
            
          end
        },

        {Key="crusader-strike", SpellId=35395, Role={ "dps","generator", },
          Description="",
          RangeSpell=85256, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanUse1HPGenerator
            
          end
        },

        {Key="divine-toll", SpellId=304971, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanUseTargetBasedHPGenerator
          end
        },

        {Key="exorcism", SpellId=383185, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.NotHpTime
          end
        },

        {Key="divine-storm-3hp", SpellId=53385, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.MultipleTargets
          end
        },

        {Key="templars-verdict-3hp", SpellId=85256, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="hammer-of-justice", SpellId=853, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsPvp or (not ctx.vars.IsBossFight and ctx.vars.TargetIsMoving)
          end
        },

        {Key="hand-of-hindrance", SpellId=183218, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsPvp or
            (not ctx.vars.IsBossFight and ctx.vars.TargetIsMoving)
          end
        },

        {Key="blinding-light", SpellId=115750, Role={  },
          Description="",
          RangeSpell=35395, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.NotHpTime
          end
        },

        {Key="word-of-glory-filler", SpellId=85673, Role={ "heal","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=true,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium and ctx.vars.NotHpTime
          end
        },

        {Key="interrupt", SpellId=96231, Role={ "interrupt", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="avenging-wrath-monitor", SpellId=31884, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="shiled-of-vengeance-monitor", SpellId=184662, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

      },

      slots={
        {Type="spell", Spell=31884, 
          Description="Default cooldown (%s)",
          Icon="", Overlay=false, Charges=false
        },
        {Type="spell", Spell=184662, 
          Description="Alerts when %s is up",
          Icon="", Overlay=false, Charges=false
        },
        {Type="buff", Spell=223817, 
          Description="Alerts when %s is on",
          Icon="", Overlay=false, Charges=false
        },
        {Type="buff", Spell=114250, 
          Description="Flash of Light has reduced cost",
          Icon="", Overlay=false, Charges=true
        },
      },

      code={
        IsAoe=function(ctx)
          return ctx.vars.Targets > 1
        end,

        LastConsecrationTime=function(ctx)
          return (
            ctx.vars.LastCastSpell == ctx.SPI.Consecration and 
            ctx.vars.LastCastTime
          ) or ctx.vars.LastConsecrationTime or 0
        end,

        WingsOn=function(ctx)
          return ctx:GetBuff(ctx.SPI.AvengingWrath).active
          or ctx:GetBuff(ctx.SPI.Crusade).active
        end,

        FinalReckoningActive=function(ctx)
          return ctx:GetDebuff(ctx.SPI.Reckoning).active or 
          ctx:GetDebuff(ctx.SPI.FinalReckoning).active
        end,

        ExecutionSentenceActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.ExecutionSentence).active
        end,

        EmpyreanPowerActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.EmpyreanPower).active
        end,

        HolyAvengerActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.HolyAvenger).active
        end,

        DivinePurposeActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.DivinePurposeBuff).active
        end,

        ConsecrationActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.Consecration).active
        end,

        FiresOfJusticeActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.FiresOfJusticeBuff).active
        end,

        SeraphimActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.Seraphim).active
        end,

        NeedsConsecration=function(ctx)
          return (ctx.vars.Now - (ctx.vars.LastConsecrationTime or 0)) >= 11.5
        end,

        HPMultiplier=function(ctx)
          return (ctx.vars.HolyAvengerActive and 3) or 1
        end,

        NotHpTime=function(ctx)
          return not (
            ctx.vars.Has5HP or 
            ctx.vars.WingsOn or
            ctx.vars.HolyAvengerActive or
            ctx.vars.DivinePurposeActive or
            ctx.vars.FiresOfJusticeActive
          )
        end,

        Has5HP=function(ctx)
          return ctx.vars.HolyPower == 5
        end,

        IsNotMoving=function(ctx)
          return not ctx.vars.IsMoving
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthChangingRate < 0
        end,

        MultipleTargets=function(ctx)
          return ctx.vars.Targets > 1
        end,

        HealthIsCritical=function(ctx)
          return ctx.vars.HealthPercent <= 0.2
        end,

        SelflessHealerMaxStack=function(ctx)
          return ctx:GetBuff(ctx.SPI.SelflessHealer).charges > 3
        end,

        TargetNotDying=function(ctx)
          return ctx.vars.TargetHealthPercent >= 0.3
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent <= 0.8
        end,

        MultipleAttackers=function(ctx)
          return ctx.vars.Attackers > 1 or ctx.vars.Targets > 2
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent <= 0.4
        end,

        HasShieldsEquipped=function(ctx)
          return IsEquippedItemType("Shields")
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsBossFight
          or ctx.vars.IsPvp
          or (ctx.vars.IsAoe 
            and ctx.vars.HealthRate < 0 
            and ctx.vars.HealthPercent < 0.7)
          or (ctx.vars.HealthPercent < 0.5 
            and ctx.vars.HealthRate < 0)
        end,

        CanUse1HPGenerator=function(ctx)
          return (
            ctx.vars.HolyPower + 
            (1 * ctx.vars.HPMultiplier)
          ) < 6
        end,

        CanUse2HPGenerator=function(ctx)
          return (
            ctx.vars.HolyPower + 
            (2 * ctx.vars.HPMultiplier)
          ) < 6
        end,

        CanUse3HPGenerator=function(ctx)
          return (
            ctx.vars.HolyPower + 
            (3 * ctx.vars.HPMultiplier)
          ) < 6
        end,

        CanUseTargetBasedHPGenerator=function(ctx)
          return (
            ctx.vars.HolyPower + 
            (min(5, ctx.vars.Targets) * ctx.vars.HPMultiplier)
          ) < 6
        end,

      }
    }

  elseif ctx.vars.Spec == "PALADIN-2" then
    return {
      SPI = {
        Animosity = 375797,
        ArcaneTorrent = 155145,
        ArdentDefender = 31850,
        AshenHallow = 316958,
        AvengerSShield = 31935,
        AvengingWrath = 31884,
        BastionOfLight = 378974,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BlessedHammer = 204019,
        BlessingOfSummer = 328620,
        BloodOfTheEnemy = 297108,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChargedBlast = 370455,
        ConcentratedFlame = 295373,
        Consecration = 26573,
        ConsecrationBuff = 188370,
        ConsecrationDebuff = 204242,
        Crusade = 231895,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivinePurpose = 223817,
        DivineResonance = 384027,
        DivineShield = 642,
        DivineToll = 304971,
        EmpyreanLegacy = 387170,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EverburningFlame = 370819,
        ExecutionSentence = 343527,
        EyeOfTyr = 387174,
        FeedTheFlames = 369846,
        Fireblood = 265221,
        FlashOfLight = 19750,
        FocusedAzeriteBeam = 299336,
        FontOfMagic = 375783,
        GuardianOfAncientKings = 86659,
        GuardianOfAzeroth = 299358,
        HammerOfJustice = 853,
        HammerOfTheRighteous = 53595,
        HammerOfWrath = 24275,
        HandOfHindrance = 183218,
        HolyAvenger = 105809,
        HolyBlade = 383342,
        Judgment = 20271,
        Judgment_bad = 275779,
        JusticarSVengeance = 215661,
        LayOnHands = 633,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        MemoryOfLucidDreams = 299374,
        MomentOfGlory = 327193,
        PurifyingBlast = 299347,
        Rebuke = 96231,
        RubyEmbers = 365937,
        SanctifiedWrath = 171648,
        Scintillation = 370821,
        SentinelBuff = 389539,
        Seraphim = 152262,
        ShieldOfTheRighteous = 53600,
        ShiningLight = 321136,
        Snapfire = 370783,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        VanguardSMomentum = 383314,
        VanquisherSHammer = 328204,
        Volatility = 369089,
        WakeOfAshes = 255937,
        WordOfGlory = 85673,
      },

      prios = {
        {Key="avengers-shield-taunt", SpellId=31935, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.NotInCombat
          end
        },

        {Key="lay-on-hands", SpellId=633, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=true, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="divine-shield", SpellId=642, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=true, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical 
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="ardent-defender", SpellId=31850, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsAlmostCritical 
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="guardian-of-ancient-kings", SpellId=86659, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow and 
              ctx.vars.IsBeingDamaged
          end
        },

        {Key="word-of-glory", SpellId=85673, Role={ "heal","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="holy-avenger", SpellId=105809, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
          end
        },

        {Key="bastion-shield-of-the-righteous", SpellId=53600, Role={ "dps","spender", },
          Description="",
          RangeSpell=53595, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BastionOfLightActive
          end
        },

        {Key="moment-of-glory", SpellId=327193, Role={ "dps","survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
          end
        },

        {Key="bastion-of-light", SpellId=378974, Role={ "cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="divine-toll", SpellId=304971, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="shield-of-the-righteous-5hp", SpellId=53600, Role={ "dps","spender", },
          Description="",
          RangeSpell=53595, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.Has5Hp or
              ctx.vars.WingsOn or
              ctx.vars.DivinePurposeActive or
              ctx.vars.HolyAvengerActive or
              ctx.vars.SentinelActive
          end
        },

        {Key="word-of-glory-free", SpellId=85673, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsNotFull and 
              ctx.vars.ShiningLightActive
          end
        },

        {Key="consecration", SpellId=26573, Role={ "preparation", },
          Description="",
          RangeSpell=53595, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.NeedsConsecration and
              ctx.vars.IsNotMoving
          end
        },

        {Key="avengers-shield-multitarget", SpellId=31935, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="judgment-2HP", SpellId=275779, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.WingsOn 
            and ctx.vars.HasTalentSanctifiedWrath
            and ctx.vars.CanUse2HPGenerator 
          end
        },

        {Key="judgment-1HP", SpellId=275779, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not (ctx.vars.WingsOn 
            and ctx.vars.HasTalentSanctifiedWrath) 
            and ctx.vars.CanUse1HPGenerator 
          end
        },

        {Key="hammer-of-wrath", SpellId=24275, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanUse1HPGenerator
          end
        },

        {Key="hammer-of-the-righteous", SpellId=53595, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanUse1HPGenerator
          end
        },

        {Key="blessed-hammer", SpellId=204019, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanUse1HPGenerator
          end
        },

        {Key="eye-of-tyr", SpellId=387174, Role={ "dps","hinder", },
          Description="",
          RangeSpell=53595, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="consecration-filler", SpellId=26573, Role={ "preparation", },
          Description="",
          RangeSpell=53595, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=true,
          Condition=function(this, ctx)
            return ctx.vars.IsNotMoving
          end
        },

        {Key="hammer-of-justice", SpellId=853, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsPvp
          end
        },

        {Key="hand-of-hindrance", SpellId=183218, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsPvp
          end
        },

        {Key="rebuke", SpellId=96231, Role={ "interrupt", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="avenging-wrath", SpellId=31884, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

      },

      slots={
        {Type="spell", Spell=31884, 
          Description="Default cooldown",
          Icon="", Overlay=false, Charges=false
        },
      },

      code={
        IsAoe=function(ctx)
          return ctx.vars.Targets > 1
        end,

        LastConsecrationTime=function(ctx)
          return (ctx.vars.LastCastSpell == ctx.SPI.Consecration 
          and ctx.vars.LastCastTime) 
          or ctx.vars.LastConsecrationTime 
          or 0
        end,

        AvengingWrathActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.AvengingWrath).active
        end,

        DivinePurposeActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.DivinePurpose).active
        end,

        HolyAvengerActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.HolyAvenger).active
        end,

        ShiningLightActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.ShiningLight).active
        end,

        SentinelActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.SentinelBuff).active
        end,

        BastionOfLightActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.BastionOfLight).active
        end,

        HasTalentSanctifiedWrath=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.SanctifiedWrath)
        end,

        HPMultiplier=function(ctx)
          return (ctx.vars.HolyAvengerActive and 3) or 1
        end,

        HealthIsCritical=function(ctx)
          return ctx.vars.HealthPercent <= 0.2
        end,

        HealthIsAlmostCritical=function(ctx)
          return ctx.vars.HealthPercent <= 0.3
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent < 0.4
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent <= 0.65
        end,

        HealthIsNotFull=function(ctx)
          return ctx.vars.HealthPercent <= 0.75
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthRate < 0
        end,

        IsNotMoving=function(ctx)
          return not ctx.vars.IsMoving
        end,

        Has5Hp=function(ctx)
          return ctx.vars.HolyPower == 5
        end,

        NotInCombat=function(ctx)
          return not UnitAffectingCombat("player")
        end,

        NeedsConsecration=function(ctx)
          return (ctx.vars.Now - (ctx.vars.LastConsecrationTime or 0)) > 13.5
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsBossFight
          or ctx.vars.IsPvp
          or (ctx.vars.IsAoe
            and ctx.vars.HealthPercent < 0.7 
            and ctx.vars.HealthRate < 0 )
          or (ctx.vars.Targets == 1 
            and ctx.vars.HealthPercent < 0.5 
            and ctx.vars.HealthRate < 0)
        end,

        CanUse1HPGenerator=function(ctx)
          return (ctx.vars.HolyPower +
          (1 * ctx.vars.HPMultiplier)) < 6 
        end,

        CanUse2HPGenerator=function(ctx)
          return (ctx.vars.HolyPower +
          (2 * ctx.vars.HPMultiplier)) < 6 
        end,

        CanUseTargetBasedHPGenerator=function(ctx)
          return (ctx.vars.HolyPower +
          (min(ctx.vars.Targets, 5) * ctx.vars.HPMultiplier)) < 6 
        end,

        WingsOn=function(ctx)
          return ctx.vars.AvengingWrathActive 
          or ctx.vars.SentinelActive
        end,

      }
    }

  elseif ctx.vars.Spec == "WARRIOR-1" then
    return {
      SPI = {
        AncientAftershock = 325886,
        Animosity = 375797,
        Avatar = 107574,
        BitterImmunity = 383762,
        BlademastersTormentTalent = 390138,
        Bladestorm = 227847,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BloodAndThunderTalent = 384277,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChargedBlast = 370455,
        Cleave = 845,
        ColossusSmash = 167105,
        ColossusSmashDebuff = 208086,
        Condemn = 317349,
        ConquerorSBanner = 324143,
        DeadlyCalm = 262228,
        DeepWounds = 262115,
        DefensiveStance = 197690,
        DieByTheSword = 118038,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        EmpyreanLegacy = 387170,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EverburningFlame = 370819,
        Execute = 163201,
        ExecutionersPrecisionTalent = 386634,
        FeedTheFlames = 369846,
        FervorOfBattleTalent = 202316,
        Fireblood = 265221,
        FocusedAzeriteBeam = 299336,
        FontOfMagic = 375783,
        GuardianOfAzeroth = 299358,
        Hamstring = 1715,
        HolyBlade = 383342,
        IgnorePain = 190456,
        ImpendingVictory = 202168,
        InForTheKill = 248622,
        IntimidatingShout = 5246,
        JusticarSVengeance = 215661,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        MemoryOfLucidDreams = 299374,
        MortalStrike = 12294,
        Overpower = 7384,
        Pummel = 6552,
        PurifyingBlast = 299347,
        RendArms = 772,
        RendDebuff = 388539,
        RubyEmbers = 365937,
        Scintillation = 370821,
        Skullsplitter = 260643,
        Slam = 1464,
        Snapfire = 370783,
        SpearOfBastion = 376079,
        SpearOfBastionOld = 307865,
        StormBolt = 107570,
        SweepingStrikes = 260708,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        ThunderClap = 6343,
        ThunderClapArms = 396719,
        ThunderousRoar = 384318,
        TideOfBloodTalent = 386357,
        VanguardSMomentum = 383314,
        VictoryRush = 34428,
        Volatility = 369089,
        Warbreaker = 262161,
        Whirlwind = 1680,
      },

      prios = {
        {Key="bitter-immunity", SpellId=383762, Role={ "survival","heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical
          end
        },

        {Key="impending-victory", SpellId=202168, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
          end
        },

        {Key="victory-rush", SpellId=34428, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
          end
        },

        {Key="die-by-the-sword", SpellId=118038, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="defensive-stance", SpellId=197690, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.DefensiveStanceOff
              and (ctx.vars.HealthIsLow
              or ctx.vars.TargetedByBoss)
          end
        },

        {Key="intimidating-shout", SpellId=5246, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow
              and not ctx.vars.IsBossFight
              and ctx.vars.IsAoe
          end
        },

        {Key="thunder-clap", SpellId=396719, Role={ "dps","generator", },
          Description="",
          RangeSpell=12294, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.RendDebuffExpiring and ctx.vars.IsAoe
          end
        },

        {Key="rend", SpellId=772, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.RendDebuffExpiring
          end
        },

        {Key="avatar", SpellId=107574, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
            and (ctx.vars.ColossusSmashEnabled
              or ctx.vars.WarbreakerEnabled)
          end
        },

        {Key="warbreaker", SpellId=262161, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="colossus-smash", SpellId=167105, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="spear-of-bastion", SpellId=376079, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasDebuffColossusSmash
          end
        },

        {Key="skullsplitter", SpellId=260643, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasDebuffColossusSmash
          end
        },

        {Key="cleave-urgent", SpellId=845, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsAoe
              and (ctx.vars.DeepWoundsExpiring
              or ctx.vars.HasBuffOverpower)
          end
        },

        {Key="sweeping-strikes", SpellId=260708, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsAoe
          end
        },

        {Key="ancient-aftershock", SpellId=325886, Role={ "dps", },
          Description="",
          RangeSpell=12294, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasDebuffColossusSmash
          end
        },

        {Key="thunderous-roar-in-for-the-kill", SpellId=384318, Role={ "dps", },
          Description="",
          RangeSpell=12294, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasBuffInForTheKill
          end
        },

        {Key="mortal-strike-deep-wounds", SpellId=12294, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.DeepWoundsExpiring
          end
        },

        {Key="mortal-strike-executioners-precision", SpellId=12294, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasExecutionersPrecision
          end
        },

        {Key="execute", SpellId=163201, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="overpower", SpellId=7384, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="storm-bolt-stun", SpellId=107570, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsPvp
              or ctx.vars.HasManyEnemies
              or (not ctx.vars.IsBossFight and 
                ctx.vars.HealthIsLow)
          end
        },

        {Key="mortal-strike", SpellId=12294, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="bladestorm", SpellId=227847, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBossFight
              or ctx.vars.HasManyEnemies
              or ctx.vars.HasDebuffColossusSmash
          end
        },

        {Key="whirlwind", SpellId=1680, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsAoe
              or ctx.vars.HasTalentFervorOfTheBattle
          end
        },

        {Key="cleave", SpellId=845, Role={ "dps","spender", },
          Description="",
          RangeSpell=12294, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsAoe
          end
        },

        {Key="slam", SpellId=1464, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="storm-bolt", SpellId=107570, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="hamstring", SpellId=1715, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="pummel", SpellId=6552, Role={ "interrupt", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="victory-rush-filler", SpellId=34428, Role={ "filler", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="avatar-slot", SpellId=107574, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

      },

      slots={
        {Type="spell", Spell=107574, 
          Description="",
          Icon="", Overlay=false, Charges=false
        },
      },

      code={
        HasTalentFervorOfTheBattle=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.FervorOfBattleTalent)
        end,

        HasExecutionersPrecision=function(ctx)
          return ctx:GetDebuff(ctx.SPI.ExecutionersPrecisionTalent).active
        end,

        HasDebuffColossusSmash=function(ctx)
          return ctx:GetDebuff(ctx.SPI.ColossusSmashDebuff).active
        end,

        HasBuffOverpower=function(ctx)
          return ctx:GetBuff(ctx.SPI.Overpower).active
        end,

        HasBuffInForTheKill=function(ctx)
          return ctx:GetBuff(ctx.SPI.InForTheKill).remaining > 0.5
        end,

        DeepWoundsExpiring=function(ctx)
          return ctx:GetDebuff(ctx.SPI.DeepWounds).remaining < 4
        end,

        ColossusSmashEnabled=function(ctx)
          return ctx:GetSpell(ctx.SPI.ColossusSmash).cooldown < ctx.vars.GCD
        end,

        RendDebuffExpiring=function(ctx)
          return ctx:GetDebuff(ctx.SPI.RendDebuff).remaining < 4
        end,

        WarbreakerEnabled=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Warbreaker) 
          and ctx:GetSpell(ctx.SPI.Warbreaker).cooldown < ctx.vars.GCD
        end,

        HealthIsCritical=function(ctx)
          return ctx.vars.HealthPercent < 0.3
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent < 0.45
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent <= 0.7
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthRate < 0
        end,

        HasManyEnemies=function(ctx)
          return ctx.vars.Targets > 3 or ctx.vars.Attackers > 3
        end,

        RageCanGrow20=function(ctx)
          return (ctx.vars.Rage + 20) <= ctx.vars.RageMax
        end,

        IsAoe=function(ctx)
          return ctx.vars.Targets > 1 or ctx.vars.Attackers> 1
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsBossFight
          or ctx.vars.IsPvp
          or ctx.vars.Attackers > 3 
          or ctx.vars.Targets > 3
          or ctx.vars.HealthPercent <= 0.6
        end,

        DefensiveStanceOff=function(ctx)
          return not ctx:GetBuff(ctx.SPI.DefensiveStance).active
        end,

        TargetedByBoss=function(ctx)
          return ctx.vars.IsBossFight 
          and UnitIsUnit("boss1target", "player")
        end,

      }
    }

  elseif ctx.vars.Spec == "DEMONHUNTER-1" then
    return {
      SPI = {
        Animosity = 375797,
        Annihilation = 201427,
        BladeDance = 188499,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        Blur = 198589,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChaosNova = 179057,
        ChaosStrike = 162794,
        ChargedBlast = 370455,
        ConsumeMagic = 278326,
        Darkness = 196718,
        DeathSweep = 210152,
        DemonBlades = 203555,
        DemonSBite = 162243,
        Disrupt = 183752,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        ElysianDecree = 390163,
        EmpyreanLegacy = 387170,
        EssenceBreak = 258860,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EverburningFlame = 370819,
        EyeBeam = 198013,
        FeedTheFlames = 369846,
        FelBarrage = 258925,
        Felblade = 232893,
        FelRush = 195072,
        Fireblood = 265221,
        FirstBlood = 206416,
        FodderToTheFlame = 329554,
        FontOfMagic = 375783,
        GlaiveTempest = 342817,
        HolyBlade = 383342,
        ImmolationAura = 258920,
        Initiative = 391215,
        InnerDemons = 337548,
        JusticarSVengeance = 215661,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        Metamorphosis = 187827,
        MetamorphosisOld = 191427,
        Momentum = 206476,
        Netherwalk = 196555,
        RubyEmbers = 365937,
        Scintillation = 370821,
        SigilOfFlame = 204596,
        SinfulBrand = 317009,
        Snapfire = 370783,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        TheHunt = 370965,
        ThrowGlaive = 204157,
        UnboundChaos = 347462,
        VanguardSMomentum = 383314,
        VengefulRetreat = 198793,
        Volatility = 369089,
      },

      prios = {
        {Key="netherwalk", SpellId=196555, Role={ "survival", },
          Description="Run, little girl, run!",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.AboutToDie and
              ctx.vars.IsFighting
          end
        },

        {Key="vengeful-retreat-escape", SpellId=198793, Role={ "survival", },
          Description="Use to get out of a dangerous situation",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="darkness", SpellId=196718, Role={ "survival", },
          Description="Prevents damage to self and allies",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow and
              ctx.vars.IsBeingDamaged
          end
        },

        {Key="blur", SpellId=198589, Role={ "survival", },
          Description="Damage reduction",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium and 
              ctx.vars.IsBeingDamaged
          end
        },

        {Key="fel-rush-back", SpellId=195072, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=true,
          Condition=function(this, ctx)
            return ctx.vars.LastCastSpell == ctx.SPI.FelRush
          end
        },

        {Key="elysian-decree", SpellId=390163, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
          end
        },

        {Key="the-hunt", SpellId=370965, Role={ "dps","heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="immolation-aura", SpellId=258920, Role={ "dps","generator", },
          Description="",
          RangeSpell=183752, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Fury + 20) <= ctx.vars.FuryMax
          end
        },

        {Key="sigil-of-flame", SpellId=204596, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Fury + 30) <= ctx.vars.FuryMax
          end
        },

        {Key="chaos-nova", SpellId=179057, Role={ "dps","spender","hinder", },
          Description="",
          RangeSpell=183752, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasMultipleTargets
            or ctx.vars.IsPvp
            or (ctx.vars.HealthIsLow and not ctx.vars.IsBossFight)
          end
        },

        {Key="felblade", SpellId=232893, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Fury + 40) <= ctx.vars.FuryMax
          end
        },

        {Key="death-sweep", SpellId=210152, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="glaive-tempest", SpellId=342817, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="fel-barrage", SpellId=258925, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="eye-beam", SpellId=198013, Role={ "dps","spender", },
          Description="",
          RangeSpell=183752, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
          end
        },

        {Key="essence-break", SpellId=258860, Role={ "dps", },
          Description="",
          RangeSpell=183752, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="blade-dance", SpellId=188499, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="annihilation", SpellId=201427, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="fel-rush-max-charges", SpellId=195072, Role={ "dps", },
          Description="",
          RangeSpell=183752, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.FelRushCharges > 1
          end
        },

        {Key="chaos-strike", SpellId=162794, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="demons-bite", SpellId=162243, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.HasDemonBladesTalent
            and (ctx.vars.Fury + 35) <= ctx.vars.FuryMax
          end
        },

        {Key="throw-glaive", SpellId=204157, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="metamorphosis", SpellId=187827, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="consume-magic", SpellId=278326, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="disrupt", SpellId=183752, Role={ "interrupt", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

      },

      slots={
        {Type="spell", Spell=187827, 
          Description="%s: your main cooldown",
          Icon="", Overlay=false, Charges=false
        },
        {Type="spell", Spell=278326, 
          Description="%s: steal a magic effect from the target",
          Icon="", Overlay=false, Charges=false
        },
      },

      code={
        HealthIsCritical=function(ctx)
          return ctx.vars.HealthPercent < 0.3
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent < 0.5
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent < 0.8
        end,

        AboutToDie=function(ctx)
          return ctx.vars.HealthPercent <= 0.2
        end,

        FuryLevelHigh=function(ctx)
          return ctx.vars.Fury >= 80
        end,

        HasManyEnemies=function(ctx)
          return ctx.vars.Targets >= 3
        end,

        HasMultipleTargets=function(ctx)
          return ctx.vars.Targets > 1
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthRate < 0
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsBossFight
          or ctx.vars.IsPvp
          or ctx.vars.HasMultipleTargets
          or ctx.vars.HealthIsLow
        end,

        UnboundChaosActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.UnboundChaos).active
        end,

        HasMomentumTalent=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Momentum)
        end,

        EssenceBreakOnCooldown=function(ctx)
          return ctx:GetSpell(ctx.SPI.EssenceBreak).cooldown >= 3
        end,

        BladeDanceAvailable=function(ctx)
          return ctx:GetSpell(ctx.SPI.BladeDance).cooldown == 0
        end,

        EyeBeamAvailable=function(ctx)
          return ctx:GetSpell(ctx.SPI.EyeBeam).cooldown == 0
        end,

        DeathSweepAvailable=function(ctx)
          return ctx:GetSpell(ctx.SPI.DeathSweep).cooldown == 0
        end,

        TargetHasEssenceBreak=function(ctx)
          return ctx:GetDebuff(ctx.SPI.EssenceBreak).active
        end,

        MomentumActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.Momentum).active
        end,

        HasDemonBladesTalent=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.DemonBlades)
        end,

        TargetHasInitiative=function(ctx)
          return ctx:GetDebuff(ctx.SPI.Initiative).active
        end,

        FelRushCharges=function(ctx)
          return ctx:GetSpell(ctx.SPI.FelRush).charges
        end,

      }
    }

  elseif ctx.vars.Spec == "WARRIOR-3" then
    return {
      SPI = {
        Animosity = 375797,
        Avatar = 107574,
        BattleShout = 6673,
        BattleStance = 386164,
        BerserkerRage = 18499,
        BerserkerShout = 384100,
        BitterImmunity = 383762,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChallengingShout = 1161,
        ChargedBlast = 370455,
        DeepWounds = 262115,
        DefensiveStance = 386208,
        DemoralizingShout = 1160,
        Devastate = 20243,
        DisruptingShout = 386071,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        DragonRoar = 118000,
        EmpyreanLegacy = 387170,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EverburningFlame = 370819,
        Execute = 163201,
        FeedTheFlames = 369846,
        Fireblood = 265221,
        FontOfMagic = 375783,
        Hamstring = 1715,
        HeroicLeap = 6544,
        HeroicThrow = 57755,
        HolyBlade = 383342,
        IgnorePain = 190456,
        ImpendingVictory = 202168,
        Intercept = 198304,
        IntimidatingShout = 5246,
        JusticarSVengeance = 215661,
        LastStand = 12975,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        Pummel = 6552,
        RallyingCry = 97462,
        Ravager = 228920,
        Rend = 394062,
        Revenge = 6572,
        RubyEmbers = 365937,
        Scintillation = 370821,
        ShatteringThrow = 64382,
        ShieldBlock = 2565,
        ShieldBlockBuff = 132404,
        ShieldCharge = 385952,
        ShieldSlam = 23922,
        ShieldWall = 871,
        Shockwave = 46968,
        Slam = 1464,
        Snapfire = 370783,
        SpearOfBastion = 376079,
        SpellBlock = 392966,
        SpellReflection = 23920,
        StormBolt = 107570,
        TalentDevastator = 236279,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        ThunderClap = 6343,
        ThunderousRoar = 384318,
        TitanicThrow = 384090,
        VanguardSMomentum = 383314,
        VictoryRush = 34428,
        Volatility = 369089,
        Whirlwind = 1680,
        WreckingThrow = 384110,
      },

      prios = {
        {Key="shield-wall", SpellId=871, Role={ "survival","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="last-stand", SpellId=12975, Role={ "survival","heal","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="victory-rush", SpellId=34428, Role={ "survival","heal","dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
          end
        },

        {Key="impending-victory-heal", SpellId=202168, Role={ "survival","heal","dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow
              or (ctx.vars.HasVictoriusBuff and ctx.vars.HealthIsMedium)
          end
        },

        {Key="ignore-pain-low-health", SpellId=190456, Role={ "survival","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.IgnorePainActive
              and ctx.vars.HealthIsLow
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="shield-block-low-health", SpellId=2565, Role={ "survival","spender","preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.ShieldBlockActive
              and ctx.vars.HealthIsLow
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="execute", SpellId=163201, Role={ "dps","spender","reaction", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Rage - 20) > 49 
          end
        },

        {Key="ignore-pain", SpellId=190456, Role={ "survival","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.IgnorePainActive
              and ctx.vars.HealthIsMedium
              and ctx.vars.IsBeingDamaged
              and ctx.vars.WillNotDepleteRage
          end
        },

        {Key="shield-block", SpellId=2565, Role={ "survival","spender","preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.ShieldBlockActive
              and ctx.vars.IsBeingDamaged
              and ctx.vars.HealthIsMedium 
              and ctx.vars.WillNotDepleteRage
          end
        },

        {Key="shield-charge", SpellId=385952, Role={ "dps","generator","hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Rage + 20) < 101
          end
        },

        {Key="ravager", SpellId=228920, Role={ "dps","generator","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
            and ((ctx.vars.Rage + 10) < 101)
          end
        },

        {Key="thunderous-roar", SpellId=384318, Role={ "dps","generator","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
            and ((ctx.vars.Rage + 10) < 101)
          end
        },

        {Key="dragon-roar", SpellId=118000, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="spear-of-bastion", SpellId=376079, Role={ "dps","generator","dot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
            and ((ctx.vars.Rage + 20) < 101)
          end
        },

        {Key="shield-slam", SpellId=23922, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Rage + 15) < 101
          end
        },

        {Key="thunder-clap", SpellId=6343, Role={ "dps","spender","generator","hinder", },
          Description="",
          RangeSpell=23922, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Rage - 30) > 29
          end
        },

        {Key="shockwave", SpellId=46968, Role={ "dps","generator","hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
            and not ctx.vars.IsBossFight
            and ((ctx.vars.Rage + 10) < 101)
          end
        },

        {Key="revenge", SpellId=6572, Role={ "dps","spender", },
          Description="",
          RangeSpell=23922, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.Rage > 50
          end
        },

        {Key="whirlwind", SpellId=1680, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Rage - 30) > 49
          end
        },

        {Key="execute-filler", SpellId=163201, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="rend", SpellId=394062, Role={ "dps","spender","hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Rage - 30) > 29
          end
        },

        {Key="devastate", SpellId=20243, Role={ "dps", },
          Description="",
          RangeSpell=23922, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.HasTalentDevastator
          end
        },

        {Key="wrecking-throw", SpellId=384110, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="hamstring", SpellId=1715, Role={ "dps","dot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.IsBossFight
          end
        },

        {Key="intercept", SpellId=198304, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="rallying-cry", SpellId=97462, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="demoralizing-shout", SpellId=1160, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="avatar", SpellId=107574, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="pummel", SpellId=6552, Role={ "interrupt", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

      },

      slots={
        {Type="spell", Spell=107574, 
          Description="",
          Icon="", Overlay=false, Charges=false
        },
        {Type="spell", Spell=198304, 
          Description="",
          Icon="", Overlay=false, Charges=false
        },
        {Type="spell", Spell=1160, 
          Description="",
          Icon="", Overlay=false, Charges=false
        },
        {Type="spell", Spell=97462, 
          Description="",
          Icon="", Overlay=false, Charges=false
        },
      },

      code={
        HealthIsCritical=function(ctx)
          return ctx.vars.HealthPercent < 0.35
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthChangingRate < 0
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent < 0.65
        end,

        HasVictoriusBuff=function(ctx)
          return ctx:GetBuff(ctx.SPI.Victorious).active
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent < 0.85
        end,

        IgnorePainActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.IgnorePain).active
        end,

        ShieldBlockActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.ShieldBlockBuff).active
        end,

        WillNotDepleteRage=function(ctx)
          return (ctx.vars.Rage / ctx.vars.RageMax) > 0.8
        end,

        ThunderClapActive=function(ctx)
          return ctx:GetDebuff(ctx.SPI.ThunderClap).active
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsBossFight
            or ctx.vars.IsPvp
            or ctx.vars.IsAoE
            or ctx.vars.HealthIsLow
        end,

        HasTalentDevastator=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.TalentDevastator)
        end,

      }
    }

  elseif ctx.vars.Spec == "DEMONHUNTER-2" then
    return {
      SPI = {
        Animosity = 375797,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChaosNova = 179057,
        ChargedBlast = 370455,
        ConsumeMagic = 278326,
        Darkness = 196718,
        DemonSpikes = 203720,
        DemonSpikesBuff = 203819,
        Disrupt = 183752,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        ElysianDecree = 390163,
        EmpyreanLegacy = 387170,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EverburningFlame = 370819,
        FeedTheFlames = 369846,
        Felblade = 232893,
        FelDevastation = 212084,
        FieryBrand = 204021,
        Fireblood = 265221,
        FontOfMagic = 375783,
        Fracture = 263642,
        HolyBlade = 383342,
        ImmolationAura = 258920,
        InfernalStrike = 189110,
        JusticarSVengeance = 215661,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        Metamorphosis = 187827,
        RazelikhSDefilement = 337544,
        RubyEmbers = 365937,
        Scintillation = 370821,
        Shear = 203783,
        ShearOld = 203782,
        SigilOfFlame = 204596,
        SigilOfMisery = 207684,
        SigilOfSilence = 202137,
        SinfulBrand = 317009,
        Snapfire = 370783,
        SoulBarrier = 263648,
        SoulCarver = 207407,
        SoulCleave = 228477,
        SoulFragments = 203981,
        SpiritBomb = 247454,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        TheHunt = 370965,
        TheHuntDebuff = 323639,
        ThrowGlaive = 204157,
        VanguardSMomentum = 383314,
        VengefulRetreat = 198793,
        Volatility = 369089,
      },

      prios = {
        {Key="elysian-decree-pull", SpellId=390163, Role={ "dps","heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.IsFighting
          end
        },

        {Key="infernal-strike-pull", SpellId=189110, Role={ "dps", },
          Description="",
          RangeSpell=204157, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.IsFighting
          end
        },

        {Key="metamorphosis", SpellId=187827, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical
              and ctx.vars.IsFighting
          end
        },

        {Key="spirit-bom-heals", SpellId=247454, Role={ "heal","dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow and ctx.vars.IsFighting
          end
        },

        {Key="soul-barrier", SpellId=263648, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow and ctx.vars.IsFighting
          end
        },

        {Key="fiery-brand", SpellId=204021, Role={ "dps","hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
          end
        },

        {Key="demon-spikes", SpellId=203720, Role={ "survival","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
            and not ctx.vars.HasDemonSpikes
          end
        },

        {Key="spirit-bomb", SpellId=247454, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasSoulFragments
          end
        },

        {Key="soul-cleave", SpellId=228477, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
            or ctx.vars.FuryPercent >= 0.9
          end
        },

        {Key="elysian-decree", SpellId=390163, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="the-hunt", SpellId=370965, Role={ "dps","heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
            or ctx.vars.IsDangerousFight
          end
        },

        {Key="soul-carver", SpellId=207407, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="fel-devastation", SpellId=212084, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
            or ctx.vars.FuryPercent >= 0.9
          end
        },

        {Key="sigil-of-flame", SpellId=204596, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Fury + 30 - 10) <= ctx.vars.FuryMax
          end
        },

        {Key="immolation-aura", SpellId=258920, Role={ "dps","generator", },
          Description="",
          RangeSpell=183752, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Fury + 20 - 10) <= ctx.vars.FuryMax
          end
        },

        {Key="infernal-strike", SpellId=189110, Role={ "dps", },
          Description="",
          RangeSpell=204157, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.InfernalStrikeHasTwoCharges
          end
        },

        {Key="felblade", SpellId=232893, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.Fury + 40 - 10) <= ctx.vars.FuryMax
          end
        },

        {Key="fracture", SpellId=263642, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ((ctx.vars.Fury + 25 - 10) <= ctx.vars.FuryMax)
            and (ctx.vars.FracturedSouls < 4)
          end
        },

        {Key="shear", SpellId=203783, Role={ "dps","survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.HasFractureTalent
          end
        },

        {Key="chaos-nova", SpellId=179057, Role={ "dps","spender","hinder", },
          Description="",
          RangeSpell=183752, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasMultipleTargets
            or ctx.vars.IsPvp
            or (ctx.vars.HealthIsLow and not ctx.vars.IsBossFight)
          end
        },

        {Key="throw-glaive", SpellId=204157, Role={ "filler", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="disrupt", SpellId=183752, Role={ "interrupt", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

      },

      slots={
        {Type="spell", Spell=187827, 
          Description="%s: Your main cooldown",
          Icon="", Overlay=false, Charges=false
        },
        {Type="spell", Spell=278326, 
          Description="%s: steal a magic buff from the target",
          Icon="", Overlay=false, Charges=false
        },
      },

      code={
        HasFractureTalent=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Fracture)
        end,

        HasDemonSpikes=function(ctx)
          return ctx:GetBuff(ctx.SPI.DemonSpikesBuff).active
        end,

        FracturedSouls=function(ctx)
          return ctx:GetBuff(ctx.SPI.SoulFragments).charges
        end,

        HealthIsCritical=function(ctx)
          return ctx.vars.HealthPercent < 0.35
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent < 0.5
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent < 0.85
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthRate < 0
        end,

        HasMultipleTargets=function(ctx)
          return ctx.vars.Targets > 1 or ctx.vars.Enemies > 2
        end,

        IsDangerousFoe=function(ctx)
          local uc = UnitClassification("target")
                    return (uc == "worldboss" 
          or uc == "rareelite" 
          or uc == "elite" 
          or uc == "rare")
          and UnitLevel("target") >= UnitLevel("player")
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsDangerousFoe
          or ctx.vars.IsBossFight
          or ctx.vars.IsPvp
          or ctx.vars.HasMultipleTargets
          or (ctx.vars.HealthIsLow
          and ctx.vars.IsBeingDamaged)
        end,

        HasSoulFragments=function(ctx)
          return (ctx.vars.FracturedSouls or 0) > 3
        end,

        InfernalStrikeHasTwoCharges=function(ctx)
          return ctx:GetSpell(ctx.SPI.InfernalStrike).charges > 1
        end,

      }
    }

  elseif ctx.vars.Spec == "EVOKER-1" then
    return {
      SPI = {
        Animosity = 375797,
        AzureStrike = 362969,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BlessingOfTheBronze = 364342,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        CauterizingFlame = 374251,
        ChargedBlast = 370455,
        DeepBreath = 357210,
        Disintegrate = 356995,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        Dragonrage = 375087,
        EmeraldBlossom = 355913,
        EmpyreanLegacy = 387170,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EternitySurge = 359073,
        EverburningFlame = 370819,
        Expunge = 365585,
        FeedTheFlames = 369846,
        Fireblood = 265221,
        FireBreath = 357208,
        Firestorm = 368847,
        FontOfMagic = 375783,
        FuryOfTheAspects = 390386,
        HolyBlade = 383342,
        Hover = 358267,
        JusticarSVengeance = 215661,
        Landslide = 358385,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        LivingFlame = 361469,
        ObsidianScales = 363916,
        OppressingRoar = 372048,
        Pyre = 357211,
        Quell = 351338,
        RenewingBlaze = 374348,
        Rescue = 370665,
        RubyEmbers = 365937,
        Scintillation = 370821,
        ShatteringStar = 370452,
        SleepWalk = 360806,
        Snapfire = 370783,
        Soar = 381322,
        SourceOfMagic = 369459,
        TailSwipe = 368970,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        TimeSpiral = 374968,
        TipTheScales = 370553,
        Unravel = 368432,
        VanguardSMomentum = 383314,
        VerdantEmbrace = 360995,
        Volatility = 369089,
        WingBuffet = 357214,
        Zephyr = 374227,
      },

      prios = {
        {Key="verdant-embrace", SpellId=360995, Role={ "heal","survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsNotGood
          end
        },

        {Key="emerald-blossom", SpellId=355913, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
          end
        },

        {Key="obsidian-scales", SpellId=363916, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsFighting and ctx.vars.HealthIsLow
          end
        },

        {Key="renewing-blaze", SpellId=374348, Role={ "heal","survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsFighting and ctx.vars.HealthIsMedium
          end
        },

        {Key="zephyr", SpellId=374227, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsFighting and ctx.vars.HealthIsLow
          end
        },

        {Key="firestorm-pull", SpellId=368847, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.IsFighting
          end
        },

        {Key="living-flame-pull", SpellId=361469, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.IsFighting
          end
        },

        {Key="tip-the-scales", SpellId=370553, Role={ "preparation","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
          end
        },

        {Key="eternity-surge-instant", SpellId=359073, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffTipTheScalesActive
          end
        },

        {Key="fire-breath-instant", SpellId=357208, Role={ "dps", },
          Description="",
          RangeSpell=359073, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffTipTheScalesActive
          end
        },

        {Key="dragonrage", SpellId=375087, Role={ "dps","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
          end
        },

        {Key="free-pyre", SpellId=357211, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffEssenceBurstActive
          end
        },

        {Key="deep-breath", SpellId=357210, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="free-disintegrate", SpellId=356995, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffEssenceBurstActive
          end
        },

        {Key="shattering-star", SpellId=370452, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="pyre-no-essence", SpellId=357211, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffEssenceBurstActive 
            and ctx.vars.HasManyTargets
          end
        },

        {Key="wing-buffet", SpellId=357214, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.EnemyIsNear
          end
        },

        {Key="tail-swipe", SpellId=368970, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.EnemyIsNear
          end
        },

        {Key="disintegrate-no-essence", SpellId=356995, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffEssenceBurstActive
          end
        },

        {Key="fire-breath", SpellId=357208, Role={ "dps", },
          Description="",
          RangeSpell=359073, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="eternity-surge", SpellId=359073, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="living-flame", SpellId=361469, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="firestorm", SpellId=368847, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="pyre", SpellId=357211, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasManyTargets
          end
        },

        {Key="disintegrate", SpellId=356995, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="azure-strike", SpellId=362969, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="quell", SpellId=351338, Role={ "interrupt", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="oppressing-roar", SpellId=372048, Role={ "slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

      },

      slots={
        {Type="spell", Spell=390386, 
          Description="",
          Icon="", Overlay=false, Charges=false
        },
        {Type="spell", Spell=372048, 
          Description="",
          Icon="", Overlay=false, Charges=false
        },
      },

      code={
        HealthIsNotGood=function(ctx)
          return ctx.vars.HealthPercent <= 0.8
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent <= 0.6
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent <= 0.5
        end,

        BuffEssenceBurstActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.EssenceBurst).active
        end,

        BuffTipTheScalesActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.TipTheScales).active
        end,

        HasManyTargets=function(ctx)
          return ctx.vars.Targets > 2
        end,

        EnemyIsNear=function(ctx)
          return ctx:CheckEnemyIsNear()
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsBossFight
          or ctx.vars.IsPvp
          or ctx.vars.HasManyTargets
          or ctx.vars.HealthIsLow
        end,

      }
    }

  elseif ctx.vars.Spec == "EVOKER-3" then
    return {
      SPI = {
        Animosity = 375797,
        AzureStrike = 362969,
        BlastFurnace = 375510,
        BlessedChampion = 403010,
        BoundlessJudgment = 405278,
        Burnout = 375801,
        ChargedBlast = 370455,
        DeepBreath = 357210,
        Disintegrate = 356995,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        Dragonrage = 375087,
        EmeraldBlossom = 355913,
        EmpyreanLegacy = 387170,
        EssenceBurst = 359618,
        EternitySSpan = 375757,
        EternitySurge = 359073,
        EverburningFlame = 370819,
        FeedTheFlames = 369846,
        Fireblood = 265221,
        FireBreath = 357208,
        Firestorm = 368847,
        FontOfMagic = 375783,
        HolyBlade = 383342,
        JusticarSVengeance = 215661,
        LeapingFlames = 369939,
        LightSJudgment = 255647,
        LivingFlame = 361469,
        ObsidianScales = 363916,
        Pyre = 357211,
        RenewingBlaze = 374348,
        RubyEmbers = 365937,
        Scintillation = 370821,
        ShatteringStar = 370452,
        Snapfire = 370783,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarSVerdict = 85256,
        TipTheScales = 370553,
        VanguardSMomentum = 383314,
        Volatility = 369089,
      },

      prios = {
        {Key="PreCombat_Firestorm", SpellId=368847, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModePreCombat and ctx.vars.HasTalentFirestorm
          end
        },

        {Key="PreCombat_LivingFlame", SpellId=361469, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModePreCombat and 
            not ctx.vars.HasTalentFirestorm
          end
        },

        {Key="Survival_EmeraldBlossom", SpellId=355913, Role={ "survival","heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsDropping
          end
        },

        {Key="Survival_RenewingBlaze", SpellId=374348, Role={ "survival","heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
          end
        },

        {Key="Survival_ObsidianScales", SpellId=363916, Role={ "survival","heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium and 
            not ctx.vars.BuffRenewingBlaze.active
          end
        },

        {Key="Instant_FireBreath", SpellId=357208, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe
          end
        },

        {Key="Instant_EternitySurge", SpellId=359073, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="Instant_Firestorm", SpellId=368847, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="Aoe_Dragonrage", SpellId=375087, Role={ "dps","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and (ctx.vars.SpellFireBreath.cooldown <= ctx.vars.GCD and ctx.vars.SpellEternitySurge.cooldown < 3 * ctx.vars.GCD)
          end
        },

        {Key="Aoe_TipTheScales", SpellId=370553, Role={ "preparation","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and (ctx.vars.BuffDragonrage.active and 
            (ctx.vars.Targets <= 6 or 
            not ctx.vars.SpellFireBreath.ready))
          end
        },

        {Key="Aoe_FireBreath", SpellId=357208, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and (ctx.vars.SpellDragonrage.cooldown > 10)
          end
        },

        {Key="Aoe_EternitySurge", SpellId=359073, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and
            (not ctx.vars.HasTalentDragonrage or ctx.vars.SpellDragonrage.cooldown > 15 or
            ctx.vars.HasTalentEternitysSpan or 
            not ctx.vars.HasTalentFontOfMagic or ctx.vars.BuffDragonrage.active)
          end
        },

        {Key="Aoe_AzureStrike_DragonRage", SpellId=362969, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and ctx.vars.BuffDragonrage.active
          end
        },

        {Key="Aoe_DeepBreath", SpellId=357210, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and 
            not ctx.vars.BuffDragonrage.active
          end
        },

        {Key="Aoe_Firestorm", SpellId=368847, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe
          end
        },

        {Key="Aoe_ShatteringStar", SpellId=370452, Role={ "dps","hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe
          end
        },

        {Key="Aoe_AzureStrike", SpellId=362969, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe
          end
        },

        {Key="Aoe_Pyre_Volatility", SpellId=357211, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and 
            ctx.vars.HasTalentVolatility
          end
        },

        {Key="Aoe_LivingFlame", SpellId=361469, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and 
            (ctx.vars.BuffBurnout.active and ctx.vars.BuffLeapingFlames.active and 
            not ctx.vars.BuffEssenceBurst.active)
          end
        },

        {Key="Aoe_Pyre", SpellId=357211, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and ctx.vars.SpellDragonrage.cooldown >= 10
          end
        },

        {Key="Aoe_Disintegrate", SpellId=356995, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and 
            (not ctx.vars.HasTalentShatteringStar or ctx.vars.SpellShatteringStar.cooldown > 5 or ctx.vars.Essence > ctx.vars.EssenceMax - 1 or ctx.vars.BuffEssenceBurst.charges == ctx.vars.BuffEssenceBurst.max)
          end
        },

        {Key="Aoe_LivingFlame_Burnout", SpellId=361469, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeAoe and 
            ctx.vars.HasTalentSnapfire and 
            ctx.vars.BuffBurnout.active
          end
        },

        {Key="Dragonrage", SpellId=375087, Role={ "dps","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (
            ctx.vars.SpellFireBreath.cooldown < ctx.vars.GCD and 
            ctx.vars.SpellEternitySurge.cooldown < 2 * ctx.vars.GCD
            ) or
            ctx.vars.BossInFight
          end
        },

        {Key="TipTheScales", SpellId=370553, Role={ "cooldown","preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight and 
            (ctx.vars.BuffDragonrage.active or (ctx.vars.HasTalentFeedTheFlames and 
            not ctx.vars.SpellFireBreath.ready))
          end
        },

        {Key="Fb_FireBreath", SpellId=357208, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeFb
          end
        },

        {Key="Es_EternitySurge", SpellId=359073, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeEs
          end
        },

        {Key="ShatteringStar", SpellId=370452, Role={ "dps","hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.BuffDragonrage.active or
            ctx.vars.HasTalentFeedTheFlames or 
            not ctx.vars.HasBloodLust
          end
        },

        {Key="LivingFlame", SpellId=361469, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffDragonrage.active and
            ctx.vars.BuffBurnout.active
          end
        },

        {Key="AzureStrike", SpellId=362969, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffDragonrage.active
          end
        },

        {Key="Pyre", SpellId=357211, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.HasTalentVolatility or 
            not ctx.vars.HasTalentEternitysSpan or 
            not ctx.vars.HasTalentScintillation)  and ctx.vars.BuffChargedBlast.charges > 19
          end
        },

        {Key="Firestorm", SpellId=368847, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not (ctx.vars.BuffDragonrage.active or
            ctx.vars.DebuffShatteringStar.active) or ctx.vars.BuffSnapfire.active
          end
        },

        {Key="LivingFlame_MaxBurnout", SpellId=361469, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.BuffDragonrage.active and ctx.vars.BuffBurnout.charges == ctx.vars.BuffBurnout.max
          end
        },

        {Key="Disintegrate", SpellId=356995, Role={ "dps","hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.BuffDragonrage.active and 
            (not ctx.vars.HasTalentShatteringStar or ctx.vars.SpellShatteringStar.cooldown > 6 or ctx.vars.Essence > (ctx.vars.EssenceMax - 1) or ctx.vars.BuffEssenceBurst.charges == ctx.vars.BuffEssenceBurst.max) 
          end
        },

        {Key="DeepBreath", SpellId=357210, Role={ "dps","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.BuffDragonrage.active and ctx.vars.Targets > 1
          end
        },

        {Key="LivingFlame_Filler", SpellId=361469, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

      },

      slots={
      },

      code={
        BuffBurnout=function(ctx)
          return ctx:GetBuff(ctx.SPI.Burnout)
        end,

        BuffChargedBlast=function(ctx)
          return ctx:GetBuff(ctx.SPI.ChargedBlast)
        end,

        BuffDragonrage=function(ctx)
          return ctx:GetBuff(ctx.SPI.Dragonrage)
        end,

        BuffEssenceBurst=function(ctx)
          return ctx:GetBuff(ctx.SPI.EssenceBurst)
        end,

        BuffLeapingFlames=function(ctx)
          return ctx:GetBuff(ctx.SPI.LeapingFlames)
        end,

        BuffRenewingBlaze=function(ctx)
          return ctx:GetBuff(ctx.SPI.RenewingBlaze)
        end,

        BuffSnapfire=function(ctx)
          return ctx:GetBuff(ctx.SPI.Snapfire)
        end,

        BuffTipTheScales=function(ctx)
          return ctx:GetBuff(ctx.SPI.TipTheScales)
        end,

        DebuffFireBreath=function(ctx)
          return ctx:GetDebuff(ctx.SPI.FireBreath)
        end,

        DebuffLivingFlame=function(ctx)
          return ctx:GetDebuff(ctx.SPI.LivingFlame)
        end,

        DebuffShatteringStar=function(ctx)
          return ctx:GetDebuff(ctx.SPI.ShatteringStar)
        end,

        SpellDragonrage=function(ctx)
          return ctx:GetSpell(ctx.SPI.Dragonrage)
        end,

        SpellEternitySurge=function(ctx)
          return ctx:GetSpell(ctx.SPI.EternitySurge)
        end,

        SpellFireBreath=function(ctx)
          return ctx:GetSpell(ctx.SPI.FireBreath)
        end,

        SpellShatteringStar=function(ctx)
          return ctx:GetSpell(ctx.SPI.ShatteringStar)
        end,

        HasTalentAnimosity=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Animosity)
        end,

        HasTalentDragonrage=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Dragonrage)
        end,

        HasTalentEternitysSpan=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.EternitysSpan)
        end,

        HasTalentEverburningFlame=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.EverburningFlame)
        end,

        HasTalentFeedTheFlames=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.FeedTheFlames)
        end,

        HasTalentFirestorm=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Firestorm)
        end,

        HasTalentFontOfMagic=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.FontOfMagic)
        end,

        HasTalentRubyEmbers=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.RubyEmbers)
        end,

        HasTalentScintillation=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Scintillation)
        end,

        HasTalentShatteringStar=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.ShatteringStar)
        end,

        HasTalentSnapfire=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Snapfire)
        end,

        HasTalentVolatility=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Volatility)
        end,

        HealthIsDropping=function(ctx)
          return ctx.vars.HealthPercent <= 0.85
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent <= 0.6
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent <= 0.35
        end,

        TalentBlastFurnaceRank=function(ctx)
          return ctx:GetTalentRank(ctx.SPI.BlastFurnace)
        end,

        IsModePreCombat=function(ctx)
          return not ctx.vars.IsFighting
        end,

        IsModeAoe=function(ctx)
          return ctx.vars.Targets >= 3
        end,

        IsModeFb=function(ctx)
          return not ctx.vars.HasTalentDragonrage or 
          ctx.vars.SpellDragonrage.cooldown > 0 or 
          not ctx.vars.HasTalentAnimosity
        end,

        IsModeEs=function(ctx)
          return not ctx.vars.HasTalentDragonrage or 
          ctx.vars.SpellDragonrage.cooldown > 0 or 
          not ctx.vars.HasTalentAnimosity
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsBossFight or 
          ctx.vars.IsPvp or
          ctx.vars.HealthIsLow
        end,

      }
    }

  elseif ctx.vars.Spec == "PALADIN-3" then
    return {
      SPI = {
        ArcaneTorrent = 155145,
        AvengingWrath = 31884,
        BladeOfJustice = 184575,
        BlessedChampion = 403010,
        BoundlessJudgment = 405278,
        Consecration = 26573,
        Crusade = 231895,
        CrusaderStrike = 35395,
        DivineArbiter = 404306,
        DivineAuxiliary = 406158,
        DivineHammer = 198034,
        DivineResonance = 384027,
        DivineShield = 642,
        DivineStorm = 53385,
        DivineToll = 304971,
        EmpyreanLegacy = 387170,
        EmpyreanPower = 326733,
        ExecutionSentence = 343527,
        FinalReckoning = 343721,
        Fireblood = 265221,
        FlashOfLight = 19750,
        HammerOfWrath = 24275,
        HolyBlade = 383342,
        Judgment = 20271,
        Judgment_bad = 275779,
        JusticarSVengeance = 215661,
        LayOnHands = 633,
        LightSJudgment = 255647,
        Rebuke = 96231,
        ShieldOfVengeance = 184662,
        TemplarSlash = 406647,
        TemplarStrike = 407480,
        TemplarStrikes = 406646,
        TemplarSVerdict = 85256,
        VanguardSMomentum = 383314,
        WakeOfAshes = 255937,
        WordOfGlory = 85673,
      },

      prios = {
        {Key="Survival_DivineShield", SpellId=642, Role={ "survival","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow and
            ctx.vars.IsBeingDamaged
          end
        },

        {Key="Survival_LayOnHands", SpellId=633, Role={ "heal","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical
          end
        },

        {Key="Surival_ShieldOfVengeance", SpellId=184662, Role={ "survival","dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow and 
            ctx.vars.IsBeingDamaged
          end
        },

        {Key="Survial_FlashOfLight", SpellId=19750, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
            
          end
        },

        {Key="Survival_WordOfGlory", SpellId=85673, Role={ "survival","heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow
          end
        },

        {Key="Survival_JusticarsVengeance", SpellId=215661, Role={ "survival","heal","dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
          end
        },

        {Key="PreCombat_ShieldOfVengeance", SpellId=184662, Role={ "preparation","survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=true,
          Condition=function(this, ctx)
            return ctx.vars.IsModePreCombat
          end
        },

        {Key="Cooldowns_LightsJudgment", SpellId=255647, Role={ "dps","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.Targets >= 2 
          end
        },

        {Key="Cooldowns_Fireblood", SpellId=265221, Role={ "cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffAvengingWrath.active or ctx.vars.BuffCrusade.active and ctx.vars.BuffCrusade.charges == 10
          end
        },

        {Key="Free_DivineStorm", SpellId=53385, Role={ "dps","survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffEmpyreanPower.active
          end
        },

        {Key="Cooldowns_ExecutionSentence", SpellId=343527, Role={ "dps","spender","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight and (not ctx.vars.BuffCrusade.active and ctx.vars.SpellCrusade.cooldown > 10 or ctx.vars.BuffCrusade.charges == 10 or ctx.vars.SpellAvengingWrath.cooldown > 10)
          end
        },

        {Key="Cooldowns_FinalReckoning", SpellId=343721, Role={ "dps","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.SpellCrusade.cooldown > 0 and (
            not ctx.vars.BuffCrusade.active or ctx.vars.BuffCrusade.charges >= 10) )
          end
        },

        {Key="Finishers_DivineStorm", SpellId=53385, Role={ "dps","spender", },
          Description="",
          RangeSpell=85256, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeFinishers and
            ctx.vars.Targets >= 2
          end
        },

        {Key="Finishers_JusticarsVengeance", SpellId=215661, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeFinishers
          end
        },

        {Key="Finishers_TemplarsVerdict", SpellId=85256, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsModeFinishers and ctx.vars.IsTemplarsVerdictValid
          end
        },

        {Key="Generators_WakeOfAshes", SpellId=255937, Role={ "dps","generator", },
          Description="",
          RangeSpell=184575, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HolyPower <= 2 
          end
        },

        {Key="Generators_DivineToll", SpellId=304971, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HolyPower <= 2 and 
            not ctx.vars.DebuffJudgment.active 
          end
        },

        {Key="Generators_TemplarSlash_Aoe", SpellId=406647, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffTemplarStrikes.remaining < ctx.vars.GCD and ctx.vars.Targets >= 2
          end
        },

        {Key="Generators_Judgment_Aoe", SpellId=20271, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.DebuffJudgment.active and (ctx.vars.HolyPower <= 3 or 
            not ctx.vars.HasTalentBoundlessJudgment) and 
            ctx.vars.Targets >= 2
          end
        },

        {Key="Generators_BladeOfJustice_Aoe", SpellId=184575, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.HolyPower <= 3 or 
            not ctx.vars.HasTalentHolyBlade) and 
            ctx.vars.Targets >= 2
          end
        },

        {Key="Generators_HammerOfWrath", SpellId=24275, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HolyPower <= 3
          end
        },

        {Key="Generators_TemplarSlash", SpellId=406647, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.BuffTemplarStrikes.remaining < ctx.vars.GCD
          end
        },

        {Key="Generators_BladeOfJustice", SpellId=184575, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HolyPower <= 3 or 
            not ctx.vars.HasTalentHolyBlade
          end
        },

        {Key="Generators_Judgment", SpellId=275779, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.DebuffJudgment.active and (ctx.vars.HolyPower <= 3 or (ctx.vars.HolyPower <= 4 and not ctx.vars.HasTalentBoundlessJudgment))
          end
        },

        {Key="Generators_CrusaderStrike", SpellId=35395, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HolyPower <= 3
            and ctx.vars.IsCrusaderStrikeValid
          end
        },

        {Key="Generators_TemplarStrike", SpellId=407480, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HolyPower <= 4
          end
        },

        {Key="Cooldowns_ShieldOfVengeance", SpellId=184662, Role={ "dps","survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=true,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight and 
            not ctx.vars.WingsOn
          end
        },

        {Key="Fillers_Consecration", SpellId=26573, Role={ "dps", },
          Description="",
          RangeSpell=184575, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.NeedsConsecration
          end
        },

        {Key="Filler_DivineHammer", SpellId=198034, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.Targets >= 2
          end
        },

        {Key="Generator_ArcaneTorrent", SpellId=155145, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HolyPower <= 4
          end
        },

        {Key="Filler_Judgment", SpellId=20271, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="Rebuke", SpellId=96231, Role={ "interrupt", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="Slot_AvengingWrath", SpellId=31884, Role={ "cooldown","slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="Slot_Crusade", SpellId=231895, Role={ "cooldown","slot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

      },

      slots={
        {Type="spell", Spell=31884, 
          Description="Default Cooldown",
          Icon="", Overlay=false, Charges=false
        },
        {Type="spell", Spell=184662, 
          Description="Shields",
          Icon="", Overlay=false, Charges=false
        },
      },

      code={
        BuffAvengingWrath=function(ctx)
          return ctx:GetBuff(ctx.SPI.AvengingWrath)
        end,

        BuffCrusade=function(ctx)
          return ctx:GetBuff(ctx.SPI.Crusade)
        end,

        BuffDivineArbiter=function(ctx)
          return ctx:GetBuff(ctx.SPI.DivineArbiter)
        end,

        BuffDivineResonance=function(ctx)
          return ctx:GetBuff(ctx.SPI.DivineResonance)
        end,

        BuffEmpyreanLegacy=function(ctx)
          return ctx:GetBuff(ctx.SPI.EmpyreanLegacy)
        end,

        BuffEmpyreanPower=function(ctx)
          return ctx:GetBuff(ctx.SPI.EmpyreanPower)
        end,

        BuffTemplarStrikes=function(ctx)
          return ctx:GetBuff(ctx.SPI.TemplarStrikes)
        end,

        DebuffConsecration=function(ctx)
          return ctx:GetDebuff(ctx.SPI.Consecration)
        end,

        DebuffJudgment=function(ctx)
          return ctx:GetDebuff(ctx.SPI.Judgment)
        end,

        SpellAvengingWrath=function(ctx)
          return ctx:GetSpell(ctx.SPI.AvengingWrath)
        end,

        SpellBladeOfJustice=function(ctx)
          return ctx:GetSpell(ctx.SPI.BladeOfJustice)
        end,

        SpellCrusade=function(ctx)
          return ctx:GetSpell(ctx.SPI.Crusade)
        end,

        SpellExecutionSentence=function(ctx)
          return ctx:GetSpell(ctx.SPI.ExecutionSentence)
        end,

        SpellFinalReckoning=function(ctx)
          return ctx:GetSpell(ctx.SPI.FinalReckoning)
        end,

        SpellJudgment=function(ctx)
          return ctx:GetSpell(ctx.SPI.Judgment)
        end,

        HasTalentBlessedChampion=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.BlessedChampion)
        end,

        HasTalentBoundlessJudgment=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.BoundlessJudgment)
        end,

        HasTalentCrusade=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.Crusade)
        end,

        HasTalentDivineAuxiliary=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.DivineAuxiliary)
        end,

        HasTalentExecutionSentence=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.ExecutionSentence)
        end,

        HasTalentFinalReckoning=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.FinalReckoning)
        end,

        HasTalentHolyBlade=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.HolyBlade)
        end,

        HasTalentVanguardsMomentum=function(ctx)
          return ctx:HasTalentByID(ctx.SPI.VanguardsMomentum)
        end,

        WingsOn=function(ctx)
          return ctx.vars.BuffCrusade.active
          or ctx.vars.BuffAvengingWrath.active
        end,

        IsModePreCombat=function(ctx)
          return  not ctx.vars.IsFighting
        end,

        IsModeFinishers=function(ctx)
          return ctx.vars.HolyPower == 5 or 
          ctx.vars.WingsOn or
          ((ctx.vars.DebuffJudgment.active or ctx.vars.HolyPower == 4)  and ctx.vars.BuffDivineResonance.active)
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsBossFight
          or ctx.vars.IsPvp
          or (ctx.vars.Targets >= 2 
            and ctx.vars.HealthPercent < 0.7)
          or ctx.vars.HealthPercent < 0.5 
          
        end,

        LastConsecrationTime=function(ctx)
          return (
            ctx.vars.LastCastSpell == ctx.SPI.Consecration and 
            ctx.vars.LastCastTime
          ) or ctx.vars.LastConsecrationTime or 0
        end,

        NeedsConsecration=function(ctx)
          return (ctx.vars.Now - (ctx.vars.LastConsecrationTime or 0)) >= 8.5
        end,

        HealthIsCritical=function(ctx)
          return ctx.vars.HealthPercent <= 0.2
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent <= 0.4
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent <= 0.8
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthChangingRate < 0
        end,

        IsTemplarsVerdictValid=function(ctx)
          return not IsPlayerSpell(ctx.SPI.JusticarSVengeance)
        end,

        IsCrusaderStrikeValid=function(ctx)
          return not IsPlayerSpell(ctx.SPI.TemplarStrike)
        end,

      }
    }

  end
end
