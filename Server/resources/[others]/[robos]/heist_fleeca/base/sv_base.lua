COOLDOWN_FLEECA = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0 }

W.CreateCallback('heist_fleeca:cooldown', function(source, callback, index)
    local src = source

    if index and COOLDOWN_FLEECA[index] and callback then
        if (os.time() - COOLDOWN_FLEECA[index]) < Config.FleecaHeist[index].nextRob and COOLDOWN_FLEECA[index] ~= 0 then
            return callback(false)
        else
            COOLDOWN_FLEECA[index] = os.time()

            if COOLDOWN_FLEECA[index] > 0 then
                return callback(true)
            end
        end
    end
end)

RegisterServerEvent('fleecaheist:server:rewardItem')
AddEventHandler('fleecaheist:server:rewardItem', function(reward, count)
    local src = source
    local player = W.GetPlayer(src)
    player.addMoney('money', count)
    W.SendToDiscord('robbery', "FLECCA", "Flecca Robado", src)
end)

RegisterServerEvent('fleecaheist:server:doorSync')
AddEventHandler('fleecaheist:server:doorSync', function(index)
    TriggerClientEvent('fleecaheist:client:doorSync', -1, index)
end)

RegisterServerEvent('fleecaheist:server:lootSync')
AddEventHandler('fleecaheist:server:lootSync', function(index, type, k)
    TriggerClientEvent('fleecaheist:client:lootSync', -1, index, type, k)
end)

RegisterServerEvent('fleecaheist:server:modelSync')
AddEventHandler('fleecaheist:server:modelSync', function(index, k, model)
    TriggerClientEvent('fleecaheist:client:modelSync', -1, index, k, model)
end)

RegisterServerEvent('fleecaheist:server:grabSync')
AddEventHandler('fleecaheist:server:grabSync', function(index, k, model)
    TriggerClientEvent('fleecaheist:client:grabSync', -1, index, k, model)
end)

RegisterServerEvent('fleecaheist:server:resetHeist')
AddEventHandler('fleecaheist:server:resetHeist', function(index)
    TriggerClientEvent('fleecaheist:client:resetHeist', -1, index)
end)

RegisterCommand('resetfleeca', function(source)
    local src = source
    local player = W.GetPlayer(src)

    if not player then
        return
    end

    if player.group == 'mod' or player.group == 'admin' then
        TriggerClientEvent('fleecaheist:client:nearBank', src)
    end
end)