local W = exports.ZCore:get()
local hasAlreadyEnteredMarker, lastZone
local currentAction, currentActionMsg, currentActionData, isInService = nil, nil, {}, false
Config.ShopsJobs = {}
Config.Blips = {}
local Machines = {}
local ActualJobCount = {}

-- local Status = {
-- 	DELIVERY_INACTIVE                 = 0,
-- 	PLAYER_STARTED_DELIVERY           = 1,
-- 	PLAYER_REACHED_VEHICLE_POINT      = 2,
-- 	PLAYER_REMOVED_GOODS_FROM_VEHICLE = 3,
-- 	PLAYER_REACHED_DELIVERY_POINT     = 4,
-- 	PLAYER_RETURNING_TO_BASE          = 5
-- }

-- -- Don't touch this, pls :)

-- local CurrentStatus             = Status.DELIVERY_INACTIVE
-- local CurrentSubtitle           = nil
local CurrentBlip               = nil
local CurrentItem               = nil
local CurrentVehicle            = nil
local keyzone = nil
-- local CurrentAttachments        = {}
-- local CurrentVehicleAttachments = {}
-- local DeliveryLocation          = {}
-- local DeliveryComplete          = {}
-- local DeliveryRoutes            = {}
local PlayerData                = nil
-- local FinishedJobs              = 0

function startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

Citizen.CreateThread(function() 
	Citizen.Wait(5000)
	
	ReqTheModel('prop_rum_bottle')
    ReqTheModel('prop_cs_shot_glass')
    ReqTheModel('p_cs_shot_glass_s')
	ReqTheModel('prop_cs_silver_tray')
	ReqTheModel('prop_ff_noodle_02')
end)

ShotsList = {}

