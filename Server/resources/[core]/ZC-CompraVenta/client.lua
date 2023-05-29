RegisterNetEvent('okokContract:GetVehicleInfo', function(source_playername, date, description, price, source)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local closestPlayer, playerDistance = W.GetClosestPlayer()
	local sellerID = source
	target = GetPlayerServerId(closestPlayer)

	if closestPlayer ~= -1 and playerDistance <= 3.0 then
		local vehicle = W.GetClosestVehicle(coords)
		local vehiclecoords = GetEntityCoords(vehicle)
		local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)
		if DoesEntityExist(vehicle) and (vehDistance <= 3) then
			local vehProps = W.GetVehicleProperties(vehicle)

			W.TriggerCallback("okokContract:GetTargetName", function(targetName)
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'openContractSeller',
					plate = vehProps.plate,
					model = GetDisplayNameFromVehicleModel(vehProps.model),
					source_playername = source_playername,
					sourceID = sellerID,
					target_playername = targetName,
					targetID = target,
					date = date,
					description = description,
					price = price
				})
			end, target)
		else
			ClearPedTasks(PlayerPedId())
			W.Notify("Contrato",'Debes estar cerca de tu vehículo')
		end
	else
		ClearPedTasks(PlayerPedId())
		W.Notify("Contrato",'El comprador debe estar al lado tuya')
	end
end)

RegisterNetEvent('okokContract:OpenContractInfo')
AddEventHandler('okokContract:OpenContractInfo', function()
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'openContractInfo'
	})
end)

RegisterNetEvent('okokContract:OpenContractOnBuyer')
AddEventHandler('okokContract:OpenContractOnBuyer', function(data)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'openContractOnBuyer',
		plate = data.plateNumber,
		model = data.vehicleModel,
		source_playername = data.sourceName,
		sourceID = data.sourceID,
		target_playername = data.targetName,
		targetID = data.targetID,
		date = data.date,
		description = data.description,
		price = data.price
	})
end)

RegisterNUICallback("action", function(data, cb)
	if data.action == "submitContractInfo" then
		TriggerServerEvent("okokContract:SendVehicleInfo", data.vehicle_description, data.vehicle_price)
		SetNuiFocus(false, false)
	elseif data.action == "signContract1" then
		TriggerServerEvent("okokContract:SendContractToBuyer", data)
		ClearPedTasks(PlayerPedId())
		SetNuiFocus(false, false)
	elseif data.action == "signContract2" then
		TriggerServerEvent("okokContract:changeVehicleOwner", data)
		ClearPedTasks(PlayerPedId())
		SetNuiFocus(false, false)
	elseif data.action == "close" then
		ClearPedTasks(PlayerPedId())
		SetNuiFocus(false, false)
	end
end)

RegisterNetEvent('okokContract:startContractAnimation', function()
	loadAnimDict('anim@amb@nightclub@peds@')
	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, false)
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

RegisterCommand("checkcar", function ()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	if vehicle and vehicle ~= 0 then
		local OwnData = W.GetPlayerData()
		if OwnData.job and OwnData.job.name == "sandycar" and OwnData.job.duty then
			W.TriggerCallback('Wave:GetPlayersJob', function(players)
				if players and #players == 0 then
					local vehProps = W.GetVehicleProperties(vehicle)
					local engine = vehProps.modEngine
					local brakes = vehProps.modBrakes
					local transmision = vehProps.modTransmission
					local armor = vehProps.modArmor
					local suspension = vehProps.modSuspension
					local text = "Motor: "..engine.." \nFrenos: "..brakes.." \nTransmisión: "..transmision.." \nArmadura: "..armor.." \nSuspensión: "..suspension
					TriggerEvent('chat:addMessage', {args = {"Revisión del vehículo", text}, color = {200, 20, 20}})
				else
					W.Notify("Revisión", "No puedes revisar el vehículo mientras hay mecánicos")
				end
			end, 'mechanic', true)
		end
	else
		W.Notify("NOTIFICACION", "Subete a un coche")
	end
end)