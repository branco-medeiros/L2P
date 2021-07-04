local L2P = LibStub("AceAddon-3.0"):GetAddon("L2P")
function L2P:GetSpecData(ctx) 
  if not ctx.vars.Spec then 
    return {}
  
  elseif ctx.vars.Spec == "PALADIN-3" then
    return {
      SPI = {
        ArcaneTorrent = 155145,
        AshenHallow = 316958,
        AvengingWrath = 31884,
        BladeOfJustice = 184575,
        BlessingOfAutumn = 328622,
        BlessingOfSpring = 328282,
        BlessingOfSummer = 328620,
        BlessingOfWinter = 328281,
        BloodOfTheEnemy = 297108,
        ConcentratedFlame = 295373,
        Consecration = 26573,
        ConsecrationDebuff = 204242,
        Crusade = 231895,
        CrusaderStrike = 35395,
        DivinePurpose = 223817,
        DivineShield = 642,
        DivineStorm = 53385,
        DivineToll = 304971,
        EmpyreanPower = 326733,
        ExecutionSentence = 343527,
        FinalReckoning = 343721,
        FlashOfLight = 19750,
        FocusedAzeriteBeam = 299336,
        GuardianOfAzeroth = 299358,
        HammerOfJustice = 853,
        HammerOfWrath = 24275,
        HandOfHindrance = 183218,
        HolyAvenger = 105809,
        Judgment = 20271,
        LayOnHands = 633,
        MemoryOfLucidDreams = 299374,
        PurifyingBlast = 299347,
        Rebuke = 96231,
        SelflessHealer = 114250,
        Seraphim = 152262,
        ShieldOfTheRighteous = 53600,
        ShieldOfVengeance = 184662,
        TemplarSVerdict = 85256,
        TheUnboundForce = 298452,
        VanquisherSHammer = 328204,
        VisionOfPerfection = 303344,
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
            return ctx.vars.HealthIsLow 
              and ctx.vars.IsBeingDamaged
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
            return ctx.vars.HealthIsLow 
              and ctx.vars.IsBeingDamaged
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

        {Key="flash-of-light", SpellId=19750, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsLow
          end
        },

        {Key="seraphin", SpellId=152262, Role={ "preparation","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.FinalReckoningActive or
            ctx.vars.ExecutionSentenceActive or
            ctx.vars.WingsOn
          end
        },

        {Key="execution-sentence", SpellId=343527, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBossFight or 
            ctx.vars.TargetNotDying
          end
        },

        {Key="shield-of-the-righteous", SpellId=53600, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasShieldsEquipped
          end
        },

        {Key="divine-storm", SpellId=53385, Role={ "dps","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.EmpyreanPowerActive or 
            (ctx.vars.MultipleTargets and 
              (ctx.vars.Has5HP or
               ctx.vars.HolyAvengerActive or
               ctx.vars.WingsOn
              )
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
            ctx.vars.HolyAvengerActive or
            ctx.vars.WingsOn
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

        {Key="divine-toll-no-hp", SpellId=304971, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight 
              and (ctx.vars.DivineTollOneEnemy
              or ctx.vars.DivineTollMoreEnemies)
          end
        },

        {Key="holy-avenger", SpellId=105809, Role={ "preparation","cooldown", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
          end
        },

        {Key="wake-of-ashes", SpellId=255937, Role={ "dps","generator", },
          Description="",
          RangeSpell=35395, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasLessThan3HP and not ctx.vars.HolyAvengerActive
          end
        },

        {Key="judgment", SpellId=20271, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.HolyAvengerActive and 
            ctx.vars.HasLessThan3HP) or 
            ctx.vars.HasLessThan5HP
          end
        },

        {Key="blade-of-justice", SpellId=184575, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.HolyAvengerActive and 
            ctx.vars.HasLessThan3HP) or 
            ctx.vars.HasLessThan5HP
          end
        },

        {Key="hammer-of-wrath", SpellId=24275, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.HolyAvengerActive and 
            ctx.vars.HasLessThan3HP) or 
            ctx.vars.HasLessThan5HP
          end
        },

        {Key="crusader-strike", SpellId=35395, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.HolyAvengerActive and 
            ctx.vars.HasLessThan3HP) or 
            ctx.vars.HasLessThan5HP
          end
        },

        {Key="divine-toll", SpellId=304971, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.MultipleAttackers
          end
        },

        {Key="vanquishers-hammer", SpellId=328204, Role={ "dps","spender","preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="blessing-of-summer", SpellId=328620, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="blessing-of-autumn", SpellId=328622, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="blessing-of-winter", SpellId=328281, Role={ "survival","dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="blessing-of-spring", SpellId=328282, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="ashen-hallow", SpellId=316958, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
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

        {Key="word-of-glory-filler", SpellId=85673, Role={ "heal","spender", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=true,
          Condition=function(this, ctx)
            return ctx.HealthIsMedium
          end
        },

        {Key="consecration", SpellId=26573, Role={ "hinder","spender", },
          Description="",
          RangeSpell=35395, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsNotMoving 
              and not ctx.vars.WingsOn
              and not ctx.vars.HolyAvengerActive
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
        Has5HP=function(ctx)
          return ctx.vars.HolyPower == 5
        end,

        HasNoHP=function(ctx)
          return ctx.vars.HolyPower == 0
        end,

        CanGenerateHP=function(ctx)
          return (ctx:GetSpell(ctx.SPI.CrusaderStrike).cooldown <= ctx.vars.GCD
          or ctx:GetSpell(ctx.SPI.BladeOfJustice).cooldown <= ctx.vars.GCD
          or ctx:GetSpell(ctx.SPI.HammerOfWrath).cooldown <= ctx.vars.GCD
          or ctx:GetSpell(ctx.SPI.Judgment).cooldown <= ctx.vars.GCD
          or ctx:GetSpell(ctx.SPI.WakeOfAshes).cooldown <= ctx.vars.GCD) and
          ctx.vars.HolyPower < 3
        end,

        HasLessThan4HP=function(ctx)
          return ctx.vars.HolyPower < 4
        end,

        FinalReckoningActive=function(ctx)
          return ctx:GetDebuff(ctx.SPI.Reckoning).active or 
          ctx:GetDebuff(ctx.SPI.FinalReckoning).active
        end,

        ExecutionSentenceActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.ExecutionSentence).active
        end,

        HasLessThan3HP=function(ctx)
          return ctx.vars.HolyPower < 3 
        end,

        EmpyreanPowerActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.EmpyreanPower).active
        end,

        HolyAvengerActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.HolyAvenger).active
        end,

        HasLessThan5HP=function(ctx)
          return ctx.vars.HolyPower < 5
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

        HasConsecrationDebuff=function(ctx)
          return ctx:GetDebuff(ctx.SPI.ConsecrationDebuff).active
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

        WingsOn=function(ctx)
          return ctx:GetBuff(ctx.SPI.AvengingWrath).active
            or ctx:GetBuff(ctx.SPI.Crusade).active
        end,

        DivineTollOneEnemy=function(ctx)
          local fr = ctx.vars.FinalRecogningActive;
          local hp = ctx.vars.HolyPower; 
          return ctx.vars.Enemies == 1 and (
            (fr and hp < 3) or
            (not fr and hp < 5)
          )
           
        end,

        DivineTollMoreEnemies=function(ctx)
          return ctx.vars.Enemies > 1 
            and not ctx.vars.FinalRecogningActive
            and (ctx.vars.HolyPower + min(5, ctx.vars.Enemies)) < 6
          
        end,

      }
    }

  elseif ctx.vars.Spec == "PALADIN-2" then
    return {
      SPI = {
        ArcaneTorrent = 155145,
        ArdentDefender = 31850,
        AshenHallow = 316958,
        AvengerSShield = 31935,
        AvengingWrath = 31884,
        BlessingOfSummer = 328620,
        BloodOfTheEnemy = 297108,
        ConcentratedFlame = 295373,
        Consecration = 26573,
        ConsecrationBuff = 188370,
        ConsecrationDebuff = 204242,
        Crusade = 231895,
        DivinePurpose = 223817,
        DivineShield = 642,
        DivineToll = 304971,
        ExecutionSentence = 343527,
        FlashOfLight = 19750,
        FocusedAzeriteBeam = 299336,
        GuardianOfAncientKings = 86659,
        GuardianOfAzeroth = 299358,
        HammerOfJustice = 853,
        HammerOfTheRighteous = 53595,
        HammerOfWrath = 24275,
        HandOfHindrance = 183218,
        HolyAvenger = 105809,
        Judgment = 275779,
        Judgment = 20271,
        LayOnHands = 633,
        MemoryOfLucidDreams = 299374,
        PurifyingBlast = 299347,
        Rebuke = 96231,
        Seraphim = 152262,
        ShieldOfTheRighteous = 53600,
        ShiningLight = 321136,
        VanquisherSHammer = 328204,
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
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
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
              and ctx.vars.IsBeingAttacked 
              
          end
        },

        {Key="ardent-defender", SpellId=31850, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
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

        {Key="word-of-glory", SpellId=85673, Role={ "heal", },
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
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium
              and ctx.vars.HasLessThan3HP
          end
        },

        {Key="shield-of-the-righteous-5hp", SpellId=53600, Role={ "dps", },
          Description="",
          RangeSpell=53595, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.Has5Hp or 
              ctx.vars.AvengingWrathActive or 
              ctx.vars.DivinePurposeActive or
              ctx.vars.HolyAvengerActive
          end
        },

        {Key="consecration", SpellId=26573, Role={ "preparation","hinder","dps", },
          Description="",
          RangeSpell=53595, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsNotMoving
            and (ctx.vars.NoConsecrationDebuff 
            or ctx.vars.NoConsecrationBuff)
          end
        },

        {Key="avengers-shield-multitarget", SpellId=31935, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.Targets > 2
          end
        },

        {Key="divine-toll", SpellId=304971, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return (ctx.vars.IsBossFight
              or ctx.vars.HasManyEnemies
              or ctx.vars.IsPvp)
              and (ctx.vars.DivineTollOneEnemy
              or ctx.vars.DivineTollMoreEnemies)
          end
        },

        {Key="judgment", SpellId=275779, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.WillNotCapHP
          end
        },

        {Key="hammer-of-wrath", SpellId=24275, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.WillNotCapHP
          end
        },

        {Key="avengers-shield", SpellId=31935, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="hammer-of-the-righteous", SpellId=53595, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.WillNotCapHP
          end
        },

        {Key="word-of-glory-free", SpellId=85673, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsMedium and 
              ctx.vars.HasShiningLightBuff
          end
        },

        {Key="consecration-filler", SpellId=26573, Role={ "preparation","dps","hinder", },
          Description="",
          RangeSpell=53595, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsNotMoving
            and (ctx.vars.NoConsecrationDebuff 
            or ctx.vars.NoConsecrationBuff)
          end
        },

        {Key="hammer-of-justice", SpellId=853, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.isPvp
          end
        },

        {Key="hand-of-hindrance", SpellId=183218, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.isPvp
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
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
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
        HealthIsCritical=function(ctx)
          return ctx.vars.HealthPercent <= 0.2
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthRate < 0
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent < 0.4
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent < 0.75
        end,

        HasShiningLightBuff=function(ctx)
          return ctx:GetBuff(ctx.SPI.ShiningLight).active
        end,

        IsBeingAttacked=function(ctx)
          return ctx.vars.HealthRate < 0
        end,

        NoConsecrationDebuff=function(ctx)
          return ctx:GetDebuff(ctx.SPI.ConsecrationDebuff).remaining <= 2
        end,

        IsNotMoving=function(ctx)
          return not ctx.vars.IsMoving
        end,

        Has5Hp=function(ctx)
          return ctx.vars.HolyPower == 5
        end,

        AvengingWrathActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.AvengingWrath).active
        end,

        DivinePurposeActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.DivinePurpose).active
        end,

        HealthIsAlmostCritical=function(ctx)
          return ctx.vars.HealthPercent <= 0.3
        end,

        NotInCombat=function(ctx)
          return not UnitAffectingCombat("player")
        end,

        DivineTollOneEnemy=function(ctx)
          local fr = ctx.vars.FinalRecogningActive;
          local hp = ctx.vars.HolyPower; 
          return ctx.vars.Enemies == 1 and (
            (fr and hp < 3) or
            (not fr and hp < 5)
          )
           
        end,

        DivineTollMoreEnemies=function(ctx)
          return ctx.vars.Enemies > 1 
            and not ctx.vars.FinalRecogningActive
            and (ctx.vars.HolyPower + min(5, ctx.vars.Enemies)) < 6
          
        end,

        HasLessThan3HP=function(ctx)
          return ctx.vars.HolyPower < 3
        end,

        HasLessThan5HP=function(ctx)
          return ctx.vars.HolyPower < 5
        end,

        HolyAvengerActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.HolyAvenger).active
        end,

        WillNotCapHP=function(ctx)
          return (ctx.vars.HolyAvengerActive 
            and ctx.vars.HasLessThan3HP) 
            or ctx.vars.HasLessThan5HP
        end,

        HasManyEnemies=function(ctx)
          return ctx.vars.Enemies > 2
        end,

        NoConsecrationBuff=function(ctx)
          return not ctx:GetBuff(ctx.SPI.ConsecrationBuff).active
        end,

      }
    }

  elseif ctx.vars.Spec == "DEATH-KNIGHT-1" then
    return {
      SPI = {
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
      },

      prios = {
      },

      slots={
      },

      code={
      }
    }

  elseif ctx.vars.Spec == "WARRIOR-1" then
    return {
      SPI = {
        AncientAftershock = 325886,
        Avatar = 107574,
        Bladestorm = 227847,
        Cleave = 845,
        ColossusSmash = 167105,
        Condemn = 317349,
        ConquerorSBanner = 324143,
        DeadlyCalm = 262228,
        DeepWounds = 262115,
        DefensiveStance = 197690,
        DieByTheSword = 118038,
        Execute = 163201,
        FocusedAzeriteBeam = 299336,
        GuardianOfAzeroth = 299358,
        Hamstring = 1715,
        IgnorePain = 190456,
        ImpendingVictory = 202168,
        IntimidatingShout = 5246,
        MemoryOfLucidDreams = 299374,
        MortalStrike = 12294,
        Overpower = 7384,
        Pummel = 6552,
        PurifyingBlast = 299347,
        Rend = 772,
        Skullsplitter = 260643,
        Slam = 1464,
        SpearOfBastion = 307865,
        StormBolt = 107570,
        SweepingStrikes = 260708,
        TheUnboundForce = 298452,
        VictoryRush = 34428,
        Warbreaker = 262161,
        Whirlwind = 1680,
      },

      prios = {
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

        {Key="conquerors-banner", SpellId=324143, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsDangerousFight
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

        {Key="rend", SpellId=772, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.RendDebuffExpiring
          end
        },

        {Key="cleave-urgent", SpellId=845, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.IsAoe
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

        {Key="mortal-strike-urgent", SpellId=12294, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.DeepWoundsExpiring
              or ctx.vars.HasBuffOverpower
          end
        },

        {Key="skullsplitter", SpellId=260643, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.RageCanGrow20 
              and ctx.vars.BladeStormOnCooldown
          end
        },

        {Key="deadly-calm", SpellId=262228, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
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

        {Key="condemn", SpellId=317349, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="execute", SpellId=163201, Role={ "dps", },
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

        {Key="ancient-aftershock", SpellId=325886, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="spear-of-bastion", SpellId=307865, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
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
              or ctx.vars.HasBuffColossusSmash
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

        {Key="ignore-pain", SpellId=190456, Role={ "heal", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBeingDamaged 
              and ctx.vars.HealthIsMedium
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
        DeepWoundsExpiring=function(ctx)
          return ctx:GetDebuff(ctx.SPI.DeepWounds).remaining < 4
        end,

        HasManyEnemies=function(ctx)
          return ctx.vars.Targets > 3 or ctx.vars.Attackers > 3
        end,

        HasBuffColossusSmash=function(ctx)
          return ctx:GetBuff(ctx.SPI.ColossusSmash).active
        end,

        RageCanGrow20=function(ctx)
          return (ctx.vars.Rage + 20) <= ctx.vars.RageMax
        end,

        BladeStormOnCooldown=function(ctx)
          return ctx:GetSpell(ctx.SPI.Bladestorm).cooldown > 0
        end,

        IsAoe=function(ctx)
          return ctx.vars.Targets > 1 or ctx.vars.Attackers> 1
        end,

        HasBuffOverpower=function(ctx)
          return ctx:GetBuff(ctx.SPI.Overpower).active
        end,

        HasTalentFervorOfTheBattle=function(ctx)
          return ctx:HasTalent(3, 2)
        end,

        RendDebuffExpiring=function(ctx)
          return ctx:GetDebuff(ctx.SPI.Rend).remaining < 4
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent <= 0.7
        end,

        ColossusSmashEnabled=function(ctx)
          return ctx:GetSpell(ctx.SPI.ColossusSmash).cooldown < ctx.vars.GCD
        end,

        WarbreakerEnabled=function(ctx)
          return ctx:HasTalent(5, 2) 
            and ctx:GetSpell(ctx.SPI.Warbreaker).cooldown < ctx.vars.GCD
          
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

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent < 0.45
        end,

        TargetedByBoss=function(ctx)
          return ctx.vars.IsBossFight 
            and UnitIsUnit("boss1target", "player") 
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthRate < 0
        end,

      }
    }

  elseif ctx.vars.Spec == "DEMONHUNTER-1" then
    return {
      SPI = {
        Annihilation = 201427,
        BladeDance = 188499,
        Blur = 198589,
        ChaosNova = 179057,
        ChaosStrike = 162794,
        ConsumeMagic = 278326,
        Darkness = 196718,
        DeathSweep = 210152,
        DemonSBite = 162243,
        Disrupt = 183752,
        ElysianDecree = 306830,
        EssenceBreak = 258860,
        EyeBeam = 198013,
        FelBarrage = 258925,
        Felblade = 232893,
        FelRush = 195072,
        FodderToTheFlame = 329554,
        GlaiveTempest = 342817,
        ImmolationAura = 258920,
        InnerDemons = 337548,
        Metamorphosis = 191427,
        Netherwalk = 196555,
        SinfulBrand = 317009,
        TheHunt = 323639,
        ThrowGlaive = 185123,
        UnboundChaos = 347462,
        VengefulRetreat = 198793,
      },

      prios = {
        {Key="netherwalk", SpellId=196555, Role={ "survival", },
          Description="Run, little girl, run!",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.AboutToDie and
              ctx.vars.IsBeingDamaged
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

        {Key="elysian-decree", SpellId=306830, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="sinful-brand", SpellId=317009, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="the-hunt", SpellId=323639, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="fodder-to-the-flame", SpellId=329554, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="fel-rush-umbounded", SpellId=195072, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.UnboundChaosActive
          end
        },

        {Key="glaive-tempest", SpellId=342817, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="fel-rush-momentum", SpellId=195072, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasMomentumTalent 
              and ctx.vars.MomentumExpiring
          end
        },

        {Key="vengeful-retreat-momentum", SpellId=198793, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasMomentumTalent
              and ctx.vars.FuryLevelCanGrow
          end
        },

        {Key="essence-break", SpellId=258860, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.FuryLevelHigh
          end
        },

        {Key="immolation-aura", SpellId=258920, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.FuryLevelCanGrow
          end
        },

        {Key="death-sweep", SpellId=210152, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasManyEnemies 
              or ctx.vars.HasFirstBloodTalent
          end
        },

        {Key="blade-dance", SpellId=188499, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasManyEnemies
              or ctx.vars.HasFirstBloodTalent
            
          end
        },

        {Key="eye-beam", SpellId=198013, Role={ "dps", },
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
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="felblade", SpellId=232893, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.FuryLevelCanGrow40
          end
        },

        {Key="annihilation", SpellId=201427, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.FuryLevelCanGrow20
          end
        },

        {Key="chaos-strike", SpellId=162794, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="throw-glaive-aoe", SpellId=185123, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasMultipleTargets
          end
        },

        {Key="demons-bite", SpellId=162243, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.FuryLessThan25
          end
        },

        {Key="throw-glaive", SpellId=185123, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="chaos-nova", SpellId=179057, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="fel-rush", SpellId=195072, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="metamorphosis", SpellId=191427, Role={ "slot", },
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
        {Type="spell", Spell=191427, 
          Description="Metamorphosis: your main cooldown",
          Icon="", Overlay=false, Charges=false
        },
        {Type="spell", Spell=278326, 
          Description="Consume Magic: steal a magic effect from the target",
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

        MomentumExpiring=function(ctx)
          return ctx:GetBuff(ctx.SPI.Momentum).remaining < 2.5
        end,

        FuryLevelHigh=function(ctx)
          return ctx.vars.Fury >= 80
        end,

        UnboundChaosActive=function(ctx)
          return ctx:GetBuff(ctx.SPI.UnboundChaos).active
        end,

        HasManyEnemies=function(ctx)
          return ctx.vars.Targets >= 3
        end,

        HasFirstBloodTalent=function(ctx)
          return ctx:HasTalent(5, 2)
        end,

        HasMomentumTalent=function(ctx)
          return ctx:HasTalent(7, 2)
        end,

        FuryLevelCanGrow20=function(ctx)
          return (ctx.Power.Fury + 20) < ctx.Power.FuryMax
        end,

        HasMultipleTargets=function(ctx)
          return ctx.vars.Targets > 1
        end,

        FuryLessThan25=function(ctx)
          return (ctx.Power.Fury + 25) <= ctx.Power.FuryMax
        end,

        FuryLevelCanGrow=function(ctx)
          return (ctx.Power.Fury + 15) < ctx.Power.FuryMax
        end,

        FuryLevelCanGrow40=function(ctx)
          return (ctx.Power.Fury + 40) <= ctx.Power.FuryMax
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthRate < 0
        end,

        AboutToDie=function(ctx)
          return ctx.vars.HealthPercent <= 0.2
        end,

      }
    }

  elseif ctx.vars.Spec == "WARRIOR-3" then
    return {
      SPI = {
        AncientAftershock = 325886,
        Avatar = 107574,
        BattleShout = 6673,
        BerserkerRage = 18499,
        Bladestorm = 46924,
        Bloodbath = 12292,
        Cleave = 845,
        CleaveBuff = 188923,
        ColossusSmash = 167105,
        ColossusSmashDebuff = 208086,
        ConcentratedFlame = 295373,
        Condemn = 317349,
        ConquerorSBanner = 324143,
        DeepWounds = 115767,
        DemoralizingShout = 1160,
        Devastate = 20243,
        DragonRoar = 118000,
        Execute = 163201,
        FocusedRage = 207982,
        HeroicLeap = 6544,
        HeroicThrow = 174529,
        IgnorePain = 190456,
        ImpendingVictory = 202168,
        Intercept = 198304,
        IntimidatingShout = 5246,
        LastStand = 12975,
        MortalStrike = 12294,
        MortalWounds = 115804,
        NeltharionSFury = 203524,
        Overpower = 7384,
        Pummel = 6552,
        RallyingCry = 97462,
        Ravager = 152277,
        Recklessness = 1719,
        Rend = 772,
        Revenge = 6572,
        ShieldBlock = 2565,
        ShieldBlockBuff = 132404,
        ShieldSlam = 23922,
        ShieldWall = 871,
        Shockwave = 46968,
        Slam = 1464,
        SpearOfBastion = 307865,
        StormBolt = 107570,
        SuddenDeath = 52437,
        ThunderClap = 6343,
        Victorious = 32216,
        VictoryRush = 34428,
        Warbreaker = 209577,
        Whirlwind = 1680,
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

        {Key="condemn", SpellId=317349, Role={ "dps","spender","reaction", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="execute", SpellId=163201, Role={ "dps","spender","reaction", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
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

        {Key="revenge-dump-rage", SpellId=6572, Role={ "dps","spender", },
          Description="",
          RangeSpell=23922, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.Rage > 50
              and ctx.vars.HealthIsOk
            
          end
        },

        {Key="shield-slam", SpellId=23922, Role={ "dps","generator", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.CanGenerate15Rage
          end
        },

        {Key="ancient-aftershock", SpellId=325886, Role={ "dps","generator","hinder","dot", },
          Description="",
          RangeSpell=23922, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBossFight
              or ctx.vars.IsPvp
              or ctx.vars.IsAoE
              or ctx.vars.HealthIsLow
            
          end
        },

        {Key="thunder-clap", SpellId=6343, Role={ "dps","generator","hinder", },
          Description="",
          RangeSpell=23922, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.ThunderClapActive
              and ctx.vars.CanGenerate5Rage
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

        {Key="spear-of-bastion", SpellId=307865, Role={ "dps","dot", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBossFight
              or ctx.vars.IsPvp
              or ctx.vars.IsAoE
              or ctx.vars.HealthIsLow
            
          end
        },

        {Key="conqueror-s-banner", SpellId=324143, Role={ "survival","preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBossFight
              or ctx.vars.IsPvp
              or ctx.vars.IsAoE
              or ctx.vars.HealthIsLow
            
          end
        },

        {Key="shockwave", SpellId=46968, Role={ "dps","hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.IsBossFight
              or ctx.vars.IsAoE
          end
        },

        {Key="devastate", SpellId=20243, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
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

        IsAoE=function(ctx)
          return ctx.vars.Enemies > 2
        end,

        WillNotDepleteRage=function(ctx)
          return (ctx.vars.Rage / ctx.vars.RageMax) > 0.8
        end,

        HealthIsOk=function(ctx)
          return ctx.vars.HealthPercent >= 0.75
        end,

        ThunderClapActive=function(ctx)
          return ctx:CheckDebuff(ctx.SPI.ThunderClap).active
        end,

        CanGenerate15Rage=function(ctx)
          return ctx.vars.RageMax - ctx.vars.Rage >= 15
        end,

        CanGenerate5Rage=function(ctx)
          return ctx.vars.RageMax - ctx.vars.Rage >= 5
        end,

      }
    }

  elseif ctx.vars.Spec == "DEMONHUNTER-2" then
    return {
      SPI = {
        ConsumeMagic = 278326,
        DemonSpikes = 203720,
        Disrupt = 183752,
        ElysianDecree = 306830,
        Felblade = 232893,
        FelDevastation = 212084,
        FieryBrand = 204021,
        FodderToTheFlame = 329554,
        Fracture = 263642,
        ImmolationAura = 258920,
        InfernalStrike = 189110,
        Metamorphosis = 187827,
        RazelikhSDefilement = 337544,
        Shear = 203782,
        SigilOfFlame = 204596,
        SinfulBrand = 317009,
        SoulBarrier = 263648,
        SoulCleave = 228477,
        SoulFragments = 203981,
        SpiritBomb = 247454,
        TheHunt = 323639,
        ThrowGlaive = 204157,
      },

      prios = {
        {Key="elysian-decree-pull", SpellId=306830, Role={ "reaction", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.InCombat
          end
        },

        {Key="infernal-strike-pull", SpellId=189110, Role={ "reaction", },
          Description="",
          RangeSpell=204157, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return not ctx.vars.InCombat
          end
        },

        {Key="metamorphosis", SpellId=187827, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HealthIsCritical
              and ctx.vars.IsBeingDamaged
          end
        },

        {Key="soul-barrier", SpellId=263648, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBeingDamaged
              and ctx.vars.HealthIsLow
          end
        },

        {Key="fiery-brand", SpellId=204021, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBossFight
              or ctx.vars.IsPvp
              or ctx.vars.IsDangerousFoe
              or ctx.vars.IsDangerousFight
          end
        },

        {Key="demon-spikes", SpellId=203720, Role={ "survival", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.IsBeingDamaged
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

        {Key="elysian-decree", SpellId=306830, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.TargetIsNear
          end
        },

        {Key="sinful-brand", SpellId=317009, Role={ "hinder", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="the-hunt", SpellId=323639, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="fodder-to-the-flame", SpellId=329554, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="spirit-bomb", SpellId=247454, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasSoulFragments
          end
        },

        {Key="fel-devastation", SpellId=212084, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=true, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="soul-cleave", SpellId=228477, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.HasAtLeast60Fury
          end
        },

        {Key="fracture", SpellId=263642, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.WillNotCap2Souls 
              and ctx.vars.WillNotCap25Fury
          end
        },

        {Key="immolation-aura", SpellId=258920, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=true, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.WillNotCap20Fury
              and ctx.vars.TargetIsNear
          end
        },

        {Key="sigil-of-flame", SpellId=204596, Role={ "preparation", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=true, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
          end
        },

        {Key="shear", SpellId=203782, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return true
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
      },

      code={
        InCombat=function(ctx)
          return UnitAffectingCombat("player")
        end,

        WillNotCap25Fury=function(ctx)
          return (ctx.vars.Fury + 25) <= ctx.vars.FuryMax
        end,

        WillNotCap20Fury=function(ctx)
          return (ctx.vars.Fury + 20) <= ctx.vars.FuryMax
        end,

        IsBeingDamaged=function(ctx)
          return ctx.vars.HealthRate < 0
        end,

        IsDangerousFoe=function(ctx)
          local uc = UnitClassification("target")
          return (uc == "worldboss" 
            or uc == "rareelite" 
            or uc == "elite" 
            or uc == "rare")
            and UnitLevel("target") >= UnitLevel("player")
        end,

        HealthIsLow=function(ctx)
          return ctx.vars.HealthPercent < 0.5
        end,

        HealthIsCritical=function(ctx)
          return ctx.vars.HealthPercent < 0.35
        end,

        IsDangerousFight=function(ctx)
          return ctx.vars.IsBeingDamaged
            and ctx.vars.HealthIsLow
        end,

        HasSoulFragments=function(ctx)
          return ctx:GetBuff(ctx.SPI.SoulFragments).charges > 3
        end,

        HealthIsMedium=function(ctx)
          return ctx.vars.HealthPercent < 0.85
        end,

        InfernalStrikeHasTwoCharges=function(ctx)
          local sp = ctx:GetSpell(ctx.SPI.InfernalStrike)
          return sp.charges > 1 
            or (sp.charges == 1 and sp.NextCharge < 2)
        end,

        WillNotCap2Souls=function(ctx)
          return ctx:GetBuff(ctx.SPI.SoulFragments).charges < 4
        end,

        TargetIsNear=function(ctx)
          return ctx:CheckEnemyIsClose()
        end,

        HasAtLeast60Fury=function(ctx)
          return ctx.vars.Fury >= 60
        end,

      }
    }

  end
end
