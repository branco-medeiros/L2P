-- L2P
local Main = LibStub("AceAddon-3.0"):NewAddon("L2P", "AceConsole-3.0", "AceEvent-3.0")
local Frames = LibStub("L2P-Framelets")
local AceGUI = LibStub("AceGUI-3.0")

local DEFAULT_FREQUENCY = 15
local DEFAULT_XICON_ROW_SIZE = 5

--------------------------------------------------------------------------------
local function L(text)
--------------------------------------------------------------------------------
-- the ubiquitous locale funtion
--------------------------------------------------------------------------------
  return text
end

--------------------------------------------------------------------------------
function Main:DbgMsg(...)
--------------------------------------------------------------------------------
  if self.Debug then self:Print(format(...)) end
end

--------------------------------------------------------------------------------
function Main:ResetEngine()
--------------------------------------------------------------------------------
  self.Engine:Init()
  local prios, spec = self.Engine:Load(self:GetSpecData(self.Engine))
  self:CreateSlots(self.Engine.slots)
  self.Active = self.Engine:SetActive(prios>0).Active
  if self.Active then self:LoadKeys() end
  self:DbgMsg("Loaded %d spells for spec %s", prios, spec)
  self.Engine:ShowHideFrame()
end


--------------------------------------------------------------------------------
function Main:CreateSlots()
--------------------------------------------------------------------------------
    self:InitXIcons(#self.Engine.slots)
    self:ReloadIcons()
    
    for i, slot in ipairs(self.Engine.slots) do
      local icon = self:AddXIcon()
      if slot.Type == "buff" then 
        icon:AsBuffIcon()
        icon.Buffs = {slot.Spell}
        
      elseif slot.Type == "debuff" then
        icon:AsDebuffIcon()
        icon.Debuffs = {slot.Spell}
        
      elseif slot.Type == "aura" then
        icon:AsAuraIcon()
        icon.Auras = {slot.Spell}
        
      elseif slot.Type == "spell" then
        local splist ={}
        for k, v in pairs(self.Engine.Spells) do
          if v.HasRoleSlot and v.SpellId == slot.Spell then
            splist = {v}
            break
          end
        end  
        icon:AsSpellMonitor()
        icon.Spells = splist
      end
      icon.Tooltip = slot.Description      
    end

    local interrupts = {}
    for k, v in pairs(self.Engine.Spells) do
      if v.HasRoleInterrupt then table.insert(interrupts, Frames:NewInterruptSpell(v)) end
    end
    self.InterruptIcon.Spells = interrupts
end


--------------------------------------------------------------------------------
function Main:EnableEvents()
--------------------------------------------------------------------------------
  self:RegisterEvent('PLAYER_LOGIN')
  self:RegisterEvent('PLAYER_ENTER_COMBAT')
  self:RegisterEvent('PLAYER_LEAVE_COMBAT')
  self:RegisterEvent('PLAYER_TARGET_CHANGED')
  self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
  self:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
  self:RegisterEvent('PLAYER_TALENT_UPDATE')
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
  self:RegisterEvent('ACTIVE_COMBAT_CONFIG_CHANGED')
  self:RegisterEvent('TRAIT_CONFIG_UPDATED')
end --  fn Main:EnableEvents

--------------------------------------------------------------------------------
function Main:DisableEvents()
--------------------------------------------------------------------------------
  self:UnregisterEvent('PLAYER_LOGIN')
  self:UnregisterEvent('PLAYER_ENTER_COMBAT')
  self:UnregisterEvent('PLAYER_LEAVE_COMBAT')
  self:UnregisterEvent('PLAYER_TARGET_CHANGED')
  self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
  self:UnregisterEvent('PLAYER_TALENT_UPDATE')
	self:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
  self:UnregisterEvent('ACTIVE_COMBAT_CONFIG_CHANGED')
  self:UnregisterEvent('TRAIT_CONFIG_UPDATED')
end -- fn Main:DisableEvents

--------------------------------------------------------------------------------
function Main:PLAYER_ENTER_COMBAT(evt, ...)
--------------------------------------------------------------------------------]
  --self:Print("PLAYER_ENTER_COMBAT")
  self.Engine:OnEnterCombat(evt, ...)
end 

--------------------------------------------------------------------------------
function Main:PLAYER_LEAVE_COMBAT(evt, ...)
--------------------------------------------------------------------------------
  --self:Print("PLAYER_LEAVE_COMBAT")
  self.Engine:OnLeaveCombat(evt, ...)
end

