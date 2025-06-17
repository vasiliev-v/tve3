modifier_troll_spell_ms_max_x4 = class({})
function modifier_troll_spell_ms_max_x4:IsPurgable()         return false end
function modifier_troll_spell_ms_max_x4:IsPurgeException()   return false end
function modifier_troll_spell_ms_max_x4:RemoveOnDeath()      return true end
function modifier_troll_spell_ms_max_x4:IsHidden()           return false end
function modifier_troll_spell_ms_max_x4:IsStackable()        return true end
function modifier_troll_spell_ms_max_x4:IsPermanent()        return false end
function modifier_troll_spell_ms_max_x4:GetTexture()         return "troll_spell_ms_max" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_ms_max_x4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_troll_spell_ms_max_x4:GetModifierMoveSpeedBonus_Special_Boots()
	 return 1000 
end