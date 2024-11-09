game_spells_lib = class({})

-- Массив существующих навыков
-- 1 - название
-- 2 - Иконка (ЭТО ДОЛЖНО БЫТЬ ДЕФОЛТНОЕ ОТОБРАЖЕНИЕ БЕЗ УРОВНЯ ПРОКАЧКИ, ЕСЛИ У ИГРОКА ЕСТЬ НАВЫК И УРОВЕНЬ, ТО ДОБАВЛЯЕТСЯ К ИКОНКЕ УЖЕ иконка_1 или иконка_2 и т.д.) (Не забудь что в js не компилятся иконки и их надо будет где-то закомпилить в xml или css)
-- 3 - Модификатор
-- 4 - Описание улучшений 1-2-3

game_spells_lib.spells_list =
{
    --[[
    {"spell_1", "spell_1", "modifier_spell_test", {"spell_1_description_level_1", "spell_1_description_level_2", "spell_1_description_level_3"}, "1"},
    {"spell_2", "spell_1", "modifier_spell_test_2", {"spell_2_description_level_1", "spell_2_description_level_2", "spell_2_description_level_3"}, "1"},
    {"spell_3", "spell_1", "modifier_spell_test_3", {"spell_3_description_level_1", "spell_3_description_level_2", "spell_3_description_level_3"}, "0"},
    {"spell_4", "spell_1", "modifier_spell_test_4", {"spell_4_description_level_1", "spell_4_description_level_2", "spell_4_description_level_3"}, "0"},
    {"spell_5", "spell_1", "modifier_spell_test_5", {"spell_5_description_level_1", "spell_5_description_level_2", "spell_5_description_level_3"}, "1"},
    --]]
     --{"troll_spell_block_damage", "troll_spell_block_damage", "modifier_troll_spell_block_damage", {"troll_spell_block_damage_description_level_1", "troll_spell_block_damage_description_level_2", "troll_spell_block_damage_description_level_3"}, "1"},
    {},
    {"elf_spell_ms", "elf_spell_ms", "modifier_elf_spell_ms", {"elf_spell_ms_description_level_1", "elf_spell_ms_description_level_2", "elf_spell_ms_description_level_3"}, "0"},
    {"elf_spell_gold", "elf_spell_gold", "modifier_elf_spell_gold", {"elf_spell_gold_description_level_1", "elf_spell_gold_description_level_2", "elf_spell_gold_description_level_3"}, "0"},
    {"elf_spell_lumber", "elf_spell_lumber", "modifier_elf_spell_lumber", {"elf_spell_lumber_description_level_1", "elf_spell_lumber_description_level_2", "elf_spell_lumber_description_level_3"}, "0"},
    {"elf_spell_cd_reduce", "elf_spell_cd_reduce", "modifier_elf_spell_cd_reduce", {"elf_spell_cd_reduce_description_level_1", "elf_spell_cd_reduce_description_level_2", "elf_spell_cd_reduce_description_level_3"}, "0"},
    {"elf_spell_cd_worker", "elf_spell_cd_worker", "modifier_elf_spell_cd_worker", {"elf_spell_cd_worker_description_level_1", "elf_spell_cd_worker_description_level_2", "elf_spell_cd_worker_description_level_3"}, "0"},
    {"elf_spell_armor_wall", "elf_spell_armor_wall", "modifier_elf_spell_armor_wall", {"elf_spell_armor_wall_description_level_1", "elf_spell_armor_wall_description_level_2", "elf_spell_armor_wall_description_level_3"}, "0"},
    {"elf_spell_tower_damage", "elf_spell_tower_damage", "modifier_elf_spell_tower_damage", {"elf_spell_tower_damage_description_level_1", "elf_spell_tower_damage_description_level_2", "elf_spell_tower_damage_description_level_3"}, "0"},
    {"elf_spell_limit_gold", "elf_spell_limit_gold", "modifier_elf_spell_limit_gold", {"elf_spell_limit_gold_description_level_1", "elf_spell_limit_gold_description_level_2", "elf_spell_limit_gold_description_level_3"}, "0"},
    {"elf_spell_limit_lumber", "elf_spell_limit_lumber", "modifier_elf_spell_limit_lumber", {"elf_spell_limit_lumber_description_level_1", "elf_spell_limit_lumber_description_level_2", "elf_spell_limit_lumber_description_level_3"}, "0"},
    {"elf_spell_true", "elf_spell_true", "modifier_elf_spell_true", {"elf_spell_true_description_level_1", "elf_spell_true_description_level_2", "elf_spell_true_description_level_3"}, "0"},
    {"elf_spell_tower_range", "elf_spell_tower_range", "modifier_elf_spell_tower_range", {"elf_spell_tower_range_description_level_1", "elf_spell_tower_range_description_level_2", "elf_spell_tower_range_description_level_3"}, "0"},
    {"elf_spell_blink", "elf_spell_blink", "modifier_elf_spell_blink", {"elf_spell_blink_description_level_1", "elf_spell_blink_description_level_2", "elf_spell_blink_description_level_3"}, "0"},
    {"elf_spell_damage_gold", "elf_spell_damage_gold", "modifier_elf_spell_damage_gold", {"elf_spell_damage_gold_description_level_1", "elf_spell_damage_gold_description_level_2", "elf_spell_damage_gold_description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},
    {"elf_spell_", "elf_spell_", "modifier_elf_spell_", {"elf_spell__description_level_1", "elf_spell__description_level_2", "elf_spell__description_level_3"}, "0"},


    {"troll_spell_ms", "troll_spell_ms", "modifier_troll_spell_ms", {"troll_spell_ms_description_level_1", "troll_spell_ms_description_level_2", "troll_spell_ms_description_level_3"}, "1"},
    {"troll_spell_gold_hit", "troll_spell_gold_hit", "modifier_troll_spell_gold_hit", {"troll_spell_gold_hit_description_level_1", "troll_spell_gold_hit_description_level_2", "troll_spell_gold_hit_description_level_3"}, "1"},
    {"troll_spell_hp_reg", "troll_spell_hp_reg", "modifier_troll_spell_hp_reg", {"troll_spell_hp_reg_description_level_1", "troll_spell_hp_reg_description_level_2", "troll_spell_hp_reg_description_level_3"}, "1"},
    {"troll_spell_limit_gold", "troll_spell_limit_gold", "modifier_troll_spell_limit_gold", {"troll_spell_limit_gold_description_level_1", "troll_spell_limit_gold_description_level_2", "troll_spell_limit_gold_description_level_3"}, "1"},
    {"troll_spell_cd_reduce", "troll_spell_cd_reduce", "modifier_troll_spell_cd_reduce", {"troll_spell_cd_reduce_description_level_1", "troll_spell_cd_reduce_description_level_2", "troll_spell_cd_reduce_description_level_3"}, "1"},
    {"troll_spell_armor", "troll_spell_armor", "modifier_troll_spell_armor", {"troll_spell_armor_description_level_1", "troll_spell_armor_description_level_2", "troll_spell_armor_description_level_3"}, "1"},
    {"troll_spell_vision", "troll_spell_vision", "modifier_troll_spell_vision", {"troll_spell_vision_description_level_1", "troll_spell_vision_description_level_2", "troll_spell_vision_description_level_3"}, "1"},
    {"troll_spell_magic_resist", "troll_spell_magic_resist", "modifier_troll_spell_magic_resist", {"troll_spell_magic_resist_description_level_1", "troll_spell_magic_resist_description_level_2", "troll_spell_magic_resist_description_level_3"}, "1"},
    {"troll_spell_status_resist", "troll_spell_status_resist", "modifier_troll_spell_status_resist", {"troll_spell_status_resist_description_level_1", "troll_spell_status_resist_description_level_2", "troll_spell_status_resist_description_level_3"}, "1"},
    {"troll_spell_silence_target", "troll_spell_silence_target", "modifier_troll_spell_silence_target", {"troll_spell_silence_target_description_level_1", "troll_spell_silence_target_description_level_2", "troll_spell_silence_target_description_level_3"}, "1"},
    {"troll_spell_silence_area", "troll_spell_silence_area", "modifier_troll_spell_silence_area", {"troll_spell_silence_area_description_level_1", "troll_spell_silence_area_description_level_2", "troll_spell_silence_area_description_level_3"}, "1"},
    {"troll_spell_stun_target", "troll_spell_stun_target", "modifier_troll_spell_stun_target", {"troll_spell_stun_target_description_level_1", "troll_spell_stun_target_description_level_2", "troll_spell_stun_target_description_level_3"}, "1"},
    {"troll_spell_haste", "troll_spell_haste", "modifier_troll_spell_haste", {"troll_spell_haste_description_level_1", "troll_spell_haste_description_level_2", "troll_spell_haste_description_level_3"}, "1"},
    {"troll_spell_ward", "troll_spell_ward", "modifier_troll_spell_ward", {"troll_spell_ward_description_level_1", "troll_spell_ward_description_level_2", "troll_spell_ward_description_level_3"}, "1"},
    {"troll_spell_bkb", "troll_spell_bkb", "modifier_troll_spell_bkb", {"troll_spell_bkb_description_level_1", "troll_spell_bkb_description_level_2", "troll_spell_bkb_description_level_3"}, "1"},
    {"troll_spell_slow_target", "troll_spell_slow_target", "modifier_troll_spell_slow_target", {"troll_spell_slow_target_description_level_1", "troll_spell_slow_target_description_level_2", "troll_spell_slow_target_description_level_3"}, "1"},
    {"troll_spell_slow_area", "troll_spell_slow_area", "modifier_troll_spell_slow_area", {"troll_spell_slow_area_description_level_1", "troll_spell_slow_area_description_level_2", "troll_spell_slow_area_description_level_3"}, "1"},
    {"troll_spell_invis", "troll_spell_invis", "modifier_troll_spell_invis", {"troll_spell_invis_description_level_1", "troll_spell_invis_description_level_2", "troll_spell_invis_description_level_3"}, "1"},
    {"troll_spell_evasion", "troll_spell_evasion", "modifier_troll_spell_evasion", {"troll_spell_evasion_description_level_1", "troll_spell_evasion_description_level_2", "troll_spell_evasion_description_level_3"}, "1"},
    {"troll_spell_atkspeed", "troll_spell_atkspeed", "modifier_troll_spell_atkspeed", {"troll_spell_atkspeed_description_level_1", "troll_spell_atkspeed_description_level_2", "troll_spell_atkspeed_description_level_3"}, "1"},
    {"troll_spell_wolf", "troll_spell_wolf", "modifier_troll_spell_wolf", {"troll_spell_wolf_description_level_1", "troll_spell_wolf_description_level_2", "troll_spell_wolf_description_level_3"}, "1"},
    {"troll_spell_reveal", "troll_spell_reveal", "modifier_troll_spell_reveal", {"troll_spell_reveal_description_level_1", "troll_spell_reveal_description_level_2", "troll_spell_reveal_description_level_3"}, "1"},
    {"troll_spell_night_buff", "troll_spell_night_buff", "modifier_troll_spell_night_buff", {"troll_spell_night_buff_description_level_1", "troll_spell_night_buff_description_level_2", "troll_spell_night_buff_description_level_3"}, "1"},
    {"troll_spell_gold_wisp", "troll_spell_gold_wisp", "modifier_troll_spell_gold_wisp", {"troll_spell_gold_wisp_description_level_1", "troll_spell_gold_wisp_description_level_2", "troll_spell_gold_wisp_description_level_3"}, "1"},
    

    
    --[[
  
 
   {"troll_spell_", "troll_spell_", "modifier_troll_spell_", {"troll_spell__description_level_1", "troll_spell__description_level_2", "troll_spell__description_level_3"}, "1"},
   

]]
}

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
game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE = 999 -- в минутах до скольки можно поставить навык

CustomNetTables:SetTableValue("game_spells_lib", "spell_list", game_spells_lib.spells_list)
CustomNetTables:SetTableValue("game_spells_lib", "spell_cost", {cost = game_spells_lib.spells_cost_random})
CustomNetTables:SetTableValue("game_spells_lib", "spell_active", game_spells_lib.current_activated_spell)

-- ТЕСТОВАЯ ТАБЛИЦА ДАННЫХ ИГРОКА
--CustomNetTables:SetTableValue("game_spells_lib", tostring(0), game_spells_lib.PLAYER_INFO[0])

function game_spells_lib:event_set_activate_spell(data)
    if data.PlayerID == nil then return end
    local player_id = data.PlayerID
    local hero = PlayerResource:GetSelectedHeroEntity(player_id)
    if hero == nil then return end
    local modifier_name = data.modifier_name
    local spell_name = data.spell_name

    local havePerk = false
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        if spell_name == game_spells_lib.PLAYER_INFO[player_id][tostring(i)][tostring(1)] then
            havePerk = true
            break
        end
    end
    if not havePerk then
        return
    end

    for _, spell_history in pairs(game_spells_lib.spells_list) do
        if spell_history[1] == spell_name then
            if tonumber(spell_history[5]) == 0 and not hero:IsElf() then
                return
            elseif tonumber(spell_history[5]) == 1 and not hero:IsTroll()  then
                return
            end
        end
    end

    -- Создание таблицы активных навыков у игрока с айди
    if game_spells_lib.current_activated_spell[player_id] == nil then
        game_spells_lib.current_activated_spell[player_id] = {}
    end
    if GameRules.startTime == nil then
		GameRules.startTime = 1
	end
    -- нельзя использовать после опредленного времени
    if (math.floor(GameRules:GetGameTime() - GameRules.startTime) / 60) >= game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE then
		return
	end

    -- Находим есть ли у игрока этот навык, если есть то удаляет, если нет то добавляем
    if game_spells_lib:FindCurrentSpellPlayer(player_id, spell_name) then
        game_spells_lib:RemovePlayerSpell(player_id, spell_name, modifier_name, hero)
    else
        -- Если у игрока больше 3 активных навыков, то надо удалить самый старый включенный навык
        if #game_spells_lib.current_activated_spell[player_id] >= 3 then
            game_spells_lib:RemoveOldSpell(player_id, hero)
        end
        -- Добавление навыка
        game_spells_lib:AddPlayerSpell(player_id, spell_name, modifier_name, hero)
    end

    -- Обновление визуала активных навыков
    CustomNetTables:SetTableValue("game_spells_lib", "spell_active", game_spells_lib.current_activated_spell)
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
    for i=#game_spells_lib.current_activated_spell[id], 1, -1 do
        if game_spells_lib.current_activated_spell[id][i] == spell_name then
            table.remove(game_spells_lib.current_activated_spell[id], i)
            hero:RemoveModifierByName(modifier_name)
            break
        end
    end
end

function game_spells_lib:AddPlayerSpell(id, spell_name, modifier_name, hero)
    if game_spells_lib.current_activated_spell[id] == nil then
        game_spells_lib.current_activated_spell[id] = {}
    end
    table.insert(game_spells_lib.current_activated_spell[id], spell_name)
    local spell_mod = hero:AddNewModifier(hero, nil, modifier_name, {}):SetStackCount(game_spells_lib:GetSpellLevel(id, spell_name))
    DebugPrint("lvl " .. game_spells_lib:GetSpellLevel(id, spell_name))
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
    DebugPrintTable(drop_info)
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
		dataShop.SteamID = tostring(PlayerResource:GetSteamID(player_id))
		dataShop.Num = tostring(drop_info[1])
        dataShop.Score = tostring(drop_info[2])
        dataShop.Nick = "skill"
        dataShop.Coint = tostring(cost)
        dataShop.TypeDonate = "gem"
        dataShop.PlayerID = player_id
        Shop.GetSkill(dataShop, callback)
    end

end

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
                if spell_history[1] == game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] and tonumber(spell_history[5]) == idPerk then
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
                    if spell_history[1] == game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] and tonumber(spell_history[5]) == idPerk then
                        table.insert(find_random_to_upgrade, game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"])
                    end
                end
            end
        end
    end
    local random_upgrade = find_random_to_upgrade[RandomInt(1, #find_random_to_upgrade)]
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
        if tonumber(spell_history[5]) == idPerk then
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
        return random_spells[RandomInt(1, #random_spells)][1]
    end
    return nil
end