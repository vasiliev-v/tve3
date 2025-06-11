modifier_elf_spell_target_damage = class({})
function modifier_elf_spell_target_damage:IsPurgable()         return false end
function modifier_elf_spell_target_damage:IsPurgeException()   return false end
function modifier_elf_spell_target_damage:RemoveOnDeath()      return true end
function modifier_elf_spell_target_damage:IsHidden()           return false end
function modifier_elf_spell_target_damage:IsStackable()        return true end
function modifier_elf_spell_target_damage:IsPermanent()        return false end
function modifier_elf_spell_target_damage:GetTexture()         return "elf_spell_target_damage" end
--------------------------------------------------------------------------------

function modifier_elf_spell_target_damage:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		InsertAbilityAfter(hero, "build_research_lab", "elf_spell_target_damage")
		-- hero:AddAbility("elf_spell_target_damage")
		local abil = hero:FindAbilityByName("elf_spell_target_damage")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_target_damage:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_target_damage")
	end
end

function modifier_elf_spell_target_damage:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_target_damage")
		local countStack = hero:FindModifierByName("modifier_elf_spell_target_damage"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_target_damage:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_target_damage")
		local countStack = hero:FindModifierByName("modifier_elf_spell_target_damage"):GetStackCount()
		abil:SetLevel(countStack)
	end
end