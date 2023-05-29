Weapons = setmetatable({ }, Weapons)
Weapons.Variables = {
    opened = false,
    data = {}
}

function Weapons:open()
    local elements = {
        { label = 'Pistola SNS - <span style="color:yellow;">20.000€</span>', weapon = 'WEAPON_SNSPISTOL', name = 'Pistola SNS', price = 20000 },
        { label = 'Ganzua - <span style="color:yellow;">600€</span>', weapon = 'lockpick', name = 'Ganzua', price = 600 },
        { label = 'Botella de Buceo - <span style="color:yellow;">1.400€</span>', weapon = 'botella_buceo', name = 'Botella de buceo', price = 1400 },
        { label = 'Walkie Talkie - <span style="color:yellow;">300€</span>', weapon = 'radio', name = 'Walkie Talkie', price = 300 },
        { label = 'Taladro - <span style="color:yellow;">2.000€</span>', weapon = 'drill', name = 'Taladro', price = 2000 },
        { label = 'Linterna - <span style="color:yellow;">3.500€</span>', weapon = 'WEAPON_FLASHLIGHT', name = 'Linterna', price = 3500 },
        { label = 'Cuchillo - <span style="color:yellow;">7.500€</span>', weapon = 'WEAPON_KNIFE', name = 'Cuchillo', price = 7500 },
        { label = 'Palanca - <span style="color:yellow;">6.200€</span>', weapon = 'WEAPON_CROWBAR', name = 'Palanca', price = 6200 },
        { label = 'Machete - <span style="color:yellow;">8.500€</span>', weapon = 'WEAPON_MACHETE', name = 'Machete', price = 8500 },
        { label = 'Llave Inglesa - <span style="color:yellow;">6.700€</span>', weapon = 'WEAPON_WRENCH', name = 'Llave Inglesa', price = 6700 },
        /*{ label = 'Cargador - <span style="color:yellow;">850€</span>', weapon = 'WEAPON_WRENCH', name = 'Cargador', price = 850 },*/
    }


    W.OpenMenu("Armamento", "ammunation_menu", elements, function(data, name)
        W.DestroyMenu(name)

        Wait(250)
        W.OpenMenu("Armamento", "ammunation_menu", {
            {label = 'Pagar con efectivo', value = 'money'},
            {label = 'Pagar con tarjeta', value = 'bank'}
        }, function(data2, name2)
            W.DestroyMenu(name2)

            if data2.value == 'money' then
                local playerData = W.GetPlayerData()

                if playerData.money.money >= 75 then
                    TriggerServerEvent('ZC-Shops:removeMoney', data.price, true, data)
                    W.Notify('Ammunation', 'Has comprado un ~y~'..data.name..'~w~ por ~g~$'..data.price..'~w~ ', 'verify')
                else
                    W.Notify('Ammunation', 'No tienes suficiente dinero para poder comprar este arma.', 'error')
                end
            elseif data2.value == 'bank' then
                Weapons.Variables.data = data
                TriggerEvent("Ox-Banking:buyWithCreditCard", GetCurrentResourceName(), 'ammunation')
            end
        end)
    end, function ()
        Weapons.Variables.opened = false
    end)
end

function Weapons:_init()
    CreateThread(function()
        for k, v in pairs(Cfg.Ammunations) do
            W.CreateBlip(v.coords, 110, 3, 0.7, "Ammunation", GetCurrentResourceName())
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

            for k, v in pairs(Cfg.Ammunations) do
                local Distance = #(v.coords - Coords)

                if Distance < 5.0 then
                    Sleep = 0

                    W.ShowText(v.coords + vector3(0,0,1), '~y~Ammunation\n~w~Comprar armamento', 0.5, 8)
                    if Distance < 2 then
                        inZone = true

                        if IsControlPressed(1, 38) then
                            Weapons:open()
                            Weapons.Variables.opened = true
                        end
                    end
                end
            end

            if inZone and not shown then
                shown = true

                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_weaponshop')
            elseif not inZone and shown then
                shown = false
                
                exports['ZC-HelpNotify']:close('interact_weaponshop')
            end

            Wait(Sleep)
        end
    end)
end

RegisterNUICallback("closePin", function (data, cb)
    if data.typeShop == 'ammunation' then
        Weapons.Variables.opened = false
        Weapons.Variables.data = {}
        W.Notify('Ammunation', 'La transacción ha ~r~fallado~w~.', 'error')

        return cb("")
    end
end)

RegisterNUICallback("correctPin4", function(data, cb)
    if data.typeShop == 'ammunation' then
        Weapons.Variables.opened = false
        TriggerServerEvent('ZC-Shops:removeMoney', Weapons.Variables.data.price, true, Weapons.Variables.data, 'bank')
        W.Notify('Ammunation', 'Has comprado un ~y~'..Weapons.Variables.data.name..'~w~ por ~g~$'..Weapons.Variables.data.price..'~w~', 'verify')

        return cb("")
    end
end)

Weapons:_init()