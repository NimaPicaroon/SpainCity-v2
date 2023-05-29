HeistModule = setmetatable({ }, HeistModule)
HeistModule._data = {
    players = {},
    robbers = {}
}
HeistModule.__index = HeistModule

RegisterNetEvent('shopheist:startRobbing', function(index)
    local src = source

    if not index or not HEIST_DATA.shops[index] then
        return
    end

    HEIST_DATA.shops[index].data.robbing = true
    GlobalState.HeistShops = HEIST_DATA.shops

    HeistModule._data.players[src] = index
    HeistModule._data.robbers[src] = true
    GlobalState.ShopsRobbers = HeistModule._data.robbers
end)

RegisterNetEvent('shopheist:endedRobByDistance', function(index)
    local src = source

    if not index or not HEIST_DATA.shops[index] then
        return
    end

    HEIST_DATA.shops[index].data.robbing = false
    HEIST_DATA.shops[index].data.robbed = true
    GlobalState.HeistShops = HEIST_DATA.shops

    TriggerClientEvent('shopheist:resetStore', -1, index)
end)

RegisterNetEvent('shopheist:endedRob', function(index)
    local src = source

    if not index or not HEIST_DATA.shops[index] then
        return
    end

    HEIST_DATA.shops[index].data.robbing = false
    HEIST_DATA.shops[index].data.robbed = true
    GlobalState.HeistShops = HEIST_DATA.shops

    TriggerClientEvent('shopheist:endPed', -1, index, src)
end)

RegisterNetEvent('shopheist:addMoney')
AddEventHandler('shopheist:addMoney', function(index, secret)
    local src = source
    local ply = Wave.GetPlayer(src)

    if secret then
        DropPlayer(src, 'Adiós cheto')
    end

    if HeistModule._data.players[src] == index then
        local reward = math.random(2000, 3000)

        ply.addMoney('money', reward)
        ply.Notify('Atraco', 'Has robado ~r~$'..reward..'~w~ del badulaque', 'verify')
        Wave.SendToDiscord('robbery', "BADULAQUE / LICORERÍA", 'Robó '..reward..'$ de la tienda', src)

        HeistModule._data.players[src] = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        for key, value in next, HEIST_DATA.shops do
            if value.data.robbed then
                value.data.cooldown -= (1 * 1000) ---Remove 1 minute from cooldown

                if value.data.cooldown <= 0 then
                    value.data.cooldown = value.defaultCooldown
                    value.data.robbed = false
                    GlobalState.HeistShops = HEIST_DATA.shops
                    
                    TriggerClientEvent('shopheist:resetStore', -1, key)
                end
            end
        end

        Citizen.Wait(5 * 1000) ---5 seconds
    end
end)