Shops = setmetatable({ }, Shops)
local closestShops = {}
Shops.Variables = {
    IsOpened = false,
    Props = {},
}
Props = {}
Basket = {
    ['data'] = {{action = 'buy', label= 'Pagar'}, {action = 'cancel', label = 'Cancelar Compra'}, {action = '', label= '[Tu compra]'}},
    ['amount'] = 0
}

Citizen.CreateThread(function()
    while not W do
        Wait(100)
    end

    W.TriggerCallback('ZCore:getProps', function(props)
        Props = props
    end)

    while true do
        for key, value in next, Shops.Variables.Props do
            if DoesEntityExist(value) and not IsEntityAttached(value) then
                DeleteEntity(value)
                Shops.Variables.Props[key] = nil
            end
        end

        Citizen.Wait(2000)
    end
end)

---Load the shops
Shops.DeleteProp = function ()
    for k,v in pairs (Shops.Variables.Props) do
        DeleteEntity(v)
        Shops.Variables.Props[k] = nil
    end

    ClearPedTasks(PlayerPedId())
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        Shops.DeleteProp()
    end
end)

Shops.Attach = function(item)
    local id = #Shops.Variables.Props + 1

    if Props[item] and Cfg.Props[id] then
        Shops.Variables.Props[id] = CreateObject(GetHashKey(Props[item]), GetEntityCoords(PlayerPedId()), true, true)
        FreezeEntityPosition(Shops.Variables.Props[id], true)
        SetEntityAsMissionEntity(Shops.Variables.Props[id])
        SetEntityCollision(Shops.Variables.Props[id], false, true)

        AttachEntityToEntity(Shops.Variables.Props[id], Shops.Variables.Props['Basket'], GetPedBoneIndex(PlayerPedId(), 58866), Cfg.Props[id].x, Cfg.Props[id].y, Cfg.Props[id].z, -90.0, -20.0, 30.0, true, true, false, true, 1, true)
    end
end

Shops.Load = function ()
    CreateThread(function()
        for k, v in pairs(Cfg.Shops) do
            W.CreateBlip(v.coords, 52, 2, 0.7, "Tienda", GetCurrentResourceName())
        end
    end)
    CreateThread(function()
        while true do
            local Ped    = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local Sleep  = 1000

            for k, v in pairs(Cfg.Shops) do
                local Distance = #(v.coords - Coords)
                if Distance < 20.0 then
                    if not closestShops[k] then
                        closestShops[k] = v
                    end
                else
                    if closestShops[k] then
                        closestShops[k] = nil
                    end
                end
            end

            if #Shops.Variables.Props > 0 then
                if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'walk', 49) then
                    TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
                end
                local haveShop = false
                for i=1, #Cfg.Shops do
                    if closestShops[i] then
                        haveShop = true
                    end
                end

                if not haveShop then
                    Shops.DeleteProp()
                    Basket = {
                        ['data'] = {{action = 'buy', label= 'Pagar'}, {action = 'cancel', label = 'Cancelar Compra'}, {action = '', label= '[Tu compra]'}},
                        ['amount'] = 0
                    }
                end
            end
            Wait(Sleep)
        end
    end)
    CreateThread(function()
        if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
            RequestAnimDict("anim@heists@narcotics@trash")
        end
        while not HasAnimDictLoaded("anim@heists@narcotics@trash") do
            Wait(0)
        end

        local inZone = false
        local show = false
        while true do
            local Ped    = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local Sleep  = 1000
            inZone = false

            for i=1, #Cfg.Shops do
                if closestShops[i] then
                    for k, v in pairs(closestShops[i].points) do
                        local Distance = #(v.coords - Coords)
                        if Distance < 2.5 then
                            if not Shops.Variables.IsOpened then
                                Sleep = 0

                                W.ShowText(v.coords, '~y~Tienda\n~w~'..v.label, 0.5, 8)
                                if Distance < 1 then
                                    inZone = true

                                    if IsControlPressed(1, 38) then
                                        Shops.Open(k)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if inZone and not shown then
                shown = true

                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_itemshop')
            elseif not inZone and shown then
                exports['ZC-HelpNotify']:close('interact_itemshop')
                shown = false
            end

            Wait(Sleep)
        end
    end)
