LinkLuaModifier("modifier_skill_troll_ms", "modifiers/modifier_skill_troll_ms.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_ms_aura", "modifiers/modifier_skill_troll_ms.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_ms = class({})

--------------------------------------------------------------------------------

function  modifier_skill_troll_ms:IsHidden()
    return false
end

function  modifier_skill_troll_ms:IsPurgable()
    return false
end

function  modifier_skill_troll_ms:IsStackable()
    return true
end

function  modifier_skill_troll_ms:IsPermanent()
	return false
end

function modifier_skill_troll_ms:GetTexture()
    return "item_boots"
end
--------------------------------------------------------------------------------
 modifier_skill_troll_ms_aura = class({})

function  modifier_skill_troll_ms_aura:IsHidden()
    return false
end
function modifier_skill_troll_ms_aura:GetTexture()
    return "item_boots"
end

function  modifier_skill_troll_ms_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_ms_aura:IsPermanent()
	return false
end

function  modifier_skill_troll_ms_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
    return funcs
end

function modifier_skill_troll_ms_aura:GetModifierMoveSpeedBonus_Special_Boots()
	return 1 * self:GetStackCount()
end

function modifier_skill_troll_ms_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end

function modifier_skill_troll_ms_aura:OnRefresh( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local countStack = caster:FindModifierByName("modifier_skill_troll_ms_aura"):GetStackCount()
		self:SetStackCount(countStack)
	end
end

