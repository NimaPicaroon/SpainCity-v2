HeistModule = setmetatable({ }, HeistModule)
HeistModule._data = {
    store = nil,
    heist = false,
    cabinets = 0
}
HeistModule.__index = HeistModule

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        for key, value in next, HEIST_DATA.STORES do
            local dist = #(playerPos - value.coords)

            if dist <= 75.0 then
                HeistModule._data.store = key
            end
        end

        Citizen.Wait(750)
    end
end)

Citizen.CreateThread(function()
    local zone = false
    local show = false

    while true do
        local msec = 750
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local OwnData = Wave.GetPlayerData()
        zone = false

        if HeistModule._data.store and not GlobalState.Ammunation or (HeistModule._data.store and not GlobalState.Ammunation[HeistModule._data.store]) then
            local dist = #(HEIST_DATA.STORES[HeistModule._data.store].coords - playerPos)

            if dist <= 1.25 and IsPedArmed(playerPed, 4) then
                
                --print('Holaaaaq')
                msec = 0
                zone = true

                if IsControlJustPressed(0, 246) then
                    if OwnData.gang.name then
                    --print('somos los ballas')
                        Wave.TriggerCallback('Wave:GetPlayersJob', function(players)
                            if players and #players >= HEIST_DATA.COPS then
                                Wave.TriggerCallback('heist_ammunation:start', function(can)
                                    if can then
                                        HeistModule._data.heist = true
                                        exports['ZC-HelpNotify']:close('heist_ammunation_start')

                                        if HeistModule._data.heist then
                                            TriggerServerEvent('ZC-Dispatch:sendAlert', 'police', '¡Un ammunation está siendo robado! Que venga una patrulla porfavor!', playerPos, GetPlayerServerId(PlayerId()), 'heist', 'ammunation')
                                        end
                                    end
                                end, HeistModule._data.store)
                            else
                                Wave.Notify('Ammu-Nation', 'No hay suficientes policías para iniciar el robo.', 'error')
                            end
                        end, 'police')
                    else
                        Wave.Notify('Ammu-Nation', 'Para robar tienes que ser banda.', 'error')
                    end
                end
            end
        elseif HeistModule._data.store and GlobalState.Ammunation[HeistModule._data.store] and HeistModule._data.heist then
            for key, value in next, HEIST_DATA.STORES[HeistModule._data.store].cabinets do
                local dist = #(playerPos - vec3(value.coords.x, value.coords.y, value.coords.z))

                if dist <= 7.5 and not value.robbed then
                    msec = 0
                    zone = true
                    Wave.ShowText(vec3(value.coords.x, value.coords.y, value.coords.z), value.text, 0.6, 8)

                    if dist <= 0.75 then
                        if IsControlJustPressed(0, 246) then
                            value.robbed = true
                            zone = false
                            exports['ZC-HelpNotify']:close('heist_ammunation_start')

                            if value.robbed then
                                SetEntityCoords(playerPed, value.coords.x, value.coords.y, value.coords.z - 0.95)
                                SetEntityHeading(playerPed, value.coords.w)


                                if not value.animation then
                                    PlaySoundFromCoord(-1, 'Glass_Smash', value.coords.x, value.coords.y, value.coords.z, '', 0, 0, 0)
                                end

                                if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
                                    RequestNamedPtfxAsset('scr_jewelheist')
                                end

                                while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
                                    Citizen.Wait(0)
                                end

                                SetPtfxAssetNextCall('scr_jewelheist')
                                StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', value.coords.x, value.coords.y, value.coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

                                if not value.animation then
                                    while not HasAnimDictLoaded('missheist_jewel') do
                                        RequestAnimDict('missheist_jewel')
                                        Citizen.Wait(5)
                                    end

                                    TaskPlayAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
                                else
                                    ExecuteCommand('e pickapple')
                                    FreezeEntityPosition(playerPed, true)
                                end

                                DrawSubtitleTimed(5000, 1)
                                Citizen.Wait(5000)
                                ClearPedTasksImmediately(playerPed)
                                FreezeEntityPosition(playerPed, false)
                                TriggerServerEvent('heist_ammunation:reward', HeistModule._data.store, key)
                                PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)

                                HeistModule._data.cabinets = HeistModule._data.cabinets + 1

                                if HeistModule._data.cabinets >= #HEIST_DATA.STORES[HeistModule._data.store].cabinets then
                                    for index, val in next, HEIST_DATA.STORES[HeistModule._data.store].cabinets do
                                        val.robbed = false
                                        HeistModule._data.cabinets = 0
                                    end
                                    
                                    Wave.Notify('Ammunation', 'Has terminado de robar todo', 'verify')
                                    TriggerServerEvent('heist_ammunation:end', HeistModule._data.store)
                                end
                            end
                        end
                    end
                end
            end

            if #(playerPos - HEIST_DATA.STORES[HeistModule._data.store].coords) >= 30.0 then
                for index, val in next, HEIST_DATA.STORES[HeistModule._data.store].cabinets do
                    val.robbed = false
                    HeistModule._data.cabinets = 0
                end
                
                Wave.Notify('Ammunation', 'Te has alejado mucho del robo', 'error')
                TriggerServerEvent('heist_ammunation:end', HeistModule._data.store)
            end
        end

        if zone and not show then
            show = true

            exports['ZC-HelpNotify']:open('Usa <strong>Y</strong> para robar', 'heist_ammunation_start')
        elseif not zone and show then
            show = false

            exports['ZC-HelpNotify']:close('heist_ammunation_start')
        end

        Citizen.Wait(msec)
    end
end)