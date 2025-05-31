Player = Player or {}

require('libraries/team')

local goldGainedImportance = 15
local goldGivenImportance = -20
local lumberGainedImportance = 15
local lumberGivenImportance = -20
local rankImportance = 100
local rankPers = 30

function CDOTA_PlayerResource:SetSelectedHero(playerID, heroName)
    local player = PlayerResource:GetPlayer(playerID)
	if player == nil then
        GameRules.disconnectedHeroSelects[playerID] = heroName
        return nil
	end
	GameRules.disconnectedHeroSelects[playerID] = nil
    player:SetSelectedHero(heroName)
	return true
end

function CDOTA_PlayerResource:SetGold(hero,gold)
	local status, nextCall = Error_debug.ErrorCheck(function() 
		local playerID = hero:GetPlayerOwnerID()
		local limitGold = 0
		if hero:HasModifier("modifier_troll_spell_limit_gold")  then
			if hero:FindModifierByName("modifier_troll_spell_limit_gold"):GetStackCount() == 1  then
				limitGold = 200000 
			elseif hero:FindModifierByName("modifier_troll_spell_limit_gold"):GetStackCount() == 2 then
				limitGold = 300000
			elseif hero:FindModifierByName("modifier_troll_spell_limit_gold"):GetStackCount() == 3 then
				limitGold = 400000
			end
		end
		if hero:HasModifier("modifier_troll_spell_limit_gold_x4")  then
			if hero:FindModifierByName("modifier_troll_spell_limit_gold_x4"):GetStackCount() == 1  then
				limitGold = 200000 
			elseif hero:FindModifierByName("modifier_troll_spell_limit_gold_x4"):GetStackCount() == 2 then
				limitGold = 350000
			elseif hero:FindModifierByName("modifier_troll_spell_limit_gold_x4"):GetStackCount() == 3 then
				limitGold = 500000
			end
		end

		if hero:HasModifier("modifier_elf_spell_limit_gold")  then
			if hero:FindModifierByName("modifier_elf_spell_limit_gold"):GetStackCount() == 1  then
				limitGold = 200000 
			elseif hero:FindModifierByName("modifier_elf_spell_limit_gold"):GetStackCount() == 2 then
				limitGold = 400000
			elseif hero:FindModifierByName("modifier_elf_spell_limit_gold"):GetStackCount() == 3 then
				limitGold = 600000
			end
		end

		if hero:HasModifier("modifier_elf_spell_limit_gold_x4")  then
			if hero:FindModifierByName("modifier_elf_spell_limit_gold_x4"):GetStackCount() == 1  then
				limitGold = 200000 
			elseif hero:FindModifierByName("modifier_elf_spell_limit_gold_x4"):GetStackCount() == 2 then
				limitGold = 350000
			elseif hero:FindModifierByName("modifier_elf_spell_limit_gold_x4"):GetStackCount() == 3 then
				limitGold = 500000
			end
		end

		if GameRules.MapSpeed >= 4 then
			gold = math.min(gold, math.floor(2000000 * GameRules.MultiMapSpeed + limitGold))
		else
			gold = math.min(gold, math.floor(1000000 * GameRules.MultiMapSpeed + limitGold)) 
		end
		GameRules.gold[playerID] = gold
		CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_custom_gold_changed", {
			playerID = playerID,
			gold = PlayerResource:GetGold(playerID)
		})
	end)
end

function CDOTA_PlayerResource:ModifyGold(hero,gold,noGain)
	local status, nextCall = Error_debug.ErrorCheck(function() 
		if GameRules.test2 then
			PlayerResource:SetGold(hero, math.floor(1000000 * GameRules.MultiMapSpeed))
			return 1
		end
		noGain = noGain or false
		local pID = hero:GetPlayerOwnerID()
		PlayerResource:SetGold(hero, (GameRules.gold[pID] or 0) + gold)
		if gold > 0 and not noGain then
			PlayerResource:ModifyGoldGained(pID,gold)
		end
	end)
end

function CDOTA_PlayerResource:GetGold(pID)
	return math.floor(GameRules.gold[pID] or 0)
