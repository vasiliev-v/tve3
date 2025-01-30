modifier_troll_spell_haste = class({})
function modifier_troll_spell_haste:IsPurgable()         return false end
function modifier_troll_spell_haste:IsPurgeException()   return false end
function modifier_troll_spell_haste:RemoveOnDeath()      return true end
function modifier_troll_spell_haste:IsHidden()           return false end
function modifier_troll_spell_haste:IsStackable()        return true end
function modifier_troll_spell_haste:IsPermanent()        return false end
function modifier_troll_spell_haste:GetTexture()         return "troll_spell_haste" end
--------------------------------------------------------------------------------
function modifier_troll_spell_haste:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_haste")
		local abil = hero:FindAbilityByName("troll_spell_haste")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_haste:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_haste")
	end
end

function modifier_troll_spell_haste:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_haste")
		local countStack = hero:FindModifierByName("modifier_troll_spell_haste"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

