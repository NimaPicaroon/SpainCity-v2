local picking = false
local talking = false

CreateThread(function()
	local add = false
	local CurrentPlant
	while true do
		local wait = 1000
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped, false)
		local distance = GetDistanceBetweenCoords(coords, vector3(3469.68, 2799.4, 11.61), true)

		if not OwnData.gang then
			OwnData.gang = W.GetPlayerData().gang
		end

		if visited['coke'] and distance < 100 and OwnData.gang.name then
            wait = 250
            if #plantsCoke < 15 then
                RequestModel('prop_plant_palm_01a')
                while not HasModelLoaded(GetHashKey('prop_plant_palm_01a')) do
                    Wait(0)
                end
                local modelSpawn = CreateObject(GetHashKey('prop_plant_palm_01a'), GeneratePlantCoords2(), false, true, true)
                FreezeEntityPosition(modelSpawn, true)
                PlaceObjectOnGroundProperly(modelSpawn)
                table.insert(plantsCoke, modelSpawn)
            elseif #plantsCoke == 15 then
                for k, v in pairs(plantsCoke) do
                    local distancetoPlant = #(GetEntityCoords(v) - coords)
                    if distancetoPlant <= 3.5 and not picking and not IsPedInAnyVehicle(ped, true) then
                        wait = 0
						if not add then
							exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'interact_coke')
							add = true
						end
						CurrentPlant = k

                        if IsControlJustReleased(0, 38) then
                            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_KNIFE") then
                                picking = true
								W.Progressbar("picking_coke", 'Recogiendo...', 10000, false, true, {
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
									TriggerServerEvent('Ox-Drugs:giveItem', 'hoja_cocalero', 1)
									DeleteEntity(v)
									table.remove(plantsCoke, k)
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
					exports['ZC-HelpNotify']:close('interact_coke')
				end
            end
		else
			if #plantsCoke > 0 then
                for k, v in ipairs(plantsCoke) do
                    DeleteEntity(v)
                    table.remove(plantsCoke, k)
                    Wait(100)
                end
			end
		end
		Wait(wait)
	end
end)

CreateThread(function()
	local add = false
	local add2 = false
	while true do
		local wait = 750
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped, false)
		local distance = GetDistanceBetweenCoords(coords, vector3(1005.73, -3200.33, -39.55), true)
		local distance2 = GetDistanceBetweenCoords(coords, vector3(1006.03, -3195.19, -39.85), true)

		if not OwnData.gang then
			OwnData.gang = W.GetPlayerData().gang
		end

		if distance <= 5.0 then
			wait = 0
			DrawMarker(1, vector3(1005.73, -3200.33, -39.55), 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 0, 153, 255, 255, 0, 0, 0, 0, 0, 0, 0)
			if distance <= 2.0 then
				if not add then
					exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'interact_coke2')
					add = true
				end
				if IsControlJustPressed(0, 38) and not talking then
					talking = true
					local elements = {
						{label= "Mezclar soda cáustica y amoniaco", value = "amon"}
					}

					W.OpenMenu("Procesar", "pro_menu", elements, function (data, name)
						W.DestroyMenu(name)
						if data.value then
							local have, item = W.HaveItem("soda_caustica")
							if have == 0 then W.Notify('DROGAS', '~r~No~w~ tienes lo necesario para hacerlo', 'error') return end
							local have2, item2 = W.HaveItem("amoniaco")
							if have2 == 0 then W.Notify('DROGAS', '~r~No~w~ tienes lo necesario para hacerlo', 'error') return end

							W.Progressbar("mix", 'Mezclando...', 5000, false, true, {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}, {
								animDict = 'creatures@rottweiler@tricks@',
								anim = 'petting_franklin'
							}, {}, {}, function() -- Done
								talking = false
								ClearPedTasks(ped)
								TriggerServerEvent('Ox-Drugs:removeItem', 'soda_caustica', 1, item.slotId)
								TriggerServerEvent('Ox-Drugs:removeItem', 'amoniaco', 1, item2.slotId)
								TriggerServerEvent('Ox-Drugs:giveItem', 'pasta_coca', 2)
							end, function()
								W.Notify('Mezcla', 'Has cancelado la acción', 'error')
								talking = false
							end)
						else
							talking = false
						end
					end)
				end
			else
				talking = false
				add = false
				exports['ZC-HelpNotify']:close('interact_coke2')
			end
		end

		if distance2 <= 5.0 then
			wait = 0
			DrawMarker(1, vector3(1006.03, -3195.19, -39.90), 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 0, 153, 255, 255, 0, 0, 0, 0, 0, 0, 0)
			if distance2 <= 2.0 then
				if not add2 then
					exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'interact_coke3')
					add2 = true
				end

				if IsControlJustPressed(0, 38) and not talking then
					talking = true
					local elements = {
						{label= "Mezclar pasta de coca y acetona", value = "acetona"}
					}

					W.OpenMenu("Procesar", "pro_menu2", elements, function (data, name)
						W.DestroyMenu(name)
						if data.value then
							local have, item = W.HaveItem("pasta_coca")
							if have == 0 then W.Notify('DROGAS', '~r~No~w~ tienes lo necesario para hacerlo', 'error') return end
							local have2, item2 = W.HaveItem("acetona")
							if have2 == 0 then W.Notify('DROGAS', '~r~No~w~ tienes lo necesario para hacerlo', 'error') return end
							W.Progressbar("mix2", 'Mezclando...', 5000, false, true, {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}, {
								animDict = 'creatures@rottweiler@tricks@',
								anim = 'petting_franklin'
							}, {}, {}, function() -- Done
								talking = false
								ClearPedTasks(ped)
								TriggerServerEvent('Ox-Drugs:removeItem', 'pasta_coca', 1, item.slotId)
								TriggerServerEvent('Ox-Drugs:removeItem', 'acetona', 1, item2.slotId)
								TriggerServerEvent('Ox-Drugs:giveItem', 'clorhidrato_coca', 3)
							end, function()
								W.Notify('Mezcla', 'Has cancelado la acción', 'error')
								talking = false
							end)
						else
							talking = false
						end
					end)
				end
			else
				talking = false
				add2 = false
				exports['ZC-HelpNotify']:close('interact_coke3')
			end
		end

		Wait(wait)
	end
end)

function GeneratePlantCoords2()
	while true do
		Wait(1)

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		local plantX = 3469.68 + modX
		local plantY = 2799.4 + modY

		local coordZ = GetZCoord2(plantX, plantY)
		local coord = vector3(plantX, plantY, coordZ -2.5)

		if ValidateCoords2(coord) then
			return coord
		end
	end
end


function ValidateCoords2(plantCoord)
    local validate = true

    for k, v in pairs(plantsCoke) do
        if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
            validate = false
        end
    end

    if GetDistanceBetweenCoords(plantCoord, vector3(3469.68, 2799.4, 11.61), true) > 21 then
        validate = false
    end

    return validate
end

function GetZCoord2(x, y)
	local groundCheckHeights = { 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 149.0, 151.0, 152.0, 153.0, 154.0, 155.0, 156.0}

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return  11.0
end