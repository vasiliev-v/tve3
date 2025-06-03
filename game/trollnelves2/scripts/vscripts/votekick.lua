-- --[[
require('settings')
local votes = {}
local countVote = {}
local checkVote
local lastKickTime = {}
local startVote = {}

function VotekickStart(eventSourceIndex, event)
	local playerName
	if string.match(GetMapName(),"clanwars") or string.match(GetMapName(),"1x1") then
        SendErrorMessage(event.PlayerID, "error_not_kick_cw")
        return 
    end 
	if event.target ~= nil then
		local hero = PlayerResource:GetSelectedHeroEntity(event.target)
		local ctrHeroID = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
		local team = hero:GetTeamNumber()
		if ctrHeroID:IsTroll() and team == DOTA_TEAM_BADGUYS  then
			playerName = PlayerResource:GetPlayerName(event.target)
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "show_votekick_options", {["name"] = playerName, ["id"] = event.target})
			--if lastKickTime[event.target] == nil then
			lastKickTime[event.target] = -300
			return
			--end
		end
		if ctrHeroID:IsAngel() then
			return 
		end 
		if tonumber(GameRules.GetRep[event.target]) > -50 or tonumber(GameRules.GetRep[event.PlayerID]) <= 0  then
			SendErrorMessage(event.PlayerID, "error_not_kick_normal")
        	return 
		end
		local countEflVote = 0
		if ctrHeroID:IsElf() then
			local elfCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
			for i=0, elfCount do
				local pID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
				if PlayerResource:GetSelectedHeroEntity(pID) ~= nil then 
					local hero2 = PlayerResource:GetSelectedHeroEntity(pID)
					if pID ~= event.target and hero2:IsElf() and PlayerResource:GetConnectionState(pID) == 2 then
						countEflVote = countEflVote + 1
					end
				end
			end
			if countEflVote <= MIN_PLAYER_KICK and GameRules.FakeList[event.target] == nil then
				SendErrorMessage(event.PlayerID, "Not enough players for Kick. Need ".. MIN_PLAYER_KICK .. " players. Count players " .. countEflVote)
				return 
			end
		end

		if ctrHeroID:IsElf() and team == DOTA_TEAM_GOODGUYS and PlayerResource:GetConnectionState(event.target) == 2 
			and (lastKickTime[event.target] == nil or lastKickTime[event.target] + 300 < GameRules:GetGameTime())
			and (checkVote == nil or checkVote + 40 < GameRules:GetGameTime()) then	
			local elfCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
			for i=0, elfCount do
				local pID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
				if PlayerResource:GetSelectedHeroEntity(pID) ~= nil then 
					local hero2 = PlayerResource:GetSelectedHeroEntity(pID)
					if pID ~= event.target and hero2:IsElf() and PlayerResource:GetConnectionState(pID) == 2 then
						if countVote[event.target] == nil then
							countVote[event.target] = 0
						end 
						local text = PlayerResource:GetPlayerName(event.PlayerID)
						countVote[event.target] = countVote[event.target] + 1
						playerName = PlayerResource:GetPlayerName(event.target)
						lastKickTime[event.target] = GameRules:GetGameTime()
						checkVote = GameRules:GetGameTime()
						text = text .. " launched a vote against " .. PlayerResource:GetPlayerName(event.target)
						GameRules:SendCustomMessageToTeam("<font color='#FF0000'>"  .. text  .. "</font>" , team, team, team)
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "show_votekick_options", {["name"] = playerName, ["id"] = event.target,["casterID"] = pID} )
						
					end
				end
			end
			elseif (lastKickTime[event.target] == nil or lastKickTime[event.target] + 300 > GameRules:GetGameTime())
			and (checkVote == nil or checkVote + 40 < GameRules:GetGameTime()) then
			local timeLeftKick = math.ceil(lastKickTime[event.target] + 300 - GameRules:GetGameTime())
			SendErrorMessage(event.PlayerID, "The following voting will be available in "..timeLeftKick.." seconds!")
			else 
			SendErrorMessage(event.PlayerID, "You can not run a double vote! Please wait 40 seconds.")
		end 
	end	
end