--------------------------------------------------------------------------------
function Main:PLAYER_TARGET_CHANGED(evt, ...)
--------------------------------------------------------------------------------
  --self:Print("PLAYER_TARGET_CHANGED")
  self.Engine:OnTargetChanged(evt, ...)
end 

--------------------------------------------------------------------------------
function Main:COMBAT_LOG_EVENT_UNFILTERED(evt, ...)
--------------------------------------------------------------------------------
  self.Engine:OnCombatLog(evt, ...)
end

--------------------------------------------------------------------------------
function Main:UPDATE_SHAPESHIFT_FORM(evt, ...)
--------------------------------------------------------------------------------
  self.LoadKeysNeeded = true
end

--------------------------------------------------------------------------------
function Main:PLAYER_LOGIN(evt, ...)
-------------------------------------------------------------------------------
  self:DbgMsg("Player Login")
  self.SpecChanged = true
end

--------------------------------------------------------------------------------
function Main:PLAYER_TALENT_UPDATE(evt, ...)
--------------------------------------------------------------------------------
	self:DbgMsg("Talent update")
	self.TalentsChanged = true
end

--------------------------------------------------------------------------------
function Main:ACTIVE_COMBAT_CONFIG_CHANGED(evt, ...)
--------------------------------------------------------------------------------
	self:DbgMsg("Active Combat Config Changed")
	self.TalentsChanged = true
end

--------------------------------------------------------------------------------
function Main:TRAIT_CONFIG_UPDATED(evt, ...)
--------------------------------------------------------------------------------
	self:DbgMsg("Talent Config Updated")
	self.TalentsChanged = true
end


--------------------------------------------------------------------------------
function Main:ACTIVE_TALENT_GROUP_CHANGED(evt, ...)
--------------------------------------------------------------------------------
	self:DbgMsg("Talent group changed")
	self.SpecChanged = true
end


--------------------------------------------------------------------------------
function Main:OnUpdate(evt, elapsed, ...)
--------------------------------------------------------------------------------
-- called by the MainFrame when it is visible
--------------------------------------------------------------------------------
  self.Elapsed = (self.Elapsed or 0) + (elapsed or 0)
  -- exits if throtling
  if self.Throtle and self.Elapsed < self.Throtle then return end

  if self.SpecChanged or self.TalentsChanged then
    self.SpecChanged = false
    self.TalentsChanged = false
    self:ResetEngine() -- reset engine may change our active status
    self.LoadKeysNeeded = true
  end

  if self.Active then
    if self.LoadKeysNeeded then
      self.LoadKeysNeeded = false
      self:LoadKeys()
    end

    self.Engine:Update(elapsed)
    self:UpdateIcons()
    self:ShowVars()
  else 
    self.MainFrame:Hide()
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
function Main:ShowVars()
--------------------------------------------------------------------------------
  if self.DebugFrame:IsVisible() then
    self.DebugFrame:ShowVars(self.Engine.vars)
  end
end


--------------------------------------------------------------------------------
function Main:ResetFramePosition()
--------------------------------------------------------------------------------
  self:DbgMsg(L'Frame position was reset')
  self.MainFrame:ClearAllPoints()
  self.MainFrame:SetPoint("CENTER", 0, -150)
end

