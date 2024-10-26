ability_rocket_flare = class({})
LinkLuaModifier('modifier_ability_rocket_flare_dummy', 'abilities/rattletrap/rocket_flare', LUA_MODIFIER_MOTION_NONE)

function ability_rocket_flare:GetAOERadius() return self:GetSpecialValueFor("radius") end

function OnSpellStart(event)
    local caster = event.ability:GetCaster()
    local targetPos = event.ability:GetCursorPosition()

    local dummy = CreateUnitByName('npc_dummy_unit', targetPos, false, nil, nil, caster:GetTeam())
    dummy:AddNewModifier(caster, event.ability, 'modifier_ability_rocket_flare_dummy', {})
    dummy:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
    local projectile = {
        Target = dummy,
        Source = event.ability:GetCaster(),
        Ability = event.ability,
        EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
        bDodgable = false,
        bProvidesVision = true,
		iVisionRadius = event.ability:GetSpecialValueFor("vision_radius"),
		iVisionTeamNumber = caster:GetTeamNumber(),
        iMoveSpeed = event.ability:GetSpecialValueFor("speed"),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
    }
    ProjectileManager:CreateTrackingProjectile(projectile)
    EmitGlobalSound("Hero_Rattletrap.Rocket_Flare.Fire")
    event.ability.targetpos = targetPos
    event.ability.target = dummy
end

function OnProjectileHit(event)
    DebugPrint("event.ParticleMy")
    
    DebugPrint(event.ParticleMy1)
    DebugPrint(event.articley)
    local caster = event.ability:GetCaster()
    ParticleManager:CreateParticle(event.ParticleMy3, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy1, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy2, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy3, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy1, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy2, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy4, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy5, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy6, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy7, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    ParticleManager:CreateParticle(event.ParticleMy8, DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 , event.ability.target)
    
    local radius = event.ability:GetSpecialValueFor("radius")
    local duration = event.ability:GetSpecialValueFor("duration")
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), event.ability.targetpos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
    EmitGlobalSound("Hero_Rattletrap.Rocket_Flare.Explode")
    Timers:CreateTimer(10, function()
        UTIL_Remove(event.ability.target)
    end)
    for _, enemy in pairs(enemies) do
        ApplyDamage({victim = enemy, attacker = caster, damage = event.ability:GetSpecialValueFor("damage"), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability})
    end
    AddFOWViewer( caster:GetTeamNumber(), event.ability.targetpos, event.ability:GetSpecialValueFor("vision_radius"), event.ability:GetSpecialValueFor("duration"), false ) 
    
end

modifier_ability_rocket_flare_dummy = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return false end,
    CheckState  = function(self)
        return {
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
            [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
            [MODIFIER_STATE_INVULNERABLE] = true,
            [MODIFIER_STATE_UNSELECTABLE] = true,
            [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        }
    end,  
})