modifier_elf_spell_blink = class({})

function modifier_elf_spell_blink:IsPurgable()         return false end
function modifier_elf_spell_blink:IsPurgeException()   return false end
function modifier_elf_spell_blink:RemoveOnDeath()      return true end
function modifier_elf_spell_blink:IsHidden()           return false end
function modifier_elf_spell_blink:IsStackable()        return true end
function modifier_elf_spell_blink:IsPermanent()        return false end
function modifier_elf_spell_blink:GetTexture()         return "elf_spell_blink" end

function modifier_elf_spell_blink:OnCreated()
	if not IsServer() then return end
	self:UpdateBlinkItemLevel()
end

function modifier_elf_spell_blink:OnRefresh()
	if not IsServer() then return end
	self:UpdateBlinkItemLevel()
end

function modifier_elf_spell_blink:OnStackCountChanged(oldStackCount)
	if not IsServer() then return end
	self:UpdateBlinkItemLevel()
end

function modifier_elf_spell_blink:OnDestroy()
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

function modifier_elf_spell_blink:UpdateBlinkItemLevel()
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