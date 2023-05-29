local OwnData = {}

RegisterNetEvent('ZCore:playerLoaded', function()
    OwnData = W.GetPlayerData()
end)

RegisterNetEvent('ZCore:setJob', function(job)
  OwnData.job = job
end)

RegisterNetEvent('ZCore:setGang', function(job2)
  OwnData.gang = job2
end)

key_to_teleport = 38

positions = {
    {{9.96, -667.44, 32.49, 34.36}, {1.32, -701.12, 15.17, 355.08},{8, 131, 0}, "Reserva de oro ~y~E"},
    {{3540.8, 3675.92, 27.17, 169.12}, {3540.2, 3673.24, 20.05, 171.84},{8, 131, 0}, "Humane Labs ~y~E"},
    {{1066.12, -3183.52, -40.11, 0.68}, {2889.72, 4391.4, 49.49, 0.68},{244, 244, 244}, "Zona privada ~y~E"}, --Compra
    {{5477.16, 278.08, 19.39, 0.68}, {-2272.7454, 228.6735, 168.6021, 264.8454},{8, 131, 0}, "Circuito/Ciudad ~y~E"}, -- Karts
    {{-117.16, -604.6, 35.33, 250.16}, {-139.76, -617.48, 167.89, 99.63},{8, 131, 0}, "Eventos ~y~E"}, --Eventos
    {{781.6, -1868.16, 28.33, 85.96}, {-2221.12, 1157.64, -24.51, 181.92},{8, 131, 0}, "Entrar/Salir ~y~E"}, --Eventos
    {{-2151.28, 1106.08, -25.63, 270.96}, {-2137.6, 1106.16, -27.63, 272.92},{8, 131, 0}, "Entrar/Salir ~y~E"}, --Eventos
    {{-2352.67, 3253.17, 31.81, 329.38}, {-2353.68, 3251.336, 100.45, 216.44},{8, 131, 0}, "Subir/Bajar ~y~E"}, --Eventos
    {{1790.1, 4602.64, 36.68, 356.38}, {997.16, -3200.68, -37.39, 273.44},{8, 131, 0}, "entrar ~y~E"}, --Eventos
    {{997.16, -3200.68, -37.39, 273.44}, {1790.1, 4602.64, 36.68, 356.38},{8, 131, 0}, "Salir ~y~E"}, --Eventos  
    {{928.22, 36.69, 80.09, 273.44}, {964.68, 58.52, 111.55, 45.38},{8, 131, 0}, "Subir ~y~E"}, --casino
    {{964.68, 58.52, 111.55, 45.38 }, {928.22, 36.69, 80.09, 273.44},{8, 131, 0}, "Bajar ~y~E"}, --casino
    -- primeras coordenadas, sitio del tp, segundas coordenadas destino del tp, tercer es el color del tp, cuarto el mensaje
}

-----------------------------------------------------------------------------
-------------------------DO NOT EDIT BELOW THIS LINE-------------------------
-----------------------------------------------------------------------------

