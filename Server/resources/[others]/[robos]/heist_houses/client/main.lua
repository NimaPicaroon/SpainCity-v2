local robando = false
local entradaCoords = nil
local cerradura = true
local coordsx, coordsy, coordsz, t
local coord = false
local alarma = false
local timer = false
local modelo
local casacoords
local items = {}
local trabajando = false
local interior = {}
local ruido = 0
local dentro = false
local cargando = false
local PlayerJob
W = nil


---


Citizen.CreateThread(function()
	W = exports.ZCore:get() Wait(0)

	if W then
		W.TriggerCallback('heist_houses:entrada', function(x,y,z,a)
			coordsx, coordsy, coordsz, t = x,y,z,a
			coord = true

			local blip = AddBlipForCoord(coordsx, coordsy, coordsz)
			SetBlipSprite (blip, 162)
			SetBlipScale  (blip, 0.7)
			SetBlipDisplay(blip, 4)
			SetBlipColour (blip, 0)
			SetBlipAsShortRange(blip, true)
		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Desconocido')
			EndTextCommandSetBlipName(blip)
		end)

		while W.GetPlayerData().job == nil do
			Citizen.Wait(10)
		end

		PlayerJob = W.GetPlayerData().job.name
	
		-- print(coordsx, coordsy, coordsz)
		-- local blip = AddBlipForCoord(coordsx, coordsy, coordsz)
		-- SetBlipSprite (blip, 162)
		-- SetBlipScale  (blip, 0.7)
		-- SetBlipDisplay(blip, 4)
		-- SetBlipColour (blip, 31)
		-- SetBlipAsShortRange(blip, true)
	
		-- BeginTextCommandSetBlipName("STRING")
		-- AddTextComponentString('Desconocido')
		-- EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while not robando do
		Citizen.Wait(1000)
	end
	local inZone = false
	local shown = false
	local inZone2 = false
	local shown2 = false

	while true do
		local w = 500
		inZone = false
		inZone2 = false

		if robando then
			w = 3
			
			for i = 1, #items do
				local objCoords = GetEntityCoords(items[i].objeto)
				if #(GetEntityCoords(PlayerPedId()) - objCoords) <= 150.0 and not items[i].robado then
					W.ShowText(objCoords, 'Objeto', 0.6, 8)

					if #(GetEntityCoords(PlayerPedId()) - objCoords) <= items[i].dist and not items[i].robado then
						inZone = true
						if IsControlJustPressed(0,246) and not cargando then
							items[i].robado = true
							if items[i].anim == 'cajafuerte' then
								TriggerEvent('safecracker:start',false,2,function(res)
									if res then
										TriggerServerEvent('heist_houses:item','cajafuerte',t)
									else
										items[i].robado = false
									end
								end)
							else
								TriggerEvent('heist_houses:anim',items[i].anim,items[i].borrar,i)
							end
						end
					end
				end
			end

			if #(GetEntityCoords(PlayerPedId()) - vector3(casacoords.x, casacoords.y, casacoords.z)) < 1.5 then
				inZone2 = true
				if IsControlJustPressed(0, 38) then
					if W.GetPlayerData().job.name ~= Config.PoliceJobName then	
						if esNoche() then
							salir()
						else
							salir(true)
						end
					else
						salir(true)
					end
				end
			end
		end

		if inZone and not shown then
			shown = true

			exports['ZC-HelpNotify']:open('Usa <strong>Y</strong> para robar', 'other_interact_heist_house')
		elseif not inZone and shown then
			shown = false

			exports['ZC-HelpNotify']:close('other_interact_heist_house')
		end

		if inZone2 and not shown2 then
			shown2 = true

			exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para salir', 'other_interact_heist_house_exit')
		elseif not inZone2 and shown2 then
			shown2 = false

			exports['ZC-HelpNotify']:close('other_interact_heist_house_exit')
		end

		Citizen.Wait(w)
	end
end)

