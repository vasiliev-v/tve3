function OnSpellStart(event)
    local caster = event.caster
	local playerID = caster:GetMainControllingPlayer()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
   -- local unit = CreateUnitByName( "winter2023_npc" , event.ability:GetCursorPosition(), true, nil, nil, hero:GetTeamNumber() ) 
    if event.NameModel then
       -- wearables:AttachWearable(hero, "models/props_frostivus/frostivus_party_hat.vmdl" )
    end
    if event.NameEffect then
        p = ParticleManager:CreateParticle("particles/santa_hat.vpcf", 1, hero)
        ParticleManager:SetParticleControlEnt(p, 1, hero, PATTACH_POINT_FOLLOW, "follow_origin", hero:GetAbsOrigin(), true)
        -- particles/econ/events/anniversary_10th/anniversary_10th_hat_ambient_npc_dota_hero_furion_treant.vpcf
    end
   

end