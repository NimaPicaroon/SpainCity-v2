Wave.RegisterCommand("searchweapon", "admin", function(source, args, player)
    local weapon = args[1]
    if(not weapon)then
        return player.Notify("ERROR", "Tienes que indicar en el primer argumento el nombre del arma Ej (WEAPON_PISTOL)", "error")
    end
    MySQL.Async.fetchAll("SELECT name from storage where data LIKE '%" .. weapon .. "%' and name not LIKE '%police%'", {}, function(result)
        for k, v in pairs(result) do
            TriggerClientEvent('chat:addMessage', source, { args = {"[" .. weapon .. "]", v.name}, color = {255, 0, 145} })
        end
    end)
end, { { name = 'weapon', help = 'ID del arma que quieres buscar en los almacenamientos' }}, 'Comando para buscar un tipo de arma en todos los armarios del servidor')

Wave.RegisterCommand("searchstorage", "admin", function(source, args, player)
    local storage = args[1]
    if(not storage)then
        return player.Notify("ERROR", "Tienes que indicar el nombre del almacén Ej (house224)", "error")
    end
    if(not StorageModule._data.storages[storage])then
        return player.Notify("ERROR", "El almacén indicado no existe, comprueba que lo escribiste correctamente", "error")
    end
    for k, v in pairs(StorageModule._data.storages[storage].inventory)do
        if(v.item and v.type and v.type == "weapon" or string.find(v.item, "rounds"))then
            if(v.metadata and v.metadata.serialnumber)then
                TriggerClientEvent('chat:addMessage', source, { args = {"[" .. v.item .. "]", v.metadata.serialnumber}, color = {255, 0, 145} })
            elseif(v.metadata and v.metadata.rounds)then
                TriggerClientEvent('chat:addMessage', source, { args = {"[" .. v.item .. "] con x" .. v.metadata.rounds .." balas", storage}, color = {255, 0, 145} })
            elseif(v.quantity)then
                TriggerClientEvent('chat:addMessage', source, { args = {"[" .. v.item .. "] x" ..v.quantity, storage}, color = {255, 0, 145} })
            end
        end
    end
end, { { name = 'storage', help = 'Nombre concreto' }}, 'Comando para revisar absolutamente todo el storage concreto')