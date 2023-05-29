local cats =  {
	{coords = vec3(-573.92, -1054.8, 21.4), h = 95.04, move = false, dict = "creatures@cat@amb@world_cat_sleeping_ground@base", anim = "base", ped = nil},
	{coords = vec3(-584.2, -1062.96, 22.19), h = 243.14, move = false, dict = "creatures@cat@amb@world_cat_sleeping_ledge@base", anim = "base", ped = nil},
	{coords = vec3(-575.14, -1058.04, 21.72), h = 147.14, move = false, dict = "creatures@cat@amb@world_cat_sleeping_ledge@base", anim = "base", ped = nil},
	{coords = vec3(-579.48, -1063.88, 21.93), h = 127.14, move = false, dict = "creatures@cat@amb@world_cat_sleeping_ledge@base", anim = "base", ped = nil},
	{coords = vec3(-568.4, -1053.08, 21.21), h = 176.92, move = "indoor", ped = nil},
}

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
	  	for k,v in pairs(cats) do
			DeleteEntity(v.ped)
		end
	end
end)

LoadAnim = function(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Wait(10)
    end
end

Move = function(type, ped)
	SetEntityNoCollisionEntity(ped, PlayerPedId(), false)
	if type == "indoor" then
		TaskGoToCoordAnyMeans(ped, vector3(-575.12, -1052.96, 20.61), 1.5, 0, 0, 786603, 2)
		local npc_distance = GetDistanceBetweenCoords(GetEntityCoords(ped) , vector3(-575.12, -1052.96, 20.61), false)
		while npc_distance > 0.5 do Wait(100) npc_distance = GetDistanceBetweenCoords(GetEntityCoords(ped), vector3(-575.12, -1052.96, 20.61), false) end
		TaskGoToCoordAnyMeans(ped, vector3(-582.16, -1055.76, 20.69), 1.5, 0, 0, 786603, 2)
		local npc_distance3 = GetDistanceBetweenCoords(GetEntityCoords(ped) , vector3(-582.16, -1055.76, 20.69), false)
		while npc_distance3 > 0.3 do Wait(100) npc_distance3 = GetDistanceBetweenCoords(GetEntityCoords(ped), vector3(-582.16, -1055.76, 20.69), false) end
		TaskPlayAnim(ped, "creatures@cat@amb@world_cat_sleeping_ground@base", "base", 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
		SetEntityCoords(ped, GetEntityCoords(ped) - vec3(0.0, 0.0, 0.71))
		Wait(20000)
		SetEntityCoords(ped, GetEntityCoords(ped) + vec3(0.0, 0.0, 0.71))
		ClearPedTasks(ped)
		TaskGoToCoordAnyMeans(ped, vector3(-575.12, -1052.96, 20.61), 1.5, 0, 0, 786603, 2)
		local npc_distance4 = GetDistanceBetweenCoords(GetEntityCoords(ped) , vector3(-575.12, -1052.96, 20.61), false)
		while npc_distance4 > 0.5 do Wait(100) npc_distance4 = GetDistanceBetweenCoords(GetEntityCoords(ped), vector3(-575.12, -1052.96, 20.61), false) end
		TaskGoToCoordAnyMeans(ped, vector3(-568.84, -1054.32, 20.61), 1.5, 0, 0, 786603, 2)
		local npc_distance5 = GetDistanceBetweenCoords(GetEntityCoords(ped) , vector3(-568.84, -1054.32, 20.61), false)
		while npc_distance5 > 0.5 do Wait(100) npc_distance5 = GetDistanceBetweenCoords(GetEntityCoords(ped), vector3(-568.84, -1054.32, 20.61), false) end
		TaskGoToCoordAnyMeans(ped, vector3(-568.4, -1053.08, 20.61), 1.5, 0, 0, 786603, 2)
		local npc_distance2 = GetDistanceBetweenCoords(GetEntityCoords(ped) , vector3(-568.4, -1053.08, 20.61), false)
		while npc_distance2 > 0.5 do Wait(100) npc_distance2 = GetDistanceBetweenCoords(GetEntityCoords(ped), vector3(-568.4, -1053.08, 20.61), false) end
		SetEntityHeading(ped, 181.44)
		Wait(20000)
		Move(type, ped)
	end
end

CreateThread(function()
	local modelHash = GetHashKey('a_c_cat_01')
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Wait(1)
	end
	for k,v in pairs(cats) do
		if not v.ped then
			v.ped = CreatePed(2, modelHash, v.coords, v.h, false, true)
			DecorSetInt(v.ped, 'SPAWNEDPED', 1)
			SetBlockingOfNonTemporaryEvents(v.ped, true)
			SetPedDiesWhenInjured(v.ped, false)
			SetPedCanPlayAmbientAnims(v.ped, true)
			SetPedCanRagdollFromPlayerImpact(v.ped, false)
			SetEntityInvincible(v.ped, true)
		end
		if not v.move then
			FreezeEntityPosition(v.ped, true)
			LoadAnim(v.dict)
			TaskPlayAnim(v.ped, v.dict, v.anim, 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
		else
			SetEntityNoCollisionEntity(v.ped, PlayerPedId(), false)
			Move(v.move, v.ped)
		end
	end
end)