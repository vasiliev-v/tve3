modifier_troll_spell_wolf = class({})
function modifier_troll_spell_wolf:IsPurgable()         return false end
function modifier_troll_spell_wolf:IsPurgeException()   return false end
function modifier_troll_spell_wolf:RemoveOnDeath()      return true end
function modifier_troll_spell_wolf:IsHidden()           return false end
function modifier_troll_spell_wolf:IsStackable()        return true end
function modifier_troll_spell_wolf:IsPermanent()        return false end
function modifier_troll_spell_wolf:GetTexture()         return "troll_spell_wolf" end
--------------------------------------------------------------------------------
function modifier_troll_spell_wolf:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_wolf")
		local abil = hero:FindAbilityByName("troll_spell_wolf")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_wolf:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_wolf")
	end
end

function modifier_troll_spell_wolf:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_wolf")
		local countStack = hero:FindModifierByName("modifier_troll_spell_wolf"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_wolf:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_wolf")
		local countStack = hero:FindModifierByName("modifier_troll_spell_wolf"):GetStackCount()
		abil:SetLevel(countStack)
	end
end
