modifier_troll_spell_magic_resist = class({})
function modifier_troll_spell_magic_resist:IsPurgable()         return false end
function modifier_troll_spell_magic_resist:IsPurgeException()   return false end
function modifier_troll_spell_magic_resist:RemoveOnDeath()      return true end
function modifier_troll_spell_magic_resist:IsHidden()           return false end
function modifier_troll_spell_magic_resist:IsStackable()        return true end
function modifier_troll_spell_magic_resist:IsPermanent()        return false end
function modifier_troll_spell_magic_resist:GetTexture()         return "troll_spell_magic_resist" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_magic_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end

function modifier_troll_spell_magic_resist:GetModifierMagicalResistanceBonus()
	if self:GetStackCount() == 1 then 
		return 10
	elseif self:GetStackCount() == 2  then
		return 15
	elseif self:GetStackCount() == 3  then
		return 20
	else return 0 end
end
