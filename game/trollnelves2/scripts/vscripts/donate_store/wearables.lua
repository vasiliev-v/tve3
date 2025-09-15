if wearables == nil then
    _G.wearables = class({})
end

defaultpart = {}

require('settings')
require("donate_store/wearables_data")

function wearables:SelectPart(info)
    if info.offp ~= 0 then
        -- сброс эффекта
        GameRules.SkinTower[info.PlayerID]["effect"] = nil
        PlayerResource:GetSelectedHeroEntity(info.PlayerID):RemoveModifierByName("part_mod")
        CustomNetTables:SetTableValue("Shop_active", tostring(info.PlayerID), GameRules.SkinTower[info.PlayerID])
        return
    end

    local parts = CustomNetTables:GetTableValue("Particles_Tabel", tostring(info.PlayerID))
    if not parts or parts[info.part] == nil or parts[info.part] == "nill" then
        return
    end

    -- Общие действия
    local hero = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
    local arr = {
        info.PlayerID,
        PlayerResource:GetPlayerName(info.PlayerID),
        info.part,
        PlayerResource:GetSelectedHeroName(info.PlayerID)
    }
    CustomGameEventManager:Send_ServerToAllClients("UpdateParticlesUI", arr)

    hero:RemoveModifierByName("part_mod")
    hero:AddNewModifier(hero, hero, "part_mod", { part = info.part })

    -- Применяем лейбл из таблицы
    --local cfg = Wearables.EffectConfig[info.part]
    --if cfg then
    --    hero:SetCustomHealthLabel(cfg.label, unpack(cfg.color))
    --end

    -- Запоминаем выбор
    GameRules.SkinTower[info.PlayerID]["effect"] = info.part
    CustomNetTables:SetTableValue("Shop_active", tostring(info.PlayerID), GameRules.SkinTower[info.PlayerID])
end

function wearables:AttachWearable(unit, modelPath)
    local wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = modelPath, DefaultAnim=animation, targetname=DoUniqueString("prop_dynamic")})
    wearable:FollowEntity(unit, true)
    unit.wearables = unit.wearables or {}
    table.insert(unit.wearables, wearable)
end

function wearables:RemoveWearables(hero)
    print('#')
	local wearables = {} -- объявление локального массива на удаление
	local cur = hero:FirstMoveChild() -- получаем первый указатель над подобъект объекта hero ()
	
	while cur ~= nil do --пока наш текущий указатель не равен nil(пустота/пустой указатель)
		cur = cur:NextMovePeer() -- выбираем следующий указатель на подобъект нашего обьекта
		if cur ~= nil and cur:GetClassname() ~= "" and (cur:GetClassname() == "dota_item_wearable" or cur:GetClassname() == "prop_dynamic") then -- проверяем, елси текущий указатель не пуст, название класса не пустое, и если этот класс есть класс "dota_item_wearable", то есть надеваемые косметические предметы
			--DebugPrint(cur:GetClassname())
			table.insert(wearables, cur) -- добавляем в таблицу на удаление текущий предмет(сверху проверяли класс текущего объекта)
		end
	end
	
	for i = 1, #wearables do -- собственно цикл для удаления всего занесенного в массив на удаление
		UTIL_Remove(wearables[i]) -- удаляем объект
	end
	wearables = nil
end

function UpdateModel(target, model, scale)
	target:SetOriginalModel(model)
	target:SetModel(model)
	target:SetModelScale(scale)
