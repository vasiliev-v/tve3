modifier_elf_spell_target_damage_x4 = class({})
function modifier_elf_spell_target_damage_x4:IsPurgable()         return false end
function modifier_elf_spell_target_damage_x4:IsPurgeException()   return false end
function modifier_elf_spell_target_damage_x4:RemoveOnDeath()      return true end
function modifier_elf_spell_target_damage_x4:IsHidden()           return false end
function modifier_elf_spell_target_damage_x4:IsStackable()        return true end
function modifier_elf_spell_target_damage_x4:IsPermanent()        return false end
function modifier_elf_spell_target_damage_x4:GetTexture()         return "elf_spell_target_damage" end
--------------------------------------------------------------------------------

function modifier_elf_spell_target_damage_x4:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("elf_spell_target_damage_x4")
		local abil = hero:FindAbilityByName("elf_spell_target_damage_x4")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_target_damage_x4:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_target_damage_x4")
	end
end

function modifier_elf_spell_target_damage_x4:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_target_damage_x4")
		local countStack = hero:FindModifierByName("modifier_elf_spell_target_damage_x4"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_target_damage_x4:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_target_damage_x4")
		local countStack = hero:FindModifierByName("modifier_elf_spell_target_damage_x4"):GetStackCount()
		abil:SetLevel(countStack)
	end
end