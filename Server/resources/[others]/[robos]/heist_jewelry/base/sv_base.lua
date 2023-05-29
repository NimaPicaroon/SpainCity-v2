GlobalState.ActiveHeist = false
GlobalState.HackingJewelry = false

local lastrob = 0
local start = false

RegisterNetEvent('heist_jewelry:hacking', function(bool)
    GlobalState.HackingJewelry = bool
end)

RegisterServerEvent('vangelicoheist:server:toggle')
AddEventHandler('vangelicoheist:server:toggle', function(bool)
    GlobalState.ActiveHeist = bool
    if bool then
        W.SendToDiscord('robbery', "JOYERÍA", "Joyería finalizada", source)
    end
end)

RegisterServerEvent('vangelicoheist:server:rewardItem')
AddEventHandler('vangelicoheist:server:rewardItem', function(item, amount)
    local src = source
    local player = W.GetPlayer(src)
    local whitelistItems = {}

    if player then
        for k, v in pairs(Config['VangelicoHeist']['smashRewards']) do
            whitelistItems[v['item']] = true
        end

        for k, v in pairs(Config['VangelicoInside']['glassCutting']['rewards']) do
            whitelistItems[v['item']] = true
        end

        for k, v in pairs(Config['VangelicoInside']['painting']) do
            whitelistItems[v['rewardItem']] = true
        end

        if whitelistItems[item] then
            player.addItemToInventory(item, amount)
        else
            print('^3Hacker encontrado ID: ^7('..src..')')
        end
    end
end)

RegisterServerEvent('vangelicoheist:server:startGas')
AddEventHandler('vangelicoheist:server:startGas', function()
    TriggerClientEvent('vangelicoheist:client:startGas', -1)
end)

RegisterServerEvent('vangelicoheist:server:insideLoop')
AddEventHandler('vangelicoheist:server:insideLoop', function()
    TriggerClientEvent('vangelicoheist:client:insideLoop', -1)
end)

RegisterServerEvent('vangelicoheist:server:lootSync')
AddEventHandler('vangelicoheist:server:lootSync', function(type, index)
    TriggerClientEvent('vangelicoheist:client:lootSync', -1, type, index)
end)

RegisterServerEvent('vangelicoheist:server:globalObject')
AddEventHandler('vangelicoheist:server:globalObject', function(obj, random)
    TriggerClientEvent('vangelicoheist:client:globalObject', -1, obj, random)
end)

RegisterServerEvent('vangelicoheist:server:smashSync')
AddEventHandler('vangelicoheist:server:smashSync', function(sceneConfig)
    TriggerClientEvent('vangelicoheist:client:smashSync', -1, sceneConfig)
end)

RegisterCommand('resetjoyeria', function(source)
    local src = source
    local player = W.GetPlayer(src)

    if not player then
        return
    end

    if player.group == 'mod' or player.group == 'admin' then
        GlobalState.ActiveHeist = false
        TriggerClientEvent('vangelicoheist:client:resetHeist', -1)
    end
end)