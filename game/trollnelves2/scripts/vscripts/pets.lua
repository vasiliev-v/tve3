require("donate_store/wearables_data")
Pets = Pets or {
	playerPets = {}
}

-- function Pets:Precache( context )
-- 	print( "Pets precache start" )

-- 	for _, effect in pairs( self.heroEffects ) do
-- 		if effect.resource then
-- 			PrecacheResource( "particle_folder", effect.resource, context )
-- 		end
-- 	end

-- 	for _, p in pairs( self.petsData.particles ) do
-- 		PrecacheResource( "particle", p.particle, context )
-- 	end

-- 	for _, c in pairs( self.petsData.couriers ) do
-- 		PrecacheModel( c.model, context )

-- 		for _, p in pairs( c.particles ) do
-- 			if type( p ) == "string" then
-- 				PrecacheResource( "particle", p, context )
-- 			end
-- 		end
-- 	end

-- 	print( "Pets precache end" )
-- end

function Pets:Init()
	
	-- RegisterCustomEventListener( "cosmetics_select_pet", Dynamic_Wrap( self, "CreatePet" ) )
	-- RegisterCustomEventListener( "cosmetics_remove_pet", Dynamic_Wrap( self, "DeletePet" ) )

	GameRules:GetGameModeEntity():SetContextThink( "pets_think", function()
		self:OnThink()

		return  0.1
	end, 0.4 )
	end

-- local function HidePet( pet, time )
-- 	pet:AddNoDraw()
-- 	pet.isHidden = true
-- 	pet.unhideTime = GameRules:GetDOTATime( false, false ) + time

-- 	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_disguise_smoke_top.vpcf", PATTACH_WORLDORIGIN, nil )
-- 	ParticleManager:SetParticleControl( particle, 0, pet:GetAbsOrigin() )
-- 	ParticleManager:ReleaseParticleIndex( particle )
-- end

-- local function UnhidePet( pet )
-- 	pet:RemoveNoDraw()
-- 	pet.isHidden = false

-- 	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_disguise_smoke_top.vpcf", PATTACH_WORLDORIGIN, nil )
-- 	ParticleManager:SetParticleControl( particle, 0, pet:GetAbsOrigin() )
-- 	ParticleManager:ReleaseParticleIndex( particle )
-- end