end


function CDOTA_PlayerResource:SetLumber(hero, lumber)
	local status, nextCall = Error_debug.ErrorCheck(function() 
		local playerID = hero:GetPlayerOwnerID()
		local limitLumber = 0
		if hero:HasModifier("modifier_elf_spell_limit_lumber")  then
			if hero:FindModifierByName("modifier_elf_spell_limit_lumber"):GetStackCount() == 1  then
				limitLumber = 100000 
			elseif hero:FindModifierByName("modifier_elf_spell_limit_lumber"):GetStackCount() == 2 then
				limitLumber = 200000
			elseif hero:FindModifierByName("modifier_elf_spell_limit_lumber"):GetStackCount() == 3 then
				limitLumber = 500000
			end
		end
		if hero:HasModifier("modifier_elf_spell_limit_lumber_x4")  then
			if hero:FindModifierByName("modifier_elf_spell_limit_lumber_x4"):GetStackCount() == 1  then
				limitLumber = 100000 
			elseif hero:FindModifierByName("modifier_elf_spell_limit_lumber_x4"):GetStackCount() == 2 then
				limitLumber = 200000
			elseif hero:FindModifierByName("modifier_elf_spell_limit_lumber_x4"):GetStackCount() == 3 then
				limitLumber = 500000
			end
		end
		if GameRules.MapSpeed >= 4 then
			lumber = math.min(lumber, math.floor(2000000 * GameRules.MultiMapSpeed + limitLumber))
		else
			lumber = math.min(lumber, math.floor(1000000 * GameRules.MultiMapSpeed + limitLumber))
		end
		GameRules.lumber[playerID] = lumber
		CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_lumber_changed", {
			playerID = playerID,
			lumber = PlayerResource:GetLumber(playerID)
		})
	end)
end

function CDOTA_PlayerResource:ModifyLumber(hero,lumber,noGain)
	local status, nextCall = Error_debug.ErrorCheck(function() 
		if GameRules.test2 then
			PlayerResource:SetLumber(hero, math.floor(1000000 * GameRules.MultiMapSpeed))
			return 1
		end
		noGain = noGain or false
		local pID = hero:GetPlayerOwnerID()
		PlayerResource:SetLumber(hero, (GameRules.lumber[pID] or 0) + lumber)
		if lumber > 0 and not noGain then
			PlayerResource:ModifyLumberGained(pID, lumber)
		end
	end)
end

function CDOTA_PlayerResource:GetLumber(pID)
	if GameRules.lumber[pID] == nil then
		GameRules.lumber[pID] = 0
	end
	return math.floor(GameRules.lumber[pID]) or 0
end


function CDOTA_PlayerResource:ModifyGoldGained(pID,amount)
	local status, nextCall = Error_debug.ErrorCheck(function() 
		GameRules.goldGained[pID] = PlayerResource:GetGoldGained(pID) + amount
	end)
end

function CDOTA_PlayerResource:GetGoldGained(pID)
	if GameRules.goldGained[pID] == nil then
		GameRules.goldGained[pID] = 0
	end
	return GameRules.goldGained[pID] or 0
end

function CDOTA_PlayerResource:ModifyGoldGiven(pID,amount)
	GameRules.goldGiven[pID] = PlayerResource:GetGoldGiven(pID) + amount
end

function CDOTA_PlayerResource:GetGoldGiven(pID)
	if GameRules.goldGiven[pID] == nil then
		GameRules.goldGiven[pID] = 0
	end
	return GameRules.goldGiven[pID] or 0
end

function CDOTA_PlayerResource:ModifyDamageGiven(pID, amount)
	GameRules.damageGiven[pID] = PlayerResource:GetDamageGiven(pID) + amount
end

function CDOTA_PlayerResource:GetDamageGiven(pID)
	if GameRules.damageGiven[pID] == nil then
		GameRules.damageGiven[pID] = 0
	end
	return GameRules.damageGiven[pID] or 0
end

