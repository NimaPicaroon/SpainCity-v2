Amb = setmetatable({ }, Amb)
Amb.Variables = {
    IsDead = false,
    IsKO = false,
    CameraStarted = false,
    OwnId = GetPlayerServerId(PlayerId()),
    DeadPeople = {}
}

IsDead = function()
    if Amb.Variables.IsDead  then
        if Amb.Variables.IsKO then
            return 'ko'
        else
            return true
        end
    end
    return false
end

exports('IsDead', IsDead)
exports('isKO', Amb.Variables.IsKO)

CreateThread(function ()
    while true do
        Wait(300)
        if IsEntityDead(PlayerPedId()) and not Amb.Variables.IsDead then
            if not exports['eden_airsoft']:isPlaying() then
                Amb.Die()
            else
                Amb.Revive()
            end
        end
    end
end)

Amb.Revive = function ()
    CreateThread(function ()
        --TriggerServerEvent("core:server:statusRef")
        Wait(300)
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        SendNUIMessage({
            hide = true
        })
        TriggerServerEvent('ZC-Ambulance:updateDead', 0)
        ResurrectPed(Ped)
        StopGameplayCamShaking()
        ClearPedTasks(Ped)
        StopScreenEffect('DeathFailOut')
        Amb.Variables.IsDead = false
        Amb.Variables.IsKO = false
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityCoords(Ped, Coords + vector3(0, 0, 0.1))
        SetPedMaxHealth(Ped, 200)
        SetEntityHealth(Ped, 200)
        SetEntityInvincible(Ped, false)
        exports['ZC-HelpNotify']:close('ambulance_revive')
    end)
end

Amb.ReviveModified = function ()
    CreateThread(function ()
        W.Notify('HOSPITAL', 'Los médicos te están atendiendo...')
        Wait(8000)
        --TriggerServerEvent("core:server:statusRef")
        Wait(300)
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        SendNUIMessage({
            hide = true
        })
        TriggerServerEvent('ZC-Ambulance:updateDead', 0)
        ResurrectPed(Ped)
        ClearPedTasks(Ped)
        StopGameplayCamShaking()
        StopScreenEffect('DeathFailOut')
        Amb.Variables.IsDead = false
        Amb.Variables.IsKO = false
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityCoords(Ped, Coords + vector3(0, 0, 0.1))
        SetPedMaxHealth(Ped, 200)
        SetEntityHealth(Ped, 200)
        SetEntityInvincible(Ped, false)
        exports['ZC-HelpNotify']:close('ambulance_revive')
    end)
end

RegisterNetEvent("zcambulance:client:revivePlayer", Amb.Revive)

RegisterNetEvent("zcambulance:client:revivePlayerModified", Amb.ReviveModified)

RemoveAll = function ()
    TriggerServerEvent("core:server:statusRef")
    Wait(300)
    TriggerServerEvent('ZCore:resetInventory')
    TriggerServerEvent('ZC-Ambulance:updateDead', 0)
    local Ped = PlayerPedId()
    ResurrectPed(Ped)
    StopGameplayCamShaking()
    StopScreenEffect('DeathFailOut')
    Amb.Variables.IsDead = false
    Amb.Variables.IsKO = false
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityCoords(Ped, vector3(-460-3, -288.78, 34.95))
    SetEntityHeading(Ped, 21.9)
    SetPedMaxHealth(Ped, 200)
    SetEntityHealth(Ped, 200)
    SetEntityInvincible(Ped, false)
    W.Notify('HOSPITAL', 'Has sido encontrado inconsciente y se te ha tratado en el hospital, buen día')
    exports['ZC-HelpNotify']:close('ambulance_revive')
end

RegisterNetEvent("ZC-Ambulance:WasDead", RemoveAll)

Sync = function (tab)
    Amb.Variables.DeadPeople = tab
end

RegisterNetEvent("ZC-Ambulance:SyncPeople", Sync)

