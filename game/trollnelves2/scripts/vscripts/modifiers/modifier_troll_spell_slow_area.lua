modifier_troll_spell_slow_area = class({})
function modifier_troll_spell_slow_area:IsPurgable()         return false end
function modifier_troll_spell_slow_area:IsPurgeException()   return false end
function modifier_troll_spell_slow_area:RemoveOnDeath()      return true end
function modifier_troll_spell_slow_area:IsHidden()           return false end
function modifier_troll_spell_slow_area:IsStackable()        return true end
function modifier_troll_spell_slow_area:IsPermanent()        return false end
function modifier_troll_spell_slow_area:GetTexture()         return "troll_spell_slow_area" end
--------------------------------------------------------------------------------
function modifier_troll_spell_slow_area:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_slow_area")
		local abil = hero:FindAbilityByName("troll_spell_slow_area")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_slow_area:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_slow_area")
	end
end

function modifier_troll_spell_slow_area:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_slow_area")
		local countStack = hero:FindModifierByName("modifier_troll_spell_slow_area"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_slow_area:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_slow_area")
		local countStack = hero:FindModifierByName("modifier_troll_spell_slow_area"):GetStackCount()
		abil:SetLevel(countStack)
	end
end