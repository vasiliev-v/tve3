modifier_elf_spell_true = class({})
function modifier_elf_spell_true:IsPurgable()         return false end
function modifier_elf_spell_true:IsPurgeException()   return false end
function modifier_elf_spell_true:RemoveOnDeath()      return true end
function modifier_elf_spell_true:IsHidden()           return false end
function modifier_elf_spell_true:IsStackable()        return true end
function modifier_elf_spell_true:IsPermanent()        return false end
function modifier_elf_spell_true:GetTexture()         return "elf_spell_true" end
--------------------------------------------------------------------------------

function modifier_elf_spell_true:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("elf_spell_true")
		local abil = hero:FindAbilityByName("elf_spell_true")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_true:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_true")
	end
end

function modifier_elf_spell_true:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_true")
		local countStack = hero:FindModifierByName("modifier_elf_spell_true"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_true:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_true")
		local countStack = hero:FindModifierByName("modifier_elf_spell_true"):GetStackCount()
		abil:SetLevel(countStack)
	end
end