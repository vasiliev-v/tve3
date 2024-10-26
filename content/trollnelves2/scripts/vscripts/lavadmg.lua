LinkLuaModifier("modifier_lava_damage_1","lavadmg.lua", LUA_MODIFIER_MOTION_NONE)
function StartTouchDamage( trigger )
    local ent = trigger.activator

    ent:AddNewModifier(ent, self, "modifier_lava_damage_1", {})
end

function EndTouch( trigger )
    local ent = trigger.activator
    ent:RemoveModifierByName("modifier_lava_damage_1")
end

-----------------------------------------------------------------------------------------

modifier_lava_damage_1 = modifier_lava_damage_1 or class({})

function modifier_lava_damage_1:IsHidden()
    return true
end

function modifier_lava_damage_1:IsPassive()
    return false
end

function modifier_lava_damage_1:IsPurgable()
    return false
end

function modifier_lava_damage_1:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink( 0.01 )
end

function modifier_lava_damage_1:OnIntervalThink()
    if IsServer() then
        local damage_table = {
            victim = self:GetParent(),
            attacker = self:GetParent(),
            ability = self,
            damage = 100001,
            damage_type = DAMAGE_TYPE_PURE
        }
        ApplyDamage(damage_table)
    end
end