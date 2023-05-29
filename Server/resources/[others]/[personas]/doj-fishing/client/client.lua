
local W = exports.ZCore:get()
local fishing = false
local pause = false
local pausetimer = 0
local correct = 0
local genderNum = 0
local peds = {} 

CreateThread(function()
	while true do
		Wait(1200)
		if pause and fishing then
			pausetimer = pausetimer + 1
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1)
		if fishing then
			if IsControlJustReleased(0, 46) then
				input = 1
			end

			if IsControlJustReleased(0, Config.StopFishing) then
				endFishing()
				W.Notify('Pesca', "Has dejado de pescar", "error")
			end

			if fishing then
				playerPed = PlayerPedId()
				local pos = GetEntityCoords(playerPed)
				if GetWaterHeight(pos.x, pos.y, pos.z-2, pos.z -3.0)  then
				else
					endFishing()
					W.Notify('Pesca', "El agua no es lo suficientemente profunda para pescar", "error")
				end
				if IsEntityDead(playerPed) or IsEntityInWater(playerPed) then
					endFishing()
					W.Notify('Pesca', "Pesca finalizada", "error")
				end
			end
			
			if pausetimer > 3 then
				input = 99
			end
			
			if pause and input ~= 0 then
				pause = false
				if input == correct then
					TriggerEvent('fishing:SkillBar')
				else
					W.Notify('Pesca', "El pez escapó!", "error")
					loseBait()
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		local wait = math.random(Config.FishingWaitTime.minTime , Config.FishingWaitTime.maxTime)
		Wait(wait)
		if fishing then
			hidded = false
			pause = true
			correct = 1
			input = 0
			pausetimer = 0
		end
	end
end)

CreateThread(function()
	while true do
		Wait(500)
		for k = 1, #Config.PedList, 1 do
			v = Config.PedList[k]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - v.coords)

			if dist < 50.0 and not peds[k] then
				local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
				peds[k] = {ped = ped}
			end

			if dist >= 50.0 and peds[k] then
				for i = 255, 0, -51 do
					Wait(50)
					SetEntityAlpha(peds[k].ped, i, false)
				end
				DeletePed(peds[k].ped)
				peds[k] = nil
			end
		end
	end
end)

RegisterNetEvent('fishing:SkillBar', function(message)
	local Skillbar = exports['skillbar']:GetSkillbarObject()
	Skillbar.Start({
		duration = math.random(2500,5000),
		pos = math.random(10, 30),
		width = math.random(10, 20),
	}, function()
		catchAnimation()
	end, function()
		W.Notify('Pesca', "El pez escapó!", "error")
		loseBait()
	end)
end) 

RegisterNetEvent('fishing:client:spawnFish', function(args)
	local time = 10000
	local args = tonumber(args)
	if args == 1 then 
		RequestTheModel("A_C_KillerWhale")
		local pos = GetEntityCoords(PlayerPedId())
		local ped = CreatePed(29, `A_C_KillerWhale`, pos.x, pos.y, pos.z, 90.0, true, false)
		SetEntityHealth(ped, 0)
		DecorSetInt(ped, "propHack", 74)
		SetModelAsNoLongerNeeded(`A_C_KillerWhale`)
		Wait(time)
		DeletePed(ped)	
	elseif args == 2 then 
		RequestTheModel("A_C_dolphin")
		local pos = GetEntityCoords(PlayerPedId())
		local ped = CreatePed(29, `A_C_dolphin`, pos.x, pos.y, pos.z, 90.0, true, false)
		SetEntityHealth(ped, 0)
		DecorSetInt(ped, "propHack", 74)
		SetModelAsNoLongerNeeded(`A_C_dolphin`)
		Wait(time)
		DeletePed(ped)
	elseif args == 3 then
		RequestTheModel("A_C_sharkhammer")
		local pos = GetEntityCoords(PlayerPedId())
		local ped = CreatePed(29, `A_C_sharkhammer`, pos.x, pos.y, pos.z, 90.0, true, false)
		SetEntityHealth(ped, 0)
		DecorSetInt(ped, "propHack", 74)
		SetModelAsNoLongerNeeded(`A_C_sharkhammer`)
		Wait(time)
		DeletePed(ped)
	elseif args == 4 then
		RequestTheModel("A_C_SharkTiger")
		local pos = GetEntityCoords(PlayerPedId())
		local ped = CreatePed(29, `A_C_SharkTiger`, pos.x, pos.y, pos.z, 90.0, true, false)
		SetEntityHealth(ped, 0)
		DecorSetInt(ped, "propHack", 74)
		SetModelAsNoLongerNeeded(`A_C_SharkTiger`)
		Wait(time)
		DeletePed(ped)
	elseif args == 5 then
		RequestTheModel("A_C_stingray")
		local pos = GetEntityCoords(PlayerPedId())
		local ped = CreatePed(29, `A_C_stingray`, pos.x, pos.y, pos.z, 90.0, true, false)
		SetEntityHealth(ped, 0)
		DecorSetInt(ped, "propHack", 74)
		SetModelAsNoLongerNeeded(`A_C_stingray`)
		Wait(time)
		DeletePed(ped)
	else
		RequestTheModel("a_c_fish")
		local pos = GetEntityCoords(PlayerPedId())
		local ped = CreatePed(29, `a_c_fish`, pos.x, pos.y, pos.z, 90.0, true, false)
		SetEntityHealth(ped, 0)
		DecorSetInt(ped, "propHack", 74)
		SetModelAsNoLongerNeeded(`a_c_fish`)
		Wait(time)
		DeletePed(ped)
	end
end)

