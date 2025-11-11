elf_spell_teleport_x4 = class({})

LinkLuaModifier("modifier_teleportation", "heroes/hero_furion/elf_spell_teleport_x4.lua", LUA_MODIFIER_MOTION_NONE)

function elf_spell_teleport_x4:OnAbilityPhaseStart()
	if not IsServer() then return true end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if not target or target:IsNull() then return false end
	self._tp_point = target:GetAbsOrigin()
	caster:AddNewModifier(caster, self, "modifier_teleportation", {duration = self:GetCastPoint()})
	EmitSoundOn("Hero_Furion.Teleport_Grow", caster)
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_teleport_end.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(p, 1, self._tp_point)
	caster._elfx4_tp_end = p
	return true
end

function elf_spell_teleport_x4:OnAbilityPhaseInterrupted()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if caster._elfx4_tp_end then
		ParticleManager:DestroyParticle(caster._elfx4_tp_end, false)
		ParticleManager:ReleaseParticleIndex(caster._elfx4_tp_end)
		caster._elfx4_tp_end = nil
	end
	caster:StopSound("Hero_Furion.Teleport_Grow")
	caster:RemoveModifierByName("modifier_teleportation")
end

function elf_spell_teleport_x4:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self._tp_point or (target and target:GetAbsOrigin()) or caster:GetAbsOrigin()
	EmitSoundOn("Hero_Furion.Teleport_Disappear", caster)
	FindClearSpaceForUnit(caster, point, true)
	caster:Stop()
	if caster._elfx4_tp_end then
		ParticleManager:DestroyParticle(caster._elfx4_tp_end, false)
		ParticleManager:ReleaseParticleIndex(caster._elfx4_tp_end)
		caster._elfx4_tp_end = nil
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
	if parent._elfx4_tp_end then
		ParticleManager:DestroyParticle(parent._elfx4_tp_end, false)
		ParticleManager:ReleaseParticleIndex(parent._elfx4_tp_end)
		parent._elfx4_tp_end = nil
	end
	parent:StopSound("Hero_Furion.Teleport_Grow")
	parent:Interrupt()
	self:Destroy()
end
