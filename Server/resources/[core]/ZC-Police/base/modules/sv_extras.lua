ExtrasController = setmetatable({ }, ExtrasController)
ExtrasController.__index = ExtrasController

W.RegisterCommand('extras', 'user', function(source, args, player)
    if player.job and player.job.name == 'police' then
        TriggerClientEvent('police:openExtras', source)
    end
end, {}, 'Comando para poner los extras a tu vehículo')

W.RegisterCommand('livery', 'user', function(source, args, player)
    if player.job and player.job.name == 'police' then
        TriggerClientEvent('police:openLiveries', source)
    end
end, {}, 'Comando para poner los liveries a tu vehículo')