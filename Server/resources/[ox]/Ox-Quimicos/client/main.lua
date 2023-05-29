local menuOpen = false
local wasOpen = false
local isPickingUp = false
local SpawnedChemicals = 0
local Chemicals = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.ChemicalsField.coords, true) < 30 then
			SpawnChemicals()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

--Proceso a LSD

Citizen.CreateThread(function()
	while true do
		s = 1000
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, Config.CircleZones.lsdProcessing.coords, true)
		local shown = false

		if distance < 3.5 and IsPedOnFoot(playerPed) then
			s = 0

				exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'lsd_processprompt')


			if IsControlJustReleased(0, 38) then
				local have = W.HaveItem('lsa')
				if have < 1 then 
					W.Notify('LSD', '~r~No~w~ tienes LSA encima.', 'error')
				else
				W.Progressbar("LSD", 'Procesando LSA...', 15000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function() -- Done
					TriggerServerEvent('Ox-Quimicos:processLSD')
				end, function()
					W.Notify('LSD', 'Has cancelado la acción', 'error')
				end)
				end
			end
		end
		if distance < 3.5 and not shown then
			shown = true
				exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'lsd_processprompt')
		else 
			exports['ZC-HelpNotify']:close('lsd_processprompt')

			shown = false
		end
		Citizen.Wait(s)
	end
end)

--Proceso a LSA

Citizen.CreateThread(function()
	while true do
		s = 1000
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, Config.CircleZones.ChemicalsConvertionMenu.coords, true) 
		local shown = false
		

		if distance < 1.7 and IsPedOnFoot(playerPed) then
			s = 0

				exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'chemicals_prompt')

				if IsControlJustReleased(0, 38) then
					local have = W.HaveItem('chemicals')
					if have < 1 then 
						W.Notify('LSA', '~r~No~w~ tienes químicos encima.', 'error')
					else
					W.Progressbar("taking_bullets", 'Procesando químicos...', 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function()
						TriggerServerEvent('Ox-Quimicos:processLSA')
                    end, function()
                        W.Notify('LSA', 'Has cancelado la acción', 'error')
                    end)
				end
				end
		end
		if distance < 1.7 and not shown then
			shown = true
				exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'chemicals_prompt')
		else 
			exports['ZC-HelpNotify']:close('chemicals_prompt')

			shown = false
		end
		Citizen.Wait(s)
	end
end)

--Recolecta Quimicos

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DisableControlAction(0, 73, true)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID
		local shown = false

		for i=1, #Chemicals, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(Chemicals[i]),(-1), false) < 1 then
				nearbyObject, nearbyID = Chemicals[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then
			
			if IsControlJustReleased(0, 38) and not isPickingUp then
				exports['ZC-HelpNotify']:close('chemicals_pickupprompt')
				isPickingUp = true

						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

						Citizen.Wait(3000)
						ClearPedTasks(playerPed)
						Citizen.Wait(2000)
						shown = false
						DeleteObject(nearbyObject)
		
						table.remove(Chemicals, nearbyID)
						SpawnedChemicals = SpawnedChemicals - 1
		
						TriggerServerEvent('Ox-Quimicos:pickChemicals', "chemicals", 1)

				Wait (10)
				isPickingUp = false

			end

		else
			Citizen.Wait(500)
		end

		if nearbyObject and not shown then
			shown = true

			if not isPickingUp then
				exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'chemicals_pickupprompt')
			end
		else 
			exports['ZC-HelpNotify']:close('chemicals_pickupprompt')

			shown = false
		end

	end

end)

function SpawnChemicals()
	while SpawnedChemicals < 10 do
		Citizen.Wait(0)
		local chemicalsCoords = GeneratechemicalsCoords()

		W.SpawnLocalObject('prop_barrel_01a', chemicalsCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(Chemicals, obj)
			SpawnedChemicals = SpawnedChemicals + 1
		end)
	end
end

function ValidatechemicalsCoord(plantCoord)
	if SpawnedChemicals > 0 then
		local validate = true

		for k, v in pairs(Chemicals) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.ChemicalsField.coords, false) > 30 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GeneratechemicalsCoords()
	while true do
		Citizen.Wait(1)

		local chemicalsCoordX, chemicalsCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-7, 7)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-7, 7)

		chemicalsCoordX = Config.CircleZones.ChemicalsField.coords.x + modX
		chemicalsCoordY = Config.CircleZones.ChemicalsField.coords.y + modY

		local coordZ = GetCoordZChemicals(chemicalsCoordX, chemicalsCoordY)
		local coord = vector3(chemicalsCoordX, chemicalsCoordY, 48.34)

		if ValidatechemicalsCoord(coord) then
			return coord
		end
	end
end

function GetCoordZChemicals(x, y)
	local groundCheckHeights = {9.0, 10.0, 11.0}

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 5.9
end