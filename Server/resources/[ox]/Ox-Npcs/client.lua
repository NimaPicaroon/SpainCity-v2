local pedList = {}
local cam = nil
local name = ''
local waitMore = true
local inMenu = false
local hasEntered = false
local OwnData

-- CREATE NPCs

CreateThread(function()
	local pedInfo = {}
	local camCoords = nil
	local camRotation = nil

	for k, v in pairs(Config.TalkToNPC) do
		RequestModel(GetHashKey(v.npc))
		while not HasModelLoaded(GetHashKey(v.npc)) do
			Wait(1)
		end

		RequestAnimDict("mini@strip_club@idles@bouncer@base")
		while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
			Wait(1)
		end

		ped =  CreatePed(4, v.npc, v.coordinates[1], v.coordinates[2], v.coordinates[3], v.heading, false, true)
		SetEntityHeading(ped, v.heading)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		DecorSetInt(ped, 'SPAWNEDPED', 1)
		if v.anim then
			TaskPlayAnim(ped,v.anim[1],v.anim[2], 8.0, 0.0, -1, 1, 0, 0, 0, 0)
		else
			if v.scenario then
				TaskStartScenarioInPlace(ped, v.scenario, 0, true)
			else
				if v.anim ~= false then
					TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
				end
			end
		end

		if Config.AutoCamPosition then
			local px, py, pz = table.unpack(GetEntityCoords(ped, true))
			local x, y, z = px + GetEntityForwardX(ped) * 1.2, py + GetEntityForwardY(ped) * 1.2, pz + 0.52

			camCoords = vector3(x, y, z)
		end

		if Config.AutoCamRotation then
			local rx = GetEntityRotation(ped, 2)

			camRotation = rx + vector3(0.0, 0.0, 181)
		end

		pedInfo = {
			name = v.name,
			model = v.npc,
			pedCoords = v.coordinates,
			entity = ped,
			camCoords = camCoords,
			camRotation = camRotation,
		}

		table.insert(pedList, pedInfo)
	end
end)

-- CHECK DISTANCE & JOB

RegisterNetEvent('ZCore:setGang', function(job, lastJob)
	if not OwnData then
		OwnData = W.GetPlayerData()
	end
	OwnData.gang = job
end)

RegisterNetEvent('ZCore:playerLoaded', function()
	OwnData = W.GetPlayerData()
end)

