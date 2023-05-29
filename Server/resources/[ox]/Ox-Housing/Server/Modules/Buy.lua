RegisterServerEvent("Ox-Housing:server:buyHouse")
AddEventHandler("Ox-Housing:server:buyHouse", function(id, price)
    local _src = source
    local xPlayer = W.GetPlayer(_src)
    Houses[id].houseManagement().ownHouse(xPlayer.identifier, _src, function(result)
        if result then
            xPlayer.Notify("CASA",'Has adquirido la propiedad', 'verify')
            xPlayer.removeMoney('bank', price)
            TriggerClientEvent("Ox-Housing:client:modHouse", -1, Houses[id], id)
        end
    end)
end)