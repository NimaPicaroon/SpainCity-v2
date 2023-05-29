MotelController = setmetatable({ }, MotelController)
MotelController._variables = {
    _promise = promise.new(),
    _motels = {},
    _ped = nil,
    _pos = nil,
    _data = nil,
    _closest = nil,
    _closestRoom = nil,
    _closestDoor = nil,
    _showing = false
}


RegisterKeyMapping('carlock', 'Cerrar/Abrir tu vehículo', 'keyboard', 'U')

RegisterCommand("carlock", function ()
    local dict = "anim@mp_player_intmenu@key_fob@"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = W.GetClosestEntity(W.GetVehicles(), false, coords)
    local distanceToVeh = #(GetEntityCoords(vehicle) - coords)
    if vehicle > 0 and distanceToVeh <= 4 then
        local plate = GetVehicleNumberPlateText(vehicle)
        plate = plate:gsub("%s+", "")
        local haveTheKeys = exports["ZC-VehicleShop"]:HaveKeys(plate)

        if haveTheKeys then
            local label = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local lockStatus = GetVehicleDoorLockStatus(vehicle)
            if lockStatus == 1 or lockStatus == 0 then
                SetVehicleDoorsLocked(vehicle, 2)
                SetVehicleDoorsLocked(vehicle, 6)
                PlayVehicleDoorCloseSound(vehicle, 1)
                SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                W.Notify('MANDO REMOTO', 'Has ~r~cerrado~w~ tu ~y~'..label)
            elseif lockStatus == 2 or lockStatus == 6 then
                SetVehicleDoorsLocked(vehicle, 1)
                PlayVehicleDoorOpenSound(vehicle, 0)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                W.Notify('MANDO REMOTO', 'Has ~g~abierto~w~ tu ~y~'..label)
            end
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
            end
            SetVehicleLights(vehicle, 2)
            Wait(150)
            SetVehicleLights(vehicle, 0)
            Wait(150)
            SetVehicleLights(vehicle, 2)
            Wait(150)
            SetVehicleLights(vehicle, 0)
        else
            if Entity(vehicle).state.isFaction and (Entity(vehicle).state.job == W.GetPlayerData().job.name) then
                local label = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local lockStatus = GetVehicleDoorLockStatus(vehicle)
                if lockStatus == 1 or lockStatus == 0 then
                    SetVehicleDoorsLocked(vehicle, 2)
                    SetVehicleDoorsLocked(vehicle, 6)
                    PlayVehicleDoorCloseSound(vehicle, 1)
                    SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                    W.Notify('MANDO REMOTO', 'Has ~r~cerrado~w~ tu ~y~'..label)
                elseif lockStatus == 2 or lockStatus == 6 then
                    SetVehicleDoorsLocked(vehicle, 1)
                    PlayVehicleDoorOpenSound(vehicle, 0)
                    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    W.Notify('MANDO REMOTO', 'Has ~g~abierto~w~ tu ~y~'..label)
                end
                if not IsPedInAnyVehicle(PlayerPedId(), true) then
                    TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                end
                SetVehicleLights(vehicle, 2)
                Wait(150)
                SetVehicleLights(vehicle, 0)
                Wait(150)
                SetVehicleLights(vehicle, 2)
                Wait(150)
                SetVehicleLights(vehicle, 0)
            
                if not Entity(vehicle).state.ignoreLocks then
                    TriggerServerEvent('ZCore:ignoreLocks', NetworkGetNetworkIdFromEntity(vehicle))
                end
            else
                W.Notify('MANDO REMOTO', 'Parece ser que no tienes las llaves de tu vehículo.')
            end
        end
    else
        W.Notify('MANDO REMOTO', 'Parece ser que no estás cerca de tu vehículo.')
    end
end)