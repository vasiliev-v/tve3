ability_cinder_brew = class({})
LinkLuaModifier('modifier_ability_cinder_brew_debuff', 'abilities/brewmaster/cinder_brew', LUA_MODIFIER_MOTION_NONE)

function OnSpellStart(event)
    
    event.ability:GetCaster():EmitSound("Hero_Brewmaster.CinderBrew.Cast")

    local vPoint = event.ability:GetCursorPosition()
    local hCaster = event.ability:GetCaster()

    local brew_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.ability:GetCaster())
	ParticleManager:SetParticleControl(brew_particle, 1, vPoint)
    ParticleManager:ReleaseParticleIndex(brew_particle)
    -- DOTA IMBA: https://github.com/EarthSalamander42/dota_imba/blob/master/game/dota_addons/dota_imba_reborn/scripts/vscripts/components/abilities/heroes/hero_brewmaster.lua
    ProjectileManager:CreateLinearProjectile({
		EffectName	= "",
		Ability		= self,
		Source		= event.ability:GetCaster(),
		vSpawnOrigin	= event.ability:GetCaster():GetAbsOrigin(),
		vVelocity	= ((event.ability:GetCursorPosition() - event.ability:GetCaster():GetAbsOrigin()) * Vector(1, 1, 0)):Normalized() * 1600,
		vAcceleration	= nil, --hmm...
		fMaxSpeed	= nil, -- What's the default on this thing?
		fDistance	= (event.ability:GetCursorPosition() - event.ability:GetCaster():GetAbsOrigin()):Length2D(),
		fStartRadius	= 0,
		fEndRadius		= 0,
		fExpireTime		= nil,
		iUnitTargetTeam	= DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bIgnoreSource		= true,
		bHasFrontalCone		= false,
		bDrawsOnMinimap		= false,
		bVisibleToEnemies	= true,
		bProvidesVision		= false,
		iVisionRadius		= nil,
		iVisionTeamNumber	= nil,
		ExtraData			= {},
	})
    event.ability.vlocation = vPoint
end

function OnProjectileHit(event)
    local vLocation = event.ability.vlocation
    local units = FindUnitsInRadius(event.ability:GetCaster():GetTeam(), 
    vLocation, 
    nil, 
    event.ability:GetSpecialValueFor('radius'),
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    event.ability:GetAbilityTargetFlags(), 
    FIND_ANY_ORDER, 
    false)
    local duration = event.ability:GetSpecialValueFor('duration')
    local total_damage = event.ability:GetSpecialValueFor('total_damage')
    local extra_duration = event.ability:GetSpecialValueFor('extra_duration')
    for k,v in pairs(units) do 
        v:AddNewModifier(event.ability:GetCaster(), self, 'modifier_ability_cinder_brew_debuff', {
            duration = duration,
            total_damage = total_damage,
            extra_duration = extra_duration
        })
    end 

end 


modifier_ability_cinder_brew_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    AllowIllusionDuplicate  = function(self) return true end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_debuff.vpcf" end,
    GetStatusEffectName     = function(self) return "particles/status_fx/status_effect_brewmaster_cinder_brew.vpcf" end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_EVENT_ON_TAKEDAMAGE} end,
    GetModifierMoveSpeedBonus_Percentage = function(self) return self.movespeed end,
})

function modifier_ability_cinder_brew_debuff:OnCreated(data)
    self.movespeed  = -event.ability:GetAbility():GetSpecialValueFor('movement_slow')
    self.totaldamage = data.total_damage
    self.extra_duration = data.extra_duration
end 

function modifier_ability_cinder_brew_debuff:OnIntervalThink()
    -- dota imba 
    ApplyDamage({
		victim 			= event.ability:GetParent(),
		damage 			= self.damage_per_instance,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= event.ability:GetCaster(),
		ability 		= event.ability:GetAbility()
	})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, event.ability:GetParent(), self.damage_per_instance, nil)
end

function modifier_ability_cinder_brew_debuff:OnTakeDamage(keys)
	if keys.unit == event.ability:GetParent() and not self.bIgnited and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		self.bIgnited = true
	
		event.ability:GetParent():EmitSound("Hero_BrewMaster.CinderBrew.Ignite")
        local newDuration = event.ability:GetRemainingTime() + self.extra_duration
		local burn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_crit.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.ability:GetParent())
		event.ability:AddParticle(burn_particle, false, false, -1, false, false)
		event.ability:SetDuration(newDuration, true)
		
		self.damage_per_instance	= self.totaldamage / 8
		self.tick_interval			= newDuration / 8 
		event.ability:StartIntervalThink(self.tick_interval)
	end
end