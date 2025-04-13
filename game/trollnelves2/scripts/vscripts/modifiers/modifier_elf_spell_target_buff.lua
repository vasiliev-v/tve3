modifier_elf_spell_target_buff = class({})
function modifier_elf_spell_target_buff:IsPurgable()         return false end
function modifier_elf_spell_target_buff:IsPurgeException()   return false end
function modifier_elf_spell_target_buff:RemoveOnDeath()      return true end
function modifier_elf_spell_target_buff:IsHidden()           return false end
function modifier_elf_spell_target_buff:IsStackable()        return true end
function modifier_elf_spell_target_buff:IsPermanent()        return false end
function modifier_elf_spell_target_buff:GetTexture()         return "elf_spell_target_buff" end
--------------------------------------------------------------------------------

function modifier_elf_spell_target_buff:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("elf_spell_target_buff")
		local abil = hero:FindAbilityByName("elf_spell_target_buff")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_target_buff:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_target_buff")
	end
end

function modifier_elf_spell_target_buff:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_target_buff")
		local countStack = hero:FindModifierByName("modifier_elf_spell_target_buff"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_target_buff:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_target_buff")
		local countStack = hero:FindModifierByName("modifier_elf_spell_target_buff"):GetStackCount()
		abil:SetLevel(countStack)
	end
end