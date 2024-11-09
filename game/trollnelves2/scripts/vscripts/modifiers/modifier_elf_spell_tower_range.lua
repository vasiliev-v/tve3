modifier_elf_spell_tower_range = class({})
function modifier_elf_spell_tower_range:IsPurgable()         return false end
function modifier_elf_spell_tower_range:IsPurgeException()   return false end
function modifier_elf_spell_tower_range:RemoveOnDeath()      return true end
function modifier_elf_spell_tower_range:IsHidden()           return false end
function modifier_elf_spell_tower_range:IsStackable()        return true end
function modifier_elf_spell_tower_range:IsPermanent()        return false end
function modifier_elf_spell_tower_range:GetTexture()         return "troll_spell_cd_reduce" end
--------------------------------------------------------------------------------
