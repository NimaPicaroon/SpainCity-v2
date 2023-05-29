local pilot, aircraft, parachute, crate, pickup, blip, soundID, planeBlip
local requiredModels = {}
InDrop = false


function crateDrop(data)
    local dropCoords = MISSIONS_DATA._airdrop.coords[math.random(1, #MISSIONS_DATA._airdrop.coords)]
    InDrop = true
    Citizen.CreateThread(function()

        requiredModels = {'p_cargo_chute_s', "ex_prop_adv_case_sm", "cuban800", "s_m_m_pilot_02", "prop_box_wood02a_pu"} -- parachute, pickup case, plane, pilot, crate

        for i = 1, #requiredModels do
            RequestModel(GetHashKey(requiredModels[i]))
            while not HasModelLoaded(GetHashKey(requiredModels[i])) do
                Wait(0)
            end
        end

        RequestWeaponAsset(GetHashKey("weapon_flare")) -- flare won't spawn later in the script if we don't request it right now
        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end

        local rHeading = math.random(0, 360) + 0.0
        local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 5000.0 -- this defines how far away the plane is spawned
        local theta = (rHeading / 180.0) * 3.14
        local rPlaneSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -500.0) -- the plane is spawned at

        local dx = dropCoords.x - rPlaneSpawn.x
        local dy = dropCoords.y - rPlaneSpawn.y
        local heading = GetHeadingFromVector_2d(dx, dy) -- determine plane heading from coordinates

        aircraft = CreateVehicle(GetHashKey("cuban800"), rPlaneSpawn, heading, true, true)
        SetEntityHeading(aircraft, heading)
        SetVehicleDoorsLocked(aircraft, 2) -- lock the doors so pirates don't get in
        SetEntityDynamic(aircraft, true)
        ActivatePhysics(aircraft)
        SetVehicleForwardSpeed(aircraft, 60.0)
        Wait(3000)
        planeBlip = AddBlipForEntity(aircraft)
        SetBlipAsFriendly(planeBlip, true)
        SetBlipSprite(planeBlip, 16)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Piloto")
        EndTextCommandSetBlipName(planeBlip)
        SetBlipScale(planeBlip, 0.7)
        SetBlipColour(planeBlip, 5)
        SetVehicleForwardSpeed(aircraft, 70.0)
        SetHeliBladesFullSpeed(aircraft) -- works for planes I guess
        SetVehicleEngineOn(aircraft, true, true, false)
        ControlLandingGear(aircraft, 3) -- retract the landing gear
        OpenBombBayDoors(aircraft) -- opens the hatch below the plane for added realism
        SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)
        pilot = CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true)
        DecorSetInt(pilot, 'SPAWNEDPED', 1)
        SetBlockingOfNonTemporaryEvents(pilot, true) -- ignore explosions and other shocking events
        SetPedRandomComponentVariation(pilot, false)
        SetPedKeepTask(pilot, true)
        SetPlaneMinHeightAboveTerrain(aircraft, 20)
        TaskVehicleDriveToCoord(pilot, aircraft, vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), 60.0, 0, GetHashKey("cuban800"), 262144, 15.0, -1.0) -- to the dropsite, could be replaced with a task sequence
        ShowHeadingIndicatorOnBlip(planeBlip, true)
        local droparea = vector2(dropCoords.x, dropCoords.y)
        local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
        while not IsEntityDead(pilot) and #(planeLocation - droparea) > 5.0 do -- wait for when the plane reaches the dropCoords ± 5 units
            Wait(100)
            planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y) -- update plane coords for the loop
        end

        if IsEntityDead(pilot) then -- I think this will end the script if the pilot dies, no idea how return works
            RemoveBlip(planeBlip)
            InDrop = false
            return
        end

        TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, GetHashKey("cuban800"), 262144, -1.0, -1.0) -- disposing of the plane like Rockstar does, send it to 0; 0 coords with -1.0 stop range, so the plane won't be able to achieve its task
        SetEntityAsNoLongerNeeded(pilot)
        SetEntityAsNoLongerNeeded(aircraft)

        local crateSpawn = vector3(dropCoords.x, dropCoords.y, GetEntityCoords(aircraft).z - 5.0) -- crate will drop to the exact position as planned, not at the plane's current position

        crate = CreateObject(GetHashKey("prop_box_wood02a_pu"), crateSpawn, true, true, true) -- a breakable crate to be spawned directly under the plane, probably could be spawned closer to the plane
        SetEntityLodDist(crate, 1000) -- so we can see it from the distance
        ActivatePhysics(crate)
        SetDamping(crate, 2, 0.1) -- no idea but Rockstar uses it
        SetEntityVelocity(crate, 0.0, 0.0, -0.2) -- I think this makes the crate drop down, not sure if it's needed as many times in the script as I'm using

        parachute = CreateObject(GetHashKey(requiredModels[1]), crateSpawn, true, true, true) -- create the parachute for the crate, location isn't too important as it'll be later attached properly
        SetEntityLodDist(parachute, 1000)
        SetEntityVelocity(parachute, 0.0, 0.0, -0.2)
        -- settings nil to pickup hash because we gonna put other type of rewards
        pickup = CreateAmbientPickup("PICKUP_MONEY_WALLET", crateSpawn, 0, 0, GetHashKey("ex_prop_adv_case_sm"), true, true) -- create the pickup itself, location isn't too important as it'll be later attached properly
        ActivatePhysics(pickup)
        SetDamping(pickup, 2, 0.0245)
        SetEntityVelocity(pickup, 0.0, 0.0, -0.2)

        blip = AddBlipForEntity(pickup)
        SetBlipSprite(blip, 408)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Drop")
        EndTextCommandSetBlipName(blip)
        SetBlipAlpha(blip, 120)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2)
        AttachEntityToEntity(parachute, pickup, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true) -- attach the crate to the pickup
        AttachEntityToEntity(pickup, crate, 0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, false, false, true, false, 2, true) -- attach the pickup to the crate, doing it in any other order makes the crate drop spazz out
        FreezeEntityPosition(crate, false)

        while HasObjectBeenBroken(crate) == false do -- wait till the crate gets broken (probably on impact), then continue with the script
            Wait(0)
        end
        local parachuteCoords = vector3(GetEntityCoords(parachute)) -- we get the parachute dropCoords so we know where to drop the flare
        ShootSingleBulletBetweenCoords(parachuteCoords, parachuteCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0) -- flare needs to be dropped with dropCoords like that, otherwise it remains static and won't remove itself later
        DetachEntity(parachute, true, true)
        DeleteEntity(parachute)
        DetachEntity(pickup) -- will despawn on its own
        SetBlipAlpha(blip, 255)

        while DoesEntityExist(pickup) do -- wait till the pickup gets picked up, then the script can continue
            Wait(0)
        end
        while DoesObjectOfTypeExistAtCoords(parachuteCoords, 10.0, GetHashKey("w_am_flare"), true) do
            Wait(0)
            local prop = GetClosestObjectOfType(parachuteCoords, 10.0, GetHashKey("w_am_flare"), false, false, false)
            RemoveParticleFxFromEntity(prop)
            SetEntityAsMissionEntity(prop, true, true)
            DeleteObject(prop)
        end
        if DoesBlipExist(blip) then -- remove the blip, should get removed when the pickup gets picked up anyway, but isn't a bad idea to make sure of it
            RemoveBlip(blip)
        end

        if DoesBlipExist(planeBlip) then -- remove the blip, should get removed when the pickup gets picked up anyway, but isn't a bad idea to make sure of it
            RemoveBlip(planeBlip)
        end
        InDrop = false
        TriggerServerEvent("Ox-Gangs:getDrop", data)
        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

        RemoveWeaponAsset(GetHashKey("weapon_flare"))
    end)
