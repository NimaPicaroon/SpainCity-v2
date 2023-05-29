W.CreateCallback('ZCore:checkItem', function(source, callback, item)
    local src <const> = source
    local player <const> = W.GetPlayer(src)

    if player and item then
        for k, v in pairs(player.inventory.items) do
            if v.item == item then
                return callback(true, v)
            end
        end
    end
end)

W.CreateCallback('core:getCoords', function(source, callback)
    local src = source
    local ply = W.GetPlayer(src)

    if not ply then
        return callback({ x = 0.0, y = 0.0, z = 0.0 })
    else
        return callback({ x = ply.coords.x, y = ply.coords.y, z = ply.coords.z })
    end
end)

W.CreateCallback('ZCore:getProps', function(source, callback)
    return callback(W.Props)
end)