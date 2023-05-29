OpenArmory = function(id)
    W.OpenMenu('Inventario', 'house_Inv', {
        { label = 'Administrar items', value = 'admin_items' },
        { label = 'Administrar armas', value = 'admin_weapons' },
        { label = 'Mis Outfits', value = 'clothes' },
        { label = 'Borrar Outfits', value = 'delete' }
    }, function(data, menu)
        W.DestroyMenu(menu)
        Wait(200)
        if data.value == 'admin_items' then
            W.OpenMenu('Administrar items', 'house_items', {
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
                                    TriggerServerEvent('storage:store', { name = "house"..id, data = data, amount = amount, defaultWeight = 1000, house = true })
                                    Wait(500)
                                    OpenArmory(id)
                                end
                            end)
                        else
                            SetCurrentPedWeapon(ped, -1569615261, true)
                            TriggerServerEvent('storage:store', { name = "house"..id, data = data, amount = 1, defaultWeight = 1000, house = true })
                            Wait(500)
                            OpenArmory(id)
                        end
                    end)
                elseif data.value == 'withdraw_items' then
                    W.TriggerCallback('storage:get', function(inventory)
                        if inventory then
                            local items = {}
                            for kk, item in pairs(inventory) do
                                if GlobalState.Items[item.item] and GlobalState.Items[item.item].type ~='weapon' then
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
                            local title = 'Armario'

                            W.OpenMenu(title, "storage_menu", items, function (data, name)
                                W.DestroyMenu(name)
                                if data.quantity > 1 then
                                    W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                                        W.CloseDialog()
                                        amount = tonumber(amount)
                                        if amount and amount <= data.quantity then
                                            SetCurrentPedWeapon(ped, -1569615261, true)
                                            TriggerServerEvent('storage:withdraw', { name = "house"..id, data = data, amount = amount, defaultWeight = 1000, house = true })
                                            Wait(500)
                                            OpenArmory(id)
                                        end
                                    end)
                                else
                                    TriggerServerEvent('storage:withdraw', { name = "house"..id, data = data, amount = 1, defaultWeight = 1000, house = true })
                                    Wait(500)
                                    OpenArmory(id)
                                end
                            end)
                        end
                    end, "house"..id, 10000)
                end
            end)
        elseif data.value == 'admin_blackmoney' then
            W.TriggerCallback('Ox-Housing:getBlackMoney', function(houseMoney)
                W.OpenMenu('Administrar dinero negro', 'admin_blackmoney', {
                    { label = 'Balance <span style="color: red">($'..houseMoney..')</span>', value = 'none' },
                    { label = 'Depositar dinero', value = 'deposit_money' },
                    { label = 'Retirar dinero', value = 'withdraw_money' }
                }, function(data, menu)
                    W.DestroyMenu(menu)
                    Wait(200)

                    if data.value == 'deposit_money' then
                        local blackMoney =  xPlayer.money.blackmoney
                        if blackMoney > 0 then
                            W.OpenDialog("Cantidad a depositar ($"..blackMoney..")", "dialog_quaaa", function(amount)
                                W.CloseDialog()
                                amount = tonumber(amount)
                                if amount and amount <= blackMoney then
                                    TriggerServerEvent('Ox-Housing:blackmoneyAction', 'deposit', amount, id)
                                    Wait(500)
                                    OpenArmory(id)
                                else
                                    W.Notify('Almacenamiento', 'Cantidad ~r~inválida o no tienes ~r~suficiente~w~.', 'error')
                                end
                            end)
                        else
                            W.Notify('Almacenamiento', 'No tienes ~r~dinero negro~w~ que depositar.', 'error')
                        end
                    elseif data.value == 'withdraw_money' then
                        W.OpenDialog("Cantidad a retirar ($"..houseMoney..")", "dialog_quaaa", function(amount)
                            W.CloseDialog()

                            amount = tonumber(amount)
                            if amount and amount <= houseMoney then
                                TriggerServerEvent('Ox-Housing:blackmoneyAction', 'withdraw', amount, id)
                                Wait(500)
                                OpenArmory(id)
                            else
                                W.Notify('Almacenamiento', 'Cantidad ~r~inválida o no hay ~r~suficiente~w~ depositado.', 'error')
                            end
                        end)
                    end
                end)
            end, id)
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

                        if data.quantity > 1 then
                            W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                                W.CloseDialog()

                                amount = tonumber(amount)
                                if amount and amount <= data.quantity then
                                    SetCurrentPedWeapon(ped, -1569615261, true)
                                    TriggerServerEvent('storage:store', { name = "house"..id, data = data, amount = amount, defaultWeight = 1000, house = true })
                                    Wait(500)
                                    OpenArmory(id)
                                end
                            end)
                        else
                            TriggerServerEvent('storage:store', { name = "house"..id, data = data, amount = 1, defaultWeight = 1000, house = true })
                            Wait(500)
                            OpenArmory(id)
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
                            local title = 'Armario'

                            W.OpenMenu(title, "storage_menu", items, function (data, name)
                                W.DestroyMenu(name)
                                if data.quantity > 1 then
                                    W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                                        W.CloseDialog()
                                        amount = tonumber(amount)
                                        if amount and amount <= data.quantity then
                                            TriggerServerEvent('storage:withdraw', { name = "house"..id, data = data, amount = amount, defaultWeight = 1000, house = true })
                                            Wait(500)
                                            OpenArmory(id)
                                        end
                                    end)
                                else
                                    TriggerServerEvent('storage:withdraw', { name = "house"..id, data = data, amount = 1, defaultWeight = 1000, house = true })
                                    Wait(500)
                                    OpenArmory(id)
                                end
                            end)
                        end
                    end, "house"..id, 10000)
                end
            end)
        elseif data.value == 'clothes' then
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
        end
    end)
end