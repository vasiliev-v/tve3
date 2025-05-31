-- This is the primary trollnelves2 trollnelves2 script and should be used to assist in initializing your game mode
-- Set this to true if you want to see a complete debug output of all events/processes done by trollnelves2
-- You can also change the cvar 'trollnelves2_spew' at any time to 1 or 0 for output/no output
TROLLNELVES2_DEBUG_SPEW = true

if trollnelves2 == nil then
    --DebugPrint('[TROLLNELVES2] creating trollnelves2 game mode')
    _G.trollnelves2 = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')

-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/util')
require('libraries/notifications')
require('libraries/popups')
require('libraries/team')
require('libraries/player')
require('libraries/entity')

require('internal/trollnelves2')
require('settings')
require('events')
require('reklama')
require('chatcommand')
require('votekick')
require('drop')
require('donate_store/wearables')
require('donate_store/SelectPets')
require('setup_state_lib')
require('pets')
require('flag')
require('filter')
require('speech_bubble/speech_bubble_class')
require('libraries/worldpanels')

function trollnelves2:PostLoadPrecache()
    Pets:Init()
    --DebugPrint("[BAREBONES] Performing Post-Load precache")
end
-- Gets called when a player chooses if he wants to be troll or not
function OnPlayerTeamChoose(eventSourceIndex, args)
    local playerID = args.PlayerID
    local vote = args["team"]
    GameRules.playerTeamChoices[playerID] = vote
end

function trollnelves2:GameSetup()
    goGame = false
    for pID = 0, DOTA_MAX_TEAM_PLAYERS do
        if  PlayerResource:GetSteamAccountID(pID) == 201083179  or  -- я 
            PlayerResource:GetSteamAccountID(pID) == 453925557  or  -- Alma
            PlayerResource:GetSteamAccountID(pID) == 183899786  or 
            PlayerResource:GetSteamAccountID(pID) == 381067505  or 

            --- Сингапур
            PlayerResource:GetSteamAccountID(pID) == 379678577 or
            PlayerResource:GetSteamAccountID(pID) == 175389622 or   -- super shy

            PlayerResource:GetSteamAccountID(pID) == 1551531770      -- sniper
            
        then
            goGame = true
        end
        
    end
    if goGame == false then
        for pID = 0, DOTA_MAX_TEAM_PLAYERS do
            GameRules.KickList[pID] = 1 
            SendToServerConsole("kick " .. PlayerResource:GetPlayerName(pID))
        end
    end

    if IsServer() then
        for pID = 0, DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayerID(pID) and not PlayerResource:IsFakeClient(pID) then
                --[[
                    GameRules:SendCustomMessage("Nick: " .. PlayerResource:GetPlayerName(pID) .. " pID: " .. pID, 1, 1)
                    GameRules:SendCustomMessage("GetCustomTeamAssignment: " .. PlayerResource:GetCustomTeamAssignment(pID) .. " pID: " .. pID, 1, 1)
                    GameRules:SendCustomMessage("GetLiveSpectatorTeam: " .. PlayerResource:GetLiveSpectatorTeam(pID) .. " pID: " .. pID, 1, 1)
                    GameRules:SendCustomMessage("GetTeam: " .. PlayerResource:GetTeam(pID) .. " pID: " .. pID, 1, 1)
                    GameRules:SendCustomMessage("IsValidTeamPlayer: " .. tostring(PlayerResource:IsValidTeamPlayer(pID))  .. " pID: " .. pID, 1, 1)
                    GameRules:SendCustomMessage("IsValidTeamPlayerID: " .. tostring(PlayerResource:IsValidTeamPlayerID(pID)) .. " pID: " .. pID, 1, 1)
                ]]
                PlayerResource:SetCustomTeamAssignment(pID, DOTA_TEAM_GOODGUYS)
                --PlayerResource:SetSelectedHero(pID, ELF_HERO)
                GameRules.Score[pID] = 0
                GameRules.GetGem[pID] = 0
                GameRules.PlayersFPS[pID] = false
                if GameRules.scores[pID] == nil then
                    GameRules.scores[pID] = {elf = 0, troll = 0}
                    GameRules.scores[pID].elf = 0
                    GameRules.scores[pID].troll = 0
                end
                local steam = tostring(PlayerResource:GetSteamID(pID))
                CustomNetTables:SetTableValue("Shop", tostring(pID), GameRules.PoolTable)
                Shop.RequestDonate(pID, steam, callback)
            end
        end
        Shop.RequestBpDay(callback)
        if GameRules.MapSpeed == 1 then
            Stats.RequestDataTop10("1", callback)
        elseif GameRules.MapSpeed == 2 then 
            Stats.RequestDataTop10("2", callback)
        elseif GameRules.MapSpeed == 4 then
            Stats.RequestDataTop10("3", callback)
        end
        -- StartReklama()
        GameRules.PlayersCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) + PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) + PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_CUSTOM_1) + PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_CUSTOM_2)
        --DebugPrint("count player " .. GameRules.PlayersCount)

        setup_state_lib:SetupStartMapVotes()

        -- Timers:CreateTimer(TEAM_CHOICE_TIME, function()
        --     SelectHeroes()
        --     GameRules:FinishCustomGameSetup()
        -- end)
    end
end

-- функция сортировки по первому элементу, следующие не учитываются
function mySort(a,b)
    if  a[2] > b [2] then
        return true
    end
    return false
