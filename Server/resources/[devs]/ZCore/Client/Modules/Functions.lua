W.Functions = { }
W.Callbacks = { }
W.Blips     = { }
W.CThread   = CreateThread

---comment
---@param cb any
W.Thread = function(cb)
    W.CThread(cb)
end

W.Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish then
                onFinish()
            end
        else
            if onCancel then
                onCancel()
            end
        end
    end)
end

W.MathRound = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

---comment
---@param Range any
W.DeleteVehiclesInArea = function(Range)
    local Vehicles = W.EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
    local Ply = PlayerPedId()
    local PlyCoords = GetEntityCoords(Ply)
    for V in Vehicles do
        local VehicleCoords = GetEntityCoords(V)
        local Distance = #(PlyCoords - VehicleCoords)
        if Distance < Range then
            NetworkRequestControlOfEntity(V)
            SetEntityAsMissionEntity(V, false, false)
            DeleteEntity(V)
            W.Print("INFO", "Deleted entity " ..V)
        end
    end
end

function W.GetVehicles()
	return GetGamePool('CVehicle')
end

function W.GetClosestVehicle(coords)
    local ped = PlayerPedId()
    local vehicles = W.GetVehicles()
    local closestDistance = -1
    local closestVehicle = -1
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

W.GetVehiclesInArea = function(coords, maxDistance) 
	return W.EnumerateEntitiesWithinDistance(W.GetVehicles(), false, coords, maxDistance) 
end

W.IsSpawnPointClear = function(coords, maxDistance)
	return #W.GetVehiclesInArea(coords, maxDistance) == 0
end

