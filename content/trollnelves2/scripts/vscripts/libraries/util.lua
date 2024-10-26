require('libraries/notifications')

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