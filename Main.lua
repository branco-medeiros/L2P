-- Learn To Play!
-- by Glub@Terokar
--------------------------------------------------------------------------------
-- a general spell priority and buff status monitor
--------------------------------------------------------------------------------

local addon_name, Main = ...

local DEFAULT_BDR_TEX = 'Interface\\DialogFrame\\UI-DialogBox-Background-Dark'
local DEFAULT_BG_TEX = "Interface\\DialogFrame\\UI-DialogBox-Background"
--local DEFAULT_BG_TEX = "Interface\\AddOns\\L2P\\textures\\Flat.tga"
local DEFAULT_INTERVAL = 3
local DEFAULT_TRACKER_MAX = 20
local MODE_ST_TEX = "Interface\\WorldStateFrame\\CombatSwords"
local MODE_CUSTOM_TEX = "Interface\\WorldStateFrame\\NeutralTower"
local MODE_ST = 'st' -- Single target
local MODE_AOE = 'aoe' -- aoe mode
local MODE_CUSTOM = 'custom' -- a temporary mode, defined by the user

local DEFAULT_ALPHA = 1
local DEFAULT_LOCKED = false
local DEFAULT_CHECKRANGE = true
local DEFAULT_FREQUENCY = 15
local MAX_FREQUENCY = 100
local ACTIVE_SPELLS = 2
local SPELL_CAST_TIME = 4
local DAMAGE_PAIN_DURATION = 2 -- 2 seconds of pain
local GCD_SPELL_ID = 61304
local MINIMUM_DAMAGE_FOR_PAIN = 0.0001
local DEFAULT_XICON_ROW_SIZE = 5
local OBLIVION_SPHERE = 272407

local MAX_BUFF_DEBUFF = 64


-- default modes
local MODES = {
 [MODE_ST]     = {tex= MODE_ST_TEX, color={0, 0, 0}},
 [MODE_AOE]    = {tex= MODE_ST_TEX, color = {1, 0, 0}},
 [MODE_CUSTOM] = {tex= MODE_CUSTOM_TEX, color = {.5, .5, .5}}
}

local SPN = {
  Bloodlust       = GetSpellInfo(2825),
  Bloodlust       = GetSpellInfo(2825),
  Heroism         = GetSpellInfo(32182),
  TimeWarp        = GetSpellInfo(80353),
  AncientHysteria = GetSpellInfo(90355),
}

local Cmds = {}

--------------------------------------------------------------------------------
local function L(text)
--------------------------------------------------------------------------------
-- the ubiquitous locale funtion
--------------------------------------------------------------------------------
  return (Main.Strings and Main.Strings[text]) or text
end

--------------------------------------------------------------------------------
local function NormalizeMode(list)
--------------------------------------------------------------------------------
-- normalizes a mode array ensuring that at least the entries for single target,
-- aoe and custom are present
--------------------------------------------------------------------------------
  local r = {}
  list = list or {}
  r[MODE_ST]     = list[MODE_ST] or {}
  r[MODE_AOE]    = list[MODE_AOE] or {}
  r[MODE_CUSTOM] = list[MODE_CUSTOM] or {}
  return r
end

--------------------------------------------------------------------------------
local function GetSavedVars()
--------------------------------------------------------------------------------
  return _G[SAVED_VARS] or {}
end

--------------------------------------------------------------------------------
local function ShowMsg(Msg, ...)
--------------------------------------------------------------------------------
  if ... then Msg = format(Msg, ...) end
  print("[L2P] ", Msg)
end

--------------------------------------------------------------------------------
local function ShowError(Msg, ...)
--------------------------------------------------------------------------------
  if ... then Msg = format(Msg, ...) end
  print('|cFFFFCC33' .. Msg)
end


--------------------------------------------------------------------------------
local function DbgMsg(Msg, ...)
--------------------------------------------------------------------------------
  if Main.Debug then ShowMsg(Msg, ...) end
end


--//////////////////////////////////////////////////////////////////////////////
-- Event
-- simple "event" dispatching
--//////////////////////////////////////////////////////////////////////////////

-------------------------------------------------------------------------------
local function Event_Remove(this, method)
-------------------------------------------------------------------------------
-- removes a listener
-------------------------------------------------------------------------------
  local j = 0
  for i, v in ipairs(this.Targets) do
    if v.Method == method then
      j = i
      break
    end
  end
  if j ~= 0 then table.remove(this.Targets, j) end
end -- Event_Remove

-------------------------------------------------------------------------------
local function Event_Raise(this, ...)
-------------------------------------------------------------------------------
-- calls each listener, the event object is passed as the first argument
-- just after the context
-------------------------------------------------------------------------------
  for i, v in ipairs(this.Targets) do
    v.Method(v.Context, this, ...)
  end
end

-------------------------------------------------------------------------------
local function Event_Add(this, method, context)
-------------------------------------------------------------------------------
-- adds a new listener. Method is the method to call when the event is raized;
-- Context is the variable which will be in context when the event is raised.
-------------------------------------------------------------------------------
  local Entry = {Context = context, Method = method}
  table.insert(this.Targets, Entry)
end -- fn Event_Add


-------------------------------------------------------------------------------
local function Event_Clear(this)
-------------------------------------------------------------------------------
-- discards all targets
-------------------------------------------------------------------------------
  this.Targets = {}
end


-------------------------------------------------------------------------------
local function Event_Create(Sender)
-------------------------------------------------------------------------------
--  constructor
-------------------------------------------------------------------------------
  local evt = {}

  evt.Sender = Sender
  evt.Targets = {}
  evt.Add = Event_Add
  evt.Remove = Event_Remove
  evt.Raise = Event_Raise
  evt.Clear = Event_Clear
  return evt
end -- fn Event_Create



--//////////////////////////////////////////////////////////////////////////////
-- Tracker
-- Tracks mobs (or other items) for a given time
--//////////////////////////////////////////////////////////////////////////////

-------------------------------------------------------------------------------
local function Tracker_Add(this, id)
-------------------------------------------------------------------------------
-- adds an item to the list of tracked items, together with the time when the
-- item must be removed
-------------------------------------------------------------------------------
  this.Items[id] = GetTime() + (this.Interval or DEFAULT_INTERVAL)
end -- fn Tracker_Add

-------------------------------------------------------------------------------
local function Tracker_Remove(this, id)
-------------------------------------------------------------------------------
-- removes an item from the tracking list
-------------------------------------------------------------------------------
  this.Items[id] = nil
end -- fn Tracker_Remove

-------------------------------------------------------------------------------
local function Tracker_Refresh(this)
-------------------------------------------------------------------------------
-- removes items that already expired and keeps the count of items down to
-- a predefined maximum
-------------------------------------------------------------------------------
  local count = 0
  local items = {}
  local now = GetTime()
  for k, i in pairs(this.Items) do
    if (i >= now) then
      count = count+1
      items[k] = i
      -- if there are too many items in the list, bails out of the loop
      if count >= this.Max then break end
    end
  end -- for k, i...
  this.Items = items
  this.Count = count
  return count
end -- fn Tracker_Refresh

-------------------------------------------------------------------------------
local function Tracker_Create(Interval)
-------------------------------------------------------------------------------
-- returns an object to track items for a given interval
-------------------------------------------------------------------------------
  return {
    Items = {},
    Count = 0,
    Interval = Interval,
    Max = DEFAULT_TRACKER_MAX + 1,
    Add = Tracker_Add,
    Remove = Tracker_Remove,
    Refresh = Tracker_Refresh
  }
end -- fn Tracker_Create()




--//////////////////////////////////////////////////////////////////////////////
-- Spell
-- provides information over a given spell
--//////////////////////////////////////////////////////////////////////////////

-------------------------------------------------------------------------------
local function Spell_Update(this, Ctx)
-------------------------------------------------------------------------------
-- returns true if the spell is instant and is usabble and its conditions
-- are met
-------------------------------------------------------------------------------
  this.Valid = false
  this.Enabled = false
  this.NoMana = true
  if not this.SpName then return false end
  if this.Id and not IsPlayerSpell(this.Id) then return false end
  
  local cast = select(SPELL_CAST_TIME, GetSpellInfo(this.SpName))
  local ok = ((cast and cast <= 0) or this.NoInstant) and this:IsUsable()
	this.Charges, this.MaxCharges = GetSpellCharges(this.SpName)

  if ok and this.Condition then
    this.Valid = this:Condition(Ctx)
  else
    this.Valid = ok
  end
  return this.Valid
end -- fn Spell_Update

-------------------------------------------------------------------------------
local function Spell_IsUsable(this)
-------------------------------------------------------------------------------
-- returns true if the spell can be used/has mana
-------------------------------------------------------------------------------
  local ok, nomana = IsUsableSpell(this.SpName)
  this.Enabled = (ok and true) or false
  this.NoMana = (nomana and true) or false
  return this.Enabled
end -- fn Spell_IsUsable

-------------------------------------------------------------------------------
local function Spell_GetActivation(this, now)
-------------------------------------------------------------------------------
-- returns when the spell will become available
-------------------------------------------------------------------------------
  this.Start, this.Duration = GetSpellCooldown(this.SpName)
  if not this.Start then return nil end
  local s = this.Start
  if s == 0 then s = now end
  this.When = s + this.Duration
  this.Cooldown = this.When - now
  return this.When
end -- fn Spell_GetActivation

-------------------------------------------------------------------------------
local function Spell_CheckRange(this)
-------------------------------------------------------------------------------
-- returns true if the spell is in range
-------------------------------------------------------------------------------
  this.InRange = this.NoTarget or
    this.NoRange or
    not this.SpellBookIndexForRange or
    IsSpellInRange(this.SpellBookIndexForRange, BOOKTYPE_SPELL, "target") == 1
    or false

  return this.InRange
end -- fn Spell_CheckRange

-------------------------------------------------------------------------------
local function Spell_GetTexture(this)
-------------------------------------------------------------------------------
  return GetSpellTexture(this.SpName or "")
end -- fn Spell_GetTexture

-------------------------------------------------------------------------------
local function Spell_Debug(this)
-------------------------------------------------------------------------------
  for k, v in pairs(this) do
    if type(v) ~= "function" then print(k, ": ", v) end
  end
end

-------------------------------------------------------------------------------
local function Spell_Create(Key, SpName, Condition, Caption)
-------------------------------------------------------------------------------
-- returns a spell object
-- Condition is a function Spell:Condition(Context) that returns true if the
-- spell meets the conditions to be actived
-------------------------------------------------------------------------------
  sp = {}
  sp.Key = Key          -- a unique name to identify this 'spell'
  sp.SpName = SpName    -- the spell name
  sp.Caption = Caption  -- a text describing the spell
  sp.Condition = Condition
  sp.When = 0
  sp.Start = 0
  sp.Duration = 0
  sp.InRange = false
  sp.Valid = false
  sp.Enabled = false
  sp.NoMana = true

	if type(SpName) == "function" then
	-- SpName can be function
		sp.GetSpellName = SpName
	  sp.InitSpellName = function(this)
			this.SpName = this:GetSpellName()
			return this.SpName
		end
		sp:InitSpellName()
  else
		sp.InitSpellName =function(this)
			return this.SpName
		end
	end

  -- Spell API
  sp.GetTexture = Spell_GetTexture
  sp.Update = Spell_Update
  sp.IsUsable = Spell_IsUsable
  sp.GetActivation = Spell_GetActivation
  sp.CheckRange = Spell_CheckRange
  sp.Debug = Spell_Debug
  return sp

end -- fn Spell_Create()


-------------------------------------------------------------------------------
local function Spell_CreateById(Id, Name, Options)
-------------------------------------------------------------------------------
-- creates a spell based only in id and name
-------------------------------------------------------------------------------
  if type(Name) == "table" and not Options then
    Options = Name
    Name = nil
  end
  if not Name then Name = GetSpellInfo(Id) end
  local sp = Spell_Create("", Name)
  sp.Id = Id
  --[[
  if Name then 
    sp.SpellBookIndex = FindSpellBookSlotBySpellID(Id) 
    sp.SpellBookIndexForRange = sp.SpellBookIndex
  end
  ]]
  if Options then
    sp.NoTarget = Options.NoTarget or false
    sp.NoRange = Options.NoRange or false
    sp.NoInstant = Options.NoInstant or false
  end
  return sp
end -- fn Spell_CreateById


--//////////////////////////////////////////////////////////////////////////////
-- InterruptSpell
-- a spell that activates if the target is casting an interruptible spell
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function InterruptSpell_Create(SpellOrKey, SpName, Caption)
--------------------------------------------------------------------------------

  local Condition = function(this, Ctx)
    local casting, _, _, _, _, _, _, CantInterrupt = UnitCastingInfo("target")
    if not casting then
      casting, _, _, _, _, _, CantInterrupt = UnitChannelInfo("target")
    end
    return (casting ~= 'Starblast') and (casting and CantInterrupt == false and true) or false
  end

  local sp = SpellOrKey
  if type(sp) == "string" then
    sp = Spell_Create(sp, SpName, Condition, Caption)
  else
    sp.Condition = Condition
  end

  return sp

end -- function InterruptSpell_Create


--//////////////////////////////////////////////////////////////////////////////
-- SpellFrame
-- represents the main frame where icons will reside
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function SpellFrame_SetVisible(this, value)
--------------------------------------------------------------------------------
  if value then this:Show() else this:Hide() end
end


--------------------------------------------------------------------------------
local function SpellFrame_SetLocked(this, value)
--------------------------------------------------------------------------------
  value = (value and true) or false
  if value then
    this:SetScript("OnMouseDown", nil)
    this:SetScript("OnMouseUp", nil)
    this:SetScript("OnDragStop", nil)
    this:SetBackdropColor(0, 0, 0, 0)
    this:SetMovable(false)
    this:EnableMouse(false)
  else
    this:SetScript("OnMouseDown", this.StartMoving)
    this:SetScript("OnMouseUp", this.StopMovingOrSizing)
    this:SetScript("OnDragStop", this.StopMovingOrSizing)
    this:SetBackdropColor(0, 0, 0, .4)
    this:SetMovable(true)
    this:EnableMouse(true)
  end -- if
  this.IsLocked = value