--------------------------------------------------------------------------------
function Main:LoadKeys(show)
--------------------------------------------------------------------------------
  local klist = self:MapSpellKeys()
  for k, s in pairs(self.Engine.Spells) do
    -- sets the message for the spell based on the spell name
    -- or the action spell name (in cases such as in Pyroblast, where the actual spell cast
    -- when the effect procs is different from the spell in the action bar)
    local t = klist[s.SpName] or (s.ActionSpell and klist[s.ActionSpell]) or {}
    local key = t.key
    local slot = t.slot
    s.Message = key and key:gsub("SHIFT%-", "s")
    s.Slot = slot
    if show then self:Print(k, ":", s.Message or "") end
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
          local isSpell = actionType == 'spell'
          if actionType == 'macro' then
            id = select(MACRO_SPELL_INDEX, GetMacroSpell(id))
						if id then id = tonumber(id) end
          end
          if id then
            id = GetSpellInfo(id)
            if id then
							slist[id] = {key = key, slot = isSpell and slot or nil}
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
      GameTooltip:SetText(string.format(Icon.Tooltip, Icon.TooltipData or ""))
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
    local ic = Frames:NewIcon(fr, 20, 20, true)
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
  ic = Frames:NewMobsIcon(fr, 40, 40)
  ic:XYAt(-16, -20)
  ic:SetBorder(4)
  ic.Name = "MobsIcon"
  ic.Tooltip = L"Enemies you hit"
  AttachTooltip(ic)
  self.MobsIcon = ic

  -- the icon for the player's HP
  ic = Frames:NewHPIcon(fr, 60, 60)
  ic:XYAt(20, 0)
  ic:SetBorder(4)
  ic.Name = "HPIcon"
  self.HPIcon = ic

   -- the icon for the suggested spell

  ic = Frames:NewCurrentSpellIcon(self.HPIcon, 45, 45)
  ic:CenterAt(0, 0)
  ic:SetBorder(4)
  ic.Name = "CurSpellIcon"
  ic.Tooltip = L"Current best spell: %s"
  ic.TooltipData = L"None"
  AttachTooltip(ic)
  self.CurSpellIcon = ic

   -- the text to a custom message when a given spell is selected
  ic = Frames:NewMsgIcon(self.CurSpellIcon, 45, 45)
  ic:CenterAt(0, -20)
  ic.Source = self.CurSpellIcon
  self.CurMsgIcon = ic

   -- the icon for second best suggested spell
  ic = Frames:NewNextSpellIcon(fr, 40, 40)
  ic:XYAt(76, -20)
  ic:SetBorder(4)
  ic.Name = "NextSpellIcon"
  ic.Tooltip = L"Next best spell: %s"
  ic.TooltipData = L"None"
  AttachTooltip(ic)
  self.NextSpellIcon = ic


  ic = Frames:NewMsgIcon(self.NextSpellIcon, 40, 40, 16)
  ic:CenterAt(0, -20)
  ic.Source = self.NextSpellIcon
  self.NextMsgIcon = ic

  -- the icon for the interrupt spell
  ic = Frames:NewSpellMonitorIcon(fr, 25, 25, true)
  ic:XYAt(76, 0)
  ic:SetBorder(4)
  ic.Name = "InterruptIcon"
  ic.Tooltip = L"Interrupts"
  AttachTooltip(ic)
  self.InterruptIcon = ic

  -- the move handler
  ic = Frames:NewIcon(fr, 8, 8)
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
  
end -- Main:CreateIcons


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
function Main:CreateDebugFrame()
--------------------------------------------------------------------------------
  if not self.DebugFrame then
    local frame = AceGUI:Create("Window")
    frame:SetCallback("OnClose", function(widget)
      frame:Hide()
    end)
    
    frame:Hide()
    
    self.DebugFrame = frame
    frame:SetWidth(300)
    frame:SetHeight(400)
    frame:SetTitle("L2P vars")
    frame:SetLayout("Fill")
    
    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    frame.VarsList = scroll
    frame.Lines = {}
    frame:AddChild(scroll)
    
    function frame:ClearVars()
      self.VarsList:ReleaseChildren()
      self.Lines = {}
    end
    
    function frame:ShowVars(vars)
      vars = vars or {}
      local list = {}
      for k, v in pairs(vars) do
        local str = (type(v) == "number" and math.floor(v) ~= v and string.format("%.4f", v )) or tostring(v)
        table.insert(list, k .. ': ' .. str)
      end
      table.sort(list)
      local varlist = self.Lines
      for n, item in ipairs(list) do
        if n > #varlist then 
          local line = AceGUI:Create("Label")
          table.insert(varlist, line)
          self.VarsList:AddChild(line)
        end
        varlist[n]:SetText(item)
      end
      for n = #list + 1, #varlist do
        varlist[n]:SetText("")
      end    
    end
    
  end
  
  
end


function Main:SetDebug(value)
  self.Debug = value
  if self.Engine then self.Engine.Debug = value end
  return self
end

--------------------------------------------------------------------------------
function Main:cmd_help(...)
--------------------------------------------------------------------------------
  self:Print("/l2p reset")
  self:Print(L"     resets the addon")
  self:Print("/l2p names")
  self:Print(L"     lists the actual names of each spell")
  self:Print("/l2p list")
  self:Print(L"     list the spells in priority order")
  self:Print("/l2p loadkeys")
  self:Print(L"     tries to load the keys corresponding to each spell")
  self:Print("/l2p debug [on|off]")
  self:Print(L"     enables/disables debug mode")
  self:Print("/l2p debug_spells")
  self:Print(L"     lists all spells and their stati")
end


--------------------------------------------------------------------------------
function Main:cmd_reset(Args)
--------------------------------------------------------------------------------
  if not Args or Args == '' then
    self:ResetFramePosition()
    
  elseif strlower(Args) == 'prio' then
    self:Print(L'The priority lists were reset')
    self:ResetEngine()
  end
end -- fn Main:cmd_reset