end 
local allPlayersIDs = {}
local wannabeTrollIDs = {}
local takeNew = 1
local trollPlayerID = -1
local countAttempts = 0
function NewTroll()
    Timers:CreateTimer(1, function()
    if takeNew ~= 1 then
        return
    end
    takeNew = 2
    local newTrollPlayerID = nil
    if #wannabeTrollIDs > 0  then
        newTrollPlayerID = wannabeTrollIDs[math.random(#wannabeTrollIDs)]
        if PlayerResource:GetConnectionState(newTrollPlayerID) ~= 2 or trollPlayerID == newTrollPlayerID then
            newTrollPlayerID = nil
            for j = 1, #wannabeTrollIDs do
                if wannabeTrollIDs[j] ~= trollPlayerID and PlayerResource:IsValidPlayerID(wannabeTrollIDs[j]) and PlayerResource:GetConnectionState(wannabeTrollIDs[j]) == 2 and not PlayerResource:IsFakeClient(wannabeTrollIDs[j]) then
                    newTrollPlayerID = pID
                    break
                end
            end
        end
    end
    if newTrollPlayerID == nil then 
        newTrollPlayerID = allPlayersIDs[math.random(#allPlayersIDs)]
        if PlayerResource:GetConnectionState(newTrollPlayerID) ~= 2 or trollPlayerID == newTrollPlayerID then
            for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == 2 and not PlayerResource:IsFakeClient(pID) and trollPlayerID ~= pID then
                    newTrollPlayerID = pID
                    break
                end
            end
        end
    end
    if newTrollPlayerID ~= nil then 
        if GameRules.trollHero then
            UTIL_Remove(GameRules.trollHero)
        end
        GameRules:SendCustomMessage("newTrollPlayerID: " .. newTrollPlayerID, 1, 1)
        GameRules:SendCustomMessage("trollPlayerID: " .. trollPlayerID, 1, 1)
        local hero = PlayerResource:GetSelectedHeroEntity(newTrollPlayerID)
        if not hero and countAttempts < 4 then
            countAttempts = countAttempts + 1 
            return
        end
        PlayerResource:ReplaceHeroWith(newTrollPlayerID, TROLL_HERO, 0, 0)
        UTIL_Remove(hero)
        hero = PlayerResource:GetSelectedHeroEntity(newTrollPlayerID)
        PlayerResource:SetCustomTeamAssignment(newTrollPlayerID, DOTA_TEAM_BADGUYS) -- A workaround for wolves sometimes getting stuck on elves team, I don't know why or how it happens.
        hero:SetTeam(DOTA_TEAM_BADGUYS)
        InitializeBadHero(hero)
    end
    end)
end

function SetRoles()
    local donateTroll = {}
    for pID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(pID)  then
            table.insert(allPlayersIDs, pID)
            local playerSelection = GameRules.playerTeamChoices[pID]
            local pointScore = tonumber(GameRules.scores[pID].elf or 0) + tonumber(GameRules.scores[pID].troll or 0)
            local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))["2"]["0"]
            local party_id = tonumber(tostring(PlayerResource:GetPartyID(pID)))
            local partyGame = false 
            if party_id and party_id == 0 then
                DebugPrint("not  party_id and party_id = 0 ID " .. pID)
            else 
                DebugPrint("party" .. pID .. "party_id        " ..  party_id)
                local pary_chance = RandomInt(0, 100)
                if pary_chance > 25 then
                    partyGame = false 
                end
            end

            DebugPrint("party2 " .. pID .. "party_id2 " ..  party_id)

            if playerSelection == "troll" and PlayerResource:GetConnectionState(pID) == 2 and not PlayerResource:IsFakeClient(pID) and GameRules.FakeList[pID] == nil then
                if GameRules.PlayersCount >= MIN_RATING_PLAYER and (pointScore > 1 or PoolTable ~= "0") and not partyGame then
                    table.insert(wannabeTrollIDs, pID)
                elseif GameRules.PlayersCount < MIN_RATING_PLAYER or GameRules:IsCheatMode() then
                    table.insert(wannabeTrollIDs, pID)
                end
            end

            PlayerResource:SetCustomTeamAssignment(pID, DOTA_TEAM_GOODGUYS)
        end
    end
    
    local sumChance = 0
    if #wannabeTrollIDs > 0 then
        if #GameRules.BonusTrollIDs > 0 then
            --DebugPrint("Count Donate: " .. #GameRules.BonusTrollIDs)
            table.sort(GameRules.BonusTrollIDs, mySort)
            for _, bonus in ipairs(GameRules.BonusTrollIDs) do
                local playerID, chance = unpack(bonus)
                for j = 1, #wannabeTrollIDs do
                    if playerID == wannabeTrollIDs[j] then
                        table.insert(donateTroll, {playerID, chance})
                        sumChance = sumChance + tonumber(chance)
                    end
                end
            end
            if #donateTroll > 1 then
                table.sort(donateTroll, mySort)
                sumChance = sumChance/100
                local roll_chance = RandomFloat(0, 100)
                local check_chance_max = 0
                local check_chance_min = 0
                for _, bonus in ipairs(donateTroll) do
                    local playerID, chance = unpack(bonus)
                    check_chance_max = check_chance_max + (tonumber(chance)/sumChance)
                    if chance == 100 then
                        trollPlayerID = playerID
                        break
                    end
                    if check_chance_max > roll_chance and check_chance_min <= roll_chance then
                        trollPlayerID = playerID
                        break
                    else 
                        check_chance_min = check_chance_max  
                    end
                end
            elseif #donateTroll == 1 then 
                for _, donate in ipairs(donateTroll) do
                    local playerID, chance = unpack(donate)
                    trollPlayerID = playerID
                end
            end
        end
        if #wannabeTrollIDs > 0 and (trollPlayerID == -1 or trollPlayerID == nil) then
            trollPlayerID = wannabeTrollIDs[math.random(#wannabeTrollIDs)]
            if PlayerResource:GetConnectionState(trollPlayerID) ~= 2 then
                for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                    if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == 2 and not PlayerResource:IsFakeClient(pID) then
                        trollPlayerID = pID
                        break
                    end
                end
            end
        end
    else
        trollPlayerID = allPlayersIDs[math.random(#allPlayersIDs)]
        if PlayerResource:GetConnectionState(trollPlayerID) ~= 2 then
            for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == 2 and not PlayerResource:IsFakeClient(pID) then
                    trollPlayerID = pID
                    break
                end
            end
        end
    end
    if not GameRules.test then
        PlayerResource:SetCustomTeamAssignment(trollPlayerID, DOTA_TEAM_BADGUYS)
    end
end

function SelectHeroes()
    if not GameRules.test then
        local troll_player_id = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, 1)
        PlayerResource:SetSelectedHero(troll_player_id, TROLL_HERO)
    end
    local elfCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
    for i = 1, elfCount do
        local pID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
        PlayerResource:SetSelectedHero(pID, ELF_HERO)
        if GameRules.colorCounter <= #PLAYER_COLORS then
            local color = PLAYER_COLORS[GameRules.colorCounter]
            PlayerResource:SetCustomPlayerColor(pID, color[1], color[2], color[3])
            GameRules.colorCounter = GameRules.colorCounter + 1
        end
    end
end

function trollnelves2:OnHeroInGame(hero)
    --DebugPrint("OnHeroInGame")
    if hero:GetUnitName() == "npc_dota_hero_wisp" then
        local abil = hero:FindAbilityByName("dummy_passive")
        abil:SetLevel(abil:GetMaxLevel())
        PlayerResource:SetGold(hero, 0)
        PlayerResource:SetLumber(hero, 0)
        return false
    end 
    local team = hero:GetTeamNumber()
    InitializeHero(hero)
    if team == DOTA_TEAM_BADGUYS then InitializeBadHero(hero) end
    
    if not string.match(GetMapName(),"clanwars") then
		if team == DOTA_TEAM_BADGUYS then InitializeBadHero(hero) end
        if hero:IsElf() then
            InitializeBuilder(hero)
            elseif hero:IsTroll() then
            InitializeTroll(hero)
            elseif hero:IsAngel() then
            InitializeAngel(hero)
            elseif hero:IsWolf() then
            InitializeWolf(hero)
        end
	else
        if team == DOTA_TEAM_CUSTOM_1 or team == DOTA_TEAM_CUSTOM_2 then InitializeBadHero(hero) end
        if hero:IsElf() then
            InitializeBuilder(hero)
        elseif hero:IsTroll() and team == DOTA_TEAM_CUSTOM_1 then
            InitializeTroll(hero)
        elseif hero:IsTroll() and team == DOTA_TEAM_CUSTOM_2 then
            InitializeTroll2(hero)
        end
    end
end



function InitializeHero(hero)
    --DebugPrint("Initialize hero")
    if hero:GetUnitName() == "npc_dota_hero_bear"  then
        return
    end
    PlayerResource:SetGold(hero, 0)
    PlayerResource:SetLumber(hero, 0)
    if not GameRules.startTime then
        hero:AddNewModifier(nil, nil, "modifier_stunned", nil)
    end
        if hero == nil then
            return nil
        end
        if GameRules.scores[hero:GetPlayerOwnerID()] == nil then
            GameRules.scores[hero:GetPlayerOwnerID()] = {elf = 0, troll = 0}
			GameRules.scores[hero:GetPlayerOwnerID()].elf = 0
			GameRules.scores[hero:GetPlayerOwnerID()].troll = 0
        end

        local point = tonumber(GameRules.scores[hero:GetPlayerOwnerID()].elf or 0) + tonumber(GameRules.scores[hero:GetPlayerOwnerID()].troll or 0) 
        if hero ~= nil then
            if point > 0 then 
                hero:AddExperience(point, DOTA_ModifyXP_Unspecified, false,false)
            end
        end
    hero:ClearInventory()
    -- Learn all abilities (this isn't necessary on creatures)
    for i = 0, hero:GetAbilityCount() - 1 do
        local ability = hero:GetAbilityByIndex(i)
        if ability then ability:SetLevel(ability:GetMaxLevel()) end
    end
    hero:SetAbilityPoints(0)
    hero:SetStashEnabled(false)
    
    hero:SetDeathXP(0)
    PlayerResource:NewSelection(hero:GetPlayerOwnerID(), PlayerResource:GetSelectedHeroEntity(hero:GetPlayerOwnerID()))
end

function InitializeBadHero(hero)
    --DebugPrint("Initialize bad hero")
    local playerID = hero:GetPlayerOwnerID()
    local status, nextCall = Error_debug.ErrorCheck(function() 
        hero.hpReg = 0
        hero.hpRegDebuff = 0
        Timers:CreateTimer(function()
            if hero:IsNull() then return 1 end
            local rate = FrameTime()
            local fullHpReg = math.max(hero.hpReg - hero.hpRegDebuff, 0)
            if fullHpReg > 0 and hero:IsAlive() then
                local optimalRate = 1 / fullHpReg
                rate = optimalRate > rate and optimalRate or rate
                local ratedHpReg = fullHpReg * rate
                hero:SetHealth(hero:GetHealth() + ratedHpReg)
            end
            if rate == nil then
                rate = 1 
            end
            if rate == 0 then
                rate = 1 
            end
            return rate
        end)
    end)
    
    -- Give small flying vision around hero to see elf walls/rocks on highground
    -- --[[
    Timers:CreateTimer(function()
        if not hero or hero:IsNull() then return end
        if hero:IsAlive() then
            AddFOWViewer(hero:GetTeamNumber(), hero:GetAbsOrigin(), 370, 0.1, false)
        end
        return 0.1
    end)
    --hero:SetStashEnabled(false)
    --]]
end

function InitializeBuilder(hero)
    --DebugPrint("Initialize builder")
    local playerID = hero:GetPlayerOwnerID()
    hero.food = 0
    hero.wisp = 0
    hero.mine = 0
    hero.wispmine = 0
    hero.alive = true
    hero.units = {}
    hero.disabledBuildings = {}
    hero.buildings = {} -- This keeps the name and quantity of each building
    for _, buildingName in ipairs(GameRules.buildingNames) do
        hero.buildings[buildingName] = {
            startedConstructionCount = 0,
            completedConstructionCount = 0
        }
    end
    hero:SetRespawnsDisabled(true)
    
    hero:AddItemByName("item_root_ability")
    hero:AddItemByName("item_silence_ability")
    hero:AddItemByName("item_glyph_ability")
    if string.match(GetMapName(),"clanwars") then
        hero:AddItemByName("item_max_move2")
    else  
        --hero:AddItemByName("item_night_ability")
        hero:AddItemByName("item_blink_datadriven")
    end
    hero:AddItemByName("item_stormcrafter_datadriven")
    hero:AddItemByName("item_anti_angel")
    
    
    if GameRules.MapSpeed == 4 or string.match(GetMapName(),"turbo2x") then
        hero:AddItemByName("item_max_move")
    end
    hero.goldPerSecond = 0
    hero.lumberPerSecond = 0


    Timers:CreateTimer(function()
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)
        if hero:IsNull() then return 1 end
        if hero:IsAngel() or hero:IsWolf() then
            return
        end
        if FlagCheck(hero) then
            hero:AddNewModifier(hero, nil, "modifier_antibase", {Duration = 10})
        end
        return 1
    end)
    
    UpdateSpells(hero)
    if not string.match(GetMapName(),"turbo2x") then
        PlayerResource:SetGold(hero, ELF_STARTING_GOLD)
        PlayerResource:SetLumber(hero, ELF_STARTING_LUMBER)
    else
        PlayerResource:SetGold(hero, ELF_STARTING_GOLD_TURBO)
        PlayerResource:SetLumber(hero, ELF_STARTING_LUMBER_TURBO)
    end
    if string.match(GetMapName(),"turbo2x") then
        if hero:isElf() then 
            hero:RemoveModifierByName("build_tent")
            hero:RemoveModifierByName("build_rock_1")
            hero:AddAbilityByName("build_barrack")
            hero:AddAbilityByName("build_demonic_wall")
        end
    end
    PlayerResource:ModifyFood(hero, 0)
    PlayerResource:ModifyWisp(hero, 0)
    PlayerResource:ModifyMine(hero, 0)
    PlayerResource:ModifyWispMine(hero, 0)
    hero:SetStashEnabled(false)
    hero:RemoveAbility("troll_warlord_battle_trance_datadriven")
    Timers:CreateTimer(BUFF_ENIGMA_TIME/GameRules.MapSpeed, function() 
        hero = PlayerResource:GetSelectedHeroEntity(playerID)
        if hero == nil then
            return nil
        end
        if hero:IsElf() then
            hero:AddAbility("troll_warlord_battle_trance_datadriven")
            local abil = hero:FindAbilityByName("troll_warlord_battle_trance_datadriven")
            abil:SetLevel(abil:GetMaxLevel())
        end
    end)   
    hero:CalculateStatBonus(true)
end

function GoldForElf()
    Timers:CreateTimer(function()
        local status, nextCall = Error_debug.ErrorCheck(function()
            for pID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
                if PlayerResource:IsValidPlayerID(pID) then
                    local hero = PlayerResource:GetSelectedHeroEntity(pID)
                    if hero and hero.IsElf and hero:IsElf() then
                        hero.goldPerSecond = hero.goldPerSecond or 0
                        hero.lumberPerSecond = hero.lumberPerSecond or 0
                        GameRules.gold[pID] = GameRules.gold[pID] or 0

                        if hero.goldPerSecond then 
                            PlayerResource:ModifyGold(hero, hero.goldPerSecond)
                        end
                        if hero.lumberPerSecond then
                            PlayerResource:ModifyLumber(hero, hero.lumberPerSecond)
                        end
                    end
                end
            end
        end)

        return 1  
    end)
end
function InitializeTroll(hero)
    
    local playerID = hero:GetPlayerOwnerID()
    --DebugPrint("Initialize troll, playerID: ", playerID)
    GameRules.trollHero = hero
    GameRules.trollID = playerID

    --local abil = hero:FindAbilityByName("arc_warden_magnetic_field") --event ability
    
    hero.units = {}
    hero.disabledBuildings = {}
    hero.buildings = {} -- This keeps the name and quantity of each building
    hero.buildings["troll_hut_1"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_2"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_3"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_4"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_5"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_6"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_7"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_8"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    if GameRules.MapSpeed == 1 and not string.match(GetMapName(),"clanwars")  then
        hero:RemoveAbility("special_bonus_cooldown_reduction_50")
        hero:RemoveAbility("special_bonus_cooldown_reduction_30")
    elseif GameRules.MapSpeed == 2 then
        hero:RemoveAbility("special_bonus_cooldown_reduction_30")
        hero:AddNewModifier(hero, nil, "modifier_movespeed_x2", {})
    elseif GameRules.MapSpeed >= 4 and not string.match(GetMapName(),"clanwars") then
        hero:AddNewModifier(hero, nil, "modifier_movespeed_x4", {})
    end
    
    if string.match(GetMapName(),"clanwars") and GameRules.MapSpeed == 1 then
        hero:RemoveAbility("special_bonus_cooldown_reduction_50") 
        hero:RemoveAbility("special_bonus_cooldown_reduction_30")
        --hero:AddNewModifier(hero, nil, "modifier_movespeed_x2", {})
    elseif string.match(GetMapName(),"clanwars") and GameRules.MapSpeed == 4 then
        hero:AddNewModifier(hero, nil, "modifier_movespeed_x4", {})
    end

    hero:RemoveAbility("troll_spell_silence_target")
    hero:RemoveAbility("troll_spell_silence_area")
    hero:RemoveAbility("troll_spell_stun_target")
    hero:RemoveAbility("troll_spell_haste")
    hero:RemoveAbility("troll_spell_ward")
    hero:RemoveAbility("troll_spell_bkb")
    hero:RemoveAbility("troll_spell_slow_target")
    hero:RemoveAbility("troll_spell_slow_area")
    hero:RemoveAbility("troll_spell_invis")
    hero:RemoveAbility("troll_spell_evasion")
    hero:RemoveAbility("troll_spell_atkspeed")
    hero:RemoveAbility("troll_spell_wolf")
    hero:RemoveAbility("troll_spell_reveal")
    hero:RemoveAbility("troll_spell_night_buff")
    --hero:RemoveAbility("")
    
    if GameRules.test2 == false then
        hero:RemoveAbility("lone_druid_spirit_bear_datadriven")
    end
    local units = Entities:FindAllByClassname("npc_dota_creature")
    for _, unit in pairs(units) do
        local unit_name = unit:GetUnitName();
        if string.match(unit_name, "shop") or
            string.match(unit_name, "troll_hut") then
            unit:SetOwner(hero)
            unit:SetControllableByPlayer(playerID, true)
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
    
    if GameRules.test2 then
        hero:AddItemByName("item_dmg_12")
        hero:AddItemByName("item_armor_12")
        hero:AddItemByName("item_hp_12")
        hero:AddItemByName("item_hp_reg_12")
        hero:AddItemByName("item_atk_spd_7")
        hero:AddItemByName("item_disable_repair_2")
        hero:AddItemByName("item_disable_repair")
    end
    hero:SetStashEnabled(false)
    
    -- check count elf 
    Timers:CreateTimer(function()
        local countElf = 0
        local countAngel = 0
        if not hero or hero:IsNull() then return end
        if hero:IsAlive() then
            local units = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetOrigin() , nil, 900 , DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL  , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false) --range 600 <-1200
            for _,unit in pairs(units) do
                if unit ~= nil then
                    if unit:GetUnitName() == "flag" then
                        countAngel = 1 --countElf = 1
                    end
                    if unit:IsElf() and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) == 2 then
                        countElf = countElf + 1
                    end
                end
            end
            if countAngel == 1 then		-- or countElf >= 3 new
                if hero:HasModifier("modifier_antiblock") then
                    hero:RemoveModifierByName("modifier_antiblock")
                end
            else
                if not hero:HasModifier("modifier_antiblock") then
                    hero:AddNewModifier(hero, nil, "modifier_antiblock", {})
                end
            end
            
        end
        return 1
    end)
    if string.match(GetMapName(),"clanwars")  then
        Timers:CreateTimer(30, function()
            PlayerResource:SetCustomTeamAssignment(playerID, DOTA_TEAM_GOODGUYS)
            PlayerResource:SetCustomTeamAssignment(playerID, DOTA_TEAM_GOODGUYS)
            hero:SetTeam(DOTA_TEAM_GOODGUYS)
        end)
        local abil2 = hero:FindAbilityByName("troll_antiblock")
        abil2:EndCooldown()
        abil2:StartCooldown(999999) 
    end
    hero:CalculateStatBonus(true)
    --hero:AddItemByName("item_zombie_bag")
end

function InitializeAngel(hero)
    --DebugPrint("Initialize angel")
    hero:AddItemByName("item_blink_datadriven")
    --if not string.match(GetMapName(),"halloween") then 
    --    hero:RemoveAbility("silence_datadriven")
    --end
    hero:CalculateStatBonus(true)
end

function trollnelves2:ControlUnitForTroll(hero)
    local playerID = hero:GetPlayerOwnerID()
    local units = Entities:FindAllByClassname("npc_dota_creature")
    local checkTrollHutLevel6 = false --local checkTrollHutLevel9 = false --local checkTrollHutLevel6 = false
    for _,unit in pairs(units) do
        local unit_name_hut = unit:GetUnitName();
        if unit_name_hut == "troll_hut_6" then --if unit_name_hut == "troll_hut_10" then --if unit_name_hut == "troll_hut_7" then
            --DebugPrint("in2")
            checkTrollHutLevel6 = true --checkTrollHutLevel7 = true
        end
    end 
    if not checkTrollHutLevel6 then
        PlayerResource:SetUnitShareMaskForPlayer(GameRules.trollID, playerID, 2, true)
        return nil
    end
    for _, unit in pairs(units) do
        local unit_name = unit:GetUnitName();
        if string.match(unit_name, "shop") or
            string.match(unit_name, "troll_hut") then
            --DebugPrint("in3")
            unit:SetOwner(hero)
            unit:SetControllableByPlayer(playerID, true)
        end
    end
    
    for pID=0,DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(pID) then
            local badBoy = PlayerResource:GetSelectedHeroEntity(pID)
            if badBoy then
                local team = badBoy:GetTeamNumber()
                if team ~= nil then
                    if team == DOTA_TEAM_BADGUYS then
                        PlayerResource:SetUnitShareMaskForPlayer(playerID, pID, 2, true)
                        PlayerResource:SetUnitShareMaskForPlayer(GameRules.trollID, pID, 2, false)
                        --DebugPrint("GOOO1!! " .. pID)
                    end
                end
            end
        end
    end
end

function InitializeWolf(hero)
    local playerID = hero:GetPlayerOwnerID()
    --DebugPrint("Initialize wolf, playerID: " .. playerID)
    -- --DebugPrint("GameRules.trollID: " .. GameRules.trollID)
    local koeff = 1
    if (GameRules:GetGameTime() - GameRules.startTime) <= 600 then
        koeff = 2
    end
    local trollNetworth = math.floor(GameRules.trollHero:GetNetworth()/koeff)
    local lumber = trollNetworth / 64000 * WOLF_STARTING_RESOURCES_FRACTION
    local gold = math.floor((lumber - math.floor(lumber)) * 64000)
    lumber = math.floor(lumber)
    
    PlayerResource:SetGold(hero, math.floor(gold))
    PlayerResource:SetLumber(hero, math.floor(lumber))
    
    trollnelves2:ControlUnitForTroll(hero)
    
    local abil = hero:FindAbilityByName("troll_warlord_battle_trance_datadriven")
    if abil ~= nil then
        abil:RemoveAbility("troll_warlord_battle_trance_datadriven")
    end
    hero:CalculateStatBonus(true)
end

function trollnelves2:PreStart()
    --StopAnimationGlobal()
    StartCreatingMinimapBuildings() --new
    local gameStartTimer = PRE_GAME_TIME
    ModifyLumberPrice(0)

    Timers:CreateTimer(function()
        if gameStartTimer > 0 then
            Notifications:ClearBottomFromAll()
            Notifications:BottomToAll({
                text = "Game starts in " .. gameStartTimer,
                style = {color = '#E62020'},
                duration = 1
            })
            gameStartTimer = gameStartTimer - 1
            if gameStartTimer == 7 then
                BuildingHelper:UpdateGrid()
                LinkModifier:Start()
            end
            if GameRules.trollHero ~= nil then
                PlayerResource:SetGold(GameRules.trollHero , 0)
            end
            return 1
            else
            if GameRules.trollHero or GameRules.test then -- 
                Notifications:ClearBottomFromAll()
                Notifications:BottomToAll(
                    {
                        text = "Game started!",
                        style = {color = '#E62020'},
                        duration = 1
                    })
                    if IsServer() then
                        GoldForElf()
                    end
                    if GameRules.trollHero then
                        GameRules.trollHero:RemoveModifierByName("modifier_disconnected") 
                    end
                    GameRules.startTime = GameRules:GetGameTime()
                    
                    -- Unstun the elves
                    local elfCount = PlayerResource:GetPlayerCountForTeam(
                    DOTA_TEAM_GOODGUYS)
                    for i = 1, elfCount do
                        local pID = PlayerResource:GetNthPlayerIDOnTeam(
                        DOTA_TEAM_GOODGUYS, i)
                        local playerHero = PlayerResource:GetSelectedHeroEntity(pID)
                        if playerHero then
                            playerHero:RemoveModifierByName("modifier_stunned")
                            PlayerResource:NewSelection(playerHero:GetPlayerOwnerID(), PlayerResource:GetSelectedHeroEntity(playerHero:GetPlayerOwnerID()))
                        end
                    end
                    
                    local trollSpawnTimer = TROLL_SPAWN_TIME
                    local trollHero = GameRules.trollHero
                    if trollHero then
                        trollHero:AddNewModifier(trollHero, nil, "modifier_stunned", {Duration = trollSpawnTimer})
                        PlayerResource:SetGold(trollHero, TROLL_STARTING_GOLD)
                        if string.match(GetMapName(),"1x1") then
                            if GameRules.MapSpeed >= 4 then
                                PlayerResource:SetGold(trollHero, TROLL_STARTING_GOLD_SOLO + TROLL_STARTING_GOLD_X4)
                            else
                                PlayerResource:SetGold(trollHero, TROLL_STARTING_GOLD_SOLO)
                            end
                        end
                        if string.match(GetMapName(),"turbo") then
                            PlayerResource:SetGold(trollHero, TROLL_STARTING_GOLD_TURBO)
                        end
                        PlayerResource:SetLumber(trollHero, TROLL_STARTING_LUMBER)
                    end

                    Timers:CreateTimer(function()
                        if trollSpawnTimer > 0 then
                            Notifications:ClearBottomFromAll()
                            Notifications:BottomToAll(
                                {
                                    text = "Troll spawns in " .. trollSpawnTimer,
                                    style = {color = '#E62020'},
                                    duration = 1
                                })
                                trollSpawnTimer = trollSpawnTimer - 1
                                return 1.0
                            elseif GameRules.trollHero then 
                                local trollHero = GameRules.trollHero
                                trollHero:RemoveModifierByName("modifier_stunned")    
                            end
                    end)
                    else
                    Notifications:ClearBottomFromAll()
                    Notifications:BottomToAll(
                        {
                            text = "Troll hasn't spawned yet!Resetting!",
                            style = {color = '#E62020'},
                            duration = 1
                        })
                        if not string.match(GetMapName(),"clanwars") then
                            NewTroll()
                        end
                        gameStartTimer = 3
                        return 1.0
            end
        end
    end)
    GetAllItems()
end


function GetAllItems()
    if IsServer() then
        Timers:CreateTimer(25, function() 
            if not PlayerResource:GetSelectedHeroEntity(0) then
                return 10
            end
            wearables:SetPart() 
            Shop:SetStats() 
            wearables:SetSkin() 
            SelectPets:SetPets()
            game_spells_lib:SetSpellPlayers()
        end)
        GameRules.PlayersCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) + PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) + PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_CUSTOM_1) + PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_CUSTOM_2)
        GameRules:SendCustomMessage("<font color='#00FFFF '> Number of players: " .. GameRules.PlayersCount .. "</font>" ,  0, 0)
    end 
end



function StartCreatingMinimapBuildings()
    Timers:CreateTimer(1, function()
        if GameRules:State_Get() > DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
            return
        end
        -- Create minimap entities for buildings that are visible and don't already have a minimap entity
        local allEntities = Entities:FindAllByClassname("npc_dota_creature")
        for _, unit in pairs(allEntities) do
            if not unit:IsNull() and IsCustomBuilding(unit) and not unit.minimapEntity and unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS and IsLocationVisible(DOTA_TEAM_BADGUYS, unit:GetAbsOrigin()) and (string.match(unit:GetUnitName(),"rock") or string.match(unit:GetUnitName(),"trader") or string.match(unit:GetUnitName(),"flag")) then
                unit.minimapEntity = CreateUnitByName("minimap_entity", unit:GetAbsOrigin(), false, unit:GetOwner(), unit:GetOwner(), unit:GetTeamNumber())
                unit.minimapEntity:AddNewModifier(unit.minimapEntity, nil, "modifier_minimap", {})
                unit.minimapEntity.correspondingEntity = unit
            end
        end
        -- Kill minimap entities of dead buildings when location is scouted
        local minimapEntities = Entities:FindAllByClassname("npc_dota_building")
        for k, minimapEntity in pairs(minimapEntities) do
            if not minimapEntity:IsNull() and minimapEntity.correspondingEntity == "dead" and IsLocationVisible(DOTA_TEAM_BADGUYS, minimapEntity:GetAbsOrigin()) then
                minimapEntity.correspondingEntity = nil
               -- minimapEntity:ForceKill(false)
                minimapEntity:Kill(nil, minimapEntity)
                UTIL_Remove(minimapEntity)
            end
        end
        return 1
    end)
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function trollnelves2:Inittrollnelves2()
    trollnelves2 = self
    trollnelves2:_Inittrollnelves2()
end

function ModifyLumberPrice(amount)
    amount = string.match(amount, "[-]?%d+") or 0
    GameRules.lumberPrice = math.max(GameRules.lumberPrice + amount, MINIMUM_LUMBER_PRICE)
    GameRules.lumberSell = math.max(GameRules.lumberPrice - 15, MINIMUM_LUMBER_PRICE)
    CustomGameEventManager:Send_ServerToTeam(DOTA_TEAM_GOODGUYS,
        "player_lumber_price_changed", {
            lumberPrice = GameRules.lumberPrice,
            lumberSell = GameRules.lumberSell
        })
    CustomGameEventManager:Send_ServerToTeam(DOTA_TEAM_BADGUYS,
        "player_lumber_price_changed", {
            lumberPrice = GameRules.lumberPrice,
            lumberSell = GameRules.lumberSell
        })
end

function SetResourceValues()
    for pID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayer(pID) then
            if GameRules.startTime == nil then
                GameRules.startTime = 1
            end
            CustomNetTables:SetTableValue("resources",
                tostring(pID) .. "_resource_stats", {
                    gold = PlayerResource:GetGold(pID),
                    lumber = PlayerResource:GetLumber(pID),
                    goldGained = PlayerResource:GetGoldGained(pID),
                    lumberGained = PlayerResource:GetLumberGained(pID),
                    goldGiven = PlayerResource:GetGoldGiven(pID),
                    lumberGiven = PlayerResource:GetLumberGiven(pID),
                    timePassed = GameRules:GetGameTime() - GameRules.startTime,
                    PlayerChangeScore = GameRules.Score[pID],
                    GetGem = GameRules.GetGem[pID]
                })
        end
    end
end

function GetModifiedName(orgName)
    if string.match(orgName, TROLL_HERO) then
        return "<font color='#FF0000'>The Mighty Troll</font>"
        elseif string.match(orgName, ELF_HERO) then
        return "<font color='#00CC00'>Elf</font>"
        elseif string.match(orgName, WOLF_HERO[1]) or string.match(orgName, WOLF_HERO[2]) then
        return "<font color='#800000'>Wolf</font>"
        elseif string.match(orgName, ANGEL_HERO[1]) or string.match(orgName, ANGEL_HERO[2]) then 
        return "<font color='#0099FF'>Angel</font>"
        else
        return "?"
    end
end

function SellItem(unit, item)
    
    if item then
        if not item:IsSellable() then
            SendErrorMessage(issuerID, "error_item_not_sellable")
        end
        local gold_cost = item:GetSpecialValueFor("gold_cost")
        local lumber_cost = item:GetSpecialValueFor("lumber_cost")
        local playerID = unit:GetPlayerOwnerID()
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)

        if hero:IsElf() or not hero:CanSellItems() then
            return
        end
        UTIL_Remove(item)
        PlayerResource:ModifyGold(hero, gold_cost, true)
        PlayerResource:ModifyLumber(hero, lumber_cost, true)
        local player = hero:GetPlayerOwner()

        EmitSoundOnEntityForPlayer("DOTA_Item.Hand_Of_Midas", hero, hero:GetPlayerOwnerID())
    end
    
