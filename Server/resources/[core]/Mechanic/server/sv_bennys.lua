-----------------------
----   Variables   ----
-----------------------
W = exports.ZCore:get()
local RepairCosts = {}

-----------------------
----   Callbacks   ----
-----------------------

W.CreateCallback('qb-customs:server:GetLocations', function(_, cb)
    cb(Config.Locations)
end)

-----------------------
---- Server Events ----
-----------------------

AddEventHandler("playerDropped", function()
    local source = source
    RepairCosts[source] = nil
end)

RegisterNetEvent('qb-customs:server:attemptPurchase', function(type, upgradeLevel, location)
    local src = source
    
    TriggerClientEvent('qb-customs:client:purchaseSuccessful', src)
end)

RegisterNetEvent('qb-customs:server:updateRepairCost', function(cost)
    local source = source
    RepairCosts[source] = cost
end)

RegisterNetEvent("qb-customs:server:updateVehicle", function(myCar, plate)
    local vehicle = exports['ZC-Garages']:getVehicle(plate)

    if not vehicle then
        return
    end

    vehicle:Properties().set(myCar)
    vehicle:Properties().plate(plate)
    
    exports.oxmysql:execute('UPDATE `owned_vehicles` SET `vehicle` = ? WHERE `plate` = ?', { json.encode(myCar), plate }, function(executed) end)
end)

RegisterNetEvent('qb-customs:server:UpdateLocation', function(location, type, key, value)
    local source = source
    local player = W.GetPlayer(source)

    if not player then
        return
    end

    if player.group ~= 'user' then
        Config.Locations[location][type][key] = value
        TriggerClientEvent('qb-customs:client:UpdateLocation', -1, location, type, key, value)
    else
        CancelEvent()
    end
end)