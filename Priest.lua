local addon_name, Main = ...

local function L(text)
  return (Main.Strings and Main.Strings[text]) or text
end

  if select(2, UnitClass("player")) == 'PRIEST' then
    local SPN = {
      Cascade         = GetSpellInfo(121135),
      DevouringPlague = GetSpellInfo(2944),
      DivineStar      = GetSpellInfo(110744),
      Halo            = GetSpellInfo(120517),
      InnerFire       = GetSpellInfo(588),
      MindBlast       = GetSpellInfo(8092),
      MindFlay        = GetSpellInfo(15407),
      MindSear        = GetSpellInfo(124469),
      MindSpike       = GetSpellInfo(73510),
      PWFortitude     = GetSpellInfo(21562),
      PowerInfusion   = GetSpellInfo(10060),
      ShadowOrb       = GetSpellInfo(95740),
      SWDeath         = GetSpellInfo(32379),
      SWPain          = GetSpellInfo(124464),
      Shadowfiend     = GetSpellInfo(34433),
      Shadowform      = GetSpellInfo(15473),
      SurgeOfDarkness = GetSpellInfo(87160),
      Silence         = GetSpellInfo(15487),
      VampiricEmbrace = GetSpellInfo(15286),
      VampiricTouch   = GetSpellInfo(34914),


      zz = 0
    }

    -- initializes the variables used by conditionals
    local function Init(this, Ctx)
      Ctx.Has3ShadowOrbs = (UnitPower("player", SPELL_POWER_SHADOW_ORBS) or 0) == 3
      Ctx.DevouringPlagueOn = Ctx:CheckDebuff(SPN.DevouringPlague) > 0
      Ctx.NeedSWPain = select(2, Ctx:CheckDebuff(SPN.SWPain)) < 4
      Ctx.NeedVampiricTouch = select(2, Ctx:CheckDebuff(SPN.VampiricTouch)) < 4
      Ctx.HasSurgeOfDarkness = Ctx:CheckBuff(SPN.SurgeOfDarkness) > 0
    end

    local DISCIPLINE = "discipline"
    local HOLY = "holy"
    local SHADOW = "shadow"

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
    local ROTATION = "prio"
    local AOE  = "aoe"
    local SKIP = "skip"
    local INIT = "init"
    local VAR = "var"

    local NO_CONDITION = false
    local ON_COOLDOWN = false

    function Main:GetEngine()
      return self:InitSpecs(
        {DISCIPLINE, SKIP},
        {HOLY, SKIP},
        {SHADOW, SKIP},

        ------------------------------------------------------------------------
        -- SHADOW
        ------------------------------------------------------------------------

        {SHADOW, SPELL, "devouring-plague",  SPN.DevouringPlague, function(t, c) return c.Has3ShadowOrbs end},
        {SHADOW, SPELL, "mind-blast",        SPN.MindBlast, ON_COOLDOWN, NoInstant=true},
        {SHADOW, SPELL, "shadow-word-death", SPN.SWDeath, ON_COOLDOWN},
        {SHADOW, SPELL, "big-mind-sear",     SPN.MindSear, function(t, c) return c.Mobs >= 4 end, NoInstant=true},
        {SHADOW, SPELL, "mind-sear",         SPN.MindSear, function(t, c) return c.Mobs > 1 end, NoInstant=true},
        {SHADOW, SPELL, "mind-flay",         SPN.MindFlay, function(t, c) return c.DevouringPlagueOn end, NoInstant=true},
        {SHADOW, SPELL, "mind-spike",        SPN.MindSpike, function(t, c) return c.HasSurgeOfDarkness end, NoInstant=true},
        {SHADOW, SPELL, "shadow-word-pain",  SPN.SWPain, function(t, c) return c.NeedSWPain end},
        {SHADOW, SPELL, "vampiric-touch",    SPN.VampiricTouch, function(t,c) return c.NeedVampiricTouch end, NoInstant=true},
        {SHADOW, SPELL, "cascade",           SPN.Cascade, ON_COOLDOWN},
        {SHADOW, SPELL, "divine-star",       SPN.DivineStar, ON_COOLDOWN},
        {SHADOW, SPELL, "halo",              SPN.Halo, ON_COOLDOWN},
        {SHADOW, SPELL, "power-infusion",    SPN.PowerInfusion, function(t, c) return c.IsBossFight end},
        {SHADOW, SPELL, "shadow-fiend",      SPN.Shadowfiend, function(t, c) return (c.IsBossFight and c.HasBloodLust) or (c.HealthPercent < .4) end},
        {SHADOW, SPELL, "vampiric-embrace",  SPN.VampiricEmbrace, function(t, c) return c.HealthPercent < .4 end},
        {SHADOW, SPELL, "filler-mind-sear",  SPN.MindSear, function(t, c) return c.Mobs > 1 end, NoInstant=true},
        {SHADOW, SPELL, "filler-mind-flay",  SPN.MindFlay, ON_COOLDOWN, NoInstant=true},
        {SHADOW, SPELL, "silence",           SPN.Silence, NO_CONDITION},

        {SHADOW, ROTATION, {"vampiric-embrace", "shadow-fiend", "devouring-plague", "mind-spike", "big-mind-sear", "mind-blast", "shadow-word-death", "mind-sear", "mind-flay", "shadow-word-pain", "vampiric-touch", "halo", "cascade", "divine-star", "filler-mind-sear", "filler-mind-flay"}},

        {SHADOW, INIT, Init},
        {SHADOW, SLOT1, BUFF,                SPN.InnerFire, SPN.InnerFire},
        {SHADOW, SLOT2, BUFF,                SPN.Shadowform, SPN.Shadowform},
        {SHADOW, SLOT3, BUFF,                SPN.PWFortitude, SPN.PWFortitude},
        {SHADOW, INT,   "silence"}
      )
    end
  end


