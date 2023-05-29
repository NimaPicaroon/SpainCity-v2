local Clothes = setmetatable({ }, Clothes)
Clothes.Variables = {
    IsOpened = false
}
Latest = {}
Fade = {}

OpenClotheShop = function()
    W.OpenMenu('¿Qué quieres hacer?', 'clotheshop', {
        { label = 'Cambiarme de Ropa', value = 'change_clothe'},
        { label = 'Administrar Conjuntos', value = 'outfits' }
    }, function(data, menu)
        W.DestroyMenu(menu)

        if data.value == 'change_clothe' then
            TriggerEvent("ZC-Character:openMenu", 'clothes')
        elseif data.value == 'outfits' then
            Wait(250)
            W.OpenMenu("Vestuario", "motel_wardrobe_menu", {
                { label = "Mis conjuntos", value = "my" },
                { label = "Borrar conjuntos", value = "delete" }
            }, function (data2, menu2)
                local v = data2.value
                W.DestroyMenu(menu2)
                Wait(200)
                local oldHealh = GetEntityHealth(GetPlayerPed(-1))
                if v == 'my' then
                    W.TriggerCallback('ZC-Character:getOutfits', function(outfits)
                        if outfits and #outfits > 0 then
                            local el = {}
                            for k,v in pairs(outfits) do
                                table.insert(el, {
                                    label = v.name,
                                    name = v.name,
                                    skin = v.skin
                                })
                            end
    
                            W.OpenMenu('Tu vestuario', "outf_motel_menu", el, function (data3, name3)
                                W.DestroyMenu(name3)
                                TriggerEvent("ZC-Character:loadSkin", data3.skin, true, nil, nil, nil, nil, true)
                                Clothes.Variables.IsOpened = false
                                Citizen.Wait(200)
                                SetEntityHealth(PlayerPedId(), oldHealh)
                            end)
                        else
                            W.Notify('Conjuntos', 'No tienes ningún conjunto guardado', 'error')
                            Clothes.Variables.IsOpened = false
                        end
                    end)
                elseif v == 'delete' then
                    W.TriggerCallback('ZC-Character:getOutfits', function(outfits)
                        if outfits and #outfits > 0 then
                            local el = {}
                            for k,v in pairs(outfits) do
                                table.insert(el, {
                                    label = v.name,
                                    name = v.name,
                                    data = v
                                })
                            end
    
                            W.OpenMenu('Conjuntos', "outf_motel_menu_delete", el, function (data4, name4)
                                W.DestroyMenu(name4)
                                W.TriggerCallback("ZC-Character:deleteOutfit", function(deleted)
                                    if deleted then
                                        W.Notify('Conjuntos', 'Has borrado un conjunto', 'error')
                                        Clothes.Variables.IsOpened = false
                                    end
                                end, data4.data)
                            end)
                        else
                            W.Notify('Conjuntos', 'No tienes ningún conjunto guardado', 'error')
                            Clothes.Variables.IsOpened = false
                        end
                    end)
                end
            end)
        end
    end, function()
        Clothes.Variables.IsOpened = false
    end)
end

Clothes.Load = function ()
    CreateThread(function()
        for k, v in pairs(Cfg.Clothes) do
            W.CreateBlip(v.coords, 73, 61, 0.7, "Tienda de ropa", GetCurrentResourceName())
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

            for k, v in pairs(Cfg.Clothes) do
                local Distance = #(v.coords - Coords)
                if Distance < 15 then
                    Sleep  = 500
                    if Distance < 5 then
                        Sleep = 0
                        W.ShowText(v.coords + vector3(0,0,1), '~y~Vestuario\n~w~Cambiarse de ropa', 0.5, 8)
                        
                        if Distance < 2 then
                            inZone = true

                            if IsControlPressed(1, 38) then
                                if exports['Ox-Jobcreator']:IsHandcuffed() then return end
                                if exports['ZC-Ambulance']:IsDead() then return end

                                OpenClotheShop()
                            end
                        end
                    end
                end
            end

            if inZone and not shown then
                shown = true

                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_clotheshop')
            elseif not inZone and shown then
                shown = false

                exports['ZC-HelpNotify']:close('interact_clotheshop')
            end

            Wait(Sleep)
        end
    end)
