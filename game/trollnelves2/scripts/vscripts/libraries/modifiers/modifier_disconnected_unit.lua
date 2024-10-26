modifier_disconnected_unit = class({})


function modifier_disconnected_unit:CheckState() 
    return { [MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_BLIND] = true,
            [MODIFIER_STATE_STUNNED] = true,
        }
end

function modifier_disconnected_unit:IsHidden()
    return false
end

function modifier_disconnected_unit:IsPurgable()
    return true
end