--------------------------------------------------------------------------------
function Main:cmd_names()
--------------------------------------------------------------------------------
  if self.Active then
    for k, v in pairs(self.Engine.Spells) do
      self:Printf("%s: %s", k, v.SpName)
    end
  else
    self:Print(L"L2P is not active")
  end -- if
end -- Main:cmd_names

--------------------------------------------------------------------------------
function Main:cmd_list()
--------------------------------------------------------------------------------
  if self.Active then
    local Prio = self.Engine.Prio
    local list = (Prio and table.concat(Prio, ' ')) or "<none>"
    self:Print(list)
  else
    self:Print(L"L2P is not active")
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
	value = (not value and ((self.Debug and "off") or "on")) or (value == "on" and "on") or "off"
	if value == "on" then self:SetDebug(true) else value = "off"; self:SetDebug(false) end
	self:Print("Debug is", value)
end

--------------------------------------------------------------------------------
function Main:cmd_showvars()
--------------------------------------------------------------------------------
  self.DebugFrame:Show()
end

--------------------------------------------------------------------------------
function Main:cmd_debug_spells()
--------------------------------------------------------------------------------
	Main.Dbg:ShowSpells()
end

--------------------------------------------------------------------------------
function Main:OnChatCommand(Text)
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
        self:Print(L"L2P is not active")
      end
    else
      self:Print(L"Invalid command")
    end
  end
end -- fn DispatchCmd


--------------------------------------------------------------------------------
function Main:OnEnable()
--------------------------------------------------------------------------------
  self:DbgMsg("Enabled")

  self:DbgMsg("Creating MainFrame")
  local sf =  Frames:NewSpellFrame(0, 0, 100, 80)
  sf:SetFrameStrata("DIALOG")
  sf:Hide()
  self.MainFrame = sf
  self:ResetFramePosition()
  sf.OnUpdate:Add(self.OnUpdate, self)

  self:DbgMsg("Creating Icons")
  self:CreateIcons()
  
  self.DbgMsg("Creating the DebugFrame")
  self:CreateDebugFrame()
  
  self:DbgMsg("Loading the Engine")
  self.Engine = LibStub("L2P-Engine"):SetFrame(sf)
  self.Engine.Debug = self.Debug
  
  self:DbgMsg("Hooking Events")
  self:EnableEvents()
  
  self.Elapsed = 0
  self.Throtle = 1 / DEFAULT_FREQUENCY
  self.Active = false;

  self:ResetEngine()

  _G["l2p"] = self
  _G["xl2p"] = self.Engine
  
end --  fn HandleAddOnLoaded


--------------------------------------------------------------------------------
function Main:OnInitialize()
--------------------------------------------------------------------------------
  self:SetDebug(false) -- true
  self:DbgMsg("Initialize")
  self:RegisterChatCommand("l2p", "OnChatCommand")
end -- fn Initialize


Main.utils = {
  IndexOf = function(list, item)
    for i, v in ipairs(list) do
      if v == item then return i end
    end
  end,
  
  GetTable = function(theTable, noFn, maxlevels, ret, level, done)
    ret = ret or {} 
    level = (level or 0) + 1
    done = done or {}
    local spc = string.format("%".. (level*2) .. "s", " ")
    
    if type(theTable) ~= "table" then 
      table.insert(ret, spc .. '[... not a table]')
      return ret 
    end
    
    maxlevels = maxlevels or 10
    if maxlevels < 1 then
      table.insert(ret, spc .. "[...too many levels]")
      return ret
    end
    
    if Main.utils.IndexOf(done, theTable) then
      table.insert(ret, spc .. "[...]")
      return ret
    end 
    
    table.insert(done, theTable)
    
    local fn = {}
    local keys = {}
    for k, v in pairs(theTable) do
      if type(v) == "function" then
        table.insert(fn, spc .. k .. ": <function>")        
      else
        table.insert(keys, k)
      end
    end
    
    if not noFn then
      table.sort(fn)
      for _, v in ipairs(fn) do table.insert(ret, v) end
    end
    fn = nil
    
    table.sort(keys)
    for _, k in ipairs(keys) do
      local v = theTable[k]
      local t = type(v)
      if t == "table" then
        table.insert(ret, spc .. k .. ":")
        Main.utils.GetTable(v, noFn, maxlevels - 1, ret, level, done)
      
      elseif t ~= "function" then
        table.insert(ret, spc .. k .. ': ' .. tostring(v))
      end
    end
    keys = nil
    if level == 1 then done = nil end
    return ret
  end,
  
  dumpTable = function(theTable, noFn, maxlevels)
    local ret = Main.utils.GetTable(theTable, noFn, maxlevels)
    for _, v in ipairs(ret) do print(v) end
    return ret
  end
}

