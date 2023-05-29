AdminDispatcher = {}
AdminDispatcher.tasks = {}

Citizen.CreateThread(function()
    AdminDispatcher.init()
end)

W.RegisterCommand('report', 'user', function(playerSrc, playerArgs, player)
    local playerMessage = table.concat(playerArgs, ' ')
    if playerMessage ~= '' then
        AdminDispatcher.addTask(playerMessage, playerSrc, player, "reports")
    else
        player.Notify('ADMINISTRACIÓN', "Escribe el mensaje", 'error')
    end
    W.SendToDiscord("reports", "NUEVO REPORTE", playerMessage, playerSrc)

end, { { name = 'message', help = 'Mensaje' } }, 'Comando para enviar un reporte')

W.RegisterCommand('bug', 'user', function(playerSrc, playerArgs, player)
    local playerMessage = table.concat(playerArgs, ' ')
    if playerMessage ~= '' then
        AdminDispatcher.addTask(playerMessage, playerSrc, player, "bugs")
    else
        player.Notify('ADMINISTRACIÓN', "Escribe el mensaje", 'error')
    end
    W.SendToDiscord("reports", "NUEVO BUG REPORTADO", playerMessage, playerSrc)
end, { { name = 'message', help = 'Mensaje' } }, 'Comando para enviar un bug')

AdminDispatcher.init = function()
    for k, v in pairs(Cfg.DispatcherTypes) do
        if not AdminDispatcher.tasks[k] then
            AdminDispatcher.tasks[k] = {}
            W.Print("INFO", "New report config loaded: " .. k)
        end
    end
end

AdminDispatcher.addTask = function(message, playerSrc, player, typeTask)
    local date = os.date('*t')
    local taskConfig = Cfg.DispatcherTypes[typeTask]
    TriggerClientEvent('chat:addMessage', playerSrc, { args = {string.format("%s | [%s] -  %s", taskConfig.title, playerSrc, GetPlayerName(playerSrc)), message }, color = taskConfig.color })
    local taskNumber = #AdminDispatcher.tasks[typeTask] +1
    AdminDispatcher.tasks[typeTask][taskNumber] = {
        message = message,
        source = playerSrc,
        date = {
            min = date.min,
            hour = date.hour,
            day = date.day,
            month = date.month,
        },
        taskConfig = taskConfig,
        taskType = typeTask,
        player = player,
        handled = false,
    }
    for k, v in pairs(admins) do
        if(playerSrc ~= v.source and v.service)then
            TriggerClientEvent('chat:addMessage', v.source, { args = {string.format("%s ID %s | [%s] - %s", taskConfig.title, taskNumber, playerSrc, GetPlayerName(playerSrc)), message}, color = taskConfig.color })
        end
    end
    --W.SendToDiscord("reports", "NUEVO REPORTE", GetPlayerName(playerSrc)..": " ..playerMessage, playerSrc)
end

AdminDispatcher.acceptReport = function(taskType, taskId, adminSrc, adminData)
    if(AdminDispatcher.tasks[taskType][taskId])then
        if(not AdminDispatcher.tasks[taskType][taskId].handled)then
            AdminDispatcher.tasks[taskType][taskId].handled = true
            local taskAssigned = AdminDispatcher.tasks[taskType][taskId]
            local customerServed = W.GetPlayer(taskAssigned.source)
            local taskTitle = taskAssigned.taskConfig.title
            customerServed.Notify(taskTitle:upper() .. " #" .. taskId, "Su " .. taskTitle:lower() .. " ha sido atendido por un administrador", "verify")
            adminData.Notify(taskTitle:upper() .. " #" .. taskId, "Has atendido correctamente el " .. taskTitle:lower() .. " de " .. customerServed.name, "verify")
            for k, v in pairs(admins) do
                if(v.service)then
                    TriggerClientEvent('chat:addMessage', v.source, { args = {"El " .. taskTitle:lower() .. " número " .. taskId .. " ha sido atendido por " .. adminData.name}, color = taskAssigned.taskConfig.color })
                end
            end
            W.SendToDiscord("reports", taskTitle .. " #" .. taskId .. " atendido", "El " .. taskTitle:lower() .. " con concepto (" .. taskAssigned.message .. ") fue atendido por " .. adminData.name, adminData.src)
        else
            adminData.Notify("Centralita de Administración", "El aviso que quieres atender ya fue atendido por otro administrador", "error")
        end
    else
        adminData.Notify("Centralita de Administración", "El aviso que quieres atender no existe", "error")
    end
