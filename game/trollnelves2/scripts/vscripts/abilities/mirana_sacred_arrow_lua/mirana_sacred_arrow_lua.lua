mirana_sacred_arrow_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "abilities/mirana_sacred_arrow_lua/mirana_sacred_arrow_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function OnSpellStart(event)
	-- unit identifier
	local caster = event.ability:GetCaster()
	local origin = caster:GetOrigin()
	local point = event.ability:GetCursorPosition()

	-- load data
	local projectile_name = "particles/snowball_my.vpcf"
	local projectile_speed = event.ability:GetSpecialValueFor("arrow_speed")
	local projectile_distance = event.ability:GetSpecialValueFor("arrow_range")
	local projectile_start_radius = event.ability:GetSpecialValueFor("arrow_width")
	local projectile_end_radius = event.ability:GetSpecialValueFor("arrow_width")
	local projectile_vision = event.ability:GetSpecialValueFor("arrow_vision")

	local min_damage = event.ability:GetAbilityDamage()
	local bonus_damage = event.ability:GetSpecialValueFor( "arrow_bonus_damage" )
	local min_stun = event.ability:GetSpecialValueFor( "arrow_min_stun" )
	local max_stun = event.ability:GetSpecialValueFor( "arrow_max_stun" )
	local max_distance = event.ability:GetSpecialValueFor( "arrow_max_stunrange" )

	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()

	-- logic
	local info = {
		Source = caster,
		Ability = event.ability,
		vSpawnOrigin = caster:GetOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = true,
		bReplaceExisting = true,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),
        
		ExtraData = {
			originX = origin.x,
			originY = origin.y,
			originZ = origin.z,

			max_distance = max_distance,
			min_stun = min_stun,
			max_stun = max_stun,

			min_damage = min_damage,
			bonus_damage = bonus_damage,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)
	-- Effects
	local sound_cast = "Hero_Mirana.ArrowCast"
	EmitSoundOn( sound_cast, caster )
    event.ability.extradata = info.ExtraData
end

--------------------------------------------------------------------------------
-- Projectile
function OnProjectileHit_ExtraData1( event )
    local hTarget = event.target
    local extraData = event.ability.extradata
    local vLocation = hTarget:GetAbsOrigin()
    DebugPrint("1")
	if hTarget==nil then return end
    DebugPrint("2")
	-- calculate distance percentage
	local origin = Vector( extraData.originX, extraData.originY, extraData.originZ )
	local distance = (vLocation-origin):Length2D()
	local bonus_pct = math.min(1,distance/extraData.max_distance)
    
	-- damage
	if (not hTarget:IsConsideredHero()) and (not hTarget:IsAncient()) and (not hTarget:IsMagicImmune()) and (hTarget:IsHero()) then
		local damageTable = {
			victim = hTarget,
			attacker = event.ability:GetCaster(),
			damage = hTarget:GetHealth() + 1,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = event.ability, --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
		}
        ParticleManager:CreateParticle("particles/econ/events/snowball/snowball_projectile_explosion.vpcf", PATTACH_POINT  , hTarget)
		ApplyDamage(damageTable)
		return true
	end

	local damageTable = {
		victim = hTarget,
		attacker = event.ability:GetCaster(),
		damage = extraData.min_damage + extraData.bonus_damage*bonus_pct,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = event.ability, --Optional.
	}
	if hTarget:IsHero() then
		ApplyDamage(damageTable)
	end
	-- stun
	hTarget:AddNewModifier(
		event.ability:GetCaster(), -- player source
		event.ability, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = math.max(extraData.min_stun, extraData.max_stun*bonus_pct) } -- kv
	)

	AddFOWViewer( event.ability:GetCaster():GetTeamNumber(), vLocation, 500, 3, false )

	-- effects
	local sound_cast = "Hero_Mirana.ArrowImpact"
	EmitSoundOn( sound_cast, hTarget )

	return true
end

modifier_generic_stunned_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_stunned_lua:IsDebuff()
	return true
end

function modifier_generic_stunned_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_stunned_lua:OnCreated( kv )
	if not IsServer() then return end

	self.particle = "particles/generic_gameplay/generic_stunned.vpcf"
	if kv.bash==1 then
		self.particle = "particles/generic_gameplay/generic_bashed.vpcf"
	end


	-- calculate status resistance
	local resist = 1-self:GetParent():GetStatusResistance()
	local duration = kv.duration*resist
	self:SetDuration( duration, true )
end

function modifier_generic_stunned_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_generic_stunned_lua:OnRemoved()
end

function modifier_generic_stunned_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_generic_stunned_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_stunned_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_generic_stunned_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_generic_stunned_lua:GetEffectName()
	return self.particle
end

function modifier_generic_stunned_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end