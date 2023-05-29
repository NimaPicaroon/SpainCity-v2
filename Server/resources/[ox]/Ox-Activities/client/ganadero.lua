local started = false
local gan = nil
local repeated = {}
local animalblip
local animals = {}
local ganblip
local notif
local done = 0
local ganveh

function ganStart(inicoords, carcoords, vehicle, carh)
    W.Notify('ACTIVIDAD', 'Vamos a empezar el trabajo, te comento lo que debes de hacer. Subete al vehículo que tienes delante y te voy a ir dando instrucciones. Recuerda que en tu menú personal puedes cancelar el trabajo en el F10')
    Wait(2000)
    local hash = GetHashKey(vehicle)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(1)
    end

    ganveh = CreateVehicle(hash, carcoords, carh, true, true)
    TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(ganveh))
    exports['LegacyFuel']:SetFuel(ganveh, 100.0)
    started = true
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        if IsPedInVehicle(ped, ganveh) and started then
            wait = 100
            createGanMarkers(ganveh)
            break
        end
        Wait(wait)
    end
end


function createGanMarkers(ganveh)
    if done ~= Config.Gan.max then 
        gan = math.random(1, #Config.Gan.locations)
        if repeated[gan] then 
            createGanMarkers(ganveh)
        else
            SpawnAnimal('a_c_cow', vector3(Config.Gan.locations[gan].x, Config.Gan.locations[gan].y, Config.Gan.locations[gan].z), Config.Gan.locations[gan].h)
            notif = false
            repeated[gan] = true
            point = true
            while point do
                local wait = 1500
                local pcoords = GetEntityCoords(PlayerPedId(-1))

                dista = GetDistanceBetweenCoords(pcoords, Config.Gan.locations[gan].x, Config.Gan.locations[gan].y, Config.Gan.locations[gan].z, true)
                if dista < 25 then
                    if not notif then
                        W.Notify('ACTIVIDAD', 'Sal del vehículo para coger el cubo')
                        notif = true
                    end

                    local vehcoords = GetEntityCoords(ganveh)

                    distocar = GetDistanceBetweenCoords(pcoords, vehcoords, true)
                    if distocar < 3 and distocar > 0.05 then
                        wait = 0

                        if DoesEntityExist(ganveh) and not IsPedInAnyVehicle(PlayerPedId(-1)) then
                            W.ShowText(vehcoords + vector3(0.0, 0.0, 1.5), '~y~Vehículo\n~w~Sacar cubo', 1, 8)
                            if IsControlJustPressed(1, 38) then
                                RequestAnimDict("amb@prop_human_bum_bin@idle_b")
                                while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do
                                    Wait(1)
                                end
                                TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 0, false, false, false)
                                Wait(2000)
                                ClearPedTasks(PlayerPedId())
                                fobject = CreateObject(GetHashKey("prop_bucket_01a"), pcoords, true, true, true)
                                SetEntityAsMissionEntity(fobject)
                                AttachEntityToEntity(fobject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0, -0.1, -0.15, 0.0, 0.0, 0.0, true, true, true, false, false, true)
                                RequestAnimDict("anim@heists@box_carry@")
                                while not HasAnimDictLoaded("anim@heists@box_carry@") do
                                    Wait(1)
                                end
                                TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
                                Wait(500)
                                SetEntityCollision(fobject, false,true)
                                W.Notify('ACTIVIDAD', 'Ahora ve a ordeñar a la vaca')
                                ord(ganveh, fobject)
                                break
                            end
                        else
                            break
                        end
                    end
                end

                Wait(wait)
            end
        end
    else
        finishGanJob(ganveh)
    end

end

function SpawnAnimal(ped, coords, h)
    local hash = GetHashKey(ped)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(1)
    end

    animalped = CreatePed("PED_TYPE_ANIMAL", ped, coords, h, false, false)
    DecorSetInt(animalped, 'SPAWNEDPED', 1)
    SetEntityAsMissionEntity(animalped, true, true)
    SetBlockingOfNonTemporaryEvents(animalped, true)
    table.insert(animals, animalped)
    CreateAnimalBlip(coords)
    W.Notify('ACTIVIDAD', 'Ve al lugar donde está la vaca')
end

