-- L2P-Framelets -- 

local DEFAULT_TRACKER_MAX = 20
local DEFAULT_BDR_TEX = 'Interface\\DialogFrame\\UI-DialogBox-Background-Dark'
local DEFAULT_BG_TEX = "Interface\\DialogFrame\\UI-DialogBox-Background"
local DEFAULT_INTERVAL = 3
local SPELL_CAST_TIME = 4

-- AceAddon prelude for library registration
local MAJOR, MINOR = "L2P-Framelets", 1
local Framelets = LibStub:NewLibrary(MAJOR, MINOR)
if not Framelets then return end

--//////////////////////////////////////////////////////////////////////////////
-- Event
-- simple "event" dispatching
--//////////////////////////////////////////////////////////////////////////////

local Icon_Create
local TextIcon_Create
local SpellMonitorIcon_FromIcon
local DebuffIcon_FromIcon
local BuffIcon_FromIcon
local AuraIcon_FromIcon
local SpellIcon_FromIcon
local SpellMonitorIcon_FromSpellIcon

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
  this.InvalidSpell = not this.SpName or not this:IsValidSpell()
  if this.InvalidSpell then return false end
    
  local cast = select(SPELL_CAST_TIME, GetSpellInfo(this.SpName))
  local ok = ((cast and cast <= 0) or this.NotInstant) and this:IsUsable()
	this.Charges, this.MaxCharges = GetSpellCharges(this.SpName)

  if ok and this.Condition then
    this.Valid = this:Condition(Ctx)
  else
    this.Valid = ok
  end
  return this.Valid
end -- fn Spell_Update

-------------------------------------------------------------------------------
local function Spell_IsValidSpell(this)
-------------------------------------------------------------------------------
  local id = this.SpellId
  return (id or false) and IsPlayerSpell(id)
end
  
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
    (this.Slot and ActionHasRange(this.Slot) and IsActionInRange(this.Slot)) or
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
  sp.IsValidSpell = Spell_IsValidSpell
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
      -- argument count is different!
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
  local sf =  Icon_Create(nil, w, h)
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

-------------------------------------------------------------------------------
local function Icon_SetText(this, text)
-------------------------------------------------------------------------------
-- sets the content of a text layer; if one does not exist, creates
-------------------------------------------------------------------------------
  if (this.IconText or "") ~= (text or "") then
		if not this.TextIcon then 
			local w = this:GetWidth()
			local h = this:GetHeight()
			local icon = TextIcon_Create(this, w, h, 10)
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
local function Icon_AsSpellMonitor(this)
--------------------------------------------------------------------------------
  return SpellMonitorIcon_FromIcon(this)
end

--------------------------------------------------------------------------------
local function Icon_AsDebuffIcon(this)
--------------------------------------------------------------------------------
  return DebuffIcon_FromIcon(this)
end

--------------------------------------------------------------------------------
local function Icon_AsBuffIcon(this)
--------------------------------------------------------------------------------
  return BuffIcon_FromIcon(this)
end

--------------------------------------------------------------------------------
local function Icon_AsAuraIcon(this)
--------------------------------------------------------------------------------
  return AuraIcon_FromIcon(this)
end

--------------------------------------------------------------------------------
local function Icon_AsSpellIcon(this)
--------------------------------------------------------------------------------
  return SpellIcon_FromIcon(this)
end

--------------------------------------------------------------------------------
Icon_Create = function (Parent, w, h, HasCooldown)
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
  
  fr.AsSpellMonitor = Icon_AsSpellMonitor
  fr.AsAuraIcon = Icon_AsAuraIcon
  fr.AsBuffIcon = Icon_AsBuffIcon
  fr.AsBuffIcon = Icon_AsDebuffIcon
  fr.AsSpellIcon  = Icon_AsSpellIcon
  
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
TextIcon_Create = function (Parent, w, h, FontSize)
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
local function SpellIcon_NewSpellMonitor(this)
--------------------------------------------------------------------------------
  return SpellMonitorIcon_FromSpellIcon(this)
end

