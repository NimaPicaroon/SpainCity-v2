JOB.AssignUnity = function()
    local pressed = false
    local assignations = {}
    local Elements = {
        { label = 'Revisar tu asignación', value = 'check-assignation' },
        { label = 'Unidad de patrullaje', value = 'patrol-unity'},
        { label = 'Unidades especiales', value = 'especial-unities' },
        { label = 'TACs', value = 'tacs' },
        { label = 'Robos', value = 'heists' }
    }

    W.OpenMenu("Menú de asignaciones", "assign-unity", Elements, function (data, menu)
        pressed = true
        W.DestroyMenu(menu)
        Wait(150)

        if data.value ~= 'check-assignation' then
            if W.Assignations[JOB.Variables.OwnJob.name] then
                for k,v in pairs(W.Assignations[JOB.Variables.OwnJob.name][data.value]) do
                    table.insert(assignations, { label = v.label, value = v.label })
                end
            end

            W.OpenMenu(data.label, "assign-unity", assignations, function (data2, menu2)
                W.DestroyMenu(menu2)

                W.Notify('Asignaciones', 'Te has asignado en la unidad de ~g~'..data2.label..'~w~.', 'verify')
                TriggerServerEvent('police:changeAssignation', data2.value)
            end, function()
                Wait(200)
                JOB.AssignUnity()
            end)
        else
            local playerData = W.GetPlayerData()

            if playerData.job.assignation == 'none' then
                return W.Notify('Asignaciones', 'No tienes ~r~ninguna ~w~unidad ~r~asignada', 'error')
            end

            W.Notify('Asignaciones', 'Tu asignación actual es: ~g~'..playerData.job.assignation..'', 'verify')
        end
    end, function()
        if not pressed then
            Wait(200)
            JOB.OpenInteractionMenu()
        end
    end)
end

exports('shape', function(playerVeh)
    local vehicle = StartShapeTestCapsule(GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, 1.0, 1.0), GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, 105.0, 0.0), 3.0, 10, playerVeh, 7)
    _, _, _, _, frontVehicle = GetShapeTestResult(vehicle)

    return frontVehicle
end)

JOB.SendBill = function()
    local id = nil
    local reason = nil
    local amount = nil

    W.OpenDialog('ID del jugador', 'billing_interactionmenu1', function(idd)
        W.CloseDialog()

        if idd and tonumber(idd) then
            id = idd
            Wait(200)
            
            W.OpenDialog('Razón de la Multa', 'billing_interactionmenu2', function(billingReason)
                W.CloseDialog()
        
                if billingReason then
                    reason = billingReason
                    Wait(200)
                    
                    W.OpenDialog('Precio de la Multa', 'billing_interactionmenu3', function(price)
                        W.CloseDialog()
                
                        if price then
                            amount = price
                            Wait(200)
                            
                            local data = { playerId = id, reason = reason, amount = amount, senderid = GetPlayerServerId(PlayerId()), sender = JOB.Variables.OwnJob.label, payed = false, society = JOB.Variables.OwnJob.name }
                            TriggerServerEvent('bill:send', data.playerId, data)
                        else
                            W.Notify('Multa', 'Multa ~r~inválida~w~', 'error')
                        end
                    end)
                else
                    W.Notify('Multa', 'Multa ~r~inválida~w~', 'error')
                end
            end)
        else
            W.Notify('Multa', 'ID ~r~inválida~w~', 'error')
        end
    end, function()
        Wait(200)
        JOB.OpenInteractionMenu()
    end)
end

