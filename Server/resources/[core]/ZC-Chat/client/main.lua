-- @main
RegisterNetEvent('ZC-Chat:chat:radio')
AddEventHandler('ZC-Chat:chat:radio', function(playerFaction, playerMessage, messageColor, tyspe)
    local playerData = W.GetPlayerData()
    local myrank = playerData.job.rank
    -- if tyspe == 1 then
    --     if playerData.job and playerData.job.name == playerFaction and myrank > 15 then
    --         if playerData.job.duty then
    --             TriggerEvent('chat:addMessage', {args = playerMessage, color = messageColor})
    --         end
    --     end
    -- elseif tyspe == 2 then
    --     if playerData.job and playerData.job.name == playerFaction and myrank <= 15 then
    --         if playerData.job.duty then
    --             TriggerEvent('chat:addMessage', {args = playerMessage, color = messageColor})
    --         end
    --     end
    -- else
        if playerData.job and playerData.job.name == playerFaction then
            if playerData.job.duty then
                TriggerEvent('chat:addMessage', {args = playerMessage, color = messageColor})
            end
        end
    -- end
end)

RegisterNetEvent('ZC-Chat:chat:specialRadio')
AddEventHandler('ZC-Chat:chat:specialRadio', function(factions, playerMessage, messageColor)
    local playerData = W.GetPlayerData()

    if playerData.job and (playerData.job.name == factions[1] or playerData.job.name == factions[2]) then
        if playerData.job.duty then
            TriggerEvent('chat:addMessage', {args = playerMessage, color = messageColor})
        end
    end
end)

RegisterNetEvent('chat:sendPoliDispo')
AddEventHandler('chat:sendPoliDispo', function()
    local playerId = GetPlayerServerId(PlayerId())

    ExecuteCommand('entorno Inteligencia informa de un posible robo')
end)


RegisterNetEvent('ZC-Chat:chat:proximity')
AddEventHandler('ZC-Chat:chat:proximity', function(targetId, messageTitle, playerMessage, name, isOop, netId)
    if isOop then
        TriggerEvent('chat:addMessage', {
            template = Settings.chat.types[messageTitle]:format(playerMessage),
            args = { '['..targetId..'] OOP', playerMessage}
        })
    else
        local targetPed = NetworkGetEntityFromNetworkId(netId)
        if GetPedDrawableVariation(targetPed, 1) > 0 then
            name = 'Anónimo'
        end
        if messageTitle == "me" or messageTitle == "do" then
            TriggerEvent('chat:addMessage', {
                template = Settings.chat.types[messageTitle]:format(playerMessage),
                args = { '['..targetId..'] ', playerMessage}
            })
        else
            if Settings.chat.types[messageTitle] then
                TriggerEvent('chat:addMessage', {
                    template = Settings.chat.types[messageTitle]:format(playerMessage),
                    args = { '['..targetId..'] '..name, playerMessage}
                })
            end
        end
    end
end)

RegisterNetEvent('ZC-Chat:chat:proximitySource')
AddEventHandler('ZC-Chat:chat:proximitySource', function(netId, targetId, messageTitle, playerMessage, messageColor, players)
    local name = nil
    local targetPed = NetworkGetEntityFromNetworkId(netId)

    if GetPedDrawableVariation(targetPed, 1) > 0 then
        name = 'Anónimo'
        TriggerServerEvent('ZC-Chat:proximity', targetId, messageTitle, playerMessage, name, players)
    else
        name = messageColor
        TriggerServerEvent('ZC-Chat:proximity', targetId, messageTitle, playerMessage, name, players)
    end
end)

RegisterCommand("me", function(src, args)
    local playerMessage = table.concat(args, ' ')
    if playerMessage ~= "" then
        local players = W.GetPlayersInArea(GetEntityCoords(PlayerPedId()), Settings.chat.proximityRadius)
        if players then
            for k,v in pairs(players) do 
                players[k] = {source = GetPlayerServerId(v)}
            end
        end
        TriggerServerEvent("ZC-Chat:sendMe", playerMessage, players)
    end
end)

RegisterCommand("do", function(src, args)
    local playerMessage = table.concat(args, ' ')
    if playerMessage ~= "" then
        local players = W.GetPlayersInArea(GetEntityCoords(PlayerPedId()), Settings.chat.proximityRadius)
        if players then
            for k,v in pairs(players) do 
                players[k] = {source = GetPlayerServerId(v)}
            end
        end
        TriggerServerEvent("ZC-Chat:sendDo", playerMessage, players)
    end
end)

RegisterCommand("intentar", function(src, args)
    local players = W.GetPlayersInArea(GetEntityCoords(PlayerPedId()), Settings.chat.proximityRadius)
    if players then
        for k,v in pairs(players) do 
            players[k] = {source = GetPlayerServerId(v)}
        end
    end
    local playerChoose = math.random(1, 2)
    local playerMessage = 'Si'
    if playerChoose >= 2 then
        playerMessage = 'No'
    end
    TriggerServerEvent("ZC-Chat:sendIntentar", playerMessage, players)
end)

RegisterCommand("dados", function(src, args)
    local players = W.GetPlayersInArea(GetEntityCoords(PlayerPedId()), Settings.chat.proximityRadius)
    if players then
        for k,v in pairs(players) do 
            players[k] = {source = GetPlayerServerId(v)}
        end
    end
    if args[1] and args[2] then
        local playerChoose = math.random(args[1], args[2])
        TriggerServerEvent("ZC-Chat:sendDados", 'Entre ('..args[1]..','..args[2]..') ha salido el número '..playerChoose, players)
    else
        local playerChoose = math.random(1, 6)

        TriggerServerEvent("ZC-Chat:sendDados", 'Ha salido el número '..playerChoose, players)
    end
end)

RegisterNetEvent('ZC-Chat:checkDistances')
AddEventHandler('ZC-Chat:checkDistances', function(playerMessage)
    local players = W.GetPlayersInArea(GetEntityCoords(PlayerPedId()), Settings.chat.proximityRadius)
    if players then
        for k,v in pairs(players) do 
            players[k] = {source = GetPlayerServerId(v)}
        end
    end

    TriggerServerEvent("ZC-Chat:sendOop", playerMessage, players)
end)

local restringed = false

RegisterCommand('esconderchat',
    function()
        if restringed then
            restringed = false
            W.Notify('success', 'Ahora se muestran los mensajes globales', 'verify')
        else
            restringed = true 
            W.Notify('success', 'Ahora ya no se muestran los mensajes globales', 'verify')
        end
    end
)

RegisterNetEvent('chat:sendTwtMessage',
    function(args)
        if not restringed then
            TriggerEvent('chat:addMessage', args)
        end
    end
)