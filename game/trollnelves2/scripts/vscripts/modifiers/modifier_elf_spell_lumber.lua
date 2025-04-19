modifier_elf_spell_lumber = class({})
function modifier_elf_spell_lumber:IsPurgable()         return false end
function modifier_elf_spell_lumber:IsPurgeException()   return false end
function modifier_elf_spell_lumber:RemoveOnDeath()      return true end
function modifier_elf_spell_lumber:IsHidden()           return false end
function modifier_elf_spell_lumber:IsStackable()        return true end
function modifier_elf_spell_lumber:IsPermanent()        return false end
function modifier_elf_spell_lumber:GetTexture()         return "elf_spell_lumber" end
--------------------------------------------------------------------------------
function  modifier_elf_spell_lumber:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_elf_spell_lumber:GetModifierMoveSpeedBonus_Constant()
	if self:GetStackCount() == 1 then 
		return -30
	elseif self:GetStackCount() == 2  then
		return -20
	elseif self:GetStackCount() == 3  then
		return -10
	else return 0 end
end

function modifier_elf_spell_lumber:OnCreated( kv )
	if IsServer() then
		local hero = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		PlayerResource:ModifyLumber(hero,2,true)
	end
end

function modifier_elf_spell_lumber:OnDestroy( kv )
	if IsServer() then
		local hero = self:GetParent()
		
	end
end