local L2P = LibStub("AceAddon-3.0"):GetAddon("L2P")
function L2P:GetClassSpec(ctx) 
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

        {Key="divine-toll-no-hp", SpellId=304971, Role={ "dps", },
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

        {Key="holy-avenger", SpellId=105809, Role={ "preparation", },
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

        {Key="divine-toll", SpellId=304971, Role={ "dps", },
          Description="",
          RangeSpell=nil, PetSpell=nil, ActionSpell=nil,
          NoTarget=false, NoRange=false, NotInstant=false, WhileMoving=false,
          Primary=false, Secondary=false,
          Condition=function(this, ctx)
            return ctx.vars.MultipleAttackers
          end
        },

        {Key="vanquishers-hammer", SpellId=328204, Role={ "dps","generator", },
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

        {Key="blessing-of-winter", SpellId=328281, Role={ "survival", },
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

        {Key="consecration", SpellId=26573, Role={ "hinder", },
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

end