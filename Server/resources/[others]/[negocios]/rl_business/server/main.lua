W = exports.ZCore:get()
local ShopItems = {}
local ShopItemsAux = {}
local ShopOpened = {}

--Sistema de bares
ShotsList = {}
EatList = {}

exports('getConfig', function()
	return Config.ItemShots, Config.ItemEat
end)

RegisterNetEvent('rl_business:SyncDelObjectSpawn')
AddEventHandler('rl_business:SyncDelObjectSpawn',function(netId)
	local src = source
	local found = false
	for i = 1, #ShotsList, 1 do
        if ShotsList[i].netId == netId then
			TriggerClientEvent("rl_business:drinkProp", src, netId, ShotsList[i].effect)
            table.remove(ShotsList, i)
			found = true
            break
        end
    end
	if found then
		TriggerClientEvent("rl_business:SyncDelObjectSpawnCL", -1, netId)
	end
end)

RegisterNetEvent('rl_business:SyncDelObjectSpawnEat')
AddEventHandler('rl_business:SyncDelObjectSpawnEat',function(netId)
	local src = source
	local found = false
	for i = 1, #EatList, 1 do
        if EatList[i].netId == netId then
			TriggerClientEvent("rl_business:eatProp", src, netId, EatList[i].name)
            table.remove(EatList, i)
			found = true
            break
        end
    end
	if found then
		TriggerClientEvent("rl_business:SyncDelObjectSpawnCLEat", -1, netId)
	end
end)

RegisterNetEvent('rl_business:SyncObjectSpawn')
AddEventHandler('rl_business:SyncObjectSpawn',function(coords, itemname)
	local _hash = GetHashKey('p_cs_shot_glass_s')
	local netId = CreateObject(_hash, coords, true, true, false)
	while not DoesEntityExist(netId) do
		Citizen.Wait(100)
	end
	local netIdObj = NetworkGetNetworkIdFromEntity(netId)
	table.insert(ShotsList, {
		netId = netIdObj,
		label = Config.ItemShots[itemname].label,
		effect = Config.ItemShots[itemname].effect,
		coords = coords
	})
	TriggerClientEvent("rl_business:SyncObjectSpawnCL", -1, {
		netId = netIdObj,
		label = Config.ItemShots[itemname].label,
		effect = Config.ItemShots[itemname].effect,
		coords = coords
	})
end)

RegisterNetEvent('rl_business:SyncObjectSpawnEat')
AddEventHandler('rl_business:SyncObjectSpawnEat',function(coords, itemname)
	local _hash = GetHashKey(Config.ItemEat[itemname].object)
	local netId = CreateObject(_hash, coords, true, true, false)
	while not DoesEntityExist(netId) do
		Citizen.Wait(100)
	end
	local netIdObj = NetworkGetNetworkIdFromEntity(netId)
	table.insert(EatList, {
		netId = netIdObj,
		name = itemname,
		label = Config.ItemEat[itemname].label,
		effect = Config.ItemEat[itemname].effect,
		coords = coords
	})
	TriggerClientEvent("rl_business:SyncObjectSpawnCLEat", -1, {
		netId = netIdObj,
		name = itemname,
		label = Config.ItemEat[itemname].label,
		effect = Config.ItemEat[itemname].effect,
		coords = coords
	})
end)

--Limpieza de caches
AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		print("Limpiando Shots")
		for k,v in pairs(ShotsList) do
			DeleteEntity(NetworkGetEntityFromNetworkId(v.netId))
		end
	end
end)

--Limpieza de caches
AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		print("Limpiando Shots")
		for k,v in pairs(EatList) do
			DeleteEntity(NetworkGetEntityFromNetworkId(v.netId))
		end
	end
end)