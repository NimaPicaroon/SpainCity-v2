local modofps1 = false
local modofps2 = false
local modofps3 = false

RegisterKeyMapping('menupersonal', 'Abrir menú personal', 'keyboard', 'F10')

RegisterCommand('menupersonal', function()
	if exports['ZC-Ambulance']:IsDead() then return end
	OpenPersonalMenu()
end, false)

function OpenPersonalMenu()
	local elements = {}
	local playerData = W.GetPlayerData()

	local inActivity = exports['Ox-Activities']:InActivity()
	if inActivity then
		table.insert(elements, {label = '<span style="color:yellow;">CANCELAR ACTIVIDAD</span>', value = 'cancelar'})
	end

	local vip = '<b style=color:red>No obtenido</b>'

	VIPS = {
		[1] = "<b style=color:blue> Basico</b> 🎲",
		[2] = "<b style=color:gold> Oro</b> 🏆",
		[3] = "<b style=color:lightblue> Premium</b> 🔱",
		[4] = "<b style=color:purple> Deluxe</b> 💎",
		[5] = "<b style=color:red> Fundador</b> 🔥",
		[6] = "<b style=color:yellow> Nuclear</b> ☢️",
		[7] = "<b style=color:yellow> Padrino</b> 🎩",
		[8] = "<b style=color:yellow> Donador</b> 💳"
	}

	if playerData.vip == true or playerData.vip > 0 then
		vip = VIPS[playerData.vip]
	end

	table.insert(elements, { ["label"] = "Cobrar VIP: "..vip, ["value"] = "vip" })
	table.insert(elements, { ["label"] = "Peds 🧍", ["value"] = "peds" })
	-- peds
	--table.insert(elements, { ["label"] = 'Ver horas de servicio', ["value"] = "servicehours" })
	table.insert(elements, { ["label"] = "Menú de licencias", ["value"] = "licenses" })
	table.insert(elements, { ["label"] = 'Tus vehículos', ["value"] = "ownvehicles" })
	table.insert(elements, { ["label"] = "Estética", ["value"] = "hud" })
	table.insert(elements, { ["label"] = "Otros", ["value"] = "others" })
	table.insert(elements, { ["label"] = "Editor de Rockstar", ["value"] = "editor" })

	W.OpenMenu("¿Que quieres hacer?", "menupersonal_menu", elements, function (data, name)
		W.DestroyMenu(name)
		if data.value == 'hud' then
			Wait(200)
			openHudMenu()
		elseif data.value == "peds" then
			ExecuteCommand('peds')
		elseif data.value == 'vip' then
			TriggerServerEvent('vip:getVipSalary')
		elseif data.value == 'others' then
			Wait(200)
			openOthersMenu()
		elseif data.value == 'editor' then
			Wait(200)
			rockstarEditor()
		elseif data.value == 'cancelar' then
			TriggerServerEvent('Ox-Activities:cancelar', inActivity)
		elseif data.value == 'ownvehicles' then
			Wait(200)
			GetOwnVehicles(playerData.identifier)
		-- elseif data.value == 'servicehours' then
		-- 	Wait(200)
		-- 	W.TriggerCallback('Menupersonal:getHours', function(hours, minutes)
		-- 		if not minutes then
		-- 			minutes = 0
		-- 		end

		-- 		W.Notify('Horas', 'Has hecho en total ~y~'..hours..'~w~ horas y ~y~'..minutes..'~w~ minutos en total')
		-- 	end)
		elseif data.value == 'licenses' then
			Wait(200)
			OpenDniMenu()
		end
	end)
end

GetOwnVehicles = function(identifier)
    local garages = exports['ZC-Garages']:getVehicles()
    local vehicles = {}

    for key, value in next, garages do
		print(value.owner, identifier)
        if value.owner == identifier then
            value.model = GetHashKey(value.model)
            table.insert(vehicles, { label = GetLabelText(GetDisplayNameFromVehicleModel(value.model))..' - '..value.plate, model = value.model, value = value.garage, plate = value.plate, vehicleshop = value.vehicleshop })
        end
    end

    W.OpenMenu("Tus Vehículos", "inter-menu-cumbai-vehicle", vehicles, function (data, menu)
        W.DestroyMenu(menu)

        if not data or not data.value then
            return
        end
        local elements2 = {}
        table.insert(elements2, {label = "Ver localización del vehículo", value = "view_location_veh"})
        
        Wait(250)
        W.OpenMenu("Información - " .. data.plate, "menu-vehicle-info-options", elements2, function (data2, menu2)
            W.DestroyMenu(menu2)
            if not data2 or not data2.value then
                return
            end
            if(data2.value == "view_location_veh")then
                W.Notify('Vehículos', 'Tu '..data.label..' está en el '..data.value, 'info')
            elseif(data2.value == "copy_keys_gps")then
                TriggerServerEvent('vehicleshop:copyKey', data.plate, data.model)
            end
        end)
    end)
