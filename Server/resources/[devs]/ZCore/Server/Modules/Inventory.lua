W.Drops = {}
W.NewDrops = {}
W.NewObjects = {}

RegisterNetEvent("ZCore:newDrops", function (Drops, objects)
    W.NewDrops = Drops
    W.NewObjects = objects
end)

W.GiveItem = function(target, amount, item)
    local src = source
    local player = W.GetPlayer(src)
    local targetPlayer = W.GetPlayer(target)
    local metadata = item.metadata
    local hasPlayerItem = false
    for k, v in pairs(player.inventory.items) do
        if(v.item == item.name and v.quantity >= tonumber(amount))then
            hasPlayerItem = true
            break
        end
    end
    if(not hasPlayerItem)then
        W.SendToDiscord("cheaters", "Dupeo detectado (trade_items)", "Jugadores implicados: \n" .. player.identifier .. " (" .. player.name .. ") \n" .. targetPlayer.identifier .. " (" .. targetPlayer.name .. ")\n Cantidad del intento: " .. amount .. " (" .. item.name .. ")", src)
        return
    end
    if targetPlayer.canHoldItem(item.name, tonumber(amount)) then
        player.removeItemFromInventory(item.name, amount, item.slotId)
        targetPlayer.addItemToInventory(item.name, amount, metadata, item.slotId)

        if not DoesEntityExist(GetVehiclePedIsIn(GetPlayerPed(player.src))) then
            TriggerClientEvent('ZCore:giveAnimation', player.src, item.name, 'givetake1_a')
        end

        if not DoesEntityExist(GetVehiclePedIsIn(GetPlayerPed(targetPlayer.src))) then
            TriggerClientEvent('ZCore:giveAnimation', targetPlayer.src, item.name, 'givetake1_b', src)
        end
        
        player.Notify('NOTIFICACIÓN', 'Has entregado ~y~x'..amount..' '..item.label..'~w~ al jugador con ~y~ID: '.. target..'~w~', 'verify')
        targetPlayer.Notify('NOTIFICACIÓN', 'Has recibido ~y~x'..amount..' '..item.label..'~w~ del jugador con ~y~ID: '.. src..'~w~', 'verify')
        W.SendToDiscord("dar", "ENTREGA ITEM", "x"..amount.. " " ..item.label.. " a "..targetPlayer.name.. " con la ID: "..target, src)
    end
end

RegisterNetEvent("ZCore:giveItem", W.GiveItem)

W.RemoveItem = function(amount, itemData)
    local src = source
    local player = W.GetPlayer(src)

    if itemData and itemData.slotId then
        player.removeItemFromInventory(itemData.name, amount or 1, itemData.slotId)
    end
end

RegisterNetEvent('ZCore:removeItem', W.RemoveItem)

W.GiveMoney = function(target, amount, type)
    local src = source
    local player = W.GetPlayer(src)
    local targetPlayer = W.GetPlayer(target)
    if(tonumber(player.money[type]) >= tonumber(amount))then
        player.removeMoney(type, amount)
        targetPlayer.addMoney(type, amount)
        player.Notify('NOTIFICACIÓN', 'Has entregado ~g~'..amount..'$~w~ al jugador con ~y~ID: '.. target..'~w~', 'verify')
        targetPlayer.Notify('NOTIFICACIÓN', 'Has recibido ~g~'..amount..'$~w~ del jugador con ~y~ID: '.. src..'~w~', 'verify')
        W.SendToDiscord("dar", "ENTREGA DINERO", "$"..amount.. " a "..targetPlayer.name.. " con la ID: "..target, src)
    else
        W.SendToDiscord("cheaters", "Dupeo detectado (inventory_give_and_steal)", "Jugadores implicados: \n" .. player.identifier .. " (" .. player.name .. ") \n" .. targetPlayer.identifier .. " (" .. targetPlayer.name .. ")\n Cantidad del intento: " .. amount, src)
    end
end

RegisterNetEvent("ZCore:giveMoney", W.GiveMoney)

---comment
---@param amount any
---@param item any
W.DropItem = function(amount, item, coords)
    local src = source
    W.Thread(function ()
        local player = W.GetPlayer(src)
        local hasPlayerItem = false
        for k, v in pairs(player.inventory.items) do
            if(v.item == item.name and v.quantity >= tonumber(amount))then
                hasPlayerItem = true
                break
            end
        end
        if(not hasPlayerItem)then
            W.SendToDiscord("cheaters", "Dupeo detectado (drop_money_non_existed)", "Jugadore implicados: \n" .. player.identifier .. " (" .. player.name .. ") \nObjeto del intento: x" .. tonumber(amount) .. " " .. item.label, src)
            return
        end
        local id = W.CreateDropId()
        W.Drops[id] = {amount = amount, data = item}
        player.removeItemFromInventory(item.name, amount, item.slotId)
        TriggerClientEvent('ZCore:addDrop', -1, id, src, item.name, item.label, amount, item.slotId, coords)
        TriggerClientEvent('ZCore:dropAnim', src)
        Wait(1900)
        W.SendToDiscord("drop", "TIRAR ITEM", "x"..amount.." "..item.label, src)
        player.Notify('NOTIFICACIÓN', 'Has tirado ~y~x'..amount..' '..item.label..'~w~ al suelo', 'verify')
    end)
