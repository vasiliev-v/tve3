require('error_debug')
Stats = Stats or {}

local checkResult = {}
local countCheckStats = 0 
local countCheckTime = 0 

function Stats.SubmitMatchData(winner,callback)
	if string.match(GetMapName(),"1x1") then
		Stats.Tournament1x1(winner,callback)
	else
		Stats.Normal(winner,callback)
	end  
end

function Stats.Normal(winner,callback)
	local status, nextCall = Error_debug.ErrorCheck(function() 
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
	local debuffPoint = 0
	local sign = 1 
	
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetTeam(pID) ~= 5 then
			if GameRules.scores[pID] == nil then

				GameRules.scores[pID] = {elf = 0, troll = 0}
				GameRules.scores[pID].elf = 0
				GameRules.scores[pID].troll = 0

			end

			if GameRules.GetRep[pID] == nil then
        		GameRules.GetRep[pID] = 0
    		end

			if GameRules.Rep[pID] == nil then
				GameRules.Rep[pID] = 0
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
				data.XpBP = GameRules.BonusGem[pID]
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
				-- 
				data.PartyId = tostring(PlayerResource:GetPartyID(pID) or 0)
				data.Color = tostring(pID)
				data.DamageGiven = tostring(PlayerResource:GetDamageGiven(pID) or 0)
				data.DamageTake = tostring(PlayerResource:GetDamageTake(pID) or 0)
				data.DeathTime = tostring(GameRules.deathTime[pID] or 0)

				
				if PlayerResource:GetConnectionState(pID) ~= 2 then
					data.Death = tostring(PlayerResource:GetDeaths(pID) + 1 or 0)
				else
					data.Death = tostring(PlayerResource:GetDeaths(pID) or 0)
				end
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
				
				if game_spells_lib.current_activated_spell[pID] ~= nil then
					data.Perk1 = game_spells_lib.current_activated_spell[pID][1] or ""
					data.Perk2 = game_spells_lib.current_activated_spell[pID][2] or ""
					data.Perk3 = game_spells_lib.current_activated_spell[pID][3] or ""	 
				end

				if hero then
					if PlayerResource:GetConnectionState(pID) ~= 2 then
						hero:IncrementDeaths(pID)
					end
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
						data.Rep = 5
					else 
						data.Score = tostring(math.floor(debuffPoint - 10 + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
						if not hero:IsTroll() then
							data.Team = tostring(2)
						end
						data.Rep = -3
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
							data.Rep = -5
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
					if tonumber(data.Score) >= 30 then
						data.Score = tostring(math.floor(tonumber(data.Score) *  (1 + GameRules.BonusPercent)))
						data.XpBP = tonumber(data.Score)/10 + 1
					else 
						data.Score = tostring(math.floor(tonumber(data.Score) *  (1 - GameRules.BonusPercent)))
						data.XpBP = tonumber(0)
					end
				else
					data.Type = "ELF KICK"
					data.Score = tostring(-200)
					data.Team = tostring(2)
					data.Rep = -40 
				end
				data.Key = dedicatedServerKey
				data.BonusPercent = tostring(GameRules.BonusPercent)
			     --	local text = tostring(PlayerResource:GetPlayerName(pID)) .. " got " .. data.Score
				GameRules.Score[pID] = data.Score
		      	--	GameRules:SendCustomMessage(text, 1, 1)

				if tonumber(data.Score) > 10 or tonumber(data.Score) < 0 then
					data.Rep = tostring(data.Rep) + GameRules.GetRep[pID]
				else
					data.Rep = tostring(0)
				end

				if GameRules.Rep[pID] ~= nil then
					if tonumber(GameRules.Rep[pID]) >= 10000 then
						data.Rep = 0 
					elseif tonumber(GameRules.Rep[pID]) + data.Rep > 10000  then
						data.Rep = 10000 - tonumber(GameRules.Rep[pID])
					end
				end
				data.Rep = tostring(data.Rep)
				if data.XpBP > 0 then
					data.EndGame = 1
					data.XpBP = math.floor(data.XpBP * GameRules.BonusGem[pID])
					GameRules.GetXpBP[pID] = data.XpBP
				end
				if data.SteamID ~= "0" then
					Stats.CheckDayQuest(pID)
					Stats.SendData(data,callback)
				end
				
			end 
		end
	end
	Timers:CreateTimer(10, function() 
		GameRules:SetGameWinner(winner)
		SetResourceValues()
		GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
	end)
	::continue::
	end)
end
-- Эло 1x1: ожидаемая сила по сумме рейтингов (elf+troll), апдейт только кармана сыгранной стороны
function Stats.Tournament1x1(winner, callback)
	DebugPrint("1")
	local status, nextCall = Error_debug.ErrorCheck(function()
		if GameRules.startTime == nil then GameRules.startTime = 1 end
		if not GameRules.isTesting and GameRules:IsCheatMode() then
			GameRules:SetGameWinner(winner)
			SetResourceValues()
			return
		end
DebugPrint("2")
		-- ========== ELO helpers ==========
		local K = 32 -- базовый K-фактор

		local function ensure_scores(pID)
			GameRules.scores = GameRules.scores or {}
			GameRules.scores[pID] = GameRules.scores[pID] or { elf = 0, troll = 0 }
			GameRules.scores[pID].elf = GameRules.scores[pID].elf or 0
			GameRules.scores[pID].troll = GameRules.scores[pID].troll or 0
		end

		-- суммарный рейтинг игрока (учитываем оба кармана)
		local function total_rating(pID)
			ensure_scores(pID)
			return (tonumber(GameRules.scores[pID].elf) or 0) + (tonumber(GameRules.scores[pID].troll) or 0)
		end

		local function expected_score(ra, rb)
			return 1 / (1 + 10 ^ ((rb - ra) / 400))
		end

		local function elo_delta(ra, rb, S)
			local E = expected_score(ra, rb)
			return math.floor(K * (S - E) + 0.5)
		end

		local function get_side(pID)
			local hero = PlayerResource:GetSelectedHeroEntity(pID)
			if hero and hero.IsTroll and hero:IsTroll() then return "troll" end
			if hero and hero.IsElf and hero:IsElf() then return "elf" end
			-- если определить по герою не можем, считаем эльфом по умолчанию (при желании поменяйте)
			return "elf"
		end
		-- =================================
DebugPrint("3")
		-- соберём валидных игроков
		local players = {}
		for pID = 0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetTeam(pID) ~= 5 and not GameRules.isTesting then
				table.insert(players, pID)
				ensure_scores(pID)
			else
				table.insert(players, pID)
				ensure_scores(pID)
			end
		end
DebugPrint("4")
		-- строго 1x1
		if GameRules.PlayersCount ~= 2 and not GameRules.isTesting then
			Timers:CreateTimer(1.0, function()
				GameRules:SetGameWinner(winner)
				SetResourceValues()
			end)
			return
		end
DebugPrint("5")
		local p1, p2 = players[1], players[2]
		local r1, r2 = total_rating(p1), total_rating(p2)

		for _, pID in ipairs(players) do
			DebugPrint("6")
			if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetTeam(pID) ~= 5 then
				local opp    = (pID == p1) and p2 or p1
				local r_self = (pID == p1) and r1 or r2
				local r_opp  = (pID == p1) and r2 or r1

				local S = (PlayerResource:GetTeam(pID) == winner) and 1 or 0
				local delta = elo_delta(r_self, r_opp, S)

				-- обновляем ТОЛЬКО рейтинг сыгранной стороны
				local side = get_side(pID)
				if side == "elf" then
					GameRules.scores[pID].elf = (GameRules.scores[pID].elf or 0) + delta
				else
					GameRules.scores[pID].troll = (GameRules.scores[pID].troll or 0) + delta
				end
DebugPrint("7")
				-- ===== упаковка данных для вашего бэка (Score = только ΔЭло) =====
				local data = {}
				data.MatchID = tostring(GameRules:Script_GetMatchID() or 0)
				data.Team = tostring(PlayerResource:GetTeam(pID))
				data.Map = GameRules.MapName
				data.SteamID = tostring(PlayerResource:GetSteamID(pID) or 0)
				data.Time = tostring((GameRules:GetGameTime() - GameRules.startTime) / 60 or 0)
				data.Kill = tostring(PlayerResource:GetKills(pID) or 0)
				data.Death = tostring(PlayerResource:GetDeaths(pID) or 0)
				data.Nick = tostring(PlayerResource:GetPlayerName(pID) or "unknown")
				data.Type = tostring(PlayerResource:GetType(pID) or "null")
				data.DeathTime = tostring(GameRules.deathTime[pID] or 0)

				data.GoldGained = tostring(PlayerResource:GetGoldGained(pID)/1000 or 0)
				data.GoldGiven = tostring(PlayerResource:GetGoldGiven(pID)/1000 or 0)
				data.LumberGained = tostring(PlayerResource:GetLumberGained(pID)/1000 or 0)
				data.LumberGiven = tostring(PlayerResource:GetLumberGiven(pID)/1000 or 0)
				-- 
				data.PartyId = tostring(PlayerResource:GetPartyID(pID) or 0)
				data.Color = tostring(pID)
				data.DamageGiven = tostring(PlayerResource:GetDamageGiven(pID) or 0)
				data.DamageTake = tostring(PlayerResource:GetDamageTake(pID) or 0)

				data.Nick = "error-nick"
				if PlayerResource:GetPlayerName(pID) then
					data.Nick = tostring(PlayerResource:GetPlayerName(pID))
				end
				data.GPS = tostring(tonumber(PlayerResource:GetGoldGained(pID) or 0)/tonumber(GameRules:GetGameTime() - GameRules.startTime))
				data.LPS = tostring(tonumber(PlayerResource:GetLumberGained(pID) or 0)/tonumber(GameRules:GetGameTime() - GameRules.startTime))
				
				-- главное поле
				data.Score = tostring(delta)

				-- сопутствующие поля, если их ждёт сервер; не влияют на рейтинг
				data.Rep = "0"
				data.Key = dedicatedServerKey

				GameRules.Score = GameRules.Score or {}
				GameRules.Score[pID] = data.Score
DebugPrint("8")
				if data.SteamID ~= "0" then
					DebugPrint("9")
					Stats.SendData(data, callback)
				end
			end
		end

		Timers:CreateTimer(10, function()
			GameRules:SetGameWinner(winner)
			SetResourceValues()
			GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
		end)
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
			GameRules:SendCustomMessage("Error connecting Stats.SendData", 1, 1)
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

	CustomNetTables:SetTableValue("Shop", tostring(pId), PoolTable)
	CustomNetTables:SetTableValue("scorestats", tostring(pId), { playerScoreElf = tostring(GameRules.scores[pId].elf), playerScoreTroll = tostring(GameRules.scores[pId].troll) })
	return obj
end

function Stats.RequestRep(obj, pId, callback)
	--DebugPrint("***********RequestRep*************************")
	
	GameRules.Rep[pId] = 0
	GameRules.GetRep[pId] = 0
	--DebugPrintTable(obj)
	local nick = tostring(PlayerResource:GetPlayerName(pId))
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pId))
	PoolTable["10"]["0"] = "0"
	if #obj > 0 then
		if obj[1].gold ~= nil and #obj == 1 then
			PoolTable["10"]["0"] = obj[1].gold 
			--DebugPrint("obj[1].gold " .. obj[1].gold )
			GameRules.Rep[pId] = obj[1].gold 
		end
	end
	if tonumber(GameRules.Rep[pId]) <= -1000 then
		GameRules.FakeList[pId] = 1
	end
	CustomNetTables:SetTableValue("Shop", tostring(pId), PoolTable)
	return obj
end

function Stats.RequestDataTop10(mapSpd, callback)

	if GameRules:IsCheatMode() and not GameRules.isTesting then
		return -1 
	end

	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "all/" .. mapSpd)
	if not req then
		return
	end
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	--DebugPrint("***********************************************")

	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			--DebugPrint(res.Body)
			if countCheckStats <= 3 then
				DebugPrint("RECONNECT RATING!!!!!!!")
				Timers:CreateTimer(15, function() 
					countCheckStats = countCheckStats + 1
					Stats.RequestDataTop10(mapSpd, callback)
			    end)
			end
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		--DeepPrintTable(obj)
		--DebugPrint("***********************************************")
		local obj,pos,err = json.decode(res.Body)
		local ratingTable = {}
		if #obj > 0 then
			for id=1,#obj do
				ratingTable[id] = {obj[id].steamID, obj[id].elf, obj[id].troll, obj[id].score, obj[id].matchID}
			end
		end
		CustomNetTables:SetTableValue("Shop", "top10", ratingTable)	
		
		---CustomNetTables:SetTableValue("stats", tostring( pId ), { steamID = obj.steamID, score = obj.score })
		return obj
		
	end)
	if IsServer() then
        for pID = 0, DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayerID(pID) and not PlayerResource:IsFakeClient(pID) then
                local steam = tostring(PlayerResource:GetSteamID(pID))
                CustomNetTables:SetTableValue("Shop", tostring(pID), GameRules.PoolTable)
                Shop.RequestDonate(pID, steam, callback)
            end
        end
	end
