local Pause = false
local showing = false
local haveSeatbelt = false
local seatbelt = false
local speedBuffer  = {[1] = 0}
local velBuffer    = {}
local vehicleCruiser = false

Fwv = function (entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

CreateThread(function ()
    while true do
        local sleep = 800
        local ped = PlayerPedId()
        local is_in_vehicle = IsPedInAnyVehicle(ped, false)
        if is_in_vehicle then -- GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped
            if not Pause then
                local vehicle = GetVehiclePedIsIn(ped)
                local class = GetVehicleClass(vehicle)
                if (class >= 0 and class <= 7) or (class >= 9 and class <= 12) or (class >= 17 and class <= 20) then
                    haveSeatbelt = true
                else
                    haveSeatbelt = false
                end
                if class ~= 13 then
                    if not showing then
                        local data = {
                            show = true
                        }
                        SendNUIMessage({
                            action = 'vehicle',
                            data = data
                        })
                        showing = true
                        if seatbelt then
                            SendNUIMessage({
                                action = 'sound',
                                seatbelt = true,
                                putSound = false
                            })
                        else
                            if not seatbelt then
                                SendNUIMessage({
                                    action = 'sound',
                                    seatbelt = true,
                                    putSound = false
                                })
                            end
                        end
                    end
                    local speed = GetEntitySpeed(vehicle) * 3.6
                    local rev = GetVehicleCurrentRpm(vehicle)
                    local fuel = DecorGetFloat(vehicle, '_FUEL_LEVEL')
                    local engine = GetVehicleEngineHealth(vehicle)
                    local gears = GetVehicleCurrentGear(vehicle)

                    if gears == 0 then
                        gears = 'R'
                    end

                    if not seatbelt and haveSeatbelt then
                        speedBuffer[2] = speedBuffer[1]
                        speedBuffer[1] = speed / 3.6
                        if speedBuffer[2] and GetEntitySpeedVector(vehicle, true).y > 1.0  and speedBuffer[1] > 60 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.2) then
                            local co = GetEntityCoords(ped)
                            local fw = Fwv(ped)
                            SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                            SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                            Wait(1)
                            SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                            showing = false
                            local data = {
                                show = false
                            }
                            SendNUIMessage({
                                action = 'vehicle',
                                data = data
                            })
                            SendNUIMessage({
                                action = 'sound',
                                seatbelt = true,
                                putSound = false
                            })
                            speedBuffer[1], speedBuffer[2] = 0, 0
                        end

                        velBuffer[2] = velBuffer[1]
                        velBuffer[1] = GetEntityVelocity(vehicle)
                    else
                        if haveSeatbelt then
                            DisableControlAction(0, 75)
                        end
                    end

                    local data = {
                        speed  = Round(speed),
                        show = true,
                        rev    = rev - 0.20,
                        fuel = fuel,
                        engine = (engine / 10),
                        gears = gears,
                    }

                    SendNUIMessage({
                        action = 'vehicle',
                        data = data
                    })
                    sleep = 20
                end
            else
                if showing then
                    showing = false
                    local data = {
                        show = false
                    }
                    SendNUIMessage({
                        action = 'vehicle',
                        data = data
                    })
                    SendNUIMessage({
                        action = 'sound',
                        seatbelt = false
                    })
                end
            end
        else
            if showing then
                showing = false
                local data = {
                    show = false
                }
                SendNUIMessage({
                    action = 'vehicle',
                    data = data
                })
                SendNUIMessage({
                    action = 'sound',
                    seatbelt = true,
                    putSound = false
                })
                speedBuffer[1], speedBuffer[2] = 0, 0
                haveSeatbelt = false
                seatbelt  = false
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()

        if IsPauseMenuActive() then
            Pause = true
        else
            if Pause then
                Pause = false
            end
        end

        if IsPedInAnyVehicle(ped) and haveSeatbelt and not Pause then
            if not seatbelt then
                SendNUIMessage({
                    action = 'sound',
                    seatbelt = false,
                    putSound = true
                })
            else
                SendNUIMessage({
                    action = 'sound',
                    seatbelt = true,
                    putSound = false
                })
            end
        end
        Wait(wait)
    end
end)

