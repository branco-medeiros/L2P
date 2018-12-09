local addon_name, Main = ...

local function L(text)
  return (Main.Strings and Main.Strings[text]) or text
end

  if select(2, UnitClass("player")) == 'HUNTER' then
    local SPN = {
      AMurderOfCrows  = GetSpellInfo(131894),
      AspectOfTheHawk     = GetSpellInfo(109260),
      AspectOfTheironHawk = GetSpellInfo(13165),
      ArcaneShot      = GetSpellInfo(3044),
      BeastCleave     = GetSpellInfo(115939),
      BestialWrath    = GetSpellInfo(19574),
      CobraShot       = GetSpellInfo(77767),
      CounterShot     = GetSpellInfo(147362),
      DireBeast       = GetSpellInfo(120679),
      ExplosiveTrap   = GetSpellInfo(13813),
      FocusFire       = GetSpellInfo(82692),
      Frenzy          = GetSpellInfo(19623),
      GlaiveToss      = GetSpellInfo(117050),
      HuntersMark     = GetSpellInfo(1130),
      KillCommand     = GetSpellInfo(34026),
      KillShot        = GetSpellInfo(53351),
      Misdirection    = GetSpellInfo(34477),
      MultiShot       = GetSpellInfo(2643),
      Rabid           = GetSpellInfo(53401),
      RapidFire       = GetSpellInfo(3045),
      Readiness       = GetSpellInfo(23989),
      SerpentSting    = GetSpellInfo(1978),
      Stampede        = GetSpellInfo(121818),
      SteadyShot      = GetSpellInfo(56641),
      zz = 0
    }

    -- initializes the variables used by conditionals
    local function Init(this, Ctx)

      Ctx.NoHuntersMark = Ctx:CheckDebuff(SPN.HuntersMark) == 0

      local ct, exp = Ctx:CheckDebuff(SPN.SerpentSting)
      Ctx.NeedSerpentSting = ct == 0
      Ctx.SerpentStingExpiring = exp <= 4

      Ctx.FrenzyCap = Ctx:CheckBuff(SPN.Frenzy, "pet") == 5
      Ctx.Focus = 100 * UnitPower("player", SPELL_POWER_FOCUS) / UnitPowerMax("player", SPELL_POWER_FOCUS)
      Ctx.TooMuchFocus = Ctx.Focus > 60
      Ctx.NeedMoreFocus = Ctx.Focus <= 40
      Ctx.NeedExplosiveTrap = true -- ? no idea how to track this
      Ctx.NeedBeastCleave = Ctx:CheckBuff(SPN.BeastCleave) == 0
      Ctx.RabidPet = Ctx:CheckBuff(SPN.Rabid, "pet") > 0
    end

    local BM = "beast-mastery"
    local MM = "marksmanship"
    local SV = "survival"

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

    local NO_CONDITION = false

    function Main:GetEngine()
      return self:InitSpecs(
        {BM, SKIP},
        {MM, SKIP},
        {SV, SKIP},

        ------------------------------------------------------------------------
        -- BEAST MASTERY
        ------------------------------------------------------------------------

        {BM, SPELL, "a-murder-of-crows",SPN.AMurderOfCrows,  function(this, Ctx) return Ctx.IsBossFight end},
        {BM, SPELL, "arcane-shot",      SPN.ArcaneShot,      function(this, Ctx) return Ctx.TooMuchFocus end, string.format(L"%s to dump focus.", SPN.ArcaneShot)},
        {BM, SPELL, "cobra-shot",       SPN.CobraShot,       NO_CONDITION, NoInstant = true}, -- filler
        {BM, SPELL, "counter-shot",     SPN.CounterShot,     NO_CONDITION},
        {BM, SPELL, "bestial-wrath",    SPN.BestialWrath,    function(this, Ctx) return Ctx.FrenzyCap and Ctx.RabidPet end },
        {BM, SPELL, "dire-beast",       SPN.DireBeast,       NO_CONDITION},
        {BM, SPELL, "explosive-trap",   SPN.ExplosiveTrap,   function(this, Ctx) return Ctx.NeedExplosiveTrap end},
        {BM, SPELL, "focus-cobra-shot", SPN.CobraShot,       function(this, Ctx) return Ctx.NeedMoreFocus end, string.format(L"%s to regain focus.", SPN.CobraShot)},
        {BM, SPELL, "focus-fire",       SPN.FocusFire,       function(this, Ctx) return Ctx.FrenzyCap end},
        {BM, SPELL, "glaive-toss",      SPN.GlaiveToss,      NO_CONDITION},
        {BM, SPELL, "hunters-mark",     SPN.HuntersMark,     function(this, Ctx) return Ctx.NoHuntersMark end},
        {BM, SPELL, "kill-command",     SPN.KillCommand,     NO_CONDITION},
        {BM, SPELL, "kill-shot",        SPN.KillShot,        NO_CONDITION},
        {BM, SPELL, "misdirection",     SPN.Misdirection,    NO_CONDITION},
        {BM, SPELL, "multi-shot",       SPN.MultiShot,       function(this, Ctx) return Ctx.NeedBeastCleave end},
        {BM, SPELL, "rapid-fire",       SPN.RapidFire,       NO_CONDITION},
        {BM, SPELL, "serpent-sting",    SPN.SerpentSting,    function(this, Ctx) return Ctx.NeedSerpentSting end},
        {BM, SPELL, "ss-cobra-shot",    SPN.CobraShot,       function(this, Ctx) return Ctx.SerpentStingExpiring end, string.format(L"%s to refresh %s", SPN.CobraShot, SPN.SerpentSting), NoInstant = true},
        {BM, SPELL, "stampede",         SPN.Stampede,        NO_CONDITION},
        {BM, SPELL, "steady-shot",      SPN.SteadyShot,      NO_CONDITION, NoInstant = true}, -- filler

        ------------------------------------------------------------------------
        -- ROTATION
        ------------------------------------------------------------------------
        {BM, PRIO, {"hunters-mark", "kill-shot", "serpent-sting", "ss-cobra-shot", "a-murder-of-crows", "bestial-wrath", "focus-fire", "glaive-toss", "kill-command", "arcane-shot", "cobra-shot", "steady-shot"}},
        {BM, AOE,  {"hunters-mark", "kill-shot", "serpent-sting", "multi-shot", "explosive-trap", "ss-cobra-shot", "a-murder-of-crows", "bestial-wrath", "focus-fire", "glaive-toss", "kill-command", "arcane-shot", "cobra-shot", "steady-shot"}},

        ------------------------------------------------------------------------
        -- slots, interrupts, etc
        ------------------------------------------------------------------------
        {BM, INIT, Init},
        {BM, INT,   "counter-shot"},
        {BM, SLOT1, SPELL, "misdirection", SPN.Misdirection},
        {BM, SLOT2, SPELL, "stampede", SPN.Stampede},
        {BM, SLOT3, SPELL, "rapid-fire", SPN.RapidFire},
        {BM, VAR, "AoeMin", 3}

      )
    end  -- function Main:GetEngine
  end -- if ... HUNTER
