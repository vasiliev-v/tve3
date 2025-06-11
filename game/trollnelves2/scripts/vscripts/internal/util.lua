function DebugPrint(...)
  local spew = Convars:GetInt('trollnelves2_spew') or -1
  if spew == -1 and TROLLNELVES2_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    print(...)
  end
end

function DebugPrintTable(...)
  local spew = Convars:GetInt('trollnelves2_spew') or -1
  if spew == -1 and TROLLNELVES2_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    PrintTable(...)
  end
end

function PrintTable(t, indent, done)
  --print ( string.format ('PrintTable type %s', type(keys)) )
  if type(t) ~= "table" then return end

  done = done or {}
  done[t] = true
  indent = indent or 0

  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end

  table.sort(l)
  for k, v in ipairs(l) do
    -- Ignore FDesc
    if v ~= 'FDesc' then
      local value = t[v]

      if type(value) == "table" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..":")
        PrintTable (value, indent + 2, done)
      elseif type(value) == "userdata" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
      else
        if t.FDesc and t.FDesc[v] then
          print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
        else
          print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        end
      end
    end
  end
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'


--[[Author: Noya
  Date: 09.08.2015.
  Hides all dem hats
]]
function HideWearables( event )
  local hero = event.caster
  local ability = event.ability

  hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
  local hero = event.caster

  for i,v in pairs(hero.hiddenWearables) do
    v:RemoveEffects(EF_NODRAW)
  end
end

function CDOTA_Item:Use()
    local caster = self:GetOwner()
    if caster ~= nil and (caster:IsHero() or caster:HasInventory()) then
        local newCharges = self:GetCurrentCharges() - 1
        if newCharges > 0 then
            self:SetCurrentCharges(newCharges)
        else
            caster:TakeItem(self)
        end
    end
end

function ConvertToTime( value )
  local value = tonumber( value )

if value <= 0 then
  return "00:00:00";
else
    hours = string.format( "%02.f", math.floor( value / 3600 ) );
    mins = string.format( "%02.f", math.floor( value / 60 - ( hours * 60 ) ) );
    secs = string.format( "%02.f", math.floor( value - hours * 3600 - mins * 60 ) );
    if math.floor( value / 3600 ) == 0 then
      return mins .. ":" .. secs
    end
    return hours .. ":" .. mins .. ":" .. secs
end
end

function ParticleManager:Create(sParticle, ...)
  local qArgs = {...}

  if isdotaobject(qArgs[1]) then
      table.insert(qArgs, 1, PATTACH_ABSORIGIN_FOLLOW)
  elseif qArgs[1] == nil then
      qArgs[1] = PATTACH_WORLDORIGIN
  end

  if qArgs[2] ~= nil and not isdotaobject(qArgs[2]) then
      table.insert(qArgs, 2, nil)
  end

  local nParticle = self:CreateParticle(sParticle, qArgs[1], qArgs[2])

  if qArgs[3] then self:Fade(nParticle, qArgs[3], qArgs[4]) end

  return nParticle
end

function ParticleManager:Fade(nParticle, nDelay, bFaded)
  if type(nDelay) == 'boolean' then
      nDelay = 0
      bFaded = nDelay
  end

  Timers:CreateTimer(nDelay or 0, function()
      self:DestroyParticle(nParticle, not bFaded)
      self:ReleaseParticleIndex(nParticle)
  end)
end

function ParticleManager:Animate(nParticle, nPoint, vStart, vTarget, nDuration,
                               bForceEnd)
  nDuration = nDuration or 0
  local vDelta

  if nDuration > 0 then vDelta = (vTarget - vStart) / nDuration end

  local hTimer = Timers:CreateTimer(function(nTime)
      if nDuration <= 0 then
          bForceEnd = true
          return
      end

      self:SetParticleControl(nParticle, nPoint, vStart)

      vStart = vStart + vDelta * nTime
      nDuration = nDuration - nTime

      return 1 / 30
  end)

  hTimer.OnDestroy = function()
      if bForceEnd then
          self:SetParticleControl(nParticle, nPoint, vTarget)
      end
  end

  return hTimer
end

StaticParticle = StaticParticle or class {}

function StaticParticle:constructor(sName, ...)
  self.bNull = false
  self.qCall = {}
  self.tParticles = {}
  self.sName = sName

  local tArgs = args({...}, {'number', isdotaobject, 'function'})

  self.hParent = tArgs[2]
  self.nAttach = tArgs[1] or
                     (self.hParent and PATTACH_ABSORIGIN_FOLLOW or
                         PATTACH_WORLDORIGIN)
  self.fCondition = tArgs[3] or function() return true end

  for nPlayer = 0, DOTA_MAX_PLAYERS - 1 do self:InitPlayer(nPlayer) end

  self.nInitListener = CustomGameEventManager:RegisterListenerInited(
                           'sv_client_init', function(tEvent)
          self:InitPlayer(tEvent.PlayerID)
      end)
end

