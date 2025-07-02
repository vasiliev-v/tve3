modifier_death_armor = class({})

function modifier_death_armor:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
    }

    return funcs
end

function modifier_death_armor:CheckState() 
    return { [MODIFIER_STATE_SPECIALLY_DENIABLE] = true }
end


function modifier_death_armor:GetModifierExtraHealthPercentage( params )
    self:GetParent():GetDeaths()
    if self:GetParent():GetDeaths() == 0 or self:GetParent():GetDeaths() == 1 then
        return -50
    elseif self:GetParent():GetDeaths() == 2 then
        return -85
    else
        return -95
    end
end

function modifier_death_armor:IsHidden()
    return false
end

function modifier_death_armor:IsDebuff()
    return true
end

function modifier_death_armor:GetTexture()
    return "build_tower_15"
end