function ord(ganveh, fobject)
    while true do
        local wait = 1500

        local pcoords = GetEntityCoords(PlayerPedId())
        local animalcoords = GetEntityCoords(animalped)
        distgan = GetDistanceBetweenCoords(pcoords, animalcoords, true)
        if distgan < 15 then
            wait = 500
            if distgan < 1.5 then
                wait = 0
                W.ShowText(animalcoords + vector3(0.0, 0.0, 0.5), '~y~Vaca\n~w~Ordeñar', 1, 8)
                if IsControlJustPressed(1, 38) then
                    ClearPedTasks(PlayerPedId())
                    DeleteObject(fobject)

                    local object = CreateObjectNoOffset(GetHashKey('prop_bucket_01a'), animalcoords + vector3(0, 0, -1.0), false, false, false)
                    FreezeEntityPosition(object, true)
                    SetEntityCollision(object, false,true)
                    local ped = PlayerPedId()
                    RemoveBlip(animalblip)

                    RequestAnimDict("amb@medic@standing@tendtodead@idle_a")
                    while not HasAnimDictLoaded("amb@medic@standing@tendtodead@idle_a") do
                        Wait(1)
                    end
                    TaskPlayAnim(ped, "amb@medic@standing@tendtodead@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)

                    FreezeEntityPosition(animalped, true)
                    FreezeEntityPosition(ped, true)
                    Wait(8000)
                    FreezeEntityPosition(animalped, false)
                    FreezeEntityPosition(ped, false)
                    ClearPedTasks(ped)

                    CatchBucket(ganveh, object)
                    W.Notify('ACTIVIDAD', 'Ahora ve a guardar el cubo')
                    break
                end
            end
        end
        Wait(wait)
    end
end

function CatchBucket(ganveh, object)
    while true do
        local wait2 = 1500
        local pcoords = GetEntityCoords(PlayerPedId())
        local buckcoords = GetEntityCoords(object)

        distobucker = GetDistanceBetweenCoords(pcoords, buckcoords, true)
        if distobucker < 3 and distobucker > 0.05 then
            wait2 = 0
            if DoesEntityExist(ganveh) and not IsPedInAnyVehicle(PlayerPedId(-1)) then
                W.ShowText(buckcoords + vector3(0.0, 0.0, 0.5), '~y~Cubo\n~w~Coger', 1, 8)
                if IsControlJustPressed(1, 38) then
                    DeleteObject(object)

                    fobject = CreateObject(GetHashKey("prop_bucket_01a"), pcoords, true, true, true)
                    SetEntityAsMissionEntity(object)
                    AttachEntityToEntity(fobject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0, -0.1, -0.15, 0.0, 0.0, 0.0, true, true, true, false, false, true)
                    RequestAnimDict("anim@heists@box_carry@")
                    while not HasAnimDictLoaded("anim@heists@box_carry@") do
                        Wait(1)
                    end
                    local pos = GetEntityCoords(PlayerPedId(), false)
                    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
                    Wait(500)
                    SetEntityCollision(fobject, false,true)
                    W.Notify('ACTIVIDAD', 'Ahora ve a guardar el cubo en el coche')
                    Save(ganveh, fobject)
                    break
                end
            else
                break
            end
        end

        Wait(wait2)
    end
end

function Save(ganveh, fobject)
    local ped = PlayerPedId()
    fixed = true
    while fixed do
        local wait3 = 1000
        local pcoords = GetEntityCoords(PlayerPedId())
        local vehcoords = GetEntityCoords(ganveh)

        distocar2 = GetDistanceBetweenCoords(pcoords, vehcoords, true)

        if distocar2 < 3 and distocar > 0.05 then
            wait3 = 0
            W.ShowText(vehcoords + vector3(0.0, 0.0, 1.5), '~y~Cubo\n~w~Meter al vehículo', 1, 8)
            if IsControlJustPressed(1, 38) then
                DeleteObject(fobject)
                RequestAnimDict("amb@prop_human_bum_bin@idle_b")
                while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do
                    Wait(1)
                end
                TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 0, false, false, false)
                Wait(3000)
                ClearPedTasks(ped)
                done = done + 1
                createGanMarkers(ganveh)
                fixed = false
            end
        end
        Wait(wait3)
    end
end

function finishGanJob(ganveh)
    W.Notify('ACTIVIDAD', 'Has terminado el trabajo, dirigete de vuelta al Granero')
    CreateGanBlip(Config.Gan.FinishPoint)
    while true do
        local wait4 = 1500
        local pcoords = GetEntityCoords(PlayerPedId())
        dist = GetDistanceBetweenCoords(pcoords, Config.Gan.FinishPoint, true)
        if dist < 8 then
            wait4 = 0
            DrawMarker(27, Config.Gan.FinishPoint - vector3(0,0,0.5), 0, 0, 0, 0, 0, 0, 4.2000, 4.2000, 0.6001, 255, 0, 0, 500, 0, 0, 0, 1)
            if dist < 2 then
                W.ShowText(Config.Gan.FinishPoint + vector3(0.0, 0.0, 0.5), '~y~Vehículo\n~w~Entregar y cobrar', 1, 8)
                if IsControlJustPressed(1, 38) then
                    TriggerEvent("ZC-Character:loadSkin", lastSkin)
                    DeleteVehicle(ganveh)
                    TriggerServerEvent('Ox-Activities:start', 'vacas')
                    done = 0
                    RemoveBlip(ganblip)
                    RemoveBlip(animalblip)
                    repeated = {}
                    for k,v in pairs(animals) do
                        DeleteEntity(animals[k])
                    end
                    animals = {}
                    start()
                    break
                end
            end
        end
        Wait(wait4)
    end
end

RegisterNetEvent('Ox-Activities:cancelarGanadero', function()
    TriggerEvent("ZC-Character:loadSkin", lastSkin)
    DeleteVehicle(ganveh)
    done = 0
    RemoveBlip(ganblip)
    RemoveBlip(animalblip)
    for k,v in pairs(animals) do
        DeleteEntity(animals[k])
    end
    animals = {}
    activity = nil
    repeated = {}
    start()
end)

function CreateGanBlip(pos)
    ganblip = AddBlipForCoord(pos.x, pos.y)
	SetBlipHighDetail(ganblip, true)
	SetBlipSprite(ganblip, 1)
	SetBlipScale(ganblip, 0.7)
	SetBlipColour(ganblip, 0)
	SetBlipRoute(ganblip, true)
	SetBlipRouteColour(ganblip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Granero")
	EndTextCommandSetBlipName(ganblip)
end

function CreateAnimalBlip(pos)
    animalblip = AddBlipForCoord(pos.x, pos.y)
	SetBlipHighDetail(animalblip, true)
	SetBlipSprite(animalblip, 1)
	SetBlipScale(animalblip, 0.7)
	SetBlipColour(animalblip, 0)
	SetBlipRoute(animalblip, true)
	SetBlipRouteColour(animalblip, 1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Vaca")
	EndTextCommandSetBlipName(animalblip)
end