end

AdminDispatcher.countTasksNotHandled = function(type)
    local counter = 0
    for k, v in pairs(AdminDispatcher.tasks[type]) do
        if(not v.handled)then
            counter = counter +1
        end
    end
    return counter
end

AdminDispatcher.countAllDeliveredTasks = function(type)
    return #AdminDispatcher.tasks[type]
end

W.RegisterCommand('mior', 'mod', function(playerSrc, playerArgs, player)
    if(playerArgs[1])then
        AdminDispatcher.acceptReport("reports", tonumber(playerArgs[1]), playerSrc, player)
    end
end, { { name = 'id', help = 'ID del reporte' } }, 'Comando para atender reportes')

W.RegisterCommand('miob', 'mod', function(playerSrc, playerArgs, player)
    if(playerArgs[1])then
        AdminDispatcher.acceptReport("bugs", tonumber(playerArgs[1]), playerSrc, player)
    end
end, { { name = 'id', help = 'ID del reporte' } }, 'Comando para atender reportes')

W.RegisterCommand('reportes', 'mod', function(playerSrc, playerArgs, player)
    local totalNotHandledReports = AdminDispatcher.countTasksNotHandled("reports")
    if(totalNotHandledReports == 0)then
        player.Notify("Centralita de Reportes", "No hay reportes sin atender, muchas gracias equipo administrativo!", "info")
        return
    end
    TriggerClientEvent('chat:addMessage', playerSrc, { args = {string.format("Total de reportes sin atender: %s", AdminDispatcher.countTasksNotHandled("reports")) }, color = {3, 202, 252} })
    TriggerClientEvent('chat:addMessage', playerSrc, { args = {string.format("Total de reportes durante todo el reinicio: %s", AdminDispatcher.countAllDeliveredTasks("reports")) }, color = {3, 202, 252} })
    for k, v in pairs(AdminDispatcher.tasks["reports"]) do
        if(not v.handled)then
            TriggerClientEvent('chat:addMessage', playerSrc, { args = {string.format("REPORTE [%s] | %s - [%s] | ^0%s a las ^2%s:%s", k, v.player.name, v.source, v.message, v.date.hour, v.date.min) }, color = {3, 202, 252} })
        end
    end
end, {}, 'Comando para ver los reportes sin atender')

W.RegisterCommand('bugs', 'mod', function(playerSrc, playerArgs, player)
    local totalNotHandledReports = AdminDispatcher.countTasksNotHandled("bugs")
    if(totalNotHandledReports == 0)then
        player.Notify("Centralita de Bugs", "No hay bugs sin atender, muchas gracias equipo administrativo!", "info")
        return
    end
    TriggerClientEvent('chat:addMessage', playerSrc, { args = {string.format("Total de bugs sin atender: %s", AdminDispatcher.countTasksNotHandled("bugs")) }, color = {3, 202, 252} })
    TriggerClientEvent('chat:addMessage', playerSrc, { args = {string.format("Total de bugs durante todo el reinicio: %s", AdminDispatcher.countAllDeliveredTasks("bugs")) }, color = {3, 202, 252} })
    for k, v in pairs(AdminDispatcher.tasks["bugs"]) do
        if(not v.handled)then
            TriggerClientEvent('chat:addMessage', playerSrc, { args = {string.format("BUG [%s] | %s - [%s] | ^0%s a las ^2%s:%s", k, v.player.name, v.source, v.message, v.date.hour, v.date.min) }, color = {3, 202, 252} })
        end
    end
end, {}, 'Comando para ver los bugs sin atender')