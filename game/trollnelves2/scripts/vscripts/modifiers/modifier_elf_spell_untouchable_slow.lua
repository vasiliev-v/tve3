-- Дебафф на атакующего врага: уменьшает attackspeed пока идёт анимация замаха
modifier_elf_spell_untouchable_slow = class({})

function modifier_elf_spell_untouchable_slow:IsHidden()     return false end
function modifier_elf_spell_untouchable_slow:IsDebuff()     return true end
function modifier_elf_spell_untouchable_slow:IsPurgable()   return false end
function modifier_elf_spell_untouchable_slow:GetTexture()   return "elf_spell_untouchable" end

function modifier_elf_spell_untouchable_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_elf_spell_untouchable_slow:GetModifierAttackSpeedBonus_Constant()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then return 0 end
    -- отрицательное значение = замедление
    return -ability:GetSpecialValueFor("attack_speed_slow")
end
