function OnSpellStart(event)
    local caster = event.caster
	local playerID = caster:GetMainControllingPlayer()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local unit = CreateUnitByName( "winter2023_npc" , event.ability:GetCursorPosition(), true, nil, nil, hero:GetTeamNumber() ) 

    unit:SetModel( event.Name )
	unit:SetOriginalModel( event.Name )
	unit:SetModelScale(event.SizeModel)

    unit:SetOwner(hero)
	unit:SetControllableByPlayer(playerID, true)
    unit:AddNewModifier(unit, nil, "modifier_phased", {})
    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
    local dur = event.ability:GetSpecialValueFor("duration")

    unit:AddNewModifier(unit, unit, "modifier_kill_time", {duration = dur})
end