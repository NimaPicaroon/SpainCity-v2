MyData = {}
local player = W.GetPlayerData()
MarkersFunction = {
    pressed = false,

    ['armory'] = function (coords)
        W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~y~Armario\n~w~Abrir armario', 0.5, 8)
        if IsControlJustPressed(1, 38) and not MarkersFunction.pressed then
            MarkersFunction.pressed = true
            OpenArmory()
            Citizen.SetTimeout(1000, function()
                MarkersFunction.pressed = false
            end)
        end
    end,

    ['getvehs'] = function (coords)
        W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~g~Garaje\n~w~Ver vehículos', 0.8, 8)
        if IsControlJustPressed(1, 38) and not MarkersFunction.pressed then
            MarkersFunction.pressed = true

            local VehData = {}
            for k, v in pairs(points) do
                table.insert(VehData, {label = v.bike.label, value = v.bike.value, price = v.bike.price})
                table.insert(VehData, {label = v.car.label, value = v.car.value, price = v.car.price})
            end
            W.OpenMenu("Vehículos", "vehs_menu", VehData, function (data, name)
                local v = data.value
                SpawnVehicle(v)
                W.DestroyMenu(name)
            end)

            Citizen.SetTimeout(1000, function()
                MarkersFunction.pressed = false
            end)
        end
    end,
    ---comment
    ---@param coords any
    ['savevehs'] = function (coords)
        W.ShowText(vector3(coords.x, coords.y, coords.z + 1.2), '~r~Garaje\n~w~Guardar vehículos', 0.8, 8)
        if IsControlJustPressed(1, 38) and not MarkersFunction.pressed then
            MarkersFunction.pressed = true
            CreateThread(function ()
                local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                TaskLeaveVehicle(PlayerPedId(), Vehicle, 0)
                Wait(2000)
                DeleteVehicle(Vehicle)
            end)

            Citizen.SetTimeout(1000, function()
                MarkersFunction.pressed = false
            end)
        end
    end,
    ---comment
    ---@param coords any
    ['boss'] = function (coords, isBoss)
        if isBoss then
            W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~y~Jefe\n~w~Opciones de jefe', 0.5, 8)
            if IsControlJustPressed(1, 38) and not MarkersFunction.pressed then
                MarkersFunction.pressed = true
                if isBoss then
                    BossMenu()
                end

                Citizen.SetTimeout(1000, function()
                    MarkersFunction.pressed = false
                end)
            end
        end
    end,

    ['clothing'] = function (coords)
        W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~y~Vestuario\n~w~Ver conjuntos', 0.5, 8)
        if IsControlJustPressed(1, 38) and not MarkersFunction.pressed then
            MarkersFunction.pressed = true
            OpenWardrobe()
            Citizen.SetTimeout(1000, function()
                MarkersFunction.pressed = false
            end)
        end
    end
}

BossMenu = function()
    W.OpenMenu('Administrar tu Empresa', 'boss_menu', {
        { label = 'Administrar dinero', value = 'money' },
        --{ label = 'Administrar empleados', value = 'employees' },
    }, function(data, name)
        W.DestroyMenu(name)
        Wait(200)

        if data.value == 'money' then
            BossMoneyMenu()
        end
    end)
end

BossMoneyMenu = function()
    W.OpenMenu('Administrar dinero', 'money_boss_menu', {
        { label = 'Balance: <span style="color:yellow;">'..MyData.gangData.money..'€</span>', value = 'balance'},
        { label = 'Depositar dinero', value = 'deposit_money' },
        { label = 'Retirar dinero', value = 'withdraw_money' },
    }, function(data, name)
        W.DestroyMenu(name)
        Wait(200)

        if data.value == 'deposit_money' then
            W.OpenDialog('Cantidad a depositar', 'quantity_deposit_boss_menu', function(amount)
                W.CloseDialog()

                if tonumber(amount) and tonumber(amount) > 0 then
                    TriggerServerEvent('Ox-Gangs:blackmoneyAction', 'deposit', tonumber(amount), MyData.gang.name)
                    MyData.gangData.money = MyData.gangData.money + amount
                else
                    W.Notify('ERROR', 'Introduce una cantidad válida', 'error')
                end
            end)
        elseif data.value == 'withdraw_money' then
            W.OpenDialog('Cantidad a retirar', 'quantity_deposit_boss_menu', function(amount)
                W.CloseDialog()

                if tonumber(amount) and tonumber(amount) > 0 then
                    TriggerServerEvent('Ox-Gangs:blackmoneyAction', 'withdraw', tonumber(amount), MyData.gang.name)
                    MyData.gangData.money = MyData.gangData.money - amount
                else
                    W.Notify('ERROR', 'Introduce una cantidad válida', 'error')
                end
            end)
        end
    end)
