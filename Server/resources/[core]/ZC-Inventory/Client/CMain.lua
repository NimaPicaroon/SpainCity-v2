local IsMenuOpened
local selectedData
local selectedMoney
local Break

RegisterNetEvent("core:openInventory", function(data)
    local player = W.GetPlayerData()
    CreateThread(function()
        SendNUIMessage({ open = data, totalWeight = data.totalWeight, maxWeight = player.maxWeight})
        while true do
            Wait(0)
            if IsControlPressed(0, 18) then
                SendNUIMessage({ key = "enter" })
                Wait(250)
            end

            if Break then
                SendNUIMessage({ close = true })
                IsMenuOpened = nil
                Break = nil
                break
            end

            if IsControlPressed(0, 177) then
                SendNUIMessage({ close = true })
                if not selectedData and not selectedMoney then
                    IsMenuOpened = nil
                    break
                end
                Wait(250)
            end

            if IsControlPressed(0, 27) then
                Wait(100)
                SendNUIMessage({ key = "ArrowUp", data = IsMenuOpened })
            end

            if IsControlPressed(0, 173) then
                Wait(100)
                SendNUIMessage({ key = "ArrowDown", data = IsMenuOpened })
            end

            if IsControlPressed(0, 174) then
                SendNUIMessage({ key = "ArrowLeft" })
                Wait(100)
            end

            if IsControlPressed(0, 175) then
                SendNUIMessage({ key = "ArrowRight" })
                Wait(100)
            end
        end
    end)
end)

RegisterNUICallback('selected', function(item, cb)
    local inv = W.GetItemsForInventory()
    for k,v in pairs(inv.data) do
        if (item.name == v.name) and (tonumber(item.slotId) == tonumber(v.slotId)) then
            selectedData = inv.data[k]
            local data = json.decode(v.metadata)
            if data ~= false then
                local tables = {}
                for k,v in pairs(data) do
                    if W.Metadata[k] then
                        table.insert(tables, {
                            label = W.Metadata[k],
                            value = v
                        })
                    end
                end

                cb(tables)
            end
        end
    end
end)

RegisterNUICallback('selectedMoney', function (data)
    selectedMoney = data.money
end)

RegisterNUICallback('notSelected', function(data)
    selectedData = nil
    selectedMoney = nil
end)

RegisterNUICallback('getPeople', function(data, cb)
    local playersNearby = W.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)

    if #playersNearby > 0 then
        local players = {}

        for i=1, #playersNearby, 1 do
            if playersNearby[i] ~= PlayerId() then
                table.insert(players, {
                    label = '[' .. GetPlayerServerId(playersNearby[i]) .. ']',
                    playerId = GetPlayerServerId(playersNearby[i])
                })
            end
        end

        return cb(players)
    end
    W.Notify('NOTIFICACIÓN', '~r~No~w~ hay jugadores cerca', 'error')
    return cb(nil)
end)

exports('closeInv', function()
    Break = true
    IsMenuOpened = nil
end)

RegisterNUICallback('giveItem', function(data, cb)
    local id = tonumber(data.id)
    if selectedData then
        local itemGived = selectedData
        selectedData = nil
        if tonumber(itemGived.quantity) > 1 then
            W.OpenDialog('Cantidad', 'amount', function(amount)
                if amount and tonumber(amount) then
                    if tonumber(amount) <= 0 then
                        return W.Notify('Inventario', 'Cantidad inválida', 'error')
                    end
                    
                    if tonumber(amount) <= tonumber(itemGived.quantity) then
                        TriggerServerEvent('ZCore:giveItem', id, amount, itemGived)
                        Wait(300)
                        Break = true
                        Wait(100)
                        local inv = W.GetItemsForInventory()
                        IsMenuOpened = inv
                        TriggerEvent("core:openInventory", inv)
                    else
                        W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
                    end
                else
                    W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
                end
            end)
        else
            TriggerServerEvent('ZCore:giveItem', id, 1, itemGived)
            Wait(300)
            Break = true
            Wait(100)
            local inv = W.GetItemsForInventory()
            IsMenuOpened = inv
            TriggerEvent("core:openInventory", inv)
        end
    elseif selectedMoney then
        local money = selectedMoney
        selectedMoney = nil
        if tonumber(money) > 0 then
            W.OpenDialog('Cantidad', 'amount', function(amount)
                if amount and tonumber(amount) then
                    if tonumber(amount) <= 0 then
                        return W.Notify('Inventario', 'Cantidad inválida', 'error')
                    end

                    if tonumber(amount) <= tonumber(money) then
                        TriggerServerEvent('ZCore:giveMoney', id, amount, 'money')
                        Wait(300)
                        Break = true
                        Wait(100)
                        local inv = W.GetItemsForInventory()
                        IsMenuOpened = inv
                        TriggerEvent("core:openInventory", inv)
                    else
                        W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
                    end
                else
                    W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
                end
            end)
        else
            W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
        end
    end
end)