end

local pedEntities = {}
local peds = {
    [1] = { ped = GetHashKey('ig_vagspeak'), coords = vec4(-598.59, 222.93, 74.15, 270.01), anim = true, menu = true, animData = { dict = 'timetable@reunited@ig_10', name = 'isthisthebest_jimmy' } },
    [2] = { ped = GetHashKey('u_m_m_jewelsec_01'), coords = vec4(-594.18, 220.45, 74.15, 90.04), anim = false, menu = false, weapon = true, weaponHash = GetHashKey('weapon_sawnoffshotgun') },
    [3] = { ped = GetHashKey('s_m_y_doorman_01'), coords = vec4(-598.41, 221.29, 74.15, 314.55), anim = false, menu = false, weapon = true, weaponHash = GetHashKey('weapon_compactrifle') },
    [4] = { ped = GetHashKey('s_m_y_doorman_01'), coords = vec4(-598.31, 224.4, 74.15, 260.02), anim = false, menu = false, weapon = true, weaponHash = GetHashKey('weapon_specialcarbine') },
    [5] = { ped = GetHashKey('s_m_m_highsec_01'), coords = vec4(-594.21, 225.13, 74.15, 93.11), anim = false, menu = false, weapon = true, weaponHash = GetHashKey('weapon_specialcarbine') }
}

