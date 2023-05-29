local damaged = false

CreateThread(function ()
    W.Print("INFO", "Starting the main dead thread dead handler!")
    while true do
        local Sleep = 500
        local Ped = PlayerPedId()
        local Status = GlobalState[Amb.Variables.OwnId..'-status']

        if Status and not Amb.Variables.IsDead then
            if Status.hunger <= 0 then
                TaskLeaveVehicle(Ped, GetVehiclePedIsIn(Ped, false), 1)
                Amb.Die()
            end

            if Status.thirst <= 0 then
                TaskLeaveVehicle(Ped, GetVehiclePedIsIn(Ped, false), 1)
                Amb.Die()
            end
        end

        if GetEntityHealth(Ped) <= 149 then
            setHurt()
        elseif damaged and GetEntityHealth(Ped) > 150 then
            setNotHurt()
        end

        Wait(Sleep)
    end
end)

function setHurt()
    damaged = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(PlayerPedId(), "move_m@injured", true)
end

function setNotHurt()
    damaged = false
    ResetPedMovementClipset(PlayerPedId())
    ResetPedWeaponMovementClipset(PlayerPedId())
    ResetPedStrafeClipset(PlayerPedId())
end