GarageModule = setmetatable({ }, GarageModule)
GarageModule._data = { 
    vehicles = {},
    plates = {},
    loaded = false
}
GarageModule.__index = GarageModule

function GarageModule:get(plate)
    if type(plate) ~= 'string' then
        return
    end

    if not GarageModule._data.vehicles[plate] then
        return
    end

    return GarageModule._data.vehicles[plate]
end

exports('getVehicle', function(plate)
    local vehicle = GarageModule:get(plate)

    return vehicle
end)

exports('getVehicles', function()
    return GarageModule._data.vehicles
end)

function GarageModule:create(data)
    if not data then
        return
    end
    GarageModule._data.vehicles[data.plate] = GarageClass:create(data)
    GarageModule._data.plates[data.plate] = { plate = data.plate, created = true }
end

exports('createVehicle', function(data)
    local vehicle = GarageModule:create(data)

    return vehicle
end)

exports('getVehiclesByIdentifier', function(identifier)
    local vehicles = {}

    for key, value in next, GarageModule._data.vehicles do
        if value.owner == identifier then
            table.insert(vehicles, value)
        end
    end

    return vehicles
end)

exports('getVehiclesByGarage', function(garage)
    local vehicles = {}
    for key, value in next, GarageModule._data.vehicles do
        if value.garage == garage then
            table.insert(vehicles, value)
        end
    end

    return vehicles
end)

exports('getVehiclesOwned', function(identifier)
    local vehicles = {}

    for key, value in next, GarageModule._data.vehicles do
        if tostring(value.owner) == tostring(identifier) then
            vehicles[value.plate] = value
        end
    end
    
    return vehicles
end)

exports("getVehicleData", function(plate)
    if(not plate or not GarageModule._data.vehicles[plate])then
        return false
    end
    return GarageModule._data.vehicles[plate]
end)

W.CreateCallback('garages:getVehicleData', function(source, callback, plate)
    if(not plate or not GarageModule._data.vehicles[plate])then
        callback(false)
        return
    end

    callback(GarageModule._data.vehicles[plate])
end)

function GarageModule:delete(plate)
    if not plate then
        return
    end
    GarageModule._data.vehicles[plate] = nil
    GarageModule._data.plates[plate] = nil
end

exports('deleteVehicle', function(plate)
   GarageModule:delete(plate)
   return true
end)

function GarageModule:load(source)
    if type(source) ~= 'number' then
        return
    end

    local src = source
    local ply = W.GetPlayer(src)

    if not ply then
        return print('^5ZC-Garages^7 - Player does not exist.')
    end

    if not GarageModule._data.loaded then
        print('^5ZC-Garages^7 - Loaded for the first time ^5database^7 vehicles.')

        exports.oxmysql:execute('SELECT * FROM owned_vehicles', {}, function(data)
            for key, value in ipairs(data) do
                if value.plate then
                    GarageModule._data.vehicles[value.plate] = GarageClass:create(value)
                    GarageModule._data.plates[value.plate] = { plate = value.plate, created = true }
                end
            end

            GarageModule._data.loaded = true

            if GarageModule._data.loaded then
                local plyVehicles = exports['ZC-Garages']:getVehiclesOwned(ply.identifier)

                TriggerClientEvent('garages:sync', src, plyVehicles)
            end
        end)
    else
        local plyVehicles = exports['ZC-Garages']:getVehiclesOwned(ply.identifier)
    
        TriggerClientEvent('garages:sync', src, plyVehicles)
    end
end

RegisterNetEvent('garages:request', function()
    local src = source

    GarageModule:load(src)
end)

RegisterNetEvent("garages:updateStoreAndGarage", function(plate, stored, garage)
    local veh = GarageModule:get(plate)
    local player = W.GetPlayerByIdentifier(veh.owner)
    veh:Store().set(stored)
    veh:Garage().set(garage)

    exports.oxmysql:execute('UPDATE owned_vehicles SET garage = ? WHERE plate = ?', { garage, plate })

    if(player)then
        local plyVehicles = exports['ZC-Garages']:getVehiclesOwned(player.identifier)
        TriggerClientEvent('garages:sync', player.src, plyVehicles)
        player.Notify("ADMINISTRACIÓN", "Un administrador recolocó tu vehículo con matrícula " .. plate .. " a garaje central", "verify")
    end
end)

RegisterNetEvent('garages:update', function(data, playerSrc)
    local veh = GarageModule:get(data.plate)
    
    if not veh then
        local src = playerSrc or source
        local ply = W.GetPlayer(src)
        GarageModule._data.vehicles[data.plate] = GarageClass:create(data)
        GarageModule._data.plates[data.plate] = { plate = data.plate, created = true }
        W.Print('INFO', 'Player ^5'..src..'^7 buyed a new vehicle at the vehicleshop')
        local plyVehicles = exports['ZC-Garages']:getVehiclesOwned(ply.identifier)
        
        TriggerClientEvent('garages:sync', src, plyVehicles)

        return
    end

    veh:Store().set(data.stored)
    veh:Garage().set(data.garage)
    veh:Properties().set(data.properties)

    exports.oxmysql:execute('UPDATE owned_vehicles SET garage = ? WHERE plate = ?', { data.garage, data.plate })

    veh:Properties().plate(data.plate)
    veh:Name().set(data.name)
end)

