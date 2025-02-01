if wearables == nil then
    _G.wearables = class({})
end
local dedicatedServerKey = GetDedicatedServerKeyV3("1")

defaultpart = {}

require('settings')

function wearables:SelectPart(info)
    if info.offp == 0 then
        local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(info.PlayerID))
        if parts ~= nil then
            if parts[info.part] ~= "nill" and parts[info.part] ~= nil then
				
                local arr = {
                    info.PlayerID,
                    PlayerResource:GetPlayerName(info.PlayerID),
                    info.part,
                    PlayerResource:GetSelectedHeroName(info.PlayerID)
				}
				
                CustomGameEventManager:Send_ServerToAllClients( "UpdateParticlesUI", arr)
                PlayerResource:GetSelectedHeroEntity(info.PlayerID):RemoveModifierByName("part_mod")
                PlayerResource:GetSelectedHeroEntity(info.PlayerID):AddNewModifier(PlayerResource:GetSelectedHeroEntity(info.PlayerID), PlayerResource:GetSelectedHeroEntity(info.PlayerID), "part_mod", {part = info.part})
				local npc = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
				if info.part == "21" then
					npc:SetCustomHealthLabel("#top1autumn",  250, 179, 0)
				elseif info.part == "25" then
					npc:SetCustomHealthLabel("#top3autumn",  250, 179, 0)
				elseif info.part == "5" then
					npc:SetCustomHealthLabel("#top10autumn",  24, 181, 29)
				elseif info.part == "4" then
					npc:SetCustomHealthLabel("#tester1",  0, 217, 7)
				elseif info.part == "8" then
					npc:SetCustomHealthLabel("#moder",  250, 0, 0)
				elseif info.part == "7" then
					npc:SetCustomHealthLabel("#dev",  200, 0, 250)
				elseif info.part == "37" then
					npc:SetCustomHealthLabel("#top1winter",  95, 89, 255)
				elseif info.part == "49" then
					npc:SetCustomHealthLabel("#top2winter",  95, 89, 255)
				elseif info.part == "50" then
					npc:SetCustomHealthLabel("#top3winter",  95, 89, 255)
				elseif info.part == "38" then
					npc:SetCustomHealthLabel("#top1spring",  24, 181, 29)
				elseif info.part == "39" then
					npc:SetCustomHealthLabel("#top2spring",  24, 181, 29)
				elseif info.part == "40" then
					npc:SetCustomHealthLabel("#top3spring",  24, 181, 29)
				elseif info.part == "41" then
					npc:SetCustomHealthLabel("#top1summer",  255, 229, 31)
				elseif info.part == "42" then
					npc:SetCustomHealthLabel("#top2summer",  255, 229, 31)
				elseif info.part == "43" then
					npc:SetCustomHealthLabel("#top3summer",  255, 229, 31)
				elseif info.part == "45" then
					npc:SetCustomHealthLabel("#top1-3patreon",  36, 233, 255)
				elseif info.part == "52" then
					npc:SetCustomHealthLabel("#top2event",  70, 130, 180)
				elseif info.part == "53" then
					npc:SetCustomHealthLabel("#top1event",  70, 130, 180)
				elseif info.part == "54" then
					npc:SetCustomHealthLabel("#top3event",  70, 130, 180)
				elseif info.part == "55" then
					npc:SetCustomHealthLabel("#top1battle",  205, 92, 92)
				elseif info.part == "56" then
					npc:SetCustomHealthLabel("#top2battle",  205, 92, 92)
				elseif info.part == "57" then
					npc:SetCustomHealthLabel("#top3battle",  205, 92, 92)
				elseif info.part == "76" then
					npc:SetCustomHealthLabel("#top1x1",  24, 181, 29)
				elseif info.part == "77" then
					npc:SetCustomHealthLabel("#top2x1",  24, 181, 29)
				elseif info.part == "78" then
					npc:SetCustomHealthLabel("#top3x1",  24, 181, 29)
				elseif info.part == "79" then
					npc:SetCustomHealthLabel("#trainer",  154, 205, 50)
				elseif info.part == "80" then
					npc:SetCustomHealthLabel("#troll10k",  243, 134, 134)
				elseif info.part == "85" then
					npc:SetCustomHealthLabel("#youtuber",  243, 161, 97)
				elseif info.part == "86" then
					npc:SetCustomHealthLabel("#top2autumn",  250, 179, 0)
				elseif info.part == "87" then
					npc:SetCustomHealthLabel("#top1cwwinter",  95, 89, 255)
				elseif info.part == "88" then
					npc:SetCustomHealthLabel("#top1cwspring",  24, 181, 29)
				elseif info.part == "89" then
					npc:SetCustomHealthLabel("#top1cwasummer",  255, 229, 31)
				elseif info.part == "90" then
					npc:SetCustomHealthLabel("#top1cwautumn",  250, 179, 0)
				end
			end
		end
	else
        PlayerResource:GetSelectedHeroEntity(info.PlayerID):RemoveModifierByName("part_mod")
	end
end

function wearables:AttachWearable(unit, modelPath)
    local wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = modelPath, DefaultAnim=animation, targetname=DoUniqueString("prop_dynamic")})
    wearable:FollowEntity(unit, true)
    unit.wearables = unit.wearables or {}
    table.insert(unit.wearables, wearable)
end

function wearables:RemoveWearables(hero)
    print('#RemoveWearables')
	local wearables = {} -- объявление локального массива на удаление
	local cur = hero:FirstMoveChild() -- получаем первый указатель над подобъект объекта hero ()
	
	while cur ~= nil do --пока наш текущий указатель не равен nil(пустота/пустой указатель)
		cur = cur:NextMovePeer() -- выбираем следующий указатель на подобъект нашего обьекта
		if cur ~= nil and cur:GetClassname() ~= "" and (cur:GetClassname() == "dota_item_wearable" or cur:GetClassname() == "prop_dynamic") then -- проверяем, елси текущий указатель не пуст, название класса не пустое, и если этот класс есть класс "dota_item_wearable", то есть надеваемые косметические предметы
			DebugPrint(cur:GetClassname())
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
function wearables:SetPart()
	local pplc = PlayerResource:GetPlayerCount()
	for i=0,pplc-1 do
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
				end
			end
		end
	end
end
	

function wearables:SelectSkin(info)
	local npc = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
    if info.offp == 0 then
		if not EVENT_START then
			SetModelVip(npc, info.part)
		end		
	else
		SetModelStandart(npc)
	end
end

function wearables:SetSkin()
	local pplc = PlayerResource:GetPlayerCount()
	for i=0,pplc-1 do
		if GameRules.SkinTower[i]["skin"] ~= nil and GameRules.SkinTower[i]["skin"]  ~= "" and PlayerResource:GetConnectionState(i) == 2 then
			local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(i))
			if PoolTable["1"][GameRules.SkinTower[i]["skin"]] ~= nil  then
				SetModelVip(PlayerResource:GetSelectedHeroEntity(i), tostring(GameRules.SkinTower[i]["skin"]))
			end
		end
	end
end

