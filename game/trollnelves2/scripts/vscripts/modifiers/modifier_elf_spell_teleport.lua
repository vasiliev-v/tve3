modifier_elf_spell_teleport = class({})
function modifier_elf_spell_teleport:IsPurgable()         return false end
function modifier_elf_spell_teleport:IsPurgeException()   return false end
function modifier_elf_spell_teleport:RemoveOnDeath()      return true end
function modifier_elf_spell_teleport:IsHidden()           return false end
function modifier_elf_spell_teleport:IsStackable()        return true end
function modifier_elf_spell_teleport:IsPermanent()        return false end
function modifier_elf_spell_teleport:GetTexture()         return "elf_spell_teleport" end
--------------------------------------------------------------------------------

function modifier_elf_spell_teleport:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		hero:AddAbility("elf_spell_teleport")
		local abil = hero:FindAbilityByName("elf_spell_teleport")
		abil:SetLevel(countStack)
	end
end
function modifier_elf_spell_teleport:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		hero:RemoveAbility("elf_spell_teleport")
	end
end

function modifier_elf_spell_teleport:OnRefresh( kv )
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_teleport")
		local countStack = hero:FindModifierByName("modifier_elf_spell_teleport"):GetStackCount()
		abil:SetLevel(countStack)
	end
end

function modifier_elf_spell_teleport:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local abil = hero:FindAbilityByName("elf_spell_teleport")
		local countStack = hero:FindModifierByName("modifier_elf_spell_teleport"):GetStackCount()
		abil:SetLevel(countStack)
	end
end