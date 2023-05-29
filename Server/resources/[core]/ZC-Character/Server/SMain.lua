RegisterNetEvent('ZC-Character:loadPlayer', function(fixpj)
    local src = source
    local player = W.GetPlayer(src)

    if not player then
        return
    end

    TriggerClientEvent("ZC-Character:loadSkin", src, player.skin, false, player.fade, player.ped, true, fixpj)
end)

RegisterNetEvent("ZC-Character:saveSkin", function(skin, fade)
    local src = source
    local player = W.GetPlayer(src)

    player.updateSkin(skin)
    if fade and #fade > 0 then
        player.updateFade(fade)
        TriggerClientEvent('ZC-Character:updateSkin', src, skin)
    end
end)

W.RegisterCommand('skin', 'mod', function(playerSrc, playerArgs, player)
    if not playerArgs[1] then
        TriggerClientEvent("ZC-Character:openMenu", playerSrc)
    elseif tonumber(playerArgs[1]) then
        TriggerClientEvent("ZC-Character:openMenu", tonumber(playerArgs[1]))
    else
        player.Notify('ERROR', 'Algo has hecho mal', 'error')
    end
end, {{ name = 'id', help = 'ID' }}, 'Comando para cambiarse el PJ')

local outfits = {}

RegisterNetEvent("ZC-Character:saveOutfit", function (skin, name)
    local src = source
    local player = W.GetPlayer(src)

    MySQL.Async.execute("INSERT INTO `outfits` (`identifier`, `name`, `skin`) VALUES (@identifier, @name, @skin)", {
        ['@identifier']      = player.identifier,
        ['@name']       = name,
        ['@skin']    = json.encode(skin)
    })

    if not outfits[player.identifier] then
        outfits[player.identifier] = {}
    end
    table.insert(outfits[player.identifier], {name=name,  skin=skin})
end)

W.Thread(function()
    MySQL.ready(function ()
        MySQL.Async.fetchAll("SELECT * FROM outfits", {}, function(result)
            for k, v in pairs(result) do
                if not outfits[v.identifier] then
                    outfits[v.identifier] = {}
                end
                table.insert(outfits[v.identifier], {name=v.name,  skin=json.decode(v.skin)})
            end
        end)
    end)
end)

W.CreateCallback("ZC-Character:getOutfits", function(source, cb)
    local player = W.GetPlayer(source)

    if outfits[player.identifier] then
        cb(outfits[player.identifier])
    else
        cb({})
    end
end)

W.CreateCallback("ZC-Character:deleteOutfit", function(source, cb, data)
    local src = source
    local player = W.GetPlayer(source)
    local deleted = false

    if not data then
        return cb(false)
    end

    if outfits[player.identifier] then
        for key, value in pairs(outfits[player.identifier]) do
            if value.name == data.name then
                deleted = true
                table.remove(outfits[player.identifier], key)
            end
        end

        if deleted then
            exports.oxmysql:execute('DELETE FROM outfits WHERE `name` = ? AND `identifier` = ?', {
                data.name,
                player.identifier
            }, function()
                return cb(true)
            end)
        end

        return cb(false)
    else
        return cb({})
    end
end)

W.CreateCallback("ZC-Character:getSkin", function(source, cb)
    local player = W.GetPlayer(source)

    if player and player.skin then
        return cb(player.skin)
    end
end)