end -- fn SpellFrame_SetLocked

--------------------------------------------------------------------------------
local function SpellFrame_Create(cx, cy, w, h)
--------------------------------------------------------------------------------
  local sf =  Cmds.CreateIcon(nil, w, h)
  sf:SetImage(0, .39, .58, 0)
  --sf:SetBorder(6)

  sf:SetClampedToScreen(true)
  sf:SetPoint("CENTER", cx, cy)
  -- sf:SetUserPlaced(true)
  sf.SetLocked = SpellFrame_SetLocked
  sf.SetVisible = SpellFrame_SetVisible
  sf.OnUpdate = Event_Create()
  sf:SetScript(
    "OnUpdate",
    function(this, elapsed)
      this.OnUpdate:Raise(elapsed)
    end
  )

  sf:SetLocked(false)
  return sf
end -- fn SpellFrame_Create



--//////////////////////////////////////////////////////////////////////////////
-- Icon
-- represents a visual symbol on the screen. used to show spells or other
-- esoteric elements
--//////////////////////////////////////////////////////////////////////////////

-------------------------------------------------------------------------------
local function Icon_SetImageColor(this, r, g, b, a)
-------------------------------------------------------------------------------
-- sets the frame color
-------------------------------------------------------------------------------
  this.ImageTex:SetVertexColor(r, g, b, a)
  return this
end -- fn Icon_SetImageColor

-------------------------------------------------------------------------------
local function Icon_SetBorderColor(this, r, g, b)
-------------------------------------------------------------------------------
  this:SetBackdropBorderColor(r, g, b, 1)
  return this
end -- fn Icon_SetBorderColor

-------------------------------------------------------------------------------
local function Icon_ShowCooldown(this, s, d, r)
-------------------------------------------------------------------------------
-- shows the cooldown, if possible
-------------------------------------------------------------------------------
  if this.CdFrame and s then
		this.CdFrame:SetReverse(r or false)
    this.CdFrame:SetCooldown(s, d)

  end
  return this

end -- fn Icon_ShowCooldown

-------------------------------------------------------------------------------
local function Icon_SetDefaultImage(this, tex)
-------------------------------------------------------------------------------
-- defines a default image for when no image is specified
-------------------------------------------------------------------------------
  this.DefaultBg = tex
  return this
end -- fn Icon_SetDefaultImage

-------------------------------------------------------------------------------
local function Icon_SetImage(this, tex, ...)
-------------------------------------------------------------------------------
-- show a given image on the icon. if none is specified, DefaultImage will be
-- shown instead. If this doesnt exist either, shows a blank image
-------------------------------------------------------------------------------
  tex = tex or this.DefaultBg or DEFAULT_BG_TEX
	local r, g, b, a
  if type(tex) == "number" then
    r = tex
    g, b, a = ...
	elseif type(tex) == "table" then
		r, g, b, a = tex
  end
	if type(r) == "number" and g and b then
		a = a or 1
		this.ImageTex:SetColorTexture(r, g, b, a)
	else
		this.ImageTex:SetTexture(tex, ...)
	end
  return this
end -- fn Icon_SetImage

-- forward declares the text icon creation function
local TextIcon_CreateFn;

-------------------------------------------------------------------------------
local function Icon_SetText(this, text)
-------------------------------------------------------------------------------
-- sets the content of a text layer; if one does not exist, creates
-------------------------------------------------------------------------------
  if (this.IconText or "") ~= (text or "") then
		if not this.TextIcon then 
			local w = this:GetWidth()
			local h = this:GetHeight()
			local icon = TextIcon_CreateFn(this, w, h, 10)
			this.TextIcon = icon
		end
		this.IconText = text or ""
		this.TextIcon:SetText(this.IconText)
	end
  return this
end -- fn Icon_SetText

-------------------------------------------------------------------------------
local function Icon_SetBorder(this, size, edge)
-------------------------------------------------------------------------------
-- simulates line borders
-------------------------------------------------------------------------------
  if not size or size == 0 then
    this:SetBackdrop({edgeFile = nil, edgeSize = 0})
  else
    this.edge = edge or this.edge or DEFAULT_BDR_TEX
    this:SetBackdrop({edgeFile= this.edge, edgeSize=size})
    this:SetBorderColor(0,0,0)
  end --if
  return this
end -- fn Icon_SetBorder

-------------------------------------------------------------------------------
local function Icon_CenterAt(this, x, y)
-------------------------------------------------------------------------------
-- ceters at the specified coordinate
-------------------------------------------------------------------------------
  this:SetPoint("CENTER", x, y)
end -- fn Icon_CenterAt

-------------------------------------------------------------------------------
local function Icon_RelativeCenterAt(this, x, y, other)
-------------------------------------------------------------------------------
-- ceters relative to the center of the specified frame 
-------------------------------------------------------------------------------
  this:SetPoint("CENTER", other, x, y)
end -- fn Icon_CenterAt


-------------------------------------------------------------------------------
local function Icon_XYAt(this, x, y)
-------------------------------------------------------------------------------
  this:SetPoint("TOPLEFT", x, y)
end -- fn Icon_XYAt

-------------------------------------------------------------------------------
local function Icon_RelativeXYAt(this, x, y, other)
-------------------------------------------------------------------------------
  this:SetPoint("TOPLEFT", other, x, y)
end -- fn Icon_XYAt

-------------------------------------------------------------------------------
local function Icon_SetVisible(this, value)
-------------------------------------------------------------------------------
  this.active = value
end -- fn Icon_SetVisible

-------------------------------------------------------------------------------
local function Icon_Activate(this)
-------------------------------------------------------------------------------
  if this.active then this:Show() end
end -- fn Icon_Activate

--------------------------------------------------------------------------------
local function Icon_Update(this, Ctx)
--------------------------------------------------------------------------------
--  does nothing
end

--------------------------------------------------------------------------------
local function Icon_Create(Parent, w, h, HasCooldown)
--------------------------------------------------------------------------------
-- creates an "icon" frame
--------------------------------------------------------------------------------
  local fr = CreateFrame("Frame", nil,  Parent)
  fr:SetSize(w, h)

  -- the image
  local t = fr:CreateTexture(nil, "BACKGROUND")

  t:SetAllPoints(fr)
  t:SetTexture(DEFAULT_BG_TEX)
  fr.ImageTex = t

  -- the cooldown frame
  if HasCooldown then
    cd = CreateFrame("Cooldown", nil, fr, "CooldownFrameTemplate")
    cd:SetAllPoints()
    cd:SetAlpha(1)
    fr.CdFrame = cd
  end

  fr.SetImageColor = Icon_SetImageColor
  fr.SetBorderColor = Icon_SetBorderColor
  fr.ShowCooldown = Icon_ShowCooldown
  fr.SetDefaultImage = Icon_SetDefaultImage
  fr.SetImage = Icon_SetImage
  fr.SetBorder = Icon_SetBorder
  fr.CenterAt = Icon_CenterAt
  fr.RelativeCenterAt = Icon_RelativeCenterAt
  fr.XYAt = Icon_XYAt
  fr.RelativeXYAt = Icon_RelativeXYAt
  fr.SetVisible = Icon_SetVisible
  fr.Activate = Icon_Activate
	fr.SetText = Icon_SetText
  fr.Update = Icon_Update

  return fr

end -- fn Icon_Create



--//////////////////////////////////////////////////////////////////////////////
-- TextIcon
-- specialized Icon to show text instead of image
--//////////////////////////////////////////////////////////////////////////////

-------------------------------------------------------------------------------
local function TextIcon_SetText(this, text)
-------------------------------------------------------------------------------
  this.TextFrame:SetText(text)
end -- fn TextIcon_SetText

--------------------------------------------------------------------------------
local function TextIcon_Create(Parent, w, h, FontSize)
--------------------------------------------------------------------------------
  local fr = Icon_Create(Parent, w, h)
  local f = fr:CreateFontString(nil,"OVERLAY")
  FontSize = FontSize or 24
  f:SetFont("Fonts\\MORPHEUS.ttf", FontSize, "THICKOUTLINE")
	f:SetAllPoints()
	f:SetTextColor(1,1,0,1) -- yellow
  fr.TextFrame = f

  fr.SetText = TextIcon_SetText

  return fr

end -- fn TextIcon_Create
-- Updates TextIcon_CreateFn
TextIcon_CreateFn = TextIcon_Create


--//////////////////////////////////////////////////////////////////////////////
-- SpellIcon
-- subclass for Icon that shows a given spell
--//////////////////////////////////////////////////////////////////////////////

-------------------------------------------------------------------------------
local function SpellIcon_UpdateSpell(this, sp, CheckRange)
-------------------------------------------------------------------------------
-- assumes that sp:Update(Ctx) was already called previously
-------------------------------------------------------------------------------
  this.Spell = sp
  if sp then
    this:SetImage(sp:GetTexture())
    this:ShowCooldown(sp.Start, sp.Duration)
    this:SetStatus(sp, CheckRange)
  else
    this:SetImage("")
  end
end -- fn SpellIcon_UpdateSpell

-------------------------------------------------------------------------------
local function SpellIcon_SetStatus(this, sp, CheckRange)
-------------------------------------------------------------------------------
-- assumes that sp:Update(Ctx) was already called previously
-------------------------------------------------------------------------------
  if not sp.Valid or not sp.Enabled or sp.NoMana then
    this:SetImageColor(.3, .3, .3)

  elseif CheckRange and not sp.InRange then
    this:SetImageColor(.5, 0, 0)

  else
    this:SetImageColor(1, 1, 1)
  end
end -- fn SpellIcon_SetStatus

--------------------------------------------------------------------------------
local function SpellIcon_FromIcon(Icon)
--------------------------------------------------------------------------------
  Icon:SetDefaultImage(false)
  Icon.UpdateSpell = SpellIcon_UpdateSpell
  Icon.SetStatus = SpellIcon_SetStatus

  return Icon
end -- fn SpellIcon_FromIcon

--------------------------------------------------------------------------------
local function SpellIcon_Create(Parent, w, h)
--------------------------------------------------------------------------------
-- creates an icon that iteracts with a given spell
--------------------------------------------------------------------------------
  return SpellIcon_FromIcon(Icon_Create(Parent, w, h, true))
end -- fn SpellIcon_Create



--//////////////////////////////////////////////////////////////////////////////
-- AuraIcon
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function AuraIcon_FromIcon(Icon)
--------------------------------------------------------------------------------
  Icon:SetDefaultImage("Interface\\BUTTONS\\UI-GroupLoot-Pass-Down")

  Icon.Update = function(this, Ctx)
    local Aura = GetShapeshiftForm()
    Aura = this.Auras and this.Auras[Aura]
    if Aura ~= this.Aura then
      this:SetImage(GetSpellTexture(Aura or ""))
      this.Aura = Aura
    end
  end
  return Icon
end -- AuraIcon_FromIcon


--------------------------------------------------------------------------------
local function AuraIcon_Create(Parent, W, H)
--------------------------------------------------------------------------------
  return AuraIcon_FromIcon(Icon_Create(Parent, W, H))
end -- fn AuraIcon_Create




--//////////////////////////////////////////////////////////////////////////////
-- BuffIcon
--//////////////////////////////////////////////////////////////////////////////


--------------------------------------------------------------------------------
local function BuffIcon_FromIcon(Icon)
--------------------------------------------------------------------------------
  --Icon:SetDefaultImage("Interface\\BUTTONS\\UI-GroupLoot-Pass-Down")

	
  Icon.Update = function(this, Ctx)
		local c, _, duration, name, id, expires = Ctx:CheckBuff(this.Buffs or {})
		
		local n, e, d = this.Buff
		if n ~= name or e ~= expires or d ~= duration then
      -- using both the spell name and the spell id because some spell names
      -- are not returning the texture!!
      this:SetImage(GetSpellTexture(name) or GetSpellTexture(id))
			this:ShowCooldown((expires or Ctx.Now) - duration, duration, true)
      this.Buff = {name, expires, duration}
    end
		this:SetText((c and c > 1 and c) or "")
  end

  return Icon
end -- fn BuffIcon_FromIcon

--------------------------------------------------------------------------------
local function BuffIcon_Create(Parent, w, h)
--------------------------------------------------------------------------------
  return BuffIcon_FromIcon(Icon_Create(Parent, w, h))
end -- fn BuffIcon_Create



--//////////////////////////////////////////////////////////////////////////////
-- DebuffIcon
--//////////////////////////////////////////////////////////////////////////////


--------------------------------------------------------------------------------
local function DebuffIcon_FromIcon(Icon)
--------------------------------------------------------------------------------
  --Icon:SetDefaultImage("Interface\\BUTTONS\\UI-GroupLoot-Pass-Down")

  Icon.Update = function(this, Ctx)
		local count, _, duration, name, id, expires = Ctx:CheckDebuff(this.Debuffs or {})
		local n, e, d = this.Debuff
		if n ~= name or e ~= expires or d ~= duration then
			this:SetImage(GetSpellTexture(name) or GetSpellTexture(id))
			this:ShowCooldown((expires or Ctx.Now) - duration, duration, true)
			this.Debuff = {name, expires, duration}
		end
		this:SetText((c and c > 1 and c) or "")
  end

  return Icon
end -- fn DebuffIcon_FromIcon

--------------------------------------------------------------------------------
local function DebuffIcon_Create(Parent, w, h)
--------------------------------------------------------------------------------
  return DebuffIcon_FromIcon(Icon_Create(Parent, w, h))
end -- fn DebuffIcon_Create




