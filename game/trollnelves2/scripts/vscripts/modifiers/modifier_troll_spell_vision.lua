modifier_troll_spell_vision = class({})
function modifier_troll_spell_vision:IsPurgable()         return false end
function modifier_troll_spell_vision:IsPurgeException()   return false end
function modifier_troll_spell_vision:RemoveOnDeath()      return true end
function modifier_troll_spell_vision:IsHidden()           return false end
function modifier_troll_spell_vision:IsStackable()        return true end
function modifier_troll_spell_vision:IsPermanent()        return false end
function modifier_troll_spell_vision:GetTexture()         return "item_hp_12" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    }
    return funcs
end

function modifier_troll_spell_vision:GetBonusDayVision()
	if self:GetStackCount() == 1 then 
		return 100
	elseif self:GetStackCount() == 2  then
		return 175
	elseif self:GetStackCount() == 3  then
		return 275
	else return 0 end
end

function modifier_troll_spell_vision:GetBonusNightVision()
	if self:GetStackCount() == 1 then 
		return 100
	elseif self:GetStackCount() == 2  then
		return 175
	elseif self:GetStackCount() == 3  then
		return 275
	else return 0 end
end
