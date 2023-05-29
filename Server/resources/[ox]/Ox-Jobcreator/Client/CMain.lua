JOB = setmetatable({ }, JOB)

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end

    while not W.GetPlayerData().job do
        Wait(100)
    end

    TriggerServerEvent('jobcreator:init')
end)