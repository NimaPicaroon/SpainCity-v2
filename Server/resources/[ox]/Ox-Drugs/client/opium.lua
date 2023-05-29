local picking = false
local talking = false

CreateThread(function()
	local add = false
	local CurrentPlant
	while true do
		local wait = 1000
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped, false)
		local distance = GetDistanceBetweenCoords(coords, vector3(307.8, 4332.8, 47.89), true)

		if not OwnData.gang then
			OwnData.gang = W.GetPlayerData().gang
		end

		if distance < 100 and visited['opium'] and OwnData.gang.name then
            wait = 250
            if #plants < 15 then
                RequestModel('prop_cs_plant_01')
                while not HasModelLoaded(GetHashKey('prop_cs_plant_01')) do
                    Wait(0)
                end
                local modelSpawn = CreateObject(GetHashKey('prop_cs_plant_01'), GeneratePlantCoords(), false, true, true)
                FreezeEntityPosition(modelSpawn, true)
                PlaceObjectOnGroundProperly(modelSpawn)
                table.insert(plants, modelSpawn)
            elseif #plants == 15 then
                for k, v in pairs(plants) do
                    local distancetoPlant = #(GetEntityCoords(v) - coords)
                    if distancetoPlant <= 2.5 and not picking and not IsPedInAnyVehicle(ped, true) then
                        wait = 0
						if not add then
							exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'interact_opium')
							add = true
						end
						CurrentPlant = k

                        if IsControlJustReleased(0, 38) then
                            if W.HaveItem('cizallas') > 0 then
                                picking = true
								W.Progressbar("picking_opium", 'Recogiendo...', 10000, false, true, {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								}, {
									animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
									anim = 'machinic_loop_mechandplayer'
								}, {}, {}, function() -- Done
									picking = false
									ClearPedTasks(ped)
									TriggerServerEvent('Ox-Drugs:giveItem', 'resina_adormidera', 1)
									DeleteEntity(v)
									table.remove(plants, k)
								end, function()
									W.Notify('Recogida', 'Has cancelado la acción', 'error')
									picking = false
								end)
                            else
                                W.Notify('ERROR', 'Necesitas algo para cortar la planta', 'error')
                            end
                        end
					else
						if CurrentPlant == k then
							CurrentPlant = nil
						end
                    end
                end

				if add and not CurrentPlant then
					add = false
					exports['ZC-HelpNotify']:close('interact_opium')
				end
            end
		else
			if #plants > 0 then
                for k, v in ipairs(plants) do
                    DeleteEntity(v)
                    table.remove(plants, k)
                    Wait(100)
                end
			end
		end
		Wait(wait)
	end
end)

