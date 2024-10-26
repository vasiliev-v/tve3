function TvEGift(trigger)
    local unit = trigger.activator
    local unitName = trigger.caller:GetName()
    local hero = unit:GetOwner()
    if hero then
        local spawnPoint = hero:GetAbsOrigin()	
		local newItem = CreateItem("item_vip", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		local dropRadius = RandomFloat( 50, 100 )
    end
end
