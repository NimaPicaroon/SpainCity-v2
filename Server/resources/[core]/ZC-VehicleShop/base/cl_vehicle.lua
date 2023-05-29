VehicleController = setmetatable({ }, VehicleController)
VehicleController._store = {}
VehicleController._data = {}
VehicleController._scale = {1, ''}

VehicleController.closest = nil
VehicleController.buying = false

VehicleController.__index = VehicleController

VehicleController.sync = function(vehicleshop, data)
    if type(vehicleshop) ~= 'string' then
        return
    end
    
    if type(data) ~= 'table' then
        return
    end

    local self = {}
    self.data = data
    self.vehicleshop = vehicleshop

    self.set = function()
        VehicleController._store[self.vehicleshop] = self.data
    end

    self.set()
end

VehicleController.get = function(_entity, _type)
    if type(_type) ~= 'string' then
        print('VehicleController.get failed: _type is not a string.')

        return
    end

    local self = {}
    self.entity = _entity
    self.model = GetEntityModel(self.entity)
    self.type = _type
    
    if self.type == 'acceleration' then
        local acceleration = (GetVehicleModelAcceleration(self.model) * 200.0)

        return acceleration % 1 >= 0.5 and math.ceil(acceleration) or math.floor(acceleration)
    elseif self.type == 'speed' then
        local speed = (GetVehicleMaxSpeed(self.entity) * 3600.0 / 1609.344 * 1.9)

        return speed % 1 >= 0.5 and math.ceil(speed) or math.floor(speed)
    elseif self.type == 'brakes' then
        local brakes = (GetVehicleMaxBraking(self.entity) * 70.0)

        return brakes % 1 >= 0.5 and math.ceil(brakes) or math.floor(brakes)
    elseif self.type == 'traction' then
        local traction = (GetVehicleModelMaxTraction(self.model) * 20)

        return traction % 1 >= 0.5 and math.ceil(traction) or math.floor(traction)
    end
end

exports('getSpecifications', VehicleController.get)

VehicleController.scaleform = function(_data)
    SetScaleformMovieAsNoLongerNeeded(VehicleController._scale[1])
    Wait(100)
    scaleform = RequestScaleformMovie("mp_car_stats_20")

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SET_VEHICLE_INFOR_AND_STATS")
    PushScaleformMovieFunctionParameterString(_data.name)
    PushScaleformMovieFunctionParameterString("~h~Precio: ~y~".._data.price)
    PushScaleformMovieFunctionParameterString("MPCarHUD")
    PushScaleformMovieFunctionParameterString("benefactor")
    PushScaleformMovieFunctionParameterString("Max Velocidad")
    PushScaleformMovieFunctionParameterString("Aceleración")
    PushScaleformMovieFunctionParameterString("Frenos")
    PushScaleformMovieFunctionParameterString("Tracción")
    PushScaleformMovieFunctionParameterInt(_data.speed)
    PushScaleformMovieFunctionParameterInt(_data.acceleration)
    PushScaleformMovieFunctionParameterInt(_data.brakes)
    PushScaleformMovieFunctionParameterInt(_data.traction)
    PopScaleformMovieFunctionVoid()
    VehicleController._scale = {scaleform,_data.name}
    EndScaleformMovieMethod()

    return scaleform
end

exports('createScaleform', VehicleController.scaleform)

VehicleController.create = function(vehicleshop)
    if type(vehicleshop) ~= 'string' then
        return
    end

    local self = {}
    self.vehicleshop = vehicleshop

    self.create = function()
        for _,v in pairs(VehicleController._store[self.vehicleshop]) do
            if (v.data.entity == 0 or not DoesEntityExist(v.data.entity)) or (DoesEntityExist(v.data.entity)) then
                while DoesEntityExist(v.data.entity) do
                    DeleteVehicle(v.data.entity)
                    SetEntityAsMissionEntity(v.data.entity, false, true)

                    Wait(100)
                end

                RequestModel(GetHashKey(v.data.model))
                while not HasModelLoaded(GetHashKey(v.data.model)) do
                    RequestModel(GetHashKey(v.data.model))

                    Wait(0)
                end

                W.SpawnLocalVehicle(v.data.model, vector3(v.x, v.y, v.z), v.w, function(vehicle)
                    v.data.entity = vehicle

                    SetVehicleDirtLevel(vehicle, 0.0)
                    SetVehicleColours(vehicle, v.data.colour.primary, v.data.colour.secondary)
                    SetVehicleCustomSecondaryColour(vehicle, 0, 0, 0)

                    SetEntityAsMissionEntity(vehicle, true, true)
                    SetVehicleOnGroundProperly(vehicle)
                    FreezeEntityPosition(vehicle, true)
                    SetEntityInvincible(vehicle, true)
                    SetModelAsNoLongerNeeded(vehicle)
                    SetEntityProofs(vehicle, true, true, true, true, true, true, 1, true)
                    SetVehicleTyresCanBurst(vehicle, false)
                    SetVehicleCanBreak(vehicle, false)
                    SetVehicleCanBeVisiblyDamaged(vehicle, false)
                    SetEntityCanBeDamaged(vehicle, false)
                    SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
                    SetVehicleDoorsLocked(vehicle, 2)
                end)
            end
        end
    end

    self.create()
end

