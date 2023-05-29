local accounts = {}

RegisterNetEvent('Ox-Banking:loadPersonalAccount', function()
    local player = W.GetPlayer(source)
    exports.oxmysql:execute("SELECT * FROM `accounts` WHERE owner = ?", {player.identifier}, function(result)
        for k, v in pairs(result) do
            accounts[player.identifier] = {credit = v.credit, owner = v.owner, pin = v.pin, amount = v.amount}
        end
        GlobalState.Accounts = accounts
    end)
end)

exports('getPlayerAccount', function(identifier)
    return accounts[identifier]
end)

exports('deleteAccount', function(identifier)
    accounts[identifier] = nil

    GlobalState.Accounts = accounts
end)

RegisterNetEvent('Ox-Banking:deposit', function(amount)
    local src = source
    local player = W.GetPlayer(src)

    if player.getMoney('money') < amount then
        return player.Notify('Banco', 'No tienes dinero suficiente', 'error')
    end

    player.removeMoney('money', amount)
    player.addMoney('bank', amount)
    player.Notify('BANCO', 'Has depositado ~g~'..amount..'$~w~ a tu cuenta', 'verify')
    W.SendToDiscord('bank', "DEPÓSITO", '$'..amount..' en su cuenta', src)
end)

RegisterNetEvent('Ox-Banking:withdraw', function(amount)
    local src = source
    local player = W.GetPlayer(src)

    if player.getMoney('bank') < amount then
        return player.Notify('Banco', 'No tienes dinero suficiente', 'error')
    end

    player.removeMoney('bank', amount)
    player.addMoney('money', amount)
    player.Notify('BANCO', 'Has retirado ~g~'..amount..'$~w~ de tu cuenta', 'verify')
    W.SendToDiscord('bank', "RETIRO", '$'..amount..' de su cuenta', src)
end)

RegisterNetEvent('Ox-Banking:transfer', function(iban, amount)
    local src = source
    local player = W.GetPlayer(src)
    local foundIban = false
    local target

    if player.getMoney('bank') < amount then
        return player.Notify('Banco', 'No tienes dinero suficiente', 'error')
    end

    for k,v in pairs(accounts) do
        if v.credit == iban then
            foundIban = true
            target = W.GetPlayerByIdentifier(v.owner)
            if target then
                player.removeMoney('bank', amount)
                target.addMoney('bank', amount)
                player.Notify('BANCO', 'Has transerido ~g~'..amount..'$~w~ a la cuenta ~y~'..iban, 'verify')
                target.Notify('BANCO', 'Has recibido unaa transferencia de ~g~'..amount..'$~w~ de la cuenta ~y~'..accounts[player.identifier].credit, 'verify')
                W.SendToDiscord('bank', "TRANSFERENCIA", '**'..GetPlayerName(src)..'** transferió '..amount..'€ a '..GetPlayerName(target.src), src)
            else
                player.Notify('BANCO', 'No se puede realizar la transferencia ahora mismo', 'error')
            end
        end
    end

    if not foundIban then
        player.Notify('BANCO', 'IBAN ~r~incorrecto', 'error')
    end
end)

RegisterNetEvent('Ox-Banking:changePin', function(pin)
    local src = source
    local player = W.GetPlayer(src)

    MySQL.Async.fetchAll("UPDATE `accounts` SET `pin` = @pin WHERE `owner` = @owner", {
        ['@pin'] = pin,
        ['@owner'] = player.identifier
    }, function()
        accounts[player.identifier].pin = pin
        GlobalState.Accounts = accounts
        player.Notify('BANCO', 'PIN cambiado ~g~correctamente', 'verify')
    end)
end)

W.CreateCallback('Ox-Banking:getPlayerPin', function(source, callback, identifier)
    if(accounts[identifier])then
        if(accounts[identifier].pin)then
            callback(accounts[identifier].pin)
        else
            callback(false, "no_pin")
        end
    else
        callback(false, "no_account")
    end
end)

exports("GetPlayerPin", function(identifier)
    if(accounts[identifier])then
        if(accounts[identifier].pin)then
            return accounts[identifier].pin
        else
            return false, "no_pin"
        end
    end
    return false, "script_not_answering"
end)

RegisterNetEvent('Ox-Banking:createPin', function(pin)
    local src = source
    local player = W.GetPlayer(src)

    exports.oxmysql:execute("UPDATE `accounts` SET pin = ? WHERE `owner` = ?", {
        tonumber(pin),
        player.identifier
    }, function()
        accounts[player.identifier].pin = tonumber(pin)
        GlobalState.Accounts = accounts
        player.Notify('BANCO', 'PIN creado ~g~correctamente', 'verify')
    end)
end)

RegisterNetEvent('Ox-Banking:createAccount', function()
    local src = source
    local player = W.GetPlayer(src)

    print('hola')
    if not accounts[player.identifier] then
        local credit = tostring('WV '.. math.random(1000, 9999) ..' '.. math.random(1000, 9999) ..' '.. math.random(1000, 9999))

        MySQL.Async.fetchAll("INSERT INTO `accounts` (`owner`, `pin`, `credit`) VALUES (@owner, @pin, @credit)", {
            ['@credit'] = credit,
            ['@pin'] = 0000,
            ['@owner'] = player.identifier
        }, function()
            accounts[player.identifier] = {credit = credit, owner = player.identifier, pin = 0000}
            GlobalState.Accounts = accounts
            local slotId = W.SlotId()
            player.addItemToInventory('creditcard', 1, {number=credit}, slotId)
            player.Notify('BANCO', 'Cuenta creada ~g~correctamente', 'verify')
        end)
    else
        player.Notify('BANCO', 'Ya tienes una ~y~cuenta', 'error')
    end
end)

hasAccount = function(identifier)
    if accounts[identifier] then
        return true
    else
        return false
    end
end

exports('hasAccount', hasAccount)

RegisterNetEvent('Ox-Banking:newCredit', function()
    local src = source
    local player = W.GetPlayer(src)

    if player.money.bank > 50 then
        if hasAccount() then
            if player.canHoldItem('creditcard', 1) then
                player.removeMoney('bank', 50)
                player.addItemToInventory('creditcard', 1, {number=accounts[player.identifier].credit})
                player.Notify('BANCO', 'Has conseguido una ~y~tarjeta extra~w~ por ~g~50$', 'verify')
            end
        else
            player.Notify('BANCO', 'Create una ~y~cuenta', 'error')
        end
    else
        player.Notify('BANCO', 'No tienes dinero en la cuenta', 'error')
    end
end)

RegisterNetEvent('Ox-Banking:newCreditBank', function()
    local src = source
    local player = W.GetPlayer(src)

    if not accounts[player.identifier] then
        player.Notify('BANCO', 'Tienes que crearte una cuenta antes', 'error')
        
        return
    end

    if player.money.bank > 200 then
        if player.canHoldItem('creditcard', 1) then
            player.removeMoney('bank', 200)
            player.addItemToInventory('creditcard', 1, {number=accounts[player.identifier].credit})
            player.Notify('BANCO', 'Toma tu ~y~tarjeta~w~, retiraremos ~g~200$~w~ de tu cuenta', 'verify')
        end
    else
        player.Notify('BANCO', '~r~No~w~ tienes suficiente dinero en tu cuenta', 'error')
    end
end)