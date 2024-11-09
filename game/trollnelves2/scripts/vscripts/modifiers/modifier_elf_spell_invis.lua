modifier_elf_spell_invis = class({})
function modifier_elf_spell_invis:IsPurgable()         return false end
function modifier_elf_spell_invis:IsPurgeException()   return false end
function modifier_elf_spell_invis:RemoveOnDeath()      return true end
function modifier_elf_spell_invis:IsHidden()           return false end
function modifier_elf_spell_invis:IsStackable()        return true end
function modifier_elf_spell_invis:IsPermanent()        return false end
function modifier_elf_spell_invis:GetTexture()         return "elf_spell_invis" end
--------------------------------------------------------------------------------
function modifier_elf_spell_invis:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("elf_spell_invis")
		local abil = hero:FindAbilityByName("elf_spell_invis")
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_invis:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_invis")
	end
end

function modifier_elf_spell_invis:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_invis")
		local countStack = hero:FindModifierByName("modifier_elf_spell_invis"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_invis:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_invis")
		local countStack = hero:FindModifierByName("modifier_elf_spell_invis"):GetStackCount()
		abil:SetLevel(countStack)
	end
end