RegisterKeyMapping('seatbelt', 'Ponerse el cinturón', 'keyboard', 'X')

RegisterCommand("seatbelt", function ()
    --if exports['Ox-Phone']:IsPhoneOpened() then return end
    if exports['ZC-Ambulance']:IsDead() then return end
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        if haveSeatbelt then
            if not seatbelt then
                seatbelt = true
                SendNUIMessage({
                    action = 'sound',
                    seatbelt = true,
                    sound = 1
                })
            else
                seatbelt = false
                SendNUIMessage({
                    action = 'sound',
                    seatbelt = false,
                    sound = 0
                })
            end
        end
    end
end)

RegisterKeyMapping('limitador', 'Poner el limitador', 'keyboard', '7')

RegisterCommand("limitador", function ()
    --if exports['Ox-Phone']:IsPhoneOpened() then return end
    if exports['Ox-Jobcreator']:IsHandcuffed() then return end
    if exports['ZC-Ambulance']:IsDead() then return end
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)

        local vehicleSpeedSource = GetEntitySpeed(vehicle)
        if vehicleCruiser then
            vehicleCruiser = false
            SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel"))
            W.Notify('NOTIFICACIÓN', "Limitador desactivado")
        else
            vehicleCruiser = true
            SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
            W.Notify('NOTIFICACIÓN', "Limitador activado")
        end
    end
end)

RegisterCommand("hood", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if GetVehicleDoorAngleRatio(veh, 4) > 0 then
            SetVehicleDoorShut(veh, 4, false)
        else
            SetVehicleDoorOpen(veh, 4, false, false)
        end
    end
end, false)

RegisterCommand("trunk", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if GetVehicleDoorAngleRatio(veh, 5) > 0 then
            SetVehicleDoorShut(veh, 5, false)
        else
            SetVehicleDoorOpen(veh, 5, false, false)
        end
    end
end, false)

-----------------------------------------------------------------------------------------

local isBlackedOut = false
local oldBodyDamage = 0

-- function doTheEffect()
-- 	SetTimecycleModifier('BarryFadeOut')
-- 	SetTimecycleModifierStrength(math.min(0.3 / 10, 0.6))
-- 	local myPed = GetPlayerPed(-1)
-- 	local vehicle = GetVehiclePedIsUsing(myPed,false)
-- 	SetVehicleEngineOn(vehicle, false, false, true)
-- 	SetTimecycleModifier("REDMIST_blend")
-- 	TriggerEvent("ZC-Stress:addStress", 12)
-- 	ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.2)
-- 	Wait(4000)
-- 	SetTimecycleModifier("hud_def_desat_Trevor")
-- 	Wait(2500)
-- 	SetTimecycleModifier("")
-- 	SetTransitionTimecycleModifier("")
-- 	StopGameplayCamShaking()
-- 	SetVehicleEngineOn(vehicle, true, false, true)
-- end

-- function blackout()
-- 	if not isBlackedOut then
-- 		isBlackedOut = true

-- 		CreateThread(function()
-- 			DoScreenFadeOut(100)
-- 			while not IsScreenFadedOut() do
-- 				Wait(0)
-- 			end
-- 			Wait(2200)
-- 			DoScreenFadeIn(250)
-- 			isBlackedOut = false
-- 			doTheEffect()
-- 		end)
-- 	end
-- end

-- CreateThread(function()
-- 	while true do
--         local pausadano = 1000

-- 		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

-- 		if vehicle > 0 then
-- 			pausadano = 200

-- 			HideLoadingOnFadeThisFrame()
--             local currentDamage = GetVehicleBodyHealth(vehicle)

--             if currentDamage ~= oldBodyDamage then
--                 if not isBlackedOut and (currentDamage < oldBodyDamage) and ((oldBodyDamage - currentDamage) >= 110) then
--                     blackout()
--                 end
--                 oldBodyDamage = currentDamage
--             end
-- 		else
-- 			oldBodyDamage = 0
-- 		end
--         Wait(pausadano)
-- 	end
-- end)