end
function wearables:SetPart(i)

    local hero = PlayerResource:GetSelectedHeroEntity(i)
    if not hero then
        Timers:CreateTimer(2, function()
            wearables:SetPart(i)
        end)
		return
	end

    if GameRules.SkinTower[i]["effect"] ~= nil and GameRules.SkinTower[i]["effect"] ~= "" and PlayerResource:GetConnectionState(i) == 2 then
        if PlayerResource:GetSelectedHeroEntity(i):FindModifierByName("part_mod") == nil then
            local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(i))
            local num = tostring(tonumber(GameRules.SkinTower[i]["effect"])+100) 
            if PoolTable["1"][num] ~= nil then
                local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(i))
                --Say(nil,"text here", false)
                --GameRules:SendCustomMessage("<font color='#58ACFA'> использовал эффект </font>"..info.name.."#partnote".." test", 0, 0)
                local arr = {
                    i,
                    PlayerResource:GetPlayerName(i),
                    tonumber(GameRules.SkinTower[i]["effect"]),
                    PlayerResource:GetSelectedHeroName(i)
                }
                PlayerResource:GetSelectedHeroEntity(i):AddNewModifier(PlayerResource:GetSelectedHeroEntity(i), PlayerResource:GetSelectedHeroEntity(i), "part_mod", {part = GameRules.SkinTower[i]["effect"]})

                CustomNetTables:SetTableValue("Shop_active", tostring(i), GameRules.SkinTower[i])
            end
        end
    end

end
	

function wearables:SelectSkin(info)
	local npc = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
    if info.offp == 0 then
	    SetModelVip(npc, info.part)
	else
		SetModelStandart(npc)
        GameRules.SkinTower[info.PlayerID]["skin"] = nil
	end
    CustomNetTables:SetTableValue("Shop_active", tostring(info.PlayerID), GameRules.SkinTower[info.PlayerID])
end

function wearables:SelectLabel(info)
	local npc = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
    if info.offp == 0 then
	    SetLabelVip(npc, info.part)
	else
		SetLabelStandart(npc)
        GameRules.SkinTower[info.PlayerID]["label"] = nil
	end
    CustomNetTables:SetTableValue("Shop_active", tostring(info.PlayerID), GameRules.SkinTower[info.PlayerID])
end

function SetLabelStandart(npc, num)
    if not npc then return end
    npc:SetCustomHealthLabel("", 255, 255,   255)
end



function SetLabelVip(npc, num)
    if not npc then return end

    local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(npc:GetPlayerOwnerID()))
    if not PoolTable or not PoolTable["1"] or PoolTable["1"][num] == nil then
        return
    end

    -- Применяем лейбл из таблицы
    local cfg = Wearables.EffectConfig[num]
    if cfg then
        npc:SetCustomHealthLabel(cfg.label, unpack(cfg.color))
    end

    GameRules.SkinTower[npc:GetPlayerOwnerID()]["label"] = num
    CustomNetTables:SetTableValue("Shop_active", tostring(npc:GetPlayerOwnerID()), GameRules.SkinTower[npc:GetPlayerOwnerID()])
end

function wearables:SetSkin(i)
	
    local hero = PlayerResource:GetSelectedHeroEntity(i)
    if not hero then
        Timers:CreateTimer(2, function()
            wearables:SetSkin(i)
        end)
		return
	end

    if GameRules.SkinTower[i]["skin"] ~= nil and GameRules.SkinTower[i]["skin"]  ~= "" and PlayerResource:GetConnectionState(i) == 2 then
        local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(i))
        if PoolTable["1"][GameRules.SkinTower[i]["skin"]] ~= nil  then
            SetModelVip(PlayerResource:GetSelectedHeroEntity(i), tostring(GameRules.SkinTower[i]["skin"]))
            CustomNetTables:SetTableValue("Shop_active", tostring(i), GameRules.SkinTower[i])
        end
    end
	 
end

function wearables:SetLabel(i)
	
    local hero = PlayerResource:GetSelectedHeroEntity(i)
    if not hero then
        Timers:CreateTimer(2, function()
            wearables:SetLabel(i)
        end)
		return
	end

    if GameRules.SkinTower[i]["label"] ~= nil and GameRules.SkinTower[i]["label"]  ~= "" and PlayerResource:GetConnectionState(i) == 2 then
        local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(i))
        if PoolTable["1"][GameRules.SkinTower[i]["label"]] ~= nil  then
            SetLabelVip(PlayerResource:GetSelectedHeroEntity(i), tostring(GameRules.SkinTower[i]["label"]))
            CustomNetTables:SetTableValue("Shop_active", tostring(i), GameRules.SkinTower[i])
        end
    end
	 
