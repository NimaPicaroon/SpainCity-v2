HotwireVehicles = {}

RegisterNetEvent('hotwire:use', function(slotId)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(playerPos.x, playerPos.y, playerPos.z, 5.0) then
        local vehicle = nil

        if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 5.0, 0, 71)
		end

        if not DoesEntityExist(vehicle) then
            return
        end

        TriggerServerEvent('ZCore:removeItem', 1, { name = 'lockpick', slotId = slotId })
        RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        W.Notify('Ganzuar', 'Vas a empezar a ganzuar el vehículo, prepárate.', 'info')

        while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
            Citizen.Wait(0)
        end
        ExecuteCommand('entorno Alguien está intentando robar un coche!')

        TaskPlayAnim(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false)	
        TriggerEvent('ZC-Skillbar:startSkillbar', function(success)
            vehicle = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 5.0, 0, 71)
            local label = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
            if success then
                TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(vehicle))
                ClearPedTasksImmediately(PlayerPedId())
                SetVehicleEngineOn(vehicle, false, false)
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                ExecuteCommand('entorno Han forzado un vehículo con una ganzua. El modelo es un '..label..' y la matrícula es '..GetVehicleNumberPlateText(vehicle))
                W.Notify('Ganzua', 'Has conseguido ganzuar el vehículo.', 'verify')
            else 
                W.Notify('Ganzua', '¡Has fallado!', 'error')
                local probabilities = math.random(1, 5)
                if probabilities == 5 then
                    ExecuteCommand('entorno Han forzado un vehículo con una ganzua. El modelo es un '..label..' y la matrícula es '..GetVehicleNumberPlateText(vehicle))
                end
                ClearPedTasksImmediately(PlayerPedId())
                SetVehicleAlarm(vehicle, true)
                SetVehicleAlarmTimeLeft(vehicle, 20000)
            end
        end, 5, math.random(5, 7))
    else
        W.Notify('Ganzua', 'No hay ningún coche cerca', 'error')
    end
end)

Citizen.CreateThread(function()
    while not GlobalState.IgnoreLocks do
        Wait(500)
    end

    while true do
        local playerPed = PlayerPedId()
        local playerVeh = GetVehiclePedIsIn(playerPed)

        if DoesEntityExist(playerVeh) then
            if not GlobalState.IgnoreLocks[UtilsModule:parse(GetVehicleNumberPlateText(playerVeh))] then
                TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(playerVeh))
            end
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while not GlobalState.IgnoreLocks do
        Wait(500)
    end

    while true do
        local playerPed = PlayerPedId()
        local playerTrying = GetVehiclePedIsTryingToEnter(playerPed)
        local vehicleText = GetVehicleNumberPlateText(playerTrying)

        if playerTrying ~= 0 and not GlobalState.IgnoreLocks[UtilsModule:parse(vehicleText)] then
            local lock = GetVehicleDoorLockStatus(playerTrying)

            SetVehicleDoorsLocked(playerTrying, 2)
        end

        Citizen.Wait(0)
    end
end)