local mechid
local mech = nil
local mechveh
local done = 0

function mechStart(inicoords, carcoords, vehicle, carh)
    W.Notify('ACTIVIDAD', 'Vamos a empezar el trabajo, te comento lo que debes de hacer. Subete al vehículo que tienes delante y te voy a ir dando instrucciones. Recuerda que en tu menú personal puedes cancelar el trabajo en el F10')
    Wait(2000)
    local hash = GetHashKey(vehicle)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(1)
    end

    mechveh = CreateVehicle(hash, carcoords, carh, true, true)
    TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(mechveh))
    exports['LegacyFuel']:SetFuel(mechveh, 100.0)
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        if IsPedInVehicle(ped, mechveh) then
            wait = 100
            createMarkersMech(ped, inicoords, mechveh)
            W.Notify('ACTIVIDAD', 'Ve a por la mercancia')
            break
        end
        Wait(wait)
    end

end


function createMarkersMech(ped, inicoords, mechveh)
    if done ~= Config.Mech.MaxRepairs then
        mech = math.random(1, #Config.Mech.locations)
        if mech == mechid then
            createMarkersMech(ped, inicoords)
        end
        CreateMechBlip(Config.Mech.locations[mech])
        point = true
        local spawned = false
        while point do
            local wait = 1500
            local pcoords = GetEntityCoords(PlayerPedId())

            dist = GetDistanceBetweenCoords(pcoords, Config.Mech.locations[mech].x, Config.Mech.locations[mech].y, Config.Mech.locations[mech].z, true)

            if dist < 40 then
                wait = 500
                if not spawned then
                    createMechObject()
                    spawned = true
                end

                if dist < 5 then
                    wait = 0
                    local merccoords = vector3(Config.Mech.locations[mech].x, Config.Mech.locations[mech].y, Config.Mech.locations[mech].z)
                    if DoesEntityExist(mechveh) then
                        W.ShowText(merccoords + vector3(0.0, 0.0, 1.5), '~y~Carga\n~w~Recoger', 1, 8)
                        if IsControlJustPressed(1, 38) then
                            attachMech(mechveh)
                            break
                        end
                    else
                        break
                    end
                end
            end

            Wait(wait)
        end
    else
        finishJob(mechveh)
    end

end

function createMarkersMechMerc(mechveh)
    point = true
    while point do
        local wait = 1500
        local pcoords = GetEntityCoords(PlayerPedId())

        dist = GetDistanceBetweenCoords(pcoords, 1218.64, -3230.92, 4.69)

        if dist < 5 then
            wait = 500
            DrawMarker(27, vector3(1218.64, -3230.92, 4.69) - vector3(0,0,0.5), 0, 0, 0, 0, 0, 0, 4.2000, 4.2000, 0.6001, 255, 0, 0, 500, 0, 0, 0, 1)
            if dist < 3 then
                wait = 0
                if DoesEntityExist(mechveh) then
                    W.ShowText(vector3(1218.64, -3230.92, 4.69) + vector3(0.0, 0.0, 1.5), '~y~Carga\n~w~Entregar', 1, 8)
                    if IsControlJustPressed(1, 38) then
                        DeleteObject(mechobject)
                        done = done + 1
                        RemoveBlip(mercblip)
                        createMarkersMech(nil, nil, mechveh)
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

function finishJob(mechveh)
    W.Notify('ACTIVIDAD', 'Has terminado el trabajo, dirigete de vuelta a la sede')
    CreateMechBlip(Config.Mech.FinishPoint)
    while true do
        local wait = 1500
        local pcoords = GetEntityCoords(PlayerPedId())
        dist = GetDistanceBetweenCoords(pcoords, Config.Mech.FinishPoint, true)
        if dist < 8 then
            wait = 0
            DrawMarker(27, Config.Mech.FinishPoint - vector3(0,0,0.5), 0, 0, 0, 0, 0, 0, 4.2000, 4.2000, 0.6001, 255, 0, 0, 500, 0, 0, 0, 1)
            if dist < 2 then
                W.ShowText(Config.Mech.FinishPoint + vector3(0.0, 0.0, 1.0), '~y~Vehículo\n~w~Entregar y cobrar', 1, 8)
                if IsControlJustPressed(1, 38) then
                    TriggerEvent("ZC-Character:loadSkin", lastSkin, false)
                    DeleteVehicle(mechveh)
                    TriggerServerEvent('Ox-Activities:start', 'port')
                    done = 0
                    RemoveBlip(mechblip)
                    start()
                    break
                end
            end
        end
        Wait(wait)
    end
end

RegisterNetEvent('Ox-Activities:cancelarMec', function()
    TriggerEvent("ZC-Character:loadSkin", lastSkin, false)
    DeleteVehicle(mechveh)
    RemoveBlip(mercblip)
    done = 0
    activity = nil
    RemoveBlip(mechblip)
    DeleteEntity(mechobject)
    start()
end)

function attachMech(mechveh)
    mechid = mech
    SetEntityAsMissionEntity(mechobject)
    AttachEntityToEntity(mechobject, mechveh, 3, 0.0, 1.3, -0.49, 0.0, 0, 90.0, false, false, false, false, 2, true)
    RemoveBlip(mechblip)
    CreateMechBlipMerc()
    createMarkersMechMerc(mechveh)
end

function createMechObject()
    mechobject = CreateObjectNoOffset(GetHashKey('prop_boxpile_06b'), Config.Mech.locations[mech].x, Config.Mech.locations[mech].y, Config.Mech.locations[mech].z, false, false, false)
    SetEntityHeading(mechobject, Config.Mech.locations[mech].h)
    SetEntityAsMissionEntity(mechobject)
    FreezeEntityPosition(mechobject, true)
end

function CreateMechBlip(pos)
    mechblip = AddBlipForCoord(pos.x, pos.y)
	SetBlipHighDetail(mechblip, true)
	SetBlipSprite(mechblip, 1)
	SetBlipScale(mechblip, 0.7)
	SetBlipColour(mechblip, 0)
	SetBlipRoute(mechblip, true)
	SetBlipRouteColour(mechblip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Mercancia")
	EndTextCommandSetBlipName(mechblip)
end

function CreateMechBlipMerc()
    mercblip = AddBlipForCoord(1218.64, -3230.92, 4.69)
	SetBlipHighDetail(mercblip, true)
	SetBlipSprite(mercblip, 1)
	SetBlipScale(mercblip, 0.7)
	SetBlipColour(mercblip, 0)
	SetBlipRoute(mercblip, true)
	SetBlipRouteColour(mercblip, 2)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de mercancia")
	EndTextCommandSetBlipName(mercblip)

    W.Notify('ACTIVIDAD', 'Ahora ve a entregar la mercancia')
end