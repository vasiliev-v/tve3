LinkLuaModifier("modifier_lava_damage","lavadamage.lua", LUA_MODIFIER_MOTION_NONE)
function StartTouchDamage( trigger )
    local ent = trigger.activator

    ent:AddNewModifier(ent, self, "modifier_lava_damage", {})
end

function EndTouch( trigger )
    local ent = trigger.activator
    ent:RemoveModifierByName("modifier_lava_damage")
end

-----------------------------------------------------------------------------------------

modifier_lava_damage = modifier_lava_damage or class({})

function modifier_lava_damage:IsHidden()
    return true
end

function modifier_lava_damage:IsPassive()
    return false
end

function modifier_lava_damage:IsPurgable()
    return false
end

function modifier_lava_damage:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink( 0.08 )
end

function modifier_lava_damage:OnIntervalThink()
    if IsServer() then
        local damage_table = {
            victim = self:GetParent(),
            attacker = self:GetParent(),
            ability = self,
            damage = 1,
            damage_type = DAMAGE_TYPE_PURE
        }
        ApplyDamage(damage_table)
    end
end