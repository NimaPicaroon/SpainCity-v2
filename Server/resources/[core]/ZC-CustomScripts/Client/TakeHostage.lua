RegisterCommand('k', function()
    ExecuteCommand('e surrender')
end)

local holdingHostageInProgress = false
local hostageAllowedWeapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_PISTOL50",
	"weapon_bottle",
	"weapon_knife",
	"weapon_switchblade",
	"weapon_snspistol",
	"weapon_heavypistol",
	"weapon_revolver",
	"weapon_microsmg"
	--etc add guns you want
}

RegisterCommand("th",function(source, args)
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)

	for i=1, #hostageAllowedWeapons do
		if HasPedGotWeapon(PlayerPedId(), GetHashKey(hostageAllowedWeapons[i]), false) and IsPedArmed(PlayerPedId(), 5) then
			canTakeHostage = true 
			foundWeapon = GetHashKey(hostageAllowedWeapons[i])
			break
		end
	end

	if not canTakeHostage then 
        W.Notify('Rehén', 'Necesitas tener un arma para poder hacer esto', 'error')
	end

	if not holdingHostageInProgress and canTakeHostage then		
		local player = PlayerPedId()	
	
		lib = 'anim@gangops@hostage@'
	
		anim1 = 'perp_idle'
	
		lib2 = 'anim@gangops@hostage@'
	
		anim2 = 'victim_idle'
	
		distans = 0.11 --Higher = closer to camera
		distans2 = -0.24 --higher = left
		height = 0.0
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 49
		animFlagTarget = 50
		attachFlag = true 
		local closestPlayer = GetClosestPlayer(2)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= nil then
			SetCurrentPedWeapon(PlayerPedId(), foundWeapon, true)
			holdingHostageInProgress = true
			holdingHostage = true 
			TUSMUERTOS()
			TriggerServerEvent('cmg3_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
		else
            W.Notify('Rehén', 'No hay nadie cerca que puedas coger como rehén', 'error')
		end
	end
	canTakeHostage = false 
end,false)

exports('getHostage', function()
    return holdingHostage
end)

RegisterNetEvent('cmg3_animations:syncTarget')
AddEventHandler('cmg3_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag,animFlagTarget,attach)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	if holdingHostageInProgress then 
		holdingHostageInProgress = false 
	else 
		holdingHostageInProgress = true
	end
	if beingHeldHostage then 
		beingHeldHostage = false 
	else 
		beingHeldHostage = true 
	end  

	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	if attach then 
		AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	else 
	end
	
	if controlFlag == nil then controlFlag = 0 end
	
	if animation2 == "victim_fail" then 
		SetEntityHealth(PlayerPedId(),0)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
		holdingHostageInProgress = false 
	elseif animation2 == "shoved_back" then 
		holdingHostageInProgress = false 
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
	else
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false	
	end
end)

RegisterNetEvent('cmg3_animations:syncMe')
AddEventHandler('cmg3_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()

	ClearPedSecondaryTask(PlayerPedId())
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	--Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	if animation == "perp_fail" then 
		SetPedShootsAtCoord(PlayerPedId(), 0.0, 0.0, 0.0, 0)
		holdingHostageInProgress = false 
	end
	if animation == "shove_var_a" then 
		Wait(900)
		ClearPedSecondaryTask(PlayerPedId())
		holdingHostageInProgress = false 
	end
end)

