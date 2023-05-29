RegisterNetEvent('ZCore:playerLoaded', function()
    local PlayerData = W.GetPlayerData()
    if(PlayerData.job.name == "police" and PlayerData.job.duty)then 
        TriggerServerEvent("police_refs:addUnit")
    end
end)

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    while not W.GetPlayerData().job do
        Wait(500)
    end

    TriggerServerEvent('references:addUnit')
end)