modifier_troll_spell_bkb = class({})
function modifier_troll_spell_bkb:IsPurgable()         return false end
function modifier_troll_spell_bkb:IsPurgeException()   return false end
function modifier_troll_spell_bkb:RemoveOnDeath()      return true end
function modifier_troll_spell_bkb:IsHidden()           return false end
function modifier_troll_spell_bkb:IsStackable()        return true end
function modifier_troll_spell_bkb:IsPermanent()        return false end
function modifier_troll_spell_bkb:GetTexture()         return "troll_spell_bkb" end
--------------------------------------------------------------------------------
function modifier_troll_spell_bkb:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("troll_spell_bkb")
		local abil = hero:FindAbilityByName("troll_spell_bkb")
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_bkb:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("troll_spell_bkb")
	end
end

function modifier_troll_spell_bkb:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_haste")
		local countStack = hero:FindModifierByName("modifier_troll_spell_bkb"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_bkb:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_haste")
		local countStack = hero:FindModifierByName("modifier_troll_spell_bkb"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

