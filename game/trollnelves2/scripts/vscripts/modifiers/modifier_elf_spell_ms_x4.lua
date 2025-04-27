modifier_elf_spell_ms_x4 = class({})
function modifier_elf_spell_ms_x4:IsPurgable()         return false end
function modifier_elf_spell_ms_x4:IsPurgeException()   return false end
function modifier_elf_spell_ms_x4:RemoveOnDeath()      return true end
function modifier_elf_spell_ms_x4:IsHidden()           return false end
function modifier_elf_spell_ms_x4:IsStackable()        return true end
function modifier_elf_spell_ms_x4:IsPermanent()        return false end
function modifier_elf_spell_ms_x4:GetTexture()         return "elf_spell_ms" end
--------------------------------------------------------------------------------
function  modifier_elf_spell_ms_x4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
    return funcs
end

function modifier_elf_spell_ms_x4:GetModifierMoveSpeedBonus_Special_Boots()
	if self:GetStackCount() == 1 then 
		return 5
	elseif self:GetStackCount() == 2  then
		return 10
	elseif self:GetStackCount() == 3  then
		return 20
	else return 0 end
end