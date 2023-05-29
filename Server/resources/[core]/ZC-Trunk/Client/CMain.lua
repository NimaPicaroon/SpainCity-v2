local menuOpened = false

Props = {}
RegisterNetEvent('Ox-Needs:loadProps', function (props)
    Props = props
end)

RegisterKeyMapping('trunk', 'Abrir maletero', 'keyboard', 'Y')

RegisterCommand("trunk", function ()
    --if exports['Ox-Phone']:IsPhoneOpened() then return end
    if exports['Ox-Jobcreator']:IsHandcuffed() then return end
    if exports['ZC-Ambulance']:IsDead() then return end
    if exports['ZC-Menu']:isOpened() then return end

    if not menuOpened then
        if not HasAnimDictLoaded('mp_common') then
            RequestAnimDict('mp_common')
            while not HasAnimDictLoaded('mp_common') do
                Wait(1)
            end
        end

        if not HasAnimDictLoaded('mp_arresting') then
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Wait(1)
            end
        end

        if not HasAnimDictLoaded('mp_gun_shop_tut') then
            RequestAnimDict('mp_gun_shop_tut')
            while not HasAnimDictLoaded('mp_gun_shop_tut') do
                Wait(1)
            end
        end

        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, true) then return end
        local coords = GetEntityCoords(ped)
        local vehicle = W.GetClosestEntity(W.GetVehicles(), false, coords)
        local distanceToVeh = #(GetEntityCoords(vehicle) - coords)
        local locked = GetVehicleDoorLockStatus(vehicle)

        if vehicle > 0 and distanceToVeh < 4 then
            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
            local distanceToTrunk = #(trunkpos - coords)

            if distanceToTrunk <= 2 then
                local playersNearby = W.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 2.0)

                if #playersNearby == 0 then
                    if GetPedInVehicleSeat(vehicle, -1) == 0 then
                        local plate = GetVehicleNumberPlateText(vehicle)
                        plate = plate:gsub("%s+", "")

                        local OwnData =  W.GetPlayerData()
                        if OwnData.job and (OwnData.job.name == 'police' and OwnData.job.duty) then
                            TaskPlayAnim(ped, 'mp_gun_shop_tut', 'indicate_right', 8.0, -8, -1, 49, 0, 0, 0, 0)
                            Wait(1000)
                            ClearPedTasks(ped)
                            OpenTrunk(vehicle, plate)
                        else
                            if locked == 1 or locked == 0 then
                                TaskPlayAnim(ped, 'mp_gun_shop_tut', 'indicate_right', 8.0, -8, -1, 49, 0, 0, 0, 0)
                                Wait(1000)
                                ClearPedTasks(ped)
                                OpenTrunk(vehicle, plate)
                            else
                                W.Notify('MALETERO', 'Este maletero está cerrado')
                            end
                        end
                    end
                else
                    W.Notify('NOTIFICACION', 'Hay alguien demasiado cerca del maletero')
                end
            end
        end
    end
end, false)

