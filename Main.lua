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

local DEFAULT_ALPHA = 1
local DEFAULT_LOCKED = false
local DEFAULT_CHECKRANGE = true
local DEFAULT_FREQUENCY = 15

local SPELL_CAST_TIME = 4

local GCD_SPELL_ID = 61304
local DEFAULT_XICON_ROW_SIZE = 5



local SPN = {
  Bloodlust       = GetSpellInfo(2825),
  Bloodlust       = GetSpellInfo(2825),
  Heroism         = GetSpellInfo(32182),
  TimeWarp        = GetSpellInfo(80353),
  AncientHysteria = GetSpellInfo(90355),
}

-- forward commands (lua won't call a function declared later???)
local Cmds = {}

--------------------------------------------------------------------------------
local function PrintTable(name, v)
--------------------------------------------------------------------------------
  print(name, ":")
  print(table.concat(v, " "))
  for k, v in pairs(v) do
    print(k, ": ", v)
  end
  print("")
end

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
  return list
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
  if this.SpellId and not IsPlayerSpell(this.SpellId) then return false end
  
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
  sp.Key = Key          
  sp.SpName = SpName    
  sp.Caption = Caption  
  sp.Condition = Condition
  sp.When = 0
  sp.Start = 0
  sp.Duration = 0
  sp.InRange = false
  sp.Valid = false
  sp.Enabled = false
  sp.NoMana = true

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
local function Spell_CreateById(Id)
-------------------------------------------------------------------------------
-- creates a spell based only in id and name
-------------------------------------------------------------------------------
  local sp = Spell_Create("", GetSpellInfo(Id))
  sp.SpellId = Id
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
  local fr = CreateFrame("Frame", nil,  Parent, "BackdropTemplate")
  fr:SetSize(w, h)

  -- the image
  local t = fr:CreateTexture(nil, "BACKGROUND")

  t:SetAllPoints(fr)
  t:SetTexture(DEFAULT_BG_TEX)
  fr.ImageTex = t

  -- the cooldown frame
  if HasCooldown then
    local cd = CreateFrame("Cooldown", nil, fr, "CooldownFrameTemplate")
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
local function Engine_CalcGCD(this)
------------------------------------------------------------------------------
  this:UpdateGCD(this)
end

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
local function Engine_GetSpellInfo(this, spell)
------------------------------------------------------------------------------
--[[ returns information about a give spell: 
  - ready: true if the spell can be used, 
  - charges: the number of charges (0 if the spell doesn't have charges)
  - cooldown: how long it will take for the cooldown to finish
  - NextCharge: how long it will take for the next charge to load
]]
------------------------------------------------------------------------------
  local ret = {ready = false, charges = 0, cooldown = 0, NextCharge = 0} 
  local c, m, s, d = GetSpellCharges(spell)
  if c then ret.charges = c end
  if s then ret.NextCharge = s + d - this.Now end
  local e
  s, d, e = GetSpellCooldown(spell)
  ret.ready = d == 0 or e == 0
  if s then ret.cooldown = s + d - this.Now end
  return ret
end

------------------------------------------------------------------------------
local function Engine_GetDebuffInfo(this, spell, target)
------------------------------------------------------------------------------
--[[ returns information about a debuff in the specified target
  - active: the debuff is present
  - charges: how many charges 
  - remaining: how much time remains until the debuff expires
]]
------------------------------------------------------------------------------
  local charges, remaining, duration, name, id = this:CheckBuffOrDebuffAuto(spell, true, target)
  
  return {
    active = charges > 0,
    charges = charges,
    remaining = remaining,
    duration = duration,
    name = name
  }
end

------------------------------------------------------------------------------
local function Engine_GetMyDebuffInfo(this, spell)
------------------------------------------------------------------------------
-- returns information about a debuff on the player
------------------------------------------------------------------------------
  return this:GetDebuff(spell, "PLAYER")
end

------------------------------------------------------------------------------
local function Engine_GetTtargetBuffInfo(this, spell)
------------------------------------------------------------------------------
-- returns information about a buff on the target
------------------------------------------------------------------------------
  return this:GetBuff(spell, "TARGET")
end

------------------------------------------------------------------------------
local function Engine_GetBuffInfo(this, spell, target)
------------------------------------------------------------------------------
--[[ returns information about a debuff in the specified target
  - active: the debuff is present
  - charges: how many charges 
  - remaining: how much time remains until the debuff expires
]]
------------------------------------------------------------------------------
  local charges, remaining, duration, name, id = this:CheckBuffOrDebuffAuto(spell, false, target)
  --count, expires, duration, name, id, xp
  return {
    active = charges > 0,
    charges = charges,
    remaining = remaining,
    duration = duration,
    name = name
  }
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
  if not this.Active
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
local function Engine_Update(this, elapsed)
------------------------------------------------------------------------------
  this:UpdateState(elapsed)
  this:UpdateSpells()
  this:SelectSpells()

end -- fn Engine_HandleUpdate

------------------------------------------------------------------------------
local function Engine_OnEnterCombat(this)
------------------------------------------------------------------------------
  this.InCombat = true
  this:ShowHideFrame()
end -- fn Engine_OnEnterCombat


------------------------------------------------------------------------------
local function Engine_OnLeaveCombat(this)
------------------------------------------------------------------------------
  this.InCombat = false
  this:ShowHideFrame()
end -- fn Engine_OnLeaveCombat


------------------------------------------------------------------------------
local function Engine_OnTargetChanged(this)
------------------------------------------------------------------------------
  this:ShowHideFrame()
end -- fn Engine_OnTargetChanged


------------------------------------------------------------------------------
local function Engine_OnCombatLog(this)
------------------------------------------------------------------------------
  if not this.Active then return end

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
			this:DbgTrack("LastCastSpell", tostring(this.LastCastSpell) .. " - " .. GetSpellInfo(this.LastCastSpell))
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
		this.ElapsedDamage = (this.ElapsedDamage or 0) + (value or 0)
	end

end -- fn Engine_OnCombatLog


------------------------------------------------------------------------------
local function Engine_IsInCombat(this)
------------------------------------------------------------------------------
-- returns true if player is in combat
------------------------------------------------------------------------------
  --if UnitInVehicle("player") then return false end
  return (
    UnitGUID("target")
    and not UnitIsFriend("player", "target")
    and UnitHealth("target") > 0
  ) or (
    UnitAffectingCombat("player") and true
  ) or this.InCombat
end -- fn Engine_IsInCombat



------------------------------------------------------------------------------
local function Engine_CalcLag(this)
------------------------------------------------------------------------------
-- records the network lag
------------------------------------------------------------------------------
  local lag = select(3, GetNetStats())
  this.Lag = lag / 1000 -- lag comes in msec, turn it into sec
end -- fn Engine_CalcLag


------------------------------------------------------------------------------
local function Engine_UpdateState(this, elapsed)
------------------------------------------------------------------------------
-- colects the information needed to select the spells
------------------------------------------------------------------------------
  this.Now = GetTime()
  this.Elapsed = elapsed

  local target = UnitGUID("target")
  if target then this.MobList:Add(target) end
  
  this.Mobs = this.MobList:Refresh()
  this.Targets = this.Mobs
	
  this.Attackers = this.AttackerList:Refresh()
  this.Enemies = this.Attackers
  
  for k, i in pairs(this.MobList.Items) do
    if not this.AttackerList.Items[k] then this.Enemies = this.Enemies + 1 end
  end

  this:CalcGCD()
  this:CalcLag()

  -- refreshes variables used by spec calculators
  local TLevel = UnitLevel("target") or 0
  
  this.IsBossFight = (TLevel < 0) or (TLevel > (UnitLevel("player") + 2)) or UnitIsPlayer("target")
	this.IsPvp = UnitIsPlayer("target") 
  
  this.WeAreBeingAttacked = this.Attackers > 0

  --calcs health and pain
  this.PrevHealth = this.Health
  
  local Health = UnitHealth("player")
  local HealthMax = UnitHealthMax("player")
  
  this.Health = Health
  this.HealthMax = HealthMax
  this.HealthPercent = Health/HealthMax

  if not this.PrevHealth then this.PrevHealth = Health end
  this.HealthChangingRate = (Health / this.PrevHealth) - 1
	
  this.HasBloodLust = (this:CheckBuff({SPN.Bloodlust, SPN.Heroism, SPN.TimeWarp, SPN.AncientHysteria}) > 0)
  this.IsMoving = GetUnitSpeed("player") > 0
  this.TargetIsMoving = GetUnitSpeed("target") > 0
  
  this.TargetHealthMax = UnitHealthMax("target") or 0
  this.TargetHealth = UnitHealth("target") or 0
  this.TargetHealthPercent = (this.TargetHealthMax > 0 and this.TargetHealth/this.TargetHealthMax) or 0; 
  
  this.Power = {}
  
  for k, v in pairs(Enum.PowerType) do
    if v >= 0 and k ~= "NumPowerTypes" then 
      this.Power[k] = UnitPower("player", v) or 0
    end
  end
  
  this.ElapsedDamage = 0
  
  this:RefreshVars()
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
    return (a.When < b.When) or (a.SpellId < b.SpellId)
  else
    return a.prio > b.prio
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
  if this.CurSpell.Key ~= BestSpell.Key or this.NextSpell.Key ~= SecondBestSpell.Key then
    this:DbgTrack("spells:", (BestSpell.Key or 'none') .. " - " .. (SecondBestSpell.Key or 'none'))
  end
  
  this.CurSpell = BestSpell
  this.NextSpell = SecondBestSpell

  return
  
end -- Engine_SwitchToNewSpells

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
  local Prio = this.Prio
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
local function Engine_MapSpellsToBook(this)
-------------------------------------------------------------------------------
-- adds a spellbook index to the spells, which is needed for some methods
-- (specifically, IsSpellInRange is working unreliably with the spell name,
-- but it works ok if the spellbook index is used
-------------------------------------------------------------------------------
  local INDEX_SPELL_ID = 7
  local sp = {}
  local k, s, i

  local function getSpellSlot(id)
    local name = GetSpellInfo(id)
    local ok, index = pcall(FindSpellBookSlotBySpellID, id)
    if not ok then ShowError("Error locating spell book index for %s (%d)", tostring(name), id) end
    return index
  end
  
  -- gets the id of each spell (and of the RangeSpell, if present)
  for k, s in pairs(this.Spells) do
    local id = s.SpellId
    s.SpellBookIndex = getSpellSlot(id)
    
    if s.RangeSpell then
      id = s.RangeSpell
      s.RangeSpellId = id
      s.RangeSpellBookIndex = getSpellSlot(id)
    end
  end

  -- saves RangeSpellBookIndex and NoRange if the spell uses no range
  for k, s in pairs(this.Spells) do
    if not s.NoRange and not s.NoTarget then
      if s.RangeSpellId then
        --s.RangeSpellBookIndex = getId(s.RangeSpellId)
        s.SpellBookIndexForRange = s.RangeSpellBookIndex
      elseif s.SpellBookIndex then
        s.NoRange = not SpellHasRange(s.SpellBookIndex, BOOKTYPE_SPELL)
        if not s.NoRange then s.SpellBookIndexForRange = s.SpellBookIndex end
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
		Getter = function(i) return UnitBuff(target, i) end
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
local function Engine_Load(this, data)
-------------------------------------------------------------------------------
  this.SPI = data.SPI or {}
  this.Spells = {}
  this.Prio = {}
  if data.prios then
    for n, p in ipairs(data.prios) do
      local spell = Spell_CreateById(p.SpellId)
      for k, v in pairs(p) do
        spell[k] = v
      end
      this.Spells[spell.Key] = spell
      local key = spell.Key
      if spell.Role ~= 'interrupt' and spell.Role ~= 'slot' then
        table.insert(this.Prio, key)
      end
    end
  end
  
  this.code = data.code or {}
  this.slots = data.slots or {}
  
  this:MapSpellsToBook()
  
  DbgMsg("Loaded %d spells for spec %s", #data.prios, this.vars.Spec)
end

-------------------------------------------------------------------------------
local function Engine_Init(this)
-------------------------------------------------------------------------------
  this.PlayerClass = select(2, UnitClass("player"))
  this.Spec = GetSpecialization()
  this.vars = this.vars or {}
  this.vars.Spec = this.PlayerClass .. "-" .. this.Spec -- e.g. PALADIN-3
end


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
local function Engine_RefreshVars(this)
-------------------------------------------------------------------------------
-- loads value sinto Engine.vars (which will be used by the current spec-handler)
-------------------------------------------------------------------------------
  local vars = this.vars or {}
  this.vars = vars
  
  for k, v in pairs(this.Power) do
    vars[k] = v
  end
  
  vars.Health = this.Health
  vars.HealthMax = this.HealthMax
  vars.HealthPercent = this.HealthPercent
  vars.TargetHealth = this.TargetHealth
  vars.TargetHealthMax = this.TargetHealthMax
  vars.TargetHealthPercent = this.TargetHealthPercent
  vars.Attackers = this.Attackers
  vars.Targets = this.Targets
  vars.Now = this.Now
  vars.IsBossFight = this.IsBossFight
  vars.IsPvp = this.IsPvp
  vars.GCD = this.GCD
  vars.HealthRate = this.HealthChangingRate
  vars.HealthChangingRate = this.HealthChangingRate
  vars.LastCastSpell = this.LastCastSpell
  vars.IsMoving = this.IsMoving
  vars.TargetIsMoving = this.TargetIsMoving
  
  for k, f in pairs(this.code) do
    vars[k] = f(this)
  end
end


-------------------------------------------------------------------------------
local function Engine_Create(Frame)
-------------------------------------------------------------------------------
  local eng = {}

  local EmptySpell = Spell_Create()

  eng.Spec = ''                     -- player spec we are handling
  eng.Spells = {}                   -- list of valid spells indexed by keys
  eng.Frame = Frame                 -- the spell frame
  eng.WeAreBeingAttacked = false
	eng.PainPerSecond = 0             
	eng.PainReact = 0               -- percentual estimate for the damage we are receiving
  eng.ElapsedDamage = 0             -- the raw damage received between updates
  eng.IncreasingPain = false
	eng.HealthPercent = 1							 

  eng.Mobs = 0                      -- current number of mobs being hit by the player
	eng.Attackers = 0                 -- current number of enemies attacking us
  eng.Enemies = 0 
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
  eng.PlayerGUID = UnitGUID("player")

  -- Engine API
  eng.Init = Engine_Init
  eng.Load = Engine_Load
  eng.OnEnterCombat = Engine_OnEnterCombat
  eng.OnLeaveCombat = Engine_OnLeaveCombat
  eng.OnCombatLog = Engine_OnCombatLog
  eng.OnTargetChanged = Engine_OnTargetChanged
  eng.Update = Engine_Update
  eng.ShowHideFrame = Engine_ShowHideFrame
  eng.IsInCombat = Engine_IsInCombat
  eng.CalcGCD = Engine_UpdateGCD
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
	eng.UpdateGCD = Engine_UpdateGCD

  eng.CheckBuff = Engine_CheckBuff
  eng.CheckDebuff = Engine_CheckDebuff
	eng.CheckBuffOrDebuffAuto = Engine_CheckBuffDebuffAuto

  eng.CheckEnemyDistance = Engine_CheckEnemyDistance
  eng.CheckEnemyIsClose = Engine_CheckEnemyIsClose
  eng.CheckEnemyIsNotFar = Engine_CheckEnemyIsNotFar
  eng.CheckEnemyIsFar = Engine_CheckEnemyIsFar  
  
	eng.HasTalent = Engine_HasTalent
  
  eng.Dump = Engine_Dump
	eng.DbgTrack = Engine_DbgTrack
  
  eng.RefreshVars = Engine_RefreshVars
  
  eng.GetSpellInfo = Engine_GetSpellInfo
  eng.GetBuffInfo = Engine_GetBuffInfo
  eng.GetDebuffInfo = Engine_GetDebuffInfo
  eng.GetTargetBuffInfo = Engine_GetTargetBuffInfo
  eng.GetMyBuffInfo = Engine_GetMyBuffInfo
  
  eng.GetBuff = eng.GetBuffInfo
  eng.GetSpell = eng.GetSpellInfo
  eng.GetDebuff = eng.GetDebuffInfo
  eng.GetTargetBuff = eng.GetTargetBuffInfo
  eng.GetMyDebuff = eng.GetMyBuffInfo

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
  this.Prio = {...}
  return this
end

--------------------------------------------------------------------------------
local function SpecInfo_AddSingleTargetSpell(this, spell)
--------------------------------------------------------------------------------
-- adds a single spell at the end of the priority list
--------------------------------------------------------------------------------
  if not this.Prio then this.Prio = {} end
  table.insert(this.Prio, spell)
  return this
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
function Main:ResetEngine()
--------------------------------------------------------------------------------
  self.Engine:Init()
  self.Engine:Load(self:GetSpecData(self.Engine))
  self:CreateSlots(self.Engine.slots)
  self.Engine.Active = #self.Engine.Prio > 0
  self.Active = self.Engine.Active
end


--------------------------------------------------------------------------------
function Main:CreateSlots()
--------------------------------------------------------------------------------
    self:InitXIcons(#self.Engine.slots)
    self:ReloadIcons()
    
    for i, slot in ipairs(self.Engine.slots) do
      local icon = self:AddXIcon()
      if slot.Type == "buff" then 
        Cmds.CreateBuffIcon(icon)
        icon.Buffs = {slot.Spell}
        
      elseif slot.Type == "debuff" then
        Cmds.CreateDebuffIcon(icon)
        icon.Debuffs = {slot.Spell}
        
      elseif slot.Type == "aura" then
        Cmds.CreateAuraIcon(icon)
        icon.Auras = {slot.Spell}
        
      elseif slot.Type == "spell" then
        local splist ={}
        for k, v in pairs(self.Engine.Spells) do
          if v.Role == "slot" and v.SpellId == slot.Spell then
            splist = {v}
            break
          end
        end  
        Cmds.CreateSpellMonitor(icon)
        icon.Spells = splist
      end
    end

    local interrupts = {}
    for k, v in pairs(self.Engine.Spells) do
      if v.Role == "interrupt" then table.insert(interrupts, Cmds.CreateInterruptSpell(v)) end
    end
    self.InterruptIcon.Spells = interrupts
end


--------------------------------------------------------------------------------
function Main:EnableEvents()
--------------------------------------------------------------------------------
  local fr = self.EventFrame
  fr:RegisterFor('PLAYER_LOGIN', self.HandlePlayerLogin, self)
  fr:RegisterFor('PLAYER_ENTER_COMBAT', self.HandleEnterCombat, self)
  fr:RegisterFor('PLAYER_LEAVE_COMBAT', self.HandleLeaveCombat, self)
  fr:RegisterFor('PLAYER_TARGET_CHANGED', self.HandleTargetChanged, self)
  fr:RegisterFor('COMBAT_LOG_EVENT_UNFILTERED', self.HandleCombatLog, self)
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
function Main:HandleEnterCombat(evt, ...)
--------------------------------------------------------------------------------
  self.Engine:OnEnterCombat(evt, ...)
end -- fn Main:HandleEnterCombat

--------------------------------------------------------------------------------
function Main:HandleLeaveCombat(evt, ...)
--------------------------------------------------------------------------------
  self.Engine:OnLeaveCombat(evt, ...)
end -- fn Main:HandleLeaveCombat

--------------------------------------------------------------------------------
function Main:HandleTargetChanged(evt, ...)
--------------------------------------------------------------------------------
  self.Engine:OnTargetChanged(evt, ...)
end -- fn Main:HandleTargetChanged

--------------------------------------------------------------------------------
function Main:HandleCombatLog(evt, ...)
--------------------------------------------------------------------------------
  self.Engine:OnCombatLog(evt, ...)
end -- fn Main:HandleCombatLog

--------------------------------------------------------------------------------
function Main:HandleShapeshiftUpdate(evt, ...)
--------------------------------------------------------------------------------
  self.LoadKeysNeeded = true
end -- fn Main:HandlePlayerLogin

--------------------------------------------------------------------------------
function Main:HandlePlayerLogin(evt, ...)
-------------------------------------------------------------------------------
  DbgMsg("Player Login")
  self.SpecChanged = true
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
-- called by the MainFrame when it is visible
--------------------------------------------------------------------------------
  self.Elapsed = (self.Elapsed or 0) + (elapsed or 0)
  -- exits if throtling
  if self.Throtle and self.Elapsed < self.Throtle then return end

  if self.SpecChanged or self.TalentsChanged then
    self.SpecChanged = false
    self.TalentsChanged = false
    self.LoadKeysNeeded = true
		self:ResetEngine() -- reset engine may change our active status
	end

  if self.Active then
    if self.LoadKeysNeeded then
      self.LoadKeysNeeded = false
      self:LoadKeys()
    end

    self.Engine:Update(elapsed)
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
    self:ResetEngine()
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
    local list = table.concat(Prio, ' ')
    ShowMsg("prio: %s", k, list)
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
        local slot = button.action or button:GetAttribute('action') or 0
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
function Main:DispatchCmd(Text)
--------------------------------------------------------------------------------
  local Text = string.trim(SecureCmdOptionParse(Text))
  if not Text or Text == '' then
    self:cmd_help()
  else
    local Cmd, Args = string.match(Text, "(%S+)(.*)")
    Args = string.trim(Args)
    Cmd = 'cmd_' .. strlower(Cmd)
    if self[Cmd] then
      if self.Active then
        self[Cmd](self, Args)
      else
        ShowMsg(L"L2P is not active")
      end
    else
      print(L"Invalid command")
    end
  end
end -- fn DispatchCmd


--------------------------------------------------------------------------------
function Main:HandleAddOnLoaded(evt, addon)
--------------------------------------------------------------------------------
  if addon ~= addon_name then return end

  DbgMsg("HandleAddOnLoaded")

  local sf =  SpellFrame_Create(0, 0, 100, 80)
  sf:SetFrameStrata("DIALOG")
  sf:Hide()
  
  self.Elapsed = 0
  self.Throtle = 1 / DEFAULT_FREQUENCY
  self.MainFrame = sf
  self.Active = false;
  
  sf.OnUpdate:Add(self.HandleOnUpdate, self)

  self:cmd_reset()
  self:CreateIcons()

  DbgMsg("Activating the engine")
  self.Engine = Engine_Create(sf)
  self:EnableEvents()
  if self.GetSpecData then self:ResetEngine() end
  
end --  fn HandleAddOnLoaded


--------------------------------------------------------------------------------
function Main:Initialize()
--------------------------------------------------------------------------------
  self.Debug = true
  DbgMsg("Initialize")
  
  _G["L2P"] = self
 
  -- the event frame
  local fr = EventFrame_Create()
  fr:RegisterFor('ADDON_LOADED', Main.HandleAddOnLoaded, self)

  self.EventFrame = fr
  self.AddonName = addon_name
	self.Dbg = Debug_Create()


  -- create slash comds
  SLASH_L2P1 = '/l2p'
  SlashCmdList.L2P = function(msg, editbox)
    self:DispatchCmd(msg, editbox)
  end

end -- fn Initialize

Cmds.CreateIcon = Icon_Create -- needed to forward the Icon_Create call
Cmds.CreateBuffIcon = BuffIcon_FromIcon
Cmds.CreateDebuffIcon = DebuffIcon_FromIcon
Cmds.CreateAuraIcon = AuraIcon_FromIcon
Cmds.CreateSpellIcon = SpellIcon_FromIcon
Cmds.CreateSpellMonitor = SpellMonitorIcon_FromIcon
Cmds.CreateInterruptSpell = InterruptSpell_Create

Main.ShowMsg = ShowMsg
Main:Initialize()

