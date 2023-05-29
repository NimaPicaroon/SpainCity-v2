local closestPoint = nil
local clothesPoints = {
    { coords = vector3(-461.14, -286.3, 34.91), type = 'hospital' },
    { coords = vector3(-1072.64, -824.32, 5.53), type = 'federal' },
    { coords = vector3(1789.76, 2544.12, 45.61), type = 'federal' },
    { coords = vector3(1778.32, 2544.08, 45.61), type = 'federal' },
    { coords = vector3(1821.56, 3666.2, 34.33), type = 'hospital' },
    { coords = vector3(-442.56, 6011.24, 28.05), type = 'federal' },
    { coords = vector3(1858.48, 3686.48, 30.33), type = 'federal' },
    { coords = vector3(473.08, -1007.76, 26.33), type = 'federal' },
    { coords = vector3(-247.28, 6314.2, 33.49), type = 'hospital' },
    { coords = vector3(-486.96, -335.84, 69.57), type = 'hospital' },
    { coords = vector3(328.12, -586.68, 42.33), type = 'hospital' },
    { coords = vector3(-183.72, 411.84, 110.85), type = 'hospital' },
    { coords = vector3(-2164.2, 3252.04, 32.85), type = 'skin' },
}
local typeClothes = {
    ['federal'] = {
        ['M'] = {['bags_1'] = 0, ['bags_2'] = 0, ['tshirt_1'] = 14, ['tshirt_2'] = 0, ['torso_1'] = 16, ['torso_2'] = 0, ['shoes_1'] = 98, ['shoes_2'] = 0, ['pants_1'] = 47, ['pants_2'] = 4, ['helmet_1'] = -1, ['helmet_2'] = -1, ['arms'] = 14, ['decals_1'] = 24, ['decals_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0, ['mask_1'] = 0, ['mask_2'] = 0, ['glasses_1'] = -1, ['glasses_2'] = -1},
        ['H'] = {['bags_1'] = 0, ['bags_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['torso_1'] = 31, ['torso_2'] = 0, ['shoes_1'] = 42, ['shoes_2'] = 1, ['pants_1'] = 45, ['pants_2'] = 4, ['helmet_1'] = -1, ['helmet_2'] = -1, ['arms'] = 14, ['decals_1'] = 25, ['decals_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0, ['mask_1'] = 0, ['mask_2'] = 0, ['glasses_1'] = -1, ['glasses_2'] = -1}
    },
    ['hospital'] = {
        ['M'] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 14, ['tshirt_2'] = 0,
            ['torso_1'] = 95, ['torso_2'] = 0,
            ['shoes_1'] = 35, ['shoes_2'] = 1,
            ['pants_1'] = 17, ['pants_2'] = 0,
            ['arms'] = 4, 
            ['decals_1'] = 1, ['decals_2'] = 1,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
        },
        ['H'] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 104, ['torso_2'] = 0,
            ['shoes_1'] = 34, ['shoes_2'] = 0,
            ['pants_1'] = 29, ['pants_2'] = 0,
            ['arms'] = 3, 
            ['decals_1'] = 1, ['decals_2'] = 1,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
        }
    }
}

function OpenClothesMenu(clotheType)
    W.OpenMenu('Cambiar vestimenta', 'change_outfit', {
        { label = 'Tu vestimenta', value = 'citizen' },
        { label = 'Conjunto', value = 'outfit' }
    }, function(data, name)
        W.DestroyMenu(name)

        if data.value == 'citizen' then
            W.TriggerCallback('ZC-Character:getSkin', function(skin)
                TriggerEvent('ZC-Character:loadSkin', skin, true)
            end)
        elseif data.value == 'outfit' then
            local playerData = W.GetPlayerData()
            local gender = (playerData.identity.gender):upper()

            SetPedComponentVariation(PlayerPedId(), 3, typeClothes[clotheType][gender]['arms'], 0, 2)						-- Arms
            SetPedComponentVariation(PlayerPedId(), 8,		typeClothes[clotheType][gender]['tshirt_1'], typeClothes[clotheType][gender]['tshirt_2'], 2)					-- Tshirt
            SetPedComponentVariation(PlayerPedId(), 11,		typeClothes[clotheType][gender]['torso_1'],			typeClothes[clotheType][gender]['torso_2'], 2)					-- torso parts
            SetPedComponentVariation(PlayerPedId(), 10,		typeClothes[clotheType][gender]['decals_1'],			typeClothes[clotheType][gender]['decals_2'], 2)					-- decals
            SetPedComponentVariation(PlayerPedId(), 4,		typeClothes[clotheType][gender]['pants_1'],			typeClothes[clotheType][gender]['pants_2'], 2)					-- pants
            SetPedComponentVariation(PlayerPedId(), 6,		typeClothes[clotheType][gender]['shoes_1'],			typeClothes[clotheType][gender]['shoes_2'], 2)					-- shoes
            ExecuteCommand('do dejaría sus pertenencias en la mesa y se cambiaría la vestimenta por la otorgada en presencia de un agente')
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        for index, value in pairs(clothesPoints) do
            local dist = #(playerPos - value.coords)

            if dist <= 5.0 then
                closestPoint = index
            end
        end

        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    local show = false
    while true do
        local msec = 750
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        if closestPoint then
            local dist = #(playerPos - clothesPoints[closestPoint].coords)

            if dist <= 2.5 then
                msec = 0

                if not show then
                    show = true
                    exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para vestirte', 'interact_federal')
                end
                W.ShowText(clothesPoints[closestPoint].coords, '~y~Vestimenta\n~w~Cambiarte conjunto', 0.5, 8)
                if IsControlJustPressed(0, 38) then
                    if clothesPoints[closestPoint].type == "skin" then
                        TriggerEvent("ZC-Character:openMenu")
                    else
                        OpenClothesMenu(clothesPoints[closestPoint].type)
                    end
                end
            else
                if show then
                    exports['ZC-HelpNotify']:close('interact_federal')
                end
            end
        else
            if show then
                exports['ZC-HelpNotify']:close('interact_federal')
            end
        end

        Citizen.Wait(msec)
    end
end)