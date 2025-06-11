modifier_elf_spell_heal = class({})
function modifier_elf_spell_heal:IsPurgable()         return false end
function modifier_elf_spell_heal:IsPurgeException()   return false end
function modifier_elf_spell_heal:RemoveOnDeath()      return true end
function modifier_elf_spell_heal:IsHidden()           return false end
function modifier_elf_spell_heal:IsStackable()        return true end
function modifier_elf_spell_heal:IsPermanent()        return false end
function modifier_elf_spell_heal:GetTexture()         return "elf_spell_heal" end
--------------------------------------------------------------------------------

function modifier_elf_spell_heal:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		InsertAbilityAfter(hero, "build_research_lab", "elf_spell_heal")
		-- hero:AddAbility("elf_spell_heal")
		local abil = hero:FindAbilityByName("elf_spell_heal")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_heal:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_heal")
	end
end

function modifier_elf_spell_heal:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_heal")
		local countStack = hero:FindModifierByName("modifier_elf_spell_heal"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_heal:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_heal")
		local countStack = hero:FindModifierByName("modifier_elf_spell_heal"):GetStackCount()
		abil:SetLevel(countStack)
	end
end