local farm = 0
local farmveh
local pblip
local farmdone = 0
local locations = {}
local models = {}
local farmblip = {}
local carry = false

function farmStart(inicoords, carcoords, vehicle, carh)

    W.Notify('ACTIVIDAD', 'Vamos a empezar el trabajo, te comento lo que debes de hacer. Subete al tractor que tienes delante y te voy a ir dando instrucciones. Recuerda que en tu menú personal puedes cancelar el trabajo en el F10')
    Wait(2000)
    local hash = GetHashKey(vehicle)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(1)
    end

    farmveh = CreateVehicle(hash, carcoords, carh, true, true)
    TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(farmveh))
    exports['LegacyFuel']:SetFuel(farmveh, 100.0)
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        if IsPedInVehicle(ped, farmveh) then
            wait = 100
            W.Notify('ACTIVIDAD', 'Ve a por la paja')
            createMarkersfarm(farmveh)
            break
        end
        Wait(wait)
    end
end

function createMarkersfarm(farmveh)
    if farmdone ~= Config.Farm.MaxRepairs then
        for k,v in pairs(Config.Farm.locations) do
            locations = Config.Farm.locations
            farm = farm + 1
            local rpos = math.random(-2,2)
            CreatefarmBlip(Config.Farm.locations[farm].x + rpos, Config.Farm.locations[farm].y + rpos)
            models[farm] = CreateObject(GetHashKey("prop_haybale_03"), Config.Farm.locations[farm].x + rpos, Config.Farm.locations[farm].y + rpos, Config.Farm.locations[farm].z, false, false, false)
            PlaceObjectOnGroundProperly(models[farm])
            FreezeEntityPosition(models[farm], true)
        end
        point = true
        while point do
            local wait = 900
            local pcoords = GetEntityCoords(PlayerPedId())
            if not carry then
                for k,v in pairs(locations) do
                    dist = GetDistanceBetweenCoords(pcoords, v.x, v.y, v.z, true)
                    for k,v in pairs(farmblip) do
                        blipcoords = GetBlipCoords(farmblip[k])
                        dist3 = GetDistanceBetweenCoords(pcoords, blipcoords, false)
                        if dist3 < 5 then
                            if IsControlJustPressed(1, 38) then
                                RemoveBlip(farmblip[k])
                                table.remove(farmblip, k)
                            end
                        end
                    end
                    for k,v in pairs(models) do
                        if dist < 6 then
                            local coords = GetEntityCoords(models[k])
                            dist2 = GetDistanceBetweenCoords(pcoords, coords, true)
                            wait = 0
                            if dist2 < 6 then
                                W.ShowText(GetEntityCoords(models[k]) + vector3(0,0,1.0), '~y~Bola de heno\n~w~Recoger', 1, 8)
                                if IsControlJustPressed(1, 38) then
                                    W.Progressbar("picking", 'Recogiendo...', 3000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        carry = true
                                        AttachEntityToEntity(models[k], farmveh, 4, -0.70, -2.95, -0.80, 0.0, 0, 90.0, false, false, false, false, 2, true)
                                        CreatefarmBlipMerc(models[k], farmveh)
                                        table.remove(models, k)
                                    end, function()
                                        W.Notify('Recogida', 'Has cancelado la acción', 'error')
                                    end)
                                end
                            end
                        end
                    end
                end
            end
            Wait(wait)
        end
    end

end