RegisterNetEvent("rl_business:serveProp")
AddEventHandler("rl_business:serveProp", function (alcohol)
    ReqAnimDict("anim@amb@nightclub@mini@drinking@bar@player_bartender@one")
    
    --Botella Mano Derecha
    local bottleprop = CreateObject(Config.ItemShots[alcohol].object, 1.0, 1.0, 1.0, 1, 1, 0)
	local bone_right = GetPedBoneIndex(PlayerPedId(), 28422)
	
	AttachEntityToEntity(bottleprop, PlayerPedId(), bone_right, 0.10, -0.1, -0.05, 0.0, 90.0, 90.0, 1, 1, 0, 0, 2, 1)

    --Vaso de chupito Mano Izquierda
    local shotprop = CreateObject('prop_cs_shot_glass', 1.0, 1.0, 1.0, 1, 1, 0)
	local bone_left = GetPedBoneIndex(PlayerPedId(), 4089)
	
	AttachEntityToEntity(shotprop, PlayerPedId(), bone_left, 0.03, -0.04, 0.0, 185.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

    TaskPlayAnim(PlayerPedId(), "anim@amb@nightclub@mini@drinking@bar@player_bartender@one", "one_bartender", 8.0, 5.0, -1, true, 1, 0, 0, 0)
    Citizen.Wait(4400)
    local _shotcoords = GetEntityCoords(shotprop)
    DeleteObject(bottleprop)
    DeleteObject(shotprop)
    --Vaso de chupito Mano Izquierda
    local drinkprop = CreateObject('p_cs_shot_glass_s', _shotcoords, 1, 1, 0)
    Citizen.Wait(100)
    PlaceObjectOnGroundProperly_2(drinkprop)
    local drinkpropNetId = ObjToNet(drinkprop)
    Citizen.Wait(1000)
    local _shotcoords2 = GetEntityCoords(drinkprop)
    Citizen.Wait(1000)
    DeleteObject(drinkprop)
    --soltar vaso y poner encima de la encimera
    TriggerServerEvent("rl_business:SyncObjectSpawn", _shotcoords2, alcohol)
    ClearPedTasksImmediately(PlayerPedId())
end)


RegisterNetEvent('rl_business:SyncObjectSpawnCL')
AddEventHandler('rl_business:SyncObjectSpawnCL',function(newShot)
	table.insert(ShotsList, newShot)
end)

RegisterNetEvent('rl_business:SyncDelObjectSpawnCL')
AddEventHandler('rl_business:SyncDelObjectSpawnCL',function(netId)
	for i = 1, #ShotsList, 1 do
        if ShotsList[i].netId == netId then
            table.remove(ShotsList, i)
            break
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        local sleep = 1000
        local myCoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(ShotsList) do
            local distance = #(myCoords - v.coords)
            if distance < 1.5 then
                W.ShowText(vector3(v.coords.x, v.coords.y, v.coords.z + 0.1), 'Presiona ~y~E~w~ para tomar ~o~' .. v.label, 0.6, 8)

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("rl_business:SyncDelObjectSpawn", v.netId)
                    Citizen.Wait(8000)
                end
                sleep = 0
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('rl_business:drinkProp')
AddEventHandler('rl_business:drinkProp', function(netId, effectName)
	drinkShot(netId, effectName)
end)

function drinkShot(netId, effectName)
	ClearPedTasksImmediately(PlayerPedId())
    local object = NetworkGetEntityFromNetworkId(netId)
    local timeout = 100
    while timeout > 0 and not DoesEntityExist(object) do
        Citizen.Wait(50)
        timeout = timeout - 1
    end
    NetworkRequestControlOfEntity(object)
    timeout = 100
	while timeout > 0 and not NetworkHasControlOfEntity(object) do
		Wait(100)
        NetworkRequestControlOfEntity(object)
		timeout = timeout - 1
	end

    ReqAnimDict("anim@amb@nightclub@mini@drinking@bar@player_bartender@one")
    TaskPlayAnim(PlayerPedId(), "anim@amb@nightclub@mini@drinking@bar@player_bartender@one", "one_player", 8.0, 5.0, -1, true, 1, 0, 0, 0)
    Citizen.Wait(4500)
    local bone_right = GetPedBoneIndex(PlayerPedId(), 28422)
    AttachEntityToEntity(object, PlayerPedId(), bone_right, 0.0, 0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
    Citizen.Wait(3500)
    DeleteEntity(object)
    ClearPedTasksImmediately(PlayerPedId())
end

function plateEat(netId, Name)
	ClearPedTasksImmediately(PlayerPedId())
    local dictName = Config.ItemEat[Name].dict
    local animName = Config.ItemEat[Name].anim
  
    -- Request animation dictionary.
    RequestAnimDict(dictName)
    while not HasAnimDictLoaded(dictName) do
      Wait(1)
    end

	local object = NetworkGetEntityFromNetworkId(netId)
    local timeout = 100
    while timeout > 0 and not DoesEntityExist(object) do
        Citizen.Wait(50)
        timeout = timeout - 1
    end
    NetworkRequestControlOfEntity(object)
    timeout = 100
	while timeout > 0 and not NetworkHasControlOfEntity(object) do
		Wait(100)
        NetworkRequestControlOfEntity(object)
		timeout = timeout - 1
	end
  
    -- Play animation on player ped. -- prop_cs_plate_01
    local playerPed = PlayerPedId()
    TaskPlayAnim(playerPed, dictName, animName, 4.0, 4.0, -1, 51, 0.0)

	Citizen.CreateThread(function()
		while DoesEntityExist(object) do
			if not IsEntityPlayingAnim(PlayerPedId(), dictName, animName, 3) then
				TaskPlayAnim(PlayerPedId(), dictName, animName, 4.0, 4.0, -1, 51, 0.0)
			end
			Citizen.Wait(100)
		end
	end)

	local tenedorprop = CreateObject(Config.ItemEat[Name].object2, 1.0, 1.0, 1.0, 1, 1, 0)
	local bone_right = GetPedBoneIndex(PlayerPedId(), 58868)
	
	AttachEntityToEntity(tenedorprop, PlayerPedId(), bone_right, 0.0, 0.0, 0.05, 0.0, 20.0, -105.0, 1, 1, 0, 0, 2, 1)
	local bone_right = GetPedBoneIndex(PlayerPedId(), 60309)
	
	AttachEntityToEntity(object, PlayerPedId(), bone_right, 0.04, 0.05, 0.04, -20.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

	W.Progressbar("eat_something", "Comiendo..", 25000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
		local status = W.GetPlayerData().status
		W.Notify('Comida', "Has terminado de comer", "success")
		status.hunger = status.hunger + Config.ItemEat[Name].effect
		TriggerServerEvent('core:updateStatus', status)

		DeleteEntity(tenedorprop)
		DeleteEntity(object)
		-- Unload animation dictionary.
		RemoveAnimDict(dictName)
		ClearPedTasksImmediately(PlayerPedId())
    end)
end

FoodsList = {}

function DrinkProp(netId, Name)
    local object = NetworkGetEntityFromNetworkId(netId)
    local timeout = 100
    while timeout > 0 and not DoesEntityExist(object) do
        Citizen.Wait(50)
        timeout = timeout - 1
    end
    NetworkRequestControlOfEntity(object)
    timeout = 100
	while timeout > 0 and not NetworkHasControlOfEntity(object) do
		Wait(100)
        NetworkRequestControlOfEntity(object)
		timeout = timeout - 1
	end

    ReqAnimDict(Config.ItemEat[Name].dict)
    TaskPlayAnim(PlayerPedId(), Config.ItemEat[Name].dict, Config.ItemEat[Name].anim, 8.0, 5.0, -1, 49, 1, 0, 0, 0)
    local bone_right = GetPedBoneIndex(PlayerPedId(), 28422)
    AttachEntityToEntity(object, PlayerPedId(), bone_right, 0.0, 0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	Citizen.CreateThread(function()
		while DoesEntityExist(object) do
			if not IsEntityPlayingAnim(PlayerPedId(), Config.ItemEat[Name].dict, Config.ItemEat[Name].anim, 3) then
				TaskPlayAnim(PlayerPedId(), Config.ItemEat[Name].dict, Config.ItemEat[Name].anim, 8.0, 5.0, -1, 49, 1, 0, 0, 0)
			end
			Citizen.Wait(100)
		end
	end)
	Citizen.Wait(2500)
	W.Progressbar("eat_something", "Bebiendo..", 25000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
		local status = W.GetPlayerData().status
		W.Notify('Comida', "Has terminado de beber", "success")
		status.thirst = status.thirst + Config.ItemEat[Name].effect
		TriggerServerEvent('core:updateStatus', status)

		DeleteEntity(object)
		ClearPedTasksImmediately(PlayerPedId())
		RemoveAnimDict(Config.ItemEat[Name].dict)
    end)
end

RegisterNetEvent("rl_business:servePropEat")
AddEventHandler("rl_business:servePropEat", function (food)
    ReqAnimDict("amb@code_human_wander_eating_donut@female@base")
    --Bandeja
    local bandejaprop = CreateObject("prop_cs_silver_tray", 1.0, 1.0, 1.0, 1, 1, 0)
	local noodleprop = CreateObject(Config.ItemEat[food].object, 1.0, 1.0, 1.0, 1, 1, 0)
	local bone_right = GetPedBoneIndex(PlayerPedId(), 28422)
	
	AttachEntityToEntity(bandejaprop, PlayerPedId(), bone_right, 0.0, 0.0, 0.1, 40.0, 90.0, -95.0, 1, 1, 0, 0, 2, 1)
	AttachEntityToEntity(noodleprop, PlayerPedId(), bone_right, 0.0, Config.ItemEat[food].offset[1], 0.1, 40.0, 90.0, -95.0, 1, 1, 0, 0, 2, 1)

	TaskPlayAnim(PlayerPedId(), "amb@code_human_wander_eating_donut@female@base", "static", 8.0, 8.0, -1, 49, 1, 0, 0, 0)

	local noodle_place_prop = CreateObject(Config.ItemEat[food].object, 1.0, 1.0, 1.0, 0, 0, 0)
	SetEntityAlpha(noodle_place_prop, 200)
	
	local showed = false

	while true do
		if not showed then
			showed = true

			exports['ZC-HelpNotify']:open('Pulsa <strong>F<strong> para servir', 'servir_comida')
		end

		local hit, coords = RayCastGamePlayCamera(5.0)
		if hit then
			local spawnCoords = vector3(coords.x, coords.y, coords.z)
			SetEntityCoords(noodle_place_prop, spawnCoords.x, spawnCoords.y, spawnCoords.z)
			PlaceObjectOnGroundProperly_2(noodle_place_prop)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), "amb@code_human_wander_eating_donut@female@base", "static", 3) then
			TaskPlayAnim(PlayerPedId(), "amb@code_human_wander_eating_donut@female@base", "static", 8.0, 8.0, -1, 49, 1, 0, 0, 0)
		end

		if IsControlJustReleased(0,49) then
			ExecuteCommand("me Coloca " .. Config.ItemEat[food].label .. " de la bandeja en la mesa.")
			local npp = GetEntityCoords(noodle_place_prop)
			DeleteObject(noodle_place_prop)
			TriggerServerEvent("rl_business:SyncObjectSpawnEat", npp, food)
			exports['ZC-HelpNotify']:close('servir_comida')
			break
		end
		Citizen.Wait(0)
	end

	exports['ZC-HelpNotify']:close('servir_comida')
	DeleteObject(bandejaprop)
	DeleteObject(noodleprop)
    ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent('rl_business:SyncObjectSpawnCLEat')
AddEventHandler('rl_business:SyncObjectSpawnCLEat',function(newShot)
	table.insert(FoodsList, newShot)
end)

RegisterNetEvent('rl_business:SyncDelObjectSpawnCLEat')
AddEventHandler('rl_business:SyncDelObjectSpawnCLEat',function(netId)
	for i = 1, #FoodsList, 1 do
        if FoodsList[i].netId == netId then
            table.remove(FoodsList, i)
            break
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        local sleep = 1000
        local myCoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(FoodsList) do
            local distance = #(myCoords - v.coords)
            if distance < 1.5 then
				if Config.ItemEat[v.name].type == "drink" then
					W.ShowText(vector3(v.coords.x, v.coords.y, v.coords.z + 0.15), 'Presiona ~y~E~w~ para beber ~o~' .. v.label, 0.6, 8)
				else
					W.ShowText(vector3(v.coords.x, v.coords.y, v.coords.z + 0.15), 'Presiona ~y~E~w~ para comer ~o~' .. v.label, 0.6, 8)
				end
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("rl_business:SyncDelObjectSpawnEat", v.netId)
                    Citizen.Wait(8000)
                end
                sleep = 0
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('rl_business:eatProp')
AddEventHandler('rl_business:eatProp', function(netId, Name)
	if Config.ItemEat[Name].type == "drink" then
		DrinkProp(netId, Name)
	elseif Config.ItemEat[Name].type == "plate" then
		plateEat(netId, Name)
	end
end)

function RotationToDirection(rotation)

	local adjustedRotation =
	{
	  x = (math.pi / 180) * rotation.x,
	  y = (math.pi / 180) * rotation.y,
	  z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
	  x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
	  y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
	  z = math.sin(adjustedRotation.x)
	}
	return direction
  end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c
end

function ReqTheModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end

function ReqAnimDict(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(0)
	end
end