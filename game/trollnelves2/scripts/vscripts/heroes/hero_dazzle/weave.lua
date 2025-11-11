weave_datadriven = class({})

LinkLuaModifier("modifier_weave_friendly_datadriven", "heroes/hero_dazzle/weave.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_weave_enemy_datadriven",    "heroes/hero_dazzle/weave.lua", LUA_MODIFIER_MOTION_NONE)

function weave_datadriven:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local vision = self:GetSpecialValueFor("vision")
	local vision_duration = self:GetSpecialValueFor("vision_duration")
	local friendly_per_sec = self:GetSpecialValueFor("armor_per_second")
	local enemy_per_sec = self:GetSpecialValueFor("negative_armor_per_second")

	if caster:HasScepter() then
		radius = self:GetSpecialValueFor("radius_scepter")
		duration = self:GetSpecialValueFor("duration_scepter")
		friendly_per_sec = self:GetSpecialValueFor("armor_per_second_scepter")
	end

	EmitSoundOn("Hero_Dazzle.Weave", caster)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_weave.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(p, 0, point)
	ParticleManager:SetParticleControl(p, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(p)

	AddFOWViewer(caster:GetTeamNumber(), point, vision, vision_duration, true)

	local allies = FindUnitsInRadius(
		caster:GetTeamNumber(), point, nil, radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false
	)
	for _,unit in pairs(allies) do
		if unit and not unit:IsNull() then
			unit:AddNewModifier(caster, self, "modifier_weave_friendly_datadriven", {duration = duration, armor_per_sec = friendly_per_sec})
		end
	end

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(), point, nil, radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false
	)
	for _,unit in pairs(enemies) do
		if unit and not unit:IsNull() then
			unit:AddNewModifier(caster, self, "modifier_weave_enemy_datadriven", {duration = duration, armor_per_sec = enemy_per_sec})
		end
	end
end

modifier_weave_friendly_datadriven = class({})

function modifier_weave_friendly_datadriven:IsPurgable() return true end
function modifier_weave_friendly_datadriven:IsDebuff() return false end
function modifier_weave_friendly_datadriven:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_weave_friendly_datadriven:OnCreated(kv)
	self.per_sec = tonumber(kv.armor_per_sec) or (self:GetAbility() and self:GetAbility():GetSpecialValueFor("armor_per_second")) or 0
	self.tick = (self:GetAbility() and self:GetAbility():GetSpecialValueFor("tick_interval")) or 1.0
	if IsServer() then
		self:SetStackCount(0)
		self.p = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.p, 1, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_overhead", self:GetParent():GetAbsOrigin(), true)
		self:StartIntervalThink(self.tick)
	end
end

function modifier_weave_friendly_datadriven:OnRefresh(kv)
	self.per_sec = tonumber(kv.armor_per_sec) or (self:GetAbility() and self:GetAbility():GetSpecialValueFor("armor_per_second")) or self.per_sec or 0
	self.tick = (self:GetAbility() and self:GetAbility():GetSpecialValueFor("tick_interval")) or self.tick or 1.0
	if IsServer() then
		self:StartIntervalThink(self.tick)
	end
end

function modifier_weave_friendly_datadriven:OnIntervalThink()
	self:SetStackCount(self:GetStackCount() + 1)
end

function modifier_weave_friendly_datadriven:OnDestroy()
	if IsServer() and self.p then
		ParticleManager:DestroyParticle(self.p, false)
		ParticleManager:ReleaseParticleIndex(self.p)
	end
end

function modifier_weave_friendly_datadriven:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_weave_friendly_datadriven:GetModifierPhysicalArmorBonus()
	local per = self.per_sec or 0
	return self:GetStackCount() * per
end

modifier_weave_enemy_datadriven = class({})

function modifier_weave_enemy_datadriven:IsPurgable() return true end
function modifier_weave_enemy_datadriven:IsDebuff() return true end
function modifier_weave_enemy_datadriven:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_weave_enemy_datadriven:OnCreated(kv)
	self.per_sec = tonumber(kv.armor_per_sec) or (self:GetAbility() and self:GetAbility():GetSpecialValueFor("negative_armor_per_second")) or 0
	self.tick = (self:GetAbility() and self:GetAbility():GetSpecialValueFor("tick_interval")) or 1.0
	if IsServer() then
		self:SetStackCount(0)
		self.p = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.p, 1, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_overhead", self:GetParent():GetAbsOrigin(), true)
		self:StartIntervalThink(self.tick)
	end
end

function modifier_weave_enemy_datadriven:OnRefresh(kv)
	self.per_sec = tonumber(kv.armor_per_sec) or (self:GetAbility() and self:GetAbility():GetSpecialValueFor("negative_armor_per_second")) or self.per_sec or 0
	self.tick = (self:GetAbility() and self:GetAbility():GetSpecialValueFor("tick_interval")) or self.tick or 1.0
	if IsServer() then
		self:StartIntervalThink(self.tick)
	end
end

function modifier_weave_enemy_datadriven:OnIntervalThink()
	self:SetStackCount(self:GetStackCount() + 1)
end

function modifier_weave_enemy_datadriven:OnDestroy()
	if IsServer() and self.p then
		ParticleManager:DestroyParticle(self.p, false)
		ParticleManager:ReleaseParticleIndex(self.p)
	end
end

function modifier_weave_enemy_datadriven:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_weave_enemy_datadriven:GetModifierPhysicalArmorBonus()
	local per = self.per_sec or 0
	return self:GetStackCount() * per
end
