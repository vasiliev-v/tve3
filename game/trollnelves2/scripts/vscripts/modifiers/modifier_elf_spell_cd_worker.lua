modifier_elf_spell_cd_worker = class({})
function modifier_elf_spell_cd_worker:IsPurgable()         return false end
function modifier_elf_spell_cd_worker:IsPurgeException()   return false end
function modifier_elf_spell_cd_worker:RemoveOnDeath()      return true end
function modifier_elf_spell_cd_worker:IsHidden()           return false end
function modifier_elf_spell_cd_worker:IsStackable()        return true end
function modifier_elf_spell_cd_worker:IsPermanent()        return false end
function modifier_elf_spell_cd_worker:GetTexture()         return "elf_spell_cd_worker" end
--------------------------------------------------------------------------------
