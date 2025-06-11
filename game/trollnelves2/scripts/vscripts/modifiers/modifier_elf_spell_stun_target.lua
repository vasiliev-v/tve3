modifier_elf_spell_stun_target = class({})
function modifier_elf_spell_stun_target:IsPurgable()         return false end
function modifier_elf_spell_stun_target:IsPurgeException()   return false end
function modifier_elf_spell_stun_target:RemoveOnDeath()      return true end
function modifier_elf_spell_stun_target:IsHidden()           return false end
function modifier_elf_spell_stun_target:IsStackable()        return true end
function modifier_elf_spell_stun_target:IsPermanent()        return false end
function modifier_elf_spell_stun_target:GetTexture()         return "elf_spell_stun_target" end
--------------------------------------------------------------------------------

function modifier_elf_spell_stun_target:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		InsertAbilityAfter(hero, "build_research_lab", "elf_spell_stun_target")
		-- hero:AddAbility("elf_spell_stun_target")
		local abil = hero:FindAbilityByName("elf_spell_stun_target")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_stun_target:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_stun_target")
	end
end

function modifier_elf_spell_stun_target:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_stun_target")
		local countStack = hero:FindModifierByName("modifier_elf_spell_stun_target"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_stun_target:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_stun_target")
		local countStack = hero:FindModifierByName("modifier_elf_spell_stun_target"):GetStackCount()
		abil:SetLevel(countStack)
	end
end