game_spells_lib = class({})

local AspectsConfig = require("aspects/aspects_config")
game_spells_lib.aspects_config = AspectsConfig
game_spells_lib.spells_list = AspectsConfig:GetSpellList()

CustomNetTables:SetTableValue("game_spells_lib", "aspects_config", AspectsConfig:GetSerializableConfig(game_spells_lib.spells_list))

-- Я пока хуй знает как тебе это переписать, но лучше я сделаю все напримере такого массива, а ты поправишь потом
game_spells_lib.PLAYER_INFO =
{
    [0] = 
    {
        spell_buying = {}, -- Будет хранение {"название", уровень}
        coins = 0,
    },
}

game_spells_lib.current_activated_spell = {}
game_spells_lib.spells_cost_random = 500
game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE = 1
if GameRules:IsCheatMode() and not GameRules.isTesting then
    game_spells_lib.spells_cost_random = -2
    --game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE = 999 -- в минутах до скольки можно поставить навык
     
    --for idx, spell in ipairs(game_spells_lib.spells_list) do
    --    spell[8] = {0, -3, -4}
    --end

end


CustomNetTables:SetTableValue("game_spells_lib", "spell_list", game_spells_lib.spells_list)
CustomNetTables:SetTableValue("game_spells_lib", "spell_cost", {cost = game_spells_lib.spells_cost_random})
CustomNetTables:SetTableValue("game_spells_lib", "spell_active", game_spells_lib.current_activated_spell)

-- ТЕСТОВАЯ ТАБЛИЦА ДАННЫХ ИГРОКА
--CustomNetTables:SetTableValue("game_spells_lib", tostring(0), game_spells_lib.PLAYER_INFO[0])

function game_spells_lib:event_set_activate_spell(data)
    if GetMapName() == "1x1" then
        return
    end
    if data.PlayerID == nil then return end
    local player_id = data.PlayerID
    local hero = PlayerResource:GetSelectedHeroEntity(player_id)
    
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        if hero == nil then return end
    end

    local modifier_name = data.modifier_name
    local spell_name = data.spell_name
    local player_team = PlayerResource:GetTeam(player_id)
    -- Проверка, есть ли навык у игрока вообще
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    local havePerk = false
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        if spell_name == game_spells_lib.PLAYER_INFO[player_id][tostring(i)][tostring(1)] then
            havePerk = true
            break
        end
    end
    if not havePerk then return end

    -- Проверки на сторону и активность перка
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        for _, spell_history in pairs(game_spells_lib.spells_list) do
            if spell_history[1] == spell_name then
                if tonumber(spell_history[6]) == 0 and player_team ~= 2 and not hero:IsElf() then return end
                if tonumber(spell_history[6]) == 1 and player_team ~= 3 and not hero:IsTroll() then return end
                if tonumber(spell_history[7]) ~= 1 then return end
            end
        end
    end

    -- Создание таблицы, если нет
    if game_spells_lib.current_activated_spell[player_id] == nil then
        game_spells_lib.current_activated_spell[player_id] = {}
    end

    -- Проверка времени
    --if (GameRules:GetGameTime() / 60) >= game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE then
    --    return
    --end
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP and not GameRules:IsCheatMode() then
        SendErrorMessage(player_id, "error_cant_take_aspect")
        return
    end
    local was_solo_before = game_spells_lib:HasSoloPerk(player_id)
    local is_solo_now = (spell_name == "elf_spell_solo_player")

    -- Если уже активен, то снимаем
    if game_spells_lib:FindCurrentSpellPlayer(player_id, spell_name) then
        game_spells_lib:RemovePlayerSpell(player_id, spell_name, modifier_name, hero)
    else
        -- Определяем лимит
        local max_allowed = 1
        if was_solo_before or is_solo_now or player_team == 3 or GameRules:IsCheatMode() then
            max_allowed = 3
        end

        -- Удаляем старый, если превышает лимит
        if #game_spells_lib.current_activated_spell[player_id] >= max_allowed then
            game_spells_lib:RemoveOldSpell(player_id, hero)
        end

        -- Добавляем новый
        game_spells_lib:AddPlayerSpell(player_id, spell_name, modifier_name, hero)
    end

    -- Обновляем отображение
    local result = {}
    for pid, list in pairs(game_spells_lib.current_activated_spell) do
        result[tostring(pid)] = {}
        for i = 1, #list do
            result[tostring(pid)][tostring(i)] = list[i]
        end
    end
    CustomNetTables:SetTableValue("game_spells_lib", "spell_active", result)
