local warned = {}

Citizen.CreateThread(function()
	while false do
		local wait = 10000

		if GetAspectRatio() < 1.4 then
			W.Notify('Resolución', 'La ~r~resolución 4:3 está prohibida en el servidor~w~. Si no te la quitas, serás kickeado del servidor...', 'info')
			local id = GetPlayerServerId(PlayerId())

			if warned[GetPlayerName(id)] == nil then
				warned[GetPlayerName(id)] = 0
			end

			warned[GetPlayerName(id)] = warned[GetPlayerName(id)] + 1

			if warned[GetPlayerName(id)] > 12 then
				warned[GetPlayerName(id)] = 0
				TriggerServerEvent('ZC-CustomScripts:Kick')
			end
		end
		Citizen.Wait(wait)
	end
end)
