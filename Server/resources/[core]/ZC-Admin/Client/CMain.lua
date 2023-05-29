Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end

    while not W.GetPlayerData().job do
        Wait(100)
    end

    TriggerServerEvent('admin:playerLoaded')
end)

RegisterNetEvent("ZC-Admin:setPed", function(savePed)
    W.OpenDialog('Ped', 'amount', function(ped)
        if tostring(ped) then
            local model = GetHashKey(ped)

            if IsModelInCdimage(model) and IsModelValid(model) then
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)

                if savePed then
                    TriggerServerEvent('ZCore:savePed', ped)
                end
            else
                W.Notify('Ped', 'Este ped no existe', 'error')
            end
        else
            W.Notify('Ped', 'Ha fallado algo', 'error')
        end
    end)
end)

RegisterNetEvent("ZC-Admin:tpm", function()
    local WaypointHandle = GetFirstBlipInfoId(8)
    local ply = PlayerPedId()

    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 400 do
            SetPedCoordsKeepVehicle(ply, waypointCoords["x"], waypointCoords["y"], height + 0.0)
            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
            if foundGround then
                SetPedCoordsKeepVehicle(ply, waypointCoords["x"], waypointCoords["y"], height + 0.0)
                break
            end
            Citizen.Wait(5)
        end
        W.Notify('ADMIN', 'Te ~g~teletransportaste~w~ al destino', 'verify')
    else
        W.Notify('ADMIN', '¡~r~Seleccione el destino~w~ en el mapa primero!', 'error')
    end
end)

RegisterCommand('ir', function()
    local player = W.GetPlayerData()
    if player.group == 'mod' or player.group == 'admin' then
        local elements = {}

        table.insert(elements,	{ label = 'Zona Admin', value = 'tadmin', coords = {x = -2165.16, y = 3234.8, z = 32.25}})
        table.insert(elements,	{ label = 'Comisaria Sur', value = 'comisarias', coords = {x = 428.92, y = -981.17, z = 29.71}})
        table.insert(elements,	{ label = 'Hospital Sur', value = 'hospis', coords = {x = 281.91, y = -619.0, z = 41.02}})
        table.insert(elements,	{ label = 'Ayuntamiento L.S', value = 'ayuntamiento', coords = {x = -538.76, y = -216.44, z = 37.64}})
        W.OpenMenu("¿A donde quieres ir?", "ir", elements, function (data, name)
            W.DestroyMenu(name)
            if data.value  then
                SetEntityCoords(PlayerPedId(), data.coords.x, data.coords.y, data.coords.z)
            end
        end)
    end
end)

RegisterNetEvent("ZC-Admin:repair", function ()
    if IsPedInAnyVehicle(PlayerPedId(), false)  then
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        SetVehicleDeformationFixed(vehicle)
        SetVehicleFixed(vehicle)
        SetVehicleFuelLevel(vehicle, 100)
        SetVehicleDirtLevel(vehicle, 0)
        exports['LegacyFuel']:SetFuel(vehicle, 100)
        -- exports['ZC-Garages']:setWhitelist(vehicle)
    end
end)

RegisterCommand('limpiar', function()
    local ped = PlayerPedId()
    ClearPedBloodDamage(ped)
end)

RegisterCommand('clearpeds', function(src, args)
    local player = W.GetPlayerData()
    if player.group == 'mod' or player.group == 'admin' then
        local radius = tonumber(args[1])
        if radius and radius <= 50 then
            local coords = GetEntityCoords(PlayerPedId())
            ClearAreaOfPeds(coords.x, coords.y, coords.z, radius)
        else
            W.Notify('ADMIN', '¡Pon un radio válido ~y~(<50)~w~!', 'error')
        end
    end
end)

-------- noclip --------------
local noclip = false
local NoclipSpeed = 1
local oldSpeed = 1

local function GetSeatThatPeadIsIn(ped)
    if not IsPedInAnyVehicle(ped, false) then return
    else
        local veh = GetVehiclePedIsIn(ped)
        for i = 0, GetVehicleMaxNumberOfPassengers(veh) do
        if GetPedInVehicleSeat(veh) then return i end
        end
    end
end

local function getcamdirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)

    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z
end

local function requestControlOnce(entity)
    if not NetworkIsInSession or NetworkHasControlOfEntity(entity) then
        return true
    end
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(entity), true)
    return NetworkRequestControlOfEntity(entity)
end

RegisterNetEvent("ZC-Admin:noclip", function()
    noclip = not noclip
    while true do
        Citizen.Wait(0)
        if(noclip)then
        local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), 0)
        local k = nil
        local x, y, z = nil
        if not isInVehicle then
            k = PlayerPedId()
            x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 2))
        else
            k = GetVehiclePedIsIn(PlayerPedId(), 0)
            x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 1))
        end
        if isInVehicle and GetSeatThatPeadIsIn(PlayerPedId()) ~= -1 then requestControlOnce(k) end
        local dx, dy, dz = getcamdirection()
        SetEntityVisible(PlayerPedId(), 0, 0)
        SetEntityVisible(k, 0, 0)
        SetEntityVelocity(k, 0.0001, 0.0001, 0.0001)
        if IsDisabledControlJustPressed(0, 21) then -- Change speed
            oldSpeed = NoclipSpeed
            NoclipSpeed = NoclipSpeed * 6
        end
        if IsDisabledControlJustReleased(0, 21) then -- Restore speed
            NoclipSpeed = oldSpeed
        end
        if IsDisabledControlPressed(0, 32) then -- MOVE FORWARD
            x = x + NoclipSpeed * dx
            y = y + NoclipSpeed * dy
            z = z + NoclipSpeed * dz
        end
        if IsDisabledControlPressed(0, 269) then -- MOVE BACK
            x = x - NoclipSpeed * dx
            y = y - NoclipSpeed * dy
            z = z - NoclipSpeed * dz
        end
        if IsDisabledControlPressed(0, 22) then -- MOVE UP
            z = z + NoclipSpeed
        end
        if IsDisabledControlPressed(0, 36) then -- MOVE DOWN
            z = z - NoclipSpeed
        end
        SetEntityCoordsNoOffset(k, x, y, z, true, true, true)
        else
        SetEntityVisible(PlayerPedId(), true)
        if IsPedInAnyVehicle(PlayerPedId(), 0) then
            SetEntityVisible(GetVehiclePedIsIn(PlayerPedId(), 0), true)
        end
        Citizen.Wait(200)
        break
        end
    end
end)

local inv = false

RegisterNetEvent('ZC-Admin:inv', function()
  inv = not inv
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if inv then
				SetEntityVisible(PlayerPedId(), false)
			else
				SetEntityVisible(PlayerPedId(), true)
				Citizen.Wait(20)
			end
		end
	end)
end)

RegisterNetEvent('ZC-Admin:tp', function(coords)
    SetEntityCoords(PlayerPedId(), coords.x + 0.0, coords.y + 0.0, coords.z + 0.0)
end)

RegisterNetEvent("ZC-Admin:freeze")
AddEventHandler("ZC-Admin:freeze", function(player, input)
    local player = PlayerId()
    local ped = PlayerPedId()
    if input then
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)
    else
        SetEntityCollision(ped, true)
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
    end
end)