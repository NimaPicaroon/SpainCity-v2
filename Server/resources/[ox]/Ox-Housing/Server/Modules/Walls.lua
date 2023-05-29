RegisterServerEvent("Ox-Housing:server:addPaint")
AddEventHandler("Ox-Housing:server:addPaint", function(type, initTxd, initTxn, url, id)
    local houseAct = Houses[id].houseManagement()
    houseAct.changeStyle(type, initTxd, initTxn, url, function(result)
        log("Changed interior style")
    end)
end)

W.CreateCallback('Ox-Housing:server:setWallsAndFloors', function(source,cb,id)
    local houseInfo = Houses[id].houseInfo()
    houseInfo.getStyle(function(result)
        if result then
            cb(result)
        else
            cb(false)
        end
    end)
end)