function OpenTrunk(vehicle, plate)
    local category = false
    menuOpened = vehicle
    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    local locked = GetVehicleDoorLockStatus(vehicle)
    local class = GetVehicleClass(vehicle)
    local defaultWeight = Cfg.SpecialWeights[model] or Cfg.VehicleLimit[class]

    if locked == 1 or locked == 0 then
        if class == 5 or class == 7 then
            SetVehicleDoorOpen(vehicle, 4, false, true)
        else
            SetVehicleDoorOpen(vehicle, 5, false, true)
        end

        W.OpenMenu('Maletero - '..plate, 'trunk_menu', {
            { label = 'Administrar items', value = 'admin_items' },
        }, function(data, menu)
            category = true
            W.DestroyMenu(menu)
            Wait(200)

            if data.value == 'admin_items' then
                menuOpened = vehicle
                W.OpenMenu('Administrar items', 'selectedOption_menu', {
                    { label = 'Depositar items', value = 'deposit_items' },
                    { label = 'Retirar items', value = 'withdraw_items' }
                }, function(data2, menu2)
                    W.DestroyMenu(menu2)
                    Wait(200)

                    if data2.value == 'deposit_items' then
                        menuOpened = vehicle
                        local inventory = W.GetItemsForInventory()
                        local items = {}
                        for kk,item in pairs(inventory.data) do
                            if type(json.decode(item.metadata)) == 'table' then
                                local tables = {}
                                for k,v in pairs(json.decode(item.metadata)) do
                                    table.insert(tables, {
                                        label = W.Metadata[k],
                                        value = v
                                    })
                                end
                                table.insert(items, {label = '['..item.quantity..'] '..item.label, quantity = item.quantity, name = item.name, itemName = item.name, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                            else
                                table.insert(items, {label = '['..item.quantity..'] '..item.label, quantity = item.quantity, name = item.name, itemName = item.name, slotId = item.slotId, metadata = item.metadata})
                            end
                        end

                        Wait(200)
                        W.OpenMenu('Tu inventario', "yourinventoy_menu", items, function (data3, name3)
                            W.DestroyMenu(name3)
                            category = true
                            local ped = PlayerPedId()
                            local coords = GetEntityCoords(ped)
                            if tonumber(data3.quantity) > 1 then
                                Wait(200)
                                W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                                    W.CloseDialog()
                                    amount = tonumber(amount)
                                    if amount and amount <= tonumber(data3.quantity) then
                                        TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8, -1, 2, 0, 0, 0, 0)
                                        local prop = CreateObject(GetHashKey(Props[data3.name]), coords.x, coords.y, coords.z, true)
                                        FreezeEntityPosition(prop, true)
                                        SetEntityAsMissionEntity(prop)
                                        SetEntityCollision(prop, false, true)
                                        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
                                        Wait(1000)
                                        DeleteEntity(prop)
                                        SetCurrentPedWeapon(ped, -1569615261, true)
                                        TriggerServerEvent('storage:store', { name = plate, data = data3, amount = amount, defaultWeight = defaultWeight})
                                        Wait(1500)
                                        ClearPedTasks(ped)
                                        OpenTrunk(vehicle, plate)
                                    end
                                end)
                            else
                                TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8, -1, 2, 0, 0, 0, 0)
                                local prop = CreateObject(GetHashKey(Props[data3.name]), coords.x, coords.y, coords.z, true)
                                FreezeEntityPosition(prop, true)
                                SetEntityAsMissionEntity(prop)
                                SetEntityCollision(prop, false, true)
                                AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
                                Wait(3000)
                                DeleteEntity(prop)
                                TriggerServerEvent('storage:store', { name = plate, data = data3, amount = 1, defaultWeight = defaultWeight })
                                Wait(1500)
                                ClearPedTasks(ped)
                                OpenTrunk(vehicle, plate)
                            end
                        end, function ()
                            if category then
                                menuOpened = nil
                                category = false

                                if class == 5 or class == 7 then
                                    SetVehicleDoorShut(vehicle, 4, false)
                                else
                                    SetVehicleDoorShut(vehicle, 5, false)
                                end
                                TriggerServerEvent('ZC-Trunk:closeTrunk', plate)
                            end
                        end)
                    elseif data2.value == 'withdraw_items' then
                        menuOpened = vehicle
                        W.TriggerCallback('storage:get', function(inventory, weight)
                            if inventory then
                                local items = {}
        
                                for kk,item in pairs(inventory) do
                                    if type(item.metadata) == 'string' then
                                        item.metadata = json.decode(item.metadata)
                                    end
        
                                    if type(item.metadata) == 'table' then
                                        local tables = {}
                                        for k,v in pairs(item.metadata) do
                                            table.insert(tables, {
                                                label = W.Metadata[k],
                                                value = v
                                            })
                                        end
        
                                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                                    else
                                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata})
                                    end
                                end
                                Wait(200)
                                W.OpenMenu('Maletero - '.. plate.. ' - '..weight..'/'..defaultWeight, "trunk_menu", items, function (data2, name2)
                                    W.DestroyMenu(name2)
                                    local ped = PlayerPedId()
                                    local coords = GetEntityCoords(ped)
                                    category = true

                                    if tonumber(data2.quantity) > 1 then
                                        W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                                            W.CloseDialog()
                                            local amount = tonumber(amount)
                                            if amount and amount <= data2.quantity then
                                                TaskPlayAnim(ped, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
                                                Wait(1000)
                                                local prop = CreateObject(GetHashKey(Props[data2.name]), coords.x, coords.y, coords.z, true)
                                                FreezeEntityPosition(prop, true)
                                                SetEntityAsMissionEntity(prop)
                                                SetEntityCollision(prop, false, true)
                                                AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
                                                Wait(2000)
                                                DeleteEntity(prop)
                                                TriggerServerEvent('storage:withdraw', { name = plate, data = data2, amount = amount, defaultWeight = defaultWeight, house = true })
                                                Wait(500)
                                                ClearPedTasks(ped)
                                                OpenTrunk(vehicle, plate)
                                            end
                                        end)
                                    else
                                        TaskPlayAnim(ped, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
                                        Wait(1000)
                                        local prop = CreateObject(GetHashKey(Props[data2.name]), coords.x, coords.y, coords.z, true)
                                        FreezeEntityPosition(prop, true)
                                        SetEntityAsMissionEntity(prop)
                                        SetEntityCollision(prop, false, true)
                                        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
                                        Wait(2000)
                                        DeleteEntity(prop)
                                        TriggerServerEvent('storage:withdraw', { name = plate, data = data2, amount = 1, defaultWeight = defaultWeight, house = true })
                                        Wait(500)
                                        ClearPedTasks(ped)
                                        OpenTrunk(vehicle, plate)
                                    end
                                end, function ()
                                    if category then
                                        menuOpened = nil
                                        category = false

                                        if class == 5 or class == 7 then
                                            SetVehicleDoorShut(vehicle, 4, false)
                                        else
                                            SetVehicleDoorShut(vehicle, 5, false)
                                        end
                                        TriggerServerEvent('ZC-Trunk:closeTrunk', plate)
                                    end
                                end)
                            end
                        end, plate, defaultWeight)
                    end
                end)
            end
        end, function()
            Wait(300)

            if not category then
                menuOpened = nil

                if class == 5 or class == 7 then
                    SetVehicleDoorShut(vehicle, 4, false)
                else
                    SetVehicleDoorShut(vehicle, 5, false)
                end
                TriggerServerEvent('ZC-Trunk:closeTrunk', plate)
            end
        end)
    else
        W.Notify('MALETERO', 'El maletero está cerrado', 'error')
        TriggerServerEvent('ZC-Trunk:closeTrunk', plate)
        menuOpened = nil
        category = false
    end
end

CreateThread(function()
    while true do
        local sleep = 1000

        if DoesEntityExist(menuOpened) then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local trunk = GetOffsetFromEntityInWorldCoords(menuOpened, 0, -2.5, 0)

            if #(trunk - coords) > 3 then
                SetVehicleDoorShut(vehicle, 4, false)
                SetVehicleDoorShut(vehicle, 5, false)
                W.CloseDialog()
                W.DestroyMenu("yourinventoy_menu")
                W.DestroyMenu("trunk_menu")
                W.DestroyMenu("selectedOption_menu")
            end
        end
        Wait(sleep)
    end
end)