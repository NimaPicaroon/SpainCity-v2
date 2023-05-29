Shops = {}

CreateThread(function()
    MySQL.ready(function ()
        local content = LoadResourceFile(GetCurrentResourceName(), "./base/modules/Server/shop.json")
        if not content or not json.decode(content) then
            content = {}
        else
            content = json.decode(content)
        end
        Shops = content

        for i, info in ipairs(Shops) do -- 604800
            if os.time() - info.time > 604800 then
                Shops[i] = {time = os.time()}
            end
        end
    end)
end)

SavePaycheck = function ()
    SaveResourceFile(GetCurrentResourceName(), "./base/modules/Server/shop.json", json.encode(Shops, {indent = true}), -1)
end

W.CreateCallback("Ox-Gangs:orderDrop", function(source, cb, data, pay)
    local player = W.GetPlayer(source)

    if player.getMoney('money') >= pay then
        player.removeMoney('money', pay)
        player.Notify("Basel", "Has pagado ~g~$"..pay, 'verify')
        TriggerEvent("Ox-Gangs:getDrop", player.src, data)
        cb(true)
    else
        player.Notify("Basel", "No tienes suficiente dinero para pagarme, no me hagas perder el tiempo", 'verify')
        cb(false)
    end
end)
RegisterNetEvent('Ox-Gangs:getDrop', function(source, data)
    local player = W.GetPlayer(source)
    for k,v in pairs(data) do
        local metadata = W.DefaultMetadata[v.name] or false
        player.addItemToInventory(v.name, v.amount, metadata)
        W.SendToDiscord('crafteos', "COMPRA ACCESORIOS", GetPlayerName(source)..' ha comprado x'..v.amount..' '..v.name.." para la banda "..player.gang.label, source)
    end
    player.Notify("Basel", "Aquí tienes el pedido, vuelve cuando quieras", 'verify')
end)