function Pets:OnThink()
	for _, pet in pairs( Pets.playerPets ) do
		local owner = pet:GetOwner()
		if not owner then
			return
		end
		local owner_pos = owner:GetAbsOrigin()
		local pet_pos = pet:GetAbsOrigin()
		local distance = ( owner_pos - pet_pos ):Length2D()
		local owner_dir = owner:GetForwardVector()
		local dir = owner_dir * RandomInt( 110, 140 )

		-- if owner:IsInvisible() and not pet:HasModifier( "modifier_cosmetic_pet_invisible" ) then
		-- 	pet:AddNewModifier( pet, nil, "modifier_cosmetic_pet_invisible", {} )
		-- elseif not owner:IsInvisible() and pet:HasModifier( "modifier_cosmetic_pet_invisible" ) then
		-- 	pet:RemoveModifierByName( "modifier_cosmetic_pet_invisible" )
		-- end

		-- local enemy_dis
		-- local near = FindUnitsInRadius(
		-- 	owner:GetTeam(),
		-- 	pet:GetAbsOrigin(),
		-- 	nil,
		-- 	300,
		-- 	DOTA_UNIT_TARGET_TEAM_ENEMY,
		-- 	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		-- 	DOTA_UNIT_TARGET_FLAG_NO_INVIS,
		-- 	FIND_CLOSEST,
		-- 	false
		-- )[1]

		-- if near then
		-- 	enemy_dis = ( near:GetAbsOrigin() - pet_pos ):Length2D()
		-- end

		if distance > 900 then
			-- if not pet.isHidden then
			-- 	HidePet( pet, 0.35 )
			-- end

			local a = RandomInt( 60, 120 )

			if RandomInt( 1, 2 ) == 1 then
				a = a * -1
			end

			local r = RotatePosition( Vector( 0, 0, 0 ), QAngle( 0, a, 0 ), dir )

			pet:SetAbsOrigin( owner_pos + r )
			pet:SetForwardVector( owner_dir )

			FindClearSpaceForUnit( pet, owner_pos + r, true )
		elseif distance > 150 then
			local right = RotatePosition( Vector( 0, 0, 0 ), QAngle( 0, RandomInt( 70, 110 ) * -1, 0 ), dir ) + owner_pos
			local left = RotatePosition( Vector( 0, 0, 0 ), QAngle( 0, RandomInt( 70, 110 ), 0 ), dir ) + owner_pos

			-- if enemy_dis and enemy_dis < 300 and distance < 400 then
			-- 	pet:Stop()
			-- else
				if ( pet_pos - right ):Length2D() > ( pet_pos - left ):Length2D() then
					pet:MoveToPosition( left )
				else
					pet:MoveToPosition( right )
				end
			-- end
		elseif distance < 90 then
			pet:MoveToPosition( owner_pos + ( pet_pos - owner_pos ):Normalized() * RandomInt( 110, 140 ) )
		-- elseif near and ( near:GetAbsOrigin() - pet_pos ):Length2D() < 110 then
		-- 	pet:MoveToPosition( pet_pos + ( pet_pos - near:GetAbsOrigin() ):Normalized() * RandomInt( 100, 150 ) )
		end
		if owner:HasModifier("modifier_generic_invisibility") then
        local invisModifier = owner:FindModifierByName("modifier_generic_invisibility")
		local check = true
        if invisModifier then
            local remainingTime = invisModifier:GetRemainingTime()
            pet:AddNewModifier(pet,nil,"modifier_generic_invisibility",{duration=remainingTime})
        end
		end
		if owner:HasModifier("modifier_invisible") then
        local invisModifier = owner:FindModifierByName("modifier_invisible")
        if invisModifier then
            local remainingTime = invisModifier:GetRemainingTime()
            pet:AddNewModifier(pet,nil,"modifier_invisible",{duration=remainingTime})
        end
		end
	end
end

function Pets.CreatePet(keys, num)
    local id   = keys.PlayerID
    local hero = keys.hero
    local idx  = tonumber(num)
    local cfg  = Wearables.petConfigs[idx]
    if not cfg then return end

    local roll = RandomInt(0, 1)  -- для ветвлений

    -- выбираем модель
    local model = cfg.model
    if cfg.models then
        -- cfg.models — массив из 2 строк
        model = cfg.models[roll + 1]
    end

    -- эффект и группа материала
    local effect = cfg.effect or ""
    local matGrp = cfg.matGrp
               or (cfg.matGrps and cfg.matGrps[roll + 1])
               or "0"

    -- создаём питомца
    local pet = CreateUnitByName(
        "npc_cosmetic_pet",
        hero:GetAbsOrigin() + RandomVector(RandomInt(6000, 8000)),
        true, hero, hero, hero:GetTeam()
    )
    pet:SetForwardVector(hero:GetAbsOrigin())
    pet:AddNewModifier(pet, nil, "modifier_cosmetic_pet", {})

    pet:SetModel(model)
    pet:SetOriginalModel(model)
    pet:SetModelScale(1.1)

    Pets.playerPets[id] = pet
    pet:SetMaterialGroup(matGrp)

    if effect ~= "" then
        ParticleManager:CreateParticle(effect, PATTACH_POINT_FOLLOW, pet)
    end
end


function Pets.DeletePet( keys )
 	local id = keys.PlayerID

 	if not Pets.playerPets[id] then
 		return
	end

 	--HidePet( Pets.playerPets[id].unit, 0 )
	UTIL_Remove(Pets.playerPets[id])
	Pets.playerPets[id] = nil
end