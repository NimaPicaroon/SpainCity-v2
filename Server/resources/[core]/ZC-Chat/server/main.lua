function logschr7(header, message)
    local webhook = "https://discord.com/api/webhooks/1101854877275127810/M_6RGPEjYAihRnHyagIAnv71Pp96IqSB7hV57F7vSeJJgdSGPlRQnHS45CRfST7UiwiA"
    local name = "CENTRALITA"
    local connect = {
          {
              ["title"] = header,
              ["description"] = message
          }
      }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
end

-- @main
AddEventHandler('chatMessage', function(player, playerName, playerMsg)
    if playerMsg:sub(1, 1) ~= '/' and player > 0 then
        TriggerClientEvent('ZC-Chat:checkDistances', player, playerMsg)
        W.SendToDiscord('chat', 'OOP', playerMsg, player)
    end

    CancelEvent()
end)

RegisterNetEvent('ZC-Chat:sendOop', function(playerMessage, players)
    local src = source
    local player = W.GetPlayer(src)

    if players then
        for k,v in pairs(players) do
            TriggerClientEvent('ZC-Chat:chat:proximity', v.source, src, 'oop', playerMessage, '', true)
        end
    end
    TriggerClientEvent('ZC-Chat:chat:proximity', src, src, 'oop', playerMessage, '', true)
end)

RegisterNetEvent('ZC-Chat:proximity', function(targetId, messageTitle, playerMessage, name, players)
    if players then
        for k,v in pairs(players) do
            TriggerClientEvent('ZC-Chat:chat:proximity', v.source, targetId, messageTitle, playerMessage, name)
        end
    end
    TriggerClientEvent('ZC-Chat:chat:proximity', source, targetId, messageTitle, playerMessage, name)
end)

RegisterNetEvent('ZC-Chat:sendMe', function(playerMessage, players)
    local src = source
    local player = W.GetPlayer(src)
    local playerName = player.identity.name..' '..player.identity.lastname
    W.SendToDiscord('chat', 'ME', playerMessage, src)
    TriggerClientEvent('ZC-Chat:chat:proximitySource', src, NetworkGetNetworkIdFromEntity(GetPlayerPed(src)), src, 'me', playerMessage, playerName, players)
end)

RegisterNetEvent('ZC-Chat:sendDo', function(playerMessage, players)
    local src = source
    local player = W.GetPlayer(src)
    local playerName = player.identity.name..' '..player.identity.lastname
    W.SendToDiscord('chat', 'DO', playerMessage, src)
    TriggerClientEvent('ZC-Chat:chat:proximitySource', src, NetworkGetNetworkIdFromEntity(GetPlayerPed(src)), src, 'do', playerMessage, playerName, players)
end)

RegisterNetEvent('ZC-Chat:sendIntentar', function(playerMessage, players)
    local src = source
    local player = W.GetPlayer(src)

    if players then
        for k,v in pairs(players) do
            TriggerClientEvent('ZC-Chat:chat:proximity', v.source, src, "try", playerMessage, '')
        end
    end
    TriggerClientEvent('ZC-Chat:chat:proximity', src, src, "try", playerMessage, '')
end)

RegisterCommand('comunidad', function(source, args, rawCommand)
    local src = source
    local player = W.GetPlayer(src)
    TriggerClientEvent('chat:sendTwtMessage', -1, { 
        args = {
            "^1[^3Comunidad^0] [(^3"..source.."^0) "..player.name.. "]",
            table.concat(args, ' ')
        }, color = { 255, 250, 74 }
    })
end, false)

RegisterCommand('anon', function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('chat:sendTwtMessage', -1, { 
        args = {
            "^1[DarkWeb] (^3"..source.."^0)",
            table.concat(args, ' ')
        }, color = { 255, 75, 75 }
    })
end, false)

RegisterCommand('twt', function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('chat:sendTwtMessage', -1, { 
        args = {
            "^1[Twitter] ("..source..")(^4"..GetPlayerName(source).."^0)",
            table.concat(args, ' ')
        }, color = { 115, 150, 252 }
    })
end, false)

RegisterNetEvent('ZC-Chat:sendDados', function(playerMessage, players)
    local src = source
    local player = W.GetPlayer(src)
    if players then
        for k,v in pairs(players) do
            TriggerClientEvent('ZC-Chat:chat:proximity', v.source, src, "dados", playerMessage, '')
        end
    end
    TriggerClientEvent('ZC-Chat:chat:proximity', src, src, "dados", playerMessage, '')
end)

