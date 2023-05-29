local garaje =  {
	{x = 5478.2, y = 254.88, z = 19.13}
}

local borrado =  {
	{x = 5473.16, y = 254.64, z = 19.13}
}

local blips = {
	{title="Karts", colour=0, id=380, x = -2273.09, y = 228.65, z = 169.6}
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
            	DrawMarker(1, borrado[k].x, borrado[k].y, borrado[k].z, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.101, 255, 0, 0, 255, 0, 0, 0, 1)
			end
		end

		Wait(wait)
    end
end)

CreateThread(function()
    while true do
		local wait = 1000

        for k in pairs(garaje) do
			local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed, false)
            local dist = #(vec3(plyCoords.x, plyCoords.y, plyCoords.z) - vec3(garaje[k].x, garaje[k].y, garaje[k].z))

            if dist <= 1.3 then
				wait = 0
				W.ShowText(vector3(garaje[k].x, garaje[k].y, garaje[k].z + 1), '~y~Karts\n~w~Sacar un kart', 0.5, 8)
				if IsControlJustPressed(0, 38) then
				  	Garajekarts()
				end
			end
		end

		for k in pairs(borrado) do
			local playerPed = PlayerPedId()
			local plyCoords = GetEntityCoords(playerPed, false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, borrado[k].x, borrado[k].y, borrado[k].z)

            if dist <= 1.5 then
				wait = 0
				W.ShowText(vector3(borrado[k].x, borrado[k].y, borrado[k].z + 1), '~y~Karts\n~w~Guardar kart', 0.5, 8)
				if IsControlJustPressed(0, 38) then
					DeleteEntity(GetVehiclePedIsIn(playerPed, false))
					yourveh = nil
				end
			end
		end
		Wait(wait)
	end
end)

CreateThread(function()
    while true do
		local wait = 1500

		if yourveh then
			local vehCoords = GetEntityCoords(yourveh, false)
			local dist = Vdist(vehCoords.x, vehCoords.y, vehCoords.z, vector3(5473.2, 272.56, 19.13))

			if dist >= 300 then
				DeleteEntity(yourveh)
				yourveh = nil
				W.Notify('ERROR', 'Donde ibas crack', 'error')
			end
		end
		Wait(wait)
	end
end)

function PuntoLibre3()
	local spawnPoint2 = vector3(5473.2, 272.56, 19.13)
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

function Garajekarts()
	local heading = 351.92

	local elements = {
		{label = 'Kart', value = 'veto'},
		{label = 'Kart 2', value = 'veto2'}
	}

	W.OpenMenu("Karts", "karts_menu", elements, function (data, name)
		local foundSpawn, spawnPoint = PuntoLibre3()

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