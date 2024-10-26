LinkLuaModifier("modifier_skill_troll_cd_reduce", "modifiers/modifier_skill_troll_cd_reduce.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_cd_reduce_aura", "modifiers/modifier_skill_troll_cd_reduce.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_cd_reduce = class({})

--------------------------------------------------------------------------------

function  modifier_skill_troll_cd_reduce:IsHidden()
    return false
end

function  modifier_skill_troll_cd_reduce:IsPurgable()
    return false
end

function  modifier_skill_troll_cd_reduce:IsStackable()
    return true
end

function  modifier_skill_troll_cd_reduce:IsPermanent()
	return false
end

function modifier_skill_troll_cd_reduce:GetTexture()
    return "lia_totem_of_persistence"
end
--------------------------------------------------------------------------------
 modifier_skill_troll_cd_reduce_aura = class({})

function  modifier_skill_troll_cd_reduce_aura:IsHidden()
    return false
end
function modifier_skill_troll_cd_reduce_aura:GetTexture()
    return "lia_totem_of_persistence"
end

function  modifier_skill_troll_cd_reduce_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_cd_reduce_aura:IsPermanent()
	return false
end

function  modifier_skill_troll_cd_reduce_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end

function modifier_skill_troll_cd_reduce_aura:GetModifierPercentageCooldown()
	return 1 * self:GetStackCount()
end

function modifier_skill_troll_cd_reduce_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end

function modifier_skill_troll_cd_reduce_aura:OnRefresh( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local countStack = caster:FindModifierByName("modifier_skill_troll_cd_reduce_aura"):GetStackCount()
		self:SetStackCount(countStack)
	end
end

