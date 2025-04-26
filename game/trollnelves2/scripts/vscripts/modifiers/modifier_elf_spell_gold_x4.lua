modifier_elf_spell_gold_x4 = class({})
function modifier_elf_spell_gold_x4:IsPurgable()         return false end
function modifier_elf_spell_gold_x4:IsPurgeException()   return false end
function modifier_elf_spell_gold_x4:RemoveOnDeath()      return true end
function modifier_elf_spell_gold_x4:IsHidden()           return false end
function modifier_elf_spell_gold_x4:IsStackable()        return true end
function modifier_elf_spell_gold_x4:IsPermanent()        return false end
function modifier_elf_spell_gold_x4:GetTexture()         return "elf_spell_gold" end
--------------------------------------------------------------------------------
function  modifier_elf_spell_gold_x4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_elf_spell_gold_x4:GetModifierMoveSpeedBonus_Constant()
	if self:GetStackCount() == 1 then 
		return -20
	elseif self:GetStackCount() == 2  then
		return -10
	elseif self:GetStackCount() == 3  then
		return 0
	else return 0 end
end

function modifier_elf_spell_gold_x4:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		PlayerResource:ModifyGold(hero,10,true)
	end
end

function modifier_elf_spell_gold_x4:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		
	end
end

function modifier_elf_spell_gold_x4:OnStackCountChanged()
	if IsServer() then
		local hero = self:GetParent()
		local countStack = hero:FindModifierByName("modifier_elf_spell_gold_x4"):GetStackCount()
		if countStack == 2 then
			PlayerResource:ModifyGold(hero,5,true)
		elseif countStack == 3 then
			PlayerResource:ModifyGold(hero,10,true)
		end
	end
end