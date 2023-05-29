GLOBAL_BLIPS = {}
isBoss = false
Changing = false
MyData = {}


RegisterNetEvent("Ox-Gangs:fetchGang", function(gangData)
    Changing = true
    for k,v in pairs(GLOBAL_BLIPS) do
        RemoveBlip(v.blip)
    end
    if gangData then
        local data =  W.GetPlayerData().gang
        MyData.gang = data
        MyData.gangData = gangData
        CreateThread(function ()
            if gangData.blip then
                local v = gangData.blip[1]
                local blip = AddBlipForCoord(vector3(tonumber(v.x) + 0.0, tonumber(v.y) + 0.0, tonumber(v.z) + 0.0))
                SetBlipSprite(blip, tonumber(v.sprite))
                SetBlipColour(blip, tonumber(v.color))
                SetBlipScale(blip, 0.8)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.text)
                EndTextCommandSetBlipName(blip)
                table.insert(GLOBAL_BLIPS, { blip = blip })
            end
            isBoss = data.isBoss
            Changing = false

            while true do
                local PlayerPed = PlayerPedId()
                local PlayerCoords = GetEntityCoords(PlayerPed)
                local Sleep = 1000
                for k, v in pairs(points) do
                    if v.name == data.name then

                        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.garage.x,v.garage.y,v.garage.z, true) < 3.0 then
							Sleep = 0
							DrawMarker(1, vec3(tonumber(v.garage.x), tonumber(v.garage.y), tonumber(v.garage.z) - 0.91) , 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 0, 255, 0, 255, 0, 0, 0, 0, 0, 0, 0)
							W.ShowText(vec3(v.garage.x, v.garage.y, v.garage.z), '~g~Garaje\n~w~Ver vehículos', 0.8, 8)
							if IsControlJustReleased(0, 38) then
                                local VehData = {}
                                table.insert(VehData, {label = v.bike.label, value = v.bike.value, color1 = v.bike.color1, color2 = v.bike.color2})
                                table.insert(VehData, {label = v.car.label, value = v.car.value, color1 = v.car.color1, color2 = v.car.color2})
                                W.OpenMenu("Vehículos", "vehs_menu", VehData, function (data, name)
                                    local v = data.value
                                    local colorprim = data.color1
                                    local colorsec = data.color2
                                    local coords = GetEntityCoords(GetPlayerPed(-1))
                                    local heading = GetEntityHeading(GetPlayerPed(-1))

                                    --if W.GetPlayerData().money.bank > data.price then
                                        W.SpawnVehicle(data.value, coords, heading, true, function(veh)
                                            SetVehicleColours(veh, colorprim, colorsec)
                                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                            TriggerEvent("LegacyFuel:SetFuel", veh, 100)
                                        end)
                                        --TriggerServerEvent("Ox-Gangs:vehiclesmoney", data.price, MyData.gang.name)
                                    --else 
                                        --W.Notify('GARAJE', 'No tienes suficiente dinero', 'error')
                                    --end
                                    W.DestroyMenu(name)
                                    
                                end)
							end
						elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.saveCar.x,v.saveCar.y,v.saveCar.z, true) < 4.0 then
							Sleep = 0
							DrawMarker(1, vec3(tonumber(v.saveCar.x), tonumber(v.saveCar.y), tonumber(v.saveCar.z) - 0.91), 0, 0, 0, 0, 0, 0, 3.401, 3.401, 0.11, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0)
                            W.ShowText(vec3(v.saveCar.x, v.saveCar.y, v.saveCar.z), '~r~Garaje\n~w~Guardar vehículos', 0.8, 8)
							if IsControlJustReleased(0, 38) then
                                CreateThread(function ()
                                    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                                    TaskLeaveVehicle(PlayerPedId(), Vehicle, 0)
                                    Wait(2000)
                                    DeleteVehicle(Vehicle)
                                end)
							end
                        elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.armory.x,v.armory.y,v.armory.z, true) < 3.0 then
                            Sleep = 0
							DrawMarker(1, vec3(tonumber(v.armory.x), tonumber(v.armory.y), tonumber(v.armory.z) - 0.91), 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.051, 255, 190, 45, 255, 0, 0, 0, 0, 0, 0, 0)
                            W.ShowText(vector3(v.armory.x, v.armory.y, v.armory.z), '~y~Vestuario\n~w~Ver conjuntos', 0.5, 8)
                            if IsControlJustPressed(1, 38) and not MarkersFunction.pressed then
                                MarkersFunction.pressed = true
                                OpenArmory()
                                Citizen.SetTimeout(1000, function()
                                    MarkersFunction.pressed = false
                                end)
                            end 
                        elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.mboss.x,v.mboss.y,v.mboss.z, true) < 3.0 then
                            if isBoss then
                                Sleep = 0
				    			DrawMarker(1, vec3(tonumber(v.mboss.x), tonumber(v.mboss.y), tonumber(v.mboss.z) - 0.91) , 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.051, 255, 190, 45, 255, 0, 0, 0, 0, 0, 0, 0)
                                W.ShowText(vector3(v.mboss.x, v.mboss.y, v.mboss.z), '~y~Jefe\n~w~Ver acciones', 0.5, 8)
                                if IsControlJustPressed(1, 38) and not MarkersFunction.pressed then
                                    MarkersFunction.pressed = true
                                    BossMenu()
                                    Citizen.SetTimeout(1000, function()
                                        MarkersFunction.pressed = false
                                    end)
                                end  
                            end
                        elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.garheli.x,v.garheli.y,v.garheli.z, true) < 6.0 then
                            Sleep = 0
                            if not IsPedInAnyVehicle(PlayerPedId()) then
                                DrawMarker(1, vec3(tonumber(v.garheli.x), tonumber(v.garheli.y), tonumber(v.garheli.z) - 0.91), 0, 0, 0, 0, 0, 0, 3.401, 3.401, 0.11, 0, 255, 0, 255, 0, 0, 0, 0, 0, 0, 0)
                                W.ShowText(vec3(v.garheli.x, v.garheli.y, v.garheli.z), '~g~Helipuerto\n~w~Sacar heli', 0.8, 8)
                                if IsControlJustReleased(0, 38) then
                                    local heliData = {}
                                    table.insert(heliData, {label = v.heli.label, value = v.heli.value, color1 = v.heli.color1, color2 = v.heli.color2})
                                    W.OpenMenu("Vehículos", "helis_menu", heliData, function (data, name)
                                        local v = data.value
                                        local colorprim = data.color1
                                        local colorsec = data.color2
                                        local coords = GetEntityCoords(GetPlayerPed(-1))
                                        local heading = GetEntityHeading(GetPlayerPed(-1))

                                        --if W.GetPlayerData().money.bank > data.price then
                                            W.SpawnVehicle(data.value, coords, heading, true, function(veh)
                                                SetVehicleColours(veh, colorprim, colorsec)
                                                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                                TriggerEvent("LegacyFuel:SetFuel", veh, 100)
                                            end)
                                            --TriggerServerEvent("Ox-Gangs:vehiclesmoney", data.price, MyData.gang.name)
                                        --else 
                                           -- W.Notify('GARAJE', 'No tienes suficiente dinero', 'error')
                                        --end
                                        W.DestroyMenu(name)

                                    end)
                                end
                            else
                                DrawMarker(1, vec3(tonumber(v.garheli.x), tonumber(v.garheli.y), tonumber(v.garheli.z) - 0.91), 0, 0, 0, 0, 0, 0, 5.401, 5.401, 0.11, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0)
                                W.ShowText(vec3(v.garheli.x, v.garheli.y, v.garheli.z), '~r~Helipuerto\n~w~Guardar heli', 0.8, 8)
							    if IsControlJustReleased(0, 38) then
                                    CreateThread(function ()
                                        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                                        TaskLeaveVehicle(PlayerPedId(), Vehicle, 0)
                                        Wait(2000)
                                        DeleteVehicle(Vehicle)
                                    end)
							    end
                            end    
						end
                    end
                end
                if Changing then
                    break
                end
                Wait(Sleep)
            end
        end)
    else
        Changing = false
        MyData.gang = {}
        MyData.gangData = nil
    end
end)

RegisterNetEvent("Ox-Gangs:fetchGangData", function(gangData)
    MyData.gangData = gangData
end)

exports('MyGangData', function()
    return MyData.gangData
end)