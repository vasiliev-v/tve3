
mode = nil
require('filter')
require('events')
require("game_spells_lib")
-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function trollnelves2:_Inittrollnelves2()
  -- Setup rules
  GameRules:SetHeroRespawnEnabled(true)
  GameRules:SetUseUniversalShopMode(false)
  GameRules:SetSameHeroSelectionEnabled(true)
  GameRules:SetHeroSelectionTime(0)
  GameRules:SetStrategyTime(0)
  GameRules:SetShowcaseTime(0)
  GameRules:SetPreGameTime(PRE_GAME_TIME)
  GameRules:SetPostGameTime(120)
   -- Will finish game setup using FinishCustomGameSetup()
  GameRules:SetCustomGameSetupRemainingTime(-1)
  GameRules:SetCustomGameSetupTimeout(-1)
  GameRules:EnableCustomGameSetupAutoLaunch(false)
  if not string.match(GetMapName(),"clanwars") then
    GameRules:SetCustomGameSetupAutoLaunchDelay(-1)
  else
    GameRules:SetCustomGameSetupAutoLaunchDelay(TEAM_CHOICE_TIME)
  end
  GameRules:SetStartingGold(0)
  GameRules:SetTreeRegrowTime(0)
  GameRules:SetUseCustomHeroXPValues(false)
  GameRules:SetGoldPerTick(0)
  GameRules:SetGoldTickTime(0)
  GameRules:SetRuneSpawnTime(0)
  GameRules:SetUseBaseGoldBountyOnHeroes(false)
  GameRules:SetFirstBloodActive(false)
  GameRules:SetHideKillMessageHeaders(true)
  if not string.match(GetMapName(),"clanwars") then
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 17)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 17)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 6)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2, 6)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_3, 6)
  else
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 5)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 5)
  end
  
  GameRules:SetCustomGameTeamMaxPlayers(0, 0)
 -- GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_NOTEAM, 0)
 -- GameRules:SetCustomGameTeamMaxPlayers(-1, 0)
  --GameRules:SetIgnoreLobbyTeamsInCustomGame(true)

  -- Setup game mode
  mode = GameRules:GetGameModeEntity()     
  mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )  
  mode:SetRecommendedItemsDisabled(true)
  mode:SetBuybackEnabled(false)
  mode:SetTopBarTeamValuesVisible(false)
  mode:SetCustomHeroMaxLevel(999)
  mode:SetAnnouncerDisabled(false)
  mode:SetWeatherEffectsDisabled(true)
  if not GameRules:IsCheatMode() then  
    mode:SetPauseEnabled(false)
  end
  mode:SetStashPurchasingDisabled(true)
  mode:SetNeutralStashEnabled(false)
  mode:SetSendToStashEnabled(false)
  
  mode:SetMinimumAttackSpeed(MINIMUM_ATTACK_SPEED)
  mode:SetMaximumAttackSpeed(MAXIMUM_ATTACK_SPEED)
  
  mode:SetUseCustomHeroLevels ( true )
  mode:SetCameraDistanceOverride(1400)
  mode:SetCustomScanCooldown(9999999)
 -- mode:SetBotThinkingEnabled(false)
 mode:SetGiveFreeTPOnDeath(false)
 mode:SetTPScrollSlotItemOverride("item_anti_angel")

 mode:SetDaynightCycleAdvanceRate(1)
 mode:SetDaynightCycleDisabled(false)
 GameRules:SetTimeOfDay(0.25)


