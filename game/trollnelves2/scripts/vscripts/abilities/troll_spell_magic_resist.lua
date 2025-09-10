troll_spell_magic_resist = class({})

LinkLuaModifier(
    "modifier_troll_spell_magic_resist_buff",
    "abilities/modifier_troll_spell_magic_resist_buff.lua",
    LUA_MODIFIER_MOTION_NONE
)

function troll_spell_magic_resist:OnSpellStart()
    local caster   = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    caster:AddNewModifier(caster, self, "modifier_troll_spell_magic_resist_buff", { duration = duration })

    caster:EmitSound("DOTA_Item.LinkensSphere.Target")
end
