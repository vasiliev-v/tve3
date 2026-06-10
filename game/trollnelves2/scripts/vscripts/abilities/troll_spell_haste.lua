troll_spell_haste = class({})

LinkLuaModifier("modifier_troll_spell_haste_bonus_ms", "abilities/troll_spell_haste.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_spell_haste_no_limit", "abilities/troll_spell_haste.lua", LUA_MODIFIER_MOTION_NONE)

function troll_spell_haste:GetCooldown(level)
    return self.BaseClass.GetCooldown(self, level)
end

function troll_spell_haste:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    caster:AddNewModifier(caster, self, "modifier_troll_spell_haste_bonus_ms", {
        duration = duration
    })
    caster:AddNewModifier(caster, self, "modifier_troll_spell_haste_no_limit", {
        duration = duration
    })

    caster:EmitSound("Hero_Windrun.Windrun")
end

modifier_troll_spell_haste_bonus_ms = class({})

function modifier_troll_spell_haste_bonus_ms:IsHidden()
    return false
end

function modifier_troll_spell_haste_bonus_ms:IsPurgable()
    return true
end

function modifier_troll_spell_haste_bonus_ms:GetEffectName()
    return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end

function modifier_troll_spell_haste_bonus_ms:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_troll_spell_haste_bonus_ms:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }
end

function modifier_troll_spell_haste_bonus_ms:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_troll_spell_haste_bonus_ms:GetModifierEvasion_Constant()
    return self:GetAbility():GetSpecialValueFor("eva")
end

modifier_troll_spell_haste_no_limit = class({})

function modifier_troll_spell_haste_no_limit:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_troll_spell_haste_no_limit:GetModifierMoveSpeed_Max( params )
    local ms = 700 
    if GameRules.MapSpeed == 2 then
        ms = 800 
    end
    return ms
end

function modifier_troll_spell_haste_no_limit:GetModifierMoveSpeed_Limit( params )
    local ms = 700 
    if GameRules.MapSpeed == 2 then
        ms = 800 
    end
    return ms
end

function modifier_troll_spell_haste_no_limit:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_troll_spell_haste_no_limit:IsHidden()
    return true
end