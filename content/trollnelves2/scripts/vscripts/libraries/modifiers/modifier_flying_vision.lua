modifier_flying_vision = class({})

function modifier:OnIntervalThink()
    if IsServer() then
        local parent=self:GetParent()
        local range = 370
        AddFOWViewer(parent:GetTeam(),
        parent:GetCenter(),range,think_interval,
        false)
    end
end