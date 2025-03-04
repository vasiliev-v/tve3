modifier_troll_spell_silence_target = class({})
function modifier_troll_spell_silence_target:IsPurgable()         return false end
function modifier_troll_spell_silence_target:IsPurgeException()   return false end
function modifier_troll_spell_silence_target:RemoveOnDeath()      return true end
function modifier_troll_spell_silence_target:IsHidden()           return false end
function modifier_troll_spell_silence_target:IsStackable()        return true end
function modifier_troll_spell_silence_target:IsPermanent()        return false end
function modifier_troll_spell_silence_target:GetTexture()         return "troll_spell_silence_target" end
--------------------------------------------------------------------------------
function modifier_troll_spell_silence_target:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_silence_target")
		local abil = hero:FindAbilityByName("troll_spell_silence_target")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_silence_target:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_silence_target")
	end
end

function modifier_troll_spell_silence_target:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_silence_target")
		local countStack = hero:FindModifierByName("modifier_troll_spell_silence_target"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_silence_target:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_silence_target")
		local countStack = hero:FindModifierByName("modifier_troll_spell_silence_target"):GetStackCount()
		abil:SetLevel(countStack)
	end
end
