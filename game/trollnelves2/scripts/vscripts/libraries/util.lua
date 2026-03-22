require('libraries/notifications')
print ( '[[TROLLNELVES2] util' )
function SendErrorMessage( pID, string )
    Notifications:ClearBottom(pID)
    Notifications:Bottom(pID, {text=string, style={color='#E62020'}, duration=2})
    EmitSoundOnEntityForPlayer("General.Cancel", PlayerResource:GetPlayer(pID), pID)
end

function fireLeftNotify(pid, bSameTeam,msg, data)

    local team=-1
    if bSameTeam then
        local pdata=PlayerResource:GetPlayer(pid)
        if pdata then
            team=pdata:GetTeamNumber()
        end
        
    end
    local gameEvent = {}
    gameEvent["player_id"] = pid
    gameEvent["teamnumber"] = team
    gameEvent["player_id2"] = data.pid2
    gameEvent["value"] = data.float0
    gameEvent["value1"] = data.float1
    gameEvent["value2"] = data.float2
    gameEvent["value3"] = data.float3
    gameEvent["int_value"] = data.int1
    gameEvent["int_value2"] = data.int2
    gameEvent["ability_name"] = data.ability
    gameEvent["locstring_value"] = data.str1
    gameEvent["locstring_value2"] = data.str2
    --
    gameEvent["message"] = msg
    --
    FireGameEvent("dota_combat_event_message", gameEvent)
end

function FindValidLootPosition(center, minRadius, maxRadius, attempts, treeRadius)
    attempts = attempts or 100
    treeRadius = treeRadius or 64

    for i = 1, attempts do
        local radius = RandomFloat(minRadius, maxRadius)
        local rawPos = center + RandomVector(radius)
        local pos = GetGroundPosition(rawPos, nil)

        if GridNav:IsTraversable(pos)
            and not GridNav:IsBlocked(pos)
            and not GridNav:IsNearbyTree(pos, treeRadius, true) then
            return pos
        end
    end

    return nil
end

function DropLootByRules(item_name, center, minRadius, maxRadius, launchHeight, launchDuration)
    if not item_name or not center then
        --print("[DropLootByRules] invalid args")
        return nil
    end

    minRadius = minRadius or 250
    maxRadius = maxRadius or 450
    launchHeight = launchHeight or 250
    launchDuration = launchDuration or 0.5

    local finalPos = FindValidLootPosition(center, minRadius, maxRadius, 100, 64)

    if not finalPos and maxRadius < 1000 then
        local fallbackMinRadius = maxRadius + 1
        local fallbackMaxRadius = 1000

        if fallbackMinRadius <= fallbackMaxRadius then
            finalPos = FindValidLootPosition(center, fallbackMinRadius, fallbackMaxRadius, 10, 64)
        end
    end

    if not finalPos then
        --print("[DropLootByRules] no valid drop position for", item_name)
        return nil
    end

    local item = CreateItem(item_name, nil, nil)
    if not item then
        --print("[DropLootByRules] CreateItem FAILED for", item_name)
        return nil
    end

    local drop = CreateItemOnPositionForLaunch(finalPos, item)
    if not drop then
        --print("[DropLootByRules] CreateItemOnPositionForLaunch FAILED for", item_name)
        UTIL_Remove(item)
        return nil
    end

    item:LaunchLootInitialHeight(false, 0, launchHeight, launchDuration, finalPos)
    return item
end