function CDOTA_PlayerResource:ModifyDamageTake(pID, amount)
	DebugPrint(amount)
	GameRules.damageTake[pID] = PlayerResource:GetDamageTake(pID) + amount
end

function CDOTA_PlayerResource:GetDamageTake(pID)
	if GameRules.damageTake[pID] == nil then
		GameRules.damageTake[pID] = 0
	end
	return GameRules.damageTake[pID] or 0
end



function CDOTA_PlayerResource:ModifyLumberGained(pID,amount)
	local status, nextCall = Error_debug.ErrorCheck(function() 
		GameRules.lumberGained[pID] = PlayerResource:GetLumberGained(pID) + amount
	end)
end

function CDOTA_PlayerResource:GetLumberGained(pID)
	if GameRules.lumberGained[pID] == nil then
		GameRules.lumberGained[pID] = 0
	end
	return GameRules.lumberGained[pID] or 0
end

function CDOTA_PlayerResource:ModifyLumberGiven(pID,amount)
	GameRules.lumberGiven[pID] = PlayerResource:GetLumberGiven(pID) + amount
end

function CDOTA_PlayerResource:GetLumberGiven(pID)
	if GameRules.lumberGiven[pID] == nil then
		GameRules.lumberGiven[pID] = 0
	end
	return GameRules.lumberGiven[pID] or 0
end

function CDOTA_PlayerResource:GetAllStats(pID)
	local sum = 0
	sum = sum + PlayerResource:GetGoldGained(pID) + PlayerResource:GetGoldGiven(pID) + PlayerResource:GetLumberGiven(pID) + PlayerResource:GetLumberGained(pID)
	return sum
end

function CDOTA_PlayerResource:ModifyFood(hero,food)
	if hero == nil then
		return
	end
    food = string.match(food,"[-]?%d+") or 0
    local playerID = hero:GetPlayerOwnerID()
    hero.food = hero.food + food
	CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_food_changed", {
		playerID = playerID,
		food = math.floor(hero.food),
		maxFood = GameRules.maxFood,
	})
end

function CDOTA_PlayerResource:ModifyWisp(hero,wisp)
	if hero == nil then
		return
	end
    wisp = string.match(wisp,"[-]?%d+") or 0
    local playerID = hero:GetPlayerOwnerID()
    hero.wisp = hero.wisp + wisp
	CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_wisp_changed", {
		playerID = playerID,
		wisp = math.floor(hero.wisp),
		maxWisp = GameRules.maxWisp,
	})
end

function CDOTA_PlayerResource:ModifyMine(hero, mine)
	if hero == nil then
		return
	end
    mine = string.match(mine,"[-]?%d+") or 0
    local playerID = hero:GetPlayerOwnerID()
    hero.mine = hero.mine + mine
	CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_mine_changed", {
		playerID = playerID,
		mine = math.floor(hero.mine),
		maxMine = GameRules.maxMine,
	})
end

function CDOTA_PlayerResource:ModifyWispMine(hero, mine)
	if hero == nil then
		return
	end
    mine = string.match(mine,"[-]?%d+") or 0
    local playerID = hero:GetPlayerOwnerID()
    hero.wispmine = hero.wispmine + mine
	CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_wispmine_changed", {
		playerID = playerID,
		wispmine = math.floor(hero.wispmine),
		maxWispMine = GameRules.maxWispMine,
	})
end

function CDOTA_PlayerResource:GetScore(pID, team)
	if PlayerResource:IsValidPlayerID(pID) then
		if team == 2 then
			return tonumber(GameRules.scores[pID].elf)   -- + GameRules.scores[pID].troll
		elseif team == 3 then
			return tonumber(GameRules.scores[pID].troll) -- + GameRules.scores[pID].elf
		else 
			return 0
		end
	end
end

function CDOTA_PlayerResource:GetType(pID)
	local heroName = PlayerResource:GetSelectedHeroName(pID)
    return string.match(heroName,TROLL_HERO) and "troll"
	or string.match(heroName,ANGEL_HERO[1]) and "angel"
	or string.match(heroName,ANGEL_HERO[2]) and "angel"
	or string.match(heroName,WOLF_HERO[1]) and "wolf"
	or string.match(heroName,WOLF_HERO[2]) and "wolf"
	or "elf"
