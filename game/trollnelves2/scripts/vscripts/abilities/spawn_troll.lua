function OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability

    if not caster or caster:IsNull() then return end
    if not ability or ability:IsNull() then return end

    local playerID = caster:GetMainControllingPlayer()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)

    if not hero or hero:IsNull() then
        hero = caster
    end

    local wardLevel = 1

    local function CheckWardModifier(modifierName)
        if hero:HasModifier(modifierName) then
            local stack = hero:GetModifierStackCount(modifierName, hero)

            if stack and stack > wardLevel then
                wardLevel = stack
            end
        end
    end

    CheckWardModifier("modifier_troll_spell_ward")
    CheckWardModifier("modifier_troll_spell_ward_x4")

    wardLevel = math.max(1, math.min(wardLevel, 3))

    local npcName = "troll_ward_npc_" .. tostring(wardLevel)

    local unit = CreateUnitByName(
        npcName,
        ability:GetCursorPosition(),
        true,
        nil,
        nil,
        hero:GetTeamNumber()
    )

    if not unit or unit:IsNull() then return end

    if event.Name then
        unit:SetModel(event.Name)
        unit:SetOriginalModel(event.Name)
    end

    unit:SetModelScale(tonumber(event.SizeModel) or 1)

    unit:SetOwner(hero)
    unit:SetControllableByPlayer(playerID, true)

    unit:AddNewModifier(unit, nil, "modifier_phased", {})
    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
    unit:AddNewModifier(unit, nil, "modifier_building", {})
    

    local dur = ability:GetSpecialValueFor("duration")
    unit:AddNewModifier(unit, unit, "modifier_kill_time", { duration = dur })
end