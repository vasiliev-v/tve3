
Clanwars = Clanwars or {}
local checkResult = {}

function Clanwars.SubmitMatchData(winner,callback)
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
	local debuffPoint = 0
	local sign = 1 
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetTeam(pID) ~= 5 then
			if GameRules.scores[pID] == nil then
				GameRules.scores[pID] = {elf = 0, troll = 0}
				GameRules.scores[pID].elf = 0
				GameRules.scores[pID].troll = 0

			end
			if GameRules.Bonus[pID] == nil then
				GameRules.Bonus[pID] = 0
			end
			if checkResult[pID] == nil then
				checkResult[pID] = 1
			else
				goto continue
			end
			local koeff = 1
			if PlayerResource:GetTeam(pID) ~= winner then
				koeff = -1 
			end

			if PlayerResource:GetDeaths(pID) ~= 0  then
				if GameRules:GetGameTime() - GameRules.startTime < 300 then -- <5 min
					GameRules.Bonus[pID] = GameRules.Bonus[pID] - 30
				elseif GameRules:GetGameTime() - GameRules.startTime >= 300 and GameRules:GetGameTime() - GameRules.startTime <  600 then -- 5-10 min
					GameRules.Bonus[pID] = GameRules.Bonus[pID] - 15 
				end
			end
			 
		end
	end

	if GameRules.PlayersCount >= MIN_RATING_PLAYER_CW then
		for pID=0,DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) and not PlayerResource:IsFakeClient(pID) and PlayerResource:GetTeam(pID) ~= 5 then
				data.MatchID = tostring(GameRules:Script_GetMatchID() or 0)
				data.XpBP = 10
				data.Team = tostring(PlayerResource:GetTeam(pID))
				--data.duration = GameRules:GetGameTime() - GameRules.startTime
				data.Map = GetMapName()
				local hero = PlayerResource:GetSelectedHeroEntity(pID)
				data.SteamID = tostring(PlayerResource:GetSteamID(pID) or 0)
				data.Time = tostring(tonumber(GameRules:GetGameTime() - GameRules.startTime)/60 or 0)
				data.GoldGained = tostring(PlayerResource:GetGoldGained(pID)/1000 or 0)
				data.GoldGiven = tostring(PlayerResource:GetGoldGiven(pID)/1000 or 0)
				data.LumberGained = tostring(PlayerResource:GetLumberGained(pID)/1000 or 0)
				data.LumberGiven = tostring(PlayerResource:GetLumberGiven(pID)/1000 or 0)
				data.Kill = tostring(PlayerResource:GetKills(pID) or 0)
				data.Death = tostring(PlayerResource:GetDeaths(pID) or 0)
				
				data.Nick = tostring(PlayerResource:GetPlayerName(pID))
				data.GPS = tostring(tonumber(data.GoldGained)/tonumber(GameRules:GetGameTime() - GameRules.startTime))
				data.LPS = tostring(tonumber(data.LumberGained)/tonumber(GameRules:GetGameTime() - GameRules.startTime))
				
				data.GetScoreBonus = tostring("0")
				if tonumber(data.GetScoreBonus) > 0 then
					data.GetScoreBonus = tostring(math.floor(tonumber(data.GetScoreBonus) * sign))
				end
				data.GetScoreBonusRank = tostring("0")
				data.GetScoreBonusGoldGained = tostring(PlayerResource:GetScoreBonusGoldGained(pID))
				data.GetScoreBonusGoldGiven = tostring(PlayerResource:GetScoreBonusGoldGiven(pID))
				data.GetScoreBonusLumberGained = tostring(PlayerResource:GetScoreBonusLumberGained(pID))
				data.GetScoreBonusLumberGiven = tostring(PlayerResource:GetScoreBonusLumberGiven(pID))		
				data.Score = 0
				if hero then
					data.Type = tostring(PlayerResource:GetType(pID) or "null")
				else
					data.Type = "ELF KICK"
				end

				if PlayerResource:GetTeam(pID) == winner then
					data.Score = tostring(math.floor(GameRules.Bonus[pID] + 10))
				else 
					data.Score = tostring(math.floor(GameRules.Bonus[pID] - 50))
				end 

				if tonumber(data.Score) >= 0 then
					data.Score = tostring(math.floor(tonumber(data.Score) *  (1 + GameRules.BonusPercent)))
					data.XpBP = tonumber(data.Score)/2
				else 
					-- data.Score = tostring(math.floor(tonumber(data.Score) *  (1 - GameRules.BonusPercent)))
					data.XpBP = tonumber(1)
				end
				data.Key = dedicatedServerKey
				data.BonusPercent = GameRules.BonusPercent
				local text = tostring(PlayerResource:GetPlayerName(pID)) .. " got " .. data.Score
				GameRules.Score[pID] = data.Score
				GameRules:SendCustomMessage(text, 1, 1)
				Clanwars.SendData(data,callback)
				if data.XpBP > 0 then
					data.EndGame = 1
					if GameRules.BonusGem[pID] == nil then
						GameRules.BonusGem[pID] = 1
					end
					data.XpBP = math.floor(data.XpBP * GameRules.BonusGem[pID])
					Shop.GetGem(data)
					GameRules.GetXpBP[pID] = data.XpBP
				end
			end 
		end
	end
	::continue::
	Timers:CreateTimer(5, function() 
		GameRules:SetGameWinner(winner)
		SetResourceValues()
	end)
end

function Clanwars.SendData(data,callback)
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
			GameRules:SendCustomMessage("Error connecting Clanwars.SendData", 1, 1)
			--DebugPrint("Error connecting")
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end
