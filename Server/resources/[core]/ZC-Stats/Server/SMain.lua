local RemovedStats = {}

AddEventHandler('ZCore:playerLoaded', function(source, player)
    if player then
        local newWeight = 10 + (player.stats.strength * 0.1)
        player.updateMaxWeight(newWeight)
    end
end)

RegisterNetEvent("ZC-Stats:updateWeight2", function()
    local player = W.GetPlayer(source)
    local newWeight = 10 + (player.stats.strength * 0.1)

    player.updateMaxWeight(newWeight)
end)