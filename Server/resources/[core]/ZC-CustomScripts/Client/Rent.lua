local menuOpened = false
local rented = false

local spawnCoords = {
    [vector3(-719.04, -1326.15, 0.6)] = vec4(-720.03, -1348.33, 0.12, 139.16),
    [vector3(-3427.03, 967.55, 8.35)] = vec4(-3412.99, 932.94, 0.32, 121.25),
    [vector3(-1612.11, 5260.41, 3.97)] = vec4(-1620.72, 5247.73, 0.12, 24.50),
    [vector3(-275.91, 6638.13, 7.48)] = vec4(-288.47, 6645.84, 0.05, 58.35),
    [vector3(3854.76, 4463.93, 2.73)] = vec4(3857.8, 4477.32, 0.12, 275.91),
    [vector3(12.37, -2801.16, 2.53)] = vec4(0.014, -2794.20, 0.51, 182.03)
}

Citizen.CreateThread(function()
    for key, value in pairs(spawnCoords) do
        local blip = AddBlipForCoord(value.x, value.y, value.z)

        SetBlipSprite (blip, 427)
        SetBlipScale  (blip, 0.7)
        SetBlipDisplay(blip, 4)
        SetBlipColour (blip, 25)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Alquiler de Barcos')
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('rent:rentBoat', function(coords)
    local elements = {}
    local playerData = W.GetPlayerData()
    menuOpened = vec3(coords.x, coords.y, coords.z)

    if playerData.job and playerData.job.name == 'police' then
        table.insert(elements, { label = 'Lancha Grande LSPD - <span style="color: yellow">$0</span>', value = 'largeboat', price = 0 })
        table.insert(elements, { label = 'Lancha Pequeña LSPD - <span style="color: yellow">$0</span>', value = 'hillboaty', price = 0 })
    end

    if playerData.job and playerData.job.name == 'ambulance' then
        table.insert(elements, { label = 'Moto Agua SAFD - <span style="color: yellow">GRATIS</span>', value = 'seashark2', price = 0 })
    end

    table.insert(elements, { label = 'Dinghy - <span style="color: yellow">$1000</span>', value = 'dinghy', price = 1000 })
    table.insert(elements, { label = 'Jetmax - <span style="color: yellow">$800</span>', value = 'jetmax', price = 800 })
    table.insert(elements, { label = 'Moto de Agua - <span style="color: yellow">$250</span>', value = 'seashark', price = 250 })
    table.insert(elements, { label = 'Squalo - <span style="color: yellow">$500</span>', value = 'squalo', price = 500 })

    Wait(500)
    W.OpenMenu('Alquiler de Barcos', 'rent_boats', elements, function(data, name)
        W.DestroyMenu(name)

        if data.value and data.price then
            if playerData.money.money >= data.price then
                local spawn = spawnCoords[vec3(coords.x, coords.y, coords.z)]

                W.SpawnVehicle(data.value, vector3(spawn.x, spawn.y, spawn.z), spawn.w, true, function(vehicle)    
                    SetVehicleDirtLevel(vehicle, 0.0)
                    SetVehicleCustomSecondaryColour(vehicle, 0, 0, 0)

                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SetVehicleOnGroundProperly(vehicle)
                end)

                W.Notify('Alquiler', 'Has alquilado un ~y~'..data.label..'~w~', 'verify')
            else
                W.Notify('Alquiler', 'No tienes ~r~dinero suficiente~w~.', 'error')
            end
        end
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if menuOpened then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local distance = #(menuOpened - coords)

            if distance > 3 then
                W.CloseDialog()
                W.DestroyMenu("rent_boats")
            end
        end

        Wait(sleep)
    end
end)

local ancla = false

RegisterCommand('ancla', function()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed)

    if GetVehicleClass(playerVeh) == 14 then
        ancla = not ancla

        if ancla then
            FreezeEntityPosition(playerVeh, true)
            SetVehicleOnGroundProperly(playerVeh)
            W.Notify('Ancla', 'Has ~y~anclado~w~ tu barco', 'verify')
        else
            FreezeEntityPosition(playerVeh, false)
            W.Notify('Ancla', 'Has ~y~desanclado~w~ tu barco', 'verify')
        end
    end
end)