end

Shops.Open = function (type)
    Shops.Variables.IsOpened = true
    if type ~= "shop" then
        W.OpenMenu("Tienda", "shop_menu", Cfg.Items[type], function (data, name)
            W.DestroyMenu(name)

            W.OpenDialog("Cantidad", "dialog_qua", function(amount)
                W.CloseDialog()

                local amount = tonumber(amount)

                if amount <= 0 then
                    return W.Notify('Tienda', 'Pon un valor mayor de 0', 'error')
                end

                if data.item == 'tabaccopack' and amount > 1 then
                    W.Notify('Tienda', 'Solo puedes comprar un paquete de tabaco', 'error')

                    return
                end

                if #Basket['data'] > 3 then
                    local founded = false

                    for k,v in pairs(Basket['data']) do
                        if (v.name == 'tabaccopack' and not founded) and data.item == 'tabaccopack' then
                            founded = true
                            W.Notify('Tienda', 'Solo puedes comprar un paquete de tabaco', 'error')
                            return
                        end
                    end
                end

                if #Basket['data'] > 3 then
                    local added = false
                    for k,v in pairs(Basket['data']) do
                        if v.name == data.item then
                            added = true
                            Basket['amount'] = Basket['amount'] - (data.price * v.amount)
                            Basket['data'][k].amount = v.amount + amount
                            Basket['data'][k].label = Basket['data'][k].itemLabel..' x'..Basket['data'][k].amount
                            Basket['amount'] = Basket['amount'] + (data.price * Basket['data'][k].amount)
                            W.Notify('Tienda', 'Has añadido ~y~x'..amount..'~w~ '..v.itemLabel..' a tu cesta', 'verify')
                        end
                    end

                    if not added then
                        added = true
                        table.insert(Basket['data'], {name = data.item, label = data.label..' x'..amount, itemLabel = data.label, amount = amount, price = data.price})
                        Basket['amount'] = Basket['amount'] + data.price * amount
                        W.Notify('Tienda', 'Has añadido ~y~x'..amount..'~w~ '..data.label..' a tu cesta', 'verify')
                        Shops.Attach(data.item)
                    end
                else
                    table.insert(Basket['data'], {name = data.item, label = data.label..' x'..amount, itemLabel = data.label, amount = amount, price = data.price})
                    Basket['amount'] = Basket['amount'] + data.price * amount
                    W.Notify('Tienda', 'Has añadido ~y~x'..amount..'~w~ '..data.label..' a tu cesta', 'verify')

                    if not Shops.Variables.Props['Basket'] then
                        Shops.Variables.Props['Basket'] = CreateObject(GetHashKey('prop_fruit_basket'), GetEntityCoords(PlayerPedId()), true, true, true)
                        FreezeEntityPosition(Shops.Variables.Props['Basket'], true)
                        SetEntityAsMissionEntity(Shops.Variables.Props['Basket'])
                        SetEntityCollision(Shops.Variables.Props['Basket'], false, true)
                        AttachEntityToEntity(Shops.Variables.Props['Basket'], PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 58866), 0.15, -0.28, 0.1, -90.0, -20.0, 30.0, true, true, false, true, 1, true)
                        TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
                    end

                    Shops.Attach(data.item)
                end
            end)
        end, function ()
            Shops.Variables.IsOpened = false
        end)
    else
        W.OpenMenu("Tienda", "cajaaaa_menu", Basket['data'], function (data, menu)
            print(json.encode(Basket['data'], { indent = true }))

            if data.action and data.action == 'buy' then
                if #Basket['data'] > 3 then
                    W.DestroyMenu(menu, true)
                    Shops.Buy()
                else
                    W.Notify('Tienda', 'No tienes nada en tu ~y~cesta', 'error')
                end
            elseif data.action and data.action == 'cancel' then
                W.DestroyMenu(menu, true)

                if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'walk', 49) then
                    TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
                end
    
                Shops.DeleteProp()
                Basket = {
                    ['data'] = {{action = 'buy', label= 'Pagar'}, {action = 'cancel', label = 'Cancelar Compra'}, {action = '', label= '[Tu compra]'}},
                    ['amount'] = 0
                }
            else
                if data.action == '' then
                    return
                end
                W.DestroyMenu(menu)
                W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                    W.CloseDialog()
                    local amount = tonumber(amount)
                    local removed = false
                    for k,v in pairs(Basket['data']) do
                        if not removed then
                            if v.name == data.name then
                                W.Notify('Tienda', 'Has retirado ~y~x'..amount..'~w~ '..v.itemLabel..' de tu cesta', 'error')
                                if amount < v.amount then
                                    removed = true
                                    Basket['amount'] = Basket['amount'] - data.price * v.amount
                                    Basket['data'][k].amount = Basket['data'][k].amount - amount
                                    Basket['data'][k].label = Basket['data'][k].itemLabel..' x'..Basket['data'][k].amount
                                    Basket['amount'] = Basket['amount'] + data.price * v.amount
                                elseif amount == v.amount then
                                    removed = true
                                    Basket['amount'] = Basket['amount'] - data.price * v.amount
                                    table.remove(Basket['data'], k)
                                else
                                    W.Notify('Tienda', 'No tienes tanto en la ~y~cesta', 'error')
                                end
                            end
                        end
                    end
                end)
            end
        end, function ()
            Shops.Variables.IsOpened = false
        end)
    end