end

function UpdateSpells(unit)
    local playerID = unit:GetPlayerOwnerID()
    local hero = unit
    local ownerHero = PlayerResource:GetSelectedHeroEntity(playerID)
    for a = 0, unit:GetAbilityCount() - 1 do
        local tempAbility = unit:GetAbilityByIndex(a)
        if tempAbility then
            local abilityKV = GetAbilityKV(tempAbility:GetAbilityName());
            local bIsBuilding = abilityKV and abilityKV.Building or 0
            if bIsBuilding == 1 then
                local buildingName = abilityKV.UnitName
                DisableAbilityIfMissingRequirements(playerID, hero, tempAbility,
                buildingName)
            end
        end
    end
    if ownerHero then
        if ownerHero.build_worker then
            if ownerHero.build_worker:IsAlive() then
                for a = 0, ownerHero.build_worker:GetAbilityCount() - 1 do
                    DebugPrint("Done")
                    local tempAbility = ownerHero.build_worker:GetAbilityByIndex(a)
                    if tempAbility then
                        local abilityKV = GetAbilityKV(tempAbility:GetAbilityName());
                        local bIsBuilding = abilityKV and abilityKV.Building or 0
                        if bIsBuilding == 1 then
                            local buildingName = abilityKV.UnitName
                            DisableAbilityIfMissingRequirements(playerID, hero, tempAbility, buildingName)
                        end
                    end
                end
            end
        end
    end
