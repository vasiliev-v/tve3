-- reveal_area.lua

reveal_area = class({})

LinkLuaModifier("modifier_reveal_area_charges", "abilities/reveal_area.lua", LUA_MODIFIER_MOTION_NONE)

-------------------------------------------------
-- Ability
-------------------------------------------------

function reveal_area:GetIntrinsicModifierName()
	return "modifier_reveal_area_charges"
end

function reveal_area:OnUpgrade()
	if not IsServer() then return end
	if self:GetLevel() ~= 1 then return end

	local caster = self:GetCaster()
	local max_charges = self:_getMaxChargesForCaster(caster)

	-- Повесим мод, если его нет (постоянный, без duration)
	if not caster:HasModifier("modifier_reveal_area_charges") then
		caster:AddNewModifier(caster, self, "modifier_reveal_area_charges", {})
	end

	self._charges = max_charges
	self._start_charge = false
	self._cooldown_left = 0.0

	-- твой флаг для медведя
	if caster.first == nil then
		caster.first = true
	end
	if caster:GetUnitName() == "npc_dota_hero_bear" and caster.first then
		caster.first = false
		return
	end

	-- Основной цикл восстановления
	Timers:CreateTimer(function()
		if not caster or caster:IsNull() then return 0.5 end

		local cd_red = self:_getCooldownReductionOwnerAware(caster)
		local max_ch = self:_getMaxChargesForCaster(caster)
		if not self._charges then self._charges = max_ch end

		local base_replenish = self:GetSpecialValueFor("charge_replenish_time")
		local replenish_time = base_replenish * cd_red

		if self._start_charge and self._charges < max_ch then
			local next_charge = self._charges + 1
			local mod_name = "modifier_reveal_area_charges"

			-- Обновляем визуализацию РОВНО один раз на цикл:
			-- если ещё не максимум — делаем Remove+Add С ДЛИТЕЛЬНОСТЬЮ
			if next_charge ~= max_ch then
				caster:RemoveModifierByName(mod_name)
				caster:AddNewModifier(caster, self, mod_name, { duration = replenish_time })
				self:_startCooldownTick(replenish_time)
			else
				-- Достигли максимума: Remove+Add БЕЗ длительности (постоянный)
				caster:RemoveModifierByName(mod_name)
				caster:AddNewModifier(caster, self, mod_name, {})
				self._start_charge = false
			end

			-- Стек заряда
			local mod = caster:FindModifierByName(mod_name)
			if mod then mod:SetStackCount(next_charge) end
			self._charges = next_charge
		end

		-- Планирование следующей «порции» восстановления
		if self._charges ~= max_ch then
			self._start_charge = true
			return replenish_time
		else
			return 0.5
		end
	end)
end

-- внутренняя шкала для КД способности, когда зарядов 0
function reveal_area:_startCooldownTick(replenish_time)
	self._cooldown_left = replenish_time
	Timers:CreateTimer(function()
		self._cooldown_left = self._cooldown_left - 0.1
		if self._cooldown_left > 0.1 then
			return 0.1
		end
	end)
end

-- Нажатие способности
function reveal_area:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	if not self._charges or self._charges <= 0 then return end

	local max_charges = self:_getMaxChargesForCaster(caster)
	local cd_red = self:_getCooldownReductionOwnerAware(caster)
	local base_replenish = self:GetSpecialValueFor("charge_replenish_time")
	local replenish_time = base_replenish * cd_red

	local no_deplete = caster:HasModifier("modifier_troll_warlord_presence")
		or caster:HasModifier("modifier_troll_boots_3")

	local next_charge = no_deplete and self._charges or (self._charges - 1)
	local mod_name = "modifier_reveal_area_charges"

	-- Если трата идёт с ПОЛНОГО стека — запускаем КД-кольцо:
	-- Remove+Add с duration (и больше duration не трогаем!)
	if self._charges == max_charges and not no_deplete then
		caster:RemoveModifierByName(mod_name)
		caster:AddNewModifier(caster, self, mod_name, { duration = replenish_time })
		self:_startCooldownTick(replenish_time)
	end

	-- Обновляем стеки
	local mod = caster:FindModifierByName(mod_name)
	if mod then mod:SetStackCount(next_charge) end
	self._charges = next_charge

	-- КД на самой кнопке при 0 зарядах
	if not no_deplete then
		if self._charges == 0 then
			self:StartCooldown(math.max(self._cooldown_left, 0.05))
		else
			self:EndCooldown()
		end
	end

	self:_reveal(point)
