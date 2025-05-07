if Shop == nil then
	_G.Shop = class({})
end

require("donate_store/shop_data")

local dedicatedServerKey = "TESTSESADASASDASDQ412EDFDSFQ124132421ESR1241234WQSA" -- GetDedicatedServerKeyV3("1")
local MatchID = tostring(GameRules:Script_GetMatchID() or 0)
local lastSpray = {}
local lastSounds = {}
local chanceCheck = {} 			

local countCheckShop = 0

function Shop.RequestDonate(pID, steam, callback)
	if GameRules:IsCheatMode() and not GameRules.isTesting then
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		PoolTable["5"]["0"] = PlayerResource:GetSteamAccountID(pID)
		PoolTable["5"]["1"] = PlayerResource:GetSteamID(pID)
		PoolTable["0"]["0"] = "-1"
		PoolTable["0"]["1"] = "-1"
		local parts = {}
		for id = 1, 200 do
			PoolTable["1"][id] = tostring(id)
			parts[id] = "normal"
		end
		for id = 600, 1099 do
			PoolTable["1"][id] = tostring(id)
		end	
		for id = 1200, 1250 do
			PoolTable["1"][id] = tostring(id)
		end
		for id=1, #game_spells_lib.spells_list do
			PoolTable["12"][tostring(id)] = {game_spells_lib.spells_list[id][1], 1, 0}	
		end
		CustomNetTables:SetTableValue("Particles_Tabel",tostring(pID),parts)
		CustomNetTables:SetTableValue("Pets_Tabel",tostring(pID),parts)
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
		return -1 
	end
	
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	for id=1, #game_spells_lib.spells_list do
		PoolTable["12"][tostring(id)] = {game_spells_lib.spells_list[id][1], 1, 0}	
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	game_spells_lib.PLAYER_INFO[pID] = CustomNetTables:GetTableValue("Shop", tostring(pID))[12]

	local req 
	if GameRules.MapSpeed == 1 then
		req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "vip/" .. steam)
	elseif GameRules.MapSpeed == 2 then 
		req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "vip2/" .. steam)
	elseif GameRules.MapSpeed == 4 then
	    req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "vip3/" .. steam)
	end
	
	if not req then
		return
	end

	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("RequestVip ***********************************************" .. GameRules.server )
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			-- DebugPrint(res.Body)
			if countCheckShop <= 3 then
				DebugPrint("RECONNECT!!!!!!!")
				Timers:CreateTimer(60, function() 
					countCheckShop = countCheckShop + 1
					Shop.RequestDonate(pID, steam, callback)	
			    end)
			end
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)

		--DebugPrint("***********************************************")
		local status, nextCall = Error_debug.ErrorCheck(function() 
			Shop.RequestVip(obj[1], pID, steam, callback)
			Shop.RequestSounds(obj[2], pID, steam, callback)
			Shop.RequestSkin(obj[3], pID, steam, callback)
			Shop.RequestPets(obj[4], pID, steam, callback)
			Shop.RequestEvent(obj[5], pID, steam, callback)
			Shop.RequestVipDefaults(obj[6], pID, steam, callback)
			--Shop.RequestSkinDefaults(obj[7], pID, steam, callback)
			--Shop.RequestPetsDefaults(obj[8], pID, steam, callback)
			Shop.RequestBonus(obj[7], pID, steam, callback)
			Shop.RequestBPBonus(obj[8], pID, steam, callback)
			Shop.RequestBonusTroll(obj[9], pID, steam, callback)
			Shop.RequestCoint(obj[10], pID, steam, callback)
			Shop.RequestChests(obj[11], pID, steam, callback)
			Shop.RequestXP(obj[12], pID, steam, callback)
			Shop.RequestBan(obj[13], pID, steam, callback)
			Shop.RequestRewards(obj[14], pID, steam, callback)
			Shop.RequestBPplayer(obj[15], pID, steam, callback)
			Stats.RequestData(obj[16], pID)
			Stats.RequestRep(obj[17], pID)
			Shop.RequestSkill(obj[18], pID)
			Stats.RequestRating(obj[19], pID)
			Shop.RequestBPget(obj[20], pID)
			Shop.RequestAchivements(obj[21], pID)
			--Shop.RequestBP(callback)
		end)
		return obj
	end)
	
end

function Shop.RequestVip(obj, pID, steam, callback)
	local parts = {}
	--DebugPrint("RequestVip ***********************************************" .. GameRules.server )
	-- DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	PoolTable["5"]["0"] = PlayerResource:GetSteamAccountID(pID)
	PoolTable["5"]["1"] = PlayerResource:GetSteamID(pID)
	for id = 1, 90 do
		if GameRules:IsCheatMode() then 
			PoolTable["1"][id] = tostring(id)
			parts[id] = "normal"
		else
			parts[id] = "nill"
		end
		
	end
	CustomNetTables:SetTableValue("Particles_Tabel",tostring(pID),parts)
	for id=1,#obj do
		parts[obj[id].num] = "normal"
		CustomNetTables:SetTableValue("Particles_Tabel",tostring(pID),parts)
		PoolTable["1"][tostring(obj[id].num+100)] = tostring(obj[id].num+100)
		
		if tonumber(obj[id].num) == 11 then
			PoolTable["1"]["601"] = "601"
			PoolTable["1"]["620"] = "620"
			

			--Timers:CreateTimer(120, function()
				-- local msg = "<font color='#00FFFF '>"  .. tostring(PlayerResource:GetPlayerName(pID)) .. " thank you for your support!" .. "</font>"
				--fireLeftNotify(pID, false, msg, {})
			--end);
		end	
	end
	
	if GameRules:IsCheatMode() then 
		for id = 1, 200 do
			PoolTable["1"][id] = tostring(id)
		end
		for id = 600, 1099 do
			PoolTable["1"][id] = tostring(id)
		end	
		for id = 1200, 1250 do
			PoolTable["1"][id] = tostring(id)
		end
	end		

	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	return obj

