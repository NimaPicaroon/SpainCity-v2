WeaponsVip = setmetatable({ }, WeaponsVip)
WeaponsVip.Variables = {
    opened = false,
    data = {}
}

function WeaponsVip:open()
    local elements = {
        { label = 'Pistola Vintage - <span style="color:yellow;">20.000€</span>', weapon = 'WEAPON_VINTAGEPISTOL', name = 'Pistola Vintage', price = 20000 },
        { label = 'Cargador vacío - <span style="color:yellow;">1.500€</span>', weapon = 'emptyclip', name = 'Cargador vacío', price = 2000 },
        { label = '250 Balas de pistola - <span style="color:yellow;">7.500€</span>', weapon = 'pistol_box', name = '250 Balas de pistola', price = 7500 },
    }


    W.OpenMenu("Armamento", "ammunationvip_menu", elements, function(data, name)
        W.DestroyMenu(name)

        Wait(250)
        W.OpenMenu("Armamento", "ammunationvip_menu", {
            {label = 'Pagar con efectivo', value = 'money'},
            {label = 'Pagar con tarjeta', value = 'bank'}
        }, function(data2, name2)
            W.DestroyMenu(name2)
            local playerVip = W.GetPlayerData().vip

            if playerVip and (tonumber(playerVip) >= 3) then
                if data2.value == 'money' then
                    local playerData = W.GetPlayerData()

                    if playerData.money.money >= 2000 then
                        TriggerServerEvent('ZC-Shops:removeMoney', data.price, true, data)
                        W.Notify('Ammunation VIP', 'Has comprado un ~y~'..data.name..'~w~ por ~g~$'..data.price..'~w~ ', 'verify')
                    else
                        W.Notify('Ammunation VIP', 'No tienes suficiente dinero para poder comprar este arma.', 'error')
                    end
                elseif data2.value == 'bank' then
                    WeaponsVip.Variables.data = data
                    TriggerEvent("Ox-Banking:buyWithCreditCard", GetCurrentResourceName(), 'ammunationvip')
                end
            else
                W.Notify('Ammunation VIP', 'Necesitas como mínimo el VIP Premium para poder comprar aquí.', 'error')
            end
        end)
    end, function ()
        WeaponsVip.Variables.opened = false
    end)
end

function WeaponsVip:_init()
    CreateThread(function()
        for k, v in pairs(Cfg.AmmunationsVIP) do
            W.CreateBlip(v.coords, 110, 5, 0.7, "Ammunation VIP", GetCurrentResourceName())
        end
    end)

    local inZone = false
    local shown = false
    CreateThread(function()
        while true do
            local Ped    = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local Sleep  = 1000
            inZone = false

            for k, v in pairs(Cfg.AmmunationsVIP) do
                local Distance = #(v.coords - Coords)

                if Distance < 5.0 then
                    Sleep = 0

                    W.ShowText(v.coords + vector3(0,0,1), '~y~Ammunation VIP\n~w~Comprar armamento', 0.5, 8)
                    if Distance < 2 then
                        inZone = true

                        if IsControlPressed(1, 38) then
                            WeaponsVip:open()
                            WeaponsVip.Variables.opened = true
                        end
                    end
                end
            end

            if inZone and not shown then
                shown = true

                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_weaponsviphop')
            elseif not inZone and shown then
                shown = false
                
                exports['ZC-HelpNotify']:close('interact_weaponsviphop')
            end

            Wait(Sleep)
        end
    end)
end

RegisterNUICallback("closePin", function (data, cb)
    if data.typeShop == 'ammunationvip' then
        WeaponsVip.Variables.opened = false
        WeaponsVip.Variables.data = {}
        W.Notify('Ammunation VIP', 'La transacción ha ~r~fallado~w~.', 'error')

        return cb("")
    end
end)

RegisterNUICallback("correctPin5", function(data, cb)
    if data.typeShop == 'ammunationvip' then
        WeaponsVip.Variables.opened = false
        TriggerServerEvent('ZC-Shops:removeMoney', WeaponsVip.Variables.data.price, true, WeaponsVip.Variables.data, 'bank')
        W.Notify('Ammunation VIP', 'Has comprado un ~y~'..WeaponsVip.Variables.data.name..'~w~ por ~g~$'..WeaponsVip.Variables.data.price..'~w~', 'verify')

        return cb("")
    end
end)

WeaponsVip:_init()