modifier_troll_spell_hp_reg = class({})
function modifier_troll_spell_hp_reg:IsPurgable()         return false end
function modifier_troll_spell_hp_reg:IsPurgeException()   return false end
function modifier_troll_spell_hp_reg:RemoveOnDeath()      return true end
function modifier_troll_spell_hp_reg:IsHidden()           return false end
function modifier_troll_spell_hp_reg:IsStackable()        return true end
function modifier_troll_spell_hp_reg:IsPermanent()        return false end
function modifier_troll_spell_hp_reg:GetTexture()         return "item_hp_12" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_hp_reg:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end

function modifier_troll_spell_hp_reg:GetModifierConstantHealthRegen()
	if self:GetStackCount() == 1 then 
		return 1
	elseif self:GetStackCount() == 2  then
		return 2
	elseif self:GetStackCount() == 3  then
		return 4
	else return 0 end
end
