modifier_elf_spell_smoke = class({})
function modifier_elf_spell_smoke:IsPurgable()         return false end
function modifier_elf_spell_smoke:IsPurgeException()   return false end
function modifier_elf_spell_smoke:RemoveOnDeath()      return true end
function modifier_elf_spell_smoke:IsHidden()           return false end
function modifier_elf_spell_smoke:IsStackable()        return true end
function modifier_elf_spell_smoke:IsPermanent()        return false end
function modifier_elf_spell_smoke:GetTexture()         return "elf_spell_smoke" end
--------------------------------------------------------------------------------

function modifier_elf_spell_smoke:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		InsertAbilityAfter(hero, "build_research_lab", "elf_spell_smoke")
		-- hero:AddAbility("elf_spell_smoke")
		local abil = hero:FindAbilityByName("elf_spell_smoke")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_smoke:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_smoke")
	end
end

function modifier_elf_spell_smoke:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_smoke")
		local countStack = hero:FindModifierByName("modifier_elf_spell_smoke"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_smoke:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_smoke")
		local countStack = hero:FindModifierByName("modifier_elf_spell_smoke"):GetStackCount()
		abil:SetLevel(countStack)
	end
end