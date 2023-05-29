W.CreateCallback("Ox-Housing:getInventory", function(source, cb, id)
    local House = Houses[id]
    local gangs = exports['Ox-Gangs']:GetGangs()

    if House.gang then
        if House.gang ~= '' then
            cb(House.inventory:Inventory().get(), House.inventory:Weight().get(), Housing.Weights[gangs[House.gang].level])
        else
            cb(House.inventory:Inventory().get(), House.inventory:Weight().get(), 1000)
        end
    else
        cb(House.inventory:Inventory().get(), House.inventory:Weight().get(), 1000)
    end
end)

W.CreateCallback('Ox-Housing:getPlayerBlackmoney', function(source, callback)
    local src = source
    local player = W.GetPlayer(src)

    if player and player.money and player.money.money then
        return callback(player.money.money)
    end

    return callback(false)
end)

W.CreateCallback('Ox-Housing:getBlackMoney', function(source, cb, id)
    local House = Houses[id]
    cb(House.money)
end)

RegisterNetEvent('Ox-Housing:blackmoneyAction', function(action, quantity, id)
    if not Houses[id] then
        return
    end
    local src = source
    local player = W.GetPlayer(src)
    local House = Houses[id]

    if action == 'deposit' then
        player.removeMoney('blackmoney', quantity)
        House.addBlackmoney(quantity)
        player.Notify('ARMARIO', 'Has depositado ~r~$'..quantity, 'verify')
    elseif action == 'withdraw' then
        House.removeBlackmoney(quantity)
        player.addMoney('blackmoney', quantity)
        player.Notify('ARMARIO', 'Has retirado ~r~$'..quantity, 'verify')
    else
        return
    end
end)