end


function game_spells_lib:GetSpellLevel(player_id, spell_name)
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        if spell_name == game_spells_lib.PLAYER_INFO[player_id][tostring(i)][tostring(1)] then
            return tonumber(game_spells_lib.PLAYER_INFO[player_id][tostring(i)][tostring(2)])
        end
    end
    return 0
end

function GetTableLng(tbl)
    local getN = 0
    for n in pairs(tbl) do 
      getN = getN + 1 
    end
    return getN
  end

function game_spells_lib:FindCurrentSpellPlayer(id, spell_name)
    if game_spells_lib.current_activated_spell[id] == nil then
        game_spells_lib.current_activated_spell[id] = {}
    end
    for _, spell in pairs(game_spells_lib.current_activated_spell[id]) do
        if spell == spell_name then
            return true
        end
    end
    return false
end

function game_spells_lib:RemovePlayerSpell(id, spell_name, modifier_name, hero)
    if game_spells_lib.current_activated_spell[id] == nil then
        game_spells_lib.current_activated_spell[id] = {}
    end

    local was_solo = false
    -- удаляем сам спелл
    for i = #game_spells_lib.current_activated_spell[id], 1, -1 do
        if game_spells_lib.current_activated_spell[id][i] == spell_name then
            table.remove(game_spells_lib.current_activated_spell[id], i)
            if spell_name == "elf_spell_solo_player" then
                was_solo = true
            end
            if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
                hero:RemoveModifierByName(modifier_name)
            end
            break
        end
    end

    -- если это solo и игрок не на BADGUYS (тролях), то оставляем только один последний перк
    local player_team = PlayerResource:GetTeam(id)
    if was_solo and player_team ~= DOTA_TEAM_BADGUYS then
        local last = game_spells_lib.current_activated_spell[id][#game_spells_lib.current_activated_spell[id]]
        game_spells_lib.current_activated_spell[id] = {}
        if last ~= nil then
            table.insert(game_spells_lib.current_activated_spell[id], last)
        end
    end
end


function game_spells_lib:AddPlayerSpell(id, spell_name, modifier_name, hero)
    if game_spells_lib.current_activated_spell[id] == nil then
        game_spells_lib.current_activated_spell[id] = {}
    end
    table.insert(game_spells_lib.current_activated_spell[id], spell_name)
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then return end
    local spell_mod = hero:AddNewModifier(hero, nil, modifier_name, {}):SetStackCount(game_spells_lib:GetSpellLevel(id, spell_name))
    if spell_mod then
        spell_mod:SetStackCount(game_spells_lib:GetSpellLevel(id, spell_name))
    end
end

function game_spells_lib:RemoveOldSpell(id, hero)
    if game_spells_lib.current_activated_spell[id] == nil then
        game_spells_lib.current_activated_spell[id] = {}
    end
    if game_spells_lib.current_activated_spell[id][1] ~= nil then
        local spell_name = table.remove(game_spells_lib.current_activated_spell[id], 1)
        if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then return end
        local modifier_name = game_spells_lib:FindModifierFromSpellName(spell_name)
        hero:RemoveModifierByName(modifier_name)
    end
end

function game_spells_lib:FindModifierFromSpellName(spell_name)
    for _, list in pairs(game_spells_lib.spells_list) do
        if list[1] == spell_name then
            return list[3]
        end
    end
    return nil
end

-- remove buy random aspect
--[[
function game_spells_lib:event_buy_spell(data)
    if data.PlayerID == nil then return end
    local player_id = data.PlayerID
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    if game_spells_lib.PLAYER_INFO[player_id] == nil then
        return
    end
    local player = PlayerResource:GetPlayer( player_id )
    if player == nil then return end
    if data.idPerk ~= 0 and data.idPerk ~= 1 then
        return
    end
    local coint = CustomNetTables:GetTableValue("Shop", tostring(player_id))["0"]["1"]
    -- Минус деньги
    local cost = game_spells_lib.spells_cost_random
    if tonumber(coint) < cost then
        -- Ошибка, на всякий случай, но я энивей отключаю кнопку покупки (для арбузеров ебаных)
        print("Нет денег")
        return
    end
    local find_new_spell = game_spells_lib:FindNewSpell(player_id, data.idPerk) -- Находим случайный навык, которго нет у игрока, если таких нет то дальше будем искать на апгрейд
    local drop_info
    if find_new_spell then
        drop_info = game_spells_lib:PlayerDropNewSpell(find_new_spell, player_id)
        CustomGameEventManager:Send_ServerToPlayer( player, 'event_spell_shop_drop', {spell_name = find_new_spell} )
    else
        drop_info = game_spells_lib:PlayerUpgradeSpell(player_id, data.idPerk)
        if drop_info ~= nil and (drop_info[2] > 0 and drop_info[2] < 4) then
            CustomGameEventManager:Send_ServerToPlayer( player, 'event_spell_shop_drop', {spell_name = drop_info[1], upgrade = drop_info[2]} )
        end
    end

    if drop_info ~= nil and drop_info[2] < 4 and drop_info[2] > 0 then
        local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(player_id))
        local dataShop = {}
        if drop_info[4] == nil then
            PoolTable["12"][tostring(GetTableLng(PoolTable["12"]))] = drop_info
        elseif drop_info[2] > 0 and drop_info[2] < 4 then
            PoolTable["12"][tostring(drop_info[4])] = drop_info
        end
        CustomNetTables:SetTableValue("Shop", tostring(player_id), PoolTable)
        game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))[12]
        if not GameRules:IsCheatMode()  then
            dataShop.SteamID = tostring(PlayerResource:GetSteamID(player_id))
            dataShop.Num = tostring(drop_info[1])
            dataShop.Score = tostring(drop_info[2])
            dataShop.Nick = "skill"
            dataShop.Coint = tostring(cost)
            dataShop.TypeDonate = "gem"
            dataShop.PlayerID = player_id
            Shop.GetSkill(dataShop, callback)
        end
        game_spells_lib:UpdatePlayerSpellCosts(player_id)
    end

