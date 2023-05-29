Main = { }
Main.__data = { player = { } }

-- @main
--RegisterNetEvent('core:session:playerInit', function(playerData, playerNew)
    --Main.__data.player = playerData
    --Gym.Init()
--end)

-- @blip
Citizen.CreateThread(function()
	for _, gym in pairs(Settings.Gyms) do
        gym.blip = W.CreateBlip(gym.shop, 311, 15, 0.7, gym.name, GetCurrentResourceName())
	end
end)

--@
Citizen.CreateThread(function()
    while Gym == nil do Wait(100) end
    while Speed == nil do Wait(100) end

    while true do
        local msec = 1500

        if Gym.__data.inAction then
            msec = 0
            if Gym.__data.inAction > 100 then
                Gym.__data.inAction = 100
            end

            SendNUIMessage({
                percentage = Gym.__data.inAction
            })

            if IsControlJustPressed(0, 73) then
                Gym.__data.cancel = true
                SendNUIMessage({
                    hide = true
                })
                W.Notify('CANCELACIÓN', 'Has ~r~cancelado~w~ el ejercicio', 'error')
            end
        end

        if Speed.__data.time then
            SendNUIMessage({
                time = Speed.__data.time
            })
        end
        Citizen.Wait(msec)
    end
end)

Citizen.CreateThread(function()
    while Gym == nil do Wait(100) end
    while Speed == nil do Wait(100) end

    while true do
        local msec = 3000

        if Speed.__data.time then
            msec = 0
            if IsControlJustPressed(0, 22) then
                Gym.__data.cancel = true
            end
        end

        Citizen.Wait(msec)
    end
end)

Citizen.CreateThread(function()
    while Gym == nil do Wait(100) end
    while Speed == nil do Wait(100) end

    while true do
        local msec = 1000

        if Speed.__data.time then
            Speed.__data.time = Speed.__data.time + 1
        end

        if Gym.__data.resting then
            if Gym.__data.resting_time < 60 then
                Gym.__data.resting_time = Gym.__data.resting_time + 1
            else
                Gym.__data.resting = nil
                Gym.__data.resting_time = 0
                W.Notify('GIMNASIO', 'Puedes volver a ~g~entrenar~w~', 'verify')
            end
        end

        Citizen.Wait(msec)
    end
end)