Amb.Timer = function (veh)
    local ped = PlayerPedId()
    ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.5)
    local KO = promise.new()

    local koTimer = 120
    SendNUIMessage({
        show = true
    })
    CreateThread(function()
        while koTimer > 0 and Amb.Variables.IsDead do
            Wait(1000)

            if koTimer > 0 then
                koTimer = koTimer - 1
            end

            ped = PlayerPedId()
            if GetEntityHealth(ped) < 200 then
                KO:resolve()
                break
            end

            if koTimer == 0 then
                KO:resolve()
                break
            end

            if not Amb.Variables.IsDead then
                KO:resolve()
                break
            end

            if not veh then
                if not IsEntityPlayingAnim(ped, "random@dealgonewrong", "idle_a", 1) then
                    loadAnimDict("random@dealgonewrong")
                    TaskPlayAnim(ped, "random@dealgonewrong", "idle_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                end
            else
                if not IsEntityPlayingAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1) then
                    loadAnimDict("veh@low@front_ps@idle_duck")
                    TaskPlayAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                end
            end

            local min, sec = secondsToClock(koTimer)
            local text = ''
            if min == 1 then
                text = ("Quedarás <b style='color:#F40202'>inconsciente</b> en 1 min y "..sec.." segs")
                if sec == 1 then
                    text = ("Quedarás <b style='color:#F40202'>inconsciente</b> en 1 min y "..sec.." seg")
                elseif sec == 0 then
                    text = ("Quedarás <b style='color:#F40202'>inconsciente</b> en 1 min")
                end
            else
                text = ("Quedarás <b style='color:#F40202'>inconsciente</b> en "..sec.." segs")
                if sec == 1 then
                    text = ("Quedarás <b style='color:#F40202'>inconsciente</b> en "..sec.." seg")
                end
            end

            SendNUIMessage({
                text = text
            })
        end
    end)

    Citizen.Await(KO)
    if Amb.Variables.IsDead then
        local shown = false
        StartScreenEffect('DeathFailOut', 0, false)
        Amb.Variables.IsKO = false
        StopGameplayCamShaking()
        local pos = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.3, heading, true, false)
        SetEntityInvincible(ped, true)
        SetEntityHealth(ped, GetEntityMaxHealth(ped))

        if not IsPedInAnyVehicle(ped, false) then
            loadAnimDict("dead")
            TaskPlayAnim(ped, "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        end

        local earlySpawnTimer = 120
        local bleedoutTimer = 50 * 60

        CreateThread(function()
            while earlySpawnTimer > 0 and Amb.Variables.IsDead do
                Wait(1000)

                if earlySpawnTimer > 0 then
                    earlySpawnTimer = earlySpawnTimer - 1
                end
            end

            while bleedoutTimer > 0 and Amb.Variables.IsDead do
                Wait(1000)

                if bleedoutTimer > 0 then
                    bleedoutTimer = bleedoutTimer - 1
                end
            end
        end)

        CreateThread(function()
            local text, timeHeld

            while earlySpawnTimer > 0 and Amb.Variables.IsDead do
                Wait(0)
                local min, sec = secondsToClock(earlySpawnTimer)
                local ped = PlayerPedId()

                if not Amb.Variables.IsDead then
                    shown = false
                    exports['ZC-HelpNotify']:close('ambulance_revive')

                    break
                end

                if not IsPedInAnyVehicle(ped, false) and not IsEntityPlayingAnim(ped, "random@dead", "dead_a", 1) then
                    loadAnimDict("dead")
                    TaskPlayAnim(ped, "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                end

                if min > 0 then
                    if min == 1 then
                        text = ("Reaparición <b style='color:#1DDA10'>disponible</b> en "..min.." min "..sec.." segs")
                        if sec == 1 then
                            text = ("Reaparición <b style='color:#1DDA10'>disponible</b> en "..min.." min "..sec.." segs")
                        end
                    else
                        text = ("Reaparición <b style='color:#1DDA10'>disponible</b> en "..min.." mins "..sec.." segs")
                        if sec == 1 then
                            text = ("Reaparición <b style='color:#1DDA10'>disponible</b> en "..min.." mins "..sec.." segs")
                        end
                    end
                else
                    text = ("Reaparición <b style='color:#1DDA10'>disponible</b> en "..sec.." segs")
                    if sec == 1 then
                        text = ("Reaparición <b style='color:#1DDA10'>disponible</b> en "..sec.." segs")
                    end
                end

                SendNUIMessage({
                    text = text
                })
            end
            local timePressed = 0
            while bleedoutTimer > 0 and Amb.Variables.IsDead do
                Wait(0)
                local min, sec = secondsToClock(bleedoutTimer)

                if not IsPedInAnyVehicle(ped, false) and not IsEntityPlayingAnim(ped, "random@dead", "dead_a", 1) then
                    loadAnimDict("dead")
                    TaskPlayAnim(ped, "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                end

                if not shown then
                    shown = true

                    exports['ZC-HelpNotify']:open('Manten pulsado <strong>E</strong> para reaparecer', 'ambulance_revive')
                end

                if IsControlPressed(0, 38) then
                    timePressed = timePressed + 1
                    if(timePressed > 200)then
                        local ped = PlayerPedId()
                        RemoveAll()
                        shown = false
                        exports['ZC-HelpNotify']:close('ambulance_revive')
                        SendNUIMessage({
                            hide = true
                        })
                        TriggerServerEvent("ZC-Ambulance:TirarDeE", GetPlayerServerId(ped))
                        break
                    end
                else
                    timePressed = 0
                end

                if min >  0 then
                    if min == 1 then
                        text = ("Te <b style='color:#F40202'>quedan</b> "..min.." min "..sec.." segs")
                        if sec == 1 then
                            text = ("Te <b style='color:#F40202'>quedan</b> "..min.." min "..sec.." segs")
                        end
                    else
                        text = ("Te <b style='color:#F40202'>quedan</b> "..min.." mins "..sec.." segs")
                        if sec == 1 then
                            text = ("Te <b style='color:#F40202'>quedan</b> "..min.." mins "..sec.." segs")
                        end
                    end
                else
                    text = ("Te <b style='color:#F40202'>quedan</b> "..sec.." segs")
                    if sec == 1 then
                        text = ("Te <b style='color:#F40202'>quedan</b> "..sec.." seg")
                    end
                end
                SendNUIMessage({
                    text = text
                })
            end

            if bleedoutTimer < 1 and Amb.Variables.IsDead then
                RemoveAll()
                SendNUIMessage({
                    hide = true
                })
            end
        end)
    end
end

Amb.Die = function ()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local cause = GetCauseOfDeath()

    local killerEntity = GetPedSourceOfDeath(ped)
    local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

    if GetPlayerServerId(killerClientId) == 0 then
        killerClientId = false
    end

    TriggerServerEvent('ZC-Ambulance:updateDead', 1, cause, GetPlayerServerId(killerClientId) or false)
    Amb.Variables.IsDead = true
    Amb.Variables.IsKO = true
    SetCurrentPedWeapon(ped, 'WEAPON_UNARMED', true)

    CreateThread(function()
        while Amb.Variables.IsDead do
            Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
			EnableControlAction(0, 245, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 0, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 288, true)
            EnableControlAction(0, 213, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 46, true)
            EnableControlAction(0, 47, true)

            if Amb.Variables.IsKO then
                EnableControlAction(0, 249, true)
            end
        end
    end)

    if IsPedInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped)
        local vehseats = GetVehicleModelNumberOfSeats(GetHashKey(GetEntityModel(veh)))
        for i = -1, vehseats do
            local occupant = GetPedInVehicleSeat(veh, i)
            if occupant == ped then
                NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.3, heading, true, false)
                SetPedIntoVehicle(ped, veh, i)
            end
        end
    else
        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.3, heading, true, false)
    end

    ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    if IsPedInAnyVehicle(ped, false) then
        loadAnimDict("veh@low@front_ps@idle_duck")
        TaskPlayAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
    else
        loadAnimDict("random@dealgonewrong")
        TaskPlayAnim(ped, "random@dealgonewrong", "idle_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
    end
    Amb.Timer(IsPedInAnyVehicle(ped, false))
end

RegisterNetEvent("zcambulance:client:killPlayer", Amb.Die)

Amb.Heal = function (type)
    if not type then
        TriggerServerEvent("core:server:statusRef")
        Wait(200)
        FreezeEntityPosition(PlayerPedId(), false)
        local Ped = PlayerPedId()
        SetEntityHealth(Ped, 200)
    else
        local playerPed = PlayerPedId()
        local maxHealth = GetEntityMaxHealth(playerPed)
        if type == 'small' then
            local health = GetEntityHealth(playerPed)
            local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
            SetEntityHealth(playerPed, newHealth)
        elseif type == 'big' then
            SetEntityHealth(playerPed, maxHealth)
        end
        W.Notify('MÉDICO', 'Has sido ~g~tratado', 'verify')
    end
end

RegisterNetEvent("zcambulance:client:heal", Amb.Heal)

-- Elevators

local elevators = {
    [1] = { coords = vec4(-444.8, -339.23, 78.32, 0.0), name = 'Azotea' }, -- Azotea
    [2] = { coords = vec4(-490.65, -327.52, 42.31, 0.0), name = 'Oficinas' }, -- Oficinas
    [3] = { coords = vec4(-435.99, -359.59, 34.59, 355.26), name = 'Lobby' }, -- Lobby
    [4] = { coords = vec4(-418.99, -344.75, 24.23, 111.68), name = 'Parking' }, -- Parking
    [5] = { coords = vec4(247.09, -1372.05, 24.54, 319.84), name = 'Morgue' }, -- Morgue
    [6] = { coords = vec4(248.82, -1369.72, 29.65, 320.25), name = 'Oficinas de la Morgue' }, -- Oficinas de la Morgue
    [7] = { coords = vec4(-490.64, -327.72, 69.57, 171.88), name = 'Planta de Ingresos' }, -- Planta de ingresos
    [8] = { coords = vec4(-452.44, -288.48, -131.79, 109.96), name = 'Quirófanos' }, -- Planta de quirófanos
}

useElevator = function()
    local self = {}
    self.elements = {}
    self.playerId = GetPlayerServerId(PlayerId())


    for k,v in pairs(elevators) do
        table.insert(self.elements, { label = v.name, coords = v.coords })
    end

    if self.elements then
        --if exports['Ox-Phone']:IsPhoneOpened() then return end
        if exports['Ox-Jobcreator']:IsHandcuffed() then return end
        if exports['ZC-Ambulance']:IsDead() then return end
        if exports['ZC-Menu']:isOpened() then return end

        W.OpenMenu('Ascensor', 'ems_elevator', self.elements, function(data, name)
            W.DestroyMenu(name)

            if data then
                if DoesEntityExist(PlayerPedId()) then
                    RequestCollisionAtCoord(data.coords.x, data.coords.y, data.coords.z)

                    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                        RequestCollisionAtCoord(data.coords.x, data.coords.y, data.coords.z)

                        Citizen.Wait(500)
                    end

                    DoScreenFadeOut(500)
                    Wait(2000)
                    SetEntityCoords(PlayerPedId(), data.coords.x, data.coords.y, data.coords.z, false, false, false, false)
                    SetEntityHeading(PlayerPedId(), data.coords.w)
                    Wait(1000)
                    DoScreenFadeIn(500)

                    W.Notify('Ascensor', 'Has ido a la planta '..data.label..'.', 'verify')
                end
            end
        end)
    end
end

startElevator = function()
    Citizen.CreateThread(function()
        while true do
            local msec = 1000

            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            local jugador = W.GetPlayerData()

            if playerPed and playerPos then
                for k,v in pairs(elevators) do
                    local dist = #(playerPos - vec3(v.coords.x, v.coords.y, v.coords.z))

                    --if jugador.job.name == 'police' or jugador.job.name == 'ambulance' then

                        if dist <= 3.0 then
                            msec = 5
                            if jugador.job.name == 'police' or jugador.job.name == 'ambulance' then

                            W.ShowText(vec3(v.coords.x, v.coords.y, v.coords.z), '~y~Ascensor~w~\nSubir/Bajar de planta', 0.5, 8)
                            if dist <= 1.5 then
                                if IsControlJustPressed(0, 38) then
                                    useElevator()
                                end
                            end
                            end
                        end
                    --end
                end
            end

            Citizen.Wait(msec)
        end
    end)
end

Citizen.CreateThread(startElevator)