JOB.Jail = function (id, comisaria, celda, time, peligroso)
    local pressed = false
    local elements = {}

    table['insert'](elements, {label = "ID del sujeto: " ..id, value = "id"})
    table['insert'](elements, {label = "Comisaria: " ..comisaria, value = "comisaria"})
    table['insert'](elements, {label = "Celda: " ..celda, value = "celda"})
    table['insert'](elements, {label = "Tiempo (min): " ..time, value = "time"})
    table['insert'](elements, {label = "Peligroso: " ..peligroso, value = "peligroso"})
    table['insert'](elements, {label = "Confirmar", value = "conf"})

    W.OpenMenu("Encarcelar", "menu_door", elements, function (data, name)
        pressed = true
        W.DestroyMenu(name)
        local v = data['value']
        if v == "id" then
            W.OpenDialog('ID del sujeto', 'iddd', function(idd)
                W.CloseDialog()
                if idd and tonumber(idd) then
                    id = idd
                    Wait(200)
                    JOB.Jail(id, comisaria, celda, time, peligroso)
                else
                    W.Notify('ERROR', 'ID ~r~inválida~w~', 'error')
                end
            end)
        elseif v == "comisaria" then
            Wait(200)
            local elements2 = {
                {label = "Mission Row", value = "vespucci"},
                {label = "Sandy", value = "sandy"},
                {label = "Paleto", value = "paleto"},
            }
            W.OpenMenu("Comisaria", "comi", elements2, function (data, name)
                W.DestroyMenu(name)
                if data.value then
                    comisaria = data.label
                    Wait(200)
                    JOB.Jail(id, comisaria, celda, time, peligroso)
                else
                    Wait(200)
                    JOB.Jail(id, comisaria, celda, time, peligroso)
                end
            end)
        elseif v == "celda" then
            if comisaria == "Mission Row" then
                W.OpenDialog('Celda 1-5', 'celda', function(idd)
                    W.CloseDialog()
                    if idd and tonumber(idd) and tonumber(idd) < 6 and tonumber(idd) > 0 then
                        celda = idd
                        Wait(200)
                        JOB.Jail(id, comisaria, celda, time, peligroso)
                    else
                        W.Notify('ERROR', 'Celda ~r~inválida~w~', 'error')
                    end
                end)
            elseif comisaria == "Sandy" then
                W.OpenDialog('Celda 1-3', 'celda', function(idd)
                    W.CloseDialog()
                    if idd and tonumber(idd) and tonumber(idd) < 4 and tonumber(idd) > 0 then
                        celda = idd
                        Wait(200)
                        JOB.Jail(id, comisaria, celda, time, peligroso)
                    else
                        W.Notify('ERROR', 'Celda ~r~inválida~w~', 'error')
                    end
                end)
            elseif comisaria == "Paleto" then
                W.OpenDialog('Celda 1-4', 'celda', function(idd)
                    W.CloseDialog()
                    if idd and tonumber(idd) and tonumber(idd) < 5 and tonumber(idd) > 0 then
                        celda = idd
                        Wait(200)
                        JOB.Jail(id, comisaria, celda, time, peligroso)
                    else
                        W.Notify('ERROR', 'Celda ~r~inválida~w~', 'error')
                    end
                end)
            else
                W.Notify('ERROR', 'Elige una comisaria', 'error')
            end
        elseif v == "time" then
            W.OpenDialog('Tiempo encarcelado (min)', 'time_', function(idd)
                W.CloseDialog()
                if idd and tonumber(idd) then
                    time = idd
                    Wait(200)
                    JOB.Jail(id, comisaria, celda, time, peligroso)
                else
                    W.Notify('ERROR', 'ID ~r~inválida~w~', 'error')
                end
            end)
        elseif v == "peligroso" then
            Wait(200)
            local elements2 = {
                {label = "Peligroso", value = "peligroso"},
                {label = "No Peligroso", value = "no_peligroso"},
            }
            W.OpenMenu("Peligrosidad", "Peligrosidad", elements2, function (data, name)
                W.DestroyMenu(name)
                if data.value then
                    peligroso = data.label
                    Wait(200)
                    JOB.Jail(id, comisaria, celda, time, peligroso)
                else
                    Wait(200)
                    JOB.Jail(id, comisaria, celda, time, peligroso)
                end
            end)
        elseif v == "conf" then
            if id == "" or comisaria == "" or celda == "" or time == "" or peligroso == "" then
                W.Notify('ERROR', 'Introduce todos los valores', 'error')
                Wait(200)
                JOB.Jail(id, comisaria, celda, time, peligroso)
            else
                TriggerServerEvent("Ox-Jobcreator:jail", tonumber(id), comisaria, tonumber(celda), tonumber(time), peligroso)
            end
        end
    end, function()
        if not pressed then
            Wait(200)
            JOB.OpenInteractionMenu()
        end
    end)
end

