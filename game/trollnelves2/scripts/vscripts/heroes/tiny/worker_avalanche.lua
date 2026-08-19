worker_avalanche = class({})

function worker_avalanche:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function worker_avalanche:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_tiny/tiny_avalanche_projectile_explode.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context)
end

function worker_avalanche:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local total_damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	local tick_count = self:GetSpecialValueFor("tick_count")
	if tick_count <= 0 then tick_count = 5 end
	local tick_interval = self:GetSpecialValueFor("tick_interval")
	if tick_interval <= 0 then tick_interval = duration / tick_count end
	local damage_per_tick = total_damage / tick_count
	local stun_per_tick = tick_interval * 1.5

	-- Sound
	EmitSoundOnLocationWithCaster(point, "Ability.Avalanche", caster)

	-- Initial explosion burst
	for i = 1, 3 do
		local hit_loc = point + RandomVector(RandomFloat(0, radius))
		hit_loc.z = GetGroundHeight(hit_loc, nil)
		local p_exp = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche_projectile_explode.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(p_exp, 0, hit_loc)
		ParticleManager:ReleaseParticleIndex(p_exp)
	end

	-- Ticks
	local current_tick = 0
	Timers:CreateTimer(function()
		current_tick = current_tick + 1

		-- Explode particles in area on each tick
		for i = 1, 3 do
			local hit_loc = point + RandomVector(RandomFloat(0, radius))
			hit_loc.z = GetGroundHeight(hit_loc, nil)
			local p_exp = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche_projectile_explode.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(p_exp, 0, hit_loc)
			ParticleManager:ReleaseParticleIndex(p_exp)
		end

		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			point,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			0,
			0,
			false
		)

		local damageTable = {
			attacker = caster,
			damage = damage_per_tick,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		for _, enemy in pairs(enemies) do
			if IsValidEntity(enemy) and enemy:IsAlive() and not enemy:IsMagicImmune() then
				damageTable.victim = enemy
				ApplyDamage(damageTable)
				enemy:AddNewModifier(caster, self, "modifier_stunned", { duration = stun_per_tick })
			end
		end

		if current_tick < tick_count then
			return tick_interval
		end
		return nil
	end)
end
