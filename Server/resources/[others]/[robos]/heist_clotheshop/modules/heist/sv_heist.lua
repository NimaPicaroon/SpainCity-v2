HeistModule = setmetatable({ }, HeistModule)
HeistModule._data = {
    players = {},
    robbers = {}
}
HeistModule.__index = HeistModule

RegisterNetEvent('clotheshopheist:startRobbing', function(index)
    local src = source

    if not index or not HEIST_DATA.shops[index] then
        return
    end

    HEIST_DATA.shops[index].data.robbing = true
    GlobalState.HeistClotheshops = HEIST_DATA.shops

    HeistModule._data.players[src] = index
    HeistModule._data.robbers[src] = true
    GlobalState.ClotheshopRobbers = HeistModule._data.robbers
end)

RegisterNetEvent('clotheshopheist:endedRobByDistance', function(index)
    local src = source

    if not index or not HEIST_DATA.shops[index] then
        return
    end

    HEIST_DATA.shops[index].data.robbing = false
    HEIST_DATA.shops[index].data.robbed = true
    GlobalState.HeistClotheshops = HEIST_DATA.shops

    TriggerClientEvent('clotheshopheist:resetStore', -1, index)
end)

RegisterNetEvent('clotheshopheist:endedRob', function(index)
    local src = source

    if not index or not HEIST_DATA.shops[index] then
        return
    end

    HEIST_DATA.shops[index].data.robbing = false
    HEIST_DATA.shops[index].data.robbed = true
    GlobalState.HeistClotheshops = HEIST_DATA.shops

    TriggerClientEvent('clotheshopheist:endPed', -1, index, src)
end)

RegisterNetEvent('clotheshopheist:addMoney')
AddEventHandler('clotheshopheist:addMoney' , function(index, secret)
    local src = source
    local ply = Wave.GetPlayer(src)

    if secret then
        DropPlayer(src, 'Adiós cheto')
    end

    if HeistModule._data.players[src] == index then
        local reward = math.random(2000, 3000)

        ply.addMoney('money', reward)
        ply.Notify('Atraco', 'Has robado ~r~'..reward..'€~w~ de la tienda de ropa', 'verify')
        Wave.SendToDiscord('robbery', "TIENDA DE ROPA", 'Robó '..reward..'€ de la tienda de ropa', src)

        HeistModule._data.players[src] = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        for key, value in next, HEIST_DATA.shops do
            if value.data.robbed then
                value.data.cooldown -= (120 * 1000) ---Remove 1 minute from cooldown

                if value.data.cooldown <= 0 then
                    value.data.cooldown = value.defaultCooldown
                    value.data.robbed = false
                    GlobalState.HeistClotheshops = HEIST_DATA.shops
                    
                    TriggerClientEvent('clotheshopheist:resetStore', -1, key)
                end
            end
        end

        Citizen.Wait(5 * 1000) ---5 seconds
    end
end)