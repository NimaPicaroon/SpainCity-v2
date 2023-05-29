RdeController = setmetatable({ }, RdeController)
RdeController.__data = {}
MySQL.ready(function()
    RdeController.__data = {}
    exports.oxmysql:execute('SELECT * FROM rde', {}, function(rde)
        for _, value in pairs(rde) do
            RdeController.__data[value.id .. "-marc"] = {
                id = value.id,
                creator = value.creator,
                data = json.decode(value.data),
                sended = false,
            }
        end
        GlobalState.Zones = RdeController.__data
        W.Print("INFO", "Loaded rde zones")
    end)
end)

function RdeController:Add(value)
    if(value.id and value.creator and value.data)then
        RdeController.__data[value.id .. "-marc"] = {
            id = value.id,
            creator = value.creator,
            data = value.data,
            sended = false,
        }
        GlobalState.Zones[value.id .. "-marc"] = RdeController.__data[value.id .. "-marc"]
        TriggerClientEvent("ZC-Rde:add", -1, value.id .. "-marc", RdeController.__data[value.id .. "-marc"])
    end
end

function RdeController:Remove(key)
    RdeController.__data[key .. "-marc"] = nil
    GlobalState.Zones[key .. "-marc"] = nil
    TriggerClientEvent("ZC-Rde:remove", -1, key)
end

W.RegisterCommand('entornozona', 'admin', function(playerSrc, playerArgs, player)
    if(not playerArgs[1])then
        player.Notify('ADMINISTRACIÓN', "Tienes que indicar un mensaje para añadir un entorno", 'error')
        return
    end
    local ped = GetPlayerPed(playerSrc)
    local coords = GetEntityCoords(ped)
    local message = table.concat(playerArgs, " ")
    local formattedData = json.encode({coords = coords, message = message})
    MySQL.Async.execute('INSERT INTO rde (creator, data) VALUES (@creator, @data)', {
        ['@creator'] = player.name,
        ['@data'] = formattedData,
    })
    RdeController:Add({
        id = math.random(1000000, 9999999),
        creator = player.name,
        data = json.decode(formattedData),
    })
    player.Notify('ADMINISTRACIÓN', "Has creado correctamente el entorno de zona", 'verify')
end, { { name = 'message', help = 'Mensaje del entorno de zona' } }, 'Comando de administración para crear entornos de zona')

W.RegisterCommand('zonas', 'admin', function(playerSrc, playerArgs, player)
    TriggerClientEvent('chat:addMessage', playerSrc, { 
        args = {"Entornos", ""}, 
        color = Cfg.Customization.color
    })
    for k, v in pairs(RdeController.__data) do
        if(v.data.message)then
            TriggerClientEvent('chat:addMessage', playerSrc, { 
                args = {v.id, v.data.message .. " (" .. v.creator ..")"}, 
                color = Cfg.Customization.color
            })
        end
    end
end, {}, 'Comando de administración para mirar la lista de entornos de zona')

W.RegisterCommand('quitarzona', 'admin', function(playerSrc, playerArgs, player)
    if(not tonumber(playerArgs[1]))then
        return player.Notify("ERROR", "Tienes que indicar la id de la zona", "error")
    end
    if(RdeController.__data[playerArgs[1] .. "-marc"])then
        exports.oxmysql:execute('DELETE FROM rde WHERE id = @id', {
            ['@id'] = playerArgs[1]
        })
        RdeController:Remove(playerArgs[1])
        player.Notify("ADMINISTRACIÓN", "Eliminaste correctamente la zona con id " .. playerArgs[1], "verify")
    else
        return player.Notify("ERROR", "No hay ninguna zona con el id indicado", "error")
    end
end, { { name = 'id', help = 'ID del entorno de zona (/zonas)' } }, 'Comando de administración para eliminar entornos de zona')