end

-------------------------------------------------
-- Helpers
-------------------------------------------------

function reveal_area:_getCooldownReductionOwnerAware(caster)
	local cd_red = caster:GetCooldownReduction()
	if caster:GetUnitName() == "npc_dota_hero_bear" then
		local hero = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())
		if hero then cd_red = hero:GetCooldownReduction() end
	end
	return cd_red
end

function reveal_area:_getMaxChargesForCaster(caster)
	local max_ch = self:GetSpecialValueFor("maximum_charges")
	if caster:HasModifier("modifier_troll_spell_reveal") then
		local s = caster:FindModifierByName("modifier_troll_spell_reveal"):GetStackCount()
		if s == 1 then max_ch = 3
		elseif s == 2 then max_ch = 4
		elseif s >= 3 then max_ch = 5 end
	end
	return max_ch
end

function reveal_area:_scaledRadius(base_radius)
	local name = GetMapName() or ""
	if string.match(name, "1x1") then
		return base_radius * 0.32
	elseif string.match(name, "arena") then
		return base_radius * 0.58
	else
		return base_radius
	end
end

function reveal_area:_getRadius()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius1")

	if caster:HasModifier("modifier_troll_spell_vision") then
		local s = caster:FindModifierByName("modifier_troll_spell_vision"):GetStackCount()
		if s == 1 then radius = radius + 300
		elseif s == 2 then radius = radius + 600
		elseif s >= 3 then radius = radius + 900 end
	end

	if caster:HasModifier("modifier_troll_spell_vision_x4") then
		local s = caster:FindModifierByName("modifier_troll_spell_vision_x4"):GetStackCount()
		if s == 1 then radius = radius + 300
		elseif s == 2 then radius = radius + 600
		elseif s >= 3 then radius = radius + 900 end
	end

	return self:_scaledRadius(radius)
end

function reveal_area:_reveal(point)
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:_getRadius()

	EmitSoundOn("Hero_Silencer.Curse.Cast", caster)
	EmitSoundOnLocationWithCaster(point, "hero_bloodseeker.bloodRite", caster)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(p, 0, point)
	ParticleManager:SetParticleControl(p, 1, Vector(radius, 0, 0))
	Timers:CreateTimer(duration, function()
		ParticleManager:DestroyParticle(p, false)
		ParticleManager:ReleaseParticleIndex(p)
	end)

	AddFOWViewer(caster:GetTeamNumber(), point, radius, duration, false)

	local elapsed = 0
	Timers:CreateTimer(0.03, function()
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(), point, nil, radius,
			DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL,
			DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false
		)
		for _,unit in pairs(units) do
			if unit and unit:HasModifier("modifier_invisible") and not unit:HasModifier("modifier_invisible_truesight_immune") then
				unit:RemoveModifierByName("modifier_invisible")
			end
		end
		elapsed = elapsed + 0.03
		if elapsed < duration then return 0.03 end
	end)
end

-------------------------------------------------
-- ONE modifier: stacks + cooldown ring
-------------------------------------------------

modifier_reveal_area_charges = class({})

function modifier_reveal_area_charges:IsHidden() return false end
function modifier_reveal_area_charges:IsPurgable() return false end
function modifier_reveal_area_charges:IsDebuff() return false end
function modifier_reveal_area_charges:RemoveOnDeath() return false end
function modifier_reveal_area_charges:GetAttributes()
	-- постоянный; не MULTIPLE; duration задаётся только через Remove+Add
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_reveal_area_charges:GetTexture()
	return self:GetAbility():GetAbilityTextureName()
end

function modifier_reveal_area_charges:OnCreated()
	if not IsServer() then return end
	local ability = self:GetAbility()
	if ability and ability._charges then
		self:SetStackCount(ability._charges)
	else
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("maximum_charges"))
	end
end

-- По желанию можно добавить тултип с остатком (чтобы видеть цифрой при наведении):
function modifier_reveal_area_charges:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP }
end
function modifier_reveal_area_charges:OnTooltip()
	-- если у модификатора есть duration, движок отдаст реальный остаток
	local remain = self:GetRemainingTime() or -1
	if remain < 0 then return 0 end
	return math.max(0, math.floor(remain * 10 + 0.5) / 10)
end