W.GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		coords = GetEntityCoords(PlayerPedId())
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				filteredEntities[#filteredEntities + 1] = entity
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

---comment
---@param initFunc any
---@param moveFunc any
---@param disposeFunc any
---@return fun()
W.EnumerateEntities = function(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

RegisterNetEvent("core:client:deleteVehsInArea", W.DeleteVehiclesInArea)

---comment
---@param name any
---@param cb any
---@param ... any
W.TriggerCallback = function(name, cb, ...)
   W.Callbacks[name] = cb 
   TriggerServerEvent("core:server:exCallback", name, ...)
end

---comment
---@param name any
---@param ... any
W.ManageCb = function(name, ...)
    W.Callbacks[name](...)
end

RegisterNetEvent("core:client:handleCb", W.ManageCb)

---comment
---@param title any
---@param name any
---@param data any
---@param cb any
---@param closecb any
W.OpenMenu = function (title, name, data, cb, closecb)
    --if exports['Ox-Phone']:IsPhoneOpened() then return end
    if exports['Ox-Jobcreator']:IsHandcuffed() then return end
    if exports['ZC-Ambulance']:IsDead() then return end
    if exports['ZC-Menu']:isOpened() then return end

    if not W.Menus[name] then
        W.Menus[name] = { }
        W.Menus[name]['void'] = cb
        W.Menus[name]['data'] = data
        W.Menus[name]['close'] = closecb
        TriggerEvent("core:openMenu", title, name, data)
    end
end

---comment
---@param item any
---@param name any
W.HandleMenu = function (item, name)
    if W.Menus[name] then
        W.Menus[name]['void'](W.Menus[name]['data'][item], name)
    end
end

RegisterNetEvent("core:sendData", W.HandleMenu)

---comment
---@param name any
W.DestroyMenu = function (name, option)
    if W.Menus[name] then
        TriggerEvent("core:closeMenu", option)
        if W.Menus[name]['close'] then
            W.Menus[name]['close']()
        end

        W.Menus[name] = nil
    end
end

W.DestroyAllMenus = function ()
	for k,v in pairs(W.Menus) do
		TriggerEvent("core:closeMenu", option)
        if W.Menus[k]['close'] then
            W.Menus[k]['close']()
        end

        W.Menus[k] = nil
	end
end

RegisterNetEvent("core:destroyMenu", W.DestroyMenu)

---comment
---@param title any
---@param name any
---@param cb any
W.OpenDialog = function (title, name, cb)
    W.Dialogs[name] = { }
    W.Dialogs[name]['void'] = cb
    TriggerEvent("core:client:showDialog", title, name)
end

---comment
---@param name any
---@param data any
W.HandleDialog = function (name, data)
    W.Dialogs[name]['void'](data)
    W.Dialogs[name] = { }
end

RegisterNetEvent("core:sendDialogData", W.HandleDialog)

---comment
---@param coords any
---@param text any
---@param size any
---@param font any
W.ShowText = function(coords, text, size, font)
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

---comment
---@param coords any
---@param sprite any
---@param color any
---@param scale any
---@param title any
---@param resource any
---@return any
W.CreateBlip = function (coords, sprite, color, scale, title, resource)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(title)
    EndTextCommandSetBlipName(blip)
    table.insert(W.Blips, {blip = blip, resource = resource})
    return blip
end

AddEventHandler("onResourceStop", function(resource)
    for k, v in pairs(W.Blips) do
        if v.resource == resource then
            RemoveBlip(v.blip)
        end
    end
end)

---comment
---@param title any
---@param content any
---@param type any
W.Notify = function(title, content, type)
    if type then
        TriggerEvent("core:client:notify", type, title, content)
    else
        TriggerEvent("core:client:notify", 'info', title, content)
    end
end

RegisterNetEvent("core:client:Notify", W.Notify)

---comment
W.CloseDialog = function()
    TriggerEvent("wdialog:client:closeMenu")
end

---comment
---@param onlyOtherPlayers any
---@param returnKeyValue any
---@param returnPeds any
---@return table
W.GetPlayers = function(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for k,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				table.insert(players, returnPeds and ped or player)
			end
		end
	end

	return players
end

W.GetPeds = function(ignoreList)
    local pedPool = GetGamePool('CPed')
    local peds = {}
    ignoreList = ignoreList or {}
    for i = 1, #pedPool, 1 do
        local found = false
        for j = 1, #ignoreList, 1 do
            if ignoreList[j] == pedPool[i] then
                found = true
            end
        end
        if not found then
            peds[#peds + 1] = pedPool[i]
        end
    end
    return peds
end

---comment
---@param entities any
---@param isPlayerEntities any
---@param coords any
---@param maxDistance any
---@return table
W.EnumerateEntitiesWithinDistance = function(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

---comment
---@param model any
---@param coords any
---@param cb any
W.SpawnObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		if not HasModelLoaded(model) and IsModelInCdimage(model) then
			RequestModel(model)

			while not HasModelLoaded(model) do
				Citizen.Wait(1)
			end
		end
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

---comment
---@param model any
---@param coords any
---@param cb any
W.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		if not HasModelLoaded(model) and IsModelInCdimage(model) then
			RequestModel(model)

			while not HasModelLoaded(model) do
				Citizen.Wait(1)
			end
		end
		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

---comment
---@param coords any
---@param distance any
---@return table
W.GetPlayersInArea = function(coords, distance)
    return W.EnumerateEntitiesWithinDistance(W.GetPlayers(true, true), true, coords, distance)
end

---comment
---@param coords any
---@return integer
W.GetClosestPlayer = function(coords)
    return W.GetClosestEntity(W.GetPlayers(true, true), true, coords, nil)
end

---comment
---@param text any
---@param coords any
W.Floating = function (text, coords)
    if text and coords then
        exports['ZC-Interaction']:open(text, coords)
    end
end

---comment
---@return table
W.GetItemsForInventory = function()
    return W.Inventory.Items
end

---comment
---@return table
W.GetPlayerData = function()
    return W.YourData
end

W.SpawnVehicle = function (model, coords, heading, networked, cb)
    local Hash = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(Hash) do
        Wait(1)
    end

    local vehicle = CreateVehicle(model, coords, heading, networked, false)

    if networked then
        local id = NetworkGetNetworkIdFromEntity(vehicle)
        SetNetworkIdCanMigrate(id, true)
        SetEntityAsMissionEntity(vehicle, true, false)
		
		TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(vehicle))
    end
	
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')

    RequestCollisionAtCoord(coords)
    while not HasCollisionLoadedAroundEntity(vehicle) do
        Wait(0)
    end
	
    cb(vehicle)
end



W.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Wait(1)
		end

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb then
			cb(vehicle)
		end
	end)
end

---comment
---@param name any
---@return any
W.HaveItem = function(name)
    for k,v in pairs(W.Inventory.Items['data']) do
        if tostring(v.name) == tostring(name) then
            return tonumber(v.quantity), v
        end
    end

    return 0
end

W.ShowHelpNotification = function(msg, thisFrame, beep, duration)
	AddTextEntry('HelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('HelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('HelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

W.Parse = function(text)    
    return string.gsub(text, " ", "")
end

W.SetVehicleProperties = function(vehicle, props, plate)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

        if plate then
		    SetVehicleNumberPlateText(vehicle, plate)
		else
            SetVehicleNumberPlateText(vehicle, props.plate)
        end

		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
		if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
		if props.color1Custom then
			SetVehicleCustomPrimaryColour(vehicle, tonumber(props.color1Custom[1]), tonumber(props.color1Custom[2]), tonumber(props.color1Custom[3]))
		end
		if props.color2Custom then
			SetVehicleCustomSecondaryColour(vehicle, tonumber(props.color2Custom[1]), tonumber(props.color2Custom[2]), tonumber(props.color2Custom[3]))
		end
		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for extraId,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(extraId), 0)
				else
					SetVehicleExtra(vehicle, tonumber(extraId), 1)
				end
			end
		end

		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
		if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
		if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end

W.GetVehicleProperties = function(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}
		local color1Custom = {}
		color1Custom[1], color1Custom[2], color1Custom[3] = GetVehicleCustomPrimaryColour(vehicle)
		local color2Custom = {}
		color2Custom[1], color2Custom[2], color2Custom[3] = GetVehicleCustomSecondaryColour(vehicle)


		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				-- local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				-- extras[tostring(extraId)] = state
				extras[tostring(extraId)] = IsVehicleExtraTurnedOn(vehicle, extraId)
			end
		end

		return {
			model             = GetEntityModel(vehicle),

			plate             = GetVehicleNumberPlateText(vehicle),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

			bodyHealth        = GetVehicleBodyHealth(vehicle),
			engineHealth      = GetVehicleEngineHealth(vehicle),
			tankHealth        = GetVehiclePetrolTankHealth(vehicle),

			fuelLevel         = GetVehicleFuelLevel(vehicle),
			dirtLevel         = GetVehicleDirtLevel(vehicle),
			color1            = colorPrimary,
			color2            = colorSecondary,
			color1Custom = color1Custom,
			color2Custom = color2Custom,
			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) or GetVehicleMod(vehicle, 48),
			modLightbar = GetVehicleMod(vehicle, 49),
			fuel			  = exports['LegacyFuel']:GetFuel(vehicle)
		}
	else
		return
	end
end

W.Round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

RegisterCommand('menubug', W.DestroyAllMenus)