end

function changeLatest(skin, fade)
    Latest = skin
    if fade then
        Fade = fade
    end
end

RegisterNetEvent("ZC-Shops:latestSkin", changeLatest)

RegisterNetEvent("ZC-Shops:closeClothes", function()
    local elements = {
        {value = 'yes', label= 'Si'},
        {value = 'no', label= 'No'}
    }
    W.OpenMenu("¿Quieres comprar la ropa? (150€)", "outfit_menu", elements, function (data, name)
        W.DestroyMenu(name)
        if data.value == 'yes' then
            Wait(250)

            W.OpenMenu("¿Quieres comprar la ropa? (150€)", "outfit_menu", {
                { label = 'Pagar en efectivo', value = 'efectivo' },
                { label = 'Pagar con tarjeta', value = 'bank' }
            }, function (data2, name2)
                W.DestroyMenu(name2)

                if data2.value == 'efectivo' then
                    local data = W.GetPlayerData()
                    if data.money.money >= 150 then
                        TriggerServerEvent('ZC-Shops:removeMoney', 150)
                        W.Notify('TIENDA DE ROPA', 'Has pagado ~g~150€~w~ por tu ropa', 'verify')
                        Wait(300)
                        W.OpenMenu("¿Guardar conjunto?", "outfit_menu", elements, function (data, name)
                            W.DestroyMenu(name)
                            if data.value == 'yes' then
                                W.OpenDialog("Nombre del conjunto", "name_dialog", function (outfitName)
                                    W.CloseDialog()
                                    if outfitName then
                                        TriggerEvent("ZC-Character:saveOutfit", outfitName)
                                        W.Notify('TIENDA DE ROPA', 'Guardaste tu conjunto correctamente', 'verify')
                                    end
                                end)
                            end
                        end)
                    else
                        W.Notify('TIENDA DE ROPA', 'No tienes tanto ~y~dinero', 'error')
                        TriggerEvent('ZC-Character:loadSkin', Latest)
                        Wait(500)
                        TriggerServerEvent("ZC-Character:saveSkin", Latest)
                    end
                elseif data2.value == 'bank' then
                    TriggerEvent("Ox-Banking:buyWithCreditCard", GetCurrentResourceName(), 'clotheshop')
                else
                    return
                end
            end)
        else
            TriggerEvent('ZC-Character:loadSkin', Latest)
            Wait(500)
            TriggerServerEvent("ZC-Character:saveSkin", Latest)
        end
    end, function ()
        Clothes.Variables.IsOpened = false
    end)
end)

Clothes.Load()

RegisterNetEvent('Ox-Banking:transactionFailed', function(typeShop)
    if typeShop == 'clotheshop' then
        Clothes.Variables.IsOpened = false
        TriggerEvent('ZC-Character:loadSkin', Latest)
        Wait(500)
        TriggerServerEvent("ZC-Character:saveSkin", Latest)
    end
end)

RegisterNUICallback("closePin", function (data, cb)
    if data.typeShop == 'clotheshop' then
        Clothes.Variables.IsOpened = false
        W.Notify('Tienda de Ropa', 'La transacción ha ~r~fallado~w~.', 'error')

        return cb("")
    end
end)

RegisterNUICallback("correctPin3", function(data, cb)
    if data.typeShop == 'clotheshop' then
        Clothes.Variables.IsOpened = false
        TriggerServerEvent('ZC-Shops:removeMoney', 150, false, nil, 'bank')
        W.Notify('Tienda de Ropa', 'Has pagado ~g~150€~w~ por tu ropa', 'verify')
        Wait(300)
        W.OpenMenu("¿Guardar conjunto?", "outfit_menu", {
            {value = 'yes', label= 'Si'},
            {value = 'no', label= 'No'}
        }, function (data, name)
            W.DestroyMenu(name)
            if data.value == 'yes' then
                W.OpenDialog("Nombre del conjunto", "name_dialog", function (outfitName)
                    W.CloseDialog()
                    if outfitName then
                        TriggerEvent("ZC-Character:saveOutfit", outfitName)
                        W.Notify('TIENDA DE ROPA', 'Guardaste tu conjunto correctamente', 'verify')
                    end
                end)
            end
        end)

        return cb("")
    end
end)
