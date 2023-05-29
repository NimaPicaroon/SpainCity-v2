RegisterServerEvent("Ox-Housing:server:addFurni")
AddEventHandler("Ox-Housing:server:addFurni", function(id, obj, coords, heading, price)
    local _src = source
    local xPlayer = W.GetPlayer(_src)
    local houseAct = Houses[id].houseManagement()

    if xPlayer.money.bank > price then
        houseAct.addFurni(obj, coords, heading, function(done)
            if done then
                xPlayer.removeMoney('bank', price)
                xPlayer.Notify("CASA",'Has añadido un mueble','verify')
            end
        end)

        for k, v in pairs(insideMembers) do
            if v.id == id then
                TriggerClientEvent("Ox-Housing:client:syncFur", v.plyid, obj, coords, heading)
            end
        end
    else
        xPlayer.Notify("BANCO", 'No tienes suficiente dinero', 'error')
    end
end)

RegisterServerEvent("Ox-Housing:server:deleteFurn")
AddEventHandler("Ox-Housing:server:deleteFurn", function(coords, id)
    local _src = source
    local xPlayer = W.GetPlayer(_src)
    local houseAct = Houses[id].houseManagement()
    houseAct.deleteFurni(coords, function(done)
        if done then
            xPlayer.Notify("CASA",'Has eliminado el mueble','verify')
        end
    end)
end)


W.CreateCallback('Ox-Housing:server:getFurni', function(source, cb, id)
    local houseInf = Houses[id].houseInfo()
    houseInf.getFurniture(function(result)
        cb(result)
    end)
end)
