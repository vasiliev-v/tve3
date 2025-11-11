vengefulspirit_wave_of_terror_datadriven = class({})

LinkLuaModifier("modifier_wave_of_terror_datadriven", "heroes/hero_vengefulspirit/wave_of_terror.lua", LUA_MODIFIER_MOTION_NONE)

function vengefulspirit_wave_of_terror_datadriven:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local caster_location = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()
	local forward = (target_point - caster_location):Normalized()

	local wave_speed = self:GetSpecialValueFor("wave_speed")
	local wave_width = self:GetSpecialValueFor("wave_width")
	local wave_range = self:GetSpecialValueFor("wave_range")
	local vision_aoe = self:GetSpecialValueFor("vision_aoe")
	local vision_duration = self:GetSpecialValueFor("vision_duration")

	EmitSoundOn("Hero_VengefulSpirit.WaveOfTerror", caster)

	local info = {
		EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
		Ability = self,
		vSpawnOrigin = caster_location,
		vVelocity = Vector(forward.x * wave_speed, forward.y * wave_speed, 0),
		fDistance = wave_range,
		fStartRadius = wave_width,
		fEndRadius = wave_width,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}
	ProjectileManager:CreateLinearProjectile(info)

	local wave_location = Vector(caster_location.x, caster_location.y, caster_location.z)
	local traveled = 0
	local step = wave_speed * (1/30)
	Timers:CreateTimer(function()
		wave_location = wave_location + forward * step
		traveled = traveled + step
		AddFOWViewer(caster:GetTeamNumber(), wave_location, vision_aoe, vision_duration, false)
		if traveled >= wave_range then
			return nil
		else
			return 1/30
		end
	end)
end

function vengefulspirit_wave_of_terror_datadriven:OnProjectileHit(target, location)
	if not IsServer() then return end
	if not target then return true end
	local duration = self:GetSpecialValueFor("tooltip_duration")
	target:AddNewModifier(self:GetCaster(), self, "modifier_wave_of_terror_datadriven", {duration = duration})
	local damage = self:GetAbilityDamage() or 0
	ApplyDamage({
		victim = target,
		attacker = self:GetCaster(),
		ability = self,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
	})
	return false
end

modifier_wave_of_terror_datadriven = class({})

function modifier_wave_of_terror_datadriven:IsHidden() return false end
function modifier_wave_of_terror_datadriven:IsDebuff() return true end
function modifier_wave_of_terror_datadriven:IsPurgable() return true end
function modifier_wave_of_terror_datadriven:GetEffectName() return "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror_recipient.vpcf" end
function modifier_wave_of_terror_datadriven:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_wave_of_terror_datadriven:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_wave_of_terror_datadriven:GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then return 0 end
	return self:GetAbility():GetSpecialValueFor("armor_reduction")
end
