modifier_elf_spell_reveal = class({})
function modifier_elf_spell_reveal:IsPurgable()         return false end
function modifier_elf_spell_reveal:IsPurgeException()   return false end
function modifier_elf_spell_reveal:RemoveOnDeath()      return true end
function modifier_elf_spell_reveal:IsHidden()           return false end
function modifier_elf_spell_reveal:IsStackable()        return true end
function modifier_elf_spell_reveal:IsPermanent()        return false end
function modifier_elf_spell_reveal:GetTexture()         return "elf_spell_reveal" end
--------------------------------------------------------------------------------

function modifier_elf_spell_reveal:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("elf_spell_reveal")
		local abil = hero:FindAbilityByName("elf_spell_reveal")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_reveal:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_reveal")
	end
end

function modifier_elf_spell_reveal:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_reveal")
		local countStack = hero:FindModifierByName("modifier_elf_spell_reveal"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_reveal:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_reveal")
		local countStack = hero:FindModifierByName("modifier_elf_spell_reveal"):GetStackCount()
		abil:SetLevel(countStack)
	end
end