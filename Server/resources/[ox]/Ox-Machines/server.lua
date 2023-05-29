W = exports.ZCore:get()

W.CreateCallback('machines:buy', function(source, callback, price)
    local src = source
    local ply = W.GetPlayer(src)

    if ply.getMoney('money') >= price then
        ply.removeMoney('money', price)

        return callback(true)
    else
        ply.Notify('Máquinas Expendedoras', 'No tienes dinero suficiente', 'error')

        return callback(false)
    end
end)