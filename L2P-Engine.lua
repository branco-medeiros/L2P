-- L2P Engine

local GCD_SPELL_ID = 61304
local MAJOR, MINOR = "L2P-Engine", 1
local Engine = LibStub:NewLibrary(MAJOR, MINOR)
if not Engine then return end

local Utils = LibStub("L2P-Framelets")
local SPN = {
  Bloodlust       = GetSpellInfo(2825),
  Heroism         = GetSpellInfo(32182),
  TimeWarp        = GetSpellInfo(80353),
  AncientHysteria = GetSpellInfo(90355),
}


------------------------------------------------------------------------------
function Engine:CalcGCD()
------------------------------------------------------------------------------
  self:UpdateGCD()
end

------------------------------------------------------------------------------
function Engine:UpdateGCD()
------------------------------------------------------------------------------
-- updatess our global cooldown measure based on the Global Cooldown Spell,
-- which triggers whenever a global cooldown dependent spell is cast
-- if we have no information, we use the last value registered
------------------------------------------------------------------------------
	local s, d = GetSpellCooldown(GCD_SPELL_ID)
	self.GCD = (s > 0 and d)
		or (self.GCD ~= 0 and self.GCD)
		or (1.5 * (1 - UnitSpellHaste("player")/100))
end

------------------------------------------------------------------------------
function Engine:GetSpell(spell)
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
  if s then ret.NextCharge = s + d - self.Now end
  local e
  s, d, e = GetSpellCooldown(spell)
  ret.ready = d == 0 or e == 0
  if s then ret.cooldown = s + d - self.Now end
  return ret
end

------------------------------------------------------------------------------
function Engine:GetMyDebuff(spell)
------------------------------------------------------------------------------
-- returns information about a debuff on the player
------------------------------------------------------------------------------
  return self:GetDebuff(spell, "PLAYER")
end

------------------------------------------------------------------------------
function Engine:GetTargetBuff(spell)
------------------------------------------------------------------------------
-- returns information about a buff on the target
------------------------------------------------------------------------------
  return self:GetBuff(spell, "TARGET")
end

------------------------------------------------------------------------------
function Engine:GetBuff(spell, target)
------------------------------------------------------------------------------
--[[ returns information about a debuff in the specified target
  - active: the debuff is present
  - charges: how many charges 
  - remaining: how much time remains until the debuff expires
]]
------------------------------------------------------------------------------
  local charges, remaining, duration, name, id = self:CheckBuffOrDebuffAuto(spell, false, target)
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
function Engine:GetDebuff(spell, target)
------------------------------------------------------------------------------
--[[ returns information about a debuff in the specified target
  - active: the debuff is present
  - charges: how many charges 
  - remaining: how much time remains until the debuff expires
]]
------------------------------------------------------------------------------
  local charges, remaining, duration, name, id = self:CheckBuffOrDebuffAuto(spell, true, target)
  
  return {
    active = charges > 0,
    charges = charges,
    remaining = remaining,
    duration = duration,
    name = name
  }
end

------------------------------------------------------------------------------
function Engine:ShowHideFrame()
------------------------------------------------------------------------------
-- decides if the main frame should be shown
------------------------------------------------------------------------------
  if not self.Active
  or not self:IsInCombat() then
    self.Frame:Hide()
    self.CombatTick = 0
    return false
  else
    -- ok, we are visible and active.
    -- update our state, select the spell and show the icons
    self.Frame:Show()
    return true
  end
end


------------------------------------------------------------------------------
function Engine:Update(elapsed)
------------------------------------------------------------------------------
  self:UpdateState(elapsed)
  self:UpdateSpells()
  self:SelectSpells()
  self:ShowHideFrame()
end -- fn Engine_HandleUpdate

------------------------------------------------------------------------------
function Engine:OnEnterCombat()
------------------------------------------------------------------------------
  self.InCombat = true
  self:ShowHideFrame()
end -- fn Engine_OnEnterCombat


------------------------------------------------------------------------------
function Engine:OnLeaveCombat()
------------------------------------------------------------------------------
  self.InCombat = false
  self:ShowHideFrame()
end -- fn Engine_OnLeaveCombat


------------------------------------------------------------------------------
function Engine:OnTargetChanged()
------------------------------------------------------------------------------
  self:ShowHideFrame()
end -- fn Engine_OnTargetChanged


