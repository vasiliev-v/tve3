modifier_tower_spell_dmg_x4 = class({})
function modifier_tower_spell_dmg_x4:IsPurgable()         return false end
function modifier_tower_spell_dmg_x4:IsPurgeException()   return false end
function modifier_tower_spell_dmg_x4:RemoveOnDeath()      return true end
function modifier_tower_spell_dmg_x4:IsHidden()           return false end
function modifier_tower_spell_dmg_x4:IsStackable()        return true end
function modifier_tower_spell_dmg_x4:IsPermanent()        return false end
function modifier_tower_spell_dmg_x4:GetTexture()         return "elf_spell_tower_damage" end
--------------------------------------------------------------------------------
function  modifier_tower_spell_dmg_x4:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
    return funcs
end

function  modifier_tower_spell_dmg_x4:GetModifierPreAttack_BonusDamage()
    local percent = 1
    if self:GetStackCount() == 1 then 
		percent = 0.10
	elseif self:GetStackCount() == 2  then
		percent = 0.15
	elseif self:GetStackCount() == 3  then
		percent = 0.20
	end
	return math.floor(self:GetParent():GetDamageMax() * percent + 0.5)
end

function  modifier_tower_spell_dmg_x4:GetModifierAttackRangeBonus()
    local percent = 0
    if self:GetStackCount() == 1 then 
		percent = 10
	elseif self:GetStackCount() == 2  then
		percent = 20
	elseif self:GetStackCount() == 3  then
		percent = 30
	end
	return percent 
end