reveal_area = class({})
LinkLuaModifier("modifier_reveal_area_charges", "abilities\\reveal_area.lua", LUA_MODIFIER_MOTION_NONE)

function reveal_area:GetIntrinsicModifierName()
	return "modifier_reveal_area_charges"
end

function reveal_area:OnUpgrade()
	if not IsServer() then return end
	if self:GetLevel() ~= 1 then return end

	local caster = self:GetCaster()
	local max_charges = self:GetSpecialValueFor("maximum_charges")
	local modifier = caster:AddNewModifier(caster, self, "modifier_reveal_area_charges", {})
	if modifier then
		modifier:SetStackCount(max_charges)
	end

	self._charges = max_charges
	self._start_charge = false
	self._cooldown_left = 0.0

	if caster.first == nil then
		caster.first = true
	end

	if caster:GetUnitName() == "npc_dota_hero_bear" and caster.first then
		caster.first = false
		return
	end

	Timers:CreateTimer(function()
		if not caster or caster:IsNull() then return 0.5 end

		local cd_red = caster:GetCooldownReduction()
		if caster:GetUnitName() == "npc_dota_hero_bear" then
			local hero = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())
			if hero then cd_red = hero:GetCooldownReduction() end
		end

		local max_ch = self:GetSpecialValueFor("maximum_charges")
		if caster:HasModifier("modifier_troll_spell_reveal") then
			local s = caster:FindModifierByName("modifier_troll_spell_reveal"):GetStackCount()
			if s == 1 then max_ch = 3
			elseif s == 2 then max_ch = 4
			elseif s >= 3 then max_ch = 5 end
		end

		if not self._charges then self._charges = max_ch end

		local base_replenish = self:GetSpecialValueFor("charge_replenish_time")
		local replenish_time = base_replenish * cd_red

		if self._start_charge and self._charges < max_ch then
			local next_charge = self._charges + 1
			local mod = caster:FindModifierByName("modifier_reveal_area_charges")
			if next_charge ~= max_ch then
				if mod then mod:SetDuration(replenish_time, true) end
				self:_startCooldownTick(replenish_time, caster)
			else
				if mod then mod:SetDuration(-1, true) end
				self._start_charge = false
			end
			if mod then mod:SetStackCount(next_charge) end
			self._charges = next_charge
		end

		if self._charges ~= max_ch then
			self._start_charge = true
			return replenish_time
		else
			return 0.5
		end
	end)
end

function reveal_area:_startCooldownTick(replenish_time, caster)
	self._cooldown_left = replenish_time
	Timers:CreateTimer(function()
		self._cooldown_left = self._cooldown_left - 0.1
		if self._cooldown_left > 0.1 then
			return 0.1
		end
	end)
end

function reveal_area:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	if not self._charges or self._charges <= 0 then return end

	local max_charges = self:GetSpecialValueFor("maximum_charges")
	if caster:HasModifier("modifier_troll_spell_reveal") then
		local s = caster:FindModifierByName("modifier_troll_spell_reveal"):GetStackCount()
		if s == 1 then max_charges = 3
		elseif s == 2 then max_charges = 4
		elseif s >= 3 then max_charges = 5 end
	end

	local cd_red = caster:GetCooldownReduction()
	if caster:GetUnitName() == "npc_dota_hero_bear" then
		local hero = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())
		if hero then cd_red = hero:GetCooldownReduction() end
	end

	local base_replenish = self:GetSpecialValueFor("charge_replenish_time")
	local replenish_time = base_replenish * cd_red

	local no_deplete = caster:HasModifier("modifier_troll_warlord_presence") or caster:HasModifier("modifier_troll_boots_3")
	local next_charge = no_deplete and self._charges or (self._charges - 1)

	if self._charges == max_charges then
		local mod = caster:FindModifierByName("modifier_reveal_area_charges")
		if mod then mod:SetDuration(replenish_time, true) end
		self:_startCooldownTick(replenish_time, caster)
	end

	local mod = caster:FindModifierByName("modifier_reveal_area_charges")
	if mod then mod:SetStackCount(next_charge) end
	self._charges = next_charge

	if self._charges == 0 then
		self:StartCooldown(self._cooldown_left)
	else
		self:EndCooldown()
	end

	self:_reveal(point)
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
		if s == 1 then radius = radius + 150
		elseif s == 2 then radius = radius + 225
		elseif s >= 3 then radius = radius + 300 end
	end

	if caster:HasModifier("modifier_troll_spell_vision_x4") then
		local s = caster:FindModifierByName("modifier_troll_spell_vision_x4"):GetStackCount()
		if s == 1 then radius = radius + 150
		elseif s == 2 then radius = radius + 225
		elseif s >= 3 then radius = radius + 300 end
	end

	return self:_scaledRadius(radius)
end

function reveal_area:_reveal(point)
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:_getRadius()

	EmitSoundOn("Hero_Silencer.Curse.Cast", caster)
	EmitSoundOnLocationWithCaster(point, "hero_bloodseeker.bloodRite", caster)

	local p = ParticleManager:CreateParticle("particles/scan_particle.vpcf", PATTACH_WORLDORIGIN, nil)
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
		if elapsed < duration then
			return 0.03
		end
	end)
end

modifier_reveal_area_charges = class({})

function modifier_reveal_area_charges:IsHidden() return false end
function modifier_reveal_area_charges:IsPurgable() return false end
function modifier_reveal_area_charges:IsDebuff() return false end
function modifier_reveal_area_charges:RemoveOnDeath() return false end
function modifier_reveal_area_charges:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