------------------------------------------------------------------------------
function Engine:OnCombatLog()
------------------------------------------------------------------------------
  if not self.Active then return end

  local timestamp, event, hidecaster, source, sname, sflags,
  sflags2, dest, dname, dflags, flags2, 
	p1, p2, p3, p4, p5, p7, p8, p9, p10 = CombatLogGetCurrentEventInfo()
	
  if event == 'UNIT_DIED' then
  -- if an unit died and is in our list, remove it
    self.MobList:Remove(dest)
		self.AttackerList:Remove(dest)
    return
  end

	local isPlayerAction = self.PlayerGUID == source
	if isPlayerAction then
		self:UpdateGCD()
		if event == "SPELL_CAST_SUCCESS" then
			self.LastCastSpell = p1
			self.LastCastTime = GetTime()
			self:DbgTrack("LastCastSpell", tostring(self.LastCastSpell) .. " - " .. GetSpellInfo(self.LastCastSpell))
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
		-- if self is one of our own events then
		-- adds the mob to our list, scheduling it to be removed if we dont hear
		-- from it in a short while
		self.MobList:Add(dest)

	elseif self.PlayerGUID == dest then
		-- otherwise, if is someone attacking us
		-- adds the attacker to a list of attackers
		self.AttackerList:Add(source)
		local prefix = strsub(event, 1, 5)
		local value = (prefix == "SWING" and p1) or (prefix == "ENVIR" and p2) or p4
		self.ElapsedDamage = (self.ElapsedDamage or 0) + (value or 0)
	end

end -- fn Engine_OnCombatLog


------------------------------------------------------------------------------
function Engine:IsInCombat()
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
  ) or self.InCombat
end -- fn Engine_IsInCombat



------------------------------------------------------------------------------
function Engine:CalcLag()
------------------------------------------------------------------------------
-- records the network lag
------------------------------------------------------------------------------
  local lag = select(3, GetNetStats())
  self.Lag = lag / 1000 -- lag comes in msec, turn it into sec
end -- fn Engine_CalcLag


------------------------------------------------------------------------------
function Engine:UpdateState(elapsed)
------------------------------------------------------------------------------
-- colects the information needed to select the spells
------------------------------------------------------------------------------
  self.Now = GetTime()
  self.Elapsed = elapsed
  
  local target = UnitGUID("target")
  if target then self.MobList:Add(target) end
  
  self.Mobs = self.MobList:Refresh()
  self.Targets = self.Mobs
	
  self.Attackers = self.AttackerList:Refresh()
  self.Enemies = self.Attackers
  
  for k, i in pairs(self.MobList.Items) do
    if not self.AttackerList.Items[k] then self.Enemies = self.Enemies + 1 end
  end

  self:CalcGCD()
  self:CalcLag()

  -- refreshes variables used by spec calculators
  local TLevel = UnitLevel("target") or 0
  
  self.IsBossFight = (TLevel < 0) or (TLevel > (UnitLevel("player") + 2)) or UnitIsPlayer("target")
	self.IsPvp = UnitIsPlayer("target") 
  
  self.WeAreBeingAttacked = self.Attackers > 0

  --calcs health and pain
  self.PrevHealth = self.Health
  
  local Health = UnitHealth("player")
  local HealthMax = UnitHealthMax("player")
  
  self.Health = Health
  self.HealthMax = HealthMax
  self.HealthPercent = Health/HealthMax

  if not self.CombatTick or self.CombatTick == 0 then
    self.CombatTick = 0
    self.PrevHealth = Health
    self.HealthChangingRate = 0
    self.CombatDamage = 0
    self.PainPerTick = 0
  end
  
  self.CombatTick = self.CombatTick + 1
  
  if self.ElapsedDamage > 0 then 
    self.CombatDamage = self.CombatDamage + self.ElapsedDamage
    self.PainPerTick = self.CombatDamage / self.CombatTick / HealthMax * 100
  end
  
  if Health ~= self.PrevHealth then 
    self.HealthChangingRate = (Health - self.PrevHealth) / self.PrevHealth
    self.PrevHealth = Health
  end
  
	
  self.HasBloodLust = (self:CheckBuff({SPN.Bloodlust, SPN.Heroism, SPN.TimeWarp, SPN.AncientHysteria}) > 0)
  self.IsMoving = GetUnitSpeed("player") > 0
  self.TargetIsMoving = GetUnitSpeed("target") > 0
  
  self.TargetHealthMax = UnitHealthMax("target") or 0
  self.TargetHealth = UnitHealth("target") or 0
  self.TargetHealthPercent = (self.TargetHealthMax > 0 and self.TargetHealth/self.TargetHealthMax) or 0; 
  
  self.Power = {}
  
  for k, v in pairs(Enum.PowerType) do
    if v >= 0 and k ~= "NumPowerTypes" then 
      local maxPower = UnitPowerMax("player", v)
      if maxPower > 0 then 
        local power = UnitPower("player", v) or 0
        self.Power[k] = power 
        self.Power[k .. "Max"] = maxPower
        self.Power[k .. "Percent"] = power/maxPower
      end
    end
  end
  
  self.ElapsedDamage = 0
  
  self:RefreshVars()