Citizen.CreateThread(function()
	local w
	while not coord do
		Citizen.Wait(0)
	end
	local inZone = false
	local shown = false

	while true do
		w = 1000
		local playercoords = GetEntityCoords(PlayerPedId())
		local dist = #(vector3(playercoords.x, playercoords.y, playercoords.z) - vector3(coordsx, coordsy, coordsz))
		inZone = false

		if dist < 2 then
			w = 5

			inZone = true
			if IsControlJustPressed(0, 38) then
				LoadAnim("timetable@jimmy@doorknock@")
				FreezeEntityPosition(PlayerPedId(),true)
				TaskPlayAnim(PlayerPedId(), "timetable@jimmy@doorknock@", 'knockdoor_idle', 2.0, 2.0, 3000, 1, 0, true, true, true)						
				FreezeEntityPosition(PlayerPedId(),false)
				TriggerEvent('heist_houses:iniciar')				
			end
		end

		if inZone and not shown then
			shown = true

			exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'call_door_heist')
		elseif not inZone and shown then
			shown = false

			exports['ZC-HelpNotify']:close('call_door_heist')
		end

		Citizen.Wait(w)
	end
end)

RegisterNetEvent('heist_houses:iniciar')
AddEventHandler('heist_houses:iniciar', function()
	W.TriggerCallback('heist_houses:trabajos', function(puedeRobar)	
		if puedeRobar then
			W.TriggerCallback('Wave:GetPlayersJob', function(players)
				if players and #players >= 2 then
					if not trabajando then
						limpiar()
						trabajando = true
						entradaCoords = Casas()
						TriggerEvent('heist_houses:notification',Config.Lang['jobwait'])
						Citizen.Wait(Config.CoordsWait * 60 * 1000)
						PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", true)
						SetNewWaypoint(entradaCoords.x,entradaCoords.y)
						TriggerEvent('heist_houses:notification',Config.Lang['assigned'])
						Entrada()
					else
						TriggerEvent('heist_houses:notification',Config.Lang['wait'])
					end
				end
			end, 'police', true)
		else
			TriggerEvent('heist_houses:notification',Config.Lang['cooldown'])
		end
	end)
end)

RegisterNetEvent('heist_houses:ruido')
AddEventHandler('heist_houses:ruido', function()
	local ped = PlayerPedId()
	local alertado = false
	while robando do		
		if dentro then	
			barra(ruido)
			if IsPedShooting(ped) then
				ruido = ruido + 20
			end
			if GetEntitySpeed(ped) > 1.7 then
				ruido = ruido + 10				
				if GetEntitySpeed(ped) > 2.5 then
					ruido = ruido + 15
				end
				if GetEntitySpeed(ped) > 3.0 then
					ruido = ruido + 20
				end
				Citizen.Wait(300)
			else
				ruido = ruido - 2
				if ruido < 0 then
					ruido = 0
				end
				Citizen.Wait(1000)
			end
			barra(ruido)
			if ruido > 100 then
				if not alertado then
					alertado = true
					SendNUIMessage({type = 'alarm'})
					TriggerEvent('heist_houses:notification',Config.Lang['alarm'])
					TriggerServerEvent('ZC-Dispatch:sendAlert', 'police', '¡Están robando en mi casa! Necesito ayuda porfavor', GetEntityCoords(PlayerPedId()), GetPlayerServerId(PlayerId()), 'heist', 'houses')
				end
			end
		end
		if #(GetEntityCoords(PlayerPedId()) - vector3(casacoords.x, casacoords.y, casacoords.z)) >= 150 then
			limpiar()
		end
		Citizen.Wait(5)		
	end
end)

if Config.PoliceRaidWithCommand then
	RegisterCommand('raidhouse', function()
		if W.GetPlayerData().job.name == Config.PoliceJobName then
			TriggerEvent('heist_houses:policeRaid')
		end
	end)
end

RegisterNetEvent('heist_houses:policeRaid')
AddEventHandler('heist_houses:policeRaid', function()
	if PlayerJob == Config.PoliceJobName then
		for i = 1, #Config.Casas do
			local casa = Config.Casas[i]
			if #(GetEntityCoords(PlayerPedId()) - vector3(casa.x, casa.y, casa.z)) < 5 then
				entradaCoords = casa
				entrar(true)
			end
		end
	end
end)