JOB.InternAlerts = function()
    local pressed = false
    local Elements = {
        { label = '254v', value = 1},
        { label = '10-06', value = 2 },
        { label = '10-06 - 6ADAM', value = 3 },
        { label = '10-20', value = 4 },
        --{ label = '10-98 al 10-95', value = 5 },
        { label = 'QRR', value = 5 }
    }

    W.OpenMenu("Alertas internas", "intern-alerts", Elements, function (data, menu)
        pressed = true
        W.DestroyMenu(menu)

        local playerPed = PlayerPedId()
		local playerPos = GetEntityCoords(playerPed)
        local playerVeh = GetVehiclePedIsIn(PlayerPedId())
        local playerStreet = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
        local playerLoc = GetStreetNameFromHashKey(playerStreet)
        local playerData = W.GetPlayerData()

        -- if not playerData.job.assignation or (playerData.job.assignation and playerData.job.assignation == 'none') then
        --     return W.Notify('Asignaciones', 'No tienes ningúna unidad asignada', 'error')
        -- end

        if data.value < 4 then
            if IsPedInAnyVehicle(playerPed) and playerVeh > 0 then
                local vehicle = StartShapeTestCapsule(GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, 1.0, 1.0), GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, 105.0, 0.0), 3.0, 10, playerVeh, 7)
                _, _, _, _, frontVehicle = GetShapeTestResult(vehicle)

                if DoesEntityExist(frontVehicle) then
                    local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(frontVehicle)))
                    local vehicleColour = GetVehicleColours(frontVehicle)
                    local vehiclePlate = GetVehicleNumberPlateText(frontVehicle)

                    if vehicleName == 'CARNOTFOUND' or vehicleName == 'NULL' then
                        vehicleName = 'Vehículo no reconocido'
                    end

                    if data.value == 1 then
                        ExecuteCommand('f En un 254v | Modelo: '..vehicleName..' | Color: '..W.VehiclesColor[tostring(vehicleColour)]..' | Matrícula: '..vehiclePlate..' | '..playerLoc..'.')
                    elseif data.value == 2 then
                        ExecuteCommand('f Realizando 10-06 | Modelo: '..vehicleName..' | Color: '..W.VehiclesColor[tostring(vehicleColour)]..' | Matrícula: '..vehiclePlate..' | '..playerLoc..'.')
                    elseif data.value == 3 then
                        ExecuteCommand('entorno 10-06 6-ADAM | '..playerData.identity.name..' '..playerData.identity.lastname..' | '..playerData.job.ranklabel..'.')
                    else
                        ExecuteCommand('entorno 10-20 '..playerData.identity.name..' '..playerData.identity.lastname..' | '..playerData.job.ranklabel..'.')
                        -- ExecuteCommand('f 10-20 | '..playerLoc..'.')
                    end
                else
                    W.Notify('Alertas internas', 'No hay ningún vehículo frente a ti.', 'error')
                end
            else
                local vehicle = JOB.GetClosestVehicle(playerPos)

                if DoesEntityExist(vehicle) then
                    local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                    local vehicleColour = GetVehicleColours(vehicle)
                    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

                    if vehicleName == 'CARNOTFOUND' or vehicleName == 'NULL' then
                        vehicleName = 'Vehículo no reconocido'
                    end

                    if data.value == 1 then
                        ExecuteCommand('f En un 254v | Modelo: '..vehicleName..' | Color: '..W.VehiclesColor[tostring(vehicleColour)]..' | Matrícula: '..vehiclePlate..' | '..playerLoc..'.')
                    elseif data.value == 2 then
                        ExecuteCommand('f Realizando 10-06 | Modelo: '..vehicleName..' | Color: '..W.VehiclesColor[tostring(vehicleColour)]..' | Matrícula: '..vehiclePlate..' | '..playerLoc..'.')
                    elseif data.value == 3 then
                        ExecuteCommand('entorno 10-06 6-ADAM | '..playerData.identity.name..' '..playerData.identity.lastname..' | '..playerData.job.ranklabel..'.')
                    else
                        ExecuteCommand('entorno 10-20 '..playerData.identity.name..' '..playerData.identity.lastname..' | '..playerData.job.ranklabel..'.')
                        --ExecuteCommand('f 10-20 | '..playerLoc..'.')
                    end
                end
            end
        elseif data.value == 4 then
            ExecuteCommand('entorno 10-20 '..playerData.identity.name..' '..playerData.identity.lastname..' | '..playerData.job.ranklabel..'.')
            -- ExecuteCommand('f 10-20 | '..playerLoc..'.')
        else
            TriggerServerEvent('Ox-Jobcreator:QRR', playerPos, playerData)
        end
    end, function()
        if not pressed then
            Wait(200)
            JOB.OpenInteractionMenu()
        end
    end)
end

RegisterNetEvent('jobcreatorv2:jailClient', function(id, time, name)
    ExecuteCommand('f '..name..' | '..time..' | Nº de preso: '..id)
end)

JOB.OpenCitizenMenu = function ()
    local Elements = {}
    table.insert(Elements, { label = "Esposar", value = "handcuff" })
    table.insert(Elements, { label = "Desesposar", value = "rhandcuff" })
    table.insert(Elements, { label = "Coger del brazo/Soltar del brazo", value = "drag" })
    table.insert(Elements, { label = "Meter en vehículo", value = "putveh" })
    table.insert(Elements, { label = "Sacar del vehículo", value = "remveh" })

    W.OpenMenu("Interacción ciudadana", "citizen-cumbai", Elements, function (data, menu)
        W.DestroyMenu(menu)
        if data.value == "handcuff" then
            local player, distance = JOB.GetClosestPlayer()
            local ped = PlayerPedId()
            local playerheading = GetEntityHeading(ped)
            local playerlocation = GetEntityForwardVector(PlayerPedId())
            local playerCoords = GetEntityCoords(ped)
            if distance < 2 and distance ~= -1 and player then
                ExecuteCommand('me le coloca los grilletes en ambas manos')
                TriggerServerEvent('jobcreatorv2:server:requestarrest', GetPlayerServerId(player), playerheading, playerCoords, playerlocation)
            end
        elseif data.value == "rhandcuff" then
            local player, distance = JOB.GetClosestPlayer()
            local ped = PlayerPedId()
            local playerheading = GetEntityHeading(ped)
            local playerlocation = GetEntityForwardVector(PlayerPedId())
            local playerCoords = GetEntityCoords(ped)
            if distance < 2 and distance ~= -1 and player then
                ExecuteCommand('me le retira los grilletes')
                TriggerServerEvent('jobcreatorv2:server:requestunaarrest', GetPlayerServerId(player), playerheading, playerCoords, playerlocation)
            end
        elseif data.value == "drag" then
            local player, distance = JOB.GetClosestPlayer()
            if distance < 3 and distance ~= -1  and player then
                TriggerServerEvent('jobcreatorv2:server:escort', GetPlayerServerId(player))
                if not JOB.Variables.IsDragging then
                    ExecuteCommand('me le sujeta del brazo y le lleva consigo')
                    JOB.Loadanimdict('switch@trevor@escorted_out')
                    TaskPlayAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
                    JOB.Variables.IsDragging = true
                else
                    ExecuteCommand('me le suelta del brazo')
                    Wait(500)
                    ClearPedTasks(PlayerPedId())
                    JOB.Variables.IsDragging = false
                end
            end
        elseif data.value == "putveh" then
            local player, distance = JOB.GetClosestPlayer()
            if distance < 3 and distance ~= -1 and player then
                ExecuteCommand('me le introduce en el vehículo')
                TriggerServerEvent('jobcreatorv2:server:putinvehicle', GetPlayerServerId(player))
            end
        elseif data.value == "remveh" then
            local player, distance = JOB.GetClosestPlayer()
            if distance < 3 and distance ~= -1 and player then
                ExecuteCommand('me le saca del vehículo')
                TriggerServerEvent('jobcreatorv2:server:outfromveh', GetPlayerServerId(player))
            end
        end
    end, function()
        Wait(200)
        JOB.OpenInteractionMenu()
    end)