VehicleController.buy = function(price, vehicleshop, spot, data)
    if type(price) ~= 'number' then
        return
    end
    
    if type(vehicleshop) ~= 'string' then
        return
    end

    local self = {}
    self.price = price
    self.vehicleshop = vehicleshop
    self.spot = spot
    self.data = data

    W.TriggerCallback('vehicleshop:money', function(enough, message)
        if enough then
            while not DoesEntityExist(self.data.entity) do
                Wait(150)
            end

            self.data.properties = W.GetVehicleProperties(self.data.entity)
            self.data.properties.plate = Utils.GeneratePlate()
            self.data.properties.fuel = 100.0
            
            if self.data.properties.plate then
                TriggerServerEvent('vehicleshop:buy', self.price, self.vehicleshop, self.spot, self.data)
            end
        else
            W.Notify('Concesionario', message, 'error')
        end
    end, self.price)
end

RegisterNetEvent('vehicleshop:create', VehicleController.create)
RegisterNetEvent('vehicleshop:sync', VehicleController.sync)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    TriggerServerEvent('vehicleshop:loaded', GetPlayerServerId(PlayerId()))

    for k,v in pairs(VEHICLE_DATA.BLIPS) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
		SetBlipSprite (blip, v.sprite)
		SetBlipScale  (blip, 0.6)
		SetBlipDisplay(blip, 4)
		SetBlipColour (blip, 51)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.text)
		EndTextCommandSetBlipName(blip)
    end
end)

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        for k,v in pairs(VehicleController._store) do
            local dist = #(playerPos - vec3(VehicleController._store[k][1].x, VehicleController._store[k][1].y, VehicleController._store[k][1].z))

            if dist < 50.0 then
                VehicleController.closest = k
            end
        end

        Citizen.Wait(2000)
    end
end)

ClosestVehicle = nil

Citizen.CreateThread(function()
    while true do
        local msec = 350
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        if VehicleController.closest then
            for k,v in pairs(VehicleController._store[VehicleController.closest]) do
                local dist = #(playerPos - vec3(v.x, v.y, v.z))

                if dist < 100.0 then
                    SetEntityCoords(v.data.entity, v.x, v.y, v.z)
                    SetEntityHeading(v.data.entity, v.w)
                end

                if dist <= 3.0 then
                    ClosestVehicle = k
                end
            end
        end

        Citizen.Wait(msec)
    end
end)

Citizen.CreateThread(function()
    local inZone = false
    local shown = false
    
    while true do
        local msec = 500
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        inZone = false

        if ClosestVehicle and VehicleController.closest and VehicleController._store[VehicleController.closest][ClosestVehicle] then
            local data = VehicleController._store[VehicleController.closest][ClosestVehicle]
            local dist = #(playerPos - vec3(data.x, data.y, data.z))
            local _, dim = GetModelDimensions(GetHashKey(data.data.model))
            local vehCoords = GetEntityCoords(data.data.entity) + vec3(0.0, 0.0, dim.z + 2.5)

            if dist <= 2.5 then
                msec = 0
                inZone = true

                if not data.data.scaleform or VehicleController._scale[2] ~= GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(data.data.model))) then
                    data.data.scaleform = VehicleController.scaleform({
                        entity = data.data.entity,
                        name = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(data.data.model))),
                        price = data.data.price and (data.data.price..'€') or 'ERROR',
                        speed = VehicleController.get(data.data.entity, 'speed'),
                        acceleration = VehicleController.get(data.data.entity, 'acceleration'),
                        brakes = VehicleController.get(data.data.entity, 'brakes'),
                        traction = VehicleController.get(data.data.entity, 'traction')
                    })
                else
                    DrawScaleformMovie_3dNonAdditive(data.data.scaleform, vehCoords, 181.0, 180.0, GetGameplayCamRot().z + 180.0, 0.0, 2.0, 0.0, 7.0, 5.0, 6.0,0)
                end

                if IsControlJustPressed(0, 176) then
                    local playerVip = W.GetPlayerData().vip

                    if VEHICLE_DATA.VIPS[data.vehicleShop] then
                        if playerVip and (tonumber(playerVip) >= 3) then
                            VehicleController.buying = true
                            VehicleController._data = { price = data.data.price, vehicleshop = data.vehicleShop, spot = data.spot, data = data.data}
                            TriggerEvent("Ox-Banking:buyWithCreditCard", GetCurrentResourceName())
                            exports['ZC-HelpNotify']:close('buy_vehicle_interaction') 
                        else
                            VehicleController.buying = false
                            VehicleController._data = {}
        
                            W.Notify('Concesionario', 'Debes ser VIP para acceder a este concesionario', 'error')
                        end
                    else
                        VehicleController.buying = true
                        VehicleController._data = { price = data.data.price, vehicleshop = data.vehicleShop, spot = data.spot, data = data.data}
                        TriggerEvent("Ox-Banking:buyWithCreditCard", GetCurrentResourceName())
                        exports['ZC-HelpNotify']:close('buy_vehicle_interaction') 
                    end
                end
            end
        end

        if inZone and not shown then
            shown = true

            exports['ZC-HelpNotify']:open('Usa <strong>ENTER</strong> para comprar', 'buy_vehicle_interaction')
        elseif not inZone and shown then
            shown = false

            exports['ZC-HelpNotify']:close('buy_vehicle_interaction')
        end

        Citizen.Wait(msec)
    end
end)

RegisterNUICallback("closePin", function (data, cb)
    VehicleController.buying = false
    VehicleController._data = {}
    W.Notify('Concesionario', 'Transacción fallida', 'error')

    return cb("")
end)

RegisterNUICallback("correctPin", function(data, cb)
    VehicleController.buying = false
    VehicleController.buy(VehicleController._data.price, VehicleController._data.vehicleshop, VehicleController._data.spot, VehicleController._data.data)

    return cb("")
end)

exports('getScale', function() return VehicleController._scale end)