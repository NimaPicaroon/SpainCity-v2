Gym = { }
Gym.__data = { inAction = nil, resting = nil, cancel = nil, resting_time = 0 }
Gym.__index = Gym

-- @points

CreateThread(function()
    for k,v in pairs(Settings.Bikes) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
		SetBlipSprite (blip, 226)
		SetBlipScale  (blip, 0.7)
		SetBlipDisplay(blip, 4)
        SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Alquiler de Bicicletas')
		EndTextCommandSetBlipName(blip)
    end

    local inZone = false
    local shown = false

    while true do
        local msec = 750
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        inZone = false

        for k,v in pairs(Settings.Bikes) do
            local dist = #(playerPos - vec3(v.coords.x, v.coords.y, v.coords.z))

            -- if dist < 2 then
            --     msec = 0
            --     inZone = true
            --     W.ShowText(vec3(v.coords.x, v.coords.y, v.coords.z) + vector3(0,0,1), '~y~Alquiler\n~w~Alquila una bicicleta', 0.5, 8)
            if dist < 13 and dist >= 1.3 then
                msec = 0
                inZone = false
                DrawMarker(38, v.coords.x, v.coords.y, v.coords.z +0.5, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.5, 0.5, 0.5, 255, 203, 65, 255, false, true, 2, nil, nil, false)
                elseif dist < 1.3 then
                    msec = 0
                    inZone = true
                    W.ShowText(vec3(v.coords.x, v.coords.y, v.coords.z) + vector3(0,0,1), '~y~Alquiler\n~w~Alquila una bicicleta', 0.5, 8)
                    DrawMarker(38, v.coords.x, v.coords.y, v.coords.z +0.5, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.5, 0.5, 0.5, 255, 203, 65, 255, false, true, 2, nil, nil, false)

                    if IsControlJustPressed(0, 38) then
                        local elements = {
                            {label = 'Moto Faggio (200€)', price = 100, value = 'faggio'},
                            {label = 'BMX (100$)', price = 100, value = 'bmx'},
                            {label = 'Cruiser (50$)', price = 50, value = 'cruiser'},
                        }
                        W.OpenMenu('Alquiler', 'bikes', elements, function(data, name)
                            local ply_data = W.GetPlayerData()
                            
                            if tonumber(ply_data.money['money']) >= tonumber(data.price) then
                                TriggerServerEvent('ZC-Gym:rentBike', tonumber(data.price))
                                local model = GetHashKey(data.value)
                                RequestModel(model)
                                while not HasModelLoaded(model) do Wait(0) end
                                local bike = CreateVehicle(model, vec3(v.coords.x, v.coords.y, v.coords.z), v.coords.w, true)
                                TaskWarpPedIntoVehicle(PlayerPedId(), bike, -1)
                                SetModelAsNoLongerNeeded(model)
                                TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(bike))
                                W.Notify('ALQUILER', 'Has alquilado la ~y~'..data.value:upper()..'~w~  por ~g~$'..data.price..'~w~', 'verify')
                                W.DestroyMenu(name)
                            else
                            W.Notify('ALQUILER', '~r~No~w~ tienes suficiente dinero', 'error')
                        end
                    end)
                end
            end
        end

        if inZone and not shown then
            shown = true

            exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_gym_bmx')
        elseif not inZone and shown then
            exports['ZC-HelpNotify']:close('interact_gym_bmx')

            shown = false
        end

        Citizen.Wait(msec)
    end
end)

OwnData = {}

RegisterNetEvent('ZCore:setJob', function(job, lastJob)
	OwnData.job = job
end)

