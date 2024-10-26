modifier_antifeed = class({})

function modifier_antifeed:IsHidden()
    return false
end

function modifier_antifeed:IsDebuff()
    return false
end

function modifier_antifeed:GetTexture()
    return "antifeed"
end

function modifier_antifeed:OnCreated( kv )
	if IsServer() then
		self.accumulatedRageDamage = ParticleManager:CreateParticle( "particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8_glyph.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl(self.accumulatedRageDamage, 0, self:GetParent():GetAbsOrigin())
	end
end

function modifier_antifeed:OnDestroy( kv )
	if IsServer() then
		ParticleManager:DestroyParticle(self.accumulatedRageDamage, true)
	end
end