end

function wearables:SetWolf(PlayerID)
	if GameRules.SkinTower[PlayerID]["wolf"] ~= nil and GameRules.SkinTower[PlayerID]["wolf"]  ~= "" and PlayerResource:GetConnectionState(PlayerID) == 2 then
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(PlayerID))
		if PoolTable["1"][GameRules.SkinTower[PlayerID]["wolf"]] ~= nil  then
			local npc = PlayerResource:GetSelectedHeroEntity(PlayerID)
			SetModelVip(npc, tostring(GameRules.SkinTower[PlayerID]["wolf"]))
            CustomNetTables:SetTableValue("Shop_active", tostring(PlayerID), GameRules.SkinTower[PlayerID])
		end
	end
end

function wearables:SetBear(PlayerID)
	if GameRules.SkinTower[PlayerID]["bear"] ~= nil and GameRules.SkinTower[PlayerID]["bear"]  ~= "" and PlayerResource:GetConnectionState(PlayerID) == 2 then
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(PlayerID))
		if PoolTable["1"][GameRules.SkinTower[PlayerID]["bear"]] ~= nil  then
			local npc = PlayerResource:GetSelectedHeroEntity(PlayerID)
			SetModelVip(npc, tostring(GameRules.SkinTower[PlayerID]["bear"]))
            CustomNetTables:SetTableValue("Shop_active", tostring(PlayerID), GameRules.SkinTower[PlayerID])
		end
	end
end



function wearables:SetDefaultPart(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
	local data = {}
	if event.part ~=  nil then
		data.SteamID = tostring(PlayerResource:GetSteamID(event.PlayerID))
		data.Num = tostring(event.part)
		data.TypeDonate = tostring(1)
		data.Type = "effect"
		if GameRules.SaveDefItem[event.PlayerID][1] == nil then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][1] = 1
		elseif  GameRules.SaveDefItem[event.PlayerID][1] < 100 then
			Shop.GetVip(data, callback)
		end
	end
end	

function wearables:SetDefaultLabel(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
	local data = {}
	if event.part ~=  nil then
		data.SteamID = tostring(PlayerResource:GetSteamID(event.PlayerID))
		data.Num = tostring(event.part)
		data.TypeDonate = tostring(1)
		data.Type = "label"
		if GameRules.SaveDefItem[event.PlayerID][1] == nil then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][1] = 1
		elseif  GameRules.SaveDefItem[event.PlayerID][1] < 100 then
			Shop.GetVip(data, callback)
		end
	end
end	

function wearables:SetDefaultSkin(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
	local data = {}
	if event.part ~= nil then
		data.SteamID = tostring(PlayerResource:GetSteamID(event.PlayerID))
		data.Num = tostring(event.part)
		data.TypeDonate = tostring(1)
		if tonumber(event.part) >= 620 and tonumber(event.part) <= 631 then
			data.Type = "wolf"
			if GameRules.SaveDefItem[event.PlayerID][2] == nil then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][2] = 1
			elseif  GameRules.SaveDefItem[event.PlayerID][2] < 100 then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][2] = GameRules.SaveDefItem[event.PlayerID][2] + 1
			end
		elseif (tonumber(event.part) >= 673 and tonumber(event.part) <= 682) or 
               (tonumber(event.part) >= 1800 and tonumber(event.part) <= 1801) then
			data.Type = "bear"
			if GameRules.SaveDefItem[event.PlayerID][3] == nil then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][3] = 1
			elseif  GameRules.SaveDefItem[event.PlayerID][3] < 100 then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][3] = GameRules.SaveDefItem[event.PlayerID][3] + 1
			end
		else
			data.Type = "skin"
			if GameRules.SaveDefItem[event.PlayerID][4] == nil then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][4] = 1
			elseif  GameRules.SaveDefItem[event.PlayerID][4] < 100 then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][4] = GameRules.SaveDefItem[event.PlayerID][4] + 1
			end	
		end	
	end
