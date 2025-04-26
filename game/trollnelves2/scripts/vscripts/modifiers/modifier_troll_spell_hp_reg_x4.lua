modifier_troll_spell_hp_reg_x4 = class({})
function modifier_troll_spell_hp_reg_x4:IsPurgable()         return false end
function modifier_troll_spell_hp_reg_x4:IsPurgeException()   return false end
function modifier_troll_spell_hp_reg_x4:RemoveOnDeath()      return true end
function modifier_troll_spell_hp_reg_x4:IsHidden()           return false end
function modifier_troll_spell_hp_reg_x4:IsStackable()        return true end
function modifier_troll_spell_hp_reg_x4:IsPermanent()        return false end
function modifier_troll_spell_hp_reg_x4:GetTexture()         return "troll_spell_hp_reg" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_hp_reg_x4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end

function modifier_troll_spell_hp_reg_x4:GetModifierConstantHealthRegen()
	if self:GetStackCount() == 1 then 
		return 2
	elseif self:GetStackCount() == 2  then
		return 4
	elseif self:GetStackCount() == 3  then
		return 8
	else return 0 end
end
