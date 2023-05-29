RegisterNetEvent('Ox-Interaction:handcuffNPC')
AddEventHandler('Ox-Interaction:handcuffNPC', function()
    IsHandcuffed    = true
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
                    TaskPlayAnim(cercainPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
                    FreezeEntityPosition(cercainPed, true)
                    ExecuteCommand('me le coloca unas bridas en ambas manos')
                end)
            end
        end
    end
end)


RegisterNetEvent('Ox-Interaction:detenidoNPC')
AddEventHandler('Ox-Interaction:detenidoNPC', function()
    distanceToHave, cercainPed = GetCercainPed()
    if cercainPed ~= nil and distanceToHave < 3 then
        if GetPedType(cercainPed) ~= 28 and IsPedAPlayer(cercainPed) == false and IsPedDeadOrDying(cercainPed) == false and IsPedInAnyVehicle(cercainPed) == false and CheckPedWasCustomerBefore(cercainPed) ~= true then
            local spawnedWorkPed = false
            if(DecorExistOn(cercainPed, 'SPAWNEDPED') )then
                spawnedWorkPed = true
            end
            if(spawnedWorkPed == false) then
                RequestAnimDict("mp_arrest_paired")
                while not HasAnimDictLoaded("mp_arrest_paired") do
                    Wait(10)
                end
                TaskPlayAnim(cercainPed, "mp_arrest_paired", "crook_p2_back_left", 8.0, -8.0, 5500, 33, 0, false, false, false)
            end
        end
    end
end)

RegisterNetEvent('Ox-Interaction:arrestarNPC')
AddEventHandler('Ox-Interaction:arrestarNPC', function()
	RequestAnimDict("mp_arrest_paired")
	while not HasAnimDictLoaded("mp_arrest_paired") do
		Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "cop_p2_back_left", 8.0, -8.0, 3650, 33, 0, false, false, false) 
	Wait(3000)
end)


RegisterNetEvent('Ox-Interaction:EscoltarNPC')
AddEventHandler('Ox-Interaction:EscoltarNPC', function()
    RequestAnimDict("switch@trevor@escorted_out")
	while not HasAnimDictLoaded("switch@trevor@escorted_out") do
		Wait(10)
	end
    distanceToHave, cercainPed = GetCercainPed()
    if cercainPed ~= nil and distanceToHave < 3 then
        if GetPedType(cercainPed) ~= 28 and IsPedAPlayer(cercainPed) == false and IsPedDeadOrDying(cercainPed) == false and IsPedInAnyVehicle(cercainPed) == false and CheckPedWasCustomerBefore(cercainPed) ~= true then
            local spawnedWorkPed = false
            if(DecorExistOn(cercainPed, 'SPAWNEDPED') )then
                spawnedWorkPed = true
            end
            if(spawnedWorkPed == false) then
                if cercainPed then 
                    if IsEntityAttachedToEntity(cercainPed, GetPlayerPed(PlayerId())) then
                    DetachEntity(cercainPed, GetPlayerPed(PlayerId()), true)
                    ClearPedTasks(GetPlayerPed(PlayerId()))
                    else
                    AttachEntityToEntity(cercainPed, GetPlayerPed(PlayerId()), 11816, 0.0, 0.59, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                    TaskPlayAnim(GetPlayerPed(PlayerId()), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
                    ExecuteCommand('me le sujeta/suelta del brazo')
                    SetEntityAsMissionEntity(cercainPed, true, true)
                    SetBlockingOfNonTemporaryEvents(cercainPed, true)
                    end
                end
            end
        end
    end
end)