RegisterNetEvent('fishing:fishstart', function()
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(playerPed) 
	if IsPedSwimming(playerPed) then 
		return
		W.Notify('Pesca', "No puedes estar nadando y pescando al mismo tiempo.", "error")
	end 
	if IsPedInAnyVehicle(playerPed) then 
		return 
		W.Notify('Pesca', "Debe salir de su vehículo para comenzar a pescar.", "error")
	end 
	if GetWaterHeight(pos.x, pos.y, pos.z-2, pos.z - 3.0) then
		local time = 1000
		W.Notify('Pesca', "Usando caña de pescar", "error")
		Wait(time)
		W.Notify('Pesca', "Presiona [X] para parar de pescar!", "info")
		fishAnimation()
	else
		W.Notify('Pesca', "Tienes que ir más cerca de la orilla", "error")
	end
end, false)

RegisterNetEvent('doj:client:ReturnBoat', function(args)
	local ped = PlayerPedId()
	local args = tonumber(args)

	if IsPedInAnyVehicle(ped) then
		if args == 1 then 
			local boat = GetVehiclePedIsIn(ped,true) 
			DeleteEntity(boat)
			SetEntityCoords(ped, Config.PlayerReturnLocation.LaPuerta.x, Config.PlayerReturnLocation.LaPuerta.y, Config.PlayerReturnLocation.LaPuerta.z, 0, 0, 0, false) 
			SetEntityHeading(ped, Config.PlayerReturnLocation.LaPuerta.w)
			TriggerServerEvent('fishing:server:returnDeposit')
		elseif args == 2 then
			local boat = GetVehiclePedIsIn(ped,true) 
			DeleteEntity(boat)
			SetEntityCoords(ped, Config.PlayerReturnLocation.PaletoCove.x, Config.PlayerReturnLocation.PaletoCove.y, Config.PlayerReturnLocation.PaletoCove.z, 0, 0, 0, false) 
			SetEntityHeading(ped, Config.PlayerReturnLocation.PaletoCove.w)
			TriggerServerEvent('fishing:server:returnDeposit')
		elseif args == 3 then
			local boat = GetVehiclePedIsIn(ped,true) 
			DeleteEntity(boat)
			SetEntityCoords(ped, Config.PlayerReturnLocation.ElGordo.x, Config.PlayerReturnLocation.ElGordo.y, Config.PlayerReturnLocation.ElGordo.z, 0, 0, 0, false) 
			SetEntityHeading(ped, Config.PlayerReturnLocation.ElGordo.w)
			TriggerServerEvent('fishing:server:returnDeposit')
		elseif args == 3 then
			local boat = GetVehiclePedIsIn(ped,true) 
			DeleteEntity(boat)
			SetEntityCoords(ped, Config.PlayerReturnLocation.ActDam.x, Config.PlayerReturnLocation.ActDam.y, Config.PlayerReturnLocation.ActDam.z, 0, 0, 0, false) 
			SetEntityHeading(ped, Config.PlayerReturnLocation.ActDam.w)
			TriggerServerEvent('fishing:server:returnDeposit')
		else
			local boat = GetVehiclePedIsIn(ped,true) 
			DeleteEntity(boat)
			SetEntityCoords(ped, Config.PlayerReturnLocation.AlamoSea.x, Config.PlayerReturnLocation.AlamoSea.y, Config.PlayerReturnLocation.AlamoSea.z, 0, 0, 0, false) 
			SetEntityHeading(ped, Config.PlayerReturnLocation.AlamoSea.w)
			TriggerServerEvent('fishing:server:returnDeposit')
		end
	end
end)