--//////////////////////////////////////////////////////////////////////////////
-- SpellMonitorIcon
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function SpellMonitorIcon_FromSpellIcon(SpellIcon)
--------------------------------------------------------------------------------
  SpellIcon:SetDefaultImage(false)

  SpellIcon.Update = function(this, Ctx)
    local Spells = this.Spells or {}
	  local sp = false
    for _, s in ipairs(Spells) do
      if s then
        if not sp then sp = s end
        s:Update(Ctx)
        s:GetActivation(Ctx.Now)
        s:CheckRange()
        if s.Valid then
          sp = s
          break
        end
      end
    end
    if sp then this:UpdateSpell(sp, true) end
  end

  return SpellIcon
end

--------------------------------------------------------------------------------
local function SpellMonitorIcon_FromIcon(Icon)
--------------------------------------------------------------------------------
  return SpellMonitorIcon_FromSpellIcon(SpellIcon_FromIcon(Icon))
end

--------------------------------------------------------------------------------
local function SpellMonitorIcon_Create(Parent, w, h)
--------------------------------------------------------------------------------
  return SpellMonitorIcon_FromSpellIcon(SpellIcon_Create(Parent, w, h))

end -- fn SpellMonitorIcon_Create




--//////////////////////////////////////////////////////////////////////////////
-- MsgIcon
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function MsgIcon_Create(Parent, w, h, size)
--------------------------------------------------------------------------------
  local I = TextIcon_Create(Parent, w, h, size)
  I.ImageTex:SetTexture('')

  I.Update = function(this, Ctx)
	local no = {}
    local NewMsg = ((this.Source or no).Spell or no).Message  or ""
    if NewMsg ~= this.Msg then
      this:SetText(NewMsg)
      if NewMsg == '' then this:Hide() elseif this.Msg == "" then this:Show() end
      this.Msg = NewMsg
    end
  end

  return I

end -- fn MsgIcon_Create



--//////////////////////////////////////////////////////////////////////////////
-- MobsIcon
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function MobsIcon_Create(Parent, w, h)
--------------------------------------------------------------------------------
  local I = TextIcon_Create(Parent, w, h)

  I.Limit = DEFAULT_TRACKER_MAX
  I.LastCount = 0

  I.Update = function(this, Ctx)
    local Mobs = Ctx.Mobs or 0

    if Mobs ~= this.LastCount then
      local text = (Mobs == 0 and "") or Mobs
      if this.Limit and (Mobs > this.Limit) then text = '...' end
      this:SetText(text)
      this.LastCount = Mobs
    end
  end

  return I

end -- fn MobsIcon_Create



--//////////////////////////////////////////////////////////////////////////////
-- ModeIcon
-- used to indicate which mode is active (single target, aoe or custom)
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function ModeIcon_Create(Parent, w, h)
--------------------------------------------------------------------------------
  local I = SpellIcon_Create(Parent, w, h)
  I.Edge = "Interface\\Tooltips\\UI-Tooltip-Background"

  I.Update = function(this, Ctx)
    local Mode = Ctx.Mode or ''
    if strlen(Mode) == 0 then Mode = MODE_ST end -- default mode is single target
    if this.LastMode == Mode then return end
    this.LastMode = Mode
    local info = MODES[Mode]
    this:SetImage(info.tex)
    this.ImageTex:SetTexCoord(0, .5, 0, .5)
    this:SetBorderColor(unpack(info.color))
  end

  return I

end -- fn ModeIcon_Create



--//////////////////////////////////////////////////////////////////////////////
-- HpIcon
-- Changes color based on health status
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function HPIcon_Create(Parent, w, h)
--------------------------------------------------------------------------------
  local I = SpellIcon_Create(Parent, w, h)

  I.Update = function(this, Ctx)
    local Health = UnitHealth("player")/UnitHealthMax("player")

    local r, g, b = 0, 1, 0 -- green, baby, green
    if Health == 0 then
      r, g, b = .7, .7, .7 -- dead gray

    elseif Health <= .25 then
      r, g, b = 1,0,0      -- dangerously red

    elseif Health <= .4 then
      r, g, b = 1, .5, 0   -- effing orange

    elseif Health  <= .6 then
      r, g, b = 1, 1, 0    -- ops yellow
    end
    this:SetImage(r, g, b, .6)
  end

  return I

end -- fn HPIcon_Create



--//////////////////////////////////////////////////////////////////////////////
-- CurrentSpellIcon
-- The spell suggested by the priority system
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function CurrentSpellIcon_Create(Parent, w, h)
--------------------------------------------------------------------------------
  local I = SpellIcon_Create(Parent, w, h)

  I.Update = function(this, Ctx)
    this:UpdateSpell(Ctx.CurSpell, Ctx.CheckRange)
  end

  return I
end -- fn CurrentSpellIcon_Create



--//////////////////////////////////////////////////////////////////////////////
-- NextSpellIcon
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function NextSpellIcon_Create(Parent, W, H)
--------------------------------------------------------------------------------
  local I = SpellIcon_Create(Parent, W, H)

  I.Update = function(this, Ctx)
    this:UpdateSpell(Ctx.NextSpell, Ctx.CheckRange)
  end

  return I
end -- fn NextSpellIcon_Create



--//////////////////////////////////////////////////////////////////////////////
-- Engine
--//////////////////////////////////////////////////////////////////////////////

------------------------------------------------------------------------------
local function Engine_UpdateGCD(this)
------------------------------------------------------------------------------
-- updatess our global cooldown measure based on the Global Cooldown Spell,
-- which triggers whenever a global cooldown dependent spell is cast
-- if we have no information, we use the last value registered
------------------------------------------------------------------------------
	local s, d = GetSpellCooldown(GCD_SPELL_ID)
	this.GCD = (s > 0 and d)
		or (this.GCD ~= 0 and this.GCD)
		or (1.5 * (1 - UnitSpellHaste("player")/100))
end


------------------------------------------------------------------------------
local function Engine_FindSpellName(this, Name)
------------------------------------------------------------------------------
-- returns the spell that matches the name or nil if a) no spell matches
-- or b) more than one spell matches. uses '-' as place mark
------------------------------------------------------------------------------
  local spell = this.Spells[Name]
  if not spell then
    Name = '^' .. string.gsub(string.gsub(Name, '%%', '%%'), '-', '.*-') .. '.*'
    for k, v in pairs(this.Spells) do
      local found = string.match(k, Name)
      if found and spell then return nil end
      if found then spell = v end
    end
  end
  return (spell and spell.Key) or nil
end -- Engine_FindSpellName


------------------------------------------------------------------------------
local function Engine_ShowHideFrame(this)
------------------------------------------------------------------------------
-- decides if the main frame should be shown
------------------------------------------------------------------------------
  if this.HideFrame
  or not this:IsInCombat() then
    this.Frame:Hide()
    return false
  else
    -- ok, we are visible and active.
    -- update our state, select the spell and show the icons
    this.Frame:Show()
    return true
  end
end


------------------------------------------------------------------------------
local function Engine_Update(this)
------------------------------------------------------------------------------
  -- exits if frame must be hidden
  if not this:ShowHideFrame() then return end

  this:UpdateState()
  this:UpdateSpells()
  this:SelectSpells()
  this:SortSpells()

end -- fn Engine_HandleUpdate

------------------------------------------------------------------------------
local function Engine_HandleEnterCombat(this, evt, ...)
------------------------------------------------------------------------------
  this.InCombat = true
  this:ShowHideFrame()
end -- fn Engine_HandleEnterCombat


------------------------------------------------------------------------------
local function Engine_HandleLeaveCombat(this, evt, ...)
------------------------------------------------------------------------------
  this.InCombat = false
  this:ShowHideFrame()
end -- fn Engine_HandleLeaveCombat


------------------------------------------------------------------------------
local function Engine_HandleTargetChanged(this, evt, ...)
------------------------------------------------------------------------------
  this:ShowHideFrame()
end


------------------------------------------------------------------------------
local function Engine_HandleCombatLog(this)
------------------------------------------------------------------------------
	local timestamp, event, hidecaster, source, sname, sflags,
  sflags2, dest, dname, dflags, flags2, 
	p1, p2, p3, p4, p5, p7, p8, p9, p10 = CombatLogGetCurrentEventInfo()
	
  if event == 'UNIT_DIED' then
  -- if an unit died and is in our list, remove it
    this.MobList:Remove(dest)
		this.AttackerList:Remove(dest)
    return
  end

	local isPlayerAction = this.PlayerGUID == source
	if isPlayerAction then
		this:UpdateGCD()
		if event == "SPELL_CAST_SUCCESS" then
			this.LastCastSpell = p1
			this.LastCastTime = GetTime()
			--this:DbgTrack("LastCastSpell", tostring(this.LastCastSpell) .. " - " .. GetSpellInfo(this.LastCastSpell))
		end
	end

  if not (
      string.match(event, "_DAMAGE$")
      or (event == 'DAMAGE_SHIELD')
  ) then
  -- handle events only if it's a damage event
    return
  end

  if isPlayerAction then
		-- if this is one of our own events then
		-- adds the mob to our list, scheduling it to be removed if we dont hear
		-- from it in a short while
		this.MobList:Add(dest)

	elseif this.PlayerGUID == dest then
		-- otherwise, if is someone attacking us
		-- adds the attacker to a list of attackers
		this.AttackerList:Add(source)
		local prefix = strsub(event, 1, 5)
		local value = (prefix == "SWING" and p1) or (prefix == "ENVIR" and p2) or p4

		-- if prefix == "SWING" then
		-- print(event, sname, dname, ...)
		local damage = (value or 0) / UnitHealthMax("player")
		--if(damage > 0) then print("COMBAT DAMAGE: ", damage) end
		this.ElapsedDamaged = (this.ElapsedDamaged or 0) + damage
		if damage >= MINIMUM_DAMAGE_FOR_PAIN then
			this.PainDuration = this.Now + DAMAGE_PAIN_DURATION
		end

	end


end


------------------------------------------------------------------------------
local function Engine_IsInCombat(this)
------------------------------------------------------------------------------
-- returns true if player is in combat
------------------------------------------------------------------------------
  --if UnitInVehicle("player") then return false end

  return (this.LastMode == MODE_AOE)
  or (
    UnitGUID("target")
    and not UnitIsFriend("player", "target")
    and UnitHealth("target") > 0
  ) or (
    UnitAffectingCombat("player") and true
  ) or this.InCombat
end -- fn Engine_IsInCombat


------------------------------------------------------------------------------
local function Engine_SelectMode(this)
------------------------------------------------------------------------------
  this.LastMode = this.Mode
  if #this.CurPrio[MODE_CUSTOM] > 0 then
    this.Mode = MODE_CUSTOM
  else
    this.Mode = MODE_ST
    local aoe = this.AoeMin or 0
    if aoe > 0 and this.Mobs >= aoe then
      this.Mode = MODE_AOE
    end
  end
  return this.Mode
end -- fn Engine_SelectMode


------------------------------------------------------------------------------
local function Engine_CalcGCD_obsolete(this)
------------------------------------------------------------------------------
-- calculates the GCD using the global cooldown of the reference spell
------------------------------------------------------------------------------
  if this.GCDSpell then
    local GCD = select(SPELL_CAST_TIME, GetSpellInfo(this.GCDSpell))
    this.GCD = GCD / 1000 -- cast time comes in msec, turn it into sec
  else
    -- uses a default value for global cooldown...
    this.GCD = 1.5
  end
  return this.GCD
end -- fn Engine_CalcGCD

------------------------------------------------------------------------------
local function Engine_CalcLag(this)
------------------------------------------------------------------------------
-- records the network lag
------------------------------------------------------------------------------
  local lag = select(3, GetNetStats())
  this.Lag = lag / 1000 -- lag comes in msec, turn it into sec
end -- fn Engine_CalcLag


------------------------------------------------------------------------------
local function Engine_CalcDamage(this)
------------------------------------------------------------------------------
-- calculates the incoming damage and provides a fall down of the damage already taken
------------------------------------------------------------------------------
  local Health = UnitHealth("player")
  if not this.PainSnapshot or this.HealthPercent > 0.99 or this.PainPerSecond < 0 then
    this.PainPerSecond = 0
    this.HealthRef = Health
    this.HealthPercentRef = this.HealthPercent
    this.HealthRefTime = this.Now
    this.HealthPercentRef2 this.HealthPercent
    this.PainDelta = 0
    this.PainDelta2 = 0
    return
  end

  this.PainDelta2 = this.HealthPercent / this.HealthPercentRef2 - 1
  this.HealthPercentRef2 = this.HealthPercent
  this.PainDelta = this.HealthPercent / this.HealthPercentRef - 1
  this.PainPerSecond = (this.HealthRef - Health) / (this.Now - this.HealthRefTime)
  
	if this.Debug and (not this.LastSnap or (this.Now - this.LastSnap) >= 1 ) then
		if this.PainPerSecond > 0 then
      ShowMsg("delta: %.2f%% - desta2: %.2f%% - PainPerSecond: %.3f%%", this.PainDelta, this.PainDelta2, this.PainPerSecond)
    end
		this.LastSnap = this.Now
	end
end

------------------------------------------------------------------------------
local function Engine_UpdateState(this)
------------------------------------------------------------------------------
-- colects the information needed to select the spells
------------------------------------------------------------------------------
  this.Now = GetTime()

  local target = UnitGUID("target")
  if target then this.MobList:Add(target) end
  this.Mobs = this.MobList:Refresh()
	this.Attackers = this.AttackerList:Refresh()
  this.Enemies = this.Attackers
  for k, i in pairs(this.MobList.Items) do
    if not this.AttackerList.Items[k] then this.Enemies = this.Enemies + 1 end
  end
  this:SelectMode()
  this:CalcGCD()
  this:CalcLag()

  -- refreshes variables used by spec calculators
  local TLevel = UnitLevel("target") or 0
  this.IsBossFight = (TLevel < 0) or (TLevel > (UnitLevel("player") + 2)) or UnitIsPlayer("target")
	this.IsPvp = UnitIsPlayer("target") and this:CheckDebuff(OBLIVION_SPHERE) == 0
  this.WeAreBeingAttacked = this.Attackers > 0

  this.HealthPercent = UnitHealth("player")/UnitHealthMax("player")
  this:CalcDamage()

  this.HasBloodLust = (this:CheckBuff({SPN.Bloodlust, SPN.Heroism, SPN.TimeWarp, SPN.AncientHysteria}) > 0)

  this.IsMoving = GetUnitSpeed("player") > 0

  -- alllows the initialization of the spec data
  -- for a new cicle
  if this.InitSpec then this.InitSpec(this, this) end
