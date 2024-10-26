function Spawn(event)
	local caster = event.caster
	local playerID = caster:GetPlayerID()
	local duration = event.ability:GetSpecialValueFor("duration")
    local food = event.ability:GetSpecialValueFor("food_cost") 
    local unit = CreateUnitByName(event.name_creep, caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, true)
	if duration and duration >= 1 and duration <= 99999 then
		unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	end
    event.ability:SpendCharge(1)
	unit:AddNewModifier(unit, nil, "modifier_phased", {Duration = 0.3})
    -- ResolveNPCPositions(unit:GetAbsOrigin(),65)
end
		