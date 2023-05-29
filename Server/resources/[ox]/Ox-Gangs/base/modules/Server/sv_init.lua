AddEventHandler('ZCore:playerLoaded', function(source, player)
    if player then
        if player['gang'] and player['gang'].name then
            table.insert(Gangs[player['gang'].name].players, player.src)
            TriggerClientEvent("Ox-Gangs:fetchGang", tonumber(source), Gangs[player.gang.name])
        end
    end
    
    TriggerClientEvent('Ox-Gangs:gangsInfo', tonumber(source), Gangs)
end)