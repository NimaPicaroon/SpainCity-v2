
W.CreateCallback('Ox-Housing:getVehiclesByGarage', function(source, cb, garage) 
    cb(exports["ZC-Garages"]:getVehiclesByGarage(garage))
end)

W.RegisterCommand('movercoche', 'mod', function(playerSrc, playerArgs, player)
    local plate = playerArgs[1]
    if(not plate)then
        player.Notify("ADMINISTRACIÓN", "Tienes que indicar la matrícula en el primer argumento", "error")
        return
    end
    TriggerEvent('garages:updateStoreAndGarage', plate, true, "Garaje Central")
    player.Notify("ADMINISTRACIÓN", "Has movido correctamente el vehículo con matrícula " .. plate .. " a Garaje Central", "verify")
end, { { name = 'plate', help = 'Matrícula del vehículo en cuestión' }}, 'Comando para llevar un vehículo específico a garaje central')