end

function Stats.RequestRating(obj, pId, callback)
	-- DebugPrint("***********RequestRating*************************")
	
	--DebugPrintTable(obj)
	local nick = tostring(PlayerResource:GetPlayerName(pId))
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pId))
	PoolTable["13"] = {}
	if #obj > 0 then
		PoolTable["13"] = {obj[1].rank,obj[1].steamID, obj[1].elf, obj[1].troll, obj[1].score, obj[1].matchID}
	end
	CustomNetTables:SetTableValue("Shop", tostring(pId), PoolTable)
	return obj
end


function Stats.RequestDataTime(callback)

	if GameRules:IsCheatMode() and not GameRules.isTesting then
		return -1 
	end

	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "datetime" )
	if not req then
		return
	end
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	--DebugPrint("***********************************************")

	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			--DebugPrint(res.Body)
			if countCheckTime <= 3 then
				DebugPrint("RECONNECT RATING!!!!!!!")
				Timers:CreateTimer(15, function() 
					countCheckTime = countCheckTime + 1
					Stats.RequestDataTime(callback)
			    end)
			end
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		--DeepPrintTable(obj)
		--DebugPrint("***********************************************")
		local obj,pos,err = json.decode(res.Body)
		local dateTimeTable = {}
		if #obj > 0 then
			dateTimeTable[1] = {obj[1].bpTime, obj[1].rewardTime}
		end
		CustomNetTables:SetTableValue("Shop", "datetime", dateTimeTable)
		
		---CustomNetTables:SetTableValue("stats", tostring( pId ), { steamID = obj.steamID, score = obj.score })
		return obj
		
	end)
