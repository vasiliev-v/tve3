mod_system = class({})

local MOD_LIST = 
	{
		{"Yes", 0}
	}

function mod_system:Init()
    mod_system.votes_map = {}
    CustomGameEventManager:RegisterListener("troll_elves_mod_votes", Dynamic_Wrap(mod_system, "SetVotesMap"))
    Timers:CreateTimer(0, function()
        if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
            return
        end
      --  CustomGameEventManager:Send_ServerToAllClients("", {maps = MOD_LIST}) 
        return 0.1
    end)
end

function mod_system:SetVotesMap(data) 
	mod_system.votes_map[data.PlayerID] = data.panel_id

	local maps_list = MOD_LIST

	local table_k = {}

	for map_id, i in pairs(maps_list) do
		local has_info = false
		for _, map_id_select in pairs(mod_system.votes_map) do
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
		local percent = votes / GameRules.PlayersCount * 100
		table.insert( table_votes, { map_id = tonumber(map_id), votes = votes, percent = percent  } )
	end

	table.sort( table_votes, function(a,b) return ( a.votes > b.votes ) end )

	CustomGameEventManager:Send_ServerToAllClients("troll_elves_mod_votes_change_visual", {table_votes})
end

function mod_system:GetCurrentModFromVotes()
	local table_k = {}
	for _, map_id in pairs(mod_system.votes_map) do
		if table_k[tostring(map_id)] then
			table_k[tostring(map_id)] = table_k[tostring(map_id)] + 1
		else
			table_k[tostring(map_id)] = 1
		end
	end
	local table_votes = {}
	for map_id, votes in pairs(table_k) do
		local percent = votes / GameRules.PlayersCount * 100
		table.insert( table_votes, { map_id = tonumber(map_id), votes = votes, percent = percent  } )
	end

	--if table_votes[1] == nil then
	--	return true
	--end
	--if table_votes[1].percent >= 3333 then
	--	return false
	--else
	--	return true
	--end

	if GameRules.MapSpeed == 4 then
		return true
	else
		return false
	end
end

mod_system:Init()



