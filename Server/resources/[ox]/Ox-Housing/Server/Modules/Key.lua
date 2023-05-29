RegisterServerEvent("Ox-Housing:server:giveKey")
AddEventHandler("Ox-Housing:server:giveKey", function(id)
    local _src = source
    local xPlayer = W.GetPlayer(_src)
    local houseInfo = Houses[id].houseInfo()
    local houseData = Houses[id]
    houseInfo.getOwner(function(result)
        if result.identifier == xPlayer.identifier then
            if xPlayer.canHoldItem("house_keys", 1) then
                if(not houseData.key_code)then
                    xPlayer.Notify("NOTIFICACIÓN", "Para hacer una copia de la llave necesitas colocar una cerradura")
                    return
                end
                xPlayer.addItemToInventory("house_keys", 1, { house = id, house_owner = GetCharacterName(_src), house_key_code = houseData.key_code})
                xPlayer.Notify('Casas', 'Has pagado ~y~$50~w~ por una ~y~copia~w~ de las llaves de tu casa', 'verify')
                xPlayer.removeMoney('bank', 50)
            end
        end
    end)
end)

RegisterServerEvent("Ox-Housing:server:changeLock")
AddEventHandler("Ox-Housing:server:changeLock", function(id)
    local _src = source
    local xPlayer = W.GetPlayer(_src)
    local houseInfo = Houses[id].houseInfo()
    local houseData = Houses[id]
    houseInfo.getOwner(function(result)
        if result.identifier == xPlayer.identifier then
            if(houseData.key_code)then
                xPlayer.removeMoney('bank', 500)
            end
            houseData.changeKeyCode()
            xPlayer.addItemToInventory("house_keys", 1, { house = id, house_owner = GetCharacterName(_src), house_key_code = houseData.key_code})
            xPlayer.Notify('Casas', 'Has pagado ~y~$500~w~ por el cambio de la cerradura', 'verify')
            TriggerClientEvent("Ox-Housing:client:modHouse", -1, Houses[id], id)
        end
    end)
end)