function wearables:SetWolf(PlayerID)
	if GameRules.SkinTower[PlayerID]["wolf"] ~= nil and GameRules.SkinTower[PlayerID]["wolf"]  ~= "" and PlayerResource:GetConnectionState(PlayerID) == 2 then
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(PlayerID))
		if PoolTable["1"][GameRules.SkinTower[PlayerID]["wolf"]] ~= nil  then
			local npc = PlayerResource:GetSelectedHeroEntity(PlayerID)
			SetModelVip(npc, tostring(GameRules.SkinTower[PlayerID]["wolf"]))
		end
	end
end

function wearables:SetBear(PlayerID)
	if GameRules.SkinTower[PlayerID]["bear"] ~= nil and GameRules.SkinTower[PlayerID]["bear"]  ~= "" and PlayerResource:GetConnectionState(PlayerID) == 2 then
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(PlayerID))
		if PoolTable["1"][GameRules.SkinTower[PlayerID]["bear"]] ~= nil  then
			local npc = PlayerResource:GetSelectedHeroEntity(PlayerID)
			SetModelVip(npc, tostring(GameRules.SkinTower[PlayerID]["bear"]))
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
		elseif  GameRules.SaveDefItem[event.PlayerID][1] < 4 then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][1] = GameRules.SaveDefItem[event.PlayerID][1] + 1
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
		if tonumber(event.part) >= 602 and tonumber(event.part) <= 631 then
			data.Type = "wolf"
			if GameRules.SaveDefItem[event.PlayerID][2] == nil then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][2] = 1
			elseif  GameRules.SaveDefItem[event.PlayerID][2] < 4 then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][2] = GameRules.SaveDefItem[event.PlayerID][2] + 1
			end
		elseif tonumber(event.part) >= 673 and tonumber(event.part) <= 682 then
			data.Type = "bear"
			if GameRules.SaveDefItem[event.PlayerID][3] == nil then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][3] = 1
			elseif  GameRules.SaveDefItem[event.PlayerID][3] < 4 then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][3] = GameRules.SaveDefItem[event.PlayerID][3] + 1
			end
		else
			data.Type = "skin"
			if GameRules.SaveDefItem[event.PlayerID][4] == nil then
				Shop.GetVip(data, callback)
				GameRules.SaveDefItem[event.PlayerID][4] = 1
			elseif  GameRules.SaveDefItem[event.PlayerID][4] < 4 then
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
		elseif  GameRules.SaveDefItem[event.PlayerID][5] < 30 then
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
		elseif  GameRules.SaveDefItem[event.PlayerID][10] < 4 then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][10] = GameRules.SaveDefItem[event.PlayerID][10] + 1
		end	
	end
end	


