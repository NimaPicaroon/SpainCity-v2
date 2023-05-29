RegisterNetEvent('Wave:GiveDonatorVehicle', function(model)
    local player = PlayerPedId()

    if not model or not IsModelInCdimage(model) then
        return W.Notify('Donador', 'El modelo del vehiculo escrito no es un modelo válido', 'error')
    end

    if IsPedInAnyVehicle(player) then
        local vehicle = GetVehiclePedIsIn(player)
        local vehicleData = W.GetVehicleProperties(vehicle)

        if vehicle and vehicleData then
            if GetEntityModel(vehicle) == GetHashKey(model) then
                TriggerServerEvent('Wave:SetDonatorVehicle', GetPlayerServerId(PlayerId()), vehicleData, GetVehicleNumberPlateText(vehicle), model)
                W.Notify('Donador', 'Transfiriendo vehículo al depósito...', 'warn')
            else
                W.Notify('Donador', 'El modelo del coche que el administrador ha puesto en el comando no es el mismo en el que estás montado.', 'error')
            end
        end
    else
        W.Notify('Donador', 'Tienes que estar montado en un coche para poder hacer esto', 'error')
    end
end)