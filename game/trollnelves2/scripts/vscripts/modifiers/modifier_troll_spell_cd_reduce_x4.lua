modifier_troll_spell_cd_reduce_x4 = class({})
function modifier_troll_spell_cd_reduce_x4:IsPurgable()         return false end
function modifier_troll_spell_cd_reduce_x4:IsPurgeException()   return false end
function modifier_troll_spell_cd_reduce_x4:RemoveOnDeath()      return true end
function modifier_troll_spell_cd_reduce_x4:IsHidden()           return false end
function modifier_troll_spell_cd_reduce_x4:IsStackable()        return true end
function modifier_troll_spell_cd_reduce_x4:IsPermanent()        return false end
function modifier_troll_spell_cd_reduce_x4:GetTexture()         return "troll_spell_cd_reduce" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_cd_reduce_x4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end

function modifier_troll_spell_cd_reduce_x4:GetModifierPercentageCooldown()
	if self:GetStackCount() == 1 then 
		return 7
	elseif self:GetStackCount() == 2  then
		return 10
	elseif self:GetStackCount() == 3  then
		return 15
	else return 0 end
end