end

JOB.Revive = function (player)
    local deadPeople = exports['ZC-Ambulance']:GetDeadPeople()

    if(deadPeople[GetPlayerServerId(player)])then
        local playerPed = PlayerPedId()

        W.Notify('REANIMACIÓN', 'Reanimación en curso')

        local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

        for i=1, 15, 1 do
            Wait(900)

            JOB.Loadanimdict(lib)
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        end

        TriggerServerEvent("ZC-Ambulance:revivePlayerFromJob", GetPlayerServerId(player))

        ClearPedBloodDamage(playerPed)

        W.Notify('NOTIFICACIÓN', 'La persona ha sido reanimada', 'verify')
    else
        W.Notify('NOTIFICACIÓN', 'La persona no está inconsciente', 'error')
    end
end

JOB.Heal = function (player, type)
    local deadPeople = exports['ZC-Ambulance']:GetDeadPeople()
    if not deadPeople[GetPlayerServerId(player)] then
        local playerPed = PlayerPedId()
        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        Wait(5000)
        Wait(5000)
        ClearPedTasks(playerPed)
        TriggerServerEvent('ZC-Ambulance:healFromJob', GetPlayerServerId(player), type)
    else
        W.Notify('NOTIFICACIÓN', 'La persona está inconsciente', 'error')
    end
end

JOB.OpenNpcsMenu = function ()
    local Elements = {}
    table.insert(Elements, { label = "Esposar", value = "handcuff" })
    table.insert(Elements, { label = "Desesposar", value = "rhandcuff" })
    table.insert(Elements, { label = "Coger del brazo/Soltar del brazo", value = "drag" })
    table.insert(Elements, { label = "Meter en vehículo", value = "putveh" })
    table.insert(Elements, { label = "Sacar del vehículo", value = "remveh" })
    table.insert(Elements, { label = "Amenazar y arrodillar", value = "surrender" })

    W.OpenMenu("Interacción Npcs", "citizen-cumbaiwwwi", Elements, function (data, menu)
        W.DestroyMenu(menu)
        if data.value == "handcuff" then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'Sonido_Esposar_Policia', 0.5)
            TriggerEvent("Ox-Interaction:arrestarNPC")
            TriggerEvent("Ox-Interaction:detenidoNPC")
            Wait(5400)
            TriggerEvent('Ox-Interaction:handcuffNPC')
        elseif data.value == "surrender" then
            TriggerEvent('Ox-Interaction:SurrenderNPC')
        elseif data.value == "rhandcuff" then
            TriggerEvent('Ox-Interaction:getuncuffedNPC')
            TriggerEvent("Ox-Interaction:douncuffingNPC")
        elseif data.value == "drag" then
            TriggerEvent('Ox-Interaction:EscoltarNPC')
        elseif data.value == "putveh" then
            TriggerEvent('Ox-Interaction:putInVehicleNPC')
        elseif data.value == "remveh" then
            TriggerEvent('Ox-Interaction:OutPlayerVehicleNPC')
        end
    end, function()
        Wait(200)
        JOB.OpenInteractionMenu()
    end)
end

JOB.OpenTradeMenu = function ()
    local Elements = {}
    table.insert(Elements, {label = ('Vender vehículo'), value = 'sell'})
    table.insert(Elements, {label = ('Comprar vehículo'), value = 'buy'})

    W.OpenMenu("Interacción con vehículos", "citizen-sdaasdasdasdas", Elements, function (data, menu)
        W.DestroyMenu(menu)
        if data.value == "sell" then
            local closestPlayer, playerDistance = W.GetClosestPlayer()
            if closestPlayer ~= -1 and playerDistance <= 3.0 then
                TriggerServerEvent('larrys:openContract', GetPlayerServerId(PlayerId()))
            else
                W.Notify("VENTA", 'El comprador debe estar al lado tuya', "error")
            end
        elseif data.value == "buy" then
            local closestPlayer, playerDistance = W.GetClosestPlayer()
            if closestPlayer ~= -1 and playerDistance <= 3.0 then
                local target = GetPlayerServerId(closestPlayer)
                TriggerServerEvent('larrys:openContract', target)
            else
                W.Notify("Compra", 'El vendedor debe estar al lado tuya', "error")
            end
        end
    end, function()
        Wait(200)
        JOB.OpenInteractionMenu()
    end)
