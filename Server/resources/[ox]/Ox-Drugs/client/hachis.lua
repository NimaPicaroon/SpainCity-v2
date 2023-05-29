local talking = false
CreateThread(function()
	local add = false
	while true do
		local wait = 750
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped, false)
		local distance = GetDistanceBetweenCoords(coords, vector3(379.56, -2445.6, 5.09), true)

		if not OwnData.gang then
			OwnData.gang = W.GetPlayerData().gang
		end

		if distance < 100 and OwnData.gang.name then
			if creatednpcs['fridge'] == nil then
				local modelHash = GetHashKey('ig_chef')
				RequestModel(modelHash)
				while not HasModelLoaded(modelHash) do
					Wait(1)
				end
				local SpawnedPed = CreatePed(2, modelHash, vector3(379.56, -2445.6, 5.09), 327.72, false, true)
				DecorSetInt(SpawnedPed, 'SPAWNEDPED', 1)
				creatednpcs['fridge'] = SpawnedPed
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
					exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'hachis2')
					add = true
				end

				if IsControlJustReleased(0, 38) then
					talking = true
					W.TriggerCallback('Ox-Drugs:getOrder', function(time)
						if time == nil then
							local count, item = W.HaveItem('hoja_polvo')
							if count == 0 then
								W.Notify('DESCONOCIDO', 'No tengo nada que hablar contigo')
								talking = false
							else
								W.Notify('DESCONOCIDO', 'Acompañame...')
								FreezeEntityPosition(creatednpcs['fridge'], false)
								TaskGoToCoordAnyMeans(creatednpcs['fridge'], 376.28, -2440.4, 5.09, 1.0, 0, 0, 786603, 2)
								local npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge']) , vector3(376.28, -2440.4, 5.09), false)
								while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge']) , vector3(376.28, -2440.4, 5.09), false) end
								SetEntityHeading(creatednpcs['fridge'], 175.0)
								Wait(500)

								W.OpenDialog("Inserta la cantidad de hojas que quieras procesar", "give_hojas", function(amount)
									W.CloseDialog()
									amount = tonumber(amount)
									if amount <= count then
										if W.GetPlayerData().money.money > (amount * 16) then
											W.Notify('DESCONOCIDO', 'Has pagado ~y~$'..(amount * 16))
											TriggerServerEvent('Ox-Drugs:proccessHojas', amount, item)
											TaskStartScenarioInPlace(creatednpcs['fridge'], 'PROP_HUMAN_BUM_BIN', 0, false)
											Wait(3000)
											ClearPedTasks(creatednpcs['fridge'])
											W.Notify('DESCONOCIDO', 'Vuelve en ~y~1h~w~ y la hojas estará procesada')
											Wait(500)
											TaskGoToCoordAnyMeans(creatednpcs['fridge'], vector3(379.56, -2445.6, 5.09), 1.0, 0, 0, 786603, 2)
											npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge']) , vector3(379.56, -2445.6, 5.09), false)
											while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge']) , vector3(379.56, -2445.6, 5.09), false) end
											SetEntityHeading(creatednpcs['fridge'], 175.9)
											talking = false
										else
											W.Notify('DESCONOCIDO', 'Necesitas pagarme ~y~$'..(amount * 16), 'error')
											Wait(500)
											TaskGoToCoordAnyMeans(creatednpcs['fridge'], vector3(379.56, -2445.6, 5.09), 1.0, 0, 0, 786603, 2)
											npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge']) , vector3(379.56, -2445.6, 5.09), false)
											while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge']) , vector3(379.56, -2445.6, 5.09), false) end
											SetEntityHeading(creatednpcs['fridge'], 175.9)
											talking = false
										end
									else
										W.Notify('DESCONOCIDO', '~r~No~w~ tienes tanta hojas', 'error')
										Wait(500)
										TaskGoToCoordAnyMeans(creatednpcs['fridge'], vector3(379.56, -2445.6, 5.09), 1.0, 0, 0, 786603, 2)
										npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge']) , vector3(379.56, -2445.6, 5.09), false)
										while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge']) , vector3(379.56, -2445.6, 5.09), false) end
										SetEntityHeading(creatednpcs['fridge'], 175.9)
										talking = false
									end
								end)
							end
						elseif time == true then
							TriggerServerEvent('Ox-Drugs:giveProccessedHojas')
							talking = false
						else
							W.Notify('DESCONOCIDO', 'Ahora mismo estoy ~y~ocupado')
							talking = false
						end
					end, 'hachis')
				end
			else
				add = false
				exports['ZC-HelpNotify']:close('hachis2')
			end
		else
			if creatednpcs['fridge'] ~= nil then
				DeleteEntity(creatednpcs['fridge'])
				creatednpcs['fridge'] = nil
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
		local distance = GetDistanceBetweenCoords(coords, vector3(1407.96, 3670.4, 33.01), true)

		if not OwnData.gang then
			OwnData.gang = W.GetPlayerData().gang
		end

		if distance < 100 and OwnData.gang.name then
			if creatednpcs['fridge2'] == nil then
				local modelHash = GetHashKey('mp_f_weed_01')
				RequestModel(modelHash)
				while not HasModelLoaded(modelHash) do
					Wait(1)
				end
				local SpawnedPed = CreatePed(2, modelHash, vector3(1407.96, 3670.4, 33.01), 153.72, false, true)
				DecorSetInt(SpawnedPed, 'SPAWNEDPED', 1)
				creatednpcs['fridge2'] = SpawnedPed
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
					exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'hachis3')
					add = true
				end

				if IsControlJustReleased(0, 38) then
					talking = true
					local count, item = W.HaveItem('resina_kief')
					if count == 0 then
						W.Notify('DESCONOCIDO', 'No tengo nada que hablar contigo')
						talking = false
					else
						W.Notify('DESCONOCIDO', 'Acompañame...')
						FreezeEntityPosition(creatednpcs['fridge2'], false)
						TaskGoToCoordAnyMeans(creatednpcs['fridge2'], 1408.68, 3667.68, 33.09, 1.0, 0, 0, 786603, 2)
						local npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge2']) , vector3(1408.68, 3667.68, 33.09), false)
						while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge2']) , vector3(1408.68, 3667.68, 33.09), false) end
						SetEntityHeading(creatednpcs['fridge2'], 200.0)
						Wait(500)

						W.OpenDialog("Inserta la cantidad de resina de Kief que quieras procesar", "give_Kief", function(amount)
							W.CloseDialog()
							amount = tonumber(amount)
							if amount <= count and (amount % 2 == 0) then
								TaskStartScenarioInPlace(creatednpcs['fridge2'], 'PROP_HUMAN_BUM_BIN', 0, false)
								Wait(3000)
								ClearPedTasks(creatednpcs['fridge2'])
								W.Notify('DESCONOCIDO', 'Toma tu pedido')
								TriggerServerEvent('Ox-Drugs:proccessKief', amount, item)
								Wait(500)
								TaskGoToCoordAnyMeans(creatednpcs['fridge2'], vector3(1407.96, 3670.4, 33.01), 1.0, 0, 0, 786603, 2)
								npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge2']) , vector3(1407.96, 3670.4, 33.01), false)
								while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge2']) , vector3(1407.96, 3670.4, 33.01), false) end
								SetEntityHeading(creatednpcs['fridge2'], 153.9)
								talking = false
							else
								W.Notify('DESCONOCIDO', '~r~No~w~ tienes tanta resina de Kief o tienes que meter un número par', 'error')
								Wait(500)
								TaskGoToCoordAnyMeans(creatednpcs['fridge2'], vector3(1407.96, 3670.4, 33.01), 1.0, 0, 0, 786603, 2)
								npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge2']) , vector3(1407.96, 3670.4, 33.01), false)
								while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(creatednpcs['fridge2']) , vector3(1407.96, 3670.4, 33.01), false) end
								SetEntityHeading(creatednpcs['fridge2'], 153.9)
								talking = false
							end
						end)
					end
				end
			else
				add = false
				exports['ZC-HelpNotify']:close('hachis3')
			end
		else
			if creatednpcs['fridge2'] ~= nil then
				DeleteEntity(creatednpcs['fridge2'])
				creatednpcs['fridge2'] = nil
			end
		end

		Wait(wait)
	end
