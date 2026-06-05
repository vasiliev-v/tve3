modifier_elf_spell_blink_x4 = class({})

function modifier_elf_spell_blink_x4:IsPurgable()         return false end
function modifier_elf_spell_blink_x4:IsPurgeException()   return false end
function modifier_elf_spell_blink_x4:RemoveOnDeath()      return true end
function modifier_elf_spell_blink_x4:IsHidden()           return false end
function modifier_elf_spell_blink_x4:IsStackable()        return true end
function modifier_elf_spell_blink_x4:IsPermanent()        return false end
function modifier_elf_spell_blink_x4:GetTexture()         return "elf_spell_blink" end

function modifier_elf_spell_blink_x4:OnCreated()
	if not IsServer() then return end
	self:UpdateBlinkItemLevel()
end

function modifier_elf_spell_blink_x4:OnRefresh()
	if not IsServer() then return end
	self:UpdateBlinkItemLevel()
end

function modifier_elf_spell_blink_x4:OnStackCountChanged(oldStackCount)
	if not IsServer() then return end
	self:UpdateBlinkItemLevel()
end

function modifier_elf_spell_blink_x4:OnDestroy()
	if not IsServer() then return end

	local parent = self:GetParent()

	Timers:CreateTimer(FrameTime(), function()
		if not parent or parent:IsNull() then return nil end

		local item = parent:FindItemInInventory("item_blink_datadriven")
		if item then
			item:SetLevel(1)
		end

		return nil
	end)
end

function modifier_elf_spell_blink_x4:UpdateBlinkItemLevel()
	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end

	local item = parent:FindItemInInventory("item_blink_datadriven")
	if not item then return end

	local stacks = self:GetStackCount()
	local level = 1

	if stacks == 1 then
		level = 2
	elseif stacks == 2 then
		level = 3
	elseif stacks >= 3 then
		level = 4
	end

	item:SetLevel(level)
end