end

JOB.OpenAmbulanceMenu = function ()
    local Elements = {}
    table.insert(Elements, {label = ('Reanimar'), value = 'ambulance_revive'})
    table.insert(Elements, {label = ('Cura pequeña'), value = 'ambulance_small'})
    table.insert(Elements, {label = ('Cura grave'), value = 'ambulance_big'})

    W.OpenMenu("Interacción ciudadana", "citizen-cumbaii", Elements, function (data, menu)
        W.DestroyMenu(menu)
        if data.value == "ambulance_revive" then
            local player, distance = JOB.GetClosestPlayer()
            if distance < 3 and distance ~= -1 and player then
                JOB.Revive(player)
            end
        elseif data.value == "ambulance_small" then
            local player, distance = JOB.GetClosestPlayer()
            if distance < 3 and distance ~= -1 and player then
                JOB.Heal(player, 'small')
            end
        elseif data.value == "ambulance_big" then
            local player, distance = JOB.GetClosestPlayer()
            if distance < 3 and distance ~= -1 and player then
                JOB.Heal(player, 'big')
            end
        end
    end, function()
        Wait(200)
        JOB.OpenInteractionMenu()
    end)
end

JOB.Objects = function ()
    local Elements = {
        {label = ('Cono'), model = 'prop_roadcone02a'},
        {label = ('Barrera'), model = 'prop_barrier_work05'},
        {label = ('Barrera naranja'), model = 'prop_mp_barrier_02b'},
        {label = ('Barrera flecha derecha'), model = 'prop_mp_arrow_barrier_01'},
        {label = ('Barrera pequeña'), model = 'prop_barrier_work01a'},
        {label = ('Cono luces'), model = 'prop_air_conelight'},
        {label = ('Cono simple'), model = 'prop_roadcone02c'},
        {label = ('Pinchos'), model = 'p_ld_stinger_s'},
        {label = ('Caja mediana'), model = 'prop_box_wood07a'},
        {label = ('Caja grande'), model = 'prop_box_wood08a'}
    }

    W.OpenMenu("Objetos", "obj", Elements, function (data, menu)
        W.DestroyMenu(menu)
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        local forward   = GetEntityForwardVector(playerPed)
        local x, y, z   = table.unpack(coords + forward * 1.0)

        if data.model == 'prop_roadcone02a' then
            z = z - 1.8
        elseif data.model == 'prop_air_conelight' then
            z = z - 0.7
        end

        W.SpawnObject(data.model, {x = x, y = y, z = z}, function(obj)
            SetEntityHeading(obj, GetEntityHeading(playerPed))
            PlaceObjectOnGroundProperly(obj)
        end)
    end, function()
        Wait(200)
        JOB.OpenInteractionMenu()
    end)
end

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s',
		'prop_mp_barrier_02b',
		'prop_mp_arrow_barrier_01',
		'prop_barrier_work01a',
		'prop_air_conelight',
        'prop_box_wood07a',
        'prop_box_wood08a',
		'prop_roadcone02c'
	}

	while true do
        local wait = 5000
        if GlobalState and JOB.Variables.OwnJob and GlobalState[JOB.Variables.OwnJob.name.."-guille"].options['objects'] then
            wait = 1000
            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)

            local closestDistance = -1
            local closestEntity   = nil

            for i=1, #trackedEntities, 1 do
                local object = GetClosestObjectOfType(coords, 1.5, GetHashKey(trackedEntities[i]), false, false, false)


                if DoesEntityExist(object) then
                    local objCoords = GetEntityCoords(object)
                    local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

                    if closestDistance == -1 or closestDistance > distance then
                        closestDistance = distance
                        closestEntity   = object
                    end
                end
            end

            if closestDistance ~= -1 and closestDistance <= 2 then
                wait = 0
                W.ShowText(GetEntityCoords(closestEntity) + vector3(0,0,1), '~y~Objeto\n~w~ Borrar', 0.8, 8)
                if IsControlJustReleased(0, 38) then
                    if LastEntity ~= closestEntity then
                        LastEntity = closestEntity
                        DeleteEntity(closestEntity)
                    end
                end
            end
        end

        Wait(wait)
	end
end)

