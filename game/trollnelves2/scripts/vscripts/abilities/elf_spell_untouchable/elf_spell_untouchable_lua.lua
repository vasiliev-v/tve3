elf_spell_untouchable = class({})

function elf_spell_untouchable:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if not target or target:IsNull() then return end

    local duration = self:GetSpecialValueFor("duration")

    target:AddNewModifier(
        caster,
        self,
        "modifier_elf_spell_untouchable_buff",
        { duration = duration }
    )

    -- звук и частицы применения
    EmitSoundOn("Hero_Omniknight.Repel", target)
    local fx = ParticleManager:CreateParticle(
        "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_green.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target
    )
    ParticleManager:SetParticleControl(fx, 1, Vector(300, 300, 300))
    ParticleManager:SetParticleControl(fx, 2, Vector(300, 300, 300))
    ParticleManager:ReleaseParticleIndex(fx)
end