end	

function wearables:SetDefaultSkinTower(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
	local data = {}
	if event.part ~= nil then
		data.SteamID = tostring(PlayerResource:GetSteamID(event.PlayerID))
		data.Num = tostring(event.part)
		data.TypeDonate = tostring(1)
		data.Type = event.type
		if GameRules.SaveDefItem[event.PlayerID][5] == nil then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][5] = 1
		elseif  GameRules.SaveDefItem[event.PlayerID][5] < 100 then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][5] = GameRules.SaveDefItem[event.PlayerID][5] + 1
		end	
	end
end	

function wearables:SetDefaultSkinWisp(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
	local data = {}
	if event.part ~= nil then
		data.SteamID = tostring(PlayerResource:GetSteamID(event.PlayerID))
		data.Num = tostring(event.part)
		data.TypeDonate = tostring(1)
		data.Type = "wisp"
		if GameRules.SaveDefItem[event.PlayerID][10] == nil then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][10] = 1
		elseif  GameRules.SaveDefItem[event.PlayerID][10] < 100 then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][10] = GameRules.SaveDefItem[event.PlayerID][10] + 1
		end	
	end
end	

function SetModelVip(npc, num)
    if not npc then return end

    local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(npc:GetPlayerOwnerID()))
    if not PoolTable or not PoolTable["1"] or PoolTable["1"][num] == nil then
        return
    end

    local data
    if npc:IsWolf() then
        data = Wearables.wolfModels[num]
        if data then
            npc:SetOriginalModel(data.model)
            npc:SetModel(data.model)
            npc:SetModelScale(data.scale)
            GameRules.SkinTower[npc:GetPlayerOwnerID()]["wolf"] = num
        end

    elseif npc:IsTroll() and npc.bear then
        data = Wearables.bearModels[num]
        if data then
            npc.bear:SetOriginalModel(data.model)
            npc.bear:SetModel(data.model)
            npc.bear:SetModelScale(data.scale)
            GameRules.SkinTower[npc.bear:GetPlayerOwnerID()]["bear"] = num
        end

    elseif npc:IsElf() then
        data = Wearables.elfModels[num]
        if data then
            npc:SetOriginalModel(data.model)
            npc:SetModel(data.model)
            npc:SetModelScale(data.scale)
            GameRules.SkinTower[npc:GetPlayerOwnerID()]["skin"] = num
        end
    end
end

function SetModelStandart(npc)	
	if npc:GetUnitName() == "npc_dota_hero_lycan" then
		npc:SetOriginalModel("models/heroes/lycan/lycan_wolf.vmdl")
		npc:SetModel("models/heroes/lycan/lycan_wolf.vmdl")
		npc:SetModelScale(1)
        GameRules.SkinTower[npc:GetPlayerOwnerID()]["wolf"] = nil
	elseif npc:IsElf() then
		npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl")
		npc:SetModel("models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl")
		npc:SetModelScale(1)
	end
end

function wearables:SelectSkinTower(info)
	local npc = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
    if info.offp == 0 then
		GameRules.SkinTower[info.PlayerID][info.type] = info.part
		SetModelVipTower(npc, info.part, info.PlayerID)
		
	else
        GameRules.SkinTower[info.PlayerID][info.type] = nil
		-- SetModelStandart(npc)
	end
    CustomNetTables:SetTableValue("Shop_active", tostring(info.PlayerID), GameRules.SkinTower[info.PlayerID])
end

