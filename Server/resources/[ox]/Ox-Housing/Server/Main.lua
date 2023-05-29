Houses = {}
insideMembers = {}

MySQL.ready(function()
    Wait(2100)
    exports.oxmysql:execute('SELECT * FROM housing', {}, function(v)
        for k, v in pairs(v) do
            if #json.decode(v.owners) == 0 then
                local info = json.decode(v.info)
                Houses[v.id] = CreateHouse(nil, v.id, info.price, json.decode(v.locations), info.bought, json.decode(v.furniture), tonumber(0), info.shell, {}, {}, v.gang, v.key_code or false)
            end
            for key, val in pairs(json.decode(v.owners)) do
                local info = json.decode(v.info)
                Houses[v.id] = CreateHouse(val.owner, v.id, info.price, json.decode(v.locations), info.bought, json.decode(v.furniture), tonumber(v.blackmoney), info.shell, json.decode(v.owners), json.decode(v.paints), v.gang or false, v.key_code or false)
            end
        end
        TriggerClientEvent("Ox-Housing:client:refreshHouses", -1, Houses)
        -- TriggerEvent('ZC-Garage:loadHouses', Houses)
	end)
end)

W.CreateCallback('Ox-Housing:getData', function(source, cb)
    cb(Houses)
end)

RegisterNetEvent('housing:loaded', function()
    local src = source

    if not src then
        return
    end

    TriggerClientEvent('Ox-Housing:client:playerLoaded', src, Houses)
end)

local playersentering = {}

W.CreateCallback('Ox-Housing:getPeopleOut', function(source, cb, id)
    if playersentering[id] == nil then
        playersentering[id] = {}
        playersentering[id]['players'] = {}
    end
    if id and playersentering[id] and playersentering[id]['players'] and #playersentering[id]['players'] > 0 then
        cb(playersentering[id]['players'])
    else
        cb(nil)
    end
end)

RegisterServerEvent("Ox-Housing:server:attemptToAccess")
AddEventHandler("Ox-Housing:server:attemptToAccess", function(id)
    local _src = source
    TriggerEvent('InteractSound_SV:PlayOnOne', _src, 'timbre', 0.5)

    for k, v in pairs(insideMembers) do
        if v.id == id then
            TriggerEvent('InteractSound_SV:PlayOnOne', v.plyid, 'timbre', 0.5)
        end
    end

    local found = false
    while not playersentering[id] do Wait(100) end
    for k,v in pairs(playersentering[id]['players']) do
        if v.source == _src then
            found = true
        end
    end

    if not found then
        local name = GetCharacterName(_src)

        if name ~= 'ERROR' then
            table.insert(playersentering[id]['players'], {source = _src, name = name})
        end
    end
end)

RegisterServerEvent("Ox-Housing:server:letIn")
AddEventHandler("Ox-Housing:server:letIn", function(id, data, coordsShell, secCoords, idHouse)
    for k,v in pairs(playersentering[idHouse]['players']) do
        if v.source == id then
            table.remove(playersentering[idHouse]['players'], k)
        end
    end

    TriggerClientEvent("Ox-Housing:client:letIn", tonumber(id), data, coordsShell, secCoords, idHouse)
end)

RegisterServerEvent("Ox-Housing:server:lights")
AddEventHandler("Ox-Housing:server:lights", function(id, light)
    local _src = source
    for k, v in pairs(insideMembers) do
        if v.id == id and v.plyid ~= _src then
            TriggerClientEvent("Ox-Housing:client:lights", tonumber(v.plyid), light)
        end
    end
end)

RegisterServerEvent("Ox-Housing:enterHouse", function(id)
    local _src = source
    table.insert(insideMembers, {id = id, plyid = _src})
    TriggerEvent('InteractSound_SV:PlayOnOne', _src, 'abrir', 0.6)
    if playersentering[id] == nil then
        playersentering[id] = {}
        playersentering[id]['players'] = {}
    end
end)

RegisterServerEvent("Ox-Housing:server:goOut")
AddEventHandler("Ox-Housing:server:goOut", function(id)
    local _src = source
    for k,v in pairs(insideMembers) do
        if v.id == id then
            if v.plyid == _src then
                table.remove(insideMembers, k)
            end
        end
    end
    TriggerEvent('InteractSound_SV:PlayOnOne', _src, 'cerrar', 0.6)
    playersentering[id] = nil
end)

RegisterServerEvent("Ox-Housing:server:syncToPlayersInside")
AddEventHandler("Ox-Housing:server:syncToPlayersInside", function(type, ftxd, ftxn, url, id)
    local _src = source
    for k, v in pairs(insideMembers) do
        if v.id == id then
            if v.plyid ~= _src then
                log("Sync type")
                TriggerClientEvent("Ox-Housing:client:syncType", v.plyid, type, ftxd, ftxn, url, id)
            end
        end
    end
end)

function GetCharacterName(source)
    local player = W.GetPlayer(source)

    if not player then
        return 'ERROR'
    end

	return player.identity.name.." ".. player.identity.lastname
end

RegisterServerEvent("Ox-Housing:deleteHouse", function(id)
    local _src = source
    local xPlayer = W.GetPlayer(_src)
    Houses[id] = nil
    xPlayer.Notify("CASA",'Casa borrada', 'verify')
    TriggerClientEvent("Ox-Housing:client:modHouse", -1, Houses[id], id)
    TriggerClientEvent("Ox-Housing:client:refreshHouses", _src, Houses)
    exports.oxmysql:execute('DELETE FROM housing WHERE id = @id', {
        ['@id'] = id
    })

    exports.oxmysql:execute('UPDATE players SET have_house = ? WHERE have_house = ?', { 0, id })
end)

RegisterServerEvent("Ox-Housing:modifyHouse", function(id, price)
    local _src = source
    local xPlayer = W.GetPlayer(_src)
    Houses[id].price = price
    local newInfo = {
        bought = Houses[id].bought,
        price = Houses[id].price,
        shell = Houses[id].shell
    }
    xPlayer.Notify("CASA",'Casa modificada', 'verify')
    TriggerClientEvent("Ox-Housing:client:modHouse", -1, Houses[id], id)
    TriggerClientEvent("Ox-Housing:client:refreshHouses", _src, Houses)
    MySQL.Async.execute("UPDATE housing SET `info` = @info WHERE `id` = @id", {
        ['@info'] = json.encode(newInfo),
        ['@id'] = id,
    })
end)

AddEventHandler("ZCore:playerDisconnected", function(src, player)
    if(player)then
        for k, v in pairs(insideMembers) do
            if(v.plyid == src)then
                if(Houses[v.id])then
                    for k, v in pairs(Houses[v.id].points) do
                        if(v.type == "entrada")then
                            TriggerEvent("core:server:updateCacheInfo", player.identifier, "coords", json.encode({x = v.coords.x, y = v.coords.y, z = v.coords.z, heading = 0.0}))
                            table.remove(insideMembers, k)
                            return
                        end
                    end
                end
            end
        end
    end
end)