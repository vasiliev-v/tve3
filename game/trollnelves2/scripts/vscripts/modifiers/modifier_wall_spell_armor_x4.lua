modifier_wall_spell_armor_x4 = class({})
function modifier_wall_spell_armor_x4:IsPurgable()         return false end
function modifier_wall_spell_armor_x4:IsPurgeException()   return false end
function modifier_wall_spell_armor_x4:RemoveOnDeath()      return true end
function modifier_wall_spell_armor_x4:IsHidden()           return false end
function modifier_wall_spell_armor_x4:IsStackable()        return true end
function modifier_wall_spell_armor_x4:IsPermanent()        return false end
function modifier_wall_spell_armor_x4:GetTexture()         return "troll_spell_cd_reduce" end
--------------------------------------------------------------------------------
function  modifier_wall_spell_armor_x4:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function  modifier_wall_spell_armor_x4:GetModifierPhysicalArmorBonus()
    local percent = 1
    if self:GetStackCount() == 1 then 
		percent = 0.05
	elseif self:GetStackCount() == 2  then
		percent = 0.10
	elseif self:GetStackCount() == 3  then
		percent = 0.15
	end
	return self:GetParent():GetPhysicalArmorBaseValue() * percent + 1
end