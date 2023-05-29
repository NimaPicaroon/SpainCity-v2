---Holds Playing animation
---@class Play
Play = {}

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
    local ply = GetPlayerPed(-1)
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
	--print("closest player is dist: " .. tostring(closestDistance))
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

isCarry = false

Llevar = function()
	local player, distance = W.GetClosestPlayer()
	print(player)
	TriggerServerEvent('esx_barbie_lyftupp:lyfteruppn', GetPlayerServerId(player))
	Citizen.Wait(3000)

	local dict = "anim@heists@box_carry@"
	
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	
	local player, distance = W.GetClosestPlayer()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	
	if distance ~= -1 and distance <= 3.0 then
		local closestPlayer, distance = W.GetClosestPlayer()
		TriggerServerEvent('esx_barbie_lyftupp:lyfter', GetPlayerServerId(closestPlayer))		
		
		TaskPlayAnim(GetPlayerPed(-1), dict, "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
		isCarry = true
	else
		ShowNotification('Ho hay jugadores cerca')
	end
end

---Checks for sex of ped
---@return string
local function checkSex()
    local pedModel = GetEntityModel(PlayerPedId())
    for i = 1, #cfg.malePeds do
        if pedModel == GetHashKey(cfg.malePeds[i]) then
            return 'male'
        end
    end
    return 'female'
end

---Notify a person with default notificaiont
---@param message string
local function notify(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(0, 1)
end

--Cancelar animación
RegisterCommand('+HALG', function()
    Load.Cancel()
end, false)

RegisterKeyMapping('+HALG', "Cancelar animación", "keyboard", "X")

---Plays an animation
---@param dance table
---@param particle table
---@param prop table
---@param p table Promise
Play.Animation = function(dance, particle, prop, p)
    if dance then
        -- if cfg.animActive then
        --     Load.Cancel()
        -- end
        Load.Dict(dance.dict)
        if prop then
            Play.Prop(prop)
        end

        if particle then
            local nearbyPlayers = {}
            local players = GetActivePlayers()
            if #players > 1 then
                for i = 1, #players do
                    nearbyPlayers[i] = GetPlayerServerId(players[i])
                end
                cfg.ptfxOwner = true
                TriggerServerEvent('anims:syncParticles', particle, nearbyPlayers)
            else
                Play.Ptfx(PlayerPedId(), particle)
            end
        end

        local loop = cfg.animDuration
        local move = 1
        if cfg.animLoop and not cfg.animDisableLoop then
            loop = -1
        else
            if dance.duration then
                SetTimeout(dance.duration, function() Load.Cancel() end)
            else
                SetTimeout(cfg.animDuration, function() Load.Cancel() end)
            end
        end
        if cfg.animMovement and not cfg.animDisableMovement then
            move = 51
        end
        TaskPlayAnim(PlayerPedId(), dance.dict, dance.anim, 1.5, 1.5, loop, move, 0, false, false, false)
        RemoveAnimDict(dance.dict)
        cfg.animActive = true
        if p then
            p:resolve({passed = true})
        end
        return
    end
    p:reject({passed = false})
end

---Plays a scene
---@param scene table
---@param p table Promise
Play.Scene = function(scene, p)
    if scene then
        local sex = checkSex()
        if not scene.sex == 'both' and not (sex == scene.sex) then
            Play.Notification('info', 'Sex does not allow this animation')
        else
            if scene.sex == 'position' then
                local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
                TaskStartScenarioAtPosition(PlayerPedId(), scene.scene, coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), 0, 1, false)
            else
                TaskStartScenarioInPlace(PlayerPedId(), scene.scene, 0, true)
            end
            cfg.sceneActive = true
            p:resolve({passed = true})
            return
        end
    end
    p:reject({passed = false})
end

---Changes the facial expression
---@param expression table
---@param p table Promise
Play.Expression = function(expression, p)
    if expression then
        SetFacialIdleAnimOverride(PlayerPedId(), expression.expressions, 0)
        p:resolve({passed = true})
        return
    end
    p:reject({passed = false})
end

---Changes the walking anim of a ped
---@param walks table
---@param p table Promise
Play.Walk = function(walks, p)
    if walks then
        Load.Walk(walks.style)
        SetPedMovementClipset(PlayerPedId(), walks.style, cfg.walkingTransition)
        RemoveAnimSet(walks.style)
        SetResourceKvp('savedWalk', walks.style)
        p:resolve({passed = true})
        return
    end
    p:reject({passed = false})
end

---Creates a prop(s)
---@param props table
Play.Prop = function(props)
    if props then
        if props.prop then
            Load.Model(props.prop)
            Load.PropCreation(PlayerPedId(), props.prop, props.propBone, props.propPlacement)
        end
        if props.propTwo then
            Load.Model(props.propTwo)
            Load.PropCreation(PlayerPedId(), props.propTwo, props.propTwoBone, props.propTwoPlacement)
        end
    end
end

---Creates a particle effect
---@param ped number
---@param particles table
Play.Ptfx = function(ped, particles)
    if particles then
        Load.Ptfx(particles.asset)
        UseParticleFxAssetNextCall(particles.asset)
        local attachedProp
        for _, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(ped, v) then
                attachedProp = v
                break
            end
        end
        if not attachedProp and not cfg.ptfxEntitiesTwo[NetworkGetEntityOwner(ped)] and not cfg.ptfxOwner and ped == PlayerPedId() then
            attachedProp = cfg.propsEntities[1] or cfg.propsEntities[2]
        end
        Load.PtfxCreation(ped, attachedProp or nil, particles.name, particles.asset, particles.placement, particles.rgb)
    end
end

---Tries to send event to server for animation
---@param shared table
---@param p table
Play.Shared = function(shared, p)
    if shared then
        local closePed = Load.GetPlayer()
        if closePed then
            local targetId = NetworkGetEntityOwner(closePed)
            Play.Notification('info', 'Request sent to ' .. GetPlayerName(targetId))
            TriggerServerEvent('anims:awaitConfirmation', GetPlayerServerId(targetId), shared)
            p:resolve({passed = true, shared = true})
        end
    end
    p:resolve({passed = false, nearby = true})
end

---Creates a notifications
---@param type string
---@param message string
Play.Notification = function(type, message)
    if cfg.useTnotify then
        exports['t-notify']:Alert({
            style  =  type or 'info',
            message  =  message or 'Something went wrong...'
        })
    else
        notify(message)
    end
end

---Plays shared animation if accepted
---@param shared table
---@param targetId number
---@param owner any
RegisterNetEvent('anims:requestShared', function(shared, targetId, owner)
    if type(shared) == "table" and targetId then
        if cfg.animActive or cfg.sceneActive then
            Load.Cancel()
        end
        Wait(350)

        local targetPlayer = Load.GetPlayer()
        if targetPlayer then
            SetTimeout(shared[4] or 3000, function() cfg.sharedActive = false end)
            cfg.sharedActive = true
            local ped = PlayerPedId()
            if not owner then
                local targetHeading = GetEntityHeading(targetPlayer)
                local targetCoords = GetOffsetFromEntityInWorldCoords(targetPlayer, 0.0, shared[3] + 0.0, 0.0)

                SetEntityHeading(ped, targetHeading - 180.1)
                SetEntityCoordsNoOffset(ped, targetCoords.x, targetCoords.y, targetCoords.z, 0)
            end

            Load.Dict(shared[1])
            TaskPlayAnim(PlayerPedId(), shared[1], shared[2], 2.0, 2.0, shared[4] or 3000, 1, 0, false, false, false)
            RemoveAnimDict(shared[1])
        end
    end
end)

---Loads shared confirmation for target
---@param target number
---@param shared table
RegisterNetEvent('anims:awaitConfirmation', function(target, shared)
    if not cfg.sharedActive then
        Load.Confirmation(target, shared)
    else
        TriggerServerEvent('anims:resolveAnimation', target, shared, false)
    end
end)

---Just notification function but for
---server to send to target
---@param type string
---@param message string
RegisterNetEvent('anims:notify', function(type, message)
    Play.Notification(type, message)
end)

exports('Play', function()
    return Play
end)

RegisterNetEvent('anims:syncPlayerParticles', function(syncPlayer, particle)
    local mainPed = GetPlayerPed(GetPlayerFromServerId(syncPlayer))
    if mainPed > 0 and type(particle) == "table" then
        Play.Ptfx(mainPed, particle)
    end
end)

RegisterNetEvent('anims:syncRemoval', function(syncPlayer)
    local targetParticles = cfg.ptfxEntitiesTwo[tonumber(syncPlayer)]
    if targetParticles then
        StopParticleFxLooped(targetParticles, false)
        cfg.ptfxEntitiesTwo[syncPlayer] = nil
    end
end)

local animDict = "missminuteman_1ig_2"
local anim = "handsup_base"
local handsup = false

RegisterKeyMapping('hu', 'Subir las manos', 'KEYBOARD', 'X')

RegisterCommand('hu', function()
    local ped = PlayerPedId()
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(100)
	end
  if not IsInAnimation then
    if not IsPedInAnyVehicle(ped, false) then
      handsup = not handsup 
      if handsup then
          TaskPlayAnim(ped, animDict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
          if IsPedInAnyVehicle(ped, false) then
              local vehicle = GetVehiclePedIsIn(ped, false)
              if GetPedInVehicleSeat(vehicle, -1) == ped then
                  CreateThread(function()
                      while handsup do
                          Wait(1)
                          DisableControlAction(0, 59, true) -- Disable steering in vehicle
                          DisableControlAction(0,21,true) -- disable sprint
                          DisableControlAction(0,24,true) -- disable attack
                          DisableControlAction(0,25,true) -- disable aim
                          DisableControlAction(0,47,true) -- disable weapon
                          DisableControlAction(0,58,true) -- disable weapon
                          DisableControlAction(0,71,true) -- veh forward
                          DisableControlAction(0,72,true) -- veh backwards
                          DisableControlAction(0,63,true) -- veh turn left
                          DisableControlAction(0,64,true) -- veh turn right
                          DisableControlAction(0,263,true) -- disable melee
                          DisableControlAction(0,264,true) -- disable melee
                          DisableControlAction(0,257,true) -- disable melee
                          DisableControlAction(0,140,true) -- disable melee
                          DisableControlAction(0,141,true) -- disable melee
                          DisableControlAction(0,142,true) -- disable melee
                          DisableControlAction(0,143,true) -- disable melee
                          DisableControlAction(0,75,true) -- disable exit vehicle
                          DisableControlAction(27,75,true) -- disable exit vehicle
                      end
                  end)
              end
          end
      else
          ClearPedTasks(ped)
      end

    end
  else
    handsup = false
    Load.Cancel()
  end
end, false)

