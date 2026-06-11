modifier_movespeed_x2 = class({})

function modifier_movespeed_x2:IsHidden()
    return true
end

function modifier_movespeed_x2:IsPurgable()
    return false
end

function modifier_movespeed_x2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }
end

function modifier_movespeed_x2:HasSpeedModifier()
    local parent = self:GetParent()
    return parent:HasModifier("modifier_troll_spell_haste_bonus_ms")
end

function modifier_movespeed_x2:GetModifierMoveSpeed_Max(params)
    if self:HasSpeedModifier() then
        return 800
    end

    return 650
end

function modifier_movespeed_x2:GetModifierMoveSpeed_Limit(params)
    if self:HasSpeedModifier() then
        return 800
    end

    return 650
end

function modifier_movespeed_x2:GetModifierIgnoreMovespeedLimit()
    return 1
end