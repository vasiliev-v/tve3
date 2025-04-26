modifier_troll_spell_evasion_x4 = class({})
function modifier_troll_spell_evasion_x4:IsPurgable()         return false end
function modifier_troll_spell_evasion_x4:IsPurgeException()   return false end
function modifier_troll_spell_evasion_x4:RemoveOnDeath()      return true end
function modifier_troll_spell_evasion_x4:IsHidden()           return false end
function modifier_troll_spell_evasion_x4:IsStackable()        return true end
function modifier_troll_spell_evasion_x4:IsPermanent()        return false end
function modifier_troll_spell_evasion_x4:GetTexture()         return "troll_spell_evasion_x4" end
--------------------------------------------------------------------------------
function modifier_troll_spell_evasion_x4:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_evasion_x4")
		local abil = hero:FindAbilityByName("troll_spell_evasion_x4")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_evasion_x4:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_evasion_x4")
	end
end

function modifier_troll_spell_evasion_x4:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_evasion_x4")
		local countStack = hero:FindModifierByName("modifier_troll_spell_evasion_x4"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_evasion_x4:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_evasion_x4")
		local countStack = hero:FindModifierByName("modifier_troll_spell_evasion_x4"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

