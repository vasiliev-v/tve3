modifier_hit_wisp = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,

    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_HEALTHBAR_PIPS,
            MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
            MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
            MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
            MODIFIER_EVENT_ON_ATTACKED
        }
    end,

    GetModifierHealthBarPips = function(self)
        return math.ceil((self:GetParent():GetMaxHealth() or 0))
    end,

    GetAbsoluteNoDamageMagical  = function(self) return 1 end,
    GetAbsoluteNoDamagePhysical  = function(self) return 1 end,
    GetAbsoluteNoDamagePure  = function(self) return 1 end,

    OnAttacked              = function(self, event)
        if not IsServer() then return end

        local parent = self:GetParent()

        if parent ~= event.target or not event.attacker then return end

        local newHealth = parent:GetHealth() - 1
        if newHealth > 0 then
            parent:ModifyHealth(newHealth, self, false, 0)
        else
            self.Dead = true
            parent:Kill(nil, event.attacker)
        end
    end,
})