RegisterNetEvent('heist_houses:policiablip')
AddEventHandler('heist_houses:policiablip', function(coords)
	if PlayerJob == Config.PoliceJobName then
		TriggerEvent('heist_houses:notification',Config.Lang['police_alert'])
		local alertablip = AddBlipForCoord(coords.x,coords.y,coords.z)
		SetBlipSprite(alertablip, 161)
		SetBlipScale(alertablip, 2.0)
		SetBlipColour(alertablip, 3)
		PulseBlip(alertablip)
		Wait(60000)
		RemoveBlip(alertablip)
	end
end)

function Casas()
	local ubicacion = math.random(1, #Config.Casas)		
	local c = Config.Casas[ubicacion]
	return c
end

function Entrada()
	local inZone = false
	local shown = false

	while trabajando do
		local espera = 1500
		inZone = false

		distancia = #(GetEntityCoords(PlayerPedId()) - vector3(entradaCoords.x, entradaCoords.y, entradaCoords.z))
		if distancia < 3 and esNoche() then
			espera = 5
			inZone = true

			if IsControlJustReleased(0, 246) and distancia < 3 then
				if cerradura then
					W.TriggerCallback('heist_houses:lockpick',function(tieneLockpick)
						if tieneLockpick then
							ganzuar()
						else
							TriggerEvent('heist_houses:notification',Config.Lang['lockpick'])
						end
					end)
				else
					entrar()
				end
			end	
		end

		if inZone and not shown then
			shown = true

			exports['ZC-HelpNotify']:open('Usa <strong>Y</strong> para robar', 'open_heist_house')
		elseif not inZone and shown then
			shown = false

			exports['ZC-HelpNotify']:close('open_heist_house')
		end

		Citizen.Wait(espera)
	end		
end

function entrar(policia)
	if not robando then
		if entradaCoords.modelo == 'HighEnd' then
			casacoords, heading, items, interior = HighEnd(entradaCoords)
		elseif entradaCoords.modelo == 'MidApt' then
			casacoords, heading, items, interior = MidApt(entradaCoords)
		end
		ClearAreaOfPeds(casacoords.x,casacoords.y,casacoords.z, 100.0, 1)
		robando = true
		if not policia then
			TriggerEvent('heist_houses:ruido')
		end
	else
		DoScreenFadeOut(1000)
		Citizen.Wait(1500)
		SetEntityCoords(PlayerPedId(),casacoords.x,casacoords.y,casacoords.z)
		SetEntityHeading(PlayerPedId(),heading)
		Citizen.Wait(2500)
		DoScreenFadeIn(1500)
	end
	dentro = true
end

RegisterNetEvent('heist_houses:anim')
AddEventHandler('heist_houses:anim', function(anim, borrar, i)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	LoadAnim('mp_common_heist')
	LoadAnim("anim@heists@box_carry@")
	if anim == 'tv' then
		FreezeEntityPosition(ped,true)
		TaskPlayAnim(ped, "mp_common_heist", 'use_terminal_loop', 2.0, 2.0, -1, 1, 0, true, true, true)
		Citizen.Wait(10000)
		ClearPedTasksImmediately(ped)
		FreezeEntityPosition(ped,false)
		television = CreateObject(GetHashKey("prop_tv_flat_01"), coords.x, coords.y, coords.z,  true,  true, false)
		AttachEntityToEntity(television, ped, GetPedBoneIndex(ped, 57005), 0.0, 0.0, 0.0, 0.0, 20.0, 0.0, true, true, false, true, 1, true)
		RequestWalking('anim_group_move_ballistic')
		SetPedMovementClipset(ped, 'anim_group_move_ballistic', 0.2)
		DeleteEntity(items[i].objeto)
		cargando = true
		while true do
			local w = 50
			if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "walk", 3) then
				TaskPlayAnim(ped, 'anim@heists@box_carry@', "walk", 8.0, -8, -1, 49, 0, 0, 0, 0)
			end			
			local ubicacion = GetEntityCoords(PlayerPedId())
			local vehicle = getVehicleInfront(2)
			local d1 = GetModelDimensions(GetEntityModel(vehicle))
			local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
			local Distance = GetDistanceBetweenCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, ubicacion.x, ubicacion.y, ubicacion.z, false)
			
			if Distance < 3 then
				w = 3
				DrawText3D(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, Config.Lang['putinveh'])
			end
			if IsControlJustReleased(0, 38) then                           
				if esVanWL() then	
					Citizen.Wait(400)
					DetachEntity(television, 1, 0)
					DeleteEntity(television)
					television = nil
					ClearPedTasksImmediately(ped)
					RemoveAnimSet('anim_group_move_ballistic')
					ResetPedMovementClipset(ped)
					TriggerServerEvent('heist_houses:item','tv',t)
					cargando = false
					break
				end
			end
			Citizen.Wait(w)
		end
	elseif anim == 'telescopio' then
		LoadAnim("anim@heists@narcotics@trash")
		FreezeEntityPosition(ped,true)
		TaskPlayAnim(ped, "mp_common_heist", 'use_terminal_loop', 2.0, 2.0, -1, 1, 0, true, true, true)
		Citizen.Wait(2000)
		ClearPedTasksImmediately(ped)
		FreezeEntityPosition(ped,false)
		telescopioObj = CreateObject(GetHashKey("prop_t_telescope_01b"), coords.x, coords.y, coords.z,  true,  true, false)
		AttachEntityToEntity(telescopioObj, ped, GetPedBoneIndex(ped, 57005), -0.06, 0.0, -0.31, 0.0, 20.0, 0.0, true, true, false, true, 1, true)
		DeleteEntity(items[i].objeto)
		cargando = true
		while true do
			local w = 50
			if not IsEntityPlayingAnim(ped, "anim@heists@narcotics@trash", "walk", 3) then
				TaskPlayAnim(ped, "anim@heists@narcotics@trash", "walk", 8.0, 8.0, -1, 50, 0, false, false, false)
			end
			local ubicacion = GetEntityCoords(PlayerPedId())
			local vehicle = getVehicleInfront(2)
			local d1 = GetModelDimensions(GetEntityModel(vehicle))
			local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
			local Distance = GetDistanceBetweenCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, ubicacion.x, ubicacion.y, ubicacion.z, false)
			
			if Distance < 3 then
				w = 3
				DrawText3D(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, Config.Lang['putinveh'])
			end
			
			if IsControlJustReleased(0, 38) then                           
				if esVanWL() then	
					Citizen.Wait(400)
					DetachEntity(telescopioObj, 1, 0)
					DeleteEntity(telescopioObj)
					telescopioObj = nil
					ClearPedTasksImmediately(ped)		
					TriggerServerEvent('heist_houses:item','telescopio',t)
					cargando = false
					break
				end
			end
			Citizen.Wait(w)
		end
	elseif anim == 'pintura' then
		FreezeEntityPosition(ped,true)
		TaskPlayAnim(ped, "mp_common_heist", 'use_terminal_loop', 2.0, 2.0, -1, 1, 0, true, true, true)
		Citizen.Wait(2000)
		ClearPedTasksImmediately(ped)
		Citizen.Wait(250)	
		AnimBolso()
		DeleteEntity(items[i].objeto)
		TriggerServerEvent('heist_houses:item','arte',t)
		return true
	elseif anim == 'normal' then
		FreezeEntityPosition(ped,true)	
		AnimBolso()
		TriggerServerEvent('heist_houses:item','random',t)
		if borrar then
			DeleteEntity(items[i].objeto)
		end
	elseif anim == 'mesa' then
		FreezeEntityPosition(ped,true)
		Citizen.Wait(1000)
		ClearPedTasksImmediately(ped)
		FreezeEntityPosition(ped,false)
		local suerte = math.random(1,10)
		TriggerServerEvent('heist_houses:item','random',t)
		if borrar then
			DeleteEntity(items[i].objeto)
		end
	elseif anim == 'laptop' then
		FreezeEntityPosition(ped,true)
		AnimBolso()
		DeleteEntity(items[i].objeto)
		TriggerServerEvent('heist_houses:item','laptop',t)
	else
		LoadAnim("anim@heists@box_carry@")
		FreezeEntityPosition(ped,true)
		TaskPlayAnim(ped, "mp_common_heist", 'use_terminal_loop', 2.0, 2.0, -1, 1, 0, true, true, true)
		Citizen.Wait(5000)
		ClearPedTasksImmediately(ped)
		FreezeEntityPosition(ped,false)
		local objeto = CreateObject(GetHashKey(anim), coords.x, coords.y, coords.z,  true,  true, false)
		AttachEntityToEntity(objeto, ped, GetPedBoneIndex(ped, 28422), 0.0, -0.1, -0.08, 0.0, 90.0, 0.0, true, true, false, true, 1, true)
		DeleteEntity(items[i].objeto)
		cargando = true
		while true do
			local w = 50
			if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 3) then
				TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
			end
			local ubicacion = GetEntityCoords(PlayerPedId())
			local vehicle = getVehicleInfront(2)
			local d1 = GetModelDimensions(GetEntityModel(vehicle))
			local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
			local Distance = GetDistanceBetweenCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, ubicacion.x, ubicacion.y, ubicacion.z, false)
			
			if Distance < 3 then
				w = 3
				DrawText3D(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, Config.Lang['putinveh'])
			end
			
			if IsControlJustReleased(0, 38) then                           
				if esVanWL() then	
					Citizen.Wait(400)
					DetachEntity(objeto, 1, 0)
					DeleteEntity(objeto)
					objeto = nil
					ClearPedTasksImmediately(ped)		
					TriggerServerEvent('heist_houses:item',anim,t)
					cargando = false
					break
				end
			end
			Citizen.Wait(w)
		end
	end
