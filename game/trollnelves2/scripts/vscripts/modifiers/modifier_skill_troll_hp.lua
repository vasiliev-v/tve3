LinkLuaModifier("modifier_skill_troll_hp", "modifiers/modifier_skill_troll_hp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_hp_aura", "modifiers/modifier_skill_troll_hp.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_hp = class({})

--------------------------------------------------------------------------------

function  modifier_skill_troll_hp:IsHidden()
    return false
end

function  modifier_skill_troll_hp:IsPurgable()
    return false
end

function  modifier_skill_troll_hp:IsStackable()
    return true
end

function  modifier_skill_troll_hp:IsPermanent()
	return false
end
function modifier_skill_troll_hp:GetTexture()
    return "item_hp_12"
end

--------------------------------------------------------------------------------
 modifier_skill_troll_hp_aura = class({})

function  modifier_skill_troll_hp_aura:IsHidden()
    return false
end
function modifier_skill_troll_hp_aura:GetTexture()
    return "item_hp_12"
end

function  modifier_skill_troll_hp_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_hp_aura:IsPermanent()
	return false
end

function  modifier_skill_troll_hp_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end

function modifier_skill_troll_hp_aura:GetModifierHealthBonus()
	return 1 * self:GetStackCount()
end

function modifier_skill_troll_hp_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end

function modifier_skill_troll_hp_aura:OnRefresh( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local countStack = caster:FindModifierByName("modifier_skill_troll_hp_aura"):GetStackCount()
		self:SetStackCount(countStack)
	end
end

