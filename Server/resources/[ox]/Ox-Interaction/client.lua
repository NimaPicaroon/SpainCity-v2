local _waitLoopTime = 100
PlayerData = {}
local pedVeh

Citizen.CreateThread(function()
    DecorRegister('SPAWNEDPED', 2)
end)

RegisterNetEvent('ZCore:playerLoaded', function()
    PlayerData = W.GetPlayerData()
end)

RegisterNetEvent('ZCore:setJob')
AddEventHandler('ZCore:setJob', function(job)
  	PlayerData.job = job
end)

currentPed = nil
customers = {}
function CheckPedWasCustomerBefore(ped)
	local wasCustomer = false
	if #customers > 10 then
	  table.remove(customers, 1)
	end
	for i,v in ipairs(customers) do
	  	if(v == ped) then
			wasCustomer = true
	  	end
	end
	return wasCustomer
end

function GetCercainPed()
	local cercainPed = nil
	local distanceToHave = 999999
	local peds = GetGamePool("CPed")
	local coordsUser = GetEntityCoords(PlayerPedId())
	for k, v in pairs(peds) do
		if v ~= PlayerPedId() then
			local coordsPed = GetEntityCoords(v)
			local distanceBetween = #(coordsPed - coordsUser)
			if distanceBetween < distanceToHave then
				distanceToHave = distanceBetween
				cercainPed = v
			end
		end
	end
	return distanceToHave, cercainPed -- Devuelve variables a donde las llames
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Wait( 0 )
	end
end

CreateThread(function()
    while true do
        Wait(_waitLoopTime)
        distanceToHave, cercainPed = GetCercainPed()
        if pedVeh then
            local dist = #(GetEntityCoords(pedVeh) - GetEntityCoords(PlayerPedId()))
            if dist > 100.0 then
                DeleteEntity(pedVeh)
                pedVeh = nil
            end
        end

        if IsPlayerFreeAimingAtEntity(PlayerId(), cercainPed) and (IsPedArmed(PlayerPedId(), 4) or IsPedArmed(PlayerPedId(), 1)) then
            _waitLoopTime = 100
            if cercainPed ~= nil and distanceToHave < 10 then
                if GetPedType(cercainPed) ~= 28 and IsPedAPlayer(cercainPed) == false and IsPedDeadOrDying(cercainPed) == false and CheckPedWasCustomerBefore(cercainPed) ~= true then
                    local spawnedWorkPed = false
                    if(DecorExistOn(cercainPed, 'SPAWNEDPED'))then
                        spawnedWorkPed = true
                        _waitLoopTime = 1000
                    end
                    if(spawnedWorkPed == false) then
                        _waitLoopTime = 100
                        if not IsPedInAnyVehicle(cercainPed, true) then
                            if not IsEntityAMissionEntity(cercainPed) then
                                ClearPedTasksImmediately(cercainPed)
                                Wait(200)
                                TaskHandsUp(cercainPed, 15000, 0, 0, true)
                                SetEntityAsMissionEntity(cercainPed, true, true)
                                SetBlockingOfNonTemporaryEvents(cercainPed, true)
                            end
                        elseif IsPedInAnyVehicle(cercainPed, true) and PlayerData.job and PlayerData.job.name ~= 'police' then
                            local localvehicle = GetVehiclePedIsIn(cercainPed, false)
                            if (GetPedInVehicleSeat(localvehicle, -1) == cercainPed) then
                                TaskLeaveVehicle(cercainPed, localvehicle, 1)
                                Wait(2500)
                                SetEntityAsMissionEntity(cercainPed, true, true)
                                SetBlockingOfNonTemporaryEvents(cercainPed, true)
                                TaskHandsUp(cercainPed, 99999, 0, 0, true)
                                pedVeh = cercainPed
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('Ox-Interaction:giveAnimation')
AddEventHandler('Ox-Interaction:giveAnimation', function()
    distanceToHave, cercainPed = GetCercainPed()
    loadAnimDict('mp_common')
    TaskPlayAnim(cercainPed, "mp_common", "givetake1_a", 8.0, 8.0, 2000, 50, 0, false, false, false)
end)

RegisterNetEvent('Ox-Interaction:SurrenderNPC')
AddEventHandler('Ox-Interaction:SurrenderNPC', function()
    distanceToHave, cercainPed = GetCercainPed()
    if cercainPed ~= nil and distanceToHave < 1 then
        loadAnimDict("random@arrests")
        loadAnimDict("random@arrests@busted")
        if (IsEntityPlayingAnim(cercainPed, "random@arrests@busted", "idle_a", 3)) then 
            TaskPlayAnim(cercainPed, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(3000)
            TaskPlayAnim(cercainPed, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0)
            Wait(8000)
            DeleteEntity(cercainPed)
            ExecuteCommand("do El rehén habría salido del establecimiento y se pondría en la pared para el posterior cacheo del Agente")
        else
            TaskPlayAnim(cercainPed, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(1000)
            TaskPlayAnim(cercainPed, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(500)
            TaskPlayAnim(cercainPed, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(1000)
            TaskPlayAnim(cercainPed, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
            SetEntityAsMissionEntity(cercainPed, true, true)
            SetBlockingOfNonTemporaryEvents(cercainPed, true)
            FreezeEntityPosition(cercaninPed, true)
        end
    end
end)