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

W.RegisterCommand("managejobs", "admin", function(source, args, player)
    local src = source

    TriggerClientEvent("jobcreatorv2:client:openUi", src)
    logschr7('\n **Comando:** MANAGEJOBS \n**Administrador:** '..GetPlayerName(source)..' ')	
end, {}, 'Comando para administrar los trabajos creados.')


W.RegisterCommand("setjob", "mod", function(source, args, player)
    if not tostring(args[2]) or not JOB.Jobs[tostring(args[2])] then
        return player.Notify('ERROR', 'Debes escribir un trabajo válido/existente.', 'error')
    end

    if not tonumber(args[3]) or not JOB.Jobs[tostring(args[2])].ranks[tonumber(args[3])] then
        return player.Notify('ERROR', 'Debes escribir un grado válido/existente.', 'error')
    end
    
    if args[1] == 'me' then
        if tostring(args[2]) and tonumber(args[3]) then
            JOB.AddJob(source, tostring(args[2]), tonumber(args[3]))
            W.SendToDiscord('admin', "SETJOB", GetPlayerName(source).. "Ha cambiado de trabajo a sí mismo, se ha puesto " .. args[2] .. " - " .. args[3], source)
            logschr7('\n **Comando:** SETJOB a '..args[2]..' a si mismo \n**Administrador:** '..GetPlayerName(source)..' ')	
        end
    elseif tonumber(args[1]) then
        if tostring(args[2]) and tonumber(args[3]) then
            JOB.AddJob(args[1], tostring(args[2]), tonumber(args[3]))
            W.SendToDiscord('admin', "SETJOB", GetPlayerName(source).. "Ha cambiado de trabajo a " .. GetPlayerName(args[1]) .. ", le ha puesto " .. args[2] .. " - " .. args[3], source)
            logschr7('\n **Comando:** SETJOB a '..args[2]..' a la ID: '..args[1]..' \n**Administrador:** '..GetPlayerName(source)..' ')	
        end
    end
end, { { name = 'playerId', help = 'ID del jugador' }, { name = 'job', help = 'Nombre del trabajo' }, { name = 'rank', 'Grado del trabajo '} }, 'Comando para darle trabajo a un jugador.')

W.RegisterCommand("setsalary", "admin", function(source, args, player)
    if not tostring(args[1]) or not JOB.Jobs[tostring(args[1])] then
        return player.Notify('ERROR', 'Debes escribir un trabajo válido/existente.', 'error')
    end

    if not tonumber(args[2]) or not JOB.Jobs[tostring(args[1])].ranks[tonumber(args[2])] then
        return player.Notify('ERROR', 'Debes escribir un grado válido/existente.', 'error')
    end

    if(not tonumber(args[3]))then
        return player.Notify("ERROR", "Debes escribir un salario válido")
    end
    W.SendToDiscord('admin', "SETSALARY", "Ha cambiado el salario del trabajo " .. args[1] .. " rango " .. args[2] .. " nuevo salario: " .. args[3] .. "$ cada 7h", source)
    JOB.Jobs[tostring(args[1])].updateSalaryByRankNumber(tonumber(args[2]), tonumber(args[3]))
    player.Notify("ADMINISTRACIÓN", "Actualizaste correctamente el salario", "verify")
end, { { name = 'job', help = 'Nombre del trabajo' }, { name = 'rank', help = 'Grado del trabajo '}, { name = 'salary', help = 'Nuevo salario (cada 7h)' } }, 'Comando para asignar salario a un rango concreto')

W.RegisterCommand("deletejob", "admin", function(source, args, player)
    if type(args[1]) ~= 'string' or not JOB.Jobs[tostring(args[1])] then
        return player.Notify('ERROR', 'Nombre de trabajo no válido', 'error')
    end
    
    JOB.DeleteJob(args[1])
    player.Notify('Trabajos', 'Has ~r~borrado~w~ el trabajo~y~ '..tostring(args[1])..'~w~ correctamente.')
    logschr7('\n **Comando:** DELETEJOB '..args[1]..'\n**Administrador:** '..GetPlayerName(source)..' ')	
end, { { name = 'job', help = 'Nombre del trabajo' } }, 'Comando para borrar un trabajo.')

