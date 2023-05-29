function SaveVehicle(houseId)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed)
    local vehicleProperties = W.GetVehicleProperties(vehicle)
    if(not HasVehicleKeys(vehicleProperties.plate))then
        W.Notify("NOTIFICACIÓN", "No tienes las llaves del vehículo que intentas guardar en la vivienda", "error")
        return
    end
    vehicleProperties.plate = string.gsub(vehicleProperties.plate, "%s+", "")
    W.TriggerCallback('garages:getVehicleData', function(vehicleData)
        print(vehicleData.stored)
        if(vehicleData)then
            vehicleData.stored = true
            vehicleData.garage = "house_" .. houseId
            vehicleData.properties = vehicleProperties
            TriggerServerEvent("garages:update", vehicleData)
        else
            W.Notify("Casa #" .. houseId, "El vehículo que intentas guardar no existe", "verify")
            return
        end
        TaskLeaveVehicle(playerPed, vehicle, 0)
        Citizen.Wait(1500)
        DeleteEntity(vehicle)
        W.Notify("Casa #" .. houseId, "Has guardado correctamente el vehículo en el garaje", "verify")
    end, vehicleProperties.plate)
end

function OpenGarageMenu(houseId) 
    if(not housesData[houseId])then
        W.Notify("NOTIFICACIÓN", "Ocurrió un error al abrir el menú del garaje, contacta con un desarrollador (house_data_not_exist)", "error")
        return
    end
    W.TriggerCallback('Ox-Housing:getVehiclesByGarage', function(result)
        local elements = {}
        
        for k, v in pairs(result) do
            table.insert(elements, {
                label = GetLabelText(GetDisplayNameFromVehicleModel(v.properties.model)) .. " - " .. v.plate,
                model = v.model,
                info = v,
            })
        end

        local data = nil

        W.OpenMenu('Garaje #' .. houseId, "housing_garage_" .. houseId, elements, function (data, name)
            W.DestroyMenu(name)
            if(not data)then
                W.Notify("NOTIFICACIÓN", "No hay ningún vehículo en el interior del garaje de la propiedad", "error")
                return
            end
            data = data
            Wait(250)

            W.OpenMenu('Garaje #'..houseId, 'housing_selected_vehicle', {
                { label = 'Sacar vehículo', value = 'getvehicle'},
                { label = 'Hacer copia de llaves', value = 'copykeys'}
            }, function(data2, name2)
                W.DestroyMenu(name2)
                if data2.value == 'getvehicle' then
                    if(not HasVehicleKeys(data.info.properties.plate))then
                        W.Notify("NOTIFICACIÓN", string.format("No tienes las llaves del vehículo que intentas coger (%s)", data.info.properties.plate), "error")
                        return 
                    end
                    if(data.info)then
                        local hash = data.info.properties.model
                        RequestModel(hash)
                        if not IsModelValid(hash) then
                            print("not valid model, contact to dev")
                            return
                        end
                    
                        while not HasModelLoaded(hash) do
                            Citizen.Wait(100)
                    
                            print('Ox-Housing - Loading model')
                        end
                        local vehicleSpawnCoords = 0
                        for k, v in pairs(housesData[houseId].points) do
                            if(v.type == "garaje")then
                                vehicleSpawnCoords = vector4(v.coords.x, v.coords.y, v.coords.z, v.heading or 0.0)
                            end
                        end
                        local playerPed = GetPlayerPed(-1)
                        local vehicle = CreateVehicle(hash, vector3(vehicleSpawnCoords.x, vehicleSpawnCoords.y, vehicleSpawnCoords.z), vehicleSpawnCoords.w, true, true)
                        W.SetVehicleProperties(vehicle, data.info.properties, data.info.plate)
                        SetEntityInvincible(vehicle, false)
                        SetVehicleCanBreak(vehicle, true)
                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        SetVehicleNumberPlateText(vehicle, data.info.plate)
                        SetModelAsNoLongerNeeded(hash)
                        exports['LegacyFuel']:SetFuel(vehicle, 100.0)
                        TriggerServerEvent('ZCore:ignoreLocks', NetworkGetNetworkIdFromEntity(vehicle))
                        data.info.properties.plate = string.gsub(data.info.properties.plate, "%s+", "")
                        W.TriggerCallback('garages:getVehicleData', function(GarageModule)
                            GarageModule.stored = false
                            GarageModule.garage = "Deposito"
                            GarageModule.properties = data.info.properties
                            TriggerServerEvent('garages:update', GarageModule)
                        end, data.info.properties.plate)
                    end
                else
                    local playerData = W.GetPlayerData()

                    if playerData.money.bank >= 50 then
                        TriggerServerEvent('garages:copyKey', data.info.plate, data.model)
                        W.Notify('Garaje', 'Has pagado ~y~$50~w~ por una ~y~copia~w~ de tus llaves de: ~y~'..data.info.plate..'~w~.', 'verify')
                    else
                        W.Notify('Garaje', 'La tarjeta de credio rechazó la conexión.', 'error')
                    end
                end
            end)
        end)
    end, "house_" .. houseId)
end

function HasVehicleKeys(plate)
    plate = string.gsub(plate, "%s+", "")
    local PlayerData = W.GetPlayerData()
    for k, v in pairs(PlayerData.inventory.items) do
        if(v.item == "carkey")then
            if(v.metadata)then
                if(v.metadata.plate and v.metadata.plate == plate)then
                    return true
                end
            end
        end
    end

    return false
end