modifier_troll_spell_limit_gold = class({})
function modifier_troll_spell_limit_gold:IsPurgable()         return false end
function modifier_troll_spell_limit_gold:IsPurgeException()   return false end
function modifier_troll_spell_limit_gold:RemoveOnDeath()      return true end
function modifier_troll_spell_limit_gold:IsHidden()           return false end
function modifier_troll_spell_limit_gold:IsStackable()        return true end
function modifier_troll_spell_limit_gold:IsPermanent()        return false end
function modifier_troll_spell_limit_gold:GetTexture()         return "item_hp_12" end
