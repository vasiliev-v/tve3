require('libraries/util')
require('trollnelves2')
require('stats')
require('donate_store/wearables')
require('drop')
require('error_debug')
require('settings')

CheckBank = false
CheckBarak3 = false
-- A build ability is used (not yet confirmed)
function Build( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local building_name = ability:GetAbilityKeyValues()['UnitName']
    local hero = caster:IsRealHero() and caster or caster:GetOwner()
    local playerID = hero:GetPlayerOwnerID()
    local gold_cost = ability:GetSpecialValueFor("gold_cost")
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
	local mine_cost = ability:GetSpecialValueFor("MineCost")
    local status, nextCall = Error_debug.ErrorCheck(function()
    if GameRules.FakeList[playerID] ~= nil then
        return
    end
    -- Makes a building dummy and starts panorama ghosting
    BuildingHelper:AddBuilding(event)
    
    -- Additional checks to confirm a valid building position can be performed here
    event:OnPreConstruction(function(vPos)
        
        -- Check for minimum height if defined
        if not BuildingHelper:MeetsHeightCondition(vPos) then
            SendErrorMessage(playerID, "error_invalid_build_position")
            return false
        end

       -- if building_name == "flag" and GameRules.PlayersBase[playerID] ~= nil then
      --      SendErrorMessage(playerID, "error_place_is_flag")
      --      return false 
     --   end
        
        -- If not enough resources to queue, stop
        if PlayerResource:GetGold(playerID) < gold_cost then
            SendErrorMessage(playerID, "error_not_enough_gold")
            return false
        end
        if PlayerResource:GetLumber(playerID) < lumber_cost then
            SendErrorMessage(playerID, "error_not_enough_lumber")
            return false
        end

        if mine_cost ~= nil then
            if mine_cost ~= 0 then
                if hero.mine >= GameRules.maxMine  then
                    SendErrorMessage(playerID, "error_not_enough_mine")
                    caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
                    return false
                end
            end
        end

        return true
    end)
    
    -- Position for a building was confirmed and valid
    event:OnBuildingPosChosen(function(vPos)
        PlayerResource:ModifyGold(hero,-gold_cost)
        PlayerResource:ModifyLumber(hero,-lumber_cost)
        if mine_cost ~= nil then
            if mine_cost ~= 0 then
                PlayerResource:ModifyMine(hero, mine_cost)
            end
        end
        EmitSoundOnEntityForPlayer("DOTA_Item.ObserverWard.Activate", hero, hero:GetPlayerOwnerID())
    end)
    
    -- The construction failed and was never confirmed due to the gridnav being blocked in the attempted area
    event:OnConstructionFailed(function()
        --local playerTable = BuildingHelper:GetPlayerTable(playerID)
        --local name = playerTable.activeBuilding or " "
        --BuildingHelper:print("Failed placement of " .. name)
    end)
    
    -- Cancelled due to ClearQueue
    event:OnConstructionCancelled(function(work)
        local name = work.name
        BuildingHelper:print("Cancelled construction of " .. name)
        -- Refund resources for this cancelled work
        if work.refund and work.refund == true and not work.repair then
            PlayerResource:ModifyGold(hero,gold_cost,true)
            PlayerResource:ModifyLumber(hero,lumber_cost,true)
            if mine_cost ~= nil then
                if mine_cost ~= 0 then
                    PlayerResource:ModifyMine(hero, -1)
                end
            end
        end
    end)
    
     
        -- A building unit was created
        event:OnConstructionStarted(function(unit)
            BuildingHelper:print("Started construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
            unit.gold_cost = gold_cost
            unit.lumber_cost = lumber_cost
            unit:AddNewModifier(unit,nil,"modifier_phased",{}) 
            -- If it's an item-ability and has charges, remove a charge or remove the item if no charges left
            if ability.GetCurrentCharges and not ability:IsPermanent() then
                local charges = ability:GetCurrentCharges()
                charges = charges-1
                if charges == 0 then
                    ability:RemoveSelf()
                    else
                    ability:SetCurrentCharges(charges)
                end
            end
            --unit:RemoveModifierByName("modifier_invulnerable")
            unit:AddNewModifier(nil, nil, "modifier_stunned", {})
            
            if  caster.work then
                FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
                caster:AddNewModifier(caster, nil, "modifier_phased", {duration=0.03})
            end
               
            local unitName = unit:GetUnitName()
            ModifyStartedConstructionBuildingCount(hero, unitName, 1)
            table.insert(hero.units, unit)
            AddUpgradeAbilities(unit)
            UpdateSpells(hero)

            local item = CreateItem("item_building_cancel", unit, unit)
            if building_name ~= "flag" then
                unit:AddItem(item)
            elseif building_name == "flag" then 
            --    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
                unit:AddNewModifier(unit, nil, "modifier_phased", {})
                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
                local abil = hero:FindAbilityByName("build_flag")
                abil:StartCooldown(999999) 
                -- unit:SetCustomHealthLabel(tostring(PlayerResource:GetPlayerName(playerID)) ,  255, 255, 255)
            end
            
            for i=0, unit:GetAbilityCount()-1 do
                local ability = unit:GetAbilityByIndex(i)
                if ability then
                    local constructionStartModifiers = GetAbilityKV(ability:GetAbilityName(), "ConstructionStartModifiers")
                    if constructionStartModifiers then
                        for k,modifier in pairs(constructionStartModifiers) do
                            ability:ApplyDataDrivenModifier(unit, unit, modifier, {})
                        end
                    end
                end
            end
            if string.match(building_name,"rock") and unit:GetMana() > 0  then
                unit:SetMana(0)
            end

        end)
    
    
    
    
    -- A building finished construction
    event:OnConstructionCompleted(function(unit)
        BuildingHelper:print("Completed construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex() .. " " .. tostring(unit))
        unit.state = "complete"
        unit.ancestors = {}
        local item = unit:GetItemInSlot(0)
        if item then
            UTIL_Remove(item)
        end
        
        local unitName = unit:GetUnitName()
        ModifyCompletedConstructionBuildingCount(hero, unitName, 1)
        
        UpdateSpells(hero)
        for _, value in ipairs(hero.units) do
            UpdateUpgrades(value)
        end
        
        -- Give the unit their original attack capability
        unit:RemoveModifierByName("modifier_stunned")
        -- unit:StopAnimation() --Animation stop
        --unit:RemoveModifierByName("modifier_riki_poison_dart_debuff") --!!!
        local itemBuildingDestroy = CreateItem("item_building_destroy", nil, nil)
       -- if building_name ~= "flag"  then
            unit:AddItem(itemBuildingDestroy)
            if building_name == "flag" then 
             --   unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
                unit:AddNewModifier(unit, nil, "modifier_phased", {})
                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
                local abil = hero:FindAbilityByName("build_flag")
                abil:StartCooldown(999999) 
                -- unit:SetCustomHealthLabel(tostring(PlayerResource:GetPlayerName(playerID)) ,  255, 255, 255)
            end
        unit.attackers = {}
        
        for i=0, unit:GetAbilityCount()-1 do
            local buildingAbility = unit:GetAbilityByIndex(i)
            if buildingAbility then
                local constructionCompleteModifiers = GetAbilityKV(buildingAbility:GetAbilityName(), "ConstructionCompleteModifiers")
                if constructionCompleteModifiers then
                    for k,modifier in pairs(constructionCompleteModifiers) do
                        buildingAbility:ApplyDataDrivenModifier(unit, unit, modifier, {})
                    end
                end
            end
        end
        
        local player = unit:GetPlayerOwner()
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "unit_upgrade_complete", { })
        end

        if GameRules.SkinTower[playerID] ~= nil then
            if GameRules.SkinTower[playerID][building_name] == "1036"  then 
                wearables:RemoveWearables(unit)
                UpdateModel(unit, "models/flag_2.vmdl", 0.5)  
            end
        end
        if hero:HasModifier("modifier_elf_spell_armor_wall") and string.match(building_name,"rock") then
            if hero:FindModifierByName("modifier_elf_spell_armor_wall"):GetStackCount() == 1  then
                unit:AddNewModifier(unit, unit, "modifier_wall_spell_armor", {}):SetStackCount(1) 
            elseif hero:FindModifierByName("modifier_elf_spell_armor_wall"):GetStackCount() == 2 then
                unit:AddNewModifier(unit, unit, "modifier_wall_spell_armor", {}):SetStackCount(2) 
            elseif hero:FindModifierByName("modifier_elf_spell_armor_wall"):GetStackCount() == 3 then
                unit:AddNewModifier(unit, unit, "modifier_wall_spell_armor", {}):SetStackCount(3) 
            end
        end
        if hero:HasModifier("modifier_elf_spell_tower_damage") and string.match(building_name,"tower") then
            if hero:FindModifierByName("modifier_elf_spell_tower_damage"):GetStackCount() == 1  then
                unit:AddNewModifier(unit, unit, "modifier_tower_spell_dmg", {}):SetStackCount(1) 
            elseif hero:FindModifierByName("modifier_elf_spell_tower_damage"):GetStackCount() == 2 then
                unit:AddNewModifier(unit, unit, "modifier_tower_spell_dmg", {}):SetStackCount(2) 
            elseif hero:FindModifierByName("modifier_elf_spell_tower_damage"):GetStackCount() == 3 then
                unit:AddNewModifier(unit, unit, "modifier_tower_spell_dmg", {}):SetStackCount(3) 
            end
        end

        if hero:HasModifier("modifier_elf_spell_tower_range") and string.match(building_name,"tower") then
            if hero:FindModifierByName("modifier_elf_spell_tower_range"):GetStackCount() == 1  then
                unit:AddNewModifier(unit, unit, "modifier_tower_spell_range", {}):SetStackCount(1) 
            elseif hero:FindModifierByName("modifier_elf_spell_tower_range"):GetStackCount() == 2 then
                unit:AddNewModifier(unit, unit, "modifier_tower_spell_range", {}):SetStackCount(2) 
            elseif hero:FindModifierByName("modifier_elf_spell_tower_range"):GetStackCount() == 3 then
                unit:AddNewModifier(unit, unit, "modifier_tower_spell_range", {}):SetStackCount(3) 
            end
        end

    end)
    
    -- These callbacks will only fire when the state between below half health/above half health changes.
    -- i.e. it won't fire multiple times unnecessarily.
    event:OnBelowHalfHealth(function(unit)
        --BuildingHelper:print("" .. unit:GetUnitName() .. " is below half health.")
    end)
    
    event:OnAboveHalfHealth(function(unit)
        --BuildingHelper:print("" ..unit:GetUnitName().. " is above half health.")        
    end)
	
end)
end

-- Called when the Cancel ability-item is used
function CancelBuilding( keys )
    local building = keys.unit
    local hero = building:GetOwner()
    local playerID = building:GetMainControllingPlayer()
    local units = FindUnitsInRadius(building:GetTeamNumber() , building:GetAbsOrigin() , nil , 200 , DOTA_UNIT_TARGET_TEAM_ENEMY ,  DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    BuildingHelper:print("CancelBuilding "..building:GetUnitName().." "..building:GetEntityIndex())
    if #units > 0 and building:GetUnitName() ~= "tent" then
        SendErrorMessage(playerID, "error_enemy_nearby")
        return
    end
    -- Refund here
    if building.gold_cost then 
        PlayerResource:ModifyGold(hero,building.gold_cost*0.5,true)
    end
    if building.lumber_cost then 
        PlayerResource:ModifyLumber(hero,building.lumber_cost*0.5,true)
    end
    
    if building:HasModifier("modifier_shallow_grave_datadriven") then
        building:RemoveModifierByName("modifier_shallow_grave_datadriven")
    end
    
    building:Kill(nil, building)
    Timers:CreateTimer(0.1,function()
        UTIL_Remove(building)    
    end)
end

function DestroyBuilding( keys )
    local building = keys.unit
    local units = FindUnitsInRadius(building:GetTeamNumber() , building:GetAbsOrigin() , nil , 2000 , DOTA_UNIT_TARGET_TEAM_ENEMY ,  DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    local ownerID = building:GetPlayerOwnerID()
    local playerID = building:GetMainControllingPlayer()
    local hero = building:GetOwner()
    if #units > 0 and building:GetUnitName() ~= "tent" then
        SendErrorMessage(playerID, "error_enemy_nearby")
    else
        if building:GetUnitName() == "flag" then
            for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) then
                    if GameRules.PlayersBase[pID] == GameRules.PlayersBase[playerID] and pID ~= playerID then
                      --  GameRules.PlayersBase[pID] = nil
                        GameRules.countFlag[pID] = nil
                    --    local hero2 = PlayerResource:GetSelectedHeroEntity(pID)
                    --    local abil2 = hero:FindAbilityByName("build_flag")
                   --     abil2:StartCooldown(300) 
                    end
                end
            end
            
            local abil2 = hero:FindAbilityByName("build_flag")
            abil2:EndCooldown()
            abil2:StartCooldown(60) 
            GameRules.PlayersBase[ownerID] = nil
            GameRules.countFlag[ownerID] = nil
        end
        
        if building:HasModifier("modifier_shallow_grave_datadriven") then
            building:RemoveModifierByName("modifier_shallow_grave_datadriven")
        end
        building:Kill(nil, building)

        
    end
    
end

function UpgradeBuilding( event )
    local building = event.caster
    local NewBuildingName = event.NewName
    local playerID = building:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local upgrades = GetUnitKV(building:GetUnitName(),"Upgrades")
    local buildTime = GetUnitKV(NewBuildingName,"BuildTime")
  --  local baseID = BuildingHelper:IdBaseArea(building)
  --  if baseID ~= nil and baseID ~= GameRules.PlayersBase[playerID] and GameRules.PlayersBase[playerID] ~= nil then
  --      SendErrorMessage(playerID, "error_not_upgrade_flag_base")
  --      return false
  --  end
    if GameRules.FakeList[playerID] ~= nil then
        return
    end
    if not string.match(NewBuildingName,"troll_hut") and not string.match(NewBuildingName,"troll2_hut") then
        if not BuildingHelper:IsInsideBaseArea(building, building, NewBuildingName, true) then --and string.match(GetMapName(),"clanwars") then
            event.unit = building
            CancelBuilding(event)
            SendErrorMessage(playerID, "error_not_upgrade_flag_base")
            return false
        end
    end
    if GameRules.MapSpeed == 4 and NewBuildingName ~= "tower_19" and NewBuildingName ~= "tower_19_1" and NewBuildingName ~= "tower_19_2" and not string.match(NewBuildingName,"rock") then
        buildTime = buildTime/2
    end
    
    local gold_cost
    local lumber_cost
    
    if string.match(building:GetUnitName(),"troll_hut") then
        hero = GameRules.trollHero
        playerID = GameRules.trollID
    end
    
    -- I do it like this so you are able to have two buildings upgrade into the same upgraded building with different prices and only having one ability
    local count = tonumber(upgrades.Count)
    for i = 1, count, 1 do
        local upgrade = upgrades[tostring(i)]
        local upgraded_unit_name = upgrade.unit_name
        if upgraded_unit_name == NewBuildingName then
            gold_cost = upgrade.gold_cost
            lumber_cost = upgrade.lumber_cost
        end
        --new
        --if upgraded_unit_name == "troll_hut_2" and string.match(GetMapName(),"1x1") then
        --    gold_cost = 175
        --    lumber_cost = upgrade.lumber_cost
        --end
        --if upgraded_unit_name == "troll_hut_3" and string.match(GetMapName(),"1x1") then
        --    gold_cost = 250
        --    lumber_cost = upgrade.lumber_cost
        --end
        --if upgraded_unit_name == "troll_hut_4" and string.match(GetMapName(),"1x1") then
        --    gold_cost = 425
        --   lumber_cost = upgrade.lumber_cost
        --end
        --endnew
    end
    if gold_cost > PlayerResource:GetGold(playerID) then
        SendErrorMessage(playerID, "error_not_enough_gold")
        return false
    end
    if lumber_cost > PlayerResource:GetLumber(playerID) then
        SendErrorMessage(playerID, "error_not_enough_lumber")
        return false
    end
    -- if GameRules.MapSpeed >= 4 and NewBuildingName == 'tower_19' then
    --    SendErrorMessage(playerID, "error_not_upgrade_tower19_x4")
    --     return false
    --  end
	building:AddNewModifier(nil, nil, "modifier_stunned", {}) 
	
    local newBuilding
    local status, nextCall = Error_debug.ErrorCheck(function() 
        newBuilding = BuildingHelper:UpgradeBuilding(building,NewBuildingName)
    end)
    if string.match(building:GetUnitName(),"rock") and building:GetMana() > 0  then
        newBuilding:SetMana(0)
    end
    local newBuildingName = newBuilding:GetUnitName()
    newBuilding.state = "complete"
    
    newBuilding.ancestors = building.ancestors
    table.insert(newBuilding.ancestors,building:GetUnitName())
    for _, ancestorUnitName in pairs(newBuilding.ancestors) do
        ModifyStartedConstructionBuildingCount(hero, ancestorUnitName, 1)
        ModifyCompletedConstructionBuildingCount(hero, ancestorUnitName, 1)
    end
    table.insert(hero.units, newBuilding)
    ModifyStartedConstructionBuildingCount(hero, newBuildingName, 1)
    
    local ability = event.ability
    local skips = GetAbilityKV(ability:GetAbilityName(),"SkipRequirements")
    --DebugPrint("ability:GetAbilityName() " .. ability:GetAbilityName())
    if skips then
        for _, skipUnitName in pairs(skips) do
            --DebugPrint("skipUnitName " .. skipUnitName)
            ModifyStartedConstructionBuildingCount(hero, skipUnitName, 1)
            ModifyCompletedConstructionBuildingCount(hero, skipUnitName, 1)
        end
    end
    
    PlayerResource:ModifyGold(hero,-gold_cost)
    PlayerResource:ModifyLumber(hero,-lumber_cost)
    AddUpgradeAbilities(newBuilding)
    for i=0, newBuilding:GetAbilityCount()-1 do
        local newBuildingAbility = newBuilding:GetAbilityByIndex(i)
        if newBuildingAbility then
            local constructionCompleteModifiers = GetAbilityKV(newBuildingAbility:GetAbilityName(), "ConstructionCompleteModifiers")
            if constructionCompleteModifiers then
                for _, modifier in pairs(constructionCompleteModifiers) do
                    newBuildingAbility:ApplyDataDrivenModifier(newBuilding, newBuilding, modifier, {})
                end
            end
            local constructionStartModifiers = GetAbilityKV(newBuildingAbility:GetAbilityName(), "ConstructionStartModifiers")
            if constructionStartModifiers then
                for _, modifier in pairs(constructionStartModifiers) do
                    newBuildingAbility:ApplyDataDrivenModifier(newBuilding, newBuilding, modifier, {})
                end
            end
        end
    end
    local position = newBuilding:GetAbsOrigin()
    
    if string.match(building:GetUnitName(),"rock") then
        newBuilding:SetMana(building:GetMana())
    end
    if building:HasModifier("modifier_shallow_grave_datadriven") then
        building:RemoveModifierByName("modifier_shallow_grave_datadriven")
    end
    building:Kill(nil, hero)
    newBuilding.construction_size = BuildingHelper:GetConstructionSize(newBuildingName)
    if not string.match(newBuilding:GetUnitName(),"troll_hut") and not string.match(newBuilding:GetUnitName(),"troll2_hut") then
        newBuilding.blockers = BuildingHelper:BlockGridSquares(newBuilding.construction_size, BuildingHelper:GetBlockPathingSize(newBuildingName), position)
    elseif newBuilding:GetUnitName() == "troll_hut_6" or newBuilding:GetUnitName() == "troll2_hut_6" then --elseif newBuilding:GetUnitName() == "troll_hut_7" then
        hero:AddAbility("lone_druid_spirit_bear_datadriven")
        local abil = hero:FindAbilityByName("lone_druid_spirit_bear_datadriven")
        abil:SetLevel(abil:GetMaxLevel())
        GameRules.MultiMapSpeed = 2
    end

    if GameRules.SkinTower[playerID] ~= nil then
        ApplyTowerSkin(playerID, newBuildingName, newBuilding)
    end

    if newBuildingName == "bank" and (not CheckBank and not string.match(GetMapName(),"clanwars")) then
        if GameRules.Bonus[playerID] == nil then
            GameRules.Bonus[playerID] = 0
        end
        GameRules.Bonus[playerID] = GameRules.Bonus[playerID] + 10
        CheckBank = true
        local roll_chance = RandomFloat(0, 100)
        local playername = PlayerResource:GetPlayerName(playerID)
	    GameRules:SendCustomMessageToTeam("<font color='#009900'>"..playername.."</font> built Bank at "..ConvertToTime(GameRules:GetGameTime() - GameRules.startTime).." in X" .. GameRules.MapSpeed .. " mode.", hero:GetTeamNumber(), hero:GetTeamNumber(), hero:GetTeamNumber())
        if roll_chance <= CHANCE_DROP_GEM_BANK then
            local spawnPoint = newBuilding:GetAbsOrigin()	
            local newItem = CreateItem( "item_get_gem", nil, nil )
            local dropRadius = RandomFloat( 250, 450 )
            local randRadius = spawnPoint + RandomVector( dropRadius )
            CreateItemOnPositionForLaunch( randRadius, newItem )
            newItem:LaunchLootInitialHeight( false, 0, 250, 0.5, randRadius ) 
        end
        if roll_chance <= CHANCE_DROP_GOLD_BANK then
            local spawnPoint = newBuilding:GetAbsOrigin()	
            local newItem = CreateItem( "item_get_gold", nil, nil )
            local dropRadius = RandomFloat( 250, 450 )
            local randRadius = spawnPoint + RandomVector( dropRadius )
            CreateItemOnPositionForLaunch( randRadius, newItem )
            newItem:LaunchLootInitialHeight( false, 0, 250, 0.5, randRadius ) 
        end
    elseif newBuildingName == "barracks_3" and (not CheckBarak3 and not string.match(GetMapName(),"clanwars")) then
        GameRules.Bonus[playerID] = GameRules.Bonus[playerID] + 5
        CheckBarak3 = true
        local roll_chance = RandomFloat(0, 100)
        local playername = PlayerResource:GetPlayerName(playerID)
	    GameRules:SendCustomMessageToTeam("<font color='#009900'>"..playername.."</font> built Barracks 3 at "..ConvertToTime(GameRules:GetGameTime() - GameRules.startTime).." in X" .. GameRules.MapSpeed .. " mode.", hero:GetTeamNumber(), hero:GetTeamNumber(), hero:GetTeamNumber())
        if roll_chance <= CHANCE_DROP_GEM_BARRACKS_3 then
            local spawnPoint = newBuilding:GetAbsOrigin()	
            local newItem = CreateItem( "item_get_gem", nil, nil )
            local dropRadius = RandomFloat( 250, 450 )
            local randRadius = spawnPoint + RandomVector( dropRadius )
            CreateItemOnPositionForLaunch( randRadius, newItem )
            newItem:LaunchLootInitialHeight( false, 0, 250, 0.5, randRadius ) 
        end
        if roll_chance <= CHANCE_DROP_GOLD_BARRACKS_3 then
            local spawnPoint = newBuilding:GetAbsOrigin()	
            local newItem = CreateItem( "item_get_gold", nil, nil )
            local dropRadius = RandomFloat( 250, 450 )
            local randRadius = spawnPoint + RandomVector( dropRadius )
            CreateItemOnPositionForLaunch( randRadius, newItem )
            newItem:LaunchLootInitialHeight( false, 0, 250, 0.5, randRadius ) 
        end
    end

    if hero:HasModifier("modifier_elf_spell_armor_wall") and string.match(newBuildingName,"rock") then
        if hero:FindModifierByName("modifier_elf_spell_armor_wall"):GetStackCount() == 1  then
            newBuilding:AddNewModifier(newBuilding, newBuilding, "modifier_wall_spell_armor", {}):SetStackCount(1) 
        elseif hero:FindModifierByName("modifier_elf_spell_armor_wall"):GetStackCount() == 2 then
            newBuilding:AddNewModifier(newBuilding, newBuilding, "modifier_wall_spell_armor", {}):SetStackCount(2) 
        elseif hero:FindModifierByName("modifier_elf_spell_armor_wall"):GetStackCount() == 3 then
            newBuilding:AddNewModifier(newBuilding, newBuilding, "modifier_wall_spell_armor", {}):SetStackCount(3) 
        end
    end
    if hero:HasModifier("modifier_elf_spell_tower_damage") and string.match(newBuildingName,"tower") then
        if hero:FindModifierByName("modifier_elf_spell_tower_damage"):GetStackCount() == 1  then
            newBuilding:AddNewModifier(newBuilding, newBuilding, "modifier_tower_spell_dmg", {}):SetStackCount(1) 
        elseif hero:FindModifierByName("modifier_elf_spell_tower_damage"):GetStackCount() == 2 then
            newBuilding:AddNewModifier(newBuilding, newBuilding, "modifier_tower_spell_dmg", {}):SetStackCount(2) 
        elseif hero:FindModifierByName("modifier_elf_spell_tower_damage"):GetStackCount() == 3 then
            newBuilding:AddNewModifier(newBuilding, newBuilding, "modifier_tower_spell_dmg", {}):SetStackCount(3) 
        end
    end

    if hero:HasModifier("modifier_elf_spell_tower_range") and string.match(newBuildingName,"tower") then
        if hero:FindModifierByName("modifier_elf_spell_tower_range"):GetStackCount() == 1  then
            newBuilding:AddNewModifier(newBuilding, newBuilding, "modifier_tower_spell_range", {}):SetStackCount(1) 
        elseif hero:FindModifierByName("modifier_elf_spell_tower_range"):GetStackCount() == 2 then
            newBuilding:AddNewModifier(newBuilding, newBuilding, "modifier_tower_spell_range", {}):SetStackCount(2) 
        elseif hero:FindModifierByName("modifier_elf_spell_tower_range"):GetStackCount() == 3 then
            newBuilding:AddNewModifier(newBuilding, newBuilding, "modifier_tower_spell_range", {}):SetStackCount(3) 
        end
    end

    Timers:CreateTimer(buildTime,function()
        if newBuilding:IsNull() or not newBuilding:IsAlive() then
            return
        end
        
        newBuilding:RemoveModifierByName("modifier_stunned")
        -- newBuilding:StopAnimation() --Animation stop
        if not string.match(newBuildingName,"troll_hut") and not string.match(newBuildingName,"troll2_hut") and newBuildingName ~= "tower_19" and newBuildingName ~= "tower_19_1" and newBuildingName ~= "tower_19_2" then
            local item = CreateItem("item_building_destroy", nil, nil)
            newBuilding:AddItem(item)
        end
         --[[
        if newBuildingName == "high_true_sight_tower" then
        Timers:CreateTimer(function()
            --if not newBuildingName or newBuildingName:IsNull() then return end
            --if newBuildingName:IsAlive() then
                AddFOWViewer(newBuildingName:GetTeamNumber(), newBuildingName:GetAbsOrigin(), 1600, 0.1,
                false)
            --end
            return 0.1
        end)
        end
        --]]
        
        ModifyCompletedConstructionBuildingCount(hero, newBuildingName, 1)
        UpdateSpells(hero)
        for _, value in ipairs(hero.units) do
            UpdateUpgrades(value)
        end
    end)
end

function ApplyTowerSkin(playerID, towerName, towerEnt)
    local skins = GameRules.SkinTower[playerID]
    if not skins then return end

    -- учитываем спец-кейс tower_15_2
    local skinID = skins[towerName] or (towerName == "tower_15_2" and skins["tower_15_1"])
    local cfg = Wearables.skinConfigs[skinID]
    if not cfg then return end

    -- убираем старые носимые
    wearables:RemoveWearables(towerEnt)

    -- attach или update
    if cfg.attachments then
        for _, mdl in ipairs(cfg.attachments) do
            wearables:AttachWearable(towerEnt, mdl)
        end
    end
    if cfg.updateModel then
        UpdateModel(towerEnt, cfg.updateModel.model, cfg.updateModel.scale)
    end

    -- частицы
    if cfg.particles then
        for _, p in ipairs(cfg.particles) do
            local ent = ParticleManager:CreateParticle(p.path, p.attachType, towerEnt)
            ParticleManager:SetParticleControlEnt(
                ent, p.cp, towerEnt, p.attachType, p.attachName or "", towerEnt:GetAbsOrigin(), true
            )
        end
    end

    -- кастомная логика (1032)
    if cfg.custom then
        cfg.custom(towerEnt)
    end
end