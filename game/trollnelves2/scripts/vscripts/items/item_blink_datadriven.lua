if item_blink_datadriven == nil then
	item_blink_datadriven = class({})
end

function item_blink_datadriven:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_OVERSHOOT
	     + DOTA_ABILITY_BEHAVIOR_POINT
		 + DOTA_ABILITY_BEHAVIOR_AOE
end

function item_blink_datadriven:GetBlinkRange()
	local caster = self:GetCaster()

	local maxRange = self:GetSpecialValueFor("max_blink_range")
	local up1      = self:GetSpecialValueFor("up1")
	local up2      = self:GetSpecialValueFor("up2")
	local up3      = self:GetSpecialValueFor("up3")

	if not caster then
		return maxRange
	end

	local function applyUpgrade(modName)
		if not caster.HasModifier or not caster.GetModifierStackCount then
			return
		end

		if caster:HasModifier(modName) then
			local stacks = caster:GetModifierStackCount(modName, caster)

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

	return maxRange
end

function item_blink_datadriven:GetCastRange(vLocation, hTarget)
	return self:GetBlinkRange()
end

function item_blink_datadriven:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or not caster:IsAlive() then return end

	local maxRange = self:GetBlinkRange()
	local minRange = self:GetSpecialValueFor("min_blink_range")

	ProjectileManager:ProjectileDodge(caster)

	local p_start = ParticleManager:CreateParticle(
		"particles/econ/events/fall_2021/blink_dagger_fall_2021_start.vpcf",
		PATTACH_ABSORIGIN,
		caster
	)
	ParticleManager:ReleaseParticleIndex(p_start)
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

	local origin = caster:GetAbsOrigin()
	local target = self:GetCursorPosition()
	local diff   = target - origin
	diff.z = 0

	local dist = diff:Length2D()
	if dist < minRange then
		return
	end

	if dist > maxRange then
		target = origin + diff:Normalized() * maxRange
	end

	target = GetGroundPosition(target, caster)
	FindClearSpaceForUnit(caster, target, true)

	local p_end = ParticleManager:CreateParticle(
		"particles/econ/events/fall_2021/blink_dagger_fall_2021_end.vpcf",
		PATTACH_ABSORIGIN,
		caster
	)
	ParticleManager:ReleaseParticleIndex(p_end)
end