function wearables:SelectSkinWisp(info)
	local npc = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
    if info.offp == 0 then
		GameRules.SkinTower[info.PlayerID]["wisp"] = info.part
		SetModelVipWisp(npc, info.part, info.PlayerID, true)
	else
		GameRules.SkinTower[info.PlayerID]["wisp"] = nil
	end
    CustomNetTables:SetTableValue("Shop_active", tostring(info.PlayerID), GameRules.SkinTower[info.PlayerID])
end

function SetModelVipWisp(npc, num, playerID, save)
    if not npc then return end

    local pool = CustomNetTables:GetTableValue("Shop", tostring(npc:GetPlayerOwnerID()))
    if not pool or not pool["1"][num] then return end
    if not npc:IsElf() then return end

    local skinID = GameRules.SkinTower[playerID] and GameRules.SkinTower[playerID]["wisp"]
    if not skinID then return end

    local cfg = Wearables.wispSkinConfig[skinID]
    if not cfg then return end

    for _, unit in ipairs(npc.units) do
        if not unit or unit:IsNull() then
            goto continue
        end

        local baseName = unit:GetUnitName():match("%a+")
        if baseName ~= "wisp" or unit:GetUnitName() == "gold_wisp" then
            goto continue
        end

        wearables:RemoveWearables(unit)

        local model, scale

        if cfg.updateModel then
            model = cfg.updateModel.model
            scale = cfg.updateModel.scale
        else
            model = cfg.model
            scale = cfg.scale or 1

            if cfg.mapModels then
                local map = GameRules.MapName:lower()
                for key, m in pairs(cfg.mapModels) do
                    if string.match(map,key) then
                        model = m.model
                        scale = m.scale or scale
                        break
                    end
                end
            end
        end

        if model then
            UpdateModel(unit, model, scale)
        end
        if cfg.materialGroup then
            unit:SetMaterialGroup(tostring(cfg.materialGroup))
        end

        ::continue::
    end

    if save then
        CustomNetTables:SetTableValue("Shop_active", tostring(playerID), GameRules.SkinTower[playerID])
    end
end



function SetModelVipTower(npc, num, playerID)
    if not npc then return end

    -- Получаем табличку магазина
    local pool = CustomNetTables:GetTableValue("Shop", tostring(npc:GetPlayerOwnerID()))
    if not pool or not pool["1"] or not pool["1"][num] then
        return
    end

    if not npc:IsElf() then
        return
    end

    for _, building in ipairs(npc.units) do
        if not building or building:IsNull() then
            goto continue
        end

        local name   = building:GetUnitName()
        local skinID = GameRules.SkinTower[playerID] and GameRules.SkinTower[playerID][name]
        if not skinID then
            goto continue
        end

        -- Достаём конфиг по skinID
        local cfg = Wearables.TowerSkinConfigs[tostring(skinID)]
        if not cfg then
            return
        end

        -- Снимаем старые модели/аксессуары
        wearables:RemoveWearables(building)

        -- 1) Если есть attachments — навешиваем их
        if cfg.attachments then
            for _, modelPath in ipairs(cfg.attachments) do
                wearables:AttachWearable(building, modelPath)
            end
        end

        -- 2) Если есть частицы — создаём их
        if cfg.particles then
            for _, p in ipairs(cfg.particles) do
                local attachType  = p.attachType or PATTACH_POINT_FOLLOW
                local attachPoint = p.attachPoint or ""
                local offset      = p.offset or Vector(0,0,0)

                local ent = ParticleManager:CreateParticle(p.path, attachType, building)
                ParticleManager:SetParticleControlEnt(
                    ent,
                    p.cp or 0,
                    building,
                    attachType,
                    attachPoint,
                    offset,
                    true
                )
            end
        end

        if cfg.updateModel then
            UpdateModel(building, cfg.updateModel.model, cfg.updateModel.scale)
        end

        ::continue::
    end

    -- Обновляем NetTable
    CustomNetTables:SetTableValue("Shop_active", tostring(playerID), GameRules.SkinTower[playerID])
end

