local Shops = setmetatable({ }, Shops)

Shops.BuyItem = function(account, basket)
    local src <const> = source
    local added = false
    W.GetPlayer(src, function (player)
        if not player then return end
        for k,v in pairs(basket['data']) do
            if v.name then
                if player.canHoldItem(v.name, v.amount) then
                    local metadata = W.DefaultMetadata[v.name] or false
                    local amount = v.amount
                     
                    if player.addItemToInventory(v.name, v.amount, metadata) then
                        added = true
                    end
                end
            end
        end

        if added then
            player.removeMoney(account, basket['amount'])
            player.Notify("TIENDA", 'Has pagado ~g~'..basket['amount']..'€~w~ por tu compra.', "verify")
        end
    end)
end

RegisterNetEvent("ZC-Shops:server:buyItem", Shops.BuyItem)

RegisterNetEvent("ZC-Shops:removeMoney", function(amount, weapon, data, tyMoney)
    local src <const> = source
    W.GetPlayer(src, function (player)
        if not player then return end
        if player.getMoney(tyMoney or 'money') >= amount then
            if weapon and data then
                if player.addItemToInventory(data.weapon, 1, { bullets = 0, life = 100, serialnumber = math.random(1000000, 9999999)}) then
                    player.removeMoney(tyMoney or 'money', amount) 
                end
            else
                player.removeMoney(tyMoney or 'money', amount)
            end
        else
            player.Notify('Tienda', 'No tienes dinero suficiente', 'error')
        end
    end)
end)