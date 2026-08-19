weave_datadriven = class({})

LinkLuaModifier("modifier_weave_friendly_datadriven", "heroes/hero_dazzle/weave.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_weave_enemy_datadriven",    "heroes/hero_dazzle/weave.lua", LUA_MODIFIER_MOTION_NONE)

function weave_datadriven:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    if not caster or caster:IsNull() then return end

    local point = self:GetCursorPosition()

    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")
    local vision = self:GetSpecialValueFor("vision")
    local vision_duration = self:GetSpecialValueFor("vision_duration")
    local friendly_per_sec = self:GetSpecialValueFor("armor_per_second")
    local enemy_per_sec = self:GetSpecialValueFor("negative_armor_per_second")
    local max_stacks = self:GetSpecialValueFor("max_stacks")
    if max_stacks <= 0 then max_stacks = 20 end

    if caster:HasScepter() then
        radius = self:GetSpecialValueFor("radius_scepter")
        duration = self:GetSpecialValueFor("duration_scepter")
        friendly_per_sec = self:GetSpecialValueFor("armor_per_second_scepter")
    end

    EmitSoundOn("Hero_Dazzle.Weave", caster)

    local p = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_weave.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(p, 0, point)
    ParticleManager:SetParticleControl(p, 1, Vector(radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(p)

    AddFOWViewer(caster:GetTeamNumber(), point, vision, vision_duration, true)

    local modifier_data_friendly = {
        duration = duration,
        armor_per_sec = friendly_per_sec,
        max_stacks = max_stacks
    }

    local modifier_data_enemy = {
        duration = duration,
        armor_per_sec = enemy_per_sec,
        max_stacks = max_stacks
    }

    local allies = FindUnitsInRadius(
        caster:GetTeamNumber(), point, nil, radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false
    )
    for _, unit in pairs(allies) do
        if unit and not unit:IsNull() and unit:IsAlive() then
            unit:AddNewModifier(caster, self, "modifier_weave_friendly_datadriven", modifier_data_friendly)
        end
    end

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), point, nil, radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false
    )
    for _, unit in pairs(enemies) do
        if unit and not unit:IsNull() and unit:IsAlive() then
            unit:AddNewModifier(caster, self, "modifier_weave_enemy_datadriven", modifier_data_enemy)
        end
    end
end

--------------------------------------------------------------------------------
-- Friendly Modifier
--------------------------------------------------------------------------------
modifier_weave_friendly_datadriven = class({})