function VoteKick(eventSourceIndex, event)
	if votes[ event.playerID1 ] == nil then
		votes[ event.playerID1 ] = 0
	end 
	if startVote[event.PlayerID] == nil then
		startVote[event.PlayerID] = 0
	end 
	if event.vote > 1 or event.vote < 0 then
		return
	end
	if startVote[event.PlayerID] == 0 then
		votes[ event.playerID1 ] = votes[ event.playerID1 ] + event.vote;
		startVote[event.PlayerID] = 1
	else
		return
	end
	
	local hero = PlayerResource:GetSelectedHeroEntity(event.playerID1)
	local team = hero:GetTeamNumber()
	if votes[ event.playerID1 ] == 1 and team == DOTA_TEAM_BADGUYS 
		and PlayerResource:GetSteamAccountID(event.playerID1) ~= 201083179 
		and PlayerResource:GetSteamAccountID(event.playerID1) ~= 990264201 
		and PlayerResource:GetSteamAccountID(event.playerID1) ~= 337000240 
		and PlayerResource:GetSteamAccountID(event.playerID1) ~= 183899786 
		and PlayerResource:GetSteamAccountID(event.playerID1) ~= 129697246
		and PlayerResource:GetSteamAccountID(event.playerID1) ~= 381067505
		then
		votes[ event.playerID1 ] = 0
		startVote = {}
		hero:Kill(nil, hero)
		PlayerResource:SetGold(hero, 0)
    	PlayerResource:SetLumber(hero, 0)
		local i = 1
		local roll_chance = RandomFloat(1, 100)
		if roll_chance <= CHANCE_NEW_PERSON then
			i = 2
		end
		local newHeroName = ANGEL_HERO[i]
		local message = "%s1 will keep helping elves and now is an " .. GetModifiedName(ANGEL_HERO[i])
		local timer = 0.1
		local pos = RandomAngelLocation()
		PlayerResource:SetCustomTeamAssignment(event.playerID1, DOTA_TEAM_GOODGUYS)
		Timers:CreateTimer(function()
			GameRules:SendCustomMessage(message, event.playerID1, 0)
		end)
		hero:SetTimeUntilRespawn(timer)
		Timers:CreateTimer(timer, function()
			PlayerResource:ReplaceHeroWith(event.playerID1, newHeroName, 0, 0)
			-- UTIL_Remove(hero)
			hero = PlayerResource:GetSelectedHeroEntity(event.playerID1)
			PlayerResource:SetCustomTeamAssignment(event.playerID1, DOTA_TEAM_GOODGUYS) -- A workaround for wolves sometimes getting stuck on elves team, I don't know why or how it happens.
			FindClearSpaceForUnit(hero, pos, true)
			Timers:CreateTimer(3, function()
				PlayerResource:SetCameraTarget(event.playerID1, nil)
			end)
		end)
		
		CheckWolfInTeam(hero)
		
		return nil
	elseif team == DOTA_TEAM_BADGUYS  then
		votes[ event.playerID1 ] = 0
		startVote = {}
		return nil
	end
	if event.vote == 1 and (PlayerResource:GetSteamAccountID(event.PlayerID) == 201083179 or PlayerResource:GetSteamAccountID(event.PlayerID) == 990264201 
		or PlayerResource:GetSteamAccountID(event.PlayerID) == 337000240 or PlayerResource:GetSteamAccountID(event.PlayerID) == 183899786 or PlayerResource:GetSteamAccountID(event.PlayerID) == 381067505) then
		votes[ event.playerID1 ] = votes[ event.playerID1 ] + 3
	end
	local disKick = 0
	if tonumber(GameRules.GetRep[event.playerID1]) <= -50 then
		disKick = math.floor(tonumber(GameRules.GetRep[event.playerID1])/50) * 0.1
	end
	if event.vote == 1 then
		local text = "Vote: " .. votes[ event.playerID1 ] .. "; Count Player: " .. countVote[event.playerID1] .. "; Percent: " .. votes[ event.playerID1 ]/countVote[event.playerID1] .. "; Need perc.: " .. PERC_KICK_PLAYER + disKick .. "; Min player: 6" 
		GameRules:SendCustomMessageToTeam("<font color='#FF0000'>" ..  text  .. "</font>", team, 0, 0)
	end
	if team == DOTA_TEAM_GOODGUYS then
		Timers:CreateTimer(35.0, function() 
			
			if (votes[ event.playerID1 ]/countVote[event.playerID1]) >= PERC_KICK_PLAYER + disKick 
				and PlayerResource:GetSteamAccountID(event.playerID1) ~= 201083179 and PlayerResource:GetSteamAccountID(event.playerID1) ~= 990264201 
				and PlayerResource:GetSteamAccountID(event.playerID1) ~= 337000240 and PlayerResource:GetSteamAccountID(event.playerID1) ~= 183899786 
				and PlayerResource:GetSteamAccountID(event.playerID1) ~= 129697246 and PlayerResource:GetSteamAccountID(event.playerID1) ~= 381067505 
				or GameRules.FakeList[event.playerID1] ~= nil 
				then
				GameRules.PlayersBase[event.playerID1] = nil
				GameRules.KickList[event.playerID1] = 1
				hero = PlayerResource:GetSelectedHeroEntity(event.playerID1)
				-- hero:ForceKill(true)
				hero:Kill(nil, hero)
				if hero.units ~= nil then
					for i=1,#hero.units do
						if hero.units[i] and not hero.units[i]:IsNull() then
							local unit = hero.units[i]
							-- unit:ForceKill(false)
							unit:Kill(nil, unit)
						end
					end
				end
				SendToServerConsole("kick " .. PlayerResource:GetPlayerName(event.playerID1))
				CheckWolfInTeam(hero)
			end
			votes[ event.playerID1 ] = 0
			countVote[event.playerID1] = 0
			startVote = {}
		end);
	end 	
end


function CheckWolfInTeam(hero)
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) then
			local wolf = PlayerResource:GetSelectedHeroEntity(pID)
			if wolf ~= nil and hero ~= wolf and wolf ~= GameRules.trollHero and GameRules.KickList[pID] == nil then
				if wolf:IsWolf() then
					--DebugPrintTable(wolf)
					--DebugPrint("ControlUnitForTroll")
					trollnelves2:ControlUnitForTroll(wolf)
					return nil
				end
			end
		end
	end
	hero = GameRules.trollHero
	local playerID = GameRules.trollID
	local units = Entities:FindAllByClassname("npc_dota_creature")
	for _, unit in pairs(units) do
		local unit_name = unit:GetUnitName();
		if string.match(unit_name, "shop") or
			string.match(unit_name, "troll_hut") then
			unit:SetOwner(hero)
			unit:SetControllableByPlayer(playerID, true)
		end
	end
end