--------------------------------------------------------------------------------
SpellIcon_FromIcon = function(Icon)
--------------------------------------------------------------------------------
  Icon:SetDefaultImage(false)
  Icon.UpdateSpell = SpellIcon_UpdateSpell
  Icon.SetStatus = SpellIcon_SetStatus
  Icon.NewSpellMonitor = SpellIcon_NewSpellMonitor
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
AuraIcon_FromIcon = function(Icon)
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
BuffIcon_FromIcon = function(Icon)
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
DebuffIcon_FromIcon = function(Icon)
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
SpellMonitorIcon_FromSpellIcon = function(SpellIcon)
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
SpellMonitorIcon_FromIcon = function(Icon)
--------------------------------------------------------------------------------
  return SpellMonitorIcon_FromSpellIcon(Icon:AsSpellIcon())
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
-- Methods
--//////////////////////////////////////////////////////////////////////////////


function Framelets:NewEvent(Sender)
  return Event_Create(Sender)
end

function Framelets:NewNextSpellIcon(Parent, W, H)
  return NextSpellIcon_Create(Parent, W, H)
end

function Framelets:NewCurrentSpellIcon(Parent, W, H)
  return CurrentSpellIcon_Create(Parent, W, H)
end

function Framelets:NewHPIcon(Parent, W, H)
  return HPIcon_Create(Parent, W, H)
end

function Framelets:NewMobsIcon(Parent, W, H)
  return MobsIcon_Create(Parent, W, H)
end

function Framelets:NewMsgIcon(Parent, w, h, size)
  return MsgIcon_Create(Parent, w, h, size)
end

function Framelets:NewSpellMonitorIcon(Parent, w, h)
  return SpellMonitorIcon_Create(Parent, w, h)
end

function Framelets:NewDebuffIcon(Parent, w, h)
  return DebuffIcon_Create(Parent, w, h)
end

function Framelets:NewDebuffIconFromIcon(Icon)
  return DebuffIcon_FromIcon(Icon)
end

function Framelets:NewSpellMonitorFromSpellIcon(SpellIcon)
  return SpellMonitorIcon_FromSpellIcon(SpellIcon)
end

function Framelets:NewSpellMonitorFromIcon(Icon)
  return SpellMonitorIcon_FromIcon(Icon)
end

function Framelets:NewBuffIcon(Parent, w, h)
  return BuffIcon_Create(Parent, w, h)
end

function Framelets:NewAuraIcon(Parent, W, H)
  return AuraIcon_Create(Parent, W, H)
end

function Framelets:NewSpellIcon(Parent, w, h)
  return SpellIcon_Create(Parent, w, h)
end

function Framelets:NewTextIcon(Parent, w, h, FontSize)
  return TextIcon_Create(Parent, w, h, FontSize)
end

function Framelets:NewIcon(Parent, w, h, HasCooldown)
  return Icon_Create(Parent, w, h, HasCooldown)
end

function Framelets:NewSpellFrame(cx, cy, w, h)
  return SpellFrame_Create(cx, cy, w, h)
end

function Framelets:NewInterruptSpell(SpellOrKey, SpName, Caption)
  return InterruptSpell_Create(SpellOrKey, SpName, Caption)
end

function Framelets:NewSpellById(Id)
  return Spell_CreateById(Id)
end

function Framelets:NewSpell(Key, SpName, Condition, Caption)
  return Spell_Create(Key, SpName, Condition, Caption)
end

function Framelets:NewTracker(Interval)
  return Tracker_Create(Interval)
end

function Framelets:NewEvent(Sender)
  return Event_Create(Sender)
end

function Framelets:NewBuffIconFromIcon(Icon)
  return BuffIcon_FromIcon(Icon)
end

function Framelets:NewAuraIconFromIcon(Icon) 
  return AuraIcon_FromIcon(Icon)
end

function Framelets:NewSpellIconFromIcon(Icon)
  return SpellIcon_FromIcon(Icon)
end

local Embeds = {
  "NewAuraIcon",
  "NewAuraIconFromIcon",
  "NewBuffIcon",
  "NewBuffIconFromIcon",
  "NewCurrentSpellIcon",
  "NewDebuffIcon",
  "NewDebuffIconFromIcon",
  "NewEvent",
  "NewHPIcon",
  "NewIcon",
  "NewInterruptSpell",
  "NewMobsIcon",
  "NewMsgIcon",
  "NewNexSpellIcon",
  "NewSpell",
  "NewSpellById",
  "NewSpellFrame",
  "NewSpellIcon",
  "NewSpellIconFromIcon",
  "NewSpellMonitorFromSpellIcon",
  "NewSpellMonitorFromIcon",
  "NewSpellMonitorIcon",
  "NewTextIcon",
  "NewTracker"
}

function Framelets:Embed(target)
	for k, v in pairs(Embeds) do
		target[v] = self[v]
	end
	return target
end

