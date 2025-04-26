modifier_elf_spell_tower_range_x4 = class({})
function modifier_elf_spell_tower_range_x4:IsPurgable()         return false end
function modifier_elf_spell_tower_range_x4:IsPurgeException()   return false end
function modifier_elf_spell_tower_range_x4:RemoveOnDeath()      return true end
function modifier_elf_spell_tower_range_x4:IsHidden()           return false end
function modifier_elf_spell_tower_range_x4:IsStackable()        return true end
function modifier_elf_spell_tower_range_x4:IsPermanent()        return false end
function modifier_elf_spell_tower_range_x4:GetTexture()         return "elf_spell_tower_range" end
--------------------------------------------------------------------------------
