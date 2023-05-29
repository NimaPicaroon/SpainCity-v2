W.Metadata = {}
W.Metadata.OnlineData = {}
W.Metadata.AllData = {}

W.Metadata.Register = function(identifier, metadata, name, id)
    W.Metadata.OnlineData[identifier] = {
        data = metadata,
        name = name,
        id = id,
    }
    if(W.Metadata.AllData[identifier])then
        W.Metadata.AllData[identifier].data = metadata 
    end
end

W.Metadata.GetMetadataFromIdentifier = function(identifier)
    return W.Metadata.OnlineData[identifier] or false
end

exports("GetMetadataFromIdentifier", W.Metadata.GetMetadataFromIdentifier)

W.Metadata.GetAllOnlineMetadata = function()
    return W.Metadata.OnlineData or false
end

exports("GetAllOnlineMetadata", W.Metadata.GetAllOnlineMetadata)

-- W.Metadata.TransferDiscordModel = function()
--     local date = os.date('*t')
--     local embed = {
--         {
--             ["color"] = 10181046,
--             ["title"] = "Transferencia de especteos prioritarios comenzada...",
--             ["footer"] = {
--                 ["text"] = date.day .. '/' .. date.month .. '/' .. date.year .. ' | ' .. date.hour .. ':' .. date.min ..  ' minutos con ' .. date.sec .. " segundos",
--                 ["icon_url"] = "https://media.discordapp.net/attachments/847188518756679701/1062436457828073612/Isotipo_prueba_negro.png?width=676&height=676",
--             },
--         },
--     }
--     W.Metadata.RequestHttp(false, embed)
--     Citizen.Wait(100)
--     for k, v in pairs(W.Metadata.AllData) do
--         if(v.data)then
--             for metadata, value in pairs(W.Metadata.AllData[k].data) do
--                 if not value.label then value.label = "Not Label" end
--                 if(metadata and metadata == "admin_priority")then
--                     local embed = {
--                         {
--                             ["color"] = 10181046,
--                             ["title"] = "Especteo Prioridad - " .. value.label,
--                             ["footer"] = {
--                                 ["text"] = date.day .. '/' .. date.month .. '/' .. date.year .. ' | ' .. date.hour .. ':' .. date.min ..  ' minutos con ' .. date.sec .. " segundos",
--                                 ["icon_url"] = "https://media.discordapp.net/attachments/847188518756679701/1062436457828073612/Isotipo_prueba_negro.png?width=676&height=676",
--                             },
--                             ["fields"] = {
--                                 {
--                                     name = "Nombre",
--                                     value = v.name,
--                                     inline = true
--                                 },
--                                 {
--                                     name = "Discord",
--                                     value = v.discord,
--                                     inline = true
--                                 },
--                                 {
--                                     name = "Razón",
--                                     value = value.reason,
--                                     inline = true
--                                 },
--                                 {
--                                     name = "Fecha de sanción",
--                                     value = value.date,
--                                     inline = true
--                                 },
--                                 {
--                                     name = "Administrador",
--                                     value = value.author,
--                                     inline = true
--                                 },
--                             },
--                         },
--                     }
--                     W.Metadata.RequestHttp(false, embed)
--                     Citizen.Wait(150)
--                 end
--             end
--         end
--     end
-- end

-- W.Metadata.RequestHttp = function(content, embed)
--     if(content)then
--         PerformHttpRequest(W.Logs["priority_admin"], function(err, text, headers) 
--         end, 'POST', json.encode({username = "Metadata Webhook", content = content}), { ['Content-Type'] = 'application/json' })
--     else
--         PerformHttpRequest(W.Logs["priority_admin"], function(err, text, headers) 
--         end, 'POST', json.encode({username = "Metadata Webhook", embeds = embed}), { ['Content-Type'] = 'application/json' })
--     end
-- end

W.RegisterCommand('prioridad', 'mod', function(playerSrc, args, player)
    if(not args[1] or not args[2] or not args[3])then
        return player.Notify("ERROR", "Indica correctamente los 3 argumentos")
    end

    local targetPlayer = W.GetPlayer(args[1])
    local priorityInt = tonumber(args[2])
    local priorityLabel = W.PriorityLabels[priorityInt] or priorityInt
    table.remove(args, 1)
    table.remove(args, 1)
    local priorityReason = table.concat(args, ' ') 
    if(not targetPlayer)then
        return player.Notify("ERROR", "El jugador que intentas gestionar no está conectado o no existe")
    end
    local date = os.date('*t')
    local metadata = targetPlayer.updatePlayerMetadata("admin_priority", {
        priority = priorityInt,
        label = priorityLabel,
        author = player.name,
        authorLicense = player.identifier,
        date = date.day .. '/' .. date.month .. '/' .. date.year .. ' | ' .. date.hour .. ':' .. date.min,
        permanent = true,
        reason = priorityReason,
    })
    player.Notify("ADMINISTRACIÓN", "Has añadido correctamente a " .. targetPlayer.name .. " a la lista de especteos prioritarios")
end, { { name = 'id', help = 'Id del usuario a poner en prioridad' }, { name = 'priority', help = 'Prioridad | 1-2' }, { name = 'reason', help = 'Razón de la prioridad' } }, 'Comando para asignar prioridad de especteo a un usuario')

W.RegisterCommand('especteos', 'mod', function(playerSrc, args, player)
    local admins = exports["ZC-Admin"]:GetAdminTable()
    if(not admins[playerSrc] or not admins[playerSrc].service)then
        return player.Notify("ERROR", "No estas administrando actualmente", 'error')
    end
    local onlineMetadata = W.Metadata.GetAllOnlineMetadata()
    for k, v in pairs(onlineMetadata) do
        for metadata, value in pairs(v.data) do
            if(metadata and metadata == "admin_priority" and value.priorityInt ~= 0 and v.id ~= playerSrc)then
                TriggerClientEvent('chat:addMessage', playerSrc, { args = {string.format("[%s] | %s", v.id, v.name), string.format("Prioridad: %s | Sancionador: %s | Razón: %s | Fecha: %s", value.label, value.author, value.reason, value.date)}, color = {26, 209, 234} })
            end
        end
    end
end, {}, 'Comando para ver la gente conflictiva actualmente conectada en el servidor')

W.CreateCallback('core:metadata:getAllOnlineMetadata', function(source, callback)
    callback(W.Metadata.GetAllOnlineMetadata() or {})
end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(6000)
--     W.Metadata.TransferDiscordModel() 
-- end)