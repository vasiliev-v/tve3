modifier_troll_spell_magic_resist_buff = class({})

function modifier_troll_spell_magic_resist_buff:IsHidden()   return false end
function modifier_troll_spell_magic_resist_buff:IsDebuff()    return false end
function modifier_troll_spell_magic_resist_buff:IsPurgable()  return true  end  -- можно сделать false, если нужно

function modifier_troll_spell_magic_resist_buff:GetEffectName()
    return "particles/items_fx/immunity_sphere.vpcf"
end
function modifier_troll_spell_magic_resist_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_troll_spell_magic_resist_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ABSORB_SPELL, -- сработает на ЮНИТ-таргет способности
    }
end

-- Возвращаем 1, чтобы поглотить заклинание; сразу уничтожаем модификатор
function modifier_troll_spell_magic_resist_buff:GetAbsorbSpell(keys)
    if not IsServer() then return 0 end
    if self._triggered then return 0 end  -- защита от двойного вызова в один тик
    local parent = self:GetParent()

    -- Эффект срабатывания как у Линки
    local pfx = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_POINT_FOLLOW, parent)
    ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), false)
    ParticleManager:ReleaseParticleIndex(pfx)
    parent:EmitSound("DOTA_Item.LinkensSphere.Activate")

    self._triggered = true
    self:Destroy()  -- бафф снят сразу после поглощенияW
    return 1
end
