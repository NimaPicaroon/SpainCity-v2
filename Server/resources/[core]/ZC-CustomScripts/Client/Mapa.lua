local isRadarExtended = false

Citizen.CreateThread(function()
	while true do
		local wait = 1500

		if IsPedInAnyVehicle(PlayerPedId(), false) then
			DisplayRadar(true)
		else
			DisplayRadar(false)
		end

		Citizen.Wait(wait)
	end
end)

RegisterKeyMapping('mapa', 'Hacer el mapa grande', 'keyboard', 'M')

RegisterCommand("mapa", function(source)
	--if exports['Ox-Phone']:IsPhoneOpened() then return end
	if exports['Ox-Jobcreator']:IsHandcuffed() then return end
	if exports['ZC-Ambulance']:IsDead() then return end
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		if not isRadarExtended then
			SetRadarBigmapEnabled(true, false)
			LastGameTimer = GetGameTimer()
			isRadarExtended = true
		elseif isRadarExtended then
			SetRadarBigmapEnabled(false, false)
			LastGameTimer = 0
			isRadarExtended = false
		end
	end
end, false)

--MENU PAUSA
function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	AddTextEntry('PM_PANE_LEAVE', 'Lista de Servidores ')
	AddTextEntry('PM_PANE_QUIT', 'Salir de FiveM')
	AddTextEntry('PM_SCR_MAP', 'Mapa de SpainCity')
	AddTextEntry('PM_SCR_GAM', 'Salir')
	AddTextEntry('PM_SCR_INF', 'Notificaciones')
	AddTextEntry('PM_SCR_SET', 'Ajustes')
	AddTextEntry('PM_SCR_STA', 'Estadísticas')
	AddTextEntry('PM_SCR_RPL', 'Editor')
end)