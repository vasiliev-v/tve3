modifier_tower_spell_range = class({})
function modifier_tower_spell_range:IsPurgable()         return false end
function modifier_tower_spell_range:IsPurgeException()   return false end
function modifier_tower_spell_range:RemoveOnDeath()      return true end
function modifier_tower_spell_range:IsHidden()           return false end
function modifier_tower_spell_range:IsStackable()        return true end
function modifier_tower_spell_range:IsPermanent()        return false end
function modifier_tower_spell_range:GetTexture()         return "troll_spell_cd_reduce" end
--------------------------------------------------------------------------------
function  modifier_tower_spell_range:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
    return funcs
end

function  modifier_tower_spell_range:GetModifierAttackRangeBonus()
    local percent = 0
    if self:GetStackCount() == 1 then 
		percent = 10
	elseif self:GetStackCount() == 2  then
		percent = 20
	elseif self:GetStackCount() == 3  then
		percent = 40
	end
	return percent 
end