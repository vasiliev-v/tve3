modifier_troll_spell_magic_resist = class({})
function modifier_troll_spell_magic_resist:IsPurgable()         return false end
function modifier_troll_spell_magic_resist:IsPurgeException()   return false end
function modifier_troll_spell_magic_resist:RemoveOnDeath()      return true end
function modifier_troll_spell_magic_resist:IsHidden()           return false end
function modifier_troll_spell_magic_resist:IsStackable()        return true end
function modifier_troll_spell_magic_resist:IsPermanent()        return false end
function modifier_troll_spell_magic_resist:GetTexture()         return "troll_spell_magic_resist" end
--------------------------------------------------------------------------------
function  modifier_troll_spell_magic_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end

function modifier_troll_spell_magic_resist:GetModifierMagicalResistanceBonus()
	if self:GetStackCount() == 1 then 
		return 10
	elseif self:GetStackCount() == 2  then
		return 15
	elseif self:GetStackCount() == 3  then
		return 20
	else return 0 end
end

function modifier_troll_spell_magic_resist:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		--hero:AddAbility("troll_spell_magic_resist")
		--local abil = hero:FindAbilityByName("troll_spell_magic_resist")
		--abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_magic_resist:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		--hero:RemoveAbility("troll_spell_magic_resist")
	end
end

function modifier_troll_spell_magic_resist:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_magic_resist")
		local countStack = hero:FindModifierByName("modifier_troll_spell_magic_resist"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_troll_spell_magic_resist:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("troll_spell_magic_resist")
		local countStack = hero:FindModifierByName("modifier_troll_spell_magic_resist"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

