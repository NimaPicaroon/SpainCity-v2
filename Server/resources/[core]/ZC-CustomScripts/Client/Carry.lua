local carryingBackInProgress = false
local carryAnimNamePlaying = ""
local carryAnimDictPlaying = ""
local carryControlFlagPlaying = 0

RegisterCommand("carry",function(source, args)
	if not carryingBackInProgress then
		local lib = 'missfinale_c2mcs_1'
		local anim1 = 'fin_c2_mcs_1_camman'
		local lib2 = 'nm'
		local anim2 = 'firemans_carry'
		local distans = 0.15
		local distans2 = 0.27
		local height = 0.63
		local spin = 0.0
		local length = 100000
		local controlFlagMe = 49
		local controlFlagTarget = 33
		local animFlagTarget = 1
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)

		if closestPlayer ~= -1 and closestPlayer ~= nil then
			carryingBackInProgress = true
			CarryPerson()
			TriggerServerEvent('CarryPeople:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		else
			W.Notify('CARGAR',"No hay nadie cerca",'error')
		end
	else
		carryingBackInProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if target ~= 0 then
			TriggerServerEvent("CarryPeople:stop",target)
		end
	end
end,false)



RegisterNetEvent('CarryPeople:syncTarget')
AddEventHandler('CarryPeople:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation2
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CarryPeople:syncMe')
AddEventHandler('CarryPeople:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CarryPeople:cl_stop')
AddEventHandler('CarryPeople:cl_stop', function()
	carryingBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

CarryPerson = function()
	Citizen.CreateThread(function()
		while carryingBackInProgress do	
			if carryingBackInProgress then
				if IsControlJustPressed(0, 73) and not IsPedInAnyVehicle(PlayerPedId(), true) then
					carryingBackInProgress = false
					TriggerServerEvent("CarryPeople:stop", target)
					ClearPedSecondaryTask(PlayerPedId())
					DetachEntity(PlayerPedId(), true, false)
				end

				while not IsEntityPlayingAnim(PlayerPedId(), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
					TaskPlayAnim(PlayerPedId(), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
					Citizen.Wait(0)
				end

				DisableControlAction(0, 21, true)
			end

			Citizen.Wait(0)
		end

		DisableControlAction(0, 21, false)
	end)
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end