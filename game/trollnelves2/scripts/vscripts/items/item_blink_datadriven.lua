if item_blink_datadriven == nil then
	item_blink_datadriven = class({})
end

function item_blink_datadriven:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or not caster:IsAlive() then return end

	-- значения из AbilityValues
	local maxRange = self:GetSpecialValueFor("max_blink_range")
	local up1      = self:GetSpecialValueFor("up1")
	local up2      = self:GetSpecialValueFor("up2")
	local up3      = self:GetSpecialValueFor("up3")
	local minRange = self:GetSpecialValueFor("min_blink_range")

	-- обработка модификаторов (апгрейды)
	local function applyUpgrade(modName)
		if caster:HasModifier(modName) then
			local stacks = caster:FindModifierByName(modName):GetStackCount()
			if stacks == 1 then
				maxRange = up1
			elseif stacks == 2 then
				maxRange = up2
			elseif stacks >= 3 then
				maxRange = up3
			end
		end
	end
	applyUpgrade("modifier_elf_spell_blink")
	applyUpgrade("modifier_elf_spell_blink_x4")

	-- эффекты начала
	ProjectileManager:ProjectileDodge(caster)
	local p_start = ParticleManager:CreateParticle("particles/econ/events/fall_2021/blink_dagger_fall_2021_start.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(p_start)
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

	-- позиции
	local origin = caster:GetAbsOrigin()
	local target = self:GetCursorPosition()
	local diff   = target - origin
	local dist   = diff:Length2D()

	-- запрет слишком короткого блинка
	if dist < minRange then
		return
	end

	-- ограничение по максимальной дистанции
	if dist > maxRange then
		target = origin + diff:Normalized() * maxRange
	end

	-- перемещение
	caster:SetAbsOrigin(target)
	FindClearSpaceForUnit(caster, target, false)

	-- эффект завершения
	local p_end = ParticleManager:CreateParticle("particles/econ/events/fall_2021/blink_dagger_fall_2021_end.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(p_end)
end
