LinkLuaModifier("modifier_skill_troll_damage", "modifiers/modifier_skill_troll_damage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_damage_aura", "modifiers/modifier_skill_troll_damage.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_damage = class({})

--------------------------------------------------------------------------------

function  modifier_skill_troll_damage:IsHidden()
    return false
end

function  modifier_skill_troll_damage:IsPurgable()
    return false
end

function  modifier_skill_troll_damage:IsStackable()
    return true
end

function  modifier_skill_troll_damage:IsPermanent()
	return false
end

function modifier_skill_troll_damage:GetTexture()
    return "item_dmg_12"
end
--------------------------------------------------------------------------------
 modifier_skill_troll_damage_aura = class({})

function  modifier_skill_troll_damage_aura:IsHidden()
    return false
end
function modifier_skill_troll_damage_aura:GetTexture()
    return "item_dmg_12"
end

function  modifier_skill_troll_damage_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_damage_aura:IsPermanent()
	return false
end

function  modifier_skill_troll_damage_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

function modifier_skill_troll_damage_aura:GetModifierPreAttack_BonusDamage()
	return 1 * self:GetStackCount()
end

function modifier_skill_troll_damage_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end

function modifier_skill_troll_damage_aura:OnRefresh( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local countStack = caster:FindModifierByName("modifier_skill_troll_damage_aura"):GetStackCount()
		self:SetStackCount(countStack)
	end
end

