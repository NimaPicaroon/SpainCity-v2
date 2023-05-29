AddGang = function (src, gang, rank)
    if Gangs[gang] then
        if not Gangs[gang].ranks[tonumber(rank)] then
            return print("INFO", "The rank does not exist")
        end
    else
        return print("INFO", "The job does not exist")
    end

    local isBoss = false

    if Gangs[gang].ranks[tonumber(rank)].isBoss == 'true' then
        isBoss = true
    end

    local jobData = {
        name        = gang,
        rank        = rank,
        rankname    = Gangs[gang].ranks[tonumber(rank)].name,
        ranklabel   = Gangs[gang].ranks[tonumber(rank)].label,
        label       = Gangs[gang].label,
        salary      = Gangs[gang].ranks[tonumber(rank)].salary,
        isBoss = isBoss
    }
    local player = W.GetPlayer(src)

    if player then
        if player.gang.name and Gangs[player.gang.name] then
            for k, v in pairs(Gangs[player.gang.name].players) do
                if v == src then
                    table.remove(Gangs[player.gang.name].players, k)
                end
            end
        end
        player.setGang(jobData)
        TriggerClientEvent("Ox-Gangs:fetchGang", player.src, Gangs[gang])
        table.insert(Gangs[gang].players, src)
        player.Notify('BANDAS', 'Se te ha cambiado la banda a ~y~'..jobData.label..' - '..jobData.ranklabel..'~w~.', 'verify')
    else
        return print("INFO", "Player not connected")
    end
end

RemoveGang = function (src)
    local player = W.GetPlayer(src)
    if player then
        if player.gang.name then
            if(Gangs[player.gang.name] and Gangs[player.gang.name].players)then
                for k, v in pairs(Gangs[player.gang.name].players) do
                    if v == src then
                        table.remove(Gangs[player.gang.name].players, k)
                    end
                end
            elseif(Gangs[player.gang.name])then
                Gangs[player.gang.name].players = {}
            end
        end
        player.setGang({})
        TriggerClientEvent("Ox-Gangs:fetchGang", player.src)
        player.Notify('BANDAS', 'Se te ha quitado la banda.', 'verify')
    else
        return print("INFO", "Player not connected")
    end
end

W.CreateCallback("Ox-Gangs:getOutfits", function(source, cb, name)
    local Gang = Gangs[name]

    cb(Gang.wardrobe)
end)

DeleteOutfit = function(data, name)
    local Gang = Gangs[name]

    Gang.deleteOutfit(data)
end

RegisterNetEvent("Ox-Gangs:deleteOutfit", DeleteOutfit)

W.CreateCallback('Ox-Gangs:getPlayerBlackmoney', function(source, callback)
    local src = source
    local player = W.GetPlayer(src)

    if player and player.money and player.money.money then
        return callback(player.money.money)
    end

    return callback(false)
end)

-- RegisterNetEvent('Ox-Gangs:blackmoneyAction', function(action, quantity, job)
--     if not Gangs[job] then
--         return
--     end

--     local src = source
--     local player = W.GetPlayer(src)
--     local jobData = Gangs[job]

--     if action == 'deposit' then
--         player.removeMoney('money', quantity)
--         jobData.addBlackmoney(quantity)
--         player.Notify('ARMARIO', 'Has depositado ~r~$'..quantity, 'verify')
--         Wait(10)
--         W.SendToDiscord("dinerobanda", "DEPOSITO DINERO", "$"..quantity.. " para la banda "..player.gang.label .. "\nDinero total: $".. jobData.money, src)
--     elseif action == 'withdraw' then
--         player.addMoney('money', quantity)
--         jobData.removeBlackmoney(quantity)
--         player.Notify('ARMARIO', 'Has retirado ~r~$'..quantity, 'verify')
--         Wait(10)
--         W.SendToDiscord("dinerobanda", "RETIRO DINERO", "$"..quantity.. " de la banda "..player.gang.label .. "\nDinero restante: $".. jobData.money, src)
--     else
--         return
--     end
-- end)

RegisterNetEvent('Ox-Gangs:blackmoneyAction', function(action, quantity, job)
    if not Gangs[job] then
        return
    end

    local src = source
    local player = W.GetPlayer(src)
    local jobData = Gangs[job]
    local cash = player.getMoney('money')

    if player then
        if action == "deposit" then
            if cash >= quantity then
                jobData.money = jobData.money + quantity
                player.removeMoney('money', quantity)
                --jobData.addBlackmoney(quantity)
                player.Notify('ARMARIO', 'Has depositado ~r~'..quantity..'€', 'verify')
                W.SendToDiscord("dinerobanda", "DEPOSITO DINERO", quantity.. "€ para la banda "..player.gang.label .. "\nDinero total: ".. jobData.money.."€", src)
            else
                player.Notify('ARMARIO', 'No tienes suficiente dinero en mano para depositar.', 'error')
            end
        elseif action == "withdraw" then
            if jobData.money >= quantity then
                jobData.money = jobData.money - quantity
                --jobData.removeBlackmoney(quantity)
                player.addMoney('money', quantity)
                player.Notify('ARMARIO', 'Has retirado ~r~'..quantity..'€', 'verify')
                W.SendToDiscord("dinerobanda", "RETIRO DINERO", quantity.. "€ de la banda "..player.gang.label .. "\nDinero restante: ".. jobData.money.."€", src)
            else
                player.Notify('ARMARIO', 'No hay suficientes fondos para retirar.', 'error')
            end
        end
        Wait(1000)
        jobData.saveGang()
    end
end)

RegisterNetEvent('Ox-Gangs:vehiclesmoney', function(quantity, job)
    if not Gangs[job] then
        return
    end

    local src = source
    local player = W.GetPlayer(src)
    if player.getMoney('bank') >= quantity then 
        player.removeMoney('bank', quantity)
        if quantity >= 550 then
            player.Notify('GARAGE', 'Has pagado ~r~'..quantity.. '€ por el mantenimiento del coche.', 'verify')
        else
            player.Notify('ARMERO', 'Has pagado ~r~'..quantity.. '€ por las placas balísticas.', 'verify')
        end
    else
        player.Notify('OC', 'No tienes suficiente dinero.', 'error')
    end
end)