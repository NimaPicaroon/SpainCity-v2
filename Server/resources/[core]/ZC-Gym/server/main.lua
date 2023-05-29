Main = { }
Main.__index = Main

-- @main
RegisterServerEvent('ZC-Gym:addSkill')
AddEventHandler('ZC-Gym:addSkill', function(type, amount)
    local player = W.GetPlayer(source)
    player.addStat(type, amount)
end)

RegisterServerEvent('ZC-Gym:buyItem')
AddEventHandler('ZC-Gym:buyItem', function(data, amount)
    local player = W.GetPlayer(source)
    local money = player.getMoney('money')
    local cost = (data.price*amount)

    if money >= cost then
        if data.value == 'membership' then
            if player.canHoldItem(data.value, amount) then
                player.removeMoney('money', cost)
                player.addItemToInventory(data.value, amount, {id= player.id})
                player.Notify('TIENDA', 'Has comprado ~y~x'..amount..'~w~ '..data.label..' por ~g~$'..cost..'~w~', 'verify')
            end
        else
            if player.canHoldItem(data.value, amount) then
                local metadata = {}

                if W.Food[data.value] then
                    metadata = {g = W.Food[data.value].g}
                elseif W.Drink[data.value] then
                    metadata = {ml = W.Drink[data.value].ml}
                elseif W.Wine[data.value] then
                    metadata = {ml = W.Wine[data.value].ml}
                else
                    metadata = false
                end
                player.removeMoney('money', cost)
                player.addItemToInventory(data.value, amount, metadata)
                player.Notify('TIENDA', 'Has comprado ~y~x'..amount..'~w~ '..data.label..' por ~g~$'..cost..'~w~', 'verify')
            end
        end
    else
        player.Notify('TIENDA', '~r~No~w~ tienes suficiente dinero', 'error')
    end
end)

RegisterServerEvent('ZC-Gym:rentBike', function(price)
    local player = W.GetPlayer(source)

    player.removeMoney('money', price)
end)