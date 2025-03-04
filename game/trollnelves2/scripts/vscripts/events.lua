local lastSendTime = {}
local lastTakeGoldTime = {}
require('stats')
require('clanwars')
require('donate_store/shop')
require('libraries/entity')
require('drop')
require('settings')
require('error_debug')



function trollnelves2:OnGameRulesStateChange()
    --DebugPrint("GameRulesStateChange ******************")
    local newState = GameRules:State_Get()
    --DebugPrint(newState)
    if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        trollnelves2:GameSetup()
        trollnelves2:PostLoadPrecache()
    elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
        self:PreStart()
    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

    elseif newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD  then
 
    end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function trollnelves2:OnNPCSpawned(keys)
    --DebugPrint("OnNPCSpawned:")
    local npc = EntIndexToHScript(keys.entindex)
    if npc.GetPhysicalArmorValue then
        npc:AddNewModifier(npc, nil, "modifier_custom_armor", {})
    end
    if npc:IsHero() then
        Timers:CreateTimer(0.1,function() for i=0,15 do
                local item = npc:GetItemInSlot(i)
                if item and (item:GetName() == "item_enchanted_mango"  or item:GetName() == "item_tpscroll") then
                    npc:TakeItem(item)
                end
            end
        end)
    end
    if npc:IsRealHero() and npc.bFirstSpawned == nil then
        THINK_INTERVAL = 2
        npc.bFirstSpawned = true
        if IsServer() then
            trollnelves2:OnHeroInGame(npc)
        end
    end
    if npc:IsAngel() and PlayerResource:GetConnectionState(npc:GetPlayerOwnerID()) ~= 2 and not GameRules.test and not GameRules.test2 then
        npc:AddNewModifier(nil, nil, "modifier_disconnected", {})
    end
    if npc:IsWolf() and PlayerResource:GetConnectionState(npc:GetPlayerOwnerID()) ~= 2 and not GameRules.test and not GameRules.test2 then
        npc:AddNewModifier(nil, nil, "modifier_disconnected", {})
    end
    if npc:IsRealHero() then
        local info = {}
        info.PlayerID = npc:GetPlayerID()
        info.hero = npc
        -- local rand = RandomInt(1, 2)
        -- if rand == 1 then
        	Pets.CreatePet( info )
		-- end
        --npc:SetCustomHealthLabel("top1autumn",  123, 11, 78)
    end
    if npc:IsWolf() then
        npc:AddNewModifier(npc, nil, "modifier_death_armor", {})
        npc:AddNewModifier(npc, nil, "modifier_phased", {Duration = 1})
        ResolveNPCPositions(npc:GetAbsOrigin(),130)
    end
  --  if npc:IsAngel() then
  --      npc:AddNewModifier(npc, nil, "modifier_death_mana", {})
  --   end
    if npc:IsAngel() then
        PlayerResource:SetCustomTeamAssignment(npc:GetPlayerID(), DOTA_TEAM_GOODGUYS) -- A workaround for wolves sometimes getting stuck on elves team, I don't know why or how it happens.
        npc:SetTeam(DOTA_TEAM_GOODGUYS)
    end
    if EVENT_START then
        --Halloween(npc)  
    end
end

