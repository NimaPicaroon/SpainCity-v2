local garaje =  {
	{x = 1129.84, y = 2125.36, z = 54.61}
}

local borrado =  {
	{x = 1112.76, y = 2112.44, z = 53.11}
}

local blips = {
	{title="Circuito de motocross", colour=0, id=512, x = 1129.96, y = 2125.08, z = 1.0}
}

local yourveh = nil

CreateThread(function()
	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.7)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)

CreateThread(function()
    while true do
		local wait = 1000
		local coords = GetEntityCoords(PlayerPedId())

        for k in pairs(garaje) do
			if #(coords - vec3(garaje[k].x, garaje[k].y, garaje[k].z)) < 15.0 then
				wait = 0
            	DrawMarker(1, garaje[k].x, garaje[k].y, garaje[k].z, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.101, 0, 153, 255, 255, 0, 0, 0, 1)
			end
		end

		for k in pairs(borrado) do
			if #(coords - vec3(borrado[k].x, borrado[k].y, borrado[k].z)) < 18.0 then
				wait = 0
            	DrawMarker(1, borrado[k].x, borrado[k].y, borrado[k].z, 0, 0, 0, 0, 0, 0, 3.401, 3.401, 0.101, 255, 0, 0, 255, 0, 0, 0, 1)
			end
		end

		Wait(wait)
    end
end)

CreateThread(function()
    while true do
		local wait = 500

        for k in pairs(garaje) do
			local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed, false)
            local dist = #(vec3(plyCoords.x, plyCoords.y, plyCoords.z) - vec3(garaje[k].x, garaje[k].y, garaje[k].z))

            if dist <= 1.3 then
				wait = 0
				W.ShowText(vector3(garaje[k].x, garaje[k].y, garaje[k].z + 1), '~y~Motocross\n~w~Sacar un vehículo', 0.5, 8)

				if IsControlJustPressed(0, 38) then
				  	Garaje2()
				end
			end
		end

		for k in pairs(borrado) do
			local playerPed = PlayerPedId()
			local plyCoords = GetEntityCoords(playerPed, false)
			local dist = #(vec3(plyCoords.x, plyCoords.y, plyCoords.z) - vec3(borrado[k].x, borrado[k].y, borrado[k].z))

            if dist <= 2.5 then
				wait = 0
				W.ShowText(vector3(borrado[k].x, borrado[k].y, borrado[k].z + 1), '~y~Motocross\n~w~Guardar vehículo', 0.5, 8)
				if IsControlJustPressed(0, 38) then
					DeleteEntity(GetVehiclePedIsIn(playerPed, false))
					yourveh = nil
				end
			end
		end
		Wait(wait)
	end
end)

function PuntoLibre2()
	local spawnPoint2 = vector3(1114.52, 2133.44, 52.45)
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoint2, 1 do
		if W.IsSpawnPointClear(spawnPoint2, 2.5) then
			found, foundSpawnPoint = true, spawnPoint2
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		W.Notify('ERROR', 'Hay un vehiculo obstruyendo', 'error')
		return false
	end
end

function Garaje2()
	local heading = 329.92

	local elements = {
		{label = 'Sanchez', value = 'sanchez'},
		{label = 'Quad', value = 'blazer'}
	}

	W.OpenMenu("Motocross", "cross_menu", elements, function (data, name)
		local foundSpawn, spawnPoint = PuntoLibre2()

		if foundSpawn then
			W.DestroyMenu(name)
			if yourveh then
				DeleteEntity(yourveh)
				yourveh = nil
			end

			W.SpawnVehicle(data.value, spawnPoint, heading, true, function(veh)
				yourveh = veh
				TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
				TriggerEvent("LegacyFuel:SetFuel", veh, 100)
			end)
		end
	end)
end

CreateThread(function()
    while true do
		local wait = 1500

		if yourveh then
			local vehCoords = GetEntityCoords(yourveh, false)
			local dist = Vdist(vehCoords.x, vehCoords.y, vehCoords.z, vector3(1033.36, 2335.08, 48.73))

			if dist >= 300 then
				DeleteEntity(yourveh)
				yourveh = nil
				W.Notify('ERROR', 'Donde ibas crack', 'error')
			end
		end
		Wait(wait)
	end
end)