end

function Shop.RequestSkin(obj, pID, steam, callback)
	
	--DebugPrint("RequestSkin ***********************************************" .. GameRules.server )
	--DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))

	for id=1,#obj do
		PoolTable["1"][tostring(obj[id].num)] = tostring(obj[id].num)
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	return obj
end

function Shop.RequestSkill(obj, pID, steam, callback)
	
	--DebugPrint("RequestSkill ***********************************************" .. GameRules.server )
	--DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	for id=1, #game_spells_lib.spells_list do
		PoolTable["12"][tostring(id)] = {game_spells_lib.spells_list[id][1], 1, 0}	
	end
	for id=1,#obj do
		for idSpell=1, #game_spells_lib.spells_list do
			if tostring(obj[id].nick) == game_spells_lib.spells_list[idSpell][1] then
				PoolTable["12"][tostring(idSpell)] = {tostring(obj[id].nick), tostring(obj[id].num), tostring(obj[id].srok)}
			end
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	game_spells_lib.PLAYER_INFO[pID] = CustomNetTables:GetTableValue("Shop", tostring(pID))[12]

	return obj
end

function Shop.GetSkill(data,callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
    data.MatchID = MatchID
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server .. "buy/")
	if not req then
		return
	end
	local encData = json.encode(data)
	--DebugPrint("**********get skill*********************")
	--DebugPrint(GameRules.server)
	--DebugPrint(encData)
	--DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		--DebugPrint("***********************************************")
		--DebugPrint(res.Body)
		--DebugPrint("Response code: " .. res.StatusCode)
		--DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			--DebugPrint("Error connecting GET GEM")
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end	

function Shop.RequestEvent(obj, pID, steam, callback)
	--DebugPrint("***********RequestEvent***********************")
	--DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	PoolTable["5"]["2"] = 0
	if #obj > 0 then
		if obj[1].srok ~= nil and #obj == 1 then
			PoolTable["5"]["2"] = obj[1].srok
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	return obj
end

function Shop.GetVip(data,callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end

	if GameRules.PlayersCount < MIN_RATING_PLAYER  then
		return
	end

	data.MatchID = MatchID
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server)
	if not req then
		return
	end
	local encData = json.encode(data)
	--DebugPrint("*********shop*************************")
	--DebugPrint(GameRules.server)
    --DebugPrint(encData)
	--DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		--DebugPrint("***********************************************")
		--DebugPrint(res.Body)
		--DebugPrint("Response code: " .. res.StatusCode)
		--DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			--DebugPrint("Error connecting GET VIP")
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		if data.TypeDonate == nil then
			Shop.RequestDonate(tonumber(data.PlayerID), data.SteamID, callback)
		end
	end)
end	


function Shop.RequestVipDefaults(obj, pID, steam, callback)
	--DebugPrint("***************RequestVipDefaults********************")
	--DeepPrintTable(obj)
	--DebugPrint("RequestVipDefaults ***********************************************")
	if #obj > 0 then
		for id=1,#obj do
			if obj[id].type ~= nil then
				GameRules.SkinTower[pID][obj[id].type] = obj[id].num
                CustomNetTables:SetTableValue("Shop_active", tostring(pID), GameRules.SkinTower[pID])
			end
		end
	end
	return obj
end

function Shop.RequestSkinDefaults(obj, pID, steam, callback)
	--DebugPrint("***********RequestSkinDefaults**********************")
	--DeepPrintTable(obj)
	--DebugPrint("RequestSkinDefaults ***********************************************")
	if #obj > 0 then
		if obj[1].num ~= nil then
		--	GameRules.SkinDefaults[pID] = tonumber(obj[1].num)
		end
	end
	return obj
end

function Shop.RequestPetsDefaults(obj, pID, steam, callback)
	--DebugPrint("*************RequestPetsDefaults****************")
	--DeepPrintTable(obj)
	--DebugPrint("RequestPetsDefaults ***********************************************")
	if #obj > 0 then
		if obj[1].num ~= nil then
			--GameRules.PetsDefaults[pID] = obj[1].num
		end
	end
	return obj
end

