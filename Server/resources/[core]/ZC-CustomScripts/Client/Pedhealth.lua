Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerMaxHealth = GetPedMaxHealth(playerPed)

        if GetPedMaxHealth(playerPed) < 200 then
            SetPedMaxHealth(playerPed, 200)
            SetEntityHealth(playerPed, 200)
        end

        Citizen.Wait(2000)
    end
end)