function CreatefarmBlip(x, y)
    blips = AddBlipForCoord(x, y)
	SetBlipHighDetail(blips, true)
	SetBlipSprite(blips, 1)
	SetBlipScale(blips, 0.7)
	SetBlipColour(blips, 0)
	SetBlipRouteColour(blips, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Mercancia")
	EndTextCommandSetBlipName(blips)
    table.insert(farmblip, blips)
end

function CreateFinishBlip(pos)
    pblip = AddBlipForCoord(pos.x, pos.y)
    SetBlipHighDetail(pblip, true)
    SetBlipSprite(pblip, 1)
    SetBlipScale(pblip, 0.7)
    SetBlipColour(pblip, 0)
    SetBlipRoute(pblip, true)
    SetBlipRouteColour(pblip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Punto de entrega")
    EndTextCommandSetBlipName(pblip)
end

function CreatefarmBlipMerc(object, farmveh)
    mercblip = AddBlipForCoord(Config.Farm.deliver)
	SetBlipHighDetail(mercblip, true)
	SetBlipSprite(mercblip, 1)
	SetBlipScale(mercblip, 0.7)
	SetBlipColour(mercblip, 0)
	SetBlipRoute(mercblip, true)
	SetBlipRouteColour(mercblip, 1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de mercancia")
	EndTextCommandSetBlipName(mercblip)
    W.Notify('ACTIVIDAD', 'Ahora ve ha entregar la mercancia')
    active = true

    while active do
        local wait = 1000
        local pcoords = GetEntityCoords(PlayerPedId())
        dist4 = GetDistanceBetweenCoords(pcoords, Config.Farm.deliver)
        if dist4 < 10 then
            wait = 0
            DrawMarker(27, Config.Farm.deliver - vector3(0,0,0.6), 0, 0, 0, 0, 0, 0, 4.2000, 4.2000, 0.6001, 255, 0, 0, 500, 0, 0, 0, 1)
            if dist4 < 3 then
                W.ShowText(Config.Farm.deliver, '~y~Bola de heno\n~w~Entregar', 1, 8)
                if IsControlJustPressed(1, 38) then
                    DeleteObject(object)
                    farmdone = farmdone + 1
                    RemoveBlip(mercblip)
                    if farmdone == Config.Farm.MaxRepairs then
                        farmdone = 0
                        W.Notify('ACTIVIDAD', 'Has terminado el trabajo, dirijete a entregar el tractor')
                        finishfarmJob(farmveh)
                    else
                        W.Notify('ACTIVIDAD', 'Ve a por más paja')
                        carry = false
                    end
                    break
                end
            end
        end
        Wait(wait)
    end
end

function finishfarmJob(farmveh)
    CreateFinishBlip(Config.Farm.FinishPoint)
    while true do
        local wait = 1500
        local pcoords = GetEntityCoords(PlayerPedId())
        dist = GetDistanceBetweenCoords(pcoords, Config.Farm.FinishPoint, true)
        if dist < 4 then
            wait = 0
            DrawMarker(27, Config.Farm.FinishPoint - vector3(0,0,0.5), 0, 0, 0, 0, 0, 0, 4.2000, 4.2000, 0.6001, 255, 0, 0, 500, 0, 0, 0, 1)
            W.ShowText(Config.Farm.FinishPoint, '~y~Vehículo\n~w~Entregar y cobrar', 1, 8)
            if IsControlJustPressed(1, 38) then
                for k,v in pairs(farmblip) do
                    RemoveBlip(v)
                end
                TriggerEvent("ZC-Character:loadSkin", lastSkin)
                if NetworkGetEntityOwner(farmveh) ~= PlayerId() then
                    NetworkRequestControlOfEntity(farmveh)
                    Wait(100)
                end
                while DoesEntityExist(farmveh) do DeleteObject(farmveh); DeleteEntity(farmveh); Wait(0) end
                TriggerServerEvent('Ox-Activities:start', 'farm')
                RemoveBlip(pblip)
                farm = 0
                locations = {}
                farmblip = {}
                for k,v in pairs(models) do
                    DeleteEntity(models[k])
                end
                models = {}
                carry = false
                start()
                break
            end
        end
        Wait(wait)
    end
end

RegisterNetEvent('Ox-Activities:cancelarCultivo', function()
    for k,v in pairs(farmblip) do
        RemoveBlip(v)
    end
    TriggerEvent("ZC-Character:loadSkin", lastSkin)
    if NetworkGetEntityOwner(farmveh) ~= PlayerId() then
        NetworkRequestControlOfEntity(farmveh)
        Wait(100)
    end
    while DoesEntityExist(farmveh) do DeleteObject(farmveh); DeleteEntity(farmveh); Wait(0) end
    RemoveBlip(pblip)
    farm = 0
    locations = {}
    farmblip = {}
    for k,v in pairs(models) do
        DeleteEntity(models[k])
    end
    models = {}
    carry = false
    activity = nil
    start()
end)