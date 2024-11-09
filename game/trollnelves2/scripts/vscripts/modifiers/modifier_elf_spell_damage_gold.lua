modifier_elf_spell_damage_gold = class({})
function modifier_elf_spell_damage_gold:IsPurgable()         return false end
function modifier_elf_spell_damage_gold:IsPurgeException()   return false end
function modifier_elf_spell_damage_gold:RemoveOnDeath()      return true end
function modifier_elf_spell_damage_gold:IsHidden()           return false end
function modifier_elf_spell_damage_gold:IsStackable()        return true end
function modifier_elf_spell_damage_gold:IsPermanent()        return false end
function modifier_elf_spell_damage_gold:GetTexture()         return "troll_spell_limit_gold" end
