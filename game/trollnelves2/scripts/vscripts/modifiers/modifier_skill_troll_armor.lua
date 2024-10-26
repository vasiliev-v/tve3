LinkLuaModifier("modifier_skill_troll_armor", "modifiers/modifier_skill_troll_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_armor_aura", "modifiers/modifier_skill_troll_armor.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_armor = class({})

--------------------------------------------------------------------------------

function  modifier_skill_troll_armor:IsHidden()
    return false
end

function  modifier_skill_troll_armor:IsPurgable()
    return false
end

function  modifier_skill_troll_armor:IsStackable()
    return true
end

function  modifier_skill_troll_armor:IsPermanent()
	return false
end
function modifier_skill_troll_armor:GetTexture()
    return "item_armor_12"
end


--------------------------------------------------------------------------------
 modifier_skill_troll_armor_aura = class({})
 function modifier_skill_troll_armor_aura:GetTexture()
    return "item_armor_12"
end
function  modifier_skill_troll_armor_aura:IsHidden()
    return false
end

function  modifier_skill_troll_armor_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_armor_aura:IsPermanent()
	return false
end

function  modifier_skill_troll_armor_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_skill_troll_armor_aura:GetModifierPhysicalArmorBonus()
	return 1 * self:GetStackCount()
end

function modifier_skill_troll_armor_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end

function modifier_skill_troll_armor_aura:OnRefresh( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local countStack = caster:FindModifierByName("modifier_skill_troll_armor_aura"):GetStackCount()
		self:SetStackCount(countStack)
	end
end

