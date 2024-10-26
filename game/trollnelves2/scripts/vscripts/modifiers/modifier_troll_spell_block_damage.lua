modifier_troll_spell_block_damage = class({})
function modifier_troll_spell_block_damage:IsPurgable()         return false end
function modifier_troll_spell_block_damage:IsPurgeException()   return false end
function modifier_troll_spell_block_damage:RemoveOnDeath()      return true end
function modifier_troll_spell_block_damage:IsHidden()           return false end
function modifier_troll_spell_block_damage:IsStackable()        return true end
function modifier_troll_spell_block_damage:IsPermanent()        return false end
function modifier_troll_spell_block_damage:GetTexture()         return "troll_spell_block_damage" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_block_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
    }
    return funcs
end

function modifier_troll_spell_block_damage:GetModifierPhysical_ConstantBlock(params)
	if self:GetStackCount() == 1 then 
		return 5
	elseif self:GetStackCount() == 2  then
		return 10
	elseif self:GetStackCount() == 3  then
		return 15
	else return 0 end
end
