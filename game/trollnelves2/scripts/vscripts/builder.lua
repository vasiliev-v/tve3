require('libraries/util')
require('trollnelves2')
require('stats')
require('wearables')
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

    if string.match(building:GetUnitName(),"troll2_hut") then
        hero = GameRules.trollHero2
        playerID = GameRules.trollID2
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
    local p
    local p12 = nil

    if GameRules.SkinTower[playerID] ~= nil then
        if GameRules.SkinTower[playerID][newBuildingName] == "1001" then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/venomancer/venomancer_hydra_switch_color_arms/venomancer_hydra_switch_color_arms.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/venomancer/venomancer_hydra_switch_color_shoulder/venomancer_hydra_switch_color_shoulder.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/venomancer/venomancer_hydra_switch_color_head/venomancer_hydra_switch_color_head.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/venomancer/venomancer_hydra_switch_color_tail/venomancer_hydra_switch_color_tail.vmdl") 
        elseif GameRules.SkinTower[playerID][newBuildingName] == "1002" then     
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/viper/king_viper_head/king_viper_head.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/viper/king_viper_back/king_viper_back.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/viper/king_viper_tail/viper_king_viper_tail.vmdl")
        elseif GameRules.SkinTower[playerID][newBuildingName] == "1003" then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/drow/drow_ti9_immortal_weapon/drow_ti9_immortal_weapon.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/drow/mask_of_madness/mask_of_madness.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/drow/frostfeather_huntress_shoulder/frostfeather_huntress_shoulder.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/drow/frostfeather_huntress_misc/frostfeather_huntress_misc.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/drow/ti6_immortal_cape/mesh/drow_ti6_immortal_cape.vmdl")        
            wearables:AttachWearable(newBuilding, "models/items/drow/frostfeather_huntress_arms/frostfeather_huntress_arms.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/drow/frostfeather_huntress_legs/frostfeather_huntress_legs.vmdl") 
            p12 = ParticleManager:CreateParticle("particles/econ/items/drow/drow_ti6_gold/drow_ti6_ambient_gold.vpcf", 1, newBuilding)
            ParticleManager:SetParticleControlEnt(p12, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1004" then
            --wearables:RemoveWearables(newBuilding)
            -- wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl")
            --wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl")
            -- wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl")
            --wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_back/ti6_windranger_back.vmdl")
            --wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl")
            --local p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bowstring_ambient.vpcf", 0, newBuilding)
            --ParticleManager:SetParticleControlEnt(p, 0, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
            -- p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bow_ambient.vpcf", 1, newBuilding)
            -- ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
            --p = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_bowstring.vpcf", 3, newBuilding)
            --ParticleManager:SetParticleControlEnt(p, 3, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
            
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_cape.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_quiver.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_shoulder.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_head.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_weapon.vmdl")
            --local p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bowstring_ambient.vpcf", 0, newBuilding)
            --ParticleManager:SetParticleControlEnt(p, 0, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
            --  p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_bow_ambient.vpcf", 1, newBuilding)
            --  ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
            --p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_bowstring_ambient.vpcf", 3, newBuilding)
            --ParticleManager:SetParticleControlEnt(p, 3, newBuilding, PATTACH_POINT_FOLLOW, "attach_hook",  newBuilding:GetAbsOrigin(), true)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1005" then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/ancient_apparition/ancient_apparition_frozen_evil_head/ancient_apparition_frozen_evil_head.vmdl")--"models/items/ancient_apparition/extremely_cold_shackles_tail/extremely_cold_shackles_tail.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/ancient_apparition/ancient_apparition_frozen_evil_arms/ancient_apparition_frozen_evil_arms.vmdl")--"models/items/ancient_apparition/extremely_cold_shackles_shoulder/extremely_cold_shackles_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/ancient_apparition/ancient_apparition_frozen_evil_shoulder/ancient_apparition_frozen_evil_shoulder.vmdl")--"models/items/ancient_apparition/extremely_cold_shackles_head/extremely_cold_shackles_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/ancient_apparition/ancient_apparition_frozen_evil_tail/ancient_apparition_frozen_evil_tail.vmdl")--"models/items/ancient_apparition/extremely_cold_shackles_arms/extremely_cold_shackles_arms.vmdl")    
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1006" then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/vengefulspirit/fallenprincess_head/fallenprincess_head.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/vengefulspirit/fallenprincess_legs/fallenprincess_legs.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/vengefulspirit/fallenprincess_weapon/fallenprincess_weapon.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/vengefulspirit/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder.vmdl")
            
            p = ParticleManager:CreateParticle("particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder_crimson_ambient.vpcf", 1, newBuilding)
            ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1007"  then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/shadow_fiend/arms_deso/arms_deso.vmdl")
            wearables:AttachWearable(newBuilding, "models/heroes/shadow_fiend/head_arcana.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/nevermore/sf_souls_tyrant_shoulder/sf_souls_tyrant_shoulder.vmdl")              
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1008" or (newBuildingName == "tower_15_2" and GameRules.SkinTower[playerID]["tower_15_1"] == "1008") then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/nevermore/ferrum_chiroptera_head/ferrum_chiroptera_head.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/nevermore/ferrum_chiroptera_shoulder/ferrum_chiroptera_shoulder.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/nevermore/ferrum_chiroptera_arms/ferrum_chiroptera_arms.vmdl")
            local p = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/shadow_fiend_ambient_eyes.vpcf", 1, newBuilding)
            ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
            p = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_head_ambient.vpcf", 2, newBuilding)
            ParticleManager:SetParticleControlEnt(p, 2, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
            p = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_shoulder_ambient.vpcf", 3, newBuilding)
            ParticleManager:SetParticleControlEnt(p, 3, newBuilding, PATTACH_POINT_FOLLOW, "attach_hook",  newBuilding:GetAbsOrigin(), true)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1009"  then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/lanaya/raiment_of_the_violet_archives_shoulder/raiment_of_the_violet_archives_shoulder.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/lanaya/raiment_of_the_violet_archives_armor/raiment_of_the_violet_archives_armor.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/lanaya/raiment_of_the_violet_archives_head_hood/raiment_of_the_violet_archives_head_hood.vmdl")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1010"  then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_head/luna_ti7_set_head.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_mount/luna_ti7_set_mount.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_shoulder/luna_ti7_set_shoulder.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_weapon/luna_ti7_set_weapon.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_offhand/luna_ti7_set_offhand.vmdl")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1011"  then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/medusa/dotaplus_medusa_weapon/dotaplus_medusa_weapon.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/medusa/daughters_of_hydrophiinae/daughters_of_hydrophiinae.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_immortal_tail.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/medusa/dotaplas_medusa_head/dotaplas_medusa_head.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/medusa/dotaplus_medusa_arms/dotaplus_medusa_arms.vmdl")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1012" or (newBuildingName == "tower_19_1" and GameRules.SkinTower[playerID]["tower_19"] == "1012") or (newBuildingName == "tower_19_2" and GameRules.SkinTower[playerID]["tower_19"] == "1012")  then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/enigma/tentacular_conqueror_armor/tentacular_conqueror_armor.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/enigma/tentacular_conqueror_arms/tentacular_conqueror_arms.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/enigma/tentacular_conqueror_head/tentacular_conqueror_head.vmdl")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1013" then
            wearables:RemoveWearables(newBuilding)
            wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_shoulder/witch_hunter_set_shoulder.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_arms/witch_hunter_set_arms.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_head/witch_hunter_set_head.vmdl")
            wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_back/witch_hunter_set_back.vmdl")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1014" then
            wearables:RemoveWearables(newBuilding) 
            UpdateModel(newBuilding, "models/items/wards/frozen_formation/frozen_formation.vmdl", 1)    
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1015" then
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/wards/sylph_ward/sylph_ward.vmdl", 1)    
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1016"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/wards/watcher_below_ward/watcher_below_ward.vmdl", 1)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1017"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/wards/megagreevil_ward/megagreevil_ward.vmdl", 1)    
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1018"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/wards/dire_ward_eye/dire_ward_eye.vmdl", 1)   
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1019"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/wards/chinese_ward/chinese_ward.vmdl", 1)  
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1020"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/wards/stonebound_ward/stonebound_ward.vmdl", 1)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1021"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/wards/monty_ward/monty_ward.vmdl", 1)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1022"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/wards/gazing_idol_ward/gazing_idol_ward.vmdl", 1)  
            
            
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1023"  then
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/courier/throe/throe_flying.vmdl", 1)    
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1024"  then
            wearables:RemoveWearables(newBuilding) 
            UpdateModel(newBuilding, "models/items/courier/shagbark/shagbark_flying.vmdl", 1)    
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1025"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/courier/courier_mvp_redkita/courier_mvp_redkita_flying.vmdl", 1)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1026"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/courier/defense4_dire/defense4_dire_flying.vmdl", 1)    
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1027" then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/courier/mlg_wraith_courier/mlg_wraith_courier.vmdl", 1)   
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1028"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/courier/mei_nei_rabbit/mei_nei_rabbit_flying.vmdl", 1)  
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1029"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/courier/mango_the_courier/mango_the_courier_flying.vmdl", 1)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1030"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/courier/blazing_hatchling_the_fortune_bringer_courier/blazing_hatchling_the_fortune_bringer_courier_flying.vmdl", 1)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1031"  then 
            wearables:RemoveWearables(newBuilding)
            UpdateModel(newBuilding, "models/items/courier/bookwyrm/bookwyrm_flying.vmdl", 1)  
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1032"  then
                wearables:RemoveWearables(newBuilding)
                if p12 ~= nil then
                    ParticleManager:DestroyParticle(p12, false)  
                end
                wearables:AttachWearable(newBuilding, "models/items/drow/wandering_ranger_head/wandering_ranger_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/wandering_ranger_back/wandering_ranger_back.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/wandering_ranger_arms/wandering_ranger_arms.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/wandering_ranger_weapon/wandering_ranger_weapon.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/wandering_ranger_shoulder/wandering_ranger_shoulder.vmdl")        
                wearables:AttachWearable(newBuilding, "models/items/drow/wandering_ranger_misc/wandering_ranger_misc.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/wandering_ranger_legs/wandering_ranger_legs.vmdl")
                newBuilding.BountyWeapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/drow/wandering_ranger_weapon/wandering_ranger_weapon.vmdl"})
                newBuilding.BountyWeapon:FollowEntity(newBuilding, true)
                p = ParticleManager:CreateParticle("particles/econ/items/drow/drow_2022_cc/drow_2022_cc_weapon.vpcf", PATTACH_ABSORIGIN_FOLLOW, newBuilding.BountyWeapon)
                ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, nil, newBuilding:GetOrigin(), true) 
                p = ParticleManager:CreateParticle("particles/econ/items/drow/drow_2022_cc/drow_2022_cc_quiver.vpcf", 2, newBuilding)
                ParticleManager:SetParticleControlEnt(p, 2, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true) 
        
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1033"  then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_back/ti6_windranger_back.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl")
                --   newBuilding.BountyWeapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl"})
            --    newBuilding.BountyWeapon:FollowEntity(newBuilding, true)
                --  p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bowstring_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, newBuilding.BountyWeapon)
                --  ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, nil, newBuilding:GetOrigin(), true)
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1034"  then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/hoodwink/hood_2021_blossom_weapon/hood_2021_blossom_weapon.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/hoodwink/hood_2021_blossom_armor/hood_2021_blossom_armor.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/hoodwink/hood_2021_blossom_tail/hood_2021_blossom_tail.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/hoodwink/hood_2021_blossom_back/hood_2021_blossom_back.vmdl")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1035"   then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/clinkz/degraded_soul_hunter_weapon/degraded_soul_hunter_weapon.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/clinkz/degraded_soul_hunter_shoulder/degraded_soul_hunter_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/clinkz/degraded_soul_hunter_head/degraded_soul_hunter_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/clinkz/degraded_soul_hunter_gloves/degraded_soul_hunter_gloves.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/clinkz/degraded_soul_hunter_back/degraded_soul_hunter_back.vmdl")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1036"  then 
                wearables:RemoveWearables(newBuilding)
                UpdateModel(newBuilding, "models/flag_2.vmdl", 0.5)  
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1037"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/arcticwatchtower/arcticwatchtower.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1038"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/atlas_burden_ward/atlas_burden_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1039"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/augurys_guardian/augurys_guardian.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1040"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/chicken_hut_ward/chicken_hut_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1041"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/bane_ward/bane_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1042"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/echo_bat_ward/echo_bat_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1043"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/enchantedvision_ward/enchantedvision_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1044"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/esl_one_jagged_vision/esl_one_jagged_vision.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1045"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/esl_wardchest_radling_ward/esl_wardchest_radling_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1046"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/esl_wardchest_franglerfish/esl_wardchest_franglerfish.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1047"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/esl_wardchest_jungleworm/esl_wardchest_jungleworm.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1048"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/esl_wardchest_toadstool/esl_wardchest_toadstool.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1049"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/eye_of_avernus_ward/eye_of_avernus_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1050"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/ti8_snail_ward/ti8_snail_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1051"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/frostivus_2023_ward/frostivus_2023_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1052"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/jakiro_pyrexae_ward/jakiro_pyrexae_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1053"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/hand_2021_ward/hand_2021_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1054"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/knightstatue_ward/knightstatue_ward.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1055"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/lich_black_pool_watcher/lich_black_pool_watcher.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1056"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/revtel_jester_obs/revtel_jester_obs.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1057"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/the_monkey_sentinel/the_monkey_sentinel.vmdl", 1)
                --building:SetMaterialGroup("1")
            elseif GameRules.SkinTower[playerID][newBuildingName] == "1058"  then 
                wearables:RemoveWearables(newBuilding) 
                UpdateModel(newBuilding, "models/items/wards/warding_guise/warding_guise.vmdl", 1)
                --building:SetMaterialGroup("1")
            end
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