end

function UpdateUpgrades(building)
    if not building or building:IsNull() then return end
    
    local playerID = building:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    for a = 0, building:GetAbilityCount() - 1 do
        local ability = building:GetAbilityByIndex(a)
        if ability and ability.upgradedUnitName then
            DisableAbilityIfMissingRequirements(playerID, hero, ability,
            ability.upgradedUnitName)
        end
    end
end

function AddUpgradeAbilities(building)
    if not building or building:IsNull() then return end
    
    local upgrades = GetUnitKV(building:GetUnitName()).Upgrades
    if upgrades and upgrades.Count then
        local playerID = building:GetPlayerOwnerID()
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)
        local abilities = {}
        for a = 0, building:GetAbilityCount() - 1 do
            local tempAbility = building:GetAbilityByIndex(a)
            if tempAbility then
                table.insert(abilities, {tempAbility:GetAbilityName(), tempAbility:GetLevel()})
                building:RemoveAbility(tempAbility:GetAbilityName())
            end
        end
        
        local count = tonumber(upgrades.Count)
        for i = 1, count, 1 do
            local upgrade = upgrades[tostring(i)]
            local upgradedUnitName = upgrade.unit_name
            
            local abilityName = "upgrade_to_" .. upgradedUnitName
            local upgradeAbility = building:AddAbility(abilityName)
            upgradeAbility.upgradedUnitName = upgradedUnitName
            
            DisableAbilityIfMissingRequirements(playerID, hero, upgradeAbility, upgradedUnitName)
        end
        for _, ability in ipairs(abilities) do
            local abilityName, abilityLevel = unpack(ability)
            if not string.match(abilityName, "upgrade_to") then
                local abilityHandle = building:AddAbility(abilityName)
                abilityHandle:SetLevel(abilityLevel)
            end
        end
    end
