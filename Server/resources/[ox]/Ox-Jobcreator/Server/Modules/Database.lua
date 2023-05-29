-- OXMYSQL Wrapper code, all rights deserved to them.
---comment
---@param query any
---@param array any
---@param cb any
---@return any
JOB.Execute = function(query, array, cb)
    local p = promise.new()
    exports.oxmysql:execute(query, array, function(result)
        p:resolve(result)
    end)
    if cb then
        return cb(Citizen.Await(p))
    end
end

JOB.ExportDatabase = function(wait)
    for key, value in next, JOB.Jobs do
        if value.update then
            JOB.Execute('UPDATE guille_jobcreator SET `name` = ?, `label` = ?, `points` = ?, `data` = ?, `ranks` = ?, `blips` = ?, `publicvehicles` = ?, `privatevehicles` = ?, `wardrobe` = ?, `shop` = ?, `money` = ?, `blackmoney` = ? WHERE name = ?', {
                value.name,
                value.label,
                json.encode(value.points),
                json.encode(value.options),
                json.encode(value.ranks),
                json.encode(value.blips),
                json.encode(value.publicvehicles),
                json.encode(value.privatevehicles),
                json.encode(value.wardrobe),
                json.encode(value.shop),
                value.money,
                value.blackmoney,
                value.name
            }, function()
                W.Print('INFO', 'Job '..value.name..' has been updated to database')
            end)
            JOB.Jobs[key].update = false
            if(wait)then
                Citizen.Wait(100)
            end
        end
    end
end

JOB.ExportDatabaseByJob = function(job, type)
    if(not JOB.Jobs[job])then
        return
    end
    local value = JOB.Jobs[job]

    if(type == "markers")then
        JOB.Execute('UPDATE guille_jobcreator SET `points` = ? WHERE name = ?', {
            json.encode(value.points),
            value.name
        }, function()
            W.Print('INFO', 'Markers from '..value.name..' has been updated to database')
        end)
    elseif(type == "options")then
        JOB.Execute('UPDATE guille_jobcreator SET `options` = ? WHERE name = ?', {
            json.encode(value.options),
            value.name
        }, function()
            W.Print('INFO', 'Options from '..value.name..' has been updated to database')
        end)
    elseif(type == "ranks")then
        JOB.Execute('UPDATE guille_jobcreator SET `ranks` = ? WHERE name = ?', {
            json.encode(value.ranks),
            value.name
        }, function()
            W.Print('INFO', 'Ranks from '..value.name..' has been updated to database')
        end)
    elseif(type == "public_vehs")then
        JOB.Execute('UPDATE guille_jobcreator SET `publicvehicles` = ? WHERE name = ?', {
            json.encode(value.publicvehicles),
            value.name
        }, function()
            W.Print('INFO', 'Public vehicles from '..value.name..' has been updated to database')
        end)
    elseif(type == "shop")then
        JOB.Execute('UPDATE guille_jobcreator SET `shop` = ? WHERE name = ?', {
            json.encode(value.shop),
            value.name
        }, function()
            W.Print('INFO', 'Shop from '..value.name..' has been updated to database')
        end)
    elseif(type == "all")then
        JOB.Execute('UPDATE guille_jobcreator SET `name` = ?, `label` = ?, `points` = ?, `data` = ?, `ranks` = ?, `blips` = ?, `publicvehicles` = ?, `privatevehicles` = ?, `wardrobe` = ?, `shop` = ?, `money` = ?, `blackmoney` = ? WHERE name = ?', {
            value.name,
            value.label,
            json.encode(value.points),
            json.encode(value.options),
            json.encode(value.ranks),
            json.encode(value.blips),
            json.encode(value.publicvehicles),
            json.encode(value.privatevehicles),
            json.encode(value.wardrobe),
            json.encode(value.shop),
            value.money,
            value.blackmoney,
            value.name
        }, function()
            W.Print('INFO', 'Job '..value.name..' has been updated to database')
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        JOB.ExportDatabase()
        Citizen.Wait(5 * 60 * 1000) ---Every 5 minutes is going to update jobs that needs to be updated
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        JOB.ExportDatabase()
    end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if(eventData.secondsRemaining == 60)then
        CreateThread(function()            
            JOB.ExportDatabase()
        end)
    end
end)