CreateThread(function()
	local add = false
	while true do
		local wait = 750
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped, false)
		local distance = GetDistanceBetweenCoords(coords, vector3(356.12, 3399.68, 35.45), true)

		if not OwnData.gang then
			OwnData.gang = W.GetPlayerData().gang
		end

		if distance < 100 and OwnData.gang.name then
			if creatednpcs['sec'] == nil then
				local modelHash = GetHashKey('ig_chef')
				RequestModel(modelHash)
				while not HasModelLoaded(modelHash) do
					Wait(1)
				end
				local SpawnedPed = CreatePed(2, modelHash, vector3(356.12, 3399.68, 35.45), 260.4, false, true)
				DecorSetInt(SpawnedPed, 'SPAWNEDPED', 1)
				creatednpcs['sec'] = SpawnedPed
				TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
				Wait(1)
				TaskStartScenarioInPlace(SpawnedPed, 'WORLD_HUMAN_SMOKING', 0, false)
				SetEntityInvincible(SpawnedPed, true)
				PlaceObjectOnGroundProperly(SpawnedPed)
				SetModelAsNoLongerNeeded(modelHash)
				SetBlockingOfNonTemporaryEvents(SpawnedPed, true)
				TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
				SetPedDiesWhenInjured(SpawnedPed, false)
				SetPedCanPlayAmbientAnims(SpawnedPed, true)
				SetPedCanRagdollFromPlayerImpact(SpawnedPed, false)
				FreezeEntityPosition(SpawnedPed, true)
			end

			if distance <= 2.0 and not talking then
				wait = 0
				if not add then
					exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'interact_opium2')
					add = true
				end

				if IsControlJustReleased(0, 38) then
					talking = true
					W.TriggerCallback('Ox-Drugs:getOrder', function(time)
						if time == nil then
							local count, item = W.HaveItem('resina_adormidera')
							if count == 0 then
								W.Notify('DESCONOCIDO', 'No tengo nada que hablar contigo')
								talking = false
							else
								W.Notify('DESCONOCIDO', 'Acompañame...')
								FreezeEntityPosition(creatednpcs['sec'], false)
								TaskGoToCoordAnyMeans(creatednpcs['sec'], 360.32, 3404.2, 35.45, 1.0, 0, 0, 786603, 2)
								local npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['sec']) , vector3(360.32, 3404.2, 35.45), false)
								while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['sec']) , vector3(360.32, 3404.2, 35.45), false) end
								SetEntityHeading(creatednpcs['sec'], 113.0)
								Wait(500)

								W.OpenDialog("Inserta la cantidad de resina que quieras procesar", "give_resina", function(amount)
									W.CloseDialog()
									amount = tonumber(amount)
									if amount <= count then
										if W.GetPlayerData().money.money > (amount * 200) then
											W.Notify('DESCONOCIDO', 'Has pagado ~y~$'..(amount * 200))
											TriggerServerEvent('Ox-Drugs:proccessResina', amount, item)
											TaskStartScenarioInPlace(creatednpcs['sec'], 'PROP_HUMAN_BUM_BIN', 0, false)
											Wait(3000)
											ClearPedTasks(creatednpcs['sec'])
											W.Notify('DESCONOCIDO', 'Vuelve en ~y~1h~w~ y la resina estará procesada')
											Wait(500)
											TaskGoToCoordAnyMeans(creatednpcs['sec'], vector3(356.12, 3399.68, 35.45), 1.0, 0, 0, 786603, 2)
											npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['sec']) , vector3(356.12, 3399.68, 35.45), false)
											while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['sec']) , vector3(356.12, 3399.68, 35.45), false) end
											SetEntityHeading(creatednpcs['sec'], 110.0)
											talking = false
										else
											W.Notify('DESCONOCIDO', 'Necesitas pagarme ~y~$'..(amount * 200), 'error')
											Wait(500)
											TaskGoToCoordAnyMeans(creatednpcs['sec'], vector3(356.12, 3399.68, 35.45), 1.0, 0, 0, 786603, 2)
											npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['sec']) , vector3(356.12, 3399.68, 35.45), false)
											while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['sec']) , vector3(356.12, 3399.68, 35.45), false) end
											SetEntityHeading(creatednpcs['sec'], 110.0)
											talking = false
										end
									else
										W.Notify('DESCONOCIDO', '~r~No~w~ tienes tanta resina', 'error')
										Wait(500)
										TaskGoToCoordAnyMeans(creatednpcs['sec'], vector3(356.12, 3399.68, 35.45), 1.0, 0, 0, 786603, 2)
										npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['sec']) , vector3(356.12, 3399.68, 35.45), false)
										while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['sec']) , vector3(356.12, 3399.68, 35.45), false) end
										SetEntityHeading(creatednpcs['sec'], 110.0)
										talking = false
									end
								end)
							end
						elseif time == true then
							TriggerServerEvent('Ox-Drugs:giveProccessedResina')
							talking = false
						else
							W.Notify('DESCONOCIDO', 'Ahora mismo estoy ~y~ocupado')
							talking = false
						end
					end, 'opium')
				end
			else
				add = false
				exports['ZC-HelpNotify']:close('interact_opium2')
			end
		else
			if creatednpcs['sec'] ~= nil then
				DeleteEntity(creatednpcs['sec'])
				creatednpcs['sec'] = nil
			end
		end

		Wait(wait)
	end
end)

function GeneratePlantCoords()
	while true do
		Wait(1)

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		local plantX = 307.8 + modX
		local plantY = 4332.8 + modY

		local coordZ = GetZCoord(plantX, plantY)
		local coord = vector3(plantX, plantY, coordZ)

		if ValidateCoords(coord) then
			return coord
		end
	end
end


function ValidateCoords(plantCoord)
    local validate = true

    for k, v in pairs(plants) do
        if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
            validate = false
        end
    end

    if GetDistanceBetweenCoords(plantCoord, vector3(307.8, 4332.8, 47.89), true) > 21 then
        validate = false
    end

    return validate
end

function GetZCoord(x, y)
	local groundCheckHeights = { 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 149.0, 151.0, 152.0, 153.0, 154.0, 155.0, 156.0}

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return  48.0
end