end)

Menu = function (cped, vehicle, prop)
	exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'hachis')

	while true do
		if IsControlJustPressed(0, 38) then
			exports['ZC-HelpNotify']:close('hachis')
			break
		end
		Wait(0)
	end

	Wait(150)
	W.OpenMenu("Tienda", "shop_menu", Config.Items['hachis2'], function (data, name)
		W.DestroyMenu(name)
		W.OpenDialog("Cantidad", "dialog_qua", function(amount)
			amount = tonumber(amount)
			local money = W.GetPlayerData().money.money
			if data.blackmoney then
				money = W.GetPlayerData().money.money
			end
			if money >= (amount  * data.price) then
				W.CloseDialog()
				if data.name ~= "cancel" then
					W.TriggerCallback("Ox-Drugs-buyHachis", function (can)
						if can == true then
							Wait(1000)
							TaskGoToCoordAnyMeans(cped, GetEntityCoords(vehicle), 1.0, 0, 0, 786603, 2)
							local dis = #(GetEntityCoords(vehicle) - GetEntityCoords(cped))
							while dis > 3.0 do Wait(100) dis = #(GetEntityCoords(vehicle) - GetEntityCoords(cped)) end
							TaskEnterVehicle(cped, vehicle, 100, 1, 2.0)
							while not IsPedInVehicle(cped, vehicle, false) do Wait(100) TaskEnterVehicle(cped, vehicle, 100, 1, 2.0) end
							DeleteEntity(prop)
							DeleteObject(prop)
							TaskVehicleDriveToCoordLongrange(cped, vehicle, 2747.72, -1750.68, 0.69, 10.0, 1040, 5.0)
							visited['hachis'] = false
							local distance3 = #(GetEntityCoords(vehicle) - vector3(2747.72, -1750.68, 0.69))
							while distance3 > 5.0 do Wait(100) distance3 = #(vector3(2747.72, -1750.68, 0.69) - GetEntityCoords(vehicle)) end
							DeleteEntity(cped)
							DeleteEntity(vehicle)
						else
							W.Notify('TIENDA', can, 'error')
							Menu(cped, vehicle, prop)
						end
					end, data.name, amount, data.price, data.blackmoney)
				else
					W.Notify('TIENDA', 'Nos vemos vato!')
					TaskGoToCoordAnyMeans(cped, GetEntityCoords(vehicle), 1.0, 0, 0, 786603, 2)
					local dis = #(GetEntityCoords(vehicle) - GetEntityCoords(cped))
					while dis > 3.0 do Wait(100) dis = #(GetEntityCoords(vehicle) - GetEntityCoords(cped)) end
					TaskEnterVehicle(cped, vehicle, 100, 1, 2.0)
					while not IsPedInVehicle(cped, vehicle, false) do Wait(100) TaskEnterVehicle(cped, vehicle, 100, 1, 2.0) end
					DeleteEntity(prop)
					DeleteObject(prop)
					TaskVehicleDriveToCoordLongrange(cped, vehicle, 2747.72, -1750.68, 0.69, 10.0, 1040, 5.0)
					visited['hachis'] = false
					local distance3 = #(GetEntityCoords(vehicle) - vector3(2747.72, -1750.68, 0.69))
					while distance3 > 4.0 do Wait(100) distance3 = #(vector3(2747.72, -1750.68, 0.69) - GetEntityCoords(vehicle)) end
					DeleteEntity(cped)
					DeleteEntity(vehicle)
				end
			else
				W.Notify('TIENDA', '~r~No~w~ tienes suficiente dinero', 'error')
				Menu(cped, vehicle, prop)
			end
		end)
	end)
