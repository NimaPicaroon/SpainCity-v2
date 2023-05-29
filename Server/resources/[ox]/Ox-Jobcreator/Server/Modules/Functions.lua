JOB.GetJob = function(job, cb)
    if cb then
        return cb(JOB.Jobs[tostring(job)])
    else
        return JOB.Jobs[tostring(job)]
    end
end

exports('getJobData', JOB.GetJob)

logschr = function(webhookUrl, message)
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 
    'POST', json.encode(
        {username = "SpainCity Logs", 
        embeds = {
            {["color"] = 16711680, 
            ["author"] = {
            ["name"] = "LOGS ARMARIO",
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"},
            ["description"] = "".. message .."",
            ["footer"] = {
            ["text"] = "SpainCityRP - "..os.date("%x %X %p"),
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png",},}
        }, avatar_url = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"}), {['Content-Type'] = 'application/json' })
end

---comment
---@param source any
---@param cb any
---@return any
JOB.IsAllowed = function(source, cb)
    local player = W.GetPlayer(source)

    if W.Groups[player.group] > 0 then
        if cb then
            return cb(true)
        else
            return true
        end
    end

    if cb then
        return cb(false)
    else
        return false
    end
end

---comment
---@param data any
JOB.HandleNewJob = function(data)
    local src <const> = source
    JOB.IsAllowed(src, function (isAllowed)
        if isAllowed then
            local _, count = data.name:gsub("%S+", "")
            if count > 1 then return JOB.Print("ERROR", "The name only can have one word!") end
            JOB.Execute("INSERT INTO `guille_jobcreator` (name, label, points, ranks, data, blips, publicvehicles, privatevehicles, wardrobe, shop) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", {
                data.name,
                data.label,
                json.encode(data.markers),
                json.encode(data.ranks),
                '{"vehinfo":false, "handcuff":false,"billing":false,"objects":false, "search": false}',
                json.encode(data.blips),
                json.encode({ }),
                json.encode({ }),
                json.encode({ }),
                json.encode({ }),
            })

            JOB.Jobs[data.name] = JOB.CreateJob(data.name, data.label, data.ranks, data.markers, { }, data.blips, { }, { }, { }, { })
            JOB.Jobs[data.name].players = {}
            GlobalState[data.name.."-guille"] = JOB.Jobs[data.name]

            if data.blips and next(data.blips) ~= nil then
                -- data.blips = json.decode(data.blips)

                for _,c in pairs(data.blips) do
                    table.insert(JOB.Blips, c)
                end
            end

            --JOB.Print("INFO", ("Job loaded '%s'"):format(data.name))
            GlobalState.JobsData = JOB.Jobs
            GlobalState.JobsBlips = JOB.Blips
            TriggerClientEvent("jobcreatorv2:client:initData", -1)
        end
    end)
end

RegisterNetEvent("jobcreatorv2:server:sendNewJobData", JOB.HandleNewJob)

---comment
---@param src any
---@param job any
---@param rank any
JOB.AddJob = function (src, job, rank)
    if JOB.Jobs[job] then
        if not JOB.Jobs[job].ranks[tonumber(rank)] then
            return JOB.Print("INFO", "The rank does not exist")
        end
    else
        return JOB.Print("INFO", "The job does not exist")
    end
    local jobData = {
        name        = job,
        rank        = rank,
        rankname    = JOB.Jobs[job].ranks[tonumber(rank)].name,
        ranklabel   = JOB.Jobs[job].ranks[tonumber(rank)].label,
        label       = JOB.Jobs[job].label,
        salary      = JOB.Jobs[job].ranks[tonumber(rank)].salary,
        duty        = true,
        assignation = 'none'
    }
    local player = W.GetPlayer(src)
    if player then
        for k, v in pairs(JOB.Jobs[player.job.name].players) do
            if v == src then
                table.remove(JOB.Jobs[player.job.name].players, k)
            end
        end
        player.setJob(jobData)
        TriggerClientEvent("jobcreatorv2:client:initData", player.src)
        TriggerClientEvent('jobs:changeJob', player.src, jobData)
        TriggerEvent('jobs:updateJob', src, jobData) -- Esto da error en el core
        table.insert(JOB.Jobs[job].players, src)
        player.Notify('TRABAJO', 'Se te ha cambiado el trabajo a ~y~'..jobData.label..' - '..jobData.ranklabel..'~w~.', 'verify')
    else
        return JOB.Print("INFO", "Player not connected")
    end
end

exports('SetPlayerJob', JOB.AddJob)

JOB.DeleteJob = function(job)
    local Players = GetPlayers()

    for k, v in pairs(Players) do
        local player = W.GetPlayer(tonumber(v))

        if player.job and player.job.name == job then
            JOB.AddJob(tonumber(v), 'unemployed', 1)
        end

        if JOB.Jobs[job] and GlobalState[job.."-guille"] and JOB.Blips[job] then
            JOB.Jobs[job] = nil
            GlobalState[job.."-guille"] = nil
            JOB.Blips[job] = nil
        end

        GlobalState.JobsData = JOB.Jobs
        GlobalState.JobsBlips = JOB.Blips

        if player.job and player.job.name ~= job then
            TriggerClientEvent("jobcreatorv2:client:initData", tonumber(v))
        end

        exports.oxmysql:execute('DELETE FROM `guille_jobcreator` WHERE `name` = ?', { job }, function() end)
    end
end

JOB.EditValue = function (type, data, job)
    local src <const> = source

    JOB.IsAllowed(src, function (isAllowed)
        if isAllowed then
            if type == "updateMarkers" then
                local Job = JOB.GetJob(job)
                Job.updateMarkers(data)
            elseif type == "updateVehicles" then
                local Job = JOB.GetJob(job)
                Job.updatePublicVehs(data)
            elseif type == "updateOptions" then
                local Job = JOB.GetJob(job)
                Job.updateOptions(data)
            elseif type == "updateShop" then
                local Job = JOB.GetJob(job)
                Job.updateShop(data)
            end
        end
    end)
end

RegisterNetEvent("jobcreatorv2:server:updateValue", JOB.EditValue)

JOB.FirePlayer = function()
    local src <const> = source
    local Player = W.GetPlayer(src)
    local Rank = Player.job.rankname
    local Job = Player.job.name
    for k, v in pairs(JOB.Jobs[Job].ranks) do
        if v.name == Rank then
            if v.isBoss then
                Player.setJob(jobData)
            end
        end
    end
end

RegisterNetEvent("jobcreatorv2:server:firePlayer", JOB.FirePlayer)

JOB.AsignOutfit = function(skin, job, name)
    local Job = JOB.GetJob(job)

    Job.addOutfit(skin, name)
end

RegisterNetEvent("jobcreatorv2:server:asignOutfit", JOB.AsignOutfit)

JOB.DeleteOutfit = function(data, job)
    local Job = JOB.GetJob(job)

    Job.deleteOutfit(data)
end

RegisterNetEvent("jobcreatorv2:server:deleteOutfit", JOB.DeleteOutfit)

JOB.SetDuty = function(bool)
    local src <const> = source
    local Player = W.GetPlayer(src)

    Player.setDuty(bool)
end

RegisterNetEvent('Ox-Jobcreator:setDuty', JOB.SetDuty)

JOB.RemoveTrashItem = function(data)
    if(data and data.item)then
        local player = W.GetPlayer(source)
        local items = W.GetItems()
        player.removeItemFromInventory(data.item.name, data.amount, data.item.slotId)
        player.Notify("BASURA", "Has tirado x" .. data.amount .. " de " .. data.item.name .. " a la basura", "verify")
        --W.SendToDiscord('incautaciones', 'CONFISCADO', 'Ha dejado en incautaciones: x'..data.amount..' '..data.item.name, source)
        logschr("https://discord.com/api/webhooks/1099833620459421797/Jvf9TQ-DCIeDQrynNeBuCVN6hST-H_AwYe4xkWWhr06DhS-lkavgwwCgcPflygdxSrro", '\n**Incautado:** x'..data.amount..' '..items[data.item.name].label..'  \n**Empleado:** '..GetPlayerName(source))
    end
end

RegisterNetEvent('Ox-Jobcreator:removeTrashItem', JOB.RemoveTrashItem)

JOB.DepositMoney = function(quantity, job)
    local src = source
    local ply = W.GetPlayer(src)
    local plyMoney = ply.getMoney('money')
    local job = JOB.GetJob(job)

    if tonumber(plyMoney) >= tonumber(quantity) then
        pName = GetPlayerName(source)
        ply.removeMoney('money', tonumber(quantity))
        job.addMoney(tonumber(quantity))

        ply.Notify('SOCIEDAD', 'Has ~y~depositado~w~ la cantidad de ~g~$'..tonumber(quantity)..'~w~ en la sociedad de tu empresa.', 'verify')
        W.SendToDiscord('sociedad', 'DEPOSITO EN '..ply.job.label, '$'..tonumber(quantity), source)
    else
        ply.Notify('EFECTIVO', 'No tienes ~r~dinero suficiente~w~ para poder realizar esta acción.', 'error')
    end
end

RegisterNetEvent('Ox-Jobcreator:deposit', JOB.DepositMoney)

JOB.WithdrawMoney = function(quantity, job)
    local src = source
    local ply = W.GetPlayer(src)

    local Job = JOB.GetJob(job)

    if Job then
        Job.removeMoney(quantity, function(removed, message)
            pName = GetPlayerName(source)
            if removed then
                ply.addMoney('money', quantity)
                ply.Notify('SOCIEDAD', 'Has retirado ~g~$'..quantity..'~w~ y ahora los tienes en efectivo.', 'verify')
                W.SendToDiscord('sociedad', 'RETIRO EN '..ply.job.label, '$'..quantity, source)
            else
                ply.Notify('SOCIEDAD', message, 'error')
            end
        end)
    end
end

RegisterNetEvent('Ox-Jobcreator:withdraw', JOB.WithdrawMoney)

W.CreateCallback("jobcreatorv2:server:getOutfits", function(source, cb, name)
    local Job = JOB.GetJob(name)

    cb(Job.wardrobe)
end)

W.CreateCallback("Wave:GetPlayersJob", function(source, cb, job, needsDuty)
    local onJob = {}
    local players = JOB.Jobs[job].players

    if not JOB.Jobs[job] then
        return callback(0)
    end

    for k, v in pairs(players) do
        v = tonumber(v)

        if v then
            local player = W.GetPlayer(v)

            if player and player.job.duty then
                table.insert(onJob, v)
            end
        end
    end

    cb(onJob)
end)

exports('getPolices', function()
    local players = {}

    for key, value in next, JOB.Jobs['police'].players do
        if value then
            table.insert(players, { source = value })
        end
    end

    return players
end)

W.CreateCallback('jobcreator:getPlayerBlackmoney', function(source, callback)
    local src = source
    local player = W.GetPlayer(src)

    if player and player.money and player.money.money then
        return callback(player.money.money)
    end

    return callback(false)
end)


W.CreateCallback('carloslr:getempleo', function(source, callback, job)
    MySQL.Async.fetchAll("SELECT job, token, identity FROM `players` WHERE `job` LIKE '%"..job.."%'", {}, function(result)
        if result[1] then
            callback(result)
        else
            callback(false)
        end
    end)
end)

W.CreateCallback("carloslr:despedir", function(source, callback, token)
    local src = source
    MySQL.Async.execute("UPDATE `players` SET `job` = @job WHERE `token` = @token", {
        ['@job'] = '{"duty":true,"rankname":"unemployed","salary":50,"rank":1,"label":"Desempleado","ranklabel":"En paro","name":"unemployed"}',
        ['@token'] = token
    }, function(result)
        if result then
            callback(true)
        else
            callback(false)
        end
    end)
end)



RegisterNetEvent('jobcreator:blackmoneyAction', function(action, quantity, job)
    if not JOB.Jobs[job] then
        return
    end

    local src = source
    local player = W.GetPlayer(src)
    local jobData = JOB.Jobs[job]

    if action == 'deposit' then
        player.removeMoney('money', quantity)
        jobData.addBlackmoney(quantity)
        player.Notify('ARMARIO', 'Has depositado ~r~$'..quantity, 'verify')
    elseif action == 'withdraw' then
        jobData.removeBlackmoney(quantity)
        player.addMoney('money', quantity)
        player.Notify('ARMARIO', 'Has retirado ~r~$'..quantity, 'verify')
    else
        return
    end
end)

JailConfig = {
    ['Mission Row'] = {
        cells = {
            [1] = vec4(477.76, -1014.04, 25.33, 354.44),
            [2] = vec4(480.72, -1014.28, 25.33, 353.08),
            [3] = vec4(483.72, -1014.24, 25.33, 357.88),
            [4] = vec4(486.72, -1014.24, 25.33, 357.88),
            [5] = vec4(485.44, -1005.79, 25.33, 179.75)
        --    [6] = vec4(486.2, -1006.47, 25.33, 91.12),
        --    [7] = vec4(486.17, -1003.93, 25.33, 91.12)
        },
        exit = vec4(488.96, -1002.24, 27.05, 274.24)
    },
    ['Sandy'] = {
        cells = {
            [1] = vec4(1809.12, 3674.52, 33.25, 303.28),
            [2] = vec4(1807.8, 3677.2, 33.25, 314.32),
            [3] = vec4(1806.08, 3679.16, 33.25, 302.28)
        },
        exit = vec4(1833.12, 3668.12, 33.05, 211.8)
    },
    ['Paleto'] = {
        cells = {
            [1] = vec4(-446.59, 6011.74, 26.65, 312.28),
            [2] = vec4(-442.0, 6015.77, 26.65, 132.32),
            [3] = vec4(-449.40, 6014.63, 26.65, 302.28),
            [4] = vec4(-444.8, 6018.81, 26.65, 135.28)
        },
        exit = vec4(-422.43, 5995.6, 30.55, 280.8)
    },
}

Jails = {}

RegisterNetEvent('Ox-Jobcreator:jail', function(id, time)
    local player = W.GetPlayer(source)
    local target = W.GetPlayer(id)
    if not target then
        return player.Notify("ERROR", 'No hay nadie con esa ~y~ID', 'error')
    end
    local name = target.identity.name.." "..target.identity.lastname
    local New = time .. " meses"
    Jails[id] = {
        police = source, 
        id = id, 
        time = time * 60, 
        current_time = 0,
        name = name, 
        identifier = target.identifier,
    }
    TriggerClientEvent("jobcreatorv2:jailClient", source, id, New, name)
    sendToDiscord('INGRESO EN PRISIÓN', "**"..name.."** ha ingresado en prisión durante **"..New.. "** por **"..player.identity.name.." "..player.identity.lastname.."**\n\n**Policía:** "..player.name.."\n**Detenido:** "..target.name, 65280)
    --local ped = GetPlayerPed(id)
    --SetEntityCoords(ped, JailConfig[comisaria].cells[celda].x, JailConfig[comisaria].cells[celda].y, JailConfig[comisaria].cells[celda].z)
    --SetEntityHeading(ped, JailConfig[comisaria].cells[celda].w)
end)


Citizen.CreateThread(function()
    while true do
        for k,v in pairs(Jails) do
            if(v.time and v.current_time)then
                local time_remaining = v.time - v.current_time
                --W.Print("INFO", string.format("Player with id %s, with seconds remaining %s, total of jail %s minutes", v.id, time_remaining, v.time / 60))
                Jails[k].current_time = Jails[k].current_time +1
                if(v.current_time >= v.time)then
                    W.Print("INFO", string.format("Player with id %s has finished jail time, after %s minutes", v.id, v.time / 60))
                    local ped = GetPlayerPed(v.id)
                    if(ped)then
                        SetEntityCoords(ped, 488.96, -1002.24, 27.05)
                        SetEntityHeading(ped, 274.24)
                    end
                    Jails[k] = nil
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

function sendToDiscord(header, message)
    local webhook = "https://discord.com/api/webhooks/1098050747884634224/uYURkv-vqK995WGjURjzI12PzVchD4PiqE0pBkKT5sgPJkE8hH1rmGMauupFv3Urm4D4"
    local name = "REGISTRO PRISIÓN"
    local connect = {
          {
              ["title"] = header,
              ["description"] = message
          }
      }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
end