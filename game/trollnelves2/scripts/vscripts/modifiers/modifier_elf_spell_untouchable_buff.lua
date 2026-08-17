-- Бафф на постройку/юнита. Слушает OnAttackStart — когда враг замахивается по этому юниту,
-- применяет на атакующего дебафф замедления атакспида.
modifier_elf_spell_untouchable_buff = class({})

function modifier_elf_spell_untouchable_buff:IsHidden()     return false end
function modifier_elf_spell_untouchable_buff:IsDebuff()     return false end
function modifier_elf_spell_untouchable_buff:IsPurgable()   return false end
function modifier_elf_spell_untouchable_buff:GetTexture()   return "elf_spell_untouchable" end

function modifier_elf_spell_untouchable_buff:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        local fx = ParticleManager:CreateParticle(
            "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_green.vpcf",
            PATTACH_ABSORIGIN_FOLLOW,
            parent
        )
        -- CP1 — масштаб/радиус частицы (увеличиваем в ~3 раза)
        ParticleManager:SetParticleControl(fx, 1, Vector(300, 300, 300))
        -- CP2 — дополнительный размер для некоторых систем
        ParticleManager:SetParticleControl(fx, 2, Vector(300, 300, 300))
        self.fxBuff = fx
    end
end

function modifier_elf_spell_untouchable_buff:OnDestroy()
    if IsServer() then
        if self.fxBuff then
            -- false = дать партиклу доиграть анимацию затухания
            ParticleManager:DestroyParticle(self.fxBuff, false)
            ParticleManager:ReleaseParticleIndex(self.fxBuff)
            self.fxBuff = nil
        end
    end
end

function modifier_elf_spell_untouchable_buff:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_elf_spell_untouchable_buff:OnAttackStart(event)
    if not IsServer() then return end

    local target   = event.target
    local attacker = event.attacker

    -- только если атакуют именно этого юнита и атакующий — враг
    if not target or target ~= self:GetParent() then return end
    if not attacker or attacker:IsNull() then return end
    if attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

    local ability = self:GetAbility()
    if not ability or ability:IsNull() then return end

    -- длительность дебаффа фиксирована: пока действует анимация замаха (~1с достаточно)
    attacker:AddNewModifier(
        self:GetCaster(),
        ability,
        "modifier_elf_spell_untouchable_slow",
        { duration = 0.8 }
    )
end