end)

function salir(despawn)
	dentro = false
	DoScreenFadeOut(1000)
	Citizen.Wait(1500)
	SetEntityCoords(PlayerPedId(),entradaCoords.x, entradaCoords.y, entradaCoords.z)
	if Config.UsingEasyTime then
		TriggerEvent('cd_easytime:PauseSync', false)
	else
		h,m,s = NetworkGetGlobalMultiplayerClock()
		NetworkOverrideClockTime(h,m,s)
	end
	Citizen.Wait(800)
	SendNUIMessage({type = 'offalarm'})
	DoScreenFadeIn(2600)
	if despawn then
		limpiar()
	end
	--SendNUIMessage({closeProgress = true})
	SendNUIMessage({type = 'hide' , ruido = 0})
end

function esVanWL()
	local vehicle = getVehicleInfront(2)
	local modelo = GetEntityModel(vehicle)
	if vehicle then
		if not IsThisModelABike(modelo) then
			SetVehicleDoorOpen(vehicle,2,false,false)
			SetVehicleDoorOpen(vehicle,3,false,false)
			SetVehicleDoorOpen(vehicle,5,false,false)
			SetVehicleDoorOpen(vehicle,6,false,false)
			SetVehicleDoorOpen(vehicle,7,false,false)
			return true
		end
	else
		TriggerEvent('heist_houses:notification',Config.Lang['wrong_veh'])
	end
	return false
