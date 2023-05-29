W = exports.ZCore:get()

local timing, isPlayerWhitelisted = math.ceil(Config.Timer * 60000), false

Citizen.CreateThread(function()

	while W.GetPlayerData().job == nil do
		Citizen.Wait(15)
	end

	PlayerData = W.GetPlayerData()

	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('Ox-Disparos:Notify')
AddEventHandler('Ox-Disparos:Notify', function(alert)
	if isPlayerWhitelisted then
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 0)
		W.Notify('DISPARO', alert)
	end
end)

RegisterNetEvent('ZCore:setJob', function(job)
    PlayerData.job = job

	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('Ox-Disparos:InProgress')
AddEventHandler('Ox-Disparos:InProgress', function(coords)
	if isPlayerWhitelisted then
	local alpha = 250
	local gunshotBlip = AddBlipForRadius(coords.x, coords.y, coords.z, Config.BlipGunRadius)

	SetBlipHighDetail(gunshotBlip, true)
	SetBlipColour(gunshotBlip, 1)
	SetBlipAlpha(gunshotBlip, alpha)
	SetBlipAsShortRange(gunshotBlip, true)

	while alpha ~= 0 do
		Citizen.Wait(Config.BlipGunTime * 4)
		alpha = alpha - 1
		SetBlipAlpha(gunshotBlip, alpha)

		if alpha == 0 then
			RemoveBlip(gunshotBlip)
			return
		end
	end
end
end)

function refreshPlayerWhitelisted()
	if not PlayerData then
		return false
	end

	if not PlayerData.job then
		return false
	end

	for k,v in ipairs(Config.WhitelistedCops) do
		if v == PlayerData.job.name then
			return true
		end
	end

	return false
end

CreateThread(function()
	while true do
		Wait(2000)

		if DecorGetInt(PlayerPedId(), 'isOutlaw') == 2 then
			Citizen.Wait(timing)
			DecorSetInt(PlayerPedId(), 'isOutlaw', 1)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(20)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		streetName = GetStreetNameFromHashKey(streetName)
		local arma = GetSelectedPedWeapon(playerPed)

		if IsPedShooting(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and not exports['eden_airsoft']:isPlaying() and arma ~= 911657153 and arma ~= 600439132 then
			 --print (weaponHash)
			Wait(3000)

			if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
			DecorSetInt(playerPed, 'isOutlaw', 2)
			TriggerServerEvent("Ox-Disparos:callPolice", playerCoords, streetName)
			end
		end
	end
end)
