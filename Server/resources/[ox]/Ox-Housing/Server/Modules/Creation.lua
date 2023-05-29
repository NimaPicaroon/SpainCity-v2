W.RegisterCommand('createhouse', 'admin', function(playerSrc, playerArgs, player)
    TriggerClientEvent("Ox-Housing:client:startHouseCreation", playerSrc)
end, {}, 'Comando para crear una casa')

RegisterServerEvent("Ox-Housing:server:sendHouse")
AddEventHandler("Ox-Housing:server:sendHouse", function(shell, price, points, gangName)
    local _src = source
    local player = W.GetPlayer(_src)
    local id = #Houses + 1
    local info = {
        bought = 0,
        price = price,
        shell = shell,
    }

    if IsAllowed(_src) then
        MySQL.Async.execute("INSERT INTO housing (id, owners, locations, furniture, info, blackmoney, paints, gang) VALUES (@id, @owners, @locations, @furniture, @info, @blackmoney, @paints, @gang)", {
            ['@id']        = id,
            ['@owners']    = json.encode({}),
            ['@locations'] = json.encode(points),
            ['@furniture'] = json.encode({}),
            ['@info']      = json.encode(info),
            ['@blackmoney'] = 0,
            ['@paints']  = json.encode({}),
            ['@gang']      = gangName
        })
        Houses[id] = CreateHouse(nil, id, price, points, 0, {}, 0, shell, {}, {}, gangName)
        Wait(500)
        player.Notify('CASA', 'Casa creada ~g~correctamente')
        TriggerClientEvent("Ox-Housing:client:addHouse", -1, Houses[id])
    end
end)