JOB.OpenVehicleMenu = function(veh)
    local Elements = {}
    table.insert(Elements, { label = "Confiscar", value = "delete" })

    table.insert(Elements, { label = "Reparar", value = "repair" })

    table.insert(Elements, { label = "Limpiar", value = "clean" })

    W.OpenMenu("Interacción con vehículos", "veh-cumbai", Elements, function (data, menu)
        W.DestroyMenu(menu)
        local ped = PlayerPedId()
        if data.value == "delete" then
            TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
            Wait(5000)
            NetworkRequestControlOfEntity(veh)
            SetEntityAsMissionEntity(veh, false, false)
            DeleteEntity(veh)
            ClearPedTasks(ped)
            TriggerServerEvent("jobcreadotr:dis")
            ExecuteCommand('do Pasados unos minutos, llegaría una grúa del deposito a retirar el vehículo de la zona y procedería a llevarlo al deposito policial.')
        elseif data.value == "clean" then
            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
            Wait(10000)
            SetVehicleDirtLevel(veh, 0)
            ClearPedTasks(ped)
            W.Notify('NOTIFICACIÓN',"El vehículo ha sido limpiado", 'verify')
        elseif data.value == "repair" then
            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_VEHICLE_MECHANIC', 0, true)
            Wait(10000)
            W.Notify('NOTIFICACIÓN',"El vehículo ha sido reparado", 'verify')
            SetVehicleFixed(veh)
            ClearPedTasks(ped)
        end
    end, function()
        Wait(200)
        JOB.OpenInteractionMenu()
    end)
end

JOB.GetOwnVehicles = function(identifier)
    local garages = exports['ZC-Garages']:getVehicles()
    local vehicles = {}

    for key, value in next, garages do
        if value.owner == identifier then
            value.model = GetHashKey(value.model)
            table.insert(vehicles, { label = GetLabelText(GetDisplayNameFromVehicleModel(value.model))..' - '..value.plate, model = value.model, value = value.garage, plate = value.plate, vehicleshop = value.vehicleshop })
        end
    end

    W.OpenMenu("Tus Vehículos", "inter-menu-cumbai-vehicle", vehicles, function (data, menu)
        W.DestroyMenu(menu)

        if not data or not data.value then
            return
        end
        local elements2 = {}
        table.insert(elements2, {label = "Ver localización del vehículo", value = "view_location_veh"})
        table.insert(elements2, {label = "Hacer copia de llave", value = "copy_keys_gps"})
        
        Wait(250)
        W.OpenMenu("Información - " .. data.plate, "menu-vehicle-info-options", elements2, function (data2, menu2)
            W.DestroyMenu(menu2)
            if not data2 or not data2.value then
                return
            end
            if(data2.value == "view_location_veh")then
                W.Notify('Vehículos', 'Tu '..data.label..' está en el '..data.value, 'info')
            elseif(data2.value == "copy_keys_gps")then
                TriggerServerEvent('vehicleshop:copyKey', data.plate, data.model)
            end
        end, function()
            Wait(200)
            JOB.GetOwnVehicles(identifier)
        end)
    end, function()
        Wait(200)
        print('closed bitch')
        JOB.GetOwnVehicles(identifier)
    end)
end

exports('getOwnVehicles', JOB.GetOwnVehicles)

