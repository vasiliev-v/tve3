reveal_area_wolf = class({})

function reveal_area_wolf:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local base_radius = self:GetSpecialValueFor("radius1")
	local duration = self:GetSpecialValueFor("duration")

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

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(p, 0, point)
	ParticleManager:SetParticleControl(p, 1, Vector(radius, radius, radius))
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
end