function trollnelves2:OnPlayerReconnect(event)
    local playerID = event.PlayerID

    if GameRules.disconnectedHeroSelects[playerID] then
        Timers:CreateTimer(0, function()
            if PlayerResource:GetConnectionState(playerID) == DOTA_CONNECTION_STATE_CONNECTED then
              Timers:CreateTimer(2.25, function()
                --DebugPrint("222 GameRules.disconnectedHeroSelects[playerID] " .. tostring(GameRules.disconnectedHeroSelects[playerID]))
                local heroname = GameRules.disconnectedHeroSelects[playerID]
                -- PlayerResource:SetSelectedHero(playerID, GameRules.disconnectedHeroSelects[playerID])
                local hero = CreateHeroForPlayer("npc_dota_hero_crystal_maiden", PlayerResource:GetPlayer(playerID))
                PlayerResource:GetPlayer(playerID):SetAssignedHeroEntity(hero)
                local oldhero = hero
                hero = PlayerResource:ReplaceHeroWith(playerID, heroname ,0,0)
                hero = PlayerResource:GetSelectedHeroEntity(playerID)
                if hero then
                    UpdateSpells(hero)
                    hero:SetAbilityPoints(0)
                    PlayerResource:ModifyGold(hero, 0)
                    PlayerResource:ModifyLumber(hero, 0)
                    PlayerResource:ModifyFood(hero, 0)
                    PlayerResource:ModifyWisp(hero, 0)
                    PlayerResource:ModifyMine(hero, 0)
                    PlayerResource:ModifyWispMine(hero, 0)
                    ModifyLumberPrice(0)
                    hero:CalculateStatBonus(true)
                    hero:RemoveModifierByName("modifier_disconnected")
                    GameRules.disconnectedHeroSelects[playerID] = nil
                    if hero:IsElf() and hero:IsAlive() then
                        hero.alive = true
                        UpdateSpells(hero)
                        PlayerResource:ModifyMine(hero, 0)
                        PlayerResource:ModifyWispMine(hero, 0)
                       -- local args = {}
                       -- args.PlayerID = playerID
                       -- BuildingHelper:SendGNV(args)
                        --Timers:CreateTimer(5, function()
                        --    BuildingHelper:SendGNV(args)
                        --end)
                    end
                    if hero.units ~= nil then
                        for i=1,#hero.units do
                            if hero.units[i] and not hero.units[i]:IsNull() then
                                local unit = hero.units[i]
                                unit:RemoveModifierByName("modifier_disconnected_unit")
                            end
                        end
                    end
                    if oldhero then
                        UTIL_Remove(oldhero)
                    end
                else
                    --DebugPrint("FFUCK HERO IS NULL!!!!")
                end
              end)
            else
              return 0.03
            end
          end)
    end
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    if hero then
        if hero.legitChooser then
            local args = {}
            args.team = DOTA_TEAM_GOODGUYS
            args.PlayerID = playerID
            ChooseHelpSide(playerID, args)
        end
        hero:RemoveModifierByName("modifier_disconnected") 
        if hero:IsAngel() then 
            if hero:HasModifier("modifier_stand_invis") then
                hero:RemoveModifierByName("modifier_stand_invis")
            end
            if hero:HasModifier("modifier_invisible") then
                hero:RemoveModifierByName("modifier_invisible")
            end
        end
        UpdateSpells(hero)
        hero:SetAbilityPoints(0)
        PlayerResource:ModifyGold(hero, 0)
        PlayerResource:ModifyLumber(hero, 0)
        ModifyLumberPrice(0)
        hero:CalculateStatBonus(true)
        PlayerResource:NewSelection(hero:GetPlayerOwnerID(), PlayerResource:GetSelectedHeroEntity(hero:GetPlayerOwnerID()))
        if hero:IsElf() and hero:IsAlive() then
            hero.alive = true
            UpdateSpells(hero)
            PlayerResource:ModifyFood(hero, 0)
            PlayerResource:ModifyWisp(hero, 0)
            PlayerResource:ModifyMine(hero, 0)
            PlayerResource:ModifyWispMine(hero, 0)
            --local args = {}
           -- args.PlayerID = playerID
            --BuildingHelper:SendGNV(args)
            --Timers:CreateTimer(5, function()
            --    BuildingHelper:SendGNV(args)
            --end)
        end
        if hero.units ~= nil then
            for i=1,#hero.units do
                if hero.units[i] and not hero.units[i]:IsNull() then
                    local unit = hero.units[i]
                    unit:RemoveModifierByName("modifier_disconnected_unit")
                end
            end
        end
    else
        Timers:CreateTimer(0, function()
            if PlayerResource:GetConnectionState(playerID) == DOTA_CONNECTION_STATE_CONNECTED then
              Timers:CreateTimer(2.25, function()
                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
                if hero then
                    hero:RemoveModifierByName("modifier_disconnected")    
                    local args = {}
                    args.PlayerID = playerID
                    BuildingHelper:SendGNV(args)
                    if hero.units ~= nil then
                        for i=1,#hero.units do
                            if hero.units[i] and not hero.units[i]:IsNull() then
                                local unit = hero.units[i]
                                unit:RemoveModifierByName("modifier_disconnected_unit")
                            end
                        end
                    end
                else
                    --DebugPrint("FFUCK HERO IS NULL!!!! 2222")
                end
              end)
            else
              return 0.03
            end
        end)
    end
end

