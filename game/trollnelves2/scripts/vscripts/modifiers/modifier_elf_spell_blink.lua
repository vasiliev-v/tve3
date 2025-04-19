modifier_elf_spell_blink = class({})
function modifier_elf_spell_blink:IsPurgable()         return false end
function modifier_elf_spell_blink:IsPurgeException()   return false end
function modifier_elf_spell_blink:RemoveOnDeath()      return true end
function modifier_elf_spell_blink:IsHidden()           return false end
function modifier_elf_spell_blink:IsStackable()        return true end
function modifier_elf_spell_blink:IsPermanent()        return false end
function modifier_elf_spell_blink:GetTexture()         return "elf_spell_blink" end