CreateThread(function()
	local inZone = false
	local hasSetName = false
	local nearPed = false
	local checkedJob = false
	local hasJob = false
	local npcModel = nil
	local npcName = nil
	local npcKey = 0
	while true do
		Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		inZone = false
		nearPed = false
		if npcName == nil and npcModel == nil then
			for k,v in pairs(Config.TalkToNPC) do
				local distance = #(vec3(v.coordinates[1], v.coordinates[2], v.coordinates[3]) - vec3(playerCoords.x, playerCoords.y, playerCoords.z))

				if v.jobs[1] ~= nil then
					if distance < v.interactionRange + 2 then
						npcName = v.name
						npcModel = v.npc
						npcKey = k
						nearPed = true

					elseif not waitMore and not nearPed then
						waitMore = true
					elseif checkedJob then
						checkedJob = false
					end
				else
					if v.gangs then
						if OwnData and OwnData.gang and OwnData.gang.name and distance < v.interactionRange + 2 then
							npcName = v.name
							npcModel = v.npc
							npcKey = k
							nearPed = true
							if not inMenu then
								waitMore = false
							end
						elseif not waitMore and not nearPed then
							waitMore = true
						end
					else
						if distance < v.interactionRange + 2 then
							npcName = v.name
							npcModel = v.npc
							npcKey = k
							nearPed = true
							if not inMenu then
								waitMore = false
							end
						elseif not waitMore and not nearPed then
							waitMore = true
						end
					end
				end
			end
		else
			v = Config.TalkToNPC[npcKey]
			if v ~= nil then
				local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.coordinates[1], v.coordinates[2], v.coordinates[3])
				local zDistance = playerCoords.z - v.coordinates[3]

				if zDistance < 0 then
					zDistance = zDistance * -1
				end
				if zDistance < 2 then
					if v.jobs[1] ~= nil then
						if distance < v.interactionRange + 3 then
							if not checkedJob then
								hasJob = false
								checkedJob = true
								for k2,v2 in pairs(v.jobs) do
									if OwnData.job.name == v2 then
										hasJob = true
									end
								end
							end

							if hasJob then
								if not nearPed then
									nearPed = true
								end
								if not inMenu then
									waitMore = false
								end
								if distance < v.interactionRange then
									if not hasSetName then
										name = v.uiText
										hasSetName = true
									end
									if not inZone then
										inZone = true
									end
									if not inMenu then
										W.ShowText(vector3(v.coordinates[1], v.coordinates[2], v.coordinates[3] + 2), '~y~'..name..'\n~w~Interacciona con la persona', 0.5, 8)
									end
									if IsControlJustReleased(0, Config.Key) then
										inMenu = true
										waitMore = true
										StartCam(v.coordinates, v.camOffset, v.camRotation, v.npc, v.name)
										Wait(500)
										SetNuiFocus(true, true)
										SendNUIMessage({
											action = 'openDialog',
											name = v.name,
											dialog = v.dialog,
											options = v.options,
										})
									end
								elseif hasSetName then
									hasSetName = false
								end
							end
						elseif not waitMore and not nearPed then
							waitMore = true
						elseif checkedJob then
							checkedJob = false
						end
						if distance > v.interactionRange + 2 and npcName ~= nil and npcModel ~= nil then
							npcModel = nil
							npcName = nil
							npcKey = 0
						end
					elseif v.gangs then
						if OwnData and OwnData.gang and OwnData.gang.name and distance < v.interactionRange + 3 then
							if not nearPed then
								nearPed = true
							end
							if not inMenu then
								waitMore = false
							end
							if distance < v.interactionRange then
								if not hasSetName then
									name = v.uiText
									hasSetName = true
								end
								if not inZone then
									inZone = true
								end
								if not inMenu then
									W.ShowText(vector3(v.coordinates[1], v.coordinates[2], v.coordinates[3]+ 2), '~y~'..name..'\n~w~Interacciona con la persona', 0.5, 8)
								end

								if IsControlJustReleased(0, Config.Key) then
									inMenu = true
									waitMore = true
									StartCam(v.coordinates, v.camOffset, v.camRotation, v.npc, v.name)
									Wait(500)
									SetNuiFocus(true, true)
									SendNUIMessage({
										action = 'openDialog',
										header = v.header,
										name = v.name,
										dialog = v.dialog,
										options = v.options,
									})
								end
							elseif hasSetName then
								hasSetName = false
							end
						elseif not waitMore and not nearPed then
							waitMore = true
						end
						if distance > v.interactionRange + 2 and npcName ~= nil and npcModel ~= nil then
							npcModel = nil
							npcName = nil
							npcKey = 0
						end
					else
						if distance < v.interactionRange + 3 then
							if not nearPed then
								nearPed = true
							end
							if not inMenu then
								waitMore = false
							end
							if distance < v.interactionRange then
								if not hasSetName then
									name = v.uiText
									hasSetName = true
								end
								if not inZone then
									inZone = true
								end
								if not inMenu then
									W.ShowText(vector3(v.coordinates[1], v.coordinates[2], v.coordinates[3]+ 2), '~y~'..name..'\n~w~Interacciona con la persona', 0.5, 8)
								end

								if IsControlJustReleased(0, Config.Key) then
									inMenu = true
									waitMore = true
									StartCam(v.coordinates, v.camOffset, v.camRotation, v.npc, v.name)
									Wait(500)
									if Config.HideMinimap then
										DisplayRadar(false)
									end
									SetNuiFocus(true, true)
									SendNUIMessage({
										action = 'openDialog',
										header = v.header,
										name = v.name,
										dialog = v.dialog,
										options = v.options,
									})
								end
							elseif hasSetName then
								hasSetName = false
							end
						elseif not waitMore and not nearPed then
							waitMore = true
						end
						if distance > v.interactionRange + 2 and npcName ~= nil and npcModel ~= nil then
							npcModel = nil
							npcName = nil
							npcKey = 0
						end
					end
				end
			end
		end



		if inZone and not hasEntered then
			hasEntered = true
		elseif not inZone and hasEntered then
			hasEntered = false
		end

		if waitMore then
			Wait(1000)
		end
	end