function trollnelves2:OnDisconnect(event)
    local playerID = event.PlayerID
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    if hero == nil then
        return
    end

    if PlayerResource:GetDeaths(playerID) > 0 then
        hero.LeaveGame = 1
    end
    local team = hero:GetTeamNumber()
    local trollLoseTimer = 300
    local elfLoseTimer = 180
    if team == DOTA_TEAM_GOODGUYS and not string.match(GetMapName(),"clanwars") then
        hero:AddNewModifier(nil, nil, "modifier_disconnected", {})
        if hero.alive == true then
            hero.alive = false
            hero.dced = true
            local lastAlive = true
            for i = 0, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) do
                local pID = PlayerResource:GetNthPlayerIDOnTeam(2, i)
                local hero2 = PlayerResource:GetSelectedHeroEntity(pID) or false
                if hero2 and hero2.alive then
                    lastAlive = false
                    break
                end
            end
            if lastAlive then
                Timers:CreateTimer(function()
                    if elfLoseTimer > 0 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 2 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 4 then
                        Notifications:ClearBottomFromAll()
                        Notifications:BottomToAll(
                            {
                                text = "The Elf will lose in " .. elfLoseTimer,
                                style = {color = '#E62020'},
                                duration = 1
                            })
                            elfLoseTimer = elfLoseTimer - 1
                            return 1.0
                            elseif elfLoseTimer > 0 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) == 2 then
                            return nil
                            elseif elfLoseTimer <= 0 or PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) == 4 then
                            GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
                            local status, nextCall = Error_debug.ErrorCheck(function() 
                                Stats.SubmitMatchData(DOTA_TEAM_BADGUYS, callback)
                            end)
                            GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
                            return nil
                    end
                end)
            end
        end
        if hero.units ~= nil then
            for i=1,#hero.units do
                if hero.units[i] and not hero.units[i]:IsNull() then
                    local unit = hero.units[i]
                    unit:AddNewModifier(unit, unit, "modifier_disconnected_unit", {Duration=300})
                end
            end
        end
        elseif team == DOTA_TEAM_BADGUYS and not string.match(GetMapName(),"clanwars")  then
        hero:MoveToPosition(Vector(0, 0, 0))
        if hero:IsWolf() then
            --hero:AddNewModifier(nil, nil, "modifier_disconnected", {})
            hero:RemoveModifierByName("modifier_disconnected") 
            --[[
            Timers:CreateTimer(60, function()
                if hero ~= nil and GameRules.KickList[playerID] ~= 1 then
                    if PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 2 then
                        local wolfNetworth = hero:GetNetworth()
                        local lumber = wolfNetworth / 64000 or 0
                        local gold = math.floor((lumber - math.floor(lumber)) * 64000) or 0
                        lumber = math.floor(lumber)
                        hero:ClearInventory()
                        hero:RemoveDesol2()
                        PlayerResource:ModifyGold(GameRules.trollHero, gold, true)
                        PlayerResource:ModifyLumber(GameRules.trollHero, lumber, true)
                        PlayerResource:SetGold(hero, 0, true)
                        PlayerResource:SetLumber(hero, 0, true)
                    end
                end
            end)
            ]]
        end
    end
    if hero:IsTroll() and not string.match(GetMapName(),"clanwars") then
        Timers:CreateTimer(function()
            if trollLoseTimer > 0 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 2  and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 4 then
                Notifications:ClearBottomFromAll()
                Notifications:BottomToAll(
                    {
                        text = "The Troll will lose in " .. trollLoseTimer,
                        style = {color = '#E62020'},
                        duration = 1
                    })
                    trollLoseTimer = trollLoseTimer - 1
                    return 1.0
                    elseif trollLoseTimer > 0 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) == 2 then
                    return nil
                    elseif trollLoseTimer <= 0 or PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) == 4 then
                    GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
                    local status, nextCall = Error_debug.ErrorCheck(function() 
                        Stats.SubmitMatchData(DOTA_TEAM_GOODGUYS, callback)
                    end)
                    GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
                    return nil
            end
        end)
    end
    
end

function trollnelves2:OnConnectFull(keys)
    --DebugPrint("OnConnectFull ******************")
  --  local entIndex = keys.index + 1
    -- The Player entity of the joining user
  --  local player = EntIndexToHScript(entIndex)
  --  local userID = keys.userid
   -- GameRules.userIds = GameRules.userIds or {}
    -- The Player ID of the joining player
   -- local playerID = player:GetPlayerID()
   -- GameRules.userIds[userID] = playerID
    trollnelves2:_Capturetrollnelves2()
    
end

function trollnelves2:OnConnectPlayer(keys)
    --DebugPrint("OnConnectPlayer ******************")
    --DebugPrintTable(keys)
end



function trollnelves2:OnItemPickedUp(keys)
    print('[BAREBONES] OnItemPickedUp')
    DeepPrintTable(keys)
    local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
    local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    local itemname = keys.itemname
    
    if (hero:IsAngel() or hero:IsElf()) and (string.match(itemname,"hp") or string.match(itemname,"armor") or string.match(itemname,"dmg") or string.match(itemname,"spd") or string.match(itemname,"boots")  or string.match(itemname,"repair") or string.match(itemname,"havoc")) then 
        hero:TakeItem(itemEntity)
        return
    end  

    if itemname == "item_tpscroll" then 
        hero:TakeItem(itemEntity)
        return
    end 
    --[[
    if hero:GetNumItemsInInventory() > 6 then
        local spawnPoint = hero:GetAbsOrigin() + RandomFloat(50, 100)
         local newItem = CreateItem(itemname, itemEntity:GetPurchaser(), itemEntity:GetPurchaser())
        local drop = CreateItemOnPositionForLaunch(spawnPoint, newItem)
        newItem:LaunchLootInitialHeight(false, 0, 150, 0.5, spawnPoint)
        hero:TakeItem(itemEntity)
    end
    --]]
end

function trollnelves2:OnItemAddedInv(keys)
    print('[BAREBONES] OnItemAddedInv')
    DeepPrintTable(keys)
    local hero = EntIndexToHScript(keys.inventory_parent_entindex)
    local itemEntity = EntIndexToHScript(keys.item_entindex)
    local player = PlayerResource:GetPlayer(keys.inventory_player_id)
    local itemname = keys.itemname
    if hero ~= nil then
        if itemname == "item_tpscroll" then 
            hero:TakeItem(itemEntity)
        end 
        if (hero:IsAngel() or hero:IsElf()) and (string.match(itemname,"hp") or string.match(itemname,"armor") or string.match(itemname,"dmg") or string.match(itemname,"spd") or string.match(itemname,"boots")  or string.match(itemname,"repair") or string.match(itemname,"havoc")) then 
            hero:TakeItem(itemEntity)
            return
        end  
        if hero:GetNumItemsInInventory() > 6 then
            local spawnPoint = hero:GetAbsOrigin() + RandomFloat(50, 100)
            local newItem = CreateItem(itemname, itemEntity:GetPurchaser(), itemEntity:GetPurchaser())
            local drop = CreateItemOnPositionForLaunch(spawnPoint, newItem)
            newItem:LaunchLootInitialHeight(false, 0, 150, 0.5, spawnPoint)
            hero:TakeItem(itemEntity)
        end
    end