end

function CDOTA_PlayerResource:GetScoreBonus(pID)
	local scoreBonus = PlayerResource:GetScoreBonusGoldGained(pID) + PlayerResource:GetScoreBonusGoldGiven(pID) + PlayerResource:GetScoreBonusLumberGained(pID) + PlayerResource:GetScoreBonusLumberGiven(pID) + PlayerResource:GetScoreBonusRank(pID)
	return math.floor(scoreBonus)
end

function CDOTA_PlayerResource:GetScoreBonusGoldGained(pID)
	local team = PlayerResource:GetTeam(pID)
	local playerSum = PlayerResource:GetGoldGained(pID)
	local teamAvg = PlayerResource:GetPlayerCountForTeam(team) > 1 and (Team.GetGoldGained(team) - playerSum)/(PlayerResource:GetPlayerCountForTeam(team)-1) or playerSum
	playerSum = playerSum == 0 and 1 or playerSum
	teamAvg = teamAvg == 0 and 1 or teamAvg
	if playerSum == teamAvg then
		return 0
	end
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	if hero then
		if hero:IsWolf() or hero:IsAngel() or (hero:IsElf() and PlayerResource:GetDeaths(pID) > 0) then 
			return -15
		end
	end
	local sign = playerSum > teamAvg and 1 or -1
	local add = playerSum/teamAvg > 0 and 0 or 1
	playerSum = math.abs(playerSum)
	teamAvg = math.abs(teamAvg)
	local value = math.floor((math.max(playerSum,teamAvg)/math.min(playerSum,teamAvg)*goldGainedImportance/2))
	value = math.min(goldGainedImportance,value)
	return (value*sign)
	
end
function CDOTA_PlayerResource:GetScoreBonusGoldGiven(pID)
	local playerSum = PlayerResource:GetGoldGiven(pID)
	
	playerSum = math.abs(playerSum)
	local value = math.floor(playerSum*goldGivenImportance/1000000)
	value = math.max(goldGivenImportance,value)
	if value > 0 then
		value = value * -1
	end
	return math.floor(value)
end

function CDOTA_PlayerResource:GetScoreBonusLumberGained(pID)
	local team = PlayerResource:GetTeam(pID)
	local playerSum = PlayerResource:GetLumberGained(pID)
	local teamAvg = PlayerResource:GetPlayerCountForTeam(team) > 1 and (Team.GetLumberGained(team) - playerSum)/(PlayerResource:GetPlayerCountForTeam(team)-1) or playerSum
	playerSum = playerSum == 0 and 1 or playerSum
	teamAvg = teamAvg == 0 and 1 or teamAvg
	if playerSum == teamAvg then
		return 0
	end
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	if hero then
		if hero:IsWolf() or hero:IsAngel() or (hero:IsElf() and PlayerResource:GetDeaths(pID) > 0) then 
			return -15
		end
	end
	local sign = playerSum > teamAvg and 1 or -1
	local add = playerSum/teamAvg > 0 and 0 or 1
	playerSum = math.abs(playerSum)
	teamAvg = math.abs(teamAvg)
	local value = math.floor((math.max(playerSum,teamAvg)/math.min(playerSum,teamAvg)*lumberGainedImportance/2))
	value = math.min(lumberGainedImportance,value)
	if team == 3 then
		return 0
	else
		return (value*sign)
	end
end

function CDOTA_PlayerResource:GetScoreBonusLumberGiven(pID)
	local playerSum = PlayerResource:GetLumberGiven(pID)
	playerSum = math.abs(playerSum)
	local value = math.floor(playerSum*lumberGivenImportance/1000000)
	value = math.max(lumberGivenImportance,value)
	if value > 0 then
		value = value * -1
	end
	return math.floor(value)
end

