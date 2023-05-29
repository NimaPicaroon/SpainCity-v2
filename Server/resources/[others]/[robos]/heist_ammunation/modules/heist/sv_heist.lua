HeistModule = setmetatable({ }, HeistModule)
HeistModule._data = {
    heist = {}
}
HeistModule.__index = HeistModule
GlobalState.Ammunation = nil

function HeistModule:start(source, store, callback)
    local src = source
    local ply = Wave.GetPlayer(src)

    if not HEIST_DATA.STORES[store] then        
        return callback(false)
    end

    if(HEIST_DATA.STORES[store].timer ~= 0)then
        ply.Notify('Ammunation', '¿Qué pretendes robar de aquí? No hay nada', 'error')
        return callback(false)
    end

    if not HeistModule._data.heist[store] then
        HeistModule._data.heist[store] = true
        GlobalState.Ammunation = HeistModule._data.heist
        Wave.SendToDiscord('robbery', "AMMUNATION", "Ammunation Iniciada", ply.src)
        ply.Notify('Ammunation', 'Has empezado a robar el ammunation', 'verify')

        HEIST_DATA.STORES[store].timer = 30
        return callback(true)
    end

    ply.Notify('Ammunation', 'Ya hay un robo en progreso', 'error')
    return callback(false)
end

Wave.CreateCallback('heist_ammunation:start', function(source, callback, store)
    local src = source

    if not store then
        return
    end
    
    HeistModule:start(src, store, function(started)
        return callback(started)
    end)
end)

RegisterNetEvent('heist_ammunation:end', function(store)
    HeistModule._data.heist[store] = false
    GlobalState.Ammunation = HeistModule._data.heist
end)

RegisterNetEvent('heist_ammunation:reward', function(store, cabinet)
    local src = source

    if not store or not HEIST_DATA.STORES[store] or not HEIST_DATA.STORES[store].cabinets[cabinet] then        
        return
    end

    HEIST_DATA.STORES[store].cabinets[cabinet].reward(src)
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(2 * 10 * 1000)
        for store, v in pairs(HEIST_DATA.STORES) do
            if(v.timer ~= 0)then
                HEIST_DATA.STORES[store].timer = HEIST_DATA.STORES[store].timer - 1
            end
        end
    end
end)