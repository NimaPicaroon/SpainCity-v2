ImportController = setmetatable({ }, ImportController)
ImportController.__variables = {
    inImport = false,
    data = {},
    debugMode = true,
    inStarterLoop = false,
    policeBlips = {},
}

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    while not W.GetPlayerData().job do
        Wait(500)
    end

    ImportController.__variables.inStarterLoop = true
    ImportController:StarterLoop()
end)

function ImportController:StarterLoop()
    Citizen.CreateThread(function()
        while not NetworkIsPlayerActive(PlayerId()) do
            Wait(100)
        end
        RequestModel(GetHashKey(Cfg.Starter.ped))
        while not HasModelLoaded(GetHashKey(Cfg.Starter.ped)) do
            Wait(0)
        end

        if not spawnedPed or not DoesEntityExist(spawnedPed) then
            local spawnedPed = CreatePed(5, GetHashKey(Cfg.Starter.ped), vector3(Cfg.Starter.coords.x, Cfg.Starter.coords.y, Cfg.Starter.coords.z), Cfg.Starter.coords.w, false, true)
            SetEntityAsMissionEntity(spawnedPed, true, true)
            FreezeEntityPosition(spawnedPed, true)
            SetBlockingOfNonTemporaryEvents(spawnedPed, true)
            SetEntityInvincible(spawnedPed, true)
            SetPedFleeAttributes(spawnedPed, 0, 0)
        end
        
        local msec = 800
        local show = false
        while(ImportController.__variables.inStarterLoop)do
            Citizen.Wait(msec)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - vector3(Cfg.Starter.coords.x, Cfg.Starter.coords.y, Cfg.Starter.coords.z))
            if(distance <= 2.5)then
                msec = 0
                if not show then
                    show = true
                    exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para comenzar', 'start_help_notify_importer')
                end
                if(IsControlJustPressed(1, 38))then
                    ImportController.__variables.inStarterLoop = false
                    ImportController:Send()
                    break
                end
            else
                msec = 400
            end
            if(show and distance > 2.5)then
                show = false
                exports['ZC-HelpNotify']:close('start_help_notify_importer')
            end
        end
        exports['ZC-HelpNotify']:close('start_help_notify_importer')
        Citizen.Wait(2000)
        DeletePed(spawnedPed)
    end)
end

function ImportController:Send()
    ImportController:CanStartImportation(function(can, reason)
        if(can)then
            ImportController.__variables.inImport = true
            ImportController.__variables.data.selectedVehicle = ImportController:SelectRandomVehicle()
            ImportController.__variables.data.selectedFirstLocation = ImportController:SelectRandomLocation(1)
            ImportController.__variables.data.selectedSecondLocation = ImportController:SelectRandomLocation(2)
            ImportController.__variables.data.uniqueId = ImportController:GenerateUUID()
            ImportController.__variables.data.pedSpawned = ImportController:CreateFirstPed()
            ImportController.__variables.data.pedBlipData = ImportController:AddBlip(GetEntityCoords(ImportController.__variables.data.pedSpawned), "Punto de recogida del vehículo")
            W.Notify("IMPORTACIÓN", "¡Hola! Ves a hablar con mi contacto, él te dará instrucciones. Te he marcado la ubicación en el GPS. ¡Suerte!", "verify")
            ImportController.__variables.data.phase = 1
            TriggerServerEvent("ZC-ImportCars:registerNewImport", ImportController.__variables.data)
            ImportController:StartPedLoop()
            ExecuteCommand('entorno ¡Un coche de importación esta siendo robado!')
            ImportController.__variables.data.vehBlip = ImportController:AddBlip(vector3(ImportController.__variables.data.selectedSecondLocation.coords.x, ImportController.__variables.data.selectedSecondLocation.coords.y, ImportController.__variables.data.selectedSecondLocation.coords.z), "Punto de entrega")
            ImportController.__variables.data.vehSpawned = ImportController:SpawnVehicle(ImportController.__variables.data.selectedVehicle, ImportController.__variables.data.selectedSecondLocation)
            ImportController:TickPolice()
            ImportController:VehLoop()        else
            if(ImportController.__variables.debugMode)then
                print("[ZC-ImportCars] Access denied")
            end
            return false, W.Notify("ERROR", "Actualmente no puedes iniciar está actividad", "error")
        end
    end)
