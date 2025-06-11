modifier_elf_spell_evasion = class({})
function modifier_elf_spell_evasion:IsPurgable()         return false end
function modifier_elf_spell_evasion:IsPurgeException()   return false end
function modifier_elf_spell_evasion:RemoveOnDeath()      return true end
function modifier_elf_spell_evasion:IsHidden()           return false end
function modifier_elf_spell_evasion:IsStackable()        return true end
function modifier_elf_spell_evasion:IsPermanent()        return false end
function modifier_elf_spell_evasion:GetTexture()         return "elf_spell_evasion" end
--------------------------------------------------------------------------------

function modifier_elf_spell_evasion:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		InsertAbilityAfter(hero, "build_research_lab", "elf_spell_evasion")
		--hero:AddAbility("elf_spell_evasion")
		local abil = hero:FindAbilityByName("elf_spell_evasion")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_evasion:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_evasion")
	end
end

function modifier_elf_spell_evasion:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_evasion")
		local countStack = hero:FindModifierByName("modifier_elf_spell_evasion"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_evasion:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_evasion")
		local countStack = hero:FindModifierByName("modifier_elf_spell_evasion"):GetStackCount()
		abil:SetLevel(countStack)
	end
end