W.Times = {}

exports('getTime', function(identifier)
    if not W.Times[identifier] then
        return 0
    end

    return W.Times[identifier].hours, W.Times[identifier].mins
end)

RegisterNetEvent('ZCore:paycheck', function()
    local src = source
    local ply = W.GetPlayer(src)

    if not W.Times[ply.identifier] then
        return ply.Notify('Salario', 'No has hecho las ~y~minutos~w~ necesarios para poder cobrar.', 'error')
        --return ply.Notify('Salario', 'No has hecho las ~y~minutos~w~ necesarios para poder cobrar.. Te faltan ~y~20~w~.', 'error')
    end

    if W.Times[ply.identifier].hours < 20 then
        return ply.Notify('Salario', 'No has hecho los ~y~minutos~w~ necesarios para poder cobrar.', 'error')
        --return ply.Notify('Salario', 'No has hecho los ~y~minutos~w~ necesarios para poder cobrar. Te faltan ~y~'..(20 - W.Times[ply.identifier].hours)..'~w~.', 'error')
    end

    if ply.job.name == 'unemployed' then
        return ply.Notify('Salario', 'No tienes salario, eres desempleado.', 'error')
    end

    if W.Times[ply.identifier] then
        local jobData = exports['Ox-Jobcreator']:getJobData(ply.job.name)

        if not jobData then
            print('Job data from Jobcreator does not exist ^5('..ply.job.name..')^7.')
            return ply.Notify('Salario', 'No tienes salario', 'error')
        end

        if not jobData.ranks[tonumber(ply.job.rank)].salary then
            return ply.Notify('Salario', 'No tienes salario', 'error')
        end

        local result = W.Times[ply.identifier].hours // 20
        local rest = W.Times[ply.identifier].hours % 20
        local toPay = result * jobData.ranks[tonumber(ply.job.rank)].salary / 20

        if toPay then
            ply.addMoney('bank', tonumber(toPay))
            ply.Notify('Salario', 'Has cobrado ~g~$'..tonumber(toPay)..'~w~ por tu trabajo.', 'verify')
            --ply.Notify('Salario', 'Has cobrado ~g~$'..tonumber(toPay)..'~w~ por tu trabajo semanal.', 'verify')
           -- ply.Notify('Trabajo', 'En total hiciste ~y~'..W.Times[ply.identifier].hours..'~w~ minutos y ~y~'..W.Times[ply.identifier].mins..'~w~ minutos, pero, solo se te han cobrado ~y~'..(result * 0.20)..'~w~ horas.', 'info')
            W.SendToDiscord('paycheck', "PAGA", 'Ha cobrado $'..tonumber(toPay)..' por su trabajo semanal', src)
            W.Times[ply.identifier].hours = rest
            if W.Times[ply.identifier].hours < 0 then
                W.Times[ply.identifier].hours = 0
            end
        end
    end
end)

CreateThread(function()
    local salaries = LoadResourceFile(GetCurrentResourceName(), './Server/Modules/paycheck.json')

    if not salaries then
        W.Times = {}
    else
        W.Times = json.decode(salaries)
    end
end)

Citizen.CreateThread(function()
    while true do
        W.UpdatePayCheck()

        Citizen.Wait(60000)
    end
end)

W.UpdatePayCheck = function()
    for key, value in next, W.PlayersSource do
        if not value.disconnected then
            local player = W.GetPlayer(tonumber(value.source))

            if player then
                if player.job and player.job.name ~= 'unemployed' and player.job.duty then
                    if not W.Times[player.identifier] then
                        W.Times[player.identifier] = { hours = 0, mins = 0 }
                    end
                    
                    W.Times[player.identifier].hours = W.Times[player.identifier].hours + 1
                    -- W.Times[player.identifier].mins = W.Times[player.identifier].mins + 1

                    -- if W.Times[player.identifier].mins >= 60 then
                    --     W.Times[player.identifier].mins = 0
                    --     W.Times[player.identifier].hours = W.Times[player.identifier].hours + 1
                    -- end
                end
            end
        end
    end
end

W.ResetPaycheckCount = function(identifier)
    if(not idenifier)then
        return W.Print("ERROR", "Identifier no valid")
    end
    if(not W.Times[identifier])then
        return
    end
    W.Times[identifier].mins = 0
    W.Times[identifier].hours = 0
end

exports("ResetPaycheckCount", function(identifier)
    W.ResetPaycheckCount(identifier or false)
end)

W.GetPaycheck = function ()
    return W.Times
end

W.SavePaycheck = function ()
    SaveResourceFile(GetCurrentResourceName(), "./Server/Modules/paycheck.json", json.encode(W.Times, { indent = true }), -1)
end

CreateThread(function()
    while true do        
        W.SavePaycheck()
        
        Wait(2 * 60 * 1000)
    end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 60 then
        CreateThread(function()
            Wait(45000)

            W.SavePaycheck()
        end)
    end
end)