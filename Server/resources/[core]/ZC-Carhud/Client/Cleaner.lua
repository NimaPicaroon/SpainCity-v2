local vehicleWashStation = {
	{26.5906,  -1392.0261,  27.3634},
	{167.1034,  -1719.4704,  27.2916},
	{-74.5693,  6427.8715,  29.4400},
	{-699.6325,  -932.7043,  17.0139},
	{1362.5385, 3592.1274, 33.9211}
}

Citizen.CreateThread(function()
    local currentatmblip = 0

    while true do
        local coords = GetEntityCoords(PlayerPedId())
        local closest = 1000
        local closestCoords

        for i = 1, #vehicleWashStation do
			local garageCoords = vehicleWashStation[i]
            local dstcheck = #(vector3(garageCoords[1], garageCoords[2], garageCoords[3]) - vector3(coords.x, coords.y, coords.z))

            if dstcheck < closest then
                closest = dstcheck
                closestCoords = vector3(garageCoords[1], garageCoords[2], garageCoords[3])
            end
        end

        if DoesBlipExist(currentatmblip) then
            RemoveBlip(currentatmblip)
            currentatmblip = 0
        end

        if closestCoords then
            currentatmblip = CreateBlip(closestCoords)
        end

        Wait(2500)
    end
end)

function CreateBlip(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 100)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)

    return blip
end

local timer2 = false
local mycie = false

Citizen.CreateThread(function ()
	local inZone = false
	local shown = false

	while true do
		local sleep = 1500

		inZone = false
		if IsPedSittingInAnyVehicle(PlayerPedId()) then
			sleep = 1000
			for i = 1, #vehicleWashStation do
				local garageCoords2 = vehicleWashStation[i]
				local coords = GetEntityCoords(PlayerPedId())
				local distance = #(vector3(garageCoords2[1], garageCoords2[2], garageCoords2[3]) - vector3(coords.x, coords.y, coords.z))

				if distance < 3 then
					if not mycie then
						sleep = 0
						W.ShowText(vector3(garageCoords2[1], garageCoords2[2], garageCoords2[3] + 3), '~y~Autolavado\n~w~Limpiar tu vehículo', 1, 8)
						inZone = true
						if IsControlJustPressed(1, 38) then
							local data = W.GetPlayerData()
							if data.money.money >= 50 then
								Clean()
							else
								W.Notify('Autolavado', 'No tienes tanto ~y~dinero', 'error')
							end
						end
					else
						sleep = 0
						W.ShowText(vector3(garageCoords2[1], garageCoords2[2], garageCoords2[3] + 3), '~r~Parar', 1, 8)
						if IsControlJustPressed(1, 38) then
							mycie = false
							timer2 = false
							StopParticleFxLooped(particles, 0)
							StopParticleFxLooped(particles2, 0)
							FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), false)
						end
					end
				end
			end
		end

		if inZone and not shown then
			shown = true

			exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_carwash')
		elseif not inZone and shown then
			exports['ZC-HelpNotify']:close('interact_carwash')
			shown = false
		end

		Citizen.Wait(sleep)
	end
end)

Clean = function ()
	local car = GetVehiclePedIsUsing(PlayerPedId())
	local coords = GetEntityCoords(PlayerPedId())
	mycie = true
	FreezeEntityPosition(car, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end
	UseParticleFxAssetNextCall("core")
	local particles  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("core")
	local particles2  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x + 2, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	local timer = 10
	timer2 = true
    Citizen.CreateThread(function()
		while timer2 do
            Citizen.Wait(1000)
            if(timer > 0)then
				timer = timer - 1
			elseif (timer == 0) then
				mycie = false
				WashDecalsFromVehicle(car, 1.0)
				SetVehicleDirtLevel(car)
				FreezeEntityPosition(car, false)
				TriggerServerEvent('ZC-Carhud:removeMoney', 50)
				W.Notify('Autolavado', 'Has lavado tu ~y~coche', 'verify')
				StopParticleFxLooped(particles, 0)
				StopParticleFxLooped(particles2, 0)
				timer2 = false
			end
        end
    end)
end