LinkLuaModifier("modifier_skill_troll_lifesteal", "modifiers/modifier_skill_troll_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_lifesteal_aura", "modifiers/modifier_skill_troll_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_lifesteal = class({})

--------------------------------------------------------------------------------

function  modifier_skill_troll_lifesteal:IsHidden()
    return false
end

function  modifier_skill_troll_lifesteal:IsPurgable()
    return false
end

function  modifier_skill_troll_lifesteal:IsStackable()
    return true
end

function  modifier_skill_troll_lifesteal:IsPermanent()
	return false
end
function modifier_skill_troll_lifesteal:GetTexture()
    return "vampire_life_drain"
end


--------------------------------------------------------------------------------
 modifier_skill_troll_lifesteal_aura = class({})

function  modifier_skill_troll_lifesteal_aura:IsHidden()
    return false
end
function modifier_skill_troll_lifesteal_aura:GetTexture()
    return "vampire_life_drain"
end


function  modifier_skill_troll_lifesteal_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_lifesteal_aura:IsPermanent()
	return false
end

function  modifier_skill_troll_lifesteal_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end

function modifier_skill_troll_lifesteal_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end

function modifier_skill_troll_lifesteal_aura:OnRefresh( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local countStack = caster:FindModifierByName("modifier_skill_troll_lifesteal_aura"):GetStackCount()
		self:SetStackCount(countStack)
	end
end

function modifier_skill_troll_lifesteal_aura:OnTakeDamage(params)
    if not IsServer() then return end
    if self:GetParent() ~= params.attacker then return end
    if self:GetParent() == params.unit then return end
	local heal = self:GetStackCount() / 100 * params.damage
	self:GetParent():Heal(heal, nil)
	local effect_cast = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