end

--[[
	This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
	It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function trollnelves2:OnAllPlayersLoaded()
    --DebugPrint("[TROLLNELVES2] All Players have loaded into the game")
    
end

function trollnelves2:OnEntityKilled(keys)
    local killed = EntIndexToHScript(keys.entindex_killed)
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local killedPlayerID = killed:GetPlayerOwnerID()
    local attackerPlayerID = attacker:GetPlayerOwnerID()
    if GameRules.Bonus[attackerPlayerID] == nil then
        GameRules.Bonus[attackerPlayerID] = 0
    end
    
    local info = {}
    info.PlayerID = killedPlayerID
    info.hero = killed
    
    if killed ~= nil then
        drop:RollItemDrop(killed)
    end

    if IsBuilder(killed) then BuildingHelper:ClearQueue(killed) end
    if killed:IsRealHero() then
        local bounty = -1
        if killed:IsElf() then
            for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) then
                    if GameRules.PlayersBase[pID] == GameRules.PlayersBase[killedPlayerID] and pID ~= killedPlayerID then
                        GameRules.countFlag[pID] = nil
                    end
                end
            end

            GameRules.countFlag[killedPlayerID] = nil
            GameRules.PlayersBase[killedPlayerID] = nil

            bounty = ElfKilled(killed)
            if string.match(GetMapName(),"clanwars") then
                for pID=0,DOTA_MAX_TEAM_PLAYERS do
                    if PlayerResource:GetTeam(pID) == PlayerResource:GetTeam(attackerPlayerID) then
                        if GameRules.Bonus[pID] == nil then
                            GameRules.Bonus[pID] = 0 
                        end
                        GameRules.Bonus[pID] = GameRules.Bonus[pID] + 5
                    end
                end 
            else
                GameRules.Bonus[attackerPlayerID] = GameRules.Bonus[attackerPlayerID] + 5
            end
            
            local winnerTroll = CheckTrollVictory()
            if winnerTroll then
                for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                    if PlayerResource:IsValidPlayerID(pID) then
                        PlayerResource:SetCameraTarget(pID, killed)
                        Timers:CreateTimer(3, function()
                            PlayerResource:SetCameraTarget(pID, nil)
                        end)
                    end
                end
                GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
                local status, nextCall = Error_debug.ErrorCheck(function() 
                    if string.match(GetMapName(),"clanwars") then
                        Clanwars.SubmitMatchData(winnerTroll, callback)
                    else
                        Stats.SubmitMatchData(DOTA_TEAM_BADGUYS, callback)
                    end   
                end)
                GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
                return
            end
            Pets.DeletePet(info)
        elseif killed:IsTroll() then
            GameRules.Bonus[attackerPlayerID] = GameRules.Bonus[attackerPlayerID] + 5
            killed:SetTimeUntilRespawn(9999999)
            for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) then
                    PlayerResource:SetCameraTarget(pID, killed)
                    Timers:CreateTimer(3, function()
                        PlayerResource:SetCameraTarget(pID, nil)
                    end)
                end
            end
            GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
            local status, nextCall = Error_debug.ErrorCheck(function() 
                if string.match(GetMapName(),"clanwars") then
                    if killed:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
                        Clanwars.SubmitMatchData(DOTA_TEAM_BADGUYS, callback)
                    else
                        Clanwars.SubmitMatchData(DOTA_TEAM_GOODGUYS, callback)
                    end
                    
                else
                    Stats.SubmitMatchData(DOTA_TEAM_GOODGUYS, callback)
                end  
            end)
            GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
        elseif killed:IsWolf() then
            bounty = math.max(killed:GetNetworth() * 0.70,
            GameRules:GetGameTime())
            killed:SetRespawnPosition(Vector(0, -640, 256))
            killed:SetTimeUntilRespawn(WOLF_RESPAWN_TIME * PlayerResource:GetDeaths(killedPlayerID))
            killed:RemoveDesol2()
            if PlayerResource:GetDeaths(killedPlayerID) == 2 then
                GameRules.Bonus[attackerPlayerID] = GameRules.Bonus[attackerPlayerID] + 1
            end
            Pets.DeletePet(info)
        elseif killed:IsAngel() then
            bounty = math.max(PlayerResource:GetGold(killedPlayerID),
            GameRules:GetGameTime()) / 4
            PlayerResource:SetGold(killed, 0)
            killed:SetRespawnPosition(RandomAngelLocation())
            killed:SetTimeUntilRespawn(ANGEL_RESPAWN_TIME * PlayerResource:GetDeaths(killedPlayerID))

            Timers:CreateTimer(ANGEL_RESPAWN_TIME, function()
                killed:AddNewModifier(killed, nil, "modifier_invulnerable",
                {duration = 5})
            end)
            killed:ClearInventoryCM()
            Pets.DeletePet(info)
        end
        if bounty >= 0 and attacker ~= killed then
            local killedName = PlayerResource:GetSelectedHeroEntity(
            killedPlayerID) and
            PlayerResource:GetSelectedHeroEntity(
            killedPlayerID):GetUnitName() or
            killed:GetUnitName()
            local attackerName = PlayerResource:GetSelectedHeroEntity(
            attackerPlayerID) and
            PlayerResource:GetSelectedHeroEntity(
            attackerPlayerID):GetUnitName() or
            attacker:GetUnitName()
            bounty = math.floor(bounty) --here
            --rewardLb = (math.floor(rewardLb) - 1)
            PlayerResource:ModifyGold(attacker, bounty)
            --PlayerResource:ModifyLumber(attacker, rewardLb)
            local message = "%s1 (" .. GetModifiedName(attackerName) ..
            ") killed " ..
            PlayerResource:GetPlayerName(killedPlayerID) ..
            " (" .. GetModifiedName(killedName) ..
            ") for <font color='#F0BA36'>" .. bounty ..
            "</font> gold!"
            GameRules:SendCustomMessage(message, attackerPlayerID, 0)
        end
        else
        local hero = PlayerResource:GetSelectedHeroEntity(killedPlayerID)
        if string.match(killed:GetUnitName(),"troll_hut") then
            hero = GameRules.trollHero
        end
        if hero and hero.units and hero.alive then -- hero.units can contain other units besides buildings
            for i = #hero.units, 1, -1 do
                if not hero.units[i]:IsNull() then
                    if hero.units[i]:GetEntityIndex() == keys.entindex_killed then
                        table.remove(hero.units, i)
                        break
                    end
                end
            end
        end
        
        local unitTable = killed:GetKeyValue()
        local gridTable = unitTable and unitTable["Grid"]
        if IsCustomBuilding(killed) or gridTable then
            -- Building Helper grid cleanup
            BuildingHelper:RemoveBuilding(killed, false)
            
            if gridTable then
                for grid_type, v in pairs(gridTable) do
                    if tobool(v.RemoveOnDeath) then
                        local location = killed:GetAbsOrigin()
                        BuildingHelper:print(
                        "Clearing special grid of " .. grid_type)
                        if (v.Radius) then
                            BuildingHelper:RemoveGridType(v.Radius, location,
                            grid_type, "radius")
                            elseif (v.Square) then
                            BuildingHelper:RemoveGridType(v.Square, location,
                            grid_type)
                        end
                    end
                end
            end
            
            if hero then -- Skip looping unnecessarily when elf dies
                local name = killed:GetUnitName()
                -- --DebugPrint("name " .. name)
                ModifyStartedConstructionBuildingCount(hero, name, -1)
                if killed.state == "complete" then
                    ModifyCompletedConstructionBuildingCount(hero, name, -1)
                end
                if killed.ancestors then
                    for _, ancestorUnitName in pairs(killed.ancestors) do
                        if name ~= ancestorUnitName then
                            -- --DebugPrint("ancestorUnitName " .. ancestorUnitName)
                            ModifyStartedConstructionBuildingCount(hero,
                                ancestorUnitName,
                            -1)
                            ModifyCompletedConstructionBuildingCount(hero,
                                ancestorUnitName,
                            -1)
                        end
                    end
                end
                for _, v in ipairs(hero.units) do
                    UpdateUpgrades(v)
                end
                UpdateSpells(hero)
                if name == "flag" then
                    local hero2 = PlayerResource:GetSelectedHeroEntity(killedPlayerID)
                    local abil2 = hero2:FindAbilityByName("build_flag")
                    abil2:EndCooldown()
                    abil2:StartCooldown(60) 
                    GameRules.PlayersBase[killedPlayerID] = nil
                    GameRules.countFlag[killedPlayerID] = nil
                end
            end
            elseif killed:GetKeyValue("FoodCost") then
            local foodCost = killed:GetKeyValue("FoodCost")
            PlayerResource:ModifyFood(hero, -foodCost)
            elseif killed:GetKeyValue("WispCost") then
            local wisp = killed:GetKeyValue("WispCost")
            PlayerResource:ModifyWisp(hero, -wisp)
            elseif killed:GetKeyValue("MineCost") then
            local mine = killed:GetKeyValue("MineCost")
            PlayerResource:ModifyWispMine(hero, -mine)
        end
    end
