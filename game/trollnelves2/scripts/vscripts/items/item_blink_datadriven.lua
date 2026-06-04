LinkLuaModifier("modifier_item_blink_datadriven_speed", "items/item_blink_datadriven.lua", LUA_MODIFIER_MOTION_NONE)

if item_blink_datadriven == nil then
	item_blink_datadriven = class({})
end

modifier_item_blink_datadriven_speed = class({})

function item_blink_datadriven:GetUpgradeValue(value1, value2, value3)
	local caster = self:GetCaster()

	if not caster then
		return 0
	end

	local function getValueFromModifier(modName)
		if not caster:HasModifier(modName) then
			return nil
		end

		local stacks = caster:GetModifierStackCount(modName, caster)

		if stacks == 1 then
			return value1
		elseif stacks == 2 then
			return value2
		elseif stacks >= 3 then
			return value3
		end

		return nil
	end

	local value = getValueFromModifier("modifier_elf_spell_blink")
	if value ~= nil then
		return value
	end

	value = getValueFromModifier("modifier_elf_spell_blink_x4")
	if value ~= nil then
		return value
	end

	return 0
end

function item_blink_datadriven:GetBlinkRange()
	local range = self:GetUpgradeValue(
		self:GetSpecialValueFor("up1"),
		self:GetSpecialValueFor("up2"),
		self:GetSpecialValueFor("up3")
	)

	if range <= 0 then
		return self:GetSpecialValueFor("max_blink_range")
	end

	return range
end

function item_blink_datadriven:GetBlinkMoveSpeedBonus()
	return self:GetUpgradeValue(
		self:GetSpecialValueFor("blink_move_speed_pct1"),
		self:GetSpecialValueFor("blink_move_speed_pct2"),
		self:GetSpecialValueFor("blink_move_speed_pct3")
	)
end

function item_blink_datadriven:GetBlinkMoveSpeedDuration()
	return self:GetUpgradeValue(
		self:GetSpecialValueFor("blink_move_speed_duration1"),
		self:GetSpecialValueFor("blink_move_speed_duration2"),
		self:GetSpecialValueFor("blink_move_speed_duration3")
	)
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
	local diff = target - origin
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

	local speedDuration = self:GetBlinkMoveSpeedDuration()

	if speedDuration > 0 then
		caster:AddNewModifier(
			caster,
			self,
			"modifier_item_blink_datadriven_speed",
			{
				duration = speedDuration
			}
		)
	end

	local p_end = ParticleManager:CreateParticle(
		"particles/econ/events/fall_2021/blink_dagger_fall_2021_end.vpcf",
		PATTACH_ABSORIGIN,
		caster
	)
	ParticleManager:ReleaseParticleIndex(p_end)
end

function modifier_item_blink_datadriven_speed:IsHidden()
	return false
end

function modifier_item_blink_datadriven_speed:IsPurgable()
	return true
end

function modifier_item_blink_datadriven_speed:GetEffectName()
	return "particles/items2_fx/phase_boots.vpcf"
end

function modifier_item_blink_datadriven_speed:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_blink_datadriven_speed:GetTexture()         return "elf_spell_blink" end


function modifier_item_blink_datadriven_speed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_item_blink_datadriven_speed:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()

	if not ability then
		return 0
	end

	return ability:GetBlinkMoveSpeedBonus()
end