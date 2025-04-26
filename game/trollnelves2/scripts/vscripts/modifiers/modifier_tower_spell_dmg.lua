modifier_tower_spell_dmg = class({})
function modifier_tower_spell_dmg:IsPurgable()         return false end
function modifier_tower_spell_dmg:IsPurgeException()   return false end
function modifier_tower_spell_dmg:RemoveOnDeath()      return true end
function modifier_tower_spell_dmg:IsHidden()           return false end
function modifier_tower_spell_dmg:IsStackable()        return true end
function modifier_tower_spell_dmg:IsPermanent()        return false end
function modifier_tower_spell_dmg:GetTexture()         return "troll_spell_cd_reduce" end
--------------------------------------------------------------------------------
function  modifier_tower_spell_dmg:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

function  modifier_tower_spell_dmg:GetModifierPreAttack_BonusDamage()
    local percent = 1
    if self:GetStackCount() == 1 then 
		percent = 0.04
	elseif self:GetStackCount() == 2  then
		percent = 0.08
	elseif self:GetStackCount() == 3  then
		percent = 0.12
	end
	return self:GetParent():GetDamageMax() * percent 
end