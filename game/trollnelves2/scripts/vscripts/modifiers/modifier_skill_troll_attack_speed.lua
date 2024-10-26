LinkLuaModifier("modifier_skill_troll_attack_speed", "modifiers/modifier_skill_troll_attack_speed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_attack_speed_aura", "modifiers/modifier_skill_troll_attack_speed.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_attack_speed = class({})

--------------------------------------------------------------------------------

function  modifier_skill_troll_attack_speed:IsHidden()
    return false
end

function  modifier_skill_troll_attack_speed:IsPurgable()
    return false
end

function  modifier_skill_troll_attack_speed:IsStackable()
    return true
end

function  modifier_skill_troll_attack_speed:IsPermanent()
	return false
end
function modifier_skill_troll_attack_speed:GetTexture()
    return "item_atk_spd_6"
end

--------------------------------------------------------------------------------
 modifier_skill_troll_attack_speed_aura = class({})

function  modifier_skill_troll_attack_speed_aura:IsHidden()
    return false
end
function modifier_skill_troll_attack_speed_aura:GetTexture()
    return "item_atk_spd_6"
end

function  modifier_skill_troll_attack_speed_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_attack_speed_aura:IsPermanent()
	return false
end

function  modifier_skill_troll_attack_speed_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_skill_troll_attack_speed_aura:GetModifierAttackSpeedBonus_Constant()
	return 1 * self:GetStackCount()
end

function modifier_skill_troll_attack_speed_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end

function modifier_skill_troll_attack_speed_aura:OnRefresh( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local countStack = caster:FindModifierByName("modifier_skill_troll_attack_speed_aura"):GetStackCount()
		self:SetStackCount(countStack)
	end
end

