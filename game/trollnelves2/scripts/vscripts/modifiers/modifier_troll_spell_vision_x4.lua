modifier_troll_spell_vision_x4 = class({})
function modifier_troll_spell_vision_x4:IsPurgable()         return false end
function modifier_troll_spell_vision_x4:IsPurgeException()   return false end
function modifier_troll_spell_vision_x4:RemoveOnDeath()      return true end
function modifier_troll_spell_vision_x4:IsHidden()           return false end
function modifier_troll_spell_vision_x4:IsStackable()        return true end
function modifier_troll_spell_vision_x4:IsPermanent()        return false end
function modifier_troll_spell_vision_x4:GetTexture()         return "troll_spell_vision" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_vision_x4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    }
    return funcs
end

function modifier_troll_spell_vision_x4:GetBonusDayVision()
	if self:GetStackCount() == 1 then 
		return 150
	elseif self:GetStackCount() == 2  then
		return 225
	elseif self:GetStackCount() == 3  then
		return 300
	else return 0 end
end

function modifier_troll_spell_vision_x4:GetBonusNightVision()
	if self:GetStackCount() == 1 then 
		return 150
	elseif self:GetStackCount() == 2  then
		return 225
	elseif self:GetStackCount() == 3  then
		return 300
	else return 0 end
end
