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
        "particles/units/heroes/hero_omniknight/omniknight_repel.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target
    )
    ParticleManager:ReleaseParticleIndex(fx)
end
