CheckUnit = true
function TvESpawnBoss(trigger)
	if CheckUnit then
		local point = Entities:FindByName( nil, "event_line"):GetAbsOrigin() 
        local waypoint = Entities:FindByName( nil, "event_line") 
        local unit = CreateUnitByName( "event_line_boss_winter" , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 
        unit:SetInitialGoalEntity( waypoint )
        unit:AddNewModifier(unit, nil, "modifier_phased", {})
        unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
		CheckUnit = false
	end
end