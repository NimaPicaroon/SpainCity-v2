RegisterNetEvent('funko:buy',
    function(price, name)
        local player = W.GetPlayer(source)
        if player.getMoney('coins') >= price then
            player.removeMoney('coins', price)
            DB:insertFunko(player.identifier, name, player)
        else
            player.Notify('ERROR', 'No tienes suficientes coins', 'error')
        end
    end
)

W.CreateCallback('funko:getPlayerFunkos',
    function(source, cb)
        local player = W.GetPlayer(source)
        DB:getFunkoForPlayer(player.identifier, function(funkos) cb(funkos) end)
    end
)