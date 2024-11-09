modifier_elf_spell_tower_damage = class({})
function modifier_elf_spell_tower_damage:IsPurgable()         return false end
function modifier_elf_spell_tower_damage:IsPurgeException()   return false end
function modifier_elf_spell_tower_damage:RemoveOnDeath()      return true end
function modifier_elf_spell_tower_damage:IsHidden()           return false end
function modifier_elf_spell_tower_damage:IsStackable()        return true end
function modifier_elf_spell_tower_damage:IsPermanent()        return false end
function modifier_elf_spell_tower_damage:GetTexture()         return "troll_spell_cd_reduce" end
--------------------------------------------------------------------------------