CreateThread(function ()
    while true do
        local tiempotp = 700
        local player = PlayerPedId()
        local playerLoc = GetEntityCoords(player)

        for _,location in ipairs(positions) do
            teleport_text = location[4]
            loc1 = {
                x=location[1][1],
                y=location[1][2],
                z=location[1][3],
                heading=location[1][4]
            }
            loc2 = {
                x=location[2][1],
                y=location[2][2],
                z=location[2][3],
                heading=location[2][4]
            }
            Red = location[3][1]
            Green = location[3][2]
            Blue = location[3][3]
            job = location[5]

            if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 30) or CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 30) then 
                if job then
                    if jobcompatible(job) == true then
                        if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 12) then 
                            tiempotp = 0
                            DrawMarker(27, loc1.x, loc1.y, loc1.z, 0, 0, 0, 0, 0, 0, 2.00, 2.00, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 1)
                        elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 12) then
                            tiempotp = 0
                            DrawMarker(27, loc2.x, loc2.y, loc2.z, 0, 0, 0, 0, 0, 0, 2.00, 2.00, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 1)
                        end

                        if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 2) then 
                            tiempotp = 0
                            W.ShowText(vector3(loc1.x, loc1.y, loc1.z + 1.8), teleport_text)
                            if IsControlJustReleased(1, key_to_teleport) then
                                if IsPedInAnyVehicle(player, true) then
                                    SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                                    SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                                    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                                        SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                                        SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                                        Wait(50)
                                    end

                                    for i = 1, 10 do
                                        local height = playerLoc.z - loc2.z
                                        if height > 3 then
                                            SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                                            SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                                        end
                                        Wait(500)
                                    end
                                else
                                    SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                                    SetEntityHeading(player, loc2.heading)

                                    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                                        SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                                        SetEntityHeading(player, loc2.heading)
                                        Wait(50)
                                    end
                                    
                                    for i = 1, 10 do
                                        local height = playerLoc.z - loc2.z
                                        if height  > 3 then
                                            SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                                            SetEntityHeading(player, loc2.heading)
                                        end
                                        Wait(500)
                                    end
                                end
                            end

                        elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 2) then
                            tiempotp = 0
                            W.ShowText(vector3(loc1.x, loc1.y, loc1.z + 1.8), teleport_text)

                            if IsControlJustReleased(1, key_to_teleport) then
                                if IsPedInAnyVehicle(player, true) then
                                    SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                                    SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)

                                    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                                        SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                                        SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                                        Wait(50)
                                    end

                                    for i = 1, 10 do
                                        local height = playerLoc.z - loc2.z
                                        if height  > 3 then
                                            SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                                            SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                                        end
                                        Wait(500)
                                    end
                                else
                                    SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                                    SetEntityHeading(player, loc1.heading)

                                    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                                        SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                                        SetEntityHeading(player, loc1.heading)
                                        Wait(50)
                                    end

                                    for i = 1, 10 do
                                        local height = playerLoc.z - loc2.z
                                        if height  > 3 then
                                            SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                                            SetEntityHeading(player, loc1.heading)
                                        end
                                        Wait(500)
                                    end
                                end
                            end
                        end   
                    end 
                else
                    if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 12) then 
                        tiempotp = 0
                        DrawMarker(27, loc1.x, loc1.y, loc1.z, 0, 0, 0, 0, 0, 0, 2.00, 2.00, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 1)
                    elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 12) then
                        tiempotp = 0
                        DrawMarker(27, loc2.x, loc2.y, loc2.z, 0, 0, 0, 0, 0, 0, 2.00, 2.00, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 1)
                    end

                    if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 2) then 
                        tiempotp = 0
                        W.ShowText(vector3(loc1.x, loc1.y, loc1.z + 1.8), teleport_text)

                        if IsControlJustReleased(1, key_to_teleport) then
                            if IsPedInAnyVehicle(player, true) then
                                SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                                SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)

                                while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                                    SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                                    SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                                    Wait(50)
                                end

                                for i = 1, 10 do
                                    local height = playerLoc.z - loc2.z
                                    if height  > 3 then
                                        SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                                        SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                                    end
                                    Wait(500)
                                end
                            else
                                SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                                SetEntityHeading(player, loc2.heading)

                                while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                                    SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                                    SetEntityHeading(player, loc2.heading)
                                    Wait(50)
                                end

                                for i = 1, 10 do
                                    local height = playerLoc.z - loc2.z
                                    if height  > 3 then
                                        SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                                        SetEntityHeading(player, loc2.heading)
                                    end
                                    Wait(500)
                                end
                            end
                        end

                    elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 2) then
                        tiempotp = 0
                        W.ShowText(vector3(loc1.x, loc1.y, loc1.z + 1.8), teleport_text)

                        if IsControlJustReleased(1, key_to_teleport) then
                            if IsPedInAnyVehicle(player, true) then
                                SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                                SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)

                                while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                                    SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                                    SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                                    Wait(50)
                                end

                                for i = 1, 10 do
                                    local height = playerLoc.z - loc1.z
                                    if height  > 3 then
                                        SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                                        SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                                    end
                                    Wait(500)
                                end
                            else
                                SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                                SetEntityHeading(player, loc1.heading)

                                while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                                    SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                                    SetEntityHeading(player, loc1.heading)
                                    Wait(50)
                                end

                                for i = 1, 10 do
                                    local height = playerLoc.z - loc1.z
                                    if height  > 3 then
                                        SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                                        SetEntityHeading(player, loc1.heading)
                                    end
                                    Wait(500)
                                end
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(tiempotp)
    end
end)

function jobcompatible(jobs)
	if(jobs == nil)then
		return true
	end
	for job in pairs(jobs) do
		if((OwnData.job ~= nil and OwnData.job.name == job) or (OwnData.gang ~= nil and OwnData.gang.name and OwnData.gang.name == job))then
			return true
		end
	end
	return false
end

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end