end

function ImportController:SpawnVehicle(vehicle, locData)
    local spawnerCoords = ImportController.__variables.data.selectedFirstLocation.vehSpawner
    local model = GetHashKey(vehicle)
    RequestModel(model)
    if not IsModelValid(model) then
        return
    end
    while not HasModelLoaded(model) do
        Citizen.Wait(100)
        RequestModel(model)
    end
    local vehicle = CreateVehicle(GetHashKey(vehicle), vector3(spawnerCoords.x, spawnerCoords.y, spawnerCoords.z), spawnerCoords.w, true, true)
    SetEntityInvincible(vehicle, false)
    SetVehicleCanBreak(vehicle, true)
    SetModelAsNoLongerNeeded(model)
    exports['LegacyFuel']:SetFuel(vehicle, 100.0)
    TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(vehicle))
    W.Notify("IMPORTACIÓN", "Coge el vehículo y dirígete a la ubicación de entrega")
    return {entity = vehicle, plate = GetVehicleNumberPlateText(vehicle)}
end

exports('getImportCars', function()
    return ImportCars
end)

function ImportController:VehLoop()
    local msec = 500
    local playerPed = PlayerPedId()
    while(ImportController.__variables.data.phase == 2 and ImportController.__variables.inImport)do
        Citizen.Wait(msec)
        local locData = ImportController.__variables.data.selectedSecondLocation
        local distance = #(GetEntityCoords(playerPed) - vector3(locData.coords.x, locData.coords.y, locData.coords.z))
        if(distance <= 2.5)then
            msec = 0
            if not show then
                show = true
                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para entregar el vehículo', 'veh_help_notify_import')
            end
            if(IsControlJustPressed(1, 38))then
                local vehicle = GetVehiclePedIsIn(playerPed)
                if(GetVehicleNumberPlateText(vehicle) == ImportController.__variables.data.vehSpawned.plate)then
                    TaskLeaveVehicle(playerPed, vehicle, 0)
                    Citizen.Wait(1500)
                    ImportController.__variables.inImport = false
                    TriggerServerEvent("ZC-ImportCars:tickPolice", ImportController.__variables.data.uniqueId, false)
                    DeleteEntity(vehicle)
                    TriggerServerEvent("ZC-ImportVehicles:finish", ImportController.__variables.data)
                    if(not ImportController.__variables.inStarterLoop)then
                        ImportController.__variables.inStarterLoop = true
                        ImportController:StarterLoop()
                    end
                else
                    W.Notify("ERROR", "¿Qué es esto? ¿Tu te piensas que soy tonto? A la próxima traéme el vehículo que te pido")
                end
                break
            end
        else
            msec = 400
        end
        if(show and distance > 2.5)then
            show = false
            exports['ZC-HelpNotify']:close('veh_help_notify_import')
        end
    end
    RemoveBlip(ImportController.__variables.data.vehBlip)
    TriggerServerEvent("ZC-ImportCars:tickPolice", ImportController.__variables.data.uniqueId, false)
    ImportController.__variables.inImport = false
    ImportController.__variables.data = {}
    exports['ZC-HelpNotify']:close('veh_help_notify_import')
end

function ImportController:TickPolice()
    local tickPoliceDurationInSecs = Cfg.TickPoliceDuration * 60
    local maxTicker = (tickPoliceDurationInSecs / Cfg.TickPolice)
    local ticker = 0
    Citizen.CreateThread(function()
        while(ImportController.__variables.inImport and ticker < maxTicker)do
            Citizen.Wait(Cfg.TickPolice * 1000)
            ticker = ticker +1
            if(ticker == (maxTicker - 1))then
                W.Notify("IMPORTACIÓN", "En breves segundos la señal de la policía se verá afectada, despístalos, te veo en la entrega.")
            end
            if(ImportController.__variables.data.vehSpawned and DoesEntityExist(ImportController.__variables.data.vehSpawned.entity))then
                TriggerServerEvent("ZC-ImportCars:tickPolice", ImportController.__variables.data.uniqueId, GetEntityCoords(ImportController.__variables.data.vehSpawned.entity))
            else
                ticker = maxTicker
            end
        end
        TriggerServerEvent("ZC-ImportCars:tickPolice", ImportController.__variables.data.uniqueId, false)
    end)
