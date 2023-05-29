W = exports.ZCore:get()

-- Events

RegisterNetEvent('MultiCharacters:server:disconnect', function()
    local src = source
    DropPlayer(src, "You have disconnected from QBCore")
end)

RegisterNetEvent('MultiCharacters:server:loadUserData', function()
    local src = source

    if W.Connection.LoadPlayer(src) then
        TriggerEvent('Garages:load', src)
    end
end)

RegisterNetEvent('MultiCharacters:client:chooseChar', function()
    local src = source

    print('Loading multicharacter')
    TriggerClientEvent('MultiCharacters:client:chooseChar', src)
end)

RegisterNetEvent('MultiCharacters:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.charinfo = data

    W.Connection.LoadPlayer(src, newData)
end)

-- Callbacks

W.CreateCallback("MultiCharacters:server:setupCharacters", function(source, cb)
    local license = W.GetIdentifier(source)
    local plyChars = {}
    
    MySQL.Async.fetchAll('SELECT * FROM `players` WHERE `token` = ?', {license}, function(result)
        for i = 1, (#result), 1 do
            result[i].identity = json.decode(result[i].identity)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            plyChars[#plyChars+1] = result[i]
        end
        cb(plyChars)
    end)
end)

W.CreateCallback("MultiCharacters:server:getSkin", function(source, cb, cid)
    local src = source
    local license = W.GetIdentifier(source)
    local result = MySQL.query.await('SELECT * FROM `players` WHERE `token` = ?', {license})
    if result[1] ~= nil then
        cb(json.decode(result[1].skin), result[1].ped)
    else
        cb(nil)
    end
end)