end

function DisableAbilityIfMissingRequirements(playerID, hero, abilityHandle, unitName)
    local missingRequirements = {}
    local disableAbility = false
    local requirements = GameRules.buildingRequirements[unitName]
    if string.match(unitName,"troll_hut") then
        hero = GameRules.trollHero
    end
    if requirements then
        --DebugPrint("unitName: " .. unitName)
        --DebugPrintTable(requirements)
        for _, requiredUnitName in ipairs(requirements) do
        --    --DebugPrint("requiredUnitName: " .. requiredUnitName)
            local requiredUnit, countUnit = unpack(requiredUnitName)
            local requiredBuildingCurrentCount = hero.buildings[requiredUnit].completedConstructionCount
            if unitName == "rock_16" or unitName == "rock_17" or unitName == "rock_18" then
                if requiredUnit == "flag" then
                    requiredBuildingCurrentCount = 1
                end
            end
            if countUnit == nil then
                countUnit = 1
            end
            if requiredBuildingCurrentCount < countUnit then
                local missCount = countUnit - requiredBuildingCurrentCount 
                table.insert(missingRequirements, {requiredUnit, missCount})
                disableAbility = true
            end
        end
    end
    CustomNetTables:SetTableValue("buildings", playerID .. unitName, missingRequirements)
    
    local limit = GetUnitKV(unitName, "Limit")
    if limit ~= nil then
        local currentCount = hero.buildings[unitName].startedConstructionCount
        if currentCount >= limit then disableAbility = true end
    end
    
    
    
    if disableAbility and not GameRules.test2 then
        abilityHandle:SetLevel(0)
        hero.disabledBuildings[unitName] = true
        else
        abilityHandle:SetLevel(1)
        hero.disabledBuildings[unitName] = false
    end
end

function GetClass(unitName)
    if string.match(unitName, "rock") or string.match(unitName, "wall") then
        return "wall"
        elseif string.match(unitName, "tower") then
        return "tower"
        elseif string.match(unitName, "tent") or string.match(unitName, "barrack") or string.match(unitName, "bank") then
        return "tent"
        elseif string.match(unitName, "trader") then
        return "trader"
        elseif string.match(unitName, "workers_guild") then
        return "workers_guild"
        elseif string.match(unitName, "mother_of_nature") then
        return "mother_of_nature"
        elseif string.match(unitName, "research_lab") then
        return "research_lab"
        elseif string.match(unitName, "flag") then
        return "flag"
    end
end

function FlagCheck(caster)
    local hero = caster
	local baseID = BuildingHelper:IdBaseArea(hero)
	local playerID = hero:GetPlayerID()
	if string.match(GetMapName(),"clanwars") then
		return false
	end
	if baseID ~= nil and baseID ~= GameRules.PlayersBase[playerID] then
		for pID = 0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) then
				if GameRules.PlayersBase[pID] == baseID then
					return true
				end
			end
		end
	end
	return false
end 