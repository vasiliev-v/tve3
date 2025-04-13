elf_spell_smoke = class({})

--------------------------------------------------------------------------------
-- Ability Start
function elf_spell_smoke:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local buffDuration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local targets = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local buffDurationCreep = self:GetSpecialValueFor("duration_creep")

	-- Find Units in Radius
	local allies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		targets,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,ally in pairs(allies) do
		-- Add modifier
		if ally:IsHero() then
			ally:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_smoke_of_deceit", -- modifier name
				{ duration = buffDuration } -- kv
			)
	    else
			ally:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_smoke_of_deceit", -- modifier name
				{ duration = buffDurationCreep } -- kv
			)
		end
		local effect_cast = ParticleManager:CreateParticle( "particles/items2_fx/smoke_of_deceit.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			5,
			ally,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			ally:GetOrigin(), -- unknown
			true -- unknown, true
		)
	
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	-- Play Effects
	local sound_cast = "DOTA_Item.SmokeOfDeceit.Activate"
	EmitSoundOn( sound_cast, caster )
end