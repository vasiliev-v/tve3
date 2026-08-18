modifier_troll_spell_gold_greed = class({})
function modifier_troll_spell_gold_greed:IsPurgable()         return false end
function modifier_troll_spell_gold_greed:IsPurgeException()   return false end
function modifier_troll_spell_gold_greed:RemoveOnDeath()      return true end
function modifier_troll_spell_gold_greed:IsHidden()           return false end
function modifier_troll_spell_gold_greed:IsStackable()        return true end
function modifier_troll_spell_gold_greed:IsPermanent()        return false end
function modifier_troll_spell_gold_greed:GetTexture()         return "troll_spell_gold_greed" end
--------------------------------------------------------------------------------
function modifier_troll_spell_gold_greed:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		if not hero or hero:IsNull() then return end
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		if not hero:HasAbility("troll_spell_gold_greed") then
			hero:AddAbility("troll_spell_gold_greed")
		end
		local abil = hero:FindAbilityByName("troll_spell_gold_greed")
		if abil and not abil:IsNull() then
			abil:SetLevel(countStack)
		end
		-- Add gold accumulation bank after 2.5s delay
		Timers:CreateTimer(2.5, function()
			if not hero or hero:IsNull() or not hero:IsAlive() then return end
			if not hero.greed_activated and not hero:HasModifier("modifier_troll_spell_gold_greed_bank") then
				hero:AddNewModifier(hero, nil, "modifier_troll_spell_gold_greed_bank", {})
			end
		end)
	end
end

function modifier_troll_spell_gold_greed:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		if hero and not hero:IsNull() then
			hero:RemoveAbility("troll_spell_gold_greed")
		end
	end
end

function modifier_troll_spell_gold_greed:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		if not hero or hero:IsNull() then return end
		local abil = hero:FindAbilityByName("troll_spell_gold_greed")
		local countStack = self:GetStackCount()
		if abil and not abil:IsNull() then
			abil:SetLevel(countStack)
		end
	end
end

function modifier_troll_spell_gold_greed:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		if not hero or hero:IsNull() then return end
		local abil = hero:FindAbilityByName("troll_spell_gold_greed")
		local countStack = self:GetStackCount()
		if abil and not abil:IsNull() then
			abil:SetLevel(countStack)
		end
	end
end
