modifier_wall_spell_armor = class({})
function modifier_wall_spell_armor:IsPurgable()         return false end
function modifier_wall_spell_armor:IsPurgeException()   return false end
function modifier_wall_spell_armor:RemoveOnDeath()      return true end
function modifier_wall_spell_armor:IsHidden()           return false end
function modifier_wall_spell_armor:IsStackable()        return true end
function modifier_wall_spell_armor:IsPermanent()        return false end
function modifier_wall_spell_armor:GetTexture()         return "troll_spell_cd_reduce" end
--------------------------------------------------------------------------------
function  modifier_wall_spell_armor:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function  modifier_wall_spell_armor:GetModifierPhysicalArmorBonus()
    local percent = 1
    if self:GetStackCount() == 1 then 
		percent = 0.10
	elseif self:GetStackCount() == 2  then
		percent = 0.15
	elseif self:GetStackCount() == 3  then
		percent = 0.20
	end
	return self:GetParent():GetPhysicalArmorBaseValue() * percent + 1
end