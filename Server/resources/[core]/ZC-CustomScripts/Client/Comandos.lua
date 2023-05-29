RegisterCommand('motor', function(source, args)
    local power = GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId(), false))
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
   
    if power then
       SetVehicleEngineOn(vehicle, false, true, true)
       W.Notify('Motor', 'Has ~r~apagado el motor', 'verify')
    else
       SetVehicleEngineOn(vehicle, true)
       W.Notify('Motor', 'Has ~g~encendido el motor', 'verify')
    end
end)    
   
RegisterCommand('puerta', function(source, args)
    if args[1] then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        if GetVehicleDoorAngleRatio(vehicle, tonumber(args[1])) == 0 then
            SetVehicleDoorOpen(vehicle, tonumber(args[1]), false, false)
        else
            SetVehicleDoorShut(vehicle, tonumber(args[1]), false, false)  
        end
    else
        W.Notify('Puerta', 'Debes especificar el número de puerta', 'error')
    end
end)