function CDOTA_PlayerResource:GetScoreBonusRank(pID)
	local allyTeam = PlayerResource:GetTeam(pID)
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	local enemyTeam = allyTeam == DOTA_TEAM_GOODGUYS and DOTA_TEAM_BADGUYS or DOTA_TEAM_GOODGUYS
	
	if hero then
		if not hero:IsTroll() then 
			enemyTeam = DOTA_TEAM_BADGUYS
			allyTeam = DOTA_TEAM_GOODGUYS
		else
			enemyTeam = DOTA_TEAM_GOODGUYS
			allyTeam = DOTA_TEAM_BADGUYS
		end
	end
	local allyTeamScore = Team.GetAverageScore(allyTeam)
	if allyTeam == DOTA_TEAM_GOODGUYS then
		allyTeamScore = PlayerResource:GetScore(pID,2)
	end
	if hero then
		if hero:IsTroll() then 
			allyTeamScore = PlayerResource:GetScore(pID,3)
		end
	end
	local enemyTeamScore = Team.GetAverageScore(enemyTeam)
	if enemyTeam == DOTA_TEAM_BADGUYS then
		enemyTeamScore = PlayerResource:GetScore(GameRules.trollID,3)
	end
	local sign = allyTeamScore > enemyTeamScore and -1 or 1
	local value = math.floor((math.abs(enemyTeamScore - allyTeamScore))*rankImportance/10000)
	value = math.min(rankImportance,value)
	return (value*sign)
end

function CDOTA_PlayerResource:GetScoreBonusPersonal(pID)
	local allyTeam = PlayerResource:GetTeam(pID)
	local score = PlayerResource:GetScore(pID)
	local allyTeamScore = Team.GetAverageScore(allyTeam)
	local sign = allyTeamScore > score and 1 or -1
	local value = math.floor((math.abs(allyTeamScore - score))*rankPers/10000)
	value = math.min(rankImportance,value)
	return (value*sign)
end


function CDOTA_BaseNPC:IsElf()
    return self:GetUnitName() == ELF_HERO
end
function CDOTA_BaseNPC:IsTroll()
    return self:GetUnitName() == TROLL_HERO
end
function CDOTA_BaseNPC:IsAngel()
	return self:GetUnitName() == ANGEL_HERO[1] or self:GetUnitName() == ANGEL_HERO[2] 
end 
function CDOTA_BaseNPC:IsWolf()
	return self:GetUnitName() == WOLF_HERO[1] or self:GetUnitName() == WOLF_HERO[2] 
end
function CDOTA_BaseNPC:IsBear()
    return self:GetUnitName() == BEAR_HERO
end
function CDOTA_BaseNPC:GetNetworth()
    local sum = 0
    for i = 0, 5, 1 do
        local item = self:GetItemInSlot(i)
        if item then
			local item_name = item:GetAbilityName()
			if GetItemKV(item_name) ~= nil then
            	local gold_cost = GetItemKV(item_name)["AbilityValues"]["gold_cost"]
            	local lumber_cost = GetItemKV(item_name)["AbilityValues"]["lumber_cost"]
            	sum = sum + gold_cost + lumber_cost * 64000
			end     
		end
	end
	if self:HasItemInInventory("item_disable_repair_2") then
		sum = sum + 12288000
	end
	if self:IsTroll() or self:IsWolf() then
		sum = sum + PlayerResource:GetGold(self:GetPlayerOwnerID()) + (PlayerResource:GetLumber(self:GetPlayerOwnerID()) * 64000)
	else
		sum = sum + PlayerResource:GetGold(self:GetPlayerOwnerID())
	end
    return sum
end

function ModifyStartedConstructionBuildingCount(hero, unitName, number)
    local buildingCounts = hero.buildings[unitName]
    buildingCounts.startedConstructionCount = buildingCounts.startedConstructionCount + number
	if number == 0 then
		buildingCounts.startedConstructionCount = 0
	end
end

function ModifyCompletedConstructionBuildingCount(hero, unitName, number)
	local buildingCounts = hero.buildings[unitName]
    buildingCounts.completedConstructionCount = buildingCounts.completedConstructionCount + number
	if number == 0 then
		buildingCounts.completedConstructionCount = 0
	end
end