function Shop.RequestBonus(obj, pID, steam, callback)
	--DebugPrint("**************RequestBonus********************")
	--DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	PoolTable["3"]["0"] = "0"
	PoolTable["3"]["1"] = "none"
	if #obj > 0 then
		if obj[1].srok ~= nil then
			GameRules.BonusPercent = GameRules.BonusPercent  + 0.1
			PoolTable["3"]["0"] = 10
			PoolTable["3"]["1"] = obj[1].srok
			Timers:CreateTimer(60, function()
				local msg = "<font color='#00FFFF '>"  .. tostring(PlayerResource:GetPlayerName(pID)) .. " thanks for the rating bonus!" .. "</font>"
			--	fireLeftNotify(pID, false, msg, {})
			end);
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	return obj
end
function Shop.RequestBPBonus(obj, pID, steam, callback)
	--DebugPrint("**************RequestBPBonus********************")
	--DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	PoolTable["15"]["0"] = "none"
	if #obj > 0 then
		if obj[1].srok ~= nil then
			PoolTable["15"]["0"] = obj[1].srok
			--[[ 
			if GameRules.BonusGem[pID] ~= nil then
				GameRules.BonusGem[pID] = GameRules.BonusGem[pID] + 0.5
			else
				GameRules.BonusGem[pID] = 1.5
			end
			--]]
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	return obj
end
function Shop.RequestBonusTroll(obj, pID, steam, callback)
	--DebugPrint("************RequestBonusTroll****************")
	local tmp = 0
	--DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	PoolTable["2"]["0"] = "0"
	PoolTable["2"]["1"] = "none"
	if #obj > 0 then
		if obj[1].chance ~= nil then
			PoolTable["2"]["0"] = obj[1].chance
			PoolTable["2"]["1"] = obj[1].srok
			local roll_chance = RandomInt(0, 100)
			--[[
			if GameRules.BonusGem[pID] ~= nil then
				GameRules.BonusGem[pID] = GameRules.BonusGem[pID] + tonumber(obj[1].chance) * 0.01
			else
				GameRules.BonusGem[pID] = tonumber(obj[1].chance) * 0.01 + 1
			end
			]]
			
			if chanceCheck[pID] == nil and GameRules:GetGameTime() and GameRules:GetGameTime() < 60 then
				GameRules:SendCustomMessage("<font color='#00FFFF '>"  .. tostring(PlayerResource:GetPlayerName(pID)) .. " your chance is increased by " .. obj[1].chance .. "%. Roll: ".. roll_chance .. " </font>" ,  0, 0)
			end 
			if roll_chance <= tonumber(obj[1].chance) and PlayerResource:GetConnectionState(pID) == 2 then
				if chanceCheck[pID] == nil and GameRules:GetGameTime() and GameRules:GetGameTime() < 60 then
					GameRules:SendCustomMessage("<font color='#00FFFF '>"  .. tostring(PlayerResource:GetPlayerName(pID)) .. " you're in luck!" .. "</font>" ,  0, 0)
				end 
				table.insert(GameRules.BonusTrollIDs, {pID, obj[1].chance})
			end	
			chanceCheck[pID] = 1
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)					
end

function Shop.RequestPets(obj, pID, steam, callback)
	local parts = {}
	--DebugPrint("**************RequestPets******************")
		--DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	for id = 0, 73 do
		if GameRules:IsCheatMode() then 
			parts[id] = "normal"
		else
			parts[id] = "nill"
		end
	end
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	CustomNetTables:SetTableValue("Pets_Tabel",tostring(pID),parts)
	----DebugPrint("dateos " ..  GetSystemDate())
	
	for id=1,#obj do
		parts[obj[id].num] = "normal"
		PoolTable["1"][tostring(obj[id].num)] = tostring(obj[id].num)
		CustomNetTables:SetTableValue("Pets_Tabel",tostring(pID),parts)
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	return obj
end	

function Shop.RequestCoint(obj, pID, steam, callback)
	--DebugPrint("*****************RequestCoint*******************")
		--DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	PoolTable["0"]["0"] = "0"
	PoolTable["0"]["1"] = "0"
	if #obj > 0 then
		if obj[1].gold ~= nil then
			if obj[1].gem ~= nil then 
				PoolTable["0"]["0"] = tostring(obj[1].gold)
				PoolTable["0"]["1"] = tostring(obj[1].gem)
			end
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	return obj
end


function Shop:BuyShopItem(table, callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end

	if GameRules.FakeList[table.PlayerID] ~= nil then
		return
	end

    local steam = tostring(PlayerResource:GetSteamID(table.PlayerID))
    table.SteamID = steam
    table.MatchID = MatchID
	table.id = tostring(table.PlayerID)
	local cost = nil
	for _, reward in pairs(Shop.DonateList) do
		if reward[1] == table.Num and reward[2] == table.TypeDonate then
		    cost = reward[3]
		end
	end
	
	if cost == nil then
		return
	else
		table.Coint = cost
	end

	local req = CreateHTTPRequestScriptVM("POST",GameRules.server .. "buy/")
	local encData = json.encode(table)
	--DebugPrint("***********************************************")
	--DebugPrint(GameRules.server)
	--DebugPrint(encData)
	--DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		--DebugPrint("***********************************************")
		--DebugPrint(res.Body)
		--DebugPrint("Response code: " .. res.StatusCode)
		--DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			GameRules:SendCustomMessage("Error during purchase. Code: " .. res.StatusCode, 1, 1)
			--DebugPrint("Error during purchase.")
		else
			if GameRules:IsCheatMode() then 
				local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(table.PlayerID))
				PoolTable["1"][table.Num] = tostring(table.Num)
				CustomNetTables:SetTableValue("Shop", tostring(table.PlayerID), PoolTable)
			end
		end
		Shop.RequestDonate(tonumber(table.id), steam, callback)
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
	end)