end

function AnimBolso()
	local playerPed = PlayerPedId()
	LoadAnim('anim@heists@ornate_bank@ig_4_grab_gold')
	local fwd, _, _, pos = GetEntityMatrix(playerPed)
	local newPos = (fwd * 0.8) + pos
	SetEntityCoords(playerPed, newPos.xy, newPos.z - 1.5)
	local rot, pos = GetEntityRotation(playerPed), GetEntityCoords(playerPed)
	SetPedComponentVariation(playerPed, 5, -1, 0, 0)
	local bag = false
	local entrada = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 2, false, false, 1065353216, 0, 1.3)
	local salida = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 2, false, false, 1065353216, 0, 1.3)
	SetEntityCollision(bag, 0, 1)
	NetworkAddPedToSynchronisedScene(playerPed, entrada, "anim@heists@ornate_bank@ig_4_grab_gold", "enter", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, entrada, "anim@heists@ornate_bank@ig_4_grab_gold", "enter_bag", 4.0, -8.0, 1)
	NetworkAddPedToSynchronisedScene(playerPed, salida, "anim@heists@ornate_bank@ig_4_grab_gold", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, salida, "anim@heists@ornate_bank@ig_4_grab_gold", "exit_bag", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(entrada)
	Citizen.Wait(1500)
	NetworkStartSynchronisedScene(salida)
	Citizen.Wait(1500)
	-- DeleteEntity(bag)
	SetPedComponentVariation(playerPed, 5, 45, 0, 0)
	NetworkStopSynchronisedScene(entrada)
	NetworkStopSynchronisedScene(salida)
	FreezeEntityPosition(playerPed, false)
end

function DrawText3D(x,y,z, text)
	local size = 0.5
	local coords = vector3(x,y,z)
    local camCoords = GetGameplayCamCoords()
    local distance = #(coords - camCoords)

    if not size then size = 1 end
    if not font then font = 0 end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)

    SetDrawOrigin(coords, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function RequestWalking(set)
	RequestAnimSet(set)
	while not HasAnimSetLoaded(set) do
		Citizen.Wait(1)
	end 
end

function ganzuar()
	LoadAnim('veh@break_in@0h@p_m_one@')
	TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 1, 0.0, 0, 0, 0)
	Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
	cerradura = false
	if Config.RandomPoliceCall then	
		local s = math.random(1,5)
		if s == 2 then
			TriggerServerEvent('ZC-Dispatch:sendAlert', 'police', '¡Están forzando la cerradura de mi casa! Necesito ayuda porfavor', entradaCoords, GetPlayerServerId(PlayerId()), 'heist', 'houses')
		end
	end
	entrar()
