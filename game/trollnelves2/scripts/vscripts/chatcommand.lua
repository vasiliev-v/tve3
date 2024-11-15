if chatcommand == nil then
	_G.chatcommand = class({})
end
local lastCommandChat = {}

function chatcommand:OnPlayerChat(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.playerid)
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(event.playerid))
	if event.text == "!rank" and GameRules:GetGameTime() - GameRules.startTime > 60 and 
		(lastCommandChat[event.playerid] == nil or lastCommandChat[event.playerid] + 120 < GameRules:GetGameTime() - GameRules.startTime) then
		local message =  PlayerResource:GetPlayerName(event.playerid) .. " has a Elf score: " .. GameRules.scores[event.playerid].elf .. "; Troll score: " .. GameRules.scores[event.playerid].troll
		GameRules:SendCustomMessage("<font color='#00FF80'>" ..  message ..  "</font>", event.playerid, 0)		
		lastCommandChat[event.playerid] = GameRules:GetGameTime() 
		elseif event.text == "!bonus" and GameRules:GetGameTime() - GameRules.startTime > 60 and 
		(lastCommandChat[event.playerid] == nil or lastCommandChat[event.playerid] + 120 < GameRules:GetGameTime() - GameRules.startTime) then
		if GameRules.BonusPercent  > 0.77 then
			GameRules.BonusPercent = 0.77
		end
		local text = "Total rating bonus for this match " .. (GameRules.BonusPercent * 100) .. "%!"
		GameRules:SendCustomMessage("<font color='#00FF80'>" .. text ..  "</font>" , 1, 1)
		lastCommandChat[event.playerid] = GameRules:GetGameTime() 
		elseif event.text == "!list" and (PlayerResource:GetSteamAccountID(event.playerid) == 201083179 
		or PlayerResource:GetSteamAccountID(event.playerid) == 337000240 
		or PlayerResource:GetSteamAccountID(event.playerid) == 183899786 
		or PlayerResource:GetSteamAccountID(event.playerid) == 155143382
		or PlayerResource:GetSteamAccountID(event.playerid) == 381067505) then
		for pID = 0,DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) then
				local text = "Nick: " .. PlayerResource:GetPlayerName(pID) .. " pID: " .. pID
				GameRules:SendCustomMessage(text, 1, 1)
			end
		end
		elseif string.match(event.text,"%D+") == "!kick" and PlayerResource:GetSteamAccountID(event.playerid) == 201083179 then
		local id_kick = tonumber(string.match(event.text,"%d+"))
		local hero_kick = PlayerResource:GetSelectedHeroEntity(id_kick)
		--if hero:GetTeamNumber() == hero_kick:GetTeamNumber() then
			-- hero_kick:ForceKill(true)
			hero_kick:Kill(nil, hero_kick)
			if hero_kick.units ~= nil then
				for i=1,#hero_kick.units do
					if hero_kick.units[i] and not hero_kick.units[i]:IsNull() then
						local unit = hero_kick.units[i]
						-- unit:ForceKill(false)
						unit:Kill(nil, unit)
					end
				end
			end
		--end
		elseif string.match(event.text,"%D+") == "!kill" and PlayerResource:GetSteamAccountID(event.playerid) == 201083179 then
		local id_kick = tonumber(string.match(event.text,"%d+"))
		local hero_kick = PlayerResource:GetSelectedHeroEntity(id_kick)
		-- hero_kick:ForceKill(true)
		hero_kick:Kill(nil, hero_kick)
		elseif event.text == "!drop" and (PlayerResource:GetSteamAccountID(event.playerid) == 201083179 
		or PlayerResource:GetSteamAccountID(event.playerid) == 337000240 
		or PlayerResource:GetSteamAccountID(event.playerid) == 183899786 
		or PlayerResource:GetSteamAccountID(event.playerid) == 155143382
		or PlayerResource:GetSteamAccountID(event.playerid) == 381067505 )  then
		local spawnPoint = hero:GetAbsOrigin()	
		local newItem = CreateItem("item_vip", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		local dropRadius = RandomFloat( 50, 100 )
		newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
		elseif event.text == "!gem" and (PlayerResource:GetSteamAccountID(event.playerid) == 201083179 
		or PlayerResource:GetSteamAccountID(event.playerid) == 337000240 
		or PlayerResource:GetSteamAccountID(event.playerid) == 183899786 
		or PlayerResource:GetSteamAccountID(event.playerid) == 155143382
		or PlayerResource:GetSteamAccountID(event.playerid) == 381067505)  then
		local spawnPoint = hero:GetAbsOrigin()	
		local newItem = CreateItem("item_get_gem", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		local dropRadius = RandomFloat( 50, 100 )
		newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )

		elseif event.text == "!donate" and (PlayerResource:GetSteamAccountID(event.playerid) == 201083179 
		or PlayerResource:GetSteamAccountID(event.playerid) == 337000240 
		or PlayerResource:GetSteamAccountID(event.playerid) == 183899786 
		or PlayerResource:GetSteamAccountID(event.playerid) == 155143382
		or PlayerResource:GetSteamAccountID(event.playerid) == 381067505)  then
		local spawnPoint = hero:GetAbsOrigin()	
		local newItem = CreateItem("item_get_gold", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		local dropRadius = RandomFloat( 50, 100 )
		newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )

		elseif string.match(event.text,"%D+") == "!delete" and PlayerResource:GetSteamAccountID(event.playerid) == 201083179 then
		local id_kick = tonumber(string.match(event.text,"%d+"))
		local hero_kick = PlayerResource:GetSelectedHeroEntity(id_kick)
		if hero:GetTeamNumber() == hero_kick:GetTeamNumber() then
			if hero_kick.units ~= nil then
				for i=1,#hero_kick.units do
					if hero_kick.units[i] and not hero_kick.units[i]:IsNull() then
						local unit = hero_kick.units[i]
						-- unit:ForceKill(false)
						unit:Kill(nil, unit)
					end
				end
			end
		end
		
		elseif event.text == "!event" and GameRules:GetGameTime() - GameRules.startTime > 60 and 
		(lastCommandChat[event.playerid] == nil or lastCommandChat[event.playerid] + 120 < GameRules:GetGameTime() - GameRules.startTime) then
		local steamID = tostring(PlayerResource:GetSteamID(event.playerid))
		local pID = tonumber(event.playerid)
		Shop.RequestEvent(pID, steamID, callback)
		lastCommandChat[event.playerid] = GameRules:GetGameTime()
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		local message = tostring(PlayerResource:GetPlayerName(pID)) .. " received " .. PoolTable["5"]["2"] .. " event items."
		GameRules:SendCustomMessage("<font color='#00FF80'>" ..  message ..  "</font>", pID, 0)

		elseif event.text == "!gps" and GameRules:GetGameTime() - GameRules.startTime > 60 and 
		(lastCommandChat[event.playerid] == nil or lastCommandChat[event.playerid] + 120 < GameRules:GetGameTime() - GameRules.startTime) then
		local steamID = tostring(PlayerResource:GetSteamID(event.playerid))
		local pID = tonumber(event.playerid)
		lastCommandChat[event.playerid] = GameRules:GetGameTime()
		if hero and hero.goldPerSecond and hero.lumberPerSecond then
			local message = tostring(PlayerResource:GetPlayerName(pID)) .. "<font color='#FFEF00'> GPS: " .. hero.goldPerSecond  .. "</font> <font color='#00FF80'> LPS: " .. hero.lumberPerSecond .. "</font>"
			GameRules:SendCustomMessage(message, pID, 0)
		end
		elseif event.text == "!test" then
		if GameRules:IsCheatMode() then 
			GameRules.test = true
			TROLL_SPAWN_TIME = 5
			PRE_GAME_TIME = 10
		end
		elseif event.text == "!test2" then
		if GameRules:IsCheatMode() then 
			GameRules.test = true
			GameRules.test2 = true
			TROLL_SPAWN_TIME = 5
			PRE_GAME_TIME = 10
		end

	elseif event.text == "!troll" then
		if GameRules:IsCheatMode() then 
			GameRules.test = true
			GameRules.test2 = true
			GameRules.trollHero =  hero
        	GameRules.trollID = event.playerid
			TROLL_SPAWN_TIME = 5
			PRE_GAME_TIME = 10
			local units = Entities:FindAllByClassname("npc_dota_creature")
			for _, unit in pairs(units) do
				local unit_name = unit:GetUnitName();
				if string.match(unit_name, "shop") or
					string.match(unit_name, "troll_hut") then
					unit:SetOwner(hero)
					unit:SetControllableByPlayer(event.playerid, true)
					unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
					unit:AddNewModifier(unit, nil, "modifier_phased", {})
					if string.match(unit_name, "troll_hut") then
						unit.ancestors = {}
						ModifyStartedConstructionBuildingCount(hero, unit_name, 1)
						ModifyCompletedConstructionBuildingCount(hero, unit_name, 1)
						BuildingHelper:AddModifierBuilding(unit)
						BuildingHelper:BlockGridSquares(GetUnitKV(unit_name, "ConstructionSize"), 0, unit:GetAbsOrigin())
					end
					elseif string.match(unit_name, "npc_dota_units_base2") then
					unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
					unit:AddNewModifier(unit, nil, "modifier_phased", {})
				end
			end
		end

		elseif event.text == "!notest" then
		if GameRules:IsCheatMode() then 
			GameRules.test = false
			GameRules.test2 = false
		end
		elseif event.text == "!mute" then
			if GameRules.Mute[event.playerid] == nil then
				GameRules.Mute[event.playerid] = true
				PoolTable["5"]["3"] = 1
				CustomNetTables:SetTableValue("Shop", tostring(event.playerid), PoolTable)
			else
				GameRules.Mute[event.playerid] = nil
				PoolTable["5"]["3"] = 0
				CustomNetTables:SetTableValue("Shop", tostring(event.playerid), PoolTable)
			end		 
		elseif event.text == "!fps" then
			GameRules.PlayersFPS[event.playerid] = true
			--StopAnimationGlobal(hero:GetPlayerOwnerID) --new
			PoolTable["5"]["4"] = 1
			CustomNetTables:SetTableValue("Shop", tostring(event.playerid), PoolTable)
		elseif event.text == "!unfps" then
			GameRules.PlayersFPS[event.playerid] = false
			PoolTable["5"]["4"] = 0
			CustomNetTables:SetTableValue("Shop", tostring(event.playerid), PoolTable)
		elseif event.text == "!birthday" and (PlayerResource:GetSteamAccountID(event.playerid) == 201083179 
		or PlayerResource:GetSteamAccountID(event.playerid) == 337000240 
		or PlayerResource:GetSteamAccountID(event.playerid) == 183899786 
		or PlayerResource:GetSteamAccountID(event.playerid) == 155143382
		or PlayerResource:GetSteamAccountID(event.playerid) == 381067505) then
		local spawnPoint = hero:GetAbsOrigin()	
		local newItem = CreateItem("item_event_birthday", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		local dropRadius = RandomFloat( 50, 100 )
		newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )

		--[[
	elseif event.text == "!test23" then
		for pID = 0, DOTA_MAX_TEAM_PLAYERS do
			GameRules:SendCustomMessage("_____________________", 0, 0)
			GameRules:SendCustomMessage(tostring(PlayerResource:GetPlayerName(pID)) , 0, 0)
           	if not PlayerResource:IsValidPlayerID(pID) then
        		GameRules:SendCustomMessage("IsValidPlayerID " .. pID, 1, 1)
    		end

			if PlayerResource:IsFakeClient(pID) then 
				GameRules:SendCustomMessage("IsFakeClient " .. pID, 1, 1)
			end
			GameRules:SendCustomMessage("Playeid " .. pID  .. " team " .. PlayerResource:GetTeam(pID) ,  0, 0)
			local hero = PlayerResource:GetSelectedHeroEntity(pID)
			if not hero then
				GameRules:SendCustomMessage("not hero" ,  0, 0)
			end
			GameRules:SendCustomMessage("GetSteamAccountID " .. PlayerResource:GetSteamAccountID(pID), 0, 0)
			GameRules:SendCustomMessage("GetCustomTeamAssignment: " .. PlayerResource:GetCustomTeamAssignment(pID) .. " pID: " .. pID, 1, 1)
			GameRules:SendCustomMessage("GetLiveSpectatorTeam: " .. PlayerResource:GetLiveSpectatorTeam(pID) .. " pID: " .. pID, 1, 1)
			GameRules:SendCustomMessage("GetTeam: " .. PlayerResource:GetTeam(pID) .. " pID: " .. pID, 1, 1)
			GameRules:SendCustomMessage("IsValidTeamPlayer: " .. tostring(PlayerResource:IsValidTeamPlayer(pID))  .. " pID: " .. pID, 1, 1)
			GameRules:SendCustomMessage("IsValidTeamPlayerID: " .. tostring(PlayerResource:IsValidTeamPlayerID(pID)) .. " pID: " .. pID, 1, 1)
			GameRules:SendCustomMessage("_____________________" .. pID, 0, 0)
			
			
        end
		
		elseif event.text == "!map" then
			local mapList = {{"summer", -127},{"spring",-127},{"autumn", -127.125},{"ghosttown", -127},{"winter", 1},{"china", -238.125},{"desert", -127},{"jungle", -127}}
            local map = mapList[7] -- mapList[RandomInt(1,#mapList)]
            GameRules.MapName = map[1]
            local vector = map[2]
            --DebugPrint("mapname " .. GameRules.MapName .. " " .. vector)
            DOTA_SpawnMapAtPosition( GameRules.MapName, Vector(0,0,vector), false, nil,  Dynamic_Wrap( BuildingHelper, "UpdateGrid"), nil )
		elseif event.text == "!remap" then
			BuildingHelper.Grid = {} -- Construction grid
			BuildingHelper.Terrain = {} -- Terrain grid, this only changes when a tree is cut
			BuildingHelper.Encoded = "" -- String containing the base terrain, networked to clients
			BuildingHelper.squareX = 0 -- Number of X grid points
			BuildingHelper.squareY = 0 -- Number of Y grid points
			BuildingHelper:InitGNV()
			local args = {}
			args.PlayerID = 0
			BuildingHelper:SendGNV(args)
			GameRules.angel_spawn_points = Entities:FindAllByName("angel_spawn_point")
			GameRules.shops = Entities:FindAllByClassname("trigger_shop")
			GameRules.base = Entities:FindAllByName("trigger_base")
			GameRules.baseBlock = Entities:FindAllByName("trigger_antibild")
			GameRules.MapName = GameRules.MapName .. GameRules.MapSpeed .. "x"
			GameRules:SendCustomMessage("<font color='#00FF22 '> Map: "  .. GameRules.MapName .. "</font>" ,  0, 0)

			]]
	--elseif event.text == "!skin" then
	--	Shop.GetVip(GameRules.SaveDefItem[event.playerid],callback)
		--elseif event.text == "!xp" then
		--	GameRules:SendCustomMessage("<font color='#00FF80'>" .. hero:GetCurrentXP() ..  "</font>" , 1, 1)
		--elseif event.text == "!xpup" then
		--	hero:AddExperience(50,DOTA_ModifyXP_Unspecified,false,false)

		--[[
		elseif event.text == "!map" then
			DOTA_SpawnMapAtPosition( "winter", Vector(0,0,1), false, nil, nil, nil )
		elseif event.text == "!map1" then
			DOTA_SpawnMapAtPosition( "spring", Vector(0,0,0), false, nil, nil, nil )
		elseif event.text == "!map2" then
			DOTA_SpawnMapAtPosition( "summer", Vector(0,0,0), false, nil, nil, nil )
		elseif event.text == "!map11" then
			DOTA_SpawnMapAtPosition( "winter", Vector(0,0,1), true, nil, nil, nil )
		elseif event.text == "!remap" then
			BuildingHelper.Grid = {} -- Construction grid
   			BuildingHelper.Terrain = {} -- Terrain grid, this only changes when a tree is cut
    		BuildingHelper.Encoded = "" -- String containing the base terrain, networked to clients
    		BuildingHelper.squareX = 0 -- Number of X grid points
    		BuildingHelper.squareY = 0 -- Number of Y grid points
			BuildingHelper:InitGNV()
			local args = {}
			args.PlayerID = 0
			BuildingHelper:SendGNV(args)
	]]

	--elseif event.text == "!fps" then
	--	GameRules.PlayersFPS[event.playerid] = true
	--	if hero.units ~= nil then
	--		for i=1,#hero.units do
	--			if hero.units[i] and not hero.units[i]:IsNull() then
	--				local unit = hero.units[i]
	--				--DebugPrint(unit:GetUnitName())
	--				local dataTable = { entityIndex = unit:GetEntityIndex() }
	--				local player = hero:GetPlayerOwner()
	--				if player then
	--					if string.match(hero.units[i]:GetUnitName(),"mine") then
	--						CustomGameEventManager:Send_ServerToPlayer(player, "gold_gain_stop", dataTable)
	--					elseif string.match(hero.units[i]:GetUnitName(),"wisp") then 
	--						CustomGameEventManager:Send_ServerToPlayer(player, "tree_wisp_harvest_stop", dataTable)
	--					end
	--				end
	--			end
	--		end
	--	end
	--elseif event.text == "!unfps" then
	--	GameRules.PlayersFPS[event.playerid] = false
	--	if hero.units ~= nil then
	--		for i=1,#hero.units do
	--			if hero.units[i] and not hero.units[i]:IsNull() then
	--				local unit = hero.units[i]
	--				--DebugPrint(unit:GetUnitName())
	--				local dataTable = { entityIndex = unit:GetEntityIndex() }
	--				local player = hero:GetPlayerOwner()
	--				if player then
	--					if string.match(hero.units[i]:GetUnitName(),"mine") then
	--						CustomGameEventManager:Send_ServerToPlayer(player, "gold_gain_start", dataTable)
	--					elseif string.match(hero.units[i]:GetUnitName(),"wisp") then
	--						CustomGameEventManager:Send_ServerToPlayer(player, "tree_wisp_harvest_start", dataTable)
	--					end
	--				end
	--			end
	--		end
	--	end
	--elseif event.text  ==  "stats"  then
	--local playerStatsScore = CustomNetTables:GetTableValue("scorestats",tostring(event.playerid)); 
	--CustomNetTables:SetTableValue("scorestats", tostring(event.playerid), { playerScoreElf = tostring(GameRules.scores[event.playerid].elf), playerScoreTroll = tostring(GameRules.scores[event.playerid].troll) })
	----DebugPrint(GameRules.scores[event.playerid].elf)
	----DebugPrint(GameRules.scores[event.playerid].troll)
	----DebugPrintTable("playerStatsScore   "  ..  playerStatsScore)
	--elseif event.text == "blink" then 
	--	hero:ClearInventoryCM()
	--elseif event.text == "test" then
	--local data = {}
	--data.SteamID = tostring(PlayerResource:GetSteamID(event.playerid))
	--data.Num = "2"
	--data.Srok = "01/09/2020"
	--Shop.GetVip(data, callback)
	--http.SendRequest("post", "/test", "228")
	
	--elseif event.text == "get" then
	--Stats.RequestDataTop10(callback)
	--local stats = CustomNetTables:GetTableValue( "top10", "test" )
	----DebugPrint(stats)
	----DebugPrintTable(stats)
	--trollnelves2:OnLoadTop(stats.steamID, 1)
	--elseif event.text == "test_r" then
	--GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
	--Stats.SubmitMatchData(DOTA_TEAM_BADGUYS, callback)
	--GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
		elseif event.text  ==  "!money"  then
			-- PlayerResource:ModifyGold(hero, nil)
			--
			--local PoolTable = CustomNetTables:SetTableValue("buildings", "tower_19")
			DebugPrintTable(GameRules.buildingRequirements["tower_19"])
		end
end