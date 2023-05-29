local DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/"
function ExtractIdentifiers()
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
            TriggerEvent("log", identifierDiscord)
        end
    end
end
    

RegisterServerEvent('log')
AddEventHandler('log', function(data)

    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
          identifier = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
          license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
          xbl  = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
          playerip = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
          playerdiscord = v
          str = string.sub(v, 9)
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
          liveid = v
        end
      end
    
      if playerip == nil then
        playerip = GetPlayerEndpoint(target)
        if playerip == nil then
          playerip = 'No encontrada'
        end
      end
      if playerdiscord == nil then
        playerdiscord = 'No encontrado'
      end
      if str == nil then
        str = "No encontrado"
      end
      if liveid == nil then
        liveid = 'No encontrado'
      end
      if xbl == nil then
        xbl = 'No encontrado'
      end

    local connect = {
        {
            ["color"] = "255",
            ["title"] = "Nueva Denuncia | " ..data.ft.."-"..data.ln,
            ["description"] = "Nombre: \n `"..data.ft.."` \n Apellido: \n `"..data.ln.."`\n Razon: \n `"..data.reason.."`".."\n Fecha: \n `"..data.date.."`".."\n Discord:\n".."<@"..str..">",
	        ["footer"] = {
                ["text"] = "Denuncia",
            },
            image = {
                url = data.myImg
            },
        }
    }
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = "Ordenador CNP",  avatar_url = "https://media.discordapp.net/attachments/831490177104478208/1096498522628563004/oposicion-policia-nacional-2021-santander.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)


