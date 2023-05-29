CreateThread(function()
    local show = false
    local closestVehicel = nil
    local closestDoor = nil
    while true do
        local wait = 1000
        closestVehicel = nil
        closestDoor = nil
        local ped = PlayerPedId()
        local pco = GetEntityCoords(ped)
        local veh, Distance = W.GetClosestVehicle(pco)

        if (DoesEntityExist(veh) and Distance < 3.0 and IsPedInAnyVehicle(ped) == false and GetSelectedPedWeapon(ped) ~= 883325847) then
            for i = 1, GetNumberOfVehicleDoors(veh), 1 do
                local coord = GetEntryPositionOfDoor(veh, i)

                if (Vdist2(pco, coord) < 0.75 and not DoesEntityExist(GetPedInVehicleSeat(veh, i - 1)) and GetVehicleDoorLockStatus(veh) ~= 2 and GetEntityModel(veh) ~= -956048545) then
                    closestVehicel = veh
                    closestDoor = i - 1
                    if not show then
                        show = true
                        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para montarse', 'doors')
                    end
                    break
                end
            end

            if closestDoor then
                wait = 0
                if (IsControlJustPressed(1, 38)) then
                    TaskEnterVehicle(PlayerPedId(), closestVehicel, 10000, closestDoor, 1.0, 1, 0)
                end
            end
        end

        if show and not closestDoor then
            exports['ZC-HelpNotify']:close('doors')
            show = false
        end

        Wait(wait)
    end
end)