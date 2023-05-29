local inUse = false

RegisterNetEvent('ZC-Ambulance:useAnxiolytic', function()
	inUse = true

    local Ped = PlayerPedId()
	local lib, anim = 'mp_suicide', 'pill_fp'
    loadAnimDict("mp_suicide")
    TaskPlayAnim(Ped, lib, anim, 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    Wait(2500)
    ClearPedTasks(Ped)

	CreateThread(function()
		while true do
			Wait(3 * 1000)

			if inUse then
				local ply = PlayerPedId()
				local health = GetEntityHealth(ply)
				if health and health < 200  then
					SetEntityHealth(ply, health + 1)
				else
					inUse = false
				end
			end
		end
	end)
end)

RegisterNetEvent('ZC-Ambulance:useBandage', function(item)
	local playerPed	= PlayerPedId()
	local health = GetEntityHealth(playerPed)

	W.Progressbar("using_bandage", 'Usando venda....', 7000, false, true, {									
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	},{									
		animDict = 'anim@mp_player_intincardancestd@rps@',
		anim = 'idle_a' 
	}, {}, {}, function()
		ClearPedTasksImmediately(PlayerPedId())
		SetEntityHealth(playerPed, health + 25)
		TriggerServerEvent('ZC-Inventory:removeItem', 'bandage', 1, item.slotId)
	end)
	
end)

RegisterNetEvent('ZC-Ambulance:usePill', function()
	local Ped = PlayerPedId()
	local lib, anim = 'mp_suicide', 'pill_fp'
    loadAnimDict("mp_suicide")
    TaskPlayAnim(Ped, lib, anim, 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    DisableAllControlActions(0)
    ExecuteCommand("do Estaría perdiendo la memoria")
    Wait(20000)
    ClearPedTasks(Ped)
end)

RegisterNetEvent('ZC-Ambulance:usePill2', function()
	local Ped = PlayerPedId()
	local lib, anim = 'mp_suicide', 'pill_fp'
    loadAnimDict("mp_suicide")
    TaskPlayAnim(Ped, lib, anim, 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    DisableAllControlActions(0)
    Wait(2500)
    ClearPedTasks(Ped)
end)