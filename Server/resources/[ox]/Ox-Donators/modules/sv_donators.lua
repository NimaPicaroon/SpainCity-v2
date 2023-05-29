DonatorModule = setmetatable({}, DonatorModule)
DonatorModule.__index = DonatorModule

RegisterNetEvent('Wave:SetDonatorVehicle', function(target, props, plate, model)
    local src =  source
    local player = W.GetPlayer(src)
    local data = {
        id = exports['ZC-Garages']:newUUID(),
        owner = player.identifier,
        name = nil,
        model = tostring(model),
        vehicleshop = 'VIP',
        plate = plate,
        stored = true,
        vehicle = json.encode(props),
        garage = 'Deposito'
    }

    if not player then
        return
    end

    exports.oxmysql:execute('INSERT INTO owned_vehicles (`id`, `owner`, `name`, `model`, `vehicleshop`, `plate`, `stored`, `vehicle`, `garage`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        data.id,
        data.owner,
        data.name,
        data.model,
        data.vehicleshop,
        data.plate,
        data.stored,
        data.vehicle,
        data.garage
    }, function(executed)
        player.addItemToInventory('carkey', 1, { model = data.model, plate = data.plate })
        player.Notify('Donador', 'Tu nuevo coche de donador está en el depósito', 'verify')
         W.SendToDiscord('donations', 'Player **'..player.identifier..'** - **'..GetPlayerName(src)..'** got donator car (**'..data.model..'** - **'..data.plate..'**)', source)
        TriggerEvent('garages:update', { 
            id = data.id,
            owner = data.owner,
            plate = data.plate,
            model = data.model,
            properties = json.decode(data.vehicle),
            vehicleshop = data.vehicleshop,
            garage = data.garage,
            update = false,
            stored = data.stored
        }, src)
    end)
end)

W.RegisterCommand('darcoche', 'admin', function(source, args, player)
    local id = tonumber(args[1])
    local model = tostring(args[2])
    local target = W.GetPlayer(id)

    if not target then
        return player.Notify('Donador', 'Jugador inválido', 'error')
    end

    if not model then
        return player.Notify('Donador', 'El modelo del coche no existe', 'error')
    end

    TriggerClientEvent('Wave:GiveDonatorVehicle', target.src, model)
    
    W.SendToDiscord('donaciones', "Coche", GetPlayerName(source)..' ha dado el coche '..model..' a '..target.name, source)

end, { { name = 'id', help = 'ID' }, { name = 'spawncode', help = 'Modelo'} }, 'Dar un coche de donador a un jugador')