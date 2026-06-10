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

function modifier_movespeed_x2:GetModifierMoveSpeed_Max(params)
    return 550
end

function modifier_movespeed_x2:GetModifierMoveSpeed_Limit(params)
    return 550
end

function modifier_movespeed_x2:GetModifierIgnoreMovespeedLimit()
    return 0
end