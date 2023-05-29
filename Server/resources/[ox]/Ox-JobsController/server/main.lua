local Stores = {
    ['baducentral'] = {
        type = "badu",
        label = "Badulake central",
        state = 0
    }
}

RegisterCommand('cambiarEstado',
    function(source)
        local player = W.GetPlayer(source)
        local store = Stores[player.job.name]
        if player and store then
            if store.state == 0 then
                Stores[player.job.name] = {
                    type = store.type,
                    label = "Badulake central",
                    state = 1
                }
            end
            if store.state == 1 then
                Stores[player.job.name] = {
                    type = store.type,
                    label = "Badulake central",
                    state = 0
                }
            end
        end
    end
)

W.CreateCallback('jobscontroller:getActiveStores', function(source, callback, price)
    return callback(Stores)
end)