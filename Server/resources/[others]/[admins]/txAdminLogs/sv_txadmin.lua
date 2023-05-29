AddEventHandler('txAdmin:events:playerKicked', function(eventData)

    local target = eventData.target
    local author = eventData.author
    local reason = eventData.reason

    sendToDiscord('Jugador Kickeado', "Nombre: **" .. GetPlayerName(target).. "** \nAutor: **" .. author .. "** \nRazon: **" .. reason .. "**", 65280)

end)

AddEventHandler('txAdmin:events:playerWarned', function(eventData)

    local target = eventData.target
    local author = eventData.author
    local reason = eventData.reason
    local id = eventData.actionId

    sendToDiscord('Jugador Warneado', "Nombre: **" .. GetPlayerName(target).. "** \nAutor: **" .. author .. "** \nRazon: **" .. reason .. "**\nID: **" .. id .. "**", 65280)

end)

AddEventHandler('txAdmin:events:playerBanned', function(eventData)


    local target = eventData.targetName
    local author = eventData.author
    local reason = eventData.reason
    local id = eventData.actionId
    local exp = eventData.expiration

    if not exp then
        exp = 'Never'
    else
        exp = os.date('%c', exp)
    end 

    if (type(target) == "table") then 
        playername = "`Offline Ban`"
    else 
        playername = GetPlayerName(target)
    end
    

    sendToDiscord('Jugador Baneado', "Nombre: **" .. target .. "** \nAutor: **" .. author .. "** \nRazon: **" .. reason .. "**\nID: **" .. id .. "**\nExpira: **" .. exp .. "**", 65280)

end)

AddEventHandler('txAdmin:events:playerWhitelisted', function(eventData)

    local target = eventData.targetName
    local author = eventData.author
    local id = eventData.actionId

    sendToDiscord('Jugador Whitelisteado', "Identificador: **" .. target .. "** \nAutor: **" .. author .. "**\nID: **" .. id .. "**", 65280)

end)

AddEventHandler('txAdmin:events:announcement', function(eventData)

    local author = eventData.author
    local msg = eventData.message

    if Config.FilterAnnouncements then
        if author ~= 'txAdmin' then
            sendToDiscord('Anuncio', "Autor: **" .. author .. "**\nMessage: **" .. msg .. "**", 65280)
        end
    else
        sendToDiscord('Anuncio', "Autor: **" .. author .. "**\nMessage: **" .. msg .. "**", 65280)
    end


end)

AddEventHandler('txAdmin:events:configChanged', function(eventData)

    sendToDiscord('Configuracion Cambiada', "Se han realizado cambios en la configuración de txAdmin, si no fue así, verifíquelo lo antes posible.", 65280)

end)

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)

    local target = eventData.id

    if target == -1 then
        playername = 'Everyone'
    else
        playername = GetPlayerName(target)
    end

    sendToDiscord('Jugador Curado', "Nombre: **" .. playername .. "**", 65280)

end)

AddEventHandler('txAdmin:events:serverShuttingDown', function(eventData)

    local delay = eventData.delay
    local author = eventData.author
    local msg = eventData.message
        
        
    sendToDiscord('Servidor Apagado', "Author: **" .. author .. "**\nMessage: **" .. msg .. "**\nDelay: **" .. delay .. "ms**", 65280)
end)

function sendToDiscord(header, message)
    local webhook = Config.txAdminWebhook
    local name = Config.Username
    local connect = {
          {
              ["title"] = header,
              ["description"] = message
          }
      }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
end
