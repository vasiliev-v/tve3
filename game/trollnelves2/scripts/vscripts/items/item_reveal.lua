item_reveal = class({})

function item_reveal:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("dur_time")
	local base_radius = self:GetSpecialValueFor("radius1")

	if caster:HasModifier("modifier_troll_spell_vision") then
		local s = caster:FindModifierByName("modifier_troll_spell_vision"):GetStackCount()
		if s == 1 then base_radius = base_radius + 150
		elseif s == 2 then base_radius = base_radius + 225
		elseif s >= 3 then base_radius = base_radius + 300 end
	end
	if caster:HasModifier("modifier_troll_spell_vision_x4") then
		local s = caster:FindModifierByName("modifier_troll_spell_vision_x4"):GetStackCount()
		if s == 1 then base_radius = base_radius + 150
		elseif s == 2 then base_radius = base_radius + 225
		elseif s >= 3 then base_radius = base_radius + 300 end
	end

	local map = GetMapName() or ""
	local radius = base_radius
	if string.match(map, "1x1") then
		radius = base_radius * 0.32
	elseif string.match(map, "arena") then
		radius = base_radius * 0.58
	end

	EmitSoundOn("hero_bloodseeker.bloodRite", caster)

	local p = ParticleManager:CreateParticle("particles/scan_particle.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(p, 0, point)
	ParticleManager:SetParticleControl(p, 1, Vector(radius, 0, 0))
	Timers:CreateTimer(duration, function()
		ParticleManager:DestroyParticle(p, false)
		ParticleManager:ReleaseParticleIndex(p)
	end)

	AddFOWViewer(caster:GetTeamNumber(), point, radius, duration, false)

	local elapsed = 0
	Timers:CreateTimer(0.03, function()
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(), point, nil, radius,
			DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL,
			DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false
		)
		for _,unit in pairs(units) do
			if unit and unit:HasModifier("modifier_invisible") and not unit:HasModifier("modifier_invisible_truesight_immune") then
				unit:RemoveModifierByName("modifier_invisible")
			end
		end
		elapsed = elapsed + 0.03
		if elapsed < duration then
			return 0.03
		end
	end)

	if self:GetCurrentCharges() > 0 then
		self:SpendCharge()
	end
end
