LinkLuaModifier("modifier_skill_troll_crit", "modifiers/modifier_skill_troll_crit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_crit_aura", "modifiers/modifier_skill_troll_crit.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_crit = class({})

--------------------------------------------------------------------------------

function  modifier_skill_troll_crit:IsHidden()
    return false
end

function  modifier_skill_troll_crit:IsPurgable()
    return false
end

function  modifier_skill_troll_crit:IsStackable()
    return true
end

function  modifier_skill_troll_crit:IsPermanent()
	return false
end

function modifier_skill_troll_crit:GetTexture()
    return "skeleton_thief_obsession"
end
--------------------------------------------------------------------------------
 modifier_skill_troll_crit_aura = class({})

function  modifier_skill_troll_crit_aura:IsHidden()
    return false
end
function modifier_skill_troll_crit_aura:GetTexture()
    return "skeleton_thief_obsession"
end

function  modifier_skill_troll_crit_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_crit_aura:IsPermanent()
	return false
end

function  modifier_skill_troll_crit_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_skill_troll_crit_aura:GetModifierPreAttack_CriticalStrike(params)
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if self:GetParent():PassivesDisabled() then
			return 0.0
		end

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if self.pseudo:Trigger() then -- expose RollPseudoRandomPercentage?
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

function modifier_skill_troll_crit_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self.crit_chance = 13
		self.crit_multiplier = 1 * countStack
		self:SetStackCount(countStack)
		self.pseudo = PseudoRandom:New(13*0.01)
		self.bIsCrit = false
	end
end

function modifier_skill_troll_crit_aura:OnRefresh( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local countStack = caster:FindModifierByName("modifier_skill_troll_crit_aura"):GetStackCount()
		self:SetStackCount(countStack)
		self.crit_multiplier = 1 * countStack
		self.pseudo = PseudoRandom:New(13*0.01)
		self.bIsCrit = false
	end
end

function modifier_skill_troll_crit_aura:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.bIsCrit then
				EmitSoundOn( "DOTA_Item.Daedelus.Crit", self:GetParent() )
				self.bIsCrit = false
			end
		end
	end

	return 0.0
end