JOB.OpenInteractionMenu = function ()
    --if exports['Ox-Phone']:IsPhoneOpened() then return end
    if exports['Ox-Jobcreator']:IsHandcuffed() then return end
    if exports['ZC-Ambulance']:IsDead() then return end

    if JOB.Variables.OwnJob then
        local Elements = {}
        local MenuData = GlobalState[JOB.Variables.OwnJob.name.."-guille"]
        local ParsedData = nil
        if(MenuData and MenuData.options)then
            ParsedData = MenuData.options
        end

        table.insert(Elements, {label = "Interaccion NPC", value = "npcs"})

        if (JOB.Variables.OwnJob.duty and ParsedData and ParsedData['handcuff']) or W.GetPlayerData().gang.name then
            table.insert(Elements, { label = "Interacción ciudadana", value = "citizen" })
            table.insert(Elements, { label = 'Robar', value = 'search' })
        end

        if JOB.Variables.OwnJob.duty then
            if JOB.Variables.OwnJob.name == 'ambulance' or JOB.Variables.OwnJob.name == 'professionals' then
                table.insert(Elements, { label = 'Interacción sanitaria', value = 'citizenAmbulance' })
            end

            if JOB.Variables.OwnJob.name == 'police' then
                table.insert(Elements, { label = 'Referencias', value = 'referees' })
                table.insert(Elements, { label = 'Avisos radio interna', value = 'internradio' })
                table.insert(Elements, { label = 'Cachear', value = 'search' })
            end

            if JOB.Variables.OwnJob.name == 'ambulance' or JOB.Variables.OwnJob.name == 'police' then
                table.insert(Elements, { label = 'Menú de asignaciones', value = 'asignunity' })
            end

            if JOB.Variables.OwnJob.name == 'madrazo' then
                table.insert(Elements, { label = "Interacción con vehículos", value = "sellvehs" })
            end

            if JOB.Variables.OwnJob.name ~= 'unemployed' then
                table.insert(Elements, { label = "Facturas", value = "billing" })
            end

            if ParsedData and ParsedData['vehinfo'] or JOB.Variables.OwnJob.name == 'lsc' or JOB.Variables.OwnJob.name == 'lst' or JOB.Variables.OwnJob.name == 'hayes' or JOB.Variables.OwnJob.name == 'mecaruta' or JOB.Variables.OwnJob.name == 'bennys' or JOB.Variables.OwnJob.name == 'mecapaleto' then -- yeyi
                table.insert(Elements, { label = "Interacción con vehículos", value = "vehinfo" })
            end

            if ParsedData and ParsedData['objects'] or JOB.Variables.OwnJob.name == 'police' then
                table.insert(Elements, { label = "Colocar objetos", value = "objects" })
            end
        end

        W.OpenMenu("Menú de Interacción", "inter-menu-cumbai", Elements, function (data, menu)
            W.DestroyMenu(menu)
            if data.value == "citizen" then
                Wait(150)
                JOB.OpenCitizenMenu()
            elseif data.value == "npcs" then
                Wait(150)
                JOB.OpenNpcsMenu()
            elseif data.value == "citizenAmbulance" then
                Wait(150)
                JOB.OpenAmbulanceMenu()
            elseif data.value == "sellvehs" then
                Wait(150)
                JOB.OpenTradeMenu()
            elseif data.value == 'referees' then
                Wait(150)
                exports['Ox-References']:openMenu()
            elseif data.value == 'internradio' then
                Wait(150)
                JOB.InternAlerts()
            elseif data.value == 'asignunity' then
                Wait(150)
                JOB.AssignUnity()
            elseif data.value == "vehinfo" then
                if IsPedInAnyVehicle(PlayerPedId(), true) then W.Notify('NOTIFICACIÓN',"Bajate del vehículo", 'error') return end
                local coords = GetEntityCoords(PlayerPedId())
                local vehicle = W.GetClosestEntity(W.GetVehicles(), false, coords)
                local distanceToVeh = #(GetEntityCoords(vehicle) - coords)
                if vehicle > 0 and distanceToVeh < 3 then
                    Wait(150)
                    JOB.OpenVehicleMenu(vehicle)
                else
                    W.Notify('NOTIFICACIÓN',"Ningún vehículo cerca", 'error')
                end
            elseif data.value == "objects" then
                Wait(150)
                JOB.Objects()
            elseif data.value == "search" then
                local closestPlayer, playerDistance = W.GetClosestPlayer()
                target = GetPlayerServerId(closestPlayer)
                if closestPlayer == -1 or playerDistance > 3.0 then
                    W.Notify('Robar', 'No hay nadie cerca tuya', 'error')
                else
                    exports['ZC-Thief']:steal()
                end
            elseif data.value == 'billing' then
                JOB.SendBill()
            end
        end)
    end
end

RegisterCommand("interactionmenu", JOB.OpenInteractionMenu)
RegisterKeyMapping("interactionmenu", "Abrir menú de acciones de trabajo", "keyboard", "F6")

RegisterNetEvent('jobcreatorv2:client:getarrested', function(playerheading, playercoords, playerlocation)
	local ped = PlayerPedId()
	SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(ped, x, y, z - 1)
	SetEntityHeading(ped, playerheading)
	Wait(250)
	JOB.Loadanimdict('mp_arrest_paired')
	TaskPlayAnim(ped, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Wait(3760)
	JOB.Variables.Handcuff = true
    LoadHandcuff()
	JOB.Loadanimdict('mp_arresting')
	TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    SetEnableHandcuffs(ped, true)
    DisablePlayerFiring(ped, true)
    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
    SetPedCanPlayGestureAnims(ped, false)
end)

RegisterNetEvent('jobcreatorv2:client:doarrested', function()
    Wait(250)
	JOB.Loadanimdict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
    Wait(3000)
end)

IsHandcuffed = function ()
    return JOB.Variables.Handcuff
end

LoadHandcuff = function()
    CreateThread(function ()
        while true do
            Wait(0)
            local playerPed = PlayerPedId()

            if JOB.Variables.Handcuff then
                --DisableControlAction(0, 1, true) -- Disable pan
                --DisableControlAction(0, 2, true) -- Disable tilt
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                DisableControlAction(0, 25, true) -- Aim
                DisableControlAction(0, 263, true) -- Melee Attack 1
    
                DisableControlAction(0, 45, true) -- Reload
                DisableControlAction(0, 22, true) -- Jump
                DisableControlAction(0, 44, true) -- Cover
                DisableControlAction(0, 37, true) -- Select Weapon
                DisableControlAction(0, 23, true) -- Also 'enter'?
    
                DisableControlAction(0, 288,  true) -- Disable phone
                DisableControlAction(0, 289, true) -- Inventory
                DisableControlAction(0, 170, true) -- Animations
                DisableControlAction(0, 167, true) -- Job
    
                DisableControlAction(0, 0, true) -- Disable changing view
                DisableControlAction(0, 26, true) -- Disable looking behind
                DisableControlAction(0, 73, true) -- Disable clearing animation
                DisableControlAction(2, 199, true) -- Disable pause screen
    
                DisableControlAction(0, 59, true) -- Disable steering in vehicle
                DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
                DisableControlAction(0, 72, true) -- Disable reversing in vehicle
    
                DisableControlAction(2, 36, true) -- Disable going stealth
    
                DisableControlAction(0, 47, true)  -- Disable weapon
                DisableControlAction(0, 264, true) -- Disable melee
                DisableControlAction(0, 257, true) -- Disable melee
                DisableControlAction(0, 140, true) -- Disable melee
                DisableControlAction(0, 141, true) -- Disable melee
                DisableControlAction(0, 142, true) -- Disable melee
                DisableControlAction(0, 143, true) -- Disable melee
                DisableControlAction(0, 75, true)  -- Disable exit vehicle
                DisableControlAction(27, 75, true) -- Disable exit vehicle

                if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 and not LocalPlayer.state.handcuffed then
                    JOB.Loadanimdict('mp_arresting')
                    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                end
            else
                break
            end
        end
    end)
end

RegisterNetEvent('jobcreatorv2:client:getuncuffed', function(playerheading, playercoords, playerlocation)
    LocalPlayer.state.handcuffed = true
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z - 1)
	SetEntityHeading(PlayerPedId(), playerheading)
	Wait(250)
	JOB.Loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5500)
	JOB.Variables.Handcuff = false
    LocalPlayer.state.handcuffed = false
    ClearPedTasks(PlayerPedId())
    SetEnableHandcuffs(PlayerPedId(), false)
    DisablePlayerFiring(PlayerPedId(), false)
    SetPedCanPlayGestureAnims(PlayerPedId(), true)
    UncuffPed(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    EnableAllControlActions(0)
end)

