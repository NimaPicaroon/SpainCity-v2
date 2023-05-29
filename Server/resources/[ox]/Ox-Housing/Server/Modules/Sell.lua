RegisterServerEvent("Ox-Housing:server:sellHouse")
AddEventHandler("Ox-Housing:server:sellHouse", function(id, price, slotId)
    local _src = source
    local xPlayer = W.GetPlayer(_src)
    local houseM = Houses[id].houseManagement()
    houseM.sellHouse(_src, xPlayer.identifier, function(result)
        if result then
            xPlayer.removeItemFromInventory("house_keys", 1, slotId)
            xPlayer.Notify("CASA",'Has vendido la propiedad por ~g~$'..price, 'verify')
            xPlayer.addMoney('bank', price)
            TriggerClientEvent("Ox-Housing:client:modHouse", -1, Houses[id], id)
            TriggerClientEvent("Ox-Housing:client:refreshHouses", _src, Houses)
        end
    end)
end)

RegisterServerEvent("Ox-Housing:server:sellHouseCK", function(id, identifier)
    local houseM = Houses[id].houseManagement()
    if Houses[id].gang == "" then
        houseM.sellHouse(0, identifier, function(result)
            if result then
                TriggerClientEvent("Ox-Housing:client:modHouse", -1, Houses[id], id)
            end
        end)
    end
end)