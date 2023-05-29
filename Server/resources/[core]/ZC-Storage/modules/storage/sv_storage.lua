StorageModule = setmetatable({ }, StorageModule)
StorageModule._data = {
    storages = {},
    await = promise.new()
}
StorageModule.__index = StorageModule

--webhookUrl = 'https://discord.com/api/webhooks/1099092480227557536/hR5nznDI31Ivor6G0iaL2JZLnoXXeFL1bkYC3069GaNAHBXygczMnGmXemESifQcQPi4'
logschr7 = function(webhookUrl, message)
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 
    'POST', json.encode(
        {username = "SpainCity Logs", 
        embeds = {
            {["color"] = 16711680, 
            ["author"] = {
            ["name"] = "LOGS ARMARIO",
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"},
            ["description"] = "".. message .."",
            ["footer"] = {
            ["text"] = "SpainCityRP - "..os.date("%x %X %p"),
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png",},}
        }, avatar_url = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"}), {['Content-Type'] = 'application/json' })
end

---Storage module functions
function StorageModule:Create(storage, weight)
    storage = tostring(storage)

    if StorageModule._data.storages[storage] then
        return StorageModule._data.storages[storage]
    end

    exports.oxmysql:execute('INSERT INTO `storage` (name, data, weight, maxWeight, blackmoney) VALUES (?, ?, ?, ?, ?)', { tostring(storage), json.encode({}), 0, tonumber(weight), 0 }, function(rows)
        Wave.Print('INFO', 'Inventory '..storage..' has been created')
    end)

    StorageModule._data.storages[storage] = StorageClass:Create(storage, {}, 0, weight, 0, true)

    if StorageModule._data.storages[storage] then
        return StorageModule._data.storages[storage]
    end
end

---Storage module events
RegisterNetEvent('storage:get', function(callback, storage, weight)
    local src <const> = source
    Citizen.Await(StorageModule._data.await)

    if not StorageModule._data.storages[storage] then
        if not weight then
            weight = STORAGE_DATA.defaultWeight
        end

        local newStorage = StorageModule:Create(storage, weight)

        if newStorage then
            return callback(newStorage)
        end

        return callback(nil, nil)
    end

    return callback(StorageModule._data.storages[storage])
end)

---Storage module blackmoney events
RegisterNetEvent('storage:withdrawMoney', function(storage)
    local src <const> = source
    local player <const> = Wave.GetPlayer(src)
    local items = Wave.GetItems()
    Citizen.Await(StorageModule._data.await)

    if not StorageModule._data.storages[storage.name] then
        if not storage.weight then
            storage.weight = STORAGE_DATA.defaultWeight
        end

        StorageModule:Create(storage.name, storage.weight)
        player.Notify('Almacenamiento', 'Has creado el almacenamiento, vuelve a abrir el menú para poder usarlo.', 'verify')
    end

    if StorageModule._data.storages[storage.name] then
        local data = StorageModule._data.storages[storage.name]

        if not data then
            return
        end

        if data:Money().remove(storage.amount) then
            player.addMoney('blackmoney', storage.amount)

            Wave.SendToDiscord('storage', 'Retiro', 'x'..storage.amount..' de Dinero Negro del almacenamiento '..storage.name, player.src)
            player.Notify('Almacenamiento', 'Has ~g~retirado~y~ x'..storage.amount..'~w~ de ~y~Dinero Negro~w~.', 'verify')
        else
            return player.Notify('Almacenamiento', 'No hay dinero negro suficiente.', 'error')
        end

        return
    end

    return
end)

RegisterNetEvent('storage:storeMoney', function(storage)
    local src <const> = source
    local player <const> = Wave.GetPlayer(src)
    local items = Wave.GetItems()
    Citizen.Await(StorageModule._data.await)

    if not StorageModule._data.storages[storage.name] then
        if not storage.weight then
            storage.weight = STORAGE_DATA.defaultWeight
        end

        StorageModule:Create(storage.name, storage.weight)
        player.Notify('Almacenamiento', 'Has creado el almacenamiento, vuelve a abrir el menú para poder usarlo.', 'verify')
    end

    if StorageModule._data.storages[storage.name] then
        local data = StorageModule._data.storages[storage.name]

        if not data then
            return
        end

        if player.getMoney('blackmoney') >= storage.amount then
            player.removeMoney('blackmoney', storage.amount)

            if data:Money().add(storage.amount) then
                Wave.SendToDiscord('storage', 'Deposito', 'x'..storage.amount..' de Dinero Negro en el almacenamiento '..storage.name, src)
                player.Notify('Almacenamiento', 'Has ~g~depositado~y~ x'..storage.amount..'~w~ de ~y~Dinero Negro~w~.', 'verify')
            end
        else
            player.Notify('Almacenamiento', 'No tienes suficiente dinero negro.', 'error')

            return
        end

        return
    end

    return
end)

---Storage module callbacks
Wave.CreateCallback('storage:get', function(source, callback, storage, weight)
    local src <const> = source
    Citizen.Await(StorageModule._data.await)

    if not StorageModule._data.storages[storage] then
        if not weight then
            weight = STORAGE_DATA.defaultWeight
        end

        local newStorage = StorageModule:Create(storage, weight)

        if newStorage then
            return callback(newStorage.inventory, newStorage.weight, newStorage.blackmoney)
        end

        return callback(nil, nil)
    end

    return callback(StorageModule._data.storages[storage].inventory, StorageModule._data.storages[storage].weight, StorageModule._data.storages[storage].blackmoney)
end)

RegisterNetEvent('storage:delete', function(storageName)
    if not StorageModule._data.storages[storageName] then
        return Wave.Print("ERROR", "Almacén no existe: " .. storageName or "NULL")
    end
    StorageModule._data.storages[storageName].delete()
    StorageModule._data.storages[storageName] = nil
    GlobalState[storageName] = nil
end)

---Storage module items events
RegisterNetEvent('storage:withdraw', function(storage) --{ name = storageName, data = data2, amount = 1, house = house or nil}
    local src <const> = source
    local player <const> = Wave.GetPlayer(src)
    local items = Wave.GetItems()
    Citizen.Await(StorageModule._data.await)

    if not StorageModule._data.storages[storage.name] then
        if not storage.weight then
            storage.weight = STORAGE_DATA.defaultWeight
        end

        StorageModule:Create(storage.name, storage.weight)
        player.Notify('Almacenamiento', 'Has creado el almacenamiento, vuelve a abrir el menú para poder usarlo.', 'verify')
    end

    if StorageModule._data.storages[storage.name] then
        local data = StorageModule._data.storages[storage.name]

        if not data then
            return
        end

        if not player.canCarryItem(storage.data.name, storage.amount) then
            return player.Notify('Almacenamiento', 'No puedes llevar tanta cantidad de este objeto', 'error')
        end
        
        if data:Inventory().remove(storage.data.name, storage.amount, storage.data.slotId, player, storage.house) and player.addItemToInventory(storage.data.name, storage.amount, storage.data.metadata) then

            if storage.name == "police" or storage.name =="police-boss-storage" then
            logschr7("https://discord.com/api/webhooks/1099833466012582001/kzvbJv37q9F5YoyZWa6Ud6SUZ2W3bBOv3OY5Ivy6N1lIRlSYqBVv_N1hOJdTs0U4BtXP", '\n**Retiro:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            elseif storage.name == "ambulance" or storage.name =="ambulance-boss-storage" then
            logschr7("https://discord.com/api/webhooks/1083194737328136315/KPbDt8FdGSGCryUgK7E440Qk_n1dcVVkx8K0Tmb7nfK7Elf_d27NAO_5QQHWOCezPUv8", '\n**Retiro:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            elseif storage.name == "baduvanilla" or storage.name =="baduvanilla-boss-storage" then
            logschr7("https://discord.com/api/webhooks/1099092480227557536/hR5nznDI31Ivor6G0iaL2JZLnoXXeFL1bkYC3069GaNAHBXygczMnGmXemESifQcQPi4", '\n**Retiro:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            elseif storage.name == "terrazacasino" or storage.name == "terrazacasino-boss-storage" then 
            logschr7("https://discord.com/api/webhooks/1102348935160410132/Wlk3psEKJysxQhSyizPZRW_fV4zswv0P2Nj0maZtKHzQ5gxMf_szg-tE_yV_QvQVpzyr", '\n**Retiro:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            elseif storage.name == "pizza" or storage.name == "pizza-boss-storage" then 
            logschr7("https://discord.com/api/webhooks/1102724972121702430/VR4Su2_QLceBv_UXNh5FadOyzryibC870FLFVLxurk8kwQB_wkp2mVFZGS3_U-nnQnUC", '\n**Retiro:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            end

            Wave.SendToDiscord('storage', 'Retiro', 'x'..storage.amount..' '..items[storage.data.name].label..' del almacenamiento '..storage.name, player.src)
            player.Notify('Almacenamiento', 'Has ~g~retirado~y~ x'..storage.amount..'~w~ - ~y~'..items[storage.data.name].label..'~w~.', 'verify')
        end

        return
    end

    return
end)

RegisterNetEvent('storage:store', function(storage) --{ name = room['roomId'], data = data2, amount = amount, house = house or nil }
    local src <const> = source
    local player <const> = Wave.GetPlayer(src)
    local items = Wave.GetItems()
    Citizen.Await(StorageModule._data.await)

    local hasPlayerItem = false

    for k, v in pairs(player.inventory.items) do
        if(v.item == storage.data.name and v.quantity >= tonumber(storage.amount))then
            hasPlayerItem = true
            break
        end
    end
    if(not hasPlayerItem)then
        Wave.SendToDiscord("cheaters", "Dupeo detectado (storage_store)", "Jugador implicado: \n" .. player.identifier .. " (" .. player.name .. ") \nStorage: " .. storage.name .. "\n Cantidad del intento: " .. storage.amount .. " (" .. storage.data.name .. ")", player.src)
        return
    end

    if not StorageModule._data.storages[storage.name] then
        if not storage.weight then
            storage.weight = STORAGE_DATA.defaultWeight
        end

        StorageModule:Create(storage.name, storage.weight)
        player.Notify('Almacenamiento', 'Has creado el almacenamiento, vuelve a abrir el menú para poder usarlo.', 'verify')
    end

    if StorageModule._data.storages[storage.name] then
        local data = StorageModule._data.storages[storage.name]

        if not data then
            return
        end

        if data:Inventory().add(storage.data.name, storage.amount, storage.data.metadata, storage.data.slotId, player, storage.house) and player.removeItemFromInventory(storage.data.name, storage.amount, storage.data.slotId) then
            if storage.name == "police" or storage.name =="police-boss-storage" then
            logschr7("https://discord.com/api/webhooks/1099833466012582001/kzvbJv37q9F5YoyZWa6Ud6SUZ2W3bBOv3OY5Ivy6N1lIRlSYqBVv_N1hOJdTs0U4BtXP", '\n**Deposito:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            elseif storage.name == "ambulance" or storage.name =="ambulance-boss-storage" then
            logschr7("https://discord.com/api/webhooks/1083194737328136315/KPbDt8FdGSGCryUgK7E440Qk_n1dcVVkx8K0Tmb7nfK7Elf_d27NAO_5QQHWOCezPUv8", '\n**Deposito:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            elseif storage.name == "baduvanilla" or storage.name =="baduvanilla-boss-storage" then
            logschr7("https://discord.com/api/webhooks/1099092480227557536/hR5nznDI31Ivor6G0iaL2JZLnoXXeFL1bkYC3069GaNAHBXygczMnGmXemESifQcQPi4", '\n**Deposito:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            elseif storage.name == "terrazacasino" or storage.name == "terrazacasino-boss-storage" then 
            logschr7("https://discord.com/api/webhooks/1102348935160410132/Wlk3psEKJysxQhSyizPZRW_fV4zswv0P2Nj0maZtKHzQ5gxMf_szg-tE_yV_QvQVpzyr", '\n**Deposito:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            elseif storage.name == "pizza" or storage.name == "pizza-boss-storage" then 
            logschr7("https://discord.com/api/webhooks/1102724972121702430/VR4Su2_QLceBv_UXNh5FadOyzryibC870FLFVLxurk8kwQB_wkp2mVFZGS3_U-nnQnUC", '\n**Deposito:** x'..storage.amount..' '..items[storage.data.name].label..'  \n**Empleado:** '..GetPlayerName(player.src)..' ')
            end

            Wave.SendToDiscord('storage', 'Deposito', GetPlayerName(source)..' ha depositado x'..storage.amount..' '..items[storage.data.name].label..' en el almacenamiento '..storage.name, src)
            player.Notify('Almacenamiento', 'Has ~g~depositado~y~ x'..storage.amount..'~w~ - ~y~'..items[storage.data.name].label..'~w~.', 'verify')

            return
        end

        return
    end

    return
end)

---Storage module blackmoney callbacks
Wave.CreateCallback('storage:withdrawMoney', function(source, callback, storage)
    local src <const> = source
    local player <const> = Wave.GetPlayer(src)
    local items = Wave.GetItems()
    Citizen.Await(StorageModule._data.await)

    if not StorageModule._data.storages[storage.name] then
        if not storage.weight then
            storage.weight = STORAGE_DATA.defaultWeight
        end

        StorageModule:Create(storage.name, storage.weight)
        player.Notify('Almacenamiento', 'Has creado el almacenamiento, vuelve a abrir el menú para poder usarlo.', 'verify')
    end

    if StorageModule._data.storages[storage.name] then
        local data = StorageModule._data.storages[storage.name]

        if not data then
            return callback(false)
        end

        if data:Money().remove(storage.amount) then
            player.addMoney('blackmoney', storage.amount)

            Wave.SendToDiscord('storage', 'Retiro', 'x'..storage.amount..' de Dinero Negro del almacenamiento '..storage.name, player.src)
            player.Notify('Almacenamiento', 'Has ~g~retirado~y~ x'..storage.amount..'~w~ de ~y~Dinero Negro~w~.', 'verify')

            return callback(true)
        else
            player.Notify('Almacenamiento', 'No hay dinero negro suficiente.', 'error')
            return callback(false)
        end

        return callback(false)
    end

    return callback(false)
end)

Wave.CreateCallback('storage:storeMoney', function(source, callback, storage)
    local src <const> = source
    local player <const> = Wave.GetPlayer(src)
    local items = Wave.GetItems()
    Citizen.Await(StorageModule._data.await)

    if not StorageModule._data.storages[storage.name] then
        if not storage.weight then
            storage.weight = STORAGE_DATA.defaultWeight
        end

        StorageModule:Create(storage.name, storage.weight)
        player.Notify('Almacenamiento', 'Has creado el almacenamiento, vuelve a abrir el menú para poder usarlo.', 'verify')
    end

    if StorageModule._data.storages[storage.name] then
        local data = StorageModule._data.storages[storage.name]

        if not data then
            return callback(false)
        end

        if player.getMoney('blackmoney') >= storage.amount then
            player.removeMoney('blackmoney', storage.amount)

            if data:Money().add(storage.amount) then
                Wave.SendToDiscord('storage', 'Deposito', 'x'..storage.amount..' de Dinero Negro en el almacenamiento '..storage.name, src)
                player.Notify('Almacenamiento', 'Has ~g~depositado~y~ x'..storage.amount..'~w~ de ~y~Dinero Negro~w~.', 'verify')

                return callback(true)
            end
        else
            player.Notify('Almacenamiento', 'No tienes suficiente dinero negro.', 'error')

            return callback(false)
        end

        return callback(false)
    end

    return callback(false)
end)

---Storage module items callbacks
Wave.CreateCallback('storage:withdraw', function(source, callback, storage) --{ name = storageName, data = data2, amount = 1, house = house or nil}
    local src <const> = source
    local player <const> = Wave.GetPlayer(src)
    local items = Wave.GetItems()
    Citizen.Await(StorageModule._data.await)

    if not StorageModule._data.storages[storage.name] then
        if not storage.weight then
            storage.weight = STORAGE_DATA.defaultWeight
        end

        StorageModule:Create(storage.name, storage.weight)
        player.Notify('Almacenamiento', 'Has creado el almacenamiento, vuelve a abrir el menú para poder usarlo.', 'verify')
    end

    if StorageModule._data.storages[storage.name] then
        local data = StorageModule._data.storages[storage.name]

        if not data then
            return callback(false)
        end

        if data:Inventory().remove(storage.data.name, storage.amount, storage.data.slotId, player, storage.house) and player.addItemToInventory(storage.data.name, storage.amount, storage.data.metadata) then
            Wave.SendToDiscord('storage', 'Retiro', 'x'..storage.amount..' '..items[storage.data.name].label..' del almacenamiento '..storage.name, player.src)
            player.Notify('Almacenamiento', 'Has ~g~retirado~y~ x'..storage.amount..'~w~ - ~y~'..items[storage.data.name].label..'~w~.', 'verify')

            return callback(true)
        end

        return callback(false)
    end

    return callback(false)
end)

Wave.CreateCallback('storage:store', function(source, callback, storage) --{ name = room['roomId'], data = data2, amount = amount, house = house or nil }
    local src <const> = source
    local player <const> = Wave.GetPlayer(src)
    local items = Wave.GetItems()
    Citizen.Await(StorageModule._data.await)

    if not StorageModule._data.storages[storage.name] then
        if not storage.weight then
            storage.weight = STORAGE_DATA.defaultWeight
        end

        StorageModule:Create(storage.name, storage.weight)
        player.Notify('Almacenamiento', 'Has creado el almacenamiento, vuelve a abrir el menú para poder usarlo.', 'verify')
    end

    if StorageModule._data.storages[storage.name] then
        local data = StorageModule._data.storages[storage.name]

        if not data then
            return callback(false)
        end

        if data:Inventory().add(storage.data.name, storage.amount, storage.data.metadata, storage.data.slotId, player, storage.house) and player.removeItemFromInventory(storage.data.name, storage.amount, storage.data.slotId) then
            Wave.SendToDiscord('storage', 'Deposito', 'x'..storage.amount..' '..items[storage.data.name].label..' en el almacenamiento '..storage.name, src)
            player.Notify('Almacenamiento', 'Has ~g~depositado~y~ x'..storage.amount..'~w~ - ~y~'..items[storage.data.name].label..'~w~.', 'verify')

            return callback(true)
        end

        return callback(false)
    end

    return callback(false)
end)

--- Init storage module
Citizen.CreateThread(function()
    while not GetResourceState('oxmysql') == 'started' do
        Wait(100)

        print('Waiting for oxmysql starts')
    end

    exports.oxmysql:execute('SELECT * FROM storage', { }, function(storage)
        local total = 0

        for _, value in next, storage do
            if string.len(value.name) >= 1 then
                StorageModule._data.storages[value.name] = StorageClass:Create(value.name, json.decode(value.data), value.weight, value.maxWeight, value.blackmoney)
                total = total + 1
            end
        end
        GlobalState = StorageModule._data.storages

        --Wave.Print('INFO', 'Total of '..total..' storages has been loaded from database')
        StorageModule._data.await:resolve()
    end)

    Citizen.Await(StorageModule._data.await)
    while true do
        for _, value in pairs(StorageModule._data.storages) do
            if value.update then
                value:SQL().save()
                Wave.Print('INFO', 'Saving all storages')
            end
        end

        --Wave.Print('INFO', 'Saving all storages that needs to update to SQL')

        Citizen.Wait(5 * 60 * 1000)
    end
end)