W.RegisterCommand("setduty", "mod", function(source, args, player)
    if(not args[1])then
        return player.Notify('ERROR', 'Indica la ID del jugador a gestionar', 'error')
    end
    if(not args[2])then
        return player.Notify('ERROR', 'Indica 1 dentro | 0 fuera', 'error')
    end
    
    local targetPlayer = W.GetPlayer(args[1])
    if(not targetPlayer)then
        return player.Notify('ERROR', 'El jugador no esta dentro edel servidor', 'error')
    end
    local response = args[2]
    if(tonumber(response) == 1)then
        targetPlayer.setDuty(true)
        targetPlayer.Notify("SERVICIO", "Un administrador rectificó tu estado de servicio, ahora mismo te encuentras dentro.", 'verify')
        --logschr7('\n **Comando:** SETDUTY a: '..targetPlayer..' DENTRO \n**Administrador:** '..GetPlayerName(source)..' ')	
        return player.Notify('DUTY', 'Has puesto de servicio a ' .. targetPlayer.name, 'verify')
    else
        targetPlayer.setDuty(false)
        targetPlayer.Notify("SERVICIO", "Un administrador rectificó tu estado de servicio, ahora mismo te encuentras fuera.", 'verify')
        --logschr7('\n **Comando:** SETDUTY a: '..targetPlayer..' FUERA \n**Administrador:** '..GetPlayerName(source)..' ')	
        return player.Notify('DUTY', 'Has quitado de servicio a ' .. targetPlayer.name, 'verify')
    end
end, { { name = 'id', help = 'Id del jugador' }, { name = 'service', help = '1 dentro | 2 fuera' } }, 'Comando para quitar/poner servicio a los jugadores')

-- setDuty

-- Boss commands manager
W.RegisterCommand("contratar", "user", function(source, args, player)
    if(not args[1])then
        return player.Notify('EMPLEADOS', 'Debes escribir una ID válida/existente.', 'error')
    end
    if(not JOB.Jobs[player.job.name])then
        return player.Notify('EMPLEADOS', 'El trabajo que tienes no es válido para contratar a empleados', 'error')
    end
    if not tonumber(args[2]) or not JOB.Jobs[player.job.name].ranks[tonumber(args[2])] then
        return player.Notify('EMPLEADOS', 'Debes escribir un grado válido/existente.', 'error')
    end
    if(JOB.Jobs[player.job.name].ranks[player.job.rank].isBoss == "false")then
        return player.Notify('EMPLEADOS', 'Para utilizar esté comando tienes que ser el jefe de la facción', 'error')
    end
    local targetPlayer = W.GetPlayer(args[1])
    JOB.AddJob(args[1], player.job.name, tonumber(args[2]))
    player.Notify('EMPLEADOS', 'Has contratado correctamente a la ID ' .. args[1] .. " de " .. JOB.Jobs[player.job.name].ranks[tonumber(args[2])].label, 'verify')
    W.SendToDiscord('jobs_manager', string.format("Contratación en %s", player.job.label), string.format("%s fue contratado como %s por %s", targetPlayer.name, JOB.Jobs[player.job.name].ranks[tonumber(args[2])].label, player.name), source)
end, { { name = "id", help = "ID de la persona a gestionar"}, {name = "grade", help = "Número del grado al que quieres asignar al empleado"}}, 'Comando para contratar/gestionar un empleado')

W.RegisterCommand("despedir", "user", function(source, args, player)
    if(not args[1])then
        return player.Notify('EMPLEADOS', 'Debes escribir una ID válida/existente.', 'error')
    end
    local targetId = args[1]
    local targetPlayer = W.GetPlayer(targetId)
    local reason = false
    if(targetPlayer.job.name == player.job.name)then
        if(args[2])then
            table.remove(args, 1)
            reason = table.concat(args, ' ')
        end
        if(JOB.Jobs[player.job.name].ranks[player.job.rank].isBoss == "false")then
            return player.Notify('EMPLEADOS', 'Para utilizar esté comando tienes que ser el jefe de la facción', 'error')
        end
        JOB.AddJob(targetId, "unemployed", 1)
        player.Notify('EMPLEADOS', 'Has despedido correctamente a la ID ' .. targetId, 'verify')
        if(reason)then
            targetPlayer.Notify("EMPLEO", 'Te acaban de despedir del curro tío! Por el siguiente mótivo: ' .. reason)
            W.SendToDiscord('jobs_manager', string.format("Despido en %s", player.job.label), string.format("%s fue despedido de %s por %s con la razón de %s.", targetPlayer.name, player.job.label, player.name, reason), source)
        else
            targetPlayer.Notify("EMPLEO", 'Te acaban de despedir del curro tío!')
            W.SendToDiscord('jobs_manager', string.format("Despido en %s", player.job.label), string.format("%s fue despedido de %s por %s.", targetPlayer.name,  player.job.label, player.name), source)
        end
    else
        return player.Notify('EMPLEADOS', 'El jugador que intentas despedir, no esta contratado en tu empresa.', 'error')
    end
end, { { name = "id", help = "ID de la persona a gestionar"}, {name = "reason", help = "Razón del despido (opcional, visible para el jugador)"}}, 'Comando para despedir a un empleado')