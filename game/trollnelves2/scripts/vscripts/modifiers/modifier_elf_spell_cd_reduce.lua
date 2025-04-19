modifier_elf_spell_cd_reduce = class({})
function modifier_elf_spell_cd_reduce:IsPurgable()         return false end
function modifier_elf_spell_cd_reduce:IsPurgeException()   return false end
function modifier_elf_spell_cd_reduce:RemoveOnDeath()      return true end
function modifier_elf_spell_cd_reduce:IsHidden()           return false end
function modifier_elf_spell_cd_reduce:IsStackable()        return true end
function modifier_elf_spell_cd_reduce:IsPermanent()        return false end
function modifier_elf_spell_cd_reduce:GetTexture()         return "elf_spell_cd_reduce" end
--------------------------------------------------------------------------------
function  modifier_elf_spell_cd_reduce:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end

function modifier_elf_spell_cd_reduce:GetModifierPercentageCooldown()
	if self:GetStackCount() == 1 then 
		return 4
	elseif self:GetStackCount() == 2  then
		return 8
	elseif self:GetStackCount() == 3  then
		return 16
	else return 0 end
end
