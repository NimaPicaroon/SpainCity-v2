local playerLoaded = false
local spawnP = promise.new()
local spawnCoords

exports('isPlayerLoaded', function()
    return playerLoaded
end)

RegisterNUICallback('closeHud', function(cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        close = true
    })
    if cb.spawn then
        local coords = math.random(1, #W.Spawners[cb.spawn])

        spawnCoords = W.Spawners[cb.spawn][coords]
    end
    spawnP:resolve()
end)

W.HandleSpawn = function(coords, ped, new, dimension)
    W.Thread(function()
        SendNUIMessage({
            show = true,
            spawn = new
        })
        SetNuiFocus(true, true)

        Citizen.Await(spawnP)

        FreezeEntityPosition(PlayerPedId(), true)

        local model = GetHashKey("mp_m_freemode_01")

        if IsModelValid(GetHashKey(ped)) then
            model = GetHashKey(ped)
        end

        RequestModel(model)

        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        SetEntityVisible(PlayerPedId(), true)
        
        local spawn = {}

        if coords and not spawnCoords then
            spawn.x = tonumber(coords.x) + 0.0
            spawn.y = tonumber(coords.y) + 0.0
            spawn.z = tonumber(coords.z) + 0.0

            if coords.heading then
                spawn.heading = coords.heading
            elseif coords.w then
                spawn.heading = coords.w or 0.0
            else
                spawn.heading = 200.0
            end
        else
            spawn.x = tonumber(spawnCoords.x + 0.0)
            spawn.y = tonumber(spawnCoords.y + 0.0)
            spawn.z = tonumber(spawnCoords.z + 0.0)
            spawn.heading = tonumber(spawnCoords.w + 0.0)
        end

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)
        local Ped = PlayerPedId()
        SetEntityCoordsNoOffset(Ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)
        ClearPedTasksImmediately(Ped)
        RemoveAllPedWeapons(Ped)
        ClearPlayerWantedLevel(PlayerId())
        TriggerEvent("MultiCharacters:client:closeNUIdefault", new)

        local time = GetGameTimer()
        while (not HasCollisionLoadedAroundEntity(Ped) and (GetGameTimer() - time) < 5000) do
            Wait(0)
        end

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)
            while not IsScreenFadedIn() do
                Wait(0)
            end
        end

        playerLoaded = true

        if not ped then
            ped = false
        end

        SetEntityHealth(PlayerPedId(), 200)
        SetPedMaxHealth(PlayerPedId(), 200)
        FreezeEntityPosition(PlayerPedId(), false)
        SetCanAttackFriendly(PlayerPedId(), true, false)
		NetworkSetFriendlyFireOption(true)
        ClearPlayerWantedLevel(PlayerId())
        SetMaxWantedLevel(0)
        TriggerEvent('playerSpawned', spawn)
        TriggerServerEvent('ZCore:isPlayerLoaded')
        TriggerEvent("ZCore:playerLoaded")

        for k,v in pairs(W.InitEvents) do
            TriggerServerEvent(v, GetPlayerServerId(PlayerId()))
        end

        TriggerServerEvent("ZCore:giveAllWeapons")
        TriggerServerEvent('ZCore:setDimension', GetPlayerServerId(PlayerId()), 0)
        Wait(3000)
        TriggerServerEvent('ZCore:setDimension', GetPlayerServerId(PlayerId()), dimension)
        Wait(500)
        TriggerEvent('weapons:showBack')
    end)
end

RegisterNetEvent("core:client:spawnAndCreatePlayer", W.HandleSpawn)

RegisterNetEvent('ZCore:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.help then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.arguments, command.help)
		end
	end
end)