RegisterNetEvent('jobcreatorv2:client:douncuffing', function()
	Wait(250)
	JOB.Loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5500)
	ClearPedTasks(PlayerPedId())
end)

local drag = false
local dragUser

RegisterNetEvent('jobcreatorv2:client:drag', function(playerWhoDrag)
    if JOB.Variables.Handcuff then
        drag = not drag
        dragUser = playerWhoDrag
        JOB.HandleDrag()
	end
end)

---comment
JOB.HandleDrag = function()
    CreateThread(function ()
        local wasDragged
        while true do
            Wait(0)
            local playerPed = PlayerPedId()

            if JOB.Variables.Handcuff and drag then
                local targetPed = GetPlayerPed(GetPlayerFromServerId(dragUser))

                if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                    if not wasDragged then
                        AttachEntityToEntity(playerPed, targetPed, 11816, 0.10, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                        wasDragged = true
                    else
                        Wait(1000)
                    end
                else
                    wasDragged = false
                    drag = false
                    DetachEntity(playerPed, true, false)
                end
            elseif wasDragged then
                wasDragged = false
                DetachEntity(playerPed, true, false)
            else
                break
            end
        end
    end)
end

JOB.GetClosestVehicle = function(coords)
	local vehicles = W.GetVehicles()
	local closestDistance, closestVehicle, coords = -1, -1, coords

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance = #(coords - vehicleCoords)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle, closestDistance = vehicles[i], distance
		end
	end

	return closestVehicle, closestDistance
end

RegisterNetEvent('jobcreatorv2:client:putInVehicle', function()
	if JOB.Variables.Handcuff then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if IsAnyVehicleNearPoint(coords, 5.0) then
            local vehicle = JOB.GetClosestVehicle(coords)

            if DoesEntityExist(vehicle) and AreAnyVehicleSeatsFree(vehicle) then
                local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
               
                for i = 1, maxSeats do
                    if IsVehicleSeatFree(vehicle, i) then
                        freeSeat = i
                        break
                    end
                end

                if freeSeat then
                    SetVehicleDoorOpen(vehicle, freeSeat, true, false)
                    Wait(500)
                    TaskEnterVehicle(playerPed, vehicle, -1, freeSeat, 1.0001, 1)

                    wasDragged = false
                end
            end
        end
	end
end)

RegisterNetEvent('jobcreatorv2:client:OutVehicle', function()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 16)
        Wait(1000)
        JOB.Loadanimdict('mp_arresting')
        TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end
end)

RegisterCommand('esposar', function()
	if JOB.Variables.OwnJob and JOB.Variables.OwnJob.name == 'police' and JOB.Variables.OwnJob.duty then
		local closestPlayer, closestDistance = JOB.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			local ped = PlayerPedId()
			local playerheading = GetEntityHeading(ped)
			local playerlocation = GetEntityForwardVector(ped)
			local playerCoords = GetEntityCoords(ped)

			ExecuteCommand("me le esposa las manos")

			TriggerServerEvent('jobcreatorv2:server:requestarrest', GetPlayerServerId(closestPlayer), playerheading, playerCoords, playerlocation)
		else
			W.Notify('ESPOSAR', 'No hay nadie cerca para esposar', 'error')
		end
	end
end, false)

RegisterKeyMapping('esposar', 'Esposar (LSPD)', 'keyboard', 'o')

RegisterCommand("jail", function(source, args)
    local id = args[1]
    local time = args[2]

    if JOB.Variables.OwnJob and JOB.Variables.OwnJob.name == 'police' and JOB.Variables.OwnJob.duty then
        TriggerServerEvent("Ox-Jobcreator:jail", tonumber(id), tonumber(time))
    end
end, false)