end

function ImportController:StartPedLoop()
    local msec = 400
    local playerPed = PlayerPedId()
    local show = false
    while(ImportController.__variables.data.phase == 1)do
        Citizen.Wait(msec)
        local playerCoords = GetEntityCoords(playerPed)
        local locData = ImportController.__variables.data.selectedFirstLocation
        local distance = #(playerCoords - vector3(locData.coords.x, locData.coords.y, locData.coords.z))
        if(distance <= 2.5)then
            msec = 0
            if not show then
                show = true
                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para recoger', 'ped_help_notify_import')
            end
            if(IsControlJustPressed(1, 38))then
                RemoveBlip(ImportController.__variables.data.pedBlipData)
                ImportController.__variables.data.pedBlipData = nil
                ImportController.__variables.data.phase = 2
                break
            end
        else
            msec = 400
        end
        if(show and distance > 2.5)then
            show = false
            exports['ZC-HelpNotify']:close('ped_help_notify_import')
        end
    end
    exports['ZC-HelpNotify']:close('ped_help_notify_import')
    Citizen.CreateThread(function()
        Citizen.Wait(6000)
        DeletePed(ImportController.__variables.data.pedSpawned)
        ImportController.__variables.data.pedSpawned = nil
    end)
end

function ImportController:SelectRandomVehicle()
    local random = math.random(1, #Cfg.AvailableCars)
    return Cfg.AvailableCars[random]
end

function ImportController:SelectRandomLocation(type)
    if(type == 1)then
        local random = math.random(1, #Cfg.FirstUbications)
        return Cfg.FirstUbications[random]
    elseif(type == 2)then
        local random = math.random(1, #Cfg.SecondUbications)
        return Cfg.SecondUbications[random]
    end
end

function ImportController:CreateFirstPed()
    local pedData = ImportController.__variables.data.selectedFirstLocation
    RequestModel(GetHashKey(pedData.model))
    while not HasModelLoaded(GetHashKey(pedData.model)) do
        Wait(0)
    end
    local spawnPed = CreatePed(5, GetHashKey(pedData.model), vector3(pedData.coords.x, pedData.coords.y, pedData.coords.z), pedData.coords.w, false, true)
    SetEntityAsMissionEntity(spawnPed, true, true)
    FreezeEntityPosition(spawnPed, true)
    SetBlockingOfNonTemporaryEvents(spawnPed, true)
    SetEntityInvincible(spawnPed, true)
    SetPedFleeAttributes(spawnPed, 0, 0)
    return spawnPed
end

function ImportController:AddBlip(coords, text)
    local pedBlip = AddBlipForCoord(coords)
    SetBlipSprite(pedBlip, 1)
    SetBlipDisplay(pedBlip, 4)
    SetBlipScale(pedBlip, 1.0)
    SetBlipColour(pedBlip, 5)
    SetBlipAsShortRange(pedBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(pedBlip)
    SetBlipRoute(pedBlip, true)
    return pedBlip
end

function ImportController:CanStartImportation(cb)
    W.TriggerCallback("ZC-ImportCars:canStart", function(can)
        cb(can)
    end)
end

function ImportController:GenerateUUID()
    return math.random(1000000, 9999999)
end

RegisterNetEvent("ZC-ImportCars:tickPolice", function(id, coords)
    if(ImportController.__variables.policeBlips[id])then
        RemoveBlip(ImportController.__variables.policeBlips[id])
    end
    if(coords)then
        ImportController.__variables.policeBlips[id] = AddBlipForCoord(coords)
        SetBlipSprite(ImportController.__variables.policeBlips[id], 161)
        SetBlipScale(ImportController.__variables.policeBlips[id], 1.0)
        SetBlipColour(ImportController.__variables.policeBlips[id], 8)
        PulseBlip(ImportController.__variables.policeBlips[id])
        SetBlipAsShortRange(ImportController.__variables.policeBlips[id], false)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Localizador de vehículo robado')
        EndTextCommandSetBlipName(ImportController.__variables.policeBlips[id])
    end
end)