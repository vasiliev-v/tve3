modifier_troll_spell_armor = class({})
function modifier_troll_spell_armor:IsPurgable()         return false end
function modifier_troll_spell_armor:IsPurgeException()   return false end
function modifier_troll_spell_armor:RemoveOnDeath()      return true end
function modifier_troll_spell_armor:IsHidden()           return false end
function modifier_troll_spell_armor:IsStackable()        return true end
function modifier_troll_spell_armor:IsPermanent()        return false end
function modifier_troll_spell_armor:GetTexture()         return "troll_spell_armor" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_troll_spell_armor:GetModifierPhysicalArmorBonus()
	if self:GetStackCount() == 1 then 
		return 2
	elseif self:GetStackCount() == 2  then
		return 4
	elseif self:GetStackCount() == 3  then
		return 8
	else return 0 end
end