end -- fn Engine_UpdateState

------------------------------------------------------------------------------
local function Engine_UpdateSpells(this)
------------------------------------------------------------------------------
  local now = this.Now
  for k, s in pairs(this.Spells) do
    s:Update(this)
    s:GetActivation(now)
    s:CheckRange()
  end
end

-------------------------------------------------------------------------------
local function Engine_SortFunc(a, b)
-------------------------------------------------------------------------------
-- used to order spells based on priority and availability
-------------------------------------------------------------------------------
  local GRACE_ACTIVATION = 1


  if a.Enabled ~= b.Enabled then
    return a.Enabled
  end
  
  if a.InRange ~= b.InRange then
    return a.InRange
  end
  
  if false and (a.When < b.When) and  (b.When - a.When) > GRACE_ACTIVATION then
    return a.prio * 2 >= b.prio
  end
    
  if false and (a.When > b.When) and (a.When - b.When) > GRACE_ACTIVATION then
    return b.prio * 2 < a.prio
  end
  
  if a.prio == b.prio then
    return (a.When < b.When) or (a.Id < b.Id)
  else
    return a.prio > b.prio
  end
end

-------------------------------------------------------------------------------
local function Engine_SortSpells(this, priority)
-------------------------------------------------------------------------------
-- sorts ths spells by priority
-------------------------------------------------------------------------------
  local PRIO_INC = 100
  local NORM_COOLDOWN = 5
  
  priority = priority or this.priority
  if priority then
    local ctx = this
    local now = this.Now
    for k, s in pairs(priority.spells) do
      s.prio = 0
      s.cdDelta = 0
      s.conditions = "" 
      if s:Update() then
        s.prio = 1
        s:GetActivation(now)
        s:CheckRange()
      end
    end -- for
    
    if priority.init then 
      priority.init(this, ctx)
    end
    local splist = {}
    for k, s in pairs(priority.spells) do
      if s.prio > 1 then 
        s.cdDelta = (NORM_COOLDOWN - math.min(s.Cooldown or NORM_COOLDOWN, NORM_COOLDOWN))  / NORM_COOLDOWN
        table.insert(splist, s) 
      end
    end
    
    for k, c in pairs(priority.conditions) do
      local ok = c.test(this, ctx)
      if ok then
        for i, s in ipairs(c.spells) do
          s.prio = s.prio + (c.weight or 1) * PRIO_INC * s.cdDelta
          s.conditions = s.conditions .. " " .. k
        end
      end
    end -- for k, c
    
    
    table.sort(splist, Engine_SortFunc)
    
    -- maps the spells to already mapped keys
    klist={}
    for k, s in pairs(this.Spells) do
      klist[s.SpName] = s.Message
    end
    
    this.priority.PrevSortedSpells = this.priority.SortedSpells or {{Id=0}, {Id=0}, {Id=0}}
    this.priority.SortedSpells = splist
    
    ctx.CurSpell = splist[1]
    ctx.CurSpell.Message = klist[ctx.CurSpell.SpName]
    
    ctx.NextSpell = splist[2]
    ctx.NextSpell.Message = klist[ctx.NextSpell.SpName]

    
    local sp1 = this.priority.PrevSortedSpells
    local sp2 = this.priority.SortedSpells
    local function show(sp)
      return (klist[sp.SpName] or "??") .. " - " .. sp.SpName .. " (cd: " .. string.format("%.2f", sp.When - now) .. " prio: " .. string.format("%.2f", sp.prio) ..  "-> " .. sp.conditions .. ")"
    end
    
    if sp1[1].Id ~= sp2[1].Id or sp1[2].Id ~= sp2[2].Id then
      ctx.SortCount = (ctx.SortCount or 0) + 1
      if ctx.LastSpellSelection then
        if not ctx.LastCastTime or (ctx.LastCastTime < ctx.LastSpellSelection) then
          print("Spell Change Delta: ", ctx.Now - ctx.LastSpellSelection)
        end
      end
      ctx.LastSpellSelection = ctx.Now
      print("Prio: ", ctx.SortCount, " Mobs: ", ctx.Mobs)
      print("  ", show(sp2[1]))
      print("  ", show(sp2[2]))
      print("  ", show(sp2[3]))
    end
    
    return splist
    
  end
  
end


-------------------------------------------------------------------------------
local function Engine_IsSpellAvailable(this, spell)
-------------------------------------------------------------------------------
-- returns true if the spell can be used right now, false otherwise
-------------------------------------------------------------------------------
	if not spell then return false end
	if not GetSpellCooldown(spell) == 0 then return false end
	local u, m = IsUsableSpell(GetSpellInfo(spell))
	return u == true and m == false

end -- fn Engine_IsSpellAvailable


-------------------------------------------------------------------------------
local function Engine_SwitchToNewSpells(this, BestSpell, SecondBestSpell)
-------------------------------------------------------------------------------
-- returns true if the last suggested spell was not used and is preffered to the
-- current one
-------------------------------------------------------------------------------
  if true then
    if this.CurSpell.Key ~= BestSpell.Key or this.NextSpell.Key ~= SecondBestSpell.Key then
      this:DbgTrack("spells:", (BestSpell.Key or 'none') .. " - " .. (SecondBestSpell.Key or 'none'))
    end
    
    this.CurSpell = BestSpell
    this.NextSpell = SecondBestSpell

    return 
  end

	local GRACE_PERIOD = 0.5 -- half second
	local TimePicked = this.Now

	if not this.CurSpell or not this.CurSpell.SpellId then
	-- ifthere was not a best spell, go on as planned

		-- does nothing here

	elseif this.CurSpell.SpellId == BestSpell.SpellId then
	-- if we are selecting the same spell (even if for different reasons)
	-- pretend it was selected before

		TimePicked = this.CurSpell.TimePicked

	elseif this.CurSpell.SpellId ~= this.LastCastSpell then
	-- if we chose a spell before less than a grace period ago, and it was not used
	-- *and it can be used*, keep it around a little longer (to prevent sudden
	-- changes in the interface)

		if (this.Now - this.CurSpell.TimePicked < GRACE_PERIOD)
		and this.CurSpell.Valid then
			SecondBestSpell = BestSpell
			BestSpell = this.CurSpell
			TimePicked = BestSpell.TimePicked
		end



	end

  if this.CurSpell.SpellIId ~= BestSpell.SpellId then
    this:DbgTrack("BestSpell: ", BestSpell.SpName .. " (" .. BestSpell.Key .. ")")
  end
  
  if this.NextSpell.SpellIId ~= SecondBestSpell.SpellId then
    this:DbgTrack("NextBestSpell: ", SecondBestSpell.SpName .. " (" .. SecondBestSpell.Key .. ")")
  end
  
  
	this.CurSpell = BestSpell
	this.NextSpell = SecondBestSpell
	this.CurSpell.TimePicked = TimePicked

end -- fn Engine_SwitchToNewSpells


-------------------------------------------------------------------------------
local function Engine_SelectSpells(this, spells)
-------------------------------------------------------------------------------
-- selects two spells as the best one and the next best one
-------------------------------------------------------------------------------

	-- if the last used spell is already available, allows it to be picked otherwise
	-- prefer another spell
	local LastSpell = not this:IsSpellAvailable(this.LastCastSpell) and this.LastCastSpell
	local Primary = {}
	local Secondary = {}
	for k, s in pairs(this.Spells) do
		if s.Primary then Primary[k] = true end
		if s.Secondary then Secondary[k] = true end
	end
	local curspell = this:FindBestSpell(nil, spells, Secondary)
	local nextspell = this:FindBestSpell(curspell.SpellId, spells, Primary)

	this:SwitchToNewSpells(curspell, nextspell)

	end -- fn Engine_SelectSpells()


-------------------------------------------------------------------------------
local function Engine_FindBestSpell(this, except, spells, NotThese)
-------------------------------------------------------------------------------
-- returns the best spell form the list of priorities, excluding the one
-- given by except
-------------------------------------------------------------------------------
  local Prio = this.CurPrio[this.Mode]
  local Spells = spells or this.Spells
	NotThese = NotThese or {}

  -- creates two dummy spells for [current] and [next]
  local curspell = Spell_Create()
  curspell.When = this.Now + 60000
  curspell.InRange = false

  local Delta = this.GCD / 2 -- 0 -- math.max((this.Throtle or 0), 1/8)
  local GCDx2 = this.GCD * 2

  for _, k in ipairs(Prio) do
  -- verifies which spell is the first to come, in prio order
		if not NotThese[k] then
			local s = Spells[k]
			local valid = s
				and (s.SpellId ~= except)
				and (s.SpellId ~= curspell.SpellId)
				and s.Valid

			if valid then
				local when = s.When
				-- decides the better spell based on availability/range
				local better = (s.InRange and not curspell.InRange)
					or ((s.InRange == curspell.InRange) and (curspell.When > when))


				if better then
				-- found a good spell
					curspell = s
				end -- if better
			end -- if valid
		end -- NotThese
  end -- for k...

	return curspell

end -- fn Engine_FindBestSpell



-------------------------------------------------------------------------------
local function Engine_SelectSpells_old(this)
-------------------------------------------------------------------------------
  local Prio = this.CurPrio[this.Mode]
  local Spells = this.Spells

  local now = this.Now

  -- creates two dummy spells for [current] and [next]
  local curspell = Spell_Create()
  curspell.When = now + 60000

  local nextspell = Spell_Create()
  nextspell.When = now + 60000

  --local Casting, _, _, _, CastStart, CastEnd = UnitCastingInfo("player")
  -- only takes casting into account if its about to finish
  -- (in this case we try not to interrupt it)
  --if (Casting and ((now * 1000 - CastStart) / (CastEnd - CastStart) < .7)) then Casting = nil end

  -- future indicates when the next spell will become usable
  local future = now + this.Lag + this.GCD

  -- delta prevents a good spell losing to a not so good one because
  -- of some few msecs. If throtle is set, delta will try to
  -- keep a good spell thats becoming available in the next cicle
  local Delta = 0 -- math.max((this.Throtle or 0), 1/8)

  for _, k in ipairs(Prio) do
  -- verifies which spell is the first to come, in prio order
    local s = Spells[k]
    local valid = s
      and (s.SpName ~= curspell.SpName)
      and (s.SpName ~= nextspell.SpName)
      and s.Valid

    if valid then
      local when = s.When
      -- decides the better spell based on availability/range
      local better = (not curspell.InRange and s.InRange)
        or ((when + Delta) < curspell.When)


      if better then
      -- found a good spell
        nextspell = curspell
        curspell = s
        nextspell.When = math.max(nextspell.When, future)
      else
      -- this is no better than the current spell,
      -- so lets check it against the next spell
        when = math.max(when, future)
        if when < nextspell.When then
        -- makes this the nextspell if it is available
        -- earlier than the current nextspell
          nextspell = s
          nextspell.When = when
        end -- if
      end -- if better
    end -- if valid
  end -- for k...
  if this.Debug then
    if curspell and curspell.Key and (this.CurSpell.Key ~= curspell.Key) then
			ShowMsg(
				format("[%s] %s: %s - %s",
					this.Mode,
					curspell.Key,
					curspell.SpName,
					curspell.Tooltip or L'[no description]'
				)
      )
		elseif curspell and not curspell.Key and this.CurSpell.Key then
			ShowMsg(L"No Spell")
		end
  end

	local timePicked = this.Now

	if this.CurSpell and this.CurSpell.SpellId and this.CurSpell.SpellId ~= curspell.SpellId then
	-- if we selected another spell and make it available only at least 0.5 seconds from the time
	-- we previously selected it, so we have a smoothier transition between spells
		if (this.CurSpell.SpellId ~= this.LastCastSpell) and
			((this.Now - this.CurSpell.picked) < 0.5) then
			-- keep the current spell but set the next best one as the one we just found
			nextspell = curspell
			curspell = this.CurSpell
			timePicked = curspell.picked
		end

	end

  this.CurSpell = curspell
	this.CurSpell.picked = timePicked

  this.NextSpell = nextspell
end -- fn Engine_SelectSpells()


-------------------------------------------------------------------------------
local function Engine_Reset(this, mode)
-------------------------------------------------------------------------------
  this.CurPrio[mode] = this.RefPrio[mode] or nil
end -- fn Engine_Reset


