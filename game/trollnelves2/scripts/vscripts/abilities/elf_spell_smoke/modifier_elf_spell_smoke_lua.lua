modifier_elf_spell_smoke_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_elf_spell_smoke_lua:IsHidden()
	return false
end

function modifier_elf_spell_smoke_lua:IsDebuff()
	return false
end

function modifier_elf_spell_smoke_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_elf_spell_smoke_lua:OnCreated( kv )
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_elf_spell_smoke_lua:OnRefresh( kv )
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_elf_spell_smoke_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_elf_spell_smoke_lua:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_elf_spell_smoke_lua:GetEffectName()
-- 	if self:GetParent()~=self:GetCaster() then
-- 		return "particles/units/heroes/hero_omniknight/elf_spell_smoke_ally.vpcf"
-- 	end
-- end

-- function modifier_elf_spell_smoke_lua:GetEffectAttachType()
-- 	if self:GetParent()~=self:GetCaster() then
-- 		return PATTACH_ABSORIGIN_FOLLOW
-- 	end
-- end

function modifier_elf_spell_smoke_lua:PlayEffects()

	local particle_cast = "particles/items2_fx/smoke_of_deceit.vpcf"
	if self:GetParent()==self:GetCaster() then
		particle_cast = "particles/items2_fx/smoke_of_deceit.vpcf"
	end

	-- create particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)

	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end