end

function ElfKilled(killed)
    local killedID = killed:GetPlayerOwnerID()
    killed.alive = false
    killed.legitChooser = true
  
    --[[
    local rewardLb = ((GameRules:GetGameTime()/60) - 20)
    if rewardLb <= 0 then
        rewardLb = 1
    end
    local rewardGd = ((GameRules:GetGameTime()*GameRules:GetGameTime())/100)
    ]]
    local bounty = (PlayerResource:GetGold(killedID)/10)
    PlayerResource:SetGold(killed, 0)
    PlayerResource:SetLumber(killed, 0)
    
    for i = 1, #killed.units do
        if killed.units[i] and not killed.units[i]:IsNull() then
            local unit = killed.units[i]
            --  unit:ForceKill(false)
            unit:Kill(nil, unit)
        end
    end
    --[[
        
    ]]
    
    PlayerResource:SetCameraTarget(killedID, GameRules.trollHero)
    Timers:CreateTimer(3, function()
        PlayerResource:SetCameraTarget(killedID, nil)
    end)
    
    if string.match(GetMapName(),"clanwars") then
        UTIL_Remove(killed)
        return bounty
    end 
    
    if GameRules:GetGameTime() - GameRules.startTime >= GameRules.WOLF_START_SPAWN_TIME and GameRules.FakeList[killedID] == nil and not mod_system:GetCurrentModFromVotes() then
        local orgPlayer = killed:GetPlayerOwner()
        if orgPlayer then
            CustomGameEventManager:Send_ServerToPlayer(orgPlayer,
            "show_helper_options", {})
            Timers:CreateTimer(40, function()
                if killed and killed.legitChooser and PlayerResource:GetConnectionState(killedID) == 2 then
                    local args = {}
                    args.team = DOTA_TEAM_GOODGUYS
                    args.PlayerID = killedID
                    ChooseHelpSide(killedID, args)
                end
            end)
            else
            GameRules.dcedChoosers[killedID] = true
        end
    elseif PlayerResource:GetConnectionState(killedID) == 2 then
        local args = {}
        args.team = DOTA_TEAM_GOODGUYS
        args.PlayerID = killedID
        ChooseHelpSide(killedID, args)
    end
    if GameRules.Bonus[killedID] == nil then
        GameRules.Bonus[killedID] = 0
    end
    if GameRules.rep[killedID] == nil then
        GameRules.rep[killedID] = 0
    end
    
    if GameRules:GetGameTime() - GameRules.startTime < 300 then
        GameRules.Bonus[killedID] = GameRules.Bonus[killedID] - 150/GameRules.MapSpeed
        GameRules.rep[killedID] = GameRules.rep[killedID] - 8/GameRules.MapSpeed
    elseif GameRules:GetGameTime() - GameRules.startTime >= 300 and GameRules:GetGameTime() - GameRules.startTime <  600 then -- 5-10 min
        GameRules.Bonus[killedID] = GameRules.Bonus[killedID] - 80/GameRules.MapSpeed
        GameRules.rep[killedID] = GameRules.rep[killedID] - 4/GameRules.MapSpeed
    elseif GameRules:GetGameTime() - GameRules.startTime >= 600 and GameRules:GetGameTime() - GameRules.startTime < 1200 then -- 10-19min
        GameRules.Bonus[killedID] = GameRules.Bonus[killedID] - 20/GameRules.MapSpeed 
        GameRules.rep[killedID] = GameRules.rep[killedID] - 1
    elseif GameRules:GetGameTime() - GameRules.startTime >= 1200 and GameRules:GetGameTime() - GameRules.startTime <  1500 then -- 20-25 min
        GameRules.Bonus[killedID] = GameRules.Bonus[killedID] + 2	
    elseif GameRules:GetGameTime() - GameRules.startTime >= 1500 and GameRules:GetGameTime() - GameRules.startTime <  2400 then -- 25-40 min
        GameRules.Bonus[killedID] = GameRules.Bonus[killedID] + 8 
    elseif GameRules:GetGameTime() - GameRules.startTime >= 2400 and GameRules:GetGameTime() - GameRules.startTime <  3600 then -- 40-60 min
        GameRules.Bonus[killedID] = GameRules.Bonus[killedID] + 16 
    elseif GameRules:GetGameTime() - GameRules.startTime >= 3600 then
        GameRules.Bonus[killedID] = GameRules.Bonus[killedID] + 30  
    end
    
    return bounty