end

RegisterNetEvent('ZCore:dropItem', W.DropItem)

W.DropMoney = function(amount, type, coords)
    local src = source
    W.Thread(function ()
        local player = W.GetPlayer(src)
        local id = W.CreateDropId()
        if(player.money[type] >= tonumber(amount))then
            W.Drops[id] = {amount = amount, data = type}
            player.removeMoney(type, amount)
            TriggerClientEvent('ZCore:addDropMoney', -1, id, src, type, amount, coords)
            TriggerClientEvent('ZCore:dropAnim', src)
            Wait(1900)
            W.SendToDiscord("drop", "TIRAR DINERO", amount.."$", src)
            player.Notify('NOTIFICACIÓN', 'Has tirado ~g~x'..amount..'$~w~ al suelo', 'verify')
        else
            W.SendToDiscord("cheaters", "Dupeo detectado (drop_money_non_existed)", "Jugadore implicados: \n" .. player.identifier .. " (" .. player.name .. ") \nCantidad del intento: " .. tonumber(amount), src)
        end
    end)
end

RegisterNetEvent('ZCore:dropMoney', W.DropMoney)

---comment
---@param id any
W.PickupDrop = function(id)
    local src = source
    W.Thread(function ()
        if W.Drops[id] then
            local player = W.GetPlayer(src)
            local item = W.Drops[id]
            W.Drops[id] = nil
            item.amount = tonumber(item.amount)
            if type(item.data) == 'string' then
                player.addMoney(item.data, item.amount)
                TriggerClientEvent('ZCore:dropAnim', src)
                TriggerClientEvent('ZCore:removeDrop', -1, id)
                Wait(1900)
                player.Notify('NOTIFICACIÓN', 'Has recogido ~g~'..item.amount..'$~w~ del suelo', 'verify')
                W.SendToDiscord("drop", "RECOGER DINERO", item.amount.."$", src)
            else
                if player.canHoldItem(item.data.name, item.amount) then
                    player.addItemToInventory(item.data.name, item.amount, json.decode(item.data.metadata), item.data.slotId)
                    TriggerClientEvent('ZCore:dropAnim', src)
                    TriggerClientEvent('ZCore:removeDrop', -1, id)
                    Wait(1900)
                    W.SendToDiscord("drop", "RECOGER ITEM", "x"..item.amount.." "..item.data.label, src)
                    player.Notify('NOTIFICACIÓN', 'Has recogido ~y~x'..item.amount..' '..item.data.label..'~w~ del suelo', 'verify')
                end
            end
        end
    end)
end

RegisterNetEvent("ZCore:pickupDrop", W.PickupDrop)

RegisterNetEvent("ZCore:useItem", function(item)
    local src = source
    local player = W.GetPlayer(src)

    player.useItem(item)
end)

RegisterNetEvent("ZCore:updateSlot", function(item, slot)
    local src = source
    local player = W.GetPlayer(src)
    if item.metadata ~= false then
        item.metadata = json.decode(item.metadata)
    end

    local found = false
    if #(player.inventory.slots) > 0 then
        for k,v in pairs(player.inventory.slots) do
            if tonumber(v.slotId) == tonumber(item.slotId) and not found then
                found = true
                player.removeSlot(item, v.slot, slot)
            end
        end

        if not found then
            player.updateSlot(item, slot)
        end
    else
        player.updateSlot(item, slot)
    end
end)

RegisterNetEvent("ZCore:giveAllWeapons", function()
    local src = source
    local player = W.GetPlayer(src)

    if not player then
        return
    end

    player.giveAllWeapons()
end)

RegisterNetEvent("ZCore:changeMetadata", function(slotId, type, amount)
    local src = source
    local player = W.GetPlayer(src)

    player.changeMetadata(slotId, type, amount)
end)

W.CreateDropId = function()
    local id = math.random(10000, 99999)
    local dropid = id
    W.Thread(function ()
        while W.Drops[dropid] ~= nil do
            id = math.random(10000, 99999)
            dropid = id
            Wait(1)
        end 
    end)
    return dropid
end

GiveLoadout = function()
    local src = source
    local player = W.GetPlayer(src)

    if not player then
        return
    end

    player.giveAllWeapons()
end

RegisterNetEvent("ZCore:giveLoadout", GiveLoadout)

W.AddItem = function(name, amount)
    local src = source
    local player = W.GetPlayer(src)
    local slotId = W.SlotId()

    player.addItemToInventory(name, amount, W.DefaultMetadata[name] or false, slotId)
end

RegisterNetEvent("ZCore:addItem", W.AddItem)

W.ResetInventory = function()
    local src = source
    local player = W.GetPlayer(src)
    player.setInventory()
end

RegisterNetEvent("ZCore:resetInventory", W.ResetInventory)

W.UpdateWeight = function(type)
    local src = source
    local player = W.GetPlayer(src)

    if not player then
        return
    end

    local actualWeight = player.maxWeight
    if type == 'default' then
        newWeight = actualWeight - 7.5
    else
        newWeight = actualWeight + 7.5
    end
    player.updateMaxWeight(newWeight)
end

RegisterNetEvent("ZCore:updateWeight", W.UpdateWeight)