end

function openOthersMenu()
	local pressed = false
	local elements = {}
	local xPlayerData = W.GetPlayerData()
	table.insert(elements, { ["label"] = "Posición de armas", ["value"] = "weapons" })
	table.insert(elements, { ["label"] = "Información laboral", ["value"] = "laboralinfo" })
	table.insert(elements, { ["label"] = "Estadísticas del personaje", ["value"] = "stats" })
	table.insert(elements, { ["label"] = "Verificar pin bancario", ["value"] = "bank_pin" })

	W.OpenMenu("¿Que quieres hacer?", "others_menu", elements, function (data, name)
		pressed = true
		W.DestroyMenu(name)
		if data.value == 'weapons' then
			Wait(200)
			OpenHolsterMenu()
		elseif data.value == 'laboralinfo' then
			Wait(200)
			OpenJobPersonal()
		elseif(data.value == "bank_pin")then
			W.TriggerCallback("Ox-Banking:getPlayerPin", function(pin)
				if(pin)then
					W.Notify("BANCO", "Acabas de recbir un email procedente del banco. PIN Bancario: " .. tostring(pin))
				end
			end, xPlayerData.identifier)
		elseif data.value == 'stats' then
			ExecuteCommand('stats')
		end
	end, function()
		if not pressed then
			Wait(200)
			OpenPersonalMenu()
		end
	end)
end

function openHudMenu()
	local elements = {}

	table.insert(elements, { ["label"] = "Mostrar/Ocultar HUD", ["value"] = "hud" })
	table.insert(elements, { ["label"] = "Modo cine", ["value"] = "bandas" })
	table.insert(elements, { ["label"] = "Mostrar ID", ["value"] = "ids" })
	table.insert(elements, { ["label"] = "Ocultar ID", ["value"] = "noids" })
	table.insert(elements, { ["label"] = "Mostrar/Ocultar casas en venta", ["value"] = "casas" })

	W.OpenMenu("¿Que quieres hacer?", "hud_menu", elements, function (data, name)
		W.DestroyMenu(name)
		if data.value == 'bandas' then
			TriggerEvent('bandas')
			ExecuteCommand('togglehud')
			TriggerEvent('logo:display')
			ExecuteCommand('togglevoz')
		elseif data.value == 'hud' then
			ExecuteCommand('togglehud')
			TriggerEvent('logo:display')
			ExecuteCommand('togglevoz')
		elseif data.value == 'casas' then
			TriggerEvent('Ox-Housing:ocultarblip')
		elseif data.value == 'noids' then
			ExecuteCommand('noids')
		elseif data.value == 'ids' then
			ExecuteCommand('ids')
		end
	end, function()
		Wait(200)
		OpenPersonalMenu()
	end)
end

function rockstarEditor()
	local elements = {}
	table.insert(elements, {label = 'Iniciar Grabación', value = 'empezar_grabacion'})
	table.insert(elements, {label = 'Guardar grabación', value = 'guardar_grabacion'})
	table.insert(elements, {label = 'Descartar grabación', value = 'descartar_grabacion'})

	W.OpenMenu("¿Que quieres hacer?", "rockstar_menu", elements, function (data, name)
		W.DestroyMenu(name)
		if data.value == 'empezar_grabacion' then
			StartRecording(1)
		elseif data.value == 'guardar_grabacion' then
			if(IsRecording()) then
				StopRecordingAndSaveClip()
			end
		elseif data.value == 'descartar_grabacion' then
			StopRecordingAndDiscardClip()
		end
	end, function()
		Wait(200)
		OpenPersonalMenu()
	end)
end

function OpenJobPersonal()
	local OwnData = W.GetPlayerData()
	local elements = {}

	if OwnData.job.duty then
		local label = ('Facción: <span style="color:yellow;">'..OwnData.job.label..' - '..OwnData.job.ranklabel..'</span>')
		table.insert(elements,	{ label = label, value = ''})	
	else
		local label = ('Facción: <span style="color:red;">'..OwnData.job.label..' - '..OwnData.job.ranklabel..'</span>')
		table.insert(elements,	{ label = label, value = ''})	
	end

	if OwnData.gang and OwnData.gang.name then
		table.insert(elements,	{ label = 'Facción ilegal: <span style="color:red;">' .. OwnData.gang.label .. ' - ' .. OwnData.gang.ranklabel..'</span>', value = ''})
	end


	W.OpenMenu("Información Laboral", "job_info", elements, function(data, name)
		W.DestroyMenu(name)
	end, function()
		Wait(200)
		OpenPersonalMenu()
	end)
