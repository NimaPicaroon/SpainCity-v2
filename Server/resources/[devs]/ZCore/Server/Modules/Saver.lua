W.SaverQueue = {}
W.SaverQueue.Status = false
W.SaverQueue.QuickQueue = false
W.SaverQueue.Tasks = {}
W.SaverQueue.CKMode = {}
CreateThread(function()
    while true do
        for key, value in next, W.PlayersSource do
            if value and not value.disconnected and value.source then
                local player = W.GetPlayer(value.source)

                if player and player.update then
                    player.savePlayer()
                    --W.Print('INFO', 'Player ^5'..value.source..'^7 has been saved')
                    Citizen.Wait(750)
                end
            else
                table.remove(W.PlayersSource, key)
            end
        end
        
        Wait(20 * 60 * 1000) -- change to 15 mins
    end
end)

exports('getPlayers', function()
    return W.PlayersSource
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if(eventData.secondsRemaining == 60)then
        CreateThread(function()            
            W.SaveAll()
        end)
    elseif(eventData.secondsRemaining == 120)then
        W.SaverQueue.QuickQueue = true 
    end
end)

local forBans = {}

W.GetBanPlayer = function(src)
    Wait(2000)
    if forBans[tonumber(src)] then
        local pedido = forBans[tonumber(src)]
        forBans[tonumber(src)] = nil
        return pedido
    else
        return nil
    end
end

AddEventHandler("playerDropped", function(reason)
    local src <const> = source

    W.GetPlayer(src, function(data)
        if data then
            -- data.savePlayer('disconnect')
            if(not W.SaverQueue.CKMode[data.identifier])then
                W.Metadata.OnlineData[data.identifier] = nil
                local saverData = data.saveCachePlayer()
                table.insert(W.SaverQueue.Tasks, saverData)
                W.SaverQueue.Init()
            end
            W.SendToDiscord("access", "Jugador saliendo del servidor", reason, src)
            TriggerEvent("ZCore:playerDisconnected", src, W.Plys[tonumber(src)])
        end
    end)
    W.Plys[tonumber(src)] = nil

    if W.PlayersSource[tonumber(src)] then
        W.PlayersSource[tonumber(src)] = nil
    end
    
    W.Print("INFO", "Player ^5"..src..'^7 dropped from the server ^5('..reason..')^7')
end)

W.SaverQueue.Init = function()
    if(W.SaverQueue.Status)then
        return
    end
    W.SaverQueue.Status = true
    W.Print("INFO", "Save queue started run")
    Citizen.CreateThread(function()
        while(#W.SaverQueue.Tasks > 0)do
            for k, v in pairs(W.SaverQueue.Tasks) do
                if(W.PlayersCache[v.token])then
                    MySQL.Async.execute("UPDATE `players` SET `discord` = @discord, `inventory` = @inv, `metadata` = @metadata, `group` = @g, `dimension` = @dimension, `name` = @name, `coords` = @coords, `skills` = @stats, `money` = @money, `identity` = @identity, `status` = @status, `skin` = @skin, `ped` = @ped, `job` = @job, `gang` = @gang, `dead` = @dead, `bills` = @bills, `fade` = @fade, `phone` = @phone, `vip` = @vip WHERE `token` = @token", {
                        ['@token'] = v.token,
                        ['@discord'] = v.discord,
                        ['@g'] = v.group,
                        ['@name'] = v.name,
                        ['@ped'] = v.ped,
                        ['@vip'] = v.vip,
                        ['@coords'] = v.coords,
                        ['@inv'] = v.inventory,
                        ['@job'] = v.job,
                        ['@gang'] = v.gang,
                        ['@stats'] = v.skills,
                        ['@money'] = v.money,
                        ['@identity'] = v.identity,
                        ['@status'] = v.status,
                        ['@skin'] = v.skin,
                        ['@bills'] = v.bills,
                        ['@dimension'] = tonumber(v.dimension),
                        ['@dead'] = tonumber(v.dead),
                        ['@phone'] = tonumber(v.phone),
                        ["@metadata"] = v.metadata,
                        ['@fade'] = v.fade
                    })
                    --W.Print("INFO", "Player " .. v.name .. " has been saved waiting saver queue")
                end
                table.remove(W.SaverQueue.Tasks, k)
                if(not W.SaverQueue.QuickQueue)then
                    Citizen.Wait(1200)
                end
            end
            Citizen.Wait(1200)
        end
        W.SaverQueue.Status = false
        W.SaverQueue.QuickQueue = false
        --W.Print("INFO", "Save queue stopped, all tasks were done!")
    end)
end

exports("CKMode", function(license)
    W.SaverQueue.CKMode[license] = true
end)

RegisterServerEvent('ZCore:afkKick', function()
    local src = source
	DropPlayer(src, ('Has sido expulsado por estár AFK'))
end)