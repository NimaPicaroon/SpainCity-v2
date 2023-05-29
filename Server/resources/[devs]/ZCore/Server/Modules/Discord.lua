W.SendToDiscord = function(type, title, message, srcForced)
    local webhookUrl = W.GetWebhook(type)
    local player = W.GetPlayer(source)
    if(not webhookUrl)then
        return W.Print("ERROR", "Log: " .. title .. ", error en webhook.")
    end
    if(not player and srcForced)then
        player = W.GetPlayer(srcForced)
    end
    if(not player)then
        return W.Print("ERROR", "Log: " .. title .. ", player no detectado")
    end
    local date = os.date('*t')
    local embed = {
        {
            ["color"] = 337071,
            ["title"] = "**" .. title .. "**",
            ["fields"] = {},
            ["footer"] = {
                ["text"] = 'Fecha ' .. date.day .. '/' .. date.month .. '/' .. date.year .. ' | ' .. date.hour .. ':' .. date.min ..  ' minutos con ' .. date.sec .. " segundos",
                ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png",
            },
        },
    }
    if(message and message ~= "ZCore")then
        embed[1]["description"] = message
    end
    table.insert(embed[1]["fields"], {name = "Usuario", value = player.name.." /  ID: "..player.src.."\n"..player.discord.."\n"..player.identifier.."\n**Nombre IC: **"..player.identity.name.." "..player.identity.lastname or "No encontrado", inline = false})
    --table.insert(embed[1]["fields"], {name = "Discord ID", value = player.discord or "No encontrado", inline = false})
    --table.insert(embed[1]["fields"], {name = "Licencia Rockstar", value = player.identifier.."\n\n**Nombre IC**\n"..player.identity.name.." "..player.identity.lastname or "No encontrado", inline = false})
    table.insert(embed[1]["fields"], {name = "Dinero en Efectivo / Banco / Coins", value = player.money["money"].." / "..player.money["bank"].." / "..player.money["coins"] or "No encontrado", inline = false})
    table.insert(embed[1]["fields"], {name = "Trabajo", value = player.job.label.. " | ".. player.job.ranklabel or "No encontrado", inline = true})
    if(player.gang and player.gang.name)then
        table.insert(embed[1]["fields"], {name = "Banda", value = player.gang.label.." | "..player.gang.ranklabel or "No encontrado", inline = true})
    end
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({username = "Logs SpainCityRP", embeds = embed, avatar_url = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"}), { ['Content-Type'] = 'application/json' })
end

W.GetWebhook = function(webhook)
    if(W.Logs[webhook])then
        return W.Logs[webhook]
    elseif(string.find(webhook, ".com/api/webhooks/"))then
        return webhook
    else
        return false
    end
end