Gym.Init = function()

    CreateThread(function()
        local inZone = false
        local shown = false
        local typePoint = nil

        while true do
            local msec = 3000
            local foundGym
            local ply = PlayerPedId()
            local coords = GetEntityCoords(ply)

            typePoint = nil
            inZone = false
            for k,v in pairs(Settings.Gyms) do
                local dist = #(coords - v.shop)

                if dist < 80 then
                    foundGym = k
                end
            end

            if foundGym and Gym.__data.inAction == nil then
                msec = 1000
                for k,v in pairs(Settings.Gyms[foundGym].points) do
                    local dist = #(coords - v.coords)
                    if dist < 2 then
                        msec = 0
                        W.ShowText(v.coords + vector3(0,0,0.5), '~y~'..v.action..'\n~w~'..v.message, 0.5, 8)
                        inZone = true
                        typePoint = 'exercise'
                        if dist < 1 then
                            if IsControlJustPressed(0, 38) then
                                local membership = Gym.HaveMembership()
                                if membership == true then
                                    Gym.Action(v.action, v)
                                elseif membership == 'rob' then
                                    W.Notify('GIMNASIO', 'Parece ser que esta membresía ~r~no es tuya~w~', 'error')
                                else
                                    W.Notify('GIMNASIO', 'Necesitas una ~y~membresía~w~ de nuestro gimnasio', 'error')
                                end
                            end
                        end
                    end
                end

                 local dist = #(coords - Settings.Gyms[foundGym].shop)

                 if dist < 2 then
                     msec = 0
                     inZone = true
                     W.ShowText(Settings.Gyms[foundGym].shop + vector3(0,0,0.5), '~y~Tienda\n~w~Comprar productos', 0.5, 8)

                     if dist < 1 then
                         print('Hola')
                    --     if IsControlJustPressed(0, 38) and OwnData.job.name == "gymsur" or OwnData.job.name == "gymnorte" then
                        if IsControlJustPressed(0, 38) then
                             Gym.Shop()
                         end
                     end
                 end
            end

            if inZone and not shown then
                shown = true
    
                if not typePoint then
                    exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_gym')
                else
                    exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para ejercitarte', 'interact_exercisegym')
                end
            elseif not inZone and shown then
                exports['ZC-HelpNotify']:close('interact_gym')
                exports['ZC-HelpNotify']:close('interact_exercisegym')

                shown = false
            end

            Wait(msec)
        end
    end)
end

Gym.Init()

Gym.HaveMembership = function ()
    local inventory = W.GetItemsForInventory()

    for k,v in pairs(inventory.data) do
        if v.name == 'membership' then
            return true
        end
    end

    return false
end

-- @actions
Gym.InitSkillbar = function(cb)
    TriggerEvent('ZC-Skillbar:startSkillbar', function(success)
        cb(success)
    end, 3, math.random(5,10))
end

Gym.Shop = function()
    local elements = {
        {label = 'Membresia ($250)', price = 250, value = 'membership'},
        --{label = 'Powerade ($1)', price = 1, value = 'powerade'}
    }
    W.OpenMenu('Tienda', 'shop', elements, function(data, name)
        if data.value ~= 'membership' then
            W.OpenDialog('Cantidad', 'amount', function(amount)
                W.CloseDialog()
                if amount and tonumber(amount) then
                    TriggerServerEvent('ZC-Gym:buyItem', data, amount)
                else
                    W.Notify('TIENDA', 'Cantidad ~r~inválida~w~', 'error')
                end
            end)
        else
            TriggerServerEvent('ZC-Gym:buyItem', data, 1)
        end
        W.DestroyMenu(name)
    end)
end

Gym.Bike = function(site)
    local elements = {
        {label = 'BMX ($100)', price = 100, value = 'bmx'},
        {label = 'Cruiser ($50)', price = 50, value = 'cruiser'},
        {label = 'Scorcher ($100)', price = 100, value = 'scorcher'},
    }
    W.OpenMenu('Alquiler', 'bikes', elements, function(data, name)
        local ply_data = W.GetPlayerData()

        if tonumber(ply_data.money['money']) > tonumber(data.price) then
            TriggerServerEvent('ZC-Gym:rentBike', tonumber(data.price))
            local model = GetHashKey(data.value)
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
            local bike = CreateVehicle(model, vec3(site.coords.x, site.coords.y, site.coords.z), site.coords.w, true)
            TriggerServerEvent('ZCore:ignoreLocks', NetworkGetNetworkIdFromEntity(bike))
            TaskWarpPedIntoVehicle(PlayerPedId(), bike, -1)
            SetModelAsNoLongerNeeded(model)
            W.Notify('ALQUILER', 'Has alquilado la ~y~'..data.value:upper()..'~w~  por ~g~$'..data.price..'~w~', 'verify')
            W.DestroyMenu(name)
        else
            W.Notify('ALQUILER', '~r~No~w~ tienes suficiente dinero', 'error')
        end
    end)
