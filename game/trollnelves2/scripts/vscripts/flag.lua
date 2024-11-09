local lastFlagTime = {}



function FlagStart(eventSourceIndex, event)
	--DebugPrint("FlagStart")
	if event.target ~= nil then
		local hero = PlayerResource:GetSelectedHeroEntity(event.target)
		local casterHero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)	
		local playerName = PlayerResource:GetPlayerName(event.PlayerID)
		if string.match(GetMapName(),"clanwars") or string.match(GetMapName(),"1x1") then
			SendErrorMessage(event.PlayerID, "You cannot send the Flag in ClanWars mode.")
			return 
		end 
		if casterHero:IsElf() and hero:IsElf() and PlayerResource:GetConnectionState(event.target) == 2 
		    and GameRules.PlayersBase[event.PlayerID] ~= nil and GameRules.countFlag[event.PlayerID] == nil
			-- and (GameRules:GetGameTime() - GameRules.startTime < 120  or  (lastFlagTime[event.target] == nil or lastFlagTime[event.target] + 240 < GameRules:GetGameTime()) )
			and (lastFlagTime[event.PlayerID] == nil or lastFlagTime[event.PlayerID] + 60 < GameRules:GetGameTime()) then	
			--DebugPrint("FlagStart SEND")
			lastFlagTime[event.PlayerID] = GameRules:GetGameTime()
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.target), "show_flag_options", {["name"] = playerName, ["id"] = event.target,["casterID"] = event.casterID} )
			GameRules.PlayersBaseSendFlag[event.PlayerID] = 1 
		elseif GameRules.PlayersBase[event.PlayerID] == nil then 
			SendErrorMessage(event.PlayerID, "You have no bases.")
		elseif GameRules.countFlag[event.PlayerID] ~= nil then
			SendErrorMessage(event.PlayerID, "You can only invite 1 person.")
		else 
			local timeLeft = math.ceil(lastFlagTime[event.PlayerID] + 60 - GameRules:GetGameTime())
			SendErrorMessage(event.PlayerID, "You will be able to send the flag in " .. timeLeft .. " seconds.")
		end
	end	
end

function FlagGive(eventSourceIndex, event)
	--DebugPrint("event.vote " .. event.vote)
	local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
	local caster = PlayerResource:GetSelectedHeroEntity(event.casterID)
	if event.vote == 1 and caster:IsElf() and hero:IsElf() and GameRules.PlayersBase[event.casterID] ~= nil and GameRules.countFlag[event.casterID] == nil and GameRules.PlayersBaseSendFlag[event.casterID] ~= nil then
        --DebugPrint("GameRules.PlayersBase[event.casterID] FlagGive " .. GameRules.PlayersBase[event.casterID])
        --DebugPrint("event.casterID FlagGive " .. event.casterID)
		if hero.units ~= nil then
			for i=1,#hero.units do
				if hero.units[i] and not hero.units[i]:IsNull() and hero.units[i]:GetUnitName() == "flag" then
					local unit = hero.units[i]
					--unit:ForceKill(true)
					unit:Kill(nil, unit)
				end
			end
		end
		-- hero:RemoveAbility("build_flag")
        local abil2 = hero:FindAbilityByName("build_flag")
        abil2:EndCooldown()
		GameRules.PlayersBase[event.PlayerID] = GameRules.PlayersBase[event.casterID]
		GameRules.countFlag[event.PlayerID] = GameRules.PlayersBase[event.casterID]
		GameRules.countFlag[event.casterID] = GameRules.PlayersBase[event.casterID]
		hero:RemoveModifierByName("modifier_antibase")
		Timers:CreateTimer(0.33, function()
			hero:RemoveModifierByName("modifier_antibase")
		end)
		
		text = PlayerResource:GetPlayerName(event.PlayerID) .. " accepted the invitation to private the base."
		GameRules:SendCustomMessageToTeam("<font color='#FF0000'>"  .. text  .. "</font>" , hero:GetTeamNumber(), hero:GetTeamNumber(), hero:GetTeamNumber())
		local takeFlag = 30
		Timers:CreateTimer(function()
			if takeFlag > 0 then
				for _, v in ipairs(hero.units) do
					if string.match(v:GetUnitName(),"flag")  then
						return nil
					end
				end
				if takeFlag <= 15 then
					SendErrorMessage(event.PlayerID, "You have " .. takeFlag .. " sec to build the Flag.")
				end
				takeFlag = takeFlag - 1
				return 1.0
			else
				GameRules.PlayersBase[event.PlayerID] = nil
			end
		end)
	else
		text = PlayerResource:GetPlayerName(event.PlayerID) .. " canceled the request for a private base."
		GameRules:SendCustomMessageToTeam("<font color='#FF0000'>"  .. text  .. "</font>" , hero:GetTeamNumber(), hero:GetTeamNumber(), hero:GetTeamNumber())
	end
	GameRules.PlayersBaseSendFlag[event.casterID] = nil
end