function SetModelVip(npc, num)	
		if not npc then
			return
		end
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(npc:GetPlayerOwnerID()))
		if PoolTable["1"][num] == nil  then
			return
		end
		if npc:GetUnitName() == "npc_dota_hero_lycan" then
			if num == "620" then 
				npc:SetOriginalModel("models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl")
				npc:SetModel("models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl")
				npc:SetModelScale(1)
			elseif  num == "621" then
				npc:SetOriginalModel("models/items/lycan/ultimate/sirius_curse/sirius_curse.vmdl")
				npc:SetModel("models/items/lycan/ultimate/sirius_curse/sirius_curse.vmdl")
				npc:SetModelScale(1)
			elseif  num == "622" then
				npc:SetOriginalModel("models/items/lycan/ultimate/ambry_true_form/ambry_true_form.vmdl")
				npc:SetModel("models/items/lycan/ultimate/ambry_true_form/ambry_true_form.vmdl")
				npc:SetModelScale(1)
			elseif  num == "623" then
				npc:SetOriginalModel("models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl")
				npc:SetModel("models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl")
				npc:SetModelScale(1)
			elseif  num == "624" then
				npc:SetOriginalModel("models/items/lycan/ultimate/hunter_kings_trueform/hunter_kings_trueform.vmdl")
				npc:SetModel("models/items/lycan/ultimate/hunter_kings_trueform/hunter_kings_trueform.vmdl")
				npc:SetModelScale(1)
			elseif  num == "625" then
				npc:SetOriginalModel("models/items/lycan/ultimate/alpha_trueform9/alpha_trueform9.vmdl")
				npc:SetModel("models/items/lycan/ultimate/alpha_trueform9/alpha_trueform9.vmdl")
				npc:SetModelScale(1)
			elseif  num == "626" then
				npc:SetOriginalModel("models/items/lycan/ultimate/_ascension_of_the_hallowed_beast_form/_ascension_of_the_hallowed_beast_form.vmdl")
				npc:SetModel("models/items/lycan/ultimate/_ascension_of_the_hallowed_beast_form/_ascension_of_the_hallowed_beast_form.vmdl")
				npc:SetModelScale(1)
			elseif  num == "627" then
				npc:SetOriginalModel("models/items/lycan/ultimate/frostivus2018_lycan_savage_beast_form/frostivus2018_lycan_savage_beast_form.vmdl")
				npc:SetModel("models/items/lycan/ultimate/frostivus2018_lycan_savage_beast_form/frostivus2018_lycan_savage_beast_form.vmdl")
				npc:SetModelScale(1)
			elseif  num == "628" then
				npc:SetOriginalModel("models/items/lycan/ultimate/2018_lycan_shapeshift/2018_lycan_shapeshift.vmdl")
				npc:SetModel("models/items/lycan/ultimate/2018_lycan_shapeshift/2018_lycan_shapeshift.vmdl")
				npc:SetModelScale(1)
			elseif  num == "629" then
				npc:SetOriginalModel("models/items/lycan/ultimate/mutant_exorcist_form/mutant_exorcist_form.vmdl")
				npc:SetModel("models/items/lycan/ultimate/mutant_exorcist_form/mutant_exorcist_form.vmdl")
				npc:SetModelScale(1)
			elseif  num == "630" then
				npc:SetOriginalModel("models/items/lycan/ultimate/_werewolf_samurai_wolf_form_v1/_werewolf_samurai_wolf_form_v1.vmdl")
				npc:SetModel("models/items/lycan/ultimate/_werewolf_samurai_wolf_form_v1/_werewolf_samurai_wolf_form_v1.vmdl")
				npc:SetModelScale(1)
			elseif  num == "631" then
				npc:SetOriginalModel("models/items/lycan/ultimate/watchdog_lycan_true_form/watchdog_lycan_true_form.vmdl")
				npc:SetModel("models/items/lycan/ultimate/watchdog_lycan_true_form/watchdog_lycan_true_form.vmdl")
				npc:SetModelScale(1)
			end
		elseif npc:IsTroll() and npc.bear then
			if num == "673"  then 
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/dark_wood_true_form/dark_wood_true_form.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/dark_wood_true_form/dark_wood_true_form.vmdl")
				npc.bear:SetModelScale(0.7)
			elseif num == "674" then
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/elemental_curse_set_elemental_curse_true_form/elemental_curse_set_elemental_curse_true_form.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/elemental_curse_set_elemental_curse_true_form/elemental_curse_set_elemental_curse_true_form.vmdl")
				npc.bear:SetModelScale(0.7)
			elseif num == "675" then
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/form_of_the_atniw/form_of_the_atniw.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/form_of_the_atniw/form_of_the_atniw.vmdl")
				npc.bear:SetModelScale(0.7)
			elseif num == "676" then
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/frostivus2018_lone_druid_inuit_trueform/frostivus2018_lone_druid_inuit_trueform.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/frostivus2018_lone_druid_inuit_trueform/frostivus2018_lone_druid_inuit_trueform.vmdl")
				npc.bear:SetModelScale(0.7)
			elseif num == "677" then
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/iron_claw_true_form/iron_claw_true_form.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/iron_claw_true_form/iron_claw_true_form.vmdl")
				npc.bear:SetModelScale(0.7)
			elseif num == "678" then
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/ld_enslaved_wanderer_ability_2/ld_enslaved_wanderer_ability_2.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/ld_enslaved_wanderer_ability_2/ld_enslaved_wanderer_ability_2.vmdl")
				npc.bear:SetModelScale(0.7)
			elseif num == "679" then
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/rabid_black_bear/rabid_black_bear.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/rabid_black_bear/rabid_black_bear.vmdl")
				npc.bear:SetModelScale(0.7)
			elseif num == "680" then
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/tarzan_and_kingkong_trueform/tarzan_and_kingkong_trueform.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/tarzan_and_kingkong_trueform/tarzan_and_kingkong_trueform.vmdl")
				npc.bear:SetModelScale(0.7)
			elseif num == "681" then
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/wizened_bear/wizened_bear.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/wizened_bear/wizened_bear.vmdl")
				npc.bear:SetModelScale(0.7)
			elseif num == "682" then
				npc.bear:SetOriginalModel("models/items/lone_druid/true_form/wolf_hunter_true_form/wolf_hunter_true_form.vmdl")
				npc.bear:SetModel("models/items/lone_druid/true_form/wolf_hunter_true_form/wolf_hunter_true_form.vmdl")
				npc.bear:SetModelScale(0.7)
			end
		elseif npc:IsElf() then
			if num == "601"  then 
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "602" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_melee/crystal_radiant_melee.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_radiant_melee/crystal_radiant_melee.vmdl")
				npc:SetModelScale(1)
			elseif num == "603" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_crystal.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_crystal.vmdl")
				npc:SetModelScale(1)
			elseif num == "604" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega_crystal.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega_crystal.vmdl")
				npc:SetModelScale(1)
			elseif num == "605" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged.vmdl")
				npc:SetModelScale(1)
			elseif num == "606" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "607" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_ranged/crystal_radiant_ranged.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_radiant_ranged/crystal_radiant_ranged.vmdl")
				npc:SetModelScale(1)
			elseif num == "608" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_crystal.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_crystal.vmdl")
				npc:SetModelScale(1)
			elseif num == "609" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_mega_crystal.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_mega_crystal.vmdl")
				npc:SetModelScale(1)
			elseif num == "610" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged.vmdl")
				npc:SetModelScale(1)
			elseif num == "611" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "612" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "613" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_bad_ranged/creep_bad_ranged_crystal.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_bad_ranged/creep_bad_ranged_crystal.vmdl")
				npc:SetModelScale(1)
			elseif num == "614" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_bad_ranged/creep_bad_ranged_mega_crystal.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_bad_ranged/creep_bad_ranged_mega_crystal.vmdl")
				npc:SetModelScale(1)
			elseif num == "615" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl")
				npc:SetModelScale(1)
			elseif num == "616" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_crystal.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_crystal.vmdl")
				npc:SetModelScale(1)
			elseif num == "617" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega_crystal.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega_crystal.vmdl")
				npc:SetModelScale(1)
			elseif num == "618" then
				npc:SetOriginalModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_golden.vmdl")
				npc:SetModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_golden.vmdl")
				npc:SetModelScale(1)
			elseif num == "619" then
				npc:SetOriginalModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_crimson.vmdl")
				npc:SetModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_crimson.vmdl")
				npc:SetModelScale(1)
			
			elseif num == "635" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_flagbearer_melee.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_flagbearer_melee.vmdl")
				npc:SetModelScale(1)
			elseif num == "636" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_flagbearer_melee_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_flagbearer_melee_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "637" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_ranged.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_ranged.vmdl")
				npc:SetModelScale(1)
			elseif num == "638" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_ranged_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_ranged_mega.vmdl")
				npc:SetModelScale(1)
			
			elseif num == "639" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_melee.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_melee.vmdl")
				npc:SetModelScale(1)
			elseif num == "640" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_melee_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_melee_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "641" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_ranged.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_ranged.vmdl")
				npc:SetModelScale(1)
			elseif num == "642" then
				npc:SetOriginalModel("models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_ranged_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_ranged_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "643" then
				npc:SetOriginalModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
				npc:SetModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
				npc:SetModelScale(1.2)
			elseif num == "644" then
				npc:SetOriginalModel("models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_flagbearer_melee.vmdl")
				npc:SetModel("models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_flagbearer_melee.vmdl")
				npc:SetModelScale(1)
			elseif num == "645" then
				npc:SetOriginalModel("models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_flagbearer_melee_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_flagbearer_melee_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "646" then
				npc:SetOriginalModel("models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_ranged.vmdl")
				npc:SetModel("models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_ranged.vmdl")
				npc:SetModelScale(1)
			elseif num == "647" then
				npc:SetOriginalModel("models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_ranged_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_ranged_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "648" then
				npc:SetOriginalModel("models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_flagbearer_melee.vmdl")
				npc:SetModel("models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_flagbearer_melee.vmdl")
				npc:SetModelScale(1)
			elseif num == "649" then
				npc:SetOriginalModel("models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_flagbearer_melee_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_flagbearer_melee_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "650" then
				npc:SetOriginalModel("models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_ranged.vmdl")
				npc:SetModel("models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_ranged.vmdl")
				npc:SetModelScale(1)
			elseif num == "651" then
				npc:SetOriginalModel("models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_ranged_mega.vmdl")
				npc:SetModel("models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_ranged_mega.vmdl")
				npc:SetModelScale(1)
			elseif num == "652" then
				npc:SetOriginalModel("models/creeps/pine_cone/pine_cone.vmdl")
				npc:SetModel("models/creeps/pine_cone/pine_cone.vmdl")
				npc:SetModelScale(1)
			elseif num == "653" then
				npc:SetOriginalModel("models/heroes/furion/treant.vmdl")
				npc:SetModel("models/heroes/furion/treant.vmdl")
				npc:SetModelScale(1)
			elseif num == "654" then
				npc:SetOriginalModel("models/items/furion/treant_flower_1.vmdl")
				npc:SetModel("models/items/furion/treant_flower_1.vmdl")
				npc:SetModelScale(1)
			elseif num == "655" then
				npc:SetOriginalModel("models/items/furion/treant_stump.vmdl")
				npc:SetModel("models/items/furion/treant_stump.vmdl")
				npc:SetModelScale(1)
			elseif num == "656" then
				npc:SetOriginalModel("models/items/furion/treant/abyssal_prophet_abyssal_prophet_treant/abyssal_prophet_abyssal_prophet_treant.vmdl")
				npc:SetModel("models/items/furion/treant/abyssal_prophet_abyssal_prophet_treant/abyssal_prophet_abyssal_prophet_treant.vmdl")
				npc:SetModelScale(1)
			elseif num == "657" then
				npc:SetOriginalModel("models/items/furion/treant/allfather_of_nature_treant/allfather_of_nature_treant.vmdl")
				npc:SetModel("models/items/furion/treant/allfather_of_nature_treant/allfather_of_nature_treant.vmdl")
				npc:SetModelScale(1)
			elseif num == "658" then
				npc:SetOriginalModel("models/items/furion/treant/defender_of_the_jungle_lakad_coconut/defender_of_the_jungle_lakad_coconut.vmdl")
				npc:SetModel("models/items/furion/treant/defender_of_the_jungle_lakad_coconut/defender_of_the_jungle_lakad_coconut.vmdl")
				npc:SetModelScale(1)
			elseif num == "659" then
				npc:SetOriginalModel("models/items/furion/treant/eternalseasons_treant/eternalseasons_treant.vmdl")
				npc:SetModel("models/items/furion/treant/eternalseasons_treant/eternalseasons_treant.vmdl")
				npc:SetModelScale(1)
			elseif num == "660" then
				npc:SetOriginalModel("models/items/furion/treant/father_treant/father_treant.vmdl")
				npc:SetModel("models/items/furion/treant/father_treant/father_treant.vmdl")
				npc:SetModelScale(1)
			elseif num == "661" then
				npc:SetOriginalModel("models/items/furion/treant/fungal_lord_shroomthing/fungal_lord_shroomthing.vmdl")
				npc:SetModel("models/items/furion/treant/fungal_lord_shroomthing/fungal_lord_shroomthing.vmdl")
				npc:SetModelScale(1)
			elseif num == "662" then
				npc:SetOriginalModel("models/items/furion/treant/furion_treant_nelum_red/furion_treant_nelum_red.vmdl")
				npc:SetModel("models/items/furion/treant/furion_treant_nelum_red/furion_treant_nelum_red.vmdl")
				npc:SetModelScale(1)
			elseif num == "663" then
				npc:SetOriginalModel("models/items/furion/treant/hallowed_horde/hallowed_horde.vmdl")
				npc:SetModel("models/items/furion/treant/hallowed_horde/hallowed_horde.vmdl")
				npc:SetModelScale(1)
			elseif num == "664" then
				npc:SetOriginalModel("models/items/furion/treant/np_cute_cactus_treant/np_cute_cactus_treant.vmdl")
				npc:SetModel("models/items/furion/treant/np_cute_cactus_treant/np_cute_cactus_treant.vmdl")
				npc:SetModelScale(1)
			elseif num == "665" then
				npc:SetOriginalModel("models/items/furion/treant/np_desert_traveller_treant/np_desert_traveller_treant.vmdl")
				npc:SetModel("models/items/furion/treant/np_desert_traveller_treant/np_desert_traveller_treant.vmdl")
				npc:SetModelScale(1)
			elseif num == "666" then
				npc:SetOriginalModel("models/creeps/mega_greevil/mega_greevil.vmdl")
				npc:SetModel("models/creeps/mega_greevil/mega_greevil.vmdl")
				npc:SetModelScale(1.7)
			elseif num == "667" then
				npc:SetOriginalModel("models/items/furion/treant/primeval_treant/primeval_treant.vmdl")
				npc:SetModel("models/items/furion/treant/primeval_treant/primeval_treant.vmdl")
				npc:SetModelScale(1)
			elseif num == "668" then
				npc:SetOriginalModel("models/items/furion/treant/ravenous_woodfang/ravenous_woodfang.vmdl")
				npc:SetModel("models/items/furion/treant/ravenous_woodfang/ravenous_woodfang.vmdl")
				npc:SetModelScale(1)
			elseif num == "669" then
				npc:SetOriginalModel("models/items/furion/treant/shroomling_treant/shroomling_treant.vmdl")
				npc:SetModel("models/items/furion/treant/shroomling_treant/shroomling_treant.vmdl")
				npc:SetModelScale(1)
			elseif num == "670" then
				npc:SetOriginalModel("models/items/furion/treant/supreme_gardener_treants/supreme_gardener_treants.vmdl")
				npc:SetModel("models/items/furion/treant/supreme_gardener_treants/supreme_gardener_treants.vmdl")
				npc:SetModelScale(1)
			elseif num == "671" then
				npc:SetOriginalModel("models/items/furion/treant/the_ancient_guardian_the_ancient_treants/the_ancient_guardian_the_ancient_treants.vmdl")
				npc:SetModel("models/items/furion/treant/the_ancient_guardian_the_ancient_treants/the_ancient_guardian_the_ancient_treants.vmdl")
				npc:SetModelScale(1)
			elseif num == "672" then
				npc:SetOriginalModel("models/items/furion/treant/treant_cis/treant_cis.vmdl")
				npc:SetModel("models/items/furion/treant/treant_cis/treant_cis.vmdl")
				npc:SetModelScale(1)
			elseif num == "683" then
				npc:SetOriginalModel("models/heroes/invoker/forge_spirit.vmdl")
				npc:SetModel("models/heroes/invoker/forge_spirit.vmdl")
				npc:SetModelScale(1)			
			elseif num == "684" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/arsenal_magus_forged_spirit/arsenal_magus_forged_spirit.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/arsenal_magus_forged_spirit/arsenal_magus_forged_spirit.vmdl")
				npc:SetModelScale(1)			
			elseif num == "685" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/cadenza_spirit/cadenza_spirit.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/cadenza_spirit/cadenza_spirit.vmdl")
				npc:SetModelScale(1)			
			elseif num == "686" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/covenant_of_the_depths_deep_forged/covenant_of_the_depths_deep_forged.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/covenant_of_the_depths_deep_forged/covenant_of_the_depths_deep_forged.vmdl")
				npc:SetModelScale(1)			
			elseif num == "687" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/dark_sorcerer_forge_spirit/dark_sorcerer_forge_spirit.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/dark_sorcerer_forge_spirit/dark_sorcerer_forge_spirit.vmdl")
				npc:SetModelScale(1)			
			elseif num == "688" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit.vmdl")
				npc:SetModelScale(1)			
			elseif num == "689" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit_dpc.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit_dpc.vmdl")
				npc:SetModelScale(1)			
			elseif num == "690" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/frostivus2018_invoker_keeper_of_magic_spirit/frostivus2018_invoker_keeper_of_magic_spirit.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/frostivus2018_invoker_keeper_of_magic_spirit/frostivus2018_invoker_keeper_of_magic_spirit.vmdl")
				npc:SetModelScale(1)			
			elseif num == "691" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/grievous_ingots/grievous_ingots.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/grievous_ingots/grievous_ingots.vmdl")
				npc:SetModelScale(1)			
			elseif num == "692" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/iceforged_spirit/iceforged_spirit.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/iceforged_spirit/iceforged_spirit.vmdl")
				npc:SetModelScale(1)			
			elseif num == "693" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/infernus/infernus.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/infernus/infernus.vmdl")
				npc:SetModelScale(1)			
			elseif num == "694" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/nightlord_crypt_sentinel/nightlord_crypt_sentinel.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/nightlord_crypt_sentinel/nightlord_crypt_sentinel.vmdl")
				npc:SetModelScale(1)			
			elseif num == "695" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/sempiternal_revelations_forged_spirits/sempiternal_revelations_forged_spirits.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/sempiternal_revelations_forged_spirits/sempiternal_revelations_forged_spirits.vmdl")
				npc:SetModelScale(1.2)			
			elseif num == "696" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/steampowered_magic_forge_spirit/steampowered_magic_forge_spirit.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/steampowered_magic_forge_spirit/steampowered_magic_forge_spirit.vmdl")
				npc:SetModelScale(1)			
			elseif num == "697" then
				npc:SetOriginalModel("models/items/invoker/forge_spirit/ti8_invoker_prism_forge_spirit/ti8_invoker_prism_forge_spirit.vmdl")
				npc:SetModel("models/items/invoker/forge_spirit/ti8_invoker_prism_forge_spirit/ti8_invoker_prism_forge_spirit.vmdl")
				npc:SetModelScale(1)	
			elseif num == "698" then
				npc:SetOriginalModel("models/items/wraith_king/frostivus_wraith_king/frostivus_wraith_king_skeleton.vmdl")
				npc:SetModel("models/items/wraith_king/frostivus_wraith_king/frostivus_wraith_king_skeleton.vmdl")
				npc:SetModelScale(1.2)	
			end

		end

end

function SetModelStandart(npc)	
	if npc:GetUnitName() == "npc_dota_hero_lycan" then
		npc:SetOriginalModel("models/heroes/lycan/lycan_wolf.vmdl")
		npc:SetModel("models/heroes/lycan/lycan_wolf.vmdl")
		npc:SetModelScale(1)
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
		-- SetModelStandart(npc)
	end
end

function wearables:SelectSkinWisp(info)
	local npc = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
    if info.offp == 0 then
		GameRules.SkinTower[info.PlayerID]["wisp"] = info.part
		SetModelVipWisp(npc, info.part, info.PlayerID)
	else
		GameRules.SkinTower[info.PlayerID]["wisp"] = nil
	end
end

function SetModelVipWisp(npc, num, playerID )	
	if not npc then
		return
	end
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(npc:GetPlayerOwnerID()))
	if PoolTable["1"][num] == nil  then
		return
	end
	if npc:IsElf() then
		for _, unit in ipairs(npc.units) do
			if unit and not unit:IsNull() then  
				local nameUnit = unit:GetUnitName()
				local name = "wisp"
				if string.match(nameUnit,"%a+") == "wisp" and nameUnit ~= "gold_wisp" then
					if GameRules.SkinTower[playerID][name] == "1201" then
						if string.match(GameRules.MapName, "winter") then
							wearables:RemoveWearables(unit)
							UpdateModel(unit, "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", 1.2)    
						elseif string.match(GameRules.MapName, "spring") then
							wearables:RemoveWearables(unit)
							UpdateModel(unit, "models/items/courier/serpent_warbler/serpent_warbler_flying.vmdl", 1.1)    
						elseif string.match(GameRules.MapName, "autumn") or string.match(GameRules.MapName,"halloween") then 
							wearables:RemoveWearables(unit)
							UpdateModel(unit, "models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution_flying.vmdl", 1.2)    
						elseif string.match(GameRules.MapName,"desert") then 
							wearables:RemoveWearables(unit)
							UpdateModel(unit, "models/items/courier/ig_dragon/ig_dragon_flying.vmdl", 1.2)    
						elseif string.match(GameRules.MapName, "helheim") then 
							wearables:RemoveWearables(unit)
							UpdateModel(unit, "models/items/courier/dc_demon/dc_demon_flying.vmdl", 1.2)
						elseif string.match(GameRules.MapName,"china") then 
							wearables:RemoveWearables(unit)
							UpdateModel(unit, "models/items/courier/green_jade_dragon/green_jade_dragon_flying.vmdl", 1.4) 
						elseif string.match(GameRules.MapName,"jungle") then 
							wearables:RemoveWearables(unit)
							UpdateModel(unit, "models/items/courier/deathbringer/deathbringer_flying.vmdl", 1.4)
						elseif string.match(GameRules.MapName,"ghosttown") then 
							wearables:RemoveWearables(unit)
							UpdateModel(unit, "models/items/courier/echo_wisp/echo_wisp_flying.vmdl", 1.3) 
						elseif string.match(GameRules.MapName,"summer") then 
							wearables:RemoveWearables(unit)
							UpdateModel(unit, "models/items/courier/blazing_hatchling_the_fortune_bringer_courier/blazing_hatchling_the_fortune_bringer_courier.vmdl", 1.3) 
						end
					elseif GameRules.SkinTower[playerID][name] == "1202" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", 1.2)    
					elseif GameRules.SkinTower[playerID][name] == "1203" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/items/courier/serpent_warbler/serpent_warbler_flying.vmdl", 1.1)    
					elseif GameRules.SkinTower[playerID][name] == "1204" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution_flying.vmdl", 1.2)
					elseif GameRules.SkinTower[playerID][name] == "1205" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/items/courier/ig_dragon/ig_dragon_flying.vmdl", 1.2)
					elseif GameRules.SkinTower[playerID][name] == "1206" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/items/courier/dc_demon/dc_demon_flying.vmdl", 1.2)
					elseif GameRules.SkinTower[playerID][name] == "1207" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/items/courier/green_jade_dragon/green_jade_dragon_flying.vmdl", 1.4) 
					elseif GameRules.SkinTower[playerID][name] == "1208" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/items/courier/deathbringer/deathbringer_flying.vmdl", 1.4)
					elseif GameRules.SkinTower[playerID][name] == "1209" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/items/courier/echo_wisp/echo_wisp_flying.vmdl", 1.3)
					elseif GameRules.SkinTower[playerID][name] == "1210" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/items/courier/blazing_hatchling_the_fortune_bringer_courier/blazing_hatchling_the_fortune_bringer_courier.vmdl", 1.3) 
					elseif GameRules.SkinTower[playerID][name] == "1211" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/venoling/venoling_flying.vmdl", 1) 
					elseif GameRules.SkinTower[playerID][name] == "1212" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/trapjaw/trapjaw_flying.vmdl", 1) 
					elseif GameRules.SkinTower[playerID][name] == "1213" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/smeevil_mammoth/smeevil_mammoth_flying.vmdl", 1) 
					elseif GameRules.SkinTower[playerID][name] == "1214" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/smeevil/smeevil_flying.vmdl", 1) 
					elseif GameRules.SkinTower[playerID][name] == "1215" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/seekling/seekling.vmdl", 1.3) 
					elseif GameRules.SkinTower[playerID][name] == "1216" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/minipudge/minipudge.vmdl", 1.3) 
					elseif GameRules.SkinTower[playerID][name] == "1217" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/mega_greevil_courier/mega_greevil_courier_flying.vmdl", 1) 
					elseif GameRules.SkinTower[playerID][name] == "1218" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/frog/frog_flying.vmdl", 1) 
					elseif GameRules.SkinTower[playerID][name] == "1219" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/drodo/drodo_flying.vmdl", 1) 
					elseif GameRules.SkinTower[playerID][name] == "1220" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/doom_demihero_courier/doom_demihero_courier.vmdl", 1.3) 
					elseif GameRules.SkinTower[playerID][name] == "1221" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/baby_rosh/babyroshan_winter18_flying.vmdl", 1)
					elseif GameRules.SkinTower[playerID][name] == "1222" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/baby_rosh/babyroshan_ti9_flying.vmdl", 1) 
					elseif GameRules.SkinTower[playerID][name] == "1223" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/baby_rosh/babyroshan_ti10_flying.vmdl", 1) 
					elseif GameRules.SkinTower[playerID][name] == "1224" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/baby_rosh/babyroshan_ti10_dire_flying.vmdl", 1)  
					elseif GameRules.SkinTower[playerID][name] == "1225" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", 1) 
						unit:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1226" then
						wearables:RemoveWearables(unit)
						UpdateModel(unit, "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", 1) 
						unit:SetMaterialGroup("2")
					end	
				end
			end
        end
	end
end

function SetModelVipTower(npc, num, playerID )	
	if not npc then
		return
	end
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(npc:GetPlayerOwnerID()))
	if PoolTable["1"][num] == nil  then
		return
	end
	if npc:IsElf() then
		for _, building in ipairs(npc.units) do
			if building and not building:IsNull() then  
				local name = building:GetUnitName()
				if GameRules.SkinTower[playerID][name] == "1001" then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/venomancer/venomancer_hydra_switch_color_arms/venomancer_hydra_switch_color_arms.vmdl")
					wearables:AttachWearable(building, "models/items/venomancer/venomancer_hydra_switch_color_shoulder/venomancer_hydra_switch_color_shoulder.vmdl")
					wearables:AttachWearable(building, "models/items/venomancer/venomancer_hydra_switch_color_head/venomancer_hydra_switch_color_head.vmdl")
					wearables:AttachWearable(building, "models/items/venomancer/venomancer_hydra_switch_color_tail/venomancer_hydra_switch_color_tail.vmdl") 
				elseif GameRules.SkinTower[playerID][name] == "1002" then     
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/viper/king_viper_head/king_viper_head.vmdl")
					wearables:AttachWearable(building, "models/items/viper/king_viper_back/king_viper_back.vmdl")
					wearables:AttachWearable(building, "models/items/viper/king_viper_tail/viper_king_viper_tail.vmdl")
				elseif GameRules.SkinTower[playerID][name] == "1003" then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/drow/drow_ti9_immortal_weapon/drow_ti9_immortal_weapon.vmdl")
					wearables:AttachWearable(building, "models/items/drow/mask_of_madness/mask_of_madness.vmdl")
					wearables:AttachWearable(building, "models/items/drow/frostfeather_huntress_shoulder/frostfeather_huntress_shoulder.vmdl")
					wearables:AttachWearable(building, "models/items/drow/frostfeather_huntress_misc/frostfeather_huntress_misc.vmdl")
					wearables:AttachWearable(building, "models/items/drow/ti6_immortal_cape/mesh/drow_ti6_immortal_cape.vmdl")        
					wearables:AttachWearable(building, "models/items/drow/frostfeather_huntress_arms/frostfeather_huntress_arms.vmdl")
					wearables:AttachWearable(building, "models/items/drow/frostfeather_huntress_legs/frostfeather_huntress_legs.vmdl") 
					p12 = ParticleManager:CreateParticle("particles/econ/items/drow/drow_ti6_gold/drow_ti6_ambient_gold.vpcf", 1, building)
					ParticleManager:SetParticleControlEnt(p12, 1, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true)
					elseif GameRules.SkinTower[playerID][name] == "1004" then
					--wearables:RemoveWearables(building)
					-- wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl")
					--wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl")
					-- wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl")
					--wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_back/ti6_windranger_back.vmdl")
					--wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl")
					--local p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bowstring_ambient.vpcf", 0, building)
					--ParticleManager:SetParticleControlEnt(p, 0, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true)
					-- p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bow_ambient.vpcf", 1, building)
					-- ParticleManager:SetParticleControlEnt(p, 1, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true)
					--p = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_bowstring.vpcf", 3, building)
					--ParticleManager:SetParticleControlEnt(p, 3, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true)
					
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/windrunner/windrunner_arcana/wr_arcana_cape.vmdl")
					wearables:AttachWearable(building, "models/items/windrunner/windrunner_arcana/wr_arcana_quiver.vmdl")
					wearables:AttachWearable(building, "models/items/windrunner/windrunner_arcana/wr_arcana_shoulder.vmdl")
					wearables:AttachWearable(building, "models/items/windrunner/windrunner_arcana/wr_arcana_head.vmdl")
					wearables:AttachWearable(building, "models/items/windrunner/windrunner_arcana/wr_arcana_weapon.vmdl")
					--local p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bowstring_ambient.vpcf", 0, building)
					--ParticleManager:SetParticleControlEnt(p, 0, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true)
					--  p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_bow_ambient.vpcf", 1, building)
					--  ParticleManager:SetParticleControlEnt(p, 1, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true)
					--p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_bowstring_ambient.vpcf", 3, building)
					--ParticleManager:SetParticleControlEnt(p, 3, building, PATTACH_POINT_FOLLOW, "attach_hook",  building:GetAbsOrigin(), true)
					elseif GameRules.SkinTower[playerID][name] == "1005" then
						wearables:RemoveWearables(building)
						wearables:AttachWearable(building, "models/items/ancient_apparition/ancient_apparition_frozen_evil_head/ancient_apparition_frozen_evil_head.vmdl")--"models/items/ancient_apparition/extremely_cold_shackles_tail/extremely_cold_shackles_tail.vmdl")
						wearables:AttachWearable(building, "models/items/ancient_apparition/ancient_apparition_frozen_evil_arms/ancient_apparition_frozen_evil_arms.vmdl")--"models/items/ancient_apparition/extremely_cold_shackles_shoulder/extremely_cold_shackles_shoulder.vmdl")
						wearables:AttachWearable(building, "models/items/ancient_apparition/ancient_apparition_frozen_evil_shoulder/ancient_apparition_frozen_evil_shoulder.vmdl")--"models/items/ancient_apparition/extremely_cold_shackles_head/extremely_cold_shackles_head.vmdl")
						wearables:AttachWearable(building, "models/items/ancient_apparition/ancient_apparition_frozen_evil_tail/ancient_apparition_frozen_evil_tail.vmdl")--"models/items/ancient_apparition/extremely_cold_shackles_arms/extremely_cold_shackles_arms.vmdl")    
					elseif GameRules.SkinTower[playerID][name] == "1006" then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/vengefulspirit/fallenprincess_head/fallenprincess_head.vmdl")
					wearables:AttachWearable(building, "models/items/vengefulspirit/fallenprincess_legs/fallenprincess_legs.vmdl")
					wearables:AttachWearable(building, "models/items/vengefulspirit/fallenprincess_weapon/fallenprincess_weapon.vmdl")
					wearables:AttachWearable(building, "models/items/vengefulspirit/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder.vmdl")
					
					p = ParticleManager:CreateParticle("particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder_crimson_ambient.vpcf", 1, building)
					ParticleManager:SetParticleControlEnt(p, 1, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true)
					elseif GameRules.SkinTower[playerID][name] == "1007"  then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/shadow_fiend/arms_deso/arms_deso.vmdl")
					wearables:AttachWearable(building, "models/heroes/shadow_fiend/head_arcana.vmdl")
					wearables:AttachWearable(building, "models/items/nevermore/sf_souls_tyrant_shoulder/sf_souls_tyrant_shoulder.vmdl")              
					elseif GameRules.SkinTower[playerID][name] == "1008" or (name == "tower_15_2" and GameRules.SkinTower[playerID]["tower_15_1"] == "1008")then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/nevermore/ferrum_chiroptera_head/ferrum_chiroptera_head.vmdl")
					wearables:AttachWearable(building, "models/items/nevermore/ferrum_chiroptera_shoulder/ferrum_chiroptera_shoulder.vmdl")
					wearables:AttachWearable(building, "models/items/nevermore/ferrum_chiroptera_arms/ferrum_chiroptera_arms.vmdl")
					local p = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/shadow_fiend_ambient_eyes.vpcf", 1, building)
					ParticleManager:SetParticleControlEnt(p, 1, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true)
					p = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_head_ambient.vpcf", 2, building)
					ParticleManager:SetParticleControlEnt(p, 2, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true)
					p = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_shoulder_ambient.vpcf", 3, building)
					ParticleManager:SetParticleControlEnt(p, 3, building, PATTACH_POINT_FOLLOW, "attach_hook",  building:GetAbsOrigin(), true)
					elseif GameRules.SkinTower[playerID][name] == "1009"  then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/lanaya/raiment_of_the_violet_archives_shoulder/raiment_of_the_violet_archives_shoulder.vmdl")
					wearables:AttachWearable(building, "models/items/lanaya/raiment_of_the_violet_archives_armor/raiment_of_the_violet_archives_armor.vmdl")
					wearables:AttachWearable(building, "models/items/lanaya/raiment_of_the_violet_archives_head_hood/raiment_of_the_violet_archives_head_hood.vmdl")
					elseif GameRules.SkinTower[playerID][name] == "1010"  then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/luna/luna_ti7_set_head/luna_ti7_set_head.vmdl")
					wearables:AttachWearable(building, "models/items/luna/luna_ti7_set_mount/luna_ti7_set_mount.vmdl")
					wearables:AttachWearable(building, "models/items/luna/luna_ti7_set_shoulder/luna_ti7_set_shoulder.vmdl")
					wearables:AttachWearable(building, "models/items/luna/luna_ti7_set_weapon/luna_ti7_set_weapon.vmdl")
					wearables:AttachWearable(building, "models/items/luna/luna_ti7_set_offhand/luna_ti7_set_offhand.vmdl")
					elseif GameRules.SkinTower[playerID][name] == "1011"  then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/medusa/dotaplus_medusa_weapon/dotaplus_medusa_weapon.vmdl")
					wearables:AttachWearable(building, "models/items/medusa/daughters_of_hydrophiinae/daughters_of_hydrophiinae.vmdl")
					wearables:AttachWearable(building, "models/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_immortal_tail.vmdl")
					wearables:AttachWearable(building, "models/items/medusa/dotaplas_medusa_head/dotaplas_medusa_head.vmdl")
					wearables:AttachWearable(building, "models/items/medusa/dotaplus_medusa_arms/dotaplus_medusa_arms.vmdl")
					elseif GameRules.SkinTower[playerID][name] == "1012" or name == "tower_19_1" or name == "tower_19_2" then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/enigma/tentacular_conqueror_armor/tentacular_conqueror_armor.vmdl")
					wearables:AttachWearable(building, "models/items/enigma/tentacular_conqueror_arms/tentacular_conqueror_arms.vmdl")
					wearables:AttachWearable(building, "models/items/enigma/tentacular_conqueror_head/tentacular_conqueror_head.vmdl")
					elseif GameRules.SkinTower[playerID][name] == "1013" then
					wearables:RemoveWearables(building)
					wearables:AttachWearable(building, "models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl")
					wearables:AttachWearable(building, "models/items/sniper/witch_hunter_set_shoulder/witch_hunter_set_shoulder.vmdl")
					wearables:AttachWearable(building, "models/items/sniper/witch_hunter_set_arms/witch_hunter_set_arms.vmdl")
					wearables:AttachWearable(building, "models/items/sniper/witch_hunter_set_head/witch_hunter_set_head.vmdl")
					wearables:AttachWearable(building, "models/items/sniper/witch_hunter_set_back/witch_hunter_set_back.vmdl")
					elseif GameRules.SkinTower[playerID][name] == "1014" then
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/wards/frozen_formation/frozen_formation.vmdl", 1)   
					--building:SetMaterialGroup("1") 
					elseif GameRules.SkinTower[playerID][name] == "1015" then
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/wards/sylph_ward/sylph_ward.vmdl", 1)    
					--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1016"  then 
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/wards/watcher_below_ward/watcher_below_ward.vmdl", 1)
					--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1017"  then 
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/wards/megagreevil_ward/megagreevil_ward.vmdl", 1)  
					--building:SetMaterialGroup("1")  
					elseif GameRules.SkinTower[playerID][name] == "1018"  then 
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/wards/dire_ward_eye/dire_ward_eye.vmdl", 1)   
					--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1019"  then 
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/wards/chinese_ward/chinese_ward.vmdl", 1)  
					--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1020"  then 
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/wards/stonebound_ward/stonebound_ward.vmdl", 1)
					--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1021"  then 
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/wards/monty_ward/monty_ward.vmdl", 1)
					--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1022"  then 
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/wards/gazing_idol_ward/gazing_idol_ward.vmdl", 1)  
					--building:SetMaterialGroup("1")
					
					elseif GameRules.SkinTower[playerID][name] == "1023"  then
					wearables:RemoveWearables(building)
					UpdateModel(building, "models/items/courier/throe/throe_flying.vmdl", 1)    
					elseif GameRules.SkinTower[playerID][name] == "1024"  then
					wearables:RemoveWearables(building) 
					UpdateModel(building, "models/items/courier/shagbark/shagbark_flying.vmdl", 1)    
					elseif GameRules.SkinTower[playerID][name] == "1025"  then 
					wearables:RemoveWearables(building)
					UpdateModel(building, "models/items/courier/courier_mvp_redkita/courier_mvp_redkita_flying.vmdl", 1)
					elseif GameRules.SkinTower[playerID][name] == "1026"  then 
					wearables:RemoveWearables(building)
					UpdateModel(building, "models/items/courier/defense4_dire/defense4_dire_flying.vmdl", 1)    
					elseif GameRules.SkinTower[playerID][name] == "1027" then 
					wearables:RemoveWearables(building)
					UpdateModel(building, "models/items/courier/mlg_wraith_courier/mlg_wraith_courier.vmdl", 1)   
					elseif GameRules.SkinTower[playerID][name] == "1028"  then 
					wearables:RemoveWearables(building)
					UpdateModel(building, "models/items/courier/mei_nei_rabbit/mei_nei_rabbit_flying.vmdl", 1)  
					elseif GameRules.SkinTower[playerID][name] == "1029"  then 
					wearables:RemoveWearables(building)
					UpdateModel(building, "models/items/courier/mango_the_courier/mango_the_courier_flying.vmdl", 1)
					elseif GameRules.SkinTower[playerID][name] == "1030"  then 
					wearables:RemoveWearables(building)
					UpdateModel(building, "models/items/courier/blazing_hatchling_the_fortune_bringer_courier/blazing_hatchling_the_fortune_bringer_courier_flying.vmdl", 1)
					elseif GameRules.SkinTower[playerID][name] == "1031"  then 
					wearables:RemoveWearables(building)
					UpdateModel(building, "models/items/courier/bookwyrm/bookwyrm_flying.vmdl", 1)  
					elseif GameRules.SkinTower[playerID][name] == "1032"  then
						wearables:RemoveWearables(building)
						if p12 ~= nil then
							ParticleManager:DestroyParticle(p12, false)  
						end
						wearables:AttachWearable(building, "models/items/drow/wandering_ranger_head/wandering_ranger_head.vmdl")
						wearables:AttachWearable(building, "models/items/drow/wandering_ranger_back/wandering_ranger_back.vmdl")
						wearables:AttachWearable(building, "models/items/drow/wandering_ranger_arms/wandering_ranger_arms.vmdl")
						wearables:AttachWearable(building, "models/items/drow/wandering_ranger_weapon/wandering_ranger_weapon.vmdl")
						wearables:AttachWearable(building, "models/items/drow/wandering_ranger_shoulder/wandering_ranger_shoulder.vmdl")        
						wearables:AttachWearable(building, "models/items/drow/wandering_ranger_misc/wandering_ranger_misc.vmdl")
						wearables:AttachWearable(building, "models/items/drow/wandering_ranger_legs/wandering_ranger_legs.vmdl")
						building.BountyWeapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/drow/wandering_ranger_weapon/wandering_ranger_weapon.vmdl"})
						building.BountyWeapon:FollowEntity(building, true)
						p = ParticleManager:CreateParticle("particles/econ/items/drow/drow_2022_cc/drow_2022_cc_weapon.vpcf", PATTACH_ABSORIGIN_FOLLOW, building.BountyWeapon)
						ParticleManager:SetParticleControlEnt(p, 1, building, PATTACH_POINT_FOLLOW, nil, building:GetOrigin(), true) 
						p = ParticleManager:CreateParticle("particles/econ/items/drow/drow_2022_cc/drow_2022_cc_quiver.vpcf", 2, building)
						ParticleManager:SetParticleControlEnt(p, 2, building, PATTACH_POINT_FOLLOW, "follow_origin", building:GetAbsOrigin(), true) 
				
					elseif GameRules.SkinTower[playerID][name] == "1033"  then
						wearables:RemoveWearables(building)
						wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_back/ti6_windranger_back.vmdl")
						wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl")
						wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl")
						wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl")
						wearables:AttachWearable(building, "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl")
						--   building.BountyWeapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl"})
					--    building.BountyWeapon:FollowEntity(building, true)
						--  p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bowstring_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, building.BountyWeapon)
						--  ParticleManager:SetParticleControlEnt(p, 1, building, PATTACH_POINT_FOLLOW, nil, building:GetOrigin(), true)
					elseif GameRules.SkinTower[playerID][name] == "1034"  then
						wearables:RemoveWearables(building)
						wearables:AttachWearable(building, "models/items/hoodwink/hood_2021_blossom_weapon/hood_2021_blossom_weapon.vmdl")
						wearables:AttachWearable(building, "models/items/hoodwink/hood_2021_blossom_armor/hood_2021_blossom_armor.vmdl")
						wearables:AttachWearable(building, "models/items/hoodwink/hood_2021_blossom_tail/hood_2021_blossom_tail.vmdl")
						wearables:AttachWearable(building, "models/items/hoodwink/hood_2021_blossom_back/hood_2021_blossom_back.vmdl")
					elseif GameRules.SkinTower[playerID][name] == "1035"   then
						wearables:RemoveWearables(building)
						wearables:AttachWearable(building, "models/items/clinkz/degraded_soul_hunter_weapon/degraded_soul_hunter_weapon.vmdl")
						wearables:AttachWearable(building, "models/items/clinkz/degraded_soul_hunter_shoulder/degraded_soul_hunter_shoulder.vmdl")
						wearables:AttachWearable(building, "models/items/clinkz/degraded_soul_hunter_head/degraded_soul_hunter_head.vmdl")
						wearables:AttachWearable(building, "models/items/clinkz/degraded_soul_hunter_gloves/degraded_soul_hunter_gloves.vmdl")
						wearables:AttachWearable(building, "models/items/clinkz/degraded_soul_hunter_back/degraded_soul_hunter_back.vmdl")
					elseif GameRules.SkinTower[playerID][name] == "1036"  then 
						wearables:RemoveWearables(building)
						UpdateModel(building, "models/flag_2.vmdl", 0.5)  

					elseif GameRules.SkinTower[playerID][name] == "1037"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/arcticwatchtower/arcticwatchtower.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1038"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/atlas_burden_ward/atlas_burden_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1039"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/augurys_guardian/augurys_guardian.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1040"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/chicken_hut_ward/chicken_hut_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1041"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/bane_ward/bane_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1042"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/echo_bat_ward/echo_bat_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1043"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/enchantedvision_ward/enchantedvision_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1044"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/esl_one_jagged_vision/esl_one_jagged_vision.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1045"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/esl_wardchest_radling_ward/esl_wardchest_radling_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1046"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/esl_wardchest_franglerfish/esl_wardchest_franglerfish.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1047"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/esl_wardchest_jungleworm/esl_wardchest_jungleworm.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1048"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/esl_wardchest_toadstool/esl_wardchest_toadstool.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1049"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/eye_of_avernus_ward/eye_of_avernus_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1050"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/ti8_snail_ward/ti8_snail_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1051"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/frostivus_2023_ward/frostivus_2023_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1052"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/jakiro_pyrexae_ward/jakiro_pyrexae_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1053"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/hand_2021_ward/hand_2021_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1054"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/knightstatue_ward/knightstatue_ward.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1055"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/lich_black_pool_watcher/lich_black_pool_watcher.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1056"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/revtel_jester_obs/revtel_jester_obs.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1057"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/the_monkey_sentinel/the_monkey_sentinel.vmdl", 1)
						--building:SetMaterialGroup("1")
					elseif GameRules.SkinTower[playerID][name] == "1058"  then 
						wearables:RemoveWearables(building) 
						UpdateModel(building, "models/items/wards/warding_guise/warding_guise.vmdl", 1)
						--building:SetMaterialGroup("1")
					end
			end
        end
	end
end