end
]]

function game_spells_lib:PlayerDropNewSpell(find_new_spell, player_id)
    if game_spells_lib.PLAYER_INFO[player_id] == nil then
        return
    end
    local drop_info = 
    {
        find_new_spell, 1, nil, nil
    }
    CustomNetTables:SetTableValue("game_spells_lib", tostring(player_id), game_spells_lib.PLAYER_INFO[player_id])
    return drop_info
end

function game_spells_lib:PlayerUpgradeSpell(player_id, idPerk)
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    if game_spells_lib.PLAYER_INFO[player_id] == nil then
        return
    end
    
    local upgrade_info = {}
    local find_random_to_upgrade = {}
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        --DebugPrintTable(game_spells_lib.PLAYER_INFO[player_id][tostring(i)])
        --DebugPrint(game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"])
        if tonumber(game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"]) < 2 then
            for _, spell_history in pairs(game_spells_lib.spells_list) do
                if spell_history[1] == game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] and tonumber(spell_history[6]) == idPerk then
                    table.insert(find_random_to_upgrade, game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"])
                end
            end
        end
    end
    --DebugPrintTable(find_random_to_upgrade)
    if #find_random_to_upgrade <= 0 then
        for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
            if tonumber(game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"]) < 3 then
                for _, spell_history in pairs(game_spells_lib.spells_list) do
                    if spell_history[1] == game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] and tonumber(spell_history[6]) == idPerk then
                        table.insert(find_random_to_upgrade, game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"])
                    end
                end
            end
        end
    end
    --Рандом выбор 
    --local random_upgrade = find_random_to_upgrade[RandomInt(1, #find_random_to_upgrade)]

    --Первый найденный 
    local random_upgrade = find_random_to_upgrade[1]
    if random_upgrade then
        for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
            if game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] == random_upgrade then
                game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"] = tonumber(game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"])  + 1
                table.insert(upgrade_info, game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"])
                table.insert(upgrade_info, game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"])
                table.insert(upgrade_info, 0)
                table.insert(upgrade_info, i)
                break
            end
        end
        CustomNetTables:SetTableValue("game_spells_lib", tostring(player_id), game_spells_lib.PLAYER_INFO[player_id])
        return upgrade_info
    end
end

function game_spells_lib:FindNewSpell(player_id, idPerk)
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    if game_spells_lib.PLAYER_INFO[player_id] == nil then
        return
    end
    local random_spells = {}
    for _, spell_history in pairs(game_spells_lib.spells_list) do
        if tonumber(spell_history[6]) == idPerk then
            table.insert(random_spells, spell_history)
        end
    end
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        for y=#random_spells, 1, -1 do
            if random_spells[y][1] == game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] then
                table.remove(random_spells, y)
            end
        end
    end
    if #random_spells > 0 then
      --Выбор первого скилла. 
      return random_spells[1][1]

      --Рандом выбор. 
      --return random_spells[RandomInt(1, #random_spells)][1]
    end
    return nil
end


function game_spells_lib:GetSpellCost(player_id, spell_name, level)
    local player_data = CustomNetTables:GetTableValue("Shop", tostring(player_id))
    if not player_data or not player_data["12"] then return 0 end

    game_spells_lib.PLAYER_INFO[player_id] = player_data["12"]
    local player_spells = game_spells_lib.PLAYER_INFO[player_id]
    if not player_spells then return 0 end

    local discount_to_2 = game_spells_lib.aspects_config:GetDiscountForLevel(2)
    local discount_to_3 = game_spells_lib.aspects_config:GetDiscountForLevel(3)

    local target_index = nil
    local target_side = nil
    for idx, def in ipairs(game_spells_lib.spells_list) do
        if def[1] == spell_name then
            target_index = idx
            target_side = tostring(def[6])
            break
        end
    end

    if not target_index or not target_side then return 0 end

    local current_level = 0
    for i = 1, GetTableLng(player_spells) - 1 do
        local spell = player_spells[tostring(i)]
        if spell["1"] == spell_name then
            current_level = tonumber(spell["2"]) or 0
            break
        end
    end

    local target_level = level or (current_level + 1)
    if target_level > game_spells_lib.aspects_config.DEFAULT_MAX_LEVEL then return 0 end

    local cost = 0

    if target_level == 2 then
        for i = 1, target_index - 1 do
            local def = game_spells_lib.spells_list[i]
            if tostring(def[6]) == target_side then
                local aspect_name = def[1]
                local aspect_level = 0

                for j = 1, GetTableLng(player_spells) - 1 do
                    local spell = player_spells[tostring(j)]
                    if spell["1"] == aspect_name then
                        aspect_level = tonumber(spell["2"]) or 0
                        break
                    end
                end

                if aspect_level < 2 then
                    cost = cost + game_spells_lib.aspects_config:GetCostStep()
                end
            end
        end

        cost = cost * (1 - discount_to_2)

    elseif target_level == 3 then
        -- Все аспекты, не прокачанные до 2
        for _, def in ipairs(game_spells_lib.spells_list) do
            if tostring(def[6]) == target_side then
                local aspect_name = def[1]
                local aspect_level = 0

                for j = 1, GetTableLng(player_spells) - 1 do
                    local spell = player_spells[tostring(j)]
                    if spell["1"] == aspect_name then
                        aspect_level = tonumber(spell["2"]) or 0
                        break
                    end
                end

                if aspect_level < 2 then
                    cost = cost + game_spells_lib.aspects_config:GetCostStep()
                end
            end
        end

        -- Все ДО текущего, не прокачанные до 3
        for i = 1, target_index - 1 do
            local def = game_spells_lib.spells_list[i]
            if tostring(def[6]) == target_side then
                local aspect_name = def[1]
                local aspect_level = 0

                for j = 1, GetTableLng(player_spells) - 1 do
                    local spell = player_spells[tostring(j)]
                    if spell["1"] == aspect_name then
                        aspect_level = tonumber(spell["2"]) or 0
                        break
                    end
                end

                if aspect_level < game_spells_lib.aspects_config.DEFAULT_MAX_LEVEL then
                    cost = cost + game_spells_lib.aspects_config:GetCostStep()
                end
            end
        end

        cost = cost * (1 - discount_to_3)
    end
    if GameRules:IsCheatMode() and not GameRules.isTesting then
       return -2 
    end

    return math.max(game_spells_lib.aspects_config:GetCostStep(), math.floor(cost + 0.5)) -- округление до целого
end

function game_spells_lib:UpdatePlayerSpellCosts(player_id)
    local shop = CustomNetTables:GetTableValue("Shop", tostring(player_id))
    if not shop then return end
    local spells = shop["12"]
    if not spells then return end

    GameRules.PoolTable[18][player_id] = GameRules.PoolTable[18][player_id] or {}
    local cost_table = GameRules.PoolTable[18][player_id]

    cost_table["0"] = cost_table["0"] or {}
    cost_table["1"] = cost_table["1"] or {}

    for i = 1, GetTableLng(spells) - 1 do
        local info = spells[tostring(i)]
        if info then
            local level = tonumber(info["2"]) or 0
            local cost = self:GetSpellCost(player_id, info["1"], level + 1)
            local side = tostring(game_spells_lib.spells_list[i] and game_spells_lib.spells_list[i][6] or "0")
            cost_table[side][tostring(i)] = cost
        end
    end

    shop["18"] = cost_table
    CustomNetTables:SetTableValue("Shop", tostring(player_id), shop)
end

function game_spells_lib:PlayerUpgradeSpellSelected(player_id, spell_name)
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    if game_spells_lib.PLAYER_INFO[player_id] == nil then return nil end
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        local info = game_spells_lib.PLAYER_INFO[player_id][tostring(i)]
        if info["1"] == spell_name then
            local current = tonumber(info["2"])
            if current >= game_spells_lib.aspects_config.DEFAULT_MAX_LEVEL then return nil end
            info["2"] = current + 1
            local result = {spell_name, info["2"], 0, i}
            CustomNetTables:SetTableValue("game_spells_lib", tostring(player_id), game_spells_lib.PLAYER_INFO[player_id])
            return result
        end
    end
    return nil
end

function game_spells_lib:event_upgrade_spell(data)
    if not data.PlayerID or not data.spell_name then return end
    local player_id = data.PlayerID
    local spell_name = data.spell_name
    local player = PlayerResource:GetPlayer( player_id )
    local level = game_spells_lib:GetSpellLevel(player_id, spell_name)
    if level >= game_spells_lib.aspects_config.DEFAULT_MAX_LEVEL then return end
  
    local cost = game_spells_lib:GetSpellCost(player_id, spell_name, level + 1)
    local coins = tonumber(CustomNetTables:GetTableValue("Shop", tostring(player_id))["0"]["1"])
   
    local upgrade_info = game_spells_lib:PlayerUpgradeSpellSelected(player_id, spell_name)
    local coint = CustomNetTables:GetTableValue("Shop", tostring(player_id))["0"]["1"]

    if upgrade_info then
        if not GameRules:IsCheatMode() and tonumber(coint) < cost then
            print("Нет денег")
            return
        end
        local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(player_id))
        PoolTable["12"][tostring(upgrade_info[4])] = upgrade_info
        CustomNetTables:SetTableValue("Shop", tostring(player_id), PoolTable)
        game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))[12]
        local dataShop = {
            SteamID = tostring(PlayerResource:GetSteamID(player_id)),
            Num = tostring(upgrade_info[1]),
            Score = tostring(upgrade_info[2]),
            Nick = "skill_upgrade",
            Coint = tostring(cost),
            TypeDonate = "gem",
            PlayerID = player_id,
        }
        CustomGameEventManager:Send_ServerToPlayer( player, 'event_spell_shop_drop', {spell_name = spell_name, upgrade = level + 1} )
        if not GameRules:IsCheatMode() then
            Shop.GetSkill(dataShop, callback)
        end
        game_spells_lib:UpdatePlayerSpellCosts(player_id)
    end
end


function game_spells_lib:SetSpellPlayers(id)
    if string.match(GetMapName(),"1x1") then
        return
    end
     
    local team = PlayerResource:GetTeam(id)
    local active = game_spells_lib.current_activated_spell[id] or {}
    local team = PlayerResource:GetTeam(id)

    local hero = PlayerResource:GetSelectedHeroEntity(id)
    if not hero then
        Timers:CreateTimer(4, function()
            game_spells_lib:SetSpellPlayers(id)
        end)
		return
	end
    -- Удаляем все перки, которые не соответствуют команде, расе или выключены
    if hero then
    -- Проходим по всем выбранным перкам игрока
        for i = #active, 1, -1 do
            local spell_name = active[i]

            -- Ищем информацию об этом перке в общем списке
            for _, spell_info in ipairs(game_spells_lib.spells_list) do
                local name_in_list = spell_info[1]
                if name_in_list == spell_name then

                    local spell_team = tonumber(spell_info[6])  -- 0 - эльфы, 1 - тролли
                    local is_enabled = tonumber(spell_info[7]) == 1

                    local is_valid = false

                    -- Проверка условий: включен ли перк и подходит ли игрок по расе и команде
                    if is_enabled then
                        if spell_team == 0 and team == DOTA_TEAM_GOODGUYS and hero:IsElf() then
                            is_valid = true
                        elseif spell_team == 1 and team == DOTA_TEAM_BADGUYS and hero:IsTroll() then
                            is_valid = true
                        end
                    end

                    -- Если перк не подходит, удаляем его
                    if not is_valid then
                        table.remove(active, i)
                    end
                end
            end
        end
    end


    -- GOOD GUYS: DOTA_TEAM_GOODGUYS
    if team == DOTA_TEAM_GOODGUYS then
        if #active == 0 then
            -- нет перков: даём 1 случайный, но не elf_spell_solo_player
            local candidates = {}
            for _, info in ipairs(game_spells_lib.spells_list) do
                local spell_name = info[1]
                local allowed_team = info[6]     -- "0" — good guys
                local enabled      = info[7] == "1"
                if allowed_team == "0" and enabled and spell_name ~= "elf_spell_solo_player" then
                    table.insert(candidates, spell_name)
                end
            end
            if #candidates > 0 then
                active[1] = candidates[RandomInt(1, #candidates)]
            end
        else
            -- есть перки, но нет solo-перка: добавляем последний в списке
            local has_solo = false
            for _, name in ipairs(active) do
                if name == "elf_spell_solo_player" then has_solo = true break end
            end
            if not has_solo and #active > 0 then
            -- запоминаем последнюю запись
            local last_selected = active[#active]
                -- очищаем текущий список active
                for i = #active, 1, -1 do
                    table.remove(active, i)
                end
            -- сохраняем только последний выбранный перк
            table.insert(active, last_selected)
            end
        end
    -- BAD GUYS: DOTA_TEAM_BADGUYS
    elseif team == DOTA_TEAM_BADGUYS then
        if #active == 0 then
            -- нет перков: даём 3 случайных для bad guys
            local candidates = {}
            for _, info in ipairs(game_spells_lib.spells_list) do
                local spell_name  = info[1]
                local allowed_team = info[6]   -- "1" — bad guys
                local enabled      = info[7] == "1"
                if allowed_team == "1" and enabled then
                    table.insert(candidates, spell_name)
                end
            end
            -- выбираем без повторов
            local picked = {}
            while #picked < 3 and #candidates > 0 do
                local idx = RandomInt(1, #candidates)
                table.insert(picked, candidates[idx])
                table.remove(candidates, idx)
            end
            for i, name in ipairs(picked) do
                active[i] = name
            end
        end
    end

    -- Сохраняем обновлённый список, если он был пустым или мы его дополнили
    game_spells_lib.current_activated_spell[id] = active
    -- Наконец, выдаём перки герою
    if #active > 0 then
        local hero = PlayerResource:GetSelectedHeroEntity(id)
        if hero then
            for _, spell_name in ipairs(active) do
                local modifier_name = game_spells_lib:FindModifierFromSpellName(spell_name)
                local level = game_spells_lib:GetSpellLevel(id, spell_name)
                if not hero:HasModifier(modifier_name) then
                    local mod = hero:AddNewModifier(hero, nil, modifier_name, {})
                    if mod then
                        mod:SetStackCount(level)
                    end
                end
            end
        end
    end

    CustomNetTables:SetTableValue("game_spells_lib", "spell_active", game_spells_lib.current_activated_spell)

end


function game_spells_lib:HasSoloPerk(id)
    if game_spells_lib.current_activated_spell[id] == nil then
        return false
    end
    for _, s in pairs(game_spells_lib.current_activated_spell[id]) do
        if s == "elf_spell_solo_player" then
            return true
        end
    end
    return false
end
