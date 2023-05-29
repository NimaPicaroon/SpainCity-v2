RegisterServerEvent("ZC-Dispatch:sendAlert")
AddEventHandler("ZC-Dispatch:sendAlert", function(faction, text, coords, id, type, heistType)
    local player = W.GetPlayer(source)
    if faction == 'police' then
        local players = exports['Ox-References']:getPolices()

        for k,v in pairs(players) do
            if v and v.source then
                TriggerClientEvent("ZC-Dispatch:sendAlertToClient", v.source, faction, text.. ' (ID: '..source..')', coords, id, type, heistType)
            end
        end
        W.SendToDiscord("entorno", "ENTORNO", text, source)
    elseif faction == 'ambulance' then
        local players = exports['ZC-Ambulance']:getMedics()

        for k,v in pairs(players) do
            if v and v.source then
                TriggerClientEvent("ZC-Dispatch:sendAlertToClient", v.source, faction, text.. ' (ID: '..source..')', coords, id, type, heistType)
            end
        end
        W.SendToDiscord("entorno", "AUXILIO", text, source)
    elseif faction == 'taxi' then
        local players = exports['Ox-Jobcreator']:getTaxis()
        --text = player.phone..": "..text
        for k,v in pairs(players) do
            if v and v.source then
                TriggerClientEvent("ZC-Dispatch:sendAlertToClient", v.source, faction, text.. ' (ID: '..source..')', coords, id, type, heistType)
            end
        end
        W.SendToDiscord("entorno", "PEDIRTAXI", text, source)
    end
end)

RegisterNetEvent('dispatch:entornoSended', function()
    local src = source

    TriggerClientEvent('ZC-Chat:checkDistances', src, 'Alguien ha enviado una llamada de entorno')
end)