end

Shops.Buy = function ()
    Wait(300)
    local elements = {
        {label = 'Pagar con efectivo', value = 'money'},
        {label = 'Pagar con tarjeta', value = 'bank'}
    }
    W.OpenMenu("Carrito - $"..Basket['amount'], "buy_menu", elements, function (data, name)
        W.DestroyMenu(name)
        local playerData = W.GetPlayerData()
        if data.value == 'money' then
            if playerData.money.money >= Basket['amount'] then
                TriggerServerEvent("ZC-Shops:server:buyItem", data.value, Basket)
                Shops.DeleteProp()
                Basket = {
                    ['data'] = {{action = 'buy', label= 'Pagar'}, {action = 'cancel', label = 'Cancelar Compra'}, {action = '', label= '[Tu compra]'}},
                    ['amount'] = 0
                }
            else
                W.Notify('Tienda', 'No tienes tanto ~y~dinero', 'error')
            end
        else
            if playerData.money.bank >= Basket['amount'] then
                TriggerEvent("Ox-Banking:buyWithCreditCard", GetCurrentResourceName(), 'shopitems')
            else
                W.Notify('Tienda', 'No tienes tanto ~y~dinero en el banco', 'error')
            end
        end
    end, function ()
        Shops.Variables.IsOpened = false
    end)
end

Shops.Load()

RegisterNUICallback("closePin", function (data, cb)
    if data.typeShop == 'shopitems' then
        W.Notify('Tienda', 'Transacción ~r~fallida', 'error')
        return cb("")
    end
end)

RegisterNUICallback("correctPin", function (data, cb)
    if data.typeShop == 'shopitems' then
        Shops.DeleteProp()
        TriggerServerEvent("ZC-Shops:server:buyItem", "bank", Basket)
        Basket = {
            ['data'] = {{action = 'buy', label= 'Pagar'}, {action = 'cancel', label = 'Cancelar Compra'}, {action = '', label= '[Tu compra]'}},
            ['amount'] = 0
        }
        return cb("")
    end
end)