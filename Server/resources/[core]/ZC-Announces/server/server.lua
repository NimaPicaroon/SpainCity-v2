local announces = {}

function refresh()
    MySQL.Async.fetchAll("SELECT * FROM announces", {}, function(result)
        announces = {}
        for i = 1,#result, 1 do
            table.insert(announces, {job = result[i]['job'], pic = result[i]['pic'], picBack = result[i]['picBack'], color = result[i]['color'], name = result[i]['name'], colorbar = result[i]['colorbar'], titlecolor = result[i]['titlecolor']})
        end
    end)
end

RegisterServerEvent("guille_anu:server:create")
AddEventHandler("guille_anu:server:create", function(job, pic, picBack, color, name, colorbar, titlecolor)
    local xPlayer = W.GetPlayer(source)
    if W.Groups[xPlayer.group] > 0 then
        MySQL.Async.execute('INSERT INTO announces (job, pic, picBack, color, name, colorbar, titlecolor) VALUES (@job, @pic, @picBack, @color, @name, @colorbar, @titlecolor)', {
            ['@job'] = job,
            ['@pic'] = pic,
            ['@picBack'] = picBack,
            ['@color'] = color,
            ['@name'] = name,
            ['@colorbar'] = colorbar,
            ['@titlecolor'] = titlecolor,
        })
    end
    xPlayer.Notify('ANUNCIO', 'Creando anuncio...')
    Wait(3000)
    table.insert(announces, {job = job, pic = pic, picBack = picBack, color = color, name = name, colorbar = colorbar, titlecolor = titlecolor})
    xPlayer.Notify('ANUNCIO', 'Anuncio creado ~g~correctamente', 'verify')
end)

RegisterCommand(Config['deletecommand'], function(source, args)
    local xPlayer = W.GetPlayer(source)
    local announce = false

    if W.Groups[xPlayer.group] > 1 then
        local job = args[1]
        for i = 1, #announces, 1 do
            if announces[i]['job'] == job then
                announce = true
                MySQL.Async.execute('DELETE FROM announces WHERE job=@job ', {
                    ['@job'] = job,
                })
                xPlayer.Notify('ANUNCIO', 'Borrando anuncio...')
                Wait(3000)
                table.remove(announces, i)
                xPlayer.Notify('ANUNCIO', 'Anuncio ~r~borrado', 'verify')
                break
            end
        end
        if not announce then
            xPlayer.Notify('ANUNCIO', 'No hay anuncion para este trabajo', 'error')
        end
    end
end)

W.CreateCallback("guille_anu:getAnounce", function(source, cb)
    local player = W.GetPlayer(source)
    local announce = false
    for i = 1, #announces, 1 do
        if announces[i]['job'] == player.job.name and player.job.duty then
            announce = true
            cb(announces[i])
            break
        end
    end
    if not announce then
        player.Notify('ERROR', 'No hay anuncios disponibles', 'error')
    end
end)

RegisterServerEvent("guille_anu:server:sendAnu")
AddEventHandler("guille_anu:server:sendAnu", function(pic, picBack, color, name, content, colorbar, titlecolor)
    TriggerClientEvent("guille_an:server:syncAnounce", -1, pic, picBack, color, name, content, colorbar, titlecolor)
    W.SendToDiscord("jobs_manager", "ANUNCIO", content, source)
end)

MySQL.ready(function()
    print("^4[guille_announcecreator]^0 Refreshing announces")
    refresh()
end)