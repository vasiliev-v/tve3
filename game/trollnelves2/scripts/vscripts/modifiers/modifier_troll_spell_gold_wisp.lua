modifier_troll_spell_gold_wisp = class({})
function modifier_troll_spell_gold_wisp:IsPurgable()         return false end
function modifier_troll_spell_gold_wisp:IsPurgeException()   return false end
function modifier_troll_spell_gold_wisp:RemoveOnDeath()      return true end
function modifier_troll_spell_gold_wisp:IsHidden()           return false end
function modifier_troll_spell_gold_wisp:IsStackable()        return true end
function modifier_troll_spell_gold_wisp:IsPermanent()        return false end
function modifier_troll_spell_gold_wisp:GetTexture()         return "troll_spell_gold_wisp" end
--------------------------------------------------------------------------------

function modifier_troll_spell_gold_wisp:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_gold_wisp")
		local abil = hero:FindAbilityByName("troll_spell_gold_wisp")
		abil:SetLevel(countStack)
	end
end
function modifier_troll_spell_gold_wisp:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_gold_wisp")
	end
end

function modifier_troll_spell_gold_wisp:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_gold_wisp")
		local countStack = hero:FindModifierByName("modifier_troll_spell_gold_wisp"):GetStackCount()
		abil:SetLevel(countStack)
	end
end
