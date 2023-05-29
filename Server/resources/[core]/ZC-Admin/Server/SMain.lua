local backs = {}
admins = {}

RegisterNetEvent('admin:playerLoaded', function()
    local src = source
    local ply = W.GetPlayer(src)

    if ply and ply.group then
        if W.Groups[ply.group] > 0 then
            admins[src] = {service = true, player = ply, source = src}
        end 
    end
end)

RegisterNetEvent('ZCore:updateGroup', function(player, source, group)
    if group == 'user' and admins[player.src] then
        admins[player.src] = nil
    end

    if not admins[player.src] and W.Groups[player.group] > 0 then
        admins[player.src] = {service = false, player = player, source = player.src}
    end
end)

AddEventHandler('ZCore:playerDisconnected', function(source, player)
    if W.Groups[player.group] > 0 then
        admins[source] = nil
    end
end)

W.RegisterCommand('adminservicio', 'mod', function(playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    admins[playerSrc].service = not admins[playerSrc].service

    if admins[playerSrc].service then
        player.Notify('Staff', 'Has entrado de servicio', 'info')
    else
        player.Notify('Staff', 'Te has salido de servicio', 'info')
    end
end, {}, 'Comando para cambiar el estado de la Staff')

W.RegisterCommand('a', 'mod', function(playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local playerMessage = table.concat(playerArgs, ' ')
    if playerMessage ~= '' then
        for k,v in pairs(admins) do
            if v.service then
                TriggerClientEvent('chat:addMessage', v.source, { args = {string.format('Chat de Staff | [%s', playerSrc..'] - '..GetPlayerName(playerSrc)), playerMessage }, color = {41, 141, 214} })
            end
        end
        W.SendToDiscord("chat", "ADMIN CHAT", playerMessage, playerSrc)
    else
        player.Notify('Staff', "Escribe el mensaje", 'error')
    end
end, { { name = 'message', help = 'Mensaje' } }, 'Comando para enviar mensajes entre el staff')

W.RegisterCommand('staff', 'mod', function(playerSrc, playerArgs, player)
    local StringListAdmins = ""
    for k, v in pairs(admins) do
        if v.service then
            if StringListAdmins == "" then
                StringListAdmins = StringListAdmins .. " " .. GetPlayerName(v.source)
            else
                StringListAdmins = StringListAdmins .. ", " .. GetPlayerName(v.source)
            end
        end
    end

    TriggerClientEvent('chat:addMessage', playerSrc, { args = {string.format('Lista de Staff\'s | [%s', playerSrc..'] - '.."Lista Admins Servicio"), StringListAdmins }, color = {41, 141, 214} })
end)

function GetAdminsConnected()
    local count = 0
    for k, v in pairs(admins) do
        count = count +1
    end
    return count
end

W.RegisterCommand('openinventory', 'admin', function(playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    if(not playerArgs[1])then
        player.Notify('Staff', "Tienes que indicar la ID del jugador en el segundo argumento", 'error')
        return
    end
    local player = tonumber(playerArgs[1])
    TriggerEvent("thief:start", player, true, playerSrc)
end, { { name = 'id', help = 'Id del jugador' } }, 'Comando para revisar el inventario de un jugador')


W.RegisterCommand('tpm', 'mod', function(playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    TriggerClientEvent('ZC-Admin:tpm', playerSrc)
    logschr7('\n **Comando:** TPM \n**Administrador:** '..GetPlayerName(playerSrc)..' ')	
end, {}, 'Comando para teletransportarse a un lugar')

W.RegisterCommand("repair", 'mod', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local player = W.GetPlayer(playerSrc)
    
    TriggerClientEvent("ZC-Admin:repair", playerSrc)
    if Cfg.WhitelistedAdmins[player.identifier] then
        --print ("personawl")
    else
    logschr7('\n **Comando:** REPAIR \n**Administrador:** '..GetPlayerName(playerSrc)..' ')	
    end
end, {}, 'Comando para reparar un coche')

W.RegisterCommand("noclip", 'mod', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local player = W.GetPlayer(playerSrc)

    TriggerClientEvent("ZC-Admin:noclip", playerSrc)
    if Cfg.WhitelistedAdmins[player.identifier] then
        --print ("personawl")
    else
        logschr7('\n **Comando:** NOCLIP \n**Administrador:** '..GetPlayerName(playerSrc)..' ')	
    end
end, {}, 'Comando para usar el noclip')

W.RegisterCommand("inv", 'mod', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    TriggerClientEvent("ZC-Admin:inv", playerSrc)
    if Cfg.WhitelistedAdmins[player.identifier] then
        --print ("personawl")
    else
        logschr7('\n **Comando:** INV \n**Administrador:** '..GetPlayerName(playerSrc)..' ')
    end
end, {}, 'Comando para ponerte invisible')

W.RegisterCommand("tp", 'mod', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    if playerArgs[1] and playerArgs[2] and playerArgs[3] then
        TriggerClientEvent("ZC-Admin:tp", playerSrc, {x = playerArgs[1], y = playerArgs[2], z = playerArgs[3]})
        logschr7('\n **Comando:** TP\n**Coords: **x:'..playerArgs[1]..' y:'..playerArgs[2]..' z:'..playerArgs[3]..' \n**Administrador:** '..GetPlayerName(playerSrc)..' ')	
    else
        player.Notify('Staff', "Coordenadas inv�lidas", 'error')
    end
end, {{ name = 'x', help = 'x' }, { name = 'y', help = 'y' }, { name = 'z', help = 'z' }}, 'Comando para teletransportarse a unas coordenadas')

W.RegisterCommand("goto", 'mod', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local target = W.GetPlayer(playerArgs[1])
    if target then
        TriggerClientEvent("ZC-Admin:tp", playerSrc, GetEntityCoords(GetPlayerPed(playerArgs[1])))
        logschr7('\n **Comando:** GOTO a la ID: '..playerArgs[1]..' \n**Administrador:** '..GetPlayerName(playerSrc)..' ')	
    else
        player.Notify('Staff', "El jugador no esta jugando", 'error')
    end
end, {{ name = 'id', help = 'ID' }}, 'Comando para teletransportarse a un jugador')

W.RegisterCommand("bring", 'mod', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local target = W.GetPlayer(playerArgs[1])
    if target then
        backs[target.src] = GetEntityCoords(GetPlayerPed(playerArgs[1]))
        local coords = GetEntityCoords(GetPlayerPed(playerSrc))
        TriggerClientEvent("ZC-Admin:tp", target.src, coords)
        logschr7('\n **Comando:** BRING a la ID: '..playerArgs[1]..' \n**Administrador:** '..GetPlayerName(playerSrc)..' ')	
    else
        player.Notify('Staff', "El jugador no esta jugando", 'error')
    end
end, {{ name = 'id', help = 'ID' }}, 'Comando para traer a un jugador a tu posici�n')

W.RegisterCommand("back", 'mod', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local target = W.GetPlayer(playerArgs[1])
    if target and backs[target.src] then
        TriggerClientEvent("ZC-Admin:tp", target.src, backs[target.src])
        backs[target.src] = nil
        logschr7('\n **Comando:** BACK a la ID: '..target.src..' \n**Administrador:** '..GetPlayerName(playerSrc)..' ')	
    else
        player.Notify('Staff', "El jugador no esta jugando o no ha sido tepeado", 'error')
    end
end, {{ name = 'id', help = 'ID' }}, 'Comando para llevar a un jugador a su posici�n anterior')

W.RegisterCommand("freeze", 'mod', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local target = W.GetPlayer(playerArgs[1])
    if target then
        TriggerClientEvent("ZC-Admin:freeze", target, true)
        --logschr7('\n **Comando:** FREEZE a la ID: '..target..' \n**Administrador:** '..GetPlayerName(playerSrc)..' ')	
    else
        player.Notify('Staff', "El jugador no esta jugando", 'error')
    end
end, {{ name = 'id', help = 'ID' }}, 'Comando para freezear a un jugador')

W.RegisterCommand("unfreeze", 'mod', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local target = W.GetPlayer(playerArgs[1])
    if target then
        TriggerClientEvent("ZC-Admin:freeze", target, false)
        --logschr7('\n **Comando:** UNFREEZE a la ID: '..target..' \n**Administrador:** '..GetPlayerName(playerSrc)..' ')	
    else
        player.Notify('Staff', "El jugador no esta jugando", 'error')
    end
end, {{ name = 'id', help = 'ID' }}, 'Comando para desfreezear a un jugador')

W.RegisterCommand("ped", 'admin', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    if playerArgs[1] == 'me' then
        playerArgs[1] = playerSrc
    end

    local target = W.GetPlayer(playerArgs[1])
    if target then
        TriggerClientEvent("ZC-Admin:setPed", target.src)
    else
        player.Notify('Staff', "El jugador no esta jugando", 'error')
    end
end, {{ name = 'id', help = 'ID' }}, 'Comando para setearse una ped')

W.RegisterCommand("ck", 'admin', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local target = tonumber(playerArgs[1])
    local targetPly = W.GetPlayer(target)

    if targetPly and targetPly.identifier then
        local license = targetPly.identifier

        player.Notify('CK', "El jugador estaba conectado, desconectando jugador..", 'info')
        exports["ZCore"]:CKMode(targetPly.identifier)
        DropPlayer(targetPly.src, "Se te está haciendo un CK")
        W.SendToDiscord("admin", "CK", GetPlayerName(playerSrc).." le hizo CK a "..targetPly.name.." | "..targetPly.identifier, playerSrc)
        Citizen.Wait(1000)

        local ply = MySQL.Sync.fetchAll('SELECT * FROM players WHERE token=@id', {['@id'] = license})
        if ply and ply[1] and tonumber(ply[1].have_house) ~= 0 then
            TriggerEvent("Ox-Housing:server:sellHouseCK", tonumber(ply[1].have_house), license)
        end
        local vehicles = exports['ZC-Garages']:getVehiclesByIdentifier(license)
        exports["ZCore"]:ResetPaycheckCount(license)

        for k,v in ipairs(vehicles) do
            exports['ZC-Garages']:deleteVehicle(v.plate)
        end

        local queries = {
            { query = 'DELETE FROM `players` WHERE `token` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `accounts` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `outfits` WHERE `identifier` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `owned_vehicles` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_ads` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_chats` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_contacts` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_groups` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `storage` WHERE `name` = :wipeIDStorage', values = { ['wipeIDStorage'] = "police-"..license } },
            { query = 'DELETE FROM `notas` WHERE `citizenid` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `notas_admin` WHERE `citizenid` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `delitos` WHERE `identifier` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `okokbilling` WHERE `receiver_identifier` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_phones` WHERE `id` = :wipeID', values = { ['wipeID'] = license } },
        }
        exports.oxmysql:transaction(queries, function(result) 
            if player then
                player.Notify('CK', 'Ck realizado', "verify")

            end
        end)
        W.Connection.ClearCacheInfo(license, true)
    else
        player.Notify('CK', "El jugador no esta jugando", 'error')
    end

    
    
end, {{ name = 'playerId', help = 'ID del jugador' }}, 'Comando para hacer ck a un jugador')

W.RegisterCommand("ckdiscord", 'admin', function (playerSrc, playerArgs, player)
    if not admins[playerSrc] then return end

    local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE discord = ?', { 'discord:'..playerArgs[1] })

    if not result or not result[1] then
        return player.Notify('CK Discord', 'No hay ningún jugador con esta ID de discord', 'error')
    end

    if result[1] and result[1].token then
        local license = result[1].token

        exports["ZCore"]:CKMode(license)
        Citizen.Wait(1000)

        if tonumber(result[1].have_house) ~= 0 then
            TriggerEvent("Ox-Housing:server:sellHouseCK", tonumber(result[1].have_house), license)
        end
        
        local vehicles = exports['ZC-Garages']:getVehiclesByIdentifier(license)
        exports["ZCore"]:ResetPaycheckCount(license)

        for k,v in ipairs(vehicles) do
            exports['ZC-Garages']:deleteVehicle(v.plate)
        end

        local queries = {
            { query = 'DELETE FROM `players` WHERE `token` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `accounts` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `outfits` WHERE `identifier` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `owned_vehicles` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_ads` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_chats` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_contacts` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_groups` WHERE `owner` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `storage` WHERE `name` = :wipeIDStorage', values = { ['wipeIDStorage'] = "police-"..license } },
            { query = 'DELETE FROM `notas` WHERE `citizenid` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `notas_admin` WHERE `citizenid` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `delitos` WHERE `identifier` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `okokbilling` WHERE `receiver_identifier` = :wipeID', values = { ['wipeID'] = license } },
            { query = 'DELETE FROM `phone_phones` WHERE `id` = :wipeID', values = { ['wipeID'] = license } },
        }
        exports.oxmysql:transaction(queries, function(result) 
            if player then
                player.Notify('CK', 'CK realizado', "verify")
                W.SendToDiscord("admin", "CKDISCORD", GetPlayerName(playerSrc).." le hizo CK a <@"..playerArgs[1].."> | "..license , playerSrc)
            end
        end)
        W.Connection.ClearCacheInfo(license, true)
    else
        player.Notify('CK', "El jugador no esta jugando", 'error')
    end
    
end, {{ name = 'discord', help = 'ID de discord' }}, 'Comando para hacer ck a un jugador')

exports("GetAdminTable", function()
    return admins 
end)

webhookUrl = 'https://discord.com/api/webhooks/1099082830887264306/YP29KjzvRSu0L8LgRjBNpEQy5W7mrX8IaxFuOFKUSZdW1SZfFs-R6Fl8vfC6aKEvWASI'
logschr7 = function(message)
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