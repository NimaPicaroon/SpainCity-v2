CONNECTED_PLAYERS = 0

AddEventHandler('ZCore:playerLoaded', function(source, player)
    if player then
        CONNECTED_PLAYERS = CONNECTED_PLAYERS + 1
    end
end)

AddEventHandler("ZCore:playerDisconnected", function(src, player)
    if player then
        CONNECTED_PLAYERS = CONNECTED_PLAYERS - 1
    end
end)

W.CreateCallback('K-Score:getData',
    function(source, cb)
        cb(CONNECTED_PLAYERS)
    end
)