end -- fn Engine_UpdateState

------------------------------------------------------------------------------
function Engine:UpdateSpells()
------------------------------------------------------------------------------
  local now = self.Now
  for k, s in pairs(self.Spells) do
    s:Update(self)
    s:GetActivation(now)
    s:CheckRange()
  end
end

-------------------------------------------------------------------------------
function Engine:IsSpellAvailable(spell)
-------------------------------------------------------------------------------
-- returns true if the spell can be used right now, false otherwise
-------------------------------------------------------------------------------
	if not spell then return false end
	if not GetSpellCooldown(spell) == 0 then return false end
	local u, m = IsUsableSpell(GetSpellInfo(spell))
	return u == true and m == false

end -- fn Engine_IsSpellAvailable


-------------------------------------------------------------------------------
function Engine:SwitchToNewSpells(BestSpell, SecondBestSpell)
-------------------------------------------------------------------------------
-- returns true if the last suggested spell was not used and is preffered to the
-- current one
-------------------------------------------------------------------------------
  if self.CurSpell.Key ~= BestSpell.Key or self.NextSpell.Key ~= SecondBestSpell.Key then
    self:DbgTrack("spells:", (BestSpell.Key or 'none') .. " - " .. (SecondBestSpell.Key or 'none'))
  end
  
  self.CurSpell = BestSpell
  self.NextSpell = SecondBestSpell

  return
  
end -- Engine_SwitchToNewSpells

-------------------------------------------------------------------------------
function Engine:SelectSpells(spells)
-------------------------------------------------------------------------------
-- selects two spells as the best one and the next best one
-------------------------------------------------------------------------------

	-- if the last used spell is already available, allows it to be picked otherwise
	-- prefer another spell
	local LastSpell = not self:IsSpellAvailable(self.LastCastSpell) and self.LastCastSpell
	local Primary = {}
	local Secondary = {}
	for k, s in pairs(self.Spells) do
		if s.Primary then Primary[k] = true end
		if s.Secondary then Secondary[k] = true end
	end
	local curspell = self:FindBestSpell(nil, spells, Secondary)
	local nextspell = self:FindBestSpell(curspell.SpellId, spells, Primary)

	self:SwitchToNewSpells(curspell, nextspell)

	end -- fn Engine_SelectSpells()


-------------------------------------------------------------------------------
function Engine:FindBestSpell(except, spells, NotThese)
-------------------------------------------------------------------------------
-- returns the best spell form the list of priorities, excluding the one
-- given by except
-------------------------------------------------------------------------------
  local Prio = self.Prio
  local Spells = spells or self.Spells
	NotThese = NotThese or {}

  -- creates two dummy spells for [current] and [next]
  local curspell = Utils:NewSpell()
  curspell.When = self.Now + 60000
  curspell.InRange = false

  local Delta = self.GCD / 2 -- 0 -- math.max((self.Throtle or 0), 1/8)
  local GCDx2 = self.GCD * 2

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
function Engine:MapSpellsToBook()
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

  -- fills the sp dictionary
  for k, s in pairs(self.Spells) do
    local sk = tostring(s.SpellId)
    if not sp[sk] then sp[sk] = getSpellSlot(s.SpellId) end
    s.SpellBookIndex = sp[sk]
    if s.RangeSpell then
      sk = tostring(s.RangeSpell)
      if not sp[sk] then sp[sk] = getSpellSlot(s.RangeSpell) end
      s.RangeSpellId = s.RangeSpell
      s.RangeSpellBookIndex = sp[sk]
    end
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
function Engine:RefreshTalents()
-------------------------------------------------------------------------------
  l2p:Print("refreshing talents")
  local talents = {}
  self.talents = talents
  local configID = C_ClassTalents.GetActiveConfigID()
  local treeID = C_Traits.GetConfigInfo(configID).treeIDs[1]
  local nodes = C_Traits.GetTreeNodes(treeID)
  
  for _, nodeID in ipairs(nodes) do
    local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
    if nodeInfo.currentRank and nodeInfo.currentRank > 0 and nodeInfo.activeEntry then
      local entryInfo = C_Traits.GetEntryInfo(configID, nodeInfo.activeEntry.entryID)
      local definitionInfo = entryInfo and entryInfo.definitionID and C_Traits.GetDefinitionInfo(entryInfo.definitionID)
      local spellID = definitionInfo and definitionInfo.spellID
      if spellID then
        talents[tostring(spellID)] = nodeInfo.currentRank
      end
    end
  end
  return talents