end

function Shop:BuyOpenChests(table, callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
    local steam = tostring(PlayerResource:GetSteamID(table.PlayerID))
    table.SteamID = steam
    table.MatchID = MatchID
	table.id = tostring(table.PlayerID)
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server .. "buy/")
	local encData = json.encode(table)
	--DebugPrint("***********************************************")
	--DebugPrint(GameRules.server)
	--DebugPrint(encData)
	--DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		--DebugPrint("***********************************************")
		--DebugPrint(res.Body)
		--DebugPrint("Response code: " .. res.StatusCode)
		--DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			GameRules:SendCustomMessage("Error during purchase. Code: " .. res.StatusCode, 1, 1)
			--DebugPrint("Error during purchase.")
		else
			if GameRules:IsCheatMode() then 
				local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(table.PlayerID))
				PoolTable["1"][table.Num] = tostring(table.Num)
				CustomNetTables:SetTableValue("Shop", tostring(table.PlayerID), PoolTable)
			end
		end
		Shop.RequestDonate(tonumber(table.id), steam, callback)
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
	end)
end

function Shop.GetGem(data,callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
    data.MatchID = MatchID
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server .. "coint/")
	if not req then
		return
	end
	local encData = json.encode(data)
	--DebugPrint("***********************************************")
	--DebugPrint(GameRules.server)
	--DebugPrint(encData)
	--DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		--DebugPrint("***********************************************")
		--DebugPrint(res.Body)
		--DebugPrint("Response code: " .. res.StatusCode)
		--DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			--DebugPrint("Error connecting GET GEM")
		end
		if data.EndGame == nil then
			Shop.RequestDonate(tonumber(data.playerID), data.SteamID, callback)
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end	


function Shop.RequestChests(obj, pID, steam, callback)
	--DebugPrint("************RequestChests*******************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	PoolTable["4"] = {}
	if #obj > 0 then
		for id=1,#obj do
			PoolTable["4"][obj[id].num] = {tostring(obj[id].num), tostring(obj[id].score) }
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)		
	return obj
end

function Shop.RequestSounds(obj, pID, steam, callback)
	--DebugPrint("************RequestSounds*********************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	if #obj > 0 then
		for id=1,#obj do
			PoolTable["1"][tostring(obj[id].num)] = tostring(obj[id].num)
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)		
	return obj
end

function Shop:OpenChestAnimation(data)
	local id = data.PlayerID
	local reward = Shop:GetReward(data.chest_id, id) -- Предлагаю в этой функции возвращать выданный айди предмета
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(id), "shop_reward_request", {reward = reward})
end

function Shop:GetReward(chest_id, playerID)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
	-- Написал убогий рандом надеюсь перепишешь
	-- vladu4eg: мне нравится твоя идея. Сначала роллятся первые шмотки из списка, а потом уже дорогие шмотки. 
    print(chest_id)
    DeepPrintTable(Shop.Chests[chest_id])
	local reward_recieve = Shop.Chests[chest_id][2][1] 
	local currency = RandomInt(Shop.Chests[chest_id][2][3][1], Shop.Chests[chest_id][2][3][2])
	local data = {}
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.PlayerID = playerID
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(playerID))
--	PoolTable["4"][tostring(chest_id)] = {tostring(chest_id), tostring(chest_id.score - 1) }
--	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	if PoolTable["4"][tostring(chest_id)] == nil then
		return
	end
	
	--DebugPrint("reward_recieve " .. reward_recieve)
	for _, reward in pairs(Shop.Chests[chest_id][1]) do
		if RollPercentage(reward[2]) then
		    reward_recieve = reward[1]
			--DebugPrint("playerID " .. playerID)
			
			
			for i, v in pairs(PoolTable["1"]) do
				if tostring(reward[1]) == tostring(v) then
					reward_recieve = Shop.Chests[chest_id][2][1]
					goto continue
				end
			end
			break
		end

		::continue::
	end
	data.TypeDonate = "chests"
	data.Coint = "0"

	data.Nick = chest_id 
	data.Num = tostring(reward_recieve)
	data.id = tostring(playerID)
	
	if reward_recieve == "gold" then -- Проверка что выпала голда
		data.Gem = 0
		data.Gold = currency
		data.Num = tostring(999)
		print(currency)
	elseif reward_recieve == "gem" then -- Проверка что выпали гемы
		data.Gem = currency
		data.Gold = 0
		data.Num = tostring(999)
	elseif reward_recieve < 100 then
		data.Nick = "pet_open_" .. chest_id 
	elseif reward_recieve >= 100 and reward_recieve < 200 then
		data.Nick = "particle_open_" .. chest_id 
	elseif reward_recieve >= 600 and reward_recieve < 700 then
		data.Nick = "skin_open_" .. chest_id 
	elseif reward_recieve >= 700 and reward_recieve < 900 then
		data.Nick = "sound_open_" .. chest_id 
	end
	
	Shop:BuyOpenChests(data, callback)
	-- Тут сразу можно отправку в базу данных оформить для награды, ее айди это reward_recieve / currency это сколько голды или гемов
	return reward_recieve
