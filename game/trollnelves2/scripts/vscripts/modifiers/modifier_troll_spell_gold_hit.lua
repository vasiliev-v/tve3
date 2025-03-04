modifier_troll_spell_gold_hit = class({})
function modifier_troll_spell_gold_hit:IsPurgable()         return false end
function modifier_troll_spell_gold_hit:IsPurgeException()   return false end
function modifier_troll_spell_gold_hit:RemoveOnDeath()      return true end
function modifier_troll_spell_gold_hit:IsHidden()           return false end
function modifier_troll_spell_gold_hit:IsStackable()        return true end
function modifier_troll_spell_gold_hit:IsPermanent()        return false end
function modifier_troll_spell_gold_hit:GetTexture()         return "troll_spell_gold_hit" end

--------------------------------------------------------------------------------
function modifier_troll_spell_gold_hit:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_gold_hit")
		local abil = hero:FindAbilityByName("troll_spell_gold_hit")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_gold_hit:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_gold_hit")
	end
end

function modifier_troll_spell_gold_hit:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_gold_hit")
		local countStack = hero:FindModifierByName("modifier_troll_spell_gold_hit"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_gold_hit:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_gold_hit")
		local countStack = hero:FindModifierByName("modifier_troll_spell_gold_hit"):GetStackCount()
		abil:SetLevel(countStack)
	end
end