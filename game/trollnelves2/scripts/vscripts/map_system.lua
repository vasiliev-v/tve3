if map_system == nil then
    _G.map_system = class({})
end

local MAPS_LIST = {}

if string.match(GetMapName(),"1x1")  then
	MAPS_LIST = 
	{
		{"random", 			   0, 	"s2r://panorama/images/new_player_intro/01-basics_tutorial_psd.vtex"},
		{"1x1amazon", 		-127,	"s2r://panorama/images/new_design/maps/1x1amazon.png"}, 
		{"1x1fjord",	    -127, 	"s2r://panorama/images/new_design/maps/1x1fjord.png"}, 
		{"1x1tokyo", 		-127,	"s2r://panorama/images/new_design/maps/1x1tokyo.png"}
	}
else
	MAPS_LIST = 
	{
		{"random", 		   0,   "s2r://panorama/images/new_player_intro/01-basics_tutorial_psd.vtex"},
		{"atlantida", 	-127, 	"s2r://panorama/images/new_design/maps/atlantida.png"},
		{"athens", 	    -127, 	"s2r://panorama/images/new_design/maps/athens.png"},
		{"bloodville",	-127, 	"s2r://panorama/images/new_design/maps/bloodville.png"},
		{"garden", 		-127, 	"s2r://panorama/images/new_design/maps/garden.png"},
		-- {"gorge",		-127, 	"s2r://panorama/images/new_design/maps/gorge.png"},
		{"kanyon", 		-127, 	"s2r://panorama/images/new_design/maps/kanyon.png"},
		{"mines", 		-127, 	"s2r://panorama/images/new_design/maps/mines.png"},
		{"north", 		-127, 	"s2r://panorama/images/new_design/maps/north.png"},
		{"oasis", 		-127,	"s2r://panorama/images/new_design/maps/oasis.png"},
		{"okinawa", 	-127,	"s2r://panorama/images/new_design/maps/okinawa.png"}
	}
end

map_system.MAPS_LIST_G = MAPS_LIST

function map_system:Init()
    map_system.votes_map = {}
    CustomGameEventManager:RegisterListener("troll_elves_map_votes", Dynamic_Wrap(map_system, "SetVotesMap"))
    Timers:CreateTimer(0, function()
        if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
            return
        end
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_load_maps_list", {maps = MAPS_LIST}) 
        return 0.1
    end)
end


function map_system:SetVotesMap(data) 
	DebugPrint(PlayerResource:GetTeam(data.PlayerID))
	if string.match(GetMapName(),"1x1") and PlayerResource:GetTeam(data.PlayerID) ~= DOTA_TEAM_BADGUYS then
        return
    end

	map_system.votes_map[data.PlayerID] = data.panel_id

        local maps_list = MAPS_LIST

        local vote_players = 0

        for _, i in pairs(map_system.votes_map) do
                vote_players = vote_players + 1
        end

        local table_k = {}

        for map_id, i in pairs(maps_list) do
                local has_info = false
                for _, map_id_select in pairs(map_system.votes_map) do
                        if tostring(map_id_select) == tostring(map_id)  then
                                if table_k[tostring(map_id_select)] then
                                        table_k[tostring(map_id_select)] = table_k[tostring(map_id_select)] + 1
                                else
                                        table_k[tostring(map_id_select)] = 1
                                end
                                has_info = true
                        end
                end
                if not has_info then
                        table_k[tostring(map_id)] = 0
                end
        end

        local table_votes = {}

        for map_id, votes in pairs(table_k) do
                local percent = votes / vote_players * 100
                table.insert( table_votes, { map_id = tonumber(map_id), votes = votes, percent = percent  } )
        end

        table.sort( table_votes, function(a,b) return ( a.votes > b.votes ) end )

        CustomGameEventManager:Send_ServerToAllClients("troll_elves_map_votes_change_visual", table_votes)

        local eligible = map_system:GetEligibleVotersCount()
        if eligible > 0 and vote_players >= eligible then
            if Timers.RemoveTimer then
                Timers:RemoveTimer("map_vote_stage_timer")
            elseif Timers.Remove then
                Timers:Remove("map_vote_stage_timer")
            end

            BuildingHelper:UpdateMapStage()
            setup_state_lib:SetNextStage()

        end


end

function map_system:GetCurrentMapFromVotes()
	local final_map = MAPS_LIST[RandomInt(2, #MAPS_LIST)]
	local maps_list = MAPS_LIST

	local table_k = {}
	for _, map_id in pairs(map_system.votes_map) do
		if table_k[tostring(map_id)] then
			table_k[tostring(map_id)] = table_k[tostring(map_id)] + 1
		else
			table_k[tostring(map_id)] = 1
		end
	end

	local table_votes = {}
	for map_id, votes in pairs(table_k) do
		table.insert( table_votes, { map_id = tonumber(map_id), votes = votes } )
	end
	
	table.sort( table_votes, function(a,b) return ( a.votes > b.votes ) end )

	if table_votes[1] then
		if table_votes[1].map_id ~= 1 then
			final_map = maps_list[table_votes[1].map_id]
		end
	end
    return final_map
end

function map_system:GetEligibleVotersCount()
    local total = 0
    local only_dire = string.match(GetMapName(), "1x1") ~= nil

    for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
        if PlayerResource:IsValidPlayerID(playerID)
            and PlayerResource:GetConnectionState(playerID) == DOTA_CONNECTION_STATE_CONNECTED
            and not PlayerResource:IsFakeClient(playerID) then

            local team = PlayerResource:GetTeam(playerID)

            if only_dire then
                if team == DOTA_TEAM_BADGUYS then
                    total = total + 1
                end
            else
                if team ~= DOTA_TEAM_NOTEAM then
                    total = total + 1
                end
            end
        end
    end

    return total
end

map_system:Init()