function TestSpawnVehicle(model, cb, coords, isnetworked, teleportInto)
    local ped = PlayerPedId()
    model = type(model) == 'string' and GetHashKey(model) or model
    if not IsModelInCdimage(model) then return end
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    isnetworked = isnetworked == nil or isnetworked
    RequestModel(model)

	while not HasModelLoaded(model) do
		Wait(500)
	end

    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, isnetworked, false)
    local netid = NetworkGetNetworkIdFromEntity(veh)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, 'OFF')
    SetVehicleFuelLevel(veh, 100.0)
    SetModelAsNoLongerNeeded(model)
    if teleportInto then TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1) end
    if cb then cb(veh) end
end

RegisterNetEvent('doj:client:rentaBoat', function(args)
	local args = tonumber(args)
	local chance = math.random(1, 20)

	W.TriggerCallback('fishing:server:checkMoney', function(isSuccess)
		if isSuccess then 
			if chance == 10 then
				TriggerServerEvent("fishing:server:addTackleBox")
			end
			if args == 1 then 
				TestSpawnVehicle(Config.RentalBoat, function(boat)
					SetVehicleNumberPlateText(boat, "Rent-a-Boat")
					exports['LegacyFuel']:SetFuel(boat, 100.0)
					SetEntityHeading(boat, Config.BoatSpawnLocation.LaPuerta.w)
					TaskWarpPedIntoVehicle(PlayerPedId(), boat, -1)
					SetVehicleEngineOn(boat, true, true)
				end, Config.BoatSpawnLocation.LaPuerta, true) 
			elseif args == 2 then 
				TestSpawnVehicle(Config.RentalBoat, function(boat)
					SetVehicleNumberPlateText(boat, "Rent-a-Boat")
					exports['LegacyFuel']:SetFuel(boat, 100.0)
					SetEntityHeading(boat, Config.BoatSpawnLocation.PaletoCove.w)
					TaskWarpPedIntoVehicle(PlayerPedId(), boat, -1)
					SetVehicleEngineOn(boat, true, true)
				end, Config.BoatSpawnLocation.PaletoCove, true) 
			elseif args == 3 then 
				TestSpawnVehicle(Config.RentalBoat, function(boat)
					SetVehicleNumberPlateText(boat, "Rent-a-Boat")
					exports['LegacyFuel']:SetFuel(boat, 100.0)
					SetEntityHeading(boat, Config.BoatSpawnLocation.ElGordo.w)
					TaskWarpPedIntoVehicle(PlayerPedId(), boat, -1)
					SetVehicleEngineOn(boat, true, true)
				end, Config.BoatSpawnLocation.ElGordo, true) 
			elseif args == 3 then
				TestSpawnVehicle(Config.RentalBoat, function(boat)
					SetVehicleNumberPlateText(boat, "Rent-a-Boat")
					exports['LegacyFuel']:SetFuel(boat, 100.0)
					SetEntityHeading(boat, Config.BoatSpawnLocation.ActDam.w)
					TaskWarpPedIntoVehicle(PlayerPedId(), boat, -1)
					SetVehicleEngineOn(boat, true, true)
				end, Config.BoatSpawnLocation.ActDam, true) 
			else
				TestSpawnVehicle(Config.RentalBoat, function(boat)
					SetVehicleNumberPlateText(boat, "Rent-a-Boat")
					exports['LegacyFuel']:SetFuel(boat, 100.0)
					SetEntityHeading(boat, Config.BoatSpawnLocation.AlamoSea.w)
					TaskWarpPedIntoVehicle(PlayerPedId(), boat, -1)
					SetVehicleEngineOn(boat, true, true)
				end, Config.BoatSpawnLocation.AlamoSea, true) 
			end  
		end
	end)
end)