RegisterNetEvent('garages:getData', function(identifier, callback)
    local playerId = identifier
    local vehicles = {}

    for key, value in next, GarageModule._data.vehicles do
        if value.owner == identifier then
            vehicles[tostring(value.plate)] = value
        end
    end

    return callback(vehicles)
end)

RegisterNetEvent('Wave:UpdateProperties', function(plate, properties)
    local veh = GarageModule:get(plate)
    print('Updating properties')

    if not veh then
        return
    end

    veh:Properties().set(properties)
end)

Citizen.CreateThread(function()
    while not next(GarageModule._data.vehicles) do
        Wait(100)
    end

    while true do
        for key, value in next, GarageModule._data.plates do
            local vehicle = GarageModule:get(value.plate)

            if vehicle.update then
                exports.oxmysql:execute('UPDATE `owned_vehicles` SET `plate` = ?, `name` = ?, `owner` = ?, `stored` = ?, `vehicle` = ?, `garage` = ? WHERE `id` = ?', { tostring(vehicle.plate), vehicle.name, vehicle.owner, vehicle.stored, json.encode(vehicle.properties), tostring(vehicle.garage), vehicle.id }, function()
                    vehicle.update = false

                    if not vehicle.update then
                        print('^5ZC-Garages^7 - Saving ^5'..vehicle.plate..'^7 on database.')
                    end

                    Citizen.Wait(750)
                end)
            end
        end
        
        Citizen.Wait(3 * 60 * 1000)
    end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining <= 100 then
        CreateThread(function()
            for key, value in next, GarageModule._data.plates do
                local vehicle =  GarageModule:get(value.plate)
    
                if vehicle.update then
                    exports.oxmysql:execute('UPDATE `owned_vehicles` SET `plate` = ?, `name` = ?, `owner` = ?, `stored` = ?, `vehicle` = ?, `garage` = ? WHERE `id` = ?', { tostring(vehicle.plate), vehicle.name, vehicle.owner, vehicle.stored, json.encode(vehicle.properties), tostring(vehicle.garage), vehicle.id }, function()
                        vehicle.update = false
    
                        if not vehicle.update then
                            print('^5ZC-Garages^7 - Saving ^5'..vehicle.plate..'^7 on database (TXADMIN SCHEDULED RESTART).')
                        end
                    end)
                end
            end
        end)
    end
end)

W.CreateCallback('garages:payVehicle', function(source, callback)
    local src = source
    local ply = W.GetPlayer(src)

    if ply.getMoney('money') >= 250 then
        ply.removeMoney('money', 250)

        return callback(true)
    elseif ply.getMoney('bank') >= 250 then
        ply.removeMoney('bank', 250)

        return callback(true)
    else
        return callback(false)
    end
end)

RegisterNetEvent('garages:copyKey', function(plate, model)
    local src = source
    local player = W.GetPlayer(src)

    if not player then
        return
    end

    if player.getMoney('bank') >= 100 then
        player.removeMoney('bank', 100)
        player.addItemToInventory('carkey', 1, {
            plate = plate,
            model = model
        })
    end
end)

RegisterNetEvent('ZC-Garage:addGarage', function(coords, id)
    if coords then
        if not coords.heading then
            coords.heading = 200.0
        end

        table.insert(GARAGES_DATA.garages, { name = 'Casa #'..id, blip = false, impound = false, deposit = 2, classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, job = false, text = '~y~Garaje\n~w~Tus vehículos', vehicles = nil, houseId = id, blipData = { sprite = 290, colour = 0, scale = 0.6 }, positions = { menu = vec4(coords.x, coords.y, coords.z, coords.heading) }, })
        TriggerClientEvent('garages:sendAll', -1, GARAGES_DATA.garages)
    end
end)

W.RegisterCommand("deletevehicle", "admin", function(source, args, player)
    if(not args[1])then
        return
    end
    local plate = args[1]
    GarageModule:delete(plate)
    exports.oxmysql:execute('DELETE FROM `owned_vehicles` WHERE `plate` = ?', { plate }, function() end)
    player.Notify("ADMINISTRACIÓN", "Has borrado correctamente el vehículo con matrícula ~g~" .. plate, "verify")
end, { { name = 'plate', help = 'Matrícula' }}, 'Comando para eliminar vehículo')

W.RegisterCommand("givekey", "mod", function(source, args, player)
    if(not args[1] or not args[2])then
        return
    end
    local player = args[1]
    if(player == "me")then
        player = source
    end
    player = W.GetPlayer(player)
    player.addItemToInventory("carkey", 1, {
        plate = args[2]
    })
end, { { name = 'playerId', help = 'ID del jugador' }, { name = 'plate', help = 'Matrícula del vehículo' }}, 'Comando para agregar llaves de vehículos')