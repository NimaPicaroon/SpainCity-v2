local started = false
local elec = nil
local repeated = {}
local pblip
local object
local attach
local notif
local done = 0
local elecveh

function elecStart(inicoords, carcoords, vehicle, carh)
    W.Notify('ACTIVIDAD', 'Vamos a empezar el trabajo, te comento lo que debes de hacer. Subete al vehículo que tienes delante y te voy ir dando instrucciones. Usa SHIFT y CONTROL para user el carguero. Recuerda que en tu menú personal puedes cancelar el trabajo en el F10')
    Wait(2000)
    local hash = GetHashKey(vehicle)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(1)
    end

    elecveh = CreateVehicle(hash, carcoords, carh, true, true)
    TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(elecveh))
    exports['LegacyFuel']:SetFuel(elecveh, 100.0)
    started = true
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        if IsPedInVehicle(ped, elecveh) and started then
            W.Notify('ACTIVIDAD', 'Ve a reparar las farolas')
            createMarkers(elecveh)
            break
        end
        Wait(wait)
    end

end

function createMarkers(elecveh)
    if done ~= Config.Elec.MaxRepairs then
        elec = math.random(1, #Config.Elec.locations)
        if repeated[elec] then
            createMarkers(elecveh)
        else
            notif = false
            repeated[elec] = true
            CreateElecBlip(Config.Elec.locations[elec])
            local point = true
            while point do
                local wait = 1500
                local pcoords = GetEntityCoords(PlayerPedId())

                dist = GetDistanceBetweenCoords(pcoords, Config.Elec.locations[elec].x, Config.Elec.locations[elec].y, Config.Elec.locations[elec].z, true)
                if dist < 8 then
                    if not notif then
                        W.Notify('ACTIVIDAD', 'Sal del vehículo para coger la escalera')
                        notif = true
                    end

                    local vehcoords = GetEntityCoords(elecveh)
                    distocar = GetDistanceBetweenCoords(pcoords, vehcoords, true)
                    if distocar < 3 and distocar > 0.05 then
                        wait = 0
                        local vehcoords = GetEntityCoords(elecveh)
                        if DoesEntityExist(elecveh) and not IsPedInAnyVehicle(PlayerPedId()) then
                            W.ShowText(vehcoords + vector3(0.0, 0.0, 1.5), '~y~Escalera\n~w~Sacar', 1, 8)
                            if IsControlJustPressed(1, 38) then

                                RequestAnimDict("amb@prop_human_bum_bin@idle_b")
                                while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do
                                    Wait(1)
                                end
                                TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 0, false, false, false)
                                Wait(2000)
                                ClearPedTasks(PlayerPedId())
                                fobject = CreateObject(GetHashKey("hw1_06_ldr_"), pcoords, true, true, true)
                                SetEntityAsMissionEntity(object)
                                AttachEntityToEntity(fobject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -2.5, -0.50, 0.0, 0.0, 90.0, 0.0, true, true, true, false, false, true)
                                RequestAnimDict("anim@heists@box_carry@")
                                while not HasAnimDictLoaded("anim@heists@box_carry@") do
                                    Wait(1)
                                end
                                TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
                                Wait(2000)
                                attach(elecveh, fobject)
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
        finishElecJob(elecveh)
    end
end


function attach(elecveh, fobejct)
    while true do
        local wait = 1500
        local pcoords = GetEntityCoords(PlayerPedId())
        dist = GetDistanceBetweenCoords(pcoords, Config.Elec.locations[elec].x, Config.Elec.locations[elec].y, Config.Elec.locations[elec].z, true)
        if dist < 2 then
            wait = 0
            W.ShowText(vector3(Config.Elec.locations[elec].x, Config.Elec.locations[elec].y, Config.Elec.locations[elec].z + 1.0), '~y~Escalera\n~w~Colocar', 1, 8)
            if IsControlJustPressed(1, 38) then
                elecid = elec
                ClearPedTasks(PlayerPedId())
                DeleteObject(fobejct)
                createObject(elecveh)
                break
            end
        end
        Wait(wait)
    end
end

