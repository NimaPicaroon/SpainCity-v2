webhookUrl = 'https://discordapp.com/api/webhooks/'
logs = function(message)
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 
    'POST', json.encode(
        {username = "X", 
        embeds = {
            {["color"] = 16711680, 
            ["author"] = {
            ["name"] = "Dirección Logs",
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"},
            ["description"] = "".. message .."",
            ["footer"] = {
            ["text"] = "SpainCityRP - "..os.date("%x %X %p"),
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png",},}
        }, avatar_url = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"}), {['Content-Type'] = 'application/json' })
end

W.RegisterCommand('setvip', 'admin', function(source, args, player)
    local id = args[1]
    
    if id == 'me' then
        id = source
    else
        id = tonumber(id)
    end

    local player = W.GetPlayer(source)
    local target = W.GetPlayer(id)

    if not target then
        return
    end

    target.setVip(args[2])
    player.Notify('Vip', 'Le has puesto el VIP a '..target.name..'.', 'verify')
    target.Notify('Vip', 'Un administrador te ha puesto el VIP', 'verify')

    W.SendToDiscord('donaciones', "VIP", GetPlayerName(source)..' ha dado el VIP '..args[2]..' a '..target.name, source)
end, { { name = 'id', help = 'ID' }, { name = 'rango', help = 'Rango VIP' } }, 'Comando para dar VIP a un jugador')

W.RegisterCommand('setped', 'admin', function(source, args, player)
    local id = args[1]
    local ped = args[2]
    
    if id == 'me' then
        id = source
    else
        id = tonumber(id)
    end

    local player = W.GetPlayer(source)
    local target = W.GetPlayer(id)

    if not target then
        return
    end

    target.updatePed(ped or "")
end, { { name = 'id', help = 'ID' }, { name = 'ped', help = 'Nombre interno de la ped' } }, 'Comando para dar una ped a un jugador')

W.RegisterCommand('deletevip', 'admin', function(source, args, player)
    local id = args[1]
    
    if id == 'me' then
        id = source
    else
        id = tonumber(id)
    end

    local target = W.GetPlayer(id)

    if not target then
        return
    end

    target.setVip(0)
    player.Notify('Vip', 'Le has quitado el VIP a '..target.name..'.', 'verify')
    target.Notify('Vip', 'Un administrador te ha quitado el VIP', 'verify')
end, { { name = 'id', help = 'ID' } }, 'Comando para quitar VIP a un jugador')

W.RegisterCommand('servicio', 'user', function(source, args, player)
    if not player then
        return
    end

    player.setDuty(not player.job.duty)

    if not player.job.duty then
        player.Notify('Trabajo', 'Has salido de servicio', 'verify')
    else
        player.Notify('Trabajo', 'Has entrado de servicio', 'verify')
    end
end, {}, 'Comando para entrar/salir de servicio')

W.RegisterCommand('setconsolegroup', function(source, args)
    if source > 0 then
        return
    end

    local id = tonumber(args[1])
    local group = tostring(args[2])
    local player = W.GetPlayer(id)

    if not player then
        return
    end

    player.setGroup(group, function(result)
        if result then
            W.SendToDiscord('admin', "SETCONSOLEGROUP", '**Console** set **'..player.name..'** to group **'..group..'**', source)
            W.Print("INFO", "Group changed")
        end
    end)
end, true)

W.RegisterCommand("setgroup", "admin", function(source, args, player)
    local id = args[1]
    local group = args[2]
    if tonumber(id) and group then
        local player = W.GetPlayer(id)
        if not player then return end
        player.setGroup(group, function(result)
            if result then
                W.SendToDiscord('admin', "SETGROUP", '**'..GetPlayerName(source)..'** set **'..player.name..'** to group **'..group..'**', source)
                W.Print("INFO", "Group changed")
            end
        end)
    end
end, { { name = 'id', help = 'ID' }, { name = 'group', help = 'Grupo' } }, 'Comando para dar permisos a un jugador')

W.RegisterCommand("setdimension", "admin", function(source, args, player)
    local id = args[1]
    local dimension = args[2]
    if id == 'me' or tonumber(id) and tonumber(dimension) then
        if id == 'me' then
            id = source
        end

        W.Dimensions.Set(tonumber(id), tonumber(dimension))
    end
end, { { name = 'id', help = 'ID' }, { name = 'dimension', help = 'Dimensión' } }, 'Comando para setear la dimensión a un jugador')

W.RegisterCommand("car", "admin", function(source, args, player)
    local vehicle <const> = args[1]
    local src <const> = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local h = GetEntityHeading(ped)
    local veh = CreateVehicle(GetHashKey(vehicle), coords.x, coords.y, coords.z, h, true, true)
    Wait(100)
    while not DoesEntityExist(veh) do
        Wait(200)
    end
    TaskWarpPedIntoVehicle(ped, veh, -1)
    TriggerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(veh))
    if W.WhitelistedAdmins[player.identifier] then
        --print ("personawl")
    else
        W.SendToDiscord('admin', "CAR", '**'..GetPlayerName(source)..'** spawneó un: '..vehicle, source)
        logs('\n **Comando:** CAR '..vehicle..' \n**Administrador:** '..GetPlayerName(source)..' ')
    end	
    TriggerClientEvent("ZC-Admin:repair", player.src, 'caradmin')
end, { { name = 'car', help = 'Coche' } }, 'Comando para spawnear un vehículo')

W.RegisterCommand("dv", "mod", function(source, args, player)
    local range <const> = args[1]
    if range and tonumber(range) then
        TriggerClientEvent("core:client:deleteVehsInArea", player.src, tonumber(range))
        if W.WhitelistedAdmins[player.identifier] then
            --print ("personawl")
        else
        logs('\n **Comando:** DV '..range..' \n**Administrador:** '..GetPlayerName(source)..' ')
        end
    else
        TriggerClientEvent("core:client:deleteVehsInArea", player.src, 1)
        if W.WhitelistedAdmins[player.identifier] then
            --print ("personawl")
        else
        logs('\n **Comando:** DV \n**Administrador:** '..GetPlayerName(source)..' ')
        end	
    end
end, {{ name = 'range', help = 'Rango' }}, 'Comando para eliminar un vehículo')

W.RegisterCommand("save", "admin", function(source, args, player)
    if not args[1] then
        player.savePlayer()
    else
        if not tonumber(args[1]) then return end
        local Player = W.GetPlayer(args[1])
        Player.savePlayer()
    end
end, {{ name = 'id', help = 'Id' }}, 'Comando para guardar los datos de un jugador')

W.RegisterCommand("giveaccountmoney", "admin", function(source, args, player)
    if not tonumber(args[1]) then return end
    local Player = W.GetPlayer(args[1])
    if args[1] == "me" then
        args[1] = source
        Player = player
    end
    if W.WhitelistedAdmins[player.identifier] then
        --print ("personawl")
    else
        W.SendToDiscord('admin', "GIVEACCOUNTMONEY", '**'..GetPlayerName(source)..'** gave **'..GetPlayerName(Player.src)..'** $'..args[3].." en "..args[2], source)
        logs('\n **Comando:** GIVEACCOUNTMONEY - '..args[3]..' a '..GetPlayerName(Player.src)..' \n**Administrador:** '..GetPlayerName(source)..' ')	
    end
    Player.addMoney(args[2], args[3])
    print(json.encode(Player.money))
end, {{ name = 'id', help = 'Id' }, { name = 'account', help = 'money|bank|crypto|coins' }, { name = 'amount', help = 'Cantidad' }}, 'Comando para dar dinero a un jugador')

W.RegisterCommand("removeaccountmoney", "admin", function(source, args, player)
    if not tonumber(args[1]) then return end
    local Player = W.GetPlayer(args[1])
    if args[1] == "me" then
        args[1] = source
        Player = player
    end
    if W.WhitelistedAdmins[player.identifier] then
        --print ("personawl")
    else
        W.SendToDiscord('admin', "REMOVEACCOUNTMONEY", '**'..GetPlayerName(source)..'** remove **'..GetPlayerName(Player.src)..'** $'..args[3].." en "..args[2], source)
        logs('\n **Comando:** REMOVEACCOUNTMONEY - '..args[3]..' a '..GetPlayerName(Player.src)..' \n**Administrador:** '..GetPlayerName(source)..' ')
    end
    Player.removeMoney(args[2], args[3])
    print(json.encode(Player.money))
end, {{ name = 'id', help = 'Id' }, { name = 'account', help = 'money|bank|crypto|coins' }, { name = 'amount', help = 'Cantidad' }}, 'Comando para retirar dinero a un jugador')

W.RegisterCommand("saveall", "admin", function(source, args, player)
    W.SaveAll()
end)

W.RegisterCommand("giveitem", "mod", function(source, args, player)
    local src = source
    if #args == 3 then
        local id = args[1]
        local name = args[2]
        local amount = args[3]
        if W.Items[name] then
            local slotId = W.SlotId()
            if id == "me" then
                if player.canHoldItem(name, tonumber(amount)) then
                    if not W.IsWeapon(name) then
                        player.addItemToInventory(name, tonumber(amount), W.DefaultMetadata[name] or false, slotId)
                    else
                        player.addItemToInventory(name, tonumber(amount), W.DefaultMetadata['weapon'], slotId)
                    end
                    if W.WhitelistedAdmins[player.identifier] then
                        --print ("personawl")
                    else
                        W.SendToDiscord('admin', "GIVEITEM", '**'..GetPlayerName(src)..'** gave **a si mismo** x'..amount..' '..name, src)
                        logs('\n **Comando:** GIVEITEM - x'..amount..' '..name..' a si mismo \n**Administrador:** '..GetPlayerName(src)..' ')
                    end
                end
            elseif tonumber(id) then
                local ply = W.GetPlayer(tonumber(id))
                if ply.canHoldItem(name, tonumber(amount)) then
                    if not W.IsWeapon(name) then
                        ply.addItemToInventory(name, tonumber(amount), W.DefaultMetadata[name] or false, slotId)
                    else
                        ply.addItemToInventory(name, tonumber(amount), W.DefaultMetadata['weapon'], slotId)
                    end
                    if W.WhitelistedAdmins[player.identifier] then
                        --print ("personawl")
                    else
                        W.SendToDiscord('admin', "GIVEITEM", '**'..GetPlayerName(src)..'** gave **'..GetPlayerName(id)..'** x'..amount..' '..name, src)
                        logs('\n **Comando:** GIVEITEM - x'..amount..' '..name..' a '..GetPlayerName(id)..' \n**Administrador:** '..GetPlayerName(src)..' ')
                    end
                end
            end
        else
            player.Notify("ERROR", "El item no existe", "error")
        end
    else
        player.Notify("ERROR", "El comando precisa tres argumentos", "error")
    end
end, {{ name = 'id', help = 'Id' }, { name = 'item', help = 'Nombre del Item' }, { name = 'amount', help = 'Cantidad' }}, 'Comando para dar un item a un jugador')

W.RegisterCommand("clearinventory", "admin", function(source, args, player)
    if #args == 0 then
        player.setInventory()
    else
        local id = tonumber(args[1])
        local ply = W.GetPlayer(id)
        if ply then
            ply.setInventory()
            if W.WhitelistedAdmins[player.identifier] then
                --print ("personawl")
            else
            logs('\n **Comando:** CLEARINVENTORY a '..GetPlayerName(id)..' \n**Administrador:** '..GetPlayerName(source)..' ')
            end
        end
    end
end, {{ name = 'id', help = 'Id' }}, 'Comando para borrar el inventario de un jugador')

W.RegisterCommand("clearloadout", "admin", function(source, args, player)
    if(args[1] == "me")then
        args[1] = source
    end
    local id = tonumber(args[1])
    local ply = W.GetPlayer(id)
    if ply then
        ply.clearLoadout()
        if W.WhitelistedAdmins[player.identifier] then
            --print ("personawl")
        else
        logs('\n **Comando:** CLEARLOADOUT a '..GetPlayerName(id)..' \n**Administrador:** '..GetPlayerName(source)..' ')
        end
    end
end, {{ name = 'id', help = 'Id' }}, 'Comando para quitar las armas a un jugador')

W.RegisterCommand("updatestat", "admin", function(source, args, player)
    if args[1] and tonumber(args[2]) then
        W.SendToDiscord('admin', "UPDATESTAT", '**'..GetPlayerName(source)..'** updated stat **'..args[1]..'** to **'..args[2]..'**', source)
        player.setStat(args[1], args[2])
    end
end, {{ name = 'type', help = 'stamina|strength|stress|diving' }, { name = 'amount', help = 'Cantidad' }}, 'Comando para dar stats a un jugador')

W.RegisterCommand('clear', 'user', function(source, args, player)
	TriggerClientEvent('chat:clear', player.src)
end, {}, 'Comando para borrarte el chat')

W.RegisterCommand('cls', 'user', function(source, args, player)
	TriggerClientEvent('chat:clear', player.src)
end, {}, 'Comando para borrarte el chat')

W.RegisterCommand('clearall', 'admin', function()
	TriggerClientEvent('chat:clear', -1)
    logs('\n **Comando:** CLEARALL \n**Administrador:** '..GetPlayerName(source)..' ')
end, {}, 'Comando para borrar el chat')

W.RegisterCommand('clsall', 'admin', function()
	TriggerClientEvent('chat:clear', -1)
    logs('\n **Comando:** CLSALL \n**Administrador:** '..GetPlayerName(source)..' ')
end, {}, 'Comando para borrar el chat')

W.RegisterCommand('customs', 'admin', function(source)
    local ped = GetPlayerPed(source)
    TriggerClientEvent('qb-customs:client:EnterCustoms', source, {
        coords = GetEntityCoords(ped),
        heading = GetEntityHeading(ped),
        categories = {
            repair = true,
            mods = true,
            armor = true,
            respray = true,
            liveries = true,
            wheels = true,
            tint = true,
            plate = true,
            extras = true,
            neons = true,
            xenons = true,
            horn = true,
            turbo = true,
            cosmetics = true,
        }
    })
end, {}, 'Abrir menú de tuneo')
