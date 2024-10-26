modifier_troll_spell_reveal = class({})
function modifier_troll_spell_reveal:IsPurgable()         return false end
function modifier_troll_spell_reveal:IsPurgeException()   return false end
function modifier_troll_spell_reveal:RemoveOnDeath()      return true end
function modifier_troll_spell_reveal:IsHidden()           return false end
function modifier_troll_spell_reveal:IsStackable()        return true end
function modifier_troll_spell_reveal:IsPermanent()        return false end
function modifier_troll_spell_reveal:GetTexture()         return "troll_spell_reveal" end