Citizen.CreateThread(function()
    for i = 1, #peds, 1 do
        RequestModel(peds[i].ped)

        while not HasModelLoaded(peds[i].ped) do
            Wait(100)

            RequestModel(peds[i].ped)
        end

        local ped = CreatePed(0, peds[i].ped, vector3(peds[i].coords.x, peds[i].coords.y, peds[i].coords.z - 1.0), peds[i].coords.w, false)
        DecorSetInt(ped, 'SPAWNEDPED', 1)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetEntityInvincible(ped, true)
        table.insert(pedEntities, { entity = ped, index = i })

        if peds[i].anim then
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_AA_SMOKE", 0, true)
        end

        if peds[i].weapon then
            GiveWeaponToPed(ped, peds[i].weaponHash, 250, false, true)
            SetCurrentPedWeapon(ped, peds[i].weaponHash, true)
        end
    end
end)

local basket = {}

OpenBasketMenu = function()
    local elements = {
        {label = "Armas blancas", value = "blanca"},
        {label = "Pistolas", value = "pistols"},
    }

    local gang = MyData.gangData
    local gangLevel = 1
    if gang then
        gangLevel = gang.level
    end

    if gangLevel >= 2 then
        table.insert(elements, {label = "Subfusiles", value = "subfusil"})
    end
    if gangLevel >= 3 then
        table.insert(elements, {label = "Escopetas", value = "escopeta"})
        table.insert(elements, {label = "Fusiles", value = "fusil"})
        table.insert(elements, {label = "Chaleco", value = "chaleco"})
    end
    if #basket > 0 then
        local totalTo = 0

        table.insert(elements, {label = "Vaciar pedido", value = "basketremove"})
        table.insert(elements, {label = "<span style='color: yellow;'>Confirmar pedido</span>", value = "confirm"})

        for k,v in pairs (basket) do
            totalTo = totalTo + v.price
        end

        table.insert(elements, {label = "Total: <span style='color: green;'>$"..totalTo.."</span>", value = "none"})
    end
    Wait(200)
    W.OpenMenu("Partes de armas", "drugssdasdasd_menu", elements, function (data, name)
        W.DestroyMenu(name)

        if data.value == 'basketremove' then
            basket = {}
            W.Notify('Basel', 'Has vacíado tu cesta', 'error')
        end

        if data.value ~= "confirm" then
            OpenBasketMenu2(data.value, gangLevel)
        else
            local total = 0
            for k,v in pairs (basket) do
                total = total + v.price
            end
            local OwnData = W.GetPlayerData()
            if OwnData.money.money >= total then
                W.TriggerCallback('Ox-Gangs:orderDrop', function(can)
                    if can then
                        basket = {}
                    end
                end, basket, total)
            else
                W.Notify('Basel', 'Te faltan ~y~$'..(total-OwnData.money.money), 'info')
            end
        end
    end)
end

OpenBasketMenu2 = function(type)
    local elements = {
        { label = 'Tubo de Hierro (<span style="color: yellow;">1.900€</span>)', value = 'tubo_hierro', amount = 10, price = 1900 },
        { label = 'Hoja de Acero (<span style="color: yellow;">800€</span>)', value = 'hoja_acero', amount = 25, price = 800},
        { label = 'Mango de Madera (<span style="color: yellow;">3000€</span>)', value = 'mango_madera', amount = 10, price = 3000},
    }
    if type == "pistols" then
        elements = {}
        table.insert(elements, { label = 'Armazón de Pistola (<span style="color: yellow;">5.000€</span>)', value = 'arm_pistol', amount = 10, price = 5000 })
        table.insert(elements, { label = 'Muelle Recuperador (<span style="color: yellow;">5.000€</span>)', value = 'dock_pistol', amount = 25, price = 5000})
        table.insert(elements, { label = 'Cañón de Pistola (<span style="color: yellow;">5.000€</span>)', value = 'canon_pistol', amount = 10, price = 5000})
    elseif type == "subfusil" then
        elements = {}
        table.insert(elements, { label = 'Armazón de Subfusil (<span style="color: yellow;">17.500€</span>)', value = 'arm_subfusil', amount = 3, price = 17500 })
        table.insert(elements, { label = 'Cañón de Subfusil (<span style="color: yellow;">12.250€</span>)', value = 'canon_subfusil', amount = 3, price = 12250 })
        table.insert(elements, { label = 'Alza (<span style="color: yellow;">8.500€</span>)', value = 'alza_subfusil', amount = 6, price = 8500 })
        table.insert(elements, { label = 'Culata (<span style="color: yellow;">5.000€</span>)', value = 'culata_subfusil', amount = 6, price = 5000 })
    elseif type == "escopeta" then
        elements = {}
        table.insert(elements, { label = 'Armazón de Escopeta (<span style="color: yellow;">31.500€</span>)', value = 'arm_escopeta', amount = 2, price = 31500 })
        table.insert(elements, { label = 'Cañón de Escopeta (<span style="color: yellow;">24.500€</span>)', value = 'canon_escopeta', amount = 2 , price = 24500})
        table.insert(elements, { label = 'Disipador (<span style="color: yellow;">17.500€</span>)', value = 'disip_escopeta', amount = 2, price = 17500 })
        table.insert(elements, { label = 'Corredera (<span style="color: yellow;">14.000€</span>)', value = 'corre_escopeta', amount = 2, price = 14000 })
    elseif type == "fusil" then
        elements = {}
        table.insert(elements, { label = 'Armazón de Fusil (<span style="color: yellow;">52.500€</span>)', value = 'arm_fusil', amount = 3, price = 52500 })
        table.insert(elements, { label = 'Supresor (<span style="color: yellow;">35.000€</span>)', value = 'supre_fusil', amount = 3, price = 35000 })
        table.insert(elements, { label = 'Cañón de Fusil (<span style="color: yellow;">35.000€</span>)', value = 'canon_fusil', amount = 3, price = 35000 })
        table.insert(elements, { label = 'Empuñadura (<span style="color: yellow;">17.500€</span>)', value = 'emp_fusil', amount = 6, price = 17500 })
        table.insert(elements, { label = 'Culata Retráctil (<span style="color: yellow;">28.000€</span>)', value = 'culata_fusil', amount = 5, price = 28000 })
        table.insert(elements, { label = 'Mira Larga (<span style="color: yellow;">7.000€</span>)', value = 'largescope', amount = 5, price = 7000 })
    elseif type == "chaleco" then
        elements = {}
        table.insert(elements, { label = 'Chaleco Antibalas (<span style="color: yellow;">$2500</span>)', value = 'bulletproof', amount = 10, price = 2500 })
    end
    Wait(200)
    W.OpenMenu('Productos', 'basel_products', elements, function(data, name)
        W.DestroyMenu(name)

        W.OpenDialog("Cantidad", "dialog_qua", function(amount)
            W.CloseDialog()

            if tonumber(amount) and (tonumber(amount) <= data.amount) then
                table.insert(basket, {name = data.value, amount = amount, price = data.price * amount, max = data.amount})
                OpenBasketMenu()
            else
                W.Notify('Basel', 'Solo tengo ~y~x'..data.amount..'~w~ de ~y~'..data.label, 'info')
                OpenBasketMenu()
            end
        end)
    end)