end

-------------------------------------------------------------------------------
function Engine:HasTalent(row, col)
-------------------------------------------------------------------------------
	local sg = GetActiveSpecGroup()
	return (select(4, GetTalentInfo(row, col, sg)) and true) or false
end

-------------------------------------------------------------------------------
function Engine:HasTalentByID(id)
-------------------------------------------------------------------------------
  if not self.talents then self:RefreshTalents() end
  return (self.talents[tostring(id)] or 0) > 0
end

-------------------------------------------------------------------------------
function Engine:CheckBuffDebuff(Getter, Comparer)
-------------------------------------------------------------------------------
  for i = 1, 128 do
    local name, _, count, _, duration, expires, _, _, _, id = Getter(i)
    if not id then break end
    if Comparer(name, id) then
      if not count then count = 0 elseif count == 0 then count = 1 end
			local xp = expires
      if not expires then expires = 0 else expires = expires - self.Now end
      return count, expires, duration, name, id, xp
    end
  end
  return 0, 0, 0
end

-------------------------------------------------------------------------------
function Engine:CheckBuffOrDebuffAuto(What, isDebuff, target)
-------------------------------------------------------------------------------
  if not self.Now or self.Now == 0 then self.Now = GetTime() end
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
					expires = expires - self.Now 
				end
        
				return count, expires, duration, name, id, xp
			end
		end
  end
  return 0, 0, 0
end


-------------------------------------------------------------------------------
function Engine:CheckDebuff(Debuff, target)
-------------------------------------------------------------------------------
	return self:CheckBuffOrDebuffAuto(Debuff, true, target)
end

-------------------------------------------------------------------------------
function Engine:CheckBuff(Buff, target)
-------------------------------------------------------------------------------
	return self:CheckBuffOrDebuffAuto(Buff, false, target)
end

-------------------------------------------------------------------------------
function Engine:CheckEnemyDistance(distance)
-------------------------------------------------------------------------------
-- returns true if there's any enemy at the specified distance
-------------------------------------------------------------------------------
  distance = distance or 3
  local result = CheckInteractDistance("target", distance) or false
  if not result and self.Attackers > 0 then
    for k, n in pairs(self.AttackerList) do
      if CheckInteractDistance(k, distance) then
        result = true
        break
      end
    end
  end
  if not result and self.Mobs > 0 then
    for k, n in pairs(self.MobList) do
      if CheckInteractDistance(k, distance) then
        result = true
        break
      end
    end
  end
  return result
end

-------------------------------------------------------------------------------
function Engine:CheckEnemyIsClose()
-------------------------------------------------------------------------------
  return self:CheckEnemyDistance(3)
end

-------------------------------------------------------------------------------
function Engine:CheckEnemyIsNotFar()
-------------------------------------------------------------------------------
  return self:CheckEnemyDistance(2)
end

-------------------------------------------------------------------------------
function Engine:CheckEnemyIsFar()
-------------------------------------------------------------------------------
  return self:CheckEnemyDistance(1)
end

-------------------------------------------------------------------------------
function Engine:HasGlyphSpell(SpellId)
-------------------------------------------------------------------------------
	for n = 1, GetNumGlyphSockets() do
	  local _, _, _, s = GetGlyphSocketInfo(n)
	  if s == SpellId then return true end
	end
	return false
end -- HasGlyphSpell