end

Gym.Action = function(action, data)
    if not Gym.__data.inAction and Gym.__data.resting ~= true and not IsPedInAnyVehicle(PlayerPedId(), true) then
        if action ~= 'Velocidad' then
            SendNUIMessage({
                show_percentage = true
            })
        end
        if action == 'Yoga' then
            Gym.Yoga()
        elseif action == 'Velocidad' then
            Gym.Speed(data)
        elseif action == 'Dominadas' then
            Gym.Push_Up(data)
        elseif action == 'Pesas' then
            Gym.Weights(data)
        elseif action == 'Abdominales' then
            Gym.Situps(data)
        elseif action == 'Flexiones' then
            Gym.Flex(data)
        end
    else
        W.Notify('DESCANSO', 'Debes ~y~descansar~w~ para volver a entrenar')
    end
end

Gym.AddSkill = function(type, attemps, time)
    Gym.__data.inAction = nil
    local points = Settings.Skills[type].points

    if attemps and attemps < 6 then
        points = points + 2
    end

    if time and time < 75 then
        points = points + 2
    end

    TriggerServerEvent('ZC-Gym:addSkill', type, points)
    if type == 'strength' then
        TriggerServerEvent("ZC-Stats:updateWeight2")
    end
    W.Notify('HABILIDADES', 'Has subido ~g~x'..points..'~w~ puntos de ~y~'.. Settings.Skills[type].label, 'verify')
end

-- @exercises
Gym.Speed = function(data)
    local ply = PlayerPedId()
    SendNUIMessage({
        show_time = true
    })
    Speed.InitCam(data.specificZone)

    Wait(500)

    FreezeEntityPosition(ply, false)

    Wait(100)
    W.Notify('GIMNASIO', '¡Puedes empezar ya!')

    Gym.__data.inAction = 0
    Speed.__data.time = 0

    while true do
        local msec = 1000
        local ply = PlayerPedId()

        if Gym.__data.cancel then
            break
        end

        if IsPedInAnyVehicle(ply, true) then
            Gym.__data.cancel = true
        end

        local ply_coords = GetEntityCoords(ply)
        local dist = #(ply_coords - vector3(-1305.16, -1388.76, 4))

        if dist < 25 then
            msec = 500
            if dist < 16 then
                msec = 0
                DrawMarker(4, vector3(-1305.16, -1388.76, 4), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(2.5, 2.5, 1.5), 0, 255, 0, 255, true, false, 2, true, false, false)
                if dist < 2 then
                    break
                end
            end
        end

        Wait(msec)
    end
    W.Notify('GIMNASIO', '¡Ahora vuelve al punto de inicio!')
    while true do
        local msec = 1000
        if Gym.__data.cancel then
            break
        end

        if IsPedInAnyVehicle(ply, true) then
            Gym.__data.cancel = true
        end

        local ply_coords = GetEntityCoords(ply)
        local dist = #(ply_coords - vector3(-1213.32, -1533.56, 5))

            if dist < 25 then
                msec = 500
                if dist < 16 then
                    msec = 0
                    DrawMarker(4, vector3(-1213.32, -1533.56, 5), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(2.5, 2.5, 1.5), 0, 255, 0, 255, true, false, 2, true, false, false)
                    if dist < 2 then
                        Gym.__data.inAction = 100
                        break
                    end
                end
            end

        Wait(msec)
    end

    SendNUIMessage({
        hide = true
    })

    if not Gym.__data.cancel then
        Gym.__data.resting = true
        Gym.AddSkill('stamina', nil, Speed.__data.time)
        Speed.__data.time = nil
    else
        Gym.__data.inAction = nil
        Gym.__data.cancel = nil
        Speed.__data.time = nil
    end
