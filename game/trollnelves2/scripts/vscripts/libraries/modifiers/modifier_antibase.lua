modifier_antibase = class({})


function modifier_antibase:CheckState() 
    return { [MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			-- [MODIFIER_STATE_BLIND] = true,
        }
end

function modifier_antibase:IsHidden()
    return false
end

function modifier_antibase:IsPurgable()
    return false
end

function modifier_antibase:IsDebuff()
    return true
end

function modifier_antibase:GetTexture()
    return "build_flag"
end