function modifier_weave_friendly_datadriven:IsPurgable() return true end
function modifier_weave_friendly_datadriven:IsDebuff() return false end
function modifier_weave_friendly_datadriven:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_weave_friendly_datadriven:OnCreated(kv)
    local ability = self:GetAbility()
    self.per_sec = (kv and kv.armor_per_sec) and tonumber(kv.armor_per_sec) or (ability and ability:GetSpecialValueFor("armor_per_second")) or 0
    self.max_stacks = (kv and kv.max_stacks) and tonumber(kv.max_stacks) or (ability and ability:GetSpecialValueFor("max_stacks")) or 20
    self.tick = (ability and ability:GetSpecialValueFor("tick_interval")) or 1.0

    if IsServer() then
        self:SetStackCount(0)
        local parent = self:GetParent()
        if parent and not parent:IsNull() then
            self.p = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
            ParticleManager:SetParticleControlEnt(self.p, 1, parent, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", parent:GetAbsOrigin(), true)
        end
        self:StartIntervalThink(self.tick)
    end
end

function modifier_weave_friendly_datadriven:OnRefresh(kv)
    local ability = self:GetAbility()
    self.per_sec = (kv and kv.armor_per_sec) and tonumber(kv.armor_per_sec) or (ability and ability:GetSpecialValueFor("armor_per_second")) or self.per_sec or 0
    self.max_stacks = (kv and kv.max_stacks) and tonumber(kv.max_stacks) or (ability and ability:GetSpecialValueFor("max_stacks")) or self.max_stacks or 20
    self.tick = (ability and ability:GetSpecialValueFor("tick_interval")) or self.tick or 1.0

    if IsServer() then
        if self:GetStackCount() < self.max_stacks then
            self:StartIntervalThink(self.tick)
        end
    end
end

function modifier_weave_friendly_datadriven:OnIntervalThink()
    if not IsServer() then return end
    
    local current_stacks = self:GetStackCount()
    if current_stacks < self.max_stacks then
        local next_stack = current_stacks + 1
        self:SetStackCount(next_stack)
        
        -- Остановка таймера при достижении 20 стаков (модификатор продолжает висеть до конца duration)
        if next_stack >= self.max_stacks then
            self:StartIntervalThink(-1)
        end
    else
        self:StartIntervalThink(-1)
    end
end

function modifier_weave_friendly_datadriven:OnDestroy()
    if IsServer() and self.p then
        ParticleManager:DestroyParticle(self.p, false)
        ParticleManager:ReleaseParticleIndex(self.p)
        self.p = nil
    end
end

function modifier_weave_friendly_datadriven:DeclareFunctions()
    return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_weave_friendly_datadriven:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * (self.per_sec or 0)
end

--------------------------------------------------------------------------------
-- Enemy Modifier
--------------------------------------------------------------------------------
modifier_weave_enemy_datadriven = class({})

function modifier_weave_enemy_datadriven:IsPurgable() return true end
function modifier_weave_enemy_datadriven:IsDebuff() return true end
function modifier_weave_enemy_datadriven:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_weave_enemy_datadriven:OnCreated(kv)
    local ability = self:GetAbility()
    self.per_sec = (kv and kv.armor_per_sec) and tonumber(kv.armor_per_sec) or (ability and ability:GetSpecialValueFor("negative_armor_per_second")) or 0
    self.max_stacks = (kv and kv.max_stacks) and tonumber(kv.max_stacks) or (ability and ability:GetSpecialValueFor("max_stacks")) or 20
    self.tick = (ability and ability:GetSpecialValueFor("tick_interval")) or 1.0

    if IsServer() then
        self:SetStackCount(0)
        local parent = self:GetParent()
        if parent and not parent:IsNull() then
            self.p = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
            ParticleManager:SetParticleControlEnt(self.p, 1, parent, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", parent:GetAbsOrigin(), true)
        end
        self:StartIntervalThink(self.tick)
    end
end

function modifier_weave_enemy_datadriven:OnRefresh(kv)
    local ability = self:GetAbility()
    self.per_sec = (kv and kv.armor_per_sec) and tonumber(kv.armor_per_sec) or (ability and ability:GetSpecialValueFor("negative_armor_per_second")) or self.per_sec or 0
    self.max_stacks = (kv and kv.max_stacks) and tonumber(kv.max_stacks) or (ability and ability:GetSpecialValueFor("max_stacks")) or self.max_stacks or 20
    self.tick = (ability and ability:GetSpecialValueFor("tick_interval")) or self.tick or 1.0

    if IsServer() then
        if self:GetStackCount() < self.max_stacks then
            self:StartIntervalThink(self.tick)
        end
    end
end

function modifier_weave_enemy_datadriven:OnIntervalThink()
    if not IsServer() then return end

    local current_stacks = self:GetStackCount()
    if current_stacks < self.max_stacks then
        local next_stack = current_stacks + 1
        self:SetStackCount(next_stack)

        -- Остановка таймера при достижении 20 стаков
        if next_stack >= self.max_stacks then
            self:StartIntervalThink(-1)
        end
    else
        self:StartIntervalThink(-1)
    end
end

function modifier_weave_enemy_datadriven:OnDestroy()
    if IsServer() and self.p then
        ParticleManager:DestroyParticle(self.p, false)
        ParticleManager:ReleaseParticleIndex(self.p)
        self.p = nil
    end
end

function modifier_weave_enemy_datadriven:DeclareFunctions()
    return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_weave_enemy_datadriven:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * (self.per_sec or 0)
end