-------------------------------------------------------------------------------
local function Engine_MapSpellsToBook(this)
-------------------------------------------------------------------------------
-- adds a spellbook index to the spells, which is needed for some methods
-- (specifically, IsSpellInRange is working unreliably with the spell name,
-- but it works ok if the spellbook index is used
-------------------------------------------------------------------------------
  local INDEX_SPELL_ID = 7
  local sp = {}
  local k, s, i

  local function initId(k, v)
    sp["" .. k] = v or 0
  end

  local function getId(k)
    return sp["" .. k] or false
  end

  local function getSpellSlot(id, name)
    local ok, index = pcall(FindSpellBookSlotBySpellID, id)
    if not ok then ShowError("Error locating spell book index for %s (%d)", tostring(name), id) end
    return index
  end
  
  -- gets the id of each spell (and of the RangeSpell, if present)
  for k, s in pairs(this.Spells) do
    local id = s.Id or select(INDEX_SPELL_ID, GetSpellInfo(s.SpName))
    if id then
      s.SpellId = id
      s.SpellBookIndex = getSpellSlot(id, s.Key)
      
      --initId(id)
      if s.RangeSpell then
        id = (type(s.RangeSpell) == "number" and s.RangeSpell) or select(INDEX_SPELL_ID, GetSpellInfo(s.RangeSpell))
        s.RangeSpellId = id
        s.RangeSpellBookIndex = getSpellSlot(id, s.RangeSpell)
        --initId(id)
      end
    end
  end

  -- saves RangeSpellBookIndex and NoRange if the spell uses no range
  for k, s in pairs(this.Spells) do
    if not s.NoRange and not s.NoTarget then
      if s.SpellId then
        --s.SpellBookIndex = getId(s.SpellId)
        if s.RangeSpellId then
          --s.RangeSpellBookIndex = getId(s.RangeSpellId)
          s.SpellBookIndexForRange = s.RangeSpellBookIndex
        elseif s.SpellBookIndex then
          s.NoRange = not SpellHasRange(s.SpellBookIndex, BOOKTYPE_SPELL)
          if not s.NoRange then s.SpellBookIndexForRange = s.SpellBookIndex end
        end
      else
        s.NoRange = true
      end
    end
  end


end

-------------------------------------------------------------------------------
local function Engine_HasTalent(this, row, col)
-------------------------------------------------------------------------------
	local sg = GetActiveSpecGroup()
	return (select(4, GetTalentInfo(row, col, sg)) and true) or false
end

-------------------------------------------------------------------------------
local function Engine_SpellCooldown(this, n)
-------------------------------------------------------------------------------
-- returns the cooldown remaining, in seconds, of the specified spell
-- if the spell is invalid returns a bogus number. if the spell is ready,
-- returns 0
-------------------------------------------------------------------------------
	local s, d = GetSpellCooldown(n)
	if s == nil then return 60*60*24 end
	return (s > 0 and (s + d - this.Now)) or 0
end

-------------------------------------------------------------------------------
local function Engine_SpellCharges(this, spellname)
-------------------------------------------------------------------------------
	local c, m, s, d = GetSpellCharges(spellname)
	if c == nil then return 0 end
	if c == m then return c end
	return c + ((s + d - this.Now)/d)
end

-------------------------------------------------------------------------------
local function Engine_CheckBuffDebuff(this, Getter, Comparer)
-------------------------------------------------------------------------------
  for i = 1, 128 do
    local name, _, count, _, duration, expires, _, _, _, id = Getter(i)
    if not id then break end
    if Comparer(name, id) then
      if not count then count = 0 elseif count == 0 then count = 1 end
			local xp = expires
      if not expires then expires = 0 else expires = expires - this.Now end
      return count, expires, duration, name, id, xp
    end
  end
  return 0, 0, 0
end

-------------------------------------------------------------------------------
local function Engine_CheckBuffDebuffAuto(this, What, isDebuff, target)
-------------------------------------------------------------------------------
  local Getter
	if	isDebuff then
		target = target or "target"
		local src = (target ~= "PLAYER" and "PLAYER") or nil 
		Getter = function(i) return UnitDebuff(target, i, src) end
	else
		target = target or "PLAYER"
		Getter = function(i) return UnitBuff("PLAYER", i) end
	end
	if type(What) ~= "table" then What = {What} end
  for i = 1, 128 do
    local name, _, count, _, duration, expires, _, _, _, id = Getter(i)
    if not id then break end
		for _, n in ipairs(What) do
			local found = false
			if type(n) == "string" then found = (n == name) else found = (n == id) end
			if found then
				if not count then count = 0 elseif count == 0 then count = 1 end
				local xp = expires
				if not expires then 
					expires = 0 
				elseif expires > 0 then 
					expires = expires - this.Now 
				end
				return count, expires, duration, name, id, xp
			end
		end
  end
  return 0, 0, 0
end


-------------------------------------------------------------------------------
local function Engine_CheckDebuff(this, Debuff, target)
-------------------------------------------------------------------------------
	return this:CheckBuffOrDebuffAuto(Debuff, true, target)
end

-------------------------------------------------------------------------------
local function Engine_CheckBuff(this, Buff, target)
-------------------------------------------------------------------------------
	return this:CheckBuffOrDebuffAuto(Buff, false, target)
end

-------------------------------------------------------------------------------
local function Engine_CheckEnemyDistance(this, distance)
-------------------------------------------------------------------------------
-- returns true if there's any enemy at the specified distance
-------------------------------------------------------------------------------
  distance = distance or 3
  local result = CheckInteractDistance("target", distance) or false
  if not result and this.Attackers > 0 then
    for k, n in pairs(this.AttackerList) do
      if CheckInteractDistance(k, distance) then
        result = true
        break
      end
    end
  end
  if not result and this.Mobs > 0 then
    for k, n in pairs(this.MobList) do
      if CheckInteractDistance(k, distance) then
        result = true
        break
      end
    end
  end
  return result
end

-------------------------------------------------------------------------------
local function Engine_CheckEnemyIsClose(this)
-------------------------------------------------------------------------------
  return this:CheckEnemyDistance(3)
end

-------------------------------------------------------------------------------
local function Engine_CheckEnemyIsNotFar(this)
-------------------------------------------------------------------------------
  return this:CheckEnemyDistance(2)
end

-------------------------------------------------------------------------------
local function Engine_CheckEnemyIsFar(this)
-------------------------------------------------------------------------------
  return this:CheckEnemyDistance(1)
end

-------------------------------------------------------------------------------
local function Engine_HasGlyphSpell(SpellId)
-------------------------------------------------------------------------------
	for n = 1, GetNumGlyphSockets() do
	  local _, _, _, s = GetGlyphSocketInfo(n)
	  if s == SpellId then return true end
	end
	return false
end -- HasGlyphSpell


-------------------------------------------------------------------------------
local function Engine_DbgTrack(this, name, value)
-------------------------------------------------------------------------------
	nome = tostring(name)
	local key = "track_" .. name
	if(this[key] ~= value) then
		DbgMsg("%s : %s -> %s", tostring(this.Now), name, tostring(value))
		this[key] = value
	end
	return value
end


-------------------------------------------------------------------------------
local function Engine_Dump(this)
-------------------------------------------------------------------------------
  local temp = {}
	for k, v in pairs(this) do
		if(type(v) ~= "function") then
			table.insert(temp, format("%s = %s", k, tostring(v)))
		end
	end
  table.sort(temp)
	for n, v in ipairs(temp) do
    print(v)
	end
end


-------------------------------------------------------------------------------
local function Engine_Create(Spec, Spells, Prio, GCDSpell, Throtle, Frame)
-------------------------------------------------------------------------------
  local eng = {}

  local EmptySpell = Spell_Create()

  eng.Spec = Spec or ''             -- player spec we are handling
  eng.Spells = Spells or {}         -- list of valid spells indexed by keys
  eng.Frame = Frame                 -- the spell frame
  eng.RefPrio = NormalizeMode(Prio) -- array with spell ids in priority list
  eng.Throtle = Throtle or 0        -- how long to throtle the engine (in ms)
  eng.GCDSpell = GCDSpell           -- spell to use in gcd calculation
  eng.WeAreBeingAttacked = false
  eng.DamageReceived = 0            -- the damage received recently as a percentual of toal health
	eng.PainDuration = false        	-- interval that we feel the last damage received.
	eng.PainPerSecond = 0             -- percentual estimate for the damage we are receiving
	eng.ElapsedDamaged = 0            -- the raw damage received between updates
	eng.HealthPercent = 1							 

  eng.Mobs = 0                      -- current number of mobs being hit by the player
	eng.Attackers = 0                 -- current number of enemies attacking us
  eng.MobList = Tracker_Create()    -- tracks the mobs being hit
	eng.AttackerList = Tracker_Create()  -- tracks who are attacking us
  eng.CurSpell = EmptySpell         -- the suggested current spell object
  eng.NextSpell = EmptySpell        -- the suggested next spell object
  eng.Elapsed = 0                   -- records the elapsed time since the last update
  eng.LastMode = ''                 -- last spell mode used
  eng.InCombat = false              -- true if the engine thinks we are in combat
  eng.Mode = ''                     -- current spell mode
  eng.GCD = 0                       -- the current global cooldown
  eng.Lag = 0                       -- the network lag of the current session
  eng.Now = 0                       -- current time
  eng.CurPrio = eng.RefPrio
  eng.PlayerGUID = UnitGUID("player")

  -- Engine API
  eng.HandleEnterCombat = Engine_HandleEnterCombat
  eng.HandleLeaveCombat = Engine_HandleLeaveCombat
  eng.HandleCombatLog = Engine_HandleCombatLog
  eng.HandleTargetChanged = Engine_HandleTargetChanged
  eng.Update = Engine_Update
  eng.ShowHideFrame = Engine_ShowHideFrame
  eng.IsInCombat = Engine_IsInCombat
  eng.SelectMode = Engine_SelectMode
  eng.CalcGCD = Engine_UpdateGCD -- Engine_CalcGCD
  eng.CalcLag = Engine_CalcLag
  eng.UpdateState = Engine_UpdateState
  eng.UpdateSpells = Engine_UpdateSpells
  eng.SelectSpells = Engine_SelectSpells
	eng.FindBestSpell = Engine_FindBestSpell
	eng.IsSpellAvailable = Engine_IsSpellAvailable
	eng.SwitchToNewSpells = Engine_SwitchToNewSpells
  eng.FindSpellName = Engine_FindSpellName
  eng.Reset = Engine_Reset
  eng.MapSpellsToBook = Engine_MapSpellsToBook
  eng.CalcDamage = Engine_CalcDamage
	eng.UpdateGCD = Engine_UpdateGCD

  eng.CheckBuff = Engine_CheckBuff
  eng.CheckDebuff = Engine_CheckDebuff
  eng.CheckEnemyDistance = Engine_CheckEnemyDistance
  eng.CheckEnemyIsClose = Engine_CheckEnemyIsClose
  eng.CheckEnemyIsNotFar = Engine_CheckEnemyIsNotFar
  eng.CheckEnemyIsFar = Engine_CheckEnemyIsFar  
	eng.CheckBuffOrDebuffAuto = Engine_CheckBuffDebuffAuto
	eng.HasTalent = Engine_HasTalent
	eng.SpellCharges = Engine_SpellCharges
	eng.SpellCooldown = Engine_SpellCooldown
  eng.HasGlyphSpell = Engine_HasGlyphSpell
  eng.Dump = Engine_Dump
	eng.DbgTrack = Engine_DbgTrack
  eng.SortSpells = Engine_SortSpells

  eng:MapSpellsToBook()

  return eng
end -- fn Engine_Create



--//////////////////////////////////////////////////////////////////////////////
-- EventFrame
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function EventFrame_RegisterFor(this, event, target, context)
--------------------------------------------------------------------------------
-- associates an event handler with a system event.
-- multiple calls for the same event can be made to register different
-- "listeners".
--------------------------------------------------------------------------------
  if not this[event] then
    this[event] = Event_Create(this)
    this:RegisterEvent(event)
  end
  if target then this[event]:Add(target, context) end
end

--------------------------------------------------------------------------------
local function EventFrame_Unregister(this, event)
--------------------------------------------------------------------------------
  this:UnregisterEvent(event)
  this[event] = nil
end

--------------------------------------------------------------------------------
local function EventFrame_Create()
--------------------------------------------------------------------------------
  local ef = CreateFrame("Frame")
  ef:SetScript(
    "OnEvent",
    function(this, event, ...)
      if this[event] then
        this[event]:Raise(...)
      end
    end
  )
  ef.RegisterFor = EventFrame_RegisterFor
  ef.Unregister = EventFrame_Unregister
  return ef
end




--//////////////////////////////////////////////////////////////////////////////
-- SpecInfo
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
local function SpecInfo_SetAuras(this, Slot, ...)
--------------------------------------------------------------------------------
-- defines a list of auras to monitor
  return this:SetSlot(Slot, "a", ...)
end -- SpecInfo_AddAura


--------------------------------------------------------------------------------
local function SpecInfo_SetBuffs(this, Slot, ...)
--------------------------------------------------------------------------------
-- defines a list of buffs to monitor
  return this:SetSlot(Slot, "b", ...)
end


--------------------------------------------------------------------------------
local function SpecInfo_SetDebuffs(this, Slot, ...)
--------------------------------------------------------------------------------
-- defines a list of debuffs to monitor
  return this:SetSlot(Slot, "d", ...)
end


--------------------------------------------------------------------------------
local function SpecInfo_SetSpells(this, Slot, ...)
--------------------------------------------------------------------------------
-- defines a list of spells to monitor
  return this:SetSlot(Slot, "s", ...)
end


--------------------------------------------------------------------------------
local function SpecInfo_SetSlot(this, Slot, Mode, ...)
--------------------------------------------------------------------------------
  local r = {...}
  r.IsAura = Mode == "a"
  r.IsBuff = Mode == "b"
  r.IsDebuff = Mode == "d"
  r.IsSpell = Mode == "s"
  --this["Sp" .. Slot] = r
  table.insert(this.XIcons, r)
  return r
end

--------------------------------------------------------------------------------
local function SpecInfo_SetInterrupts(this, ...)
--------------------------------------------------------------------------------
--- defines a list of Interrupts to monitor
  local r = {...}
  this.Interrupt = r
  return r
end


--------------------------------------------------------------------------------
local function SpecInfo_SetSingleTargetSpells(this, ...)
--------------------------------------------------------------------------------
  if not this.Prio then this.Prio = {} end
  local r = {...}
  this.Prio[MODE_ST] = r
  return r
end

--------------------------------------------------------------------------------
local function SpecInfo_AddSingleTargetSpell(this, spell)
--------------------------------------------------------------------------------
-- adds a single spell at the end of the priority list
--------------------------------------------------------------------------------
  if not this.Prio then this.Prio = {} end
  if not this.Prio[MODE_ST] then this.Prio[MODE_ST] = {} end
  table.insert(this.Prio[MODE_ST], spell)
end

--------------------------------------------------------------------------------
local function SpecInfo_SetAoeSpells(this, ...)
--------------------------------------------------------------------------------
  if not this.Prio then this.Prio = {} end
  local r = {...}
  this.Prio[MODE_AOE] = r
  return r
end


--------------------------------------------------------------------------------
local function SpecInfo_SetVar(this, Name, Value)
--------------------------------------------------------------------------------
  if not this.vars then this.vars = {} end
  this.vars[Name] = Value
  return Value
end


--------------------------------------------------------------------------------
local function SpecInfo_AddSpell(this, Key, Name, Condition, Description)
--------------------------------------------------------------------------------
--- adds a list of interrupt spells
  if not Key or not Name then
    ShowError("bad key or name: [key: %s] - [name: %s]", Key or "", Name or "")
  end

  if not this.Spells then this.Spells = {} end
  
  local r = nil
  if type(Name) == "number" then
    r = Spell_CreateById(Name)
    r.Key = Key
  else
    r = Spell_Create(Key, Name)
  end
  r.Condition = Condition
  r.Description = Description
  
  this.Spells[Key] = r
  return r
end


--------------------------------------------------------------------------------
local function SpecInfo_Create(SpecName)
--------------------------------------------------------------------------------
  local r = {}
  r.AddSpell = SpecInfo_AddSpell
  r.SetVar = SpecInfo_SetVar
  r.SetSingleTargetSpells = SpecInfo_SetSingleTargetSpells
  r.SetAoeSpells = SpecInfo_SetAoeSpells
  r.MonitorInterrupts = SpecInfo_SetInterrupts
  r.MonitorBuffs = SpecInfo_SetBuffs
	r.MonitorDebuffs = SpecInfo_SetDebuffs
  r.MonitorAuras = SpecInfo_SetAuras
  r.MonitorSpells = SpecInfo_SetSpells
  r.SetSlot = SpecInfo_SetSlot
  r.AddSingleTargetSpell = SpecInfo_AddSingleTargetSpell

  r.SpecName = SpecName
  r.vars = {}
  r.XIcons = {}
  return r
end


--///////////////////////////////////////////////////////////////////////////////
-- DEBUG
--///////////////////////////////////////////////////////////////////////////////
-------------------------------------------------------------------------------
local function Debug_ShowSpellNames(this, spn)
-------------------------------------------------------------------------------
-- shows the content of the list, sorted by key
-------------------------------------------------------------------------------
	local temp = {}
	for k, n in pairs(spn) do table.insert(temp, format("%s = %s", k, n or "*[INVALID]*")) end
	table.sort(temp)
	for k, n in ipairs(temp) do print(n) end
end


-------------------------------------------------------------------------------
local function Debug_ShowSpells(this)
-------------------------------------------------------------------------------
	local temp = {}
	local spells = Main.Engine.Spells
	for k, s in pairs(spells) do table.insert(temp, k) end
	table.sort(temp)
	for k, n in ipairs(temp) do
		ShowMsg("%d - %s", k, n)
		spells[n]:Debug();
	end
end

-------------------------------------------------------------------------------
local function Debug_On()
-------------------------------------------------------------------------------
	Main.Engine.Debug = true
	Main.Debug = true
end


-------------------------------------------------------------------------------
local function Debug_Off()
-------------------------------------------------------------------------------
	Main.Engine.Debug = false
	Main.Debug = false
end


-------------------------------------------------------------------------------
local function Debug_Create()
-------------------------------------------------------------------------------
	local r ={}
	r.ShowSpellNames = Debug_ShowSpellNames
	r.ShowSpells = Debug_ShowSpells
	r.On = Debug_On
	r.Off = Debug_Off
	return r
end




--//////////////////////////////////////////////////////////////////////////////
-- Main methods
--//////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
function Main:Translate(Text)
--------------------------------------------------------------------------------
  return L(Text)
end

--------------------------------------------------------------------------------
function Main:PrepareEngine()
--------------------------------------------------------------------------------
-- selects the appropriate engine data for the current spec. If no engine is
-- present orelse there's no data for this spec, hides the main frame
--------------------------------------------------------------------------------
  local Ok = false
  local Spec = GetSpecialization() or (self.EngineData and self.EngineData.DefaultSpec) or 0
  self.Spec = Spec
  self.SpecName = ''
  local Data = self.EngineData
  if Data[Spec] and Data[Spec].Spells then
    DbgMsg("Found Spec %s", Spec)
    Ok = true
    Data = Data[Spec]
    self.SpecName = Data.SpecName
    self.Engine = Engine_Create(
      Data.SpecName,
      Data.Spells,
      Data.Prio,
      Data.GCDSpell,
      self.Throtle,
      self.MainFrame
    )
    self.Engine.InitSpec = Data.InitSpec or (ShowMsg("No initialization for this spec") or function() end)
    self.Engine.SpecToolbar = Data.SpecToolbar
    self.Engine.HideFrame = not (Data.Spells and Data.Prio)
    self:InitXIcons(Data.XIconsRowSize)
    self:ReloadIcons()
    
    local BuildIcon = function(Icon, Value)
     -- converts the icon into an appropriate type for the data
      if not Value then
        return
      elseif Value.IsBuff then
        BuffIcon_FromIcon(Icon)
        Icon.Buffs = Value
      elseif Value.IsDebuff then
        DebuffIcon_FromIcon(Icon)
        Icon.Debuffs = Value
      elseif Value.IsAura then
        AuraIcon_FromIcon(Icon)
        Icon.Auras = Value
      elseif Value.IsSpell then
        SpellMonitorIcon_FromIcon(Icon)
        Icon.Spells = Value
      end
      Icon.Tooltip = Value.Tooltip
    end
    
    --BuildIcon(self.Sp1, Data.Sp1)
    --BuildIcon(self.Sp2, Data.Sp2)
    --BuildIcon(self.Sp3, Data.Sp3)
    --BuildIcon(self.Sp4, Data.Sp4)
    --BuildIcon(self.Sp5, Data.Sp5)
    for i, what in ipairs(Data.XIcons) do
      local icon = self:AddXIcon()
      BuildIcon(icon, what)
    end

    self.InterruptIcon.Spells = Data.Interrupt
    self.LoadKeysNeeded = true

    
    
  else
    self.Engine = nil
  end

  self.Active = Ok
  self:AttachEngine()
  self.MainFrame:SetVisible(Ok)
  
  if self.Engine then self.Engine.priority = self.priorityData end
end -- fn Main:PrepareEngine


--------------------------------------------------------------------------------
function Main:AttachEngine()
--------------------------------------------------------------------------------
-- wire the engine to the events it needs
--------------------------------------------------------------------------------
  if self.Active and not self.vars then self:SetVars() end

  local fr = self.EventFrame
  local eng = self.Engine or {}

  local SetEvent = function(Name, Handler)
    local e = fr[Name]
    e:Clear()
    if Handler then e:Add(Handler, eng) end
  end

  SetEvent('PLAYER_ENTER_COMBAT', eng.HandleEnterCombat)
  SetEvent('PLAYER_LEAVE_COMBAT', eng.HandleLeaveCombat)
  SetEvent('COMBAT_LOG_EVENT_UNFILTERED', eng.HandleCombatLog)
  SetEvent('PLAYER_TARGET_CHANGED', eng.HandleTargetChanged)

  if self.Active then
    eng.AoeMin = self:GetAoeMin()
    eng.CheckRange = self:GetCheckRange()
  end

end -- fn Main:AttachEngine

--------------------------------------------------------------------------------
function Main:EnableEvents()
--------------------------------------------------------------------------------
  local fr = self.EventFrame
  fr:RegisterFor('PLAYER_LOGIN', self.HandlePlayerLogin, self)
  fr:RegisterFor('PLAYER_ENTER_COMBAT')
  fr:RegisterFor('PLAYER_LEAVE_COMBAT')
  fr:RegisterFor('PLAYER_TARGET_CHANGED')
  fr:RegisterFor('COMBAT_LOG_EVENT_UNFILTERED')
  fr:RegisterFor('UPDATE_SHAPESHIFT_FORM', self.HandleShapeshiftUpdate, self)
  fr:RegisterFor('PLAYER_TALENT_UPDATE', self.HandleTalentUpdate, self)
	fr:RegisterFor('ACTIVE_TALENT_GROUP_CHANGED', self.HandleTalentGroupChanged, self)
end --  fn Main:EnableEvents

--------------------------------------------------------------------------------
function Main:DisableEvents()
--------------------------------------------------------------------------------
  local fr = self.EventFrame
  fr:Unregister('PLAYER_LOGIN')
  fr:Unregister('PLAYER_ENTER_COMBAT')
  fr:Unregister('PLAYER_LEAVE_COMBAT')
  fr:Unregister('PLAYER_TARGET_CHANGED')
  fr:Unregister('COMBAT_LOG_EVENT_UNFILTERED')
  fr:Unregister('PLAYER_TALENT_UPDATE')
	fr:Unregister('ACTIVE_TALENT_GROUP_CHANGED')
end -- fn Main:DisableEvents


--------------------------------------------------------------------------------
function Main:HandleShapeshiftUpdate(evt, ...)
--------------------------------------------------------------------------------
  self.LoadKeysNeeded = true
end -- fn Main:HandlePlayerLogin

--------------------------------------------------------------------------------
function Main:HandlePlayerLogin(evt, ...)
-------------------------------------------------------------------------------
  DbgMsg("Player Login")
  self:PrepareEngine()
end -- fn Main:HandlePlayerLogin

--------------------------------------------------------------------------------
function Main:HandleTalentUpdate(evt, ...)
--------------------------------------------------------------------------------
	DbgMsg("Talent update")
	self.TalentsChanged = true
end -- fn Main:HandleTalentUpdate

--------------------------------------------------------------------------------
function Main:HandleTalentGroupChanged(evt, ...)
--------------------------------------------------------------------------------
	DbgMsg("Talent group change")
	self.SpecChanged = true
end -- fn Main:HandleTalentUpdate

--------------------------------------------------------------------------------
function Main:HandleOnUpdate(evt, elapsed, ...)
--------------------------------------------------------------------------------
	if self.Engine then self.Engine.Now = GetTime() end
  self.Elapsed = self.Elapsed + elapsed
  -- exits if throtling
  if self.Throtle and self.Elapsed < self.Throtle then return end

	if self.SpecChanged or self.TalentsChanged then
		if self.SpecChanged then
			self.SpecChanged = false
			DbgMsg("Engine was reset")
			self:InitEngineData()
		else
			self.TalentsChanged = false
			DbgMsg('Talents were reset')
		end-- reloads the engine!
		self:PrepareEngine()
	end


  if self.Engine then
    if self.LoadKeysNeeded then
      self.LoadKeysNeeded = false
      self:LoadKeys()
    end
		self.Engine.Elapsed = elapsed
    self.Engine:Update()
    self:UpdateIcons()
  end
end -- fn Main:HandleOnUpdate(

--------------------------------------------------------------------------------
function Main:UpdateIcons()
--------------------------------------------------------------------------------
  local Ctx = self.Engine
  for i, sp in ipairs(self.Icons) do
    sp:Update(Ctx)
  end
  local GetSpName = function(spinfo)
    return (spinfo and spinfo ~= '' and spinfo.SpName) or L'None'
  end
  self.CurSpellIcon.TooltipData = GetSpName(Ctx.CurSpell)
  self.NextSpellIcon.TooltipData = GetSpName(Ctx.NextSpell)
end -- fn Main:UpdateIcons

--------------------------------------------------------------------------------
function Main:SetVars()
--------------------------------------------------------------------------------
-- loads saved variables, applying defaults if necessary
--------------------------------------------------------------------------------
  if not L2P_SavedVars then L2P_SavedVars = {} end
  local Vars = L2P_SavedVars

  self.vars = Vars

  local Prio = (Vars.Prio and Vars.Prio[self.Spec]) or {}

  self:SetPrio(MODE_ST, Prio[MODE_ST])
  self:SetPrio(MODE_AOE, Prio[MODE_AOE])
  self:SetPrio(MODE_CUSTOM, Prio[MODE_CUSTOM])

  self:SetLocked(Vars.Locked)

  -- number of mobs to consider aoe
  self:SetAoeMin(Vars.AoeMin and Vars.AoeMin[self.SpecName])

  -- user wants to see spell range information
  self:SetCheckRange(Vars.CheckRange)

  -- alpha value for the main frame
  self:SetAlpha(Vars.Alpha)

  -- the messages to show on each spell
  self:SetMessages(Vars.Messages and Vars.Messages[self.SpecName])

  -- the frequency value
  self:SetFrequency(Vars.Frequency)
end -- fn Main:SetVars

--------------------------------------------------------------------------------
function Main:SetAoeMin(value)
--------------------------------------------------------------------------------
  local DefaultValue = self.EngineData[self.Spec].AoeMin or 0
  if value == nil then value = DefaultValue end
  value = tonumber(value)
  if value == DefaultValue then
    if self.vars.AoeMin then self.vars.AoeMin[self.SpecName] = nil end
  else
    if not self.vars.AoeMin then self.vars.AoeMin = {} end
    self.vars.AoeMin[self.SpecName] = value
  end
  if self.Engine then self.Engine.AoeMin = value end
end -- fn Main:SetAoeMin

--------------------------------------------------------------------------------
function Main:GetAoeMin()
--------------------------------------------------------------------------------
  if not (self.vars and self.vars.AoeMin and self.vars.AoeMin[self.SpecName]) then
    return self.EngineData[self.Spec].AoeMin or 0
  end
  return self.vars.AoeMin[self.SpecName]
end -- fn Main:GetAoeMin

--------------------------------------------------------------------------------
function Main:SetCheckRange(value)
--------------------------------------------------------------------------------
  if value == nil then value = DEFAULT_CHECKRANGE end
  value = (value and true) or false
  if value == DEFAULT_CHECKRANGE then
    self.vars.CheckRange = nil
  else
    self.vars.CheckRange = value
  end
  self.CheckRange = value
  if self.Engine then self.Engine.CheckRange = value end
end -- fn Main:SetCheckRange

--------------------------------------------------------------------------------
function Main:GetCheckRange()
--------------------------------------------------------------------------------
  if self.vars.CheckRange == nil then return DEFAULT_CHECKRANGE end
  return self.vars.CheckRange
end -- fn Main:GetCheckRange

--------------------------------------------------------------------------------
function Main:SetLocked(value)
--------------------------------------------------------------------------------
  if value == nil then value = DEFAULT_LOCKED end
  value = (value and true) or false
  if value == DEFAULT_LOCKED then
    self.vars.Locked = nil
  else
    self.vars.Locked = value
  end
  self.MainFrame:SetLocked(value)
end -- fn Main:SetLocked

--------------------------------------------------------------------------------
function Main:GetCheckRange()
--------------------------------------------------------------------------------
  if self.vars.CheckRange == nil then return DEFAULT_CHECKRANGE end
  return self.vars.CheckRange
end -- Main:GetCheckRange

--------------------------------------------------------------------------------
function Main:SetMessages(Keys)
--------------------------------------------------------------------------------
  if Keys == nil or Keys == '' then
    for k, s in pairs(self.Engine.Spells) do
      s.Message = nil
    end
    if self.vars.Messages then
      self.vars.Messages[self.SpecName] = nil
    end
  else
    for k, m in pairs(Keys) do
      local Sp = self.Engine.Spells[k]
      if m == '' then m = nil end
      if Sp then Sp.Message = m end
    end
    if not self.vars.Messages then self.vars.Messages = {} end
    self.vars.Messages[self.SpecName] = self:GetMessages()
  end
end

--------------------------------------------------------------------------------
function Main:GetMessages()
--------------------------------------------------------------------------------
  local list = {}
  for k, s in pairs(self.Engine.Spells) do
    if s.Message then list[k] = s.Message end
  end
  return list
end -- fn Main:GetMsg

--------------------------------------------------------------------------------
function Main:SetAlpha(value)
--------------------------------------------------------------------------------
  if value == nil then value = DEFAULT_ALPHA end
  value = math.min(1, math.max(0, tonumber(value)))
  if value == DEFAULT_ALPHA then
    self.vars.Alpha = nil
  else
    self.vars.Alpha = value
  end
  self.MainFrame:SetAlpha(value)
end -- fn Main:SetAlpha


--------------------------------------------------------------------------------
function Main:GetAlpha()
--------------------------------------------------------------------------------
  if self.vars.Alpha == nil then return DEFAULT_ALPHA end
  return self.vars.Alpha
end -- Main:GetAlpha

--------------------------------------------------------------------------------
function Main:SetFrequency(value)
--------------------------------------------------------------------------------
  if value == nil then value = DEFAULT_FREQUENCY end
  value = math.min(MAX_FREQUENCY, math.max(0, tonumber(value)))
  if value == DEFAULT_FREQUENCY then
    self.vars.Frequency = nil
  else
    self.vars.Frequency = value
  end
  value = (value == 0 and 0) or 1/value
  self.Throtle = value
  if self.Engine then self.Engine.Throtle = value end
end -- fn Main:SetFrequency

--------------------------------------------------------------------------------
function Main:GetFrequency()
--------------------------------------------------------------------------------
  if self.vars.Frequency == nil then return DEFAULT_FREQUENCY end
  return self.vars.Frequency
end -- fn Main:GetFrequency

--------------------------------------------------------------------------------
function Main:SetPrio(mode, value)
--------------------------------------------------------------------------------
-- Gets/Sets the spells for the specified mode. the spells are a list of
-- spell ids which must match the list of spell ids provided by this.Spells
-- the spell list can be specified as an array or as a space separated list
--------------------------------------------------------------------------------
  local eng = self.Engine
  local spec = eng.SpecName
  if not eng.CurPrio[mode] then
    ShowError(L'Invalid mode: %s', mode)
    return
  end

  if value == nil or value == '' or value == {} then
  -- restores the default values for the current mode and deletes the
  -- corresponding values from the exported vars
    eng:Reset(mode)
    if self.vars.Prio and self.vars.Prio[spec] then
      self.vars.Prio[spec][mode] = nil
    end
    return
  end


  --creates a hash for each spell key
  if not eng.SPN then
    local n = {}
    for _, k in ipairs(eng.Spells) do
      n[strlower(k)] = k
    end
    eng.SPN = n
  end

  -- if the new prio is a space separated list, converts to proper list
  if type(value) == 'string' then value = {strsplit(' ', value)} end

  -- if no list was suplied, uses a reference list
  if type(value) ~= 'table' then
    ShowError(L'Invalid value')
    return
  end

  -- list contains all the recognized spells supplied
  local list = {}
  local names = eng.SPN
  local Errors = 0
  for i, s in ipairs(value) do
    local k = strlower(s)
    local n = names[k]
    if n then
      table.insert(list, k)
    else
      Errors = Erros + 1
      -- alerts that we are getting crap from the user
      ShowError(L'Bad spell: %s', s)
    end
  end --for

  -- if the list of spells contained errors, abort
  if Errors > 0 then return end

  if #list == 0 then
    -- if not enough spells were supplied, whines and bails out
    ShowError(L'No spell found')
    return
  end

  -- Saves the spell list
  eng.CurPrio[mode] = list
  local final = table.concat(list, ' ')

  -- ref contais the list of default spells for this mode
  local ref = strlower(table.concat(eng.RefPrio[mode], ' '))

  if final == ref then
   -- deletes the exported priority if the current list is the default
    if self.vars.Prio
    and self.vars.Prio[spec]
    and self.vars.Prio[spec][mode] then
      self.vars.Prio[spec][mode] = nil
    end
  else
    if not self.vars.Prio then self.vars.Prio = {} end
    if not self.vars.Prio[spec] then self.vars.Prio[spec] = {} end
    self.vars.Prio[spec][mode] = final
  end
end -- fn Main:SetPrio


--------------------------------------------------------------------------------
function Main:GetPrio(mode)
--------------------------------------------------------------------------------
  local prio = self.Engine.Prio[mode]
  if prio then return strlower(table.concat(prio, ' ')) else return '' end
end -- Main:GetPrio(mode)

--------------------------------------------------------------------------------
function Main:CreateEvent(...)
--------------------------------------------------------------------------------
  return Event_Create(...)
end -- Main:CreateEvent

--------------------------------------------------------------------------------
function Main:CreateSpell(...)
--------------------------------------------------------------------------------
  return Spell_Create(...)
end -- Main:CreateSpell

--------------------------------------------------------------------------------
function Main:CreateSpellById(...)
--------------------------------------------------------------------------------
  return Spell_CreateById(...)
end -- Main:CreateSpellById

--------------------------------------------------------------------------------
function Main:CreateInterrupt(...)
--------------------------------------------------------------------------------
  return InterruptSpell_Create(...)
end -- Main:CreateInterrupt


--------------------------------------------------------------------------------
function Main:CreateSpecInfo(...)
--------------------------------------------------------------------------------
  return SpecInfo_Create(...)
end


--------------------------------------------------------------------------------
function Main:InitSpecs(...)
--------------------------------------------------------------------------------
  local Specs = {}
  local SpList = {}
  local args = {...}

  local GetSpells = function(spec, s)
    -- return a list with the spell(s) referenced by
    -- the name in s
    local temp = {}
    s = ((type(s) ~= "table") and {s}) or s
    for i, v in ipairs(s) do
      tinsert(temp, spec.Spells[v])
    end
    return temp
  end

  for i, v in ipairs(args) do
    if #v > 1 then
      local spec = v[1]
      local vcmd = v[2]

      if not SpList[spec] then
      -- adds the spec if not there yet.
      -- creation order of the specs must match the
      -- spec number in the Wow interface
        local s = self:CreateSpecInfo(spec)
        SpList[spec] = s
        spec = s
        tinsert(Specs, s)
        DbgMsg("Creating spec %s (#%i)", v[i], #Specs)
      else
        spec = SpList[spec]
      end -- if

      if vcmd == "spell" then
        local sp = spec:AddSpell(v[3], v[4])
        sp.Condition = v[5] or false
        sp.NoTarget = v.NoTarget
        sp.NoRange = v.NoRange
        sp.Tooltip = v.Tooltip or v[4]
        sp.NoInstant = v.NoInstant
        sp.RangeSpell = v.RangeSpell
        sp.ActionSpell = v.ActionSpell
        sp.PetSpell = v.PetSpell
				sp.Secondary = v.Secondary
				sp.Primary = v.Primary

      elseif vcmd == "init" then
        spec.InitSpec = v[3]

      elseif vcmd == "interrupt" then
        -- interrupt spells must be previously registered with a "spell" command;
        -- here we have just their tags
        -- e.g. {SPEC_NAME, "interrupt", {"first-interrupt", "second-interrupt", ... }}
        -- or   {SPEC_NAME, "interrupt", "interrupt-spell-key"}
        local data = {}
        for i, s in ipairs(GetSpells(spec, v[3])) do
          tinsert(data, InterruptSpell_Create(s))
        end
        --local data = GetSpells(spec, v[3])
        spec:MonitorInterrupts(unpack(data))

      elseif vcmd == "prio" then
        local list = v[3]
        if type(list) == "string" then
          spec:AddSingleTargetSpell(list)
        else 
          spec:SetSingleTargetSpells(unpack(v[3]))
        end

      elseif vcmd == "aoe" then
        spec:SetAoeSpells(unpack(v[3]))

      elseif vcmd == "var" then
        local vn = v[3]
        local vv = v[4]
        -- saves some predefined vars
        if vn == "AoeMin" or vn == "GCDSpell" then
          spec[vn] = vv
        else
          spec:SetVar(v[3], v[4])
        end

      elseif vcmd == "toolbar" then
      -- ??
        spec.SpecToolbar = v[3]

      elseif vcmd == "skip" then
      -- skip

      elseif vcmd == "cols" then
        spec.XIconsRowSize = v[3]
        
      else

        local _, _, slot = string.find(vcmd, "^slot(%d)$")
        local cmd = false
        slot = slot or (vcmd == "icon" and 0)
        if slot then
        -- slot specification
        -- (we used slotX before, now it is just 'icon')
        -- e.g. {SPEC_NAME, "icon", "buff", {Buff1, Buff2, ...}, tooltip}
        -- or   {SPEC_NAME, "icon", "buff", Buff, tooltip}

          local data = ((type(v[4]) ~= "table") and {v[4]}) or v[4]
          if v[3] == "buff" then
            cmd = spec.MonitorBuffs

          elseif v[3] == "debuff" then
            cmd = spec.MonitorDebuffs

          elseif v[3] == "aura" then
            cmd = spec.MonitorAuras

          elseif v[3] == "spell" then
            -- spells must be previously registered with a SPELL command;
            -- here we have just their tags
            -- e.g. {SPEC_NAME, "slotx", "spell", {"first-spell", "second-spell"}, tooltip}
            -- or   {SPEC_NAME, "slotx", "spell", "spell-key", tooltip}
            data = GetSpells(spec, data)
            cmd = spec.MonitorSpells
          end

          if cmd then
            local r = cmd(spec, slot, unpack(data))
            r.Tooltip = v[5]
          else
            error("Invalid command for slot " .. vcmd .. ": " .. tostring(v[3]))
          end

        else
          error("Invalid command: " .. tostring(vcmd))

        end -- if slot
      end -- if vcmd
    end -- for v#
  end -- for

  return Specs
end





--------------------------------------------------------------------------------
function Main:cmd_help(...)
--------------------------------------------------------------------------------
  ShowMsg("/l2p reset")
  ShowMsg(L"     resets the addon")
  ShowMsg("/l2p names")
  ShowMsg(L"     lists the actual names of each spell")
  ShowMsg("/l2p list")
  ShowMsg(L"     list the spells in priority order")
  ShowMsg("/l2p loadkeys")
  ShowMsg(L"     tries to load the keys corresponding to each spell")
  ShowMsg("/l2p msg")
  ShowMsg(L"     associates a message with each spell")
  ShowMsg("/l2p debug [on|off]")
  ShowMsg(L"     enables/disables debug mode")
  ShowMsg("/l2p debug_spells")
  ShowMsg(L"     lists all spells and their stati")
end


--------------------------------------------------------------------------------
function Main:cmd_reset(Args)
--------------------------------------------------------------------------------
  if not Args or Args == '' then
    DbgMsg(L'Frame position was reset')
    self.MainFrame:ClearAllPoints()
    self.MainFrame:SetPoint("CENTER", 0, -200)

  elseif strlower(Args) == 'prio' then
    ShowMsg(L'The priority lists were reset')
    self.Engine:Reset()
  end
end -- fn Main:cmd_reset

--------------------------------------------------------------------------------
function Main:cmd_names()
--------------------------------------------------------------------------------
  if self.Active then
    for k, v in pairs(self.Engine.Spells) do
      ShowMsg("%s: %s", k, v.SpName)
    end
  else
    ShowMsg(L"L2P is not active")
  end -- if
end -- Main:cmd_names

--------------------------------------------------------------------------------
function Main:cmd_list()
--------------------------------------------------------------------------------
  if self.Active then
    local Prio = self.Engine.CurPrio
    for _, k in ipairs({MODE_ST, MODE_AOE, MODE_CUSTOM}) do
      local list = table.concat(Prio[k], ' ')
      ShowMsg("%s: %s", k, list)
    end
  else
    ShowMsg(L"L2P is not active")
  end
end -- Main:cmd_list

--------------------------------------------------------------------------------
function Main:cmd_loadkeys(value)
--------------------------------------------------------------------------------
-- finds the keys for the spells in the rotations and assign then as msgs
-- for the spells
--------------------------------------------------------------------------------
  self:LoadKeys(true)
end

--------------------------------------------------------------------------------
function Main:cmd_msg(Value)
--------------------------------------------------------------------------------
  Value = string.trim(Value)
  local list
  if strlower(Value) == 'clear' then
    self:SetMessages()
    ShowMsg(L'Messages removed')

  elseif Value and Value ~= '' then
    local match, msg, p
    p = 1
    list = {}
    repeat
      key, msg, p = string.match(Value, "([%w-_]+)%s*:%s*([^%s]+)()", p)
      if key then
        local spkey = self.Engine:FindSpellName(strlower(key))
        if spkey  then
          if msg == "''" or msg == '""' then msg = '' end
          list[spkey] = msg
        else
          ShowMsg(L"Spell no found: %s", key)
        end
      end
    until not key
    self:SetMessages(list)
  end

  list = self:GetMessages()
  local text = {}
  for k, s in pairs(list) do
    table.insert(text, format("%s:%s", k, s))
  end
  if #text then
    ShowMsg(table.concat(text, ' '))
  end
end -- Main:cmd_msg


--------------------------------------------------------------------------------
function Main:cmd_debug(value)
--------------------------------------------------------------------------------
	value = (not value and ((Main.Debug and "off") or "on")) or (value == "on" and "on") or "off"
	if value == "on" then Main.Dbg.On() else value = "off"; Main.Dbg.Off() end
	ShowMsg("Debug is %s", value)
end


--------------------------------------------------------------------------------
function Main:cmd_debug_spells()
--------------------------------------------------------------------------------
	Main.Dbg:ShowSpells()
end


--------------------------------------------------------------------------------
function Main:LoadKeys(show)
--------------------------------------------------------------------------------
  local klist = self:MapSpellKeys()
  for k, s in pairs(self.Engine.Spells) do
    -- sets the message for the spell based on the spell name
    -- or the action spell name (in cases such as in Pyroblast, where the actual spell cast
    -- when the effect procs is different from the spell in the action bar)
    s.Message = klist[s.SpName] or (s.ActionSpell and klist[s.ActionSpell])
    if show then ShowMsg("%s : %s", k, s.Message or "") end
  end
end


--------------------------------------------------------------------------------
function Main:MapSpellKeys()
--------------------------------------------------------------------------------
-- returns the keymapping for the action bar spells as a map[spellname = Key]
--------------------------------------------------------------------------------
	local NUM_ACTIONBAR_SLOTS = 12
	local MACRO_SPELL_INDEX = 3

	local slist = {}
  local ActionBars = {
    ['Action'] = 'ACTIONBUTTON',
    ['MultiBarBottomLeft'] = 'MULTIACTIONBAR1BUTTON',
    ['MultiBarBottomRight'] = 'MULTIACTIONBAR2BUTTON',
    ['MultiBarRight'] = 'MULTIACTIONBAR3BUTTON',
    ['MultiBarLeft'] = 'MULTIACTIONBAR4BUTTON'
  }
  for barName, actionName in pairs(ActionBars) do
    for i = 1, NUM_ACTIONBAR_SLOTS do
      local key, k2 = GetBindingKey(actionName .. i)
      if not key then key = k2 end
      if key then
        local button = _G[barName .. 'Button' .. i]
        local slot = ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or button:GetAttribute('action') or 0
        if HasAction(slot) then
          local actionType, id = GetActionInfo(slot)
          if actionType == 'macro' then
            id = select(MACRO_SPELL_INDEX, GetMacroSpell(id))
						if id then id = tonumber(id) end
          end
          if id then
            id = GetSpellInfo(id)
            if id then
							slist[id] = key
						end
          end
        end
      end -- if key
    end -- for i
  end -- for barName...

  return slist
end


--------------------------------------------------------------------------------
function Main:AddXIcon()
--------------------------------------------------------------------------------
-- allocates space for an extra icon and 'enables' it;
--------------------------------------------------------------------------------
    local i = self.XIconsInUse + 1
    local icon = self.XIcons[i]
    if icon == nil then return nil end
    
    table.insert(self.Icons, icon)
    self.XIconsInUse = i

    i = i - 1 -- index is 1 based, and we need 0 based
    local row = floor(i / self.XIconsRowSize)
    local col = i % self.XIconsRowSize
    icon:XYAt(self.XIconsX + self.XIconSize * col, self.XIconsY - row * self.XIconSize)
    icon:Show()
    return icon
end

--------------------------------------------------------------------------------
function Main:ReloadIcons()
--------------------------------------------------------------------------------
-- recreates the list of icons
--------------------------------------------------------------------------------
  self.Icons = {}
  for i, icon in ipairs(self.MainIcons) do
    table.insert(self.Icons, icon)
  end
  
  for i = 1, self.XIconsInUse do
    table.insert(self.Icons, self.XIcons[i])
  end
  
  for i = self.XIconsInUse + 1, #self.XIcons do
    self.XIcons[i]:Hide();
  end
end

--------------------------------------------------------------------------------
function Main:InitXIcons(cols)
--------------------------------------------------------------------------------
  self.XIconsInUse = 0
  self.XIconsRowSize = cols or DEFAULT_XICON_ROW_SIZE
  self.XIconSize = 22
  self.XIconsY = -61
  self.XIconsX = floor((self.MainFrame:GetWidth() - self.XIconsRowSize * self.XIconSize)/2)
end


--------------------------------------------------------------------------------
function  Main:CreateIcons()
--------------------------------------------------------------------------------

  local function ShowTooltip(Icon)
    if Icon.Tooltip then
      GameTooltip:SetOwner(Icon, "ANCHOR_TOPLEFT")
      GameTooltip:SetText(string.format(Icon.Tooltip, Icon.TooltipData))
      GameTooltip:Show()
    end
  end

  local function HideTooltip(Icon)
    GameTooltip:Hide()
  end

  local function Attach(Icon, Event, Handler)
    if Icon:GetScript(Event) then
      Icon:HookScript(Event, Handler)
    else
      Icon:SetScript(Event, Handler)
    end
  end

  local function AttachTooltip(Icon)
    Attach(Icon, "OnEnter", ShowTooltip)
    Attach(Icon, "OnLeave", HideTooltip)
  end


  local fr = self.MainFrame
  self.MainIcons = {}
  self.XIcons = {}
  self.Icons = {}
  self:InitXIcons()
  
  -- Info Icons (the general purpose icons)
  -- they make up to 3 rows of icons at the bottom of the
  -- main frome with up to 5 icons by row

  for i = 1, 15 do 
    local ic = Icon_Create(fr, 20, 20, true)
    ic:SetBorder(3)
    ic.Name = "Sp" .. i
    AttachTooltip(ic)
    ic:Hide()
    table.insert(self.XIcons, ic) 
    self[ic.Name] = ic
  end
  --fr:SetBorder(1)


  -- The specific icons that exist in every setup
 
  -- the icon for the enemies being attacked
  ic = MobsIcon_Create(fr, 40, 40)
  ic:XYAt(-16, -20)
  ic:SetBorder(4)
  ic.Name = "MobsIcon"
  ic.Tooltip = L"Enemies you hit"
  AttachTooltip(ic)
  self.MobsIcon = ic

  -- the icon for the player's HP
  ic = HPIcon_Create(fr, 60, 60)
  ic:XYAt(20, 0)
  ic:SetBorder(4)
  ic.Name = "HPIcon"
  self.HPIcon = ic

   -- the icon for the suggested spell

  ic = CurrentSpellIcon_Create(self.HPIcon, 45, 45)
  ic:CenterAt(0, 0)
  ic:SetBorder(4)
  ic.Name = "CurSpellIcon"
  ic.Tooltip = L"Current best spell: %s"
  ic.TooltipData = L"None"
  AttachTooltip(ic)
  self.CurSpellIcon = ic

   -- the text to a custom message when a given spell is selected
  ic = MsgIcon_Create(self.CurSpellIcon, 45, 45)
  ic:CenterAt(0, -20)
  ic.Source = self.CurSpellIcon
  self.CurMsgIcon = ic

   -- the icon for second best suggested spell
  ic = NextSpellIcon_Create(fr, 40, 40)
  ic:XYAt(76, -20)
  ic:SetBorder(4)
  ic.Name = "NextSpellIcon"
  ic.Tooltip = L"Next best spell: %s"
  ic.TooltipData = L"None"
  AttachTooltip(ic)
  self.NextSpellIcon = ic


  ic = MsgIcon_Create(self.NextSpellIcon, 40, 40, 16)
  ic:CenterAt(0, -20)
  ic.Source = self.NextSpellIcon
  self.NextMsgIcon = ic

  -- the icon for the interrupt spell
  ic = SpellMonitorIcon_Create(fr, 25, 25, true)
  ic:XYAt(76, 0)
  ic:SetBorder(4)
  ic.Name = "InterruptIcon"
  ic.Tooltip = L"Interrupts"
  AttachTooltip(ic)
  self.InterruptIcon = ic

  -- the move handler
  ic = Icon_Create(fr, 8, 8)
  ic:XYAt(6, -6)
  ic:SetImage(.2, .4, .6)
  ic:SetBorder(1)
  ic.Tooltip = L"Click to move"
  ic:SetScript("OnMouseDown", function() fr:StartMoving() end)
  ic:SetScript("OnMouseUp", function() fr:StopMovingOrSizing() end)
  ic:SetScript("OnEnter", function() ic:SetImage(.4, .6, .8) end)
  ic:SetScript("OnLeave", function() ic:SetImage(.2, .4, .6) end)
  AttachTooltip(ic)
  ic:EnableMouse(true)
  self.MoveHandler = ic

  self.MainIcons = {
    self.MobsIcon,
    self.InterruptIcon,
    self.HPIcon,
    self.CurSpellIcon,
    self.NextSpellIcon,
    self.CurMsgIcon,
    self.NextMsgIcon
  }
  
  self:ReloadIcons()
  
end -- Main_CreateIcons


--------------------------------------------------------------------------------
function Main.joinTables(...)
--------------------------------------------------------------------------------
-- returns all the tables passed as parameters as a single parameter list
--------------------------------------------------------------------------------
  local args = {...}
  local result = {}
  for i, v in ipairs(args) do
    for j, w in ipairs(v) do
      table.insert(result, w)
    end 
  end
  return unpack(result)
end

--------------------------------------------------------------------------------
function Main:CreateSpellNames(ids)
--------------------------------------------------------------------------------
-- generates a table with the spell names from the spells, which ids are 
-- passed in spid; spid has the format:
-- { SpellName1 = SpellId1, SpellName2 = SpellId2, ...}
-- and CreateSpellNames will return a table like
-- { SpellName1 = GetSpellInfo(SpellId1), SpellName2 = GetSpellInfo(SpellId2),...}
--------------------------------------------------------------------------------
	local result = {}
	for k, n in pairs(ids) do
		local s = GetSpellInfo(n) or false
		if s then 
			result[k] = s
		elseif n ~= 0 then  
			print("Bad Spell:", k, "->", n) 
		end
	end
	return result
end


--------------------------------------------------------------------------------
function Main:SetEngineData(data)
--------------------------------------------------------------------------------
  self.priorityData = data
end


--------------------------------------------------------------------------------
local function DispatchCmd(this, Text)
--------------------------------------------------------------------------------
  local Text = string.trim(SecureCmdOptionParse(Text))
  if not Text or Text == '' then
    this:cmd_help()
  else
    local Cmd, Args = string.match(Text, "(%S+)(.*)")
    Args = string.trim(Args)
    Cmd = 'cmd_' .. strlower(Cmd)
    if this[Cmd] then
      if this.Active then
        this[Cmd](this, Args)
      else
        ShowMsg(L"L2P is not active")
      end
    else
      print(L"Invalid command")
    end
  end
end -- fn DispatchCmd


--------------------------------------------------------------------------------
local function InitEngineData(this)
--------------------------------------------------------------------------------
-- attaches the user engine
--------------------------------------------------------------------------------
  this.EngineData = (this.GetEngine and this:GetEngine(MODE_ST, MODE_AOE)) or false
end

--------------------------------------------------------------------------------
local function HandleAddOnLoaded(this, evt, addon)
--------------------------------------------------------------------------------

  if addon ~= addon_name then return end

  DbgMsg("HandleAddOnLoaded")
  
	this:InitEngineData()
  if not this.EngineData then DbgMsg("No engine data") end

  if this.EngineData then
    -- the spell frame
    
    DbgMsg("Activating the engine")
    
    local sf =  SpellFrame_Create(0, 0, 100, 80)
    sf:Hide()
    sf.OnUpdate:Add(this.HandleOnUpdate, this)

    this.MainFrame = sf
    this:cmd_reset()
    this:CreateIcons()
    this.Elapsed = 0
    this:EnableEvents()
  else
    DbgMsg("Deactivating the engine")
    this:DisableEvents()
  end
end --  fn HandleAddOnLoaded


--------------------------------------------------------------------------------
local function Initialize(this)
--------------------------------------------------------------------------------

  _G["L2P"] = this

  -- the event frame
  local fr = EventFrame_Create()
  fr:RegisterFor('ADDON_LOADED', HandleAddOnLoaded, this)

  this.EventFrame = fr
	this.InitEngineData = InitEngineData
  this.AddonName = addon_name
	this.DispatchCmd = DispatchCmd
	this.Dbg = Debug_Create()


  -- create slash comds
  SLASH_L2P1 = '/l2p'
  SlashCmdList.L2P = function(msg, editbox)
    DispatchCmd(this, msg, editbox)
  end

end -- fn Initialize

Main.ShowMsg = ShowMsg

Cmds.CreateIcon = Icon_Create
Initialize(Main)

