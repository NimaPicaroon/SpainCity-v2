RegisterServerEvent('Ox-Activities:start')
AddEventHandler('Ox-Activities:start', function(jobType)
    local xPlayer = W.GetPlayer(source)

    if xPlayer then
        local pay = math.random(340, 480)

        if jobType == 'farm' then
            pay = math.random(340, 480)
        elseif jobType == 'vacas' then
            pay = math.random(240, 300)
        end

        xPlayer.addMoney('bank', pay)
        W.SendToDiscord('rutas', "ACTIVIDADES", 'Ha cobrado $'..pay..' por su trabajo en '..jobType, source)
        xPlayer.Notify('ACTIVIDADES', '¡Has recibido ' .. pay .. ' dólares por el trabajo, sigue así!', 'verify')
    end
end)

RegisterServerEvent('Ox-Activities:cancelar', function(jobType)
    local xPlayer = W.GetPlayer(source)

    if xPlayer then
        if jobType == 'Electricista' then
            TriggerClientEvent('Ox-Activities:cancelarElec', xPlayer.src)
        elseif jobType == 'Portuario' then
            TriggerClientEvent('Ox-Activities:cancelarMec', xPlayer.src)
        elseif jobType == 'Granjero' then
            TriggerClientEvent('Ox-Activities:cancelarCultivo', xPlayer.src)
        elseif jobType == 'Ganadero' then
            TriggerClientEvent('Ox-Activities:cancelarGanadero', xPlayer.src)
        end

        xPlayer.Notify('ACTIVIDADES', '¡Has cancelado tu actividad!', 'verify')
    end
end)