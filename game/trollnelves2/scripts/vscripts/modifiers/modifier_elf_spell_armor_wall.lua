modifier_elf_spell_armor_wall = class({})
function modifier_elf_spell_armor_wall:IsPurgable()         return false end
function modifier_elf_spell_armor_wall:IsPurgeException()   return false end
function modifier_elf_spell_armor_wall:RemoveOnDeath()      return true end
function modifier_elf_spell_armor_wall:IsHidden()           return false end
function modifier_elf_spell_armor_wall:IsStackable()        return true end
function modifier_elf_spell_armor_wall:IsPermanent()        return false end
function modifier_elf_spell_armor_wall:GetTexture()         return "elf_spell_armor_wall" end
--------------------------------------------------------------------------------
