HeistModule = setmetatable({ }, HeistModule)
HeistModule._data = {
    closest = nil,
    stealing = false
}
HeistModule.__index = HeistModule

function HeistModule:npc(hash, coords)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end

    local ped = CreatePed(4, hash, vec3(coords.x, coords.y, coords.z), false, false)
    SetEntityHeading(ped, coords.w)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetEntityInvincible(ped, true)

    return ped
end

function HeistModule:check()
    Citizen.CreateThread(function()
        while HeistModule._data.stealing do
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)

            if HEIST_DATA.shops[HeistModule._data.closest] then
                local info = HEIST_DATA.shops[HeistModule._data.closest]

                if DoesEntityExist(info.data.entity) then
                    local dist = #(playerPos - vec3(info.coords.x, info.coords.y, info.coords.z))

                    if dist > 10.0 and GlobalState.HeistClotheshops[HeistModule._data.closest].data.robbing then
                        exports.progressbar:Cancel()
                        HeistModule._data.stealing = false
                        TriggerServerEvent('clotheshopheist:endedRobByDistance', HeistModule._data.closest)
                        Wave.Notify('Dependienta', 'Te has alejado mucho del robo y lo has cancelado', 'info')
                    end
                end
            end

            Citizen.Wait(500)
        end
    end)
end

---Reset store
RegisterNetEvent('clotheshopheist:resetStore', function(index)
    if not index or not HEIST_DATA.shops[index] then
        return
    end

    local data = HEIST_DATA.shops[index]
    if data then
        local entityCoords = GetEntityCoords(data.data.entity)

        ClearPedTasks(data.data.entity)
        SetEntityCoords(data.data.entity, data.coords.x, data.coords.y, data.coords.z, data.coords.w)
        SetEntityHeading(data.data.entity, data.coords.w)
    end
end)

---Give money to player
RegisterNetEvent('clotheshopheist:endPed', function(index)
    print('Finished progressbar, now ped gonna give you money')

    print(HeistModule._data.stealing)
    if HeistModule._data.stealing then
        local data = HEIST_DATA.shops[index]
        print('Jelou mai friend')

        if not HasAnimDictLoaded('mp_am_hold_up') then
            RequestAnimDict('mp_am_hold_up')

            while not HasAnimDictLoaded('mp_am_hold_up') do
                Wait(100)
            end
        end

        local entityCoords = GetEntityCoords(data.data.entity)

        TaskPlayAnim(data.data.entity, 'mp_am_hold_up', 'holdup_victim_20s', 8.0, -8.0, -1, 2, 0, false, false, false)
        local timer = GetGameTimer() + 10800

        while timer >= GetGameTimer() do
            Wait(0)
        end

        if not IsPedDeadOrDying(data.data.entity) then
            RequestModel(`prop_poly_bag_01`)
            while not HasModelLoaded(`prop_poly_bag_01`) do 
                Wait(0) 
            end

            timer = GetGameTimer() + 200 
            while timer >= GetGameTimer() do
                Wait(0)
            end

            local bag = CreateObject(`prop_poly_bag_01`, entityCoords, false, false)
            AttachEntityToEntity(bag, data.data.entity, GetPedBoneIndex(data.data.entity, 60309), 0.1, -0.11, 0.08, 0.0, -75.0, -75.0, 1, 1, 0, 0, 2, 1)
            timer = GetGameTimer() + 10000
            while timer >= GetGameTimer() do
                Wait(0)
            end

            if not IsPedDeadOrDying(data.data.entity) then
                DetachEntity(bag, true, false)

                timer = GetGameTimer() + 75
                while timer >= GetGameTimer() do
                    Wait(0)
                end

                SetEntityHeading(bag, data.coords.w)
                ApplyForceToEntity(bag, 3, vec3(0.0, 50.0, 0.0), 0.0, 0.0, 0.0, 0, true, true, false, false, true)

                while DoesEntityExist(bag) do
                    playerPed = PlayerPedId()
                    playerCoords = GetEntityCoords(playerPed)

                    if playerPed and playerCoords then
                        local coords = GetEntityCoords(bag)
                        local dist = #(playerCoords - coords)

                        if dist <= 2.5 then
                            HeistModule._data.stealing = false

                            PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                            TriggerServerEvent('clotheshopheist:addMoney', index, secret)
                            DeleteEntity(bag)

                            break
                        end
                    end
                    
                    Wait(0)
                end
            end
        end

        if not HasAnimDictLoaded('mp_am_hold_up') then
            RequestAnimDict('mp_am_hold_up')

            while not HasAnimDictLoaded('mp_am_hold_up') do
                Wait(100)
            end
        end

        TaskPlayAnim(data.data.entity, 'mp_am_hold_up', 'cower_intro', 8.0, -8.0, -1, 0, 0, false, false, false)
        timer = GetGameTimer() + 2500
        while timer >= GetGameTimer() do Wait(0) end
        TaskPlayAnim(data.data.entity, 'mp_am_hold_up', 'cower_loop', 8.0, -8.0, -1, 1, 0, false, false, false)
        local stop = GetGameTimer() + 120000
        
        while stop >= GetGameTimer() do
            Wait(50)
        end

        if IsEntityPlayingAnim(data.data.entity, 'mp_am_hold_up', 'cower_loop', 3) then
            ClearPedTasks(data.data.entity)
            HeistModule._data.stealing = false
        end
    end
end)

