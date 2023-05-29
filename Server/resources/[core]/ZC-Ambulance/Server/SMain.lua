Amb = setmetatable({ }, Amb)
DeadPeople = {}

W.RegisterCommand("revive", "mod", function (source, args, player)
    if args[1] then
        local ID = tonumber(args[1])
        if args[1] == 'me' then
            ID = source
        end
        if not ID then return end
        local Player = W.GetPlayer(ID)
        if Cfg.WhitelistedAdmins[player.identifier] then
            --print ("personawl")
        else
        W.SendToDiscord('admin', "REVIVE", 'A '..GetPlayerName(Player.src), source)
        logschr7('\n **Comando:** REVIVE a la ID: '..Player.src..' \n**Administrador:** '..GetPlayerName(source)..' ')	
        end
        return TriggerClientEvent("zcambulance:client:revivePlayer", Player.src)
    else
        if Cfg.WhitelistedAdmins[player.identifier] then
            --print ("personawl")
        else
        W.SendToDiscord('admin', "REVIVE", 'A si mismo', source)
        logschr7('\n **Comando:** REVIVE a si mismo \n**Administrador:** '..GetPlayerName(source)..' ')	
        end
        return TriggerClientEvent("zcambulance:client:revivePlayer", source)
    end
end, {
    {name = "Id", help = "Id del jugador (dejar vacio para revivirse a si mismo)"}
})

W.RegisterCommand("kill", "mod", function (source, args, player)
    if args[1] then
        local ID = tonumber(args[1])
        if args[1] == 'me' then
            ID = source
        end
        if not ID then return end
        local Player = W.GetPlayer(ID)

        if not Player then
            return
        end
        if Cfg.WhitelistedAdmins[player.identifier] then
            --print ("personawl")
        else
        W.SendToDiscord('admin', "KILL", GetPlayerName(source)..' mató a '..GetPlayerName(Player.src), source)
        logschr7('\n **Comando:** KILL a la ID: '..Player.src..' \n**Administrador:** '..GetPlayerName(source)..' ')
        end	
        return TriggerClientEvent("zcambulance:client:killPlayer", Player.src)
    else
        if Cfg.WhitelistedAdmins[player.identifier] then
            --print ("personawl")
        else
        W.SendToDiscord('admin', "KILL", GetPlayerName(source)..' reviviendose a si mismo', source)
        logschr7('\n **Comando:** KILL a si mismo \n**Administrador:** '..GetPlayerName(source)..' ')
        end
        return TriggerClientEvent("zcambulance:client:killPlayer", source)
    end
end, {
    {name = "Id", help = "Id del jugador (dejar vacio para matarse a si mismo)"}
})

W.RegisterCommand("heal", "mod", function (source, args, player)
    if args[1] then
        local ID = tonumber(args[1])
        if args[1] == 'me' then
            ID = source
        end
        if not ID then return end
        local Player = W.GetPlayer(ID)
        
        if not Player then
            return
        end
        if Cfg.WhitelistedAdmins[player.identifier] then
            --print ("personawl")
        else
        W.SendToDiscord('admin', "HEAL", 'A '..GetPlayerName(Player.src), source)
        logschr7('\n **Comando:** HEAL a la ID: '..Player.src..' \n**Administrador:** '..GetPlayerName(source)..' ')	
        end
        return TriggerClientEvent("zcambulance:client:heal", Player.src)
    else
        if Cfg.WhitelistedAdmins[player.identifier] then
            --print ("personawl")
        else
        W.SendToDiscord('admin', "HEAL", 'A si mismo', source)
        logschr7('\n **Comando:** HEAL a si mismo \n**Administrador:** '..GetPlayerName(source)..' ')
        end
        return TriggerClientEvent("zcambulance:client:heal", source)
    end
end, {
    {name = "Id", help = "Id del jugador (dejar vacio para matarse a si mismo)"}
})

IsDead = function (dead, cause, killerId)
    local src = source
    local player = W.GetPlayer(src)

    if dead == 1 then
        DeadPeople[src] = true
        
        if killerId == 0 then
            W.SendToDiscord('deaths', "MUERTES", 'Se ha suicidado', source)
        else
            W.SendToDiscord('deaths', "MUERTES", GetPlayerName(source)..'** ha muerto a manos de **' ..GetPlayerName(killerId).." ["..killerId..'] ** por **('..cause..')', source)
        end
    else
        DeadPeople[src] = false
    end

    TriggerClientEvent("ZC-Ambulance:SyncPeople", -1, DeadPeople)
    player.updateDead(dead)
end

RegisterNetEvent("ZC-Ambulance:updateDead", IsDead)

