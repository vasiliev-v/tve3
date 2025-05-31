modifier_troll_spell_atkspeed = class({})
function modifier_troll_spell_atkspeed:IsPurgable()         return false end
function modifier_troll_spell_atkspeed:IsPurgeException()   return false end
function modifier_troll_spell_atkspeed:RemoveOnDeath()      return true end
function modifier_troll_spell_atkspeed:IsHidden()           return false end
function modifier_troll_spell_atkspeed:IsStackable()        return true end
function modifier_troll_spell_atkspeed:IsPermanent()        return false end
function modifier_troll_spell_atkspeed:GetTexture()         return "troll_spell_atkspeed" end
--------------------------------------------------------------------------------
function modifier_troll_spell_atkspeed:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_atkspeed")
		local abil = hero:FindAbilityByName("troll_spell_atkspeed")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_atkspeed:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_atkspeed")
	end
end

function modifier_troll_spell_atkspeed:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_atkspeed")
		local countStack = hero:FindModifierByName("modifier_troll_spell_atkspeed"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_atkspeed:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_atkspeed")
		local countStack = hero:FindModifierByName("modifier_troll_spell_atkspeed"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