---Create Shops NPCS
Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    for i = 1, #HEIST_DATA.shops do
        if not HEIST_DATA.shops[i].data.entity then
            HEIST_DATA.shops[i].data.entity = HeistModule:npc(HEIST_DATA.shops[i].model, HEIST_DATA.shops[i].coords)
        end
    end
end)

---Check closest shop
Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    while true do
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        for i = 1, #HEIST_DATA.shops do
            local dist = #(playerPos - vec3(HEIST_DATA.shops[i].coords.x, HEIST_DATA.shops[i].coords.y, HEIST_DATA.shops[i].coords.z))

            if dist <= 50.0 then
                HeistModule._data.closest = i
            end
        end

        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    local playerId = PlayerId()
    local notify = false
    local check = false

    while not NetworkIsPlayerActive(playerId) do
        Wait(500)
    end

    while not HeistModule._data.closest do
        Wait(500)
    end

    while true do
        local msec = 500
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        if playerPed and playerPos then
            local data = HEIST_DATA.shops[HeistModule._data.closest]

            if not HeistModule._data.stealing then
                if DoesEntityExist(data.data.entity) then
                    local entityCoords = GetEntityCoords(data.data.entity)
        
                    if #(playerPos - entityCoords) <= 10.0 then
                        msec = 0

                        if (IsPedArmed(playerPed, 1) or IsPedArmed(playerPed, 4)) and IsPlayerFreeAimingAtEntity(playerId, data.data.entity) then
                            if (not GlobalState.HeistClotheshops[HeistModule._data.closest].data.robbed) and (not GlobalState.HeistClotheshops[HeistModule._data.closest].data.robbing) then
                                if not check then
                                    check = true

                                    Wave.TriggerCallback('Wave:GetPlayersJob', function(cops)
                                        if cops and #cops >= HEIST_DATA.cops then
                                            HeistModule._data.stealing = true
                                            HeistModule:check()
                                            TriggerServerEvent('clotheshopheist:startRobbing', HeistModule._data.closest)
                                            Wait(500)

                                            if not HasAnimDictLoaded('missheist_agency2ahands_up') then
                                                RequestAnimDict('missheist_agency2ahands_up')
                            
                                                while not HasAnimDictLoaded('missheist_agency2ahands_up') do
                                                    Wait(100)
                                                end
                                            end
                            
                                            if not IsEntityPlayingAnim(data.data.entity, 'missheist_agency2ahands_up', 'handsup_anxious', 3) then
                                                TaskPlayAnim(data.data.entity, 'missheist_agency2ahands_up', 'handsup_anxious', 8.0, -8.0, -1, 1, 0, false, false, false)
                                            end

                                            TriggerServerEvent('ZC-Dispatch:sendAlert', 'police', '¡Una tienda de ropa está siendo robado, necesitamos refuerzos!', playerPos, GetPlayerServerId(playerId), 'heist', 'shop')
                                        
                                            Wave.Progressbar('robbing_badulaque', 'Robando...', 3 * 30 * 1000, false, false, 
                                            { disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = false}, 
                                            {}, {}, {}, function() 
                                                playerPos = GetEntityCoords(playerPed)
                                                entityCoords = GetEntityCoords(data.data.entity)

                                                if #(playerPos - entityCoords) <= 12.5 then
                                                    TriggerServerEvent('clotheshopheist:endedRob', HeistModule._data.closest)
                                                end
                                            end)
                                        else
                                            Wave.Notify('Dependienta', 'Lo siento, no me queda nada para darte, no me hagas nada porfavor.', 'info')
                                        end
                                    end, 'police', true)
                                end

                                Wait(2000)
                                check = false
                            else
                                if not notify then
                                    notify = true
                                    Wave.Notify('Dependienta', '¿Qué quieres robarme? Ya lo han hecho hace un rato...', 'info')
                                end

                                Wait(2000)
                                notify = false
                            end
                        end
                    end
                end
            end
        end


        Citizen.Wait(msec)
    end
end)