end

Gym.Push_Up = function(data)
    Gym.__data.inAction = 0
    local ply = PlayerPedId()

    local animInfo = {
        ["idleDict"] = "amb@prop_human_muscle_chin_ups@male@idle_a",
        ["idleAnim"] = "idle_a",
        ["actionDict"] = "amb@prop_human_muscle_chin_ups@male@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 3000,
        ["enterDict"] = "amb@prop_human_muscle_chin_ups@male@enter",
        ["enterAnim"] = "enter",
        ["enterTime"] = 1600,
        ["exitDict"] = "amb@prop_human_muscle_chin_ups@male@exit",
        ["exitAnim"] = "exit",
        ["exitTime"] = 3700,
    }

    TaskGoToCoordAnyMeans(ply, data.coords, 1.5, 0, 0, 786603, 2)
    Wait(1000)
    SetEntityHeading(ply, data.heading)
    FreezeEntityPosition(ply, true)

    Gym.LoadAnim(animInfo["idleDict"])
    Gym.LoadAnim(animInfo["enterDict"])
    Gym.LoadAnim(animInfo["exitDict"])
    Gym.LoadAnim(animInfo["actionDict"])

    TaskPlayAnim(ply, animInfo["enterDict"], animInfo["enterAnim"], 8.0, -8.0, animInfo["enterTime"], 0, 0.0, 0, 0, 0)
    Wait(animInfo["enterTime"])

    while Gym.__data.inAction < 100 do
        if Gym.__data.cancel then
            break
        end
        TaskPlayAnim(ply, animInfo["idleDict"], animInfo["idleAnim"], 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)

        if Gym.__data.inAction < 100 then
            if IsControlJustPressed(0, 38) then
                TaskPlayAnim(ply, animInfo["actionDict"], animInfo["actionAnim"], 8.0, -8.0, animInfo["actionTime"], 0, 0.0, 0, 0, 0)
                Wait(animInfo["actionTime"])
                Gym.__data.inAction  = Gym.__data.inAction  + math.random(10, 18)
            end
        else
            break
        end
        Wait(0)
    end

    FreezeEntityPosition(ply, false)
    TaskPlayAnim(ply, animInfo["exitDict"], animInfo["exitAnim"], 8.0, -8.0, animInfo["exitTime"], 0, 0.0, 0, 0, 0)
    SendNUIMessage({
        hide = true
    })

    if not Gym.__data.cancel then
        Gym.__data.resting = true
        Gym.AddSkill('strength', nil, nil)
    else
        Gym.__data.inAction = nil
        Gym.__data.cancel = nil
    end
end

