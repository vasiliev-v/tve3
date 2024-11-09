modifier_elf_spell_limit_lumber = class({})
function modifier_elf_spell_limit_lumber:IsPurgable()         return false end
function modifier_elf_spell_limit_lumber:IsPurgeException()   return false end
function modifier_elf_spell_limit_lumber:RemoveOnDeath()      return true end
function modifier_elf_spell_limit_lumber:IsHidden()           return false end
function modifier_elf_spell_limit_lumber:IsStackable()        return true end
function modifier_elf_spell_limit_lumber:IsPermanent()        return false end
function modifier_elf_spell_limit_lumber:GetTexture()         return "troll_spell_limit_gold" end
