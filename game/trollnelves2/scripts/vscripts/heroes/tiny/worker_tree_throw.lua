LinkLuaModifier("modifier_worker_tree_throw_slow", "heroes/tiny/worker_tree_throw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_worker_tree_dummy", "heroes/tiny/worker_tree_throw", LUA_MODIFIER_MOTION_NONE)

worker_tree_throw = class({})

function worker_tree_throw:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function worker_tree_throw:Precache(context)
	PrecacheModel("models/heroes/tiny_01/tiny_tree_proj.vmdl", context)
	PrecacheResource("particle", "particles/units/heroes/hero_tiny/tiny_toss_impact.vpcf", context)
	PrecacheResource("particle", "particles/generic_gameplay/generic_slowed_cold.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context)
end

function worker_tree_throw:OnSpellStart()
	local caster = self:GetCaster()
	local target_pos = self:GetCursorPosition()
	local start_pos = caster:GetAbsOrigin() + Vector(0, 0, 100)

	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local slow_duration = self:GetSpecialValueFor("slow_duration")
	local speed = self:GetSpecialValueFor("speed")
	if speed <= 0 then speed = 1200 end
	local arc_height = self:GetSpecialValueFor("arc_height")
	if arc_height <= 0 then arc_height = 350 end

	local distance = (target_pos - start_pos):Length2D()
	local total_time = math.max(0.1, distance / speed)

	-- Sound on throw
	EmitSoundOnLocationWithCaster(start_pos, "Hero_Tiny.Tree.Cast", caster)

	-- Create dummy projectile model
	local dummy = CreateUnitByName("npc_dummy_unit", start_pos, false, caster, caster, caster:GetTeamNumber())
	if not dummy then return end

	dummy:SetOriginalModel("models/heroes/tiny_01/tiny_tree_proj.vmdl")
	dummy:SetModel("models/heroes/tiny_01/tiny_tree_proj.vmdl")
	dummy:SetModelScale(1.0)
	dummy:AddNewModifier(caster, self, "modifier_worker_tree_dummy", {})

	local elapsed_time = 0
	local interval = 0.03
	local ground_z_start = GetGroundHeight(start_pos, nil)
	local ground_z_target = GetGroundHeight(target_pos, nil)

	Timers:CreateTimer(function()
		if not IsValidEntity(dummy) or not dummy:IsAlive() then
			return nil
		end

		elapsed_time = elapsed_time + interval
		local progress = elapsed_time / total_time

		if progress >= 1.0 then
			-- Impact
			dummy:SetAbsOrigin(target_pos)
			dummy:ForceKill(false)
			dummy:AddNoDraw()

			-- Sound & Particle
			EmitSoundOnLocationWithCaster(target_pos, "Hero_Tiny.Tree.Target", caster)
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_toss_impact.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(p, 0, target_pos)
			ParticleManager:ReleaseParticleIndex(p)

			-- Damage and Slow
			local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),
				target_pos,
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
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}

			for _, enemy in pairs(enemies) do
				if IsValidEntity(enemy) and enemy:IsAlive() and not enemy:IsMagicImmune() then
					damageTable.victim = enemy
					ApplyDamage(damageTable)
					enemy:AddNewModifier(caster, self, "modifier_worker_tree_throw_slow", { duration = slow_duration })
				end
			end

			return nil
		end

		-- Ballistic arc formula: z = 4 * h * p * (1 - p)
		local current_pos_2d = start_pos + (target_pos - start_pos) * progress
		local ground_z = ground_z_start + (ground_z_target - ground_z_start) * progress
		local height = 4 * arc_height * progress * (1 - progress)
		local current_pos = Vector(current_pos_2d.x, current_pos_2d.y, ground_z + height)

		dummy:SetAbsOrigin(current_pos)

		-- Rotation during flight
		local angles = dummy:GetAnglesAsVector()
		dummy:SetAngles(angles.x + 20, angles.y + 15, 0)

		return interval
	end)
end

--------------------------------------------------------------------------------
-- Dummy Invulnerability Modifier
--------------------------------------------------------------------------------
modifier_worker_tree_dummy = class({})

function modifier_worker_tree_dummy:IsHidden() return true end
function modifier_worker_tree_dummy:IsPurgable() return false end

function modifier_worker_tree_dummy:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FLYING] = true,
	}
end

--------------------------------------------------------------------------------
-- Slow Modifier
--------------------------------------------------------------------------------
modifier_worker_tree_throw_slow = class({})

function modifier_worker_tree_throw_slow:IsHidden() return false end
function modifier_worker_tree_throw_slow:IsDebuff() return true end
function modifier_worker_tree_throw_slow:IsPurgable() return true end

function modifier_worker_tree_throw_slow:OnCreated(kv)
	local ability = self:GetAbility()
	self.ms_slow = ability and ability:GetSpecialValueFor("movespeed_slow") or -75
end

function modifier_worker_tree_throw_slow:OnRefresh(kv)
	self:OnCreated(kv)
end

function modifier_worker_tree_throw_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_worker_tree_throw_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_worker_tree_throw_slow:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_worker_tree_throw_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
