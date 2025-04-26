modifier_tower_spell_range_x4 = class({})
function modifier_tower_spell_range_x4:IsPurgable()         return false end
function modifier_tower_spell_range_x4:IsPurgeException()   return false end
function modifier_tower_spell_range_x4:RemoveOnDeath()      return true end
function modifier_tower_spell_range_x4:IsHidden()           return false end
function modifier_tower_spell_range_x4:IsStackable()        return true end
function modifier_tower_spell_range_x4:IsPermanent()        return false end
function modifier_tower_spell_range_x4:GetTexture()         return "troll_spell_cd_reduce" end
--------------------------------------------------------------------------------
function  modifier_tower_spell_range_x4:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
    return funcs
end

function  modifier_tower_spell_range_x4:GetModifierAttackRangeBonus()
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