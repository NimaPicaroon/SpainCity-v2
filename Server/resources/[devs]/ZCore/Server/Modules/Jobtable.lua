W.JobTable = { }

AddEventHandler('ZCore:playerLoaded', function(source, player)
    if(player and player.job.duty)then
        TriggerEvent("ZCore:JobTable:add", player.job, player.name, source)
    end
end)

AddEventHandler("ZCore:playerDisconnected", function(src, player)
    if(player)then
        TriggerEvent("ZCore:JobTable:remove", player.job, player.src)
    end
end)

AddEventHandler('ZCore:setJob', function(source, newJob, lastJob)
    TriggerEvent("ZCore:JobTable:add", newJob, W.Plys[source].name, source)
    TriggerEvent("ZCore:JobTable:remove", lastJob, source)
end)

AddEventHandler('ZCore:setDuty', function(source, newJob, lastJob)
    local src = source
    local player = W.GetPlayer(src)
    if(player.job.duty)then
        TriggerEvent("ZCore:JobTable:add", player.job, player.name, player.src)
    else
        TriggerEvent("ZCore:JobTable:remove", player.job, player.src)
    end
end)

RegisterNetEvent("ZCore:JobTable:remove", function(job, player)
    if not W.JobTable[job.name] then
        W.JobTable[job.name] = {}
    end
    for k, v in pairs(W.JobTable[job.name]) do
        if(v.player == player)then
            table.remove(W.JobTable[job.name], k)
        end
    end
end)

RegisterNetEvent("ZCore:JobTable:add", function(job, name, player)
    if not W.JobTable[job.name] then
        W.JobTable[job.name] = {}
    end
    for k, v in pairs(W.JobTable[job.name]) do
        if(v.player == player)then
            table.remove(W.JobTable[job.name], k)
        end
    end
    table.insert(W.JobTable[job.name], {
        job = job,
        player = player,
        name = name
    })
end)

exports("GetJobTable", function()
    return W.JobTable
end)