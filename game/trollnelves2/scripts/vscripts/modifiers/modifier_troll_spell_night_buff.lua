modifier_troll_spell_night_buff = class({})
function modifier_troll_spell_night_buff:IsPurgable()         return false end
function modifier_troll_spell_night_buff:IsPurgeException()   return false end
function modifier_troll_spell_night_buff:RemoveOnDeath()      return true end
function modifier_troll_spell_night_buff:IsHidden()           return false end
function modifier_troll_spell_night_buff:IsStackable()        return true end
function modifier_troll_spell_night_buff:IsPermanent()        return false end
function modifier_troll_spell_night_buff:GetTexture()         return "troll_spell_night_buff" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_night_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    }
    return funcs
end

function modifier_troll_spell_night_buff:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_night_buff")
		local abil = hero:FindAbilityByName("troll_spell_night_buff")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_night_buff:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_night_buff")
	end
end

function modifier_troll_spell_night_buff:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_night_buff")
		local countStack = hero:FindModifierByName("modifier_troll_spell_night_buff"):GetStackCount()
		abil:SetLevel(countStack)
	end
end


function modifier_troll_spell_night_buff:GetBonusDayVision()
	if self:GetStackCount() == 1 then 
		return 150
	elseif self:GetStackCount() == 2  then
		return 225
	elseif self:GetStackCount() == 3  then
		return 300
	else return 0 end
end

function modifier_troll_spell_night_buff:GetBonusNightVision()
	if self:GetStackCount() == 1 then 
		return 150
	elseif self:GetStackCount() == 2  then
		return 225
	elseif self:GetStackCount() == 3  then
		return 300
	else return 0 end
end

