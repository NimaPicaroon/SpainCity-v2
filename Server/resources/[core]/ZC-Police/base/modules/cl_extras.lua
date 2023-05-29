ExtrasController = setmetatable({ }, ExtrasController)
ExtrasController._store = {}

ExtrasController.__index = ExtrasController

ExtrasController.open = function()
    ExtrasController.distanceCheck(function(inDistance)
        if(inDistance)then
            local self = {}
            self.playerPed = PlayerPedId()
            self.vehicle = GetVehiclePedIsIn(self.playerPed, false)
        
            self.elements = {}
        
            if self.vehicle > 0 then
                if not ExtrasController._store[self.vehicle] then
                    ExtrasController._store[self.vehicle] = {}
        
                    for i = 1, 12 do
                        if DoesExtraExist(self.vehicle, i) then
                            if IsVehicleExtraTurnedOn(self.vehicle, i) then
                                ExtrasController._store[self.vehicle][i] = true
                            else
                                ExtrasController._store[self.vehicle][i] = false
                            end
                        end
                    end
                end
        
                for i = 1, 12 do
                    if DoesExtraExist(self.vehicle, i) then
                        if ExtrasController._store[self.vehicle][i] then
                            table.insert(self.elements, { label = 'Extra '..i..' - Quitar', value = i })
                        else
                            table.insert(self.elements, { label = 'Extra '..i..' - Poner', value = i })
                        end
                    end
                end
        
                W.OpenMenu('Extras policiales', 'police_extras_menu', self.elements, function(data, name)
                    W.DestroyMenu(name)
        
                    if DoesExtraExist(self.vehicle, tonumber(data.value)) then
                        if not ExtrasController._store[self.vehicle][data.value] then
                            local health = W.Round(GetVehicleEngineHealth(self.vehicle), 0)
        
                            ExtrasController._store[self.vehicle][data.value] = true
        
                            SetVehicleExtra(self.vehicle, tonumber(data.value), 0)
                            SetVehicleEngineHealth(self.vehicle, health)
                            W.Notify('Extras', 'Extra número '..tonumber(data.value)..' añadida correctamente.', 'verify')
        
                            Wait(250)
                            ExtrasController.open()
                        else
                            local health = W.Round(GetVehicleEngineHealth(self.vehicle), 0)
                            ExtrasController._store[self.vehicle][data.value] = false
        
                            SetVehicleExtra(self.vehicle, tonumber(data.value), 1)
                            SetVehicleEngineHealth(self.vehicle, health)
                            W.Notify('Extras', 'Extra número '..tonumber(data.value)..' retirada correctamente.', 'verify')
        
                            Wait(250)
                            ExtrasController.open()
                        end
                    end
                end)
            else
                W.Notify('Extras', 'Necesitas estar en un vehículo para poder utilizar esto.', 'error')
            end
        else
            W.Notify('Extras', 'Necesitas estar en alguna comisaría para utilizar el comando', 'error')
        end
    end)
end

ExtrasController.distanceCheck = function(cb)
    -- jobcreatorv2:server:getJobData
    W.TriggerCallback('jobcreatorv2:server:getJobData', function(data)
        print(json.encode(data.points))
        local jobPoints = ExtrasController.purgueCoords(data.points)
        local inZone = false
        local playerCoords = GetEntityCoords(GetPlayerPed(-1))
        for k, v in pairs(jobPoints) do
            local distance = #(playerCoords - v)
            if(distance < 90)then
                cb(true)
                return
            end
        end
        cb(false)
    end, "police")
end

ExtrasController.purgueCoords = function(data)
    local points = {}
    for k, v in pairs(data) do
        if #points == 0 then
            local firstCoords = vector3(tonumber(v.x), tonumber(v.y), tonumber(v.z))
            -- print("First location found: " .. firstCoords)
            table.insert(points, firstCoords)
        else
            local resultFound = false
            local newBeutifyCoords = vector3(tonumber(v.x), tonumber(v.y), tonumber(v.z))
            for _, oldCoords in pairs(points) do
                local distance = #(newBeutifyCoords - oldCoords) 
                if(distance < 90.0)then
                    resultFound = true
                end
            end
            if(not resultFound)then
                -- print("New location found: " .. newBeutifyCoords)
                table.insert(points, newBeutifyCoords)
            end
        end
    end
    return points
end

RegisterNetEvent('police:openExtras', ExtrasController.open)

ExtrasController.livery = function()
    local self = {}
    self.playerPed = PlayerPedId()
    self.vehicle = GetVehiclePedIsIn(self.playerPed, false)

    self.elements = {}

    if self.vehicle > 0 then
        local liveries = GetVehicleLiveryCount(self.vehicle)

        if liveries > 0 then
            for i = 1, liveries do
                table.insert(self.elements, { label = 'Livery - '..i, value = i })
            end

            W.OpenMenu('Liveries', 'police_liveries_menu', self.elements, function(data, name)
                W.DestroyMenu(name)
    
                SetVehicleLivery(self.vehicle, data.value)
                W.Notify('Liveries', 'Livery número '..data.value..' seteado en el vehículo.', 'verify')
                Wait(250)
                ExtrasController.livery()
            end)
        else
            W.Notify('Liveries', 'Este coche no tiene liveries disponibles.', 'error')
        end
    else
        W.Notify('Extras', 'Necesitas estar en un vehículo para poder utilizar esto.', 'error')
    end
end

RegisterNetEvent('police:openLiveries', ExtrasController.livery)