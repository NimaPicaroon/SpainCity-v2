showed = false
inConfig = false
responding = false

RegisterNetEvent('ZCore:setJob')
AddEventHandler('ZCore:setJob', function(job, lastJob)
	if not Config.Jobs[job.name] then
        showed = false
        inConfig = false
        alerts = {}
        currentAlert = 0
        SendNUIMessage({
            toggle = showed;
            toggleConfig = inConfig;
        })
    else
        if lastJob.name ~= job.name then
            showed = false
            inConfig = false
            alerts = {}
            currentAlert = 0
            SendNUIMessage({
                toggle = showed;
                toggleConfig = inConfig;
            })
        end
	end
end)

RegisterCommand("right", function()
    if showed and alerts[currentAlert + 1] and not responding then
        currentAlert = currentAlert + 1
        if alerts[currentAlert]['model'] then
            SendNUIMessage({
                text = alerts[currentAlert]['text'];
                callnum = currentAlert;
                left = true;
                pic = true;
                model = alerts[currentAlert]['model'];
            })
        else
            local distanceToAlert = #(alerts[currentAlert]['coords'] - GetEntityCoords(PlayerPedId()))
            local finalDistanceTo = round(round(distanceToAlert) * 0.001)
            local alert = {
                text = alerts[currentAlert]['text'],
                type = alerts[currentAlert]['type'],
                currentAlert = currentAlert,
                distance = finalDistanceTo;
                totalcalls = #alerts,
                changealert = true,
            }
            SendNUIMessage(alert)
        end
    end
end, false)

RegisterCommand("left", function()
    if showed and alerts[currentAlert - 1] and not responding then
        currentAlert = currentAlert - 1
        if alerts[currentAlert]['model'] then
            SendNUIMessage({
                text = alerts[currentAlert]['text'];
                callnum = currentAlert;
                left = true;
                pic = true;
                model = alerts[currentAlert]['model'];
            })
        else
            local distanceToAlert = #(alerts[currentAlert]['coords'] - GetEntityCoords(PlayerPedId()))
            local finalDistanceTo = round(round(distanceToAlert) * 0.001)
            local alert = {
                text = alerts[currentAlert]['text'],
                type = alerts[currentAlert]['type'],
                currentAlert = currentAlert,
                distance = finalDistanceTo;
                totalcalls = #alerts,
                changealert = true,
            }
            SendNUIMessage(alert)
        end
    end
end, false)

RegisterCommand("aceptarentorno", function()
    if showed and currentAlert ~= 0 and not responding then
        SetNewWaypoint(alerts[currentAlert]['coords'].x, alerts[currentAlert]['coords'].y)
        W.Notify('CENTRAL', 'Te hemos marcado el aviso en el ~y~GPS', 'verify')
        responding = true
    end
end, false)

RegisterCommand('cancelentorno', function()
    if showed and currentAlert ~= 0 and responding then
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        SetNewWaypoint(playerPos.x, playerPos.y)
        W.Notify('CENTRAL', 'Te hemos desmarcado el aviso', 'verify')
        responding = false
    end
end)

RegisterCommand("showalerts", function()
    local OwnData = W.GetPlayerData()
    if OwnData.job and Config.Jobs[OwnData.job.name] and OwnData.job.duty then
        showed = not showed
        SendNUIMessage({
            toggle = showed;
            myJob = OwnData.job.name;
        })
    else
        W.Notify('CENTRAL', 'Tu trabajo no necesita alertas')
    end
end, false)

RegisterCommand("optionsdisp", function()
    if showed then
        inConfig = not inConfig
        SendNUIMessage({
            toggleConfig = inConfig;
        })

        SetNuiFocus(inConfig, inConfig)
        SetNuiFocusKeepInput(inConfig)

        StartLoopControls()
    end
end, false)

function StartLoopControls()
    CreateThread(function()
        while inConfig do
            Wait(0)

            DisableControlAction(0, 1, true) -- disable mouse look
            DisableControlAction(0, 2, true) -- disable mouse look
            DisableControlAction(0, 3, true) -- disable mouse look
            DisableControlAction(0, 4, true) -- disable mouse look
            DisableControlAction(0, 5, true) -- disable mouse look
            DisableControlAction(0, 6, true) -- disable mouse look
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 177, true) -- disable escape
            DisableControlAction(0, 200, true) -- disable escape
            DisableControlAction(0, 202, true) -- disable escape
            DisableControlAction(0, 322, true) -- disable escape
            DisableControlAction(0, 245, true) -- disable chat
            DisableControlAction(0, 37, true) -- disable TAB
            DisableControlAction(0, 261, true) -- disable mouse wheel
            DisableControlAction(0, 262, true) -- disable mouse wheel
            HideHudComponentThisFrame(19)
            DisablePlayerFiring(PlayerId(), true) -- disable weapon firing
        end
    end)
end

RegisterKeyMapping("right", ("Mover a la siguiente alerta hacia la derecha"), 'keyboard', 'right')
RegisterKeyMapping("left", ("Mover a la siguiente alerta hacia la izquierda"), 'keyboard', 'left')
RegisterKeyMapping("showalerts", ("Abrir dispatch"), 'keyboard', 'f4')
RegisterKeyMapping("aceptarentorno", ("Marcar la alerta en el GPS"), 'keyboard', 'PAGEUP')
RegisterKeyMapping("cancelentorno", ("Desmarcar la alerta"), 'keyboard', 'PAGEDOWN')
RegisterKeyMapping("optionsdisp", ("Opciones del dispatch"), 'keyboard', 'i')