end

OpenArmory = function()
    local elements = {}
    table.insert(elements, { label = "Mis conjuntos", value = "my" })
    table.insert(elements, { label = "Borrar conjuntos", value = "delete"})
    if MyData.gangData.name == "bloodfeathers" or MyData.gangData.name == "redclover" or MyData.gangData.name == "greenlight" or MyData.gangData.name == "redarmy" or MyData.gangData.name == "redskulls" then
    table.insert(elements, { label = 'Chalecos', value = "vest" })
    end
    table.insert(elements, { label = "---------------------------", value = "none" })
    table.insert(elements, { label = 'Administrar items', value = 'admin_items' })
    table.insert(elements, { label = 'Administrar armas', value = 'admin_weapons' })
    W.OpenMenu('Inventario', 'job_armory_gangcreator', elements, function(data, menu)
        W.DestroyMenu(menu)
        Wait(200)
        local player = W.GetPlayerData()
        if data.value == 'my' then
            W.TriggerCallback('ZC-Character:getOutfits', function(outfits)
                if outfits and #outfits > 0 then
                    local el = {}
                    for k,v in pairs(outfits) do
                        table.insert(el, {
                            label = v.name,
                            name = v.name,
                            skin = v.skin
                        })
                    end

                    W.OpenMenu('Tu vestuario', "outf_menu", el, function (data, name)
                        W.DestroyMenu(name)
                        TriggerEvent("ZC-Character:loadSkin", data.skin, true)
                    end)
                else
                    W.Notify('ERROR', 'No tienes ningún conjunto guardado', 'error')
                end
            end)
        elseif data.value == 'delete' then
            W.TriggerCallback('ZC-Character:getOutfits', function(outfits)
                if outfits and #outfits > 0 then
                    local el = {}
                    for k,v in pairs(outfits) do
                        table.insert(el, {
                            label = v.name,
                            name = v.name,
                            data = v
                        })
                    end

                    W.OpenMenu('Conjuntos', "outf_motel_menu_delete", el, function (data4, name4)
                        W.DestroyMenu(name4)
                        W.TriggerCallback("ZC-Character:deleteOutfit", function(deleted)
                            if deleted then
                                W.Notify('Conjuntos', 'Has borrado un conjunto', 'error')
                            end
                        end, data4.data)
                    end)
                else
                    W.Notify('Conjuntos', 'No tienes ningún conjunto guardado', 'error')
                end
            end)
        elseif data.value == 'vest' then
            -- if W.GetPlayerData().money.bank >= 500 then
                SetPedArmour(PlayerPedId(), 200)
            --     TriggerServerEvent("Ox-Gangs:vehiclesmoney", 500, player.gang.name)
            -- else
            --     W.Notify('ERROR', 'No tienes suficiente dinero.', 'error')
            -- end
        elseif data.value == 'none' then
            OpenArmory()
        elseif data.value == 'admin_items' then
            W.OpenMenu('Administrar items', 'job_armory_admin_items', {
                { label = 'Depositar items', value = 'deposit_items' },
                { label = 'Retirar items', value = 'withdraw_items' }
            }, function(data, menu)
                W.DestroyMenu(menu)
                Wait(200)

                if data.value == 'deposit_items' then
                    local items = {}
                    local inventory = W.GetItemsForInventory()['data']

                    for k, v in pairs(inventory) do
                        if GlobalState.Items[v.name].type ~= 'weapon' then
                            if type(v.metadata) == 'string' and type(json.decode(v.metadata)) == 'table' then
                                local tables = {}

                                for info, value in pairs(json.decode(v.metadata)) do
                                    if W.Metadata[info] then
                                        table.insert(tables, {
                                            label = W.Metadata[info],
                                            value = value
                                        })
                                    end
                                end
                                table.insert(items, {label = '['..v.quantity..'] '..v.label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                            else
                                if type(v.metadata) == 'table' then
                                    local tables = {}
                                    for k,v in pairs(v.metadata) do
                                        if W.Metadata[k] then
                                            table.insert(tables, {
                                                label = W.Metadata[k],
                                                value = v
                                            })
                                        end
                                    end
                                    table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                                else
                                    table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata})
                                end
                            end
                        end
                    end
                    Wait(200)

                    W.OpenMenu('Tu inventario', "inventory_menu", items, function (data, name)
                        W.DestroyMenu(name)
                        local ped = PlayerPedId()

                        if tonumber(data.quantity) > 1 then
                            W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                                W.CloseDialog()
                                amount = tonumber(amount)
                                if amount and amount <= tonumber(data.quantity) then
                                    SetCurrentPedWeapon(ped, -1569615261, true)
                                    TriggerServerEvent('storage:store', { name = MyData.gang.name, data = data, amount = amount, house = true })
                                    Wait(500)
                                    OpenArmory()
                                end
                            end)
                        else
                            TriggerServerEvent('storage:store', { name = MyData.gang.name, data = data, amount = 1, house = true })
                            Wait(500)
                            OpenArmory()
                        end
                    end)
                elseif data.value == 'withdraw_items' then
                    W.TriggerCallback('storage:get', function(inventory)
                        if inventory then
                            local items = {}
                            for kk, item in pairs(inventory) do
                                if GlobalState.Items[item.item].type  ~=  'weapon' then
                                    if type(item.metadata) == 'string' and type(json.decode(item.metadata)) == 'table' then
                                        local tables = {}
                                        for k,v in pairs(json.decode(item.metadata)) do
                                            if W.Metadata[k] then
                                                table.insert(tables, {
                                                    label = W.Metadata[k],
                                                    value = v
                                                })
                                            end
                                        end
                                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                                    else
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
                                end
                            end
                            Wait(200)
                            W.OpenMenu('Armario', "storage_menu", items, function (data, name)
                                W.DestroyMenu(name)
                                if tonumber(data.quantity) > 1 then
                                    W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                                        W.CloseDialog()
                                        amount = tonumber(amount)
                                        if amount and amount <= tonumber(data.quantity) then
                                            TriggerServerEvent('storage:withdraw', { name = MyData.gang.name, data = data, amount = amount, house = true })
                                            Wait(500)
                                            OpenArmory()
                                        end
                                    end)
                                else
                                    TriggerServerEvent('storage:withdraw', { name = MyData.gang.name, data = data, amount = 1, house = true })
                                    Wait(500)
                                    OpenArmory()
                                end
                            end)
                        end
                    end, MyData.gang.name)
                end
            end)
        elseif data.value == 'admin_blackmoney' then
            W.OpenMenu('Administrar dinero', 'admin_blackmoney', {
                { label = 'Balance <span style="color: green">($'..MyData.gangData.money..')</span>', value = 'none' },
                { label = 'Depositar dinero', value = 'deposit_money' },
                { label = 'Retirar dinero', value = 'withdraw_money' }
            }, function(data, menu)
                W.DestroyMenu(menu)
                Wait(200)

                if data.value == 'deposit_money' then
                    W.TriggerCallback('Ox-Gangs:getPlayerBlackmoney', function(blackMoney)
                        if blackMoney > 0 then
                            W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                                W.CloseDialog()
                                amount = tonumber(amount)
                                if amount and amount <= blackMoney then
                                    TriggerServerEvent('Ox-Gangs:blackmoneyAction', 'deposit', amount, MyData.gang.name)
                                    MyData.gangData.money = MyData.gangData.money + amount
                                    Wait(500)
                                    OpenArmory()
                                else
                                    W.Notify('Almacenamiento', 'Cantidad ~r~inválida o no tienes ~r~suficiente~w~.', 'error')
                                end
                            end)
                        else
                            W.Notify('Almacenamiento', 'No tienes ~r~dinero negro~w~ que depositar.', 'error')
                        end
                    end)
                elseif data.value == 'withdraw_money' then
                    W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                        W.CloseDialog()

                        amount = tonumber(amount)
                        if amount and amount <= MyData.gangData.money then
                            TriggerServerEvent('Ox-Gangs:blackmoneyAction', 'withdraw', amount, MyData.gang.name)
                            MyData.gangData.money = MyData.gangData.money - amount
                            Wait(500)
                            OpenArmory()
                        else
                            W.Notify('Almacenamiento', 'Cantidad ~r~inválida o no hay ~r~suficiente~w~ depositado.', 'error')
                        end
                    end)
                end
            end)
        elseif data.value == 'admin_weapons' then
            W.OpenMenu('Administrar armas', 'job_armory_admin_weapons', {
                { label = 'Depositar armas', value = 'deposit_weapons' },
                { label = 'Retirar armas', value = 'withdraw_weapons' }
            }, function(data, menu)
                W.DestroyMenu(menu)
                Wait(200)

                if data.value == 'deposit_weapons' then
                    local items = {}
                    local inventory = W.GetItemsForInventory()['data']

                    for k, v in pairs(inventory) do
                        if GlobalState.Items[v.name].type == 'weapon' then
                            if type(v.metadata) == 'string' and type(json.decode(v.metadata)) == 'table' then
                                local tables = {}

                                for info, value in pairs(json.decode(v.metadata)) do
                                    if W.Metadata[info] then
                                        table.insert(tables, {
                                            label = W.Metadata[info],
                                            value = value
                                        })
                                    end
                                end
                                table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                            else
                                if type(v.metadata) == 'table' then
                                    local tables = {}
                                    for k,v in pairs(v.metadata) do
                                        if W.Metadata[k] then
                                            table.insert(tables, {
                                                label = W.Metadata[k],
                                                value = v
                                            })
                                        end
                                    end
                                    table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                                else
                                    table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata})
                                end
                            end
                        end
                    end
                    Wait(200)

                    W.OpenMenu('Tu inventario', "inventory_menu", items, function (data, name)
                        W.DestroyMenu(name)

                        local ped = PlayerPedId()

                        if tonumber(data.quantity) > 1 then
                            W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                                W.CloseDialog()

                                amount = tonumber(amount)
                                if amount and amount <= tonumber(data.quantity) then
                                    SetCurrentPedWeapon(ped, -1569615261, true)
                                    TriggerServerEvent('storage:store', { name = MyData.gang.name, data = data, amount = amount })
                                    Wait(500)
                                    OpenArmory()
                                end
                            end)
                        else
                            TriggerServerEvent('storage:store', { name = MyData.gang.name, data = data, amount = 1 })
                            Wait(500)
                            OpenArmory()
                        end
                    end)
                elseif data.value == 'withdraw_weapons' then
                    W.TriggerCallback('storage:get', function(inventory)
                        if inventory then
                            local items = {}
                            for kk, item in pairs(inventory) do
                                if GlobalState.Items[item.item].type == 'weapon' then
                                    if type(item.metadata) == 'string' and type(json.decode(item.metadata)) == 'table' then
                                        local tables = {}
                                        for k,v in pairs(json.decode(item.metadata)) do
                                            if W.Metadata[k] then
                                                table.insert(tables, {
                                                    label = W.Metadata[k],
                                                    value = v
                                                })
                                            end
                                        end
                                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                                    else
                                        if type(item.metadata) == 'table' then
                                            local tables = {}
                                            for k,v in pairs(item.metadata) do
                                                if W.Metadata[k] then
                                                    table.insert(tables, {
                                                        label = W.Metadata[k],
                                                        value = v
                                                    })
                                                end
                                            end
                                            table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                                        else
                                            table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata})
                                        end
                                    end
                                end
                            end
                            Wait(200)
                            W.OpenMenu('Armario', "storage_menu", items, function (data, name)
                                W.DestroyMenu(name)
                                if tonumber(data.quantity) > 1 then
                                    W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                                        W.CloseDialog()
                                        amount = tonumber(amount)
                                        if amount and amount <= tonumber(data.quantity) then
                                            TriggerServerEvent('storage:withdraw', { name = MyData.gang.name, data = data, amount = amount })
                                            Wait(500)
                                            OpenArmory()
                                        end
                                    end)
                                else
                                    TriggerServerEvent('storage:withdraw', { name = MyData.gang.name, data = data, amount = 1 })
                                    Wait(500)
                                    OpenArmory()
                                end
                            end)
                        end
                    end, MyData.gang.name)
                end
            end)
        end
    end)
end