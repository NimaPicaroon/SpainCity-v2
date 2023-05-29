RegisterNetEvent('Ox-Interaction:putInVehicleNPC')
AddEventHandler('Ox-Interaction:putInVehicleNPC', function()
    distanceToHave, cercainPed = GetCercainPed()
    if cercainPed ~= nil and distanceToHave < 3 then
        if GetPedType(cercainPed) ~= 28 and IsPedAPlayer(cercainPed) == false and IsPedDeadOrDying(cercainPed) == false and IsPedInAnyVehicle(cercainPed) == false and CheckPedWasCustomerBefore(cercainPed) ~= true then
            local spawnedWorkPed = false
            if(DecorExistOn(cercainPed, 'SPAWNEDPED') )then
                spawnedWorkPed = true
            end
            if(spawnedWorkPed == false) then
                local vehicle, Distance = W.GetClosestVehicle()
                if Distance < 6 then
                    if IsVehicleSeatFree(vehicle, 2) then
                        TaskWarpPedIntoVehicle(cercainPed, vehicle, 2)
                    elseif IsVehicleSeatFree(vehicle, 3) then
                        TaskWarpPedIntoVehicle(cercainPed, vehicle, 3)
                    elseif IsVehicleSeatFree(vehicle, 1) then
                        TaskWarpPedIntoVehicle(cercainPed, vehicle, 1)
                    else
                        TaskWarpPedIntoVehicle(cercainPed, vehicle, -2)
                    end
                    ExecuteCommand('me le introduce en el vehículo')
                    SetEntityAsMissionEntity(cercainPed, true, true)
                    SetBlockingOfNonTemporaryEvents(cercainPed, true)
                end
            end
        end
    end
end)


RegisterNetEvent('Ox-Interaction:OutPlayerVehicleNPC')
AddEventHandler('Ox-Interaction:OutPlayerVehicleNPC', function()
    distanceToHave, cercainPed = GetCercainPed()
    if cercainPed ~= nil and distanceToHave < 3 then
        if GetPedType(cercainPed) ~= 28 and IsPedAPlayer(cercainPed) == false and CheckPedWasCustomerBefore(cercainPed) ~= true then
            local spawnedWorkPed = false
            if(DecorExistOn(cercainPed, 'SPAWNEDPED') )then
                spawnedWorkPed = true
            end
            if(spawnedWorkPed == false) then
                local vehicle = GetVehiclePedIsIn(cercainPed, false)
                TaskLeaveVehicle(cercainPed, vehicle, 16)
                ExecuteCommand('me le saca del vehículo')
                SetEntityAsMissionEntity(cercainPed, true, true)
                SetBlockingOfNonTemporaryEvents(cercainPed, true)
            end
        end
    end
end)