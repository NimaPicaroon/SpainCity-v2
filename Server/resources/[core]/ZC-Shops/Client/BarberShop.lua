local BarberShop = setmetatable({ }, BarberShop)
BarberShop.Variables = {
    IsOpened = false
}

BarberShop.Load = function ()
    CreateThread(function()
        for k, v in pairs(Cfg.BarberShop) do
            W.CreateBlip(v.coords, 71, 0, 0.7, "Peluquería", GetCurrentResourceName())
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

            for k, v in pairs(Cfg.BarberShop) do
                local Distance = #(v.coords - Coords)
                if Distance < 15 then
                    Sleep  = 500
                    if Distance < 5 then
                        if not BarberShop.Variables.IsOpened then
                            Sleep = 0
                            W.ShowText(v.coords + vector3(0,0,1), '~y~Peluquería\n~w~Cambiarse la apariencia', 0.5, 8)
                            if Distance < 2 then
                                inZone = true
                                if IsControlPressed(1, 38) then
                                    --if exports['Ox-Phone']:IsPhoneOpened() then return end
                                    if exports['Ox-Jobcreator']:IsHandcuffed() then return end
                                    if exports['ZC-Ambulance']:IsDead() then return end
                                    if exports['ZC-Menu']:isOpened() then return end

                                    BarberShop.Variables.IsOpened = true
                                    TriggerEvent("ZC-Character:openMenu", 'hair')
                                end
                            end
                        end
                    end
                end
            end

            if inZone and not shown then
                shown = true

                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_barbershop')
            elseif not inZone and shown then
                exports['ZC-HelpNotify']:close('interact_barbershop')
                shown = false
            end

            Wait(Sleep)
        end
    end)
end

RegisterNetEvent("ZC-Shops:closeHair", function()
    local elements = {
        {value = 'yes', label= 'Si'},
        {value = 'no', label= 'No'}
    }
    W.OpenMenu("¿Quieres comprar esta apariencia? (50€)", "outfit_menu", elements, function (data, name)
        W.DestroyMenu(name)
        if data.value == 'yes' then
            Wait(250)

            W.OpenMenu("¿Quieres esta apariencia? (50€)", "outfit_menu", {
                { label = 'Pagar en efectivo', value = 'efectivo' },
                { label = 'Pagar con tarjeta', value = 'bank' }
            }, function (data2, name2)
                W.DestroyMenu(name2)
                if data2.value == 'efectivo' then
                    local playerData = W.GetPlayerData()
                    if playerData.money.money >= 50 then
                        TriggerServerEvent('ZC-Shops:removeMoney', 50)
                        W.Notify('Peluquería', 'Has pagado ~g~50€~w~', 'verify')
                    else
                        TriggerEvent('ZC-Character:loadFade', Fade)
                        W.Notify('Peluquería', 'No tienes tanto ~y~dinero', 'error')
                        TriggerEvent('ZC-Character:loadSkin', Latest)
                        Wait(500)
                        TriggerServerEvent("ZC-Character:saveSkin", Latest, Fade)
                    end
                elseif data2.value == 'bank' then
                    TriggerEvent("Ox-Banking:buyWithCreditCard", GetCurrentResourceName(), 'barbershop')
                else
                    return
                end
            end, function ()
                BarberShop.Variables.IsOpened = false
            end)
        else
            TriggerEvent('ZC-Character:loadSkin', Latest)
            Wait(500)
            TriggerServerEvent("ZC-Character:saveSkin", Latest)
        end
    end, function ()
        BarberShop.Variables.IsOpened = false
    end)
end)

BarberShop.Load()

RegisterNUICallback("closePin", function (data, cb)
    if data.typeShop == 'barbershop' then
        BarberShop.Variables.IsOpened = false
        W.Notify('Peluquería', 'La transacción ha ~r~fallado~w~.', 'error')

        return cb("")
    end
end)

RegisterNUICallback("correctPin2", function(data, cb)
    if data.typeShop == 'barbershop' then
        BarberShop.Variables.IsOpened = false
        TriggerServerEvent('ZC-Shops:removeMoney', 50, false, nil, 'bank')
        W.Notify('Peluquería', 'Has pagado ~g~50€~w~ por tu apariencia', 'verify')

        return cb("")
    end
end)
