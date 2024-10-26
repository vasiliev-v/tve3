modifier_troll_spell_ = class({})
function modifier_troll_spell_:IsPurgable()         return false end
function modifier_troll_spell_:IsPurgeException()   return false end
function modifier_troll_spell_:RemoveOnDeath()      return true end
function modifier_troll_spell_:IsHidden()           return false end
function modifier_troll_spell_:IsStackable()        return true end
function modifier_troll_spell_:IsPermanent()        return false end
function modifier_troll_spell_:GetTexture()         return "item_hp_12" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
    return funcs
end

function modifier_troll_spell_:GetModifierMoveSpeedBonus_Special_Boots()
	if self:GetStackCount() == 1 then 
		return 5
	elseif self:GetStackCount() == 2  then
		return 10
	elseif self:GetStackCount() == 3  then
		return 15
	else return 0 end
end