end

function CheckTrollVictory()
    local winnerTeam = DOTA_TEAM_BADGUYS
    for i = 1, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) do
        local playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)
        if hero and hero.alive then 
            if string.match(GetMapName(),"clanwars") then
                winnerTeam = false
            else
                return false 
            end
        end
    end

    if string.match(GetMapName(),"clanwars") and not winnerTeam then
        winnerTeam = DOTA_TEAM_GOODGUYS
        for i = 1, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) do
            local playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
            local hero = PlayerResource:GetSelectedHeroEntity(playerID)
            if hero and hero.alive then 
                winnerTeam = false
            end
        end
    end
    if string.match(GetMapName(),"clanwars") then
        return winnerTeam
    else
        return true 
    end
end

function GiveResources(eventSourceIndex, event)
    --DebugPrint("Give resources, event source index: ", eventSourceIndex)
    local targetID = event.target
    local casterID = event.PlayerID
    local gold = math.floor(math.abs(tonumber(event.gold)))
    local lumber = math.floor(math.abs(tonumber(event.lumber)))
    if string.match(GetMapName(),"clanwars") then
        SendErrorMessage(event.casterID, "error_not_send_money_cw")
        return 
    end 
    if GameRules.Block[targetID] ~= nil then
        SendErrorMessage(event.casterID, "error_not_send_money_block")
        return 
    end 
    
    if tonumber(event.gold) ~= nil and tonumber(event.lumber) ~= nil then
        if PlayerResource:GetSelectedHeroEntity(targetID) and
            PlayerResource:GetSelectedHeroEntity(targetID):GetTeam() ==
            PlayerResource:GetSelectedHeroEntity(casterID):GetTeam() then
            local hero = PlayerResource:GetSelectedHeroEntity(targetID)
            local casterHero = PlayerResource:GetSelectedHeroEntity(casterID)
            if gold and lumber then
                if PlayerResource:GetGold(casterID) < gold or
                    PlayerResource:GetLumber(casterID) < lumber then
                    SendErrorMessage(casterID, "error_not_enough_resources")
                    return
                end
                if hero:IsTroll() then
                    SendErrorMessage(event.casterID, "error_not_send_money_troll")
                    return 
                end
                if ((lastSendTime[targetID] == nil or lastSendTime[targetID] + 180 < GameRules:GetGameTime()) --if ((lastSendTime[targetID] == nil or lastSendTime[targetID] + 140 < GameRules:GetGameTime())
                and (lastTakeGoldTime[casterID] == nil or lastTakeGoldTime[casterID] + 60 < GameRules:GetGameTime())) or casterHero:IsAngel() then
                    local checkGold = true

                    if (gold >= 20000 and lumber >= 2) or (gold == 0 and lumber >= 2) or gold >= 20000 or (casterHero:IsAngel() and (gold >= 1 or lumber >= 1 )) then
                        PlayerResource:ModifyGold(casterHero, -gold, true)
                        PlayerResource:ModifyLumber(casterHero, -lumber, true)
                        PlayerResource:ModifyGold(hero, gold, true)
                        PlayerResource:ModifyLumber(hero, lumber, true)
                        PlayerResource:ModifyGoldGiven(targetID, gold)
                        PlayerResource:ModifyLumberGiven(targetID, lumber)
                        PlayerResource:ModifyGoldGiven(casterID, gold)
                        PlayerResource:ModifyLumberGiven(casterID, lumber)
                        local text = PlayerResource:GetPlayerName(casterHero:GetPlayerOwnerID()) .. "(" .. GetModifiedName(casterHero:GetUnitName()) .. ") has sent "
                        
                        if gold > 0 then
                            text = text .. "<font color='#F0BA36'>" .. gold .. "</font> gold"
                        end
                        
                        if gold > 0 and lumber > 0 then
                           text = text .. " and "
                        end
                        
                        if lumber > 0 then
                            text = text .. "<font color='#009900'>" .. lumber .. "</font> lumber"
                        end
                        text = text .. " to " .. PlayerResource:GetPlayerName(hero:GetPlayerOwnerID()) .. "(" .. GetModifiedName(hero:GetUnitName()) .. ")!"
                        GameRules:SendCustomMessageToTeam(text, casterHero:GetTeamNumber(), casterHero:GetTeamNumber(), casterHero:GetTeamNumber())
                    
                        if casterHero:IsAngel() == false then
                            lastSendTime[targetID] = GameRules:GetGameTime()
                            lastTakeGoldTime[targetID] = GameRules:GetGameTime()
                        end
                    elseif not casterHero:IsAngel() then
                        SendErrorMessage(casterID, "error_enter_need_money")
                    end
                    
                elseif lastSendTime[targetID] ~= nil and lastSendTime[targetID] + 180 > GameRules:GetGameTime() then
                    local timeLeft = math.ceil(lastSendTime[targetID] + 180 - GameRules:GetGameTime())
                    SendErrorMessage(casterID, "You can send money in " .. timeLeft .. " seconds!")
                else
                    local timeLeft = math.ceil(lastTakeGoldTime[casterID] + 60 - GameRules:GetGameTime())
                    SendErrorMessage(casterID, "You can send money in " .. timeLeft .. " seconds!")
                end
            end
        else
            SendErrorMessage(casterID, "error_select_only_your_allies")
        end
    else
        SendErrorMessage(casterID, "error_type_only_digits")
    end
end

function ChooseHelpSide(eventSourceIndex, event)
    local status, nextCall = Error_debug.ErrorCheck(function() 
    --DebugPrint("Choose help side: " .. eventSourceIndex);
    local team = event.team
    local playerID = event.PlayerID
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    hero.legitChooser = false
    
    if mod_system:GetCurrentModFromVotes() then
        local owner = hero:GetPlayerOwner()
        if owner then
            CustomGameEventManager:Send_ServerToPlayer(owner, "show_helper_options2", {})
        end
        return
    end
    if string.match(GetMapName(),"clanwars") then
        return
    end

    if team ~= 2 and team ~= 3 then
        local data = {}
        data.Log = "cheats coomand " .. event.PlayerID .. "  " .. event.team .. "   "  .. tostring(GameRules:Script_GetMatchID()) .. "  "  .. tostring(PlayerResource:GetSteamID(playerID))
	    data.Srok = ""
	    Error_debug.SendData(data,callback)
        return 
    end
    if not hero:IsElf() then
        local data = {}
        data.Log = "not ELF " .. event.PlayerID .. "  " .. event.team  .. "   "  .. tostring(GameRules:Script_GetMatchID()) .. "  "  .. tostring(PlayerResource:GetSteamID(playerID))
	    data.Srok = ""
	    Error_debug.SendData(data,callback)
        return 
    end
    if PlayerResource:GetDeaths(playerID) ~= 1 then
        local data = {}
        data.Log = "death no correct " .. event.PlayerID .. "  " .. event.team  .. "   "  .. tostring(GameRules:Script_GetMatchID()) .. "  "  .. tostring(PlayerResource:GetSteamID(playerID)) .. "   " .. tostring(PlayerResource:GetDeaths(playerID))
	    data.Srok = ""
	    Error_debug.SendData(data,callback)
        return 
    end
    if (GameRules:GetGameTime() - GameRules.startTime < GameRules.WOLF_START_SPAWN_TIME) and team == DOTA_TEAM_BADGUYS then
        local data = {}
        data.Log = "team no correct " .. event.PlayerID .. "  " .. event.team  .. "   "  .. tostring(GameRules:Script_GetMatchID()) .. "  "  .. tostring(PlayerResource:GetSteamID(playerID)) .. "   " .. tostring(PlayerResource:GetDeaths(playerID))
	    data.Srok = ""
	    Error_debug.SendData(data,callback)
        team = DOTA_TEAM_GOODGUYS
    end
    local newHeroName
    local message
    local timer
    local pos
    local i = 1
    local roll_chance = RandomFloat(0, 100)
    if roll_chance <= CHANCE_NEW_PERSON then
        i = 2
    end
    if team == DOTA_TEAM_GOODGUYS then
        newHeroName = ANGEL_HERO[i]
        message = "%s1 will keep helping elves and now is an " .. GetModifiedName(ANGEL_HERO[i])
        timer = ANGEL_RESPAWN_TIME
        pos = RandomAngelLocation()
        elseif team == DOTA_TEAM_BADGUYS then
        newHeroName = WOLF_HERO[i]
        message = "%s1 has joined the dark side and now will help " ..
        GetModifiedName(TROLL_HERO) .. ". %s1 is now a" ..
        GetModifiedName(WOLF_HERO[i])
        timer = 1
        pos = Vector(0, -640, 256)
    end
    PlayerResource:SetCustomTeamAssignment(playerID, team)
    Timers:CreateTimer(function()
        GameRules:SendCustomMessage(message, playerID, 0)
    end)
    hero:SetTimeUntilRespawn(timer)
    Timers:CreateTimer(timer, function()
        PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0)
        UTIL_Remove(hero)
        hero = PlayerResource:GetSelectedHeroEntity(playerID)
        PlayerResource:SetCustomTeamAssignment(playerID, team) -- A workaround for wolves sometimes getting stuck on elves team, I don't know why or how it happens.
        FindClearSpaceForUnit(hero, pos, true)
        wearables:SetWolf(playerID)
    end)
end)
end