function createObject(elecveh)
    local ped = PlayerPedId()
    RemoveBlip(pblip)
    RequestAnimDict("amb@prop_human_bum_bin@idle_b")
    while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do
        Wait(1)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 0, false, false, false)
    Wait(3000)
    ClearPedTasks(ped)
    local object = CreateObjectNoOffset(GetHashKey('hw1_06_ldr_'), Config.Elec.locations[elec].x, Config.Elec.locations[elec].y, Config.Elec.locations[elec].z, true, false, false)
    SetEntityHeading(object, Config.Elec.locations[elec].h)

    while true do
        wait = 1000
        local pcoords = GetEntityCoords(PlayerPedId())
        dist = GetDistanceBetweenCoords(pcoords, Config.Elec.locations[elec].x, Config.Elec.locations[elec].y, Config.Elec.locations[elec].z+4, true)
        if dist < 1 then
            wait = 0
            W.ShowText(vector3(Config.Elec.locations[elec].x, Config.Elec.locations[elec].y, Config.Elec.locations[elec].z+4), '~y~Farola\n~w~Arreglar', 1, 8)
            if IsControlJustPressed(1, 38) then
                fixFar(object, elecveh)
                break
            end
        end
        Wait(wait)
    end

end

function fixFar(object, elecveh)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    ClearPedTasks(ped)
    RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
    while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
        Wait(10)
    end
    TaskPlayAnim(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, 8.0, -1, 50, 0, false, false, false)
    Wait(4000)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)

    fixed = true
    while fixed do
        local wait = 1000
        local pcoords = GetEntityCoords(PlayerPedId())
        dist = GetDistanceBetweenCoords(pcoords, Config.Elec.locations[elec].x, Config.Elec.locations[elec].y, Config.Elec.locations[elec].z, true)
        if dist < 2.2 then
            wait = 0
            W.ShowText(vector3(Config.Elec.locations[elec].x, Config.Elec.locations[elec].y, Config.Elec.locations[elec].z + 1.0), '~y~Escalera\n~w~Recoger', 1, 8)
            if IsControlJustPressed(1, 38) then
                RequestAnimDict("amb@prop_human_bum_bin@idle_b")
                while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do
                    Wait(1)
                end
                TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 0, false, false, false)
                Wait(3000)
                ClearPedTasks(ped)
                DeleteObject(object)
                done = done + 1
                createMarkers(elecveh)
                fixed = false
            end
        end
        Wait(wait)
    end
end

function finishElecJob(elecveh)
    W.Notify('ACTIVIDAD', 'Has terminado el trabajo, dirigete de vuelta a la sede')
    CreateElecBlip(Config.Elec.FinishPoint)
    while true do
        local wait = 1500
        local pcoords = GetEntityCoords(PlayerPedId())
        dist = GetDistanceBetweenCoords(pcoords, Config.Elec.FinishPoint, true)
        if dist < 8 then
            wait = 0
            DrawMarker(27, Config.Elec.FinishPoint - vector3(0,0,0.5), 0, 0, 0, 0, 0, 0, 4.2000, 4.2000, 0.6001, 255, 0, 0, 500, 0, 0, 0, 1)
            if dist < 2 then
                W.ShowText(Config.Elec.FinishPoint + 1.0, '~y~Vehículo\n~w~Dejar vehículo y cobrar', 1, 8)
                if IsControlJustPressed(1, 38) then
                    TriggerEvent("ZC-Character:loadSkin", lastSkin)
                    DeleteVehicle(elecveh)
                    TriggerServerEvent('Ox-Activities:start', 'elec')
                    done = 0
                    RemoveBlip(pblip)
                    repeated = {}
                    start()
                    break
                end
            end
        end
        Wait(wait)
    end
end

RegisterNetEvent('Ox-Activities:cancelarElec', function()
    TriggerEvent("ZC-Character:loadSkin", lastSkin)
    DeleteVehicle(elecveh)
    done = 0
    RemoveBlip(pblip)
    activity = nil
    repeated = {}
    start()
end)

function CreateElecBlip(pos)
    pblip = AddBlipForCoord(pos.x, pos.y)
	SetBlipHighDetail(pblip, true)
	SetBlipSprite(pblip, 1)
	SetBlipScale(pblip, 0.7)
	SetBlipColour(pblip, 0)
	SetBlipRoute(pblip, true)
	SetBlipRouteColour(pblip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Punto de reparación")
	EndTextCommandSetBlipName(pblip)
end