W.CreateCallback('Menupersonal:getHours', function(source, callback)
    local player = W.GetPlayer(src)

    if not player then
        return callback(0, 0)
    end

    local hours, minutes = exports.ZCore:getTime(player.identifier)

    return callback(hours, minutes)
end)

RegisterNetEvent("ZC-Menupersonal:open", function (mugshot, src, target, type)
    local player = W.GetPlayer(src)

    local data = {
        name = player.identity.name..'  '..player.identity.lastname,
        birth = player.identity.birthdate,
        gender = player.identity.gender,
        nation = player.identity.nacionality,
        mugshot  = mugshot,
        type = type
    }
    if type == 'driver' then
        if target then
            local targetPlayer = W.GetPlayer(target)
            TriggerClientEvent('ZC-Menupersonal:show', targetPlayer.src, data)
        else
            TriggerClientEvent('ZC-Menupersonal:show', player.src, data)
        end
    else
        if target then
            local targetPlayer = W.GetPlayer(target)
            TriggerClientEvent('ZC-Menupersonal:show', targetPlayer.src, data)
        else
            TriggerClientEvent('ZC-Menupersonal:show', player.src, data)
        end
    end
end)

ConnectedPlayers = {}

VIPS = {
    [1] = { label = "Basico 🎲", salary =  250 },
    [2] = { label = "Oro 🏆", salary =  750 },
    [3] = { label = "Premium 🔱", salary =  1250 },
    [4] = { label = "Deluxe 💎", salary =  2000 },
    [5] = { label = "Fundador 🔥", salary =  4000 },
    [6] = { label = "Nuclear ☢️", salary =  7000 },
    [7] = { label = "Padrino 🎩", salary =  20000 },
    [8] = { label = "Donador", salary =  0 }
}

Citizen.CreateThread(
    function()
        W.Logger.__RegisterLog("VIP")
    end
)

function givePayCheck(source)
    local discord = W.GetDiscord(source)
    local player = W.GetPlayer(tonumber(source))
    if not ConnectedPlayers[discord] then
        if player and discord then
            local vipDataPlayer = VIPS[tonumber(player.vip)]
            if vipDataPlayer and player.vip > 0 then
                player.addMoney('bank', tonumber(vipDataPlayer.salary))
                player.Notify('Salario', 'Has cobrado ~g~$'..tonumber(vipDataPlayer.salary)..'~w~ por tu rango vip : '..vipDataPlayer.label, 'verify')
                W.Print("VIP", 'El jugador : '..GetPlayerName(source)..' ha cobrado '..tonumber(vipDataPlayer.salary))
                W.SendToDiscord('cobrarvip', "COBRAR VIP", GetPlayerName(source)..' ha cobrado $'..tonumber(vipDataPlayer.salary)..' de su VIP', source)
            end
        end
        ConnectedPlayers[discord] = true
    else
        player.Notify('Salario', 'Ya has cobrado tu salario VIP espera al proximo reinicio para volver a cobrarlo', 'error')
        W.Print("VIP", 'El jugador : '..GetPlayerName(source)..' ha intentado cobrar pero ya cobró')
    end
end

RegisterNetEvent('vip:getVipSalary',
    function()
        givePayCheck(source)
    end
)

--[[
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30 * 60 * 1000) -- 30 minutes

        local vipDataPlayer = VIPS[tonumber(player.vip)]

        if not vipDataPlayer then
            return
        end

        for k, v in pairs(vipDataPlayer) do
            local player = W.GetPlayer(v)

            if player and player.vip > 0   then
                player.addMoney('bank', vipDataPlayer.salary)
                player.Notify('SALARIO', 'Has cobrado ~g~$'.vipDataPlayer.salary..'~w~ del vip '..vipDataPlayer.label, 'verify')
            end
        end

        W.Print("INFO", 'VIP ENVIADO')
    end
end)
]]--