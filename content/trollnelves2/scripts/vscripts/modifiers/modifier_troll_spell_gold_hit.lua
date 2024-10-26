modifier_troll_spell_gold_hit = class({})
function modifier_troll_spell_gold_hit:IsPurgable()         return false end
function modifier_troll_spell_gold_hit:IsPurgeException()   return false end
function modifier_troll_spell_gold_hit:RemoveOnDeath()      return true end
function modifier_troll_spell_gold_hit:IsHidden()           return false end
function modifier_troll_spell_gold_hit:IsStackable()        return true end
function modifier_troll_spell_gold_hit:IsPermanent()        return false end
function modifier_troll_spell_gold_hit:GetTexture()         return "troll_spell_gold_hit" end
--------------------------------------------------------------------------------
