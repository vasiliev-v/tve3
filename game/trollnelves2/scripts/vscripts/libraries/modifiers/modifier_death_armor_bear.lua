modifier_death_armor_bear = class({})

function modifier_death_armor_bear:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
    }

    return funcs
end

function modifier_death_armor_bear:GetModifierExtraHealthPercentage( params )
    return -50
end

function modifier_death_armor_bear:IsHidden()
    return false
end

function modifier_death_armor_bear:IsDebuff()
    return true
end

function modifier_death_armor_bear:GetTexture()
    return "build_tower_15"
end