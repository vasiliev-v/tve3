furion_teleportation_datadriven = class({})

LinkLuaModifier("modifier_teleportation", "heroes/hero_furion/teleportation.lua", LUA_MODIFIER_MOTION_NONE)

function furion_teleportation_datadriven:OnAbilityPhaseStart()
	if not IsServer() then return true end
	local caster = self:GetCaster()
	self._tp_point = self:GetCursorPosition()

	caster:AddNewModifier(caster, self, "modifier_teleportation", {duration = self:GetCastPoint()})

	EmitSoundOn("Hero_Furion.Teleport_Grow", caster)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_teleport_end.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(p, 1, self._tp_point)
	caster._furion_tp_end = p

	return true
end

function furion_teleportation_datadriven:OnAbilityPhaseInterrupted()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if caster._furion_tp_end then
		ParticleManager:DestroyParticle(caster._furion_tp_end, false)
		ParticleManager:ReleaseParticleIndex(caster._furion_tp_end)
		caster._furion_tp_end = nil
	end
	caster:StopSound("Hero_Furion.Teleport_Grow")
	caster:RemoveModifierByName("modifier_teleportation")
end

function furion_teleportation_datadriven:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self._tp_point or self:GetCursorPosition()

	EmitSoundOn("Hero_Furion.Teleport_Disappear", caster)

	FindClearSpaceForUnit(caster, point, true)
	caster:Stop()

	if caster._furion_tp_end then
		ParticleManager:DestroyParticle(caster._furion_tp_end, false)
		ParticleManager:ReleaseParticleIndex(caster._furion_tp_end)
		caster._furion_tp_end = nil
	end
	caster:StopSound("Hero_Furion.Teleport_Grow")

	EmitSoundOn("Hero_Furion.Teleport_Appear", caster)
end

modifier_teleportation = class({})

function modifier_teleportation:IsHidden() return false end
function modifier_teleportation:IsPurgable() return false end
function modifier_teleportation:GetEffectName() return "particles/units/heroes/hero_furion/furion_teleport.vpcf" end
function modifier_teleportation:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_teleportation:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ORDER }
end

function modifier_teleportation:OnOrder(event)
	if not IsServer() then return end
	if event.unit ~= self:GetParent() then return end

	local parent = self:GetParent()
	EmitSoundOn("Hero_Furion.Teleport_Disappear", parent)

	if parent._furion_tp_end then
		ParticleManager:DestroyParticle(parent._furion_tp_end, false)
		ParticleManager:ReleaseParticleIndex(parent._furion_tp_end)
		parent._furion_tp_end = nil
	end
	parent:StopSound("Hero_Furion.Teleport_Grow")

	parent:Interrupt()
	self:Destroy()
end
