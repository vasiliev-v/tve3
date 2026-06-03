modifier_troll_spell_status_resist = class({})
function modifier_troll_spell_status_resist:IsPurgable()         return false end
function modifier_troll_spell_status_resist:IsPurgeException()   return false end
function modifier_troll_spell_status_resist:RemoveOnDeath()      return true end
function modifier_troll_spell_status_resist:IsHidden()           return false end
function modifier_troll_spell_status_resist:IsStackable()        return true end
function modifier_troll_spell_status_resist:IsPermanent()        return false end
function modifier_troll_spell_status_resist:GetTexture()         return "troll_spell_status_resist" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_status_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end

function modifier_troll_spell_status_resist:GetModifierStatusResistanceStacking()
	if self:GetStackCount() == 1 then 
		return 15
	elseif self:GetStackCount() == 2  then
		return 20
	elseif self:GetStackCount() == 3  then
		return 25
	else return 0 end
end
function modifier_troll_spell_status_resist:GetModifierMagicalResistanceBonus()
	if self:GetStackCount() == 1 then 
		return 15
	elseif self:GetStackCount() == 2  then
		return 20
	elseif self:GetStackCount() == 3  then
		return 25
	else return 0 end
end