-------------------------------------------------------------------------------
function Engine:Load(data)
-------------------------------------------------------------------------------
  data = data or {}
  self.SPI = data.SPI or {}
  self.Spells = {}
  self.Prio = {}
  if data.prios then
    for n, p in ipairs(data.prios) do
      local spell = Utils:NewSpellById(p.SpellId)
      for k, v in pairs(p) do
        spell[k] = v
      end
      for i, v in ipairs(spell.Role) do
        spell["HasRole" .. strupper(string.sub(v,1, 1)) .. string.sub(v, 2)] = true
      end
      self.Spells[spell.Key] = spell
      
      local key = spell.Key
      if not spell.HasRoleInterrupt and not spell.HasRoleSlot then
        table.insert(self.Prio, key)
      end
    end
  end
  
  self.code = data.code or {}
  self.slots = data.slots or {}
  
  self:MapSpellsToBook()
  return (data.prios and #data.prios) or 0, self.vars.Spec
end


-------------------------------------------------------------------------------
function Engine:Init()
-------------------------------------------------------------------------------
  self.PlayerClass = select(2, UnitClass("player"))
  self.Spec = GetSpecialization()
  self.vars = self.vars or {}
  self.vars.Spec = self.PlayerClass .. "-" .. self.Spec -- e.g. PALADIN-3
  self.talents = nil
end


-------------------------------------------------------------------------------
function Engine:DbgTrack(name, value)
-------------------------------------------------------------------------------
  if not self.Debug then return end
	name = tostring(name)
	local key = "track_" .. name
	if(self[key] ~= value) then
		print(format("%s : %s -> %s", tostring(self.Now), name, tostring(value)))
		self[key] = value
	end
	return value
end


-------------------------------------------------------------------------------
function Engine:Dump()
-------------------------------------------------------------------------------
  local temp = {}
	for k, v in pairs(self) do
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
function Engine:RefreshVars()
-------------------------------------------------------------------------------
-- loads value sinto Engine.vars (which will be used by the current spec-handler)
-------------------------------------------------------------------------------
  local vars = self.vars or {}
  self.vars = vars
  
  for k, v in pairs(self.Power) do
    vars[k] = v
  end
  
  vars.Health = self.Health
  vars.HealthMax = self.HealthMax
  vars.HealthPercent = self.HealthPercent
  vars.TargetHealth = self.TargetHealth
  vars.TargetHealthMax = self.TargetHealthMax
  vars.TargetHealthPercent = self.TargetHealthPercent
  vars.Attackers = self.Attackers
  vars.Targets = self.Targets
  vars.Enemies = self.Enemies
  vars.Now = self.Now
  vars.IsBossFight = self.IsBossFight
  vars.IsPvp = self.IsPvp
  vars.GCD = self.GCD
  vars.HealthRate = self.HealthChangingRate
  vars.HealthChangingRate = self.HealthChangingRate
  vars.LastCastSpell = self.LastCastSpell
  vars.LastCastTime = self.LastCastTime
  vars.IsMoving = self.IsMoving
  vars.TargetIsMoving = self.TargetIsMoving
  vars.HasBloodLust = self.HasBloodLust
  vars.CombatTick = self.CombatTick
  vars.CombatDamage = self.CombatDamage
  vars.PainPerTick = self.PainPerTick
  
  for k, f in pairs(self.code) do
    vars[k] = f(self)
  end
end

-------------------------------------------------------------------------------
function Engine:SetFrame(Frame)
-------------------------------------------------------------------------------
  self.Frame = Frame
  return self
end

-------------------------------------------------------------------------------
function Engine:SetActive(v)
-------------------------------------------------------------------------------
  self.Active = v
  return self
end

-------------------------------------------------------------------------------
local function InitEngine(Engine)
-------------------------------------------------------------------------------
  local eng = Engine
  local EmptySpell = Utils:NewSpell()

  eng.MobList = Utils:NewTracker()        -- tracks the mobs being hit
	eng.AttackerList = Utils:NewTracker()   -- tracks who are attacking us

  eng.Spec = ''                     -- player spec we are handling
  eng.Spells = {}                   -- list of valid spells indexed by keys
  eng.Frame = nil                 -- the spell frame
  eng.WeAreBeingAttacked = false
  eng.ElapsedDamage = 0             -- the raw damage received between updates
	eng.HealthPercent = 1							 
  eng.HealthRate = 0
  eng.CombatTick = 0
  eng.Mobs = 0                      -- current number of mobs being hit by the player
	eng.Attackers = 0                 -- current number of enemies attacking us
  eng.Enemies = 0 
  eng.CurSpell = EmptySpell         -- the suggested current spell object
  eng.NextSpell = EmptySpell        -- the suggested next spell object
  eng.Elapsed = 0                   -- records the elapsed time since the last update
  eng.InCombat = false              -- true if the engine thinks we are in combat
  eng.GCD = 0                       -- the current global cooldown
  eng.Lag = 0                       -- the network lag of the current session
  eng.Now = 0                       -- current time
  eng.Debug = false
  eng.PlayerGUID = UnitGUID("player")
  eng.CheckRange = true
  
end -- fn Engine_Create

InitEngine(Engine)