end

Citizen.CreateThread(function()
    while true do
        local msec = 500
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        if playerPed and playerPos and MyData.gangData and MyData.gangData.level then
            local data = peds[1]
            local distance = #(playerPos - vec3(data.coords.x, data.coords.y, data.coords.z))

            if distance <= 4.0 then
                msec = 0

                W.ShowText(vec3(data.coords.x, data.coords.y, data.coords.z + 1.0), '~y~Basel\n~w~Interactuar', 0.6, 8)
                if distance <= 2.0 then
                    if IsControlJustPressed(0, 38) then
                        if not InDrop then
                            OpenBasketMenu()
                        else
                            W.Notify('Basel', 'Ya tienes ~y~un pedido~w~ en camino', 'info')
                        end
                    end
                end
            end
        end

        Citizen.Wait(msec)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetEntityAsMissionEntity(pilot, false, true)
        DeleteEntity(pilot)
        SetEntityAsMissionEntity(aircraft, false, true)
        DeleteEntity(aircraft)
        DeleteEntity(parachute)
        DeleteEntity(crate)
        RemovePickup(pickup)
        RemoveBlip(routeblip)
        RemoveBlip(blip)
        RemoveBlip(planeBlip)
        StopSound(soundID)
        ReleaseSoundId(soundID)

        for k,v in pairs(pedEntities) do
            DeleteEntity(v.entity)
        end

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end
    end
end)

local routeblip
RegisterNetEvent("Ox-Gangs:sendDrop", function(data)
    W.Notify('Basel', 'Ahora ve al ~y~punto marcado~w~ para esperar a la entrega de mercancia', 'info')
    if not routeblip then
		routeblip = AddBlipForCoord(5067.68, -4960.28, 31.77)
		SetBlipHighDetail(routeblip, true)
		SetBlipSprite(routeblip, 1)
		SetBlipScale(routeblip, 0.8)
		SetBlipColour(routeblip, 5)
		SetBlipRoute(routeblip, true)
		SetBlipRouteColour(routeblip, 5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Entrega de mercancía")
		EndTextCommandSetBlipName(routeblip)
	end
	local npc_distance = #(vector3(5067.68, -4960.28, 31.77) - GetEntityCoords(PlayerPedId()))
	while npc_distance > 1500.0 do Wait(1000) npc_distance = #(vector3(5067.68, -4960.28, 31.77) - GetEntityCoords(PlayerPedId())) end
    W.Notify('Basel', 'Espera al piloto...', 'info')
    RemoveBlip(routeblip)
    crateDrop(data)
end)