RegisterNUICallback('dropItem', function(data, cb)
    if selectedData then
        local itemGived = selectedData
        selectedData = nil
        if tonumber(itemGived.quantity) > 1 then
            W.OpenDialog('Cantidad', 'amount', function(amount)
                if amount and tonumber(amount) then
                    if tonumber(amount) <= 0 then
                        return W.Notify('Inventario', 'Cantidad inválida', 'error')
                    end

                    if tonumber(amount) <= tonumber(itemGived.quantity) then
                        W.TriggerCallback('thief:isBeenSteal', function(result)
                            if not result then
                                TriggerServerEvent('ZCore:dropItem', amount, itemGived, GetEntityCoords(PlayerPedId()))
                                Wait(300)
                                Break = true
                                Wait(100)
                                local inv = W.GetItemsForInventory()
                                IsMenuOpened = inv
                                TriggerEvent("core:openInventory", inv)
                            else
                                W.Notify("ERROR", 'Te estan cacheando', 'error')
                            end
                        end, GetPlayerServerId(PlayerId()))
                    else
                        W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
                    end
                else
                    W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
                end
            end)
        else
            W.TriggerCallback('thief:isBeenSteal', function(result)
                if not result then
                    TriggerServerEvent('ZCore:dropItem', 1, itemGived, GetEntityCoords(PlayerPedId()))
                    Wait(300)
                    Break = true
                    Wait(100)
                    local inv = W.GetItemsForInventory()
                    IsMenuOpened = inv
                    TriggerEvent("core:openInventory", inv)
                else
                    W.Notify("ERROR", 'Te estan cacheando', 'error')
                end
            end, GetPlayerServerId(PlayerId()))
        end
    elseif selectedMoney then
        local money = selectedMoney
        selectedMoney = nil
        if tonumber(money) > 0 then
            W.OpenDialog('Cantidad', 'amount', function(amount)
                if amount and tonumber(amount) then
                    if tonumber(amount) <= 0 then
                        return W.Notify('Inventario', 'Cantidad inválida', 'error')
                    end

                    if tonumber(amount) <= tonumber(money) then
                        W.TriggerCallback('thief:isBeenSteal', function(result)
                            if not result then
                                TriggerServerEvent('ZCore:dropMoney', amount, 'money', GetEntityCoords(PlayerPedId()))
                                Wait(300)
                                Break = true
                                Wait(100)
                                local inv = W.GetItemsForInventory()
                                IsMenuOpened = inv
                                TriggerEvent("core:openInventory", inv)
                            else
                                W.Notify("ERROR", 'Te estan cacheando', 'error')
                            end
                        end, GetPlayerServerId(PlayerId()))
                    else
                        W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
                    end
                else
                    W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
                end
            end)
        else
            W.Notify('NOTIFICACIÓN', 'Cantidad ~r~inválida~w~', 'error')
        end
    end
end)

RegisterNUICallback('useItem', function(data, cb)
    local itemUsed = selectedData
    selectedData = nil

    TriggerServerEvent('ZCore:useItem', itemUsed)
    Wait(300)
    Break = true
    Wait(100)
    local inv = W.GetItemsForInventory()
    IsMenuOpened = inv
    TriggerEvent("core:openInventory", inv)
end)

RegisterNUICallback('asignSlot', function(data, cb)
    if not string.find(string.upper(selectedData.name), 'WEAPON_') then
        W.Notify('Hotbar', 'Este item no es ~r~un arma~w~.', 'error')
        selectedData = nil
        Break = true
        Wait(100)
        local inv = W.GetItemsForInventory()
        IsMenuOpened = inv
        TriggerEvent("core:openInventory", inv)
    else
        local itemUsed = selectedData
        selectedData = nil
        TriggerServerEvent('ZCore:updateSlot', itemUsed, data.slot)
        Wait(200)
        Break = true
        Wait(100)
        local inv = W.GetItemsForInventory()
        IsMenuOpened = inv
        TriggerEvent("core:openInventory", inv)
    end
end)

RegisterKeyMapping('inventory', 'Abrir inventario', 'keyboard', 'F2')

RegisterCommand("inventory", function ()
    if exports['Ox-Jobcreator']:IsHandcuffed() then return end
    if exports['ZC-Ambulance']:IsDead() then return end
    if exports['ZC-Menu']:isOpened() then return end
    if not IsMenuOpened then
        local inv = W.GetItemsForInventory()
        IsMenuOpened = inv
        TriggerEvent("core:openInventory", inv)
    end
end)