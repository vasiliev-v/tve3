require('top')

Stats = Stats or {}
local dedicatedServerKey = GetDedicatedServerKeyV3("1")
local checkResult = {}

function Stats.SubmitMatchData(winner,callback)
	if GameRules.startTime == nil then
		GameRules.startTime = 1
	end
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then 
			GameRules:SetGameWinner(winner)
			SetResourceValues()
			return 
		end
	end
	local data = {}
	local koeff =  string.match(GetMapName(),"%d+") or 1
	if koeff == 4 then
		koeff = 2
	else 
		koeff = 1
	end
	local debuffPoint = 0
	local sign = 1 
	
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetTeam(pID) ~= 5 then
			if GameRules.scores[pID] == nil then

				GameRules.scores[pID] = {elf = 0, troll = 0}
				GameRules.scores[pID].elf = 0
				GameRules.scores[pID].troll = 0

			end

			if GameRules.rep[pID] == nil then
				GameRules.rep[pID] = 0
			end
			--DebugPrint("pID " .. pID )
			if GameRules.Bonus[pID] == nil then
				GameRules.Bonus[pID] = 0
			end
			if checkResult[pID] == nil then
				checkResult[pID] = 1
			else
				goto continue
			end

			if GameRules.BonusGem[pID] == nil then
				GameRules.BonusGem[pID] = 1
			end

			if PlayerResource:GetDeaths(pID) == 0  then
				if GameRules:GetGameTime() - GameRules.startTime < 300 then
					GameRules.Bonus[pID] = GameRules.Bonus[pID] - 30/koeff 
					debuffPoint = -40/koeff
					sign = 0
				elseif GameRules:GetGameTime() - GameRules.startTime >= 300 and GameRules:GetGameTime() - GameRules.startTime <  600 then -- 5-10 min
					GameRules.Bonus[pID] = GameRules.Bonus[pID] - 20/koeff 
					debuffPoint = -30/koeff
					sign = 0.4
				elseif GameRules:GetGameTime() - GameRules.startTime >= 600 and GameRules:GetGameTime() - GameRules.startTime < 1200 then -- 10-19min
					GameRules.Bonus[pID] = GameRules.Bonus[pID] - math.floor((10/koeff))
					debuffPoint = -20/koeff
					sign = 0.8
				elseif GameRules:GetGameTime() - GameRules.startTime >= 1200 and GameRules:GetGameTime() - GameRules.startTime <  1500 then -- 20-25 min
					GameRules.Bonus[pID] = GameRules.Bonus[pID] + 2	
				elseif GameRules:GetGameTime() - GameRules.startTime >= 1500 and GameRules:GetGameTime() - GameRules.startTime <  2400 then -- 25-40 min
					GameRules.Bonus[pID] = GameRules.Bonus[pID] + 20 / koeff
				elseif GameRules:GetGameTime() - GameRules.startTime >= 2400 and GameRules:GetGameTime() - GameRules.startTime <  3600 then -- 40-60 min
					GameRules.Bonus[pID] = GameRules.Bonus[pID] + 30 / koeff
				elseif GameRules:GetGameTime() - GameRules.startTime >= 3600 then
					GameRules.Bonus[pID] = GameRules.Bonus[pID] + 40 / koeff 
				end
			end
			if PlayerResource:GetDeaths(pID) >= 10 then 
				GameRules.Bonus[pID] = GameRules.Bonus[pID] - 2
			end 
		end
	end
	if GameRules.BonusPercent  >  0.77 then
		GameRules.BonusPercent = 0.77
	end
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		for pID=0,DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetTeam(pID) ~= 5 then
				data.MatchID = tostring(GameRules:Script_GetMatchID() or 0)
				data.Gem = GameRules.BonusGem[pID]
				data.Team = tostring(PlayerResource:GetTeam(pID))
				--data.duration = GameRules:GetGameTime() - GameRules.startTime
				data.Map = GameRules.MapName
				local hero = PlayerResource:GetSelectedHeroEntity(pID)
				data.SteamID = tostring(PlayerResource:GetSteamID(pID) or 0)
				data.Time = tostring(tonumber(GameRules:GetGameTime() - GameRules.startTime)/60 or 0)
				data.GoldGained = tostring(PlayerResource:GetGoldGained(pID)/1000 or 0)
				data.GoldGiven = tostring(PlayerResource:GetGoldGiven(pID)/1000 or 0)
				data.LumberGained = tostring(PlayerResource:GetLumberGained(pID)/1000 or 0)
				data.LumberGiven = tostring(PlayerResource:GetLumberGiven(pID)/1000 or 0)
				data.Kill = tostring(PlayerResource:GetKills(pID) or 0)
				data.Death = tostring(PlayerResource:GetDeaths(pID) or 0)
				data.Nick = "error-nick"
				if PlayerResource:GetPlayerName(pID) then
					data.Nick = tostring(PlayerResource:GetPlayerName(pID))
				end
				data.GPS = tostring(tonumber(PlayerResource:GetGoldGained(pID) or 0)/tonumber(GameRules:GetGameTime() - GameRules.startTime))
				data.LPS = tostring(tonumber(PlayerResource:GetLumberGained(pID) or 0)/tonumber(GameRules:GetGameTime() - GameRules.startTime))
				
				data.GetScoreBonus = tostring(PlayerResource:GetScoreBonus(pID))
				if tonumber(data.GetScoreBonus) > 0 then
					data.GetScoreBonus = tostring(math.floor(tonumber(data.GetScoreBonus) * sign))
				end
				data.GetScoreBonusRank = tostring(PlayerResource:GetScoreBonusRank(pID))
				data.GetScoreBonusGoldGained = tostring(PlayerResource:GetScoreBonusGoldGained(pID))
				data.GetScoreBonusGoldGiven = tostring(PlayerResource:GetScoreBonusGoldGiven(pID))
				data.GetScoreBonusLumberGained = tostring(PlayerResource:GetScoreBonusLumberGained(pID))
				data.GetScoreBonusLumberGiven = tostring(PlayerResource:GetScoreBonusLumberGiven(pID))		
				data.Score = 0
				data.Rep = 0
				if hero then
					data.Type = tostring(PlayerResource:GetType(pID) or "null")
					if PlayerResource:GetTeam(pID) == winner and PlayerResource:GetDeaths(pID) == 0  then
						if hero:IsTroll() then
							data.Score = tostring(math.floor(30 + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
							if tonumber(data.Score) < 30 and sign >= 0.4 then
								data.Score = tostring(30)
							elseif tonumber(data.Score) < 30 and sign < 0.4 then 
								data.Score = tostring(2)
							end
						elseif hero:IsElf() then 
							data.Score = tostring(math.floor(30/koeff + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
							if tonumber(data.Score) < 1  then
								data.Score = tostring(1)
							end
						end
						data.Rep = 10
					else 
						data.Score = tostring(math.floor(debuffPoint - 10 + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
						if not hero:IsTroll() then
							data.Team = tostring(2)
						end
						data.Rep = -2
					end 
						
					if PlayerResource:GetConnectionState(pID) ~= 2 and hero:IsTroll() and PlayerResource:GetTeam(pID) == winner then
						data.Score = tostring(math.floor(10/koeff + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
						if tonumber(data.Score) < math.floor(10/koeff) then
							data.Score = tostring(math.floor(10/koeff))
						end
					end

					if PlayerResource:GetConnectionState(pID) ~= 2 then
						if not mod_system:GetCurrentModFromVotes() or (mod_system:GetCurrentModFromVotes() and not hero.LeaveGame) then
							data.Score = tostring(math.floor(-100 + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
							data.Team = tostring(2)
							data.Type = data.Type .. " LEAVE"
							data.Rep = -10 + GameRules.rep[pID]
						end
					end

					if (GameRules.scores[pID].elf + GameRules.scores[pID].troll) == 0 and tonumber(data.Score) < 0 and hero:IsTroll() then
						if PlayerResource:GetTeam(pID) == winner and PlayerResource:GetConnectionState(pID) == 2 then
							data.Score = "1"
						else
							data.Score = "0"
						end
						data.Type = "NEWBIE"
					end
					if tonumber(data.Score) >= 0 then
						data.Score = tostring(math.floor(tonumber(data.Score) *  (1 + GameRules.BonusPercent)))
						data.Gem = tonumber(data.Score)/2 + 1
					else 
						data.Score = tostring(math.floor(tonumber(data.Score) *  (1 - GameRules.BonusPercent)))
						data.Gem = tonumber(1)
					end
				else
					data.Type = "ELF KICK"
					data.Score = tostring(-100)
					data.Team = tostring(2)
					data.Rep = -20 + GameRules.rep[pID]
				end
				data.Key = dedicatedServerKey
				data.BonusPercent = tostring(GameRules.BonusPercent)
			--	local text = tostring(PlayerResource:GetPlayerName(pID)) .. " got " .. data.Score
				GameRules.Score[pID] = data.Score
			--	GameRules:SendCustomMessage(text, 1, 1)
				if GameRules.GetRep[pID] ~= nil then
					if tonumber(GameRules.GetRep[pID]) >= 10000 then
						data.Rep = 0 
					elseif tonumber(GameRules.GetRep[pID]) + data.Rep > 10000  then
						data.Rep = 10000 - tonumber(GameRules.GetRep[pID])
					end
				end
				if tonumber(data.Score) > 10 or tonumber(data.Score) < 0 then
					data.Rep = tostring(data.Rep)
				else
					data.Rep = tostring(0)
				end

				if data.Gem > 0 then
					data.EndGame = 1
					data.Gem = math.floor(data.Gem * GameRules.BonusGem[pID])
					GameRules.GetGem[pID] = data.Gem
				end
				
				Stats.SendData(data,callback)
			end 
		end
	end
	::continue::
	Timers:CreateTimer(5, function() 
		GameRules:SetGameWinner(winner)
		SetResourceValues()
	end)
end

function Stats.SendData(data,callback)
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server)
	if not req then
		return
	end
	local encData = json.encode(data)
	--DebugPrint("***********************************************")
	--DebugPrint(GameRules.server)
	--DebugPrint(encData)
	--DebugPrint("***********************************************")
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		--DebugPrint("***********************************************")
		--DebugPrint(res.Body)
		--DebugPrint("Response code: " .. res.StatusCode)
		--DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			GameRules:SendCustomMessage("Error connecting", 1, 1)
			--DebugPrint("Error connecting")
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end

function Stats.RequestData(obj, pId, callback)
	--DebugPrint("***********RequestData*************************")
	
	GameRules.scores[pId] = {elf = 0, troll = 0}
	GameRules.scores[pId].elf = 0
	GameRules.scores[pId].troll = 0
	--DebugPrintTable(obj)
	local nick = tostring(PlayerResource:GetPlayerName(pId))
	local message = nick .. " is not in the rating!"
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pId))

	PoolTable["8"]["0"] = "0"
	PoolTable["9"]["0"] = "0"
	if #obj > 0 then
		if obj[1].score ~= nil and #obj == 1 then
			if obj[1].team == "2" then 
				message = nick .. " has a Elf score: " .. obj[1].score
				GameRules.scores[pId].elf = obj[1].score
				GameRules.scores[pId].troll = 0
				PoolTable["8"]["0"] = obj[1]
				elseif obj[1].team == "3" then
				message = nick .. " has a Troll score: " .. obj[1].score
				GameRules.scores[pId].troll = obj[1].score
				GameRules.scores[pId].elf = 0
				PoolTable["9"]["0"] = obj[1]
			end 
		elseif  #obj == 2 then
			message =  nick .. " has a Elf score: " .. obj[1].score .. "; Troll score: " .. obj[2].score 
			GameRules.scores[pId].elf = obj[1].score
			GameRules.scores[pId].troll = obj[2].score
			PoolTable["8"]["0"] = obj[1]
			PoolTable["9"]["0"] = obj[2]

		end
	end
--	Timers:CreateTimer(TEAM_CHOICE_TIME+10, function()
--	GameRules:SendCustomMessage("<font color='#00FF80'>" ..  message ..  "</font>", pId, 0)
--	end)
	if GameRules.scores[pId].elf + GameRules.scores[pId].troll <= -7000 then
		GameRules.FakeList[pId] = 1
	end
	CustomNetTables:SetTableValue("Shop", tostring(pId), PoolTable)
	CustomNetTables:SetTableValue("scorestats", tostring(pId), { playerScoreElf = tostring(GameRules.scores[pId].elf), playerScoreTroll = tostring(GameRules.scores[pId].troll) })
	return obj
end

function Stats.RequestRep(obj, pId, callback)
	--DebugPrint("***********RequestRep*************************")
	
	GameRules.rep[pId] = 0
	GameRules.GetRep[pId] = 0
	--DebugPrintTable(obj)
	local nick = tostring(PlayerResource:GetPlayerName(pId))
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pId))
	PoolTable["10"]["0"] = "0"
	if #obj > 0 then
		if obj[1].gold ~= nil and #obj == 1 then
			PoolTable["10"]["0"] = obj[1].gold 
			--DebugPrint("obj[1].gold " .. obj[1].gold )
			GameRules.GetRep[pId] = obj[1].gold 
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pId), PoolTable)
	return obj
end

function Stats.RequestDataTop10(idTop, callback)

	if GameRules:IsCheatMode() then
		return -1 
	end

	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "all/" .. idTop)
	if not req then
		return
	end
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	--DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			--DebugPrint("Connection failed! Code: ".. res.StatusCode)
			--DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		--DeepPrintTable(obj)
		--DebugPrint("***********************************************")
		top:OnLoadTop(obj,idTop)
		---CustomNetTables:SetTableValue("stats", tostring( pId ), { steamID = obj.steamID, score = obj.score })
		return obj
		
	end)
end



--[[
	function Stats.RequestXp(pId, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "xp/" .. tostring(PlayerResource:GetSteamID(pId)))
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	--DebugPrint("***********************************************")
	
	GameRules.xp[pId] = 0
	
	req:Send(function(res)
	if res.StatusCode ~= 200 then
	--DebugPrint("Connection failed! Code: ".. res.StatusCode)
	--DebugPrint(res.Body)
	return -1
	end
	local obj,pos,err = json.decode(res.Body)
	--DebugPrint(obj.steamID)
	--DebugPrint("***********************************************"  .. #obj)
	--DebugPrintTable(obj)
	if #obj > 0 then
	GameRules.xp[pId] = obj[2].score
	end
	return obj
	end)
	end
--]]