RegisterNetEvent('fishing:client:anchor', function()
    local currVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    if currVeh ~= 0 then
        local vehModel = GetEntityModel(currVeh)
        if vehModel ~= nil and vehModel ~= 0 then
            if DoesEntityExist(currVeh) then
                if IsThisModelABoat(vehModel) or IsThisModelAJetski(vehModel) or IsThisModelAnAmphibiousCar(vehModel) or IsThisModelAnAmphibiousQuadbike(vehModel) then
                    if IsBoatAnchoredAndFrozen(currVeh) then
						W.Notify('Pesca', "Retirando ancla", "success")
                        Wait(2000)
						W.Notify('Pesca', "Ancla deshabilitada", "info")
                        SetBoatAnchor(currVeh, false)
                        SetBoatFrozenWhenAnchored(currVeh, false)
                        SetForcedBoatLocationWhenAnchored(currVeh, false)
                    elseif not IsBoatAnchoredAndFrozen(currVeh) and CanAnchorBoatHere(currVeh) and GetEntitySpeed(currVeh) < 3 then
                        SetEntityAsMissionEntity(currVeh,false,true)
						W.Notify('Pesca', "Echando ancla", "info")
                        Wait(2000)
						W.Notify('Pesca', "Ancla habilitada", "info")
                        SetBoatAnchor(currVeh, true)
                        SetBoatFrozenWhenAnchored(currVeh, true)
                        SetForcedBoatLocationWhenAnchored(currVeh, true)
                    end
                end
            end
        end
    end
end)

loseBait = function()
	local chance = math.random(1, 15)
	if chance <= 5 then
		TriggerServerEvent("fishing:server:removeFishingBait")
		loseBaitAnimation()
	end
end

loseBaitAnimation = function()
	local ped = PlayerPedId()
	local animDict = "gestures@f@standing@casual"
	local animName = "gesture_damn"
	DeleteEntity(rodHandle)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(100)
	end
	TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, 1.0, 0, 0, 0, 48, 0)
	RemoveAnimDict(animDict)
	W.Notify('Pesca', "El pez mordió tu anzuelo!", "success")
	Wait(2000)
	fishAnimation()
end

RequestTheModel = function(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end

catchAnimation = function()
	local ped = PlayerPedId()
	local animDict = "mini@tennis"
	local animName = "forehand_ts_md_far"

    local luck = math.random(1, 300)
	local catch = true

	if ( luck >= 290 and luck <= 300) or ( luck >= 200 and luck <= 270) then
		W.Notify('Pesca', "Has pescado una especie en peligro de extinción! Presiona [G] para soltarla o [F] para capturarla", "primary",6000)			
		local timeFish = 1 
		local press = false
		Wait(1)
		while not press  do
			if IsControlJustReleased(0, 23) then
				press=true
			end

			if IsControlJustReleased(0, 47) then
				W.Notify('Pesca', "Has soltado la especie exótica", "primary",5000)
				press = true
				catch = false
			end

			if timeFish == 1300 then
				W.Notify('Pesca', "Has soltado la especie exótica", "primary",5000)
				catch = false
				press = true
			end

			timeFish = timeFish + 1
			Wait(1)
		end
	end

	DeleteEntity(rodHandle)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(100)
	end
	TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, 1.0, 0, 0, 0, 48, 0)

	if catch then	
		local time = 1750	
		W.Notify('Pesca', "Pescado capturado!", "success")
		Wait(time)		
		TriggerServerEvent('fishing:server:catch',luck) 
		loseBait()
	end

	PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	RemoveAnimDict(animDict)
	endFishing()
end

fishAnimation = function()
	local have, item = W.HaveItem("fishbait")

	if have <= 0 then
		endFishing()
		return W.Notify('Pesca', 'No tienes ningún cebo de pesca', 'error')
	end

	local ped = PlayerPedId()
	local animDict = "amb@world_human_stand_fishing@idle_a"
	local animName = "idle_c"
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(100)
	end
	TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)
	fishingRodEntity()
	fishing = true
	Wait(3700)
end

fishingRodEntity = function()
	local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)
	local fishingRodHash = `prop_fishing_rod_01`
	local bone = GetPedBoneIndex(ped, 18905)
    rodHandle = CreateObject(fishingRodHash, pedPos, true)
    AttachEntityToEntity(rodHandle, ped, bone, 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
end

endFishing = function() 
	local ped = PlayerPedId()
    if rodHandle ~= 0 then
		DeleteObject(rodHandle)
		ClearPedTasks(ped)
		fishing = false
		rodHandle = 0
    end
end

nearPed = function(model, coords, heading, gender, animDict, animName, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Wait(1)
	end

	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		print("No gender provided! Check your configuration!")
	end	

	ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
	SetEntityAlpha(ped, 0, false)

	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) 
	end
	for i = 0, 255, 51 do
		Wait(50)
		SetEntityAlpha(ped, i, false)
	end

	return ped
end