function RandomAngelLocation()
    return (GameRules.angel_spawn_points and #GameRules.angel_spawn_points and
    #GameRules.angel_spawn_points > 0) and
    GameRules.angel_spawn_points[RandomInt(1,
    #GameRules.angel_spawn_points)]:GetAbsOrigin() or
    Vector(0, 0, 0)
end

function Halloween(npc)
    if string.match(GetMapName(),"halloween") then
        wearables:RemoveWearables(npc)
        if npc:IsAngel() then
            UpdateModel(npc, "models/heroes/death_prophet/death_prophet.vmdl", 1)  
            wearables:AttachWearable(npc, "models/items/death_prophet/drowned_siren_head/drowned_siren_head.vmdl")
            wearables:AttachWearable(npc, "models/items/death_prophet/drowned_siren_drowned_siren_skirt/drowned_siren_drowned_siren_skirt.vmdl")
            wearables:AttachWearable(npc, "models/items/death_prophet/drowned_siren_armor/drowned_siren_armor.vmdl")
            wearables:AttachWearable(npc, "models/items/death_prophet/exorcism/drowned_siren_drowned_siren_crowned_fish/drowned_siren_drowned_siren_crowned_fish.vmdl")
            wearables:AttachWearable(npc, "models/items/death_prophet/drowned_siren_misc/drowned_siren_misc.vmdl")
            elseif npc:IsWolf() then
            UpdateModel(npc, "models/heroes/life_stealer/life_stealer.vmdl", 1)  
            wearables:AttachWearable(npc, "models/items/lifestealer/bloody_ripper_belt/bloody_ripper_belt.vmdl")
            wearables:AttachWearable(npc, "models/items/lifestealer/promo_bloody_ripper_back/promo_bloody_ripper_back.vmdl")
            wearables:AttachWearable(npc, "models/items/lifestealer/bloody_ripper_arms/bloody_ripper_arms.vmdl")       
            wearables:AttachWearable(npc, "models/items/lifestealer/bloody_ripper_head/bloody_ripper_head.vmdl")   
            elseif npc:IsTroll() then            
            UpdateModel(npc, "models/items/wraith_king/arcana/wraith_king_arcana.vmdl", 1)  
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_weapon.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_arms.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_shoulder.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_armor.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_back.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_head.vmdl")
                    
            --UpdateModel(npc, "models/heroes/pudge/pudge.vmdl", 1)  
           -- wearables:AttachWearable(npc, "models/items/pudge/blackdeath_offhand/blackdeath_offhand.vmdl")
            --wearables:AttachWearable(npc, "models/items/pudge/blackdeath_belt/blackdeath_belt.vmdl")
          --  wearables:AttachWearable(npc, "models/items/pudge/blackdeath_head/blackdeath_head.vmdl")
         --   wearables:AttachWearable(npc, "models/items/pudge/blackdeath_back/blackdeath_back.vmdl")
          --  wearables:AttachWearable(npc, "models/items/pudge/blackdeath_weapon/blackdeath_weapon.vmdl")
          --  wearables:AttachWearable(npc, "models/items/pudge/blackdeath_shoulder/blackdeath_shoulder.vmdl")
         --   wearables:AttachWearable(npc, "models/items/pudge/blackdeath_arms/blackdeath_arms.vmdl")
            elseif npc:IsElf() then
            UpdateModel(npc, "models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl", 1)  
        end
    end 
end

--function StopAnim