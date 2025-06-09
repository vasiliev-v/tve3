modifier_elf_spell_solo_player = class({})
function modifier_elf_spell_solo_player:IsPurgable()         return false end
function modifier_elf_spell_solo_player:IsPurgeException()   return false end
function modifier_elf_spell_solo_player:RemoveOnDeath()      return true end
function modifier_elf_spell_solo_player:IsHidden()           return false end
function modifier_elf_spell_solo_player:IsStackable()        return true end
function modifier_elf_spell_solo_player:IsPermanent()        return false end
function modifier_elf_spell_solo_player:GetTexture()         return "elf_spell_solo_player" end
--------------------------------------------------------------------------------
function  modifier_elf_spell_solo_player:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
    return funcs
end

function modifier_elf_spell_solo_player:GetModifierMoveSpeedBonus_Special_Boots()
	if self:GetStackCount() == 1 then 
		return 2
	elseif self:GetStackCount() == 2  then
		return 5
	elseif self:GetStackCount() == 3  then
		return 10
	else return 0 end
end