end

function DonateShopIsItemBought(id, item)
	local player_shop_table = CustomNetTables:GetTableValue("Shop", tostring(id))
	if player_shop_table then
		for _, item_id in pairs(player_shop_table["1"]) do
			if tostring(item_id) == tostring(item) then
				return true
			end
		end
		return false
	end
	return false
end

-- SOUNDS ----

function Shop:SelectVO(keys)
	local sounds = {
		"801",
		"802",
		"803",
		"804",
		"805",
		"806",
		"807",
		"808",
		"809",
		"810",
		"811",
		"812",
		"813",
		"814",
		"815",
		"816",
		"817",
		"818",
		"819",
		"820",
		"821",
		"822",
		"823",
		"824",
		"825",
		"826",
		"827",
		"828",
		"829",
		"830",
		"831",
		"832",
		"833",
		"834",
		"835",
		"836",
		"837",
		"838",
		"839",
		"840",
		"841",
		"842",
		"843",
		"844",
		"845",
		"846",
		"847",
		"848",
		"849",
		"850",
		"851",
		"852",
		"853",
		"854",
		"855",
		"856",
		"857",
		"858",
		"859",
		"860",
		"861",
		"862",
		"863",
		"864",
		"865",
		"866",
		"867",
		"868",
		"869",
		"870",
		"871",
		"872",
		"873",
		"874",
		"875",
		"876",
		"877",
		"878",
		"879",
		"880",
		"881",
		"882",
		"883",
		"884",
		"885",
		"886",
		"887",

	}

	local sprays = {
		"701",
		"702",
		"703",
		"704",
		"705",
		"706",
		"707",
		"708",
		"709",
		"710",
		"711",
		"712",
		"713",
		"714",
		"715",
		"716",
		"717",
		"718",
		"719",
		"720",
		"721",
		"722",
		"723",
		"724",
	}

	local player = PlayerResource:GetPlayer(keys.PlayerID)

	if DonateShopIsItemBought(keys.PlayerID, keys.num) then
		for _,sound in pairs(sounds) do
			if tostring(keys.num) == tostring(sound) then
				if GameRules:IsCheatMode() then 
					lastSounds[keys.PlayerID] = nil
				end
				if lastSounds[keys.PlayerID] == nil or lastSounds[keys.PlayerID] + 300 < GameRules:GetGameTime() then 
					lastSounds[keys.PlayerID] = GameRules:GetGameTime()
				else
					EmitSoundOnEntityForPlayer("General.Cancel", player, keys.PlayerID)
					local timeLeftTime = math.ceil(lastSounds[keys.PlayerID] + 300 - GameRules:GetGameTime())
					SendErrorMessage(keys.PlayerID, "Sound will be available through ".. timeLeftTime .." seconds!")
					return
				end
				local chat = LoadKeyValues("scripts/chat_wheel_rewards.txt")

				local sound_name = "item_wheel_"..keys.num
				for pID=0,DOTA_MAX_TEAM_PLAYERS do
					if PlayerResource:IsValidPlayerID(pID) then
						if GameRules.Mute[pID] == nil then
							--DebugPrint(sound_name)
							local hero = PlayerResource:GetPlayer(pID)
							EmitSoundOnEntityForPlayer(sound_name, hero, pID)
							-- EmitSoundOnClient(sound_name, hero)
							--EmitSound(sound_name)
							
						end
					end
				end
				

				local chat = ""

				local chat_sounds = {
					[801] = "[1] Sound - Уху минус три",						
					[802] = "[2] Sound - Heelp",	
					[803] = "[3] Sound - Держи в курсе",						
					[804] = "[4] Sound - Пацаны Вообще Ребята",
					[805] = "[5] Sound - Где враги?",							
					[806] = "[6] Sound - Опять Работа?",
					[807] = "[7] Sound - Лох",
					[808] = "[8] Sound - Да это жестко",
					[809] = "[9] Sound - Я тут притаился",
					[810] = "[10] Sound - Вы хули тут делаете?",
					[811] = "[11] Sound - Убейте меня",
					[812] = "[12] Sound - Can you feel my heart",
					[813] = "[13] Sound - Cейчас зарежу",
					[814] = "[14] Sound - Йобаный рот этого казино",
					[815] = "[15] Sound - Dominic Toretto",
					[816] = "[16] Sound - Я вас уничтожу",
					[817] = "[17] Sound - Дед сбежал",
					[818] = "[18] Sound - Майнкрафт моя жизнь",
					[819] = "[19] Sound - Somebody once told me",
					[820] = "[20] Sound - Коно Дио да",
					[821] = "[21] Sound - Яре яре дазе",
					[822] = "[22] Sound - Это Фиаско",
					[823] = "[23] Sound - Помянем",
					[824] = "[24] Sound - Пам парам",
					[825] = "[25] Sound - Отдай сало",
					[826] = "[26] Sound - Я тебя топором",
					[827] = "[27] Sound - Крип крипочек",
					[828] = "[28] Sound - Нахуй Эту игру",
					[829] = "Sound - Мясо для ебли",
					[830] = "Sound - Rage Daertc",
					[831] = "Sound - Голосование",
					[832] = "Sound - Что вы делаете в холодильнике?",
					[833] = "[29] Sound - Народ погнали",
					[834] = "[30] Sound - Fatality",
					[835] = "Sound - О повезло, повезло",
					[836] = "[31] Sound - Балаанс",
					[837] = "Sound - Нет друг я не оправдываюсь",
					[838] = "[32] Sound - Кто пиздел?",
					[839] = "[] Sound - ",
					[840] = "[] Sound - ",
					[841] = "[] Sound - ",
					[842] = "[] Sound - ",
					[843] = "[33] Sound - Выходи отсюда[RUS]",
					[844] = "[34] Sound - Давай по новой[RUS]",
					[845] = "[35] Sound - Извини, не плачь[RUS]",
					[846] = "[36] Sound - Союз нерушимый[RUS]",
					[847] = "[37] Sound - Ля ты крыса[RUS]",
					[848] = "[38] Sound - Это бан[RUS]",
					[849] = "[39] Sound - Не твой уровень[RUS]",
					[850] = "[40] Sound - Я не могу его убить[RUS]",
					[851] = "[41] Sound - Он волшебник[RUS]",
					[852] = "[42] Sound - Нафиг я сюда пришел[RUS]",
					[853] = "[43] Sound - Лежать и отдыхать[RUS]",
					[854] = "[44] Sound - Был пацан[RUS]",
					[855] = "[45] Sound - Извини, я спать[RUS]",
					[856] = "[46] Sound - Не пробил[RUS]",
					[857] = "[47] Sound - 2 метра[RUS]",
					[858] = "[48] Sound - Учи уроки[RUS]",
					[859] = "[49] Sound - Ты попуск[RUS]",
					[860] = "[50] Sound - Малолетный[RUS]",
					[861] = "[51] Sound - Досвидания[RUS]",
					[862] = "[52] Sound - Смэрть[RUS]",
					[863] = "[53] Sound - Есть пробитие[RUS]",
					[864] = "[54] Sound - Маслина[RUS]",
					[865] = "[55] Sound - Перемещение[RUS]",
					[866] = "[56] Sound - Блядские Эльфы![RUS]",
					[867] = "[57] Sound - Вот это ситуация[RUS]",
					[868] = "[58] Sound - What is love[MUSIC]",
					[869] = "[59] Sound - Pornhub[MUSIC]",
					[870] = "[60] Sound - Skibidi dop yes[MUSIC]",
					[871] = "[61] Sound - Sad[MUSIC]",
					[872] = "[62] Sound - Baby Shark[MUSIC]",
					[873] = "[63] Sound - DEJA VU[MUSIC]",
					[874] = "[64] Sound - Oh you touch my[MUSIC]",
					[875] = "[65] Sound - Yamete kudasai[ANIME]",
					[876] = "[66] Sound - Welcome to cum zone[MUSIC]",
					[877] = "[67] Sound - Ah shit, here we go again[ENG]",
					[878] = "[68] Sound - To be continued[MUSIC]",
					[879] = "[69] Sound - GG[MUSIC]",
					[880] = "[70] Sound - Why are You Running?[ENG]",
					[881] = "[71] Sound - Look at this dude[ENG]",
					[882] = "[72] Sound - Why You Bully Me[ENG]",
					[883] = "[73] Sound - Nani??[ANIME]",
					[884] = "[74] Sound - It was at this moment[ENG]",
					[885] = "[75] Sound - Im fast as boy[ENG]",
					[886] = "[76] Sound - FBI[ENG]",
					[887] = "[77] Sound - 300 bucks[ENG]",

					
				}

				for id, chat_sound in pairs(chat_sounds) do
					if id == keys.num then
						chat = chat_sound
						break
					end
				end

				Say(PlayerResource:GetPlayer(keys.PlayerID), chat, false)

				--Say(PlayerResource:GetPlayer(keys.PlayerID), chat["item_wheel_"..keys.num], false)
			end
		end

		for _,spray in pairs(sprays) do
			if tostring(keys.num) == tostring(spray) then
				if lastSpray[keys.PlayerID] == nil or lastSpray[keys.PlayerID] + 60 < GameRules:GetGameTime() then 
					lastSpray[keys.PlayerID] = GameRules:GetGameTime()
				else
					EmitSoundOnEntityForPlayer("General.Cancel", player, keys.PlayerID)
					local timeLeftTime = math.ceil(lastSpray[keys.PlayerID] + 60 - GameRules:GetGameTime())
					SendErrorMessage(keys.PlayerID, "Spray will be available through ".. timeLeftTime .." seconds!")
					return
				end

				local spray_name = "item_wheel_"..keys.num

				local spray = ParticleManager:CreateParticle("particles/birzhapass/"..spray_name..".vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl( spray, 0, PlayerResource:GetSelectedHeroEntity(keys.PlayerID):GetOrigin() )
				ParticleManager:ReleaseParticleIndex( spray )
				PlayerResource:GetSelectedHeroEntity(keys.PlayerID):EmitSound("Spraywheel.Paint")
			end
		end
	else
		EmitSoundOnEntityForPlayer("General.Cancel", player, keys.PlayerID)
	end
end

function Shop.RequestRewards(obj, pID, steam, callback)
	--DebugPrint("************RequestRewards*********************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	PoolTable["6"]["0"] = "0"
	PoolTable["6"]["1"] = "1"
	PoolTable["6"]["2"] = "1"
	if #obj > 0 then
		PoolTable["6"]["0"] = tostring(obj[1].score)
		PoolTable["6"]["1"] = tostring(obj[1].num)
		PoolTable["6"]["2"] = tostring(obj[1].srok)
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)		
	return obj
end

function Shop:EventRewards(table, callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() or GameRules.PlayersCount < MIN_RATING_PLAYER then 
			SendErrorMessage(table.PlayerID, "error_take_reward")
			GameRules:SendCustomMessage("<font color='#00FFFF '> THIS IS NOT A RATING GAME. </font>" ,  0, 0)
			return 
		end
	end

    local steam = tostring(PlayerResource:GetSteamID(table.PlayerID))
    table.SteamID = steam
    table.MatchID = MatchID
	table.playerID = tostring(table.PlayerID)
	table.Gem = 0
	table.Gold = 0
	table.id = tostring(table.PlayerID)
	--table.Count 
	-- table.type
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server .. "postrewards/")
	local encData = json.encode(table)
	--DebugPrint("***********************************************")
	--DebugPrint(GameRules.server)
	--DebugPrint(encData)
	--DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		--DebugPrint("***********************************************")
		--DebugPrint(res.Body)
		--DebugPrint("Response code: " .. res.StatusCode)
		--DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			GameRules:SendCustomMessage("Error take rewards.. Code: " .. res.StatusCode, 1, 1)
			--DebugPrint("Error take rewards.")
		end
		Shop.RequestDonate(tonumber(table.playerID), table.SteamID, callback)
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end

function Shop.RequestXP(obj, pID, steam, callback)
	--DebugPrint("*****RequestXP**********************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	local tmp = {}
	if #obj > 0 then
		PoolTable["7"]["0"] = tostring(obj[1].gold)
	end

	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)		
	return obj
end

function Shop.RequestBP(callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "bpday")
	if not req then
		return
	end
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	--DebugPrint("***********RequestBP*********************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			--DebugPrint("Connection failed! Code: ".. res.StatusCode)
			--DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		local PoolTable = {}
		if #obj > 0 then
			for id=1,#obj do
				PoolTable[id] = {obj[id].matchID, obj[id].nick, obj[id].type, obj[id].log, obj[id].score, obj[id].typeDonate }
			end
		end
		CustomNetTables:SetTableValue("Shop", "bpday", PoolTable)		
		return obj
		
	end)
end

function Shop.RequestBPplayer(obj, pID, steam, callback)
	DebugPrint("************RequestBPplayer***********************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	PoolTable["10"]["1"] = {}
	if #obj > 0 then
	--	DebugPrintTable(obj)
		for id=1,#obj do
			PoolTable["10"]["1"][id] = {obj[id].idQuest, obj[id].count }
		end
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)			
	return obj
end

function Shop:EventBattlePass(table, callback)
	DebugPrintTable(table)
	DebugPrintTable("test!!!!!!!!!!!!!!")
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
    local steam = tostring(PlayerResource:GetSteamID(table.PlayerID))
    table.SteamID = steam
    table.MatchID = tostring(GameRules:Script_GetMatchID() or 0)
	table.playerID = tostring(table.PlayerID)
	table.Gem = 0
	table.Gold = 0
	--table.Count 
	-- table.type
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server .. "battlepass/")
	local encData = json.encode(table)
	--DebugPrint("***********************************************")
	--DebugPrint(GameRules.server)
	--DebugPrint(encData)
	--DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		--DebugPrint("***********************************************")
		--DebugPrint(res.Body)
		--DebugPrint("Response code: " .. res.StatusCode)
		--DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			GameRules:SendCustomMessage("Error take rewards.. Code: " .. res.StatusCode, 1, 1)
			--DebugPrint("Error take rewards.")
		end
		Shop.RequestDonate(tonumber(table.playerID), steam, callback)
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end