W.RegisterCommand('polidispo', 'user', function(playerSrc, playerArgs, player)
    TriggerClientEvent('chat:sendPoliDispo', playerSrc)
end, {}, 'Comando para enviar un entorno para preguntar la policía disponible')

W.RegisterCommand('msg', 'user', function(playerSrc, playerArgs, player)
    if playerArgs[1] and playerArgs[2] then
        local otherPlayer = W.GetPlayer(playerArgs[1])
        if otherPlayer then
            local playerMessage = table.concat(playerArgs, ' ', 2)
            local name = GetPlayerName(playerSrc)

            TriggerClientEvent('chat:addMessage', playerArgs[1], {
                template = '<div style="font-size: 0.93rem; margin-bottom: 5px;"><span style=color:#17bb13>MSG | [ID {1} - {2}]</span>: {3} </div>',
                args = { fal, playerSrc, name, playerMessage }
            })

            TriggerClientEvent('chat:addMessage', playerSrc, {
                template = '<div style="font-size: 0.93rem; margin-bottom: 5px;"><span style=color:#17bb13>MSG | [ID {1} - {2}]</span>: {3} </div>',
                args = { fal, playerSrc, name, playerMessage }
            })

            W.SendToDiscord('msg', 'MSG', '**'..GetPlayerName(playerSrc)..'** para **'..GetPlayerName(playerArgs[1])..':\n** '..playerMessage, playerSrc)
        else
            TriggerClientEvent('chat:addMessage', playerSrc, { args = { '^1SYSTEM', 'Esa ID no est� jugando... '} })
        end
    end
end, {{ name = 'id', help = 'ID del jugador' }, { name = 'message', help = 'Mensaje' } }, 'Comando para enviar mensajes privados')

W.RegisterCommand('f', 'user', function(playerSrc, playerArgs, player)
    local playerMessage = table.concat(playerArgs, ' ')
    local playerName = player.identity.name..' '..player.identity.lastname
    if player.job ~= nil and player.job.name == "police" then
        local format = playerName..' | '..player.job.assignation
    
            if player.job.assignation == 'none' then
                format = player.job.ranklabel.. ' | '..playerName
            end
            TriggerClientEvent('ZC-Chat:chat:radio', -1, player.job.name, { (Settings.chat.factions[player.job.name].message):format(format), playerMessage }, Settings.chat.factions[player.job.name].color, 2)
            logschr7('REGISTRO RADIO INTERNA', "**"..playerName.."**: "..playerMessage.."\n\n**Identificador:** "..GetPlayerName(playerSrc), 65280)
    else
        if player.job ~= nil and Settings.chat.factions[player.job.name] then
            local format = playerName..' | '..player.job.assignation
    
            if player.job.assignation == 'none' then
                format = player.job.ranklabel.. ' | '..playerName
            end
    
            TriggerClientEvent('ZC-Chat:chat:radio', -1, player.job.name, { (Settings.chat.factions[player.job.name].message):format(format), playerMessage }, Settings.chat.factions[player.job.name].color, 0)
            --logschr7('REGISTRO RADIO INTERNA', "**"..playerName.."**: "..playerMessage.."\n\n**Identificador:** "..GetPlayerName(playerSrc), 65280)
        end
    end
end, { { name = 'message', help = 'Mensaje' } }, 'Comando para enviar mensaje a la radio interna de tu facci�n')

W.RegisterCommand('fsams', 'user', function(playerSrc, playerArgs, player)
    local playerMessage = table.concat(playerArgs, ' ')
    local playerName = player.identity.name..' '..player.identity.lastname

    if player.job ~= nil then
        local format = player.job.ranklabel.. ' | '..playerName

        if player.job.name == 'police' then
            TriggerClientEvent('ZC-Chat:chat:specialRadio', -1, {'police', 'ambulance'}, { (Settings.chat.factions['police-ambulance'].message):format(format), playerMessage }, Settings.chat.factions['police-ambulance'].color)
        elseif player.job.name == 'ambulance' then
            TriggerClientEvent('ZC-Chat:chat:specialRadio', -1, {'ambulance', 'police'}, { (Settings.chat.factions['ambulance-police'].message):format(format), playerMessage }, Settings.chat.factions['ambulance-police'].color)
        end
    end
end, { { name = 'message', help = 'Mensaje' } }, 'Comando para enviar mensaje a la radio interna de tu facción')