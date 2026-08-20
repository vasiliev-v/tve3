LinkLuaModifier("modifier_elf_spell_untouchable_buff", "modifiers/modifier_elf_spell_untouchable_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elf_spell_untouchable_slow", "modifiers/modifier_elf_spell_untouchable_slow", LUA_MODIFIER_MOTION_NONE)

elf_spell_untouchable = class({})

function elf_spell_untouchable:Precache(context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts", context)
    PrecacheResource("particle", "particles/econ/events/fall_major_2015/teleport_start_fallmjr_2015_d.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", context)
end

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

    -- звук применения
    EmitSoundOn("Hero_Enchantress.NaturesAttendantsCast", target)
end

elf_spell_untouchable_x4 = class(elf_spell_untouchable)

