modifier_death_mana = class({})

function modifier_death_mana:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
    }

    return funcs
end

function modifier_death_mana:GetModifierTotalPercentageManaRegen( params )
    self:GetParent():GetDeaths()
    if self:GetParent():GetDeaths() > 3 and self:GetParent():GetDeaths() < 9 then
        return self:GetParent():GetDeaths() * -10
    elseif self:GetParent():GetDeaths() >= 9 then
        return -80
    end
end

function modifier_death_mana:IsHidden()
    return false
end