RegisterNetEvent('cmg3_animations:cl_stop')
AddEventHandler('cmg3_animations:cl_stop', function()
	holdingHostageInProgress = false
	beingHeldHostage = false 
	holdingHostage = false 
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

function GetPlayers()
    local players = {}

	for _, i in ipairs(GetActivePlayers()) do
        table.insert(players, i)
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

TUSMUERTOS = function()
	Citizen.CreateThread(function()
		while holdingHostage do 
			if GetEntityHealth(PlayerPedId()) <= 102 then --You may need to edit this death check for your server		
				holdingHostage = false
				holdingHostageInProgress = false 
				--ClearPedSecondaryTask(PlayerPedId())
				--DetachEntity(PlayerPedId(), true, false)
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations:stop",target)
				Wait(100)
				releaseHostage()
			end 
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisablePlayerFiring(PlayerPedId(),true)
			local playerCoords = GetEntityCoords(PlayerPedId())
			DrawText3D(playerCoords.x,playerCoords.y,playerCoords.z,"Presione [G] para liberar, [H] para matar")
			if IsDisabledControlJustPressed(0,47) then --release
		
				holdingHostage = false
				holdingHostageInProgress = false 
				--ClearPedSecondaryTask(PlayerPedId())
				--DetachEntity(PlayerPedId(), true, false)
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations:stop",target)
				Wait(100)
				releaseHostage()
			elseif IsDisabledControlJustPressed(0,74) then --kill 
		
				holdingHostage = false
				holdingHostageInProgress = false 	
				--ClearPedSecondaryTask(PlayerPedId())
				--DetachEntity(PlayerPedId(), true, false)		
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations:stop",target)				
				killHostage()
			end

			if beingHeldHostage then 
				DisableControlAction(0,21,true) -- disable sprint
				DisableControlAction(0,24,true) -- disable attack
				DisableControlAction(0,25,true) -- disable aim
				DisableControlAction(0,47,true) -- disable weapon
				DisableControlAction(0,58,true) -- disable weapon
				DisableControlAction(0,263,true) -- disable melee
				DisableControlAction(0,264,true) -- disable melee
				DisableControlAction(0,257,true) -- disable melee
				DisableControlAction(0,140,true) -- disable melee
				DisableControlAction(0,141,true) -- disable melee
				DisableControlAction(0,142,true) -- disable melee
				DisableControlAction(0,143,true) -- disable melee
				DisableControlAction(0,75,true) -- disable exit vehicle
				DisableControlAction(27,75,true) -- disable exit vehicle  
				DisableControlAction(0,22,true) -- disable jump
				DisableControlAction(0,32,true) -- disable move up
				DisableControlAction(0,268,true)
				DisableControlAction(0,33,true) -- disable move down
				DisableControlAction(0,269,true)
				DisableControlAction(0,34,true) -- disable move left
				DisableControlAction(0,270,true)
				DisableControlAction(0,35,true) -- disable move right
				DisableControlAction(0,271,true)
			end
			Wait(0)
		end
	end)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.19, 0.19)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function releaseHostage()
	local player = PlayerPedId()	
	lib = 'reaction@shove'
	anim1 = 'shove_var_a'
	lib2 = 'reaction@shove'
	anim2 = 'shoved_back'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 100000
	controlFlagMe = 120
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= nil then
		TriggerServerEvent('cmg3_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	else
	end
end 

function killHostage()
	local player = PlayerPedId()	
	lib = 'anim@gangops@hostage@'
	anim1 = 'perp_fail'
	lib2 = 'anim@gangops@hostage@'
	anim2 = 'victim_fail'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 0.2
	controlFlagMe = 168
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= nil then
		TriggerServerEvent('cmg3_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	else
	end	
end

local piggyBackInProgress = false
local piggyBackAnimNamePlaying = ""
local piggyBackAnimDictPlaying = ""
local piggyBackControlFlagPlaying = 0

RegisterCommand("piggyback",function(source, args)
	if not piggyBackInProgress then
		local player = PlayerPedId()	
		lib = 'anim@arena@celeb@flat@paired@no_props@'
		anim1 = 'piggyback_c_player_a'
		anim2 = 'piggyback_c_player_b'
		distans = -0.07
		distans2 = 0.0
		height = 0.45
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= -1 and closestPlayer ~= nil then
			piggyBackInProgress = true
			TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		else 
            W.Notify('Rehén', 'No hay nadie cerca que puedas coger como rehén', 'error')
		end
	else
		piggyBackInProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if target ~= 0 then 
			TriggerServerEvent("cmg2_animations:stop",target)
		end
	end
end,false)

RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	piggyBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	piggyBackAnimNamePlaying = animation2
	piggyBackAnimDictPlaying = animationLib
	piggyBackControlFlagPlaying = controlFlag
end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	piggyBackAnimNamePlaying = animation
	piggyBackAnimDictPlaying = animationLib
	piggyBackControlFlagPlaying = controlFlag
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	piggyBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if piggyBackInProgress then 
			while not IsEntityPlayingAnim(PlayerPedId(), piggyBackAnimDictPlaying, piggyBackAnimNamePlaying, 3) do
				TaskPlayAnim(PlayerPedId(), piggyBackAnimDictPlaying, piggyBackAnimNamePlaying, 8.0, -8.0, 100000, piggyBackControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end
		end
		Wait(0)
	end
end)

--[[local morreoInProgress = false
local morreoAnimNamePlaying = ""
local morreoAnimDictPlaying = ""
local morreoControlFlagPlaying = 0

RegisterCommand("morreo",function(source, args)
	if not morreoInProgress then
		local player = PlayerPedId()	
		lib = 'karxem@couple_m'
		lib2 = 'karxem_couple_m_clip'
		anim1 = 'karxem@couple_f'
		anim2 = 'karxem_couple_f_clip'
		distans = 0.2
		distans2 = -0.2
		height = 0.45
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= -1 and closestPlayer ~= nil then
			morreoInProgress = true
			TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib, lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		else 
            W.Notify('Rehén', 'No hay nadie cerca que puedas besar', 'error')
		end
	else
		morreoInProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if target ~= 0 then 
			TriggerServerEvent("cmg2_animations:stop",target)
		end
	end
end,false)]]