end)

-- ACTIONS

RegisterNUICallback('action', function(data, cb)
	if data.action == 'close' then
		SetNuiFocus(false, false)
		W.Notify('PERSONA', 'Ten un buen dia', 'info')
		hasEntered = true
		inMenu = false
		waitMore = false
		EndCam()
	elseif data.action == 'option' then
		SetNuiFocus(false, false)
		hasEntered = true
		inMenu = false
		waitMore = false
		EndCam()

		if data.options[3] == 'c' then
			TriggerEvent(data.options[2], data.options[4])
		elseif data.options[3] ~= nil then
			TriggerServerEvent(data.options[2], data.options[4])
		end
	end
end)

-- CAMERA

function StartCam(coords, offset, rotation, model, name)
	ClearFocus()

	if Config.AutoCamRotation then
		for k,v in pairs(pedList) do
			if v.pedCoords == coords then
				if v.name == name and v.model == model then
					rotation = v.camRotation
				end
			end
		end
	end

	if Config.AutoCamPosition then
		for k,v in pairs(pedList) do
			if v.pedCoords == coords then
				if v.name == name and v.model == model then
					coords = v.camCoords
				end
			end
		end
	else
		coords = coords + offset
	end

	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, rotation, GetGameplayCamFov())

	SetCamActive(cam, true)
	RenderScriptCams(true, true, Config.CameraAnimationTime, true, false)
end

function EndCam()
	ClearFocus()

	RenderScriptCams(false, true, Config.CameraAnimationTime, true, false)
	DestroyCam(cam, false)

	cam = nil
end

-- EXAMPLE EVENTS CALLED ON CONFIG.LUA

RegisterNetEvent("okokTalk:toilet")
AddEventHandler("okokTalk:toilet", function()
	W.Notify("BANCO", "No tenemos baño", 'info')
end)

RegisterNetEvent("Ox-Npcs:notify", function(msg)
	W.Notify("NOTIFICACIÓN", msg)
end)

RegisterNetEvent("okokTalk:rob")
AddEventHandler("okokTalk:rob", function()
	W.Notify("BANCO", "No bromees con esas cosas", 'warn')
end)

RegisterNetEvent("Ox-Npcs:Waypoint", function(type)
	if type == 'electricista' then
		SetNewWaypoint(-329.66, -1071.42)
		W.Notify("INEM", "Has escogido "..type..". Ve a la ubicación de tu GPS.", 'verify')
	elseif type == 'carguero' then
		SetNewWaypoint(1195.08, -3255.06)
		W.Notify("INEM", "Has escogido "..type..". Ve a la ubicación de tu GPS.", 'verify')
	elseif type == 'cultivo' then
		SetNewWaypoint(420.98, 6470.08)
		W.Notify("INEM", "Has escogido "..type..". Ve a la ubicación de tu GPS.", 'verify')
	elseif type == 'ganadero' then 
		SetNewWaypoint(1899.52, 4921.52)
		W.Notify("INEM", "Has escogido "..type..". Ve a la ubicación de tu GPS.", 'verify')
	elseif type == 'camnorte' then
		SetNewWaypoint(85.39, 6341.08) 
		W.Notify("INEM", "Has escogido Camionero del Norte. Ve a la ubicación de tu GPS.", 'verify')
	elseif type == 'camsur' then
		SetNewWaypoint(-62.26, -2520.84) 
		W.Notify("INEM", "Has escogido Camionero del Sur. Ve a la ubicación de tu GPS.", 'verify')
	end
end)