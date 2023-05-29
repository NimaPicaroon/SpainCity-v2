local IsMenuOpened

RegisterNetEvent("ZC-Character:openMenu", function(type)
    if not IsMenuOpened then
        IsMenuOpened = true
        if not Character or not Character['sex'] or not Character['ears_1'] then
            Character = DefaultSkin
        end
        if type == 'clothes' then
            TriggerEvent('ZC-Shops:latestSkin', Character)
        elseif type == 'hair' then
            TriggerEvent('ZC-Shops:latestSkin', Character, YourFade)
        end
        local values = {}
        for k,v in pairs(Character) do
            table.insert(values, {type = k, value = v})
        end
        SendNUIMessage({ open = true, current = values, max = GetMaxVals(), type = type })
        SetNuiFocus(true, true)
        CreateSkinCam()

        while true do
            Wait(5000)
            if IsMenuOpened then
                InvalidateIdleCam()
                InvalidateVehicleIdleCam()
            else
                break
            end
        end
    end
end)

RegisterNUICallback('closeMenu', function()
    SetNuiFocus(false, false)
    DeleteSkinCam()
    IsMenuOpened = nil
    TriggerServerEvent("ZC-Character:saveSkin", Character, YourFade)
end)

RegisterNUICallback('closeMenuShop', function(data)
    local type = data.type
    if type == 'clothes' then
        TriggerEvent('ZC-Shops:closeClothes')
    else
        TriggerEvent('ZC-Shops:closeHair')
    end
end)