Gym.Situps = function(data)
    Gym.__data.inAction = 0
    local ply = PlayerPedId()

    local animInfo = {
        ["idleDict"] = "amb@world_human_sit_ups@male@idle_a",
        ["idleAnim"] = "idle_a",
        ["actionDict"] = "amb@world_human_sit_ups@male@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 3400,
        ["enterDict"] = "amb@world_human_sit_ups@male@enter",
        ["enterAnim"] = "enter",
        ["enterTime"] = 4200,
        ["exitDict"] = "amb@world_human_sit_ups@male@exit",
        ["exitAnim"] = "exit", 
        ["exitTime"] = 3700
    }

    TaskGoToCoordAnyMeans(ply, data.coords, 1.5, 0, 0, 786603, 2)
    Wait(1000)
    SetEntityHeading(ply, data.heading)
    FreezeEntityPosition(ply, true)

    Gym.LoadAnim(animInfo["idleDict"])
    Gym.LoadAnim(animInfo["enterDict"])
    Gym.LoadAnim(animInfo["exitDict"])
    Gym.LoadAnim(animInfo["actionDict"])

    TaskPlayAnim(ply, animInfo["enterDict"], animInfo["enterAnim"], 8.0, -8.0, animInfo["enterTime"], 0, 0.0, 0, 0, 0)
    Wait(animInfo["enterTime"])

    while Gym.__data.inAction < 100 do
        if Gym.__data.cancel then
            break
        end
        TaskPlayAnim(ply, animInfo["idleDict"], animInfo["idleAnim"], 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)

        if Gym.__data.inAction < 100 then
            if IsControlJustPressed(0, 38) then
                TaskPlayAnim(ply, animInfo["actionDict"], animInfo["actionAnim"], 8.0, -8.0, animInfo["actionTime"], 0, 0.0, 0, 0, 0)
                Wait(animInfo["actionTime"])
                Gym.__data.inAction  = Gym.__data.inAction  + math.random(10, 20)
            end
        else
            break
        end
        Wait(0)
    end

    FreezeEntityPosition(ply, false)
    TaskPlayAnim(ply, animInfo["exitDict"], animInfo["exitAnim"], 8.0, -8.0, animInfo["exitTime"], 0, 0.0, 0, 0, 0)
    SendNUIMessage({
        hide = true
    })

    if not Gym.__data.cancel then
        Gym.__data.resting = true
        Gym.AddSkill('strength', nil, nil)
    else
        Gym.__data.inAction = nil
        Gym.__data.cancel = nil
    end
end

Gym.Flex = function(data)
    Gym.__data.inAction = 0
    local ply = PlayerPedId()

    local animInfo = {
        ["idleDict"] = "amb@world_human_push_ups@male@idle_a",
        ["idleAnim"] = "idle_c",
        ["actionDict"] = "amb@world_human_push_ups@male@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 1300,
        ["enterDict"] = "amb@world_human_push_ups@male@enter",
        ["enterAnim"] = "enter",
        ["enterTime"] = 3050,
        ["exitDict"] = "amb@world_human_push_ups@male@exit",
        ["exitAnim"] = "exit",
        ["exitTime"] = 3500
    }

    TaskGoToCoordAnyMeans(ply, data.coords, 1.5, 0, 0, 786603, 2)
    Wait(1000)
    SetEntityHeading(ply, data.heading)
    FreezeEntityPosition(ply, true)

    Gym.LoadAnim(animInfo["idleDict"])
    Gym.LoadAnim(animInfo["enterDict"])
    Gym.LoadAnim(animInfo["exitDict"])
    Gym.LoadAnim(animInfo["actionDict"])

    TaskPlayAnim(ply, animInfo["enterDict"], animInfo["enterAnim"], 8.0, -8.0, animInfo["enterTime"], 0, 0.0, 0, 0, 0)
    Wait(animInfo["enterTime"])

    while Gym.__data.inAction < 100 do
        if Gym.__data.cancel then
            break
        end
        TaskPlayAnim(ply, animInfo["idleDict"], animInfo["idleAnim"], 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)

        if Gym.__data.inAction < 100 then
            if IsControlJustPressed(0, 38) then
                TaskPlayAnim(ply, animInfo["actionDict"], animInfo["actionAnim"], 8.0, -8.0, animInfo["actionTime"], 0, 0.0, 0, 0, 0)
                Wait(animInfo["actionTime"])
                Gym.__data.inAction  = Gym.__data.inAction  + math.random(2, 8)
            end
        else
            break
        end
        Wait(0)
    end

    FreezeEntityPosition(ply, false)
    TaskPlayAnim(ply, animInfo["exitDict"], animInfo["exitAnim"], 8.0, -8.0, animInfo["exitTime"], 0, 0.0, 0, 0, 0)
    SendNUIMessage({
        hide = true
    })

    if not Gym.__data.cancel then
        Gym.__data.resting = true
        Gym.AddSkill('strength', nil, nil)
    else
        Gym.__data.inAction = nil
        Gym.__data.cancel = nil
    end
end