function Shop.RequestBPget(obj, pID, steam, callback)
	local parts = {}
	--DebugPrint("RequestVip ***********************************************" .. GameRules.server )
	-- DeepPrintTable(obj)
	--DebugPrint("***********************************************")
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	for id=1,#obj do
		PoolTable["14"][tostring(obj[id].num)] = tostring(obj[id].num)
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
	return obj

end


function Shop.RequestAchivements(obj, pID, steam, callback)

	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
	DebugPrint("RequestAchivements")
	--DebugPrintTable(obj)
	for id=1,#obj do
		PoolTable["17"][tostring(obj[id].num)] = tostring(obj[id].count)
	end
	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)

	return obj
end

function Shop:Statistics(table, check, callback)

	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(table.id))
	if table.type == "fps" then
		if tonumber(table.count) == 1 then
			GameRules.PlayersFPS[table.PlayerID] = true
		else
			GameRules.PlayersFPS[table.PlayerID] = false
		end
		PoolTable["5"]["4"] = tonumber(table.count)
		CustomNetTables:SetTableValue("Shop", tostring(table.PlayerID), PoolTable)
		table.part = table.count
		if check ~= 1 then
			SetDefaultStats(table)
		end
	elseif table.type == "mute" then
		if tonumber(table.count) == 1 then
			GameRules.Mute[table.PlayerID] = 1
			PoolTable["5"]["3"] = 1
			CustomNetTables:SetTableValue("Shop", tostring(table.PlayerID), PoolTable)
			table.part = table.count
			if check ~= 1 then
				SetDefaultStats(table)
			end
		else
			GameRules.Mute[table.PlayerID] = nil
			PoolTable["5"]["3"] = 0
			CustomNetTables:SetTableValue("Shop", tostring(table.PlayerID), PoolTable)
			table.part = "0"
			if check ~= 1 then
				SetDefaultStats(table)
			end
		end	
	elseif table.type == "block" then
		if tonumber(table.count) == 1 then
			GameRules.Block[table.PlayerID] = true
			PoolTable["5"]["5"] = 1
			CustomNetTables:SetTableValue("Shop", tostring(table.PlayerID), PoolTable)
			table.part = table.count
			if check ~= 1 then
				SetDefaultStats(table)
			end
		else
			GameRules.Block[table.PlayerID] = nil
			PoolTable["5"]["5"] = 0
			CustomNetTables:SetTableValue("Shop", tostring(table.PlayerID), PoolTable)
			table.part = "0"
			if check ~= 1 then
				SetDefaultStats(table)
			end
		end	
	end
