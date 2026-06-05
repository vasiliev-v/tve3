modifier_troll_spell_ward = class({})
function modifier_troll_spell_ward:IsPurgable()         return false end
function modifier_troll_spell_ward:IsPurgeException()   return false end
function modifier_troll_spell_ward:RemoveOnDeath()      return true end
function modifier_troll_spell_ward:IsHidden()           return false end
function modifier_troll_spell_ward:IsStackable()        return true end
function modifier_troll_spell_ward:IsPermanent()        return false end
function modifier_troll_spell_ward:GetTexture()         return "troll_spell_ward" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_ward:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    }
    return funcs
end

function modifier_troll_spell_ward:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_ward")
		local abil = hero:FindAbilityByName("troll_spell_ward")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_ward:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_ward")
	end
end

function modifier_troll_spell_ward:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_ward")
		local countStack = hero:FindModifierByName("modifier_troll_spell_ward"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_ward:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_ward")
		local countStack = hero:FindModifierByName("modifier_troll_spell_ward"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_ward:GetBonusDayVision()
	if self:GetStackCount() == 1 then 
		return 300
	elseif self:GetStackCount() == 2  then
		return 600
	elseif self:GetStackCount() == 3  then
		return 900
	else return 0 end
end

function modifier_troll_spell_ward:GetBonusNightVision()
	if self:GetStackCount() == 1 then 
		return 300
	elseif self:GetStackCount() == 2  then
		return 600
	elseif self:GetStackCount() == 3  then
		return 900
	else return 0 end
end

