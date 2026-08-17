-- Бафф на постройку/юнита. Слушает OnAttackStart — когда враг замахивается по этому юниту,
-- применяет на атакующего дебафф замедления атакспида.
modifier_elf_spell_untouachble_buff = class({})

function modifier_elf_spell_untouachble_buff:IsHidden()     return false end
function modifier_elf_spell_untouachble_buff:IsDebuff()     return false end
function modifier_elf_spell_untouachble_buff:IsPurgable()   return false end
function modifier_elf_spell_untouachble_buff:GetTexture()   return "elf_spell_untouachble" end

function modifier_elf_spell_untouachble_buff:OnCreated(kv)
    if IsServer() then
        local fx = ParticleManager:CreateParticle(
            "particles/units/heroes/hero_omniknight/omniknight_repel.vpcf",
            PATTACH_ABSORIGIN_FOLLOW,
            self:GetParent()
        )
        self.fxBuff = fx
    end
end

function modifier_elf_spell_untouachble_buff:OnDestroy()
    if IsServer() then
        if self.fxBuff then
            ParticleManager:DestroyParticle(self.fxBuff, false)
            self.fxBuff = nil
        end
    end
end

function modifier_elf_spell_untouachble_buff:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_elf_spell_untouachble_buff:OnAttackStart(event)
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
        "modifier_elf_spell_untouachble_slow",
        { duration = 0.8 }
    )
end
