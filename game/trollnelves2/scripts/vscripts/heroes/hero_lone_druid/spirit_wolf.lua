require('trollnelves2')
LinkLuaModifier("modifier_death_armor_bear",
    "libraries/modifiers/modifier_death_armor_bear",
LUA_MODIFIER_MOTION_NONE)

function SpiritBearSpawn( event )
	local caster = event.caster
	local player = caster:GetPlayerOwnerID()
	local ability = event.ability
	local level = ability:GetLevel()
	
	local origin = Vector(-320,-320,256) + RandomVector(200)
	if string.match(GetMapName(),"clanwars") then
		if caster:GetTeamNumber() == 2 then
			origin = Vector(-472,-628,256)
		else
			origin = Vector(800,-725,256)
		end
	end

	
	local checkWolf = false
	local checkHut = false
	-- Set the unit name, concatenated with the level number
	
	local unit_name = "npc_dota_lycan_wolf1" 
	if level == 2 then
		unit_name = "npc_dota_lycan_wolf2"
	elseif level == 3 then
		unit_name = "npc_dota_lycan_wolf3"
	end

	-- Synergy Level. Checks both the default and the datadriven Synergy
	local synergyAbility = caster:FindAbilityByName("lone_druid_synergy_datadriven")
	if synergyAbility == nil then
		synergyAbility = caster:FindAbilityByName("lone_druid_synergy")
	end
	if caster.bear and IsValidEntity(caster.bear) and not caster.bear:IsAlive() then
		caster.bear:RespawnUnit()
		-- caster.bear:AddNewModifier(caster.bear, nil, "modifier_death_armor_bear", {})
		FindClearSpaceForUnit(caster.bear, origin, true)
		if caster.bear:HasModifier("modifier_bear_synergy") then
			caster.bear:RemoveModifierByName("modifier_bear_synergy")
			synergyAbility:ApplyDataDrivenModifier(caster, caster.bear, "modifier_bear_synergy", nil)
		end
		if ability ~= nil then
			ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_spirit_bear", nil)
		end
		
		-- Apply the synergy buff if the ability exists
		if synergyAbility ~= nil then
			synergyAbility:ApplyDataDrivenModifier(caster, caster.bear, "modifier_bear_synergy", nil)
		end
		return
	end
	
	-- Check if the bear is alive, heals and spawns them near the caster if it is
	if caster.bear and IsValidEntity(caster.bear) and caster.bear:IsAlive() then
		FindClearSpaceForUnit(caster.bear, origin, true)
		caster.bear:SetHealth(caster.bear:GetMaxHealth())
		
		-- Spawn particle
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.bear)	
		
		-- Re-Apply the synergy buff if we found one
		if caster.bear:HasModifier("modifier_bear_synergy") then
			caster.bear:RemoveModifierByName("modifier_bear_synergy")
			synergyAbility:ApplyDataDrivenModifier(caster, caster.bear, "modifier_bear_synergy", nil)
		end
	else
		-- Create the unit and make it controllable
		SpiritCheckWolf( event )
		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:AddNewModifier(caster.bear, nil, "modifier_invulnerable", {duration = 1})
		caster.bear:SetControllableByPlayer(player, true)
		-- Apply the backslash on death modifier
		if ability ~= nil then
			ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_spirit_bear", nil)
		end
		
		-- Apply the synergy buff if the ability exists
		if synergyAbility ~= nil then
			synergyAbility:ApplyDataDrivenModifier(caster, caster.bear, "modifier_bear_synergy", nil)
		end
		InitializeBadHero(caster.bear)
		
		for i=0, caster.bear:GetAbilityCount()-1 do
			local ability = caster.bear:GetAbilityByIndex(i)
			if ability then ability:SetLevel(ability:GetMaxLevel()) end
		end
		-- Learn its abilities: return lvl 2, entangle lvl 3, demolish lvl 4. By Index
	end
end

--[[
	Author: Noya
	Date: 15.01.2015.
	When the skill is leveled up, try to find the casters bear and replace it by a new one on the same place
]]
function SpiritBearLevel( event )
	local caster = event.caster
	local player = caster:GetPlayerOwnerID()
	local ability = event.ability
	local level = ability:GetLevel()

	local unit_name = "npc_dota_lycan_wolf1" 
	if level == 2 then
		unit_name = "npc_dota_lycan_wolf2"
	elseif level == 3 then
		unit_name = "npc_dota_lycan_wolf3"
	end
	
	-- Synergy Level. Checks both the default and the datadriven Synergy
	local synergyAbility = caster:FindAbilityByName("lone_druid_synergy_datadriven")
	if synergyAbility == nil then
		synergyAbility = caster:FindAbilityByName("lone_druid_synergy")
	end
	
	if caster.bear and caster.bear:IsAlive() then 
		-- Remove the old bear in its position
		local origin = caster.bear:GetAbsOrigin()
		caster.bear:RemoveSelf()
		SpiritCheckWolf( event )
		-- Create the unit and make it controllable
		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:AddNewModifier(caster.bear, nil, "modifier_invulnerable", {duration = 3})
		caster.bear:SetControllableByPlayer(player, true)
		-- Apply the backslash on death modifier
		ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_spirit_bear", nil)
		
		-- Apply the synergy buff if the ability exists
		if synergyAbility ~= nil then
			synergyAbility:ApplyDataDrivenModifier(caster, caster.bear, "modifier_bear_synergy", nil)
		end

	end
end

-- Do a percentage of the caster health then the spawned unit takes fatal damage
function SpiritBearDeath( event )
	local caster = event.caster
	local killer = event.attacker
	local ability = event.ability
	local casterHP = caster:GetMaxHealth()
	local backlash_damage = ability:GetLevelSpecialValueFor( "backlash_damage", ability:GetLevel() - 1 ) * 0.01
	local origin = Vector(-320,-320,256) + RandomVector(200)
	-- Calculate and do the damage
	local damage = casterHP * backlash_damage
	
	ApplyDamage({ victim = caster, attacker = killer, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function SpiritCheckWolf( event )
	local caster = event.caster
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) then
			local wolf = PlayerResource:GetSelectedHeroEntity(pID)
			if wolf ~= nil then
				if wolf:IsWolf() then
					DebugPrint("in1")
					trollnelves2:ControlUnitForTroll(wolf)
					return nil
				end
			end
		end
	end
end