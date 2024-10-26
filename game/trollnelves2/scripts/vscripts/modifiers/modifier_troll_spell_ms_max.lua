modifier_troll_spell_ms_max = class({})
function modifier_troll_spell_ms_max:IsPurgable()         return false end
function modifier_troll_spell_ms_max:IsPurgeException()   return false end
function modifier_troll_spell_ms_max:RemoveOnDeath()      return true end
function modifier_troll_spell_ms_max:IsHidden()           return false end
function modifier_troll_spell_ms_max:IsStackable()        return true end
function modifier_troll_spell_ms_max:IsPermanent()        return false end
function modifier_troll_spell_ms_max:GetTexture()         return "troll_spell_ms_max" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_ms_max:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
    return funcs
end

function modifier_troll_spell_ms_max:GetModifierMoveSpeedBonus_Special_Boots()
	 return 1000 
end