modifier_boots_2 = class({})

function modifier_boots_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }

    return funcs
end

function modifier_boots_2:GetModifierMoveSpeed_Max( params )
    return 600
end


function modifier_boots_2:IsHidden()
    return false
end

function modifier_boots_2:GetModifierMoveSpeedBonus_Special_Boots()
    return 150
 end 

 function modifier_boots_2:GetTexture()
    return "item_boots_2"
end