function StaticParticle:InitPlayer(nPlayer)
  if self:IsNull() then return end

  if PlayerResource:IsValidPlayer(nPlayer) and self.fCondition(nPlayer) then
      local nOldParticle = self.tParticles[nPlayer]
      if nOldParticle then
          ParticleManager:Fade(nOldParticle)
          self.tParticles[nPlayer] = nil
      end

      local hPlayer = PlayerResource:GetPlayer(nPlayer)
      if hPlayer then
          local nParticle = ParticleManager:CreateParticleForPlayer(
                                self.sName, self.nAttach, self.hParent,
                                hPlayer)
          self.tParticles[nPlayer] = nParticle

          for _, qCall in ipairs(self.qCall) do
              local sFunctionName = qCall[1]
              local qArgs = {}
              for i = 2, #qCall do
                  table.insert(qArgs, qCall[i])
              end

              ParticleManager[sFunctionName](ParticleManager, nParticle,
                                             table.unpack(qArgs))
          end
      end
  end
end

function StaticParticle:Destroy(bFaded)
  if self.bNull then return end

  self.bNull = true

  for nPlayer, nParticle in pairs(self.tParticles) do
      ParticleManager:Fade(nParticle, bFaded)
  end

  CustomGameEventManager:UnregisterListener(self.nInitListener)

  self.tParticles = nil
  self.nInitListener = nil
end

function StaticParticle:IsNull() return self.bNull end

local fCopyFunctions = function(tSource)
  for sFunctionName, fCall in pairs(tSource) do
      if not StaticParticle[sFunctionName] and type(fCall) == 'function' and
          not sFunctionName:match('Create') then
          StaticParticle[sFunctionName] = function(self, ...)
              if self.bNull then return end

              table.insert(self.qCall, {sFunctionName, ...})

              for nPlayer, nParticle in pairs(self.tParticles) do
                  fCall(ParticleManager, nParticle, ...)
              end
          end
      end
  end
end

local tSource = ParticleManager
while type(tSource) == 'table' do
  fCopyFunctions(tSource)
  tSource = (getmetatable(tSource) or {}).__index
end


function isdotaobject( obj )
	local sType = type( obj )
	
	if sType == 'userdata' then
		return true
	end
	
	if sType == 'table' and type( obj.IsNull ) == 'function' then
		return true
	end
	
	return false
end

function isobject( obj )
	if isdotaobject( obj ) then
		return true
	end
	
	if type( obj ) == 'table' then
		if getmetatable( obj ) then
			return true
		end

		if isclass( obj ) then
			return true
		end
		
		if getclass( obj ) then
			return true
		end
	end
	
	return false
end

function istable( obj )
	return type( obj ) == 'table' and not isobject( obj )
end

function isitable( obj )
	if istable( obj ) then
		return table.size( obj ) == #obj
	end
	
	return false
end

function isindexable( obj )
	local sType = type( obj )

	if sType == 'table' then
		return true
	end

	if sType == 'userdata' then
		local bStatus = pcall( function()
			local test = obj.test
		end )
		return bStatus
	end
end

function exist( obj )
	if isindexable( obj ) then
		if type( obj.IsNull ) == 'function' then
			return not obj:IsNull()
		end
	end

	if type(obj) == 'table' then
		return table.size(obj) ~= 0 or getmetatable(obj) ~= nil
	end
	
	return obj ~= nil
end

function super( obj )
	return getbase( getclass( obj ) )
end

function GetAttachmentOrigin(unit, attach)
	return unit:GetAttachmentOrigin(unit:ScriptLookupAttachment(attach))
end

function toboolean( obj )
	return ( obj and obj ~= 0 and obj ~= '' ) or false
end

function InsertAbilityAfter(hero, ability_after, ability_to_insert)
    -- 1) Найдём индекс ability_after и соберём список «хвостовых» способностей
    local tail = {}
    local afterIndex = nil
    local i = 0
    while true do
        local abi = hero:GetAbilityByIndex(i)
        if not abi then break end

        if abi:GetAbilityName() == ability_after then
            afterIndex = i
        elseif afterIndex then
            -- сохраняем имя и уровень всех способностей после ability_after
            table.insert(tail, { name = abi:GetAbilityName(), level = abi:GetLevel() })
        end
        i = i + 1
    end

    if not afterIndex then
        print("Ошибка: не найдена способность «" .. ability_after .. "»")
        return
    end

    -- 2) Удаляем из героя все «tail» способности
    for _, info in ipairs(tail) do
        hero:RemoveAbility(info.name)
    end

    -- 3) Добавляем нужную новую способность
    if not hero:HasAbility(ability_to_insert) then
        local newAbi = hero:AddAbility(ability_to_insert)
        newAbi:SetLevel(1)
    end

    -- 4) Восстанавливаем «tail» способности в том же порядке
    for _, info in ipairs(tail) do
        local abi = hero:AddAbility(info.name)
        abi:SetLevel(info.level)
    end
end