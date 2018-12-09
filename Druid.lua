local addon_name, Main = ...

local function L(text)
  return (Main.Strings and Main.Strings[text]) or text
end

--[[
feral priority list:

-- healing

Renewal 
  LowHealth
  
Regrowth
  PredatorySwiftnessBuff
  
FrenziedRegenaration
  DamageReceived >= 0.01 and IsBearForm

   
SurvivalInstincts
  DamageReceived >= 0.01
  
-- prepare to apply rip:
TigersFury
  Energy <= 20
  or 
  (RipDebuff == 0 and ComboPoints == 5)
  or
  RipDebuff <= 7


-- combo-point spenders and bleed maintenance
Trash
  Mobs >= 4 and TrashDebuff < 4
  

SavageRoar (52610) 
  SavageRoarBuff <= 4

Rip 
  (ComboPoints == 5 and RipDebuff == 0)
  or
  (RipDebuff <= 7 and not SabertoothTalent and TargetHealthPercent > 0.25)
  
FerociousBite (22568) 
    RipDebuff <= 7
    or ComboPoints == 5

-- build combo-points

Rake-Stealth
  Prowl 

AshamanesFrenzy
  ComboPoints < 3 and TigersFuryBuff > 0

  
Rake (1822) 

Swipe
  Mobs > 1
  or
  IsBearForm
  
  
Shred

Moonfire (8921)
  LunarInspirationTalent and MoonfireDebuff <= 4
  
Ironfur
  IsBearForm


Thrash
  IsBearForm
  
Mangle
  IsBearForm
  



]]
  if select(2, UnitClass("player")) == 'DRUID' then
  
    local function MyGetSpellInfo(id)
      local s = GetSpellInfo(id) or false
      return s
    end
  
    local SPI = {
      CatForm             = 768,
      BearForm            = 5487,
      Thrash              = 106830,
      zz = 0
    }
    
		local SPN = Main:CreateSpellNames(SPI)

    local SABERTOOTH_ROW = 6
    local SABERTOOTH_COL = 1
    local LUNAR_INPIRATION_ROW = 1
    local LUNAR_INPIRATION_COL = 3
    local BLOODTALONS_ROW = 7
    local BLOODTALONS_COL = 2
    
    local BAL = "Balance"
    local FER = "Feral"
    local FERAL = "Feral"
    local GRD = "Guardian"
    local RST = "Restauration"

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

    ---------------------------------------------------------------------------
    -- Feral
    ---------------------------------------------------------------------------
    local feral = {}

		feral.SPI = {
			ApexPredator 					= 255984, 
			Berserk 							= 106951, 
			Bloodlust 						= 2825, 
			Bloodtalons 					= 155672, 
			BrutalSlash 					= 202028, 
			FeralFrenzy 					= 274837, 
			FerociousBite 				= 22568, 
			FrenziedRegenaration 	= 22842,
			Heroism 							= 32182, 
			Ironfur 							= 192081,
			JaggedWounds 					= 202032, 
			KingOftheJungle 			= 102543, 
			LunarInspiration 			= 155580,
			MassEntanglement			= 102359,
			MightyBash						= 5211,
			MomentOfClarity 			= 236068, 
			Moonfire 							= 8921, 
			OmenOfClarity 				= 16864, 
			Predator 							= 202021, 
			PredatorySwiftness 		= 16974, 
			PrimalFury 						= 159286, 
			Prowl 								= 24450, 
			Rake 									= 1822, 
			Regrowth 							= 8936,
			Renewal								= 108238,
			Rip 									= 1079, 
			SavageRoar 						= 52610, 
			Shred 								= 5221, 
			SkullBash							= 106839,
			Swipe 								= 213764, 
			Thrash 								= 106830, 
			TigersFury 						= 5217, 
			Typhoon								= 132469,
			zz = 0
		}
		
		feral.SPN = Main:CreateSpellNames(feral.SPI)
		
		
		feral.onBerserk = function(this, Ctx)
			return Ctx.IsBossFight or Ctx.Attackers > 1 or Ctx.IsPvp
		end


		feral.onBrutalSlash = function(this, Ctx)
			return true
		end


		feral.onFeralFrenzy = function(this, Ctx)
			return Ctx.ComboPoints == 0
		end


		feral.onFerociousBite = function(this, Ctx)
			return (
				((Ctx.TargetHealthPercent > 0.5 or Ctx.IsBossFight) and Ctx.ComboPoints > 4) or 
				(not Ctx.IsBossFight and Ctx.HealthPercent <= 0.5 and Ctx.ComboPoints > 2)
			) and 
				Ctx.RipDebuff > Ctx.GCD * 2 and
				Ctx.SavageRoarBuff > Ctx.GCD * 2
		end


		feral.onFerociousBiteRip = function(this, Ctx)
			return Ctx.RipDebuff > 0 and Ctx.RipDebuff < Ctx.GCD * 2
		end


		feral.onFrenziedRegeneration = function(this, Ctx)
			return Ctx.HealthPercent < 0.5
		end


		feral.onIronfur = function(this, Ctx)
			return Ctx.HealthPercent < 0.5 
				or Ctx.Attackers > 1
		end


		feral.onKingOfTheJungle = function(this, Ctx)
			return Ctx.IsBossFight or Ctx.Attackers > 1 or Ctx.IsPvp
		end


		feral.onMoonfire = function(this, Ctx)
			return Ctx.HasLunarInspiration
		end


		feral.onMightyBash = function(this, Ctx)
			return true
		end


		feral.onProwl = function(this, Ctx)
			return true
		end


		feral.onRake = function(this, Ctx)
			return Ctx.RakeDebuff < Ctx.GCD * 2
		end


		feral.onRegrowth = function(this, Ctx)
			return (
				Ctx.HealthPercent < 0.5 
				or (Ctx.HasBloodtalons and Ctx.ComboPoints > 3)
			) and not Ctx.RegrowthBuff
		end


		feral.onRenewal = function(this, Ctx)
			return Ctx.HealthPercent < 0.5
		end


		feral.onRip = function(this, Ctx)
			return (
				(Ctx.IsBossFight and Ctx.ComboPoints > 4) or 
				(not Ctx.IsBossFight and Ctx.ComboPoints > 2)
			) and Ctx.RipDebuff < Ctx.GCD * 2
		end


		feral.onSavageRoar = function(this, Ctx)
			return (
				(Ctx.IsBossFight and Ctx.ComboPoints > 4) or 
				(not Ctx.IsBossFight and Ctx.ComboPoints > 2)
			) and Ctx.SavageRoarBuff < Ctx.GCD * 2 
		end


		feral.onShred = function(this, Ctx)
			return true
		end


		feral.onSwipe = function(this, Ctx)
			return true
		end


		feral.onThrash = function(this, Ctx)
			return Ctx.ThrashDebuff < Ctx.GCD * 2
		end


		feral.onTigersFury = function(this, Ctx)
			return Ctx.Energy <= 30
		end


		feral.onTyphoon = function(this, Ctx)
			return Ctx.isPvp or Ctx.Attackers > 1 
		end


		feral.init = function(this, Ctx)
			local aura = GetShapeshiftForm()
			Ctx.IsBear          		= aura == 1
			Ctx.IsCat           		= aura == 2
			Ctx.ComboPoints     		= GetComboPoints("player", "target")
			Ctx.Energy 							= UnitPower("player", SPELL_POWER_ENERGY)
			Ctx.TargetHealthPercent = (UnitLevel("target") ~= 0 and UnitHealth("target")/UnitHealthMax("target")) or 0
			Ctx.HasBloodtalons 			= Ctx:HasTalent(7, 2)
			Ctx.HasMomentOfClarity 	= Ctx:HasTalent(7, 1)
			Ctx.HasLunarInspiration = Ctx:HasTalent(1, 3)
			Ctx.HasKingOfTheJungle 	= IsPlayerSpell(feral.SPI.KingOftheJungle)
			Ctx.HasBrutalSlash			= IsPlayerSpell(feral.SPI.BrutalSlash)
			
			local c, d = Ctx:CheckBuff(feral.SPN.SavageRoar)
			Ctx.SavageRoarBuff = d
			
			c, d = Ctx:CheckDebuff(feral.SPN.Rake)
			Ctx.RakeDebuff = d
			
			c, d = Ctx:CheckDebuff(feral.SPN.Rip)
			Ctx.RipDebuff = d

			c, d = Ctx:CheckDebuff(feral.SPN.Moonfire)
			Ctx.MoonfireDebuff = d
			
			c, d = Ctx:CheckDebuff(feral.SPN.Thrash)
			Ctx.ThrashDebuff = d
			
			c, d = Ctx:CheckBuff(feral.SPN.Regrowth)
			Ctx.RegrowthBuff = c > 0
			
			c, d = Ctx:CheckBuff(feral.SPN.TigersFury)
			Ctx.TigersFuryBuff = d
			
			c, d = Ctx:CheckBuff(feral.SPN.PredatorySwiftness)
			Ctx.PredatorySwiftnessBuff = d
			
			c, d = Ctx:CheckBuff(feral.SPN.Prowl)
			Ctx.ProwlBuff = c > 0
			
			c, d = Ctx:CheckBuff(feral.SPN.OmenOfClarity)
			Ctx.OmenOfClarityBuff = c > 0
			
						
		end
    
    function Main:GetEngine()
      return self:InitSpecs(
        {BAL, SKIP},
        {FER, SKIP},
        {GRD, SKIP},
        {RST, SKIP},

        --======================================================================
        -- GUARDIAN
        ------------------------------------------------------------------------
        -- spells
        ------------------------------------------------------------------------
        {GRD, SPELL, "thrash",      SPN.Thrash,         ON_COOLDOWN},
        

        ------------------------------------------------------------------------
        -- rotation
        ------------------------------------------------------------------------
        {GRD, PRIO, {}},
        {GRD, AOE,  {}},

        ------------------------------------------------------------------------
        -- slots, interrupts, etc
        ------------------------------------------------------------------------
        {GRD, INIT, Init},
        {GRD, INT, "skull-bash"},
        {GRD, SLOT1, SPELL, {SPN.BearForm}, string.format(L"Your aura must be in %s.", SPN.BearForm)},
        {GRD, VAR, "AoeMin", 0},
        {GRD, TBAR, "4"},
        
        --======================================================================
        -- FERAL
        ------------------------------------------------------------------------
        -- spells
        ------------------------------------------------------------------------
				{FERAL, SPELL, "berserk", 									feral.SPI.Berserk, 							feral.onBerserk, NoTarget=true},
				{FERAL, SPELL, "brutal-slash", 							feral.SPI.BrutalSlash, 					feral.onBrutalSlash, RangeSpell = feral.SPI.Rake},
				{FERAL, SPELL, "feral-frenzy", 							feral.SPI.FeralFrenzy, 					feral.onFeralFrenzy},
				{FERAL, SPELL, "ferocious-bite", 						feral.SPI.FerociousBite, 				feral.onFerociousBite},
				{FERAL, SPELL, "ferocious-bite-rip", 				feral.SPI.FerociousBite, 				feral.onFerociousBiteRip},
				{FERAL, SPELL, "frenzied-regeneration", 		feral.SPI.FrenziedRegenaration, feral.onFrenziedRegeneration, NoTarget=true},
				{FERAL, SPELL, "king-of-the-jungle", 				feral.SPI.KingOftheJungle, 			feral.onKingOfTheJungle},
				{FERAL, SPELL, "ironfur", 									feral.SPI.Ironfur, 							feral.onIronfur, NoTarget=true},
				{FERAL, SPELL, "mighty-bash", 							feral.SPI.MightyBash, 					feral.onMightyBash},
				{FERAL, SPELL, "moonfire", 									feral.SPI.Moonfire, 						feral.onMoonfire},
				{FERAL, SPELL, "rake", 											feral.SPI.Rake, 								feral.onRake},
				{FERAL, SPELL, "regrowth", 									feral.SPI.Regrowth, 						feral.onRegrowth},
				{FERAL, SPELL, "renewal", 									feral.SPI.Renewal, 							feral.onRenewal, NoTarget=true},
				{FERAL, SPELL, "rip", 											feral.SPI.Rip, 									feral.onRip},
				{FERAL, SPELL, "savage-roar", 							feral.SPI.SavageRoar, 					feral.onSavageRoar},
				{FERAL, SPELL, "shred", 										feral.SPI.Shred, 								feral.onShred},
				{FERAL, SPELL, "skull-bash", 								feral.SPI.SkullBash,						ON_COOLDOWN},
				{FERAL, SPELL, "swipe", 										feral.SPI.Swipe, 								feral.onSwipe},
				{FERAL, SPELL, "thrash", 										feral.SPI.Thrash, 							feral.onThrash},
				{FERAL, SPELL, "tigers-fury", 							feral.SPI.TigersFury, 					feral.onTigersFury},		
				{FERAL, SPELL, "typhoon", 									feral.SPI.Typhoon, 							feral.onTyphoon},		

        ------------------------------------------------------------------------
        -- rotation
        ------------------------------------------------------------------------
				{FER, PRIO, "renewal"},
				{FER, PRIO, "frenzied-regeneration"},
				{FER, PRIO, "regrowth"},
				{FER, PRIO, "ironfur"},
				{FER, PRIO, "tigers-fury"},
				{FER, PRIO, "feral-frenzy"},
				{FER, PRIO, "berserk"},
				{FER, PRIO, "king-of-the-jungle"},
				{FER, PRIO, "ferocious-bite-rip"},
				{FER, PRIO, "rip"},
				{FER, PRIO, "savage-roar"},
				{FER, PRIO, "ferocious-bite"},
				{FER, PRIO, "thrash"},
				{FER, PRIO, "rake"},
				{FER, PRIO, "moonfire"},
				{FER, PRIO, "brutal-slash"},
				{FER, PRIO, "shred"},
				{FER, PRIO, "swipe"},
				{FER, PRIO, "typhoon"},
				{FER, PRIO, "mighty-bash"},
				
				
				

        ------------------------------------------------------------------------
        -- slots, interrupts, etc
        ------------------------------------------------------------------------
        {FER, INIT, feral.init},
        {FER, INT, "skull-bash"},
        {FER, SLOT1, SPELL, "berserk"},
        {FER, SLOT3, DEBUFF, {feral.SPN.Rip}},
        {FER, SLOT4, DEBUFF, {feral.SPN.Rake}},
        
        {FER, VAR, "AoeMin", 0},
        {FER, TBAR, "4"}
        
      )
    end  -- function Main:GetEngine
  end -- if ... DRUID
