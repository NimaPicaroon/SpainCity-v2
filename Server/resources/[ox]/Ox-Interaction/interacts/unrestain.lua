RegisterNetEvent('Ox-Interaction:getuncuffedNPC')
AddEventHandler('Ox-Interaction:getuncuffedNPC', function(playerheading, playercoords, playerlocation)
    distanceToHave, cercainPed = GetCercainPed()
    if cercainPed ~= nil and distanceToHave < 3 then
        if GetPedType(cercainPed) ~= 28 and IsPedAPlayer(cercainPed) == false and IsPedDeadOrDying(cercainPed) == false and IsPedInAnyVehicle(cercainPed) == false and CheckPedWasCustomerBefore(cercainPed) ~= true then
            local spawnedWorkPed = false
            if(DecorExistOn(cercainPed, 'SPAWNEDPED') )then
                spawnedWorkPed = true
            end
            if(spawnedWorkPed == false) then
                CreateThread(function()
                    RequestAnimDict('mp_arresting')
                    while not HasAnimDictLoaded('mp_arresting') do
                        Wait(100)
                    end
                    Wait(250)
                    ExecuteCommand('me le retira las bridas')
                    TaskPlayAnim(cercainPed, 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
                    Wait(5500)
                    IsHandcuffed = false
                    TriggerEvent('Ox-Interaction:unrestrainNPC')
                    ClearPedTasks(cercainPed)
                end)
            end
        end
    end
end)

RegisterNetEvent('Ox-Interaction:unrestrainNPC')
AddEventHandler('Ox-Interaction:unrestrainNPC', function()
    distanceToHave, cercainPed = GetCercainPed()
    if cercainPed ~= nil and distanceToHave < 3 then
        if GetPedType(cercainPed) ~= 28 and IsPedAPlayer(cercainPed) == false and IsPedDeadOrDying(cercainPed) == false and IsPedInAnyVehicle(cercainPed) == false and CheckPedWasCustomerBefore(cercainPed) ~= true then
            local spawnedWorkPed = false
            if(DecorExistOn(cercainPed, 'SPAWNEDPED') )then
                spawnedWorkPed = true
            end
            if(spawnedWorkPed == false) then
                IsHandcuffed = false
                ClearPedSecondaryTask(cercainPed)
                SetEnableHandcuffs(cercainPed, false)
                DisablePlayerFiring(cercainPed, false)
                SetPedCanPlayGestureAnims(cercainPed, true)
                FreezeEntityPosition(cercainPed, false)
                SetEntityAsMissionEntity(cercainPed, false, false)
                SetBlockingOfNonTemporaryEvents(cercainPed, false)
            end
        end
    end
end)

RegisterNetEvent('Ox-Interaction:douncuffingNPC')
AddEventHandler('Ox-Interaction:douncuffingNPC', function()
	Wait(250)
    CreateThread(function()
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Wait(100)
        end
        TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
        Wait(5500)
        ClearPedTasks(GetPlayerPed(-1))
    end)
end)