Revive = function(src, account)
    local player = W.GetPlayer(source)
    local target = W.GetPlayer(src)
    player.removeMoney(account, 1000)
    player.Notify('HOSPITAL', 'Los médicos están atendiendo  al sujeto...')
    TriggerClientEvent("zcambulance:client:revivePlayerModified", target.src)
    DeadPeople[src] = false
    TriggerClientEvent("ZC-Ambulance:SyncPeople", -1, DeadPeople)
end

RegisterNetEvent("ZC-Ambulance:revivePlayer", Revive)

Revive2 = function(src, account)
    local player = W.GetPlayer(source)
    local target = W.GetPlayer(src)
    player.removeMoney(account, 1)
    player.Notify('HOSPITAL', 'Los médicos están atendiendo  al sujeto...')
    TriggerClientEvent("zcambulance:client:revivePlayerModified", target.src)
    DeadPeople[src] = false
    TriggerClientEvent("ZC-Ambulance:SyncPeople", -1, DeadPeople)
end

RegisterNetEvent("ZC-Ambulance:revivePlayerFromPolice", Revive2)

ReviveFromJob = function(target)
    local player = W.GetPlayer(target)
    TriggerClientEvent("zcambulance:client:revivePlayer", player.src)
    DeadPeople[target] = false
    TriggerClientEvent("ZC-Ambulance:SyncPeople", -1, DeadPeople)
end

RegisterNetEvent("ZC-Ambulance:revivePlayerFromJob", ReviveFromJob)

HealFromJob = function(target, type)
    local player = W.GetPlayer(target)
    TriggerClientEvent("zcambulance:client:heal", player.src, type)
end

RegisterNetEvent("ZC-Ambulance:healFromJob", HealFromJob)

AddEventHandler('ZCore:playerLoaded', function(source, player)
    if player then
        if player.dead == 1 then
            Wait(2000)
            TriggerClientEvent('ZC-Ambulance:WasDead', player.src)
            player.updateDead(0)
        end
    end
end)

local oArray = {}
local oPlayerUse = {}

AddEventHandler('playerDropped', function()
    local oSource = source
    if oPlayerUse[oSource] ~= nil then
        oArray[oPlayerUse[oSource]] = nil
        oPlayerUse[oSource] = nil
    end
end)

RegisterServerEvent('ChairBedSystem:Server:Enter')
AddEventHandler('ChairBedSystem:Server:Enter', function(object, objectcoords)
    local oSource = source
    local player = W.GetPlayer(source)
    if oArray[objectcoords] == nil then
        oPlayerUse[oSource] = objectcoords
        oArray[objectcoords] = true
        player.removeMoney("bank", 300)
        TriggerClientEvent('ChairBedSystem:Client:Animation', oSource, object, objectcoords)
    end
end)

RegisterServerEvent('ChairBedSystem:Server:Leave')
AddEventHandler('ChairBedSystem:Server:Leave', function(objectcoords)
    local oSource = source

    oPlayerUse[oSource] = nil
    oArray[objectcoords] = nil
end)

tirastebro = function()
    --local player = W.GetPlayer(source)
    W.SendToDiscord("tirardee", "HA TIRADO DE E", "A", source)
    --W.Print("INFO", source)
end
RegisterNetEvent("ZC-Ambulance:TirarDeE", tirastebro)

-- Count of EMS

Medics = { }

exports('getMedics', function()
    return Medics
end)

AddEventHandler('ZCore:playerLoaded', function(source, player)
    if player and player.job.name == 'ambulance' then
        Medics[source] = { source = source }
    end
end)

AddEventHandler('ZCore:setJob', function(source, newJob, lastJob)
    if lastJob.name == 'ambulance' and newJob.name ~= 'ambulance' then
        Medics[source] = nil

        return
    end

    if lastJob.name ~= 'ambulance' and newJob.name == 'ambulance' then
        Medics[source] = { source = source }

        return
    end
end)

AddEventHandler('ZCore:setDuty', function(source, newJob, lastJob)
    if newJob.name == 'ambulance' and newJob.onduty then
        Medics[source] = { source = source }
        
        return
    end
end)

AddEventHandler("playerDropped", function()
    local src <const> = source

    for k,v in pairs(Medics) do
        if v and (v.source == src) and Medics[v.source] then
            Medics[v.source] = nil
        end
    end
end)

webhookUrl = 'https://discord.com/api/webhooks/1099082830887264306/YP29KjzvRSu0L8LgRjBNpEQy5W7mrX8IaxFuOFKUSZdW1SZfFs-R6Fl8vfC6aKEvWASI'
logschr7 = function(message)
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 
    'POST', json.encode(
        {username = "X", 
        embeds = {
            {["color"] = 16711680, 
            ["author"] = {
            ["name"] = "Dirección Logs",
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"},
            ["description"] = "".. message .."",
            ["footer"] = {
            ["text"] = "SpainCityRP - "..os.date("%x %X %p"),
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png",},}
        }, avatar_url = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"}), {['Content-Type'] = 'application/json' })
end
