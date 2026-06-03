modifier_troll_spell_status_resist_x4 = class({})
function modifier_troll_spell_status_resist_x4:IsPurgable()         return false end
function modifier_troll_spell_status_resist_x4:IsPurgeException()   return false end
function modifier_troll_spell_status_resist_x4:RemoveOnDeath()      return true end
function modifier_troll_spell_status_resist_x4:IsHidden()           return false end
function modifier_troll_spell_status_resist_x4:IsStackable()        return true end
function modifier_troll_spell_status_resist_x4:IsPermanent()        return false end
function modifier_troll_spell_status_resist_x4:GetTexture()         return "troll_spell_status_resist" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_status_resist_x4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end

function modifier_troll_spell_status_resist_x4:GetModifierStatusResistanceStacking()
	if self:GetStackCount() == 1 then 
		return 15
	elseif self:GetStackCount() == 2  then
		return 20
	elseif self:GetStackCount() == 3  then
		return 25
	else return 0 end
end
function modifier_troll_spell_status_resist_x4:GetModifierMagicalResistanceBonus()
	if self:GetStackCount() == 1 then 
		return 15
	elseif self:GetStackCount() == 2  then
		return 20
	elseif self:GetStackCount() == 3  then
		return 25
	else return 0 end
end