end

function Stats.CheckDayQuest(pId)
	local hero = PlayerResource:GetSelectedHeroEntity(pId)
	if not hero or PlayerResource:GetDeaths(pId) > 0 then return end
	if GameRules:GetGameTime() - GameRules.startTime <= MIN_TIME_FOR_QUEST then return end
	local bp_data = CustomNetTables:GetTableValue("Shop", "bpday")
	if not bp_data then return end
	local player_table = CustomNetTables:GetTableValue("Shop", tostring(pId))["10"]
	local player_bp_info = CustomNetTables:GetTableValue("Shop", tostring(pId))["15"]
	if not player_table then return end

	if PlayerResource:GetConnectionState(pId) ~= 2 then
		return
	end

	for i = 1, 3 do
		local quest_data = player_table["1"] and player_table["1"][tostring(i)]
		if not quest_data or not quest_data["1"] then goto continue end
		local quest_id = quest_data["1"]
		local quest = bp_data[quest_id]
		
		if not quest then goto continue end
		if tonumber(quest.donate) == 1 and (not player_bp_info or not player_bp_info["0"] or player_bp_info["0"] == "none") then
			goto continue
		end

		local dataBPtmp = {}
		dataBPtmp.KeyId = tostring(quest_data["3"])
		dataBPtmp.IdQuest = tostring(quest_data["1"])
		dataBPtmp.SteamID = tostring(PlayerResource:GetSteamID(pId))
		dataBPtmp.MatchID = tostring(GameRules:Script_GetMatchID() or 0)

		if isQuestCompleted(quest, pId) then
			local progress = quest_data["2"] or 0
			if tonumber(progress) + 1 == tonumber(quest.count) then
				Shop.GetXpBattlepass(pId, callback)
				Shop.GetDayDone(dataBPtmp, callback)
			elseif tonumber(progress) + 1 < tonumber(quest.count) then
				Shop.GetDayDone(dataBPtmp, callback)
			end
		end

		::continue::
	end
end

function isQuestCompleted(q, pId)
	local hero = PlayerResource:GetSelectedHeroEntity(pId)
	if not hero then return false end

	if q.team and q.team ~= tostring(PlayerResource:GetTeam(pId)) then
		return false
	end

	if q.map and q.map ~= "" then
		local map = GameRules.MapName:lower()
		if string.match(map,q.map) then
			return true
		end
	end

	if hero:HasModifier("modifier_" .. q.icon) or hero:HasModifier("modifier_" .. q.icon .. "_x4") then
		return true
	end

	return false
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