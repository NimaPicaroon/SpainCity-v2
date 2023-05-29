CreateThread(function()
    SetTimeout(1000, function()
        exports.oxmysql:execute("SELECT id, name, label, points, data, ranks, blips, publicvehicles, privatevehicles, wardrobe, shop, money, blackmoney FROM `guille_jobcreator`", {}, function(data)
            for k, v in pairs(data) do
                v.name = tostring(v.name)
    
                JOB.Jobs[v.name] = JOB.CreateJob(v.name, v.label, json.decode(v.ranks), json.decode(v.points), json.decode(v.data), json.decode(v.blips), json.decode(v.publicvehicles), json.decode(v.privatevehicles), json.decode(v.wardrobe), json.decode(v.shop), tonumber(v.money), tonumber(v.blackmoney))
                JOB.Jobs[v.name].players = {}
                JOB.Jobs[v.name].fetchMembers()
    
                for _,c in pairs(json.decode(v.blips)) do
                    JOB.Blips[v.name] = { color = c.color, sprite = c.sprite, text = c.text, y = c.y, z = c.z, x = c.x, job = v.name}
                end
    
                GlobalState.JobsBlips = JOB.Blips
                GlobalState[v.name.."-guille"] = JOB.Jobs[v.name]
                --JOB.Print("INFO", ("Job loaded '%s'"):format(v.name))
            end

            GlobalState.JobsData = JOB.Jobs
        end)
    end)
end)

exports('getJobs', function()
    return JOB.Jobs
end)

W.CreateCallback("jobcreatorv2:server:edit", function(source, cb)
    cb(JOB.Jobs)
end)

W.CreateCallback("jobcreatorv2:server:getJobData", function(source, cb, job)
    print(job)
    cb(JOB.Jobs[job])
end)

RegisterNetEvent('jobcreator:init', function()
    local src = source
    local player = W.GetPlayer(src)

    if player['job'] and player['job'].name then
        if JOB.Jobs[player['job'].name] then
            table.insert(JOB.Jobs[player['job'].name].players, src)
            TriggerClientEvent("jobcreatorv2:client:initData", tonumber(src))
        else
            local jobData = {salary = 50, name = 'unemployed', rank = 1, rankname = 'unemployed', ranklabel = 'En paro', label = 'Desempleado', duty = true}
            player.setJob(jobData)
            TriggerClientEvent("jobcreatorv2:client:initData", tonumber(src), tonumber(src))
            TriggerClientEvent('jobs:changeJob', tonumber(src), jobData)
            TriggerEvent('jobs:updateJob', src, jobData)
        end
    end

    if player.identity and player.identity.name then
        for k,v in pairs(Jails) do
            if v.identifier == player.identifier then
                Jails[src] = {police = v.police, id = src, comisaria = v.comisaria, celda = v.celda, time = v.time, peligroso = v.peligroso, name = v.name, identifier = identifier}
                Jails[v.id] = nil
                Jails[k] = nil
            end
        end
    end
end)
RegisterNetEvent("jobcreadotr:dis")
AddEventHandler("jobcreadotr:dis", function()
    local src = source
    local player = W.GetPlayer(src)
    TriggerClientEvent("core:client:deleteVehsInArea", player.src, 1)
end)
--

Taxis = { }

exports('getTaxis', function()
    return Taxis
end)

AddEventHandler('ZCore:playerLoaded', function(source, player)
    if player and player.job.name == 'taxi' then
        Taxis[source] = { source = source }
    end
end)

AddEventHandler('ZCore:setJob', function(source, newJob, lastJob)
    if lastJob.name == 'taxi' and newJob.name ~= 'taxi' then
        Taxis[source] = nil

        return
    end

    if lastJob.name ~= 'taxi' and newJob.name == 'taxi' then
        Taxis[source] = { source = source }

        return
    end
end)

AddEventHandler('ZCore:setDuty', function(source, newJob, lastJob)
    if newJob.name == 'taxi' and newJob.onduty then
        Taxis[source] = { source = source }
        
        return
    end
end)

AddEventHandler("playerDropped", function()
    local src <const> = source

    for k,v in pairs(Taxis) do
        if v and (v.source == src) and Taxis[v.source] then
            Taxis[v.source] = nil
        end
    end
end)