end

local routeblip
Hachis = function ()
	if not routeblip then
		routeblip = AddBlipForCoord(2667.88, -1718.56, 1.69)
		SetBlipHighDetail(routeblip, true)
		SetBlipSprite(routeblip, 1)
		SetBlipScale(routeblip, 0.8)
		SetBlipColour(routeblip, 5)
		SetBlipRoute(routeblip, true)
		SetBlipRouteColour(routeblip, 5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Entrega de mercancía")
		EndTextCommandSetBlipName(routeblip)
	end

	local npc_distance = #(vector3(2667.88, -1718.56, 1.69) - GetEntityCoords(PlayerPedId()))
	while npc_distance > 10.0 do Wait(100) npc_distance = #(vector3(2667.88, -1718.56, 1.69) - GetEntityCoords(PlayerPedId())) end

	RemoveBlip(routeblip)
	local hash = GetHashKey('dinghy')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(1)
    end
    vehicle = CreateVehicle('dinghy', 2747.72, -1750.68, 0.69, 80.96, true, true)
    TriggerEvent("LegacyFuel:SetFuel", vehicle, 100)
    local ped = GetHashKey('g_m_y_armgoon_02')
    RequestModel(ped)
    while not HasModelLoaded(ped) do
        Wait(1)
    end

    cped = CreatePedInsideVehicle(vehicle, "PED_TYPE_CIVMALE", ped, -1, true, false)
	DecorSetInt(cped, 'SPAWNEDPED', 1)
	SetDriverAbility(cped, 1.0)
	SetDriverAggressiveness(cped, 0.0)
	SetEntityInvincible(cped, true)
	SetBlockingOfNonTemporaryEvents(cped, true)
    TaskVehicleDriveToCoordLongrange(cped, vehicle, 2683.12, -1726.96, -0.21, 5.0, 16777216, 2.0)

    local distance2 = #(GetEntityCoords(vehicle) - vector3(2683.12, -1726.96, -0.21))
	while distance2 > 3.0 do Wait(100) distance2 = #(vector3(2683.12, -1726.96, -0.21) - GetEntityCoords(vehicle)) end
    TaskLeaveAnyVehicle(cped, true, true)
	Wait(200)
	prop = CreateObject(GetHashKey("prop_ld_suitcase_01"), vector3(2674.32, -1723.52, -0.93), true, true, true)
    FreezeEntityPosition(prop, true)
    SetEntityAsMissionEntity(prop)
    SetEntityCollision(prop, false, true)
    AttachEntityToEntity(prop, cped, GetPedBoneIndex(cped, 57005), 0.39, 0.0, 0.0, 0.0, 266.0, 60.0, true, true, false, true, 1, true)
	while true do
		local coords = GetEntityCoords(PlayerPedId())
		TaskGoToCoordAnyMeans(cped, coords, 1.0, 0, 0, 786603, 2)
		local dis = #(coords - GetEntityCoords(cped))

		if dis < 1.2 then
			break
		end
		Wait(100)
	end

	exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'hachis')

	while true do
		if IsControlJustPressed(0, 38) then
			exports['ZC-HelpNotify']:close('hachis')
			break
		end
		Wait(0)
	end

	W.OpenMenu("Tienda", "shop_menu", Config.Items['hachis2'], function (data, name)
		W.DestroyMenu(name)
		W.OpenDialog("Cantidad", "dialog_qua", function(amount)
			amount = tonumber(amount)
			local money = W.GetPlayerData().money.money
			if data.blackmoney then
				money = W.GetPlayerData().money.money
			end
			if money >= (amount * data.price) then
				W.CloseDialog()
				if data.name ~= "cancel" then
					W.TriggerCallback("Ox-Drugs-buyHachis", function(can)
						if can == true then
							TaskGoToCoordAnyMeans(cped, GetEntityCoords(vehicle), 1.0, 0, 0, 786603, 2)
							local dis = #(GetEntityCoords(vehicle) - GetEntityCoords(cped))
							while dis > 3.0 do Wait(100) dis = #(GetEntityCoords(vehicle) - GetEntityCoords(cped)) end
							TaskEnterVehicle(cped, vehicle, 100, 1, 2.0)
							while not IsPedInVehicle(cped, vehicle, false) do Wait(100) TaskEnterVehicle(cped, vehicle, 100, 1, 2.0) end
							DeleteEntity(prop)
							DeleteObject(prop)
							TaskVehicleDriveToCoordLongrange(cped, vehicle, 2747.72, -1750.68, 0.69, 10.0, 1040, 5.0)
							visited['hachis'] = false
							local distance3 = #(GetEntityCoords(vehicle) - vector3(2747.72, -1750.68, 0.69))
							while distance3 > 4.0 do Wait(100) distance3 = #(vector3(2747.72, -1750.68, 0.69) - GetEntityCoords(vehicle)) end
							DeleteEntity(cped)
							DeleteEntity(vehicle)
						else
							W.Notify('TIENDA', can, 'error')
							Menu(cped, vehicle, prop)
						end
					end, data.name, amount, data.price, data.blackmoney)
				else
					W.Notify('TIENDA', 'Nos vemos vato!')
					TaskGoToCoordAnyMeans(cped, GetEntityCoords(vehicle), 1.0, 0, 0, 786603, 2)
					local dis = #(GetEntityCoords(vehicle) - GetEntityCoords(cped))
					while dis > 3.0 do Wait(100) dis = #(GetEntityCoords(vehicle) - GetEntityCoords(cped)) end
					TaskEnterVehicle(cped, vehicle, 100, 1, 2.0)
					while not IsPedInVehicle(cped, vehicle, false) do Wait(100) TaskEnterVehicle(cped, vehicle, 100, 1, 2.0) end
					DeleteEntity(prop)
					DeleteObject(prop)
					TaskVehicleDriveToCoordLongrange(cped, vehicle, 2747.72, -1750.68, 0.69, 10.0, 1040, 5.0)
					visited['hachis'] = false
					local distance3 = #(GetEntityCoords(vehicle) - vector3(2747.72, -1750.68, 0.69))
					while distance3 > 4.0 do Wait(100) distance3 = #(vector3(2747.72, -1750.68, 0.69) - GetEntityCoords(vehicle)) end
					DeleteEntity(cped)
					DeleteEntity(vehicle)
				end
			else
				W.Notify('TIENDA', '~r~No~w~ tienes suficiente dinero', 'error')
				Menu(cped, vehicle, prop)
			end
		end)
	end)
end

RegisterCommand('hachis', Hachis)