end

function OpenDniMenu()
	local elements = {
		{label = 'Ver tu ID', value = 'checkID'},
		{label = 'Mostrar tu ID', value = 'showID'},
		{label = 'Ver tus licencias de conducir', value = 'checkDriver'},
		{label = 'Mostrar tus licencias de conducir', value = 'showDriver'},
	}

	W.OpenMenu("¿Que quieres hacer?", "dd_menu", elements, function (data, name)
		W.DestroyMenu(name)
		local val = data.value

		if val == 'checkID' then
			TriggerServerEvent('ZC-Menupersonal:open', exports['mugshot']:GetMugShotBase64(PlayerPedId(), true), GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'id')
		elseif val == 'checkDriver' then
			TriggerServerEvent('ZC-Menupersonal:open', exports['mugshot']:GetMugShotBase64(PlayerPedId(), true), GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
		else
			local player, distance = W.GetClosestPlayer()

			if distance ~= -1 and distance <= 3.0 then
				if val == 'showID' then
				  TriggerServerEvent('ZC-Menupersonal:open', exports['mugshot']:GetMugShotBase64(PlayerPedId(), true), GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'id' )
				elseif val == 'showDriver' then
			  		TriggerServerEvent('ZC-Menupersonal:open', exports['mugshot']:GetMugShotBase64(PlayerPedId(), true), GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
				end
			else
				W.Notify('ERROR', 'Nadie cerca', 'error')
			end
		end
	end, function()
		Wait(200)
		OpenPersonalMenu()
	end)
end
RegisterCommand('fps',function(src,args)
    if args[1] == 'on' then
        SetTimecycleModifier("cinema")
    elseif args[1] == 'off' then
        SetTimecycleModifier("default")
    end
end)

RegisterNetEvent("ZC-Menupersonal:show", function(data)
	SendNUIMessage(data)
	SetNuiFocusKeepInput(true)
	while true do
		if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
			SendNUIMessage({
				close = true
			})
			break
		end
		Wait(0)
	end

	SetNuiFocusKeepInput(true)
end)

RegisterCommand('fps', function()
	openFpsMenu()
end, false)

function openFpsMenu()
	local elements = {}

	if not(modofps1) then 
		table.insert(elements,{label = 'MODO FPS1: <span style="color: Red;">OFF</span>', value = 'fps1off'})
	else 
		table.insert(elements,{label = 'MODO FPS1: <span style="color: Chartreuse;">ON</span>', value = 'fps1on'})
	end
	if not(modofps2) then 
		table.insert(elements,{label = 'MODO FPS2: <span style="color: Red;">OFF</span>', value = 'fps2off'})
	else 
		table.insert(elements,{label = 'MODO FPS2: <span style="color: Chartreuse;">ON</span>', value = 'fps2on'})
	end
	if not(modofps3) then 
		table.insert(elements,{label = 'MODO FPS3: <span style="color: Red;">OFF</span>', value = 'fps3off'})
	else 
		table.insert(elements,{label = 'MODO FPS3: <span style="color: Chartreuse;">ON</span>', value = 'fps3on'})
	end

	W.OpenMenu("¿Que modo quieres activar?", "fps_menu", elements, function (data, name)
		W.DestroyMenu(name)
		if data.value == "fps1off" then
			SetTimecycleModifier('yell_tunnel_nodirect')
			modofps1 = true
		elseif data.value == "fps1on"  then
			SetTimecycleModifier()
			ClearTimecycleModifier()
			ClearExtraTimecycleModifier() 
			modofps1 = false
		elseif data.value == "fps2off"  then
			SetTimecycleModifier('tunnel') 
			modofps2 = true
		elseif data.value == "fps2on"  then
			SetTimecycleModifier()
			ClearTimecycleModifier()
			ClearExtraTimecycleModifier()
			modofps2 = false
		elseif data.value == "fps3off"  then
			SetTimecycleModifier('MP_Powerplay_blend')
			SetExtraTimecycleModifier('reflection_correct_ambient')
			modofps3 = true
		elseif data.value == "fps3on"  then
			SetTimecycleModifier()
			ClearTimecycleModifier()
			ClearExtraTimecycleModifier()
			modofps3 = false
		end
	end, function()
	end)
end