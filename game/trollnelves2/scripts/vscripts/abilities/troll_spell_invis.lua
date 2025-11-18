troll_spell_invis = class({})

function troll_spell_invis:OnSpellStart()
    local unit = self:GetCaster()
    local id = unit:GetPlayerID()
    EmitSoundOn("Hero_Clinkz.WindWalk", unit)
    local duration = self:GetSpecialValueFor("duration")
    unit:AddNewModifier(unit, self, "modifier_generic_invisibility", { duration = duration, bonus_movement_speed = 0 })
    local elapsed = 0
    Timers:CreateTimer(function()
        if not unit or unit:IsNull() or not unit:IsAlive() then return nil end
        if elapsed >= duration then return nil end

        if unit:IsRooted() then
            elapsed = elapsed + 0.1
            return 0.1
        end

        unit:AddNewModifier(unit, self, "modifier_invisible_truesight_immune", { duration = duration - elapsed })
        return nil
    end)
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