end

function Shop:SetStats()
	local pplc = PlayerResource:GetPlayerCount()
	for i=0,pplc-1 do
		if GameRules.SkinTower[i]["fps"] ~= nil and GameRules.SkinTower[i]["fps"]  ~= "" and PlayerResource:GetConnectionState(i) == 2 then
			table.type = "fps"
			table.count = GameRules.SkinTower[i]["fps"]
			table.id = i
			table.PlayerID = i
			Shop:Statistics(table, 1, callback)
		end
		if GameRules.SkinTower[i]["mute"] ~= nil and GameRules.SkinTower[i]["mute"]  ~= "" and PlayerResource:GetConnectionState(i) == 2 then
			table.type = "mute"
			table.count = GameRules.SkinTower[i]["mute"]
			table.id = i
			table.PlayerID = i
			Shop:Statistics(table, 1, callback)
		end
		if GameRules.SkinTower[i]["block"] ~= nil and GameRules.SkinTower[i]["block"]  ~= "" and PlayerResource:GetConnectionState(i) == 2 then
			table.type = "block"
			table.count = GameRules.SkinTower[i]["block"]
			table.id = i
			table.PlayerID = i
			Shop:Statistics(table, 1, callback)
		end
	end
end

function SetDefaultStats(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
	local data = {}
	if event.part ~=  nil then
		data.SteamID = tostring(PlayerResource:GetSteamID(event.PlayerID))
		data.Num = tostring(event.part)
		data.TypeDonate = tostring(1)
		data.Type = event.type

		if GameRules.SaveDefItem[event.PlayerID][6] == nil then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][6] = 1
		elseif GameRules.SaveDefItem[event.PlayerID][6] < 100 then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][6] = GameRules.SaveDefItem[event.PlayerID][6] + 1
		end


		if data.Type == "fps" and GameRules.SaveDefItem[event.PlayerID][7] == nil then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][7] = 1
		elseif data.Type == "fps" and GameRules.SaveDefItem[event.PlayerID][7] < 30  then 
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][7] = GameRules.SaveDefItem[event.PlayerID][7] + 1
		elseif data.Type == "mute" and GameRules.SaveDefItem[event.PlayerID][8] == nil then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][8] = 1
		elseif data.Type == "mute" and GameRules.SaveDefItem[event.PlayerID][8] < 30  then 
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][8] = GameRules.SaveDefItem[event.PlayerID][8] + 1
		elseif data.Type == "block" and GameRules.SaveDefItem[event.PlayerID][9] == nil then
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][9] = 1
		elseif data.Type == "block" and GameRules.SaveDefItem[event.PlayerID][9] < 30  then 
			Shop.GetVip(data, callback)
			GameRules.SaveDefItem[event.PlayerID][9] = GameRules.SaveDefItem[event.PlayerID][9] + 1
		end	
	end
end		

function Shop.RequestBan(obj, pID, steam, callback)
	--DebugPrint("*********RequestBan*************************")
	if #obj > 0 then
		if obj[1].steamID == steam then
			GameRules.FakeList[pID] = 1
		end
	end
	return obj
end