-- Remove TP Scrolls
--[[ 
GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(function(ctx, event)
  local unit = EntIndexToHScript(event.inventory_parent_entindex_const)
  local item = EntIndexToHScript(event.item_entindex_const)

  if unit:IsHero() and unit:GetNumItemsInInventory() >= 6 then
      CreateItemOnPositionSync(unit:GetAbsOrigin(), item)
      return false
  end
  return not (item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil)
end, self)
]]
  -- Event Hooks
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(trollnelves2, 'OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(trollnelves2, 'OnNPCSpawned'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(trollnelves2, 'OnConnectFull'), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(trollnelves2, 'OnPlayerReconnect'), self)
  ListenToGameEvent("player_disconnect", Dynamic_Wrap(trollnelves2, 'OnDisconnect'), self)
  ListenToGameEvent('player_chat', Dynamic_Wrap(chatcommand, 'OnPlayerChat'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(trollnelves2, 'OnItemPickedUp'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(trollnelves2, 'OnEntityKilled'), self)
  
  -- ListenToGameEvent('dota_inventory_item_added', Dynamic_Wrap(trollnelves2, 'OnItemAddedInv'), self)
  
  
  -- Panorama event listeners
  CustomGameEventManager:RegisterListener("give_resources", GiveResources)
  CustomGameEventManager:RegisterListener("choose_help_side", ChooseHelpSide)
  CustomGameEventManager:RegisterListener("player_team_choose", OnPlayerTeamChoose)
  CustomGameEventManager:RegisterListener("choose_kick_side", VoteKick)
  CustomGameEventManager:RegisterListener("votekick_start", VotekickStart)
  CustomGameEventManager:RegisterListener("flag_start", FlagStart)
  CustomGameEventManager:RegisterListener("choose_flag_side", FlagGive)
 -- CustomGameEventManager:RegisterListener("donate_player_take", PlayerTake )
  CustomGameEventManager:RegisterListener("SelectPart", Dynamic_Wrap(wearables, 'SelectPart'))
  CustomGameEventManager:RegisterListener("SelectSkin", Dynamic_Wrap(wearables, 'SelectSkin'))
  CustomGameEventManager:RegisterListener("SelectLabel", Dynamic_Wrap(wearables, 'SelectLabel'))
  CustomGameEventManager:RegisterListener("SelectSkinTower", Dynamic_Wrap(wearables, 'SelectSkinTower'))
  CustomGameEventManager:RegisterListener("SelectSkinWisp", Dynamic_Wrap(wearables, 'SelectSkinWisp'))
  CustomGameEventManager:RegisterListener("BuyShopItem", Dynamic_Wrap(Shop, 'BuyShopItem'))
  CustomGameEventManager:RegisterListener("EventRewards", Dynamic_Wrap(Shop, 'EventRewards'))
  CustomGameEventManager:RegisterListener("Statistics", Dynamic_Wrap(Shop, 'Statistics'))
  CustomGameEventManager:RegisterListener("EventBattlePass", Dynamic_Wrap(Shop, 'EventBattlePass'))
  CustomGameEventManager:RegisterListener("SetDefaultPart", Dynamic_Wrap(wearables, 'SetDefaultPart'))
  CustomGameEventManager:RegisterListener("SetDefaultPets", Dynamic_Wrap(SelectPets, 'SetDefaultPets'))
  CustomGameEventManager:RegisterListener("SetDefaultSkin", Dynamic_Wrap(wearables, 'SetDefaultSkin'))
  CustomGameEventManager:RegisterListener("SetDefaultLabel", Dynamic_Wrap(wearables, 'SetDefaultLabel'))
  CustomGameEventManager:RegisterListener("SetDefaultSkinTower", Dynamic_Wrap(wearables, 'SetDefaultSkinTower'))
  CustomGameEventManager:RegisterListener("SetDefaultSkinWisp", Dynamic_Wrap(wearables, 'SetDefaultSkinWisp'))
  
  CustomGameEventManager:RegisterListener("SelectPets", Dynamic_Wrap(SelectPets, 'SelectPets'))
  CustomGameEventManager:RegisterListener("OpenChestAnimation", Dynamic_Wrap(Shop, 'OpenChestAnimation'))

  CustomGameEventManager:RegisterListener( "SelectVO", Dynamic_Wrap(Shop,'SelectVO'))

  CustomGameEventManager:RegisterListener( "event_set_activate_spell", Dynamic_Wrap(game_spells_lib, "event_set_activate_spell"))
  -- CustomGameEventManager:RegisterListener( "event_buy_spell", Dynamic_Wrap(game_spells_lib, "event_buy_spell")) -- remove buy random aspect
  CustomGameEventManager:RegisterListener( "event_upgrade_spell", Dynamic_Wrap(game_spells_lib, "event_upgrade_spell"))

  
  CustomNetTables:SetTableValue("building_settings", "team_choice_time", { value = TEAM_CHOICE_TIME })
  
  mode:SetModifyExperienceFilter( Dynamic_Wrap( trollnelves2, "ExperienceFilter" ), self )
   mode:SetDamageFilter( Dynamic_Wrap( trollnelves2, "DamageFilter" ), self ) 
  
 -- mode:SetItemAddedToInventoryFilter(Dynamic_Wrap(trollnelves2, "ItemPickFilter"), self)
  
  
  -- Debugging setup
  local spew = 0
  if TROLLNELVES2_DEBUG_SPEW then
    spew = 1
  end
  Convars:RegisterConvar('trollnelves2_spew', tostring(spew), 'Set to 1 to start spewing trollnelves2 debug info.  Set to 0 to disable.', 0)

  -- Change random seed
  local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
  math.randomseed(tonumber(timeTxt))
  
  --DebugPrint('[TROLLNELVES2] Done loading trollnelves2!\n\n')
end

-- This function is called as the first player loads and sets up the trollnelves2 parameters
function trollnelves2:_Capturetrollnelves2()
  if mode == nil then

    self:OnFirstPlayerLoaded()
  end 
end

function trollnelves2:LoadStaticContent(contentFile)
    return trollnelves2:prequire(contentFile)
end

function trollnelves2:prequire(...)
    local status, lib = pcall(require, ...)
    if (status) then return lib end
    return nil
end

function trollnelves2:ExperienceFilter( kv )
    if kv.reason_const ~= 0 then
        kv.experience = 0
    end
    return true
end
local getGold = {}
function trollnelves2:DamageFilter( kv )
  if kv.entindex_attacker_const ~= nil then
    local heroAttacker = EntIndexToHScript(kv.entindex_attacker_const)
    local heroKilled = EntIndexToHScript(kv.entindex_victim_const)
    local team       = heroAttacker:GetTeamNumber()
    local teamKilled = heroKilled:GetTeamNumber()
    local heroAttackerID = heroAttacker:GetPlayerOwnerID()
    local heroKilledID = heroKilled:GetPlayerOwnerID()
    local OwnHeroAtacker = PlayerResource:GetSelectedHeroEntity(heroAttackerID)
    local OwnHeroKilled = PlayerResource:GetSelectedHeroEntity(heroKilledID)

    if OwnHeroAtacker == nil or OwnHeroKilled == nil then
      return true
    end

    if OwnHeroAtacker:IsTroll() and OwnHeroKilled:IsWolf() then
       OwnHeroKilled:Kill(nil, OwnHeroKilled)
      return true
    end
    
    if OwnHeroAtacker:IsWolf() and OwnHeroKilled:IsWolf() and OwnHeroAtacker ~= OwnHeroKilled  then
      kv.damage = 0
      return true
    end

    if team ~= teamKilled and 
      PlayerResource:IsValidPlayerID(heroAttackerID) and not PlayerResource:IsFakeClient(heroAttackerID) and 
      PlayerResource:IsValidPlayerID(heroKilledID) and not PlayerResource:IsFakeClient(heroKilledID) then

        
      PlayerResource:ModifyDamageGiven(heroAttackerID, kv.damage)
      PlayerResource:ModifyDamageTake(heroKilledID, kv.damage)
    end
  

    if string.match(heroKilled:GetUnitName(), "wisp") and team == DOTA_TEAM_BADGUYS then
      kv.damage = 10
    end

    if OwnHeroAtacker:HasModifier("modifier_elf_spell_damage_gold") and 
    ((GameRules.MapSpeed == 1 and  GameRules:GetGameTime() - GameRules.startTime <= 2100) or 
    (GameRules.MapSpeed == 2 and  GameRules:GetGameTime() - GameRules.startTime <= 1200))
    then
      if OwnHeroAtacker == OwnHeroKilled then
        return true
      end
      if heroAttacker:GetTeamNumber() == heroKilled:GetTeamNumber() and OwnHeroAtacker ~= OwnHeroKilled then
        return
      end
      if getGold[heroAttackerID] == nil then
        getGold[heroAttackerID] = 0
      end
			if OwnHeroAtacker:FindModifierByName("modifier_elf_spell_damage_gold"):GetStackCount() == 1  then
				getGold[heroAttackerID] = getGold[heroAttackerID] + kv.damage * 0.10
			elseif OwnHeroAtacker:FindModifierByName("modifier_elf_spell_damage_gold"):GetStackCount() == 2 then
				getGold[heroAttackerID] = getGold[heroAttackerID] + kv.damage * 0.15 
			elseif OwnHeroAtacker:FindModifierByName("modifier_elf_spell_damage_gold"):GetStackCount() == 3 then
				getGold[heroAttackerID] = getGold[heroAttackerID] + kv.damage * 0.20
			end
      local goldToGive = math.floor(getGold[heroAttackerID])
      if goldToGive >= 1 then
        PlayerResource:ModifyGold(OwnHeroAtacker, goldToGive, true)
        getGold[heroAttackerID] = getGold[heroAttackerID] - goldToGive
      end
		end

    if OwnHeroAtacker:HasModifier("modifier_elf_spell_damage_gold_x4") and 
    (GameRules.MapSpeed == 4 and  GameRules:GetGameTime() - GameRules.startTime <= 420)
    then
      if OwnHeroAtacker == OwnHeroKilled then
        return true
      end
      if heroAttacker:GetTeamNumber() == heroKilled:GetTeamNumber() and OwnHeroAtacker ~= OwnHeroKilled then
        return
      end
      if getGold[heroAttackerID] == nil then
        getGold[heroAttackerID] = 0
      end
			if OwnHeroAtacker:FindModifierByName("modifier_elf_spell_damage_gold_x4"):GetStackCount() == 1  then
				getGold[heroAttackerID] = getGold[heroAttackerID] + kv.damage * 0.10
			elseif OwnHeroAtacker:FindModifierByName("modifier_elf_spell_damage_gold_x4"):GetStackCount() == 2 then
				getGold[heroAttackerID] = getGold[heroAttackerID] + kv.damage * 0.15 
			elseif OwnHeroAtacker:FindModifierByName("modifier_elf_spell_damage_gold_x4"):GetStackCount() == 3 then
				getGold[heroAttackerID] = getGold[heroAttackerID] + kv.damage * 0.20
			end
      local goldToGive = math.floor(getGold[heroAttackerID])
      if goldToGive >= 1 then
        PlayerResource:ModifyGold(OwnHeroAtacker, goldToGive, true)
        getGold[heroAttackerID] = getGold[heroAttackerID] - goldToGive
      end
		end



    return true
  end
end

function trollnelves2:PlayerLoaded(player, pid)
    if player == nil then return end
end