modifier_elf_spell_untouchable = class({})
function modifier_elf_spell_untouchable:IsPurgable()         return false end
function modifier_elf_spell_untouchable:IsPurgeException()   return false end
function modifier_elf_spell_untouchable:RemoveOnDeath()      return true end
function modifier_elf_spell_untouchable:IsHidden()           return false end
function modifier_elf_spell_untouchable:IsStackable()        return true end
function modifier_elf_spell_untouchable:IsPermanent()        return false end
function modifier_elf_spell_untouchable:GetTexture()         return "elf_spell_untouchable" end
--------------------------------------------------------------------------------

function modifier_elf_spell_untouchable:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		InsertAbilityAfter(hero, "build_research_lab", "elf_spell_untouchable")
		local abil = hero:FindAbilityByName("elf_spell_untouchable")
		abil:SetLevel(countStack)
		abil:StartCooldown(600)
	end
end
function modifier_elf_spell_untouchable:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_untouchable")
	end
end

function modifier_elf_spell_untouchable:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_untouchable")
		local countStack = hero:FindModifierByName("modifier_elf_spell_untouchable"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_untouchable:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_untouchable")
		local countStack = hero:FindModifierByName("modifier_elf_spell_untouchable"):GetStackCount()
		abil:SetLevel(countStack)
	end
end