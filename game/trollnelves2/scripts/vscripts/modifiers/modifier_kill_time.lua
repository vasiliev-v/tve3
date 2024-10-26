modifier_kill_time = class({})

function modifier_kill_time:IsHidden()
    return false
end

 function modifier_kill_time:GetTexture()
    return "cancel"
end

function modifier_kill_time:OnDestroy()
    if IsServer() then
        if self:GetCaster() then
            PlayerResource:RemoveFromSelection(self:GetCaster():GetPlayerOwnerID(), self:GetCaster())
		    BuildingHelper:ClearQueue(self:GetCaster())
            self:GetCaster():Kill(nil, self:GetCaster())
        end
    end
end

function modifier_kill_time:IsDebuff()
    return true
end

function modifier_kill_time:IsPurgable()
    return false
end