Gym.Weights = function(data)
    Gym.__data.inAction = 0
    local ply = PlayerPedId()

    local animInfo = {
        ["idleDict"] = "amb@world_human_muscle_free_weights@male@barbell@idle_a",
        ["idleAnim"] = "idle_c",
        ["actionDict"] = "amb@world_human_muscle_free_weights@male@barbell@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 3500
    }

    TaskGoToCoordAnyMeans(ply, data.coords, 1.5, 0, 0, 786603, 2)
    Wait(1000)
    SetEntityHeading(ply, data.heading)
    FreezeEntityPosition(ply, true)

    Gym.LoadAnim(animInfo["idleDict"])
    Gym.LoadAnim(animInfo["actionDict"])

    local prop = CreateObject(3754967026, data.coords, true, true, true)
    FreezeEntityPosition(prop, true)
    SetEntityAsMissionEntity(prop)
    SetEntityCollision(prop, false, true)
    local prop2 = CreateObject(3754967026, data.coords, true, true, true)
    FreezeEntityPosition(prop2, true)
    SetEntityAsMissionEntity(prop2)
    SetEntityCollision(prop2, false, true)

    AttachEntityToEntity(prop2, ply, GetPedBoneIndex(ply, 26610), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
    AttachEntityToEntity(prop, ply, GetPedBoneIndex(ply, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
    --AttachEntityToEntity(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)

    while Gym.__data.inAction < 100 do
        if Gym.__data.cancel then
            break
        end
        TaskPlayAnim(ply, animInfo["idleDict"], animInfo["idleAnim"], 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)

        if Gym.__data.inAction < 100 then
            if IsControlJustPressed(0, 38) then
                TaskPlayAnim(ply, animInfo["actionDict"], animInfo["actionAnim"], 8.0, -8.0, animInfo["actionTime"], 0, 0.0, 0, 0, 0)
                Wait(animInfo["actionTime"])
                Gym.__data.inAction  = Gym.__data.inAction  + math.random(4, 16)
            end
        else
            break
        end
        Wait(0)
    end

    DeleteEntity(prop)
    DeleteEntity(prop2)
    FreezeEntityPosition(ply, false)
    ClearPedTasks(ply)
    SendNUIMessage({
        hide = true
    })

    if not Gym.__data.cancel then
        Gym.__data.resting = true
        Gym.AddSkill('strength', nil, nil)
    else
        Gym.__data.inAction = nil
        Gym.__data.cancel = nil
    end
end

Gym.Yoga = function()
    Gym.__data.inAction = 0
    local attemps = 0
    local passed

    local ply = PlayerPedId()
    FreezeEntityPosition(ply, true)

    while Gym.__data.inAction < 100 do
        if Gym.__data.cancel then
            break
        end

        if Gym.__data.inAction < 100 then
            Wait(math.random(5000, 6000))

            if Gym.__data.cancel then
                break
            end

            TaskStartScenarioInPlace(ply, "world_human_yoga", 0, true)

            Gym.InitSkillbar(function(success)
                passed = success
            end)

            local p = promise.new()
            while true do
                if Gym.__data.cancel then
                    p:resolve()
                    break
                end

                local wait = 1000
                if passed == true then
                    attemps = attemps + 1
                    p:resolve()
                    ClearPedTasks(ply)
                    break
                elseif passed == false then
                    passed = nil
                    attemps = attemps + 1
                    Wait(math.random(3000, 4000))
                    Gym.InitSkillbar(function(success)
                        passed = success
                    end)
                end
                Wait(wait)
            end

            Citizen.Await(p)
            ClearPedTasks(ply)
            passed = nil
            Gym.__data.inAction = Gym.__data.inAction + math.random(20, 30)
        end
    end

    FreezeEntityPosition(ply, false)
    SendNUIMessage({
        hide = true
    })

    if not Gym.__data.cancel then
        Gym.__data.resting = true
        Gym.AddSkill('stress', attemps)
    else
        Gym.__data.inAction = nil
        Gym.__data.cancel = nil
    end
end

-- @others

Gym.LoadAnim = function(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Wait(10)
    end
end