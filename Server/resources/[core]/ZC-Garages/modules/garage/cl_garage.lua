GarageModule = setmetatable({ }, GarageModule)
GarageModule._data = { playerPed = nil, playerPos = nil, playerVeh = nil, playerData = nil, garage = nil, vehicles = {}, entities = {} }
GarageModule.__index = GarageModule
local MyHouse

RegisterNetEvent('garages:sync', function(garages)
    GarageModule._data.vehicles = garages
end)

exports('getVehicles', function(plate)
    if plate then
        return GarageModule._data.vehicles[value.plate]
    end

    return GarageModule._data.vehicles
end)

function GarageModule:spawnPeds()
    for key, value in next, GARAGES_DATA.garages do
        if value.ped then
            RequestModel(value.ped.model)
            while not HasModelLoaded(value.ped.model) do
                Wait(1)
            end

            local ped = CreatePed(0, value.ped.model, vec3(value.ped.position.x, value.ped.position.y, value.ped.position.z - 1), value.ped.position.w, false)
            FreezeEntityPosition(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedDiesWhenInjured(ped, false)
            SetPedCanPlayAmbientAnims(ped, true)
            SetPedCanRagdollFromPlayerImpact(ped, false)
            SetEntityInvincible(ped, true)
            DecorSetInt(ped, 'SPAWNEDPED', 1)
        end
    end
end

function GarageModule:spawnVehicle(data)
    local model = GetHashKey(data.info.model)
    local playerPed = PlayerPedId()
    local coords = nil
    local heading = nil
    local garage = nil

    RequestModel(model)
    if not IsModelValid(model) then
        return
    end

    while not HasModelLoaded(model) do
        Citizen.Wait(100)

        print('ZC-Garages - Loading model')
    end

    if not GARAGES_DATA.garages[data.garage].impound then
        if not GarageModule._data.vehicles[data.info.plate] then
            print('Plate does not exist')

            return
        end

        if not GARAGES_DATA.garages[GARAGES_DATA.garages[data.garage].deposit] then
            print('Deposit does not exist')

            return
        end

        GarageModule._data.vehicles[UtilsModule:parse(data.info.plate)].garage = GARAGES_DATA.garages[GARAGES_DATA.garages[data.garage].deposit].name
        GarageModule._data.vehicles[UtilsModule:parse(data.info.plate)].stored = false
    else
        GarageModule._data.vehicles[UtilsModule:parse(data.info.plate)].garage = GARAGES_DATA.garages[GARAGES_DATA.garages[data.garage].garage].name
        GarageModule._data.vehicles[UtilsModule:parse(data.info.plate)].stored = true
    end

    if GARAGES_DATA.garages[data.garage].houseId then
        coords = vec3(GARAGES_DATA.garages[data.garage].positions.menu.x, GARAGES_DATA.garages[data.garage].positions.menu.y, GARAGES_DATA.garages[data.garage].positions.menu.z)
    else
        coords = vec3(GARAGES_DATA.garages[data.garage].positions.spawner.x, GARAGES_DATA.garages[data.garage].positions.spawner.y, GARAGES_DATA.garages[data.garage].positions.spawner.z)
    end

    if GARAGES_DATA.garages[data.garage].houseId then
        heading = GARAGES_DATA.garages[data.garage].positions.menu.w
    else
        heading = GARAGES_DATA.garages[data.garage].positions.spawner.w
    end

    W.SpawnVehicle(data.info.model, coords, heading, true, function(vehicle)
        W.SetVehicleProperties(vehicle, data.info.properties, data.info.plate)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        SetVehicleNumberPlateText(vehicle, data.info.plate)
        SetModelAsNoLongerNeeded(model)
        
        --exports['LegacyFuel']:SetFuel(vehicle, 100.0)

        if GARAGES_DATA.garages[data.garage].job == 'police' then
            SetVehicleLivery(vehicle, 0)
            SetVehicleDirtLevel(vehicle, 0)
        end

        if GARAGES_DATA.garages[data.garage].houseId then
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        end

        GarageModule._data.vehicles[UtilsModule:parse(data.info.plate)].properties = W.GetVehicleProperties(vehicle)
        GarageModule._data.entities[UtilsModule:parse(data.info.plate)] = vehicle

        TriggerServerEvent('garages:update', GarageModule._data.vehicles[UtilsModule:parse(data.info.plate)])
    end)
end

function GarageModule:getVehicles()
    local vehicles = {}

    for key, value in next, GarageModule._data.vehicles do
        if not GARAGES_DATA.garages[GarageModule._data.garage].impound then
            if GARAGES_DATA.garages[GarageModule._data.garage].vehicles == "society" then
                if (value.stored and value.stored ~= 0) and (value.garage == GARAGES_DATA.garages[GarageModule._data.garage].name) and value.owner == "society_"..GARAGES_DATA.garages[GarageModule._data.garage].job then
                    if not GarageModule._data.entities[UtilsModule:parse(value.plate)] and (not DoesEntityExist(GarageModule._data.entities[UtilsModule:parse(value.plate)])) then
                        local modelHash = GetHashKey(value.model)

                        for _,class in next, GARAGES_DATA.garages[GarageModule._data.garage].classes do
                            if GetVehicleClassFromName(modelHash) == class then
                                table.insert(vehicles, {
                                    labelText = GetLabelText(GetDisplayNameFromVehicleModel(modelHash)),
                                    label = (value.name ~= nil and value.name) or GetLabelText(GetDisplayNameFromVehicleModel(modelHash))..' - '..value.plate,
                                    info = value,
                                    plate = value.plate,
                                    garage = GarageModule._data.garage
                                })
                            end
                        end
                    end
                end
            else
                if (value.stored and value.stored ~= 0) and (value.garage == GARAGES_DATA.garages[GarageModule._data.garage].name) and value.owner == GarageModule._data.playerData.identifier then
                    if not GarageModule._data.entities[UtilsModule:parse(value.plate)] and (not DoesEntityExist(GarageModule._data.entities[UtilsModule:parse(value.plate)])) then
                        local modelHash = GetHashKey(value.model)

                        for _,class in next, GARAGES_DATA.garages[GarageModule._data.garage].classes do
                            if GetVehicleClassFromName(modelHash) == class then
                                table.insert(vehicles, {
                                    labelText = GetLabelText(GetDisplayNameFromVehicleModel(modelHash)),
                                    label = (value.name ~= nil and value.name) or GetLabelText(GetDisplayNameFromVehicleModel(modelHash))..' - '..value.plate,
                                    info = value,
                                    plate = value.plate,
                                    garage = GarageModule._data.garage
                                })
                            end
                        end
                    end
                end
            end
        else
            if GARAGES_DATA.garages[GarageModule._data.garage].vehicles == "society" then
                if (value.garage == GARAGES_DATA.garages[GarageModule._data.garage].name) and (value.owner == "society_"..GARAGES_DATA.garages[GarageModule._data.garage].job) then
                    if not GarageModule._data.entities[UtilsModule:parse(value.plate)] and (not DoesEntityExist(GarageModule._data.entities[UtilsModule:parse(value.plate)])) then
                        local modelHash = GetHashKey(value.model)
    
                        for _,class in next, GARAGES_DATA.garages[GarageModule._data.garage].classes do
                            if GetVehicleClassFromName(modelHash) == class then
                                table.insert(vehicles, {
                                    labelText = GetLabelText(GetDisplayNameFromVehicleModel(modelHash)),
                                    label = (value.name ~= nil and value.name) or GetLabelText(GetDisplayNameFromVehicleModel(modelHash))..' - '..value.plate,
                                    info = value,
                                    plate = value.plate,
                                    garage = GarageModule._data.garage
                                })
                            end
                        end
                    end
                end
            else
                if (value.garage == GARAGES_DATA.garages[GarageModule._data.garage].name) and (value.owner == GarageModule._data.playerData.identifier) then
                    if not GarageModule._data.entities[UtilsModule:parse(value.plate)] and (not DoesEntityExist(GarageModule._data.entities[UtilsModule:parse(value.plate)])) then
                        local modelHash = GetHashKey(value.model)
    
                        for _,class in next, GARAGES_DATA.garages[GarageModule._data.garage].classes do
                            if GetVehicleClassFromName(modelHash) == class then
                                table.insert(vehicles, {
                                    labelText = GetLabelText(GetDisplayNameFromVehicleModel(modelHash)),
                                    label = (value.name ~= nil and value.name) or GetLabelText(GetDisplayNameFromVehicleModel(modelHash))..' - '..value.plate,
                                    info = value,
                                    plate = value.plate,
                                    garage = GarageModule._data.garage
                                })
                            end
                        end
                    end
                end
            end
        end
    end

    Wait(250)
    W.OpenMenu(GARAGES_DATA.garages[GarageModule._data.garage].name, 'garage_menu', vehicles, function(data, name)
        W.DestroyMenu(name)

        if not data then
            return
        end

        if not GARAGES_DATA.garages[GarageModule._data.garage].impound then
            Wait(250)

            W.OpenMenu(GARAGES_DATA.garages[GarageModule._data.garage].name, 'garage_select_menu', {
                { label = 'Sacar', value = 'takeout' },
                { label = 'Renombrar', value = 'rename' },
                { label = 'Hacer copia de las llaves', value = 'copykeys' }
            }, function(data2, name2)
                W.DestroyMenu(name2)

                if data2.value == 'takeout' then
                    GarageModule:spawnVehicle({ info = data.info, garage = data.garage })
                elseif data2.value == 'rename' then
                    W.OpenDialog("Nombre del Vehiculo", "vehicle_name_garage", function(name)
                        W.CloseDialog()

                        name = tostring(name)
                        if string.len(name) > 2 and string.len(name) < 20 then
                            W.Notify('Garaje', 'Has cambiado el nombre de tu ~y~'..data.labelText..'~w~ y ahora se llama ~y~'..name..'~w~.', 'verify')
                            GarageModule._data.vehicles[UtilsModule:parse(data.plate)].name = name

                            TriggerServerEvent('garages:update', GarageModule._data.vehicles[UtilsModule:parse(data.plate)])
                        else
                            W.Notify('Garaje', 'Debes escribir un nombre mas largo o corto', 'error')
                        end
                    end)
                elseif data2.value == 'copykeys' then
                    local playerData = W.GetPlayerData()

                    if playerData.money.bank >= 100 then
                        print(json.encode(data))
                        TriggerServerEvent('garages:copyKey', data.plate, data.info.model)
                        W.Notify('Garaje', 'Has pagado ~y~100€~w~ por una ~y~copia~w~ de tus llaves de: ~y~'..data.info.model..'~w~.', 'verify')
                    else
                        W.Notify('Garaje', 'La tarjeta de credio rechazó la conexión.', 'error')
                    end
                else
                    return
                end
            end)

            return
        end

        W.TriggerCallback('garages:payVehicle', function(payed)
            if not payed then return W.Notify('Garaje', 'No tienes ~y~dinero~w~ suficiente para poder ~y~recuperar tu vehiculo~w~.', 'error') end

            GarageModule:spawnVehicle({ info = data.info, garage = data.garage })
            W.Notify('Garaje', 'Has pagado ~g~250€~w~ por tu vehiculo.', 'verify')
        end)
    end, function()
        W.DestroyMenu(name)
    end)
end

function GarageModule:saveVehicle(vehicle)
    local props = W.GetVehicleProperties(vehicle)
    local plate = UtilsModule:parse(props.plate)

    if GARAGES_DATA.garages[GarageModule._data.garage].vehicles and GARAGES_DATA.garages[GarageModule._data.garage].vehicles == "society" then
        if not GarageModule._data.vehicles[plate] then
            W.Notify('Garaje', 'Este vehiculo no te pertenece', 'error')

            return
        end

        if not GarageModule._data.vehicles[plate].owner == "society_"..GARAGES_DATA.garages[GarageModule._data.garage].job then
            W.Notify('Garaje', 'Este vehiculo no te pertenece', 'error')
            
            return
        end
    else
        if (GARAGES_DATA.garages[GarageModule._data.garage].vehicles and not GARAGES_DATA.garages[GarageModule._data.garage].vehicles[GetEntityModel(vehicle)]) then
            W.Notify('Garaje', 'No puedes guardar este vehiculo aqui', 'error')
            
            return
        end

        if not GarageModule._data.vehicles[plate] then
            W.Notify('Garaje', 'Este vehiculo no te pertenece', 'error')
            
            return
        end
    end

    if not GARAGES_DATA.garages[GarageModule._data.garage].vehicles == "society" then
        if GarageModule._data.vehicles[plate].owner ~= GarageModule._data.playerData.identifier then
            W.Notify('Garaje', 'Este vehiculo no te pertenece', 'error')
            
            return
        end
    end

    TaskLeaveVehicle(GarageModule._data.playerPed, vehicle, 0)
    Citizen.Wait(1500)
    DeleteEntity(vehicle)
    W.Notify('Garaje', 'Has guardado tu vehiculo en el garaje', 'verify')
    GarageModule._data.entities[plate] = nil
    GarageModule._data.vehicles[plate].stored = true
    GarageModule._data.vehicles[plate].garage = GARAGES_DATA.garages[GarageModule._data.garage].name
    GarageModule._data.vehicles[plate].properties = props

    TriggerServerEvent('garages:update', GarageModule._data.vehicles[plate])
end

-- Principal loops
Citizen.CreateThread(function()
    DecorRegister('CARLOCK_WHITELIST', 2)
    GarageModule:spawnPeds()

    while true do
        if not GarageModule._data.playerData or GarageModule._data.playerData ~= W.GetPlayerData() then
            GarageModule._data.playerData = W.GetPlayerData()
        end

        if not GarageModule._data.playerPed or GarageModule._data.playerPed ~= PlayerPedId() then
            GarageModule._data.playerPed = PlayerPedId()
        end

        if GarageModule._data.playerPed then
            if not GarageModule._data.playerPos or GarageModule._data.playerPos ~= GetEntityCoords(GarageModule._data.playerPed) then
                GarageModule._data.playerPos = GetEntityCoords(GarageModule._data.playerPed)
            end

            if IsPedInAnyVehicle(GarageModule._data.playerPed) then
                GarageModule._data.playerVeh = GetVehiclePedIsIn(GarageModule._data.playerPed)
            else
                GarageModule._data.playerVeh = nil
            end
        end

        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while not GarageModule._data.playerPed and GarageModule._data.playerPos do
        Citizen.Wait(100)

        print('Waiting...')
    end

    while true do
        if GarageModule._data.playerPed and GarageModule._data.playerPos then
            for key, value in next, GARAGES_DATA.garages do
                local dist = #(GarageModule._data.playerPos - vec3(value.positions.menu.x, value.positions.menu.y, value.positions.menu.z))
                if value.houseId then
                    if dist <= 6.0 then
                        if MyHouse and MyHouse == value.houseId then
                            GarageModule._data.garage = key
                        end
                    end
                else
                    if dist <= 20.0 then
                        GarageModule._data.garage = key
                    end
                end
            end
        end

        Citizen.Wait(1500)
    end
end)

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(200)
    end

    while not exports.ZCore.isPlayerLoaded() do
        Citizen.Wait(500)
    end

    TriggerServerEvent('garages:request')

    while true do
        for key, value in next, GarageModule._data.entities do
            if not DoesEntityExist(value) then
                GarageModule._data.entities[UtilsModule:parse(key)] = nil
            end
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    for key, value in next, GARAGES_DATA.garages do
        if value.blip then
            local blip = AddBlipForCoord(value.positions.menu)
            SetBlipSprite(blip, value.blipData.sprite)
            SetBlipScale(blip, value.blipData.scale)
            SetBlipDisplay(blip, 4)
            SetBlipColour(blip, 3)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(value.name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

Citizen.CreateThread(function()
    local inZone = false
    local shown = false

    while not GarageModule._data.playerPed and GarageModule._data.playerPos do
        Citizen.Wait(100)

        print('Waiting...')
    end

    while true do
        local msec = 750

        if GarageModule._data.garage then
            inZone = false

            if not GarageModule._data.playerVeh then
                local dist = #(GarageModule._data.playerPos - vec3(GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.x, GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.y, GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.z))

                if dist <= 3.0 then
                    msec = 0
                    if GARAGES_DATA.garages[GarageModule._data.garage].job and (GarageModule._data.playerData.job.name == GARAGES_DATA.garages[GarageModule._data.garage].job) then
                        msec = 0

                        W.ShowText(vec3(GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.x, GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.y, GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.z) + vec3(0.0, 0.0, 1.0), GARAGES_DATA.garages[GarageModule._data.garage].text, 0.6, 8)
                        if dist <= 1.5 then
                            inZone = true

                            if IsControlJustPressed(0, 38) then
                                GarageModule:getVehicles()
                            end
                        end
                    elseif not GARAGES_DATA.garages[GarageModule._data.garage].job then
                        W.ShowText(vec3(GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.x, GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.y, GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.z) + vec3(0.0, 0.0, 1.0), GARAGES_DATA.garages[GarageModule._data.garage].text, 0.6, 8)
                        if dist <= 1.5 then
                            inZone = true

                            if IsControlJustPressed(0, 38) then
                                GarageModule:getVehicles()
                            end
                        end
                    end
                end
            else
                if not GARAGES_DATA.garages[GarageModule._data.garage].impound then
                    if GARAGES_DATA.garages[GarageModule._data.garage].houseId then
                        local dist = #(GarageModule._data.playerPos - vec3(GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.x, GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.y, GARAGES_DATA.garages[GarageModule._data.garage].positions.menu.z))
                        if dist <= 3.0 then
                            msec = 0
                            if dist <= 1.5 then
                                inZone = true
                                if IsControlJustPressed(0, 38) then
                                    GarageModule:saveVehicle(GarageModule._data.playerVeh)
                                end
                            end
                        end
                    else
                        local dist = #(GarageModule._data.playerPos - vec3(GARAGES_DATA.garages[GarageModule._data.garage].positions.spawner.x, GARAGES_DATA.garages[GarageModule._data.garage].positions.spawner.y, GARAGES_DATA.garages[GarageModule._data.garage].positions.spawner.z))

                        if dist <= 10.0 then
                            msec = 0

                            if GARAGES_DATA.garages[GarageModule._data.garage].job and (GarageModule._data.playerData.job.name == GARAGES_DATA.garages[GarageModule._data.garage].job) then
                                msec = 0
                                DrawMarker(1, GARAGES_DATA.garages[GarageModule._data.garage].positions.spawner.x, GARAGES_DATA.garages[GarageModule._data.garage].positions.spawner.y, GARAGES_DATA.garages[GarageModule._data.garage].positions.spawner.z -1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 7.0, 7.0, 0.2, 255, 0, 0, 255, false, true, 2, false, false, false, false)
                                if dist <= 2.5 then
                                    inZone = true

                                    if IsControlJustPressed(0, 38) then
                                        GarageModule:saveVehicle(GarageModule._data.playerVeh)
                                    end
                                end
                            elseif not GARAGES_DATA.garages[GarageModule._data.garage].job then
                                DrawMarker(1, GARAGES_DATA.garages[GarageModule._data.garage].positions.spawner.x, GARAGES_DATA.garages[GarageModule._data.garage].positions.spawner.y, GARAGES_DATA.garages[GarageModule._data.garage].positions.spawner.z -1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 7.0, 7.0, 0.2, 255, 0, 0, 255, false, true, 2, false, false, false, false)
                                if dist <= 1.5 then
                                    inZone = true
                                    if IsControlJustPressed(0, 38) then
                                        GarageModule:saveVehicle(GarageModule._data.playerVeh)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if inZone and not shown then
            shown = true

            exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'garage')
        elseif not inZone and shown then
            shown = false

            exports['ZC-HelpNotify']:close('garage')
        end

        Citizen.Wait(msec)
    end
end)

RegisterNetEvent('ZCore:playerLoaded', function()
    Wait(1500)
    MyHouse = exports['Ox-Housing']:myHouse()
end)

RegisterNetEvent('garages:sendAll', function(data)
    GARAGES_DATA.garages = data
end)