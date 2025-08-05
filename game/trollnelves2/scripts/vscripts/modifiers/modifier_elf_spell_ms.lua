modifier_elf_spell_ms = class({})
function modifier_elf_spell_ms:IsPurgable()         return false end
function modifier_elf_spell_ms:IsPurgeException()   return false end
function modifier_elf_spell_ms:RemoveOnDeath()      return true end
function modifier_elf_spell_ms:IsHidden()           return false end
function modifier_elf_spell_ms:IsStackable()        return true end
function modifier_elf_spell_ms:IsPermanent()        return false end
function modifier_elf_spell_ms:GetTexture()         return "elf_spell_ms" end
--------------------------------------------------------------------------------
function  modifier_elf_spell_ms:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_elf_spell_ms:GetModifierMoveSpeedBonus_Constant()
	if self:GetStackCount() == 1 then 
		return 5
	elseif self:GetStackCount() == 2  then
		return 10
	elseif self:GetStackCount() == 3  then
		return 15
	else return 0 end
end