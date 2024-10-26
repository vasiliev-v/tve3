function TvEGift(trigger)
    local unit = trigger.activator
    local unitName = trigger.caller:GetName()
    local hero = unit:GetOwner()
    if hero then
        local spawnPoint = hero:GetAbsOrigin()	
		local newItem = CreateItem("item_event_desert", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		local dropRadius = RandomFloat( 1, 200 )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
         
        newItem = CreateItem("item_event_desert", nil, nil )
		drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		dropRadius = RandomFloat( 1, 200 )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
        
        newItem = CreateItem("item_vip", nil, nil )
		drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		dropRadius = RandomFloat( 1, 200 )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
    end
end