end

function getVehicleInfront(max)
	local p = PlayerPedId()
	local p_pos = GetEntityCoords(p)
	local p_fwd = GetEntityForwardVector(p)
	local up = vector3(0.0,0.0,1.0)
	local from = p_pos + (up*2)
	local to   = p_pos - (up*2)
	local ent_hit
	for i=0,(max or 3),1 do
		local ray = StartShapeTestRay(from.x + (p_fwd.x*i),from.y + (p_fwd.y*i),from.z + (p_fwd.z*i),to.x + (p_fwd.x*i),to.y + (p_fwd.y*i),to.z + (p_fwd.z*i),2,ignore, 0);
		_,_,_,_,ent_hit = GetShapeTestResult(ray); 
		if ent_hit and ent_hit ~= 0 and ent_hit ~= -1 then
			local type = GetEntityType(ent_hit)
			if GetEntityType(ent_hit) == 2 then
				return ent_hit
			end
		end
	end
  return false
end

function limpiar()
	cerradura = true
	robando = false
	trabajando = false
	dentro = false
	ruido = 0
	if #items > 0 then
		for i = 1, #items do
			DeleteEntity(items[i].objeto)
		end
	end
	if #interior > 0 then
		for i = 1, #interior do
			DeleteEntity(interior[i])
		end
	end
	--SendNUIMessage({closeProgress = true})
	SendNUIMessage({type = 'hide' , ruido = 0})
end

function esNoche()
	local hora = GetClockHours()
	if hora > Config.Night[1] or hora < Config.Night[2] then
		return true
	end
	return false
end

function barra(porcentaje)
	--SendNUIMessage({runProgress = true, Length = porcentaje})
	if porcentaje < 100 then
		SendNUIMessage({type = 'show' , ruido = porcentaje / 1.2})
	else
		SendNUIMessage({type = 'show' , ruido = 100 / 1.2})
	end
end

RegisterNetEvent('jobs:changeJob', function(job)
	print(json.encode(job))
	PlayerJob = job.name
end)