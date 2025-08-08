troll_spell_invis_x4 = class({})

function troll_spell_invis_x4:OnSpellStart()
    local unit = self:GetCaster()
    local id = unit:GetPlayerID()
    EmitSoundOn("Hero_Clinkz.WindWalk", unit)
    local duration = self:GetSpecialValueFor("duration")
    unit:AddNewModifier(unit, self, "modifier_generic_invisibility", { duration = duration, bonus_movement_speed = 0 })
    unit:AddNewModifier(unit, self, "modifier_invisible_truesight_immune", { duration = duration})
   -- if Pets.playerPets[id] then
 	--	Pets.playerPets[id]:AddNewModifier(Pets.playerPets[id], self, "modifier_invisible", { duration = duration, bonus_movement_speed = bonus_movement_speed })
	--end
end

--[[
    if Pets.playerPets[id] then
 		Pets.playerPets[id]:AddNewModifier(Pets.playerPets[id], self, "modifier_invisible", {})
        Timers:CreateTimer(duration, function() Pets.playerPets[id]:RemoveModifierByName("modifier_invisible") end)   
	end
   ]]