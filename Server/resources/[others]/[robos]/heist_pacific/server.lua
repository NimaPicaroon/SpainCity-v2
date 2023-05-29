W = exports.ZCore:get()
local lastrob = 0
local start = false

W.CreateCallback('pacificheist:server:checkTime', function(source, cb)
    local src = source
    
    if (os.time() - lastrob) < Config['PacificHeist']['nextRob'] and lastrob ~= 0 then
        local seconds = Config['PacificHeist']['nextRob'] - (os.time() - lastrob)

        cb(false)
    else
        lastrob = os.time()
        start = true
        cb(true)
    end
end)


RegisterServerEvent('pacificheist:server:rewardItem')
AddEventHandler('pacificheist:server:rewardItem', function(item, count, type)
    local src = source
    local player = W.GetPlayer(src)
    local whitelistItems = {}

    if player then
        local sourcePed = GetPlayerPed(src)
        local sourceCoords = GetEntityCoords(sourcePed)
        local dist = #(sourceCoords - vector3(256.764, 241.272, 101.693))
        if dist > 200.0 then
            print('[rm_pacificheist] add money exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
        else
            if type == 'money' then
                player.addMoney('money', 142857)
            else
                player.addItemToInventory(item, count)
            end
        end
    end
end)

RegisterServerEvent('pacificheist:server:removeItem')
AddEventHandler('pacificheist:server:removeItem', function(item, slotId)
    local src = source
    local player = W.GetPlayer(src)

    if player then
        player.removeItemFromInventory(item, 1, slotId)
    end
end)

RegisterServerEvent('pacificheist:server:startHeist')
AddEventHandler('pacificheist:server:startHeist', function()
    TriggerClientEvent('pacificheist:client:startHeist', -1)
end)

RegisterServerEvent('pacificheist:server:resetHeist')
AddEventHandler('pacificheist:server:resetHeist', function()
    TriggerClientEvent('pacificheist:client:resetHeist', -1)
end)

RegisterServerEvent('pacificheist:server:sceneSync')
AddEventHandler('pacificheist:server:sceneSync', function(model, animDict, animName, pos, rotation)
    TriggerClientEvent('pacificheist:client:sceneSync', -1, model, animDict, animName, pos, rotation)
end)

RegisterServerEvent('pacificheist:server:particleFx')
AddEventHandler('pacificheist:server:particleFx', function(pos)
    TriggerClientEvent('pacificheist:client:particleFx', -1, pos)
end)

RegisterServerEvent('pacificheist:server:modelSwap')
AddEventHandler('pacificheist:server:modelSwap', function(pos, radius, model, newModel)
    TriggerClientEvent('pacificheist:client:modelSwap', -1, pos, radius, model, newModel)
end)

RegisterServerEvent('pacificheist:server:globalObject')
AddEventHandler('pacificheist:server:globalObject', function(object, item)
    TriggerClientEvent('pacificheist:client:globalObject', -1, object, item)
end)

RegisterServerEvent('pacificheist:server:someoneVault')
AddEventHandler('pacificheist:server:someoneVault', function(action)
    TriggerClientEvent('pacificheist:client:someoneVault', -1, action)
end)

RegisterServerEvent('pacificheist:server:openVault')
AddEventHandler('pacificheist:server:openVault', function(index)
    TriggerClientEvent('pacificheist:client:openVault', -1, index)
end)

RegisterServerEvent('pacificheist:server:vaultLoop')
AddEventHandler('pacificheist:server:vaultLoop', function()
    TriggerClientEvent('pacificheist:client:vaultLoop', -1)
end)

RegisterServerEvent('pacificheist:server:extendedLoop')
AddEventHandler('pacificheist:server:extendedLoop', function()
    TriggerClientEvent('pacificheist:client:extendedLoop', -1)
end)

RegisterServerEvent('pacificheist:server:vaultSync')
AddEventHandler('pacificheist:server:vaultSync', function(action, index)
    TriggerClientEvent('pacificheist:client:vaultSync', -1, action, index)
end)

RegisterServerEvent('pacificheist:server:extendedSync')
AddEventHandler('pacificheist:server:extendedSync', function(action, index)
    TriggerClientEvent('pacificheist:client:extendedSync', -1, action, index)
end)

RegisterServerEvent('pacificheist:server:doorSync')
AddEventHandler('pacificheist:server:doorSync', function(index)
    TriggerClientEvent('pacificheist:client:doorSync', -1, index)
end)

RegisterServerEvent('pacificheist:server:objectSync')
AddEventHandler('pacificheist:server:objectSync', function(e)
    TriggerClientEvent('pacificheist:client:objectSync', -1, e)
end)

RegisterServerEvent('pacificheist:server:doorFix')
AddEventHandler('pacificheist:server:doorFix', function(hash, heading, pos)
    TriggerClientEvent('pacificheist:client:doorFix', -1, hash, heading, pos)
end)