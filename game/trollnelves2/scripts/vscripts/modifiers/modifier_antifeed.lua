require('libraries/notifications')

modifier_antifeed = class({})


function modifier_antifeed:IsHidden() return false end
function modifier_antifeed:IsDebuff() return false end
function modifier_antifeed:GetTexture() return "antifeed" end


function modifier_antifeed:OnCreated(kv)
    if IsServer() then
        self.accumulatedRageDamage = ParticleManager:CreateParticle(
            "particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8_glyph.vpcf",
            PATTACH_WORLDORIGIN,
            self:GetParent()
        )
        ParticleManager:SetParticleControl(self.accumulatedRageDamage, 0, self:GetParent():GetAbsOrigin())

        self.canNotify = true
    end
end


function modifier_antifeed:OnDestroy(kv)
    if IsServer() then
        if self.accumulatedRageDamage then
            ParticleManager:DestroyParticle(self.accumulatedRageDamage, true)
        end
    end
end


function modifier_antifeed:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
    return funcs
end


function modifier_antifeed:OnAttackStart(event)
    if not IsServer() then return end

    local attacker = event.attacker
    local target   = event.target

    if not target or target ~= self:GetParent() then return end
    if not attacker or not attacker:IsHero() then return end

    local pID = attacker:GetPlayerID()
    if not GameRules.scores or not GameRules.scores[pID] then return end

    local trollValue = GameRules.scores[pID].troll
    if trollValue == nil or trollValue == "no" then
        trollValue = 0
    end

    if trollValue < 75 then
        if not self.canNotify then
            return
        end

        self.canNotify = false

        Timers:CreateTimer(5, function()
            if not self or self:IsNull() then return end
            self.canNotify = true
        end)
	self:GetParent():EmitSound("General.ButtonClick")
    Notifications:ClearBottomFromAll()
    Notifications:BottomToAll({
        text = "antifeed_warning",
        style = {color = 'FFFFFFFF'},
        duration = 6
    })
    end
end