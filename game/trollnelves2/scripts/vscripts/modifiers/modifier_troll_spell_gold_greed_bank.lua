modifier_troll_spell_gold_greed_bank = class({})

function modifier_troll_spell_gold_greed_bank:IsPurgable() return false end
function modifier_troll_spell_gold_greed_bank:IsPurgeException() return false end
function modifier_troll_spell_gold_greed_bank:RemoveOnDeath() return false end
function modifier_troll_spell_gold_greed_bank:IsHidden() return false end
function modifier_troll_spell_gold_greed_bank:IsStackable() return true end
function modifier_troll_spell_gold_greed_bank:IsPermanent() return true end
function modifier_troll_spell_gold_greed_bank:GetTexture() return "troll_spell_gold_greed" end
